# *****************************************************************************
#  Name             : steuer_vrgstrgl_laenderabhaengig_007_zeilenreihenfolge.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Test der Reihenfolge der Zeilen in Steuer-KONFIG
#                     siehe REWE-3854
#
#
# *****************************************************************************
@persistent
Feature:  steuer_vrgstrgl_laenderabhaengig_007_zeilenreihenfolge.feature
Background: XXX


Scenario: Verkauf 1

# hier kommen 2 Zeilen aus KONFIG in Frage:
#	| zn | ev      | rechnlaart | bestlaart | bestland | rechnustid                 | bestustid                  | standard | vrgstrgl    | namebspr                     |
#	| 10 | Verkauf | Inland     | EU-Staat  |          | vorhanden und aus EU-Staat | irrelevant                 | ja       | VKIN        | Zeilenreinhenfolge; REWE-3854|
#	|  4 | Verkauf | Inland     | EU-Staat  |          | irrelevant                 | vorhanden und aus EU-Staat | ja       | VKEUFREIUST | VRGSTRGL aus der Zeile 4 - vorne; REWE-3854|
#
# die Suche findet die Zeile 4 - korrekt!

Given I open an editor "rechnung1-1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "11zeilen"
And I set field "vom" to "."
And I set field "kunde" to "001"
And I set field "warenempf" to "004"
#
Then field "vrgstrgl" has value "VKIN"
# Rechnungsempfaenger
Then field "rechnland" has value "DEUTSCHLAND"
Then field "rechnlaart" has value "Inland"
Then field "rechnustid" is empty in row 0
# Warenempfaenger
Then field "vstaat" has value "FRANKREICH"
Then field "laarta" has value "EU-Staat"
Then field "versustid" is empty in row 0
#
And I set field "versustid" to "FR1234567"
Then field "vrgstrgl" has value "VKEUFREIUST"

#
And I close the current editor

Scenario: Einkauf 1

# hier kommen 2 Zeilen aus KONFIG in Frage:
#	| zn | ev      | rechnlaart | bestlaart | bestland | rechnustid                 | bestustid                  | standard | vrgstrgl    | namebspr                     |
#	| 24 | Einkauf | Inland     | EU-Staat  |          | vorhanden und aus EU-Staat | irrelevant                 | ja       | EKIN        | Zeilenreinhenfolge; REWE-3854|
#	| 42 | Einkauf | Inland     | EU-Staat  |          | irrelevant                 | vorhanden und aus EU-Staat | ja       | EKEUFREIUST | Einkauf; REWE-3854           |
#
# die Suche findet die Zeile 24. Zeile 24 ist richtig.


Given I open an editor "rechnung1-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "11zeilen"
And I set field "vom" to "."
And I set field "lief" to "004"
And I set field "kl2" to "001"
#
Then field "vrgstrgl" has value "EKIN"
# Rechnungsempfaenger
Then field "rechnland" has value "DEUTSCHLAND"
Then field "rechnlaart" has value "Inland"
Then field "rechnustid" is empty in row 0
# Warenempfaenger
Then field "vstaat" has value "FRANKREICH"
Then field "laarta" has value "EU-Staat"
Then field "versustid" is empty in row 0
#
And I set field "versustid" to "FR1234567"
#
Then field "vrgstrgl" has value "EKIN"
# es wird nicht gepeichert
And I close the current editor
