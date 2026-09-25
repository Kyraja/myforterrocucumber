@persistent
@FP_TEST
Feature: Daten anlegen fuer Infosystem APLADMIN

Scenario: Infosystem APLADMIN is available
Given I open the infosystem "APLADMIN"
And I close the current editor

# =========================================================================================

Scenario: Infosystem EVVORGANG copy to EVVORGANG in owev
Given I open an editor "Infosystem" from table "(Infosystem):(Infosystem)" with command "COPY" for record "10119"
And I set field "arb" to "owev"
And I save the current editor

# =========================================================================================

Scenario: Infosystem EVVORGANG copy to XEVVORGANG
Given I open an editor "Infosystem" from table "(Infosystem):(Infosystem)" with command "COPY" for record "10119"
And I set field "such" to "XEVVORGANG"
And I set field "arb" to "owev"
And I save the current editor

# =========================================================================================

Scenario: Header fields are available and can not be changed
Given I open the infosystem "APLADMIN"
Then field "infosysname" is not modifiable
Then field "copy" is not modifiable
Then field "copyname" is not modifiable
And I close the current editor

# =========================================================================================

Scenario: Header fields are available and can be changed
Given I open the infosystem "APLADMIN"
Then field "infosys" is modifiable
Then field "prefixswd" is modifiable
Then field "prefix" is modifiable
Then field "apistquelle" is modifiable
Then field "apistziel" is modifiable
And I close the current editor

# =========================================================================================

Scenario: Header fields have default values
Given I open the infosystem "APLADMIN"
Then field "infosys" has value ""
Then field "prefixswd" has value ""
Then field "prefix" has value "ow"
Then field "apistquelle" has value "ja"
Then field "apistziel" has value "nein"
And I close the current editor

# =========================================================================================

Scenario: Test table fields
Given I open the infosystem "APLADMIN"
And I set field "infosys" to "10119"
And I press button "bstart"
Then field "copy" has value "EVVORGANG"
Then field "tauswahl" has value "nein" in row 1
Then field "tarb" is not empty in row 1
Then field "taufrufparam" is not empty in row 1
Then field "tidno" is not empty in row 1
Then field "tinfosyseinaus" has value "icon:ok" in row 1
Then field "tindivaufrufparam" has value "" in row 1
Then field "tindividno" has value "" in row 1
Then field "tindivinfosyeinaus" has value "" in row 1
And I close the current editor

# =========================================================================================

Scenario: Test field Auswahl in the table
Given I open the infosystem "APLADMIN"
And I set field "infosys" to "10119"
And I press button "bstart"
And I set field "tauswahl" to "ja" in row 1
Then field "tauswahl" has value "ja" in row 1
And I set field "tauswahl" to "nein" in row 1
Then field "tauswahl" has value "nein" in row 1
And I close the current editor

# =========================================================================================

Scenario: Test button "Original activ" in the table
Given I open the infosystem "APLADMIN"
And I set field "infosys" to "10119"
And I press button "bstart"
Then field "tinfosyseinaus" has value "icon:ok" in row 1
And I press button "tinfosyseinaus" in row 1
Then field "tinfosyseinaus" has value "icon:minus" in row 1
And I press button "tinfosyseinaus" in row 1
Then field "tinfosyseinaus" has value "icon:ok" in row 1
And I close the current editor

# =========================================================================================

Scenario: Test button "Select all"
Given I open the infosystem "APLADMIN"
And I set field "infosys" to "10119"
And I press button "bstart"
And I press button "copyall"
Then field "tauswahl" has value "ja" in row 1
Then field "tauswahl" has value "ja" in row 2
Then field "tauswahl" has value "ja" in row 3
And I close the current editor

# =========================================================================================

Scenario: Test button "Cancel selection"
Given I open the infosystem "APLADMIN"
And I set field "infosys" to "10119"
And I press button "bstart"
And I set field "tauswahl" to "ja" in row 1
And I set field "tauswahl" to "ja" in row 2
And I set field "tauswahl" to "ja" in row 3
And I press button "demarkall"
Then field "tauswahl" has value "nein" in row 1
Then field "tauswahl" has value "nein" in row 2
Then field "tauswahl" has value "nein" in row 3
And I close the current editor

# =========================================================================================

Scenario: Test button "Copy selected originals"
Given I open the infosystem "APLADMIN"
And I set field "infosys" to "10119"
And I press button "bstart"
And I set field "tauswahl" to "ja" in row 1
And I press button "copyorig"
Then field "tindivaufrufparam" is not empty in row 1
Then field "tindividno" is not empty in row 1
And I close the current editor

# =========================================================================================

Scenario: Test button "Copy selected originals"
Given I open the infosystem "APLADMIN"
And I set field "infosys" to "10119"
And I press button "bstart"
And I set field "tauswahl" to "ja" in row 1
And I set field "tauswahl" to "ja" in row 2
And I press button "copyorig"
Then field "tindivaufrufparam" is not empty in row 1
Then field "tindividno" is not empty in row 1
Then field "tindivaufrufparam" is not empty in row 2
Then field "tindividno" is not empty in row 2
And I close the current editor

# =========================================================================================

Scenario: Test button "Copy activ"
Given I open the infosystem "APLADMIN"
And I set field "infosys" to "10119"
And I press button "bstart"
Then field "tindivinfosyeinaus" has value "icon:minus" in row 1
Then field "tindivapiniapl" has value "nein" in row 1
And I press button "tindivinfosyeinaus" in row 1
Then field "tindivinfosyeinaus" has value "icon:ok" in row 1
Then field "tindivapiniapl" has value "ja" in row 1
And I press button "tindivinfosyeinaus" in row 1
Then field "tindivinfosyeinaus" has value "icon:minus" in row 1
Then field "tindivapiniapl" has value "ja" in row 1
And I close the current editor

# =========================================================================================

Scenario: Test button "Delete copy"
Given I open the infosystem "APLADMIN"
And I set field "infosys" to "10119"
And I press button "bstart"
And I set field "tauswahl" to "ja" in row 1
And I set field "tauswahl" to "ja" in row 2
And I press button "deletecopy"
Then field "tindivaufrufparam" is empty in row 1
Then field "tindividno" is empty in row 1
Then field "tindivaufrufparam" is empty in row 2
Then field "tindividno" is empty in row 2
And I close the current editor

# =========================================================================================

Scenario: Test copy all CallParameter for individual Infosystem EVVORGANG
Given I open the infosystem "APLADMIN"
And I set field "infosys" to "10119"
And I press button "bstart"
And I press button "copyall"
And I press button "copyorig"
And I press button "tindivinfosyeinaus" in row 1
And I press button "tindivinfosyeinaus" in row 2
And I press button "tindivinfosyeinaus" in row 3
And I press button "tindivinfosyeinaus" in row 4
And I press button "tindivinfosyeinaus" in row 5
And I press button "tindivinfosyeinaus" in row 6
And I press button "tindivinfosyeinaus" in row 7
And I press button "tindivinfosyeinaus" in row 8
And I press button "tindivinfosyeinaus" in row 9
And I press button "tindivinfosyeinaus" in row 10
And I press button "tindivinfosyeinaus" in row 11
Then field "tindivapiniapl" has value "ja" in row 1
Then field "tindivapiniapl" has value "ja" in row 2
Then field "tindivapiniapl" has value "ja" in row 3
Then field "tindivapiniapl" has value "ja" in row 4
Then field "tindivapiniapl" has value "ja" in row 5
Then field "tindivapiniapl" has value "ja" in row 6
Then field "tindivapiniapl" has value "ja" in row 7
Then field "tindivapiniapl" has value "ja" in row 8
Then field "tindivapiniapl" has value "ja" in row 9
Then field "tindivapiniapl" has value "ja" in row 10
Then field "tindivapiniapl" has value "ja" in row 11
And I close the current editor

# =========================================================================================

Scenario: Test copy all CallParameter for individual Infosystem XEVVORGANG
Given I open the infosystem "APLADMIN"
And I set field "infosys" to "10119"
And I set field "prefixswd" to "X"
And I press button "bstart"
And I press button "copyall"
And I press button "copyorig"
And I press button "tindivinfosyeinaus" in row 1
And I press button "tindivinfosyeinaus" in row 2
And I press button "tindivinfosyeinaus" in row 3
And I press button "tindivinfosyeinaus" in row 4
And I press button "tindivinfosyeinaus" in row 5
And I press button "tindivinfosyeinaus" in row 6
And I press button "tindivinfosyeinaus" in row 7
And I press button "tindivinfosyeinaus" in row 8
And I press button "tindivinfosyeinaus" in row 9
And I press button "tindivinfosyeinaus" in row 10
And I press button "tindivinfosyeinaus" in row 11
Then field "tindivapiniapl" has value "ja" in row 1
Then field "tindivapiniapl" has value "ja" in row 2
Then field "tindivapiniapl" has value "ja" in row 3
Then field "tindivapiniapl" has value "ja" in row 4
Then field "tindivapiniapl" has value "ja" in row 5
Then field "tindivapiniapl" has value "ja" in row 6
Then field "tindivapiniapl" has value "ja" in row 7
Then field "tindivapiniapl" has value "ja" in row 8
Then field "tindivapiniapl" has value "ja" in row 9
Then field "tindivapiniapl" has value "ja" in row 10
Then field "tindivapiniapl" has value "ja" in row 11
And I close the current editor
