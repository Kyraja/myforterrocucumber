@persistent
Feature: Chargenrein.feature

Background:
And I set the fake date to "16.01.1995"

# **********************************************************************************
#  Name             : Chargenrein.feature
#  Autor            : bschiga
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Chargen-/Seriennummernverwaltung
#  ref              : ref_chargen_seriennr_cu
#
# **********************************************************************************

Scenario: R01 Chargenrein setzen in der Fertigungsliste

Given I open an editor "EINK" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such              | MAT_CHA_REIN      |
    | chverfolgung      | Chargenverfolgung |
    | chargenreinstd    | ja                |
And I set field "chimlager" to "ja"
And I save the current editor

Given I open an editor "BG_CHA_REIN_MANBU" from table "(Part):(Product)" with command "UPDATE" for record "BG_CHA_REIN_MANBU"
And I create a new row at position 1
And I set field "elex" to "EINK" in row 1
Then field "chargenrein" has value "nein" in row 1
Then field "chargenrein" is not modifiable in row 1
And I delete row at position 1
And I create a new row at position 1
And I set field "elex" to "MAT_CHA_REIN" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "manbu" to "ja" in row 1
Then field "chargenrein" has value "ja" in row 1
Then field "chargenrein" is modifiable in row 1
And I save the current editor

Given I create a work order "R01" for Product "BG_CHA_REIN_MANBU" with quantity "10" and search word "R01_"

Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "R01_000"
And I press button "absteig" to open a subeditor for "AFL"
Then field "chargenrein" is modifiable in row 1
And I set field "chargenrein" to "nein" in row 1
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "R01_000"
And I press button "absteig" to open a subeditor for "AFL"
And I set field "chargenrein" to "ja" in row 1
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "RM1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=R01_001;@richtung=rückwärts;@maxordtreffer=1"
And I set field "sofort" to "ja"
And I set field "gutmge" to "5" in row 1
And I save the current editor

Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "R01_000"
And I press button "absteig" to open a subeditor for "AFL"
Then field "chargenrein" has value "ja" in row 1
Then field "chargenrein" is modifiable in row 1
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "FBU_R01" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | R01_001   |
    | bem       | Entnahme  |
And I press button "stlvblad"
Then table has values
    | elex          | bumge | manbu |
    | MAT_CHA_REIN  | 10    | ja    |
And I set field "ljtext1" to "FBU_R01" in row 1
And I set field "tvcharge" to "01rein" in row 1
And I save the current editor

Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "R01_000"
And I press button "absteig" to open a subeditor for "AFL"
Then field "chargenrein" has value "ja" in row 1
And I set field "chargenrein" to "nein" in row 1
Then field "chargenrein" is not modifiable in row 1
And I save the current subeditor to switch back to the parent editor
And I save the current editor


Scenario: R02 BA ohne EntnahmeMZ, FBU mit abweichender Charge nicht moeglich

Given I create a work order "R02" for Product "BG_CHA_REIN_MANBU" with quantity "10" and search word "R02_"

Given I open an editor "FBU_R02" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | R02_001   |
    | bem           | Entnahme  |
    | gmgevorschl   | 5         |
And I press button "stlvblad"
Then table has values
    | elex          | bumge | manbu |
    | MAT_CHA_REIN  | 5     | ja    |
And I set field "ljtext1" to "FBU_R02" in row 1
And I set field "tvcharge" to "02rein" in row 1
And I save the current editor

Given I open an editor "FBU2_R02" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | R02_001   |
    | bem       | Entnahme  |
And I press button "stlvblad"
Then table has values
    | elex          | bumge | manbu |
    | MAT_CHA_REIN  | 5     | ja    |
And I set field "bumge" to "5" in row 1
And I set field "ljtext1" to "FBU2_R02" in row 1
Then field "tvcharge" is not modifiable in row 1
Then field "rescharge" is not modifiable in row 1
Then field "tvcharge" has value "02rein" in row 1
And I save the current editor

# Charge oeffnen um Zugriff auf die ID zu haben
Given I open an editor "Charge02rein" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=02rein;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | 02rein    |
    | eigcharge | nein      |
And I close the current editor

# gebuchte Materialentnahme oeffnen um Zugriff auf Belegnummer barmex zu haben
Given I open an editor "FBUBELEG" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=R02_001;bem=Entnahme;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "barmex" in row 0
And I close the current editor

# Buchungen im LJ pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" in row 0 to saved value
And I set field "artikel" to "MAT_CHA_REIN"
And I press start
Then table has values
    | zmge | amge     | tvcharge  | vcharge^id          | vplatz    |
    |      |  5       | 02rein    | !Charge02rein^id    | F1        |
    |      |  5       | 02rein    | !Charge02rein^id    | F1        |
And I close the current editor


Scenario: R03 BA mit EntnahmeMZ, Aenderung der Charge wird in alle Zeilen uebertragen

Given I create a work order "R03" for Product "BG_CHA_REIN_MANBU" with quantity "20" and search word "R03_"

Given I open an editor "BAR03" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "R03_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | +1    | F1     | 15       | 03rein        |
    | +2    | F2     | 5        | !dontChange   |
And I save the current editor
And I switch the current editor to editor "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
Then field "tcharge" has value "03rein" in row 2
And I set field "tcharge" to "04rein" in row 2
And I respond with answer "ja" to the dialog with id "Hinweis"
And I save the current editor
And I switch the current editor to editor "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
Then field "tcharge" has value "04rein" in row 1
Then field "tcharge" has value "04rein" in row 2
And I close the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BAR03"
And I save the current editor

Given I open an editor "FBU_R03" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | R03_001   |
    | bem           | FBU_R03   |
    | tcharge       | R03_ZU1   |
And I press button "stlvblad"
Then table has values
    | elex          | bumge | manbu |
    | MAT_CHA_REIN  | 20    | ja    |
And I set field "bumge" to "5" in row 1
Then field "tvcharge" is not modifiable in row 1
Then field "rescharge" is not modifiable in row 1
Then field "tvcharge" has value "04rein" in row 1
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I delete row at position 1
Then field "tcharge" has value "04rein" in row 1
And I set field "tcharge" to "03rein" in row 1
And I save the current editor
And I switch the current editor to editor "FBU_R03"
And I set field "ljtext1" to "FBU_R03" in row 1
And I save the current editor

Given I open an editor "FBU2_R03" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | R03_001   |
    | bem       | Entnahme  |
    | tcharge   | R03_ZU2   |
And I press button "stlvblad"
Then table has values
    | elex          | bumge | manbu |
    | MAT_CHA_REIN  | 15    | ja    |
And I set field "ljtext1" to "FBU2_R03" in row 1
Then field "tvcharge" is not modifiable in row 1
Then field "rescharge" is not modifiable in row 1
Then field "tvcharge" has value "03rein" in row 1
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
Then field "tcharge" has value "03rein" in row 1
Then field "tcharge" is not modifiable in row 1
Then field "charge" is not modifiable in row 1
And I save the current editor
And I switch the current editor to editor "FBU2_R03"
And I save the current editor

# Charge oeffnen um Zugriff auf die ID zu haben
Given I open an editor "Charge03rein" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=03rein;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | 03rein    |
    | eigcharge | nein      |
And I close the current editor

# gebuchte Materialentnahme oeffnen um Zugriff auf Belegnummer barmex zu haben
Given I open an editor "FBUBELEG" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=R03_001;bem=FBU_R03;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "barmex" in row 0
And I close the current editor

# Buchungen im LJ pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" in row 0 to saved value
And I set field "artikel" to "MAT_CHA_REIN"
And I press start
Then table has values
    | zmge | amge     | tvcharge  | vcharge^id          | vplatz    |
    |      |  5       | 03rein    | !Charge03rein^id    | F2        |
    |      | 15       | 03rein    | !Charge03rein^id    | F1        |
And I close the current editor


Scenario: R04 BA mit EntnahmeMZ, Menge erhoehen in FBU, nachdem MZ bereits voll entnommen

Given I create a work order "R04" for Product "BG_CHA_REIN_MANBU" with quantity "20" and search word "R04_"

Given I open an editor "BAR04" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "R04_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | +1    | F1     | 15       | 04rein        |
    | +2    | F1     | 5        | !dontChange   |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BAR04"
And I save the current editor

# Materialentnahme Komplettmenge
Given I open an editor "FBU_R04" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | R04_001   |
    | bem       | FBU_R04   |
And I press button "stlvblad"
Then table has values
    | elex          | bumge | manbu |
    | MAT_CHA_REIN  | 20    | ja    |
And I set field "ljtext1" to "FBU_R04" in row 1
And I save the current editor

# in MZ absteigen, Charge ist vorbelegt, keine Aenderung, mit Speichern verlassen
Given I open an editor "FBU2_R04" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | R04_001   |
    | bem       | Entnahme  |
And I press button "stlvblad"
Then table has values
    | elex          | bumge | manbu |
    | MAT_CHA_REIN  | 0     | ja    |
And I set field "ljtext1" to "FBU2_R04" in row 1
And I set field "bumge" to "1" in row 1
Then field "tvcharge" has value "04rein" in row 1
Then field "tvcharge" is not modifiable in row 1
Then field "rescharge" is not modifiable in row 1
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
Then field "tcharge" has value "04rein" in row 1
Then field "tcharge" is not modifiable in row 1
Then field "charge" is not modifiable in row 1
And I save the current editor
And I switch the current editor to editor "FBU2_R04"
Then field "tvcharge" has value "04rein" in row 1
Then field "tvcharge" is not modifiable in row 1
Then field "rescharge" is not modifiable in row 1
And I save the current editor

# MZ mit Abbruch verlassen, Charge bleibt erhalten und es kann gebucht werden
Given I open an editor "FBU3_R04" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | R04_001   |
    | bem       | Entnahme3 |
And I press button "stlvblad"
Then table has values
    | elex          | bumge | manbu |
    | MAT_CHA_REIN  | 0     | ja    |
And I set field "bumge" to "1" in row 1
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
Then field "tcharge" has value "04rein" in row 1
Then field "tcharge" is not modifiable in row 1
Then field "charge" is not modifiable in row 1
# mit Abbruch verlassen, Charge bleibt erhalten und es wird gebucht mit Charge
And I close the current editor
And I switch the current editor to editor "FBU3_R04"
Then field "tvcharge" has value "04rein" in row 1
Then field "tvcharge" is not modifiable in row 1
Then field "rescharge" is not modifiable in row 1
And I save the current editor

# Charge oeffnen um Zugriff auf die ID zu haben
Given I open an editor "Charge04rein" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=04rein;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | 04rein    |
    | eigcharge | nein      |
And I close the current editor

# gebuchte Materialentnahme oeffnen um Zugriff auf Belegnummer barmex zu haben
Given I open an editor "FBUBELEG" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=R04_001;bem=FBU_R04;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "barmex" in row 0
And I close the current editor

# Buchungen im LJ pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" in row 0 to saved value
And I set field "artikel" to "MAT_CHA_REIN"
And I press start
Then table has values
    | zmge | amge     | tvcharge  | vcharge^id          | vplatz    |
    |      | 15       | 04rein    | !Charge04rein^id    | F1        |
    |      |  5       | 04rein    | !Charge04rein^id    | F1        |
    |      |  1       | 04rein    | !Charge04rein^id    | F1        |
    |      |  1       | 04rein    | !Charge04rein^id    | F1        |
And I close the current editor


Scenario: R05 BA mit EntnahmeMZ, zusaetzliche Entnahme in der FBU

Given I create a work order "R05" for Product "BG_CHA_REIN_MANBU" with quantity "20" and search word "R05_"

Given I open an editor "BAR05" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "R05_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | +1    | F1     | 10       | 05rein        |
    | +2    | F2     | 10       | !dontChange   |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BAR05"
And I save the current editor

# Materialentnahme Komplettmenge und zusaetzliche Entnahme
Given I open an editor "FBU_R05" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | R05_001   |
    | bem       | FBU_R05   |
And I press button "stlvblad"
Then table has values
    | elex          | bumge | manbu |
    | MAT_CHA_REIN  | 20    | ja    |
And I set field "ljtext1" to "FBU_R05" in row 1
# weitere Zeile als zusaetzliche Entnahme, chargenrein ist nicht gesetzt und schreibgeschuetzt, es kann abweichende Charge gebucht werden
And I append rows
    | elex          |
    | MAT_CHA_REIN  |
Then field "chargenrein" has value "nein" in row !lastRow
Then field "chargenrein" is not modifiable in row !lastRow
Then field "rescharge" is empty in row !lastRow
And I set field "tvcharge" to "05neu" in row !lastRow
And I set field "bumge" to "1" in row !lastRow
And I save the current editor

# Materialentnahme nur zusaetzliche Entnahme, Feld chargenrein ist schreibgeschuetzt
Given I open an editor "FBU2_R05" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | R05_001   |
    | bem       | Entnahme  |
And I delete all rows
# weitere Zeile als zusaetzliche Entnahme, chargenrein ist nicht gesetzt und schreibgeschuetzt, es kann abweichende Charge gebucht werden
And I append rows
    | elex          | bumge |
    | MAT_CHA_REIN  | 1     |
Then field "chargenrein" has value "nein" in row !lastRow
Then field "chargenrein" is not modifiable in row !lastRow
Then field "rescharge" is empty in row !lastRow
And I set field "tvcharge" to "05alt" in row !lastRow
And I save the current editor

# Charge oeffnen um Zugriff auf die ID zu haben
Given I open an editor "Charge05rein" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=05rein;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | 05rein    |
    | eigcharge | nein      |
And I close the current editor

# gebuchte Materialentnahme oeffnen um Zugriff auf Belegnummer barmex zu haben
Given I open an editor "FBUBELEG" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=R05_001;bem=FBU_R05;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "barmex" in row 0
And I close the current editor

# Buchungen im LJ pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" in row 0 to saved value
And I set field "artikel" to "MAT_CHA_REIN"
And I press start
Then table has values
    | zmge | amge     | tvcharge  | vplatz    |
    |      |  1       | 05neu     | F1        |
    |      | 10       | 05rein    | F1        |
    |      | 10       | 05rein    | F2        |
    |      |  1       | 05alt     | F1        |
And I close the current editor


Scenario: R06 BA mit EntnahmeMZ und manbu, Nachbuchen auf abgelegten Fertigungsvorschlag

Given I create a work order "R06" for Product "BG_CHA_REIN_MANBU" with quantity "20" and search word "R06_"

Given I open an editor "BAR06" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "R06_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | +1    | F1     | 10       | 06rein        |
    | +2    | F2     | 10       | !dontChange   |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BAR06"
And I save the current editor

# Materialentnahme Komplettmenge
Given I open an editor "FBU_R06" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | R06_001   |
    | bem       | Entnahme  |
    | tcharge   | 0606rein  |
And I press button "stlvblad"
Then table has values
    | elex          | bumge | manbu |
    | MAT_CHA_REIN  | 20    | ja    |
And I set field "ljtext1" to "FBU_R06" in row 1
And I save the current editor

# BA-Nummer zwischenspeichern
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=R06_000;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "nummer" in row 0
And I close the current editor

Given I open an editor "RM1_R06" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=R06_001;@richtung=rückwärts;@maxordtreffer=1"
And I set field "sofort" to "ja"
And I set field "gut" to "ja"
And I set field "tkcharge" to "0606rein"
And I set field "bem" to "RM1_R06"
And I save the current editor

Given I open an editor "RM2_R06" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=R06_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "sofort" to "ja"
And I set field "gut" to "ja"
And I set field "tkcharge" to "0606rein"
And I set field "bem" to "RM2_R06"
And I save the current editor

# Prüfen ob FeVo in der Ablage
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "BG_CHA_REIN_MANBU"
And I set field "banummer" in row 0 to saved value
And I set field "nurablage" to "ja"
And I set field "lgruppe" to "KARLSRUHE"
And I press button "ladetab"
Then the table has 1 rows
And I close the current editor

# Nachbuchen auf abgelegten Fertigungsvorschlag
Given I open an editor "RMNACH1" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=R06_001;bem=RM1_R06;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
Then table has values
    | artikel           |
    | BG_CHA_REIN_MANBU |
    | MAT_CHA_REIN      |
And I set field "bem" to "NACHBUCH"
And I set field "tkcharge" to "0606rein"
And I set field "gutmge" to "1" in row 1
And I set field "mge" to "1" in row 2
Then field "tcharge" has value "06rein" in row 2
Then field "tcharge" is not modifiable in row 2
And I save the current editor

# Charge oeffnen um Zugriff auf die ID zu haben
Given I open an editor "Charge06rein" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=06rein;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | 06rein    |
    | eigcharge | nein      |
And I close the current editor

# Buchungen im LJ pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_R06^barmex"
And I set field "artikel" to "MAT_CHA_REIN"
And I press start
Then table has values
    | zmge | amge     | tvcharge  | vcharge^id          | tncharge    | vplatz    |
    |      | 10       | 06rein    | !Charge06rein^id    | 0606rein    | F1        |
    |      | 10       | 06rein    | !Charge06rein^id    | 0606rein    | F2        |
    |      |  1       | 06rein    | !Charge06rein^id    | 0606rein    | F1        |
And I close the current editor


Scenario: R07 BA mit EntnahmeMZ und Material retrograd, Teilrueckmeldungen und Nachbuchen auf abgelegten Fertigungsvorschlag

Given I open an editor "BG_CHA_REIN_RETRO" from table "(Part):(Product)" with command "UPDATE" for record "BG_CHA_REIN_RETRO"
And I create a new row at position 1
And I set field "elex" to "MAT_CHA_REIN" in row 1
And I set field "anzahl" to "1" in row 1
Then field "chargenrein" has value "ja" in row 1
And I save the current editor

Given I create a work order "R07" for Product "BG_CHA_REIN_RETRO" with quantity "20" and search word "R07_"

Given I open an editor "BAR07" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "R07_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | +1    | F1     | 10       | 07rein        |
    | +2    | F2     | 10       | !dontChange   |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BAR07"
And I save the current editor

# BA-Nummer zwischenspeichern
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=R07_000;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "nummer" in row 0
And I close the current editor

# Teilrueckmeldung auf Arbeitsschein 1
Given I open an editor "RM1_1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=R07_001;@richtung=rückwärts;@maxordtreffer=1"
And I set field "sofort" to "ja"
And I set field "gutmge" to "15" in row 1
And I set field "tkcharge" to "0707rein"
And I set field "bem" to "RM1_1_R07"
And I save the current editor

# Charge in der Materialzuordnung ist dann schreibgeschuetzt
Given I open an editor "BAR07" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "R07_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
Then field "tcharge" has value "07rein" in row 1
Then field "tcharge" is not modifiable in row 1
Then field "charge" is not modifiable in row 1
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BAR07"
And I save the current editor

Given I open an editor "RM1_2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=R07_001;@richtung=rückwärts;@maxordtreffer=1"
And I set field "sofort" to "ja"
And I set field "gutmge" to "5" in row 1
And I set field "tkcharge" to "0707rein"
And I set field "bem" to "RM1_2_R07"
And I save the current editor

# Arbeitsschein 1 ueberbuchen, Charge wird uebernommen
Given I open an editor "RM1_3" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=R07_001;@richtung=rückwärts;@maxordtreffer=1"
And I set field "sofort" to "ja"
And I set field "gutmge" to "1" in row 1
And I set field "tkcharge" to "0707rein"
And I set field "bem" to "RM1_3_R07"
And I save the current editor

Given I open an editor "RM2_1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=R07_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "sofort" to "ja"
And I set field "gutmge" to "15" in row 1
And I set field "tkcharge" to "0707rein"
And I set field "bem" to "RM2_1_R07"
And I save the current editor

Given I open an editor "RM2_2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=R07_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "sofort" to "ja"
And I set field "gut" to "ja"
And I set field "tkcharge" to "0707rein"
And I set field "bem" to "RM2_2_R07"
# Dialog Herstellkosten sind hoeher als vorkalkuliert, da ueberbucht wurde
And I respond with answer "ja" to the dialog with id "1483"
And I save the current editor

# Prüfen ob FeVo in der Ablage
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "BG_CHA_REIN_RETRO"
And I set field "banummer" in row 0 to saved value
And I set field "nurablage" to "ja"
And I set field "lgruppe" to "KARLSRUHE"
And I press button "ladetab"
Then the table has 1 rows
And I close the current editor

# Nachbuchen auf abgelegten Fertigungsvorschlag
Given I open an editor "RMNACH1" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=R07_001;bem=RM1_2_R07;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
Then table has values
    | artikel           |
    | BG_CHA_REIN_RETRO |
    | MAT_CHA_REIN      |
And I set field "bem" to "NACHBUCH"
And I set field "tkcharge" to "0707rein"
And I set field "gutmge" to "1" in row 1
And I set field "mge" to "1" in row 2
Then field "tcharge" has value "07rein" in row 2
Then field "tcharge" is not modifiable in row 2
And I save the current editor

# Charge oeffnen um Zugriff auf die ID zu haben
Given I open an editor "Charge07rein" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=07rein;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | 07rein    |
    | eigcharge | nein      |
And I close the current editor

# Buchungen im LJ pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_1^barmex"
And I set field "artikel" to "MAT_CHA_REIN"
And I press start
Then table has values
    | zmge | amge     | tvcharge  | vcharge^id          | tncharge    | vplatz    |
    |      | 10       | 07rein    | !Charge07rein^id    | 0707rein    | F1        |
    |      |  5       | 07rein    | !Charge07rein^id    | 0707rein    | F2        |
    |      |  5       | 07rein    | !Charge07rein^id    | 0707rein    | F2        |
    |      |  1       | 07rein    | !Charge07rein^id    | 0707rein    | F1        |
And I close the current editor


Scenario: R08 BA ohne MZ und Material manuell, FBU ueber Teilmenge, MZ ueber Restmenge autom. anlegen (FDA-5882)

Given I create a work order "R08" for Product "BG_CHA_REIN_MANBU" with quantity "111" and search word "R08_"

Given I open an editor "FBU_R08" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | R08_001          |
    | bem           | EntnahmeR08_001  |
    | gmgevorschl   | 10               |
And I press button "stlvblad"
Then table has values
    | elex          | bumge | manbu |
    | MAT_CHA_REIN  |    10 |    ja |
And I set field "ljtext1" to "FBU_R08" in row 1
And I set field "tvcharge" to "R08-AB" in row 1
And I set field "treszcharge" to "R08-ZU" in row 1
And I save the current editor

# Chargen oeffnen um Zugriff auf die ID zu haben
Given I open an editor "Charge08Ab" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=R08-AB;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | R08-AB    |
And I close the current editor

Given I open an editor "Charge08Zu" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=R08-ZU;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | R08-ZU    |
And I close the current editor

# gebuchte Materialentnahme oeffnen um Zugriff auf Belegnummer barmex zu haben
Given I open an editor "FBUBELEG08" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=R08_001;bem=EntnahmeR08_001;@ablage=abgelegt;@richtung=rueckwaerts;@maxordtreffer=1"
And I save value from field "barmex" in row 0
And I close the current editor

# Buchungen im LJ pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" in row 0 to saved value
And I set field "artikel" to "MAT_CHA_REIN"
And I press start
Then table has values
    | zmge | amge     | tvcharge  | vcharge^id     | vplatz    | tncharge |     ncharge^id |
    |      |  10      |  R08-AB   | !Charge08Ab^id | F1        |   R08-ZU | !Charge08Zu^id |
And I close the current editor

# Chargen in die Artikelzeile eintragen
Given I open an editor "BAR08-UPD" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "R08_000"
And I press button "absteig" to open a subeditor for "AFL"
And I set field "tcharge" to "R08-AB" in row 1
And I set field "ztcharge" to "R08-ZU" in row 1
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Entnahme-MZ pr�fen, Menge muss �ber Restmenge gehen
Given I open an editor "BAR08-VIEW" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "R08_000"
And I press button "absteig" to open a subeditor for "AFLR08"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
Then field "tcharge" has value "R08-AB" in row 1
Then field "ztcharge" has value "R08-ZU" in row 1
Then field "zuomge" has value "101" in row 1
And I close the current editor
And I switch the current editor to editor "AFLR08"
And I close the current editor
And I switch the current editor to editor "BAR08-VIEW"
And I close the current editor


