# *****************************************************************************
#  Name           : ruecklieferung_plausi.feature
#  Autor          : as
#  Verantwortlich : teampss
#  Funktion       : Test fuer Plausibilitaetspruefungen bei Ruecklieferungen
#
# *****************************************************************************

@persistent
Feature: Test fuer Plausibilitaetspruefungen bei Ruecklieferungen
Background:
Given I set the fake date to "02.01.1995"

Scenario: Ruecklieferung Teil A100 ohne Materialflussinformationen

Given I open an editor "1LS100R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS100"
And I set fields
   | num4 | 1LS100R |
   | vom  | .       |
   | ueb  | ja      |
And I set field "mge" to "-50" in row 1
And I set field "platz" to "F100" in row 1
Then saving the current editor throws the exception "2066"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then pressing button "burueckmzerg" throws the exception "2066"
Then the table has 0 rows
And I delete all rows
And I append rows
    | lpsuch | zuomge | einh  |
    | F100   | -50    | Stück |
Then pressing button "burueckmzzuord" throws the exception "2066"
Then field "ljorig" has value "(0,0,0)" in row 1
And I close the current editor
And I switch the current editor to editor "1LS100R"
And I close the current editor

Scenario: Ruecklieferung Teil A200 mit teilweise vorhandener Materialflussinformationen

Given I open an editor "1LS200R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS200"
And I set fields
   | num4 | 1LS200R |
   | vom  | .       |
   | ueb  | ja      |
And I set field "mge" to "-150" in row 1
And I set field "platz" to "F200" in row 1
Then saving the current editor throws the exception "692"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I press button "burueckmzerg"
Then field "restmge" has value "-200" in row 1
Then field "restmgeplatz" has value "-140" in row 1
Then field "restmgeplatz" has value "-60" in row 2
And I delete all rows
And I append rows
    | lpsuch | zuomge | einh  |
    | F200   | -150   | Stück |
    | F210   | -50    | Stück |
Then pressing button "burueckmzzuord" throws the exception "2036"
Then field "ljorig" has value "(0,0,0)" in row 1
And I set field "zuomge" to "-140" in row 1
And I set field "zuomge" to "-60" in row 2
And I press button "burueckmzzuord"
And I save the current editor
And I switch the current editor to editor "1LS200R"
And I save the current editor

Given I open an editor "1LS200RS" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+1LS200R"
And I set field "num4" to "1LS200RS"
And I save the current editor

Given I open an editor "2LS200R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS200"
And I set fields
   | num4 | 2LS200R |
   | vom  | .       |
   | ueb  | ja      |
And I set field "mge" to "-150" in row 1
And I set field "platz" to "F200" in row 1
Then saving the current editor throws the exception "692"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I press button "burueckmzerg"
Then field "restmge" has value "-200" in row 1
Then field "restmgeplatz" has value "-140" in row 1
Then field "restmgeplatz" has value "-60" in row 2
And I set field "zuomge" to "-70" in row 1
And I set field "zuomge" to "-30" in row 2
And I save the current editor
And I switch the current editor to editor "2LS200R"
And I save the current editor

Given I open an editor "2LS200RS" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+2LS200R"
And I set field "num4" to "2LS200RS"
And I save the current editor

Given I open an editor "3LS200R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS200"
And I set fields
   | num4 | 3LS200R |
   | vom  | .       |
   | ueb  | ja      |
And I set field "mge" to "-150" in row 1
And I set field "platz" to "F200" in row 1
Then saving the current editor throws the exception "692"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I press button "burueckmzerg"
Then field "restmge" has value "-200" in row 1
Then field "restmgeplatz" has value "-140" in row 1
Then field "restmgeplatz" has value "-60" in row 2
And I set field "zuomge" to "-140" in row 1
And I set field "zuomge" to "-60" in row 2
And I save the current editor
And I switch the current editor to editor "3LS200R"
And I save the current editor

Scenario: Stornierung eines Lieferscheins, der bereits in einer Altversion zurückgeliefert wurde.

Given opening an editor from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "1LS300" throws the exception "2224"

Scenario: Gutschrift zu einer Ruecklieferung aus einer Altversion

Given I open an editor "1RE400" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "1LS400"
And I set field "num4" to "1RE400"
And I set field "ueb" to "ja"
And I set field "vom" to "."
Then setting field "mge" to "300" in row 1 throws the exception "2024"
Then setting field "mge" to "-500" in row 1 throws the exception "2022"
And I set field "mge" to "0" in row 1
And I set field "mge" to "-300" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: Ruecklieferung Teil A500, zu dem es in einer Altversion einen Abgang in Form eines negativen Zugangs gab.

Given I open an editor "1LS500R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS500"
And I set fields
   | num4 | 1LS500R |
   | vom  | .       |
And I set field "mge" to "-10" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I press button "burueckmzerg"
Then the table has 1 rows
Then field "restmge" has value "-10" in row 1
And I close the current editor
And I switch the current editor to editor "1LS500R"
And I close the current editor

Scenario: Ruecklieferung Teil A600, das in einer Altversion schon zurueckgeliefert wurde

Given I open an editor "1LS600R" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS600"
And I set fields
   | num3 | 1LS600R |
   | vom  | .       |
   | ueb  | ja      |
And I set field "mge" to "-3" in row 1
Then saving the current editor throws the exception "692"
And I set field "mge" to "-2" in row 1
And I save the current editor
