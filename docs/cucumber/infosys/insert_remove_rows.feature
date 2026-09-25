# *****************************************************************************
#  Name           : insert_remove_rows.feature
#  Autor          : fwester
#  Verantwortlich : @forterro-prd/t024-abas-core
#  Funktion       : Tests zum deklarativen Verbot von Zeilenaktionen
# *****************************************************************************
@persistent
@INSERT_REMOVE_ROWS_TEST
Feature: CRUD 65:1

##### Insert scenarios ########################################################

Scenario: Create new infosystem that allows row action

Given I'm logged in with password "sy"
Given I open an editor "Infosystem neu" from table "(Infosystem):(Infosystem)" with command "NEW" for record ""
And I set field "such" to "ROWACTIONS"
And I set field "arb" to "ow1"
And I set field "maskorigin" to "Automatisch erzeugen"
And I set field "layoutorigin" to "Keine Ausgabe"
And I set field "zeilereinerlaubt" to "ja"
And I set field "zreinvo" to "is/VERBOTEN"
And I modify table
    | !row                  | inmask | buttonnach  | param       | vms         |
    | vname=='isbstart'     | 1      | ow1/START   | !dontChange | !dontChange |
    | vname=='isisref'      | 1      | !dontChange | !dontChange | !dontChange |
    | vname=='istbauminfo'  | 1      | !dontChange | Eingabe     | änderbar    |
And I save the current editor
And I close the current editor

################################################################################

Scenario: Cause error 10249 while saving the infosystem that forbids row action but got efop for it

Given I'm logged in with password "sy"
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "ROWACTIONS"
And I set field "zeilereinerlaubt" to "nein"
And I set field "zreinvo" to "is/VERBOTEN"
Then saving the current editor throws the exception "10249"
And I close the current editor

################################################################################

Scenario: Cause error 10249 while saving the infosystem that forbids row action but got efop for it

Given I'm logged in with password "sy"
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "ROWACTIONS"
And I set field "zeilereinerlaubt" to "nein"
And I set field "zreinvo" to ""
And I set field "zreinna" to "is/VERBOTEN"
Then saving the current editor throws the exception "10249"
And I close the current editor

################################################################################

Scenario: Set insertrows to forbidden

Given I'm logged in with password "sy"
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "ROWACTIONS"
And I set field "zeilereinerlaubt" to "nein"
And I set field "zreinvo" to ""
And I save the current editor
And I close the current editor

################################################################################

Scenario: Call infosystem that forbids row action and insert row using FO while clicking Start

Given I'm logged in with password "sy"
Given I open the infosystem "ROWACTIONS"
Then editor status "INSERTROWS" has value "0"
And I press start
Then table has values
    | tbauminfo       |
    | Hallo Welt!     |
And I close the current editor

################################################################################

Scenario: Call infosystem that forbids row action and insert row as a user and cause error 294

Given I'm logged in with password "sy"
Given I open the infosystem "ROWACTIONS"
Then editor status "INSERTROWS" has value "0"
Then creating a new row at position 1 throws the exception "294"
And I close the current editor

################################################################################

Scenario: Set insertrows to asImplemented

Given I'm logged in with password "sy"
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "ROWACTIONS"
And I set field "zeilereinerlaubt" to "ja"
And I set field "zreinvo" to ""
And I save the current editor
And I close the current editor

################################################################################

Scenario: Call infosystem that supports row action and insert row as a user successfully

Given I'm logged in with password "sy"
Given I open the infosystem "ROWACTIONS"
Then editor status "INSERTROWS" has value "1"
And I append rows
    | tbauminfo   |
    | Hallo Welt! |
Then table has values
    | tbauminfo       |
    | Hallo Welt!     |
And I close the current editor

################################################################################

Scenario: Set insertrows to asImplemented but forbid insertion using is/VERBOTEN

Given I'm logged in with password "sy"
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "ROWACTIONS"
And I set field "zeilereinerlaubt" to "ja"
And I set field "zreinvo" to "is/VERBOTEN"
And I save the current editor
And I close the current editor

################################################################################

Scenario: Call infosystem that supports row action and insert row being a user and cause error 3794

Given I'm logged in with password "sy"
Given I open the infosystem "ROWACTIONS"
Then editor status "INSERTROWS" has value "1"
Then creating a new row at position 1 throws the exception "3794"
And I close the current editor

##### Remove scenarios ########################################################

Scenario: Update infosystem

Given I'm logged in with password "sy"
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "ROWACTIONS"
And I set field "zeilereinerlaubt" to "ja"
And I set field "zreinvo" to ""
And I set field "zeilerauserlaubt" to "ja"
And I set field "zrausvo" to ""
And I modify table
    | !row                  | buttonnach  |
    | vname=='isbstart'     | ow1/START2  |
And I save the current editor
And I close the current editor

################################################################################

Scenario: Cause error 10176 while saving the infosystem that forbids row action but got efop for it

Given I'm logged in with password "sy"
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "ROWACTIONS"
And I set field "zeilerauserlaubt" to "nein"
And I set field "zrausvo" to "is/VERBOTEN"
Then saving the current editor throws the exception "10176"
And I close the current editor

################################################################################

Scenario: Cause error 10176 while saving the infosystem that forbids row action but got efop for it

Given I'm logged in with password "sy"
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "ROWACTIONS"
And I set field "zeilerauserlaubt" to "nein"
And I set field "zrausvo" to ""
And I set field "zrausna" to "is/VERBOTEN"
Then saving the current editor throws the exception "10176"
And I close the current editor

################################################################################

Scenario: Error 10713 when saving infosystem with zeilebewerlaubt==false and non empty EFOP zbewvo

Given I'm logged in with password "sy"
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "ROWACTIONS"
And I set field "zeilebewerlaubt" to "nein"
And I set field "zbewvo" to "is/VERBOTEN"
And I set field "zbewna" to ""
Then saving the current editor throws the exception "10713"
And I close the current editor

################################################################################

Scenario: Error 10713 when saving infosystem with zeilebewerlaubt==false and non empty EFOP zbewna

Given I'm logged in with password "sy"
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "ROWACTIONS"
And I set field "zeilebewerlaubt" to "nein"
And I set field "zbewvo" to ""
And I set field "zbewna" to "is/VERBOTEN"
Then saving the current editor throws the exception "10713"
And I close the current editor

################################################################################

Scenario: Error 10713 when saving infosystem with zeilebewerlaubt==false and non empty EFOPs zbewvo and zbewna

Given I'm logged in with password "sy"
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "ROWACTIONS"
And I set field "zeilebewerlaubt" to "nein"
And I set field "zbewvo" to "is/VERBOTEN"
And I set field "zbewna" to "is/VERBOTEN"
Then saving the current editor throws the exception "10713"
And I close the current editor

################################################################################

Scenario: No exception when saving infosystem with zeilebewerlaubt==false and empty EFOPs zbewvo and zbewna

Given I'm logged in with password "sy"
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "ROWACTIONS"
And I set field "zeilebewerlaubt" to "nein"
And I set field "zbewvo" to ""
And I set field "zbewna" to ""
Then saving the current editor throws the exception "!noException"
And I close the current editor

################################################################################

# Scenario: Error 9871 when trying to move a row with zeilebewerlaubt==false

# Given I'm logged in with password "sy"
# Given I open the infosystem "ROWACTIONS"
# And I append rows
    # | tbauminfo |
    # | Zeile 1   |
    # | Zeile 2   |
# Then moving rows "2" to position "1" throws the exception "9871"
# And I close the current editor

################################################################################

Scenario: No exception when saving infosystem with zeilebewerlaubt==true and non empty EFOP zbewvo

Given I'm logged in with password "sy"
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "ROWACTIONS"
And I set field "zeilebewerlaubt" to "ja"
And I set field "zbewvo" to "is/VERBOTEN"
And I set field "zbewna" to ""
Then saving the current editor throws the exception "!noException"
And I close the current editor

################################################################################

Scenario: No exception when saving infosystem with zeilebewerlaubt==true and non empty EFOP zbewna

Given I'm logged in with password "sy"
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "ROWACTIONS"
And I set field "zeilebewerlaubt" to "ja"
And I set field "zbewvo" to ""
And I set field "zbewna" to "is/VERBOTEN"
Then saving the current editor throws the exception "!noException"
And I close the current editor

################################################################################

Scenario: No exception when saving infosystem with zeilebewerlaubt==true and non empty EFOPs zbewvo and zbewna

Given I'm logged in with password "sy"
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "ROWACTIONS"
And I set field "zeilebewerlaubt" to "ja"
And I set field "zbewvo" to "is/VERBOTEN"
And I set field "zbewna" to "is/VERBOTEN"
Then saving the current editor throws the exception "!noException"
And I close the current editor

################################################################################

Scenario: No exception when saving infosystem with zeilebewerlaubt==true and empty EFOPs zbewvo and zbewna

Given I'm logged in with password "sy"
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "ROWACTIONS"
And I set field "zeilebewerlaubt" to "ja"
And I set field "zbewvo" to ""
And I set field "zbewna" to ""
Then saving the current editor throws the exception "!noException"
And I close the current editor

################################################################################

Scenario: No exception when trying to move a row with zeilebewerlaubt==true

Given I'm logged in with password "sy"
Given I open the infosystem "ROWACTIONS"
And I append rows
    | tbauminfo |
    | Zeile 1   |
    | Zeile 2   |
Then I move rows "2" to position "1"
Then the table has 2 rows
Then table has values
    | tbauminfo       |
    | Zeile 2   |
    | Zeile 1   |
Then saving the current editor throws the exception "!noException"
And I close the current editor

################################################################################

Scenario: Set deleterows to forbidden

Given I'm logged in with password "sy"
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "ROWACTIONS"
And I set field "zeilerauserlaubt" to "nein"
And I set field "zrausvo" to ""
And I save the current editor
And I close the current editor

################################################################################

Scenario: Call infosystem that forbids row action and delete row using FO while clicking Start

Given I'm logged in with password "sy"
Given I open the infosystem "ROWACTIONS"
Then editor status "INSERTROWS" has value "1"
Then editor status "DELETEROWS" has value "0"
And I create a new row at the end of the table
And I press start
Then the table has 0 rows
And I close the current editor

################################################################################

Scenario: Call infosystem that forbids row action and delete row as a user and cause error 295

Given I'm logged in with password "sy"
Given I open the infosystem "ROWACTIONS"
Then editor status "INSERTROWS" has value "1"
Then editor status "DELETEROWS" has value "0"
And I create a new row at the end of the table
And deleting the row at position !lastRow throws the exception "295"
And I close the current editor

################################################################################

Scenario: Set insertrows to asImplemented

Given I'm logged in with password "sy"
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "ROWACTIONS"
And I set field "zeilerauserlaubt" to "ja"
And I set field "zrausvo" to ""
And I save the current editor
And I close the current editor

################################################################################

Scenario: Call infosystem that supports row action and delete row as a user successfully

Given I'm logged in with password "sy"
Given I open the infosystem "ROWACTIONS"
Then editor status "INSERTROWS" has value "1"
Then editor status "DELETEROWS" has value "1"
And I append rows
    | tbauminfo   |
    | Hallo Welt! |
Then table has values
    | tbauminfo       |
    | Hallo Welt!     |
And I delete all rows
Then the table has 0 rows
And I close the current editor

################################################################################

Scenario: Set deleterows to asImplemented but forbid deleting using is/VERBOTEN

Given I'm logged in with password "sy"
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "ROWACTIONS"
And I set field "zeilerauserlaubt" to "ja"
And I set field "zrausvo" to "is/VERBOTEN"
And I save the current editor
And I close the current editor

################################################################################

Scenario: Call infosystem that supports row action and delete row being a user and cause error 3885

Given I'm logged in with password "sy"
Given I open the infosystem "ROWACTIONS"
Then editor status "INSERTROWS" has value "1"
Then editor status "DELETEROWS" has value "1"
And I append rows
    | tbauminfo   |
    | Hallo Welt! |
Then table has values
    | tbauminfo       |
    | Hallo Welt!     |
And deleting the row at position 1 throws the exception "3885"
And I close the current editor

################################################################################

Scenario: No exception when saving infosystem with zeilebewerlaubt==true and item zbewpruef has EFOP is/VERBOTEN

Given I'm logged in with password "sy"
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "ROWACTIONS"
And I set field "zeilebewerlaubt" to "ja"
And I set field "zbewpruef" to "is/VERBOTEN"
And I set field "zbewvo" to ""
And I set field "zbewna" to ""
Then saving the current editor throws the exception "!noException"
And I close the current editor

################################################################################

Scenario: Error 10713 when saving infosystem with zeilebewerlaubt==false and item zbewpruef has EFOP

Given I'm logged in with password "sy"
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "ROWACTIONS"
And I set field "zeilebewerlaubt" to "nein"
And I set field "zbewpruef" to "is/VERBOTEN"
And I set field "zbewvo" to ""
And I set field "zbewna" to ""
Then saving the current editor throws the exception "10713"
And I close the current editor
