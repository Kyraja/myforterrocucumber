@persistent
Feature: Chargenpflicht_Fertigung.feature

Background:
And I set the fake date to "16.01.1995"

# **********************************************************************************
#  Name             : Chargenpflicht_Fertigung.feature
#  Autor            : bschiga
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Chargen-/Seriennummernverwaltung
#  ref              : ref_chargen_seriennr_cu
#
# **********************************************************************************

Scenario: P10 Chargenpflicht bei Zugang aus Fertigung, bei Entnahme FBU und retrograd entsteht Zeile mit Menge 0

Given I create a work order "P10" for Product "BG01_CHARGE" with quantity "20" and search word "P10_"

Given I create a Lot "C1010ZU" for Product "BG01_CHARGE"

Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "P10_000"
And I press button "absteig" to open a subeditor for "AFL"
And I set field "manbu" to "ja" in row 3
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Rueckmeldung auf ersten Arbeitsschein mit retrogradem Material, ohne Chargenangabe
Given I open an editor "RM1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=P10_001;@richtung=rückwärts;@maxordtreffer=1"
And I set field "sofort" to "ja"
And I set field "gutmge" to "5" in row 1
And I set field "erbtext1" to "RM1" in row 1
And I save the current editor

# in der Rueckmeldung wurde fuer das retrograde Material eine Zeile mit Menge 0 erstellt, da die Chargenangabe fehlt
Given I open an editor "RM1Pruef1" via ID from editor "RM1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "VIEW"
Then the table has 2 rows
Then table has values
  | artikel     | mge   | gutmge    |
  | BG01_CHARGE | 20    | 5         |
  | EK01_CHARGE | 0     | 0         |
And I close the current editor

# FBU fuer manbu-Material, ohne MZ nur Gesamtmenge moeglich, die geladen wird
Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | P10_002   |
    | bem       | Entnahme  |
    | charge    | C1010ZU   |
And I press button "stlvblad"
Then table has values
    | elex          | bumge | manbu |
    | EK02_CHARGE   | 20    | ja    |
# Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then saving the current editor throws the exception "1164"
And I set field "tvcharge" to "1010" in row 1
And I set field "ljtext1" to "MATENT1" in row 1
And I save the current editor

# gebuchte Materialentnahme pruefen
Given I open an editor "FBUPruef1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=P10_002;bem=Entnahme;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then the table has 2 rows
Then table has values
    | artikel     | mge   | gutmge    | tcharge   |
    | BG01_CHARGE | 20    | 0         | C1010ZU   |
    | EK02_CHARGE | 20    | 0         | 1010      |
And I close the current editor

# Rueckmeldung auf zweiten Arbeitsschein, nur mit Chargenangabe
Given I open an editor "RM2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=P10_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | bem       | RM2_P10   |
And I set field "gutmge" to "5" in row 1
And I set field "erbtext1" to "RM2" in row 1
# 1164 TX=de |Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then saving the current editor throws the exception "1164"
And I set field "tkcharge" to "101010"
And I save the current editor

# im Rueckmeldebeleg die Chargenangabe pruefen fuer das Fertigteil pruefen, Material wurde manuell entnommen
Given I open an editor "RM2Pruef" via ID from editor "RM2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "VIEW"
Then the table has 2 rows
Then table has values
  | artikel     | mge   | gutmge    | tcharge    |
  | BG01_CHARGE | 20    | 5         | 101010     |
And I close the current editor

# Rueckmeldung fuer restliche Menge auf zweiten Arbeitsschein, ohne Chargenangabe => Fehlermeldung pruefen
Given I open an editor "RM2REST" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=P10_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja    |
    | gut       | ja    |
    | bem       | RM2   |
    | manrest   | ja    |
# 1164 TX=de |Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then saving the current editor throws the exception "1164"
And I set field "tcharge" to "101010" in row 1
And I set field "erbtext1" to "RM2REST" in row 1
And I save the current editor

# manbu-Material wurde bereits komplett uebernommen
# retrogrades Material wurde nicht gebucht, da Chargenangabe fehlt; es wurde automatisch der Loeschschutz gesetzt, da Materialentnahmen fehlen
Given I open an editor "RM2Pruef" via ID from editor "RM2REST" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "VIEW"
Then the table has 3 rows
Then table has values
  | artikel     | mge   | gutmge    | tcharge   |
  | BG01_CHARGE | 15    | 15        | 101010    |
  | EK02_CHARGE | 0     | 0         |           |
  | EK01_CHARGE | 0     | 0         |           |
And I close the current editor

### zur Zeit nicht moeglich
## zusaetzliche Entnahme von weiterem Material, das auch chargenpflichtig ist
#Given I open an editor "Fbuchung1" for tip command "Fbuchung" and arguments ""
#And I set field "auftrag" to "P10_000"
#And I set field "bem" to "ZUSATZMAT"
#And I set field "manent" to "ja"
#And I set field "mgr" to "101"
#And I delete all rows
#And I append rows
#  | elex        |
#  | EK03_CHARGE |
## Für die zu buchende Gutmenge mit dieser Charge reicht die Menge in den Materialzuordnungen nicht aus.
#Then setting field "bumge" to "2" in row 1 throws the exception "2058"
### 1164 TX=de |Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
##Then saving the current editor throws the exception "1164"
#And I set field "tvcharge" to "1010_3" in row 1
#And I set field "bumge" to "2" in row 1
#And I save the current editor

# Löschschutz entfernen bringt Fehlermeldung
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "P10_000"
# 1697 de      |Löschschutz kann nicht entfernt werden, da noch Restmengen vorhanden.
Then setting field "noloesch" to "nein" throws the exception "1697"
And I close the current editor

# restliche Materialentnahmen auf den BA buchen
Given I open an editor "MATENT2" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | P10_002       |
    | autorment | ja            |
    | mgr       | 101           |
    | bem       | RestEntnahme  |
And I press button "stllad"
Then table has values
    | elex          | bumge | manbu |
    | EK01_CHARGE   | 20    | nein  |
    | EK02_CHARGE   | 0     | ja    |
And I set field "ljtext1" to "MATENT2" in row 1
# 1164 TX=de |Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then saving the current editor throws the exception "1164"
And I set field "tvcharge" to "1010" in row 1
And I save the current editor

# gebuchte Materialentnahme pruefen
Given I open an editor "FBUPruef2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=P10_002;bem=RestEntnahme;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then the table has 2 rows
Then table has values
  | artikel     | mge   | gutmge    | tcharge   |
  | BG01_CHARGE |  0    | 0         |           |
  | EK01_CHARGE | 20    | 0         | 1010      |
And I close the current editor

# BA-Nummer zwischenspeichern
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=P10_000;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "nummer" in row 0
And I close the current editor

# Löschschutz entfernen
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "P10_000"
And I set field "noloesch" to "nein"
And I save the current editor

# Prüfen ob FeVo in der Ablage
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "BG01_CHARGE"
And I set field "banummer" in row 0 to saved value
And I set field "nurablage" to "ja"
And I set field "lgruppe" to "KARLSRUHE"
And I press button "ladetab"
Then the table has 1 rows
And I close the current editor

# Nachbuchen auf abgelegten Fertigungsvorschlag
## (zusätzliches Material wird auch geladen) zur Zeit nicht moeglich zusaetzliche Entnahmen zu buchen
Given I open an editor "RMNACH1" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=P10_002;bem=RestEntnahme;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
Then table has values
  | artikel     |
  | BG01_CHARGE |
  | EK01_CHARGE |
  | EK02_CHARGE |
And I set field "bem" to "NACHBUCH"
# Zugangscharge eintragen
And I set field "tkcharge" to "101010"
And I set field "gutmge" to "1" in row 1
And I modify table
    | !row  | mge   |
    | 2     | 1     |
    | 3     | 1     |
# Fehlermeldung, da Chargenangaben fuer die Entnahmeteile fehlen
Then saving the current editor throws the exception "1164"
And I modify table
    | !row  | tcharge   |
    | 2     | 1010      |
    | 3     | 1010      |
And I save the current editor

Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK02_CHARGE;buarta==Abgang;platz==F1;erbtext1==MATENT1"
Then fields have values
    | artikel       | EK02_CHARGE                   |
    | platz         | F1                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 20                            |
    | buart         | 2                             |
    | buarta        | Abgang                        |
    | ursache       | Fertigung                     |
    | detursache    | Materialentnahme Fertigung    |
Then field "tvcharge" has value "1010" in row 1
And I close the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==BG01_CHARGE;buarta==Zugang;platz==F1;erbtext1==RM2"
Then fields have values
    | artikel       | BG01_CHARGE                   |
    | platz         | F1                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 5                             |
    | buart         | 1                             |
    | buarta        | Zugang                        |
    | ursache       | Fertigung                     |
    | detursache    | Rückmeldung Fertigung         |
Then field "tncharge" has value "101010" in row 1
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==BG01_CHARGE;buarta==Zugang;platz==F1;erbtext1==RM2REST"
Then fields have values
    | artikel       | BG01_CHARGE                   |
    | platz         | F1                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 15                            |
    | buart         | 1                             |
    | buarta        | Zugang                        |
    | ursache       | Fertigung                     |
    | detursache    | Rückmeldung Fertigung         |
Then field "tncharge" has value "101010" in row 1
And I close the current editor

#Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK03_CHARGE;buarta==Abgang;platz==F1;detursache==Materialentnahme Fertigung"
#Then fields have values
#    | artikel       | EK03_CHARGE                   |
#    | platz         | F1                            |
#    | lgruppe       | KARLSRUHE                     |
#    | mge           | 2                             |
#    | buart         | 2                             |
#    | buarta        | Abgang                        |
#    | ursache       | Fertigung                     |
#    | detursache    | Materialentnahme Fertigung    |
#Then field "tvcharge" has value "1010_3" in row 1
#And I close the current editor

# das manbu-Material wurde bei der Rueckmeldung abgebucht, weil manrest angehakt und weil MZ vorhanden
#Given I open an editor "JournalAb3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK02_CHARGE;buarta==Abgang;platz==F1;erbtext1==RM2REST"
#Then fields have values
#    | artikel       | EK02_CHARGE                   |
#    | platz         | F1                            |
#    | lgruppe       | KARLSRUHE                     |
#    | mge           | 15                            |
#    | buart         | 2                             |
#    | buarta        | Abgang                        |
#    | ursache       | Fertigung                     |
#    | detursache    | Rückmeldung Fertigung         |
#Then field "tvcharge" has value "1010" in row 1
#And I close the current editor

Given I open an editor "JournalAb4" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK01_CHARGE;buarta==Abgang;platz==F1;erbtext1==MATENT2"
Then fields have values
    | artikel       | EK01_CHARGE                   |
    | platz         | F1                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 20                            |
    | buart         | 2                             |
    | buarta        | Abgang                        |
    | ursache       | Fertigung                     |
    | detursache    | Materialentnahme Fertigung    |
Then field "tvcharge" has value "1010" in row 1
And I close the current editor


Scenario: P10A Chargenpflicht bei Zugang aus Fertigung, bei Entnahme FBU und retrograd entsteht Zeile mit Menge 0

Given I create a work order "P10A1" for Product "BG04_CHARGE" with quantity "20" and search word "P10A1_"
Given I create a work order "P10A2" for Product "BG04_CHARGE" with quantity "20" and search word "P10A2_"
Given I create a work order "P10A3" for Product "BG04_CHARGE" with quantity "20" and search word "P10A3_"
Given I create a work order "P10A4" for Product "BG04_CHARGE" with quantity "20" and search word "P10A4_"
Given I create a work order "P10A5" for Product "BG04_CHARGE" with quantity "20" and search word "P10A5_"
Given I create a work order "P10A6" for Product "BG04_CHARGE" with quantity "20" and search word "P10A6_"

Given I create a Lot "C1010AZU" for Product "BG04_CHARGE"

# MZ für Zugang in voller Menge anlegen
Given I open an editor "BAP10A1MZzu" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "P10A1_000"
And I press button "mzsubm" to open a subeditor for "FertigteilMZ"
And I modify table
    | !row  | lpsuch | zuomge   | tcharge     |
    | +1    | F1     | 20       | C1010AZU    |
And I save the current editor
And I switch the current editor to editor "BAP10A1MZzu"
And I save the current editor

Given I open an editor "BAP10A2MZzu" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "P10A2_000"
And I press button "mzsubm" to open a subeditor for "FertigteilMZ"
And I modify table
    | !row  | lpsuch | zuomge   | tcharge     |
    | +1    | F1     | 20       | C1010AZU    |
And I save the current editor
And I switch the current editor to editor "BAP10A2MZzu"
And I save the current editor

Given I open an editor "BAP10A3MZzu" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "P10A3_000"
And I press button "mzsubm" to open a subeditor for "FertigteilMZ"
And I modify table
    | !row  | lpsuch | zuomge   | tcharge     |
    | +1    | F1     | 20       | C1010AZU    |
And I save the current editor
And I switch the current editor to editor "BAP10A3MZzu"
And I save the current editor

Given I open an editor "BAP10A4MZzu" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "P10A4_000"
And I press button "mzsubm" to open a subeditor for "FertigteilMZ"
And I modify table
    | !row  | lpsuch | zuomge   | tcharge     |
    | +1    | F1     | 20       | C1010AZU    |
And I save the current editor
And I switch the current editor to editor "BAP10A4MZzu"
And I save the current editor

Given I open an editor "BAP10A5MZzu" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "P10A5_000"
And I press button "mzsubm" to open a subeditor for "FertigteilMZ"
And I modify table
    | !row  | lpsuch | zuomge   | tcharge     |
    | +1    | F1     | 20       | C1010AZU    |
And I save the current editor
And I switch the current editor to editor "BAP10A5MZzu"
And I save the current editor

Given I open an editor "BAP10A6MZzu" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "P10A6_000"
And I press button "mzsubm" to open a subeditor for "FertigteilMZ"
And I modify table
    | !row  | lpsuch | zuomge   | tcharge     |
    | +1    | F1     | 20       | C1010AZU    |
And I save the current editor
And I switch the current editor to editor "BAP10A6MZzu"
And I save the current editor

# Rueckmeldung auf zweiten Arbeitsschein mit retrogradem Material, ohne Chargenangabe für die Entnahmeteile
Given I open an editor "RM1S10A1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=P10A1_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "sofort" to "ja"
And I set field "gutmge" to "5" in row 1
And I set field "erbtext1" to "RM1S10A1" in row 1
And I save the current editor

Given I open an editor "RM1S10A2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=P10A2_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "sofort" to "ja"
And I set field "gutmge" to "5" in row 1
And I set field "erbtext1" to "RM1S10A2" in row 1
And I save the current editor

Given I open an editor "RM1S10A3" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=P10A3_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "sofort" to "ja"
And I set field "gutmge" to "5" in row 1
And I set field "erbtext1" to "RM1S10A3" in row 1
And I save the current editor

Given I open an editor "RM1S10A4" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=P10A4_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "sofort" to "ja"
And I set field "gutmge" to "5" in row 1
And I set field "erbtext1" to "RM1S10A4" in row 1
And I save the current editor

Given I open an editor "RM1S10A5" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=P10A5_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "sofort" to "ja"
And I set field "gutmge" to "5" in row 1
And I set field "erbtext1" to "RM1S10A5" in row 1
And I save the current editor

Given I open an editor "RM1S10A6" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=P10A6_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "sofort" to "ja"
And I set field "gutmge" to "5" in row 1
And I set field "erbtext1" to "RM1S10A6" in row 1
And I save the current editor

# Entnahme-MZ anlegen
Given I open an editor "BA2P10A1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "P10A1_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge    |
    | +1    | F1     | 15       | C1010AAB-1 |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge    |
    | +1    | F1     | 30       | C1010AAB-2 |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA2P10A1"
And I save the current editor

Given I open an editor "BA2P10A2" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "P10A2_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge    |
    | +1    | F1     | 17       | C1010AAB-1 |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge    |
    | +1    | F1     | 34       | C1010AAB-2 |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA2P10A2"
And I save the current editor

Given I open an editor "BA2P10A3" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "P10A3_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge    |
    | +1    | F1     | 14       | C1010AAB-1 |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge    |
    | +1    | F1     | 27       | C1010AAB-2 |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA2P10A3"
And I save the current editor

Given I open an editor "BA2P10A4" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "P10A4_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge    |
    | +1    | F1     | 5        | C1010AAB-1 |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge    |
    | +1    | F1     | 10       | C1010AAB-2 |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA2P10A4"
And I save the current editor

Given I open an editor "BA2P10A5" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "P10A5_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge    |
    | +1    | F1     | 4        | C1010AAB-1 |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge    |
    | +1    | F1     | 8        | C1010AAB-2 |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA2P10A5"
And I save the current editor

Given I open an editor "BA2P10A6" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "P10A6_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge    |
    | +1    | F1     | 20       | C1010AAB-1 |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge    |
    | +1    | F1     | 39       | C1010AAB-2 |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA2P10A6"
And I save the current editor

# Rueckmeldung auf zweiten Arbeitsschein mit retrogradem Material, volle Menge
Given I open an editor "RM2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=P10A1_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "sofort" to "ja"
And I set field "gut" to "ja"
And I set field "erbtext1" to "RM2S10A1" in row 1
And I save the current editor

Given I open an editor "RM2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=P10A2_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "sofort" to "ja"
And I set field "gut" to "ja"
And I set field "erbtext1" to "RM2S10A2" in row 1
And I save the current editor

Given I open an editor "RM2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=P10A3_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "sofort" to "ja"
And I set field "gut" to "ja"
And I set field "erbtext1" to "RM2S10A3" in row 1
And I save the current editor

Given I open an editor "RM2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=P10A4_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "sofort" to "ja"
And I set field "gut" to "ja"
And I set field "erbtext1" to "RM2S10A4" in row 1
And I save the current editor

Given I open an editor "RM2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=P10A5_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "sofort" to "ja"
And I set field "gut" to "ja"
And I set field "erbtext1" to "RM2S10A5" in row 1
And I save the current editor

Given I open an editor "RM2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=P10A6_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "sofort" to "ja"
And I set field "gut" to "ja"
And I set field "erbtext1" to "RM2S10A6" in row 1
And I save the current editor

# Offene Mengen prüfen
Given I open an editor "FBUS10A1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | P10A1_002   |
    | autorment | ja          |
And I press button "stllad"
Then table has values
    | elex          | bumge | manbu |
    | EK01_CHARGE   | 5     | nein  |
    | EK02_CHARGE   | 10    | nein  |
And I close the current editor

Given I open an editor "FBUS10A2" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | P10A2_002   |
    | autorment | ja          |
And I press button "stllad"
Then table has values
    | elex          | bumge | manbu |
    | EK01_CHARGE   | 3     | nein  |
    | EK02_CHARGE   | 6     | nein  |
And I close the current editor

Given I open an editor "FBUS10A3" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | P10A3_002   |
    | autorment | ja          |
And I press button "stllad"
Then table has values
    | elex          | bumge | manbu |
    | EK01_CHARGE   | 6     | nein  |
    | EK02_CHARGE   | 13    | nein  |
And I close the current editor

Given I open an editor "FBUS10A4" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | P10A4_002   |
    | autorment | ja          |
And I press button "stllad"
Then table has values
    | elex          | bumge | manbu |
    | EK01_CHARGE   | 15    | nein  |
    | EK02_CHARGE   | 30    | nein  |
And I close the current editor

Given I open an editor "FBUS10A5" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | P10A5_002   |
    | autorment | ja          |
And I press button "stllad"
Then table has values
    | elex          | bumge | manbu |
    | EK01_CHARGE   | 16    | nein  |
    | EK02_CHARGE   | 32    | nein  |
And I close the current editor

Given I open an editor "FBUS10A6" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | P10A6_002   |
    | autorment | ja          |
And I press button "stllad"
Then table has values
    | elex          | bumge | manbu |
    | EK01_CHARGE   | 0     | nein  |
    | EK02_CHARGE   | 1     | nein  |
And I close the current editor


Scenario: P10B Chargenpflicht bei Zugang aus Fertigung, bei RM mit Restmenge stornieren wird noloesch im BA nicht gesetzt

Given I create a work order "P10B" for Product "BG04_CHARGE" with quantity "20" and search word "P10B_"

Given I open an editor "BAP10B_000" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "P10B_000"
Then field "noloesch" has value "nein"
And I close the current editor

Given I create a Lot "C1010BZU" for Product "BG04_CHARGE"

# MZ für Zugang in voller Menge anlegen
Given I open an editor "BAP10BMZzu" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "P10B_000"
And I press button "mzsubm" to open a subeditor for "FertigteilMZ"
And I modify table
    | !row  | lpsuch | zuomge   | tcharge     |
    | +1    | F1     | 20       | C1010BZU    |
And I save the current editor
And I switch the current editor to editor "BAP10BMZzu"
And I save the current editor

# Entnahme-MZ anlegen, volle Menge für retrogrades Material in Zeile 1, Teilmenge für manuelle Entnahme in Zeile 3
Given I open an editor "BA2P10B" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "P10B_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge    | zcharge |
    | +1    | F1     | 20       | C1010B-1   | C1010BZU |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge    | zcharge |
    | +1    | F1     | 30       | C1010B-2   | C1010BZU |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA2P10B"
And I save the current editor

# Material in Zeile 3 auf manuelle Entnahme umstellen
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "P10B_000"
And I press button "absteig" to open a subeditor for "AFL"
And I set field "manbu" to "ja" in row 3
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Manuelle Entnahme über gesamte Menge mit Charge
Given I open an editor "FBU10B" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag     | P10B_002 |
    | gmgevorschl |       15 |
And I press button "stllad"
Then table has values
    | elex          | bumge | manbu |
    | EK02_CHARGE   | 30    | ja    |
And I save the current editor

# Rueckmeldung auf letzten Arbeitsschein mit Restmenge stornieren
Given I open an editor "RM10B" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=P10B_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "sofort" to "ja"
And I set field "gut" to "ja"
And I set field "stornorest" to "ja"
And I set field "erbtext1" to "RM10B" in row 1
And I save the current editor

# Pruefen, ob BA abgeschlossen ist
Then opening an editor from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=P10B_000;@richtung=rückwärts;@maxordtreffer=1" throws the exception "149"


Scenario: P11 Chargenpflicht bei Zugang aus Fertigung, EntnahmeMZ fuer retrogrades Material erfassen

Given I create a work order "P11" for Product "BG01_CHARGE" with quantity "20" and search word "P11_"

Given I open an editor "BA11" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "P11_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 15       | 11111     |
    | +2    | F1     | 5        | 11111_1   |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 15       | 11122     |
    | +2    | F1     | 5        | 11122_1   |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA11"
And I save the current editor

# Rueckmeldung Gesamtmenge auf Arbeitsschein 2
Given I open an editor "RM_P11" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=P11_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | gut       | ja        |
    | tkcharge  | 111111    |
    | bem       | RM_P11    |
And I set field "erbtext1" to "RM_P11" in row 1
And I save the current editor

# die Chargen aus der MZ wurden gebucht fuer das Entnahmematerial
Given I open an editor "RM2Pruef" via ID from editor "RM_P11" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "VIEW"
Then the table has 3 rows
Then table has values
    | artikel     | mge   | gutmge    | tcharge   |
    | BG01_CHARGE | 20    | 20        | 111111    |
    | EK02_CHARGE | 20    | 0         |           |
    | EK01_CHARGE | 20    | 0         |           |
And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 2
Then table has values
    | lpsuch | zuomge   | tcharge   |
    | F1     | 15       | 11122     |
    | F1     | 5        | 11122_1   |
And I press button for next product
Then table has values
    | lpsuch | zuomge   | tcharge   |
    | F1     | 15       | 11111     |
    | F1     | 5        | 11111_1   |
And I close the current editor
And I switch the current editor to editor "RM2Pruef"
And I close the current editor

# Nachbuchen auf abgelegten Fertigungsvorschlag
Given I open an editor "RMNACH2" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=P11_002;bem=RM_P11;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
Then table has values
    | artikel     |
    | BG01_CHARGE |
    | EK01_CHARGE |
    | EK02_CHARGE |
And I set field "bem" to "NACHBUCH2"
# Zugangscharge eintragen
And I set field "tkcharge" to "111111"
And I set field "gutmge" to "1" in row 1
And I modify table
    | !row  | mge   |
    | 2     | 1     |
    | 3     | 1     |
# Fehlermeldung, da Chargenangaben fuer die Entnahmeteile fehlen
Then saving the current editor throws the exception "1164"
And I modify table
    | !row  | tcharge   |
    | 2     | 11111     |
    | 3     | 11122     |
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==BG01_CHARGE;buarta==Zugang;platz==F1;erbtext1==RM_P11"
Then fields have values
    | artikel       | BG01_CHARGE                   |
    | platz         | F1                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 20                            |
    | buart         | 1                             |
    | buarta        | Zugang                        |
    | ursache       | Fertigung                     |
    | detursache    | Rückmeldung Fertigung         |
Then field "tncharge" has value "111111" in row 1
And I close the current editor

Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK02_CHARGE;buarta==Abgang;mge==15;platz==F1;erbtext1==RM_P11"
Then fields have values
    | artikel       | EK02_CHARGE                   |
    | platz         | F1                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 15                            |
    | buart         | 2                             |
    | buarta        | Abgang                        |
    | ursache       | Fertigung                     |
    | detursache    | Rückmeldung Fertigung         |
Then field "tvcharge" has value "11122" in row 1
And I close the current editor

Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK02_CHARGE;buarta==Abgang;mge==5;platz==F1;erbtext1==RM_P11"
Then fields have values
    | artikel       | EK02_CHARGE                   |
    | platz         | F1                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 5                             |
    | buart         | 2                             |
    | buarta        | Abgang                        |
    | ursache       | Fertigung                     |
    | detursache    | Rückmeldung Fertigung         |
Then field "tvcharge" has value "11122_1" in row 1
And I close the current editor

Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK01_CHARGE;buarta==Abgang;mge==15;platz==F1;erbtext1==RM_P11"
Then fields have values
    | artikel       | EK01_CHARGE                   |
    | platz         | F1                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 15                            |
    | buart         | 2                             |
    | buarta        | Abgang                        |
    | ursache       | Fertigung                     |
    | detursache    | Rückmeldung Fertigung         |
Then field "tvcharge" has value "11111" in row 1
And I close the current editor

Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK01_CHARGE;buarta==Abgang;mge==5;platz==F1;erbtext1==RM_P11"
Then fields have values
    | artikel       | EK01_CHARGE                   |
    | platz         | F1                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 5                             |
    | buart         | 2                             |
    | buarta        | Abgang                        |
    | ursache       | Fertigung                     |
    | detursache    | Rückmeldung Fertigung         |
Then field "tvcharge" has value "11111_1" in row 1
And I close the current editor


Scenario: P18 Chargenpflicht bei Zugang aus Fertigung, Charge wird aus FertigteilMZ uebernommen

Given I create a work order "P18" for Product "BG01_CHARGE" with quantity "20" and search word "P18_"

Given I open an editor "BA18" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "P18_000"
And I press button "mzsubm" to open a subeditor for "FertigteilMZ"
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 12       | 181818_1  |
    | +2    | F2     | 8        | 181818_2  |
And I save the current editor
And I switch the current editor to editor "BA18"
And I save the current editor

# Rueckmeldung Gesamtmenge auf Arbeitsschein 2
Given I open an editor "RM_P18" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=P18_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | gut       | ja        |
    | bem       | RM_P18    |
And I set field "erbtext1" to "RM_P18" in row 1
And I save the current editor

# die Chargen aus der MZ wurden gebucht fuer das Fertigteil
Given I open an editor "RMPruef" via ID from editor "RM_P18" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "VIEW"
Then the table has 3 rows
Then table has values
  | artikel     | mge   | gutmge    | tcharge   |
  | BG01_CHARGE | 20    | 20        |           |
  | EK02_CHARGE | 0     | 0         |           |
  | EK01_CHARGE | 0     | 0         |           |
And I press button "mzsubm" to open a subeditor for "FertigteilMZ" in row 1
Then table has values
    | lpsuch | zuomge   | tcharge   |
    | F1     | 12       | 181818_1  |
    | F2     | 8        | 181818_2  |
And I close the current editor
And I switch the current editor to editor "RMPruef"
And I close the current editor

# es wurde KEIN Verfallsdatum in der Charge gesetzt, da keine Haltbarkeit im Artikel hinterlegt ist
Given I open an editor "Charge181818_1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=181818_1;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | 181818_1      |
    | eigcharge | ja            |
    | verfall   |               |
    | lief      |               |
And I close the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==BG01_CHARGE;buarta==Zugang;platz==F1;erbtext1==RM_P18"
Then fields have values
    | artikel       | BG01_CHARGE                   |
    | platz         | F1                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 12                            |
    | buart         | 1                             |
    | buarta        | Zugang                        |
    | ursache       | Fertigung                     |
    | detursache    | Rückmeldung Fertigung         |
Then field "tncharge" has value "181818_1" in row 1
And I close the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==BG01_CHARGE;buarta==Zugang;platz==F2;erbtext1==RM_P18"
Then fields have values
    | artikel       | BG01_CHARGE                   |
    | platz         | F2                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 8                             |
    | buart         | 1                             |
    | buarta        | Zugang                        |
    | ursache       | Fertigung                     |
    | detursache    | Rückmeldung Fertigung         |
Then field "tncharge" has value "181818_2" in row 1
And I close the current editor


Scenario: MGERED01 Fertigungsmenge reduzieren und Restmenge mitbuchen, keine Abbuchung ohne Charge

Given I create a work order "MGERED01" for Product "BG01_CHARGE" with quantity "2" and search word "MGERED01_"

Given I create a Lot "CHZU_MGERED01" for Product "BG01_CHARGE"

Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "MGERED01_000"
And I press button "absteig" to open a subeditor for "AFL"
And I set field "manbu" to "ja" in row 3
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Rueckmeldung auf ersten Arbeitsschein mit retrogradem Material, ohne Chargenangabe
Given I open an editor "RM1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=MGERED01_001;@richtung=rückwärts;@maxordtreffer=1"
And I set field "sofort" to "ja"
And I set field "gutmge" to "1" in row 1
And I set field "erbtext1" to "RM1" in row 1
And I save the current editor

# in der Rueckmeldung wurde fuer das retrograde Material eine Zeile mit Menge 0 erstellt, da die Chargenangabe fehlt
Given I open an editor "RM1Pruef1" via ID from editor "RM1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "VIEW"
Then the table has 2 rows
Then table has values
  | artikel     | mge   | gutmge    |
  | BG01_CHARGE | 2     | 1         |
  | EK01_CHARGE | 0     | 0         |
And I close the current editor

# Rueckmeldung auf zweiten Arbeitsschein, mit Fertigungsmenge reduzieren und Restmenge mitbuchen, aber nur mit Kopfcharge
Given I open an editor "RM2_MGERED01" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=MGERED01_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort        | ja                |
    | mgereduzieren | ja                |
    | manrest       | ja                |
    | bem           | RM2_MGERED01      |
    | kcharge       | !CHZU_MGERED01^id |
And I set field "gutmge" to "1" in row 1
And I set field "erbtext1" to "RM2_MGERED01" in row 1
And I save the current editor

# im Rueckmeldebeleg pruefen, Material wurde NICHT abgebucht
Given I open an editor "RM2Pruef" via ID from editor "RM2_MGERED01" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "VIEW"
Then the table has 3 rows
Then table has values
    | artikel     | mge   | gutmge    |
    | BG01_CHARGE | 2     | 1         |
    | EK02_CHARGE | 0     | 0         |
    | EK01_CHARGE | 0     | 0         |
And I close the current editor

# Prüfung auskommentiert, da limge in Zeile 1 nicht wie erwartet auf 1, sondern auf 0 steht.
# Zugehöriges Issue: FDA-6407
#Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "MGERED01_000"
#And I press button "absteig" to open a subeditor for "AFL"
#Then table has values
#    | !row  | elex          | limge |
#    | 1     | EK01_CHARGE   | 1     |
#    | 3     | EK02_CHARGE   | 1     |
#And I close the current subeditor to switch back to the parent editor
#And I close the current editor


Scenario: BD1 Chargenpflicht bei Zugang aus Fertigung über BDE Buchung. Keine Chargenangabe aber MZ am FV vorhanden.

Given I open an editor "MA" from table "(Employee):(Employee)" with command "UPDATE" for record "KARL"
And I set field "lohn" to "1"
And I save the current editor

Given I create a Lot "CH1_BD1" for Product "BG01_CHARGE"
Given I create a Lot "CH2_BD1" for Product "BG01_CHARGE"

Given I create a work order "BD1" for Product "BG01_CHARGE" with quantity "14" and search word "BD1_"

Given I open an editor "BABD1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BD1_000"
And I press button "mzsubm" to open a subeditor for "FertigteilMZ"
And I modify table
    | !row  | lpsuch | zuomge   | charge      |
    | +1    | F1     | 7        | !CH1_BD1^id |
    | +2    | F2     | 7        | !CH2_BD1^id |
And I save the current editor
And I switch the current editor to editor "BABD1"
And I save the current editor

# Arbeitsschein oeffnen, um Zugriff auf Nummer zu haben
Given I open an editor "BD1AS2" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BD1_002;@richtung=rückwärts;@maxordtreffer=1"
And I close the current editor

# Auftragszeit ohne Chargenangabe buchen, Buchung möglich, da MZ vorhanden
Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
And I set fields
    | ma        | KARL              |
    | asma      | !BD1AS2^nummer    |
    | anfdat    | .                 |
    | anfzeit   | 08:00             |
    | enddat    | .                 |
    | endzeit   | 08:45             |
    | istmge    | 3                 |
    | sofort    | ja                |
And I save the current editor

# Lagerjournal prüfen
And I open the infosystem "LJ"
And I set fields
    | adatum        | .                     |
    | artikel       | BG01_CHARGE           |
    | kdetursache   | Rückmeldung Fertigung |
    | beleg         | !BD1AS2^nummer        |
And I press start
Then table has values
    | art          | zmge | ncharge^id     |
    | BG01_CHARGE  | 3    | !CH1_BD1^id    |
And I close the current editor


Scenario: BD2 Chargenpflicht bei Zugang aus Fertigung über BDE Buchung. Nur vier Seriennummern in MZ am FV vorhanden.

Given I create a Lot "CH1_ZU_BG03_SN" for Product "BG03_SN"
Given I create a Lot "CH2_ZU_BG03_SN" for Product "BG03_SN"
Given I create a Lot "CH3_ZU_BG03_SN" for Product "BG03_SN"
Given I create a Lot "CH4_ZU_BG03_SN" for Product "BG03_SN"

Given I create a Lot "CH1_AB_EK04_SN" for Product "EK04_SN"
Given I create a Lot "CH2_AB_EK04_SN" for Product "EK04_SN"
Given I create a Lot "CH3_AB_EK04_SN" for Product "EK04_SN"
Given I create a Lot "CH4_AB_EK04_SN" for Product "EK04_SN"

Given I create a work order "BD2" for Product "BG03_SN" with quantity "11" and search word "BD2_"

Given I open an editor "FVBD2" from table "(Purchasing):(WorkOrderSuggestion)" with command "UPDATE" for search criteria "$,,artikel==BG03_SN;mge==11;@richtung=rückwärts;@maxordtreffer=1"
And I press button "mzsubm" to open a subeditor for "FertigteilMZ"
And I modify table
    | !row | lpsuch | zuomge   | charge             |
    | 1    | F1     | 1        | !CH1_ZU_BG03_SN^id |
    | 2    | F2     | 1        | !CH2_ZU_BG03_SN^id |
    | 3    | F3     | 1        | !CH3_ZU_BG03_SN^id |
    | 4    | F4     | 1        | !CH4_ZU_BG03_SN^id |
And I save the current editor
And I switch the current editor to editor "FVBD2"
And I press button "mzabsm" to open a subeditor for "EntnahmeteilMZ"
And I modify table
    | !row | lpsuch | zuomge   | charge             |
    | 1    | F1     | 1        | !CH1_AB_EK04_SN^id |
    | 2    | F2     | 1        | !CH2_AB_EK04_SN^id |
    | 3    | F3     | 1        | !CH3_AB_EK04_SN^id |
    | 4    | F4     | 1        | !CH4_AB_EK04_SN^id |
And I save the current editor
And I switch the current editor to editor "FVBD2"
And I save the current editor

# Arbeitsschein oeffnen, um Zugriff auf Nummer zu haben
Given I open an editor "BD2AS2" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BD2_002;@richtung=rückwärts;@maxordtreffer=1"
And I close the current editor

# Auftragszeit ohne Seriennummernangabe buchen. Seriennummern reichen nicht aus (istmge > 4) -> Fehlermeldung. istmge auf 3 setzen -> Buchung möglich
Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
And I set fields
    | ma        | MEIER             |
    | asma      | !BD2AS2^nummer    |
    | anfdat    | .                 |
    | anfzeit   | 08:00             |
    | enddat    | .                 |
    | endzeit   | 08:45             |
    | istmge    | 5                 |
    | sofort    | ja                |
# Nachfolgende Exception wird nicht geworfen, weil die Fehlermeldung nicht zum Abbruch führt, sondern der Satz nur gespeichert,
# aber nicht übertragen wird!
# Then saving the current editor throws the exception "1164"
And I set field "istmge" to "3"
And I save the current editor

# Kurzläufer ohne Seriennummernangabe buchen. Seriennummern reichen nicht aus (istmge > 1) -> Fehlermeldung. istmge auf 1 setzen -> Buchung möglich
Given I open an editor "Auftragszeit" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
And I set fields
    | ma        | MEIER             |
    | asma      | !BD2AS2^nummer    |
    | anfdat    | .                 |
    | anfzeit   | 08:50             |
    | istzeit   | 0,45              |
    | istmge    | 2                 |
    | sofort    | ja                |
# Nachfolgende Exception wird nicht geworfen, weil die Fehlermeldung nicht zum Abbruch führt, sondern der Satz nur gespeichert,
# aber nicht übertragen wird!
# Then saving the current editor throws the exception "1164"
And I set field "istmge" to "1"
And I save the current editor

# Lagerjournal prüfen
And I open the infosystem "LJ"
And I set fields
    | adatum        | .                     |
    | artikel       | BG03_SN               |
    | kdetursache   | Rückmeldung Fertigung |
    | beleg         | !BD2AS2^nummer        |
And I press start
Then table has values
    | art      | zmge | ncharge^id         |
    | BG03_SN  | 1    | !CH1_ZU_BG03_SN^id |
    | BG03_SN  | 1    | !CH2_ZU_BG03_SN^id |
    | BG03_SN  | 1    | !CH3_ZU_BG03_SN^id |
    | BG03_SN  | 1    | !CH4_ZU_BG03_SN^id |
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum        | .                     |
    | artikel       | EK04_SN               |
    | kdetursache   | Rückmeldung Fertigung |
    | beleg         | !BD2AS2^nummer        |
And I press start
Then table has values
    | art      | amge | vcharge^id         | ncharge^id         |
    | EK04_SN  | 1    | !CH1_AB_EK04_SN^id | !CH1_ZU_BG03_SN^id |
    | EK04_SN  | 1    | !CH2_AB_EK04_SN^id | !CH2_ZU_BG03_SN^id |
    | EK04_SN  | 1    | !CH3_AB_EK04_SN^id | !CH3_ZU_BG03_SN^id |
    | EK04_SN  | 1    | !CH4_AB_EK04_SN^id | !CH4_ZU_BG03_SN^id |
And I close the current editor
