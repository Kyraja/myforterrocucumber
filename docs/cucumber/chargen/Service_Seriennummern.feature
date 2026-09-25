@persistent
Feature: Service_Seriennummern.feature

Background:
And I set the fake date to "16.01.1995"

# **********************************************************************************
#  Name             : Service_Seriennummern.feature
#  Autor            : foe
#  Verantwortlich   : foe
#  Kontrolle        : carue
#  Funktion         : Testet Seriennummern im Service
#  ref              : ref_service_seriennr_cu
#
# **********************************************************************************

Scenario: Chargenpflicht in Konfiguration einschalten

Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set fields
    | chpflicht   | ja  |
And I save the current editor

Scenario Outline: Lieferanten und Kunden
Given I open an editor "<such>" from table "<table>" with command "STORE" for record "<such>"
And I set fields
    | such        | <such>        |
    | namebspr    | <namebspr>    |
    | ans         | <ans>         |
    | str         | <str>         |
    | plz         | <plz>         |
    | nort        | <nort>        |
    | staat       | <staat>       |
    | zbed        | <zbed>        |
And I save the current editor
Examples:
    | table                   | such       | namebspr             | ans       | str                  | plz         | nort            | staat       | zbed      |
    | (Vendor):(Vendor)       | LIEFCHA1   | Lieferant 1 Chargen  | LIEFCHA1  | Chargen Stra�e 1    | 12345       | Chargenstadt    | !dontChange | ZSOFORT   |
    | (Customer):(Customer)   | KUNDECH1   | Kunde 1 Chargen      | KUNDECH1  | CHSN Stra�e 1       | 56789       | CHSNstadt       | !dontChange | ZSOFORT   |
    | (Customer):(Customer)   | KUNDECH2   | Kunde 2 Chargen      | KUNDECH2  | CHSN Stra�e 2       | 67890       | CHSNstadt       | !dontChange | Z10.3     |

Scenario: STAMMDATEN - Neue Kostenstelle anlegen
Given I open an editor "kostenstelle" from table "(Account):(CostCenter)" with command "STORE" for record ""
And I set field "such" to "KS-TECHN"
And I save the current editor

Scenario: Techniker
# Mitarbeiter anlegen
Given I open an editor "Mitarbeiter" from table "(Employee):(Employee)" with command "NEW" for record ""
And I set fields
    | such    | MITECH   |
    | lohn    | 1        |
    | kstelle | KS-TECHN |
And I save the current editor

# Neuen Techniker anlegen
Given I open an editor "techniker" from table "(ServiceEmployees):(EmployeeRole)" with command "NEW" for record ""
And I set field "such" to "techniker"
And I set field "namebspr" to "Techniker"
And I set field "ma" to "MITECH"
And I save the current editor

Scenario Outline: Einkaufsartikel
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such          | <such>            |
    | namebspr      | <namebspr>        |
    | bsart         | Fremdbeschaffung  |
    | dispoa        | <dispoa>          |
    | chverfolgung  | <chverfolgung>    |
    | chimlager     | <chimlager>       |
    | lief          | <lief>            |
    | efrist        | <efrist>          |
    | epr           | <epr>             |
    | vpr           | <vpr>             |
And I save the current editor

Examples:
    | such            | namebspr                            | dispoa            | chverfolgung              | chimlager     | lief        | efrist      | epr         | vpr         | serpflicht |
    | NOCHARGE2       | ohne Chargenpflicht                 | bedarfsbezogen    |                           | !dontChange   | TEST        | 3           | 5           | 10          | nein       |
    | INVNOCHARGE     | Inventur ohne Charge                | auftragsbezogen   |                           | !dontChange   | TEST        | 3           | 5           | 10          | ja         |
    | EK01_SNR        | seriennummernpflichtiges Teil 1     | bedarfsbezogen    | Seriennummernverfolgung   | ja            | LIEFCHA1    | 3           | 5           | 10          | ja         |
    | EK02_SNR        | seriennummernpflichtiges Teil 2     | bedarfsbezogen    | Seriennummernverfolgung   | ja            | LIEFCHA1    | 3           | 5           | 10          | ja         |
    | EK03_SNR        | seriennummernpflichtiges Teil 3     | bedarfsbezogen    | Seriennummernverfolgung   | ja            | LIEFCHA1    | 3           | 15          | 20          | ja         |
    | EK04_SNR        | seriennummernpflichtiges Teil 4     | bedarfsbezogen    | Seriennummernverfolgung   | ja            | LIEFCHA1    | 3           | 35          | 50          | ja         |
    | EK05_SNR        | seriennummernpflichtiges Teil 5     | bedarfsbezogen    | Seriennummernverfolgung   | ja            | LIEFCHA1    | 3           | 35          | 50          | ja         |
    | EK06_SNR        | seriennummernpflichtiges Teil 6     | bedarfsbezogen    | Seriennummernverfolgung   | ja            | LIEFCHA1    | 1           | 10          | 14          | ja         |
    | EK07_SNR        | seriennummernpflichtiges Teil 7     | bedarfsbezogen    | Seriennummernverfolgung   | ja            | LIEFCHA1    | 2           | 20          | 24          | ja         |

#---------------------------------------------------------------------------------------------
Scenario: Seriennummerm anlegen und zubuchen
#---------------------------------------------------------------------------------------------

# Seriennummern anlegen
Given I create a Lot "C1-EK01_SNR" for Product "EK01_SNR"
Given I create a Lot "C2-EK01_SNR" for Product "EK01_SNR"
Given I create a Lot "C1-EK02_SNR" for Product "EK02_SNR"
Given I create a Lot "C2-EK02_SNR" for Product "EK02_SNR"
Given I create a Lot "C1-EK03_SNR" for Product "EK03_SNR"
Given I create a Lot "C2-EK03_SNR" for Product "EK03_SNR"
Given I create a Lot "C3-EK03_SNR" for Product "EK03_SNR"
Given I create a Lot "C1-EK04_SNR" for Product "EK04_SNR"
Given I create a Lot "C2-EK04_SNR" for Product "EK04_SNR"
Given I create a Lot "C1-EK05_SNR" for Product "EK05_SNR"
Given I create a Lot "C2-EK05_SNR" for Product "EK05_SNR"
Given I create a Lot "C1-EK06_SNR" for Product "EK06_SNR"
Given I create a Lot "C2-EK06_SNR" for Product "EK06_SNR"
Given I create a Lot "C1-EK07_SNR" for Product "EK07_SNR"
Given I create a Lot "C2-EK07_SNR" for Product "EK07_SNR"

# Bestand mit Charge zubuchen
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK01_SNR    |
    | buart     | Zugang      |
    | beleg     | LB_EK01_SNR |
    | beldat    | .           |
    | wert      | 1.          |
And I delete all rows
And I append rows
    | mge    | platz2 | tcharge2    |
    | 1      | F2     | C1-EK01_SNR |
    | 1      | F2     | C2-EK01_SNR |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK02_SNR    |
    | buart     | Zugang      |
    | beleg     | LB_EK02_SNR |
    | beldat    | .           |
    | wert      | 1.          |
And I delete all rows
And I append rows
    | mge    | platz2 | tcharge2    |
    | 1      | F2     | C1-EK02_SNR |
    | 1      | F2     | C2-EK02_SNR |
    | 1      | F1     | C3-EK02_SNR |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK03_SNR    |
    | buart     | Zugang      |
    | beleg     | LB_EK03_SNR |
    | beldat    | .           |
    | wert      | 1.          |
And I delete all rows
And I append rows
    | mge    | platz2 | tcharge2    |
    | 1      | F1     | C1-EK03_SNR |
    | 1      | F1     | C2-EK03_SNR |
    | 1      | F1     | C3-EK03_SNR |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK04_SNR    |
    | buart     | Zugang      |
    | beleg     | LB_EK04_SNR |
    | beldat    | .           |
    | wert      | 1.          |
And I delete all rows
And I append rows
    | mge    | platz2 | tcharge2    |
    | 1      | F1     | C1-EK04_SNR |
    | 1      | F1     | C2-EK04_SNR |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK05_SNR    |
    | buart     | Zugang      |
    | beleg     | LB_EK05_SNR |
    | beldat    | .           |
    | wert      | 1.          |
And I delete all rows
And I append rows
    | mge    | platz2 | tcharge2    |
    | 1      | F1     | C1-EK05_SNR |
    | 1      | F1     | C2-EK05_SNR |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK06_SNR    |
    | buart     | Zugang      |
    | beleg     | LB_EK06_SNR |
    | beldat    | .           |
    | wert      | 1.          |
And I delete all rows
And I append rows
    | mge    | platz2 | tcharge2    |
    | 1      | F1     | C1-EK06_SNR |
    | 1      | F1     | C2-EK06_SNR |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK07_SNR    |
    | buart     | Zugang      |
    | beleg     | LB_EK07_SNR |
    | beldat    | .           |
    | wert      | 1.          |
And I delete all rows
And I append rows
    | mge    | platz2 | tcharge2    |
    | 1      | F1     | C1-EK07_SNR |
    | 1      | F1     | C2-EK07_SNR |
And I save the current editor
#---------------------------------------------------------------------------------------------
Scenario: Serviceauftrag mit Seriennummer
#---------------------------------------------------------------------------------------------

# Serviceauftrag mit chargenpflichtigen Artikel angelegen
Given I open an editor "SERV_AU01" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDECH1"
And I set field "nummer" to "1SERVAU"
And I append rows
  | techniker | artex     | mge | platz | charge      |
  | techniker | EK01_SNR  |  1  | F2    | C1-EK01_SNR |
And I save the current editor

# Servicerueckmeldung erzeugen
Given I open an editor "SRM_AU01" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "SERV_AU01"
And I set field "nummer" to "1SRM"
And I set field "kstelle" to id from editor "kostenstelle"
And I set field "lgr" to "1"
And I press button "ladetab"
Then the table has 1 rows
Then setting field "bumge" to "2" in row 1 throws the exception "7039"
Then field "charge" has value "1" in row 1
Then field "charge" is not modifiable in row 1
And I set field "buchen" to "ja" in row 1
And I set field "bumge" to "1" in row 1
Then field "charge" is modifiable in row 1
And I set field "charge" to "" in row 1
Then saving the current editor throws the exception "1164"
# Falsche Charge eintragen -> Artikel stimmt nicht mit dem Artikel der Charge ueberein
Then setting field "charge" to "3" in row 1 throws the exception "3166"
And I set field "charge" to "1" in row 1
Then field "bumge" has value "1" in row 1
Then field "charge" has value "1" in row 1
Then field "charge" is modifiable in row 1
And I save the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "EK01_SNR" on StorageLocation "F2"
Then StorageQuantities have values
    | gebmge | gebeinh  | bewmge | charge |
    | 1      | Stück    | 1      | 2      |
And I close the current editor


#---------------------------------------------------------------------------------------------
Scenario: Keine 2 Servicerueckmeldungen mit gleicher Serierennummer moeglich
#---------------------------------------------------------------------------------------------

# 2 Serviceaufträge mit chargenpflichtigen Artikel angelegen
Given I open an editor "SERV_AU02" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDECH1"
And I set field "nummer" to "2SERVAU"
And I append rows
  | techniker | artex     | mge | platz | charge      |
  | techniker | EK02_SNR  |  1  | F2    | C1-EK02_SNR |
And I save the current editor

Given I open an editor "SERV_AU03" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDECH1"
And I set field "nummer" to "3SERVAU"
And I append rows
  | techniker | artex     | mge | platz | charge      |
  | techniker | EK02_SNR  |  1  | F2    | C1-EK02_SNR |
Then field "charge" has value "3" in row 1
# Speichern nicht moeglich, da Seriennummer bereits aktiv
Then saving the current editor throws the exception "7044"
And I set field "charge" to "4" in row 1
And I save the current editor

# 1. Servicerueckmeldung erzeugen, nicht buchen
Given I open an editor "SRM_AU02" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "SERV_AU02"
And I set field "nummer" to "2SRM"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bumge" to "1" in row 1
Then field "charge" is modifiable in row 1
Then field "charge" has value "3" in row 1
And I set field "ueb" to "nein"
And I save the current editor

# 2. Servicerueckmeldung erzeugen und buchen
Given I open an editor "SRM_AU03" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "SERV_AU03"
And I set field "nummer" to "3SRM"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bumge" to "1" in row 1
Then field "charge" is modifiable in row 1
Then setting field "charge" to "3" in row 1 throws the exception "7044"
Then field "charge" has value "4" in row 1
And I set field "ueb" to "ja"
And I save the current editor

# 1. Servicerueckmeldung buchen
Given I open an editor "SRM_AU02" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "UPDATE" for record "2SRM"
Then the table has 1 rows
Then field "bumge" has value "1" in row 1
Then field "charge" has value "3" in row 1
And I set field "ueb" to "ja"
And I save the current editor

#---------------------------------------------------------------------------------------------
Scenario: Servicerueckmeldung zu Serviceauftrag mit MZs
#---------------------------------------------------------------------------------------------

# Serviceauftrage mit chargenpflichtigen Artikel und MZs angelegen
Given I open an editor "SERV_AU04" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDECH1"
And I set field "nummer" to "4SERVAU"
And I append rows
  | techniker | artex     | mge | platz |
  | techniker | EK03_SNR  |  3  | F1    |
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge | charge |
    | 1     | F1     | 1      | 5      |
    | 2     | F1     | 1      | 6      |
    | 3     | F1     | 1      | 7      |
And I save the current editor
And I switch the current editor to editor "SERV_AU04"
And I save the current editor

# Servicerueckmeldung erzeugen und buchen
Given I open an editor "SRM_AU04" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "SERV_AU04"
And I set field "nummer" to "4SRM"
And I press button "ladetab"
Then the table has 1 rows
Then setting field "bumge" to "3" in row 1 throws the exception "7039"
And I set field "bumge" to "1" in row 1
And I set field "charge" to "5" in row 1
And I create a new row at the end of the table
And I set field "artikel" to " EK03_SNR" in row 2
And I set field "bumge" to "1" in row 2
And I set field "charge" to "6" in row 2
And I create a new row at the end of the table
And I set field "artikel" to " EK03_SNR" in row 3
And I set field "bumge" to "1" in row 3
And I set field "charge" to "7" in row 3
And I save the current editor

# Servicerueckmeldung zurueckbuchen - Zusätzliche Rueckgabe nicht moeglich
Given I open an editor "SRM_AU4RF" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "servau" to id from editor "SERV_AU04"
And I set field "techniker" to id from editor "techniker"
And I set field "nummer" to "4SRMF"
And I press button "ladetab"
Then the table has 3 rows
And I delete row at position 3
And I create a new row at the end of the table
And I set field "artikel" to " EK03_SNR" in row 3
And I set field "bumge" to "-1" in row 3
And I set field "charge" to "5" in row 3
Then saving the current editor throws the exception "3273"
And I close the current editor

# Servicerueckmeldung zurueckbuchen - Seriennummern eingetragen und verwerfen
Given I open an editor "SRM_AU4BR" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "servau" to id from editor "SERV_AU04"
And I set field "techniker" to id from editor "techniker"
And I set field "nummer" to "4SRMR"
And I press button "ladetab"
Then the table has 3 rows
And I set field "bumge" to "-1" in row 3
# Charge kann nicht mit Bezug zu Serviceauftragsposition gebucht werden,
# da sie ueber eine zusaetzliche Zeile abgebucht wurde
And I set field "charge" to "6" in row 3
Then saving the current editor throws the exception "3273"
And I set field "charge" to "5" in row 3
And I create a new row at the end of the table
And I set field "artikel" to " EK03_SNR" in row 4
And I set field "bumge" to "-1" in row 4
And I set field "charge" to "6" in row 4
And I create a new row at the end of the table
And I set field "artikel" to " EK03_SNR" in row 5
And I set field "bumge" to "-1" in row 5
Then setting field "charge" to "6" in row 5 throws the exception "7044"
And I set field "charge" to "7" in row 5
# Nur die zusaetzlichen Entnahmen SN 6 und 7 zurueckbuchen
And I delete row at position 3
And I save the current editor

#---------------------------------------------------------------------------------------------
Scenario: Serviceauftrag mit Seriennummer, Servicerueckmeldung nicht buchen
#---------------------------------------------------------------------------------------------

# Serviceauftrag mit chargenpflichtigen Artikel angelegen
Given I open an editor "SERV_AU05" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDECH1"
And I set field "nummer" to "5SERVAU"
And I append rows
  | techniker | artex     | mge | platz | charge      |
  | techniker | EK01_SNR  |  1  | F2    | C2-EK01_SNR |
And I save the current editor

# Servicerueckmeldung erzeugen
Given I open an editor "SRM_AU05" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "SERV_AU05"
And I set field "nummer" to "5SRM"
And I set field "kstelle" to id from editor "kostenstelle"
And I set field "lgr" to "1"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bumge" to "1" in row 1
Then field "charge" has value "2" in row 1
And I set field "buchen" to "nein" in row 1
And I save the current editor

#---------------------------------------------------------------------------------------------
Scenario: Serviceauftrag mit Seriennummer, Servicerueckmeldung und Rueckbuchung
#---------------------------------------------------------------------------------------------

# Serviceauftrag anlegen
Given I open an editor "SERV_AU06" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDECH2"
And I set field "nummer" to "6SERVAU"
And I create a new row at the end of the table
And I set field "artex" to "EK04_SNR" in row 1
And I set field "mge" to "1" in row 1
And I set field "charge" to "8" in row 1
And I save the current editor

# Servicerueckmeldung anlegen und buchen
Given I open an editor "SRM_AU06" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "servau" to id from editor "SERV_AU06"
And I set field "techniker" to id from editor "techniker"
And I set field "nummer" to "6SRM"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bumge" to "1" in row 1
And I set field "charge" to "8" in row 1
And I save the current editor

# Servicerueckmeldung zurueckbuchen - pruefen, ob Seriennummer uebernommen wurde
Given I open an editor "servicerueckmeldung2" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "servau" to id from editor "SERV_AU06"
And I set field "techniker" to id from editor "techniker"
And I set field "nummer" to "6SRMR"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bumge" to "-1" in row 1
Then field "charge" has value "8" in row 1
And I set field "bumge" to "1" in row 1
Then saving the current editor throws the exception "7044"
And I set field "bumge" to "-1" in row 1
And I save the current editor

#---------------------------------------------------------------------------------------------
Scenario: Serviceauftrag ohne Seriennummer, Servicerueckmeldung und Rueckbuchung mit Seriennummer
#---------------------------------------------------------------------------------------------

# Serviceauftrag anlegen
Given I open an editor "SERV_AU07" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDECH2"
And I set field "nummer" to "7SERVAU"
And I create a new row at the end of the table
And I set field "artex" to "EK04_SNR" in row 1
And I set field "mge" to "1" in row 1
And I save the current editor

# Servicerueckmeldung anlegen und buchen
Given I open an editor "SRM_AU07" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "servau" to id from editor "SERV_AU07"
And I set field "techniker" to id from editor "techniker"
And I set field "nummer" to "7SRM"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bumge" to "1" in row 1
And I set field "charge" to "9" in row 1
And I save the current editor

# Servicerueckmeldung zurueckbuchen - pruefen, ob Seriennummer uebernommen wurde
Given I open an editor "servicerueckmeldung2" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "servau" to id from editor "SERV_AU07"
And I set field "techniker" to id from editor "techniker"
And I set field "nummer" to "7SRMR"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bumge" to "-1" in row 1
Then field "charge" has value "9" in row 1
And I save the current editor

# Seriennummer in den Serviceauftrag zurueckschreiben
Given I open an editor "SERV_AU07B" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record from editor "SERV_AU07"
Then field "charge" has value "9" in row 1
And I save the current editor

#---------------------------------------------------------------------------------------------
Scenario: Servicerueckmeldung zu Serviceauftrag mit MZs und rueckbuchen
#---------------------------------------------------------------------------------------------

# Serviceauftrage mit chargenpflichtigen Artikel und MZs angelegen
Given I open an editor "SERV_AU08" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDECH1"
And I set field "nummer" to "8SERVAU"
And I append rows
  | techniker | artex     | mge | platz |
  | techniker | EK05_SNR  |  2  | F1    |
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge | charge |
    | 1     | F1     | 1      | 10     |
    | 2     | F1     | 1      | 11     |
And I save the current editor
And I switch the current editor to editor "SERV_AU08"
And I save the current editor

# 1. Servicerueckmeldung erzeugen und buchen
Given I open an editor "SRM_AU08A" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "SERV_AU08"
And I set field "nummer" to "8SRMA"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bumge" to "1" in row 1
And I set field "charge" to "10" in row 1
And I save the current editor

# 2. Servicerueckmeldung erzeugen und buchen
Given I open an editor "SRM_AU08B" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "SERV_AU08"
And I set field "nummer" to "8SRMB"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bumge" to "1" in row 1
And I set field "charge" to "11" in row 1
And I save the current editor

# 1. Servicerueckmeldung zurueckbuchen - Seriennummer eingetragen
Given I open an editor "SRM_AU8AR" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "servau" to id from editor "SERV_AU08"
And I set field "techniker" to id from editor "techniker"
And I set field "nummer" to "8SRMAR"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bumge" to "-1" in row 1
And I set field "charge" to "10" in row 1
And I save the current editor

# 2. Servicerueckmeldung zurueckbuchen - Seriennummer eingetragen und verwerfen
Given I open an editor "SRM_AU8BR" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "servau" to id from editor "SERV_AU08"
And I set field "techniker" to id from editor "techniker"
And I set field "nummer" to "8SRMBR"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bumge" to "-1" in row 1
And I set field "charge" to "11" in row 1
And I close the current editor

#---------------------------------------------------------------------------------------------
Scenario: Serviceauftrag mit Seriennummer anlegen und dann wieder stornieren
#---------------------------------------------------------------------------------------------

# Serviceauftrag mit chargenpflichtigen Artikel angelegen
Given I open an editor "SERV_AU09" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDECH1"
And I set field "nummer" to "9SERVAU"
And I append rows
  | techniker | artex     | mge | platz | charge      |
  | techniker | EK03_SNR  |  1  | F2    | C2-EK03_SNR |
And I save the current editor

Given I open an editor "C2-EK03_SNR" from table "(Lots):(Lots)" with command "VIEW" for record "6"
Then field "snaktabgang" has value "ja"
Then field "snabgangverf" has value "nein"
And I close the current editor

# Serviceauftrag stornieren
Given I open an editor "SERV_AU09S" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record "9SERVAU"
And I respond with answer "ja" to the dialog with id "191"
And I set field "mge" to "0" in row 1
And I save the current editor

Given I open an editor "C2-EK03_SNR" from table "(Lots):(Lots)" with command "VIEW" for record "6"
Then field "snaktabgang" has value "nein"
Then field "snabgangverf" has value "ja"
And I close the current editor

#---------------------------------------------------------------------------------------------
Scenario: Original-Seriennnummer Serviceauftrag
#---------------------------------------------------------------------------------------------

# Serviceauftrag mit chargenpflichtigen Artike anlegen
Given I open an editor "SERV_AU10" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDECH2"
And I set field "nummer" to "10SERVAU"
And I append rows
  | techniker | artex     | mge | platz | charge      |
  | techniker | EK06_SNR  |  1  | F1    | C2-EK06_SNR |
And I save the current editor

# Servicerueckmeldung anlegen und buchen
Given I open an editor "SRM_AU10" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "servau" to id from editor "SERV_AU10"
And I set field "techniker" to id from editor "techniker"
And I set field "nummer" to "10SRM"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bumge" to "1" in row 1
And I set field "charge" to "12" in row 1
And I save the current editor

# Seriennummer in den Serviceauftrag zurueckschreiben
Given I open an editor "SERV_AU10B" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record from editor "SERV_AU10"
Then field "charge" has value "12" in row 1
And I close the current editor

Given I open an editor "C1-EK06_SNR" from table "(Lots):(Lots)" with command "VIEW" for record "12"
Then field "snaktabgang" has value "nein"
Then field "snabgangverf" has value "nein"
And I close the current editor

Given I open an editor "C2-EK06_SNR" from table "(Lots):(Lots)" with command "VIEW" for record "13"
Then field "snaktabgang" has value "nein"
Then field "snabgangverf" has value "ja"
And I close the current editor

# Serviceauftrag mit bereits gebuchter Seriennummer kann geaendert werden
Given I open an editor "SERV_AU10C" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record from editor "SERV_AU10"
And I set field "vom" to "."
And I save the current editor


#---------------------------------------------------------------------------------------------
Scenario: Servicerueckmeldung zu Serviceauftrag mit MZs und Rückbuchung
#---------------------------------------------------------------------------------------------

# Serviceauftrage mit chargenpflichtigen Artikel und MZs angelegen
Given I open an editor "SERV_AU11" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDECH1"
And I set field "nummer" to "11SERVAU"
And I append rows
  | techniker | artex     | mge | platz |
  | techniker | EK07_SNR  |  2  | F1    |
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge | charge      |
    | 1     | F1     | 1      | C1-EK07_SNR |
    | 2     | F1     | 1      | C2-EK07_SNR |
And I save the current editor
And I switch the current editor to editor "SERV_AU11"
And I save the current editor

# Servicerueckmeldung fuer 1. SNR erzeugen und buchen
Given I open an editor "SRM1_AU11" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "SERV_AU11"
And I set field "nummer" to "4SRM1"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bumge" to "1" in row 1
And I set field "charge" to "C1-EK07_SNR" in row 1
And I save the current editor

# Servicerueckmeldung fuer 2. SNR erzeugen und buchen
Given I open an editor "SRM2_AU11" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "SERV_AU11"
And I set field "nummer" to "4SRM2"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bumge" to "1" in row 1
And I set field "charge" to "C2-EK07_SNR" in row 1
And I save the current editor

# 2. Servicerueckmeldung zurueckbuchen
Given I open an editor "SRM2_AU11R" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "servau" to id from editor "SERV_AU11"
And I set field "techniker" to id from editor "techniker"
And I set field "nummer" to "4SRM2R"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bumge" to "-1" in row 1
And I set field "charge" to "C2-EK07_SNR" in row 1
And I save the current editor

# Servicerueckmeldung zurueckbuchen
Given I open an editor "SRM1_AU11R" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "servau" to id from editor "SERV_AU11"
And I set field "techniker" to id from editor "techniker"
And I set field "nummer" to "4SRM1R"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bumge" to "-1" in row 1
And I set field "charge" to "C1-EK07_SNR" in row 1
And I save the current editor
