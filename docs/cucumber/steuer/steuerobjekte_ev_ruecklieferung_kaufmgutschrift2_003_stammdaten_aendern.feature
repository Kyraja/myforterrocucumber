# *****************************************************************************
#  Name             : steuerobjekte_ev_ruecklieferung_kaufmgutschrift2_003_stammdaten_aendern.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : 
#
#
#
# *****************************************************************************

@persistent
Feature: steuerobjekte_ev_ruecklieferung_kaufmgutschrift2_003_stammdaten_aendern.feature
Background: steuerliche Objekten in EK/VK


#####################################################################################################################################
#
#                                     Hier nur Einkauf; Verkauf siehe unten
#
#
#####################################################################################################################################

Scenario: 1. Ersatz fuer STRL 6000


Given  I open an editor "strgl_6000" from table "(TaxCode):(TaxRule)" with command "COPY" for record "6000"
And I set field "nummer" to "6andere"
And I set field "such" to "ANDERE"
And I set field "namebspr" to "Fast Kopie von 6000"
And I set field "ekstustpos" to "62" in row 1
And I save the current editor
And I close the current editor

Given  I open an editor "ktstrgl_7004" from table "(TaxCode):(AccountTaxRule)" with command "UPDATE" for record "7004"
Then the table has 8 rows
And I create a new row at position 1
Then the table has 9 rows
And I set field "vrgstrgl" to "EKIN" in row 1
And I set field "strgl" to "6andere" in row 1
And I save the current editor
And I close the current editor
#####################################################################################################################################


Scenario: 2. Ersatz fuer STRL 6005

Given  I open an editor "strgl_6005" from table "(TaxCode):(TaxRule)" with command "COPY" for record "6005"
And I set field "nummer" to "7andere"
And I set field "such" to "KOPIE"
And I set field "namebspr" to "Fast Kopie von 6005"
And I set field "ekstustpos" to "62" in row 1
And I save the current editor
And I close the current editor

Given  I open an editor "ktstrgl_7008" from table "(TaxCode):(AccountTaxRule)" with command "UPDATE" for record "7008"
Then the table has 1 rows
And I create a new row at position 1
Then the table has 2 rows
And I set field "vrgstrgl" to "EKAUSFREI" in row 1
And I set field "strgl" to "7andere" in row 1
And I save the current editor
And I close the current editor
#####################################################################################################################################


#####################################################################################################################################
#
#                                     Ab hier nur Verkauf
#
#
#####################################################################################################################################


Scenario: 3. Ersatz fuer STRL 5000

Given  I open an editor "strgl_5000" from table "(TaxCode):(TaxRule)" with command "COPY" for record "5000"
And I set field "nummer" to "8andere"
And I set field "such" to "KOPIE8"
And I set field "namebspr" to "Fast Kopie von 5000"
And I set field "vkstustpos" to "550" in row 1
And I set field "sktoustpos" to "87" in row 1
And I set field "ktoustpos" to "87" in row 1
And I save the current editor
And I close the current editor

Given  I open an editor "ktstrgl_7000" from table "(TaxCode):(AccountTaxRule)" with command "UPDATE" for record "7000"
Then the table has 2 rows
And I create a new row at position 1
Then the table has 3 rows
And I set field "vrgstrgl" to "VKIN" in row 1
And I set field "strgl" to "8andere" in row 1
And I save the current editor
And I close the current editor
#####################################################################################################################################

