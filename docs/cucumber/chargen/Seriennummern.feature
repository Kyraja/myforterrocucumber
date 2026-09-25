@persistent
Feature: Seriennummern.feature

Background:
And I set the fake date to "16.01.1995"

# **********************************************************************************
#  Name             : Seriennummern.feature
#  Autor            : bschiga
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Seriennummernverwaltung
#  ref              : ref_seriennr_cu
#
# **********************************************************************************

Scenario: Chargenpflicht in Konfiguration einschalten

Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set fields
    | chpflicht   | ja  |
And I save the current editor


Scenario: SNR01 Seriennummernpruefung bei der manuellen Lagerbuchung - Pflichtangabe und Menge nur 1

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK01_SNR      |
    | buart     | Zugang        |
    | beleg     | LBUZU_SNR01   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | tcharge2  |
    | 3      | F1       | 1234SNR   |
# 7039 TX=de |Artikel mit Seriennummernverfolgung darf nur mit Menge und Faktor 1 in Lagereinheit gebucht werden. Vorgang oder MZ prüfen.
Then saving the current editor throws the exception "7039"
And I modify table
    | !row  | mge    | platz2   |
    | 1     | 1      | F1       |
    | +2    | 1      | F1       |
    | +3    | 1      | F1       |
And I set field "tcharge2" to "1234SNR" in row 2
# 7043 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde zugebucht.
Then saving the current editor throws the exception "7043"
And I modify table
    | !row  | tcharge2      |
    | 2     | 3456SNR       |
    | 3     |               |
# 1164 TX=de |Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then saving the current editor throws the exception "1164"
And I set field "tcharge2" to "5678SNR" in row 3
And I save the current editor

Given I open an editor "Charge1234" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=1234SNR;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel       | EK01_SNR                  |
    | exnum         | 1234SNR                   |
    | chverfolgung  | Seriennummernverfolgung   |
And I close the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK01_SNR      |
    | buart     | Abgang        |
    | beleg     | LBUAB_SNR01   |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | charge1           |
    | 2      | F1       | !Charge1234^id    |
# 7039 TX=de |Artikel mit Seriennummernverfolgung darf nur mit Menge und Faktor 1 in Lagereinheit gebucht werden. Vorgang oder MZ prüfen.
Then saving the current editor throws the exception "7039"
And I modify table
    | !row  | mge    | platz    | tcharge1      |
    | 1     | 1      | F1       | !dontChange   |
    | +2    | 1      | F1       | 3456SNR       |
And I save the current editor

Given I open an editor "Charge5678" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=5678SNR;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel       | EK01_SNR                  |
    | exnum         | 5678SNR                   |
    | chverfolgung  | Seriennummernverfolgung   |
And I close the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK01_SNR      |
    | buart     | Umbuchung     |
    | beleg     | LBUUM_SNR01   |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | platz2   |
    | 2      | F1       | F2       |
# 7039 TX=de |Artikel mit Seriennummernverfolgung darf nur mit Menge und Faktor 1 in Lagereinheit gebucht werden. Vorgang oder MZ prüfen.
Then saving the current editor throws the exception "7039"
And I set field "mge" to "1" in row 1
# 1164 TX=de |Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then saving the current editor throws the exception "1164"
# bereits verwendete SNR kann umgebucht werden
And I set field "charge1" to "!Charge5678^id" in row 1
And I set field "charge2" to "!Charge5678^id" in row 1
And I save the current editor

Given I open an editor "Charge3456" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=3456SNR;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel       | EK01_SNR                  |
    | exnum         | 3456SNR                   |
    | chverfolgung  | Seriennummernverfolgung   |
    | snzugangverf  | nein                      |
And I close the current editor

# Umchargieren geht nur, wenn die SNR nicht im Zugang bzw. Abgang verbraucht ist
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK01_SNR      |
    | buart     | Umbuchung     |
    | beleg     | LBUUM_SNR01   |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | platz2   | charge1        | charge2           |
    | 1      | F1       | F3       | !Charge5678^id | !Charge3456^id    |
# 7043 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde zugebucht.
Then saving the current editor throws the exception "7043"
And I set field "tcharge2" to "3456NEU" in row 1
And I save the current editor

Given I open an editor "Charge3456NEU" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=3456NEU;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel       | EK01_SNR                  |
    | exnum         | 3456NEU                   |
    | chverfolgung  | Seriennummernverfolgung   |
    | snzugangverf  | nein                      |
    | snabgangverf  | ja                        |
And I close the current editor

Given I open an editor "Charge5678" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=5678SNR;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel       | EK01_SNR                  |
    | exnum         | 5678SNR                   |
    | chverfolgung  | Seriennummernverfolgung   |
    | snabgangverf  | nein                      |
    | snzugangverf  | nein                      |
And I close the current editor

# Umchargieren geht nur, wenn die SNR nicht im Zugang bzw. Abgang verbraucht ist
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK01_SNR      |
    | buart     | Umbuchung     |
    | beleg     | LBUM_SNR01A   |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | platz2   | charge1        | tcharge2  |
    | 1      | F1       | F2       | !Charge1234^id | 3456NEU_2 |
# 7044 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde abgebucht.
Then saving the current editor throws the exception "7044"
And I set field "tcharge1" to "CH_AB" in row 1
And I save the current editor


Scenario: SNR02 Seriennummernpruefung bei der Bestandskorrektur - Menge 1

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | EK01_SNR    |
    | beleg     | KORR_SNR02  |
    | beldat    | .           |
And I set field "platz" to "F3" in row 1
Then the table has 1 rows
Then table has values
   | mge   | tcharge1  |
   | 1     | 3456NEU   |
# 7040 Für Artikel mit Seriennummernverfolgung mit Bestand sind nur folgende Korrekturen erlaubt: von -1 oder 1 auf 0 oder von 0 auf 1
Then setting field "mge" to "2" in row 1 throws the exception "7040"
And I set field "mge" to "0" in row 1
And I append rows
    | platz  | mge   | ze       | tcharge1  |
    | F3     | 2     | Stück    | 1234SNR2  |
# 7039 TX=de |Artikel mit Seriennummernverfolgung darf nur mit Menge und Faktor 1 in Lagereinheit gebucht werden. Vorgang oder MZ prüfen.
Then saving the current editor throws the exception "7039"
And I set field "mge" to "1" in row 2
And I set field "zele" to "2" in row 2
# 7039 TX=de |Artikel mit Seriennummernverfolgung darf nur mit Menge und Faktor 1 in Lagereinheit gebucht werden. Vorgang oder MZ prüfen.
Then saving the current editor throws the exception "7039"
And I set field "zele" to "1" in row 2
And I save the current editor


Scenario: SNR05 Buchung nur in Lagereinheit und nur Faktor 1

Given I open an editor "LS_SNR05" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFCHA1     |
    | such   | LS_SNR05     |
    | ebeleg | LS_SNR05     |
    | vom    | .            |
    | ueb    | ja           |
And I append rows
    | artikel       | mge |
    | EINHEIT_SNR   | 1   |
Then field "he" has value "m" in row 1
Then field "tcharge" is not modifiable in row 1
# 7039 TX=de |Artikel mit Seriennummernverfolgung darf nur mit Menge und Faktor 1 in Lagereinheit gebucht werden. Vorgang oder MZ prüfen.
Then saving the current editor throws the exception "7039"
And I set field "he" to "Stück" in row 1
And I set field "lehe" to "2" in row 1
Then saving the current editor throws the exception "7039"
And I set field "lehe" to "1" in row 1
And I set field "mge" to "2" in row 1
Then field "tcharge" is not modifiable in row 1
Then saving the current editor throws the exception "7039"
And I set field "mge" to "1" in row 1
And I set field "tcharge" to "SNR05MT" in row 1
And I save the current editor


Scenario: SNR06 Seriennummernpruefung in EK-Belegen beim Buchen von Lieferschein oder Rechnung mit Lagerbewegung

Given I open an editor "EKBESNR06" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | LIEFCHA1   |
    | such | BE_SNR06   |
    | vom  | .          |
And I append rows
    | artikel   | mge | einplan |
    | EK01_SNR  | 3   | ja      |
# Charge ist noch keine Pflichtangabe in der EK-Bestellung
Then field "tcharge" is empty in row 1
# MZ wird automatisch angelegt mit 3 Zeile und jeweils Menge 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then table has values
    | zuomge   | tcharge   |
    | 1        |           |
    | 1        |           |
    | 1        |           |
And I modify table
    | !row  | lpsuch | zuomge   |
    | 1     | F1     | 2        |
# 7039 TX=de |Artikel mit Seriennummernverfolgung darf nur mit Menge und Faktor 1 in Lagereinheit gebucht werden. Vorgang oder MZ prüfen.
Then saving the current editor throws the exception "7039"
And I close the current editor
And I switch the current editor to editor "EKBESNR06"
And I save the current editor

# Charge ist noch keine Pflichtangabe beim Erstellen des Lieferscheins
Given I open an editor "LS_SNR06" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFCHA1     |
    | such   | LS_SNR06     |
    | ebeleg | LS_SNR06     |
    | vom    | .            |
    | ueb    | nein         |
And I append rows
    | artikel   | mge |
    | EK01_SNR  | 5   |
Then field "tcharge" is empty in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then table has values
    | zuomge   | tcharge   |
    | 1        |           |
    | 1        |           |
    | 1        |           |
    | 1        |           |
    | 1        |           |
And I modify table
    | !row  | lpsuch | zuomge   |
    | 3     | F1     | 2        |
Then field "tcharge" is empty in row 1
# 7039 TX=de |Artikel mit Seriennummernverfolgung darf nur mit Menge und Faktor 1 in Lagereinheit gebucht werden. Vorgang oder MZ prüfen.
Then saving the current editor throws the exception "7039"
And I close the current editor
And I switch the current editor to editor "LS_SNR06"
And I save the current editor

# Charge ist noch keine Pflichtangabe beim Erstellen einer Rechnung mit Lagerbewegung
Given I open an editor "RE_SNR06" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFCHA1     |
    | such   | RE_SNR06     |
    | ebeleg | RE_SNR06     |
    | vom    | .            |
    | tterm  | .            |
    | ueb    | nein         |
    | fakt   | ja           |
And I append rows
    | artikel   | mge |
    | EK01_SNR  | 5   |
Then field "tcharge" is empty in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then table has values
    | zuomge   | tcharge   |
    | 1        |           |
    | 1        |           |
    | 1        |           |
    | 1        |           |
    | 1        |           |
And I modify table
    | !row  | lpsuch | zuomge   |
    | 3     | F1     | 2        |
Then field "tcharge" is empty in row 1
# 7039 TX=de |Artikel mit Seriennummernverfolgung darf nur mit Menge und Faktor 1 in Lagereinheit gebucht werden. Vorgang oder MZ prüfen.
Then saving the current editor throws the exception "7039"
And I close the current editor
And I switch the current editor to editor "RE_SNR06"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Charge ist Pflichtangabe beim Buchen des EK-Lieferscheins
Given I open an editor "LS_SNR06" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "LS_SNR06"
And I set field "ueb" to "ja"
And I set field "mge" to "2" in row 1
Then field "tcharge" is empty in row 1
# 1164 TX=de |Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then saving the current editor throws the exception "7039"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | tcharge  |
    | 1     | F1     | 06SNR1   |
    | 2     | F1     |          |
And I save the current editor
And I switch the current editor to editor "LS_SNR06"
# 1490 TX=de |Charge im Vorgang und in MZ fehlt oder ist unvollständig, obwohl Chargenpflicht in Konfiguration und Artikel gesetzt ist.
Then saving the current editor throws the exception "1490"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "tcharge" to "06SNR2" in row 2
And I save the current editor
And I switch the current editor to editor "LS_SNR06"
And I save the current editor

# Charge ist Pflichtangabe beim Buchen der EK-Rechnung mit Lagerbewegung
Given I open an editor "RE_SNR06" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "RE_SNR06"
And I set field "ueb" to "ja"
And I set field "mge" to "2" in row 1
Then field "tcharge" is empty in row 1
# 1164 TX=de |Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then saving the current editor throws the exception "7039"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | tcharge  |
    | 1     | F1     | 06SNR3   |
    | 2     | F1     |          |
And I save the current editor
And I switch the current editor to editor "RE_SNR06"
# 1490 TX=de |Charge im Vorgang und in MZ fehlt oder ist unvollständig, obwohl Chargenpflicht in Konfiguration und Artikel gesetzt ist.
Then saving the current editor throws the exception "1490"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "tcharge" to "06SNR4" in row 2
And I save the current editor
And I switch the current editor to editor "RE_SNR06"
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK01_SNR;buarta==Zugang;platz==F1;ebeleg==LS_SNR06;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EK01_SNR              |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 1                     |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
Then field "tncharge" has value "06SNR1" in row 1
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK01_SNR;buarta==Zugang;platz==F1;ebeleg==LS_SNR06;@richtung=rückwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EK01_SNR              |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 1                     |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
Then field "tncharge" has value "06SNR2" in row 1
And I close the current editor

Given I open an editor "JournalZu3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK01_SNR;buarta==Zugang;platz==F1;ebeleg==RE_SNR06;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EK01_SNR              |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 1                     |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
Then field "tncharge" has value "06SNR3" in row 1
And I close the current editor

Given I open an editor "JournalZu4" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK01_SNR;buarta==Zugang;platz==F1;ebeleg==RE_SNR06;@richtung=rückwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EK01_SNR              |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 1                     |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
Then field "tncharge" has value "06SNR4" in row 1
And I close the current editor


Scenario: SNR07 Seriennummernpruefung beim Buchen von VK-Belegen, Lieferschein, Rechnung mit Lagerbewegung

Given I open an editor "VKAUFSNR07" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH1   |
    | such  | AUFSNR07   |
    | vom   | .          |
And I append rows
    | artikel   | mge | einplan |
    | EK01_SNR  | 3   | ja      |
# Charge ist noch keine Pflichtangabe im VK-Auftrag
Then field "tcharge" is empty in row 1
# MZ wird automatisch angelegt mit 3 Zeile und jeweils Menge 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then table has values
    | zuomge   | tcharge   |
    | 1        |           |
    | 1        |           |
    | 1        |           |
And I modify table
    | !row  | lpsuch | zuomge   |
    | 1     | F1     | 2        |
    | 2     | F1     | 0        |
# 7039 TX=de |Artikel mit Seriennummernverfolgung darf nur mit Menge und Faktor 1 in Lagereinheit gebucht werden. Vorgang oder MZ prüfen.
Then saving the current editor throws the exception "7039"
And I close the current editor
And I switch the current editor to editor "VKAUFSNR07"
And I save the current editor

# Charge ist noch keine Pflichtangabe beim Erstellen des VK-Lieferschein
Given I open an editor "VKLS_SNR7" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde  | KUNDECH1     |
    | such   | VKLS_SNR7    |
    | vom    | .            |
    | ueb    | nein         |
And I append rows
    | artikel   | mge |
    | EK01_SNR  | 5   |
Then field "tcharge" is empty in row 1
# MZ wird automatisch angelegt mit 5 Zeilen und jeweils Menge 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then table has values
    | zuomge   | tcharge   |
    | 1        |           |
    | 1        |           |
    | 1        |           |
    | 1        |           |
    | 1        |           |
And I modify table
    | !row  | lpsuch | zuomge   |
    | 1     | F1     | 2        |
Then field "tcharge" is empty in row 1
# 7039 TX=de |Artikel mit Seriennummernverfolgung darf nur mit Menge und Faktor 1 in Lagereinheit gebucht werden. Vorgang oder MZ prüfen.
Then saving the current editor throws the exception "7039"
And I set field "zuomge" to "1" in row 1
And I save the current editor
And I switch the current editor to editor "VKLS_SNR7"
And I save the current editor

# Charge ist noch keine Pflichtangabe beim Erstellen einer VK-Rechnung mit Lagerbewegung
Given I open an editor "VKRE_SNR7" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde  | KUNDECH1     |
    | such   | VKRE_SNR7    |
    | vom    | .            |
    | tterm  | .            |
    | ueb    | nein         |
    | fakt   | ja           |
And I append rows
    | artikel   | mge |
    | EK01_SNR  | 3   |
Then field "tcharge" is empty in row 1
# MZ wird automatisch angelegt mit 3 Zeile und jeweils Menge 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then table has values
    | zuomge   | tcharge   |
    | 1        |           |
    | 1        |           |
    | 1        |           |
And I modify table
    | !row  | lpsuch | zuomge   |
    | 1     | F1     | 2        |
Then field "tcharge" is empty in row 1
# 7039 TX=de |Artikel mit Seriennummernverfolgung darf nur mit Menge und Faktor 1 in Lagereinheit gebucht werden. Vorgang oder MZ prüfen.
Then saving the current editor throws the exception "7039"
And I set field "zuomge" to "1" in row 1
And I save the current editor
And I switch the current editor to editor "VKRE_SNR7"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Charge oeffnen um Zugriff auf die ID zu haben
Given I open an editor "06SNR1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=06SNR1;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum         | 06SNR1                    |
    | chverfolgung  | Seriennummernverfolgung   |
And I close the current editor

Given I open an editor "06SNR2" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=06SNR2;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum         | 06SNR2                    |
    | chverfolgung  | Seriennummernverfolgung   |
And I close the current editor

Given I open an editor "06SNR3" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=06SNR3;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum         | 06SNR3                    |
    | chverfolgung  | Seriennummernverfolgung   |
And I close the current editor

Given I open an editor "06SNR4" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=06SNR4;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum         | 06SNR4                    |
    | chverfolgung  | Seriennummernverfolgung   |
And I close the current editor

# Charge ist Pflichtangabe beim Buchen des VK-Lieferscheins
# vorhandene SNR nehmen, die vorher durch EK-Beleg zugebucht wurde, es darf kein neues Chargenobjekt automatisch erstellt werden
Given I open an editor "VKLS_SNR7" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "VKLS_SNR7"
And I set field "ueb" to "ja"
And I set field "mge" to "2" in row 1
Then field "tcharge" is empty in row 1
# 1490 TX=de |Charge im Vorgang und in MZ fehlt oder ist unvollständig, obwohl Chargenpflicht in Konfiguration und Artikel gesetzt ist.
Then saving the current editor throws the exception "1490"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | tcharge   |
    | 1     | F1     | 06SNR1    |
    | 2     | F1     | 06SNR2    |
Then field "charge^id" has value "!06SNR1^id" in row 1
Then field "charge^id" has value "!06SNR2^id" in row 2
# MZ wurde bereits angelegt mit 5 Zeilen, deshalb die letzten 3 Zeilen loeschen
And I delete row at position 3
And I delete row at position 3
And I delete row at position 3
And I save the current editor
And I switch the current editor to editor "VKLS_SNR7"
And I set field "ljtext1" to "VKLS_SNR07" in row 1
And I save the current editor

# Charge ist Pflichtangabe beim Buchen der VK-Rechnung mit Lagerbewegung
Given I open an editor "VKRE_SNR7" from table "(Sales):(Invoice)" with command "UPDATE" for record "VKRE_SNR7"
And I set field "ueb" to "ja"
And I set field "mge" to "2" in row 1
Then field "tcharge" is empty in row 1
# 1490 TX=de |Charge im Vorgang und in MZ fehlt oder ist unvollständig, obwohl Chargenpflicht in Konfiguration und Artikel gesetzt ist.
Then saving the current editor throws the exception "1490"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | tcharge   |
    | 1     | F1     | 06SNR3    |
    | 2     | F1     | 06SNR4    |
Then field "charge^id" has value "!06SNR3^id" in row 1
Then field "charge^id" has value "!06SNR4^id" in row 2
# MZ wurde bereits angelegt mit 3 Zeilen, deshalb die letzte Zeile loeschen
And I delete row at position 3
And I save the current editor
And I switch the current editor to editor "VKRE_SNR7"
And I set field "ljtext1" to "VKRE_SNR07" in row 1
And I save the current editor

Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK01_SNR;buarta==Abgang;platz==F1;erbtext1==VKLS_SNR07;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EK01_SNR              |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 1                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
Then field "tvcharge" has value "06SNR1" in row 1
And I close the current editor

Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK01_SNR;buarta==Abgang;platz==F1;erbtext1==VKLS_SNR07;@richtung=rückwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EK01_SNR              |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 1                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
Then field "tvcharge" has value "06SNR2" in row 1
And I close the current editor

Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK01_SNR;buarta==Abgang;platz==F1;erbtext1==VKRE_SNR07;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EK01_SNR              |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 1                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
Then field "tvcharge" has value "06SNR3" in row 1
And I close the current editor

Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK01_SNR;buarta==Abgang;platz==F1;erbtext1==VKRE_SNR07;@richtung=rückwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EK01_SNR              |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 1                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
Then field "tvcharge" has value "06SNR4" in row 1
And I close the current editor


Scenario: SNR08 Ruecklieferschein im EK nicht mit neuer Seriennummer moeglich, ist ohne Seriennummer moeglich

# neue SNR nicht moeglich, ohne SNR moeglich, LS aus Scenario SNR06 nehmen
Given I open an editor "LS_SNR06" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "LS_SNR06"
And I set fields
    | such      | RLS_SNR06 |
    | ebeleg    | RLS_SNR06 |
    | ueb       | ja        |
Then table has values
    | artikel   | tcharge   |
    | EK01_SNR  |           |
And I set field "mge" to "-1" in row 1
Then field "tcharge" is not modifiable in row 1
# ohne SNR kann gebucht werden, wird aus Originallieferschein geholt, Menge darf ungleich 1 bzw. -1 sein
And I set field "mge" to "-2" in row 1
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK01_SNR;buarta==Zugang;platz==F1;ebeleg==RLS_SNR06;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EK01_SNR              |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | -1                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Rücklieferung Einkauf |
# es wird die SNR aus dem vorher gebuchten Lieferschein genommen, zu dem die Rueckieferung erstellt wurde
Then field "tncharge" has value "06SNR1" in row 1
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK01_SNR;buarta==Zugang;platz==F1;ebeleg==RLS_SNR06;@richtung=rückwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EK01_SNR              |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | -1                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Rücklieferung Einkauf |
Then field "tncharge" has value "06SNR2" in row 1
And I close the current editor


Scenario: SNR09 Ruecklieferschein im VK nicht mit neuer Seriennummer moeglich, ist auch ohne Seriennummer moeglich

# neue Charge nicht moeglich, ohne Charge moeglich
Given I open an editor "VKLS_SNR7" from table "(Sales):(PackingSlip)" with command "RETURN" for record "VKLS_SNR7"
And I set fields
    | such      | RLS1_P07  |
    | ueb       | ja        |
Then table has values
    | artikel   | tcharge   |
    | EK01_SNR  |           |
And I set field "mge" to "-1" in row 1
Then field "tcharge" is not modifiable in row 1
# kann ohne Angabe SNR gebucht wird, wird aus Originallieferschein geholt, Menge darf ungleich 1 bzw. -1 sein
And I set field "mge" to "-2" in row 1
And I set field "platz" to "F1" in row 1
And I set field "ljtext1" to "RLS1_SNR07" in row 1
And I save the current editor

Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK01_SNR;buarta==Abgang;platz==F1;mge==-1;erbtext1==RLS1_SNR07;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EK01_SNR              |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | -1                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Rücklieferung Verkauf |
# es wird die Charge aus dem vorher gebuchten Lieferschein genommen, zu dem die Ruecklieferung erstellt wurde
Then field "tvcharge" has value "06SNR1" in row 1
And I close the current editor

Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK01_SNR;buarta==Abgang;platz==F1;mge==-1;erbtext1==RLS1_SNR07;@richtung=rückwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EK01_SNR              |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | -1                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Rücklieferung Verkauf |
Then field "tvcharge" has value "06SNR2" in row 1
And I close the current editor


Scenario: SNR10 Seriennummernpruefung bei Zugang aus Fertigung, Nachbuchen auf abgelegten Fertigungsvorschlag

Given I create a work order "SNR10" for Product "BG01_SNR" with quantity "1" and search word "SNR10_"

Given I open an editor "BA_SNR10" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SNR10_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | 1     | F1     | 1        | 1010_1    |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | 1     | F1     | 1        | 1010_2    |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_SNR10"
And I save the current editor

# Rueckmeldung auf Arbeitsschein 2
Given I open an editor "RM_SNR10" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR10_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | gut       | ja        |
    | tkcharge  | 101010    |
    | bem       | RM_SNR10  |
And I set field "erbtext1" to "RM_SNR10" in row 1
And I save the current editor

# Nachbuchen auf abgelegten Fertigungsvorschlag
Given I open an editor "RMNACH1" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=SNR10_002;bem=RM_SNR10;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
Then table has values
    | artikel     |
    | BG01_SNR    |
    | EK01_SNR    |
    | EK02_SNR    |
And I set field "bem" to "NACHBUCH2"
# Zugangscharge eintragen
And I set field "tkcharge" to "101010N"
And I set field "gutmge" to "2" in row 1
Then field "kcharge" is empty
And I delete row at position 2
And I delete row at position 2
# 7039 TX=de |Artikel mit Seriennummernverfolgung darf nur mit Menge und Faktor 1 in Lagereinheit gebucht werden. Vorgang oder MZ prüfen.
Then saving the current editor throws the exception "7039"
And I set field "gutmge" to "1" in row 1
And I set field "tkcharge" to "101010N"
And I save the current editor

# Buchungen im LJ pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM_SNR10^barmex"
And I press start
Then table has values
    | art       | zmge | amge     | tvcharge  | tncharge    |
    | EK02_SNR  |      | 1        | 1010_2    | 101010      |
    | EK01_SNR  |      | 1        | 1010_1    | 101010      |
    | BG01_SNR  | 1    |          |           | 101010      |
    | BG01_SNR  | 1    |          |           | 101010N     |
And I close the current editor


Scenario: SNR11 Seriennummernpruefung bei Zugang aus Fertigung, EntnahmeMZ fuer retrogrades Material erfassen

Given I create a work order "SNR11" for Product "BG01_SNR" with quantity "5" and search word "SNR11_"

Given I open an editor "BA_SNR11" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SNR11_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   | ztcharge  |
    | 1     | F1     | 1        | 1111_1    | 1111_1ZU  |
    | 2     | F1     | 1        | 1111_2    | 1111_2ZU  |
    | 3     | F1     | 1        | 1111_3    | 1111_3ZU  |
    | 4     | F1     | 1        | 1111_4    | 1111_4ZU  |
    | 5     | F1     | 1        | 1111_5    | 1111_5ZU  |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   | ztcharge  |
    | 1     | F1     | 1        | 1112_1    | 1111_1ZU  |
    | 2     | F1     | 1        | 1112_2    | 1111_2ZU  |
    | 3     | F1     | 1        | 1112_3    | 1111_3ZU  |
    | 4     | F1     | 1        | 1112_4    | 1111_4ZU  |
    | 5     | F1     | 1        | 1112_5    | 1111_5ZU  |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_SNR11"
And I save the current editor

# Rueckmeldung Gesamtmenge auf Arbeitsschein 1, keine Zugangsbuchung, nur Entnahme retrograd
Given I open an editor "RM1_SNR11" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR11_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | gut       | ja        |
    | bem       | RM_SNR11  |
And I set field "erbtext1" to "RM1_SNR11" in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | tcharge   |
    |  1    | F1     | 1111_1ZU  |
    |  2    | F1     | 1111_2ZU  |
    |  3    | F1     | 1111_3ZU  |
    |  4    | F1     | 1111_4ZU  |
    |  5    | F1     | 1111_5ZU  |
And I set field "zuomge" to "2" in row 1
And I set field "zuomge" to "" in row 5
# 7039 TX=de |Artikel mit Seriennummernverfolgung darf nur mit Menge und Faktor 1 in Lagereinheit gebucht werden. Vorgang oder MZ prüfen.
Then saving the current editor throws the exception "7039"
And I set field "zuomge" to "1" in row 1
And I set field "zuomge" to "1" in row 5
Then table has values
    | !row  | zuomge    | tcharge   |
    |  1    | 1         | 1111_1ZU  |
    |  2    | 1         | 1111_2ZU  |
    |  3    | 1         | 1111_3ZU  |
    |  4    | 1         | 1111_4ZU  |
    |  5    | 1         | 1111_5ZU  |
And I save the current editor
And I switch the current editor to editor "RM1_SNR11"
And I save the current editor

# Rueckmeldung Teilmenge auf Arbeitsschein 2, MZ sollte schon vorhanden sein
Given I open an editor "RM2_SNR11" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR11_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | tkcharge  | 111111    |
    | bem       | RM2_SNR11 |
And I set field "gutmge" to "4" in row 1
Then field "kcharge" is empty
And I set field "erbtext1" to "RM2_SNR11" in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
Then table has values
    | !row  | lpsuch | tcharge   |
    |  1    | F1     | 1111_1ZU  |
    |  2    | F1     | 1111_2ZU  |
    |  3    | F1     | 1111_3ZU  |
    |  4    | F1     | 1111_4ZU  |
And I close the current editor
And I switch the current editor to editor "RM2_SNR11"
And I save the current editor

# Buchungen im LJ pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_SNR11^barmex"
And I press start
Then table has values
    | art       | zmge | amge     | tvcharge  | tncharge    |
    | EK01_SNR  |      | 1        | 1111_1    | 1111_1ZU    |
    | EK01_SNR  |      | 1        | 1111_2    | 1111_2ZU    |
    | EK01_SNR  |      | 1        | 1111_3    | 1111_3ZU    |
    | EK01_SNR  |      | 1        | 1111_4    | 1111_4ZU    |
    | EK01_SNR  |      | 1        | 1111_5    | 1111_5ZU    |
And I set field "beleg" to "!RM2_SNR11^barmex"
And I press start
Then table has values
    | art       | zmge | amge     | tvcharge  | tncharge    |
    | EK02_SNR  |      | 1        | 1112_1    | 1111_1ZU    |
    | EK02_SNR  |      | 1        | 1112_2    | 1111_2ZU    |
    | EK02_SNR  |      | 1        | 1112_3    | 1111_3ZU    |
    | EK02_SNR  |      | 1        | 1112_4    | 1111_4ZU    |
    | BG01_SNR  | 1    |          |           | 1111_1ZU    |
    | BG01_SNR  | 1    |          |           | 1111_2ZU    |
    | BG01_SNR  | 1    |          |           | 1111_3ZU    |
    | BG01_SNR  | 1    |          |           | 1111_4ZU    |
And I close the current editor

# Rueckbau auf zweiten Arbeitsschein mit Menge 1 und Chargenangabe
Given I open an editor "Rueckbau_AS2" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=SNR11_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | mzeit     | 1         |
    | bzeit     | 1         |
    | sofort    | ja        |
And I set field "gutmge" to "-2" in row 1
# 2501 Die angeforderte Menge kann dem Vorgang/Platz nicht zugeordnet werden. Passen Sie Menge oder Artikeleigenschaften an.
Then saving the current editor throws the exception "2501"
And I set field "gutmge" to "-1" in row 1
# 2501 Die angeforderte Menge kann dem Vorgang/Platz nicht zugeordnet werden. Passen Sie Menge oder Artikeleigenschaften an.
Then saving the current editor throws the exception "2501"
And I set field "tcharge" to "1111_2ZU" in row 1
And I save the current editor

# Buchungen im LJ pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!Rueckbau_AS2^barmex"
And I set field "richtung" to "rückwärts"
And I press start
Then table has values
    | art       | zmge | amge     | tvcharge  | tncharge    |
    | BG01_SNR  | -1   |          |           | 1111_2ZU    |
    | EK02_SNR  |      | -1       | 1112_2    | 1111_2ZU    |
And I close the current editor

# Rueckmeldung Teilmenge auf Arbeitsschein 2, MZ schon vorhanden
Given I open an editor "RM2_SNR11" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR11_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | tkcharge  | 111111    |
    | bem       | RM2_SNR11 |
And I set field "gutmge" to "1" in row 1
And I set field "erbtext1" to "RM3_SNR11" in row 1
# 2058 de      |Für die zu buchende Gutmenge mit dieser Charge reicht die Menge in den Materialzuordnungen nicht aus.
#Then saving the current editor throws the exception "2058"
And I set field "tkcharge" to ""
And I save the current editor

# Buchungen im LJ pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM2_SNR11^barmex"
And I set field "richtung" to "rückwärts"
And I press start
Then table has values
    | art       | zmge | amge     | tvcharge  | tncharge    |
    | BG01_SNR  | 1    |          |           | 1111_5ZU    |
    | EK02_SNR  |      | 1        | 1112_5    | 1111_5ZU    |
And I close the current editor


Scenario: SNR13 Umlagerungslieferschein im Verkauf anlegen ohne Seriennummer moeglich, buchen nur mit Seriennummer

Given I open an editor "VK-UML_13" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH2          |
    | such  | VK-UML_13         |
Then field "umplatz" has value "KONSI2"
And I append rows
    | artikel       | mge  |
    | EK-UMLAGERSNR | 2    |
Then field "tcharge" is empty in row 1
And I save the current editor

Given I open an editor "VK-UML_13" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "VK-UML_13"
Then field "tcharge" is empty in row 1
And I set field "ueb" to "ja"
Then field "mge" has value "2" in row 1
# bei Menge > 1 kann keine Charge in der Position eingetragen werden, muss ueber MZ gemacht werden
Then field "tcharge" is not modifiable in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | tcharge   |
    | 1     | F1     | 13SNR1    |
    | 2     | F1     |           |
And I set field "zuomge" to "2" in row 1
And I set field "zuomge" to "0" in row 2
# 7039 TX=de |Artikel mit Seriennummernverfolgung darf nur mit Menge und Faktor 1 in Lagereinheit gebucht werden. Vorgang oder MZ prüfen.
Then saving the current editor throws the exception "7039"
And I set field "zuomge" to "1" in row 1
And I set field "zuomge" to "1" in row 2
And I save the current editor
And I switch the current editor to editor "VK-UML_13"
# 1490 TX=de |Charge im Vorgang und in MZ fehlt oder ist unvollständig, obwohl Chargenpflicht in Konfiguration und Artikel gesetzt ist.
Then saving the current editor throws the exception "1490"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "tcharge" to "13SNR2" in row 2
And I save the current editor
And I switch the current editor to editor "VK-UML_13"
And I set field "ljtext1" to "VKUML_SNR13" in row 1
And I save the current editor

Given I open an editor "JournalUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK-UMLAGERSNR;buarta==Zugang;platz==KONSI2;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EK-UMLAGERSNR                     |
    | platz         | KONSI2                            |
    | lgruppe       | KONSI                             |
    | mge           | 1                                 |
    | buart         | 1                                 |
    | buarta        | Zugang                            |
    | ursache       | Lieferschein                      |
    | detursache    | Kommissionslieferschein Verkauf   |
## soll beide Felder zugehende Charge und abgehende Charge gefüllt sein?
Then field "tncharge" has value "13SNR1" in row 1
Then field "tvcharge" has value "13SNR1" in row 1
And I close the current editor

Given I open an editor "JournalUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK-UMLAGERSNR;buarta==Zugang;platz==KONSI2;@richtung=rückwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EK-UMLAGERSNR                     |
    | platz         | KONSI2                            |
    | lgruppe       | KONSI                             |
    | mge           | 1                                 |
    | buart         | 1                                 |
    | buarta        | Zugang                            |
    | ursache       | Lieferschein                      |
    | detursache    | Kommissionslieferschein Verkauf   |
## soll beide Felder zugehende Charge und abgehende Charge gefüllt sein?
Then field "tncharge" has value "13SNR2" in row 1
Then field "tvcharge" has value "13SNR2" in row 1
And I close the current editor

Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK-UMLAGERSNR;buarta==Abgang;platz==F1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EK-UMLAGERSNR                     |
    | platz         | F1                                |
    | lgruppe       | KARLSRUHE                         |
    | mge           | 1                                 |
    | buart         | 2                                 |
    | buarta        | Abgang                            |
    | ursache       | Lieferschein                      |
    | detursache    | Kommissionslieferschein Verkauf   |
## soll beide Felder zugehende Charge und abgehende Charge gefüllt sein?
Then field "tncharge" has value "13SNR1" in row 1
Then field "tvcharge" has value "13SNR1" in row 1
And I close the current editor

Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK-UMLAGERSNR;buarta==Abgang;platz==F1;@richtung=rückwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EK-UMLAGERSNR                     |
    | platz         | F1                                |
    | lgruppe       | KARLSRUHE                         |
    | mge           | 1                                 |
    | buart         | 2                                 |
    | buarta        | Abgang                            |
    | ursache       | Lieferschein                      |
    | detursache    | Kommissionslieferschein Verkauf   |
## soll beide Felder zugehende Charge und abgehende Charge gefüllt sein?
Then field "tncharge" has value "13SNR2" in row 1
Then field "tvcharge" has value "13SNR2" in row 1
And I close the current editor


Scenario: SNR14 Umlagerungsvorschlag direkt umbuchen geht nicht, bei Menge ungleich 1

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK-UMLAGERSNR |
    | buart     | Zugang        |
    | beleg     | LBUZU_SNR14   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | tcharge2  |
    | 1      | F1       | 14SNR1    |
And I save the current editor

Given I open an editor "EK-UMLAGERSNR" from table "(Part):(Product)" with command "UPDATE" for record "EK-UMLAGERSNR"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
    | lgruppe   | efrist    | mindest   | bsart     | dispoa            | zuplatz    | abplatz   | umllg        |
    | BERLIN    | 10        | 5         | Umlagern  | bedarfsbezogen    | L3F1       | L3F1      | KARLSRUHE    |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I run Scheduling

# Umlagerungsvorschlag direkt umbuchen nur mit Menge 1 und Angabe SNR moeglich, bereits zugebuchte SNR kann verwendet werden
Given I open an editor "UML_INT_EXT" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "EK-UMLAGERSNR"
And I set field "lgruppe" to ""
And I press button "ladetab"
Then the table has 1 rows
Then table has values
    | ablgruppe | lgruppe   | mge   | fix   |
    | KARLSRUHE | BERLIN    | 5     | nein  |
And I set field "mfreig" to "ja" in row 1
And I set field "beleg" to "UMLS14"
And I set field "beldat" to "."
# 2374 TX=de |Artikel mit Seriennummernverfolgung und Menge > 1 kann nicht direkt umgebucht werden.
Then pressing button "umbuchen" in row 0 to open a subeditor throws the exception "2374"
And I set field "mge" to "1" in row 1
# 1164 TX=de |Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then pressing button "umbuchen" in row 0 to open a subeditor throws the exception "1164"
And I set field "tcharge" to "neue_CH_statt_14SNR1_nach_SN_in_UMB" in row 1
And I press button "umbuchen" to open a subeditor for "direktumbuchen"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "JournalUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK-UMLAGERSNR;buarta==Zugang;platz==L3F1;such==LUMLS14"
Then fields have values
    | artikel       | EK-UMLAGERSNR         |
    | platz         | L3F1                  |
    | lgruppe       | BERLIN                |
    | mge           | 1                     |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | erfasst               |
    | detursache    | Umlagerungsvorschlag  |
Then field "tncharge" has value "neue_CH_statt_14SNR1_nach_SN_in_UMB" in row 1
Then field "tvcharge" has value "neue_CH_statt_14SNR1_nach_SN_in_UMB" in row 1
And I close the current editor

Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK-UMLAGERSNR;buarta==Abgang;platz==F1;such==LUMLS14"
Then fields have values
    | artikel       | EK-UMLAGERSNR         |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 1                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | erfasst               |
    | detursache    | Umlagerungsvorschlag  |
Then field "tncharge" has value "neue_CH_statt_14SNR1_nach_SN_in_UMB" in row 1
Then field "tvcharge" has value "neue_CH_statt_14SNR1_nach_SN_in_UMB" in row 1
And I close the current editor


# Rücklieferschein und Storno auch ohne Seriennummer möglich
# zubuchen und liefern ohne Seriennummer, dann Seriennummernverfolgung im Artikel einschalten, dann Bestand umbuchen auf SNR, dann Storno bzw. Rücklieferung
Scenario: SNR15 EK und VK - Ruecklieferschein oder Storno ist auch ohne Seriennummer moeglich

Given I create a PurchaseOrder "EKBE1" for Vendor "TEST" with Product "NOCHARGE2" and quantity "50"

And I deliver the PurchaseOrder "EKBE1" with PackingSlip "EKLS1"

Given I create a SalesOrder "AUF1" for Customer "TEST" with Product "NOCHARGE2" and quantity "30"

And I deliver the SalesOrder "AUF1" with PackingSlip "VKLS1"

# Seriennummernverfolgung im Artikel einschalten
Given I open an editor "NOCHARGE2" from table "(Part):(Product)" with command "UPDATE" for record "NOCHARGE2"
And I set field "chverfolgung" to "Seriennummernverfolgung"
And I set field "chimlager" to "ja"
And I save the current editor

# vorhandenen Bestand teilweise auf SNR umbuchen
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | NOCHARGE2 |
    | buart     | Umbuchung |
    | beleg     | UM_Charge |
    | beldat    | .         |
And I delete all rows
And I append rows
    | mge    | platz    | platz2    | tcharge2  |
    | 1      | F1       | F1        | 14141     |
    | 1      | F1       | F1        | 14142     |
    | 1      | F1       | F1        | 14143     |
    | 1      | F1       | F1        | 14144     |
    | 1      | F1       | F1        | 14145     |
And I save the current editor

Given I open an editor "VKRLS" from table "(Sales):(PackingSlip)" with command "RETURN" for record "VKLS1"
And I set fields
    | such      | RLS_SNR15 |
    | ueb       | ja        |
And I set field "mge" to "-2" in row 1
Then field "charge" is empty in row 1
And I set field "platz" to "F1" in row 1
And I save the current editor

Given I open an editor "STORNOVKRLS" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "VKRLS"
And I save the current editor

Given I open an editor "STORNOVKLS" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "VKLS1"
And I save the current editor

Given I open an editor "EKRLS" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "EKLS1"
And I set fields
    | such      | EKRLS_15      |
    | ueb       | ja            |
And I set field "mge" to "-10" in row 1
Then field "charge" is empty in row 1
And I set field "platz" to "F1" in row 1
And I save the current editor

Given I open an editor "STORNOEKRLS" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "EKRLS"
And I save the current editor

Given I open an editor "STORNOEKLS" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "EKLS1"
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==NOCHARGE2;buarta==Zugang;platz==F1;detursache==Rücklieferung Einkauf"
Then fields have values
    | artikel       | NOCHARGE2             |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | -10                   |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Rücklieferung Einkauf |
# Es gibt keine Chargenangabe und keine Tabellenzeilen
Then the table has 0 rows
And I close the current editor

Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==NOCHARGE2;buarta==Zugang;platz==F1;detursache==Storno-Lieferung Einkauf"
Then fields have values
    | artikel       | NOCHARGE2                 |
    | platz         | F1                        |
    | lgruppe       | KARLSRUHE                 |
    | mge           | -50                       |
    | buart         | 1                         |
    | buarta        | Zugang                    |
    | ursache       | Lieferschein              |
    | detursache    | Storno-Lieferung Einkauf  |
# Es gibt keine Chargenangabe und keine Tabellenzeilen
Then the table has 0 rows
And I close the current editor

Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==NOCHARGE2;buarta==Abgang;platz==F1;detursache==Rücklieferung Verkauf"
Then fields have values
    | artikel       | NOCHARGE2             |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | -2                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Rücklieferung Verkauf |
# Es gibt keine Chargenangabe und keine Tabellenzeilen
Then the table has 0 rows
And I close the current editor

Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==NOCHARGE2;buarta==Abgang;platz==F1;detursache==Storno-Lieferung Verkauf"
Then fields have values
    | artikel       | NOCHARGE2                 |
    | platz         | F1                        |
    | lgruppe       | KARLSRUHE                 |
    | mge           | -30                       |
    | buart         | 2                         |
    | buarta        | Abgang                    |
    | ursache       | Lieferschein              |
    | detursache    | Storno-Lieferung Verkauf  |
# Es gibt keine Chargenangabe und keine Tabellenzeilen
Then the table has 0 rows
And I close the current editor


Scenario: SNR16 Inventur fuer Artikel mit Seriennummernverfolgung, chimlager=ja

Given I post a receipt via ManualStockAdjustment "LBU16" for Product "INV_LAGERJA_SNR" and quantity "1" on StorageLocation "F2" with document "LBU16"

Given I open an editor "INV_LAGERJA_SNR" from table "(Part):(Product)" with command "UPDATE" for record "INV_LAGERJA_SNR"
And I set field "chverfolgung" to "Seriennummernverfolgung"
And I set field "chimlager" to "ja"
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | INV_LAGERJA_SNR   |
    | buart     | Zugang            |
    | beleg     | LBU_16            |
    | beldat    | .                 |
    | wert      | 10.0000           |
And I delete all rows
And I append rows
    | mge    | platz2   | tcharge2  | verw      |
    | 1      | F1       | 161601    | verw03    |
    | 1      | F1       | 161602    | verw04    |
    | 1      | F2       | 161603    | verw03    |
    | 1      | F2       | 161604    | verw04    |
And I save the current editor

# Zaehlliste anlegen fuer INV_LAGERJA_SNR
Given I open an editor "Zaehlliste_SNR" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "SNR16_SNR"
And I append rows
    | artikel           | platz |
    | INV_LAGERJA_SNR   | F1    |
    | INV_LAGERJA_SNR   | F2    |
And I save the current editor

# Zaehlliste pruefen
Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "SNR16_SNR"
Then table has values
    | artikel            | tcharge   | verw     | platz    | gebeinh |
    | INV_LAGERJA_SNR    |           |          | F2       | Stück   |
    | INV_LAGERJA_SNR    | 161603    | verw03   | F2       | Stück   |
    | INV_LAGERJA_SNR    | 161604    | verw04   | F2       | Stück   |
    | INV_LAGERJA_SNR    | 161601    | verw03   | F1       | Stück   |
    | INV_LAGERJA_SNR    | 161602    | verw04   | F1       | Stück   |
And I close the current editor

# Zaehlliste bearbeiten und Charge eintragen bei Zeile ohne Charge
Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "SNR16_SNR"
And I set field "tcharge" to "161605" in row 1
And I save the current editor

# Inventur eroeffnen
Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "SNR16_SNR" and menu choice "Ja"
And I save the current editor

# Zaehlmengen erfassen und Fehlermeldungen pruefen
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "SNR16_SNR"
Then table has values
    | artikel            | tcharge   | verw     | platz    | gebeinh | ibest    |
    | INV_LAGERJA_SNR    | 161605    |          | F2       | Stück   | 0        |
    | INV_LAGERJA_SNR    | 161603    | verw03   | F2       | Stück   | 1        |
    | INV_LAGERJA_SNR    | 161604    | verw04   | F2       | Stück   | 1        |
    | INV_LAGERJA_SNR    | 161601    | verw03   | F1       | Stück   | 1        |
    | INV_LAGERJA_SNR    | 161602    | verw04   | F1       | Stück   | 1        |
    | INV_LAGERJA_SNR    |           |          | F2       | Stück   | 1        |
# Für Artikel mit Seriennummernverfolgung mit Bestand sind nur folgende Korrekturen erlaubt: von -1 oder 1 auf 0 oder von 0 auf 1
Then setting field "nbest" to "2" in row 1 throws the exception "7040"
Then setting field "nbest" to "2" in row 2 throws the exception "7040"
And I modify table
    | !row | nbest |
    |  1   | 1     |
    |  2   | 0     |
    |  3   | 1     |
    |  4   | 0     |
    |  5   | 1     |
    |  6   | 1     |
# Charge erfassen in der vorhandenen Zeile geht nicht, da der vorhandene Bestand geladen ist
# wenn nbest = ibest, dann auch ohne Charge moeglich
# fuer Differenz eine neue Zeile erfassen, nur mit Menge 1 und SNR moeglich
And I create a new row at the end of the table
And I set field "artikel" to "INV_LAGERJA_SNR" in row !lastRow
And I set field "platz" to "F1" in row !lastRow
And I set field "gebeinh" to "Stück" in row !lastRow
And I set field "gebf" to "1" in row !lastRow
And I set field "nbest" to "2" in row !lastRow
Then saving the current editor throws the exception "7039"
And I set field "nbest" to "1" in row !lastRow
Then saving the current editor throws the exception "1164"
And I set field "tcharge" to "161606" in row !lastRow
And I save the current editor

# Bestandsabschluss
Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "SNR16_SNR" and menu choice "Ja"
And I save the current editor

# Inventurkorrekturbuchungen im Infosystem LJ pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "kursache" to "Inventur"
And I set field "artikel" to "INV_LAGERJA_SNR"
And I press start
Then table has values
    | kmge | mei    | verw     | tvcharge  | tncharge  | vplatz    |
    | 1    | Stück  |          |           | 161605    | F2        |
    | -1   | Stück  | verw03   | 161603    |           | F2        |
    |      | Stück  | verw04   | 161604    | 161604    | F2        |
    | -1   | Stück  | verw03   | 161601    |           | F1        |
    |      | Stück  | verw04   | 161602    | 161602    | F1        |
    |      | Stück  |          |           |           | F2        |
And I close the current editor

# Inventurabschluss
Given I open an editor "Invbearb" from table "(Stocktaking)" with command "TRANSFER" for record "SNR16_SNR" and menu choice "Ja"
And I save the current editor


Scenario: SNR17 Inventur fuer Artikel ohne Seriennummernverfolgung, vor Bestandsabschluss umstellen auf Seriennummernverfolgung

Given I post a receipt via ManualStockAdjustment "LBU17" for Product "INVNOCHARGE" and quantity "5" on StorageLocation "F1" with document "LBU17"
Given I post a receipt via ManualStockAdjustment "LBU17A" for Product "INVNOCHARGE" and quantity "3" on StorageLocation "F2" with document "LBU17A"

# Zaehlliste anlegen und Inventur eroeffnen
Given I open an editor "Zaehlliste_SNR" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "SNR17_SNR"
And I append rows
    | artikel       | platz |
    | INVNOCHARGE   | F1    |
    | INVNOCHARGE   | F2    |
And I save the current editor

Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "SNR17_SNR" and menu choice "Ja"
And I save the current editor

# Zaehlmengen erfassen
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "SNR17_SNR"
Then table has values
    | artikel       | tcharge   | verw  | platz    | gebeinh | ibest    |
    | INVNOCHARGE   |           |       | F2       | Stück   | 3        |
    | INVNOCHARGE   |           |       | F1       | Stück   | 5        |
And I modify table
    | !row | nbest |
    |  1   | 2     |
    |  2   | 6     |
And I save the current editor

# Chargenpflicht einschalten
Given I open an editor "INVNOCHARGE" from table "(Part):(Product)" with command "UPDATE" for record "INVNOCHARGE"
And I set field "chverfolgung" to "Seriennummernverfolgung"
And I set field "chimlager" to "nein"
And I save the current editor

# Bestandsabschluss nicht moeglich, da SNR fehlen, für die zusaetzliche Menge
Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "SNR17_SNR" and menu choice "Ja"
# 1463 TX=de |Chargen in Zeilen fehlen, Inventur muss erneut editiert werden. Bestandsabschluss nicht durchgeführt.
Then saving the current editor throws the exception "1463"
And I close the current editor

# Zaehlliste bearbeiten, nbest anpassen, kleiner oder gleich ibest ist moeglich ohne SNR und mit Menge > 1
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "SNR17_SNR"
And I modify table
    | !row | nbest |
    |  2   | 5     |
And I save the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "SNR17_SNR" and menu choice "Ja"
And I save the current editor

# Inventurkorrekturbuchungen im Infosystem LJ pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "kursache" to "Inventur"
And I set field "artikel" to "INVNOCHARGE"
And I press start
Then table has values
    | kmge | mei    | verw     | tvcharge  | tncharge  | vplatz    |
    | -1   | Stück  |          |           |           | F2        |
    |      | Stück  |          |           |           | F1        |
And I close the current editor

# Inventurabschluss
Given I open an editor "Invbearb" from table "(Stocktaking)" with command "TRANSFER" for record "SNR17_SNR" and menu choice "Ja"
And I save the current editor


Scenario: SNR18 Seriennummernpruefung bei Buchung von Setartikeln

Given I open an editor "SET-SNR" from table "(Part):(Product)" with command "UPDATE" for record "SET-SNR"
# 3596 Seriennummernverfolgung nicht erlaubt bei der Entnahmeart "über Stückliste"
Then setting field "chverfolgung" to "Seriennummernverfolgung" throws the exception "3596"
And I set field "chverfolgung" to "Chargenverfolgung"
And I save the current editor

Given I open an editor "VKAUFSNR18" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH1   |
    | such  | VK_SNR18   |
    | vom   | .          |
And I append rows
    | artikel   | mge | einplan |
    | SET-SNR   | 5   | ja      |
# Charge ist noch keine Pflichtangabe im VK-Auftrag
Then field "tcharge" is empty in row 1
And I save the current editor

Given I create a Lot "C21CHSET" for Product "SET-SNR"

Given I open an editor "VK_SNR18" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "VK_SNR18"
And I set fields
    | such   | LS_SNR18 |
    | vom    | .        |
    | ueb    | ja       |
And I set field "mge" to "3" in row 1
And I set field "charge" to "!C21CHSET^id" in row 1
And I set field "ueb" to "nein"
And I press button "mzabsm" to open a subeditor for "SetartikelMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   |
    | 1     | F1     | 3        |
And I delete row at position 2
And I delete row at position 2
# 7039 TX=de |Artikel mit Seriennummernverfolgung darf nur mit Menge und Faktor 1 in Lagereinheit gebucht werden. Vorgang oder MZ prüfen.
Then saving the current editor throws the exception "7039"
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    |  1    | F1     | 1        | C1SETKOMP1    |
# 3173 de      |Bei Seriennummernverfolgung muss die gesamte Menge über die Materialzuordnung zugeordnet werden.
Then saving the current editor throws the exception "3173"
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    |  1    | F1     | 1        | !dontChange   |
    |  +2   | F1     | 1        | C2SETKOMP1    |
    |  +3   | F1     | 1        | C3SETKOMP1    |
And I press button for next product
And I modify table
    | !row  | lpsuch | tcharge       |
    | 1     | F1     | C1SETKOMP2    |
    | 2     | F1     | C2SETKOMP2    |
    | 3     | F1     | C3SETKOMP2    |
    | 4     | F1     | C4SETKOMP2    |
    | 5     | F1     | C5SETKOMP2    |
    | 6     | F1     | C6SETKOMP2    |
And I save the current editor
And I switch the current editor to editor "VK_SNR18"
And I set field "ljtext1" to "VKLS_P21" in row 1
And I set field "ueb" to "ja"
And I save value from field "nummer" in row 0
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" in row 0 to saved value
And I press start
Then table has values
    | art               | zmge | amge     | tvcharge    | tncharge   |
    | SET_KOMP01_SNR    |      | 1        | C1SETKOMP1  | C21CHSET   |
    | SET_KOMP01_SNR    |      | 1        | C2SETKOMP1  | C21CHSET   |
    | SET_KOMP01_SNR    |      | 1        | C3SETKOMP1  | C21CHSET   |
    | SET_KOMP02_SNR    |      | 1        | C1SETKOMP2  | C21CHSET   |
    | SET_KOMP02_SNR    |      | 1        | C2SETKOMP2  | C21CHSET   |
    | SET_KOMP02_SNR    |      | 1        | C3SETKOMP2  | C21CHSET   |
    | SET_KOMP02_SNR    |      | 1        | C4SETKOMP2  | C21CHSET   |
    | SET_KOMP02_SNR    |      | 1        | C5SETKOMP2  | C21CHSET   |
    | SET_KOMP02_SNR    |      | 1        | C6SETKOMP2  | C21CHSET   |
    | SET-SNR           | 3    | 3        | C21CHSET    |            |
Then field "detursache" has value "Durchgang Setartikel" in row 10
And I close the current editor


Scenario: SNR19 Seriennummernpruefung bei Koppelprodukt, MZ fuer Koppelprodukt erfassen

Given I create a work order "SNR19" for Product "BG_SNR_KOPPEL" with quantity "3" and search word "SNR19_"
Given I create a work order "SNR19M" for Product "BG_SNR_KOPPEL" with quantity "2" and search word "SNR19M_"

Given I open an editor "BA_SNR19" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SNR19_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | tcharge   |
    | 1     | F1     | 1919_1    |
    | 2     | F1     | 1919_2    |
    | 3     | F1     | 1919_3    |
And I press button for next product
Then field "artikel" has value "KOPPEL_SNR"
And I modify table
    | !row  | lpsuch | tcharge   |
    | 1     | F1     | 19192_1   |
    | 2     | F1     | 19192_2   |
    | 3     | F1     | 19192_3   |
    | 4     | F1     | 19192_4   |
    | 5     | F1     | 19192_5   |
    | 6     | F1     | 19192_6   |
And I set field "zuomge" to "2" in row 1
And I set field "zuomge" to "0" in row 6
# 7039 TX=de |Artikel mit Seriennummernverfolgung darf nur mit Menge und Faktor 1 in Lagereinheit gebucht werden. Vorgang oder MZ prüfen.
Then saving the current editor throws the exception "7039"
And I set field "zuomge" to "1" in row 1
And I set field "zuomge" to "1" in row 6
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_SNR19"
And I save the current editor

# zweiten BA auf manbu setzen, ausserdem testen, dass fuer Koppelprodukt die SNR aus der MZ nicht noch mal verwendet werden kann
Given I open an editor "BA_SNR19M" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SNR19M_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I press button for next product
Then field "artikel" has value "KOPPEL_SNR"
Then table has values
    | !row  | zuomge   |
    | 1     | 1        |
    | 2     | 1        |
    | 3     | 1        |
    | 4     | 1        |
And I set field "tcharge" to "19192_1" in row 1
And I set field "tcharge" to "19192_2M" in row 2
And I set field "tcharge" to "19192_3M" in row 3
And I set field "tcharge" to "19192_4M" in row 4
# 7043 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde zugebucht.
Then saving the current editor throws the exception "7043"
And I set field "tcharge" to "19192_1M" in row 1
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_SNR19M"
And I save the current editor

# Rueckmeldung Gesamtmenge auf Arbeitsschein 1, Zugangsbuchung fuer Baugruppe und fuer Koppelprodukt, sowie Entnahme retrograd
Given I open an editor "RM1_SNR19" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR19_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | gut       | ja        |
    | bem       | RM_SNR19  |
And I set field "erbtext1" to "RM1_SNR19" in row 1
# 7039 TX=de |Artikel mit Seriennummernverfolgung darf nur mit Menge und Faktor 1 in Lagereinheit gebucht werden. Vorgang oder MZ prüfen.
Then saving the current editor throws the exception "7039"
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | tcharge   |
    |  1    | F1     | 1919_1ZU  |
    |  2    | F1     | 1919_2ZU  |
    |  3    | F1     | 1919_3ZU  |
And I save the current editor
And I switch the current editor to editor "RM1_SNR19"
And I save the current editor

# Buchungen im LJ pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_SNR19^barmex"
And I press start
Then table has values
    | art           | zmge | amge     | tvcharge  | tncharge    |
    | KOPPEL_SNR    | 1    |          |           | 19192_1     |
    | KOPPEL_SNR    | 1    |          |           | 19192_2     |
    | KOPPEL_SNR    | 1    |          |           | 19192_3     |
    | KOPPEL_SNR    | 1    |          |           | 19192_4     |
    | KOPPEL_SNR    | 1    |          |           | 19192_5     |
    | KOPPEL_SNR    | 1    |          |           | 19192_6     |
    | EK01_SNR      |      | 1        | 1919_1    | 1919_1ZU    |
    | EK01_SNR      |      | 1        | 1919_2    | 1919_2ZU    |
    | EK01_SNR      |      | 1        | 1919_3    | 1919_3ZU    |
    | BG_SNR_KOPPEL | 1    |          |           | 1919_1ZU    |
    | BG_SNR_KOPPEL | 1    |          |           | 1919_2ZU    |
    | BG_SNR_KOPPEL | 1    |          |           | 1919_3ZU    |
And I close the current editor

# Materialentnahme und Koppelprodukt zubuchen fuer BA SNR19M
Given I open an editor "FBU_SNR19M" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | SNR19M_001    |
    | bem           | Entnahme      |
    | gmgevorschl   | 1             |
And I press button "stlvblad"
Then table has values
    | elex          | bumge | manbu |
    | EK01_SNR      | 1     | ja    |
    | KOPPEL_SNR    | 2     | ja    |
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I set field "tcharge" to "19_1M" in row 1
And I delete row at position 2
And I save the current editor
And I switch the current editor to editor "FBU_SNR19M"
And I press button "mzsubm" to open a subeditor for "MZ" in row 2
And I set field "tcharge" to "19192_1" in row 1
And I delete row at position 4
And I delete row at position 3
Then saving the current editor throws the exception "7043"
And I set field "tcharge" to "19192_1M" in row 1
And I save the current editor
And I switch the current editor to editor "FBU_SNR19M"
And I save the current editor


Scenario: SNR20 Seriennummernpruefung Eindeutigkeit in Vorgaengen - Prozessablauf EK und VK

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK01_SNR      |
    | buart     | Zugang        |
    | beleg     | LBUZU_SNR01   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | tcharge2  |
    | 1      | F1       | SNR0Z     |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK01_SNR      |
    | buart     | Zugang        |
    | beleg     | LBUZU_SNR01   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   |
    | 1      | F1       |
# 7043 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde zugebucht.
And I set field "tcharge2" to "SNR0Z" in row 1
Then saving the current editor throws the exception "7043"
And I set field "tcharge2" to "SNR0A" in row 1
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK01_SNR      |
    | buart     | Abgang        |
    | beleg     | LBUAB_SNR01   |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | tcharge1  |
    | 1      | F1       | SNR0L     |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK01_SNR      |
    | buart     | Abgang        |
    | beleg     | LBUAB_SNR01   |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz
    | 1      | F1
# 7044 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde abgebucht.
And I set field "tcharge1" to "SNR0L" in row 1
Then saving the current editor throws the exception "7044"
And I set field "tcharge1" to "SNR0A" in row 1
And I save the current editor

# ungebuchter EK-LS mit SNR in der Position, SNR kann für keine weiteren Zugaenge verwendet werden
Given I open an editor "LS_UNGEB" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFCHA1         |
    | such   | LS_UNGEB         |
    | ebeleg | LS_UNGEB_SNR20   |
    | vom    | .                |
    | ueb    | nein             |
And I append rows
    | artikel   | mge | tcharge |
    | EK01_SNR  | 1   | SNR1ZU  |
And I save the current editor

Given I open an editor "SNR0Z" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR0Z;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "EKBESNR20" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | LIEFCHA1   |
    | such | BE_SNR20   |
    | vom  | .          |
And I append rows
    | artikel   | mge | einplan |
    | EK01_SNR  | 2   | ja      |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | zuomge   |
    | 1     | F1     | 1        |
    | 2     | F1     | 1        |
And I set field "charge" to "!SNR0Z^id" in row 1
And I set field "tcharge" to "SNR2" in row 2
# 7043 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde zugebucht.
Then saving the current editor throws the exception "7043"
And I set field "tcharge" to "SNR1" in row 1
And I save the current editor
And I switch the current editor to editor "EKBESNR20"
And I save the current editor

# Lieferschein ungebucht, um die SNR zu allokieren
Given I open an editor "EKBESNR20" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE_SNR20"
And I set fields
    | such   | LS1_SNR20    |
    | ebeleg | LS1_SNR20    |
    | vom    | .            |
    | ueb    | nein         |
And I set field "mge" to "1" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete row at position 2
And I modify table
    | !row  | lpsuch | zuomge   |
    | 1     | F1     | 1        |
And I set field "charge" to "!SNR0Z^id" in row 1
# 7043 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde zugebucht.
Then saving the current editor throws the exception "7043"
And I set field "tcharge" to "SNR1ZU" in row 1
Then saving the current editor throws the exception "7043"
And I set field "tcharge" to "SNR1" in row 1
And I save the current editor
And I switch the current editor to editor "EKBESNR20"
And I save the current editor

Given I open an editor "EKBESNR20" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE_SNR20"
And I set fields
    | such   | RE1_SNR20    |
    | ebeleg | RE1_SNR20    |
    | vom    | .            |
    | tterm  | .            |
    | ueb    | ja           |
    | fakt   | ja           |
And I set field "mge" to "1" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | zuomge   |
    | 1     | F1     | 1        |
And I set field "tcharge" to "SNR1" in row 1
# 7043 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde zugebucht.
Then saving the current editor throws the exception "7043"
And I set field "tcharge" to "SNR2" in row 1
And I save the current editor
And I switch the current editor to editor "EKBESNR20"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "LS1_SNR20" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "LS1_SNR20"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "VKAUSNR20" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH1   |
    | such  | VKAUSNR20  |
    | vom   | .          |
And I append rows
    | artikel   | mge | einplan |
    | EK01_SNR  | 2   | ja      |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | zuomge   |
    | 1     | F1     | 1        |
    | 2     | F1     | 1        |
And I set field "tcharge" to "SNR0A" in row 1
And I set field "tcharge" to "SNR2" in row 2
# 7044 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde abgebucht.
Then saving the current editor throws the exception "7044"
And I set field "tcharge" to "SNR1" in row 1
And I save the current editor
And I switch the current editor to editor "VKAUSNR20"
And I save the current editor

Given I open an editor "VKAUSNR20" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "VKAUSNR20"
And I set fields
    | such   | VKLSSNR20    |
    | vom    | .            |
    | ueb    | nein         |
And I set field "mge" to "1" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete row at position 2
And I set field "tcharge" to "SNR0A" in row 1
# 7044 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde abgebucht.
Then saving the current editor throws the exception "7044"
And I set field "tcharge" to "SNR1" in row 1
And I save the current editor
And I switch the current editor to editor "VKAUSNR20"
And I save the current editor

Given I open an editor "VKAUSNR20" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "VKAUSNR20"
And I set fields
    | such   | VKRESNR20    |
    | vom    | .            |
    | tterm  | .            |
    | ueb    | ja           |
    | fakt   | ja           |
And I set field "mge" to "1" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "tcharge" to "SNR1" in row 1
# 7044 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde abgebucht.
Then saving the current editor throws the exception "7044"
And I set field "tcharge" to "SNR2" in row 1
And I save the current editor
And I switch the current editor to editor "VKAUSNR20"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "VKLSSNR20" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "VKLSSNR20"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "EKRLS" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "LS1_SNR20"
And I set fields
    | such      | RLS_SNR20 |
    | ebeleg    | RLS_SNR20 |
    | ueb       | ja        |
And I set field "mge" to "-1" in row 1
And I save the current editor

# neuer EK-LS mit SNR1, die wieder verfuegbar ist, da rueckgeliefert wurde
Given I open an editor "LS2_SNR20" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFCHA1     |
    | such   | LS2_SNR20    |
    | ebeleg | LS2_SNR20    |
    | vom    | .            |
    | ueb    | nein         |
And I append rows
    | artikel   | mge |
    | EK01_SNR  | 1   |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | 1     | F1     | 1        | SNR1      |
And I save the current editor
And I switch the current editor to editor "LS2_SNR20"
And I save the current editor

## vom Prozess her sollte die VK-Ruecklieferung VOR der EK-Ruecklieferung stattfinden, aber buchen ist vermutlich auch in "falscher" Reihenfolge moeglich
Given I open an editor "VKLSSNR20" from table "(Sales):(PackingSlip)" with command "RETURN" for record "VKLSSNR20"
And I set fields
    | such      | VKRLSNR20 |
    | ueb       | ja        |
Then table has values
    | artikel   | tcharge   |
    | EK01_SNR  |           |
And I set field "mge" to "-1" in row 1
# kann ohne Angabe SNR gebucht wird, wird aus Originallieferschein geholt
And I set field "platz" to "F1" in row 1
And I set field "ljtext1" to "VKRLS_SNR20" in row 1
And I save the current editor

# neuer VK-LS mit SNR1, die wieder verfuegbar ist, da rueckgeliefert wurde
Given I open an editor "VLS2SNR20" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde  | KUNDECH1     |
    | such   | VLS2SNR20    |
    | vom    | .            |
    | ueb    | ja           |
And I append rows
    | artikel   | mge |
    | EK01_SNR  | 1   |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | 1     | F1     | 1        | SNR1      |
And I save the current editor
And I switch the current editor to editor "VLS2SNR20"
And I save the current editor


Scenario: SNR21 Seriennummernpruefung Eindeutigkeit in Vorgaengen - Prozessablauf EK-Zugang und Fertigung

Given I open an editor "EKBESNR21" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | LIEFCHA1   |
    | such | BE_SNR21   |
    | vom  | .          |
And I append rows
    | artikel   | mge | einplan |
    | EK01_SNR  | 2   | ja      |
    | EK02_SNR  | 2   | ja      |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | 1     | F1     | 1        | SNR3_1    |
    | 2     | F1     | 1        | SNR4_1    |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | 1     | F1     | 1        | SNR3_2    |
    | 2     | F1     | 1        | SNR4_2    |
And I save the current editor
And I switch the current editor to editor "EKBESNR21"
And I save the current editor

And I deliver the PurchaseOrder "EKBESNR21" with PackingSlip "LS_SNR21"

# LBU, damit die SNR verbraucht ist
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | BG01_SNR      |
    | buart     | Zugang        |
    | beleg     | LBU_SNRZU01   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | tcharge2  |
    | 1      | F1       | SNRZU01   |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK01_SNR      |
    | buart     | Abgang        |
    | beleg     | LBU_SNRAB01   |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | tcharge1  |
    | 1      | F1       | SNRAB01   |
And I save the current editor

Given I create a work order "SNR21" for Product "BG01_SNR" with quantity "2" and search word "SNR21_"
Given I create a work order "SNR21M" for Product "BG01_SNR" with quantity "2" and search word "SNR21M_"
Given I create a work order "SNR21Z" for Product "BG01_SNR" with quantity "2" and search word "SNR21Z_"

Given I open an editor "BA_SNR21M" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SNR21M_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I save the current editor
And I switch the current editor to editor "BA_SNR21M"
And I save the current editor

Given I open an editor "SNRZU01" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNRZU01;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

# SNR in ZugangsMZ eintragen, damit diese verbraucht sind
Given I open an editor "BA_SNR21Z" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SNR21Z_000"
And I press button "mzsubm" to open a subeditor for "ZugangsMZ"
Then table has values
    | !row  | zuomge   | tcharge    |
    | 1     | 1        |            |
    | 2     | 1        |            |
And I set field "charge" to "!SNRZU01^id" in row 1
And I set field "tcharge" to "SNRZU_MZ2" in row 2
# 7043 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde zugebucht.
Then saving the current editor throws the exception "7043"
And I set field "tcharge" to "SNRZU_MZ1" in row 1
And I save the current editor
And I switch the current editor to editor "BA_SNR21Z"
And I save the current editor

Given I open an editor "BA_SNR21" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SNR21_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   |
    | 1     | F1     | 1        |
    | 2     | F1     | 1        |
And I set field "tcharge" to "SNRAB01" in row 1
And I set field "tcharge" to "SNR4_1" in row 2
# 7044 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde abgebucht.
Then saving the current editor throws the exception "7044"
And I set field "tcharge" to "SNR3_1" in row 1
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | 1     | F1     | 1        | SNR3_2    |
    | 2     | F1     | 1        | SNR4_2    |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_SNR21"
And I save the current editor

# Rueckmeldung Teilmenge auf Arbeitsschein 2, nicht buchen, ausserdem keine MZ vorhanden
Given I open an editor "RM1_SNR21M" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR21M_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | nein      |
    | bem       | RM_SNR21M |
And I set field "gutmge" to "1" in row 1
And I set field "erbtext1" to "RM1_SNR21M" in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | tcharge      |
    |  1    | F1     | SNR21_ZU1    |
And I save the current editor
And I switch the current editor to editor "RM1_SNR21M"
And I save the current editor

# Rueckmeldung Teilmenge auf Arbeitsschein 2 des anderen BA, SNR aus ungebuchter RM darf nicht verwendet werden
Given I open an editor "RM1_SNR21" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR21_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | bem       | RM_SNR21  |
And I set field "gutmge" to "1" in row 1
And I set field "erbtext1" to "RM1_SNR21" in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch |
    |  1    | F1     |
And I set field "tcharge" to "SNR21_ZU1" in row 1
# 7043 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde zugebucht.
Then saving the current editor throws the exception "7043"
And I set field "tcharge" to "SNRZU_MZ1" in row 1
Then saving the current editor throws the exception "7043"
And I set field "tcharge" to "SNR34_ZU1" in row 1
And I save the current editor
And I switch the current editor to editor "RM1_SNR21"
And I save the current editor

# ungebuchte Rueckmeldung buchen, manbu, deshalb keine Entnahmebuchung
Given I open an editor "RM1_SNR21M_BU" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record from editor "RM1_SNR21M"
And I set field "sofort" to "ja"
And I save the current editor

# Materialentnahme
Given I open an editor "FBU_R01" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | SNR21M_002    |
    | bem       | Entnahme      |
And I press button "stlvblad"
Then table has values
    | elex      | bumge | manbu |
    | EK02_SNR  | 2     | ja    |
And I set field "bumge" to "1" in row 1
# 7044 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde abgebucht.
Then setting field "tvcharge" to "SNR4_2" in row 1 throws the exception "7044"
And I set field "tvcharge" to "SNR_AB2" in row 1
And I set field "ljtext1" to "FBU_R01" in row 1
And I save the current editor

# weitere Teilmenge buchen, EntnahmeMZ vorhanden
Given I open an editor "RM2_SNR21" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR21_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | bem       | RM_SNR21  |
And I set field "gutmge" to "1" in row 1
And I set field "erbtext1" to "RM2_SNR21" in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | tcharge      |
    |  1    | F1     | SNR34_ZU1    |
# 7043 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde zugebucht.
Then saving the current editor throws the exception "7043"
And I set field "tcharge" to "SNR34_ZU2" in row 1
And I save the current editor
And I switch the current editor to editor "RM2_SNR21"
And I save the current editor

# LBU stornieren, damit SNRZU01 verwendet werden kann
Given I open an editor "LBuchungStorno" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "REVERSAL" for search criteria "$,,beleg=LBU_SNRZU01;@ablageart=abgelegt"
And I set fields
    | beleg     | LBU_Storno1   |
    | ljtext1   | Storno21      |
    | such      | STORNO_21     |
And I save the current editor

Given I open an editor "RM2_SNR21M" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR21M_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | manrest   | ja            |
    | bem       | RM2_SNR21M    |
And I set field "gutmge" to "1" in row 1
And I set field "erbtext1" to "RM2_SNR21M" in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | tcharge  |
    |  1    | F1     | SNRZU1   |
And I save the current editor
And I switch the current editor to editor "RM2_SNR21M"
And I save the current editor

# Rueckmeldung auf BA mit ZugangsMZ, Komplettmenge
Given I open an editor "RM1_SNR21Z" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR21Z_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | gut       | ja            |
    | bem       | RM1_SNR21Z    |
And I set field "erbtext1" to "RM1_SNR21Z" in row 1
And I save the current editor

# Rueckbau auf abgelegten
Given I open an editor "Rueckbau_AS2" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=SNR21Z_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | tkcharge  | SNRZU_MZ1 |
And I set field "gutmge" to "-1" in row 1
And I save the current editor

# erneute Rueckmeldung auf Arbeitsschein 2, SNRZU_MZ1 wieder verwenden
Given I open an editor "RM2_SNR21Z" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR21Z_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | gut       | ja            |
    | tkcharge  | SNRZU_MZ1     |
    | bem       | RM2_SNR21Z    |
And I set field "erbtext1" to "RM2_SNR21Z" in row 1
And I save the current editor

# Materialentnahme auf Arbeitsschein 1 (keine MZ vorhanden) und ausserdem zusaetzliche Entnahme
Given I open an editor "FBU2_R01" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | SNR21M_001    |
    | bem       | EntnahmeAS1   |
And I press button "stlvblad"
Then table has values
    | elex      | bumge | manbu |
    | EK01_SNR  | 2     | ja    |
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | 1     | F1     | 1        | SNR_AB1   |
    | 2     | F1     | 1        | SNR_AB3   |
And I save the current editor
And I switch the current editor to editor "FBU2_R01"
And I create a new row at the end of the table
And I set field "elex" to "EK02_SNR" in row !lastRow
And I set field "bumge" to "1" in row !lastRow
# 7044 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde abgebucht.
Then setting field "tvcharge" to "SNR_AB2" in row !lastRow throws the exception "7044"
And I set field "tvcharge" to "SNR_AB4" in row !lastRow
And I save the current editor


Scenario: SNR22 Seriennummer in BDE-Objekten - Auftragszeit und Kurzläufer

Given I create a Lot "SNR22_BDE1" for Product "BG01_SNR"
Given I create a Lot "SNR22_BDE2" for Product "BG01_SNR"
Given I create a Lot "SNR22_BDE3" for Product "BG01_SNR"
Given I create a Lot "SNR22_BDE4" for Product "BG01_SNR"
Given I create a Lot "SNR22_BDE5" for Product "BG01_SNR"

Given I open an editor "MA" from table "(Employee):(Employee)" with command "UPDATE" for record "KARL"
And I set field "lohn" to "1"
And I save the current editor

# Fertigungsvorschlag anlegen, ohne MZ
Given I open an editor "FV_SNR22" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel   | netmge    | mfreig    | bisuch    |
    | BG01_SNR  | 10        | ja        | SNR22_    |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Arbeitsschein oeffnen, um Zugriff auf Nummer zu haben
Given I open an editor "AS2" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=SNR22_002;@richtung=rückwärts;@maxordtreffer=1"
And I close the current editor

# Auftragszeit mit SNR-Angabe buchen, Menge > 1 wird abgelehnt beim Speichern
Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
And I set fields
    | ma        | KARL              |
    | asma      | !AS2^nummer       |
    | anfdat    | .                 |
    | anfzeit   | 08:00             |
    | enddat    | .                 |
    | endzeit   | 08:45             |
    | istmge    | 3                 |
    | charge    | !SNR22_BDE1^id    |
    | sofort    | ja                |
# Bei Seriennummernverfolgung und einer Menge > 1 muss die Erfassung über die Materialzuordnung erfolgen.
#Then saving the current editor throws the exception "1161"
# kann nicht abgefragt werden (ACK statt NKA) wird gespeichert aber nicht übertragen
And I save the current editor

# ungebuchte Auftragszeit bearbeiten und buchen
Given I open an editor "AuftragszeitUng" via ID from editor "Auftragszeit" from field "id" in row 0 for table "(PDC):(OrderTime)" with command "UPDATE"
And I set field "istmge" to "1"
And I save the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum        | .                     |
    | artikel       | BG01_SNR              |
    | kdetursache   | Rückmeldung Fertigung |
    | beleg         | !AS2^nummer           |
And I press start
Then table has values
    | art       | zmge | ncharge^id     |
    | BG01_SNR  | 1    | !SNR22_BDE1^id |
And I close the current editor

# Kurzlaeufer, Menge > 1 wird abgelehnt beim Speichern
Given I open an editor "Kurz1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
And I set fields
    | ma        | KARL              |
    | asma      | !AS2^nummer       |
    | anfdat    | .                 |
    | anfzeit   | 9:00              |
    | istzeit   | 1                 |
    | istmge    | 2                 |
    | charge    | !SNR22_BDE2^id    |
    | sofort    | ja                |
# Bei Seriennummernverfolgung und einer Menge > 1 muss die Erfassung über die Materialzuordnung erfolgen.
#Then saving the current editor throws the exception "1161"
# kann nicht abgefragt werden (ACK statt NKA) wird gespeichert aber nicht übertragen
And I save the current editor

# ungebuchten Kurzlaeufer bearbeiten und buchen
Given I open an editor "KurzUng" via ID from editor "Kurz1" from field "id" in row 0 for table "(PDC):(ShortProductionOrder)" with command "UPDATE"
And I set field "istmge" to "1"
And I save the current editor

# Auftragszeit ohne SNR-Angabe wird abgelehnt
Given I open an editor "Auftragszeit2" from table "(PDC):(OrderTime)" with command "NEW" for record ""
And I set fields
    | ma        | KARL              |
    | asma      | !AS2^nummer       |
    | anfdat    | .                 |
    | anfzeit   | 10:00             |
    | enddat    | .                 |
    | endzeit   | 10:45             |
    | istmge    | 1                 |
    | sofort    | ja                |
# Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist, MZ am FV vorhanden
# RM kann aber nicht gebucht werden
#Then saving the current editor throws the exception "1164"
# kann nicht abgefragt werden (ACK statt NKA) wird gespeichert aber nicht übertragen
And I save the current editor

# ungebuchte Auftragszeit bearbeiten, wird auch nicht gebucht, da SNR schon verwendet wurde
Given I open an editor "AuftragszeitUng2" via ID from editor "Auftragszeit2" from field "id" in row 0 for table "(PDC):(OrderTime)" with command "UPDATE"
And I set field "charge" to "!SNR22_BDE1^id"
# 7043 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde zugebucht.
#Then saving the current editor throws the exception "7043"
# kann nicht abgefragt werden (ACK statt NKA) wird gespeichert aber nicht übertragen
And I save the current editor

# ungebuchte Auftragszeit bearbeiten und buchen
Given I open an editor "AuftragszeitUng2" via ID from editor "Auftragszeit2" from field "id" in row 0 for table "(PDC):(OrderTime)" with command "UPDATE"
And I set field "charge" to "!SNR22_BDE3^id"
And I save the current editor

Given I open an editor "Kurz2" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
And I set fields
    | ma        | KARL              |
    | asma      | !AS2^nummer       |
    | anfdat    | .                 |
    | anfzeit   | 11:00             |
    | istzeit   | 1                 |
    | istmge    | 1                 |
    | sofort    | ja                |
# Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist
#Then saving the current editor throws the exception "1164"
# kann nicht abgefragt werden (ACK statt NKA) wird gespeichert aber nicht übertragen
And I save the current editor

# ungebuchte Auftragszeit bearbeiten, wird auch nicht gebucht, da SNR schon verwendet wurde
Given I open an editor "Kurz2Ung" via ID from editor "Kurz2" from field "id" in row 0 for table "(PDC):(ShortProductionOrder)" with command "UPDATE"
And I set field "charge" to "!SNR22_BDE2^id"
# 7043 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde zugebucht.
#Then saving the current editor throws the exception "7043"
# kann nicht abgefragt werden (ACK statt NKA) wird gespeichert aber nicht übertragen
And I save the current editor

# ungebuchte Auftragszeit bearbeiten und buchen
Given I open an editor "Kurz2Ung" via ID from editor "Kurz2" from field "id" in row 0 for table "(PDC):(ShortProductionOrder)" with command "UPDATE"
And I set field "charge" to "!SNR22_BDE4^id"
And I save the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum        | .                     |
    | artikel       | BG01_SNR              |
    | kdetursache   | Rückmeldung Fertigung |
    | beleg         | !AS2^nummer           |
And I press start
Then table has values
    | art       | zmge | ncharge^id     |
    | BG01_SNR  | 1    | !SNR22_BDE1^id |
    | BG01_SNR  | 1    | !SNR22_BDE2^id |
    | BG01_SNR  | 1    | !SNR22_BDE3^id |
    | BG01_SNR  | 1    | !SNR22_BDE4^id |
And I close the current editor

# Auftragszeit anlegen, noch nicht uebertragen, keine Prüfung auf Verwendung der SNR
Given I open an editor "AuftragszeitOffen1" from table "(PDC):(OrderTime)" with command "NEW" for record ""
And I set fields
    | ma        | KARL              |
    | asma      | !AS2^nummer       |
    | anfdat    | .                 |
    | anfzeit   | 13:00             |
    | enddat    | .                 |
    | endzeit   | 13:45             |
    | istmge    | 1                 |
    | charge    | !SNR22_BDE1^id    |
    | sofort    | nein              |
And I save the current editor

# Auftragszeit anlegen, noch nicht uebertragen, keine Prüfung auf Verwendung der SNR
Given I open an editor "AuftragszeitOffen2" from table "(PDC):(OrderTime)" with command "NEW" for record ""
And I set fields
    | ma        | KARL              |
    | asma      | !AS2^nummer       |
    | anfdat    | .                 |
    | anfzeit   | 14:00             |
    | enddat    | .                 |
    | endzeit   | 14:45             |
    | istmge    | 1                 |
    | charge    | !SNR22_BDE5^id    |
    | sofort    | nein              |
And I save the current editor

# Kurzlaeufer anlegen, noch nicht uebertragen, keine Prüfung auf Verwendung der SNR
Given I open an editor "KurzOffen" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
And I set fields
    | ma        | KARL              |
    | asma      | !AS2^nummer       |
    | anfdat    | .                 |
    | anfzeit   | 15:00             |
    | istzeit   | 1                 |
    | istmge    | 1                 |
    | charge    | !SNR22_BDE5^id    |
    | sofort    | nein              |
And I save the current editor


Scenario: SNR23 Seriennummer in BDE-Objekten - Auftragszeit und Kurzläufer, BA mit ZugangsMZ

Given I create a Lot "SNR23_BDE1" for Product "BG01_SNR"
Given I create a Lot "SNR23_BDE2" for Product "BG01_SNR"
Given I create a Lot "SNR23_BDE3" for Product "BG01_SNR"
Given I create a Lot "SNR23_BDE4" for Product "BG01_SNR"
Given I create a Lot "SNR23_BDE5" for Product "BG01_SNR"

Given I open an editor "MA" from table "(Employee):(Employee)" with command "UPDATE" for record "KARL"
And I set field "lohn" to "1"
And I save the current editor

# Fertigungsvorschlag anlegen, mit ZugangsMZ und EntnahmeMZ
Given I open an editor "FV_SNR23" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel   | netmge    | mfreig    |
    | BG01_SNR  | 5         | ja        |
And I press button "mzsubm" to open a subeditor for "ZugangsMZ" in row 1
And I modify table
    | !row  | lpsuch | tcharge       |
    | 1     | F1     | SNR23_BDE1    |
    | 2     | F1     | SNR23_BDE2    |
    | 3     | F1     | SNR23_BDE3    |
    | 4     | F1     | SNR23_BDE4    |
    | 5     | F1     | SNR23_BDE5    |
And I save the current editor
And I switch the current editor to editor "FV_SNR23"
And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | 1     | F1     | 1        | SNR23_AB1.1   |
    | 2     | F1     | 1        | SNR23_AB1.2   |
    | 3     | F1     | 1        | SNR23_AB1.3   |
    | 4     | F1     | 1        | SNR23_AB1.4   |
    | 5     | F1     | 1        | SNR23_AB1.5   |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | 1     | F1     | 1        | SNR23_AB2.1   |
    | 2     | F1     | 1        | SNR23_AB2.2   |
    | 3     | F1     | 1        | SNR23_AB2.3   |
    | 4     | F1     | 1        | SNR23_AB2.4   |
    | 5     | F1     | 1        | SNR23_AB2.5   |
And I save the current editor
And I switch the current editor to editor "FV_SNR23"
And I set field "bisuch" to "SNR23_" in row 1
And I set field "binoloe" to "ja" in row 1
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Arbeitsschein oeffnen, um Zugriff auf Nummer zu haben
Given I open an editor "AS2" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=SNR23_002;@richtung=rückwärts;@maxordtreffer=1"
And I close the current editor

# Auftragszeit mit Menge > 1 ist moeglich, SNR-Angabe nicht erforderlich, da ZugangsMZ vorhanden
Given I open an editor "SNR23AZ1" from table "(PDC):(OrderTime)" with command "NEW" for record ""
And I set fields
    | ma        | KARL              |
    | asma      | !AS2^nummer       |
    | anfdat    | .                 |
    | anfzeit   | 10:00             |
    | enddat    | .                 |
    | endzeit   | 10:30             |
    | istmge    | 2                 |
    | sofort    | ja                |
And I save the current editor

# Rückmeldung prüfen
Given I open an editor "SNR23RM1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,0:such=SNR23_002;1:gutmge==2;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
And I close the current editor

# Auftragszeit mit Menge == 1 ist moeglich, SNR-Angabe nicht erforderlich, da ZugangsMZ vorhanden
Given I open an editor "SNR23AZ2" from table "(PDC):(OrderTime)" with command "NEW" for record ""
And I set fields
    | ma        | KARL              |
    | asma      | !AS2^nummer       |
    | anfdat    | .                 |
    | anfzeit   | 10:30             |
    | enddat    | .                 |
    | endzeit   | 10:45             |
    | istmge    | 1                 |
    | sofort    | ja                |
And I save the current editor

# Rückmeldung prüfen
Given I open an editor "SNR23RM2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,0:such=SNR23_002;1:gutmge==1;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
And I close the current editor

# Kurzlaeufer mit Menge > 1 ist moeglich, SNR-Angabe nicht erforderlich, da ZugangsMZ vorhanden
Given I open an editor "Kurz1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
And I set fields
    | ma        | KARL              |
    | asma      | !AS2^nummer       |
    | anfdat    | .                 |
    | anfzeit   | 9:00              |
    | istzeit   | 1                 |
    | istmge    | 2                 |
    | sofort    | ja                |
And I save the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum        | .                     |
    | artikel       | BG01_SNR              |
    | kdetursache   | Rückmeldung Fertigung |
    | beleg         | !AS2^nummer           |
And I press start
Then table has values
    | art       | zmge | ncharge^id     |
    | BG01_SNR  | 1    | !SNR23_BDE1^id |
    | BG01_SNR  | 1    | !SNR23_BDE2^id |
    | BG01_SNR  | 1    | !SNR23_BDE3^id |
    | BG01_SNR  | 1    | !SNR23_BDE4^id |
    | BG01_SNR  | 1    | !SNR23_BDE5^id |
And I set field "artikel" to "EK01_SNR"
And I press start
Then table has values
    | art       | amge | ncharge^id     | tvcharge      |
    | EK01_SNR  | 1    | !SNR23_BDE1^id | SNR23_AB1.1   |
    | EK01_SNR  | 1    | !SNR23_BDE2^id | SNR23_AB1.2   |
    | EK01_SNR  | 1    | !SNR23_BDE3^id | SNR23_AB1.3   |
    | EK01_SNR  | 1    | !SNR23_BDE4^id | SNR23_AB1.4   |
    | EK01_SNR  | 1    | !SNR23_BDE5^id | SNR23_AB1.5   |
And I set field "artikel" to "EK02_SNR"
And I press start
Then table has values
    | art       | amge | ncharge^id     | tvcharge      |
    | EK02_SNR  | 1    | !SNR23_BDE1^id | SNR23_AB2.1   |
    | EK02_SNR  | 1    | !SNR23_BDE2^id | SNR23_AB2.2   |
    | EK02_SNR  | 1    | !SNR23_BDE3^id | SNR23_AB2.3   |
    | EK02_SNR  | 1    | !SNR23_BDE4^id | SNR23_AB2.4   |
    | EK02_SNR  | 1    | !SNR23_BDE5^id | SNR23_AB2.5   |
And I close the current editor


Scenario: SNR24 EK mit Beistellung - Seriennummernpruefung in der BeistellMZ

Given I create a Lot "ZU1SNR24" for Product "KT-BEISTELL_SNR"
Given I create a Lot "AB1SNR24" for Product "EKBEI_SNR"
Given I create a Lot "ZUSNR24NEU" for Product "KT-BEISTELL_SNR"
Given I create a Lot "ABSNR24NEU" for Product "EKBEI_SNR"

Given I open an editor "BE-SNR24" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFCHA2 |
    | such   | BE-SNR24 |
    | ebeleg | BE-SNR24 |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel           | mge |
    | KT-BEISTELL_SNR   |  2  |
And I press button "mzabsm" to open a subeditor for "BeistellMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   |
    | 1     | F1     | 2        |
And I delete row at position 2
# 7039 TX=de |Artikel mit Seriennummernverfolgung darf nur mit Menge und Faktor 1 in Lagereinheit gebucht werden. Vorgang oder MZ prüfen.
Then saving the current editor throws the exception "7039"
And I modify table
    | !row  | zuomge   | charge        | zcharge       |
    | 1     | 1        | !AB1SNR24^id  | !ZU1SNR24^id  |
    | +2    | 1        |               |               |
And I save the current subeditor to switch back to the parent editor
And I set field "mge" to "1" in row 1
And I save the current editor

# Lieferschein aus Bestellung, Zugangs-SNR eintragen, für Beistellteil wird aus der MZ genommen; noch nicht buchen
Given I open an editor "LS1-SNR24" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE-SNR24"
And I set fields
   | ebeleg | LS1-SNR24 |
   | such   | LS1-SNR24 |
   | ueb    | nein      |
   | vom    | .         |
And I set field "mge" to "1" in row 1
And I set field "charge" to "!ZU1SNR24^id" in row 1
And I save the current editor

Given I create a PurchaseOrder "BE2-SNR24" for Vendor "LIEFCHA2" with Product "KT-BEISTELL_SNR" and quantity "1"

# Lieferschein aus der anderen Bestellung, SNR aus ungebuchtem Lieferschein darf NICHT verwendet werden, auch nicht SNR fuer Beistellteil aus MZ
Given I open an editor "LS2-SNR24" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE2-SNR24"
And I set fields
   | ebeleg | LS2-SNR24 |
   | such   | LS2-SNR24 |
   | ueb    | nein      |
   | vom    | .         |
And I set field "mge" to "1" in row 1
And I set field "charge" to "!ZU1SNR24^id" in row 1
# 7043 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde zugebucht.
Then saving the current editor throws the exception "7043"
And I set field "charge" to "!ZUSNR24NEU^id" in row 1
And I press button "mzabsm" to open a subeditor for "BeistellMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   |
    | 1     | F1     | 1        |
And I set field "charge" to "!AB1SNR24^id" in row 1
Then saving the current editor throws the exception "7044"
And I set field "charge" to "!ABSNR24NEU^id" in row 1
And I save the current editor
And I switch the current editor to editor "LS2-SNR24"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "LS1-SNR24" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "LS1-SNR24"
And I set field "ueb" to "ja"
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!LS1-SNR24^num"
And I press start
Then table has values
    | art               | zmge | amge     | vcharge^id     | vplatz    | ncharge^id    | nplatz    |
    | EKBEI_SNR         |      | 1        | !AB1SNR24^id   | F1        | !ZU1SNR24^id  |           |
    | KT-BEISTELL_SNR   | 1    |          | (0,0,0)        |           | !ZU1SNR24^id  | F1        |
And I close the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!LS2-SNR24^num"
And I press start
Then table has values
    | art               | zmge | amge     | vcharge^id      | vplatz    | ncharge^id        | nplatz    |
    | EKBEI_SNR         |      | 1        | !ABSNR24NEU^id  | F1        | !ZUSNR24NEU^id    |           |
    | KT-BEISTELL_SNR   | 1    |          | (0,0,0)         |           | !ZUSNR24NEU^id    | F1        |
And I close the current editor


Scenario: SNR25 EK mit Beistellung - Zugangscharge aus der AFL-Zeile des Beistellteils wird in die MZ uebernommen

Given I create a Lot "ZU1SNR25" for Product "KT-BEISTELL_SNR"
Given I create a Lot "ZU2SNR25" for Product "KT-BEISTELL_SNR"
Given I create a Lot "AB1SNR25" for Product "EKBEI_SNR"

Given I open an editor "BE-SNR25" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFCHA2 |
    | such   | BE-SNR25 |
    | ebeleg | BE-SNR25 |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel           | mge |
    | KT-BEISTELL_SNR   |  1  |
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I modify table
    | !row  | charge        | zcharge       |
    | 1     | !AB1SNR25^id  | !ZU1SNR25^id  |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

## SN und zSN aus der Reservierung in die MZ uebernehmen, wenn Res_Mge=1
Given I open an editor "BE-SNR25" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "BE-SNR25"
And I press button "mzabsm" to open a subeditor for "BeistellMZ" in row 1
Then table has values
    | !row  | zuomge   | charge^id     | zcharge^id    |
    | 1     | 1        | !AB1SNR25^id  | !ZU1SNR25^id  |
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# Lieferscheine aus Bestellung des Kaufteils, in der Position Charge eintragen fuer Zugang Kaufteil
Given I open an editor "LS1-SNR25" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE-SNR25"
And I set fields
   | ebeleg | LS1-SNR25 |
   | such   | LS1-SNR25 |
   | ueb    | ja        |
   | vom    | .         |
And I set field "mge" to "1" in row 1
And I set field "charge" to "!ZU1SNR25^id" in row 1
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!LS1-SNR25^num"
And I press start
Then table has values
    | art               | zmge | amge     | vcharge^id     | vplatz    | ncharge^id     | nplatz    |
    | EKBEI_SNR         |      | 1        | !AB1SNR25^id   | F1        | !ZU1SNR25^id   |           |
    | KT-BEISTELL_SNR   | 1    |          | (0,0,0)        |           | !ZU1SNR25^id   | F1        |
And I close the current editor


Scenario: SNR26 EK mit Beistellung - Zugangs-SNR in der BeistellMZ weicht ab von der Zugangs-SNR in der MZ des Kaufteils

Given I create a Lot "ZU1SNR26" for Product "KT-BEISTELL_SNR"
Given I create a Lot "ZU2SNR26" for Product "KT-BEISTELL_SNR"
Given I create a Lot "AB1SNR26" for Product "EKBEI_SNR"

Given I open an editor "BE-SNR26" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFCHA2 |
    | such   | BE-SNR26 |
    | ebeleg | BE-SNR26 |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel         | mge |
    | KT-BEISTELL_SNR |  1  |
And I press button "mzabsm" to open a subeditor for "BeistellMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge        | zcharge       |
    | 1     | F1     | 1        | !AB1SNR26^id  | !ZU1SNR26^id  |
And I save the current subeditor to switch back to the parent editor
# MZ fuer das Kaufteil anlegen mit abweichender Zugangscharge
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge        |
    | 1     | F2     | 1        | !ZU2SNR26^id  |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Lieferscheine aus Bestellung des Kaufteils, keine SNR eintragen, soll aus MZ genommen werden
Given I open an editor "LS1-SNR26" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE-SNR26"
And I set fields
   | ebeleg | LS1-SNR26 |
   | such   | LS1-SNR26 |
   | ueb    | ja        |
   | vom    | .         |
And I set field "mge" to "1" in row 1
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!LS1-SNR26^num"
And I press start
Then table has values
    | art               | zmge | amge     | vcharge^id     | vplatz    | ncharge^id    | nplatz    |
    | EKBEI_SNR         |      | 1        | !AB1SNR26^id   | F1        | !ZU1SNR26^id  |           |
    | KT-BEISTELL_SNR   | 1    |          | (0,0,0)        |           | !ZU2SNR26^id  | F2        |
And I close the current editor


Scenario: SNR27 Nach Storno kann die Seriennummer wieder verwendet werden - Fertigung Zugang und Abgang

Given I create a work order "SNR27" for Product "BG01_SNR" with quantity "2" and search word "SNR27_"

Given I open an editor "BA_SNR27" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SNR27_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I save the current editor
And I switch the current editor to editor "BA_SNR27"
And I save the current editor

# Materialentnahme
Given I open an editor "FBU1_SNR27" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | SNR27_001     |
    | bem       | Entnahme      |
And I press button "stlvblad"
Then table has values
    | elex      | bumge | manbu |
    | EK01_SNR  | 2     | ja    |
And I set field "bumge" to "1" in row 1
And I set field "tvcharge" to "SNR27_AB1" in row 1
And I save the current editor

# Rueckmeldung auf Arbeitsschein 2 bucht Zugang
Given I open an editor "RM1_SNR27" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR27_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | tkcharge  | SNR27_ZU1     |
    | bem       | RM1_SNR21Z    |
And I set field "gutmge" to "1" in row 1
And I save the current editor

Given I open an editor "RM1_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM1_SNR27"
And I save the current editor

Given I open an editor "FBU1_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=SNR27_001;bem=Entnahme;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
And I save the current editor

# erneute FBU und Rueckmeldung mit gleicher SNR wie in stornierten Belegen
Given I open an editor "FBU2_SNR27" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | SNR27_001     |
    | bem       | Entnahme2     |
And I press button "stlvblad"
Then table has values
    | elex      | bumge | manbu |
    | EK01_SNR  | 2     | ja    |
And I set field "bumge" to "1" in row 1
And I set field "tvcharge" to "SNR27_AB1" in row 1
And I save the current editor

Given I open an editor "RM2_SNR27" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR27_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | tkcharge  | SNR27_ZU1     |
    | bem       | RM2_SNR21Z    |
And I set field "gutmge" to "1" in row 1
And I save the current editor

Given I open an editor "RM2_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM2_SNR27"
And I save the current editor

Given I open an editor "FBU2_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=SNR27_001;bem=Entnahme2;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
And I save the current editor

Given I open an editor "BA_SNR27" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SNR27_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "resetmanbu"
And I save the current editor
And I switch the current editor to editor "BA_SNR27"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   | ztcharge  |
    | 1     | F1     | 1        | SNR271_1  | SNR27_1ZU |
    | 2     | F1     | 1        | SNR271_2  | SNR27_2ZU |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   | ztcharge  |
    | 1     | F1     | 1        | SNR272_1  | SNR27_1ZU |
    | 2     | F1     | 1        | SNR272_2  | SNR27_2ZU |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_SNR27"
And I press button "mzsubm" to open a subeditor for "ZugangsMZ"
And I modify table
    | !row  | tcharge   |
    | 1     | SNR27_1ZU |
    | 2     | SNR27_2ZU |
And I save the current editor
And I switch the current editor to editor "BA_SNR27"
And I save the current editor

# Rueckmeldung bucht Zugang und retrograd Material fuer beide Arbeitsscheine
Given I open an editor "RM3_SNR27" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR27_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | bem       | RM3_SNR27     |
And I set field "gutmge" to "1" in row 1
And I save the current editor

Given I open an editor "RM3_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM3_SNR27"
And I save the current editor

Given I open an editor "SNR271_1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR271_1;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor
Given I open an editor "SNR271_2" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR271_2;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor
Given I open an editor "SNR272_1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR272_1;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor
Given I open an editor "SNR272_2" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR272_2;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor
Given I open an editor "SNR27_1ZU" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR27_1ZU;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor
Given I open an editor "SNR27_2ZU" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR27_2ZU;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "BA_SNR27" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SNR27_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge        | zcharge       |
    | 1     | F1     | 1        | !SNR271_1^id  | !SNR27_1ZU^id |
    | +2    | F1     | 1        | !SNR271_2^id  | !SNR27_2ZU^id |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | charge        | zcharge       |
    | 1     | F1     | 1        | !SNR272_1^id  | !SNR27_1ZU^id |
    | +2    | F1     | 1        | !SNR272_2^id  | !SNR27_2ZU^id |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_SNR27"
And I press button "mzsubm" to open a subeditor for "ZugangsMZ"
Then table has values
    | !row  | charge^id        |
    | 1     | !SNR27_2ZU^id    |
And I create a new row at position 1
And I set field "zuomge" to "1" in row 1
And I set field "charge" to "!SNR27_1ZU^id" in row 1
And I close the current editor
And I switch the current editor to editor "BA_SNR27"
And I save the current editor


Scenario: SNR28 Nach Abbruch kann die Seriennummer wieder verwendet werden - Einkauf Bestellung

Given I open an editor "BE_SNR28" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | LIEFCHA1   |
    | such | BE_SNR28   |
    | vom  | .          |
And I append rows
    | artikel   | mge | einplan | tcharge   |
    | EK01_SNR  | 1   | ja      | SNR28     |
And I save the current editor

Given I open an editor "SNR28" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR28;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "BE_SNR28" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE_SNR28"
# Wollen Sie diese Position wirklich stornieren?
And I respond with answer "ja" to the dialog with id "191"
And I set field "mge" to "0" in row 1
And I save the current editor

Given I open an editor "BE2_SNR28" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | LIEFCHA1   |
    | such | BE2_SNR28  |
    | vom  | .          |
And I append rows
    | artikel   | mge | einplan | charge    |
    | EK01_SNR  | 1   | ja      | !SNR28^id |
And I save the current editor

Given I open an editor "BE2_SNR28" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE2_SNR28"
# Wollen Sie diese Position wirklich stornieren?
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "S" in row 1
And I save the current editor

Given I create a Lot "SNR28_2" for Product "EK01_SNR"

Given I open an editor "BE3_SNR28" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | LIEFCHA1   |
    | such | BE3_SNR28  |
    | vom  | .          |
And I append rows
    | artikel   | mge | einplan |
    | EK01_SNR  | 2   | ja      |
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge        |
    | 1     | F2     | 1        | !SNR28^id     |
    | 1     | F2     | 1        | !SNR28_2^id   |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "BE3_SNR28" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE3_SNR28"
# Wollen Sie diese Position wirklich stornieren (Menge zugeordnet)?
And I respond with answer "ja" to the dialog with id "3180"
And I set field "mge" to "0" in row 1
And I save the current editor

Given I open an editor "BE4_SNR28" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | LIEFCHA1   |
    | such | BE4_SNR28  |
    | vom  | .          |
And I append rows
    | artikel   | mge | einplan |
    | EK01_SNR  | 2   | ja      |
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge        |
    | 1     | F2     | 1        | !SNR28^id     |
    | 1     | F2     | 1        | !SNR28_2^id   |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "BE4_SNR28" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE4_SNR28"
# Wollen Sie diese Position wirklich stornieren (Menge zugeordnet)?
And I respond with answer "ja" to the dialog with id "3180"
And I set field "status" to "S" in row 1
And I save the current editor

Given I open an editor "BE5_SNR28" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | LIEFCHA1   |
    | such | BE5_SNR28  |
    | vom  | .          |
And I append rows
    | artikel   | mge | einplan |
    | EK01_SNR  | 2   | ja      |
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge        |
    | 1     | F2     | 1        | !SNR28^id     |
    | 1     | F2     | 1        | !SNR28_2^id   |
And I save the current subeditor to switch back to the parent editor
And I save the current editor


Scenario: SNR29 Nach Abbruch kann die Seriennummer wieder verwendet werden - Verkauf Auftrag

Given I open an editor "AUFSNR29" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH1   |
    | such  | AUFSNR29   |
    | vom   | .          |
And I append rows
    | artikel   | mge | einplan | tcharge   |
    | EK01_SNR  | 1   | ja      | SNR29     |
And I save the current editor

Given I open an editor "SNR29" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR29;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "AUFSNR29" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AUFSNR29"
# Wollen Sie diese Position wirklich stornieren?
And I respond with answer "ja" to the dialog with id "191"
And I set field "mge" to "0" in row 1
And I save the current editor

Given I open an editor "AUF2SNR29" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH1   |
    | such  | AUF2SNR29  |
    | vom   | .          |
And I append rows
    | artikel   | mge | einplan | charge    |
    | EK01_SNR  | 1   | ja      | !SNR29^id |
And I save the current editor

Given I open an editor "AUF2SNR29" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AUF2SNR29"
# Wollen Sie diese Position wirklich stornieren?
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "S" in row 1
And I save the current editor

Given I create a Lot "SNR29_2" for Product "EK01_SNR"

Given I open an editor "AUF3SNR29" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH1   |
    | such  | AUF3SNR29  |
    | vom   | .          |
And I append rows
    | artikel   | mge | einplan |
    | EK01_SNR  | 2   | ja      |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge        |
    | 1     | F1     | 1        | !SNR29^id     |
    | 2     | F1     | 1        | !SNR29_2^id   |
And I save the current editor
And I switch the current editor to editor "AUF3SNR29"
And I save the current editor

Given I open an editor "AUF3SNR29" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AUF3SNR29"
# Wollen Sie diese Position wirklich stornieren (Menge zugeordnet)?
And I respond with answer "ja" to the dialog with id "3180"
And I set field "mge" to "0" in row 1
And I save the current editor

Given I open an editor "AUF4SNR29" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH1   |
    | such  | AUF4SNR29  |
    | vom   | .          |
And I append rows
    | artikel   | mge | einplan |
    | EK01_SNR  | 2   | ja      |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge        |
    | 1     | F1     | 1        | !SNR29^id     |
    | 2     | F1     | 1        | !SNR29_2^id   |
And I save the current editor
And I switch the current editor to editor "AUF4SNR29"
And I save the current editor

Given I open an editor "AUF4SNR29" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AUF4SNR29"
# Wollen Sie diese Position wirklich stornieren?
And I respond with answer "ja" to the dialog with id "3180"
And I set field "status" to "S" in row 1
And I save the current editor

Given I open an editor "AUF5SNR29" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH1   |
    | such  | AUF5SNR29  |
    | vom   | .          |
And I append rows
    | artikel   | mge | einplan |
    | EK01_SNR  | 2   | ja      |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge        |
    | 1     | F1     | 1        | !SNR29^id     |
    | 2     | F1     | 1        | !SNR29_2^id   |
And I save the current editor
And I switch the current editor to editor "AUF5SNR29"
And I save the current editor


Scenario: SNR30 Nach Abbruch kann die Seriennummer wieder verwendet werden - Fertigung Zugang und Abgang

Given I create a work order "SNR30" for Product "BG01_SNR" with quantity "2" and search word "SNR30_"

Given I open an editor "BA_SNR30" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SNR30_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I save the current editor
And I switch the current editor to editor "BA_SNR30"
And I save the current editor

# Materialentnahme
Given I open an editor "FBU1_SNR30" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | SNR30_001     |
    | bem       | Entnahme      |
And I press button "stlvblad"
Then table has values
    | elex      | bumge | manbu |
    | EK01_SNR  | 2     | ja    |
And I set field "bumge" to "1" in row 1
And I set field "tvcharge" to "SNR30_AB1" in row 1
And I close the current editor

# Rueckmeldung auf Arbeitsschein 2 wuerde Zugang buchen, wird aber abgebrochen, Editor schliessen
Given I open an editor "RM1_SNR30" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR30_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | tkcharge  | SNR30_ZU1     |
    | bem       | RM1_SNR36Z    |
And I set field "gutmge" to "1" in row 1
And I press button "mzsubm" to open a subeditor for "ZugangsMZ" in row 1
And I set field "tcharge" to "SNR30_ZU1" in row 1
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# erneute FBU und Rueckmeldung mit gleicher SNR wie vorher in den abgebrochenen Belegen
Given I open an editor "FBU2_SNR30" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | SNR30_001     |
    | bem       | Entnahme2     |
And I press button "stlvblad"
Then table has values
    | elex      | bumge | manbu |
    | EK01_SNR  | 2     | ja    |
And I set field "bumge" to "1" in row 1
And I set field "tvcharge" to "SNR30_AB1" in row 1
And I save the current editor

Given I open an editor "RM2_SNR30" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR30_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | tkcharge  | SNR30_ZU1     |
    | bem       | RM2_SNR36Z    |
And I set field "gutmge" to "1" in row 1
And I save the current editor

Given I open an editor "BA_SNR30" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SNR30_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | 1     | F1     | 1        | SNR30_AB1.2   |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | 1     | F1     | 1        | SNR30_AB2.1   |
    | 2     | F1     | 1        | SNR30_AB2.2   |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_SNR30"
And I press button "mzsubm" to open a subeditor for "ZugangsMZ"
And I modify table
    | !row  | tcharge   |
    | 1     | SNR30_ZU2 |
And I close the current editor
And I switch the current editor to editor "BA_SNR30"
And I save the current editor

# Rueckmeldung abbrechen, wuerde Zugang buchen, kein Material
Given I open an editor "RM3_SNR30" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR30_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | tkcharge  | SNR30_ZU2     |
    | bem       | RM3_SNR30     |
And I set field "gutmge" to "1" in row 1
And I close the current editor

Given I open an editor "SNR30_ZU1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR30_ZU1;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor
Given I open an editor "SNR30_ZU2" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR30_ZU2;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "RM3_SNR30" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR30_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | kcharge   | !SNR30_ZU2^id |
    | manrest   | ja            |
    | bem       | RM3_SNR30     |
And I set field "gutmge" to "1" in row 1
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM3_SNR30^barmex"
And I press start
Then table has values
    | art       | zmge | amge     | tvcharge    | ncharge^id      |
    | BG01_SNR  | 1    |          |             | !SNR30_ZU1^id   |
    | EK02_SNR  |      | 1        | SNR30_AB2.1 | !SNR30_ZU2^id   |
    | EK02_SNR  |      | 1        | SNR30_AB2.2 | !SNR30_ZU2^id   |
    | EK01_SNR  |      | 1        | SNR30_AB1.2 | !SNR30_ZU2^id   |
    | BG01_SNR  | 1    |          |             | !SNR30_ZU2^id   |
And I close the current editor


Scenario: SNR31 Nach Abbruch kann die Seriennummer wieder verwendet werden - Einkauf Lieferschein ohne MZ

Given I open an editor "BE-SNR31" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | LIEFCHA1   |
    | such | BE-SNR31   |
    | vom  | .          |
And I append rows
    | artikel   | mge | einplan |
    | EK01_SNR  | 1   | ja      |
And I save the current editor

Given I open an editor "LS1-SNR31" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE-SNR31"
And I set fields
   | ebeleg | LS1-SNR31 |
   | such   | LS1-SNR31 |
   | ueb    | nein      |
   | vom    | .         |
And I set field "mge" to "1" in row 1
And I set field "tcharge" to "SNR31" in row 1
And I save the current editor

Given I open an editor "SNR31" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR31;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "LS1-SNR31" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "LS1-SNR31"
And I set field "mge" to "0" in row 1
# Wollen Sie diese Position wirklich stornieren?
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "S" in row 1
And I delete all rows
And I save the current editor

Given I open an editor "LS2-SNR31" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE-SNR31"
And I set fields
   | ebeleg | LS2-SNR31 |
   | such   | LS2-SNR31 |
   | ueb    | ja        |
   | vom    | .         |
And I set field "mge" to "1" in row 1
And I set field "charge" to "!SNR31^id" in row 1
And I save the current editor


Scenario: SNR32 Nach Abbruch kann die Seriennummer wieder verwendet werden - Einkauf Lieferschein mit MZ

Given I open an editor "BE-SNR32" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | LIEFCHA1   |
    | such | BE-SNR32   |
    | vom  | .          |
And I append rows
    | artikel   | mge | einplan |
    | EK01_SNR  | 2   | ja      |
And I save the current editor

Given I open an editor "LS1-SNR32" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE-SNR32"
And I set fields
   | ebeleg | LS1-SNR32 |
   | such   | LS1-SNR32 |
   | ueb    | nein      |
   | vom    | .         |
And I set field "mge" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | 1     | F1     | 1        | SNR32_1   |
    | 2     | F1     | 1        | SNR32_2   |
And I save the current editor
And I switch the current editor to editor "LS1-SNR32"
And I save the current editor

Given I open an editor "SNR32_1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR32_1;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor
Given I open an editor "SNR32_2" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR32_2;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "LS1-SNR32" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "LS1-SNR32"
And I set field "mge" to "0" in row 1
# Wollen Sie diese Position wirklich stornieren (Menge zugeordnet)?
And I respond with answer "ja" to the dialog with id "3180"
And I set field "status" to "S" in row 1
And I save the current editor

Given I open an editor "LS2-SNR32" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE-SNR32"
And I set fields
   | ebeleg | LS2-SNR32 |
   | such   | LS2-SNR32 |
   | ueb    | ja        |
   | vom    | .         |
And I set field "mge" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge        |
    | 1     | F1     | 1        | !SNR32_1^id   |
    | 2     | F1     | 1        | !SNR32_2^id   |
And I save the current editor
And I switch the current editor to editor "LS2-SNR32"
And I save the current editor


Scenario: SNR33 Nach Abbruch kann die Seriennummer wieder verwendet werden - Verkauf Lieferschein ohne MZ

Given I open an editor "AUFSNR33" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH1   |
    | such  | AUFSNR33   |
    | vom   | .          |
And I append rows
    | artikel   | mge | einplan |
    | EK01_SNR  | 1   | ja      |
And I save the current editor

Given I open an editor "AUFSNR33" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "AUFSNR33"
And I set fields
    | such   | VKLS1_33    |
    | vom    | .           |
    | ueb    | nein        |
And I set field "mge" to "1" in row 1
And I set field "tcharge" to "SNR33" in row 1
And I save the current editor

Given I open an editor "SNR33" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR33;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "VKLS1_33" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "VKLS1_33"
And I set field "mge" to "0" in row 1
# Wollen Sie diese Position wirklich stornieren?
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "S" in row 1
And I delete all rows
And I save the current editor

Given I open an editor "AUFSNR33" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "AUFSNR33"
And I set fields
    | such   | VKLS2_33    |
    | vom    | .           |
    | ueb    | ja          |
And I set field "mge" to "1" in row 1
And I set field "charge" to "!SNR33^id" in row 1
And I save the current editor


Scenario: SNR34 Nach Abbruch kann die Seriennummer wieder verwendet werden - Verkauf Lieferschein mit MZ

Given I open an editor "AUFSNR34" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH1   |
    | such  | AUFSNR34   |
    | vom   | .          |
And I append rows
    | artikel   | mge | einplan |
    | EK01_SNR  | 2   | ja      |
And I save the current editor

Given I open an editor "AUFSNR34" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "AUFSNR34"
And I set fields
    | such   | VKLS1_34    |
    | vom    | .           |
    | ueb    | nein        |
And I set field "mge" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | tcharge  |
    | 1     | F1     | SNR34_1  |
    | 2     | F1     | SNR34_2  |
And I save the current editor
And I switch the current editor to editor "AUFSNR34"
And I save the current editor

Given I open an editor "SNR34_1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR34_1;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor
Given I open an editor "SNR34_2" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR34_2;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "VKLS1_34" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "VKLS1_34"
And I set field "mge" to "0" in row 1
# Wollen Sie diese Position wirklich stornieren (Menge zugeordnet)?
And I respond with answer "ja" to the dialog with id "3180"
And I set field "status" to "S" in row 1
And I delete all rows
And I save the current editor

Given I open an editor "AUFSNR34" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "AUFSNR34"
And I set fields
    | such   | VKLS2_34    |
    | vom    | .           |
    | ueb    | ja          |
And I set field "mge" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
Then table has values
    | !row  | charge^id    |
    | 1     | !SNR34_1^id  |
    | 2     | !SNR34_2^id  |
And I save the current editor
And I switch the current editor to editor "AUFSNR34"
And I save the current editor


Scenario: SNR35 Fertigungsvorschlag mit Menge 1 und SNR, in der Rueckmeldung Menge auf 2 und MZ erfassen

Given I open an editor "BG35_SNR" from table "(Part):(Product)" with command "STORE" for record "BG35_SNR"
And I set fields
    | such          | BG35_SNR                      |
    | namebspr      | SNR Baugruppe, Material ohne  |
    | chverfolgung  | Seriennummernverfolgung       |
And I delete all rows
And I append rows
    | elex  | elanzahl  |
    | EINK  | 1         |
    | A AG2 | 1         |
And I save the current editor

Given I create a work order "SNR35" for Product "BG35_SNR" with quantity "1" and search word "SNR35_"

# BA-Nummer zwischenspeichern
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=SNR35_000;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "nummer" in row 0
And I close the current editor

# SNR fuer Baugruppe im FV eintragen
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "BG35_SNR"
And I set field "banummer" in row 0 to saved value
And I press button "ladetab"
Then the table has 1 rows
And I set field "tcharge" to "SNR35" in row 1
And I save the current editor

# Rueckmeldung Gesamtmenge auf Arbeitsschein, Zugangsbuchung
Given I open an editor "RM1_SNR35" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR35_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | bem       | RM_SNR35  |
Then field "tkcharge" has value "SNR35"
# Bei Seriennummernverfolgung und einer Menge > 1 muss die Erfassung über die Materialzuordnung erfolgen.
#Then setting field "gutmge" to "2" in row 1 throws the exception "1161"
# Meldung kann nicht abgefragt werden, ACK statt NAK
And I set field "gutmge" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
Then table has values
    | !row  | zuomge    | tcharge   |
    | 1     | 1         |           |
    | 2     | 1         |           |
And I set field "tcharge" to "SNR35" in row 1
And I set field "tcharge" to "SNR35_2" in row 2
And I save the current editor
And I switch the current editor to editor "RM1_SNR35"
And I save the current editor

Given I create a work order "SNR35BA" for Product "BG35_SNR" with quantity "1" and search word "SNR35BA_"

# BA-Nummer zwischenspeichern
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=SNR35BA_000;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "nummer" in row 0
And I close the current editor

# SNR fuer Baugruppe im FV eintragen
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "BG35_SNR"
And I set field "banummer" in row 0 to saved value
And I press button "ladetab"
Then the table has 1 rows
And I set field "tcharge" to "SNR35BA" in row 1
And I save the current editor

# Rueckmeldung Gesamtmenge auf BA
Given I open an editor "RM_SNR35BA" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR35BA_000;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | gut       | ja            |
    | mgr       | 101           |
    | bem       | RM_SNR35BA    |
Then field "tkcharge" has value "SNR35BA"
# Bei Seriennummernverfolgung und einer Menge > 1 muss die Erfassung über die Materialzuordnung erfolgen.
#Then setting field "gutmge" to "2" in row 1 throws the exception "1161"
# Meldung kann nicht abgefragt werden, ACK statt NAK
And I set field "gutmge" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
Then table has values
    | !row  | zuomge    | tcharge   |
    | 1     | 1         |           |
    | 2     | 1         |           |
And I set field "tcharge" to "SNR35BA" in row 1
And I set field "tcharge" to "SNR35BA_2" in row 2
And I save the current editor
And I switch the current editor to editor "RM_SNR35BA"
And I save the current editor


Scenario: SNR36 EntnahmeMZ ueber Menge 1, ueber FBU Menge erhoehen und in MZ die Eindeutigkeit der SNR pruefen

Given I create a work order "SNR36" for Product "BG01_SNR" with quantity "1" and search word "SNR36_"

Given I open an editor "BA_SNR36" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SNR36_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I set field "tcharge" to "SNR36_1" in row 1
And I press button for next product
And I set field "tcharge" to "SNR36_2" in row 1
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_SNR36"
And I save the current editor

Given I open an editor "SNR36_1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR36_1;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

# Materialentnahme
Given I open an editor "FBU_SNR36" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | SNR36_001     |
    | bem       | Entnahme      |
And I press button "stlvblad"
Then table has values
    | elex      | bumge | manbu |
    | EK01_SNR  | 1     | ja    |
And I set field "bumge" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
Then table has values
    | !row  | zuomge    | tcharge   |
    | 1     | 1         | SNR36_1   |
And I create a new row at position 2
# 7039 TX=de |Artikel mit Seriennummernverfolgung darf nur mit Menge und Faktor 1 in Lagereinheit gebucht werden. Vorgang oder MZ prüfen.
And I set field "zuomge" to "1" in row 2
And I set field "tcharge" to "SNR36_1" in row 2
Then saving the current editor throws the exception "7044"
And I set field "charge" to "!SNR36_1^id" in row 2
Then saving the current editor throws the exception "7044"
And I set field "tcharge" to "SNR36_1A" in row 2
And I save the current editor
And I switch the current editor to editor "FBU_SNR36"
And I save the current editor


Scenario: SNR37 Fertigungsvorschlag mit Menge 1 und SNR, in der Rueckmeldung darf die SNR nicht geaendert werden, nur im FV

Given I create a work order "SNR37" for Product "BG35_SNR" with quantity "1" and search word "SNR37_"

# BA-Nummer zwischenspeichern
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=SNR37_000;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "nummer" in row 0
And I close the current editor

# SNR fuer Baugruppe im FV eintragen
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "BG35_SNR"
And I set field "banummer" in row 0 to saved value
And I press button "ladetab"
Then the table has 1 rows
And I set field "tcharge" to "SNR37_1" in row 1
And I save the current editor

# Rueckmeldung auf Arbeitsschein, zugehende Charge ist nicht aenderbar, muss im FV gemacht werden, Buchung abbrechen
Given I open an editor "RM1_SNR37" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR37_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | bem       | RM_SNR37  |
Then field "tkcharge" has value "SNR37_1"
Then field "tkcharge" is not modifiable
And I close the current editor

# SNR im FV aendern
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "BG35_SNR"
And I set field "banummer" in row 0 to saved value
And I press button "ladetab"
Then the table has 1 rows
And I set field "tcharge" to "SNR37_2" in row 1
And I save the current editor

# Rueckmeldung auf Arbeitsschein, zugehende Charge aus FV ist nicht aenderbar
Given I open an editor "RM1_SNR37" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR37_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | bem       | RM_SNR37  |
Then field "tkcharge" has value "SNR37_2"
Then field "tkcharge" is not modifiable
And I set field "gutmge" to "1" in row 1
And I save the current editor

# Buchungen im LJ pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_SNR37^barmex"
And I press start
Then table has values
    | art       | zmge | amge     | tvcharge  | tncharge    |
    | EINK      |      | 1        |           | SNR37_2     |
    | BG35_SNR  | 1    |          |           | SNR37_2     |
And I close the current editor


Scenario: SNR38 Pruefung Verwendung Seriennummer innerhalb Betriebsauftrag

Given I create a work order "SNR38" for Product "BG03_SNR" with quantity "3" and search word "SNR38_"

# SNR in ZugangsMZ eintragen, damit diese verbraucht sind
Given I open an editor "BA_SNR38" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SNR38_000"
And I press button "mzsubm" to open a subeditor for "ZugangsMZ"
And I modify table
    | !row  | tcharge    |
    | 1     | SNR38_ZU1  |
    | 2     | SNR38_ZU2  |
    | 3     | SNR38_ZU3  |
And I save the current editor
And I switch the current editor to editor "BA_SNR38"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | 1     | F1     | 1        | SNR38_1.1 |
    | 2     | F1     | 1        | SNR38_1.2 |
    | 3     | F1     | 1        | SNR38_1.3 |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | 1     | F1     | 1        | SNR38_2.1 |
    | 2     | F1     | 1        | SNR38_2.2 |
    | 3     | F1     | 1        | SNR38_2.3 |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_SNR38"
And I save the current editor

# Rueckmeldung auf Arbeitsschein 1 mit Angabe einer zugehenden Seriennummer
Given I open an editor "RM1_SNR38" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR38_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | tkcharge  | SNR38_ZU2 |
    | sofort    | ja        |
    | bem       | RM_SNR38  |
And I set field "gutmge" to "1" in row 1
And I save the current editor

# Buchungen im LJ pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_SNR38^barmex"
And I press start
Then table has values
    | art       | zmge | amge     | tvcharge  | tncharge    |
    | EK01_SNR  |      | 1        | SNR38_1.1 | SNR38_ZU2   |
And I close the current editor


Scenario: SNR38A Abbuchen bzw. Laden Material in RM bzw. FBU wenn nicht alle MZs Angabe SN haben - mit Angabe zcharge

Given I create a work order "SNR38A" for Product "BG03_SNR" with quantity "3" and search word "SNR38A_"

# SNR in ZugangsMZ eintragen, damit diese verbraucht sind
Given I open an editor "BA_SNR38A" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SNR38A_000"
And I press button "mzsubm" to open a subeditor for "ZugangsMZ"
And I modify table
    | !row  | tcharge    |
    | 1     | SNR38A_ZU1 |
    | 2     | SNR38A_ZU2 |
    | 3     | SNR38A_ZU3 |
And I save the current editor
And I switch the current editor to editor "BA_SNR38A"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       | ztcharge      |
    | 1     | F1     | 1        | SNR38A_1.1    | SNR38A_ZU2    |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       | ztcharge      |
    | 1     | F1     | 1        | SNR38A_2.1    | SNR38A_ZU2    |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_SNR38A"
And I save the current editor

Given I open an editor "FBU1_SNR38A" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | SNR38A_001    |
    | autorment | ja            |
    | tcharge   | SNR38A_ZU2    |
    | bem       | Entnahme      |
And I press button "stlvblad"
Then table has values
    | elex      | bumge | manbu |
    | EK01_SNR  | 1     | nein  |
And I close the current editor

# Rueckmeldung auf Arbeitsschein 1 mit Angabe einer zugehenden Seriennummer
Given I open an editor "RM1_SNR38A" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR38A_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | tkcharge  | SNR38A_ZU2    |
    | sofort    | ja            |
    | bem       | RM_SNR38A     |
And I set field "gutmge" to "1" in row 1
And I save the current editor

# Rueckmeldung auf Arbeitsschein 1 mit Angabe einer zugehenden Seriennummer
Given I open an editor "RM2_SNR38A" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR38A_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | tkcharge  | SNR38A_ZU1    |
    | sofort    | ja            |
    | bem       | RM_SNR38A     |
And I set field "gutmge" to "1" in row 1
And I save the current editor

Given I open an editor "RMPruef" via ID from editor "RM1_SNR38A" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "VIEW"
Then the table has 2 rows
Then table has values
    | artikel     | mge   | gutmge    | tcharge     |
    | BG03_SNR    | 3     | 1         | SNR38A_ZU2  |
    | EK01_SNR    | 1     | 0         |             |
And I close the current editor

# fuer die zweite Rueckmeldung gab es keine Angabe der SNR fuer das Entnahmeteil in der EntnahmeMZ
Given I open an editor "RMPruef" via ID from editor "RM2_SNR38A" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "VIEW"
Then the table has 2 rows
Then table has values
    | artikel     | mge   | gutmge    | tcharge     |
    | BG03_SNR    | 2     | 1         | SNR38A_ZU1  |
    | EK01_SNR    | 0     | 0         |             |
And I close the current editor

# Buchungen im LJ pruefen, nur 1 Stueck wurde entnommen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_SNR38A^barmex"
And I press start
Then table has values
    | art       | zmge | amge     | tvcharge    | tncharge      |
    | EK01_SNR  |      | 1        | SNR38A_1.1  | SNR38A_ZU2    |
And I close the current editor


Scenario: SNR38B Abbuchen bzw. Laden Material in RM bzw. FBU wenn nicht alle MZs Angabe SN haben - ohne Angabe zcharge

Given I create a work order "SNR38B" for Product "BG03_SNR" with quantity "3" and search word "SNR38B_"

# SNR in ZugangsMZ eintragen, damit diese verbraucht sind
Given I open an editor "BA_SNR38B" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SNR38B_000"
And I press button "mzsubm" to open a subeditor for "ZugangsMZ"
And I modify table
    | !row  | tcharge    |
    | 1     | SNR38B_ZU1 |
    | 2     | SNR38B_ZU2 |
    | 3     | SNR38B_ZU3 |
And I save the current editor
And I switch the current editor to editor "BA_SNR38B"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | 1     | F1     | 1        | SNR38B_1.1    |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | 1     | F1     | 1        | SNR38B_2.1    |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_SNR38B"
And I save the current editor

Given I open an editor "FBU1_SNR38B" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | SNR38B_001    |
    | autorment | ja            |
    | tcharge   | SNR38B_ZU2    |
    | bem       | Entnahme      |
And I press button "stlvblad"
Then table has values
    | elex      | bumge | manbu |
    | EK01_SNR  | 1     | nein  |
And I close the current editor

# Rueckmeldung auf Arbeitsschein 1 mit Angabe einer zugehenden Seriennummer
Given I open an editor "RM1_SNR38B" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR38B_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | tkcharge  | SNR38B_ZU2    |
    | sofort    | ja            |
    | bem       | RM_SNR38B     |
And I set field "gutmge" to "1" in row 1
And I save the current editor

# Rueckmeldung auf Arbeitsschein 1 mit Angabe einer zugehenden Seriennummer
Given I open an editor "RM2_SNR38B" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR38B_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | tkcharge  | SNR38B_ZU1    |
    | sofort    | ja            |
    | bem       | RM_SNR38B     |
And I set field "gutmge" to "1" in row 1
And I save the current editor

Given I open an editor "RMPruef" via ID from editor "RM1_SNR38B" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "VIEW"
Then the table has 2 rows
Then table has values
    | artikel     | mge   | gutmge    | tcharge     |
    | BG03_SNR    | 3     | 1         | SNR38B_ZU2  |
    | EK01_SNR    | 1     | 0         |             |
And I close the current editor

# fuer die zweite Rueckmeldung gab es keine Angabe der SNR fuer das Entnahmeteil in der EntnahmeMZ
Given I open an editor "RMPruef" via ID from editor "RM2_SNR38B" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "VIEW"
Then the table has 2 rows
Then table has values
    | artikel     | mge   | gutmge    | tcharge     |
    | BG03_SNR    | 2     | 1         | SNR38B_ZU1  |
    | EK01_SNR    | 0     | 0         |             |
And I close the current editor

# Buchungen im LJ pruefen, nur 1 Stueck wurde entnommen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_SNR38B^barmex"
And I press start
Then table has values
    | art       | zmge | amge     | tvcharge    | tncharge      |
    | EK01_SNR  |      | 1        | SNR38B_1.1  | SNR38B_ZU2    |
And I close the current editor


Scenario: SNR39 Materialentnahme mit Kopfcharge und Abgangscharge in Zeile FBU

Given I create a work order "SNR39" for Product "BG01_SNR" with quantity "2" and search word "SNR39_"

Given I create a Lot "SNR39_AB1" for Product "EK01_SNR"
Given I create a Lot "SNR39_AB2" for Product "EK01_SNR"

# SNR in ZugangsMZ eintragen
Given I open an editor "BA_SNR39" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SNR39_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I save the current subeditor to switch back to the parent editor
And I press button "mzsubm" to open a subeditor for "ZugangsMZ"
And I modify table
    | !row  | tcharge    |
    | 1     | SNR39_ZU1  |
    | 2     | SNR39_ZU2  |
And I save the current editor
And I switch the current editor to editor "BA_SNR39"
And I save the current editor

Given I open an editor "SNR39_ZU1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR39_ZU1;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "SNR39_ZU2" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR39_ZU2;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "FBU_SNR39" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | SNR39_001     |
    | gmgevorschl   | 1             |
    | charge        | !SNR39_ZU1^id |
    | bem           | Entnahme1     |
And I press button "stlvblad"
Then table has values
    | elex      | manbu |
    | EK01_SNR  | ja    |
And I set field "bumge" to "1" in row 1
And I set field "rescharge" to "!SNR39_AB1^id" in row 1
And I save the current editor

Given I open an editor "FBU_SNR39" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | SNR39_001     |
    | gmgevorschl   | 1             |
    | charge        | !SNR39_ZU2^id |
    | bem           | Entnahme2     |
And I press button "stlvblad"
Then table has values
    | elex      | manbu |
    | EK01_SNR  | ja    |
And I set field "bumge" to "1" in row 1
And I set field "rescharge" to "!SNR39_AB2^id" in row 1
And I save the current editor


Scenario: SNR13A Umchargieren mit Umlagerungslieferschein im Verkauf

Given I open an editor "VKUML_13A" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH2  |
    | such  | VKUML_13A |
Then field "umplatz" has value "KONSI2"
And I append rows
    | artikel       | mge  |
    | EK-UMLAGERSNR | 2    |
Then field "tcharge" is empty in row 1
And I save the current editor

Given I open an editor "VKUML_13A" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "VKUML_13A"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I set field "tcharge" to "SNR13A" in row 1
And I set field "tumcharge" to "SNR13ANEU" in row 1
And I set field "ljtext1" to "VKUML_SNR13A" in row 1
And I save the current editor

Given I open an editor "SNR13A" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR13A;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel       | EK-UMLAGERSNR             |
    | exnum         | SNR13A                    |
    | chverfolgung  | Seriennummernverfolgung   |
    | snabgangverf  | nein                      |
    | snzugangverf  | ja                        |
And I close the current editor

Given I open an editor "SNR13ANEU" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR13ANEU;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel       | EK-UMLAGERSNR             |
    | exnum         | SNR13ANEU                 |
    | chverfolgung  | Seriennummernverfolgung   |
    | snabgangverf  | ja                        |
    | snzugangverf  | nein                      |
And I close the current editor


Scenario: SNR14A Umlagerungsvorschlag freigeben und in Umlagerunglieferschein umchargieren

Given I open an editor "EK-UMLAGERSNR" from table "(Part):(Product)" with command "UPDATE" for record "EK-UMLAGERSNR"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I set field "mindest" to "20" in row 1
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I run Scheduling

Given I create a Lot "SNR14A" for Product "EK-UMLAGERSNR"

# Umlagerungsvorschlag freigeben und in Umlagerungslieferschein umchargieren
Given I open an editor "UML_INT_EXT" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "EK-UMLAGERSNR"
And I set field "lgruppe" to ""
And I press button "ladetab"
Then the table has 1 rows
Then table has values
    | ablgruppe | lgruppe   | fix   |
    | KARLSRUHE | BERLIN    | nein  |
And I set field "mge" to "1" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BE_freigeben"
And I set fields
    | lief  | TEST      |
    | such  | BE_SNR14A |
    | vom   | .         |
And I modify table
    | !row  | charge        | umcharge      |
    | 1     | !SNR14A^id    | !SNR14A^id    |
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# SNR ist nach umbuchen nicht fuer Abgang verbraucht
Given I open an editor "SNR14A" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR14A;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel       | EK-UMLAGERSNR             |
    | exnum         | SNR14A                    |
    | chverfolgung  | Seriennummernverfolgung   |
    | snabgangverf  | ja                        |
    | snzugangverf  | ja                        |
And I close the current editor

Given I open an editor "BE_SNR14A" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE_SNR14A"
And I set fields
    | ebeleg | LS1-SNR14A   |
    | such   | L1_SNR14A    |
    | vom    | .            |
    | ueb    | ja           |
And I modify table
    | !row  | mge   | tcharge   | umcharge      |
    | 1     | 1     | SNR14NEU  | !SNR14A^id    |
And I save the current editor

# Seriennummer ist nach umchargieren verbraucht
Given I open an editor "SNR14A" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR14A;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel       | EK-UMLAGERSNR             |
    | exnum         | SNR14A                    |
    | chverfolgung  | Seriennummernverfolgung   |
    | snabgangverf  | nein                      |
    | snzugangverf  | ja                        |
And I close the current editor

Given I open an editor "ChargeSNR14NEU" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR14NEU;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel       | EK-UMLAGERSNR             |
    | exnum         | SNR14NEU                  |
    | chverfolgung  | Seriennummernverfolgung   |
    | snabgangverf  | ja                        |
    | snzugangverf  | nein                      |
And I close the current editor


Scenario: SNR40 Umchargieren mit Fremdbeschaffungs-Lieferschein mit umplatz gefuellt

Given I create a Lot "SNR40" for Product "EK01_SNR"
Given I create a Lot "SNR40_2" for Product "EK01_SNR"

# SNR40 zubuchen, damit im Zugang verbraucht
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK01_SNR      |
    | buart     | Zugang        |
    | beleg     | LBUZU_SNR40   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | charge2       |
    | 1      | F1       | !SNR40^id     |
    | 1      | F1       | !SNR40_2^id   |
And I save the current editor

# im EK ist umcharge Abgang und charge Zugang
Given I open an editor "LS1_SNR40" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | LIEFCHA1          |
    | such      | LS_SNR40          |
    | ebeleg    | LS_SNR40          |
    | bsart     | Fremdbeschaffung  |
    | umplatz   | F1                |
    | vom       | .                 |
    | ueb       | ja                |
And I append rows
    | artikel   | mge | platz   |
    | EK01_SNR  | 1   | L3F1    |
And I set field "umcharge" to "!SNR40^id" in row 1
# Partner-Chargenfeld (charge <-> umcharge) wird vorbelegt, wenn leer, sonst nicht, damit Umchargieren moeglich ist
Then field "charge^id" has value "!SNR40^id" in row 1
And I set field "charge" to "!SNR40_2^id" in row 1
# umcharge bleibt, da nicht leer
Then field "umcharge^id" has value "!SNR40^id" in row 1
# 7043 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde zugebucht.
Then saving the current editor throws the exception "7043"
And I set field "tcharge" to "SNR40_NEU" in row 1
# Wert in umcharge bleibt, da nicht leer, SNR40 ist im Zugang verbraucht, kann aber im Abgang verwendet werden
Then field "umcharge^id" has value "!SNR40^id" in row 1
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!LS1_SNR40^num"
And I press start
Then table has values
    | art       | zmge | amge     | vcharge^id  | vplatz    | tncharge  | nplatz    |
    | EK01_SNR  |      | 1        | !SNR40^id   | F1        | SNR40_NEU |           |
    | EK01_SNR  | 1    |          | !SNR40^id   |           | SNR40_NEU | L3F1      |
And I close the current editor

# auch durch Umchargieren ist die SNR verbraucht, sowie testen dass in umcharge keine im Abgang verbrauchte SNR verwendet werden kann
Given I open an editor "LS2_SNR40" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | LIEFCHA1          |
    | such      | LS2_SNR40         |
    | ebeleg    | LS2_SNR40         |
    | bsart     | Fremdbeschaffung  |
    | umplatz   | F1                |
    | vom       | .                 |
    | ueb       | ja                |
And I append rows
    | artikel   | mge | platz   |
    | EK01_SNR  | 1   | L3F1    |
And I set field "umcharge" to "!SNR40^id" in row 1
# Partner-Chargenfeld (charge <-> umcharge) wird vorbelegt, wenn leer, sonst nicht, damit Umchargieren moeglich ist
Then field "charge^id" has value "!SNR40^id" in row 1
# neue zugehende Charge eintragen, weil SNR40 bereits im Zugang verbraucht
And I set field "tcharge" to "SNR40_NEU_2" in row 1
# umcharge wird abgelehnt # 7044 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde abgebucht.
Then saving the current editor throws the exception "7044"
And I set field "tumcharge" to "SNR40_NEU_1" in row 1
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!LS2_SNR40^num"
And I press start
Then table has values
    | art       | zmge | amge     | tvcharge    | vplatz    | tncharge      | nplatz    |
    | EK01_SNR  |      | 1        | SNR40_NEU_1 | F1        | SNR40_NEU_2   |           |
    | EK01_SNR  | 1    |          | SNR40_NEU_1 |           | SNR40_NEU_2   | L3F1      |
And I close the current editor


Scenario: SNR41 Umchargieren mit Fremdbeschaffungs-Lieferschein mit umplatz gefuellt und MZ

Given I create a Lot "SNR41_1A" for Product "EK01_SNR"
Given I create a Lot "SNR41_2A" for Product "EK01_SNR"
Given I create a Lot "SNR41_3A" for Product "EK01_SNR"
Given I create a Lot "SNR41_XX" for Product "EK01_SNR"

# SNR40 zubuchen, damit im Zugang verbraucht
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK01_SNR      |
    | buart     | Zugang        |
    | beleg     | LBUZU_SNR41   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | charge2       |
    | 1      | L3F1     | !SNR41_1A^id  |
    | 1      | L3F1     | !SNR41_2A^id  |
    | 1      | L3F1     | !SNR41_3A^id  |
    | 1      | F1       | !SNR41_XX^id  |
And I save the current editor

Given I open an editor "LS_SNR41" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | LIEFCHA1          |
    | such      | LS_SNR41          |
    | ebeleg    | LS_SNR41          |
    | bsart     | Fremdbeschaffung  |
    | umplatz   | L3F1              |
    | vom       | .                 |
    | ueb       | ja                |
And I append rows
    | artikel   | mge | platz   |
    | EK01_SNR  | 3   | F1      |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
# tumcharge ist Abgang
And I modify table
    | !row  | lpsuch | umcharge     | tcharge   |
    | 1     | F1     | !SNR41_1A^id | SNR41_1N  |
    | 2     | F1     | !SNR41_2A^id | SNR41_2N  |
    | 3     | F1     | !SNR41_3A^id |           |
And I set field "charge" to "!SNR41_XX^id" in row 3
Then saving the current editor throws the exception "7043"
And I set field "tcharge" to "SNR41_3N" in row 3
And I save the current editor
And I switch the current editor to editor "LS_SNR41"
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!LS_SNR41^num"
And I press start
Then table has values
    | art       | zmge | amge     | vcharge^id      | vplatz    | tncharge  | nplatz    |
    | EK01_SNR  |      | 1        | !SNR41_1A^id    | L3F1      | SNR41_1N  |           |
    | EK01_SNR  | 1    |          | !SNR41_1A^id    |           | SNR41_1N  | F1        |
    | EK01_SNR  |      | 1        | !SNR41_2A^id    | L3F1      | SNR41_2N  |           |
    | EK01_SNR  | 1    |          | !SNR41_2A^id    |           | SNR41_2N  | F1        |
    | EK01_SNR  |      | 1        | !SNR41_3A^id    | L3F1      | SNR41_3N  |           |
    | EK01_SNR  | 1    |          | !SNR41_3A^id    |           | SNR41_3N  | F1        |
And I close the current editor


Scenario: SNR42 Umchargieren mit EK-Bestellung mit bsart Umlagern

Given I create a Lot "SNR42" for Product "EK02_SNR"

# SNR42 zubuchen, damit im Zugang verbraucht
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK02_SNR      |
    | buart     | Zugang        |
    | beleg     | LBUZU_SNR42   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | charge2   |
    | 1      | F1       | !SNR42^id |
And I save the current editor

Given I open an editor "EKBESNR42" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief  | LIEFCHA1   |
    | such  | BE_SNR42   |
    | bsart | Umlagern   |
    | vom   | .          |
And I append rows
    | artikel   | mge | einplan | platz | abplatz |
    | EK02_SNR  | 1   | ja      | F1    | L3F1    |
And I set field "umcharge" to "!SNR42^id" in row 1
Then field "charge^id" has value "!SNR42^id" in row 1
And I save the current editor

Given I open an editor "LS1_SNR42" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE_SNR42"
And I set fields
   | ebeleg | LS1_SNR42 |
   | such   | LS1_SNR42 |
   | ueb    | nein      |
   | vom    | .         |
And I set field "mge" to "1" in row 1
And I set field "tumcharge" to "SNR42_AB" in row 1
And I set field "charge" to "!SNR42^id" in row 1
# charge wird abgelehnt # 7043 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde zugebucht.
Then saving the current editor throws the exception "7043"
# vorhandene SNR als Abgang verfuegbar, aber nicht als Zugang
And I set field "umcharge" to "!SNR42^id" in row 1
And I set field "tcharge" to "SNR42_NEU" in row 1
And I save the current editor

Given I open an editor "LS1_SNR42" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "LS1_SNR42"
And I set field "ueb" to "ja"
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!LS1_SNR42^num"
And I press start
Then table has values
    | art       | zmge | amge     | vcharge^id  | vplatz    | tncharge  | nplatz    |
    | EK02_SNR  |      | 1        | !SNR42^id   | L3F1      | SNR42_NEU |           |
    | EK02_SNR  | 1    |          | !SNR42^id   |           | SNR42_NEU | F1        |
And I close the current editor


Scenario: SNR43 Umchargieren mit EK-Bestellung mit bsart Umlagern, daraus Lieferschein mit MZ

Given I create a Lot "SNR43_1A" for Product "EK02_SNR"
Given I create a Lot "SNR43_2A" for Product "EK02_SNR"
Given I create a Lot "SNR43_3A" for Product "EK02_SNR"
Given I create a Lot "SNR43_XX" for Product "EK02_SNR"

# SNR zubuchen, damit im Zugang verbraucht
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK02_SNR      |
    | buart     | Zugang        |
    | beleg     | LBUZU_SNR43   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | charge2       |
    | 1      | L3F1     | !SNR43_1A^id  |
    | 1      | L3F1     | !SNR43_2A^id  |
    | 1      | L3F1     | !SNR43_3A^id  |
    | 1      | F1       | !SNR43_XX^id  |
And I save the current editor

Given I open an editor "EKBESNR43" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief  | LIEFCHA1   |
    | such  | BE_SNR43   |
    | bsart | Umlagern   |
    | vom   | .          |
And I append rows
    | artikel   | mge | einplan | platz | abplatz |
    | EK02_SNR  | 3   | ja      | F1    | L3F1    |
And I save the current editor

Given I open an editor "LS1_SNR43" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE_SNR43"
And I set fields
   | ebeleg | LS1_SNR43 |
   | such   | LS1_SNR43 |
   | ueb    | nein      |
   | vom    | .         |
And I set field "mge" to "3" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
# tumcharge ist Abgang
And I modify table
    | !row  | lpsuch | tcharge   | umcharge     |
    | 1     | F1     | SNR43_1N  | !SNR43_1A^id |
    | 2     | F1     | SNR43_2N  | !SNR43_2A^id |
    | 3     | F1     |           | !SNR43_3A^id |
And I set field "charge" to "!SNR43_XX^id" in row 3
Then saving the current editor throws the exception "7043"
And I set field "tcharge" to "SNR43_3N" in row 3
And I save the current editor
And I switch the current editor to editor "LS1_SNR43"
And I save the current editor

Given I open an editor "LS1_SNR43" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "LS1_SNR43"
And I set field "ueb" to "ja"
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!LS1_SNR43^num"
And I press start
Then table has values
    | art       | zmge | amge     | vcharge^id      | vplatz    | tncharge  | nplatz    |
    | EK02_SNR  |      | 1        | !SNR43_1A^id    | L3F1      | SNR43_1N  |           |
    | EK02_SNR  |      | 1        | !SNR43_2A^id    | L3F1      | SNR43_2N  |           |
    | EK02_SNR  |      | 1        | !SNR43_3A^id    | L3F1      | SNR43_3N  |           |
    | EK02_SNR  | 1    |          | !SNR43_1A^id    |           | SNR43_1N  | F1        |
    | EK02_SNR  | 1    |          | !SNR43_2A^id    |           | SNR43_2N  | F1        |
    | EK02_SNR  | 1    |          | !SNR43_3A^id    |           | SNR43_3N  | F1        |
And I close the current editor

# Seriennummer ist nach umchargieren auch fuer Abgang verbraucht
Given I open an editor "SNR43_1A" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR43_1A;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel       | EK02_SNR                  |
    | exnum         | SNR43_1A                  |
    | chverfolgung  | Seriennummernverfolgung   |
    | snabgangverf  | nein                      |
    | snzugangverf  | nein                      |
And I close the current editor

# neue SNR ist nach umbuchen nicht fuer Abgang verbraucht
Given I open an editor "SNR43_1N" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR43_1N;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel       | EK02_SNR                  |
    | exnum         | SNR43_1N                  |
    | chverfolgung  | Seriennummernverfolgung   |
    | snabgangverf  | ja                        |
    | snzugangverf  | nein                      |
And I close the current editor


Scenario: SNR14B Umlagerungsvorschlag freigeben und in Umlagerunglieferschein umchargieren, mit MZ

Given I create a Lot "SNR14B_1A" for Product "EK-UMLAGERSNR"
Given I create a Lot "SNR14B_2A" for Product "EK-UMLAGERSNR"
Given I create a Lot "SNR14B_3A" for Product "EK-UMLAGERSNR"
Given I create a Lot "SNR14B_XX" for Product "EK-UMLAGERSNR"

# SNR40 zubuchen, damit im Zugang verbraucht
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK-UMLAGERSNR |
    | buart     | Zugang        |
    | beleg     | LBU_SNR14B    |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | charge2       |
    | 1      | F1       | !SNR14B_1A^id |
    | 1      | F1       | !SNR14B_2A^id |
    | 1      | F1       | !SNR14B_3A^id |
    | 1      | L3F1     | !SNR14B_XX^id |
And I save the current editor

Given I open an editor "EK-UMLAGERSNR" from table "(Part):(Product)" with command "UPDATE" for record "EK-UMLAGERSNR"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I set field "mindest" to "25" in row 1
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I run Scheduling

# Umlagerungsvorschlag freigeben und in Umlagerungslieferschein umchargieren
Given I open an editor "UML_INT_EXT" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "EK-UMLAGERSNR"
And I set field "lgruppe" to ""
And I press button "ladetab"
Then the table has 1 rows
Then table has values
    | ablgruppe | lgruppe   | fix   |
    | KARLSRUHE | BERLIN    | nein  |
And I set field "mge" to "3" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BE_freigeben"
And I set fields
    | lief  | TEST      |
    | such  | BE_SNR14B |
    | vom   | .         |
And I save the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "BE_SNR14B" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE_SNR14B"
And I set fields
    | ebeleg | LS1-SNR14B   |
    | such   | L1_SNR14B    |
    | vom    | .            |
    | ueb    | ja           |
And I set field "mge" to "3" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
# tumcharge ist Abgang
And I modify table
    | !row  | lpsuch    | tcharge   | umcharge      |
    | 1     | L3F1      | SNR14B_1N | !SNR14B_1A^id |
    | 2     | L3F1      | SNR14B_2N | !SNR14B_2A^id |
    | 3     | L3F1      |           | !SNR14B_3A^id |
And I set field "charge" to "!SNR14B_XX^id" in row 3
Then saving the current editor throws the exception "7043"
And I set field "tcharge" to "SNR14B_3N" in row 3
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Seriennummer ist nach umchargieren auch fuer Abgang verbraucht
Given I open an editor "SNR14B_1A" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR14B_1A;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel       | EK-UMLAGERSNR             |
    | exnum         | SNR14B_1A                 |
    | chverfolgung  | Seriennummernverfolgung   |
    | snabgangverf  | nein                      |
    | snzugangverf  | nein                      |
And I close the current editor

# neue SNR ist nach umbuchen nicht fuer Abgang verbraucht
Given I open an editor "SNR14B_1N" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR14B_1N;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel       | EK-UMLAGERSNR             |
    | exnum         | SNR14B_1N                 |
    | chverfolgung  | Seriennummernverfolgung   |
    | snabgangverf  | ja                        |
    | snzugangverf  | nein                      |
And I close the current editor

Scenario: SNR14C Umlagerungsvorschlag direkt umbuchen nur mit Menge 1, Umbuchen ohne Umchargieren

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK-UMLAGERSNR |
    | buart     | Zugang        |
    | beleg     | ZU_SNR14C     |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | tcharge2  |
    | 1      | F1       | 14C_SNR1  |
    | 1      | F1       | 14C_SNR2  |
    | 1      | F1       | 14C_SNR3  |
    | 1      | F1       | 14C_SNR4  |
And I save the current editor

Given I open an editor "EK-UMLAGERSNR" from table "(Part):(Product)" with command "UPDATE" for record "EK-UMLAGERSNR"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
    | lgruppe   | efrist    | mindest   | bsart     | dispoa            | zuplatz    | abplatz   | umllg        |
    | BERLIN    | 10        | 10        | Umlagern  | bedarfsbezogen    | L3F1       | L3F1      | KARLSRUHE    |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I run Scheduling

# Umlagerungsvorschlag direkt umbuchen nur mit Menge 1 und Angabe SNR moeglich, bereits zugebuchte SNR kann verwendet werden
Given I open an editor "UML_INT_EXT" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "EK-UMLAGERSNR"
And I set field "lgruppe" to ""
And I press button "ladetab"
Then the table has 1 rows
Then table has values
    | ablgruppe | lgruppe   | mge   | fix   |
    | KARLSRUHE | BERLIN    | 4     | nein  |
And I set field "mfreig" to "ja" in row 1
And I set field "beleg" to "UMLS14C"
And I set field "beldat" to "."
And I set field "mge" to "1" in row 1
# 1164 TX=de |Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then pressing button "umbuchen" in row 0 to open a subeditor throws the exception "1164"
And I set field "tcharge" to "14C_SNR1" in row 1
And I press button "umbuchen" to open a subeditor for "direktumbuchen"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "JournalUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK-UMLAGERSNR;buarta==Zugang;platz==L3F1;such==LUMLS14C"
Then fields have values
    | artikel       | EK-UMLAGERSNR         |
    | platz         | L3F1                  |
    | lgruppe       | BERLIN                |
    | mge           | 1                     |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | erfasst               |
    | detursache    | Umlagerungsvorschlag  |
Then field "tncharge" has value "14C_SNR1" in row 1
Then field "tvcharge" has value "14C_SNR1" in row 1
And I close the current editor

Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK-UMLAGERSNR;buarta==Abgang;platz==F1;such==LUMLS14C"
Then fields have values
    | artikel       | EK-UMLAGERSNR         |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 1                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | erfasst               |
    | detursache    | Umlagerungsvorschlag  |
Then field "tncharge" has value "14C_SNR1" in row 1
Then field "tvcharge" has value "14C_SNR1" in row 1
And I close the current editor


Scenario: SNR14D Umlagerungsvorschlag freigeben, Umlagerunglieferschein mit MZ, gleiche SNR im Zu- und Abgang

Given I create a Lot "SNR14D_1A" for Product "EK-UMLAGERSNR"
Given I create a Lot "SNR14D_2A" for Product "EK-UMLAGERSNR"
Given I create a Lot "SNR14D_3A" for Product "EK-UMLAGERSNR"
Given I create a Lot "SNR14D_XX" for Product "EK-UMLAGERSNR"

# SNR40 zubuchen, damit im Zugang verbraucht
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK-UMLAGERSNR |
    | buart     | Zugang        |
    | beleg     | LBU_SNR14D    |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | charge2       |
    | 1      | F1       | !SNR14D_1A^id |
    | 1      | F1       | !SNR14D_2A^id |
    | 1      | F1       | !SNR14D_3A^id |
    | 1      | L3F1     | !SNR14D_XX^id |
And I save the current editor

Given I open an editor "EK-UMLAGERSNR" from table "(Part):(Product)" with command "UPDATE" for record "EK-UMLAGERSNR"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I set field "mindest" to "25" in row 1
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I run Scheduling

# Umlagerungsvorschlag freigeben und in Umlagerungslieferschein umchargieren
Given I open an editor "UML_INT_EXT" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "EK-UMLAGERSNR"
And I set field "lgruppe" to ""
And I press button "ladetab"
Then the table has 1 rows
Then table has values
    | ablgruppe | lgruppe   | fix   |
    | KARLSRUHE | BERLIN    | nein  |
And I set field "mge" to "3" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BE_freigeben"
And I set fields
    | lief  | TEST      |
    | such  | BE_SNR14D |
    | vom   | .         |
And I save the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "BE_SNR14D" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE_SNR14D"
And I set fields
    | ebeleg | LS1-SNR14D   |
    | such   | L1_SNR14D    |
    | vom    | .            |
    | ueb    | ja           |
And I set field "mge" to "3" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
# tumcharge ist Abgang
And I modify table
    | !row  | lpsuch    | tcharge       | umcharge      |
    | 1     | L3F1      | !SNR14D_1A^id | !SNR14D_1A^id |
    | 2     | L3F1      | !SNR14D_2A^id | !SNR14D_2A^id |
    | 3     | L3F1      | !SNR14D_3A^id | !SNR14D_3A^id |
And I save the current subeditor to switch back to the parent editor
And I save the current editor


Scenario: SNR44 Umchargieren nach Umstellen auf Seriennummernverfolgung, wenn Bestand und offene Vorgaenge

Given I open an editor "EINK" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such          | LEER_AUF_SNR      |
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
    | lgruppe   | efrist    | mindest   | bsart     | dispoa            | zuplatz    | abplatz   | umllg        |
    | BERLIN    | 10        | 2         | Umlagern  | bedarfsbezogen    | L3F1       | L3F1      | KARLSRUHE    |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | LEER_AUF_SNR  |
    | buart     | Zugang        |
    | beleg     | LBU_SNR44     |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz2   |
    | 10     | F1       |
And I save the current editor

And I run Scheduling

Given I open an editor "JournalZuLBU" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==LEER_AUF_SNR;buarta==Zugang;platz==F1;such==LLBU_SNR44"
And I close the current editor

Given I open an editor "BE_SNR44" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFCHA2 |
    | such   | BE_SNR44 |
    | ebeleg | BE_SNR44 |
    | bsart  | Umlagern |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel       | mge | platz | abplatz |
    | LEER_AUF_SNR  | 2   | L3F1  | F1      |
And I save the current editor

Given I open an editor "AUF_SNR44" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH1   |
    | such  | AUF_SNR44  |
    | vom   | .          |
And I append rows
    | artikel       | mge | einplan |
    | LEER_AUF_SNR  | 3   | ja      |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | zuomge |
    | 1     | F1     | 2      |
    | +2    | F2     | 1      |
And I save the current editor
And I switch the current editor to editor "AUF_SNR44"
And I save the current editor

Given I open an editor "VKUML_44" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH2  |
    | such  | VKUML_44  |
Then field "umplatz" has value "KONSI2"
And I append rows
    | artikel       | mge  |
    | LEER_AUF_SNR  | 1    |
Then field "tcharge" is empty in row 1
And I save the current editor

Given I open an editor "LEER_AUF_SNR" from table "(Part):(Product)" with command "UPDATE" for record "LEER_AUF_SNR"
And I set fields
    | chverfolgung  | Seriennummernverfolgung |
And I save the current editor

Given I open an editor "AUF_SNR44" from table "(Sales):(SalesOrder)" with command "VIEW" for record "AUF_SNR44"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then table has values
    | !row  | lpsuch | zuomge |
    | 1     | F1     | 2      |
    | 2     | F2     | 1      |
And I close the current editor
And I switch the current editor to editor "AUF_SNR44"
And I close the current editor

Given I open an editor "AUF_SNR44" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AUF_SNR44"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then table has values
    | !row  | lpsuch | zuomge |
    | 1     | F1     | 2      |
    | 2     | F2     | 1      |
# Artikel mit Seriennummernverfolgung darf nur mit Menge und Faktor 1 in Lagereinheit gebucht werden. Vorgang oder MZ prüfen.
Then saving the current editor throws the exception "7039"
And I set field "zuomge" to "1" in row 1
# 3173 de |Bei Seriennummernverfolgung muss die gesamte Menge über die Materialzuordnung zugeordnet werden.
Then saving the current editor throws the exception "3173"
And I modify table
    | !row  | lpsuch | zuomge |
    | +3    | F1     | 1      |
And I save the current editor
And I switch the current editor to editor "AUF_SNR44"
And I save the current editor

Given I open an editor "AUF_SNR44" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AUF_SNR44"
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | tcharge     |
    | 1     | SNR44_1     |
    | 2     | SNR44_2     |
    | 3     | SNR44_3     |
And I save the current editor
And I switch the current editor to editor "AUF_SNR44"
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | LEER_AUF_SNR  |
    | buart     | Umbuchung     |
    | beleg     | LBUM_SNR44    |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | platz2   | tcharge2  |
    | 1      | F1       | F1       | SNR44_1   |
    | 1      | F1       | F1       | SNR44_2   |
# abgehende Charge wird NICHT vorbelegt
Then field "tcharge1" is empty in row 1
Then field "tcharge1" is empty in row 2
And I save the current editor

# Umlagerungsvorschlag freigeben und in Umlagerungslieferschein abgehende Charge leer lassen, da Bestand ohne SNR vorhanden
Given I open an editor "UML_INT_EXT" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "LEER_AUF_SNR"
And I set field "lgruppe" to ""
And I press button "ladetab"
Then the table has 1 rows
Then table has values
    | ablgruppe | lgruppe   | fix   |
    | KARLSRUHE | BERLIN    | nein  |
Then field "mge" has value "2" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BE_freigeben"
And I set fields
    | lief  | TEST      |
    | such  | BE2_SNR44 |
    | vom   | .         |
And I save the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "BE2_SNR44" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE2_SNR44"
And I set fields
    | ebeleg | LS2-SNR44    |
    | such   | LS2_SNR44    |
    | vom    | .            |
    | ueb    | nein         |
And I set field "mge" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
# tumcharge ist Abgang, wird vorbelegt, kann aber leer bleiben
And I modify table
    | !row  | lpsuch    | tcharge           | umcharge  |
    | 1     | L3F1      | SNR44_NEU_UML1    |           |
    | 2     | L3F1      | SNR44_NEU_UML2    |           |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "LS2_SNR44" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "LS2_SNR44"
And I set field "ueb" to "ja"
And I save the current editor

# Umlagerungslieferschein aus der Bestellung mit bsart Umlagern erstellen, abgehende Charge darf leer bleiben
Given I open an editor "LS1_SNR44" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE_SNR44"
And I set fields
   | ebeleg | LS1_SNR44 |
   | such   | LS1_SNR44 |
   | ueb    | nein      |
   | vom    | .         |
And I set field "mge" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | tcharge      |
    | 1     | L3F1   | SNR44_NEU1   |
    | 2     | L3F1   | SNR44_NEU2   |
# tumcharge (ist Abgang) leeren, weil Bestand ohne SNR vorhanden
And I set field "umcharge" to "" in row 1
And I set field "umcharge" to "" in row 2
And I save the current editor
And I switch the current editor to editor "LS1_SNR44"
And I save the current editor

Given I open an editor "LS1_SNR44" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "LS1_SNR44"
And I set field "ueb" to "ja"
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!LS1_SNR44^num"
And I press start
Then table has values
    | art           | zmge | amge     | vcharge | vplatz    | tncharge      | nplatz    |
    | LEER_AUF_SNR  |      | 1        |         | F1        | SNR44_NEU1    |           |
    | LEER_AUF_SNR  |      | 1        |         | F1        | SNR44_NEU2    |           |
    | LEER_AUF_SNR  | 1    |          |         |           | SNR44_NEU1    | L3F1      |
    | LEER_AUF_SNR  | 1    |          |         |           | SNR44_NEU2    | L3F1      |
And I close the current editor

# VK-Umlagerungslieferschein buchen, abgehende Charge darf leer bleiben
Given I open an editor "VKUML_44" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "VKUML_44"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I set field "tumcharge" to "SNR13ANEU" in row 1
# abgehende Charge wird vorbelegt, darf aber leer bleiben
And I set field "charge" to "" in row 1
And I save the current editor


Scenario: SNR45 Nach Storno des Lieferschein kommt Seriennummer wieder in die Warteschlange - Verkauf Auftrag

Given I open an editor "AUFSNR45" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH1   |
    | such  | AUFSNR45   |
    | vom   | .          |
And I append rows
    | artikel   | mge | tcharge   |
    | EK01_SNR  | 1   | SNR45     |
And I save the current editor

# Seriennummer ist im Abgang nicht verfuegbar, da im Auftrag reserviert.
Given I open an editor "ChargeSNR45A" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR45;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel       | EK01_SNR                  |
    | exnum         | SNR45                     |
    | chverfolgung  | Seriennummernverfolgung   |
    | snabgangverf  | nein                      |
    | snaktabgang   | ja                        |
And I close the current editor

Given I open an editor "VK_SNR45" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "AUFSNR45"
And I set fields
    | such   | LS_SNR45 |
    | vom    | .        |
    | ueb    | ja       |
And I set field "mge" to "1" in row 1
And I set field "ueb" to "ja"
And I save the current editor

# Seriennummer ist im Abgang verbraucht und nicht verfuegbar
Given I open an editor "ChargeSNR45B" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR45;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel       | EK01_SNR                  |
    | exnum         | SNR45                     |
    | chverfolgung  | Seriennummernverfolgung   |
    | snabgangverf  | nein                      |
    | snaktabgang   | nein                      |
And I close the current editor

Given I open an editor "STORNOVKRLS" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "VK_SNR45"
And I save the current editor

# Seriennummer ist nach Storno wieder in Warteschlange, da im Auftrag reserviert.
Given I open an editor "ChargeSNR45" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR45;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel       | EK01_SNR                  |
    | exnum         | SNR45                     |
    | chverfolgung  | Seriennummernverfolgung   |
    | snabgangverf  | nein                      |
    | snaktabgang   | ja                        |
And I close the current editor

Scenario: SNR46 Nach Storno des Lieferschein kommt Seriennummer wieder in die Warteschlange - Einkauf Bestellung

Given I open an editor "BESNR46" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFCHA1 |
    | such   | BESNR46  |
    | ebeleg | BESNR46  |
    | vom    | .        |
And I append rows
    | artikel   | mge | tcharge   |
    | EK01_SNR  | 1   | SNR46     |
And I save the current editor

# Seriennummer ist im Zugang nicht verfuegbar, da in Bestellung reserviert.
Given I open an editor "ChargeSNR46A" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR46;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel       | EK01_SNR                  |
    | exnum         | SNR46                     |
    | chverfolgung  | Seriennummernverfolgung   |
    | snzugangverf  | nein                      |
    | snaktzugang   | ja                        |
And I close the current editor

Given I open an editor "VK_SNR46" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BESNR46"
And I set fields
    | such   | LS_SNR46 |
    | ebeleg | LS_SNR46 |
    | vom    | .        |
    | ueb    | ja       |
And I set field "mge" to "1" in row 1
And I set field "ueb" to "ja"
And I save the current editor

# Seriennummer ist im Zugang verbraucht und nicht verfuegbar
Given I open an editor "ChargeSNR46B" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR46;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel       | EK01_SNR                  |
    | exnum         | SNR46                     |
    | chverfolgung  | Seriennummernverfolgung   |
    | snzugangverf  | nein                      |
    | snaktzugang   | nein                      |
And I close the current editor

Given I open an editor "STORNOVKRLS" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "VK_SNR46"
And I save the current editor

# Seriennummer ist nach Storno wieder in Warteschlange, da in Bestellung reserviert.
Given I open an editor "ChargeSNR46" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR46;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel       | EK01_SNR                  |
    | exnum         | SNR46                     |
    | chverfolgung  | Seriennummernverfolgung   |
    | snzugangverf  | nein                      |
    | snaktzugang   | ja                        |
And I close the current editor


Scenario: SNR47 Maskenpruefung bei Seriennummern im Auftrag, nach Teillieferung kann Auftrag mit restlichen Positionen weiter bearbeitet werden

Given I open an editor "AUFSNR47" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH1   |
    | such  | AUFSNR47   |
    | vom   | .          |
And I append rows
    | artikel   | mge | tcharge   |
    | EK01_SNR  | 1   | SNR47     |
    | EINK      | 1   |           |
And I save the current editor

Given I open an editor "LS_SNR47" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "AUFSNR47"
And I set fields
    | such   | LS_SNR47 |
    | vom    | .        |
    | ueb    | ja       |
And I set field "mge" to "1" in row 1
And I save the current editor

Given I open an editor "AUFSNR47" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AUFSNR47"
Then field "limge" has value "0" in row 1
And I save the current editor

Given I open an editor "AUFSNR47" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AUFSNR47"
And I set field "mge" to "2" in row 2
And I save the current editor


Scenario: SNR48 Auftrag zwei Positionen mit gleichem Artikel und gleicher Seriennummer kann nicht gespeichert werden

Given I open an editor "AUFSNR48" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH1   |
    | such  | AUFSNR48   |
    | vom   | .          |
And I append rows
    | artikel   | mge | tcharge   |
    | EK01_SNR  | 1   | SNR48     |
    | EK01_SNR  | 1   | SNR48     |
# 7044 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde abgebucht.
Then saving the current editor throws the exception "7044"
And I set field "tcharge" to "SNR48_2" in row 2
And I save the current editor


Scenario: SNR49 EK-Bestellung zwei Positionen mit gleichem Artikel und gleicher Seriennummer kann nicht gespeichert werden

Given I open an editor "BE_SNR49" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief  | LIEFCHA1   |
    | such  | BE_SNR49   |
    | vom   | .          |
And I append rows
    | artikel   | mge | einplan | tcharge  |
    | EK02_SNR  | 1   | ja      | SNR49    |
    | EK02_SNR  | 1   | ja      | SNR49    |
# 7043 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde abgebucht.
Then saving the current editor throws the exception "7043"
And I set field "tcharge" to "SNR49_2" in row 2
And I save the current editor


Scenario: SNR50 Maskenpruefung bei Seriennummern in EK-Bestellung, nach Teillieferung kann Bestellung mit restlichen Positionen weiter bearbeitet werden

Given I open an editor "BE_SNR50" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief  | LIEFCHA1   |
    | such  | BE_SNR50   |
    | vom   | .          |
And I append rows
    | artikel   | mge | einplan | tcharge  |
    | EK02_SNR  | 1   | ja      | SNR50    |
    | EINK      | 1   | ja      |          |
And I save the current editor

Given I open an editor "LS1_SNR50" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE_SNR50"
And I set fields
   | ebeleg | LS1_SNR50 |
   | such   | LS1_SNR50 |
   | ueb    | ja        |
   | vom    | .         |
And I set field "mge" to "1" in row 1
And I save the current editor

Given I open an editor "EKBESNR50" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE_SNR50"
Then field "limge" has value "0" in row 1
And I save the current editor

Given I open an editor "EKBESNR50" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE_SNR50"
And I set field "mge" to "2" in row 2
And I save the current editor


Scenario: SNR51 Buchungen ohne Gutmenge mit bereits verbrauchter Seriennummer erlaubt
# FBU auf letzten Arbeitsschein oder BA, Rueckmeldung zusaetzliche Entnahme oder Zeitbuchung ohne Gutmenge

Given I create a work order "SNR51" for Product "BG01_SNR" with quantity "3" and search word "SNR51_"

# SNR in ZugangsMZ eintragen
Given I open an editor "BA_SNR51" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SNR51_000"
And I press button "mzsubm" to open a subeditor for "ZugangsMZ"
And I modify table
    | !row  | tcharge   |
    | 1     | SNR51_ZU1 |
    | 2     | SNR51_ZU2 |
    | 3     | SNR51_ZU3 |
And I save the current editor
And I switch the current editor to editor "BA_SNR51"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge      | ztcharge     |
    | 1     | F1     | 1        | SNR51_1.1    | SNR51_ZU1    |
    | 2     | F1     | 1        | SNR51_1.2    | SNR51_ZU2    |
    | 3     | F1     | 1        | SNR51_1.3    | SNR51_ZU3    |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge      | ztcharge     |
    | 1     | F1     | 1        | SNR51_2.1    | SNR51_ZU1    |
    | 2     | F1     | 1        | SNR51_2.2    | SNR51_ZU2    |
    | 3     | F1     | 1        | SNR51_2.3    | SNR51_ZU3    |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_SNR51"
And I save the current editor

# Rueckmeldung auf letzten Arbeitsschein nur Zeit ohne Gutmenge, mit Angabe einer zugehenden Seriennummer ist auch moeglich, wenn es noch KEINE Gutmenge mit dieser SNR gab
Given I open an editor "RM1ZEIT_SNR51" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR51_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | tkcharge  | SNR51_ZU1     |
    | sofort    | ja            |
    | ma        | KARL          |
    | lgr       | 1             |
    | bzeit     | 1             |
    | mzeit     | 1             |
    | bem       | RM_SNR51_Zeit |
And I save the current editor

# Rueckmeldung auf letzten Arbeitsschein mit Angabe einer zugehenden Seriennummer
Given I open an editor "RM1_SNR51" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR51_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | tkcharge  | SNR51_ZU1    |
    | sofort    | ja           |
    | bem       | RM_SNR51     |
And I set field "gutmge" to "1" in row 1
And I save the current editor

# FBU mit bereits verbrauchter zugehender Seriennummer
Given I open an editor "FBU1_SNR51" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | SNR51_002    |
    | autorment | ja           |
    | tcharge   | SNR51_ZU1    |
    | bem       | Entnahme     |
And I press button "stlvblad"
Then table has values
    | elex      | bumge | manbu |
    | EK02_SNR  | 0     | nein  |
And I modify table
    | !row  | manbu | bumge |
    | 1     | ja    | 1     |
# Zugangscharge in der MZ des FV und der Zeile der RES (reszcharge) unterscheiden sich -> Rückfrage
And I respond with answer "ja" to the dialog with id "Widersprüchliche Angaben in Chargen/SN für das Fertigteil in der Materialentnahme und MZ. Trotzdem lt. MZ buchen?"
And I save the current editor

# Rueckmeldung auf letzten Arbeitsschein nur Zeit ohne Gutmenge, mit Angabe einer schon verwendeten zugehenden Seriennummer
Given I open an editor "RM1ZEIT_SNR51" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR51_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | tkcharge  | SNR51_ZU1     |
    | sofort    | ja            |
    | ma        | KARL          |
    | lgr       | 1             |
    | bzeit     | 1             |
    | mzeit     | 1             |
    | bem       | RM_SNR51_Zeit |
And I save the current editor

Given I open an editor "RM2ZEIT_SNR51" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR51_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | tkcharge  | SNR51_ZU1         |
    | sofort    | ja                |
    | ma        | KARL              |
    | lgr       | 1                 |
    | bzeit     | 2                 |
    | mzeit     | 2                 |
    | bem       | RM2_SNR51_Zeit    |
And I save the current editor

# Rueckmeldung auf letzten Arbeitsschein zusätzliche Entnahme ohne Gutmenge, mit Angabe einer schon verwendeten zugehenden Seriennummer
Given I open an editor "RM2_SNR51" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR51_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | tkcharge  | SNR51_ZU1         |
    | sofort    | ja                |
    | bem       | RM_SNR51_Zusatz   |
And I append rows
    | artikel   | mge   |
    | EINK      | 1     |
And I save the current editor

## Rueckmeldung auf BA mit Angabe einer zugehenden Seriennummer (erste Rueckmeldung bucht KEINE Gutmenge, da schon 1 Stueck auf letzten Arbeitsschein)
#Given I open an editor "RMBA_SNR51" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR51_000;@richtung=rückwärts;@maxordtreffer=1"
#And I set fields
#    | tkcharge  | SNR51_ZU2    |
#    | sofort    | ja           |
#    | mgr       | 101          |
#    | bem       | RMBA_SNR51   |
#And I set field "gutmge" to "1" in row 1
#And I save the current editor
#
## Rueckmeldung Zeit auf BA, ohne Gutmenge, mit Angabe einer zugehenden Seriennummer ist auch moeglich, wenn es noch KEINE Gutmenge mit dieser SNR gab
#Given I open an editor "RMBAZEIT_SNR51" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR51_000;@richtung=rückwärts;@maxordtreffer=1"
#And I set fields
#    | tkcharge  | SNR51_ZU2         |
#    | sofort    | ja                |
#    | mgr       | 101               |
#    | ma        | KARL              |
#    | lgr       | 1                 |
#    | bzeit     | 3                 |
#    | mzeit     | 3                 |
#    | bem       | RMBA_SNR51_Zeit   |
#And I save the current editor
#
## Rueckmeldung auf BA mit Angabe einer zugehenden Seriennummer (bucht Gutmenge)
#Given I open an editor "RMBA_SNR51" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR51_000;@richtung=rückwärts;@maxordtreffer=1"
#And I set fields
#    | tkcharge  | SNR51_ZU2    |
#    | sofort    | ja           |
#    | mgr       | 101          |
#    | bem       | RMBA_SNR51   |
#And I set field "gutmge" to "1" in row 1
#And I save the current editor
#
## Rueckmeldung Zeit auf BA, ohne Gutmenge, mit Angabe einer schon verwendeten zugehenden Seriennummer
#Given I open an editor "RMBAZEIT_SNR51" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR51_000;@richtung=rückwärts;@maxordtreffer=1"
#And I set fields
#    | tkcharge  | SNR51_ZU2         |
#    | sofort    | ja                |
#    | mgr       | 101               |
#    | ma        | KARL              |
#    | lgr       | 1                 |
#    | bzeit     | 3                 |
#    | mzeit     | 3                 |
#    | bem       | RMBA_SNR51_Zeit   |
#And I save the current editor
#
## Rueckmeldung auf BA zusätzliche Entnahme ohne Gutmenge, mit Angabe einer schon verwendeten zugehenden Seriennummer
#Given I open an editor "RM2BA_SNR51" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR51_000;@richtung=rückwärts;@maxordtreffer=1"
#And I set fields
#    | tkcharge  | SNR51_ZU2             |
#    | sofort    | ja                    |
#    | mgr       | 101                   |
#    | bem       | RM2BA_SNR51_Zusatz    |
#And I append rows
#    | artikel   | mge   |
#    | TEST      | 1     |
#And I save the current editor

# Buchungen im LJ pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_SNR51^barmex"
And I press start
Then table has values
    | art       | zmge | amge     | tvcharge   | tncharge     |
    | EK02_SNR  |      | 1        | SNR51_2.1  | SNR51_ZU1    |
    | EK01_SNR  |      | 1        | SNR51_1.1  | SNR51_ZU1    |
    | BG01_SNR  | 1    |          |            | SNR51_ZU1    |
    | EK02_SNR  |      | 1        | SNR51_2.2  | SNR51_ZU1    |
    | EINK      |      | 1        |            | SNR51_ZU1    |
#And I set field "beleg" to "!RMBA_SNR51^barmex"
#And I press start
#Then table has values
#    | art       | zmge | amge     | tvcharge   | tncharge     |
#    | EK01_SNR  |      | 1        | SNR51_1.2  | SNR51_ZU2    |
#    | BG01_SNR  | 1    |          |            | SNR51_ZU2    |
#    | TEST      |      | 1        |            | SNR51_ZU2    |
And I close the current editor


Scenario: NACH01 - Nacharbeit kompletter Ablauf, Rueckmeldung nachgearbeitetes Teil auf BA

Given I create a work order "NACH01" for Product "BG01_SNR" with quantity "3" and search word "NACH01_"

Given I create a work order "N01" for Product "BG01_SNR" with quantity "2" and search word "N01_"

Given I open an editor "BA_NACH01" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "NACH01_000"
And I save value from field "lres^id" in row 0
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | 1     | F1     | 1        | NACH01_1.1    |
    | 2     | F1     | 1        | NACH01_1.2    |
    | 3     | F1     | 1        | NACH01_1.3    |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | 1     | F1     | 1        | NACH01_2.1    |
    | 2     | F1     | 1        | NACH01_2.2    |
    | 3     | F1     | 1        | NACH01_2.3    |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_NACH01"
And I save the current editor

# Rueckmeldung auf Arbeitsschein 2
Given I open an editor "RM1_NACH01" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=NACH01_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | tkcharge  | NACH01_ZU1    |
    | bem       | RM1_NACH01    |
And I set field "gutmge" to "1" in row 1
And I set field "erbtext1" to "RM1_NACH01" in row 1
And I save the current editor

Given I open an editor "RM2_NACH01" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=NACH01_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | tkcharge  | NACH01_ZU2    |
    | bem       | RM2_NACH01    |
And I set field "gutmge" to "1" in row 1
And I set field "erbtext1" to "RM2_NACH01" in row 1
And I save the current editor

Given I open an editor "RM3_NACH01" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=NACH01_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | tkcharge  | NACH01_ZU3    |
    | bem       | RM3_NACH01    |
And I set field "gutmge" to "1" in row 1
And I set field "erbtext1" to "RM3_NACH01" in row 1
And I save the current editor

Given I create a SalesOrder "AU_NACH01" for Customer "KUNDECH1" with Product "BG01_SNR" and quantity "3"

Given I open an editor "AU_NACH01" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "AU_NACH01"
And I set fields
    | such   | LS_NACH01    |
    | vom    | .            |
    | ueb    | ja           |
And I set field "mge" to "3" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | tcharge      |
    | 1     | F1     | NACH01_ZU1   |
    | 2     | F1     | NACH01_ZU2   |
    | 3     | F1     | NACH01_ZU3   |
And I save the current editor
And I switch the current editor to editor "AU_NACH01"
And I save the current editor

Given I open an editor "LS_NACH01" from table "(Sales):(PackingSlip)" with command "RETURN" for record "LS_NACH01"
And I set fields
    | such      | RLSNACH01 |
    | ueb       | ja        |
And I set field "mge" to "-1" in row 1
And I set field "platz" to "F1" in row 1
And I save the current editor

Given I open an editor "BA_N01" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "N01_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | 1     | F1     | 1        | N01_1.1   |
    | 2     | F1     | 1        | N01_1.2   |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | 1     | F1     | 1        | N01_2.1   |
    | 2     | F1     | 1        | N01_2.2   |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_N01"
And I save the current editor

# Rueckmeldung auf den anderen BA, nur Teilmenge, zu diesem kann KEIN Nacharbeits-BA erstellt werden, da er noch nicht in der Ablage ist
Given I open an editor "RM1_N01" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=N01_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | tkcharge  | N01_ZU1   |
    | bem       | RM1_N01   |
And I set field "gutmge" to "1" in row 1
And I set field "erbtext1" to "RM1_NACH01" in row 1
And I save the current editor

#Anlegen des Nacharbeits-BA => FV Neu, Artikel eintragen und im Feld vorgaenger die ID des abgelegten FV eintragen
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel   | netmge | mfreig |
    | BG01_SNR  | 1      | ja     |
And I set field "vorgaenger" in row 1 to saved value
# # Wollen Sie Nacharbeit zur Seriennummer starten und den letzten gebuchten Fertigungsvorschlag setzen?
And I respond with answer "ja" to the dialog with id "7047"
And I set field "tcharge" to "NACH01_ZU1" in row 1
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I delete row at position 1
And I delete row at position 1
And I delete row at position 1
Then the table has 1 rows
And I save the current editor
And I switch the current editor to editor "FV"
And I set field "bisuch" to "NACHARBEIT_" in row 1
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Fertigteil ueber FBU zusaetzliche Zeile entnehmen
Given I open an editor "FBU_NACH01" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | NACHARBEIT_000    |
    | mgr       | 101               |
Then field "tcharge" has value "NACH01_ZU1"
And I press button "stlvblad"
And I delete all rows
And I append rows
    | elex      | bumge | tvcharge      |
    | BG01_SNR  | 1     | NACH01_ZU1    |
And I save the current editor

# nachgearbeitetes Fertigteil ueber Rueckmeldung auf den BA wieder zubuchen mit der gleichen SNR
Given I open an editor "RM_NACHARBEIT" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=NACHARBEIT_000;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | mgr       | 101           |
    | bem       | RM_NACHARBEIT |
And I set field "gutmge" to "1" in row 1
And I save the current editor

# nachgearbeitetes Fertigteil mit neuem Lieferschein wieder ausliefern
Given I open an editor "AU_NACH01" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "+AU_NACH01"
And I set fields
    | such   | LS2NACH01    |
    | vom    | .            |
    | ueb    | ja           |
And I set field "mge" to "1" in row 1
And I set field "tcharge" to "NACH01_ZU1" in row 1
And I save the current editor


Scenario: NACH02 - Fehlermeldungen beim Anlegen des Nacharbeits-BA testen und Artikel wird ein zweites Mal nachgearbeitet

Given I open an editor "BG_CHARGE" from table "(Part):(Product)" with command "STORE" for record "BG_CHARGE"
And I set fields
    | such          | BG_CHARGE                     |
    | namebspr      | Baugruppe chargenpflichtig    |
    | chverfolgung  | Chargenverfolgung             |
And I save the current editor

Given I create a work order "N02" for Product "BG01_SNR" with quantity "2" and search word "N02_"

Given I open an editor "BA_N02" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "N02_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | 1     | F1     | 1        | N02_1.1   |
    | 2     | F1     | 1        | N02_1.2   |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | 1     | F1     | 1        | N02_2.1   |
    | 2     | F1     | 1        | N02_2.2   |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_N02"
And I save the current editor

# Rueckmeldung nur Teilmenge, zu diesem kann KEIN Nacharbeits-BA erstellt werden, da er noch nicht in der Ablage ist
Given I open an editor "RM1_N02" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=N02_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | tkcharge  | N02_ZU1   |
    | bem       | RM1_N02   |
And I set field "gutmge" to "1" in row 1
And I set field "erbtext1" to "RM1_NACH01" in row 1
And I save the current editor

Given I open an editor "BA_N02" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "N02_000"
And I save value from field "lres^id" in row 0
And I close the current editor

# zu FV der nicht abgelegt ist, kann kein Nacharbeits-BA erstellt werden
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel   | netmge | mfreig |
    | BG01_SNR  | 1      | ja     |
# Nacharbeit nur für einen abgelegten Fertigungsvorschlag gleichen Artikels mit Seriennummerverfolgung erlaubt.
Then setting field "vorgaenger" to "!BA_N02^lres^id" in row 1 throws the exception "7046"
And I close the current editor

# Rueckmeldung, damit BA abgelegt wird
Given I open an editor "RM2_N02" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=N02_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | tkcharge  | N02_ZU2   |
    | bem       | RM2_N02   |
And I set field "gutmge" to "1" in row 1
And I set field "erbtext1" to "RM2_NACH01" in row 1
And I save the current editor

# Lieferschein und Rücklieferschein erstellen
Given I create a SalesOrder "AU_N02" for Customer "KUNDECH1" with Product "BG01_SNR" and quantity "1"
Given I open an editor "AU_N02" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "AU_N02"
And I set fields
    | such   | LS_N02    |
    | vom    | .         |
    | ueb    | ja        |
And I set field "mge" to "1" in row 1
And I set field "tcharge" to "N02_ZU1" in row 1
And I save the current editor

Given I open an editor "LS_N02" from table "(Sales):(PackingSlip)" with command "RETURN" for record "LS_N02"
And I set fields
    | such      | RLSN02 |
    | ueb       | ja     |
And I set field "mge" to "-1" in row 1
And I set field "platz" to "F1" in row 1
And I save the current editor

Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel      | netmge | mfreig |
    | BG_CHARGE    | 1      | ja     |
Then field "vorgaenger" is not modifiable in row 1
And I set field "artikel" to "EK01_SNR" in row 1
# Nacharbeit nur für einen abgelegten Fertigungsvorschlag gleichen Artikels mit Seriennummerverfolgung erlaubt.
Then setting field "vorgaenger" in row 1 to saved value throws the exception "7046"
And I set field "artikel" to "BG01_SNR" in row 1
And I set field "vorgaenger" in row 1 to saved value
# 7057 TX=de |Seriennummer in der Nacharbeit fehlt oder wurde nicht mit dem Vorgänger gebucht.
Then saving the current editor throws the exception "7057"
# Wollen Sie Nacharbeit zur Seriennummer starten und den letzten gebuchten Fertigungsvorschlag setzen?
And I respond with answer "ja" to the dialog with id "7047"
And I set field "tcharge" to "N02_ZU1" in row 1
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I delete row at position 1
And I delete row at position 1
And I delete row at position 1
Then the table has 1 rows
And I save the current editor
And I switch the current editor to editor "FV"
And I set field "bisuch" to "NACHARBEIT02_" in row 1
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "BA_NACHARBEIT02" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "NACHARBEIT02_000"
And I save value from field "lres^id" in row 0
And I close the current editor

# nachgearbeitetes Fertigteil ueber Rueckmeldung auf den BA wieder zubuchen mit der gleichen SNR
Given I open an editor "RM_NACHARBEIT" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=NACHARBEIT02_000;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja                |
    | mgr       | 101               |
    | bem       | RM_NACHARBEIT02   |
And I set field "gutmge" to "1" in row 1
# 7065 TX=de |Seriennummerbestand für Nacharbeit ist falsch. Bei Storno oder Buchen RM_Nacharbeit nur Menge 0 sonst nur -1.0 oder 1.0 erlaubt
Then saving the current editor throws the exception "7065"
And I close the current editor

# Fertigteil ueber FBU zusaetzliche Zeile entnehmen
Given I open an editor "FBU_NACH01" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | NACHARBEIT02_000  |
    | mgr       | 101               |
Then field "tcharge" has value "N02_ZU1"
And I press button "stlvblad"
And I delete all rows
And I append rows
    | elex      | bumge | tvcharge  |
    | BG01_SNR  | 1     | N02_ZU1   |
And I save the current editor

Given I open an editor "RM_NACHARBEIT" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=NACHARBEIT02_000;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort        | ja                |
    | stornorest    | ja                |
    | mgr           | 101               |
    | bem           | RM_NACHARBEIT02   |
And I set field "gutmge" to "1" in row 1
And I save the current editor

Given I open an editor "AU_N02" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "+AU_N02"
And I set fields
    | such   | LS_N02NEU    |
    | vom    | .            |
    | ueb    | ja           |
And I set field "mge" to "1" in row 1
And I set field "tcharge" to "N02_ZU1" in row 1
And I save the current editor

# Artikel wird ein zweites Mal zurueckgeliefert und nachgearbeitet
Given I open an editor "LS_N02NEU" from table "(Sales):(PackingSlip)" with command "RETURN" for record "LS_N02NEU"
And I set fields
    | such      | RLSN02NEU |
    | ueb       | ja        |
And I set field "mge" to "-1" in row 1
And I set field "platz" to "F1" in row 1
And I save the current editor

Given I open an editor "N02_ZU1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=N02_ZU1;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

# Vorgaenger ist jetzt der Fertigungsvorschlag zum Nacharbeits-BA
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel      | netmge | mfreig |
    | BG01_SNR     | 1      | ja     |
# Wollen Sie Nacharbeit zur Seriennummer starten und den letzten gebuchten Fertigungsvorschlag setzen?
And I respond with answer "ja" to the dialog with id "7047"	
And I set field "charge" to "!N02_ZU1^id" in row 1
Then field "vorgaenger^id" in row 1 equals saved value
And I set field "bisuch" to "NACH02_NEU_" in row 1
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "FBU_NACH02_NEU" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | NACH02_NEU_000    |
    | mgr       | 101               |
Then field "tcharge" has value "N02_ZU1"
And I press button "stlvblad"
And I delete all rows
And I append rows
    | elex      | bumge | tvcharge  |
    | BG01_SNR  | 1     | N02_ZU1   |
And I save the current editor

Given I open an editor "RM_NACHARBEIT" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=NACH02_NEU_000;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja                |
    | mgr       | 101               |
    | bem       | RM_NACH02_NEU     |
And I set field "gutmge" to "1" in row 1
And I save the current editor

Given I open an editor "AU_N02" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "+AU_N02"
And I set fields
    | such   | LS_N02NA2    |
    | vom    | .            |
    | ueb    | ja           |
And I set field "mge" to "1" in row 1
And I set field "tcharge" to "N02_ZU1" in row 1
And I save the current editor


Scenario: NACH03 - Nacharbeit mit MZ, Menge im Nacharbeits-BA ist groesser 1, Rueckmeldung nachgearbeitetes Teil auf letzten Arbeitsschein

Given I create a work order "NACH03" for Product "BG01_SNR" with quantity "3" and search word "NACH03_"

Given I open an editor "BA_NACH03" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "NACH03_000"
And I save value from field "lres^id" in row 0
And I press button "mzsubm" to open a subeditor for "ZugangsMZ"
And I modify table
    | !row  | tcharge       |
    | 1     | NACH03_ZU1    |
    | 2     | NACH03_ZU2    |
    | 3     | NACH03_ZU3    |
And I save the current editor
And I switch the current editor to editor "BA_NACH03"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | 1     | F1     | 1        | NACH03_1.1    |
    | 2     | F1     | 1        | NACH03_1.2    |
    | 3     | F1     | 1        | NACH03_1.3    |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | 1     | F1     | 1        | NACH03_2.1    |
    | 2     | F1     | 1        | NACH03_2.2    |
    | 3     | F1     | 1        | NACH03_2.3    |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_NACH03"
And I save the current editor

# Rueckmeldung auf Arbeitsschein 2
Given I open an editor "RM1_NACH03" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=NACH03_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | gut       | ja            |
    | bem       | RM1_NACH03    |
And I set field "erbtext1" to "RM1_NACH03" in row 1
And I save the current editor

Given I create a SalesOrder "AU_NACH03" for Customer "KUNDECH1" with Product "BG01_SNR" and quantity "3"

Given I open an editor "AU_NACH03" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "AU_NACH03"
And I set fields
    | such   | LS_NACH03    |
    | vom    | .            |
    | ueb    | ja           |
And I set field "mge" to "3" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | tcharge      |
    | 1     | F1     | NACH03_ZU1   |
    | 2     | F1     | NACH03_ZU2   |
    | 3     | F1     | NACH03_ZU3   |
And I save the current editor
And I switch the current editor to editor "AU_NACH03"
And I save the current editor

Given I open an editor "LS_NACH03" from table "(Sales):(PackingSlip)" with command "RETURN" for record "LS_NACH03"
And I set fields
    | such      | RLSNACH03 |
    | ueb       | ja        |
And I set field "mge" to "-3" in row 1
And I set field "platz" to "F1" in row 1
And I save the current editor

# Anlegen des Nacharbeits-BA mit ZugangsMZ
Given I open an editor "FV_NACH03" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel   | netmge | mfreig |
    | BG01_SNR  | 3      | ja     |
And I set field "vorgaenger" in row 1 to saved value
# MZ anlegen
And I press button "mzsubm" to open a subeditor for "ZugangsMZ" in row 1
And I modify table
    | !row  | lpsuch | tcharge       |
    | 1     | F1     | NACH03_ZU1    |
    | 2     | F1     | NACH03_ZU2    |
    | 3     | F1     | NACH03_ZU3    |
And I save the current editor
And I switch the current editor to editor "FV_NACH03"
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I delete row at position 1
And I delete row at position 1
And I delete row at position 1
Then the table has 1 rows
And I save the current editor
And I switch the current editor to editor "FV_NACH03"
And I set field "bisuch" to "NACHARBEIT03_" in row 1
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Fertigteil ueber FBU zusaetzliche Zeile entnehmen, MZ nicht moeglich, mehrere Zeilen anlegen
Given I open an editor "FBU_NACH03" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | NACHARBEIT03_000  |
    | mgr       | 101               |
And I press button "stlvblad"
And I delete all rows
And I append rows
    | elex      | bumge | tvcharge      |
    | BG01_SNR  | 1     | NACH03_ZU1    |
    | BG01_SNR  | 1     | NACH03_ZU2    |
    | BG01_SNR  | 1     | NACH03_ZU3    |
And I save the current editor

# nachgearbeitetes Fertigteil ueber Rueckmeldung auf den letzten Arbeitsschein wieder zubuchen, MZ ist vorhanden
Given I open an editor "RM_NACHARBEIT03" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=NACHARBEIT03_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja                |
    | gut       | ja                |
    | bem       | RM_NACHARBEIT03   |
And I save the current editor

Given I open an editor "AU_NACH03" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "+AU_NACH03"
And I set fields
    | such   | LS_NA3NEU    |
    | vom    | .            |
    | ueb    | ja           |
And I set field "mge" to "3" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | tcharge      |
    | 1     | F1     | NACH03_ZU1   |
    | 2     | F1     | NACH03_ZU2   |
    | 3     | F1     | NACH03_ZU3   |
And I save the current subeditor to switch back to the parent editor
And I save the current editor


Scenario: NACH04 - Nacharbeit. Keine Fehlermeldung, wenn der Fertigartikel in der Nacharbeit gar nicht mehr entnommen wird
#ABS-740: Falsche Meldung bei Entnahme von Material zu NacharbeitsBA
Given I create a work order "NACH04" for Product "BG01_SNR" with quantity "2" and search word "NACH04_"

Given I open an editor "BA_NACH04" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "NACH04_000"
And I save value from field "lres^id" in row 0
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | 1     | F1     | 1        | NACH04_1.1    |
    | 2     | F1     | 1        | NACH04_1.2    |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | 1     | F1     | 1        | NACH04_2.1    |
    | 2     | F1     | 1        | NACH04_2.2    |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_NACH04"
And I save the current editor

# FBU auf Arbeitsschein 2
Given I open an editor "FBU_NACH04_1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag     | NACH04_002 |
    | gmgevorschl | 1          |
    | tcharge     | NACH04_ZU1 |
And I press button "stllad"
Then the table has 2 rows
And I save the current editor

Given I open an editor "FBU_NACH04_2" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag     | NACH04_002 |
    | gmgevorschl | 1          |
    | tcharge     | NACH04_ZU2 |
And I press button "stllad"
Then the table has 2 rows
And I save the current editor

# Rueckmeldung auf Arbeitsschein 2
Given I open an editor "RM1_NACH04" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=NACH04_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | tkcharge  | NACH04_ZU1    |
    | bem       | RM1_NACH04    |
And I set field "gutmge" to "1" in row 1
And I set field "erbtext1" to "RM1_NACH04" in row 1
And I save the current editor

Given I open an editor "RM2_NACH04" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=NACH04_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | tkcharge  | NACH04_ZU2    |
    | bem       | RM2_NACH04    |
And I set field "gutmge" to "1" in row 1
And I set field "erbtext1" to "RM2_NACH04" in row 1
And I save the current editor

Given I create a SalesOrder "AU_NACH04" for Customer "KUNDECH1" with Product "BG01_SNR" and quantity "2"

Given I open an editor "AU_NACH04" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "AU_NACH04"
And I set fields
    | such   | LS_NACH04    |
    | vom    | .            |
    | ueb    | ja           |
And I set field "mge" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | tcharge      |
    | 1     | F1     | NACH04_ZU1   |
    | 2     | F1     | NACH04_ZU2   |
And I save the current editor
And I switch the current editor to editor "AU_NACH04"
And I save the current editor

Given I open an editor "LS_NACH04" from table "(Sales):(PackingSlip)" with command "RETURN" for record "LS_NACH04"
And I set fields
    | such      | RLSNACH04 |
    | ueb       | ja        |
And I set field "mge" to "-1" in row 1
And I set field "platz" to "F1" in row 1
And I save the current editor

#Anlegen des Nacharbeits-BA => FV Neu, Artikel eintragen und im Feld vorgaenger die ID des abgelegten FV eintragen
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel   | netmge | mfreig |
    | BG01_SNR  | 1      | ja     |
And I set field "vorgaenger" in row 1 to saved value
# # Wollen Sie Nacharbeit zur Seriennummer starten und den letzten gebuchten Fertigungsvorschlag setzen?
And I respond with answer "ja" to the dialog with id "7047"
And I set field "tcharge" to "NACH04_ZU1" in row 1
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I press button "setmanbu"
And I save the current editor
And I switch the current editor to editor "FV"
And I set field "bisuch" to "NACH04-2_" in row 1
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Fertigteil ueber FBU zusaetzliche Zeile entnehmen
Given I open an editor "FBU_NACH04-2.1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | NACH04-2_000      |
    | mgr       | 101               |
Then field "tcharge" has value "NACH04_ZU1"
And I press button "stllad"
Then the table has 2 rows
And I delete all rows
And I append rows
    | elex      | bumge | tvcharge      |
    | BG01_SNR  | 1     | NACH04_ZU1    |
And I save the current editor

# Erneute Entnahme ueber FBU. Fertigteil wird mit Menge 0 vorgeschlagen, Entnahmeteile mit Menge 1.
Given I open an editor "FBU_NACH04-2.2" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | NACH04-2_000      |
    | mgr       | 101               |
Then field "tcharge" has value "NACH04_ZU1"
And I press button "stllad"
Then the table has 3 rows
Then table has values
    | mge   | elex     | buplatz | treszcharge |
    | 1     | EK01_SNR |  F1     | NACH04_ZU1  |
    | 1     | EK02_SNR |  F1     | NACH04_ZU1  |
    | 0     | BG01_SNR |  F1     |             |
And I modify table
    | !row  | tvcharge     |
    | 1     | NACH04_1.3   |
    | 2     | NACH04_2.3   |
And I save the current editor

# nachgearbeitetes Fertigteil ueber Rueckmeldung auf den BA wieder zubuchen mit der gleichen SNR
Given I open an editor "RM_NACH04-2.1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=NACH04-2_000;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | mgr       | 101           |
    | bem       | RM_NACHARBEIT |
And I set field "gutmge" to "1" in row 1
And I save the current editor

# nachgearbeitetes Fertigteil mit neuem Lieferschein wieder ausliefern
Given I open an editor "AU_NACH04" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "+AU_NACH04"
And I set fields
    | such   | LS2NACH04    |
    | vom    | .            |
    | ueb    | ja           |
And I set field "mge" to "1" in row 1
And I set field "tcharge" to "NACH04_ZU1" in row 1
And I save the current editor


Scenario: SNR52 Seriennummer erneut verwenden bei der manuellen Lagerbuchung

Given I create a Lot "SNR52_1" for Product "EK02_SNR"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK02_SNR      |
    | buart     | Zugang        |
    | beleg     | LBUZ1_SNR52   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | charge2       |
    | 1      | F1       | !SNR52_1^id   |
# bei unverbrauchter SNR darf Haken nicht setzbar sein
Then field "snerneutverwend" is not modifiable in row 1
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK02_SNR      |
    | buart     | Abgang        |
    | beleg     | LBUA1_SNR52   |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | charge1       |
    | 1      | F1       | !SNR52_1^id   |
# bei unverbrauchter SNR darf Haken nicht setzbar sein
Then field "snerneutverwend" is not modifiable in row 1
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK02_SNR      |
    | buart     | Zugang        |
    | beleg     | LBUZ2_SNR52   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | charge2       |
    | 1      | F1       | !SNR52_1^id   |
# 7043 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde zugebucht.
Then saving the current editor throws the exception "7043"
And I set field "snerneutverwend" to "ja" in row 1
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK02_SNR      |
    | buart     | Zugang        |
    | beleg     | LBUZ3_SNR52   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | charge2       |
    | 1      | F1       | !SNR52_1^id   |
# verbrauchte SNR darf nicht wieder zubuchbar sein, wenn bereits an Lager
Then field "snerneutverwend" is not modifiable in row 1
# 7043 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde zugebucht.
Then saving the current editor throws the exception "7043"
And I close the current editor

# verbrauchte SNR erneut abbuchen
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK02_SNR      |
    | buart     | Abgang        |
    | beleg     | LBUA2_SNR52   |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | charge1       |
    | 1      | F1       | !SNR52_1^id   |
# 7044 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde abgebucht.
Then saving the current editor throws the exception "7044"
And I set field "snerneutverwend" to "ja" in row 1
And I save the current editor


Scenario: SNR53 Seriennummer erneut verwenden bei der Bestandskorrektur

# verbrauchte SNR aus vorherigem Scenario wieder zubuchen ueber Bestandskorrektur
Given I open an editor "SNR52_1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR52_1;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

# positive Bestandskorrektur
Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | EK02_SNR    |
    | beleg     | KORR_SNR53  |
    | beldat    | .           |
And I set field "platz" to "F3" in row 1
Then the table has 1 rows
Then table has values
    | mge   | charge1   |
    | 0     |           |
And I modify table
    | !row  | mge   | tcharge1      |
    | 1     | 1     | NEUESNR_53    |
Then field "snerneutverwend" is not modifiable in row 1
And I modify table
    | !row  | charge1       |
    | 1     | !SNR52_1^id   |
# 7043 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde zugebucht.
Then saving the current editor throws the exception "7043"
And I set field "snerneutverwend" to "ja" in row 1
And I save the current editor

# negative Bestandskorrektur
Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | EK02_SNR    |
    | beleg     | KORR2_SNR53 |
    | beldat    | .           |
And I set field "platz" to "F3" in row 1
Then the table has 1 rows
Then table has values
    | mge   | charge1^id    |
    | 1     | !SNR52_1^id   |
And I modify table
    | !row  | mge   |
    | 1     | 0     |
# 7044 TX=de |Diese Seriennummer wird im anderen Vorgang schon verwendet oder wurde abgebucht.
Then saving the current editor throws the exception "7044"
And I set field "snerneutverwend" to "ja" in row 1
And I save the current editor
