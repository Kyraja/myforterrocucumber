@persistent
Feature: orders.feature

Background:
And I set the fake date to "07.01.1995"
Given I enable the flag 39

# **********************************************************************************
#  Name             : orders.feature
#  Autor            : mibr
#  Verantwortlich   : teampss
#  Funktion         : EDI-Orders Verarbeitung (Folgetest als Cucumber)
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
Scenario: Rahmen RAH_ORD mit Maxmenge fuer EDI Orders anlegen
# ---------------------------------------------------------------------------------------------
# neuen Rahmenauftrag anlegen
Given I open an editor "RAH_ORD" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
    | kunde       | EDIKD-3    |
    | such        | RAH_ORD    |
    | abschlnr    | RA44MAXMGE |
    | verwschl    | S          |
    | bem         | 007        |
    | waehr       | DEM        |
And I append rows
    | artikel     | mge  | maxabrufmge  | preis |
    | EDIART-4    | 1000 | 1500         |  0.77 |
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario Outline: Orders unter Beruecksichtigung der max Rahmenmenge
# ---------------------------------------------------------------------------------------------
# Orders Anlegen immer mit Hauptkunde
Given I open the infosystem "ORDERSENTRY"
And I set fields
    | kkunde   | EDIKD-3   |
    | kabm     | 4040      |
    | kbeleg   | <kbeleg>  |
    | kwaehr   | DEM       |
And I delete all rows
And I append rows
    | tartex   | tmenge | tdatum | tpreis |
    | <art1>   | <mge1> |    +10 |      5 |
    | <art2>   | <mge2> |    +20 |   1.99 |
    | EDIART-3 | <mge3> |    +30 |   4.66 |
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

Given I open an editor "AUFTRAG" from table "(Sales):(SalesOrder)" with command "VIEW" for search criteria "$,,abschlnr==<kbeleg>;@gruppe=1;;@maxtreffer=1;@ablageart=lebendig"
Then field "abschlnr" has value "<kbeleg>"
Then table has values
    | artikel^such | mge    | zrahmen^such   | preis         |
    | EDIART-4     | <mge1> | <rahmen_soll>  | <preis_soll>  |
    | <art2>       | <mge2> | <rahmen2_soll> | <preis2_soll> |
    | EDIART-3     | <mge3> |                |        50.00  |
And I close the current editor

Examples:
 | Test | Index | kbeleg    | art1     | art2     | mge1 | mge2 | mge3 | rahmen_soll | rahmen2_soll | preis_soll | preis2_soll | Info                                                   |
 | 01   | 0     | ORD_EDI74 | EDIART-4 | EDIART-2 |   10 |    5 |    6 | RAH_ORD     |              |       0.77 |       50.00 | Passt in max. Rahmenmenge                              |
 | 02   | 0     | ORD_EDI75 | EDIART-4 | EDIART-2 | 2000 |    5 |    6 |             |              |      50.00 |       50.00 | Ueberschreitet durch eine Position                     |
 | 03   | 0     | ORD_EDI76 | EDIART-4 | EDIART-4 |   10 |   20 |    6 | RAH_ORD     | RAH_ORD      |       0.77 |        0.77 | 2 gleiche Postitionen passen                           |
 | 04   | 0     | ORD_EDI77 | EDIART-4 | EDIART-4 |  500 |  970 |    6 | RAH_ORD     |              |       0.77 |       50.00 | 2. Position  ueberschreitet - Rahmen Zeile 2 geloescht |
 | 05   | 0     | ORD_EDI78 | EDIART-4 | EDIART-2 |  960 |    5 |    6 | RAH_ORD     |              |       0.77 |       50.00 | Kommt genau bis zu maxmenge                            |
 | 06   | 0     | ORD_EDI79 | EDIART-4 | EDIART-2 |   1  |    5 |    6 |             |              |      50.00 |       50.00 | Jetzt ist endgueltig voll                              |

# ---------------------------------------------------------------------------------------------
Scenario: Rahmen RAH_ORD ablegen
# ---------------------------------------------------------------------------------------------
Given I open an editor "RAH_ORDUP" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record from editor "RAH_ORD"
And I set field "tterm" to ""
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: Rahmen mit lfristkurz werden nicht verarbeitet
# ---------------------------------------------------------------------------------------------
# neuen Rahmenauftrag anlegen
Given I open an editor "RAH_SAM" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
    | kunde       | EDIKD-3    |
    | such        | RAH_SAM    |
    | abschlnr    | RA92SAM    |
    | verwschl    | S          |
And I append rows
    | artikel     | mge  | lzeit | verfuegbmge  | lfristkurz | preis |
    | EDIART-4    | 1000 |    30 |         10   |          2 | 0.88  |
And I save the current editor

# Orders Anlegen immer mit Hauptkunde
Given I open the infosystem "ORDERSENTRY"
And I set fields
    | kkunde   | EDIKD-3   |
    | kabm     | 4040      |
    | kbeleg   | RA92SAM   |
    | kwaehr   | EUR       |
And I delete all rows
And I append rows
    | tartex   | tmenge | tpreis |
    | EDIART-4 |      5 |      5 |
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
Given I open an editor "EDINACHR" from table "(EDI):(EDI)" with command "VIEW" for search criteria "$,,abbenr=RA92SAM;@richtung=(Backwards);@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | status    | 4    |
    | fcode     | 56   |
Then field "ftext" is not empty
And I close the current editor

# Rahmen ablegen
Given I open an editor "RAH_SAMUP" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record from editor "RAH_SAM"
And I set field "tterm" to ""
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: Rahmen mit lfristkurz werden nicht verarbeitet zwei gleiche Artikel
# ---------------------------------------------------------------------------------------------
# neuen Rahmenauftrag anlegen
Given I open an editor "RAH_BSAM" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
    | kunde       | EDIKD-3    |
    | such        | RAH_BSAM   |
    | abschlnr    | RA92BSAM   |
    | verwschl    | S          |
And I append rows
    | artikel     | mge  | lzeit | verfuegbmge  | lfristkurz | preis |
    | EDIART-3    | 1000 |    30 |         10   |          3 | 0.88  |
And I save the current editor

# Orders Anlegen immer mit Hauptkunde
Given I open the infosystem "ORDERSENTRY"
And I set fields
    | kkunde   | EDIKD-3   |
    | kabm     | 4040      |
    | kbeleg   | RA93BSAM  |
    | kwaehr   | EUR       |
And I delete all rows
And I append rows
    | tartex   | tmenge | tpreis | tdatum |
    | EDIART-3 |      6 |      5 | +1     |
    | EDIART-3 |      6 |      5 | +1     |
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
Given I open an editor "EDINACHR" from table "(EDI):(EDI)" with command "VIEW" for search criteria "$,,abbenr=RA93BSAM;@richtung=(Backwards);@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | status    | 4    |
    | fcode     | 56   |
Then field "ftext" is not empty
And I save the current editor

# Rahmen ablegen
Given I open an editor "RAH_BSAMUP" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record from editor "RAH_BSAM"
# Sofort verfuegbare Menge darf nicht negativ werden
Then field "ofverfuegbmge" has value "10" in row 1
And I set field "tterm" to ""
And I save the current editor


