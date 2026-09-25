@persistent
@FP_TEST
Feature: Daten anlegen fuer Infosystem PRINTSETTINGS

@persistent
Scenario Outline: Teste alle Eingabefelder des Infosystem mit dem Druckeinstellung
Given I open the infosystem "PRINTSETTINGS"
And I set field "druckeinst" to "<druckeinst>"
And I set field "bezeich" to "<bezeich>"
And I set field "abteilung" to "<abteilung>"
And I set field "inaktiv" to "<inaktiv>"
And I press button "bstart"
Then field "druckeinstdesc" has value "<druckeinstdesc>"
Then field "konfig" has value "<konfig>"
Then the table has <anz_rows> rows
And I close the current editor

Examples:
| row | druckeinst | bezeich     | abteilung   | druckeinstdesc | inaktiv     | konfig | anz_rows |
| 001 | VERKAUF    | sy          | !dontChange | Verkauf        | !dontChange | nein   | 1        |
| 002 | EINKAUF    | sy          | !dontChange | Einkauf        | !dontChange | nein   | 1        |
| 003 | SERVICE    | sy          | test        | Service        | !dontChange | nein   | 0        |

Scenario: Sperren von Feld konfig
Given I open the infosystem "PRINTSETTINGS"
And I set field "druckeinst" to "VERKAUF"
And I press button "bstart"
Then field "konfig" is not modifiable
And I close the current editor

Scenario: Loeschen und Anlegen Eintrag von Verkauf
Given I open the infosystem "PRINTSETTINGS"
And I set field "druckeinst" to "VERKAUF"
And I set field "bezeich" to "sy"
And I press button "bstart"
And I press button "teinausb" in row 1
Then field "teinausb" has value "icon:ok" in row 1
And I press button "teinausb" in row 1
Then field "teinausb" has value "icon:minus" in row 1
And I press button "teinausb" in row 1
And I close the current editor

Scenario: Loeschen alle Eintraege von Verkauf
Given I open the infosystem "PRINTSETTINGS"
And I set field "druckeinst" to "VERKAUF"
And I press button "bstart"
And I press button "einstloeschen"
And I close the current editor

Scenario: Query Keine Zuordnung
Given I query "nummer, pdreinst" from table "(Company):(Password)" where "pdreinst=VERKAUF"
Then query has no hits
