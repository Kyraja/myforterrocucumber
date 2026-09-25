@persistent
Feature: Eigencharge.feature

Background:
And I set the fake date to "16.01.1995"

# **********************************************************************************
#  Name             : Eigencharge.feature
#  Autor            : bschiga
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Chargen-/Seriennummernverwaltung
#  ref              : ref_chargen_seriennr_cu
#
# **********************************************************************************

Scenario: EC01 eigcharge=ja beim Anlegen einer Charge fuer Koppelprodukt in der FBU, auch bei zusaetzlicher Zeile

Given I create a work order "V06" for Product "BG_CHARGE_KOPPEL" with quantity "20" and search word "V06_"

Given I open an editor "BA_V04" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "V06_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I save the current editor
And I switch the current editor to editor "BA_V04"
And I save the current editor

Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | V06_001       |
    | bem       | Entnahme      |
And I press button "stlvblad"
Then table has values
    | elex          | bumge | manbu | kompeig       |
    | EK01_CHARGE   | 20    | ja    |               |
    | KOPPELCHARGE  | 20    | ja    | Koppelprodukt |
And  I modify table
    | !row  | bumge  | tvcharge |
    | 1     | 1      | V06AB    |
    | 2     | 1      | V06ZU    |
And I append rows
    | elex          | bumge  | kompeig       | tvcharge     |
    | EK03_CHARGE   | 1      | Koppelprodukt | V06ZUSATZ_KO |
And I save the current editor

Given I open an editor "KOPPEL_V06" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=V06ZU;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | V06ZU |
    | eigcharge | ja    |
    | lief      |       |
And I close the current editor

Given I open an editor "V06ZUSATZ_KO" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=V06ZUSATZ_KO;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | V06ZUSATZ_KO  |
    | eigcharge | ja            |
    | lief      |               |
And I close the current editor


Scenario: EC02 Dummycharge, die in der Fertigung fuer Koppelprodukt verwendet wird, bekommt Eigencharge gesetzt

Given I open an editor "V07DUMMY1" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
    | such      | V07DUMMY1 |
    | exnum     | V07DUMMY1 |
Then field "eigcharge" has value "nein"
And I save the current editor

Given I open an editor "V07DUMMY2" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
    | such      | V07DUMMY2 |
    | exnum     | V07DUMMY2 |
Then field "eigcharge" has value "nein"
And I save the current editor

Given I open an editor "V07DUMMY3" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
    | such      | V07DUMMY3 |
    | exnum     | V07DUMMY3 |
Then field "eigcharge" has value "nein"
And I save the current editor

Given I create a work order "V07" for Product "BG_CHARGE_KOPPEL" with quantity "20" and search word "V07_"

Given I open an editor "BA_V07" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "V07_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 2
Then field "artikel" has value "KOPPELCHARGE"
And I create a new row at position 1
And I set field "zuomge" to "20" in row 1
And I set field "charge" to "!V07DUMMY1^id" in row 1
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_V07"
And I save the current editor

Then field "eigcharge" from editor "V07DUMMY1" in row 0 has value "ja"
Then field "artikel" from editor "V07DUMMY1" in row 0 has value "KOPPELCHARGE"

Given I open an editor "V07DUMMY1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=V07DUMMY1;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | V07DUMMY1 |
    | eigcharge | ja        |
    | lief      |           |
And I close the current editor

Given I open an editor "BA_V07" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "V07_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I save the current editor
And I switch the current editor to editor "BA_V07"
And I save the current editor

Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | V07_001       |
    | bem       | Entnahme      |
And I press button "stlvblad"
Then table has values
    | elex          | bumge | manbu | kompeig       |
    | EK01_CHARGE   | 20    | ja    |               |
    | KOPPELCHARGE  | 20    | ja    | Koppelprodukt |
And  I modify table
    | !row  | bumge  | tvcharge     | rescharge     |
    | 1     | 1      | V07AB        | !dontChange   |
    | 2     | 1      | !dontChange  | !V07DUMMY2^id |
And I append rows
    | elex          | bumge  | kompeig       | rescharge        |
    | EK03_CHARGE   | 1      | Koppelprodukt | !V07DUMMY3^id    |
And I save the current editor

Then field "eigcharge" from editor "V07DUMMY2" in row 0 has value "ja"
Then field "artikel" from editor "V07DUMMY2" in row 0 has value "KOPPELCHARGE"

Then field "eigcharge" from editor "V07DUMMY3" in row 0 has value "ja"
Then field "artikel" from editor "V07DUMMY3" in row 0 has value "EK03_CHARGE"


