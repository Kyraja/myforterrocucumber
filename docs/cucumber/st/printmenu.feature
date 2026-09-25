@persistent
@FP_TEST
Feature: Daten anlegen fuer Infosystem PRINTMENU

Scenario: Druckeinstellungen kopieren

Given I open an editor "Druckeinstellungen" from table "(PrintParameter):(Settings)" with command "COPY" for record "verkauf"
And I set field "such" to "TESTDRUCKER"
And I set field "drucker" to "bildschirm"
And I save the current editor
And I close the current editor

Scenario: Druckeinstellungen in Passwort eintragen

Given I open an editor "Passwort" from table "(Company):(Password)" with command "UPDATE" for record "21"
And I set field "pdreinst" to "TESTDRUCKER"
And I save the current editor
And I close the current editor

@persistent
Scenario Outline: Teste alle Eingabefelder des Infosystem mit dem Rechnungskontext und Infosystem LKU

Given I open the infosystem "PRINTMENU"
And I set field "aktkontext" to "<kontext>"
And I set field "passwort" to "<passwort>"
And I set field "objektsel" to "<objektsel>"
And I set field "tabelle" to "<tabelle>"
And I set field "standort" to "<standort>"
And I press button "bstart"
Then field "auskonfig" has value "<auskonfig>"
Then field "pdreinst" has value "<pdreinst>"
Then field "layoutliste" has value "<layoutliste>"
Then field "druckerliste" has value "<druckerliste>"
Then field "objektsel" has value "<erg_objektsel>"
Then the table has <anz_rows> rows
And I close the current editor

Examples:
| row  | kontext   | passwort    | objektsel   | tabelle | standort    | auskonfig | pdreinst       | layoutliste | druckerliste | erg_objektsel | anz_rows | 
|  001 | V V-03-24 | !dontChange | !dontChange | nein    | !dontChange | ja        | DREINST4KONFIG | LAYL4KONFIG | DRL4KONFIG   | nein          | 2        | 
|  002 | V V-03-24 | 26          | !dontChange | nein    | !dontChange | nein      | SERVICE        | SERVICE     | STD          | nein          | 8        | 
|  003 | V V-03-24 | 26          | ja          | nein    | !dontChange | nein      | SERVICE        | SERVICE     | STD          | ja            | 25       | 
|  004 | V V-03-24 | 26          | ja          | ja      | !dontChange | nein      | SERVICE        | SERVICE     | STD          | ja            | 25       |
|  005 | V V-03-24 | 26          | ja          | nein    | CLIENT      | nein      | SERVICE        | SERVICE     | STD          | nein          | 26       |
|  006 | V V-03-23 | 21          | !dontChange | nein    | !dontChange | nein      | TESTDRUCKER    | VERKAUF     | BILDSCHIRM   | nein          | 2        |
|  007 | I LKU     | !dontChange | !dontChange | nein    | !dontChange | ja        | DREINST4KONFIG | LAYL4KONFIG | DRL4KONFIG   | nein          | 0        | 
|  008 | I LKU     | 26          | !dontChange | nein    | !dontChange | nein      | SERVICE        | SERVICE     | STD          | nein          | 0        | 
|  009 | I LKU     | 26          | !dontChange | nein    | CLIENT      | nein      | SERVICE        | SERVICE     | STD          | nein          | 0        | 

Scenario: Sperren von Feld Objektwahl
Given I open the infosystem "PRINTMENU"
And I set field "aktkontext" to "I LKU"
Then field "objektsel" is not modifiable
And I close the current editor
