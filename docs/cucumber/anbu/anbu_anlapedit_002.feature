# *****************************************************************************
#  Name             : anbu_anlapedit_0002.feature
#  Autor            : Jan Effler
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Cucumberscript zum Test ref_anlapedit2
#
# *****************************************************************************
# Fehlerhafte Abschreibungsvorschläge
# -----------------------------------

@persistent

Feature: anlapedit
Scenario: anlapedit2

Given I open an editor "abvor" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""

And I create a new row at the end of the table
And I create a new row at the end of the table
And I create a new row at the end of the table
And I create a new row at the end of the table
And I create a new row at the end of the table

Then the table has 5 rows

# 8131 : Ungültiger Monat
Then setting field "bmon" to "" throws the exception "8131"

Then the table has 5 rows

And I set field "bmon" to "6"

Then the table has 0 rows

And I press button "afaerm"

Then the table has 22 rows

And I set field "nzeigok" to "ja"
And I set field "nzeigwarn" to "ja"

Then the table has 1 rows
Then field "tafaftxt" is not empty in row 1

And I close the current editor

# ###############################################

Given I open an editor "abvor-1" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""

And I set field "bmon" to "12"

Then the table has 0 rows

And I create a new row at the end of the table
And I set field "buanlage" to "50000" in row 1
And I set field "bukto" to "62200" in row 1
And I set field "gbukto" to "04200" in row 1
And I set field "kst" to "100" in row 1
And I set field "betrag" to "350.88" in row 1
And I set field "buchen" to "ja" in row 1

And I create a new row at the end of the table
And I set field "buanlage" to "50010" in row 2
And I set field "bukto" to "62200" in row 2
Then setting field "gbukto" to "05200" in row 2 throws the exception "1361"
And I set field "kst" to "100" in row 2
And I set field "betrag" to "200.00" in row 2

Then field "buchen" is not modifiable in row 2

# Then setting field "buchen" to "ja" in row 2 throws the exception "203"

And I create a new row at the end of the table
And I set field "buanlage" to "50020" in row 3
And I set field "bukto" to "62200" in row 3
And I set field "gbukto" to "04200" in row 3
And I set field "kst" to "100" in row 3
# 4405 : Buchungsbetrag nicht erlaubt!
Then setting field "betrag" to "800000.00" in row 3 throws the exception "4405"

Then field "buchen" is not modifiable in row 3

# Then setting field "buchen" to "ja" in row 3 throws the exception "6640"

And I create a new row at the end of the table
And I set field "buanlage" to "50040" in row 4
And I set field "bukto" to "62200" in row 4
And I set field "gbukto" to "04200" in row 4
And I set field "kst" to "100" in row 4
And I set field "betrag" to "-50000" in row 4
And I set field "buchen" to "ja" in row 4

And I create a new row at the end of the table
And I set field "buanlage" to "50050" in row 5
And I set field "bukto" to "62200" in row 5
# 4404 : Buchungskonto kein gültiges Konto für verwendete Anlage!
Then setting field "gbukto" to "06500" in row 5 throws the exception "4404"
And I set field "kst" to "100" in row 5
And I set field "betrag" to "10526.32" in row 5

Then field "buchen" is not modifiable in row 5

# Then setting field "buchen" to "ja" in row 5 throws the exception "6640"

And I create a new row at the end of the table
And I set field "buanlage" to "60000" in row 6
And I set field "bukto" to "62200" in row 6
# 4404 : Buchungskonto kein gültiges Konto für verwendete Anlage!
Then setting field "gbukto" to "05200" in row 6 throws the exception "4404"
And I set field "betrag" to "10000" in row 6

Then field "buchen" is not modifiable in row 6

# Then setting field "buchen" to "ja" in row 6 throws the exception "6640"

And I create a new row at the end of the table
And I set field "buanlage" to "100004" in row 7
And I set field "bukto" to "62200" in row 7
# 4404 : Buchungskonto kein gültiges Konto für verwendete Anlage!
Then setting field "gbukto" to "06500" in row 7 throws the exception "4404"
And I set field "kst" to "100" in row 7
# 4405 : Buchungsbetrag nicht erlaubt!
Then setting field "betrag" to "-9000" in row 7 throws the exception "4405"

Then field "buchen" is not modifiable in row 7

# Then setting field "buchen" to "ja" in row 7 throws the exception "6640"

And I create a new row at the end of the table
And I set field "buanlage" to "100007" in row 8
And I set field "bukto" to "62200" in row 8
And I set field "gbukto" to "05200" in row 8
And I set field "kst" to "100" in row 8
And I set field "betrag" to "62.43" in row 8
And I set field "buchen" to "ja" in row 8

And I create a new row at the end of the table
And I set field "buanlage" to "100009" in row 9
And I set field "bukto" to "62200" in row 9
And I set field "gbukto" to "06500" in row 9
And I set field "kst" to "100" in row 9
And I set field "betrag" to "12.22" in row 9

# And I respond with answer "ja" to the dialog with id "4477"
# Then saving the current editor throws the exception "76"
And I close the current editor








# **************************************************
# Stornierung von Buchungen
# **************************************************

Given I open an editor "buch-32" from table "(Entry):(Entry)" with command "NEW" for record "32"
And I press button "storno"
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor


