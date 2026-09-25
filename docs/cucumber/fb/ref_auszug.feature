@persistant
Feature: Test_AUSZUG
Background:

Given I'm logged in with password "annette"
Given I set the fake date to "31.12.98"
#
# ---------------------------
# Termine anpassen
# ---------------------------
Scenario: set_financial_dates
Given I open an editor "finDate1" from table "(Company):(FinancialDates)" with command "UPDATE" for record "TERM" 
And I press button "bsperremand"
# das "platte" new row braucht wartungsrechte  
And I create a new row at the end of the table
And I create a new row at the end of the table
And I set field "gjanf" to "1.1.99" in row 6
And I set field "gjend" to "31.12.99" in row 6
And I set field "gjanf" to "01.01.00" in row 7
And I set field "gjend" to "31.12.00" in row 7
And I set field "jaab" to "31.12.98" 
And I set field "erend" to "31.12.98" 
And I save the current editor
And I close the current editor
#
#
Given I set the fake date to "29.04.99"
Given I'm logged in with password "sy"
# ------------
Scenario: do_entry1
# Buchung 1
Given I open an editor "Buchung-1" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
	| budat  | 27.04.99  |
	| beldat | 27.04.99  |
	| beleg  | bu1       |
And I append rows
	| konto | sbetrag     | hbetrag     |
	| L 1   | 1000.00     | !dontChange |
	| L 1   | !dontChange | 1000.00     |
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
# ------------
Scenario: do_entry2
# Buchung 2
Given I open an editor "Buchung-2" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
	| budat  | 27.04.99  |
	| beldat | 27.04.99  |
	| beleg  | bu2       |
And I append rows
	| konto | sbetrag     | hbetrag     |
	| L 1   | -1000.00    | !dontChange |
	| L 1   | !dontChange | -1000.00    |
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
# ------------
Scenario: do_entry3
# Buchung 3
Given I open an editor "Buchung-3" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
	| budat  | 27.04.99  |
	| beldat | 27.04.99  |
	| beleg  | bu3       |
And I append rows
	| konto | sbetrag     | hbetrag     |
	| L 1   | 1000.00     | !dontChange |
	| L 1   | !dontChange | 100.00      |
	| 54000 | !dontChange | 775.86      |
	| 14050 | !dontChange | 124.14      |
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
# ------------
# Buchung 4
Scenario: do_entry4
Given I open an editor "Buchung-4" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
	| budat  | 27.04.99  |
	| beldat | 27.04.99  |
	| beleg  | bu4       |
And I append rows
	| konto       | sbetrag     | hbetrag     |
	| L 1         | 99700.00    | !dontChange |
	| 18100       | !dontChange | 99700.00    |
	| 57300       | 300.00      | !dontChange |
	| 18100       | !dontChange | 300.00      |
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
# ------------
# Buchung 5
Given I open an editor "Buchung-5" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
	| budat  | 27.04.99  |
	| beldat | 27.04.99  |
	| beleg  | bu5       |
And I append rows
	| konto       | sbetrag     | hbetrag     |
	| L 1         | 97000.00    | !dontChange |
	| L 1         | 1000.00     | !dontChange |
	| 18100       | !dontChange | 98000.00    |
	| 57300       | 400.00      | !dontChange |
	| 18100       | !dontChange | 400.00      |
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
# ---------TSTAUSZUG.DAT---
# Buchung 6
Given I open an editor "Buchung-6" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
	| budat  | 27.04.99  |
	| beldat | 27.04.99  |
	| beleg  | bu6       |
And I append rows
	| konto       | sbetrag     | hbetrag     |
	| L 1         | 97000.00    | !dontChange |
	| L 1         | 1000.00     | !dontChange |
	| L 1         | !dontChange | 9000.00     |
	| 18100       | !dontChange | 89000.00    |
	| 57300       | 300.00      | !dontChange |
	| 18100       | !dontChange | 300.00      |

And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
# ------------
# Buchung 7
Given I open an editor "Buchung-7" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
	| budat  | 27.04.99  |
	| beldat | 27.04.99  |
	| beleg  | bu7       |
And I append rows
	| konto       | sbetrag     | hbetrag     |
	| L 1         | -5000.00    | !dontChange |
	| L 1         | -300.00     | !dontChange |
	| 18100       | !dontChange | -5300.00    |
	| 57300       | -60.00      | !dontChange |
	| 18100       | !dontChange | -60.00      |

And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
# ------------
# Buchung 8
Given I open an editor "Buchung-8" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
	| budat  | 27.04.99  |
	| beldat | 27.04.99  |
	| beleg  | bu8       |
And I append rows
	| konto       | sbetrag     | hbetrag     |
	| L 1         | -8000.00    | !dontChange |
	| L 1         | -100.00     | !dontChange |
	| L 1         | !dontChange | -300.00     |
	| 18100       | !dontChange | -7800.00    |
	| 57300       | -300.00     | !dontChange |
	| 18100       | !dontChange | -300.00     |  

And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
# ------------
# Buchung 9
Given I open an editor "Buchung-9" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
	| budat  | 27.04.99  |
	| beldat | 27.04.99  |
	| beleg  | bu9       |
And I append rows
	| konto       | hbetrag     | sbetrag     |
	| L 1         | -97000.00   | !dontChange |
	| L 1         | -10000.00   | !dontChange |
	| L 1         | !dontChange | -9000.00    |
	| 18100       | !dontChange | -98000.00   |
	| 57300       | !dontChange | -300.00     |
	| 18100       | -300.00     | !dontChange |  
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
# ------------
# Buchung 10
Given I open an editor "Buchung-10" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
	| budat  | 27.04.99  |
	| beldat | 27.04.99  |
	| beleg  | bu10      |
And I append rows
	| konto       | hbetrag     | sbetrag     |
	| L 1         | 97000.00    | !dontChange |
	| L 1         | 10000.00    | !dontChange |
	| L 1         | !dontChange | 9000.00     |
	| 18100       | !dontChange | 98000.00    |
	| 57300       | 300.00      | !dontChange |
	| 18100       | !dontChange | 300.00      |  
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
# ------------
# Buchung 11
Given I open an editor "Buchung-11" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
	| budat  | 27.04.99  |
	| beldat | 27.04.99  |
	| beleg  | bu11      |
And I append rows
	| konto       | sbetrag     | hbetrag     |
	| L 1         | 97000.00    | !dontChange |
	| L 1         | 10000.00    | !dontChange |
	| L 1         | !dontChange | 9000.00     |
	| 18100       | !dontChange | 98000.00    |
	| 57300       | 300.00      | !dontChange |
	| 18100       | !dontChange | 300.00      |  
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
# ------------
# Buchung 12
Given I open an editor "Buchung-12" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
	| budat  | 27.04.99  |
	| beldat | 27.04.99  |
	| beleg  | bu12      |
And I append rows
	| konto       | hbetrag     | sbetrag      |
	| L 1         | -10000.00   | !dontChange |
	| L 1         | -8000.00    | !dontChange |
	| L 1         | !dontChange | -3000.00    |
	| 18100       | !dontChange | -15000.00   |
	| 57300       | -300.00     | !dontChange |
	| 18100       | !dontChange | -300.00     |  
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
# ------------
# Buchung 13
Given I open an editor "Buchung-13" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
	| budat  | 27.04.99  |
	| beldat | 27.04.99  |
	| beleg  | bu13      |
And I append rows
	| konto       | hbetrag     | sbetrag      |
	| L 1         | -97000.00   | !dontChange |
	| L 1         | -10000.00   | !dontChange |
	| L 1         | !dontChange | -9000.00    |
	| 18100       | !dontChange | -98000.00   |
	| 57300       | -300.00     | !dontChange |
	| 18100       | !dontChange | -300.00     |  
	| L 1         | 97000.00    | !dontChange |
	| L 1         | 10000.00    | !dontChange |
	| L 1         | !dontChange | 9000.00     |
	| 18100       | !dontChange | 98000.00    |
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
