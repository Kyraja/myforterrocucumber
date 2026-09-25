# *****************************************************************************
#  Name: lockable_reference_eval_condition.feature
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet die Auswertung von bedingten Sperren in Editoren
# *****************************************************************************
@persistent
Feature: lockable_reference_eval_condition

Given I'm logged in with password "sy"

Scenario: Set_Lock_Configuration

Given I open an editor "Lock" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "LOCK_DRUCK"
And I set field "classname" to "DruckSperre"
And I set field "gesperrtegruppe" to "V-02-01"
And I append rows
    | verweissperrstellen| sperrwirkung |
    | DRUCK              | Gesperrt     |
And I save the current editor
And I close the current editor

Given I open an editor "Lock" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "LOCK_VSPERRE"
And I set field "classname" to "WarenkorbSperre"
And I set field "gesperrtegruppe" to "V-02-01"
And I append rows
    | verweissperrstellen| sperrwirkung |
    | VSPERRE            | Gesperrt     |
And I save the current editor
And I close the current editor

Given I open an editor "Lock" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "LOCK_ZEICH"
And I set field "classname" to "BearbeiterSperre"
And I set field "gesperrtegruppe" to "V-02-01"
And I append rows
    | verweissperrstellen| sperrwirkung |
    | ZEICH              | Gesperrt     |
And I save the current editor
And I close the current editor

Given I open an editor "Lock" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "LOCK_VOM"
And I set field "classname" to "DatumsSperre"
And I set field "gesperrtegruppe" to "V-02-01"
And I append rows
    | verweissperrstellen| sperrwirkung |
    | VOM_2               | Gesperrt     |
    | VOM_1               | Gesperrt     |
And I save the current editor
And I close the current editor

Given I open an editor "Lock" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "LOCK_WAEHR"
And I set field "classname" to "WaehrungsSperre"
And I set field "gesperrtegruppe" to "V-02-01"
And I append rows
    | verweissperrstellen| sperrwirkung |
    | WAEHR              | Gesperrt     |
And I save the current editor
And I close the current editor

Given I open an editor "Lock" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "LOCK_VORGANGA"
And I set field "classname" to "VorgangsartSperre"
And I set field "gesperrtegruppe" to "V-02-01"
And I append rows
    | verweissperrstellen| sperrwirkung |
    | VORGANGA           | Gesperrt     |
And I save the current editor
And I close the current editor

Given I open an editor "Lock" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "LOCK_VOM_LEER"
And I set field "classname" to "LeeresDatumsSperre"
And I set field "gesperrtegruppe" to "V-02-01"
And I append rows
    | verweissperrstellen| sperrwirkung |
    | VOM_LEER           | Gesperrt     |
And I save the current editor
And I close the current editor

Given I open an editor "Lock" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "LOCK_MGE"
And I set field "classname" to "MgeLock"
And I set field "gesperrtegruppe" to "V-02-01"
And I append rows
    | verweissperrstellen| sperrwirkung |
    | MGE                | Gesperrt     |
And I save the current editor
And I close the current editor

Given I open an editor "Lock" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "LOCK_LSART"
And I set field "classname" to "LsartLock"
And I set field "gesperrtegruppe" to "V-02-01"
And I append rows
    | verweissperrstellen| sperrwirkung |
    | LSART              | Gesperrt     |
And I save the current editor
And I close the current editor

Scenario: AZ_22001_erweitern

Given I open an editor "Enumeration" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "22001"
And I delete all rows
And I append rows
   | vaufzelem                        | aebez              |
   | Sperrkonfiguration LOCK_DRUCK    | Drucksperre        |
   | Sperrkonfiguration LOCK_VSPERRE  | Warenkorbsperre    |
   | Sperrkonfiguration LOCK_ZEICH    | Bearbeitersperre   |
   | Sperrkonfiguration LOCK_VOM      | Datumssperre       |
   | Sperrkonfiguration LOCK_WAEHR    | Währungssperre     |
   | Sperrkonfiguration LOCK_VORGANGA | Vorgangsartsperre  |
   | Sperrkonfiguration LOCK_VOM_LEER | LeeresDatumssperre |
   | Sperrkonfiguration LOCK_MGE      | Menge30sperre      |
   | Sperrkonfiguration LOCK_LSART    | Rückliefersperre   |
And I respond with answer "Ja" to the dialog with id "10951"
And I save the current editor
And I close the current editor

Scenario: Testfall_Drucksperre

Given I open an editor "Artikel_V1" from table "(Part):(Product)" with command "UPDATE" for record "V1"
And I set field "sperrkonfigurationneu" to "Drucksperre"
And I save the current editor
And I close the current editor

Given I open an editor "WEBAUFTRAG" from table "(Sales):(WebOrder)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "druck" to "true"
And I create a new row at the end of the table
Then setting field "artikel" to "V1" in row 2 throws the exception "4806"
And I close the current editor

Scenario: Testfall_Warenkorbsperre

Given I open an editor "Artikel_V1" from table "(Part):(Product)" with command "UPDATE" for record "V1"
And I set field "sperrkonfigurationneu" to "Warenkorbsperre"
And I save the current editor
And I close the current editor

Given I open an editor "WEBAUFTRAG" from table "(Sales):(WebOrder)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "vsperre" to "true"
And I create a new row at the end of the table
Then setting field "artikel" to "V1" in row 2 throws the exception "4806"
And I close the current editor

Scenario: Testfall_Datumssperre

Given I open an editor "Artikel_V1" from table "(Part):(Product)" with command "UPDATE" for record "V1"
And I set field "sperrkonfigurationneu" to "Datumssperre"
And I save the current editor
And I close the current editor

Given I open an editor "WEBAUFTRAG" from table "(Sales):(WebOrder)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "vom" to "20230515"
And I create a new row at the end of the table
Then setting field "artikel" to "V1" in row 2 throws the exception "4806"
And I close the current editor

Scenario: Testfall_Bearbeitersperre

Given I open an editor "Artikel_V1" from table "(Part):(Product)" with command "UPDATE" for record "V1"
And I set field "sperrkonfigurationneu" to "Bearbeitersperre"
And I save the current editor
And I close the current editor

Given I open an editor "WEBAUFTRAG" from table "(Sales):(WebOrder)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "zeich" to "fwester"
And I create a new row at the end of the table
Then setting field "artikel" to "V1" in row 2 throws the exception "4806"
And I close the current editor

Scenario: Testfall_Waehrungssperre

Given I open an editor "Artikel_V1" from table "(Part):(Product)" with command "UPDATE" for record "V1"
And I set field "sperrkonfigurationneu" to "Währungssperre"
And I save the current editor
And I close the current editor

Given I open an editor "WEBAUFTRAG" from table "(Sales):(WebOrder)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "waehr" to "USD"
And I create a new row at the end of the table
# Hier wird nur der Wert ergo das Verweisecho verglichen
Then setting field "artikel" to "V1" in row 2 throws the exception "4806"
And I close the current editor

Scenario: Testfall_Vorgangsartsperre

Given I open an editor "Artikel_V1" from table "(Part):(Product)" with command "UPDATE" for record "V1"
And I set field "sperrkonfigurationneu" to "Vorgangsartsperre"
And I save the current editor
And I close the current editor

Given I open an editor "WEBAUFTRAG" from table "(Sales):(WebOrder)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "vorgartaz" to "WebAU"
Then setting field "artikel" to "V1" in row 1 throws the exception "4806"
And I close the current editor

Scenario: Testfall_Leerwert_Datum

Given I open an editor "Artikel_V1" from table "(Part):(Product)" with command "UPDATE" for record "V1"
And I set field "sperrkonfigurationneu" to "LeeresDatumssperre"
And I save the current editor
And I close the current editor

Given I open an editor "WEBAUFTRAG" from table "(Sales):(WebOrder)" with command "NEW" for record ""
And I set field "vom" to ""
And I create a new row at the end of the table
Then setting field "artikel" to "V1" in row 1 throws the exception "4806"
And I close the current editor

Scenario: Testfall_Rechnungsmenge

Given I open an editor "Artikel_V1" from table "(Part):(Product)" with command "UPDATE" for record "V1"
And I set field "sperrkonfigurationneu" to "Menge30sperre"
And I save the current editor
And I close the current editor

Given I open an editor "WEBAUFTRAG" from table "(Sales):(WebOrder)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "mge" to "30000" in row 1
# Then setting field "artikel" to "V1" in row 1 throws the exception "4806"
And I close the current editor

Scenario: Testfall_Rueckliefersperre
# Dieser Test lieferte ADM.FEHL, weil die Aufzählung A327 (lsart) im Puffer in ihrem Wertebereich manipuliert wurde
# und so der Bedingungswert "Rücklieferschein" unzulässig wurde:
# Fehlermeldung:
# Die Verweissperrstellenprüfung ist wegen eines Konfigurationsproblems gescheitert.
# Verweissperrstellen, Zeile: 1
# 100011 LSART Artikel im Rücklieferschein sperren
# Der Bedingungswert '(ReturnPackingSlip)' passt nicht zur Art 'A327' des Bedingungsfeldes.
# Korrigieren Sie die Bedingung in der Sperrkonfiguration.
# http://extranet.abas.de/sub_de/help/hd/html/12.35.3.3.html#12.35.3.3471

Given I open an editor "Artikel_V1" from table "(Part):(Product)" with command "UPDATE" for record "V1"
And I set field "sperrkonfigurationneu" to "Rückliefersperre"
And I save the current editor
And I close the current editor

Given I open an editor "LIEFERSCHEIN" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
Then setting field "lsart" to "(ReturnPackingSlip)" in row 0 throws the exception "1361"
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I close the current editor
