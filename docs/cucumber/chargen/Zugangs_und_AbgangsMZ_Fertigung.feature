@persistent
Feature: Zugangs_und_AbgangsMZ_Fertigung.feature

Background:
And I set the fake date to "16.01.1995"

# **********************************************************************************
#  Name             : Zugangs_und_AbgangsMZ_Fertigung.feature
#  Autor            : bschiga
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Chargen-/Seriennummernverwaltung
#  ref              : ref_chargen_seriennr_cu
#
# **********************************************************************************

Scenario: A1F1 Zugangs- und AbgangsMZ in der Fertigung - Retrograd - BG mit 1 AG - Zugangscharge im Vorgang passt zur AbgangsMZ

Given I create a work order "A1F1" for Product "BG11_CHARGE" with quantity "10" and search word "A1F1_"

Given I create a Lot "C1A1F1ZU1" for Product "BG11_CHARGE"
Given I create a Lot "C2A1F1ZU2" for Product "BG11_CHARGE"

Given I create a Lot "C1A1F1AB1" for Product "EK01_CHARGE"
Given I create a Lot "C2A1F1AB2" for Product "EK01_CHARGE"

Given I open an editor "BA_A1F1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "A1F1_000"
And I press button "mzsubm" to open a subeditor for "ZugangsMZ"
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 5        | C1A1F1ZU1 |
And I save the current editor
And I switch the current editor to editor "BA_A1F1"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "resetmanbu"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   | zcharge   |
    | +1    | F1     | 3        | C1A1F1AB1 | C2A1F1ZU2 |
    | +2    | F1     | 2        | C2A1F1AB2 | C1A1F1ZU1 |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_A1F1"
And I save the current editor

Given I open an editor "RM1_A1F1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "A1F1_001"
And I set fields
    | sofort    | ja            |
    | kcharge   | C2A1F1ZU2     |
    | bem       | RM1_A1F1      |
And I set field "gutmge" to "4" in row 1
And I set field "erbtext1" to "RM1_A1F1" in row 1
# 2743 Für die zu buchende Gutmenge mit dieser Chargen-/Seriennummer reicht die Menge in den Materialzuordnungen nicht aus.
Then saving the current editor throws the exception "2743"
And I set field "gutmge" to "2" in row 1
And I set field "kcharge" to "C1A1F1ZU1"
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_A1F1^barmex"
And I set field "artikel" to "BG11_CHARGE"
And I press start
Then table has values
    | zmge | amge     | tvcharge    | vcharge   | tncharge  | ncharge^id    | nplatz    |
    | 2    |          |             |           | C1A1F1ZU1 | !C1A1F1ZU1^id | F1        |
And I close the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_A1F1^barmex"
And I set field "artikel" to "EK01_CHARGE"
And I press start
Then the table has 1 rows
Then table has values
    | zmge | amge     | tvcharge    | vcharge^id     | vplatz    | tncharge  | ncharge^id    |
    |      | 2        | C2A1F1AB2   | !C2A1F1AB2^id  | F1        | C1A1F1ZU1 | !C1A1F1ZU1^id |
And I close the current editor


Scenario: A1F2 Zugangs- und AbgangsMZ in der Fertigung - Retrograd - BG mit 1 AG - Zugangscharge im Vorgang passt NICHT zur AbgangsMZ

Given I create a work order "A1F2" for Product "BG11_CHARGE" with quantity "10" and search word "A1F2_"

Given I create a Lot "C1A1F2ZU1" for Product "BG11_CHARGE"
Given I create a Lot "C2A1F2ZU2" for Product "BG11_CHARGE"
Given I create a Lot "C3A1F2ZU3" for Product "BG11_CHARGE"

Given I create a Lot "C1A1F2AB1" for Product "EK01_CHARGE"
Given I create a Lot "C2A1F2AB2" for Product "EK01_CHARGE"

Given I open an editor "BA_A1F2" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "A1F2_000"
And I press button "mzsubm" to open a subeditor for "ZugangsMZ"
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 5        | C1A1F2ZU1 |
And I save the current editor
And I switch the current editor to editor "BA_A1F2"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "resetmanbu"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   | zcharge   |
    | +1    | F1     | 3        | C1A1F2AB1 | C2A1F2ZU2 |
    | +2    | F1     | 2        | C2A1F2AB2 |           |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_A1F2"
And I save the current editor

Given I open an editor "RM1_A1F2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "A1F2_001"
And I set fields
    | sofort    | ja            |
    | kcharge   | C3A1F2ZU3     |
    | bem       | RM1_A1F2      |
And I set field "gutmge" to "4" in row 1
And I set field "erbtext1" to "RM1_A1F2" in row 1
# 2743 Für die zu buchende Gutmenge mit dieser Chargen-/Seriennummer reicht die Menge in den Materialzuordnungen nicht aus.
Then saving the current editor throws the exception "2743"
And I set field "kcharge" to "C1A1F2ZU1"
And I save the current editor

# auf den AG wurden 4 Stk rueckgemeldet, Material wurde nur fuer 2 Stk abgebucht, limge nur um 2 Stk reduziert auf 8
Given I open an editor "BA_A1F2_PRUEF" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "A1F2_000"
And I press button "absteig" to open a subeditor for "AFL"
Then field "limge" has value "8" in row 1
Then field "limge" has value "6" in row 2
And I close the current editor
And I switch the current editor to editor "BA_A1F2_PRUEF"
And I close the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_A1F2^barmex"
And I set field "artikel" to "BG11_CHARGE"
And I press start
Then table has values
    | zmge | amge     | tvcharge    | vcharge   | tncharge  | ncharge^id    | nplatz    |
    | 4    |          |             |           | C1A1F2ZU1 | !C1A1F2ZU1^id | F1        |
And I close the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_A1F2^barmex"
And I set field "artikel" to "EK01_CHARGE"
And I press start
Then table has values
    | zmge | amge     | tvcharge    | vcharge^id     | vplatz    | tncharge  | ncharge^id    |
    |      | 2        | C2A1F2AB2   | !C2A1F2AB2^id  | F1        | C1A1F2ZU1 | !C1A1F2ZU1^id |
And I close the current editor


Scenario: A1F3 Zugangs- und AbgangsMZ in der Fertigung - Retrograd - BG mit 1 AG - OHNE Zugangscharge im Vorgang

Given I create a work order "A1F3" for Product "BG11_CHARGE" with quantity "10" and search word "A1F3_"

Given I create a Lot "C1A1F3ZU1" for Product "BG11_CHARGE"
Given I create a Lot "C2A1F3ZU2" for Product "BG11_CHARGE"

Given I create a Lot "C1A1F3AB1" for Product "EK01_CHARGE"
Given I create a Lot "C2A1F3AB2" for Product "EK01_CHARGE"

Given I open an editor "BA_A1F3" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "A1F3_000"
And I press button "mzsubm" to open a subeditor for "ZugangsMZ"
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 5        | C1A1F3ZU1 |
And I save the current editor
And I switch the current editor to editor "BA_A1F3"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "resetmanbu"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   | zcharge   |
    | +1    | F1     | 3        | C1A1F3AB1 | C2A1F3ZU2 |
    | +2    | F1     | 2        | C2A1F3AB2 |           |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_A1F3"
And I save the current editor

Given I open an editor "RM1_A1F3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "A1F3_001"
And I set fields
    | sofort    | ja            |
    | bem       | RM1_A1F3      |
And I set field "gutmge" to "4" in row 1
And I set field "erbtext1" to "RM1_A1F3" in row 1
And I save the current editor

# auf den AG wurden 4 Stk rueckgemeldet, Material wurde nur fuer 2 Stk abgebucht, limge nur um 2 Stk reduziert auf 8
Given I open an editor "BA_A1F3_PRUEF" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "A1F3_000"
And I press button "absteig" to open a subeditor for "AFL"
Then field "limge" has value "8" in row 1
Then field "limge" has value "6" in row 2
And I close the current editor
And I switch the current editor to editor "BA_A1F3_PRUEF"
And I close the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_A1F3^barmex"
And I set field "artikel" to "BG11_CHARGE"
And I press start
Then table has values
    | zmge | amge     | tvcharge    | vcharge   | tncharge  | ncharge^id    | nplatz    |
    | 4    |          |             |           | C1A1F3ZU1 | !C1A1F3ZU1^id | F1        |
And I close the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_A1F3^barmex"
And I set field "artikel" to "EK01_CHARGE"
And I press start
Then table has values
    | zmge | amge     | tvcharge    | vcharge^id     | vplatz    | tncharge  | ncharge^id    |
    |      | 2        | C2A1F3AB2   | !C2A1F3AB2^id  | F1        | C1A1F3ZU1 | !C1A1F3ZU1^id |
And I close the current editor


Scenario: A2F1 Zugangs- und AbgangsMZ in der Fertigung - Retrograd - Baugruppe mit 3 AG, Zugangscharge im Vorgang passt zur AbgangsMZ

Given I create a work order "A2F1" for Product "BG03_CHARGE" with quantity "10" and search word "A2F1_"

Given I create a Lot "C1A2F1ZU1" for Product "BG03_CHARGE"
Given I create a Lot "C2A2F1ZU2" for Product "BG03_CHARGE"

Given I create a Lot "C1A2F1AB1" for Product "EK01_CHARGE"
Given I create a Lot "C2A2F1AB2" for Product "EK01_CHARGE"

Given I create a Lot "C3A2F1AB1" for Product "EK02_CHARGE"
Given I create a Lot "C4A2F1AB2" for Product "EK02_CHARGE"

Given I open an editor "BA_A2F1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "A2F1_000"
And I press button "mzsubm" to open a subeditor for "ZugangsMZ"
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 5        | C1A2F1ZU1 |
And I save the current editor
And I switch the current editor to editor "BA_A2F1"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "resetmanbu"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   | zcharge   |
    | +1    | F1     | 3        | C1A2F1AB1 | C2A2F1ZU2 |
    | +2    | F1     | 2        | C2A2F1AB2 |           |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   | zcharge   |
    | +1    | F1     | 3        | C3A2F1AB1 | C2A2F1ZU2 |
    | +2    | F1     | 2        | C4A2F1AB2 |           |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_A2F1"
And I save the current editor

Given I open an editor "RM1_A2F1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "A2F1_001"
And I set fields
    | sofort    | ja            |
    | kcharge   | C2A2F1ZU2     |
    | bem       | RM1_A2F1      |
And I set field "gutmge" to "4" in row 1
And I set field "erbtext1" to "RM1_A2F1" in row 1
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_A2F1^barmex"
And I set field "artikel" to "BG03_CHARGE"
And I press start
Then the table has 0 rows
And I close the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_A2F1^barmex"
And I set field "artikel" to "EK01_CHARGE"
And I press start
Then table has values
    | zmge | amge     | tvcharge    | vcharge^id     | vplatz    | tncharge  | ncharge^id    |
    |      | 3        | C1A2F1AB1   | !C1A2F1AB1^id  | F1        | C2A2F1ZU2 | !C2A2F1ZU2^id |
    |      | 1        | C2A2F1AB2   | !C2A2F1AB2^id  | F1        | C2A2F1ZU2 | !C2A2F1ZU2^id |
And I close the current editor


Scenario: A2F2 Zugangs- und AbgangsMZ in der Fertigung - Retrograd - Baugruppe mit 3 AG, Zugangscharge im Vorgang passt NICHT zur AbgangsMZ

Given I create a work order "A2F2" for Product "BG03_CHARGE" with quantity "10" and search word "A2F2_"

Given I create a Lot "C1A2F2ZU1" for Product "BG03_CHARGE"
Given I create a Lot "C2A2F2ZU2" for Product "BG03_CHARGE"
Given I create a Lot "C3A2F2ZU3" for Product "BG03_CHARGE"

Given I create a Lot "C1A2F2AB1" for Product "EK01_CHARGE"
Given I create a Lot "C2A2F2AB2" for Product "EK01_CHARGE"

Given I create a Lot "C3A2F2AB1" for Product "EK02_CHARGE"
Given I create a Lot "C4A2F2AB2" for Product "EK02_CHARGE"

Given I open an editor "BA_A2F2" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "A2F2_000"
And I press button "mzsubm" to open a subeditor for "ZugangsMZ"
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 5        | C1A2F2ZU1 |
And I save the current editor
And I switch the current editor to editor "BA_A2F2"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "resetmanbu"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   | zcharge   |
    | +1    | F1     | 3        | C1A2F2AB1 | C2A2F2ZU2 |
    | +2    | F1     | 2        | C2A2F2AB2 |           |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   | zcharge   |
    | +1    | F1     | 3        | C3A2F2AB1 | C2A2F2ZU2 |
    | +2    | F1     | 2        | C4A2F2AB2 |           |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_A2F2"
And I save the current editor

Given I open an editor "RM1_A2F2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "A2F2_001"
And I set fields
    | sofort    | ja            |
    | kcharge   | C3A2F2ZU3     |
    | bem       | RM1_A2F2      |
And I set field "gutmge" to "4" in row 1
And I set field "erbtext1" to "RM1_A2F2" in row 1
And I save the current editor

# auf den AG wurden 4 Stk rueckgemeldet, Material wurde nur fuer 2 Stk abgebucht, limge nur um 2 Stk reduziert auf 8
Given I open an editor "BA_A2F2_PRUEF" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "A2F2_000"
And I press button "absteig" to open a subeditor for "AFL"
Then field "limge" has value "8" in row 1
Then field "limge" has value "6" in row 2
And I close the current editor
And I switch the current editor to editor "BA_A2F2_PRUEF"
And I close the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_A2F2^barmex"
And I set field "artikel" to "BG03_CHARGE"
And I press start
Then the table has 0 rows
And I close the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_A2F2^barmex"
And I set field "artikel" to "EK01_CHARGE"
And I press start
Then table has values
    | zmge | amge     | tvcharge    | vcharge^id     | vplatz    | tncharge  | ncharge^id    |
    |      | 2        | C2A2F2AB2   | !C2A2F2AB2^id  | F1        | C3A2F2ZU3 | !C3A2F2ZU3^id |
And I close the current editor

Scenario: A2F3 Zugangs- und AbgangsMZ in der Fertigung - Retrograd - Baugruppe mit 3 AG, OHNE Zugangscharge im Vorgang

Given I create a work order "A2F3" for Product "BG03_CHARGE" with quantity "10" and search word "A2F3_"

Given I create a Lot "C1A2F3ZU1" for Product "BG03_CHARGE"
Given I create a Lot "C2A2F3ZU2" for Product "BG03_CHARGE"

Given I create a Lot "C1A2F3AB1" for Product "EK01_CHARGE"
Given I create a Lot "C2A2F3AB2" for Product "EK01_CHARGE"

Given I create a Lot "C3A2F3AB1" for Product "EK02_CHARGE"
Given I create a Lot "C4A2F3AB2" for Product "EK02_CHARGE"

Given I open an editor "BA_A2F3" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "A2F3_000"
And I press button "mzsubm" to open a subeditor for "ZugangsMZ"
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 5        | C1A2F3ZU1 |
And I save the current editor
And I switch the current editor to editor "BA_A2F3"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "resetmanbu"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   | zcharge   |
    | +1    | F1     | 3        | C1A2F3AB1 | C2A2F3ZU2 |
    | +2    | F1     | 2        | C2A2F3AB2 |           |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   | zcharge   |
    | +1    | F1     | 3        | C3A2F3AB1 | C2A2F3ZU2 |
    | +2    | F1     | 2        | C4A2F3AB2 |           |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_A2F3"
And I save the current editor

Given I open an editor "RM1_A2F3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "A2F3_001"
And I set fields
    | sofort    | ja            |
    | bem       | RM1_A2F3      |
And I set field "gutmge" to "4" in row 1
And I set field "erbtext1" to "RM1_A2F3" in row 1
And I save the current editor

# auf den AG wurden 4 Stk rueckgemeldet, Material wurde fuer 4 Stk abgebucht, KEINE Zugangsbuchung deshalb Zugangscharge NICHT aus ZugangsMZ
Given I open an editor "BA_A2F3_PRUEF" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "A2F3_000"
And I press button "absteig" to open a subeditor for "AFL"
Then field "limge" has value "6" in row 1
Then field "limge" has value "6" in row 2
And I close the current editor
And I switch the current editor to editor "BA_A2F3_PRUEF"
And I close the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_A2F3^barmex"
And I set field "artikel" to "BG03_CHARGE"
And I press start
Then the table has 0 rows
And I close the current editor

# KEINE Zugangsbuchung deshalb Zugangscharge NICHT aus ZugangsMZ, AbgangsMZ mit Zugangscharge, dann AbgangsMZ nur mit Abgangscharge (Joker)
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_A2F3^barmex"
And I set field "artikel" to "EK01_CHARGE"
And I press start
Then table has values
    | zmge | amge     | tvcharge    | vcharge^id     | vplatz    | tncharge  | ncharge^id    |
    |      | 3        | C1A2F3AB1   | !C1A2F3AB1^id  | F1        | C2A2F3ZU2 | !C2A2F3ZU2^id |
    |      | 1        | C2A2F3AB2   | !C2A2F3AB2^id  | F1        |           | (0,0,0)       |
And I close the current editor


Scenario: A3F1 Zugangs- und AbgangsMZ in der Fertigung - Manbu - Baugruppe mit 3 AG, Zugangscharge in FBU, AbgangsMZ nur Teilmengen

Given I create a work order "A3F1" for Product "BG03_CHARGE" with quantity "10" and search word "A3F1_"

Given I create a Lot "C1A3F1ZU1" for Product "BG03_CHARGE"
Given I create a Lot "C2A3F1ZU2" for Product "BG03_CHARGE"

Given I create a Lot "C1A3F1AB1" for Product "EK01_CHARGE"
Given I create a Lot "C2A3F1AB2" for Product "EK01_CHARGE"

Given I create a Lot "C3A3F1AB1" for Product "EK02_CHARGE"
Given I create a Lot "C4A3F1AB2" for Product "EK02_CHARGE"

Given I open an editor "BA_A3F1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "A3F1_000"
And I press button "mzsubm" to open a subeditor for "ZugangsMZ"
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 5        | C1A3F1ZU1 |
And I save the current editor
And I switch the current editor to editor "BA_A3F1"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 3        | C1A3F1AB1 |
    | +2    | F1     | 2        | C2A3F1AB2 |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 3        | C3A3F1AB1 |
    | +2    | F1     | 2        | C4A3F1AB2 |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_A3F1"
And I save the current editor

# Angabe der Zugangscharge im Kopf der FBU, Abgangscharge wird aus der AbgangsMZ geholt, der Reihe nach
Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag     | A3F1_001        |
    | charge      | C1A3F1ZU1       |
    | bem         | Entnahme_A3F1   |
And I press button "stllad"
And I set field "bumge" to "4" in row 1
And I save the current editor

Given I open an editor "FBUBELEG" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=A3F1_001;bem=Entnahme_A3F1;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "barmex" in row 0
And I close the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" in row 0 to saved value
And I set field "artikel" to "BG03_CHARGE"
And I press start
Then the table has 0 rows
And I close the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" in row 0 to saved value
And I set field "artikel" to "EK01_CHARGE"
And I press start
Then table has values
    | zmge | amge     | tvcharge    | vcharge^id     | vplatz    | tncharge  | ncharge^id    |
    |      | 3        | C1A3F1AB1   | !C1A3F1AB1^id  | F1        | C1A3F1ZU1 | !C1A3F1ZU1^id |
    |      | 1        | C2A3F1AB2   | !C2A3F1AB2^id  | F1        | C1A3F1ZU1 | !C1A3F1ZU1^id |
And I close the current editor

# Angabe der Zugangscharge im Kopf der FBU, Abgangscharge wird aus der AbgangsMZ geholt, wenn verbraucht, dann Abgangscharge eintragen
Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag     | A3F1_001        |
    | charge      | C2A3F1ZU2       |
    | bem         | Entnahme2_A3F1  |
And I press button "stllad"
And I set field "bumge" to "3" in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
Then field "tcharge" has value "C2A3F1AB2" in row 1
And I modify table
    | !row  | zuomge    | tcharge   |
    | +2    | 2         | C1A3F1AB1 |
And I set field "mzueb" to "ja"
And I save the current editor
And I switch the current editor to editor "MATENT1"
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" in row 0 to saved value
And I set field "artikel" to "EK01_CHARGE"
And I set field "richtung" to "rückwärts"
And I press start
Then table has values
    | zmge | amge     | tvcharge    | vcharge^id     | tncharge  | ncharge^id    |
    |      | 2        | C1A3F1AB1   | !C1A3F1AB1^id  | C2A3F1ZU2 | !C2A3F1ZU2^id |
    |      | 1        | C2A3F1AB2   | !C2A3F1AB2^id  | C2A3F1ZU2 | !C2A3F1ZU2^id |
And I close the current editor
