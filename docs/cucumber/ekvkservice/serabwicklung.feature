# *****************************************************************************
#  Name           : serabwicklung.feature
#  Autor          : mibr
#  Verantwortlich : teampss
#  Funktion       : Tests zu mehrtaegigen Servicereservierungen
#                   Test der Service-STL-Generierung
#
# *****************************************************************************
#
@persistent
Feature: Serviceabwicklung
Background:
Given I set the fake date to "02.01.1995"

@service
Scenario: STAMMDATEN - Neuen Kunden anlegen
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "Bayram"
And I set fields
   | such     |  Bayram                      |
   | nummer   |  1K                          |
   | namebspr |  Bayram Werkzeugbau, Rastatt |
   | ans      |  Bayram Werkzeugbau GmbH     |
   | str      |  Riedstr. 24-28              |
   | plz      |  76437                       |
   | nort     |  Rastatt                     |
   | region   |  BADEN                       |
   | tele     |  +49 (0) 7222/9456-0         |
   | email    |  info@bayram-corp.de         |
   | betreuer |  .                           |
   | ustid    |  DE56454651                  |
   | lbed     |  EXW                         |
   | zbed     |  201                         |
And I save the current editor
Then field "name" has value "Bayram Werkzeugbau, Rastatt"
Then field "zbed" has value "201"

Given I open an editor "kunde2" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set fields
   | such     |  BayramKA                      |
   | nummer   |  2K                            |
   | namebspr |  Bayram Werkzeugbau, Karlsruhe |
   | ans      |  Bayram Werkzeugbau KA GmbH    |
   | str      |  Gartenstr. 45                 |
   | plz      |  76133                         |
   | nort     |  Karlsruhe                     |
   | tele     |  +49 (0) 721/913-0             |
   | ans2     |  Bayram Werkzeugbau KA GmbH    |
   | tele2    |  +49 (0) 721/913-111           |
And I save the current editor

@service
Scenario: STAMMDATEN - Schichtplan im Mitarbeiter hinterlegen
Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "UPDATE" for record "Test"
And I set field "splan" to "301"
And I save the current editor

@service
Scenario: STAMMDATEN - Neuen Techniker anlegen
Given I open an editor "techniker" from table "(ServiceEmployees):(EmployeeRole)" with command "STORE" for record "techniker"
And I set field "such" to "techniker"
And I set field "namebspr" to "Techniker"
And I set field "ma" to "test"
And I save the current editor

Given I open an editor "techniker2" from table "(ServiceEmployees):(EmployeeRole)" with command "COPY" for record "techniker"
And I set field "such" to "techniker2"
And I set field "namebspr" to "Techniker2"
And I set field "ma" to "Meier"
And I save the current editor

@service
Scenario Outline: STAMMDATEN - Neue Dienstleistungen
Given I open an editor "dienstl" from table "(Part):(Service)" with command "STORE" for record "dl-analyse"
And I set field "such" to "dl-analyse"
And I set field "namebspr" to "Analyse"
And I set field "vpr" to "50.00"
And I save the current editor

Given I open an editor "<ndienstl>" from table "(Part):(Service)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "vpr" to "<preis>"
And I set field "vpe" to "h"
And I set field "vhe" to "h"
And I save the current editor

Examples:
| ndienstl   | such         | namebspr      | preis |
| hdienstl   | dl-hanalyse  | Analyse mit h | 60.00 |
| repdienstl | dl-reparatur | Reparatur     | 70.00 |
| sdienstl   | dl-schulung  | Schulung      | 50.00 |
| bdienstl   | dl-beratung  | Beratung      | 80.00 |

@service
Scenario: STAMMDATEN - Neues Einsatzmittel anlegen
Given I open an editor "einsatzm" from table "(ServiceAssignment):(AssignmentResources)" with command "STORE" for record ""
And I set field "such" to "em-pkw"
And I save the current editor

@service
Scenario: STAMMDATEN - Neue Kostenstelle anlegen
Given I open an editor "kostenstelle" from table "(Account):(CostCenter)" with command "STORE" for record ""
And I set field "such" to "KS-TECHN"
And I save the current editor

@service
Scenario: STAMMDATEN - Kurztext fuer die Freigabe Rahmenauftrag -> Serviceauftrag
Given I open an editor "ra-kurztext" from table "(Company):(Summary)" with command "STORE" for record ""
And I set field "such" to "SER_AUFTR"
And I set field "typ" to "Serviceauftrag"
And I save the current editor

#
# Test der Servicereservierungsart
#
@service
Scenario: EVS-496 Artaenderung der Servicereservierungsart
#Neuen Bezeichner anlegen
Given I open an editor "bezeichner" from table "(ValueSet):(Identifier)" with command "STORE" for record "BETRIEBSRAT"
And I set field "such" to "BETRIEBSRAT"
And I set field "namebspr" to "Betriebsrat"
And I set field "classname" to "Betriebsrat"
And I set field "langtxt" to "Betriebsratstaetigkeit"
And I save the current editor
#Bezeichner in die Aufzaehlung eintragen
Given I open an editor "aufzaehlung" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "SERVICERESART"
And I set field "tabangepasst" to "ja"
And I set field "aeaktiv" to "nein" in row 15
And I set field "aeaktiv" to "nein" in row 16
And I create a new row at the end of the table
And I set field "aufzelem" to "BETRIEBSRAT" in row 17
And I set field "reosofort" to "ja"
And I set field "reoelem" to "ja"
And I save the current editor
#Servicereservierung mit neuer Serviceart anlegen
Given I open an editor "serviceres" from table "(ServiceReservation):(ServiceReservations)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "resart" to "Betriebsrat" in row 1
And setting field "resart" to "Elternzeit" in row 1 throws the exception ""
And setting field "resart" to "Wehrdienst/Zivildienst" in row 1 throws the exception ""

#
# Testfaelle fuer mehrtaegige Servicereservierungen
#
@service
Scenario: Eine Servicereservierung anlegen
Given I open an editor "serviceres" from table "(ServiceReservation):(ServiceReservations)" with command "UPDATE" for record ""
And I create a new row at the end of the table
And I set field "resart" to "Offener Termin" in row 1
And I set field "techniker" to id from editor "techniker" in row 1
And I set field "kunde" to id from editor "kunde" in row 1
And I set field "dienstl" to id from editor "dienstl" in row 1
And I set field "datumvon" to "04.12.1995" in row 1
And I set field "datumbis" to "06.12.1995" in row 1
And I set field "zzvon" to "08" in row 1
And I set field "zzbis" to "12" in row 1
And I set field "anreisedatumvon" to "04.12.1995" in row 1
And I set field "anreisezvon" to "06:00" in row 1
And I set field "abreisedatumbis" to "07.12.1995" in row 1
And I set field "abreisezbis" to "14:00" in row 1
And I respond with answer "Ja" to the dialog with id "588"
And I press button "resanlegen" in row 1
Then the table has 3 rows
Then field "datumvon" has value "04.12.1995" in row 1
Then field "zzvon" has value "8:00" in row 1
Then field "zzbis" has value "12:00" in row 1
Then field "dauer" has value "0D04h00m" in row 1
Then field "dauernetto" has value "" in row 1
Then field "anreisedatumvon" has value "04.12.1995" in row 1
Then field "anreisezvon" has value "6:00" in row 1
Then field "abreisedatumbis" is empty in row 1
Then field "abreisezbis" is empty in row 1

Then field "datumvon" has value "05.12.1995" in row 2
Then field "zzvon" has value "8:00" in row 2
Then field "zzbis" has value "12:00" in row 2
Then field "dauer" has value "0D04h00m" in row 2
Then field "dauernetto" has value "" in row 1
Then field "anreisedatumvon" is empty in row 2
Then field "anreisezvon" is empty in row 2
Then field "abreisedatumbis" is empty in row 2
Then field "abreisezbis" is empty in row 2

Then field "datumvon" has value "06.12.1995" in row 3
Then field "zzvon" has value "8:00" in row 3
Then field "zzbis" has value "12:00" in row 3
Then field "dauer" has value "0D04h00m" in row 3
Then field "dauernetto" has value "" in row 1
Then field "anreisedatumvon" is empty in row 3
Then field "anreisezvon" is empty in row 3
Then field "abreisedatumbis" has value "07.12.1995" in row 3
Then field "abreisezbis" has value "14:00" in row 3
And I save the current editor

@service
Scenario: Serviceangebot anlegen
Given I open an editor "serviceangebot" from table "(Sales):(ServiceQuotation)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "SABAYRAM"
And I create a new row at the end of the table
And I set field "techniker" to id from editor "techniker" in row 1
And I set field "artikel" to "dl-analyse" in row 1
And I set field "mge" to "1" in row !lastRow
And I set field "datumvon" to "01.12.1995" in row 1
And I set field "ganztag" to "nein" in row 1
And I set field "zzvon" to "13" in row 1
And I set field "zzbis" to "17" in row 1
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 2
Then field "artikel" has value "DL-ANALYSE" in row 2
And I set field "techniker" to id from editor "techniker" in row 2

And I set field "mge" to "1" in row 2
And I set field "datumvon" to "02.12.1995" in row 2
And I set field "ganztag" to "nein" in row 2
And I set field "zzvon" to "8" in row 2
And I set field "zzbis" to "12" in row 2
Then the table has 2 rows
And I save the current editor

@service
Scenario: Servicereservierung aufrufen und Angebotsreservierung pruefen
Given I open an editor "serviceres" from table "(ServiceReservation):(ServiceReservations)" with command "UPDATE" for record ""
And I set field "resart" to "Angebotstermin"
And I set field "techniker" to id from editor "techniker"
And I press button "ladetab"
Then the table has 2 rows
Then field "resart" has value "Angebotstermin" in row 1
Then field "kunde" has value "BAYRAM" in row 1
Then field "dienstl" has value "DL-ANALYSE" in row 1
Then field "techniker" has value "TECHNIKER" in row 1
Then field "datumvon" has value "02.12.1995" in row 1
Then field "kunde" has value "BAYRAM" in row 1
Then field "zzvon" has value "8:00" in row 1
Then field "zzbis" has value "12:00" in row 1
Then field "resart" has value "Angebotstermin" in row 2
Then field "kunde" has value "BAYRAM" in row 2
Then field "dienstl" has value "DL-ANALYSE" in row 2
Then field "techniker" has value "TECHNIKER" in row 2
Then field "datumvon" has value "01.12.1995" in row 2
Then field "kunde" has value "BAYRAM" in row 2
Then field "zzvon" has value "13:00" in row 2
Then field "zzbis" has value "17:00" in row 2

@service
Scenario: Servicereservierung aufrufen und neue Zeile einfuegen, Serviceauftrag anlegen
Given I open an editor "servicez" from table "(ServiceReservation):(ServiceReservations)" with command "UPDATE" for record ""
And I set field "resart" to "Offener Termin"
And I set field "techniker" to id from editor "techniker"
And I press button "ladetab"
Then the table has 3 rows
When I press button "grzeileeinfuegen" in row 1
And I set field "emittel" to id from editor "einsatzm" in row 2
Then the table has 4 rows
Then field "grzeile" has value "nein" in row 1
Then field "grzeile" has value "ja" in row 2
When I press button "auanlegen" to open a subeditor for "serviceauf" in row 1
And I set field "such" to "SAUBAYRAM"
And I save the current editor

@service
Scenario: Servicereservierung aufrufen und pruefen
Given I open an editor "servicep" from table "(ServiceReservation):(ServiceReservations)" with command "UPDATE" for record ""
And I set field "resart" to "Offener Termin"
And I set field "techniker" to id from editor "techniker"
And I press button "ladetab"
Then the table has 3 rows

@service
Scenario: Serviceauftrag aufrufen und Termin aendern
Given I open an editor "serviceauf" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record "SAUBAYRAM"
And I set field "datumvon" to "05.12.1995" in row 1
And I set field "zzvon" to "9" in row 1
And I set field "zzbis" to "12" in row 1
And I save the current editor

@service
Scenario: Servicereservierung aufrufen, pruefen und Termin und Uhrzeit aendern
Given I open an editor "serviceres" from table "(ServiceReservation):(ServiceReservations)" with command "UPDATE" for record ""
And I set field "resart" to "Auftragstermin"
And I set field "techniker" to id from editor "techniker"
And I press button "ladetab"
Then the table has 1 rows
Then field "datumvon" has value "05.12.1995" in row 1
Then field "zzvon" has value "9:00" in row 1
Then field "zzbis" has value "12:00" in row 1
Then field "dauer" has value "0D03h00m" in row 1
When I set field "datumvon" to "04.12.1995" in row 1
And I set field "zzbis" to "17:00" in row 1
And I set field "zzvon" to "13:00" in row 1
And I save the current editor

@service
Scenario: Serviceauftrag aufrufen und pruefen
Given I open an editor "serviceauf" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record "SAUBAYRAM"
Then field "datumvon" has value "04.12.1995" in row 1
Then field "zzvon" has value "13:00" in row 1
Then field "zzbis" has value "21:00" in row 1
And I save the current editor

@service
Scenario: Eine Servicereservierung ueber das Wochenende anlegen
Given I open an editor "serviceres" from table "(ServiceReservation):(ServiceReservations)" with command "UPDATE" for record ""
And I create a new row at the end of the table
And I set field "resart" to "Offener Termin" in row 1
And I set field "techniker" to id from editor "techniker" in row 1
And I set field "kunde" to id from editor "kunde" in row 1
And I set field "dienstl" to id from editor "dienstl" in row 1
And I set field "datumvon" to "08.12.1995" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "16" in row 1
Then field "dauer" has value "0D08h00m" in row 1
Then field "tsollzt" has value "0D07h30m" in row 1
Then field "typtag" has value "Arbeitstag" in row 1
Then field "schichtnr" has value "1" in row 1
Then field "tplan" has value "TPFRUEH" in row 1
Then field "splan" has value "SP3S" in row 1
And I set field "datumbis" to "11.12.1995" in row 1
And I respond with answer "Ja" to the dialog with id "588"
And I press button "resanlegen" in row 1
Then field "datumvon" has value "08.12.1995" in row 1
Then field "zzvon" has value "8:00" in row 1
Then field "zzbis" has value "16:00" in row 1
Then field "dauer" has value "0D08h00m" in row 1
Then field "tsollzt" has value "0D07h30m" in row 1
Then field "typtag" has value "Arbeitstag" in row 1
Then field "schichtnr" has value "1" in row 1
Then field "tplan" has value "TPFRUEH" in row 1
Then field "splan" has value "SP3S" in row 1
Then the table has 4 rows
Then field "datumvon" has value "09.12.1995" in row 2
Then field "zzvon" has value "8:00" in row 2
Then field "zzbis" has value "16:00" in row 2
Then field "dauer" has value "0D08h00m" in row 2
Then field "tsollzt" is empty in row 2
Then field "typtag" has value "Arbeitsfrei" in row 2
Then field "schichtnr" has value "1" in row 2
Then field "tplan" has value "TPFRUEH" in row 1
Then field "splan" has value "SP3S" in row 2
Then field "datumvon" has value "10.12.1995" in row 3
Then field "zzvon" has value "8:00" in row 3
Then field "zzbis" has value "16:00" in row 3
Then field "dauer" has value "0D08h00m" in row 3
Then field "tsollzt" is empty in row 3
Then field "typtag" has value "Arbeitsfrei" in row 3
Then field "schichtnr" has value "0" in row 3
Then field "tplan" has value "" in row 3
Then field "splan" has value "SP3S" in row 3
Then field "datumvon" has value "11.12.1995" in row 4
Then field "zzvon" has value "8:00" in row 4
Then field "zzbis" has value "16:00" in row 4
Then field "dauer" has value "0D08h00m" in row 4
Then field "tsollzt" has value "0D07h30m" in row 4
Then field "typtag" has value "Arbeitstag" in row 4
Then field "schichtnr" has value "1" in row 4
Then field "tplan" has value "TPFRUEH" in row 4
Then field "splan" has value "SP3S" in row 4
And I save the current editor

@service
Scenario: In Servicereservierung mit Servicereservierungsart Angebotstermin duerfen resart, kunde und dienstl nicht editierbar sein
Given I open an editor "serviceres" from table "(ServiceReservation):(ServiceReservations)" with command "UPDATE" for record ""
And I set field "resart" to "Angebotstermin"
And I set field "techniker" to id from editor "techniker"
And I press button "ladetab"
Then the table has 2 rows
Then field "resart" is not modifiable in row 1
Then field "kunde" is not modifiable in row 1
Then field "dienstl" is not modifiable in row 1
Then field "resart" is not modifiable in row 2
Then field "kunde" is not modifiable in row 2
Then field "dienstl" is not modifiable in row 2

@service
Scenario: Servicereservierung zu Serviceaufrag loeschen
Given I open an editor "serviceres" from table "(ServiceReservation):(ServiceReservations)" with command "UPDATE" for record ""
And I set field "resart" to "Auftragstermin"
And I set field "techniker" to id from editor "techniker"
And I press button "ladetab"
Then the table has 1 rows
And deleting the row at position 1 throws the exception "3885"
Then the table has 1 rows

@service
Scenario: Servicereservierung zu Serviceangebotsposition loeschen
Given I open an editor "serviceres" from table "(ServiceReservation):(ServiceReservations)" with command "UPDATE" for record ""
And I set field "resart" to "Angebotstermin"
And I set field "techniker" to id from editor "techniker"
And I press button "ladetab"
Then the table has 2 rows
And I respond with answer "ja" to the dialog with id "826"
And I delete row at position 1
And I save the current editor

@service
Scenario: Servicereservierung hat nur nur noch 1 Zeile
Given I open an editor "serviceres" from table "(ServiceReservation):(ServiceReservations)" with command "VIEW" for record ""
And I set field "resart" to "Angebotstermin"
And I set field "techniker" to id from editor "techniker"
And I press button "ladetab"
Then the table has 1 rows

@service
Scenario: Serviceangebot bearbeiten, damit die Servicereservierung wieder erzeugt wird
Given I open an editor "serviceangebot" from table "(Sales):(ServiceQuotation)" with command "UPDATE" for record "SABAYRAM"
And I save the current editor

@service
Scenario: Servicereservierung pruefen, muss wieder 2 Zeilen haben
Given I open an editor "serviceres" from table "(ServiceReservation):(ServiceReservations)" with command "VIEW" for record ""
And I set field "resart" to "Angebotstermin"
And I set field "techniker" to id from editor "techniker"
And I press button "ladetab"
Then the table has 2 rows

@service
Scenario: Einen Reparaturauftrag anlegen. Das Feld Einzeltermin muss nach dem Speichern schreibgeschuetzt sein.
Given I open an editor "rahmen" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "XSBAYRAM"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "100" in row 1
And I set field "ganztag" to "ja" in row 1
And I save the current editor

@service
Scenario: Puefen, ob der Einzeltermin editierbar ist.
Given I open an editor "rahmen" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "XSBAYRAM"
Then field "eineprotag" is not modifiable in row 1

@service
Scenario: Ein Serviceangebot anlegen. Das Feld Einzeltermin muss nach dem Speichern schreibgeschuetzt sein.
Given I open an editor "sangebot" from table "(Sales):(ServiceQuotation)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "ASBAYRAM"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "ganztag" to "ja" in row 1
And I save the current editor

@service
Scenario: Puefen, ob der Einzeltermin editierbar ist.
Given I open an editor "sangebot" from table "(Sales):(ServiceQuotation)" with command "UPDATE" for record "ASBAYRAM"
Then field "eineprotag" is not modifiable in row 1

@service
Scenario: Einen Serviceauftrag anlegen. Das Feld Einzeltermin muss nach dem Speichern schreibgeschuetzt sein.
Given I open an editor "sauftrag" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "BSBAYRAM"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "ganztag" to "ja" in row 1
And I save the current editor

@service
Scenario: Puefen, ob der Einzeltermin editierbar ist.
Given I open an editor "sauftrag" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record "BSBAYRAM"
Then field "eineprotag" is not modifiable in row 1
Scenario: EVS-573 Ein Serviceangebot mit mehrtaegiger Servicereservierung als Einzeltermin anlegen und aus Angebot und Servicereservierung verschieben
Given I open an editor "serangebot" from table "(Sales):(ServiceQuotation)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "ASBAYRAM"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "hdienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "datumvon" to "5.12.95" in row 1
And I set field "dauer" to "5D" in row 1
Then field "datumbis" has value "09.12.1995" in row 1
And I set field "ganztag" to "nein" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "12" in row 1
And I set field "eineprotag" to "ja" in row 1
And I press button "srabsteig" to open a subeditor for "serviceres" in row 1
Then the table has 5 rows
Then field "datumvon" has value "05.12.1995" in row 1
Then field "datumbis" has value "05.12.1995" in row 1
Then field "zzvon" has value "8:00" in row 1
Then field "zzbis" has value "12:00" in row 1
Then field "dauernetto" has value "0D01h00m" in row 1
Then field "dauernetto" is empty in row 2
Then field "dauernetto" is empty in row 3
Then field "dauernetto" is empty in row 4
Then field "dauernetto" is empty in row 5
Then field "datumvon" has value "09.12.1995" in row 5
Then field "datumbis" has value "09.12.1995" in row 5
Then field "zzvon" has value "8:00" in row 5
Then field "zzbis" has value "12:00" in row 5
When I set field "datumvon" to "11.12.95" in row 1
And I save the current editor
When I switch the current editor to editor "serangebot"
Then field "datumvon" has value "06.12.1995" in row 1
Then field "datumbis" has value "11.12.1995" in row 1
Then field "datumbis" is not modifiable in row 1
When I set field "datumvon" to "07.12.95" in row 1
And I press button "srabsteig" to open a subeditor for "serviceres" in row 1
Then the table has 5 rows
Then field "datumvon" has value "12.12.1995" in row 1
Then field "datumbis" has value "12.12.1995" in row 1
Then field "zzvon" has value "8:00" in row 1
Then field "zzbis" has value "12:00" in row 1
Then field "datumvon" has value "07.12.1995" in row 2
Then field "datumvon" has value "08.12.1995" in row 3
Then field "datumvon" has value "09.12.1995" in row 4
Then field "datumvon" has value "10.12.1995" in row 5
When I set field "zzvon" to "9:15" in row 1
Then field "zzbis" has value "13:15" in row 1
And I set field "zzvon" to "9:25" in row 2
Then field "zzbis" has value "13:25" in row 2
And I save the current editor
When I switch the current editor to editor "serangebot"
Then field "zzvon" has value "9:25" in row 1
Then field "zzbis" has value "13:15" in row 1
Then field "eineprotag" is not modifiable in row 1
Then field "datumvon" has value "07.12.1995" in row 1
When I set field "zzvon" to "9:05" in row 1
Then field "zzbis" has value "12:55" in row 1
When I press button "srabsteig" to open a subeditor for "serviceres" in row 1
Then field "zzvon" has value "9:15" in row 1
Then field "zzbis" has value "13:15" in row 1
Then field "zzvon" has value "9:25" in row 2
Then field "zzbis" has value "13:25" in row 2
Then field "zzvon" has value "8:00" in row 3
Then field "zzbis" has value "12:00" in row 3
Then field "zzvon" has value "8:00" in row 4
Then field "zzbis" has value "12:00" in row 4
Then field "zzvon" has value "8:00" in row 5
Then field "zzbis" has value "12:00" in row 5
And I save the current editor
And I switch the current editor to editor "serangebot"
And I save the current editor

@service
Scenario: EVS-573 Einen Serviceauftrag mit mehrtaegiger Servicereservierung als Einzeltermin anlegen und aus Auftrag und Servicereservierung verschieben.
Given I open an editor "serauftrag" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "BSBAYRAM"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "hdienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "datumvon" to "5.12.95" in row 1
And I set field "dauer" to "5D" in row 1
Then field "datumbis" has value "10.12.1995" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "12" in row 1
And I set field "eineprotag" to "ja" in row 1
And I press button "srabsteig" to open a subeditor for "serviceres" in row 1
Then the table has 6 rows
Then field "datumvon" has value "05.12.1995" in row 1
Then field "datumbis" has value "05.12.1995" in row 1
Then field "zzvon" has value "8:00" in row 1
Then field "zzbis" has value "12:00" in row 1
Then field "dauernetto" has value "0D01h00m" in row 1
Then field "dauernetto" is empty in row 2
Then field "dauernetto" is empty in row 3
Then field "dauernetto" is empty in row 4
Then field "dauernetto" is empty in row 5
Then field "dauernetto" is empty in row 6
Then field "datumvon" has value "10.12.1995" in row 6
Then field "datumbis" has value "10.12.1995" in row 6
Then field "zzvon" has value "8:00" in row 6
Then field "zzbis" has value "12:00" in row 6
When I set field "datumvon" to "11.12.95" in row 1
And I save the current editor
When I switch the current editor to editor "serauftrag"
Then field "datumvon" has value "06.12.1995" in row 1
Then field "datumbis" has value "11.12.1995" in row 1
When I set field "datumvon" to "07.12.95" in row 1
And I press button "srabsteig" to open a subeditor for "serviceres" in row 1
Then the table has 6 rows
Then field "datumvon" has value "12.12.1995" in row 1
Then field "datumbis" has value "12.12.1995" in row 1
Then field "zzvon" has value "8:00" in row 1
Then field "zzbis" has value "12:00" in row 1
Then field "datumvon" has value "07.12.1995" in row 2
Then field "datumvon" has value "08.12.1995" in row 3
Then field "datumvon" has value "09.12.1995" in row 4
Then field "datumvon" has value "10.12.1995" in row 5
Then field "datumvon" has value "11.12.1995" in row 6
Then field "datumbis" has value "11.12.1995" in row 6
Then field "zzvon" has value "8:00" in row 6
Then field "zzbis" has value "12:00" in row 6
When I set field "zzvon" to "9" in row 1
Then field "zzbis" has value "13:00" in row 1
And I set field "zzvon" to "9" in row 2
Then field "zzbis" has value "13:00" in row 2
And I set field "zzvon" to "9" in row 3
Then field "zzbis" has value "13:00" in row 3
And I set field "zzvon" to "9" in row 4
Then field "zzbis" has value "13:00" in row 4
And I set field "zzvon" to "9" in row 5
Then field "zzbis" has value "13:00" in row 5
And I set field "zzvon" to "9" in row 6
Then field "zzbis" has value "13:00" in row 6
And I save the current editor
When I switch the current editor to editor "serauftrag"
Then field "zzvon" has value "9:00" in row 1
Then field "zzbis" has value "13:00" in row 1
Then field "eineprotag" is not modifiable in row 1
And I save the current editor

@service
Scenario: EVS-508 Ein Serviceangebot mit mehrtaegiger Servicereservierung anlegen und den Termin aus Angebot und Servicereservierung verschieben
Given I open an editor "serangebot" from table "(Sales):(ServiceQuotation)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "ASBAYRAM"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "datumvon" to "5.12.95" in row 1
And I set field "datumbis" to "10.12.95" in row 1
And I set field "ganztag" to "nein" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "16" in row 1
Then field "dauer" has value "5D08h00m" in row 1
And I press button "srabsteig" to open a subeditor for "serviceres" in row 1
Then the table has 1 rows
Then field "datumvon" has value "05.12.1995" in row 1
Then field "datumbis" has value "10.12.1995" in row 1
Then field "zzvon" has value "8:00" in row 1
Then field "zzbis" has value "16:00" in row 1
When I set field "datumvon" to "06.12.95" in row 1
And I save the current editor
When I switch the current editor to editor "serangebot"
Then field "datumvon" has value "06.12.1995" in row 1
Then field "datumbis" has value "11.12.1995" in row 1
When I set field "datumvon" to "07.12.95" in row 1
And I press button "srabsteig" to open a subeditor for "serviceres" in row 1
Then the table has 1 rows
Then field "datumvon" has value "07.12.1995" in row 1
Then field "datumbis" has value "12.12.1995" in row 1
Then field "zzvon" has value "8:00" in row 1
Then field "zzbis" has value "16:00" in row 1
When I set field "zzvon" to "9" in row 1
Then field "zzbis" has value "17:00" in row 1
And I save the current editor
When I switch the current editor to editor "serangebot"
Then field "zzvon" has value "9:00" in row 1
Then field "zzbis" has value "17:00" in row 1
Then field "eineprotag" is not modifiable in row 1
When I set field "datumbis" to "13.12.95" in row 1
And I set field "zzbis" to "18" in row 1
Then field "datumvon" has value "07.12.1995" in row 1
Then field "zzvon" has value "9:00" in row 1
And I press button "srabsteig" to open a subeditor for "serviceres" in row 1
Then the table has 1 rows
Then field "datumvon" has value "07.12.1995" in row 1
Then field "datumbis" has value "13.12.1995" in row 1
Then field "zzvon" has value "9:00" in row 1
Then field "zzbis" has value "18:00" in row 1
And I save the current editor

@service
Scenario: EVS-508 Einen Serviceauftrag mit mehrtaegiger Servicereservierung anlegen und den Termin aus Auftrag und Servicereservierung verschieben
Given I open an editor "serauftrag" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "BSBAYRAM"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "datumvon" to "5.12.95" in row 1
And I set field "datumbis" to "10.12.95" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "16" in row 1
Then field "dauer" has value "5D08h00m" in row 1
And I press button "srabsteig" to open a subeditor for "serviceres" in row 1
Then the table has 1 rows
Then field "datumvon" has value "05.12.1995" in row 1
Then field "datumbis" has value "10.12.1995" in row 1
Then field "zzvon" has value "8:00" in row 1
Then field "zzbis" has value "16:00" in row 1
When I set field "datumvon" to "06.12.95" in row 1
And I save the current editor
When I switch the current editor to editor "serauftrag"
Then field "datumvon" has value "06.12.1995" in row 1
Then field "datumbis" has value "11.12.1995" in row 1
When I set field "datumvon" to "07.12.95" in row 1
And I press button "srabsteig" to open a subeditor for "serviceres" in row 1
Then the table has 1 rows
Then field "datumvon" has value "07.12.1995" in row 1
Then field "datumbis" has value "12.12.1995" in row 1
Then field "zzvon" has value "8:00" in row 1
Then field "zzbis" has value "16:00" in row 1
When I set field "zzvon" to "9" in row 1
Then field "zzbis" has value "17:00" in row 1
And I save the current editor
When I switch the current editor to editor "serauftrag"
Then field "zzvon" has value "9:00" in row 1
Then field "zzbis" has value "17:00" in row 1
Then field "eineprotag" is not modifiable in row 1
When I set field "datumbis" to "13.12.95" in row 1
And I set field "zzbis" to "18" in row 1
Then field "datumvon" has value "07.12.1995" in row 1
Then field "zzvon" has value "9:00" in row 1
And I press button "srabsteig" to open a subeditor for "serviceres" in row 1
Then the table has 1 rows
Then field "datumvon" has value "07.12.1995" in row 1
Then field "datumbis" has value "13.12.1995" in row 1
Then field "zzvon" has value "9:00" in row 1
Then field "zzbis" has value "18:00" in row 1
And I save the current editor

@service
Scenario: EVS-560 Test der Skipfelder in der Servicereservierung
Given I open an editor "serviceres" from table "(ServiceReservation):(ServiceReservations)" with command "UPDATE" for record ""
And I create a new row at the end of the table
And I set field "resart" to "Offener Termin" in row 1
And I set field "techniker" to id from editor "techniker" in row 1
And I set field "kunde" to id from editor "kunde" in row 1
And I set field "dienstl" to id from editor "dienstl" in row 1
And I set field "datumvon" to "04.12.95" in row 1
Then field "tagname" has value "Montag" in row 1
Then field "datumbis" has value "04.12.1995" in row 1
Then field "termvon" has value "04.12.1995" in row 1
Then field "termbis" has value "04.12.1995" in row 1
When I set field "zzvon" to "8" in row 1
Then field "termvon" has value "04.12.1995 08:00:00" in row 1
When I set field "zzbis" to "12" in row 1
Then field "termbis" has value "04.12.1995 12:00:00" in row 1
When I set field "datumvon" to "5.12.95" in row 1
Then field "datumbis" has value "05.12.1995" in row 1
Then field "zzvon" has value "8:00" in row 1
Then field "zzbis" has value "12:00" in row 1
Then field "termvon" has value "05.12.1995 08:00:00" in row 1
Then field "termbis" has value "05.12.1995 12:00:00" in row 1
Then field "tagname" has value "Dienstag" in row 1
When I set field "datumbis" to "7.12.95" in row 1
Then field "datumvon" has value "05.12.1995" in row 1
Then field "zzvon" has value "8:00" in row 1
Then field "zzbis" has value "12:00" in row 1
Then field "termvon" has value "05.12.1995 08:00:00" in row 1
Then field "termbis" has value "07.12.1995 12:00:00" in row 1
Then field "tagname" has value "Dienstag" in row 1
When I set field "zzvon" to "10" in row 1
Then field "datumvon" has value "05.12.1995" in row 1
Then field "datumbis" has value "07.12.1995" in row 1
Then field "zzvon" has value "10:00" in row 1
Then field "zzbis" has value "14:00" in row 1
Then field "termvon" has value "05.12.1995 10:00:00" in row 1
Then field "termbis" has value "07.12.1995 14:00:00" in row 1
Then field "tagname" has value "Dienstag" in row 1
When I set field "zzbis" to "15" in row 1
Then field "datumvon" has value "05.12.1995" in row 1
Then field "datumbis" has value "07.12.1995" in row 1
Then field "zzvon" has value "10:00" in row 1
Then field "zzbis" has value "15:00" in row 1
Then field "termvon" has value "05.12.1995 10:00:00" in row 1
Then field "termbis" has value "07.12.1995 15:00:00" in row 1
Then field "tagname" has value "Dienstag" in row 1
When I set field "zzvon" to "22" in row 1
Then field "datumvon" has value "05.12.1995" in row 1
Then field "datumbis" has value "08.12.1995" in row 1
Then field "zzvon" has value "22:00" in row 1
Then field "zzbis" has value "3:00" in row 1
Then field "termvon" has value "05.12.1995 22:00:00" in row 1
Then field "termbis" has value "08.12.1995 03:00:00" in row 1
Then field "tagname" has value "Dienstag" in row 1
And I save the current editor

@service
Scenario: EVS-560 Test der Skipfelder in der Servicereservierung
Given I open an editor "serviceres" from table "(ServiceReservation):(ServiceReservations)" with command "UPDATE" for record ""
And I set field "resart" to "Offener Termin"
And I set field "dienstl" to id from editor "dienstl"
And I set field "techniker" to id from editor "techniker"
And I press button "ladetab"
Then the table has 8 rows
Then field "datumvon" has value "05.12.1995" in row 8
Then field "datumbis" has value "08.12.1995" in row 8
Then field "zzvon" has value "22:00" in row 8
Then field "zzbis" has value "3:00" in row 8
Then field "termvon" has value "05.12.1995 22:00:00" in row 8
Then field "termbis" has value "08.12.1995 03:00:00" in row 8
Then field "tagname" has value "Dienstag" in row 8

@service
Scenario: EVS-655 Eine mehrtaegige Servicereservierung als Einzeltermine anlegen
Given I open an editor "serviceres" from table "(ServiceReservation):(ServiceReservations)" with command "UPDATE" for record ""
And I create a new row at the end of the table
And I set field "resart" to "Offener Termin" in row 1
And I set field "techniker" to id from editor "techniker" in row 1
And I set field "kunde" to id from editor "kunde" in row 1
And I set field "dienstl" to id from editor "dienstl" in row 1
And I set field "datumvon" to "04.12.95" in row 1
Then field "datumbis" has value "04.12.1995" in row 1
Then field "tplan" is not empty in row 1
Then field "splan" is not empty in row 1
Then field "schichtnr" is not empty in row 1
When I set field "datumbis" to "08.12.95" in row 1
Then field "tplan" is empty in row 1
Then field "splan" is empty in row 1
Then field "schichtnr" has value "0" in row 1
When I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "14" in row 1
And I set field "anreisedatumvon" to "03.12.95" in row 1
And I set field "anreisezvon" to "18" in row 1
And I set field "abreisedatumbis" to "08.12.95" in row 1
And I set field "abreisezbis" to "18" in row 1
And I respond with answer "Ja" to the dialog with id "588"
And I press button "resanlegen" in row 1
Then the table has 5 rows
Then field "datumvon" has value "04.12.1995" in row 1
Then field "zzvon" has value "8:00" in row 1
Then field "datumbis" has value "04.12.1995" in row 1
Then field "zzbis" has value "14:00" in row 1
Then field "anreisedatumvon" has value "03.12.1995" in row 1
Then field "anreisezvon" has value "18:00" in row 1
Then field "abreisedatumbis" is empty in row 1
Then field "abreisezbis" is empty in row 1
Then field "datumvon" has value "05.12.1995" in row 2
Then field "zzvon" has value "8:00" in row 2
Then field "datumbis" has value "05.12.1995" in row 2
Then field "zzbis" has value "14:00" in row 2
Then field "anreisedatumvon" is empty in row 2
Then field "anreisezvon" is empty in row 2
Then field "abreisedatumbis" is empty in row 2
Then field "abreisezbis" is empty in row 2
Then field "datumvon" has value "06.12.1995" in row 3
Then field "zzvon" has value "8:00" in row 3
Then field "datumbis" has value "06.12.1995" in row 3
Then field "zzbis" has value "14:00" in row 3
Then field "anreisedatumvon" is empty in row 3
Then field "anreisezvon" is empty in row 3
Then field "abreisedatumbis" is empty in row 3
Then field "abreisezbis" is empty in row 3
Then field "datumvon" has value "07.12.1995" in row 4
Then field "zzvon" has value "8:00" in row 4
Then field "datumbis" has value "07.12.1995" in row 4
Then field "zzbis" has value "14:00" in row 4
Then field "anreisedatumvon" is empty in row 4
Then field "anreisezvon" is empty in row 4
Then field "abreisedatumbis" is empty in row 4
Then field "abreisezbis" is empty in row 4
Then field "datumvon" has value "08.12.1995" in row 5
Then field "zzvon" has value "8:00" in row 5
Then field "datumbis" has value "08.12.1995" in row 5
Then field "zzbis" has value "14:00" in row 5
Then field "anreisedatumvon" is empty in row 5
Then field "anreisezvon" is empty in row 5
Then field "abreisedatumbis" has value "08.12.1995" in row 5
Then field "abreisezbis" has value "18:00" in row 5
And I save the current editor

@service
Scenario: EVS-501 Feldsteuerung & Plausibilitaetspruefungen zum An- und Abreisedatum
Given I open an editor "serviceres" from table "(ServiceReservation):(ServiceReservations)" with command "UPDATE" for record ""
And I create a new row at the end of the table
And I set field "resart" to "Offener Termin" in row 1
And I set field "techniker" to id from editor "techniker" in row 1
And I set field "kunde" to id from editor "kunde" in row 1
And I set field "dienstl" to id from editor "dienstl" in row 1
Then saving the current editor throws the exception ""
Then field "anreisedatumvon" is not modifiable in row 1
Then field "anreisezvon" is not modifiable in row 1
Then field "abreisedatumbis" is not modifiable in row 1
Then field "abreisezbis" is not modifiable in row 1
Then field "anreisedatumvon" is empty in row 1
Then field "anreisezvon" is empty in row 1
Then field "abreisedatumbis" is empty in row 1
Then field "abreisezbis" is empty in row 1
When I set field "datumvon" to "05.12.95" in row 1
Then field "datumbis" has value "05.12.1995" in row 1
Then saving the current editor throws the exception ""
And I set field "datumvon" to "06.12.95" in row 1
Then field "datumbis" has value "06.12.1995" in row 1
Then field "anreisedatumvon" is empty in row 1
Then field "abreisedatumbis" is empty in row 1
When setting field "datumbis" to "5.12.95" in row 1 throws the exception ""
When I set field "datumbis" to "6.12.95" in row 1
And I set field "zzvon" to "12" in row 1
Then setting field "zzbis" to "11" in row 1 throws the exception ""
When I set field "zzbis" to "15" in row 1
Then field "anreisedatumvon" is modifiable in row 1
Then field "anreisezvon" is modifiable in row 1
Then field "abreisedatumbis" is modifiable in row 1
Then field "abreisezbis" is modifiable in row 1
Then field "anreisedatumvon" is empty in row 1
Then field "anreisezvon" is empty in row 1
Then field "abreisedatumbis" is empty in row 1
Then field "abreisezbis" is empty in row 1
Then setting field "anreisedatumvon" to "7.12.95" in row 1 throws the exception ""
When I set field "anreisedatumvon" to "6.12.95" in row 1
Then setting field "anreisezvon" to "13" in row 1 throws the exception ""
When I set field "anreisezvon" to "10" in row 1
Then setting field "abreisedatumbis" to "5.12.95" in row 1 throws the exception ""
When I set field "abreisedatumbis" to "6.12.95" in row 1
Then setting field "abreisezbis" to "14" in row 1 throws the exception ""
When I set field "abreisezbis" to "18" in row 1
And I set field "zzvon" to "11" in row 1
Then field "zzbis" has value "14:00" in row 1
Then field "anreisezvon" has value "9:00" in row 1
Then field "abreisezbis" has value "17:00" in row 1
When I set field "zzbis" to "15" in row 1
Then field "abreisezbis" has value "18:00" in row 1
When I set field "ganztag" to "ja" in row 1
Then field "zzvon" is not modifiable in row 1
Then field "zzbis" is not modifiable in row 1
Then field "zzvon" is empty in row 1
Then field "zzbis" is empty in row 1
Then field "anreisedatumvon" is empty in row 1
Then field "abreisedatumbis" is empty in row 1
Then field "anreisezvon" is empty in row 1
Then field "abreisezbis" is empty in row 1
Then setting field "anreisedatumvon" to "06.12.1995" in row 1 throws the exception ""
Then setting field "abreisedatumbis" to "06.12.1995" in row 1 throws the exception ""
When I set field "anreisedatumvon" to "05.12.1995" in row 1
And I set field "abreisedatumbis" to "07.12.1995" in row 1
And I set field "ganztag" to "nein" in row 1
Then field "anreisedatumvon" is not modifiable in row 1
Then field "anreisedatumvon" has value "05.12.1995" in row 1
Then field "anreisezvon" is not modifiable in row 1
Then field "abreisedatumbis" is not modifiable in row 1
Then field "abreisedatumbis" has value "07.12.1995" in row 1
Then field "abreisezbis" is not modifiable in row 1
Then saving the current editor throws the exception ""
When I set field "datumvon" to "4.12.95" in row 1
Then field "datumbis" has value "04.12.1995" in row 1
Then field "anreisedatumvon" has value "03.12.1995" in row 1
Then field "abreisedatumbis" has value "05.12.1995" in row 1
When I set field "datumbis" to "5.12.95" in row 1
Then field "abreisedatumbis" has value "06.12.1995" in row 1
Then saving the current editor throws the exception ""
When I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "17" in row 1
And I save the current editor

@service
Scenario: EVS-507 Maskensteuerung fuer Ganztag Felder Serviceangebot
Given I open an editor "sangebot" from table "(Sales):(ServiceQuotation)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "ASBAYRAM"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
Then field "ganztag" has value "ja" in row 1
Then field "zzvon" is not modifiable in row 1
Then field "zzbis" is not modifiable in row 1
When I set field "ganztag" to "nein" in row 1
Then field "zzvon" is modifiable in row 1
Then field "zzbis" is modifiable in row 1
And I set field "datumvon" to "5.12.95" in row 1
And I set field "datumbis" to "6.12.95" in row 1
And I set field "zzvon" to "9" in row 1
And I set field "zzbis" to "15" in row 1
And I set field "ganztag" to "ja" in row 1
Then field "zzvon" is not modifiable in row 1
Then field "zzbis" is not modifiable in row 1
When I set field "ganztag" to "nein" in row 1
Then field "zzvon" is empty in row 1
Then field "zzbis" is empty in row 1
When I set field "zzvon" to "10" in row 1
Then field "zzbis" is empty in row 1
Then saving the current editor throws the exception ""
When I set field "ganztag" to "ja" in row 1
And I press button "srabsteig" to open a subeditor for "serviceres" in row 1
Then the table has 1 rows
Then field "ganztag" has value "ja" in row 1
And I set field "ganztag" to "nein" in row 1
And I set field "zzvon" to "10" in row 1
And I set field "zzbis" to "15" in row 1
And I set field "datumvon" to "7.12.95" in row 1
And I set field "datumbis" to "8.12.95" in row 1
And I save the current editor
And I switch the current editor to editor "sangebot"
Then field "ganztag" has value "nein" in row 1
Then field "zzvon" has value "10:00" in row 1
Then field "zzbis" has value "15:00" in row 1
Then field "datumvon" has value "07.12.1995" in row 1
Then field "datumbis" has value "08.12.1995" in row 1
Then field "eineprotag" is not modifiable in row 1
And I save the current editor

@service
Scenario: EVS-507 Maskensteuerung fuer Ganztag Felder Serviceauftrag
Given I open an editor "sauftrag" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "BSBAYRAM"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
Then field "ganztag" has value "nein" in row 1
Then field "zzvon" is empty in row 1
Then field "zzbis" is empty in row 1
Then field "zzvon" is modifiable in row 1
Then field "zzbis" is modifiable in row 1
And I set field "datumvon" to "5.12.95" in row 1
And I set field "datumbis" to "6.12.95" in row 1
And I set field "zzvon" to "9" in row 1
And I set field "zzbis" to "15" in row 1
And I set field "ganztag" to "ja" in row 1
Then field "zzvon" is not modifiable in row 1
Then field "zzbis" is not modifiable in row 1
When I set field "ganztag" to "nein" in row 1
Then field "zzvon" is empty in row 1
Then field "zzbis" is empty in row 1
When I set field "zzvon" to "10" in row 1
Then field "zzbis" is empty in row 1
Then saving the current editor throws the exception ""
When I set field "ganztag" to "ja" in row 1
And I press button "srabsteig" to open a subeditor for "serviceres" in row 1
Then the table has 1 rows
Then field "ganztag" has value "ja" in row 1
And I set field "ganztag" to "nein" in row 1
And I set field "zzvon" to "10" in row 1
And I set field "zzbis" to "15" in row 1
And I set field "datumvon" to "7.12.95" in row 1
And I set field "datumbis" to "8.12.95" in row 1
And I save the current editor
And I switch the current editor to editor "sauftrag"
Then field "ganztag" has value "nein" in row 1
Then field "zzvon" has value "10:00" in row 1
Then field "zzbis" has value "15:00" in row 1
Then field "datumvon" has value "07.12.1995" in row 1
Then field "datumbis" has value "08.12.1995" in row 1
Then field "eineprotag" is not modifiable in row 1
And I save the current editor

@service
Scenario: EVS-507 Maskensteuerung fuer Ganztag Felder Rahmenauftrag
Given I open an editor "rahmenauftrag" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "XSBAYRAM"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "10" in row 1
And I set field "ganztag" to "ja" in row 1
Then field "zzvon" is not modifiable in row 1
Then field "zzbis" is not modifiable in row 1
When I set field "ganztag" to "nein" in row 1
And I set field "datumvon" to "5.12.95" in row 1
And I set field "zzvon" to "11" in row 1
And I set field "datumbis" to "5.12.95" in row 1
Then setting field "zzbis" to "10" in row 1 throws the exception ""
When I set field "zzbis" to "13" in row 1
And I set field "zzbis" to "" in row 1
And I set field "datumbis" to "" in row 1
And I save the current editor

@service
Scenario: EVS-507 Maskensteuerung fuer Ganztag Felder Servicereservierung
Given I open an editor "serviceres" from table "(ServiceReservation):(ServiceReservations)" with command "UPDATE" for record ""
And I create a new row at the end of the table
And I set field "resart" to "krank" in row 1
And I set field "techniker" to id from editor "techniker" in row 1
And I set field "kunde" to id from editor "kunde" in row 1
And I set field "dienstl" to id from editor "dienstl" in row 1
And I set field "datumvon" to "05.12.95" in row 1
Then field "datumbis" has value "05.12.1995" in row 1
Then field "zzvon" is empty in row 1
Then field "zzbis" is empty in row 1
Then field "ganztag" has value "nein" in row 1
Then saving the current editor throws the exception ""
When I set field "zzvon" to "9" in row 1
Then setting field "zzbis" to "8" in row 1 throws the exception ""
When I set field "zzbis" to "12" in row 1
And I set field "ganztag" to "ja" in row 1
Then field "zzvon" is not modifiable in row 1
Then field "zzbis" is not modifiable in row 1
Then setting field "anreisedatumvon" to "5.12.95" in row 1 throws the exception ""
When I set field "anreisedatumvon" to "4.12.95" in row 1
Then field "anreisezvon" is modifiable in row 1
Then setting field "abreisedatumbis" to "5.12.95" in row 1 throws the exception ""
When I set field "abreisedatumbis" to "6.12.95" in row 1
Then field "abreisezbis" is modifiable in row 1
And I save the current editor
#When I switch the current editor to editor "serviceres"
When I open an editor "serviceres" from table "(ServiceReservation):(ServiceReservations)" with command "UPDATE" for record ""
And I set field "resart" to "krank"
And I press button "ladetab"
Then field "ganztag" has value "ja" in row 1

@Service
Scenario: Plausis fuer Dauer Feld in Servicereservierung Sonderfall Einzeltermin
Given I open an editor "serviceauf" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I create a new row at the end of the table
And I set field "techniker" to id from editor "techniker" in row 1
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "10" in row 1
And I set field "datumvon" to "01.01.95" in row 1
And I set field "datumbis" to "02.01.95" in row 1
And I set field "zzvon" to "08:00" in row 1
And I set field "zzbis" to "07:00" in row 1
# Erwarteter Fehler: Bei einer Taetigkeit an Einzelterminen muss die Uhrzeit des Taetigkeitsende vor deren Beginn liegen.
And setting field "eineprotag" to "Ja" in row 1 throws the exception ""
And I set field "zzbis" to "09:00" in row 1
And I set field "eineprotag" to "Ja" in row 1
# Erwarteter Fehler: Enddatum muss groesser als oder gleich Anfangsdatum sein
And setting field "zzbis" to "06:00" in row 1 throws the exception ""
And I set field "ganztag" to "Nein" in row 1
Then field "datumvon" has value "01.01.1995" in row 1
Then field "datumbis" has value "02.01.1995" in row 1
Then field "zzvon" has value "8:00" in row 1
Then field "zzbis" has value "9:00" in row 1
Then field "termvon" has value "01.01.1995 08:00:00" in row 1
Then field "termbis" has value "02.01.1995 09:00:00" in row 1
Then field "dauer" has value "1D01h00m" in row 1
And I press button "srabsteig" to open a subeditor for "serviceres" in row 1
Then the table has 2 rows
Then field "datumvon" has value "01.01.1995" in row 1
Then field "datumbis" has value "01.01.1995" in row 1
Then field "zzvon" has value "8:00" in row 1
Then field "zzbis" has value "9:00" in row 1
Then field "datumvon" has value "02.01.1995" in row 2
Then field "datumbis" has value "02.01.1995" in row 2
Then field "zzvon" has value "8:00" in row 2
Then field "zzbis" has value "9:00" in row 2
And I close the current editor

Scenario: Berechnung Dauer fuer Serviceauftrag (Vorbereitung)
Given I open an editor "SerAuf2" from table "(Sales):(ServiceOrder)" with command "STORE" for record "SADAUER"
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "SADAUER"
And I create a new row at the end of the table
And I set field "artikel" to "TEXT" in row 1
And I save the current editor

Scenario Outline: Berechnung Dauer fuer Serviceauftrag
Given I open an editor "serviceauf" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record "SADAUER"
# Datumseingabe 1
And I create a new row at the end of the table
And I set field "techniker" to "id" from editor "techniker" in row !lastRow
And I set field "artikel" to "id" from editor "dienstl" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I set field "datumvon" to "<datumvon>" in row !lastRow
And I set field "datumbis" to "<datumbis>" in row !lastRow
And I set field "zzvon" to "<zzvon>" in row !lastRow
And I set field "zzbis" to "<zzbis>" in row !lastRow
And I set field "eineprotag" to "<eineprotag>" in row !lastRow
And I set field "ganztag" to "<ganztag>" in row !lastRow
Then field "datumvon" has value "<solldatumvon>" in row !lastRow
Then field "datumbis" has value "<solldatumbis>" in row !lastRow
Then field "zzvon" has value "<sollzzvon>" in row !lastRow
Then field "zzbis" has value "<sollzzbis>" in row !lastRow
Then field "termvon" has value "<solltermvon>" in row !lastRow
Then field "termbis" has value "<solltermbis>" in row !lastRow
Then field "dauer" has value "<solldauer>" in row !lastRow
And I press button "srabsteig" to open a subeditor for "serviceres" in row !lastRow
Then the table has <sollrows> rows
And I close the current editor
And I switch the current editor to editor "serviceauf" with command "UPDATE"
And I save the current editor

Examples:
 |row |datumvon |datumbis |zzvon |zzbis |eineprotag |ganztag |solldatumvon |solldatumbis |sollzzvon |sollzzbis |solltermvon         |solltermbis        |solldauer |sollrows |
 |01  |01.01.95 |01.01.95 |08:00 |16:00 |Ja         |Nein    |01.01.1995   |01.01.1995   |8:00      |16:00     |01.01.1995 08:00:00 |01.01.1995 16:00:00|0D08h00m  |1        |
 |02  |01.01.95 |02.01.95 |08:00 |16:00 |Ja         |Nein    |01.01.1995   |02.01.1995   |8:00      |16:00     |01.01.1995 08:00:00 |02.01.1995 16:00:00|1D08h00m  |2        |
 |03  |01.01.95 |02.01.95 |08:00 |09:00 |Ja         |Nein    |01.01.1995   |02.01.1995   |8:00      |9:00      |01.01.1995 08:00:00 |02.01.1995 09:00:00|1D01h00m  |2        |
 |04  |01.01.95 |08.01.95 |08:00 |12:00 |Ja         |Nein    |01.01.1995   |08.01.1995   |8:00      |12:00     |01.01.1995 08:00:00 |08.01.1995 12:00:00|7D04h00m  |8        |
 |05  |01.01.95 |02.01.95 |08:05 |16:23 |Ja         |Nein    |01.01.1995   |02.01.1995   |8:05      |16:23     |01.01.1995 08:05:00 |02.01.1995 16:23:00|1D08h18m  |2        |
 |06  |01.01.95 |01.01.95 |      |      |Ja         |Ja      |01.01.1995   |01.01.1995   |          |          |01.01.1995          |01.01.1995         |1D00h00m  |1        |
 |07  |01.01.95 |02.01.95 |      |      |Ja         |Ja      |01.01.1995   |02.01.1995   |          |          |01.01.1995          |02.01.1995         |2D00h00m  |2        |
 |08  |01.01.95 |08.01.95 |      |      |Ja         |Ja      |01.01.1995   |08.01.1995   |          |          |01.01.1995          |08.01.1995         |8D00h00m  |8        |
 |09  |01.01.95 |01.01.95 |08:00 |16:00 |Nein       |Nein    |01.01.1995   |01.01.1995   |8:00      |16:00     |01.01.1995 08:00:00 |01.01.1995 16:00:00|0D08h00m  |1        |
 |10  |01.01.95 |02.01.95 |08:00 |16:00 |Nein       |Nein    |01.01.1995   |02.01.1995   |8:00      |16:00     |01.01.1995 08:00:00 |02.01.1995 16:00:00|1D08h00m  |1        |
 |11  |01.01.95 |02.01.95 |08:00 |09:00 |Nein       |Nein    |01.01.1995   |02.01.1995   |8:00      |9:00      |01.01.1995 08:00:00 |02.01.1995 09:00:00|1D01h00m  |1        |
 |12  |01.01.95 |08.01.95 |08:00 |12:00 |Nein       |Nein    |01.01.1995   |08.01.1995   |8:00      |12:00     |01.01.1995 08:00:00 |08.01.1995 12:00:00|7D04h00m  |1        |
 |13  |01.01.95 |02.01.95 |08:05 |16:23 |Nein       |Nein    |01.01.1995   |02.01.1995   |8:05      |16:23     |01.01.1995 08:05:00 |02.01.1995 16:23:00|1D08h18m  |1        |
 |14  |01.01.95 |01.01.95 |      |      |Nein       |Ja      |01.01.1995   |01.01.1995   |          |          |01.01.1995          |01.01.1995         |1D00h00m  |1        |
 |15  |01.01.95 |02.01.95 |      |      |Nein       |Ja      |01.01.1995   |02.01.1995   |          |          |01.01.1995          |02.01.1995         |2D00h00m  |1        |
 |16  |01.01.95 |08.01.95 |      |      |Nein       |Ja      |01.01.1995   |08.01.1995   |          |          |01.01.1995          |08.01.1995         |8D00h00m  |1        |

# Berechnung der Bis-Zeiten nach Aenderung der Dauer
Scenario: Kopf SA
Given I open an editor "SerAuf2" from table "(Sales):(ServiceOrder)" with command "STORE" for record "DAUERTX"
And I set field "kunde" to "1"
And I set field "such" to "DAUERTX"
And I create a new row at the end of the table
And I set field "artikel" to "TEXT" in row 1
And I save the current editor

Scenario Outline: Tabelle
Given I open an editor "serviceauf" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record "DAUERTX"
# Datumseingabe 1
And I create a new row at the end of the table
And I set field "techniker" to "id" from editor "techniker" in row !lastRow
And I set field "artikel" to "id" from editor "dienstl" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I set field "datumvon" to "<datumvon>" in row !lastRow
And I set field "zzvon" to "<zzvon>" in row !lastRow
And I set field "ganztag" to "<ganztag>" in row !lastRow
And I set field "dauer" to "<dauer>" in row !lastRow
And I set field "eineprotag" to "<eineprotag>" in row !lastRow
Then field "datumvon" has value "<solldatumvon>" in row !lastRow
Then field "datumbis" has value "<solldatumbis>" in row !lastRow
Then field "zzvon" has value "<sollzzvon>" in row !lastRow
Then field "zzbis" has value "<sollzzbis>" in row !lastRow
Then field "termvon" has value "<solltermvon>" in row !lastRow
Then field "termbis" has value "<solltermbis>" in row !lastRow
Then field "dauer" has value "<solldauer>" in row !lastRow
And I save the current editor

Examples:
 |row |datumvon |zzvon |dauer     |solldatumbis |sollzzvon |sollzzbis |datumbis |eineprotag |ganztag |solldatumvon |solldatumbis |sollzzvon |sollzzbis |solltermvon         |solltermbis        |solldauer |
 |01  |01.01.95 |08:00 |0D08h00m  |01.01.1995   |8:00      |16:00     |01.01.95 |Ja         |Nein    |01.01.1995   |01.01.1995   |8:00      |16:00     |01.01.1995 08:00:00 |01.01.1995 16:00:00|0D08h00m  |
 |02  |01.01.95 |08:00 |1D08h00m  |02.01.1995   |8:00      |16:00     |02.01.95 |Ja         |Nein    |01.01.1995   |02.01.1995   |8:00      |16:00     |01.01.1995 08:00:00 |02.01.1995 16:00:00|1D08h00m  |
 |03  |01.01.95 |08:00 |1D01h00m  |02.01.1995   |8:00      |9:00      |02.01.95 |Ja         |Nein    |01.01.1995   |02.01.1995   |8:00      |9:00      |01.01.1995 08:00:00 |02.01.1995 09:00:00|1D01h00m  |
 |04  |01.01.95 |08:00 |7D04h00m  |08.01.1995   |8:00      |12:00     |08.01.95 |Ja         |Nein    |01.01.1995   |08.01.1995   |8:00      |12:00     |01.01.1995 08:00:00 |08.01.1995 12:00:00|7D04h00m  |
 |05  |01.01.95 |08:05 |1D08h18m  |02.01.1995   |8:05      |16:23     |02.01.95 |Ja         |Nein    |01.01.1995   |02.01.1995   |8:05      |16:23     |01.01.1995 08:05:00 |02.01.1995 16:23:00|1D08h18m  |
 |06  |01.01.95 |      |1D00h00m  |01.01.1995   |          |          |01.01.95 |Ja         |Ja      |01.01.1995   |01.01.1995   |          |          |01.01.1995          |01.01.1995         |1D00h00m  |
 |07  |01.01.95 |      |2D00h00m  |02.01.1995   |          |          |02.01.95 |Ja         |Ja      |01.01.1995   |02.01.1995   |          |          |01.01.1995          |02.01.1995         |2D00h00m  |
 |08  |01.01.95 |      |8D00h00m  |08.01.1995   |          |          |08.01.95 |Ja         |Ja      |01.01.1995   |08.01.1995   |          |          |01.01.1995          |08.01.1995         |8D00h00m  |
 |09  |01.01.95 |08:00 |0D08h00m  |01.01.1995   |8:00      |16:00     |01.01.95 |Nein       |Nein    |01.01.1995   |01.01.1995   |8:00      |16:00     |01.01.1995 08:00:00 |01.01.1995 16:00:00|0D08h00m  |
 |10  |01.01.95 |08:00 |1D08h00m  |02.01.1995   |8:00      |16:00     |02.01.95 |Nein       |Nein    |01.01.1995   |02.01.1995   |8:00      |16:00     |01.01.1995 08:00:00 |02.01.1995 16:00:00|1D08h00m  |
 |11  |01.01.95 |08:00 |1D01h00m  |02.01.1995   |8:00      |9:00      |02.01.95 |Nein       |Nein    |01.01.1995   |02.01.1995   |8:00      |9:00      |01.01.1995 08:00:00 |02.01.1995 09:00:00|1D01h00m  |
 |12  |01.01.95 |08:00 |7D04h00m  |08.01.1995   |8:00      |12:00     |08.01.95 |Nein       |Nein    |01.01.1995   |08.01.1995   |8:00      |12:00     |01.01.1995 08:00:00 |08.01.1995 12:00:00|7D04h00m  |
 |13  |01.01.95 |08:05 |1D08h18m  |02.01.1995   |8:05      |16:23     |02.01.95 |Nein       |Nein    |01.01.1995   |02.01.1995   |8:05      |16:23     |01.01.1995 08:05:00 |02.01.1995 16:23:00|1D08h18m  |
 |14  |01.01.95 |      |1D00h00m  |01.01.1995   |          |          |01.01.95 |Nein       |Ja      |01.01.1995   |01.01.1995   |          |          |01.01.1995          |01.01.1995         |1D00h00m  |
 |15  |01.01.95 |      |2D00h00m  |02.01.1995   |          |          |02.01.95 |Nein       |Ja      |01.01.1995   |02.01.1995   |          |          |01.01.1995          |02.01.1995         |2D00h00m  |
 |16  |01.01.95 |      |8D00h00m  |08.01.1995   |          |          |08.01.95 |Nein       |Ja      |01.01.1995   |08.01.1995   |          |          |01.01.1995          |08.01.1995         |8D00h00m  |

@service
Scenario: EVS-553 Test des Abgleichs zw. Servicereservierungen und Serviceangebot
# Serviceangebot mit 2 Positionen anlegen
Given I open an editor "serangebot" from table "(Sales):(ServiceQuotation)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "AERBAYRAM"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "hdienstl" in row 1
And I set field "mge" to "10" in row 1
And I set field "techniker" to id from editor "techniker" in row 1
And I set field "datumvon" to "05.12.95" in row 1
And I set field "ganztag" to "nein" in row 1
And I set field "zzvon" to "9" in row 1
Then field "datumbis" has value "05.12.1995" in row 1
Then field "zzbis" has value "19:00" in row 1
And I create a new row at the end of the table
And I set field "artikel" to id from editor "hdienstl" in row 2
And I set field "mge" to "5" in row 2
And I set field "techniker" to id from editor "techniker" in row 2
And I set field "datumvon" to "06.12.95" in row 2
And I set field "ganztag" to "nein" in row 2
And I set field "zzvon" to "10" in row 2
Then field "zzbis" has value "15:00" in row 2
Then field "datumbis" has value "06.12.1995" in row 2
And I save the current editor

Given I open an editor "serviceres" from table "(ServiceReservation):(ServiceReservations)" with command "UPDATE" for record ""
# Angebotspositionen in Servicereservierung laden und Termine aendern
And I set field "dienstl" to id from editor "hdienstl"
And I set field "techniker" to id from editor "techniker"
And I set field "resart" to "Angebotstermin"
And I press button "ladetab"
Then the table has 2 rows
Then field "datumvon" has value "06.12.1995" in row 1
Then field "zzvon" has value "10:00" in row 1
Then field "zzbis" has value "15:00" in row 1
Then field "datumvon" has value "05.12.1995" in row 2
Then field "zzvon" has value "9:00" in row 2
Then field "zzbis" has value "19:00" in row 2
And I set field "datumvon" to "07.12.95" in row 1
And I set field "datumbis" to "08.12.95" in row 1
And I set field "zzvon" to "9" in row 1
And I set field "zzbis" to "15" in row 1
And I set field "datumvon" to "09.12.95" in row 2
And I set field "datumbis" to "10.12.95" in row 2
And I set field "zzvon" to "8" in row 2
And I set field "zzbis" to "17" in row 2
And I save the current editor

Given I open an editor "serangebot" from table "(Sales):(ServiceQuotation)" with command "UPDATE" for record "AERBAYRAM"
# Test, ob Aenderungen ins Serviceangebot uebernommen wurden
Then the table has 2 rows
Then field "datumvon" has value "09.12.1995" in row 1
Then field "datumbis" has value "10.12.1995" in row 1
Then field "zzvon" has value "8:00" in row 1
Then field "zzbis" has value "17:00" in row 1
Then field "datumvon" has value "07.12.1995" in row 2
Then field "datumbis" has value "08.12.1995" in row 2
Then field "zzvon" has value "9:00" in row 2
Then field "zzbis" has value "15:00" in row 2
And I save the current editor

Given I open an editor "serauftrag" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
# Serviceauftrag mit 2 Positionen anlegen
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "AERBAYRAM"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "hdienstl" in row 1
And I set field "mge" to "10" in row 1
And I set field "datumvon" to "05.12.95" in row 1
And I set field "zzvon" to "9" in row 1
Then field "datumbis" has value "05.12.1995" in row 1
Then field "zzbis" has value "19:00" in row 1
And I create a new row at the end of the table
And I set field "artikel" to id from editor "hdienstl" in row 2
And I set field "mge" to "5" in row 2
And I set field "datumvon" to "06.12.95" in row 2
And I set field "zzvon" to "10" in row 2
Then field "zzbis" has value "15:00" in row 2
Then field "datumbis" has value "06.12.1995" in row 2
And I save the current editor

Given I open an editor "serviceres" from table "(ServiceReservation):(ServiceReservations)" with command "UPDATE" for record ""
# Auftragspositionen in Servicereservierung laden und Termine aendern
And I set field "dienstl" to id from editor "hdienstl"
And I set field "resart" to "Auftragstermin"
And I set field "termvon" to "05.12.1995"
And I set field "termbis" to "06.12.1995"
And I press button "ladetab"
Then the table has 2 rows
Then field "datumvon" has value "06.12.1995" in row 1
Then field "zzvon" has value "10:00" in row 1
Then field "zzbis" has value "15:00" in row 1
Then field "datumvon" has value "05.12.1995" in row 2
Then field "zzvon" has value "9:00" in row 2
Then field "zzbis" has value "19:00" in row 2
And I set field "datumvon" to "07.12.95" in row 1
And I set field "datumbis" to "08.12.95" in row 1
And I set field "zzvon" to "9" in row 1
And I set field "zzbis" to "15" in row 1
And I set field "datumvon" to "09.12.95" in row 2
And I set field "datumbis" to "10.12.95" in row 2
And I set field "zzvon" to "8" in row 2
And I set field "zzbis" to "17" in row 2
And I save the current editor

Given I open an editor "serauftrag" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record "AERBAYRAM"
# Test, ob Aenderungen in den Serviceauftrag uebernommen wurden
Then the table has 2 rows
Then field "datumvon" has value "09.12.1995" in row 1
Then field "datumbis" has value "10.12.1995" in row 1
Then field "zzvon" has value "8:00" in row 1
Then field "zzbis" has value "17:00" in row 1
Then field "datumvon" has value "07.12.1995" in row 2
Then field "datumbis" has value "08.12.1995" in row 2
Then field "zzvon" has value "9:00" in row 2
Then field "zzbis" has value "15:00" in row 2
And I save the current editor

#
# Berechnung dauernetto (Arbeitszeit) bei Servicereservierungen
#
@service
Scenario: Arbeitszeit in Servicereservierungen
Given I open an editor "serviceres" from table "(ServiceReservation):(ServiceReservations)" with command "UPDATE" for record ""
And I create a new row at the end of the table
And I set field "resart" to "Offener Termin" in row 1
And I set field "techniker" to id from editor "techniker" in row 1
And I set field "kunde" to id from editor "kunde" in row 1
And I set field "dienstl" to id from editor "dienstl" in row 1
And I set field "datumvon" to "01.01.1995" in row 1
And I set field "datumbis" to "01.01.1995" in row 1
And I set field "zzvon" to "08:00" in row 1
And I set field "zzbis" to "16:00" in row 1
# And I set field "dauernetto" to "1h" in row 1
Then field "datumvon" has value "01.01.1995" in row 1
Then field "datumbis" has value "01.01.1995" in row 1
Then field "zzvon" has value "8:00" in row 1
Then field "zzbis" has value "16:00" in row 1
Then field "termvon" has value "01.01.1995 08:00:00" in row 1
Then field "termbis" has value "01.01.1995 16:00:00" in row 1
Then field "dauer" has value "0D08h00m" in row 1
Then field "dauernetto" has value "" in row 1
And I save the current editor

#
# Berechnung dauernetto (Nettoarbeitszeit) bei Servicereservierungen
#
@service
Scenario Outline: Arbeitszeit in Servicereservierungen (Mehrfachtest)
Given I open an editor "serviceres" from table "(ServiceReservation):(ServiceReservations)" with command "UPDATE" for record ""
And I create a new row at the end of the table
And I set field "resart" to "Offener Termin" in row !lastRow
And I set field "techniker" to "id" from editor "techniker" in row !lastRow
And I set field "kunde" to id from editor "kunde" in row !lastRow
And I set field "dienstl" to "id" from editor "dienstl" in row !lastRow
And I set field "datumvon" to "<datumvon>" in row !lastRow
And I set field "datumbis" to "<datumbis>" in row !lastRow
And I set field "zzvon" to "<zzvon>" in row !lastRow
And I set field "zzbis" to "<zzbis>" in row !lastRow
And I set field "ganztag" to "<ganztag>" in row !lastRow
Then field "datumvon" has value "<solldatumvon>" in row !lastRow
Then field "datumbis" has value "<solldatumbis>" in row !lastRow
Then field "zzvon" has value "<sollzzvon>" in row !lastRow
Then field "zzbis" has value "<sollzzbis>" in row !lastRow
Then field "termvon" has value "<solltermvon>" in row !lastRow
Then field "termbis" has value "<solltermbis>" in row !lastRow
Then field "dauer" has value "<solldauer>" in row !lastRow
# In Servicereservierung neu immer leer
Then field "dauernetto" has value "" in row !lastRow
And I save the current editor

Examples:
 |row |datumvon |datumbis |zzvon |zzbis |ganztag |solldatumvon |solldatumbis |sollzzvon |sollzzbis |solltermvon         |solltermbis        |solldauer |
 |01  |01.01.95 |01.01.95 |08:00 |16:00 |Nein    |01.01.1995   |01.01.1995   |8:00      |16:00     |01.01.1995 08:00:00 |01.01.1995 16:00:00|0D08h00m  |
 |02  |01.01.95 |02.01.95 |08:00 |16:00 |Nein    |01.01.1995   |02.01.1995   |8:00      |16:00     |01.01.1995 08:00:00 |02.01.1995 16:00:00|1D08h00m  |
 |03  |01.01.95 |02.01.95 |08:00 |09:00 |Nein    |01.01.1995   |02.01.1995   |8:00      |9:00      |01.01.1995 08:00:00 |02.01.1995 09:00:00|1D01h00m  |
 |04  |01.01.95 |08.01.95 |08:00 |12:00 |Nein    |01.01.1995   |08.01.1995   |8:00      |12:00     |01.01.1995 08:00:00 |08.01.1995 12:00:00|7D04h00m  |
 |05  |01.01.95 |02.01.95 |08:05 |16:23 |Nein    |01.01.1995   |02.01.1995   |8:05      |16:23     |01.01.1995 08:05:00 |02.01.1995 16:23:00|1D08h18m  |
 |06  |01.01.95 |01.01.95 |      |      |Ja      |01.01.1995   |01.01.1995   |          |          |01.01.1995          |01.01.1995         |1D00h00m  |
 |07  |01.01.95 |02.01.95 |      |      |Ja      |01.01.1995   |02.01.1995   |          |          |01.01.1995          |02.01.1995         |2D00h00m  |
 |08  |01.01.95 |08.01.95 |      |      |Ja      |01.01.1995   |08.01.1995   |          |          |01.01.1995          |08.01.1995         |8D00h00m  |
 |09  |01.01.95 |01.01.95 |08:00 |17:00 |Nein    |01.01.1995   |01.01.1995   |8:00      |17:00     |01.01.1995 08:00:00 |01.01.1995 17:00:00|0D09h00m  |
 |10  |01.01.95 |02.01.95 |08:00 |16:00 |Nein    |01.01.1995   |02.01.1995   |8:00      |16:00     |01.01.1995 08:00:00 |02.01.1995 16:00:00|1D08h00m  |
 |11  |01.01.95 |02.01.95 |08:00 |09:00 |Nein    |01.01.1995   |02.01.1995   |8:00      |9:00      |01.01.1995 08:00:00 |02.01.1995 09:00:00|1D01h00m  |
 |12  |01.01.95 |08.01.95 |08:00 |12:00 |Nein    |01.01.1995   |08.01.1995   |8:00      |12:00     |01.01.1995 08:00:00 |08.01.1995 12:00:00|7D04h00m  |
 |13  |01.01.95 |02.01.95 |08:05 |16:23 |Nein    |01.01.1995   |02.01.1995   |8:05      |16:23     |01.01.1995 08:05:00 |02.01.1995 16:23:00|1D08h18m  |
 |14  |01.01.95 |01.01.95 |      |      |Ja      |01.01.1995   |01.01.1995   |          |          |01.01.1995          |01.01.1995         |1D00h00m  |
 |15  |01.01.95 |02.01.95 |      |      |Ja      |01.01.1995   |02.01.1995   |          |          |01.01.1995          |02.01.1995         |2D00h00m  |
 |16  |01.01.95 |08.01.95 |      |      |Ja      |01.01.1995   |08.01.1995   |          |          |01.01.1995          |08.01.1995         |8D00h00m  |

@service
Scenario: Arbeitszeit in Servicereservierungen ueberschreiben
# dauernetto kann ueberschrieben werden
Given I open an editor "serviceres1" from table "(ServiceReservation):(ServiceReservations)" with command "UPDATE" for record ""
And I create a new row at the end of the table
And I set field "resart" to "Offener Termin" in row 1
And I set field "techniker" to id from editor "techniker" in row 1
And I set field "dienstl" to id from editor "dienstl" in row 1
And I set field "datumvon" to "01.01.95" in row 1
And I set field "datumbis" to "08.01.95" in row 1
And I set field "ganztag" to "ja" in row 1
And I set field "dauernetto" to "2D06h44m" in row 1
Then field "datumvon" has value "01.01.1995" in row 1
Then field "datumbis" has value "08.01.1995" in row 1
Then field "zzvon" has value "" in row 1
Then field "zzbis" has value "" in row 1
Then field "termvon" has value "01.01.1995" in row 1
Then field "termbis" has value "08.01.1995" in row 1
Then field "dauer" has value "8D00h00m" in row 1
Then field "dauernetto" has value "2D06h44m" in row 1
And I save the current editor

# Servicereservierung nochmal oeffnen und pruefen, dass der Wert auch gespeichert wurde
And I switch the current editor to editor "serviceres1"
Then field "dauernetto" has value "2D06h44m" in row 1
And I save the current editor

@service
Scenario: Servicerueckmeldung: Uebernahme der Arbeitszeit als offene Dauer
Given I open an editor "serauftragrueck" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
# Serviceauftrag anlegen
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "BSBAYRAM"
And I create a new row at the end of the table
And I set field "techniker" to id from editor "techniker" in row 1
And I set field "artikel" to id from editor "hdienstl" in row 1
And I set field "mge" to "8" in row 1
And I set field "datumvon" to "05.12.95" in row 1
And I set field "zzvon" to "9" in row 1
Then field "datumbis" has value "05.12.1995" in row 1
Then field "zzbis" has value "17:00" in row 1
And I save the current editor

# Servicerueckmeldung mit Arbeitszeit aus der Reservierung als Belegung fuer offene Dauer
Given I open an editor "servicerueckmeldung" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "serauftragrueck"
And I press button "ladetab"
Then the table has 1 rows
Then field "artikel" has value "DL-HANALYSE" in row 1
Then field "ofdauer" has value "0D08h00m" in row 1
And I set field "kstelle" to id from editor "kostenstelle"
And I set field "lgr" to "1"
And I save the current editor

@Service
Scenario: Plausis fuer Feld Arbeitszeit
Given I open an editor "serviceres" from table "(ServiceReservation):(ServiceReservations)" with command "NEW" for record ""
# Angebotspositionen in Servicereservierung laden und Termine Aendern
And I create a new row at the end of the table
And I set field "techniker" to id from editor "techniker" in row !lastRow
And I set field "dienstl" to id from editor "dienstl" in row !lastRow
And I set field "datumvon" to "07.12.95" in row !lastRow
And I set field "datumbis" to "08.12.95" in row !lastRow
And I set field "zzvon" to "9" in row !lastRow
And I set field "zzbis" to "15" in row !lastRow
Then field "dauernetto" has value "" in row !lastRow
And I set field "dauernetto" to "16h" in row !lastRow
Then field "dauernetto" has value "0D16h00m" in row !lastRow
# Erwarteter Fehler: Angegebener Zeitraum ungueltig!
And setting field "dauernetto" to "-1D" in row 1 throws the exception ""
And I close the current editor

@Service
Scenario: EVS-759 Arbeitszeit mge in Stunden aus Auftrag/Angebot übernehmen
#Serviceauftrag mit Dienstleistung und Menge in Stunden anlegen (eine Reservierung)
Given I open an editor "serviceauf" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I create a new row at the end of the table
And I set field "techniker" to id from editor "techniker" in row 1
And I set field "artikel" to id from editor "hdienstl" in row 1
And I set field "mge" to "10" in row 1
And I set field "datumvon" to "09.01.95" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "12" in row 1
And I set field "datumbis" to "12.1.95" in row 1
And I press button "srabsteig" to open a subeditor for "serviceres" in row 1
Then the table has 1 rows
Then field "dauernetto" has value "0D10h00m" in row 1
And I save the current editor
And I switch the current editor to editor "serviceauf"
#Menge ändern, Arbeitszeit darf sich nicht ändern
And I set field "mge" to "11" in row 1
And I set field "ganztag" to "ja" in row 1
And I press button "srabsteig" to open a subeditor for "serviceres" in row 1
Then the table has 1 rows
Then field "dauernetto" has value "0D10h00m" in row 1
And I save the current editor
And I switch the current editor to editor "serviceauf"
And I respond with answer "Ja" to the dialog with id "191"
And I set field "mge" to "0" in row 1
And I save the current editor

@Service
Scenario: Serviceauftrag mit Dienstleistung und Menge in Stunden anlegen eine Reservierung
Given I open an editor "serviceauf" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I create a new row at the end of the table
And I set field "techniker" to id from editor "techniker" in row 1
And I set field "artikel" to id from editor "hdienstl" in row 1
And I set field "mge" to "10" in row 1
And I set field "datumvon" to "09.01.95" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "12" in row 1
And I set field "datumbis" to "12.1.95" in row 1
And I press button "srabsteig" to open a subeditor for "serviceres" in row 1
Then the table has 1 rows
Then field "dauernetto" has value "0D10h00m" in row 1
#Mehrere Servicereservierungen anlegen
And I respond with answer "Ja" to the dialog with id "588"
When I press button "resanlegen" in row 1
Then the table has 4 rows
Then field "dauernetto" has value "0D10h00m" in row 1
And field "dauernetto" is empty in row 2
And field "dauernetto" is empty in row 3
And field "dauernetto" is empty in row 4
And I save the current editor
And I switch the current editor to editor "serviceauf"
#Menge ändern, Arbeitszeit darf sich nicht ändern
And I set field "mge" to "11" in row 1
And I press button "srabsteig" to open a subeditor for "serviceres" in row 1
Then the table has 4 rows
Then field "dauernetto" has value "0D10h00m" in row 1
And field "dauernetto" is empty in row 2
And field "dauernetto" is empty in row 3
And field "dauernetto" is empty in row 4
And I save the current editor
And I switch the current editor to editor "serviceauf"
And I respond with answer "Ja" to the dialog with id "191"
And I set field "mge" to "0" in row 1
And I save the current editor

@Service
Scenario: Serviceauftrag mit Dienstleistung und Menge in Stunden anlegen als Einzeltermine
Given I open an editor "serviceauf" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I create a new row at the end of the table
And I set field "techniker" to id from editor "techniker" in row 1
And I set field "artikel" to id from editor "hdienstl" in row 1
And I set field "mge" to "10" in row 1
And I set field "datumvon" to "09.01.95" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "12" in row 1
And I set field "datumbis" to "12.1.95" in row 1
And I set field "eineprotag" to "ja" in row 1
And I press button "srabsteig" to open a subeditor for "serviceres" in row 1
Then the table has 4 rows
Then field "dauernetto" has value "0D10h00m" in row 1
And field "dauernetto" is empty in row 2
And field "dauernetto" is empty in row 3
And field "dauernetto" is empty in row 4
And I save the current editor
And I switch the current editor to editor "serviceauf"
#Menge ändern, Arbeitszeit darf sich nicht ändern
And I set field "mge" to "11" in row 1
And I set field "ganztag" to "ja" in row 1
And I press button "srabsteig" to open a subeditor for "serviceres" in row 1
Then the table has 4 rows
Then field "dauernetto" has value "0D10h00m" in row 1
And field "dauernetto" is empty in row 2
And field "dauernetto" is empty in row 3
And field "dauernetto" is empty in row 4
And I save the current editor
And I switch the current editor to editor "serviceauf"
And I respond with answer "Ja" to the dialog with id "191"
And I set field "mge" to "0" in row 1
And I save the current editor

@Service
Scenario: Serviceauftrag mit Dienstleistung in Stueck und Menge in Stunden anlegen als Einzeltermine
Given I open an editor "serviceauf" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I create a new row at the end of the table
And I set field "techniker" to id from editor "techniker" in row 1
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "10" in row 1
And I set field "datumvon" to "09.01.95" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "12" in row 1
And I set field "datumbis" to "12.1.95" in row 1
And I set field "eineprotag" to "ja" in row 1
And I press button "srabsteig" to open a subeditor for "serviceres" in row 1
Then the table has 4 rows
Then field "dauernetto" is empty in row 1
And field "dauernetto" is empty in row 2
And field "dauernetto" is empty in row 3
And field "dauernetto" is empty in row 4
And I save the current editor
And I switch the current editor to editor "serviceauf"
#Menge ändern, Arbeitszeit darf sich nicht ändern
And I set field "mge" to "11" in row 1
And I set field "ganztag" to "ja" in row 1
And I press button "srabsteig" to open a subeditor for "serviceres" in row 1
Then the table has 4 rows
Then field "dauernetto" is empty in row 1
And field "dauernetto" is empty in row 2
And field "dauernetto" is empty in row 3
And field "dauernetto" is empty in row 4
And I save the current editor
And I switch the current editor to editor "serviceauf"
And I respond with answer "Ja" to the dialog with id "191"
And I set field "mge" to "0" in row 1
And I save the current editor

# Servicereservierungen in Einzelterminen mit ganztag=ja in der ersten SR
# Fuehrte zur falschen Anzeige in der Serviceauftragsposition
Scenario: Vorbereitung: Mehrtaegige Serviceauftragspositionen mit ganztag=ja in einer der Servicereservierungen
Given I open an editor "SerAuf2" from table "(Sales):(ServiceOrder)" with command "STORE" for record "GTAG"
And I set field "kunde" to "1"
And I set field "such" to "GTAG"
And I create a new row at the end of the table
And I set field "artikel" to "TEXT" in row 1
And I save the current editor

Scenario: Mehrtaegige Serviceauftragspositionen mit ganztag=ja in einer der Servicereservierungen
Given I open an editor "serviceauf" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record "GTAG"
And I create a new row at the end of the table
And I set field "techniker" to "id" from editor "techniker" in row !lastRow
And I set field "artikel" to "id" from editor "dienstl" in row !lastRow

And I set field "mge" to "10" in row !lastRow
And I set field "datumvon" to "01.01.95" in row !lastRow
And I set field "zzvon" to "08:00" in row !lastRow
And I set field "datumbis" to "03.01.1995" in row !lastRow
And I set field "zzbis" to "16:00" in row !lastRow
And I set field "ganztag" to "Nein" in row !lastRow
And I set field "eineprotag" to "Ja" in row !lastRow
Then field "termvon" has value "01.01.1995 08:00:00" in row !lastRow
Then field "termbis" has value "03.01.1995 16:00:00" in row !lastRow
Then field "dauer" has value "2D08h00m" in row !lastRow
And I press button "srabsteig" to open a subeditor for "serviceres" in row !lastRow
And I set field "ganztag" to "ja" in row 1
And I save the current editor
When I switch the current editor to editor "serviceauf"
Then field "datumvon" has value "01.01.1995" in row !lastRow
Then field "zzvon" has value "0:00" in row !lastRow
Then field "datumbis" has value "03.01.1995" in row !lastRow
Then field "zzbis" has value "16:00" in row !lastRow
And I save the current editor

@service
Scenario: EVS-763 Vorbelegung der Terminfelder bei der Freigabe von Rahmenauftraegen
Given I open an editor "ra-sbko" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "XSBKO"
And I set field "vorgart" to "SER_AUFTR"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "10" in row 1
And I set field "ganztag" to "ja" in row 1
And I set field "eineprotag" to "ja" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "E2" in row 2
And I set field "mge" to "10" in row 2
Then field "termvon" has value "02.01.1995" in row 1
Then field "termbis" has value "02.01.1995" in row 1
Then field "datumvon" has value "02.01.1995" in row 1
Then field "zzvon" is empty in row 1
Then field "datumbis" has value "02.01.1995" in row 1
Then field "zzbis" is empty in row 1
Then field "termvon" is empty in row 2
Then field "termbis" is empty in row 2
Then field "datumvon" has value "02.01.1995" in row 2
Then field "zzvon" is empty in row 2
Then field "datumbis" is empty in row 2
Then field "zzbis" is empty in row 2
And I save the current editor

Given I open an editor "ra-abko" from table "(Sales):(BlanketOrder)" with command "COPY" for record "XSBKO"
And I set field "such" to "XABKO"
And I set field "vorgart" to ""
Then field "termvon" has value "02.01.1995" in row 1
Then field "termbis" has value "02.01.1995" in row 1
Then field "datumvon" has value "02.01.1995" in row 1
Then field "zzvon" is empty in row 1
Then field "datumbis" has value "02.01.1995" in row 1
Then field "zzbis" is empty in row 1
Then field "ganztag" has value "ja" in row 1
Then field "eineprotag" has value "ja" in row 1
Then field "termvon" is empty in row 2
Then field "termbis" is empty in row 2
Then field "datumvon" has value "02.01.1995" in row 2
Then field "zzvon" is empty in row 2
Then field "datumbis" is empty in row 2
Then field "zzbis" is empty in row 2
And I save the current editor

Given I open an editor "au-sbko" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "XSBKO"
And I set field "such" to "BSBKO"
And I set field "ganztag" to "ja" in row 1
Then field "termvon" has value "02.01.1995" in row 1
Then field "termbis" has value "02.01.1995" in row 1
Then field "datumvon" has value "02.01.1995" in row 1
Then field "zzvon" is empty in row 1
Then field "datumbis" has value "02.01.1995" in row 1
Then field "zzbis" is empty in row 1
Then field "ganztag" has value "ja" in row 1
Then field "eineprotag" has value "ja" in row 1
Then field "termvon" is empty in row 2
Then field "termbis" is empty in row 2
Then field "datumvon" has value "02.01.1995" in row 2
Then field "zzvon" is empty in row 2
Then field "datumbis" is empty in row 2
Then field "zzbis" is empty in row 2
And I save the current editor

Given I open an editor "au-abko" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "XABKO"
And I set field "such" to "BABKO"
Then field "termvon" is empty in row 1
Then field "termbis" is empty in row 1
Then field "datumvon" has value "02.01.1995" in row 1
Then field "zzvon" is empty in row 1
Then field "datumbis" is empty in row 1
Then field "zzbis" is empty in row 1
Then field "ganztag" has value "nein" in row 1
Then field "eineprotag" has value "nein" in row 1
Then field "termvon" is empty in row 2
Then field "termbis" is empty in row 2
Then field "datumvon" has value "02.01.1995" in row 2
Then field "zzvon" is empty in row 2
Then field "datumbis" is empty in row 2
Then field "zzbis" is empty in row 2
And I save the current editor

@service
Scenario: EVS-763 Aktualisierung der Terminfelder beim Wechsel oder Leeren des Artikels im Serviceauftrag
Given I open an editor "serviceauf" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "10" in row 1
And I set field "ganztag" to "ja" in row 1
And I set field "eineprotag" to "ja" in row 1
Then field "termvon" has value "02.01.1995" in row 1
Then field "termbis" has value "02.01.1995" in row 1
Then field "datumvon" has value "02.01.1995" in row 1
Then field "zzvon" is empty in row 1
Then field "datumbis" has value "02.01.1995" in row 1
Then field "zzbis" is empty in row 1
Then field "ganztag" has value "ja" in row 1
Then field "eineprotag" has value "ja" in row 1
And I set field "artikel" to "" in row 1
Then field "termvon" is empty in row 1
Then field "termbis" is empty in row 1
Then field "datumvon" is empty in row 1
Then field "zzvon" is empty in row 1
Then field "datumbis" is empty in row 1
Then field "zzbis" is empty in row 1
Then field "ganztag" has value "nein" in row 1
Then field "eineprotag" has value "nein" in row 1
And I set field "artikel" to "E2" in row 1
Then field "termvon" is empty in row 1
Then field "termbis" is empty in row 1
Then field "datumvon" has value "02.01.1995" in row 1
Then field "zzvon" is empty in row 1
Then field "datumbis" is empty in row 1
Then field "zzbis" is empty in row 1
Then field "ganztag" has value "nein" in row 1
Then field "eineprotag" has value "nein" in row 1
And I set field "artikel" to id from editor "dienstl" in row 1
Then field "termvon" has value "02.01.1995" in row 1
Then field "termbis" has value "02.01.1995" in row 1
Then field "datumvon" has value "02.01.1995" in row 1
Then field "zzvon" is empty in row 1
Then field "datumbis" has value "02.01.1995" in row 1
Then field "zzbis" is empty in row 1
Then field "ganztag" has value "nein" in row 1
Then field "eineprotag" has value "nein" in row 1
And I close the current editor

Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "10" in row 1
Then field "termvon" is empty in row 1
Then field "termbis" is empty in row 1
Then field "datumvon" has value "02.01.1995" in row 1
Then field "zzvon" is empty in row 1
Then field "datumbis" is empty in row 1
Then field "zzbis" is empty in row 1
And I set field "artikel" to "" in row 1
Then field "termvon" is empty in row 1
Then field "termbis" is empty in row 1
Then field "datumvon" has value "02.01.1995" in row 1
Then field "zzvon" is empty in row 1
Then field "datumbis" is empty in row 1
Then field "zzbis" is empty in row 1
And I set field "artikel" to "E2" in row 1
Then field "termvon" is empty in row 1
Then field "termbis" is empty in row 1
Then field "datumvon" has value "02.01.1995" in row 1
Then field "zzvon" is empty in row 1
Then field "datumbis" is empty in row 1
Then field "zzbis" is empty in row 1
And I set field "artikel" to id from editor "dienstl" in row 1
Then field "termvon" is empty in row 1
Then field "termbis" is empty in row 1
Then field "datumvon" has value "02.01.1995" in row 1
Then field "zzvon" is empty in row 1
Then field "datumbis" is empty in row 1
Then field "zzbis" is empty in row 1
And I close the current editor

@service
Scenario: Vorbereitung: Einen Serviceauftrag anlegen. Synchronisation von SA nach SR testen
Given I open an editor "sauftrag" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "SASYNCH"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "ganztag" to "ja" in row 1
And I save the current editor

@service
Scenario: Synchronisation von SA nach SR testen
Given I open an editor "sauftrag" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record "SASYNCH"
And I create a new row at the end of the table
# SA Position mit einer SR wird synchronisiert!
And I set field "artikel" to id from editor "dienstl" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I set field "datumvon" to "5.12.95" in row !lastRow
And I set field "zzvon" to "5:45" in row !lastRow
And I set field "datumbis" to "5.12.95" in row !lastRow
And I set field "zzbis" to "8:45" in row !lastRow
And I set field "eineprotag" to "ja" in row !lastRow
And I press button "srabsteig" to open a subeditor for "serviceres" in row !lastRow
# Servicereservierung: Es existiert eine
Then the table has 1 rows
Then field "datumvon" has value "05.12.1995" in row 1
Then field "datumbis" has value "05.12.1995" in row 1
Then field "zzvon" has value "5:45" in row 1
Then field "zzbis" has value "8:45" in row 1
# Eine SR aendern
And I set field "datumvon" to "06.12.1995" in row 1
And I set field "zzvon" to "5:46" in row 1
And I set field "zzbis" to "8:46" in row 1
And I save the current editor
# Serviceauftrag: Werte haben sich geaendert
When I switch the current editor to editor "sauftrag"
Then field "datumvon" has value "06.12.1995" in row !lastRow
Then field "datumbis" has value "06.12.1995" in row !lastRow
Then field "zzvon" has value "5:46" in row !lastRow
Then field "zzbis" has value "8:46" in row !lastRow
# Serviceauftrag: Werte aendern
And I set field "datumvon" to "07.12.95" in row !lastRow
And I set field "zzvon" to "5:47" in row !lastRow
And I set field "datumvon" to "7.12.95" in row !lastRow
And I set field "zzbis" to "8:47" in row !lastRow
And I press button "srabsteig" to open a subeditor for "serviceres" in row !lastRow
# Servicereservierungen: Eine SR, Werte haben sich geaendert
Then the table has 1 rows
Then field "datumvon" has value "07.12.1995" in row 1
Then field "datumbis" has value "07.12.1995" in row 1
Then field "zzvon" has value "5:47" in row 1
Then field "zzbis" has value "8:47" in row 1
And I save the current editor
# Serviceauftrag: Anlegen Positionen mit mehreren SRs
When I switch the current editor to editor "sauftrag"
And I create a new row at the end of the table
# SA Position mit mehreren SR wird nicht synchronisiert!
And I set field "artikel" to id from editor "dienstl" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I set field "datumvon" to "5.12.95" in row !lastRow
And I set field "zzvon" to "5:33" in row !lastRow
And I set field "datumbis" to "6.12.95" in row !lastRow
And I set field "zzbis" to "8:33" in row !lastRow
And I set field "eineprotag" to "ja" in row !lastRow
And I press button "srabsteig" to open a subeditor for "serviceres" in row !lastRow
# Servicereservierung: Es existiertieren mehrere
Then the table has 2 rows
Then field "datumvon" has value "05.12.1995" in row 1
Then field "datumbis" has value "05.12.1995" in row 1
Then field "zzvon" has value "5:33" in row 1
Then field "zzbis" has value "8:33" in row 1
Then field "datumvon" has value "06.12.1995" in row 2
Then field "datumbis" has value "06.12.1995" in row 2
Then field "zzvon" has value "5:33" in row 2
Then field "zzbis" has value "8:33" in row 2
# Erste und letzte SR aendern aendern
And I set field "zzvon" to "5:32" in row 1
And I set field "zzbis" to "8:34" in row 2
And I save the current editor
# Serviceauftrag: Werte haben sich geaendert (Fruehste Uhrzeit, spaeteste Uhrzeit)
When I switch the current editor to editor "sauftrag"
Then field "datumvon" has value "05.12.1995" in row !lastRow
Then field "datumbis" has value "06.12.1995" in row !lastRow
Then field "zzvon" has value "5:32" in row !lastRow
Then field "zzbis" has value "8:34" in row !lastRow
# Serviceauftrag: Werte aendern
And I set field "datumvon" to "07.12.95" in row !lastRow
And I set field "zzvon" to "5:31" in row !lastRow
And I set field "zzbis" to "8:35" in row !lastRow
And I press button "srabsteig" to open a subeditor for "serviceres" in row !lastRow
# Servicereservierungen: Mehrere SR, Werte haben sich nicht geaendert
Then the table has 2 rows
Then field "datumvon" has value "06.12.1995" in row 1
Then field "datumbis" has value "06.12.1995" in row 1
Then field "zzvon" has value "5:32" in row 1
# Uhrzeit bis hat sich nach letzter Aenderung in den SR geaendert
Then field "zzbis" has value "8:32" in row 1
# Datumswerte aller SR verschieben sich
Then field "datumvon" has value "07.12.1995" in row 2
Then field "datumbis" has value "07.12.1995" in row 2
# Uhrzeiten wurden nicht synchronisiert
Then field "zzvon" has value "5:33" in row 2
Then field "zzbis" has value "8:34" in row 2
And I save the current editor

@servstl
Scenario Outline: Generierung von Serviceproduktstuecklisten - Stammdaten

# Einkaufsartikel anlegen
Given I open an editor "ek-teil-01" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | num2      | <num2>           |
   | such      | <such>           |
   | namebspr  | <namebspr>       |
   | bsart     | Fremdbeschaffung |
   | dispoa    | auftragsbezogen  |
   | lief      | 1                |
   | epr       | <epr>            |
   | abplatz   | F1               |
   | zuplatz   | F1               |
   | nwpflicht | ja               |
And I save the current editor

Examples:
   | num2   | such   | namebspr        | epr |
   | 001-EK | EK-001 | Einkaufsteil 1  | 10  |
   | 002-EK | EK-002 | Einkaufsteil 2  | 20  |
   | 003-EK | EK-003 | Einkaufsteil 3  | 30  |
   | 004-EK | EK-004 | Einkaufsteil 4  | 40  |
   | 005-EK | EK-005 | Einkaufsteil 5  | 50  |
   | 006-EK | EK-006 | Einkaufsteil 6  | 60  |
   | 007-EK | EK-007 | Einkaufsteil 7  | 70  |
   | 008-EK | EK-008 | Einkaufsteil 8  | 80  |
   | 009-EK | EK-009 | Einkaufsteil 9  | 90  |
   | 010-EK | EK-010 | Einkaufsteil 10 | 100 |

Scenario: Generierung von Serviceproduktstuecklisten - Stammdaten

# Baugruppen anlegen
Given I open an editor "baugr-01" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | num2      | 001-BG          |
   | such      | BG-001          |
   | namebspr  | Baugruppe 001   |
   | dispoa    | auftragsbezogen |
   | bsart     | Eigenfertigung  |
   | chimlager | ja              |
   | vpr       | 100             |
   | lief      | 1               |
   | epr       | 150             |
   | abplatz   | F1              |
   | zuplatz   | F1              |
And I append rows
   | elex       | elanzahl | tnwpflicht | manbu       |
   | EK-001     | 1        | ja         | ja          |
   | EK-002     | 2        | ja         | ja          |
   | EK-003     | 3        | ja         | ja          |
   | EK-004     | 4        | ja         | ja          |
   | A AG1      | 1        | nein       | !dontChange |
And I save the current editor

Given I open an editor "baugr-02" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | num2      | 002-BG          |
   | such      | BG-002          |
   | namebspr  | Baugruppe 002   |
   | dispoa    | auftragsbezogen |
   | bsart     | Eigenfertigung  |
   | chimlager | ja              |
   | vpr       | 200             |
   | abplatz   | F1              |
   | zuplatz   | F1              |
And I append rows
   | elex       | elanzahl | tnwpflicht |
   | EK-009     | 2        | ja         |
   | BG-001     | 3        | ja         |
   | EK-010     | 4        | ja         |
   | A AG2      | 1        | nein       |
And I save the current editor

# Charge anlegen
Given I create a Lot "CH-BG-001" for Product "BG-001"

# Serviceprodukte anlegen
Given I create a ServiceProduct "SP-BG-001" for Product "BG-001" and Lot with editor id "CH-BG-001"

Given I create a ServiceProduct "SP-BG-002" for Product "BG-002"

Scenario: Generierung von Serviceproduktstuecklisten - Beschaffung 1
Given I set the fake date to "10.01.1995"

Given I open an editor "1BE100" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | num4   | 1BE100 |
And I append rows
   | artex  | mge | vmge | platz | charge |
   | EK-001 | 1   | 1    | F1    |        |
   | EK-002 | 1   | 1    | F1    |        |
   | EK-003 | 1   | 1    | F1    |        |
   | EK-004 | 6   | 6    | F1    |        |
   | EK-005 | 1   | 1    | F1    |        |
   | EK-006 | 1   | 1    | F1    |        |
   | EK-007 | 1   | 1    | F1    |        |
   | EK-008 | 6   | 6    | F1    |        |
   | EK-009 | 1   | 1    | F1    |        |
   | EK-010 | 2   | 2    | F1    |        |
   | BG-001 | 1   | 1    | F1    | 1      |
And I save the current editor

Given I open an editor "1LS100" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE100"
And I set fields
   | num4 | 1LS100 |
   | vom  | .      |
   | ueb  | ja     |
And I save the current editor

Scenario: Generierung von Serviceproduktstuecklisten - Beschaffung 2
Given I set the fake date to "11.01.1995"

Given I open an editor "1BE200" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | num4   | 1BE200 |
And I append rows
   | artex  | mge | vmge | platz | charge |
   | EK-002 | 1   | 1    | F1    |        |
   | EK-003 | 1   | 1    | F1    |        |
   | EK-006 | 1   | 1    | F1    |        |
   | EK-007 | 1   | 1    | F1    |        |
   | EK-009 | 1   | 1    | F1    |        |
   | EK-010 | 2   | 1    | F1    |        |
And I save the current editor

Given I open an editor "1LS200" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE200"
And I set fields
   | num4 | 1LS200 |
   | vom  | .      |
   | ueb  | ja     |
And I save the current editor

Scenario: Generierung von Serviceproduktstuecklisten - Beschaffung 3
Given I set the fake date to "12.01.1995"

Given I open an editor "1BE300" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | num4   | 1BE300 |
And I append rows
   | artex  | mge | vmge | platz | charge |
   | EK-003 | 1   | 1    | F1    |        |
   | EK-007 | 1   | 1    | F1    |        |
And I save the current editor

Given I open an editor "1LS300" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE300"
And I set fields
   | num4 | 1LS300 |
   | vom  | .      |
   | ueb  | ja     |
And I save the current editor

Scenario: Generierung von Serviceproduktstuecklisten - Fertigung
Given I set the fake date to "15.01.1995"

# Baugruppen fertigen
Given I open an editor "fv" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
   | artikel | netmge | mfreig | serprod   |
   | BG-001  | 1      | ja     | SP-BG-001 |
   | BG-002  | 1      | ja     |           |
And I press button "absteig" to open a subeditor for "afl" in row 2
And I set field "charge" to id from editor "CH-BG-001" in row 2
And I save the current editor
And I switch the current editor to editor "fv"
And I set field "bisuch" to "BG001" in row 1
And I set field "bisuch" to "BG002" in row 2
And I set field "binoloe" to "ja" in row 2
And I press button "freig" to open a subeditor for "freig"
And I close the current editor
And I switch the current editor to editor "fv"
And I save the current editor

Given I open an editor "materialentnahme" for tip command "Fbuchung" and arguments ""
And I set field "auftrag" to "BG001001"
And I press button "stllad"
And I set field "bumge" to "1" in row 1
And I set field "bumge" to "2" in row 2
And I set field "bumge" to "1" in row 3
And I set field "bumge" to "2" in row 4
And I append rows
   | elex   | bumge |
   | EK-005 |  1    |
   | EK-006 |  2    |
   | EK-007 |  1    |
   | EK-008 |  2    |
And I save the current editor

Given I open an editor "materialentnahme" for tip command "Fbuchung" and arguments ""
And I set field "auftrag" to "BG001001"
And I press button "stllad"
And I set field "bumge" to " 0" in row 4
And I set field "bumge" to " 0" in row 3
And I set field "bumge" to "-1" in row 2
And I set field "bumge" to "-1" in row 1
And I append rows
   | elex   | bumge |
   | EK-005 | -1    |
   | EK-006 | -1    |
And I save the current editor

Given I open an editor "materialentnahme" for tip command "Fbuchung" and arguments ""
And I set field "auftrag" to "BG001001"
And I press button "stllad"
And I set field "bumge" to " 1" in row 1
And I set field "bumge" to " 0" in row 2
And I set field "bumge" to " 1" in row 3
And I set field "bumge" to " 2" in row 4
And I append rows
   | elex   | bumge |
   | EK-005 |  1    |
   | EK-007 |  1    |
   | EK-008 |  2    |
And I save the current editor

Given I open an editor "materialentnahme" for tip command "Fbuchung" and arguments ""
And I set field "auftrag" to "BG001001"
And I press button "stllad"
And I set field "bumge" to " 0" in row 4
And I set field "bumge" to " 0" in row 3
And I set field "bumge" to "-1" in row 2
And I set field "bumge" to " 0" in row 1
And I append rows
   | elex   | bumge |
   | EK-006 | -1    |
And I save the current editor

Given I open an editor "rueckmeldung" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BG001000"
And I set fields
   | sofort     | ja  |
   | mgr        | 101 |
   | stornorest | ja  |
And I set field "gutmge" to "1" in row 1
And I save the current editor

Given I open an editor "rueckmeldung" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BG002000"
And I set fields
   | sofort | ja  |
   | mgr    | 101 |
And I set field "gutmge" to "10" in row 1
And I save the current editor

Given I open an editor "rueckbau" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BG002000"
And I set fields
   | sofort | ja  |
   | mgr    | 101 |
And I set field "gutmge" to "-10" in row 1
And I save the current editor

Given I open an editor "rueckmeldung" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BG002000"
And I set fields
   | sofort | ja  |
   | mgr    | 101 |
And I set field "gutmge" to "1" in row 1
And I save the current editor

Given I open an editor "betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BG002000"
And I set field "noloesch" to "nein"
And I save the current editor

# Abgangslieferschein
Given I open an editor "1LS100" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1LS100 |
   | kunde  | 1      |
   | ueb    | ja     |
And I append rows
   | artikel | mge | serprod   |
   | BG-002  | 1   | SP-BG-002 |
And I save the current editor

# Service-STL ausgeben
Given I open an editor "SP-BG-001" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "SP-BG-001"
And I press button "absteigen" to open a subeditor for "stl"
Then I fill template "serviceproduktstueckliste.ftl" and append it to output file "serabwicklung.out"
And I close the current editor
And I switch the current editor to editor "SP-BG-001"
And I close the current editor

Given I open an editor "SP-BG-002" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "SP-BG-002"
And I press button "absteigen" to open a subeditor for "stl"
Then I fill template "serviceproduktstueckliste.ftl" and append it to output file "serabwicklung.out"
And I close the current editor
And I switch the current editor to editor "SP-BG-002"
And I close the current editor

Scenario: Generierung von Serviceproduktstuecklisten - Chargen und Unterbaugruppen

# Baugruppen anlegen
Given I open an editor "baugr-01" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | num2      | 010-BG          |
   | such      | BG-010          |
   | namebspr  | Baugruppe 010   |
   | dispoa    | auftragsbezogen |
   | bsart     | Eigenfertigung  |
   | chimlager | ja              |
   | vpr       | 100             |
   | lief      | 1               |
   | epr       | 150             |
   | abplatz   | F1              |
   | zuplatz   | F1              |
And I append rows
   | elex       | elanzahl | tnwpflicht |
   | A AG1      | 1        | nein       |
And I save the current editor

Given I open an editor "baugr-01" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | num2      | 011-BG          |
   | such      | BG-011          |
   | namebspr  | Baugruppe 011   |
   | dispoa    | auftragsbezogen |
   | bsart     | Eigenfertigung  |
   | chimlager | ja              |
   | vpr       | 100             |
   | lief      | 1               |
   | epr       | 150             |
   | abplatz   | F1              |
   | zuplatz   | F1              |
And I append rows
   | elex       | elanzahl | tnwpflicht | manbu       |
   | BG-010     | 1        | ja         | ja          |
   | A AG1      | 1        | nein       | !dontChange |
And I save the current editor

# Chargen anlegen
Given I create a Lot "BG-010-01" for Product "BG-010"
Given I create a Lot "BG-010-02" for Product "BG-010"
Given I create a Lot "BG-011-01" for Product "BG-011"
Given I create a Lot "BG-011-02" for Product "BG-011"

# Serviceprodukte anlegen
Given I create a ServiceProduct "BG-011-01" for Product "BG-011" and Lot with editor id "BG-011-01"
Given I create a ServiceProduct "BG-011-02" for Product "BG-011" and Lot with editor id "BG-011-02"

# Fertigung Unterbaugruppe
Given I open an editor "fv" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
   | artikel | netmge | mfreig | bisuch |
   | BG-010  | 2      | ja     | BG010  |
And I press button "freig" to open a subeditor for "freig"
And I close the current editor
And I switch the current editor to editor "fv"
And I save the current editor

Given I open an editor "rueckmeldung" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BG010000"
And I set fields
   | sofort  | ja        |
   | mgr     | 101       |
   | kcharge | BG-010-01 |
And I set field "gutmge" to "1" in row 1
And I save the current editor

Given I open an editor "rueckmeldung" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BG010000"
And I set fields
   | sofort  | ja        |
   | mgr     | 101       |
   | kcharge | BG-010-02 |
And I set field "gutmge" to "1" in row 1
And I save the current editor

# Fertigung Baugruppe
Given I open an editor "fv" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
   | artikel | netmge | charge    | serprod   | bisuch  | mfreig |
   | BG-011  | 1      | BG-011-01 | BG-011-01 | BG011-1 | ja     |
   | BG-011  | 1      | BG-011-02 | BG-011-02 | BG011-2 | ja     |
And I press button "freig" to open a subeditor for "freig"
And I close the current editor
And I switch the current editor to editor "fv"
And I save the current editor

Given I open an editor "materialentnahme" for tip command "Fbuchung" and arguments ""
And I set field "auftrag" to "BG011-1001"
And I append rows
   | elex   | bumge | rescharge |
   | BG-010 | 1     | BG-010-01 |
And I save the current editor

Given I open an editor "materialentnahme" for tip command "Fbuchung" and arguments ""
And I set field "auftrag" to "BG011-2001"
And I append rows
   | elex   | bumge | rescharge |
   | BG-010 | 1     | BG-010-02 |
And I save the current editor

Given I open an editor "rueckmeldung" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BG011-1000"
And I set fields
   | sofort     | ja  |
   | mgr        | 101 |
   | stornorest | ja  |
And I set field "gutmge" to "1" in row 1
And I save the current editor

Given I open an editor "rueckmeldung" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BG011-2000"
And I set fields
   | sofort     | ja  |
   | mgr        | 101 |
   | stornorest | ja  |
And I set field "gutmge" to "1" in row 1
And I save the current editor

# Service-STL ausgeben
Given I open an editor "BG-011-01" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "BG-011-01"
And I press button "absteigen" to open a subeditor for "stl"
Then I fill template "serviceproduktstueckliste.ftl" and append it to output file "serabwicklung.out"
And I close the current editor
And I switch the current editor to editor "BG-011-01"
And I close the current editor

Given I open an editor "BG-011-02" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "BG-011-02"
And I press button "absteigen" to open a subeditor for "stl"
Then I fill template "serviceproduktstueckliste.ftl" and append it to output file "serabwicklung.out"
And I close the current editor
And I switch the current editor to editor "BG-011-02"
And I close the current editor

Scenario: Generierung von Serviceproduktstuecklisten - Baugruppen ohne servicerelevante Komponenten

# Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "nummer" to "012-BG"
And I set field "such" to "BG-012"
And I set field "namebspr" to "Servicepflichtiger Artikel"
And I set field "vkbez" to "Servicepflichtiger Artikel"
And I set field "vbez" to "Servicepflichtiger Artikel"
And I set field "ebez" to "Servicepflichtiger Artikel"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Bedarfsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
# Stueckliste
And I create a new row at the end of the table
And I set field "elex" to "E2" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "BG1" in row 2
And I set field "elanzahl" to "1" in row 2
And I set field "tnwpflicht" to "ja" in row 2
And I set field "tverschlt" to "ja" in row 2
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 3
And I save the current editor

# Nachweispflicht in Komponenten von BG1 setzen
Given I open an editor "bg1" from table "(Part):(Product)" with command "UPDATE" for record "BG1"
And I set field "tnwpflicht" to "nein" in row 1
And I set field "mindest" to "0"
And I set field "losgr" to "0"
And I save the current editor

Scenario Outline: Serviceprodukte anlegen
Given I open an editor "<serprodukt>" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "artikel" to id from editor "<artikel>"
And I save the current editor

Examples:
| serprodukt   | such  | namebspr | artikel    |
| kundeng1     | KGSP1 | KGSP1    | serartikel |
| kundeng2     | KGSP2 | KGSP2    | serartikel |

Scenario: Auftrag mit nicht eingeplanten servicepflichtigen Artikel anlegen
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel" in row 1
And I set field "mge" to "2" in row 1
# 4861: Der Artikel ist servicepflichtig, bitte tragen Sie ein Serviceprodukt ein.
Then saving the current editor throws the exception "4861"
# Artikel nicht einplanen -> Speichern ohne Serviceprodukt moeglich
And I set field "einplan" to "nein" in row 1
And I save the current editor

Scenario: Serviceprodukt ausliefern
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "auftrag"
And I set field "einplan" to "ja" in row 1
And I press button "mzsubm" to open a subeditor for "mzuord" in row 1
And I set field "zuomge" to "1" in row 1
And I set field "serprod" to id from editor "kundeng1" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "1" in row 2
And I set field "serprod" to id from editor "kundeng2" in row 2
And I save the current editor
And I switch the current editor to editor "auftrag"
And I save the current editor

# Disposition starten
And I run Scheduling
# FV der Unterbaugruppe freigeben
Given I open an editor "freigeben1" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "bg1"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bisuch" to "ubg" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "fertigung"
And I close the current editor
And I switch the current editor to editor "freigeben1"
And I close the current editor

# BA der Unterbaugruppe rueckmelden
Given I open an editor "rueckmelden1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ubg000"
And I set field "sofort" to "ja"
And I set field "gutmge" to "0.75" in row 1
And I save the current editor

Given I open an editor "rueckmelden2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ubg000"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

# FV des servicepflichtigen Artikels freigeben
Given I open an editor "freigeben2" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to id from editor "serartikel"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bisuch" to "Service" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "fertigung"
And I close the current editor
And I switch the current editor to editor "freigeben2"
And I close the current editor

# BA des servicepflichtigen Artikels rueckmelden
Given I open an editor "rueckmelden3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "service000"
And I set field "sofort" to "ja"
And I set field "mgr" to "102"
And I set field "gutmge" to "0.5" in row 1
And I save the current editor

Given I open an editor "rueckmelden4" from table "(Workorder):(WorkOrders)" with command "DONE" for record "service000"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I set field "mgr" to "102"
And I save the current editor

# Lieferschein erzeugen und buchen
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag"
And I set field "such" to "liefer1"
And I set field "ueb" to "ja"
And I set field "mge" to "2" in row 1
And I save the current editor

# Ausgabe der Serviceproduktstueckliste
Given I open an editor "servprod" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record from editor "kundeng2"
And I press button "absteigen" to open a subeditor for "spstl"
Then I fill template "serviceproduktstueckliste.ftl" and append it to output file "serabwicklung.out"
And I close the current editor
And I switch the current editor to editor "servprod"
And I close the current editor

@service
Scenario: Ein Serviceangebot mit abgeschlosssener Textposition anlegen. Der Vorgang geht sofort in die Ablage.
Given I open an editor "sangebotzus" from table "(Sales):(ServiceQuotation)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "ZUSBAYRAM"
And I create a new row at the end of the table
And I set field "artikel" to "TEXT" in row 1
And I set field "pwert" to "100" in row 1
And I set field "status" to "*" in row 1
And I save the current editor

Then "(Sales):(ServiceQuotation)" with the editor id "sangebotzus" is filed

@service
Scenario: Storno/Loeschen von Serviceauftragspositionen

Given I open an editor "1SA001" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | nummer | 1SA001 |
   | such   | SA001  |
And I append rows
   | artikel     | mge | datumvon    | zzvon       | serprod |
   | DL-HANALYSE | 10  | .           | .           |         |
   | V1          | 10  | !dontChange | !dontChange |         |
   | V2          | 10  | !dontChange | !dontChange |         |
And I save the current editor

Given I open an editor "1SA001" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record from editor "1SA001"
And I respond with answer "ja" to the dialog with id "191"
And I set field "mge" to "0" in row 1
And I respond with answer "ja" to the dialog with id "191"
And I set field "mge" to "0" in row 2
And I close the current editor

Given I open an editor "1SR001" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set fields
   | nummer  | 1SR001 |
   | servau  | 1SA001 |
   | lgr     | 1      |
   | kstelle | 101    |
   | ueb     | nein   |
And I press button "ladetab"
And I set field "dauer" to "4h" in row 1
And I set field "bumge" to "6" in row 2
And I save the current editor

Given I open an editor "1SA001" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record from editor "1SA001"
Then setting field "mge" to "0" in row 1 throws the exception "2783"
And I respond with answer "ja" to the dialog with id "191"
And I set field "mge" to "0" in row 2
And I close the current editor

Given I open an editor "1SA001" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record from editor "1SA001"
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 2
And I save the current editor

Given I open an editor "1SA001" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record from editor "1SA001"
Then deleting the row at position 1 throws the exception "2783"
And I delete row at position 2
And I close the current editor

Given I open an editor "1SA002" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | nummer | 1SA002 |
   | such   | SA001  |
And I append rows
   | artikel     | mge | datumvon    | zzvon       | serprod |
   | DL-HANALYSE | 10  | .           | .           |         |
   | V1          | 10  | !dontChange | !dontChange |         |
   | V2          | 10  | !dontChange | !dontChange |         |
And I save the current editor

Given I open an editor "1SA002" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record from editor "1SA002"
And I respond with answer "ja" to the dialog with id "191"
And I set field "mge" to "0" in row 1
And I respond with answer "ja" to the dialog with id "191"
And I set field "mge" to "0" in row 2
And I close the current editor

Given I open an editor "1SR002" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set fields
   | nummer  | 1SR002 |
   | servau  | 1SA002 |
   | lgr     | 1      |
   | kstelle | 101    |
   | ueb     | ja     |
And I press button "ladetab"
And I set field "dauer" to "4h" in row 1
And I set field "bumge" to "6" in row 2
And I save the current editor

Given I open an editor "1SA002" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record from editor "1SA002"
Then setting field "mge" to "0" in row 1 throws the exception "2783"
Then setting field "mge" to "0" in row 2 throws the exception "0"
And I close the current editor

Given I open an editor "1SA002" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record from editor "1SA002"
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 2
And I save the current editor

Given I open an editor "1SA002" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record from editor "1SA002"
Then deleting the row at position 1 throws the exception "2783"
Then deleting the row at position 2 throws the exception "111"
And I close the current editor

@service
Scenario: Serviceauftrag mit Beleg anfuegen eines Serviceangebot
Given I open an editor "serviceangebot01" from table "(Sales):(ServiceQuotation)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "SERANG01"
And I create a new row at the end of the table
And I set field "techniker" to "Techniker2" in row 1
And I set field "artikel" to "dl-analyse" in row 1
And I set field "mge" to "1" in row 1
And I set field "datumvon" to "01.12.1995" in row 1
And I set field "ganztag" to "nein" in row 1
And I set field "zzvon" to "09" in row 1
And I set field "zzbis" to "12" in row 1
And I save the current editor

# Auftrag erzeugen
Given I open an editor "serviceauftrag01" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "beleg" to id from editor "serviceangebot01"
And I set field "such" to "SERAUF01"
And I set field "mge" to "1" in row 1
And I save the current editor

# Servicereservierung aufrufen und Reservierungsart pruefen
Given I open an editor "serviceres" from table "(ServiceReservation):(ServiceReservations)" with command "UPDATE" for record ""
And I set field "techniker" to "Techniker2"
And I press button "ladetab"
Then the table has 2 rows
Then field "resart" has value "Angebotstermin" in row 1
Then field "kunde" has value "BAYRAM" in row 1
Then field "dienstl" has value "DL-ANALYSE" in row 1
Then field "techniker" has value "TECHNIKER2" in row 1
Then field "resart" has value "Auftragstermin" in row 2
Then field "kunde" has value "BAYRAM" in row 2
Then field "dienstl" has value "DL-ANALYSE" in row 2
Then field "techniker" has value "TECHNIKER2" in row 2

#----------------------------------------------------------------------------------------------
#   Gemischte Servicerueckmeldungen
#----------------------------------------------------------------------------------------------

Scenario Outline: STAMMDATEN - Zwei neue Artikel

Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "vkbez" to "<vkbez>"
And I set field "vbez" to "<vbez>"
And I set field "ebez" to "<ebez>"
And I set field "vpr" to "<vpr>"
And I set field "bsart" to "<bsart>"
And I set field "dispoa" to "<dispoa>"
And I save the current editor

Examples:
| such     | namebspr  | vkbez     | vbez      | ebez      | vpr   | bsart            | dispoa         |
| artikel1 | Artikel 1 | Artikel 1 | Artikel 1 | Artikel 1 | 10000 | Fremdbeschaffung | bedarfsbezogen |
| artikel2 | Artikel 2 | Artikel 2 | Artikel 2 | Artikel 2 | 9000  | Fremdbeschaffung | bedarfsbezogen |
| artikel3 | Artikel 3 | Artikel 3 | Artikel 3 | Artikel 3 | 8000  | Fremdbeschaffung | bedarfsbezogen |

Scenario: STAMMDATEN - Mitarbeiter TEST um Lohngruppe und Kostenstelle erweitern
Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "UPDATE" for record "1"
And I set field "kstelle" to id from editor "kostenstelle"
And I set field "lohn" to "1"
And I save the current editor

#----------------------------------------------------------------------------------------------

Scenario: Serviceauftrag nur mit positiven Artikeln

Given I open an editor "SERV_AU1" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "1SERVAU"
And I append rows
  | techniker | artikel  | mge |
  | techniker | artikel1 |   9 |
  | techniker | artikel2 |  10 |
And I save the current editor

# Servicerueckmeldung erzeugen
Given I open an editor "servicerueckmeldung" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "SERV_AU1"
And I press button "ladetab"
Then the table has 2 rows
And I set field "buchen" to "ja" in row 1
And I set field "buchen" to "ja" in row 2
And I save the current editor

Scenario: Rueckmeldebelege pruefen zu 1SERVAU
Given I open an editor "TRM1_SERVAU1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "BA1SERVAU;1:artikel=ARTIKEL1;@ablageart=abgelegt"
Then field "artikel" has value "ARTIKEL1"
Then the table has 2 rows
Then field "artikel" has value "ARTIKEL1" in row 1
Then field "mge" has value "9" in row 1
Then field "artikel" has value "ARTIKEL2" in row 2
Then field "mge" has value "10" in row 2
And I close the current editor

#----------------------------------------------------------------------------------------------

Scenario: Serviceauftrag mit positiven und negativen Artikeln

Given I open an editor "SERV_AU2" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "2SERVAU"
And I append rows
  | techniker | artikel  | mge |
  | techniker | artikel1 |  -9 |
  | techniker | artikel2 |  10 |
  | techniker | artikel1 | -11 |
And I save the current editor

# Servicerueckmeldung erzeugen
Given I open an editor "SERV_RM2" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "SERV_AU2"
And I press button "ladetab"
Then the table has 1 rows
And I set field "buchen" to "ja" in row 1
And I save the current editor

Scenario: Rueckmeldebelege pruefen zu 2SERVAU

Given I open an editor "TRM1_SERVAU2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "BA2SERVAU;1:artikel=ARTIKEL2;@ablageart=abgelegt"
Then field "artikel" has value "ARTIKEL2"
Then the table has 1 rows
Then field "artikel" has value "ARTIKEL2" in row 1
Then field "mge" has value "10" in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------

Scenario: Serviceauftrag mit positiven/negativen Artikeln + DL ohne zugehoerigen Artikeln

Given I open an editor "SERV_AU3" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "3SERVAU"
And I append rows
  | techniker | artikel     | mge | zzvon       |
  | techniker | artikel1    |   9 | !dontChange |
  | techniker | artikel2    | -10 | !dontChange |
  | techniker | artikel2    |  11 | !dontChange |
  | techniker | artikel1    | -12 | !dontChange |
  | techniker | dl-beratung |   1 | 11          |
And I save the current editor

# Servicerueckmeldung erzeugen
Given I open an editor "SERV3_RM" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "SERV_AU3"
And I press button "ladetab"
Then the table has 3 rows
And I set field "buchen" to "ja" in row 1
And I set field "buchen" to "ja" in row 2
And I set field "buchen" to "ja" in row 3
And I save the current editor

Scenario: Rueckmeldebelege pruefen zu 3SERVAU

Given I open an editor "TRM1_SERVAU3" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "$,,such=BA3SERVAU;verw=3SERVAU_1;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
Then field "artikel" has value "ARTIKEL1"
Then the table has 2 rows
Then field "artikel" has value "ARTIKEL1" in row 1
Then field "mge" has value "9" in row 1
Then field "artikel" has value "ARTIKEL2" in row 2
Then field "mge" has value "11" in row 2
And I close the current editor

Given I open an editor "TRM2_SERVAU3" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "BA3SERVAU;artikel=dl-beratung;@ablageart=abgelegt"
Then field "bzeit" has value "1"
Then the table has 0 rows
And I close the current editor

#----------------------------------------------------------------------------------------------

Scenario: Serviceauftrag nur mit negativen Artikeln

Given I open an editor "SERV_AU4" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "4SERVAU"
And I append rows
  | techniker | artikel  | mge |
  | techniker | artikel1 |  -9 |
  | techniker | artikel2 | -10 |
And I save the current editor

# Servicerueckmeldung erzeugen
Given I open an editor "TRM1_SERVAU4" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "SERV_AU4"
And I press button "ladetab"
Then the table has 0 rows
And I close the current editor

#---------------------------------------------------------------------------------------------

Scenario: Serviceauftrag mit fuehrenden DL und mit positiven/negativen Artikeln

Given I open an editor "SERV_AU5" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "5SERVAU"
And I append rows
  | techniker | artikel  | mge | datumvon    | zzvon       | datumbis    | zzbis       |
  | techniker | DL-HANA  |   1 | !dontChange | 10          | !dontChange | !dontChange |
  | techniker | artikel1 | -10 | !dontChange | !dontChange | !dontChange | !dontChange |
  | techniker | artikel3 |  10 | !dontChange | !dontChange | !dontChange | !dontChange |
  | techniker | artikel2 |  -8 | !dontChange | !dontChange | !dontChange | !dontChange |
And I save the current editor

# Servicerueckmeldung erzeugen
Given I open an editor "SERV5_RM" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "SERV_AU5"
And I press button "ladetab"
Then the table has 2 rows
And I set field "buchen" to "ja" in row 1
And I set field "buchen" to "ja" in row 2
And I save the current editor

Scenario: Rueckmeldebelege pruefen zu 5SERVAU

Given I open an editor "TRM1_SERVAU5" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "BA5SERVAU;1:artikel=ARTIKEL3;@ablageart=abgelegt"
Then field "artikel" has value "DL-HANALYSE"
Then field "bzeit" has value "1"
Then the table has 1 rows
Then field "artikel" has value "ARTIKEL3" in row 1
Then field "mge" has value "10" in row 1
And I close the current editor

#---------------------------------------------------------------------------------------------

Scenario: Serviceauftrag 6SERVAU anlegen Artikel ohne/mit DL, DL ohne Artikel: negativ und positiv

Given I open an editor "SERV_AU6" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "6SERVAU"
And I append rows
  | techniker | artikel     | mge | datumvon    | zzvon       | datumbis    | zzbis       |
  | techniker | artikel2    | -2  | !dontChange | !dontChange | !dontChange | !dontChange |
  | techniker | artikel2    |  3  | !dontChange | !dontChange | !dontChange | !dontChange |
  | techniker | artikel1    |  6  | !dontChange | !dontChange | !dontChange | !dontChange |
  | techniker | DL-ANALYSE  |  3  | 05.12.95    |   9         | 05.12.95    |    12       |
  | techniker | artikel3    |  4  | !dontChange | !dontChange | !dontChange | !dontChange |
  | techniker | artikel1    | -4  | !dontChange | !dontChange | !dontChange | !dontChange |
  | techniker | DL-HANALYSE | -5  | 05.12.95    |  11         | !dontChange | !dontChange |
And I save the current editor

# Servicerueckmeldung
Given I open an editor "RM_SERV6" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "SERV_AU6"
And I press button "ladetab"
Then the table has 4 rows
Then field "artikel" has value "ARTIKEL2" in row 1
And I set field "buchen" to "ja" in row 1
Then field "artikel" has value "ARTIKEL1" in row 2
And I set field "buchen" to "ja" in row 2
Then field "artikel" has value "DL-ANALYSE" in row 3
And I set field "buchen" to "ja" in row 3
Then field "artikel" has value "ARTIKEL3" in row 4
And I set field "buchen" to "ja" in row 3
And I set field "dauer" to "1h" in row 3
And I set field "status" to "" in row 3
And I set field "bumge" to "2" in row 4
And I set field "status" to "" in row 4
And I save the current editor

# Erzeugte Technikerrueckmeldungen
Given I open an editor "TRM1_SERVAU6" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "$,,such=BA6SERVAU;verw=6SERVAU_2;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
Then field "artikel" has value "ARTIKEL2"
Then the table has 2 rows
Then field "artikel" has value "ARTIKEL2" in row 1
Then field "artikel" has value "ARTIKEL1" in row 2
And I close the current editor

Given I open an editor "TRM2_SERVAU6" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "BA6SERVAU;1:artikel=ARTIKEL3;@ablageart=abgelegt"
Then field "artikel" has value "DL-ANALYSE"
# 1 Stunde gebucht
Then field "bzeit" has value "1"
Then the table has 1 rows
Then field "artikel" has value "ARTIKEL3" in row 1
Then field "mge" has value "2" in row 1
And I close the current editor

#---------------------------------------------------------------------------------------------

Scenario: Serviceauftrag anlegen mit DL, positiv und negativ Positionen

Given I open an editor "SERV_AU7" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "7SERVAU"
And I append rows
  | techniker | artex        | mge | zzvon       |
  | techniker | dl-hanalyse  |   1 | 10          |
  | techniker | artikel1     | -10 | !dontChange |
  | techniker | artikel2     |  10 | !dontChange |
  | techniker | dl-reparatur |   1 | 9           |
  | techniker | dl-schulung  |   1 | 13          |
  | techniker | v1           |   2 | !dontChange |
  | techniker | v2           |   3 | !dontChange |
  | techniker | dl-beratung  |   1 | 11          |
  | techniker | e2           |  -2 | !dontChange |
  | techniker | e3           |  -3 | !dontChange |
And I save the current editor

# Servicerueckmeldung erzeugen
Given I open an editor "RM_SERV_AU7" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "SERV_AU7"
And I press button "ladetab"
Then the table has 7 rows
And I set field "buchen" to "ja" in row 1
And I set field "buchen" to "ja" in row 2
And I set field "buchen" to "ja" in row 3
And I set field "buchen" to "ja" in row 4
And I set field "buchen" to "ja" in row 5
And I set field "buchen" to "ja" in row 6
And I set field "buchen" to "ja" in row 7
And I save the current editor

Scenario: Rueckmeldebelege pruefen zu 7SERVAU

Given I open an editor "TRM1_SERVAU7" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "BA7SERVAU;artikel=DL-HANALYSE;1:artikel=ARTIKEL2;@ablageart=abgelegt"
Then field "bzeit" has value "1"
Then the table has 1 rows
Then field "artikel" has value "ARTIKEL2" in row 1
Then field "mge" has value "10" in row 1
And I close the current editor

Given I open an editor "TRM2_SERVAU7" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "BA7SERVAU;artikel=DL-REPARATUR;@ablageart=abgelegt"
Then field "bzeit" has value "1"
Then the table has 0 rows
And I close the current editor

Given I open an editor "TRM3_SERVAU7" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "BA7SERVAU;artikel=DL-SCHULUNG;1:artikel=V1;@ablageart=abgelegt"
Then field "artikel" has value "DL-SCHULUNG"
Then field "bzeit" has value "1"
Then the table has 2 rows
Then field "artikel" has value "V1" in row 1
Then field "mge" has value "2" in row 1
Then field "artikel" has value "V2" in row 2
Then field "mge" has value "3" in row 2
And I close the current editor

#---------------------------------------------------------------------------------------------

Scenario: Serviceauftrag mit positiven/negativen DL anlegen

Given I open an editor "SE_AU_DL" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "1SEAUDL"
And I append rows
  | techniker | artex        | mge | zzvon       |
  | techniker | dl-hanalyse  |  1  | 10          |
  | techniker | dl-reparatur |  1  | 9           |
  | techniker | dl-schulung  | -1  | 13          |
  | techniker | dl-beratung  |  1  | 11          |
  | techniker | artikel3     | -3  | !dontChange |
  | techniker | artikel2     | -2  | !dontChange |
  | techniker | artikel1     | 1   | !dontChange |
And I save the current editor

# Servicerueckmeldung erzeugen
# Position2 - dl_reparatur wird nicht gebucht
Given I open an editor "SRM_AUDL" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to "1SEAUDL"
And I press button "ladetab"
Then the table has 4 rows
And I set field "buchen" to "ja" in row 1
And I set field "buchen" to "ja" in row 3
And I set field "buchen" to "ja" in row 4
And I save the current editor

Scenario: Rueckmeldebelege pruefen zu 1SEAUDL

Given I open an editor "RM1_SAU_DL1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "BA1SEAUDL;artikel=DL-HANALYSE;@ablageart=abgelegt"
Then field "artikel" has value "DL-HANALYSE"
Then field "bzeit" has value "1"
Then the table has 0 rows
And I close the current editor

Given I open an editor "RM2_SAU_DL2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "BA1SEAUDL;1:artikel=ARTIKEL1;@ablageart=abgelegt"
Then field "artikel" has value "DL-BERATUNG"
Then field "bzeit" has value "1"
Then the table has 1 rows
Then field "artikel" has value "ARTIKEL1" in row 1
And I close the current editor

#---------------------------------------------------------------------------------------------

Scenario: Serviceauftrag mit DL anlegen. In der Servicerueckmeldung selbst, wird ein Ersatzteil hinzugefuegt

Given I open an editor "SE_AU_DL2" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "2SEAUDL"
And I append rows
  | techniker | artex       | mge | zzvon | zzbis       |
  | techniker | dl-hanalyse |  1  | 10    | !dontChange |
  | techniker | dl-analyse  | -1  | 10    | 11          |
And I save the current editor

# Servicerueckmeldung erzeugen, Ersatzteil anfuegen
Given I open an editor "SRM_AUDL2" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "SE_AU_DL2"
And I press button "ladetab"
Then the table has 1 rows
And I set field "buchen" to "ja" in row 1
And I create a new row at position 2
And I set field "artikel" to "artikel1" in row 2
And I set field "bumge" to "3" in row 2
And I save the current editor
# Zu buchende Servicerueckmeldung fuer den Mitarbeiter "Techniker"
# | pos | artex       | mge | dauer |
# |   1 | dl-hanalyse |  1  |  1    |
# |   2 | artikel1    |  3  |       | manuell

Scenario: Rueckmeldebelege pruefen zu 2SEAUDL
Given I open an editor "RM1_SAU_DL1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "$,,such=BA2SEAUDL;verw=2SEAUDL_1;1:artikel=;@richtung=vorwärts;@ablageart=abgelegt;@maxordtreffer=1"
Then field "artikel" has value "DL-HANALYSE"
Then field "bzeit" has value "1"
Then the table has 0 rows
And I close the current editor

Given I open an editor "RM2_SAU_DL2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "BA2SEAUDL;1:artikel=ARTIKEL1;@ablageart=abgelegt"
Then field "artikel" has value "DL-HANALYSE"
Then field "bzeit" has value "0"
Then the table has 1 rows
Then field "artikel" has value "ARTIKEL1" in row 1
And I close the current editor

#---------------------------------------------------------------------------------------------

Scenario: Serviceauftrag mit gemischten Positionen, in der Servicerueckmeldung DL-POS + Erstazteile hinzufuegen

Given I open an editor "SERV_AU8" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "8SERVAU"
And I append rows
  | techniker | artex       | mge | zzvon       |
  | techniker | V1          |  1  | !dontChange |
  | techniker | E2          | -2  | !dontChange |
  | techniker | V2          |  3  | !dontChange |
  | techniker | dl-hanalyse |  4  | 10          |
  | techniker | artikel3    |  5  | !dontChange |
  | techniker | artikel2    | -6  | !dontChange |
  | techniker | artikel1    |  7  | !dontChange |
And I save the current editor

# Servicerueckmeldung erzeugen, Ersatzteile anfuegen
Given I open an editor "SRM_AU8" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "SERV_AU8"
And I press button "ladetab"
Then the table has 5 rows
And I set field "buchen" to "ja" in row 1
# DL manuell hinzufuegen
And I create a new row at position 2
And I set field "artikel" to "dl-schulung" in row 2
And I set field "dauer" to "10m" in row 2
And I set field "buchen" to "ja" in row 3
And I set field "buchen" to "ja" in row 4
And I set field "buchen" to "ja" in row 5
And I set field "buchen" to "ja" in row 6
# Ersatzteile manuell hinzufuegen
And I create a new row at the end of the table
And I set field "artikel" to "EK-001" in row 7
And I set field "bumge" to "9" in row 7
And I create a new row at the end of the table
And I set field "artikel" to "V3" in row 8
And I set field "bumge" to "11" in row 8
# DL + Ersatzteile manuell hinzufuegen
And I create a new row at the end of the table
And I set field "artikel" to "dl-beratung" in row 9
And I set field "dauer" to "30m" in row 9
And I create a new row at the end of the table
And I set field "artikel" to "E3" in row 10
And I set field "bumge" to "13" in row 10
And I save the current editor

# Zu buchende Servicerueckmeldung fuer den Mitarbeiter "Techniker"
# | pos | artex       | mge | dauer |
# |   1 | V1          |  1  |       |
# |   2 | dl-schulung |     | 10m   | manuell
# |   3 | V2          |  3  |       |
# |   4 | dl-hanalyse |     | 4h    |
# |   5 | artikel3    |  5  |       |
# |   6 | artikel1    |  7  |       |
# |   7 | EK-001      |  9  |       | manuell
# |   8 | V3          | 11  |       | manuell
# |   9 | dl-beratung |     | 30m   | manuell
# |  10 | E3          | 13  |       | manuell

# Es entstehen die folgenden 9 Technikerrueckmeldungen:
# TRnr| Kopf        | Positionen | Vorzeichen | dauer
# 1   | V1          | V1         | +          |
# 2   | dl-schulung |            | +          | 10 min
# 3   | V2          | V2         | +          |
# 4   | dl-hanalyse | artikel3   | +          | 4 h
#     |             | artikel1   | +          |
# 5   | dl-hanalyse | EK-001     | +          | 0
#     |             | V3         | +          |
# 6   | dl-beratung | E3         | +          | 30 min

Scenario: Rueckmeldebelege pruefen zu 8SERVAU

Given I open an editor "RM1_SERVAU8" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "BA8SERVAU;1:artikel=V1;@ablageart=abgelegt"
Then field "artikel" has value "V1"
Then the table has 1 rows
Then field "artikel" has value "V1" in row 1
Then field "mge" has value "1" in row 1
And I close the current editor

Given I open an editor "RM2_SERVAU8" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "BA8SERVAU;artikel=DL-SCHULUNG;@ablageart=abgelegt"
Then field "artikel" has value "DL-SCHULUNG"
Then field "bzeit" has value "0.17"
Then the table has 0 rows
And I close the current editor

Given I open an editor "RM3_SERVAU8" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "BA8SERVAU;1:artikel=V2;@ablageart=abgelegt"
Then field "artikel" has value "V2"
Then the table has 1 rows
Then field "artikel" has value "V2" in row 1
Then field "mge" has value "3" in row 1
And I close the current editor

Given I open an editor "RM4_SERVAU8" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "BA8SERVAU;1:artikel=ARTIKEL3;@ablageart=abgelegt"
Then field "artikel" has value "DL-HANALYSE"
Then field "bzeit" has value "4"
Then the table has 2 rows
Then field "artikel" has value "ARTIKEL3" in row 1
Then field "mge" has value "5" in row 1
Then field "artikel" has value "ARTIKEL1" in row 2
Then field "mge" has value "7" in row 2
And I close the current editor

Given I open an editor "RM5_SERVAU8" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "BA8SERVAU;1:artikel=EK-001;@ablageart=abgelegt"
Then field "artikel" has value "DL-HANALYSE"
Then field "bzeit" has value "0"
Then the table has 2 rows
Then field "artikel" has value "EK-001" in row 1
Then field "mge" has value "9" in row 1
Then field "artikel" has value "V3" in row 2
Then field "mge" has value "11" in row 2
And I close the current editor

Given I open an editor "RM6_SERVAU8" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "BA8SERVAU;1:artikel=E3;@ablageart=abgelegt"
Then field "artikel" has value "DL-BERATUNG"
Then field "bzeit" has value "0.5"
Then the table has 1 rows
Then field "artikel" has value "E3" in row 1
Then field "mge" has value "13" in row 1
And I close the current editor

#---------------------------------------------------------------------------------------------

Scenario: Serviceauftrag mit gemischten Positionen, in der Servicerueckmeldung Erstazteile hinzufuegen

Given I open an editor "SERV_AU9" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "9SERVAU"
And I append rows
  | techniker | artex       | mge | zzvon       |
  | techniker | V1          |  1  | !dontChange |
  | techniker | E2          | -2  | !dontChange |
  | techniker | V2          |  3  | !dontChange |
  | techniker | dl-hanalyse |  4  | 10          |
  | techniker | artikel3    |  5  | !dontChange |
  | techniker | artikel2    | -6  | !dontChange |
  | techniker | artikel1    |  7  | !dontChange |
And I save the current editor

# Servicerueckmeldung erzeugen, Ersatzteile anfuegen
Given I open an editor "SRM_AU9" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "SERV_AU9"
And I press button "ladetab"
Then the table has 5 rows
And I set field "buchen" to "ja" in row 1
# Ersatzteil manuell hinzufuegen
And I create a new row at position 2
And I set field "artikel" to "Test" in row 2
And I set field "bumge" to "24" in row 2
And I set field "buchen" to "ja" in row 3
And I set field "buchen" to "ja" in row 4
And I set field "buchen" to "ja" in row 5
And I set field "buchen" to "ja" in row 6
And I save the current editor

# Zu buchende Servicerueckmeldungen fuer den Mitarbeiter "Techniker"
# | pos | artex       | mge |
# |   1 | V1          |  1  |
# |   2 | Test        | 24  | manuell
# |   3 | V2          |  3  |
# |   4 | dl-hanalyse |  4  |
# |   5 | artikel3    |  5  |
# |   6 | artikel1    |  7  |

Scenario: Rueckmeldebelege pruefen zu 9SERVAU

Given I open an editor "RM1_SERVAU9" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "BA9SERVAU;1:artikel=V1;@ablageart=abgelegt"
Then field "artikel" has value "V1"
Then the table has 2 rows
Then field "artikel" has value "V1" in row 1
Then field "mge" has value "1" in row 1
Then field "artikel" has value "V2" in row 2
Then field "mge" has value "3" in row 2
And I close the current editor

Given I open an editor "RM2_SERVAU9" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "BA9SERVAU;1:artikel=TEST;@ablageart=abgelegt"
Then field "artikel" has value "TEST"
Then the table has 1 rows
Then field "artikel" has value "TEST" in row 1
Then field "mge" has value "24" in row 1
And I close the current editor

Given I open an editor "RM3_SERVAU9" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "BA9SERVAU;1:artikel=artikel3;@ablageart=abgelegt"
Then field "artikel" has value "DL-HANALYSE"
Then field "bzeit" has value "4"
Then the table has 2 rows
Then field "artikel" has value "ARTIKEL3" in row 1
Then field "mge" has value "5" in row 1
Then field "artikel" has value "ARTIKEL1" in row 2
Then field "mge" has value "7" in row 2
And I close the current editor

#---------------------------------------------------------------------------------------------

# Ergaenzung von Team MPS in diesem Szenario - Zubuchung von Bestand, Pruefen der Bewertung und rueckmge sowie detursache im LJ
Scenario: Zeitkorrekturen und Materialrueckgaben zu Serviceauftrag und manuell hinzugefuegten Servicerueckmeldungszeilen - Modus aendern - zusaetzlich Bewertung pruefen

# Bestand zubuchen, damit die Entnahmebuchung sowie die Materialrueckgabe entsprechend bewertet werden
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | ARTIKEL1  |
    | buart     | Zugang    |
    | beleg     | LBU_ART1  |
    | beldat    | .         |
    | wert      | 10.0000   |
And I delete all rows
And I append rows
    | mge    | platz2   |
    | 100    | F1       |
And I save the current editor

Given I open an editor "10SA001" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "10SA001"
And I append rows
  | techniker | artex        | mge | he    | zzvon       | zzbis       |
  | techniker | dl-hanalyse  |  10 | h     | 10          | 20          |
  | techniker | artikel1     |  10 | Stück | !dontChange | !dontChange |
  | techniker | artikel2     |  10 | Stück | !dontChange | !dontChange |
  | techniker | artikel1     |  10 | Stück | !dontChange | !dontChange |
And I save the current editor

# Servicerueckmeldung
Given I open an editor "10SR001" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "10SA001"
And I set field "lgr" to "1"
And I set field "ueb" to "ja"
And I press button "ladetab"
And I set field "dauer" to "5h" in row 1
And I set field "bumge" to "5" in row 2
And I set field "bumge" to "5" in row 3
And I set field "bumge" to "5" in row 4
And I create a new row at position 1
And I set field "artikel" to "artikel1" in row 1
And I set field "bumge" to "5" in row 1
And I create a new row at position 1
And I set field "artikel" to "artikel2" in row 1
And I set field "bumge" to "5" in row 1
And I create a new row at position 1
And I set field "artikel" to "artikel1" in row 1
And I set field "bumge" to "5" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "artikel2" in row !lastRow
And I set field "bumge" to "5" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "dl-hanalyse" in row !lastRow
And I set field "dauer" to "5h" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "artikel1" in row !lastRow
And I set field "bumge" to "5" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "artikel2" in row !lastRow
And I set field "bumge" to "5" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "artikel1" in row !lastRow
And I set field "bumge" to "5" in row !lastRow
And I save the current editor

# Z   Artikel/Dienstleistung      S  Buchen  Menge  Offene Menge  Einheit  Dauer     Offene Dauer
# ------------------------------------------------------------------------------------------------
# 1   ARTIKEL1     Artikel 1      *  nein    5      0
# 2   ARTIKEL2     Artikel 2      *  nein    5      0
# 3   ARTIKEL1     Artikel 1      *  nein    5      0
# 4   DL-HANALYSE  Analyse mit h  *  nein    0      0                      0D05h00m
# 5   ARTIKEL1     Artikel 1      *  nein    5      0
# 6   ARTIKEL2     Artikel 2      *  nein    5      0
# 7   ARTIKEL1     Artikel 1      *  nein    5      0
# 8   DL-HANALYSE  Analyse mit h     nein    0      0                                0D05h00m
# 9   ARTIKEL2     Artikel 2      *  nein    5      0
# 10  ARTIKEL1     Artikel 1         nein    0      5             Stück
# 11  ARTIKEL2     Artikel 2         nein    0      5             Stück
# 12  ARTIKEL1     Artikel 1         nein    0      5             Stück

# Zeitkorrekturen und Materialrueckgaben
Given I open an editor "10SR001" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "UPDATE" for record from editor "10SR001"
And I press button "ladetab"
And I set field "dauer" to "-6h" in row 8
# Zeitkorrektur ist groesser als die gebuchte Dauer
Then saving the current editor throws the exception "3274"
And I set field "dauer" to "-5h" in row 8
And I set field "lgr" to "2"
# Lohnkosten der Zeitkorrektur sind groesser als die gebuchten Lohnkosten
Then saving the current editor throws the exception "3271"
And I set field "lgr" to "1"
And I set field "bumge" to "-6" in row 10
# Rueckgabemenge ist groesser als die gebuchte Menge
Then saving the current editor throws the exception "3273"
And I set field "bumge" to "-5" in row 10
And I set field "bumge" to "5" in row 12
# Materialentnahmen und Materialrueckgaben in einem Rueckmeldevorgang sind nicht erlaubt
Then saving the current editor throws the exception "3272"
And I set field "bumge" to "-6" in row 12
# Rueckgabemenge ist groesser als die gebuchte Menge
Then saving the current editor throws the exception "3273"
And I set field "bumge" to "-5" in row 11
And I set field "bumge" to "-5" in row 12
And I create a new row at the end of the table
And I set field "artikel" to "artikel2" in row !lastRow
And I set field "bumge" to "-5" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "dl-hanalyse" in row !lastRow
And I set field "dauer" to "-6h" in row !lastRow
# Zeitkorrektur ist groesser als die gebuchte Dauer
Then saving the current editor throws the exception "3274"
And I set field "dauer" to "-5h" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "artikel1" in row !lastRow
And I set field "bumge" to "-10" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "artikel2" in row !lastRow
And I set field "bumge" to "-10" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "artikel1" in row !lastRow
And I set field "bumge" to "10" in row !lastRow
# Materialentnahmen und Materialrueckgaben in einem Rueckmeldevorgang sind nicht erlaubt
Then saving the current editor throws the exception "3272"
And I set field "bumge" to "-11" in row !lastRow
# Rueckgabemenge ist groesser als die gebuchte Menge
Then saving the current editor throws the exception "3273"
And I set field "bumge" to "-10" in row !lastRow
And I save the current editor

# Journaleintrag selektieren und Bewertungen pruefen
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==ARTIKEL1;buarta==Zugang;platz==F1;vorgang^beleg==LBU_ART1;@richtung=vorwärts;"
Then fields have values
    | artikel       | ARTIKEL1              |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 100                   |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | erfasst               |
    | detursache    | Manueller Zugang      |
And I close the current editor

# Journaleintraege zur Entnahme
Given I open an editor "JournalAb1.1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==ARTIKEL1;mge==5;buarta==Abgang;platz==F1;verw==10SA001_1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | ARTIKEL1              |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 5                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Serviceabwicklung     |
    | detursache    | Rückmeldung Service   |
And I close the current editor

Given I open an editor "JournalAb1.2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==ARTIKEL1;mge==5;buarta==Abgang;platz==F1;verw==10SA001_1;@richtung=rückwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | ARTIKEL1              |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 5                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Serviceabwicklung     |
    | detursache    | Rückmeldung Service   |
And I close the current editor

# Journaleintraege zur Materialrueckgabe
Given I open an editor "JournalRueck1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==ARTIKEL1;mge==-5;buarta==Abgang;platz==F1;verw==10SA001_1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | ARTIKEL1              |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | -5                    |
    | rueckmge      | -5                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Serviceabwicklung     |
    | detursache    | Rückmeldung Service   |
And I close the current editor

Given I open an editor "JournalRueck2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==ARTIKEL1;mge==-5;buarta==Abgang;platz==F1;verw==10SA001_1;@richtung=rückwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | ARTIKEL1              |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | -5                    |
    | rueckmge      | -5                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Serviceabwicklung     |
    | detursache    | Rückmeldung Service   |
And I close the current editor

# Bewertung Servicerueckmeldung Abgang, Teilmenge 1, NACH Materialrueckgabe
Given I open latest Valuation "BewertungAb1.1" for Product "ARTIKEL1" and valuation transaction "JournalAb1.1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1.1^id      |
    | rueckbew      | ja                    |
    | bewart        | Mischpreis            |
    | abbewart      | Mischpreis            |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Serviceabwicklung     |
    | detursache    | Rückmeldung Service   |
    | mge           | 0                     |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet     | tbudat            | kverur^id       | orig^id        | beworig^id     | vkpos   |
    | 0    | 10.0000 | 0.0000    | direkt       | !JournalAb1.1^vom | !JournalZu1^id  | !JournalZu1^id | !JournalZu1^id |         |
And I close the current editor

# Bewertung Servicerueckmeldung Abgang, Teilmenge 1, VOR Materialrueckgabe
Given I open an editor "VorgaengerBW" via ID from editor "BewertungAb1.1" from field "vorgaenger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1.1^id      |
    | rueckbew      | nein                  |
    | bewart        | Mischpreis            |
    | abbewart      | Mischpreis            |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Serviceabwicklung     |
    | detursache    | Rückmeldung Service   |
    | mge           | 5                     |
    | bewwert       | 50.00                 |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet     | tbudat            | kverur^id      | orig^id        | beworig^id     | vkpos   |
    | 5    | 10.0000 | 0.0000    | direkt       | !JournalAb1.1^vom | !JournalZu1^id | !JournalZu1^id | !JournalZu1^id |         |
And I close the current editor

# Bewertung Servicerueckmeldung Abgang, Teilmenge 2, NACH Materialrueckgabe
Given I open latest Valuation "BewertungAb1.2" for Product "ARTIKEL1" and valuation transaction "JournalAb1.2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1.2^id      |
    | rueckbew      | ja                    |
    | bewart        | Mischpreis            |
    | abbewart      | Mischpreis            |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Serviceabwicklung     |
    | detursache    | Rückmeldung Service   |
    | mge           | 0                     |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet     | tbudat            | kverur^id      | orig^id        | beworig^id     | vkpos   |
    | 0    | 10.0000 | 0.0000    | direkt       | !JournalAb1.2^vom | !JournalZu1^id | !JournalZu1^id | !JournalZu1^id |         |
And I close the current editor

# Bewertung Servicerueckmeldung Abgang, Teilmenge 2, VOR Materialrueckgabe
Given I open an editor "VorgaengerBW" via ID from editor "BewertungAb1.2" from field "vorgaenger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1.2^id      |
    | rueckbew      | nein                  |
    | bewart        | Mischpreis            |
    | abbewart      | Mischpreis            |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Serviceabwicklung     |
    | detursache    | Rückmeldung Service   |
    | mge           | 5                     |
    | bewwert       | 50.00                 |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet     | tbudat            | kverur^id      | orig^id        | beworig^id     | vkpos   |
    | 5    | 10.0000 | 0.0000    | direkt       | !JournalAb1.2^vom | !JournalZu1^id | !JournalZu1^id | !JournalZu1^id |         |
And I close the current editor

#---------------------------------------------------------------------------------------------

Scenario: Zeitkorrekturen und Materialrueckgaben zu Serviceauftrag und manuell hinzugefuegten Servicerueckmeldungszeilen (Modus <neu>)

Given I open an editor "11SA001" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "11SA001"
And I append rows
  | techniker | artex        | mge | he    | zzvon       | zzbis       |
  | techniker | dl-hanalyse  |  10 | h     | 10          | 20          |
  | techniker | artikel1     |  10 | Stück | !dontChange | !dontChange |
  | techniker | artikel2     |  10 | Stück | !dontChange | !dontChange |
  | techniker | artikel1     |  10 | Stück | !dontChange | !dontChange |
And I save the current editor

# Servicerueckmeldung
Given I open an editor "11SR001" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "11SA001"
And I set field "lgr" to "1"
And I set field "ueb" to "ja"
And I press button "ladetab"
And I set field "dauer" to "5h" in row 1
And I set field "bumge" to "5" in row 2
And I set field "bumge" to "5" in row 3
And I set field "bumge" to "5" in row 4
And I create a new row at position 1
And I set field "artikel" to "artikel1" in row 1
And I set field "bumge" to "5" in row 1
And I create a new row at position 1
And I set field "artikel" to "artikel2" in row 1
And I set field "bumge" to "5" in row 1
And I create a new row at position 1
And I set field "artikel" to "artikel1" in row 1
And I set field "bumge" to "5" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "artikel2" in row !lastRow
And I set field "bumge" to "5" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "dl-hanalyse" in row !lastRow
And I set field "dauer" to "5h" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "artikel1" in row !lastRow
And I set field "bumge" to "5" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "artikel2" in row !lastRow
And I set field "bumge" to "5" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "artikel1" in row !lastRow
And I set field "bumge" to "5" in row !lastRow
And I save the current editor

# Z   Artikel/Dienstleistung      S  Buchen  Menge  Offene Menge  Einheit  Dauer     Offene Dauer
# ------------------------------------------------------------------------------------------------
# 1   ARTIKEL1     Artikel 1      *  nein    5      0
# 2   ARTIKEL2     Artikel 2      *  nein    5      0
# 3   ARTIKEL1     Artikel 1      *  nein    5      0
# 4   DL-HANALYSE  Analyse mit h  *  nein    0      0                      0D05h00m
# 5   ARTIKEL1     Artikel 1      *  nein    5      0
# 6   ARTIKEL2     Artikel 2      *  nein    5      0
# 7   ARTIKEL1     Artikel 1      *  nein    5      0
# 8   DL-HANALYSE  Analyse mit h     nein    0      0                                0D05h00m
# 9   ARTIKEL2     Artikel 2      *  nein    5      0
# 10  ARTIKEL1     Artikel 1         nein    0      5             Stück
# 11  ARTIKEL2     Artikel 2         nein    0      5             Stück
# 12  ARTIKEL1     Artikel 1         nein    0      5             Stück

# Zeitkorrekturen und Materialrueckgaben
Given I open an editor "11SR002" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "11SA001"
And I set field "lgr" to "1"
And I set field "ueb" to "ja"
And I press button "ladetab"
And I set field "dauer" to "-6h" in row 8
# Zeitkorrektur ist groesser als die gebuchte Dauer
Then saving the current editor throws the exception "3274"
And I set field "dauer" to "-5h" in row 8
And I set field "lgr" to "2"
# Lohnkosten der Zeitkorrektur sind groesser als die gebuchten Lohnkosten
Then saving the current editor throws the exception "3271"
And I set field "lgr" to "1"
And I set field "bumge" to "-6" in row 10
# Rueckgabemenge ist groesser als die gebuchte Menge
Then saving the current editor throws the exception "3273"
And I set field "bumge" to "-5" in row 10
And I set field "bumge" to "5" in row 12
# Materialentnahmen und Materialrueckgaben in einem Rueckmeldevorgang sind nicht erlaubt
Then saving the current editor throws the exception "3272"
And I set field "bumge" to "-6" in row 12
# Rueckgabemenge ist groesser als die gebuchte Menge
Then saving the current editor throws the exception "3273"
And I set field "bumge" to "-5" in row 11
And I set field "bumge" to "-5" in row 12
And I create a new row at the end of the table
And I set field "artikel" to "artikel2" in row !lastRow
And I set field "bumge" to "-5" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "dl-hanalyse" in row !lastRow
And I set field "dauer" to "-6h" in row !lastRow
# Zeitkorrektur ist groesser als die gebuchte Dauer
Then saving the current editor throws the exception "3274"
And I set field "dauer" to "-5h" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "artikel1" in row !lastRow
And I set field "bumge" to "-10" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "artikel2" in row !lastRow
And I set field "bumge" to "-10" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "artikel1" in row !lastRow
And I set field "bumge" to "10" in row !lastRow
# Materialentnahmen und Materialrueckgaben in einem Rueckmeldevorgang sind nicht erlaubt
Then saving the current editor throws the exception "3272"
And I set field "bumge" to "-11" in row !lastRow
# Rueckgabemenge ist groesser als die gebuchte Menge
Then saving the current editor throws the exception "3273"
And I set field "bumge" to "-10" in row !lastRow
And I save the current editor

#---------------------------------------------------------------------------------------------
Scenario: Zeilen in Servicereservierung loeschen
#---------------------------------------------------------------------------------------------
# Servicereservierung ueber Subdialog im Serviceauftrag aufrufen
Given I open an editor "Serviceauftrag" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I append rows
  |   artikel           |    mge    |  zzvon	|
  |   dl-reparatur      |    10     |  12:00	|
And I press button "srabsteig" to open a subeditor for "servicers" in row 1
And I create a new row at the end of the table
And I respond with answer "ja" to the dialog with id "826"
And I delete row at position 2
Then deleting the row at position 1 throws the exception "111"
And I save the current editor
Then I switch the current editor to editor "Serviceauftrag"
And I save the current editor

# Direkter Aufruf Servicereservierung ohne Serviceauftrag
Given I open an editor "Servicereservierung" from table "(ServiceReservation):(ServiceReservations)" with command "UPDATE" for record ""
# Eigentlich muesste Fehler 7172 "Angebotstermin oder Auftragstermin ist nicht erlaubt" kommen
Then setting field "resart" to "Auftragstermin" in row 1 throws the exception "6640"
And I create a new row at the end of the table
And I set field "resart" to "Urlaub" in row 1
And I create a new row at the end of the table
And I set field "resart" to "Krankheit" in row 2
And I respond with answer "ja" to the dialog with id "826"
And I delete row at position 2
And I close the current editor

#---------------------------------------------------------------------------------------------
# Abgangslieferschein zu Reparaturauftrag erzeugt leere SPSTL (EVS-5005)
# Testszenario ist vorbereitet, muss aber noch angepasst werden
#---------------------------------------------------------------------------------------------

Scenario: STAMMDATEN - Konsignationslagergruppe anlegen
Given I open an editor "Konsignationslg" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "konsi"
And I set field "such" to "konsi"
And I set field "namebspr" to "Konsignationslagergruppe"
And I set field "zkonsilg" to "ja"
#Then field "vkrueckliintern" is not modifiable
#Then field "vkfeigentumextern" is not modifiable
#Then field "ekrueckliextern" is not modifiable
And I save the current editor

Scenario: STAMMDATEN - Externe Lagergruppe anlegen
Given I open an editor "Externelg" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "extern"
And I set field "such" to "extern"
And I set field "namebspr" to "Externe Lagergruppe"
And I set field "zkonsilg" to "nein"
#Then field "vkrueckliintern" is modifiable
#Then field "vkfeigentumextern" is modifiable
#Then field "ekrueckliextern" is modifiable
And I save the current editor

Scenario Outline: STAMMDATEN - Konsignationslager und externes Lager anlegen
Given I open an editor "<lager>" from table "(Warehouse):(Warehouse)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "lgruppe" to id from editor "<lgruppe>"
And I save the current editor

Examples:
| lager           | such   | namebspr           | lgruppe         |
| Konsignationsla | konsi  | Konsignationslager | Konsignationslg |
| Externesla      | extern | Externes Lager     | Externelg       |

Scenario Outline: STAMMDATEN - Konsignationslagerplatz und externen Lagerplatz anlegen
Given I open an editor "<lagerplatz>" from table "(Location):(Location)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "lager" to id from editor "<lager>"
And I set field "lgruppe" to id from editor "<lgruppe>"
And I save the current editor

Examples: Lagerplatz
| lagerplatz      | such   | namebspr            | lager           | lgruppe         |
| Konsignationslp | konsi  | Konsignationslager  | Konsignationsla | Konsignationslg |
| Externerlp      | extern | Externer Lagerplatz | Externesla      | Externelg       |

Scenario: STAMMDATEN - Konsignationslagerplatz in interne Lagergruppe eingragen
Given I open an editor "internelg" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "KARLSRUHE"
And I set field "vkkundenanlieferung" to id from editor "Konsignationslp"
And I save the current editor

Scenario: STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel2" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "SERARTIKEL2"
And I set field "namebspr" to "Servicepflichtiger Artikel 2"
And I set field "vkbez" to "Servicepflichtiger Artikel 2"
And I set field "vbez" to "Servicepflichtiger Artikel 2"
And I set field "ebez" to "Servicepflichtiger Artikel 2"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#St�ckliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG1" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

Scenario: STAMMDATEN - Nachweispflicht in Elementen von BG1 setzen
Given I open an editor "bg1" from table "(Part):(Product)" with command "UPDATE" for record "BG1"
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

Scenario Outline: Serviceprodukt anlegen
Given I open an editor "<serprodukt>" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "artikel" to id from editor "<artikel>"
And I save the current editor
And I switch the current editor to editor "<serprodukt>"
And I set field "serprodtyp" to "<serprodtyp>"
And I set field "zuplatzlg" to "<zuplatzlg>"
And I set field "abplatzlg" to "<abplatzlg>"
And I set field "charge" to id from editor "<charge>"
And I save the current editor

Examples:
| serprodukt   | such  | namebspr | artikel     | serprodtyp  | zuplatzlg | abplatzlg | charge      |
| kundeng2     | KGSP3 | KGSP3    | serartikel2 | Kundenger   |           |           | !dontChange |

Scenario: Serviceprodukt ausliefern
Given I open an editor "auftrag1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I create a new row at the end of the table
#And I respond with answer "Ja" to the dialog with id "2060"
And I set field "artikel" to id from editor "serartikel2" in row 1
And I set field "mge" to "1" in row 1
And I set field "serprod" to id from editor "kundeng2" in row 1
And I save the current editor

#Disposition starten
And I run Scheduling
#Ohne Infosystem
Given I open an editor "freigeben" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to id from editor "serartikel2"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bisuch" to "Service" in row 1
#And I respond with answer "Ja" to the dialog with id "2060"
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "fertigung"
And I close the current editor
And I switch the current editor to editor "freigeben"
And I close the current editor

Scenario: Schreibschutz in BA setzen
Given I open an editor "betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "service000"
And I set field "noloesch" to "ja"
And I save the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "service001"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I set field "mgr" to "101"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "service002"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#Lieferschein erzeugen und buchen
Given I open an editor "lieferschein1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag1"
And I set field "such" to "liefer1"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor

#SPSTL im Serviceprodukt ist leer
Given I open an editor "serviceprodukt" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record from editor "kundeng2"
Then field "serstl" is empty
And I close the current editor

Scenario: Reparaturauftrag anlegen und Kundengeraet annehmen
Given I open an editor "repauftrag" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I create a new row at the end of the table
And I set field "serprod" to id from editor "kundeng2" in row 1
And I press button "repzug" to open a subeditor for "zugangsls"
And I set field "ueb" to "ja"
Then field "platz" has value "KONSI" in row 1
And I save the current editor
And I switch the current editor to editor "repauftrag"
And I save the current editor

Scenario: Kundengeraet abgeben
Given I open an editor "reparatur" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag"
And I press button "repabg" to open a subeditor for "abgangsls"
And I set field "ueb" to "ja"
Then field "platz" has value "KONSI" in row 1
And I save the current editor
And I switch the current editor to editor "reparatur"
And I save the current editor

Scenario: SPSTL im Serviceprodukt ist nicht leer
Given I open an editor "serviceprodukt" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record from editor "kundeng2"
Then field "serstl" is not empty
And I close the current editor

Scenario: Reparaturauftrag - Leihgeraet stornieren

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel3" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "SERARTIKEL3"
And I set field "namebspr" to "Servicepflichtiger Artikel 3"
And I set field "vkbez" to "Servicepflichtiger Artikel 3"
And I set field "vbez" to "Servicepflichtiger Artikel 3"
And I set field "ebez" to "Servicepflichtiger Artikel 3"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#St�ckliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG1" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

Scenario: Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set field "such" to "LEIH"
And I set field "exnum" to "001"
And I set field "artikel" to id from editor "serartikel3"
And I save the current editor

Scenario Outline: Serviceprodukt als Kunden- und Leihgeraet anlegen

Given I open an editor "<serprodukt>" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "artikel" to id from editor "<artikel>"
And I save the current editor
And I switch the current editor to editor "<serprodukt>"
And I set field "serprodtyp" to "<serprodtyp>"
And I set field "zuplatzlg" to "<zuplatzlg>"
And I set field "abplatzlg" to "<abplatzlg>"
And I set field "charge" to id from editor "<charge>"
And I save the current editor

Examples:
| serprodukt   | such  | namebspr | artikel     | serprodtyp  | zuplatzlg | abplatzlg | charge      |
| kundeng3     | KGSP4 | KGSP4    | serartikel3 | Kundengerät |           |           | !dontChange |
| leihgeraet   | LHSP  | LHSP     | serartikel3 | Leihgerät   | F4        | F4        | charge 	    |

Scenario: Serviceprodukt ausliefern - Auftrag anlegen
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel3" in row 1
And I set field "mge" to "1" in row 1
And I set field "serprod" to id from editor "kundeng3" in row 1
And I save the current editor

#Lieferschein aus Auftrag erzeugen
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag"
And I set field "such" to "liefer1"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor

Scenario: Reparaturauftrag anlegen und Zeile mit Leihgeraet stornieren
Given I open an editor "repauftrag1" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I create a new row at the end of the table
And I set field "serprod" to id from editor "kundeng3" in row 1
Then the table has 2 rows
And I save the current editor

Given I open an editor "repauftrag2" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag1"
And I respond with answer "Ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I respond with answer "Ja" to the dialog with id "191"
And I set field "status" to "*" in row 2
And I save the current editor
Then field "serprod" is empty in row 2
Then field "serprodname" is empty in row 2

Given I open an editor "repauftrag3" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I create a new row at the end of the table
And I set field "serprod" to id from editor "kundeng3" in row 1
And I save the current editor
Then the table has 2 rows


Scenario: STAMMDATEN - Fremdeigentumslagergruppe anlegen
Given I open an editor "fremdlg" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "fremd"
And I set field "such" to "fremd"
And I set field "namebspr" to "Fremdeigentumslagergruppe"
And I set field "zkonsilg" to "ja"
And I save the current editor

Scenario: STAMMDATEN - Fremdeigentumslager anlegen
Given I open an editor "fremdla" from table "(Warehouse):(Warehouse)" with command "STORE" for record "fremd"
And I set field "such" to "fremd"
And I set field "namebspr" to "Fremdeigentumslager"
And I set field "lgruppe" to id from editor "fremdlg"
And I save the current editor

Scenario: STAMMDATEN - Fremdeigentumslagerplatz anlegen
Given I open an editor "fremdlp" from table "(Location):(Location)" with command "STORE" for record "fremd"
And I set field "such" to "fremd"
And I set field "namebspr" to "Fremdeigentumslagerplatz"
And I set field "lager" to id from editor "fremdla"
And I set field "lgruppe" to id from editor "fremdlg"
And I save the current editor

Scenario: STAMMDATEN - Fremdeigentumslagerplatz in interne Lagergruppe eintragen
Given I open an editor "internelg" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "KARLSRUHE"
And I set field "vkkundenanlieferung" to id from editor "fremdlp"
And I save the current editor

Scenario: STAMMDATEN - Neue Dienstleistung mit Preiseinheit stueck anlegen
Given I open an editor "dienstl4" from table "(Part):(Service)" with command "STORE" for record "dl4"
And I set field "such" to "DL4"
And I set field "namebspr" to "Dienstleistung4"
And I set field "vpr" to "100"
And I save the current editor

Scenario: STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel4" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "SERARTIKEL4"
And I set field "namebspr" to "Servicepflichtiger Artikel 4"
And I set field "vkbez" to "Servicepflichtiger Artikel 4"
And I set field "vbez" to "Servicepflichtiger Artikel 4"
And I set field "ebez" to "Servicepflichtiger Artikel 4"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
# Stueckliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "BG1" in row 2
And I set field "elanzahl" to "1" in row 2
And I set field "tnwpflicht" to "ja" in row 2
And I set field "tverschlt" to "ja" in row 2
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 3
And I save the current editor

Scenario: Serviceprodukt als Kundengeraet anlegen
Given I open an editor "serprodukt4" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set field "such" to "SP4"
And I set field "namebspr" to "Serviceprodukt 4"
And I set field "artikel" to id from editor "serartikel4"
And I save the current editor

Scenario: Serviceprodukt ausliefern
Given I open an editor "auftrag4" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel4" in row 1
And I set field "mge" to "1" in row 1
And I set field "serprod" to id from editor "serprodukt4" in row 1
And I save the current editor

#Lieferschein
Given I open an editor "lieferschein4" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag4"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor

Scenario: Reparaturauftrag anlegen und Kundengeraet vereinnahmen und wieder ausliefern
Given I open an editor "repauftrag4" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I create a new row at the end of the table
And I set field "serprod" to id from editor "serprodukt4" in row 1
And I create a new row at the end of the table
And I set field "artex" to id from editor "dienstl4" in row 2
#Kundengeraet annehmen
And I press button "repzug" to open a subeditor for "zugangsls"
And I set field "ueb" to "ja"
Then field "platz" has value "FREMD" in row 1
And I save the current editor
And I switch the current editor to editor "repauftrag4"
#Kundengeraet abgeben
And I press button "repabg" to open a subeditor for "abgangsls"
And I set field "ueb" to "ja"
Then field "platz" has value "FREMD" in row 1
And I save the current editor
And I switch the current editor to editor "repauftrag4"
And I save the current editor
Then field "serprod" is not empty in row 1
Then field "status" has value "*" in row 1

#---------------------------------------------------------------------------------------------
Scenario: Auftrag mit Serviceprodukt, Lieferscheinrelevanz entfernen
#---------------------------------------------------------------------------------------------

# Serviceprodukt
Given I open an editor "SV1" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set fields
   | such     | SV1               |
   | namebspr | Serviceprodukt V1 |
   | artikel  | V1                |
And I save the current editor

# Auftrag
Given I open an editor "1AU001" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU001 |
   | kunde  | 1      |
And I append rows
   | artikel | mge | serprod |
   | V1      | 1   | SV1     |
And I save the current editor

# Lieferscheinrelevanz entfernen
Given I open an editor "1AU001" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "1AU001"
And I set field "serprod" to "" in row 1
And I set field "lirelev" to "false" in row 1
And I save the current editor

# Verbindung des Serviceprodukts zum Auftrag muss geloest worden sein
Then field "vkpos" from editor "SV1" is empty

#---------------------------------------------------------------------------------------------
Scenario: Kostenvoranschlag mit Zusatzposition
#---------------------------------------------------------------------------------------------

# Dienstleistung
Given I open an editor "DL001" from table "(Part):(Service)" with command "NEW" for record ""
And I set fields
   | such     | DL001              |
   | namebspr | Dienstleistung 001 |
   | vpr      | 100                |
And I save the current editor

# Zusatzposition
Given I open an editor "ZP001" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set fields
   | such   | ZP001             |
   | zptyp  | neutrale Position |
   | vpr    | 50                |
And I save the current editor

# Reparaturauftrag
Given I open an editor "1RA001" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1RA001 |
   | kunde  | 1      |
And I append rows
   | artikel | mge |
   | DL001   | 10  |
   | DL001   | 10  |
And I press button "kostenvorb" to open a subeditor for "1KV001"
And I create a new row at the end of the table
And I set field "artikel" to "ZP001" in row 3
And I save the current editor
And I switch the current editor to editor "1RA001"
And I save the current editor

# Reparaturrechnung
Given I open an editor "1RE001" from table "(Sales):(RepairOrder)" with command "INVOICE" for record from editor "1RA001"
And I set fields
   | nummer | 1RE001 |
   | tterm  | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Reparaturauftrag
Given I open an editor "1RA002" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1RA002 |
   | kunde  | 1      |
And I append rows
   | artikel | mge |
   | DL001   | 10  |
   | DL001   | 10  |
And I press button "kostenvorb" to open a subeditor for "1KV002"
And I create a new row at position 2
And I set field "artikel" to "ZP001" in row 2
And I save the current editor
And I switch the current editor to editor "1RA002"
And I save the current editor

# Reparaturrechnung
Given I open an editor "1RE002" from table "(Sales):(RepairOrder)" with command "INVOICE" for record from editor "1RA002"
And I set fields
   | nummer | 1RE002 |
   | tterm  | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Reparaturauftrag
Given I open an editor "1RA003" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1RA003 |
   | kunde  | 1      |
And I append rows
   | artikel | mge |
   | DL001   | 10  |
   | DL001   | 10  |
And I press button "kostenvorb" to open a subeditor for "1KV003"
And I create a new row at position 1
And I set field "artikel" to "ZP001" in row 1
And I save the current editor
And I switch the current editor to editor "1RA003"
And I save the current editor

# Reparaturrechnung
Given I open an editor "1RE003" from table "(Sales):(RepairOrder)" with command "INVOICE" for record from editor "1RA003"
And I set fields
   | nummer | 1RE003 |
   | tterm  | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

#---------------------------------------------------------------------------------------------

Scenario: Serviceauftrag mit chargenpflichten Artikel, in der Servicerueckmeldung buchen

# Chargenflichtigen Artikel anlegen
Given I open an editor "ARTCH1" from table "(Part):(Product)" with command "NEW" for record ""
And I set field "such" to "ARTCH1"
And I set field "namebspr" to "Chargenpflichtiger Artikel 1"
And I set field "vkbez" to "Chargenpflichtiger Artikel 1"
And I set field "vbez" to "Chargenpflichtiger Artikel 1"
And I set field "ebez" to "Chargenpflichtiger Artikel 1"
And I set field "vpr" to "120"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "chverfolgung" to "Chargenverfolgung"
And I set field "serpflicht" to "ja"
And I save the current editor

# Charge anlegen
Given I create a Lot "CH-ARTCH1" for Product "ARTCH1"

# Bestand mit Charge zubuchen
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | ARTCH1    |
    | buart     | Zugang    |
    | beleg     | LBU_ARTCH1|
    | beldat    | .         |
    | wert      | 1.2000    |
And I delete all rows
And I append rows
    | mge    | platz2 | tcharge2  |
    | 100    | F2     | CH-ARTCH1 |
And I save the current editor

# Serviceauftrag mit chargenpflichtigen Artikel angelegen
Given I open an editor "SERV_AU10" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "10SERVAU"
And I append rows
  | techniker | artex       | mge | platz | charge    |
  | techniker | ARTCH1      |  15 | F2    | CH-ARTCH1 |
And I save the current editor

# Servicerueckmeldung erzeugen
Given I open an editor "SRM_AU10" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "SERV_AU10"
And I press button "ladetab"
Then the table has 1 rows
# Falsche Charge eintragen -> Artikel stimmt nicht mit dem Artikel der Charge überein
Then setting field "charge" to "6" in row 1 throws the exception "3166"
And I set field "buchen" to "ja" in row 1
And I save the current editor

# Platzmenge pruefen
# And I export "bewertungslagermengen1" from StorageQuantities where "artikel==ARTCH1;gebmge<>0;platz==F2" to output file "serabw2.ref"
Given I query StorageQuantity for Product "ARTCH1" on StorageLocation "F2"
Then StorageQuantities have values
    | gebmge | gebeinh  | bewmge | charge |
    | 85     | Stück    | 85     | 7      |
And I close the current editor

#---------------------------------------------------------------------------------------------
Scenario: Wechsel von Artikel- zu Dienstleistungsposition im Serviceauftrag
#---------------------------------------------------------------------------------------------

# Serviceprodukt
Given I open an editor "SPBG001" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set fields
   | such     | SPBG001               |
   | namebspr | Serviceprodukt BG-001 |
   | artikel  | BG-001                |
And I save the current editor

# Serviceauftrag
Given I open an editor "1SA003" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | nummer | 1SA003 |
   | such   | SA003  |
And I append rows
   | artikel     | mge | serprod |
   | EK-001      | 1   | SPBG001 |
Then field "serstlsts" has value "undefiniert" in row 1
Then field "serstlsts" is modifiable in row 1
And I set field "artikel" to "DL-ANALYSE" in row 1
Then field "serstlsts" has value "wird nicht aktualisiert" in row 1
Then field "serstlsts" is not modifiable in row 1
And I set field "zzvon" to "." in row 1
And I set field "zzbis" to "+8" in row 1
And I save the current editor

# Rechnung
Given I open an editor "1RE004" from table "(Sales):(ServiceOrder)" with command "INVOICE" for record from editor "1SA003"
And I set fields
   | nummer | 1RE004  |
   | such   | RE004   |
   | ueb    | ja      |
   | tterm  | .       |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

#---------------------------------------------------------------------------------------------
Scenario: Anlegen aller Stufen im Servicerprodukt im Zusammenhang mit Basisartikel
#---------------------------------------------------------------------------------------------

# Basisartikel mit mindestens einer Version anlegen.
Given I open an editor "BASISBG" from table "(Part):(BaseProduct)" with command "NEW" for record ""
And I set fields
    | such     | BASISBG    |
    | namebspr | BasisBG    |
    | le       | Stück      |
And I append rows
| tversion  | tindex  | tstdvers |
| BG1       | 002     | ja       |
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E5"
And I set field "index" to "005"
And I set field "namebspr" to "Einkaufsteil fünf"
And I append rows
| tbasisartikel | elanzahl | tnwpflicht |
| BASISBG       |        2 | ja         |
And I save the current editor

# Basisartikel mit mindestens einer Version anlegen. (Enthaelt BG mit weiterem Basisartikel)
Given I open an editor "BASISSERV" from table "(Part):(BaseProduct)" with command "NEW" for record ""
And I set fields
    | such     | BASISSERV  |
    | namebspr | Basisserv  |
And I append rows
| tversion  | tindex  | tstdvers |
| E3        | 001     | nein     |
| E5        | 002     | ja       |
And I save the current editor

# Servicepflichtigen Artikel anlegen mit bsart = Eigenfertigung, serpflicht = TRUE und Basisartikel in Fertigungsliste, aber elex leeren
Given I open an editor "ARTSERVB" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
    | such       | ARTSERVB       |
    | namebspr   | ArtServB       |
    | bsart      | Eigenfertigung |
    | serpflicht | ja             |
And I append rows
   # In der Zeilenlupe der Fertigungsliste tnwpflicht = TRUE setzen
   | tbasisartikel | elex  | elanzahl | tnwpflicht |lge          | breite      |
   | BASISSERV     |       | 2        | ja         | !dontChange | !dontChange |
   |               | E1    | 4        | ja         | 100         | 100         |
And I save the current editor

# Serviceprodukt anlegen und Basisprodukt in Fertigungsliste -> Stueckliste anlegen
Given I open an editor "SP" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set field "such" to "SP"
And I set field "namebspr" to "SP"
And I set field "artikel" to "ARTSERVB"
And I press button "stlanlegen" to open a subeditor for "Stueckliste"
Then table has values
  | basisartikel      | elex | elanzahl |
  | BASISSERV         | E5   |        2 |
  |                   | E1   |        4 |
And I press button "zabsteigen" to open a subeditor for "Stueckliste2" in row 1
Then table has values
  | basisartikel  | elex | elanzahl |
  | BASISBG       | BG1  |        2 |
And I close the current editor
And I switch the current editor to editor "Stueckliste"
And I save the current editor
And I switch the current editor to editor "SP"
And I save the current editor

#---------------------------------------------------------------------------------------------
Scenario: Serviceprodukt: Standort (Kunden) wechseln
#---------------------------------------------------------------------------------------------

# Telefonnummern uebernehmen
Given I open an editor "Produkt_Service" from table "(ServiceProduct):(ServiceProduct)" with command "UPDATE" for record "KGSP1"
And I set field "Kunde" to "1K"
Then field "tele" has value "+49 (0) 7222/9456-0"
And I set field "Kunde" to "2K"
# Aus der Versandanschrift wird die Telefonnummer des Kunden uebernommen
Then field "tele" has value "+49 (0) 721/913-111"
And I set field "Kunde" to " "
Then field "tele" is empty
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: Test der Belegung von vkpos in Serviceprodukten mit und ohne Umlagerung des Fertigteils, Charge im Auftrag
# ---------------------------------------------------------------------------------------------

# Artikel anlegen
Given I open an editor "ART_VKPOS" from table "(Part):(Product)" with command "STORE" for record "SERVICE"
And I set fields
   | such         | ART_VKPOS               |
   | vpr          | 1000                    |
   | bsart        | Eigenfertigung          |
   | dispoa       | Auftragsbezogen         |
   | chverfolgung | Seriennummernverfolgung |
# Stueckliste anlegen
And I append rows
   | elex  | elanzahl    | tersatzt    |
	| E2    | 1           | ja          |
	| A AG3 | !dontChange | !dontChange |
And I save the current editor

# Seriennummern anlegen
Given I open an editor "1CH_VKPOS" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
   | nummer  | 1CH_VKPOS |
	| artikel | ART_VKPOS |
And I save the current editor

Given I open an editor "2CH_VKPOS" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
   | nummer  | 2CH_VKPOS |
	| artikel | ART_VKPOS |
And I save the current editor

# Serviceprodukte anlegen
Given I open an editor "1SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set fields
   | nummer  | 1SP_VKPOS |
   | such    | SP_VKPOS1 |
	| artikel | ART_VKPOS |
	| charge  | 1CH_VKPOS |
And I save the current editor

Given I open an editor "2SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set fields
   | nummer  | 2SP_VKPOS |
   | such    | SP_VKPOS2 |
	| artikel | ART_VKPOS |
	| charge  | 2CH_VKPOS |
And I save the current editor

# Auftrag mit 2 Positionen anlegen
Given I open an editor "1AU010" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU010 |
   | kunde  | 1      |
And I append rows
   | artex     | mge | platz |
	| ART_VKPOS | 1   | F1    |
	| ART_VKPOS | 1   | L3F2  |
And I save the current editor

# Disposition
Given I open an editor "dispo" for tip command "(Scheduling)" and arguments ""
And I close the current editor

# FVs freigeben
Given I open an editor "fv" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "ART_VKPOS"
And I press button "ladetab"
Then the table has 2 rows
And I set field "serprod" to "1SP_VKPOS" in row 1
And I set field "bisuch" to "AVKPOS" in row 1
And I set field "mfreig" to "ja" in row 1
And I set field "serprod" to "2SP_VKPOS" in row 2
And I set field "bisuch" to "BVKPOS" in row 2
And I set field "mfreig" to "ja" in row 2
And I press button "freig" to open a subeditor for "freig"
And I close the current editor
And I switch the current editor to editor "fv"
And I close the current editor

# Rueckmeldungen
Given I open an editor "rm" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AVKPOS000"
And I set fields
   | sofort | ja  |
	| gut    | ja  |
	| mgr    | 102 |
And I save the current editor

Given I open an editor "rm" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BVKPOS000"
And I set fields
   | sofort | ja  |
	| gut    | ja  |
	| mgr    | 102 |
And I save the current editor

# Umlagerung durchfuehren
Given I open an editor "umv" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "ART_VKPOS"
And I press button "ladetab"
Then the table has 1 rows
And I set field "beleg" to "UML_VKPOS"
And I set field "beldat" to "."
And I set field "charge" to "2CH_VKPOS" in row 1
And I set field "platz" to "L3F2" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "umbuchen" to open a subeditor for "umbuchen"
And I close the current editor
And I switch the current editor to editor "umv"
And I close the current editor

# Lieferschein aus Auftrag erstellen
Given I open an editor "1LS010" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU010"
And I set fields
   | nummer | 1LS010 |
   | ueb    | ja     |
And I set field "mge" to "1" in row 1
And I set field "charge" to "1CH_VKPOS" in row 1
And I set field "mge" to "1" in row 2
And I set field "charge" to "2CH_VKPOS" in row 2
And I save the current editor

# Serviceprodukte pruefen
Given I open an editor "1SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "1SP_VKPOS"
Then field "vkpos" is not empty
Then field "liefdg" is not empty
Then field "spljab" is not empty
And I close the current editor

Given I open an editor "2SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "2SP_VKPOS"
Then field "vkpos" is not empty
Then field "liefdg" is not empty
Then field "spljab" is not empty
And I close the current editor

# Lieferschein stornieren
Given I open an editor "1LS010S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "1LS010"
And I set field "nummer" to "1LS010S"
And I save the current editor

# Serviceprodukte pruefen
Given I open an editor "1SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "1SP_VKPOS"
Then field "vkpos" is not empty
Then field "liefdg" is empty
Then field "spljab" is empty
And I close the current editor

Given I open an editor "2SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "2SP_VKPOS"
Then field "vkpos" is not empty
Then field "liefdg" is empty
Then field "spljab" is empty
And I close the current editor

# Lieferschein aus Auftrag erstellen
Given I open an editor "2LS010" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU010"
And I set fields
   | nummer | 2LS010 |
   | ueb    | ja     |
And I set field "mge" to "1" in row 1
And I set field "charge" to "1CH_VKPOS" in row 1
And I set field "mge" to "1" in row 2
And I set field "charge" to "2CH_VKPOS" in row 2
And I save the current editor

# Serviceprodukte pruefen
Given I open an editor "1SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "1SP_VKPOS"
Then field "vkpos" is not empty
Then field "liefdg" is not empty
Then field "spljab" is not empty
And I close the current editor

Given I open an editor "2SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "2SP_VKPOS"
Then field "vkpos" is not empty
Then field "liefdg" is not empty
Then field "spljab" is not empty
And I close the current editor

# ---------------------------------------------------------------------------------------------
Scenario: Test der Belegung von vkpos in Serviceprodukten, Charge im Auftrag, mit MZs
# ---------------------------------------------------------------------------------------------

# Seriennummern anlegen
Given I open an editor "3CH_VKPOS" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
   | nummer  | 3CH_VKPOS |
	| artikel | ART_VKPOS |
And I save the current editor

Given I open an editor "4CH_VKPOS" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
   | nummer  | 4CH_VKPOS |
	| artikel | ART_VKPOS |
And I save the current editor

# Serviceprodukte anlegen
Given I open an editor "3SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set fields
   | nummer  | 3SP_VKPOS |
   | such    | SP_VKPOS3 |
	| artikel | ART_VKPOS |
	| charge  | 3CH_VKPOS |
And I save the current editor

Given I open an editor "4SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set fields
   | nummer  | 4SP_VKPOS |
   | such    | SP_VKPOS4 |
	| artikel | ART_VKPOS |
	| charge  | 4CH_VKPOS |
And I save the current editor

Given I open an editor "1AU011" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde  | 1      |
    | nummer | 1AU011 |
And I append rows
    | artikel   | mge | he    |
    | ART_VKPOS | 2   | Stück |
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete all rows
And I append rows
    | zuomge | charge    |
    | 1      | 3CH_VKPOS |
    | 1      | 4CH_VKPOS |
And I save the current editor
And I switch the current editor to editor "1AU011"
And I save the current editor

# Disposition
Given I open an editor "dispo" for tip command "(Scheduling)" and arguments ""
And I close the current editor

# FVs freigeben
Given I open an editor "fv" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "ART_VKPOS"
And I press button "ladetab"
Then the table has 1 rows
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete all rows
And I append rows
    | zuomge | serprod   |
    | 1      | SP_VKPOS3 |
    | 1      | SP_VKPOS4 |
And I save the current editor
And I switch the current editor to editor "fv"
And I set field "bisuch" to "CVKPOS" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "freig"
And I close the current editor
And I switch the current editor to editor "fv"
And I close the current editor

# Rueckmeldung
Given I open an editor "rm" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CVKPOS000"
And I set fields
   | sofort | ja  |
	| gut    | ja  |
	| mgr    | 102 |
And I save the current editor

# Lieferschein aus Auftrag erstellen
Given I open an editor "1LS011" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU011"
And I set fields
   | nummer | 1LS011 |
   | ueb    | ja     |
And I set field "mge" to "2" in row 1
And I save the current editor

# Serviceprodukte pruefen
Given I open an editor "3SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "3SP_VKPOS"
Then field "vkpos" is not empty
Then field "liefdg" is not empty
Then field "spljab" is not empty
And I close the current editor

Given I open an editor "4SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "4SP_VKPOS"
Then field "vkpos" is not empty
Then field "liefdg" is not empty
Then field "spljab" is not empty
And I close the current editor

# Lieferschein stornieren
Given I open an editor "1LS011S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "1LS011"
And I set field "nummer" to "1LS011S"
And I save the current editor

# Serviceprodukte pruefen
Given I open an editor "3SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "3SP_VKPOS"
Then field "vkpos" is not empty
Then field "liefdg" is empty
Then field "spljab" is empty
And I close the current editor

Given I open an editor "4SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "4SP_VKPOS"
Then field "vkpos" is not empty
Then field "liefdg" is empty
Then field "spljab" is empty
And I close the current editor

# Lieferschein aus Auftag
Given I open an editor "2LS011" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU011"
And I set fields
   | nummer | 2LS011 |
   | ueb    | ja     |
And I set field "mge" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete all rows
And I append rows
    | zuomge | charge    |
    | 1      | 3CH_VKPOS |
    | 1      | 4CH_VKPOS |
And I save the current editor
And I switch the current editor to editor "2LS011"
And I save the current editor

# Serviceprodukte pruefen
Given I open an editor "3SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "3SP_VKPOS"
Then field "vkpos" is not empty
Then field "liefdg" is not empty
Then field "spljab" is not empty
And I close the current editor

Given I open an editor "4SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "4SP_VKPOS"
Then field "vkpos" is not empty
Then field "liefdg" is not empty
Then field "spljab" is not empty
And I close the current editor

# ---------------------------------------------------------------------------------------------
Scenario: Test der Belegung von vkpos in Serviceprodukten, Serviceprodukt im Auftrag
# ---------------------------------------------------------------------------------------------

# Serviceprodukte anlegen
Given I open an editor "5SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set fields
   | nummer  | 5SP_VKPOS |
   | such    | SP_VKPOS5 |
	| artikel | ART_VKPOS |
And I save the current editor

Given I open an editor "1AU012" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde  | 1      |
    | nummer | 1AU012 |
And I append rows
    | artikel   | mge | he    | serprod   |
    | ART_VKPOS | 1   | Stück | 5SP_VKPOS |
And I save the current editor

# Disposition
Given I open an editor "dispo" for tip command "(Scheduling)" and arguments ""
And I close the current editor

# FVs freigeben
Given I open an editor "fv" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "ART_VKPOS"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bisuch" to "DVKPOS" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "freig"
And I close the current editor
And I switch the current editor to editor "fv"
And I close the current editor

# Rueckmeldung
Given I open an editor "rm" from table "(Workorder):(WorkOrders)" with command "DONE" for record "DVKPOS000"
And I set fields
   | sofort | ja  |
	| gut    | ja  |
	| mgr    | 102 |
And I save the current editor

# Lieferschein aus Auftrag erstellen
Given I open an editor "1LS012" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU012"
And I set fields
   | nummer | 1LS012 |
   | ueb    | ja     |
And I set field "mge" to "1" in row 1
And I save the current editor

# Serviceprodukt pruefen
Given I open an editor "5SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "5SP_VKPOS"
Then field "vkpos" is not empty
Then field "liefdg" is not empty
Then field "spljab" is not empty
And I close the current editor

# Lieferschein stornieren
Given I open an editor "1LS012S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "1LS012"
And I set field "nummer" to "1LS012S"
And I save the current editor

# Serviceprodukt pruefen
Given I open an editor "5SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "5SP_VKPOS"
Then field "vkpos" is not empty
Then field "liefdg" is empty
Then field "spljab" is empty
And I close the current editor

# Lieferschein aus Auftag
Given I open an editor "2LS012" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU012"
And I set fields
   | nummer | 2LS012 |
   | ueb    | ja     |
And I set field "mge" to "1" in row 1
And I save the current editor

# Serviceprodukt pruefen
Given I open an editor "5SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "5SP_VKPOS"
Then field "vkpos" is not empty
Then field "liefdg" is not empty
Then field "spljab" is not empty
And I close the current editor

# ---------------------------------------------------------------------------------------------
Scenario: Test der Belegung von vkpos in Serviceprodukten, Serviceprodukt im Auftrag, mit MZs
# ---------------------------------------------------------------------------------------------

# Serviceprodukte anlegen
Given I open an editor "6SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set fields
   | nummer  | 6SP_VKPOS |
   | such    | SP_VKPOS6 |
	| artikel | ART_VKPOS |
And I save the current editor

Given I open an editor "7SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set fields
   | nummer  | 7SP_VKPOS |
   | such    | SP_VKPOS7 |
	| artikel | ART_VKPOS |
And I save the current editor

Given I open an editor "1AU013" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde  | 1      |
    | nummer | 1AU013 |
And I append rows
    | artikel   | mge | he    |
    | ART_VKPOS | 2   | Stück |
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete all rows
And I append rows
    | zuomge | serprod   |
    | 1      | 6SP_VKPOS |
    | 1      | 7SP_VKPOS |
And I save the current editor
And I switch the current editor to editor "1AU013"
And I save the current editor

# Disposition
Given I open an editor "dispo" for tip command "(Scheduling)" and arguments ""
And I close the current editor

# FVs freigeben
Given I open an editor "fv" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "ART_VKPOS"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bisuch" to "EVKPOS" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "freig"
And I close the current editor
And I switch the current editor to editor "fv"
And I close the current editor

# Rueckmeldungen
Given I open an editor "rm" from table "(Workorder):(WorkOrders)" with command "DONE" for record "EVKPOS000"
And I set fields
   | sofort | ja  |
	| mgr    | 102 |
And I set field "gutmge" to "1" in row 1
And I save the current editor

Given I open an editor "rm" from table "(Workorder):(WorkOrders)" with command "DONE" for record "EVKPOS000"
And I set fields
   | sofort | ja  |
	| mgr    | 102 |
And I set field "gutmge" to "1" in row 1
And I save the current editor

# Lieferschein aus Auftrag erstellen
Given I open an editor "1LS013" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU013"
And I set fields
   | nummer | 1LS013 |
   | ueb    | ja     |
And I set field "mge" to "2" in row 1
And I save the current editor

# Serviceprodukte pruefen
Given I open an editor "6SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "6SP_VKPOS"
Then field "vkpos" is not empty
Then field "liefdg" is not empty
Then field "spljab" is not empty
And I close the current editor

Given I open an editor "7SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "7SP_VKPOS"
Then field "vkpos" is not empty
Then field "liefdg" is not empty
Then field "spljab" is not empty
And I close the current editor

# Lieferschein stornieren
Given I open an editor "1LS013S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "1LS013"
And I set field "nummer" to "1LS013S"
And I save the current editor

# Serviceprodukte pruefen
Given I open an editor "6SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "6SP_VKPOS"
Then field "vkpos" is empty
Then field "liefdg" is empty
Then field "spljab" is empty
And I close the current editor

Given I open an editor "7SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "7SP_VKPOS"
Then field "vkpos" is empty
Then field "liefdg" is empty
Then field "spljab" is empty
And I close the current editor

# Lieferschein aus Auftag
Given I open an editor "2LS013" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU013"
And I set fields
   | nummer | 2LS013 |
   | ueb    | ja     |
And I set field "mge" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete all rows
And I append rows
    | zuomge | serprod   |
    | 1      | 6SP_VKPOS |
    | 1      | 7SP_VKPOS |
And I save the current editor
And I switch the current editor to editor "2LS013"
And I save the current editor

# Serviceprodukte pruefen
Given I open an editor "6SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "6SP_VKPOS"
Then field "vkpos" is not empty
Then field "liefdg" is not empty
Then field "spljab" is not empty
And I close the current editor

Given I open an editor "7SP_VKPOS" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "7SP_VKPOS"
Then field "vkpos" is not empty
Then field "liefdg" is not empty
Then field "spljab" is not empty
And I close the current editor

# ---------------------------------------------------------------------------------------------
Scenario: Test Hinweismeldung, wenn in der Lieferscheinposition der Aktualisierungsstatus undefiniert ist
# ---------------------------------------------------------------------------------------------
#Auftrag - Lieferschein, dann Serviceauftrag - Lieferschein

#Serviceprodukt anlegen
Given I open an editor "serprod" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set fields
    | such     | SP1  |
    | namebspr | SP 1 |
    | artikel  | V1   |
And I press button "stlanlegen" to open a subeditor for "spstl"
And I close the current subeditor to switch back to the parent editor
And I save the current editor

#Auftrag anlegen
Given I open an editor "1AU014" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | nummer  | 1AU014 |
    | kunde   | 1                                 |
    | kl2     | 1                                 |
    | betreff | Aktualisierungsstatus undefiniert |
And I append rows
    | artex | mge | serprod |
    | V1    | 1   | SP1     |
And I save the current editor

#Lieferschein aus Auftrag anlegen und buchen
Given I open an editor "1LS014" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU014"
And I set fields
   | nummer | 1LS014 |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

#Sericeauftrag anlegen
Given I open an editor "1SAU014" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set fields
    | nummer   | 1SAU014                           |
    | kunde    | 1                                 |
    | kl2      | 1                                 |
    | betreff  | Aktualisierungsstatus undefiniert |
    | vserprod | SP1                               |
And I append rows
    | artex | mge |
    | E2    | 1   |
Then field "serprod" is not empty in row 1
Then field "serstlsts" has value "undefiniert" in row 1
And I save the current editor

#Lieferschein anlegen und buchen
Given I open an editor "1SLS014" from table "(Sales):(ServiceOrder)" with command "DELIVERY" for record "1SAU014"
And I set field "ueb" to "ja"
Then field "serstlsts" has value "undefiniert" in row 1
And I press button "offueb" in row 1
Then saving the current editor throws the exception "7472"
And I set field "ueb" to "nein"
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: Positionen in der Serviceproduktstueckliste werden gesplittet
# ---------------------------------------------------------------------------------------------

# Fremdbeschaffung anlegen
Given I open an editor "SPLIT_FB" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such         | SPLIT_FB         |
   | epr          | 10               |
   | bsart        | Fremdbeschaffung |
   | dispoa       | bedarfsbezogen   |
And I save the current editor

# Zugaenge buchen
Given I open an editor "FB_ZUGANG" for tip command "(Stockadjustment)" and arguments ""
And I set fields
   | artikel | SPLIT_FB  |
   | beleg   | FB_ZUGANG |
   | beldat  | .         |
   | buart   | Zugang    |
And I append rows
   | mge  | platz2 |
   | 1000 | F1     |
And I save the current editor

# Unterbaugruppe anlegen
Given I open an editor "SPLIT_BG" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such         | SPLIT_BG         |
   | vpr          | 100              |
   | bsart        | Eigenfertigung   |
   | dispoa       | bedarfsbezogen   |
And I append rows
   | elex     | elanzahl    | tersatzt    |
   | SPLIT_FB | 2           | ja          |
   | A AG3    | !dontChange | !dontChange |
And I save the current editor

# Fertigteil anlegen
Given I open an editor "SPLIT_FT" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such         | SPLIT_FT          |
   | vpr          | 1000              |
   | bsart        | Eigenfertigung    |
   | dispoa       | bedarfsbezogen    |
   | chverfolgung | Chargenverfolgung |
And I append rows
   | elex     | elanzahl    | tersatzt    |
   | SPLIT_BG | 1           | ja          |
   | A AG3    | !dontChange | !dontChange |
And I save the current editor

# Serviceprodukte anlegen
Given I open an editor "1SPLIT_FT" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set fields
   | nummer  | 1SPLIT_FT |
   | such    | SPLIT_FT1 |
   | artikel | SPLIT_FT  |
And I save the current editor

Given I open an editor "2SPLIT_FT" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set fields
   | nummer  | 2SPLIT_FT |
   | such    | SPLIT_FT2 |
   | artikel | SPLIT_FT  |
And I save the current editor

# Fertigungsvorschlag Unterbaugruppe anlegen
Given I open an editor "fevor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
   | artikel  | netmge | bisuch   | mfreig |
   | SPLIT_BG | 2      | SPLITBG  | ja     |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fevor"
And I save the current editor

# Rueckmeldungen Unterbaugruppe
Given I open an editor "rm" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SPLITBG000"
And I set fields
   | sofort | ja  |
   | mgr    | 102 |
And I set field "gutmge" to "1" in row 1
And I save the current editor

Given I open an editor "rm" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SPLITBG000"
And I set fields
   | sofort | ja  |
   | mgr    | 102 |
And I set field "gutmge" to "1" in row 1
And I save the current editor

# Fertigungsvorschlag Fertigteil anlegen
Given I open an editor "fevor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
   | artikel       | netmge | bisuch  | mfreig |
   | SPLIT_FT      | 2      | SPLITFT | ja     |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fevor"
And I save the current editor

# Rueckmeldungen Fertigteil
Given I open an editor "rm" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SPLITFT000"
And I set fields
   | sofort | ja  |
   | mgr    | 102 |
And I set field "gutmge" to "1" in row 1
And I set field "buplatz" to "F1" in row 1
And I save the current editor

Given I open an editor "rm" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SPLITFT000"
And I set fields
   | sofort | ja  |
   | mgr    | 102 |
And I set field "gutmge" to "1" in row 1
And I set field "buplatz" to "F1" in row 1
And I save the current editor

# Auftrag anlegen
Given I open an editor "1AU015" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | nummer | 1AU015 |
And I append rows
   | artikel   | mge | he    |
   | SPLIT_FT  | 1   | Stück |
   | SPLIT_FT  | 1   | Stück |
And I save the current editor

# Lieferschein aus Auftrag erstellen
Given I open an editor "1LS015" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU015"
And I set fields
   | nummer | 1LS015 |
   | ueb    | ja     |
And I set field "mge" to "1" in row 1
And I set field "serprod" to "1SPLIT_FT" in row 1
And I set field "mge" to "1" in row 2
And I set field "serprod" to "2SPLIT_FT" in row 2
And I save the current editor

# Serviceproduktstuecklisten ausgeben
Given I open an editor "1SPLIT_FT" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "1SPLIT_FT"
And I press button "absteigen" to open a subeditor for "stl"
Then I fill template "serviceproduktstueckliste.ftl" and append it to output file "serabwicklung.out"
And I close the current editor
And I switch the current editor to editor "1SPLIT_FT"
And I close the current editor

Given I open an editor "2SPLIT_FT" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "2SPLIT_FT"
And I press button "absteigen" to open a subeditor for "stl"
Then I fill template "serviceproduktstueckliste.ftl" and append it to output file "serabwicklung.out"
And I close the current editor
And I switch the current editor to editor "2SPLIT_FT"
And I close the current editor

# ---------------------------------------------------------------------------------------------
Scenario: Serviceauftrag (Ersatzteilaustausch) -> Lieferschein -> Ruecklieferschein
# ---------------------------------------------------------------------------------------------

# Serviceprodukt anlegen
Given I open an editor "1SP016" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set fields
	| nummer   | 1SP016             |
	| such	  | SP016              |
	| namebspr | Serviceprodukt 016 |
	| artikel  | BG-001             |
And I press button "stlanlegen" to open a subeditor for "stl"
And I save the current editor
And I switch the current editor to editor "1SP016"
And I save the current editor

# Auftrag
Given I open an editor "1AU016" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "nummer" to "1AU016"
And I append rows
	| artikel | mge | serprod |
	| BG-001  | 1   | SP016   |
And I save the current editor

# Lieferschein
Given I open an editor "1LS016" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
	| beleg  | 1AU016 |
	| nummer | 1LS016 |
	| ueb    | ja     |
And I set field "mge" to "1" in row 1
And I save the current editor

# Serviceauftrag (Ersatzteilaustausch)
Given I open an editor "1SA016" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1SA016 |
   | kunde  | 1      |
And I append rows
   | artikel | mge | he    | serprod | serstlsts         |
   | EK-003  | 1   | Stück | SP016   | wird aktualisiert |
And I save the current editor

# Lieferschein aus Serviceauftrag
Given I open an editor "2LS016" from table "(Sales):(ServiceOrder)" with command "DELIVERY" for record "1SA016"
And I set fields
   | nummer | 2LS016 |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

# Ruecklieferschein aus Lieferschein
Given I open an editor "1RLS016" from table "(Sales):(PackingSlip)" with command "RETURN" for record "2LS016"
And I set fields
   | nummer | 1RLS016 |
   | ueb    | ja      |
And I press button "offueb" in row 1
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: Dienstleistung in Serviceauftrag ueberschreiben - Termininitialisierung pruefen
# ---------------------------------------------------------------------------------------------

# Serviceauftrag
Given I open an editor "1SA004" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I append rows
   | artikel     | mge | datumvon   | zzvon  | datumbis   | zzbis   |
   | DL-BERATUNG | 1   | 05.01.1995 | 10:00  | 07.01.1995 | 12:00   |
# Dienstleistung ueberschreiben
And I set field "artikel" to "DL-SCHULUNG" in row 1
# Erwartung: Alle Termin-Felder bleiben erhalten
Then table has values
   | artikel     | mge | datumvon   | zzvon  | datumbis   | zzbis   |
   | DL-SCHULUNG | 1   | 05.01.1995 | 10:00  | 07.01.1995 | 12:00   |
And I save the current editor
