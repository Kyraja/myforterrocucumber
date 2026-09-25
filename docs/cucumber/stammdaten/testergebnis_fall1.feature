# *****************************************************************************
#  Name           : testergebnis_fall1.feature
#  Autor          : lclaus
#  Verantwortlich : lclaus
#  Kontrolle      : mibr
#  Funktion       : Aktiv scheiternder Cucumbertest zum Pruefen von testergebnis.sh
#
# *****************************************************************************
#
@persistent
Feature: Cucumberfehler
Background:
Given I set the fake date to "05.01.1995"

# ----------------------------------------------------------------------------------------------
Scenario Outline: Logikfehler erzwingen
# ----------------------------------------------------------------------------------------------

Given I open an editor "kunde" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set fields
   | nummer      | <nummer>     |
   | such        | <such>       |
   | reempf      | <reempf>     |
   | name        | <name>       |
   | ans         | <name>       |
   | str         | <str>        |
   | plz         | <plz>        |
   | nort        | <nort>       |
   | staat       | DEUTSCHLAND  |
   | email       | <email>      |

#Feld sich hat Wert TESTER -> Erzwungener Cucumberfehler
Then field "such" has value "RETSET" in row 0

And I save the current editor

Examples:
| nummer | such     | reempf      | name     | str       | plz   | nort      | email              |
| 123344 | TESTER   | !dontChange | Testfall | Teststr 1 | 11111 | Nuernberg | testfall@gmail.com |
