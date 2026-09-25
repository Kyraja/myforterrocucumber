@persistant
Feature: Booking of Invoices setting ljtext1
Background:
Given I set the fake date to "02.01.2003"
#
# Einkaufs Rechnung anlegen und verbuchen
#
Scenario: Purchasing 
	Given I open an editor "rechnung-012" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
	And I set field "lief" to "003"
	And I set field "num4" to "001-RE"
	And I set field "fakt" to "ja"
	And I set field "ueb" to "nein"
    And I set field "rechnustid" to "FR123"
	And I set field "vom" to "31.1.2002"
	And I set field "budat" to "31.1.2002"
	And I set field "ueb" to "ja"
	And I create a new row at the end of the table
	And I set field "artex" to "E1" in row 1
	And I set field "mge" to "012" in row 1
	And I set field "preis" to "012" in row 1
    And I set field "intrarel" to "nein" in row 1
	And I set field "kstelle" to "100" in row 1
    And I set field "ljtext1" to "Test ljtext1" in row 1
	And I respond with answer "Ja" to the dialog with id "4841"
	And I save the current editor
#
# Verkaufsrechnung anlegen und verbuchen
#
Scenario: Sales
	Given I open an editor "rechnung-012" from table "(Sales):(Invoice)" with command "NEW" for record ""
	And I set field "kunde" to "004"
	And I set field "fakt" to "ja"
	And I set field "ueb" to "nein"
    And I set field "rechnustid" to "FR123"
	And I set field "vom" to "31.1.2002"
	And I set field "budat" to "31.1.2002"
	And I set field "ueb" to "ja"
	And I create a new row at the end of the table
	And I set field "artex" to "V1" in row 1
	And I set field "mge" to "012" in row 1
	And I set field "preis" to "012" in row 1
    And I set field "intrarel" to "nein" in row 1
	And I set field "kstelle" to "100" in row 1
    And I set field "ljtext1" to "Test ljtext1" in row 1
	And I respond with answer "Ja" to the dialog with id "4841"
	And I save the current editor
