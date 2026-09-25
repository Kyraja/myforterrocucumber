# *****************************************************************************
#  Name           : ev_buchungsvorschau_001.feature
#  Autor          : wane
#  Verantwortlich : wane
#  Kontrolle      :
#  Funktion       : Testet die Buchungsvorschau aus den EK-/VK-Rechnungen
#                   in gebuchtem und ungebuchtem Zustand in Abhaenging von
#                   Art der Verbuchung von Rundungsdifferenzen
#
#
# *****************************************************************************
@persistent
Feature: Buchungsvorschau aus VK Rechnung
Background:
Given I set the fake date to "02.01.1995"

Scenario: Rechnungen anlegen: je 1 verbuchten und nicht verbuchten aus EK und VK

Given I open an editor "vkre-offen" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "10offen"
And I set field "kunde" to "1"
And I set field "such" to "OFFEN"
And I set field "ueb" to "nein"
And I set field "tterm" to "."
And I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "1" in row 1
And I set field "preis" to "10" in row 1
And I create a new row at the end of the table
And I set field "artex" to "e3" in row 2
And I set field "mge" to "1" in row 2
And I set field "preis" to "20" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I open an editor "vkre-uebertragen" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "10fertig"
And I set field "kunde" to "001"
And I set field "such" to "FERTIG"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "1" in row 1
And I set field "preis" to "5" in row 1
And I create a new row at the end of the table
And I set field "artex" to "e2" in row 2
And I set field "mge" to "1" in row 2
And I set field "preis" to "15" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I open an editor "ekre-offen" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "such" to "OFFEN"
And I set field "nummer" to "10offen"
And I set field "ueb" to "nein"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "1" in row 1
And I set field "preis" to "22" in row 1
And I create a new row at the end of the table
And I set field "artex" to "e2" in row 2
And I set field "mge" to "1" in row 2
And I set field "preis" to "900" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I open an editor "ekre-uebertragen" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "10fertig"
And I set field "lief" to "1"
And I set field "such" to "FERTIG"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "1" in row 1
And I set field "preis" to "22" in row 1
And I create a new row at the end of the table
And I set field "artex" to "e2" in row 2
And I set field "mge" to "1" in row 2
And I set field "preis" to "900" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#####################################################################################################################################

Scenario: Art der Verbuchung von Rundungsdifferenzen "Rundungsdifferenzzeile"


Given I open an editor "standartkontierung" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "4"
And I set field "verbrdiff" to "Rundungsdifferenzzeile"
And I save the current editor
And I close the current editor


# verbuchte Rechnungen oeffnen und Buchungsvorschau aufrufen
#
Given I open an editor "vkrechnung1" from table "(Sales):(Invoice)" with command "VIEW" for record "+10fertig"
And I press button "buvo" to open a subeditor for "buchungsvorschau"
Then field "id" has value "(153,6,0)"
Then field "vrgstrgl" has value "VKINL"
Then field "ursache" has value "Verkauf"
Then field "ursacheref" is not empty
Then field "nummer" is not empty
Then the table has 3 rows
Then field "betrag" has value "23.00" in row 1
Then field "strgl" has value "VKINREGEL" in row 2
And I close the current editor
And I switch the current editor to editor "vkrechnung1"
And I close the current editor
#
Given I open an editor "ekrechnung1" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+10fertig"
And I press button "buvo" to open a subeditor for "buchungsvorschau"
Then field "id" has value "(154,6,0)"
Then field "ursache" has value "Einkauf"
Then field "ursacheref" is not empty
Then field "nummer" is not empty
Then the table has 3 rows
Then field "ewhbetr" has value "1060.30" in row 1
Then field "betrag" has value "922.00" in row 2
Then field "strgl" has value "EKINREGEL" in row 2
And I close the current editor
And I switch the current editor to editor "ekrechnung1"
And I close the current editor


# unverbuchte Rechnung oeffnen und Buchungsvorschau aufrufen
#
Given I open an editor "vkrechnung2" from table "(Sales):(Invoice)" with command "UPDATE" for record "10offen"
And I set field "strgl" to "" in row 1
And pressing button "buvo" in row 0 to open a subeditor throws the exception "Keine Steuerregel gefunden. Bitte prüfen."
And I set field "fixstrgl" to "" in row 1
And I press button "buvo" to open a subeditor for "buchungsvorschau"
Then field "beleg" has value "10offen"
Then field "id" has value "(0,0,0)"
Then field "nummer" is empty
Then the table has 3 rows
Then field "betrag" has value "34.50" in row 1
And I close the current editor
And I switch the current editor to editor "vkrechnung2"
And I close the current editor
#
Given I open an editor "ekrechnung2" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "10offen"
And I set field "strgl" to "" in row 1
And pressing button "buvo" in row 0 to open a subeditor throws the exception "Keine Steuerregel gefunden. Bitte prüfen."
And I set field "fixstrgl" to "" in row 1
And I press button "buvo" to open a subeditor for "buchungsvorschau"
Then field "beleg" has value "10offen"
Then field "id" has value "(0,0,0)"
Then field "nummer" is empty
Then the table has 3 rows
Then field "hbetrag" has value "1060.30" in row 1
Then field "betrag" has value "922.00" in row 2
Then field "strgl" has value "EKINREGEL" in row 2
And I close the current editor
And I switch the current editor to editor "ekrechnung2"
And I close the current editor
#####################################################################################################################################

Scenario: Art der Verbuchung von Rundungsdifferenzen "Rundungsdifferenz auf Bemessungsgrundlage addieren"


Given I open an editor "standartkontierung" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "4"
And I set field "verbrdiff" to "Rundungsdifferenz auf Bemessungsgrundlage addieren"
And I save the current editor
And I close the current editor


# verbuchte Rechnungen oeffnen und Buchungsvorschau aufrufen
#
Given I open an editor "vkrechnung1" from table "(Sales):(Invoice)" with command "VIEW" for record "+10fertig"
And I press button "buvo" to open a subeditor for "buchungsvorschau"
Then field "id" has value "(153,6,0)"
Then field "vrgstrgl" has value "VKINL"
Then field "ursache" has value "Verkauf"
Then field "ursacheref" is not empty
Then field "nummer" is not empty
Then the table has 3 rows
Then field "betrag" has value "23.00" in row 1
Then field "strgl" has value "VKINREGEL" in row 2
And I close the current editor
And I switch the current editor to editor "vkrechnung1"
And I close the current editor
#
Given I open an editor "ekrechnung1" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+10fertig"
And I press button "buvo" to open a subeditor for "buchungsvorschau"
Then field "id" has value "(154,6,0)"
Then field "ursache" has value "Einkauf"
Then field "ursacheref" is not empty
Then field "nummer" is not empty
Then the table has 3 rows
Then field "ewhbetr" has value "1060.30" in row 1
Then field "betrag" has value "922.00" in row 2
Then field "strgl" has value "EKINREGEL" in row 2
And I close the current editor
And I switch the current editor to editor "ekrechnung1"
And I close the current editor


# unverbuchte Rechnung oeffnen und Buchungsvorschau aufrufen
#
Given I open an editor "vkrechnung2" from table "(Sales):(Invoice)" with command "UPDATE" for record "10offen"
And I set field "strgl" to "" in row 1
And pressing button "buvo" in row 0 to open a subeditor throws the exception "Keine Steuerregel gefunden. Bitte prüfen."
And I set field "fixstrgl" to "" in row 1
And I press button "buvo" to open a subeditor for "buchungsvorschau"
Then field "beleg" has value "10offen"
Then field "id" has value "(0,0,0)"
Then field "nummer" is empty
Then the table has 3 rows
Then field "betrag" has value "34.50" in row 1
And I close the current editor
And I switch the current editor to editor "vkrechnung2"
And I close the current editor
#
Given I open an editor "ekrechnung2" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "10offen"
And I set field "strgl" to "" in row 1
And pressing button "buvo" in row 0 to open a subeditor throws the exception "Keine Steuerregel gefunden. Bitte prüfen."
And I set field "fixstrgl" to "" in row 1
And I press button "buvo" to open a subeditor for "buchungsvorschau"
Then field "beleg" has value "10offen"
Then field "id" has value "(0,0,0)"
Then field "nummer" is empty
Then the table has 3 rows
Then field "hbetrag" has value "1060.30" in row 1
Then field "betrag" has value "922.00" in row 2
Then field "strgl" has value "EKINREGEL" in row 2
And I close the current editor
And I switch the current editor to editor "ekrechnung2"
And I close the current editor
#####################################################################################################################################

Scenario: Art der Verbuchung von Rundungsdifferenzen "Rundungsdifferenz auf Steuerbetrag addieren"


Given I open an editor "standartkontierung" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "4"
And I set field "verbrdiff" to "Rundungsdifferenz auf Steuerbetrag addieren"
And I save the current editor
And I close the current editor


# verbuchte Rechnungen oeffnen und Buchungsvorschau aufrufen
#
Given I open an editor "vkrechnung1" from table "(Sales):(Invoice)" with command "VIEW" for record "+10fertig"
And I press button "buvo" to open a subeditor for "buchungsvorschau"
Then field "id" has value "(153,6,0)"
Then field "vrgstrgl" has value "VKINL"
Then field "ursache" has value "Verkauf"
Then field "ursacheref" is not empty
Then field "nummer" is not empty
Then the table has 3 rows
Then field "betrag" has value "23.00" in row 1
Then field "strgl" has value "VKINREGEL" in row 2
And I close the current editor
And I switch the current editor to editor "vkrechnung1"
And I close the current editor
#
Given I open an editor "ekrechnung1" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+10fertig"
And I press button "buvo" to open a subeditor for "buchungsvorschau"
Then field "id" has value "(154,6,0)"
Then field "ursache" has value "Einkauf"
Then field "ursacheref" is not empty
Then field "nummer" is not empty
Then the table has 3 rows
Then field "ewhbetr" has value "1060.30" in row 1
Then field "betrag" has value "922.00" in row 2
Then field "strgl" has value "EKINREGEL" in row 2
And I close the current editor
And I switch the current editor to editor "ekrechnung1"
And I close the current editor


# unverbuchte Rechnung oeffnen und Buchungsvorschau aufrufen
#
Given I open an editor "vkrechnung2" from table "(Sales):(Invoice)" with command "UPDATE" for record "10offen"
And I set field "strgl" to "" in row 1
And pressing button "buvo" in row 0 to open a subeditor throws the exception "Keine Steuerregel gefunden. Bitte prüfen."
And I set field "fixstrgl" to "" in row 1
And I press button "buvo" to open a subeditor for "buchungsvorschau"
Then field "beleg" has value "10offen"
Then field "id" has value "(0,0,0)"
Then field "nummer" is empty
Then the table has 3 rows
Then field "betrag" has value "34.50" in row 1
And I close the current editor
And I switch the current editor to editor "vkrechnung2"
And I close the current editor
#
Given I open an editor "ekrechnung2" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "10offen"
And I set field "strgl" to "" in row 1
And pressing button "buvo" in row 0 to open a subeditor throws the exception "Keine Steuerregel gefunden. Bitte prüfen."
And I set field "fixstrgl" to "" in row 1
And I press button "buvo" to open a subeditor for "buchungsvorschau"
Then field "beleg" has value "10offen"
Then field "id" has value "(0,0,0)"
Then field "nummer" is empty
Then the table has 3 rows
Then field "hbetrag" has value "1060.30" in row 1
Then field "betrag" has value "922.00" in row 2
Then field "strgl" has value "EKINREGEL" in row 2
And I close the current editor
And I switch the current editor to editor "ekrechnung2"
And I close the current editor
#####################################################################################################################################


