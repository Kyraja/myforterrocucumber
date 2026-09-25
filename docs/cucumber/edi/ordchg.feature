@persistent
Feature: ordchg.feature

Background:
And I set the fake date to "07.01.1995"
Given I enable the flag 39

# **********************************************************************************
#  Name             : ordchg.feature
#  Autor            : mibr
#  Verantwortlich   : teampss
#  Funktion         : EDI-Orders-Change Verarbeitung (Folgetest als Cucumber)
#                     Aenderungsauftraege: Vorhandene EDI-Auftraege koennen positionsweise
#                     neu angelegt, geaendert, storniert, nicht geaendert werden
#
# **********************************************************************************

#### Vorgaenger ref_edidaten verwenden, legt Stammdaten an

# ---------------------------------------------------------------------------------------------
Scenario: EDI einschalten
# ---------------------------------------------------------------------------------------------
Given I open an editor "Firma" from table "(Company):(Configuration)" with command "UPDATE" for record "KONFIG"
And I set field "automotive" to "ja"
And I save the current editor

Scenario: Kunde EDIKD-3 fuer EDI verwalten
# Im Kundenkontakt EDISB-13 ebenfalls ORDERS aktivieren
Given I open an editor "EDISB-13" from table "(Customer):(CustomerContact)" with command "UPDATE" for record "EDISB-13"
And I press button "edinfo" to open a subeditor for "EDIInfo"
And I create a new row at the end of the table
And I set field "edinachraz" to "Auftrag" in row !lastRow
And I set field "ieabmodell" to "4040" in row !lastRow
And I set field "erlaubt" to "ja" in row !lastRow
And I save the current editor
And I switch the current editor to editor "EDISB-13"
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: Rahmen mit lfristkurz werden nicht verarbeitet
# ---------------------------------------------------------------------------------------------
# neuen Rahmenauftrag anlegen
Given I open an editor "RAH_BSAM" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
    | kunde       | EDIKD-3    |
    | such        | RAH_BSAM   |
    | abschlnr    | RA01BSAM   |
    | verwschl    | S          |
And I append rows
    | artikel     | mge  | lzeit | preis |
    | EDIART-3    | 1000 |    30 | 0.88  |
And I save the current editor

Scenario: Orders-Change duerfen keine sofort verfuegbare Menge beruecksichtigen
# Orders Anlegen immer mit Hauptkunde
Given I open the infosystem "ORDERSENTRY"
And I set fields
    | kkunde      | EDIKD-3  |
    | kabm        | 4040     |
    | kbeleg      | RA01BSAM |
    | kwaehr      | EUR      |
And I delete all rows
And I append rows
    | tpnum | tartex   | tmenge | tpreis | tdatum |
    |     1 | EDIART-3 |      5 |      5 | +1     |
And I press button "kbuerzeugen"
And I close the current editor

Given I open the infosystem "EDIIMPORT"
And I set field "abm" to "4040"
And I press button "kbumarkall"
And I press start
And I set field "tmark" to "ja" in row 1
And I press button "tbuimport" in row 1
And I close the current editor

Given I open the infosystem "EDIIMPVER"
And I set field "kborders" to "ja"
And I set field "kballekunden" to "nein"
And I delete all rows
And I create a new row at position 1
And I set field "tkunde" to "EDISB-13" in row 1
And I press button "tbuverarb" in row 1
And I close the current editor

# Status der EDI Nachricht pruefen
Given I open an editor "EDINACHR" from table "(EDI):(EDI)" with command "UPDATE" for search criteria "$,,abbenr=RA01BSAM;@richtung=(Backwards);@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | status    | 0    |
    | fcode     | 0    |
Then field "ftext" is empty
And I close the current editor

# Rahmenauftrag bekommt lfristkurz
Given I open an editor "RAH_BSAMUP" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record from editor "RAH_BSAM"
Then field "ofverfuegbmge" has value "0" in row 1
And I set field "verfuegbmge" to "10" in row 1
And I set field "lfristkurz" to "3" in row 1
And I save the current editor

# Orders-Change anlegen immer mit Hauptkunde
Given I open the infosystem "ORDERSENTRY"
And I set fields
    | kkunde      | EDIKD-3          |
    | kedinachraz | Auftragsänderung |
    | kabm        | 4060             |
    | kbeleg      | RA01BSAM         |
    | kwaehr      | EUR              |
And I delete all rows
And I append rows
    | tpnum | tartex   | tmenge | tpreis | tdatum | tbaktchg    | tbaktadd    |
    |     1 | EDIART-3 |      7 |      5 | +1     | ja          | !dontChange |
And I press button "kbuerzeugen"
And I close the current editor

Given I open the infosystem "EDIIMPORT"
And I set field "abm" to "4060"
And I press button "kbumarkall"
And I press start
And I set field "tmark" to "ja" in row 1
And I press button "tbuimport" in row 1
And I close the current editor

Given I open the infosystem "EDIIMPVER"
And I set field "kborders" to "ja"
And I set field "kballekunden" to "nein"
And I delete all rows
And I create a new row at position 1
And I set field "tkunde" to "EDISB-13" in row 1
And I press button "tbuverarb" in row 1
And I close the current editor

# Status der EDI Nachricht pruefen (Soll scheitern!)
Given I open an editor "EDINACHR" from table "(EDI):(EDI)" with command "UPDATE" for search criteria "$,,abbenr=RA01BSAM;@richtung=(Backwards);@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | status    | 4    |
    | fcode     | 56   |
Then field "ftext" is not empty
And I close the current editor

# lfristkurz rausnehmen und erneut durchfuehren, dann muss es wieder gehen
Given I open an editor "RAH_BSAMUP" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record from editor "RAH_BSAM"
# Sofort verfuegbare Menge darf nicht negativ werden
Then field "ofverfuegbmge" has value "10" in row 1
And I set field "lfristkurz" to "0" in row 1
And I set field "verfuegbmge" to "0" in row 1
And I save the current editor

# Status der EDI Nachricht pruefen (Soll scheitern!)
Given I open an editor "EDINACHR" from table "(EDI):(EDI)" with command "UPDATE" for search criteria "$,,abbenr=RA01BSAM;@richtung=(Backwards);@maxtreffer=1;@ablageart=lebendig"
And I set fields
    | status    | 2    |
    | fcode     | 0    |
And I save the current editor

Given I open the infosystem "EDIIMPVER"
And I set field "kborders" to "ja"
And I set field "kballekunden" to "nein"
And I delete all rows
And I create a new row at position 1
And I set field "tkunde" to "EDISB-13" in row 1
And I press button "tbuverarb" in row 1
And I close the current editor

# Status der EDI Nachricht pruefen (Soll scheitern!)
Given I open an editor "EDINACHR" from table "(EDI):(EDI)" with command "UPDATE" for search criteria "$,,abbenr=RA01BSAM;@richtung=(Backwards);@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | status    | 0    |
    | fcode     | 0    |
And I close the current editor

