#  Autor            : gk
#  Verantwortlich   : uo
#  Kontrolle        :
#  Funktion         :

@persistant
Feature: Validation of general Fields
Background:
Given I set the fake date to "2.2.2002"

Scenario: validate_field_bukenn
    Given I open an editor "Buchung1" from table "(Entry):(Entry)" with command "NEW" for record ""
    And setting field "kenn" to "XY" throws the exception "1336"
    And I set field "kenn" to ""
    Then field "kenn" has value "DI"
    And I close the current editor
    
Scenario: validate_field_bubudat_sy
    Given I open an editor "Buchung2" from table "(Entry):(Entry)" with command "NEW" for record ""
    And setting field "budat" to "" throws the exception "316"
    And setting field "budat" to "1.1.99" throws the exception "1294"
    And setting field "budat" to "1.1.00" throws the exception "2202"
    And I close the current editor
    
Scenario: validate_field_bubudat_wartung    
    Given I'm logged in with password "annette"
    Given I open an editor "Buchung3" from table "(Entry):(Entry)" with command "UPDATE" for record "BBU01"
    And setting field "budat" to "1.1.99" throws the exception "106"
    And I set field "budat" to "1.1.00"
    And I close the current editor
    
Scenario: validate_field_bumonat_sy    
    Given I'm logged in with password "sy"
    Given I open an editor "Buchung4" from table "(Entry):(Entry)" with command "NEW" for record ""  
    And setting field "monat" to "-1" throws the exception "131"
    And setting field "monat" to "16" throws the exception "1361"
    And setting field "monat" to "1" throws the exception "1361"
    And I close the current editor
    Given I open an editor "Buchung5" from table "(Entry):(Entry)" with command "UPDATE" for record "BBU01"
    And setting field "monat" to "-1" throws the exception "131"
    And setting field "monat" to "16" throws the exception "1361"
    And setting field "monat" to "1" throws the exception "1361"
    And I close the current editor
    Given I open an editor "Buchung6" from table "(Entry):(Entry)" with command "COPY" for record "BBU01"
    And setting field "monat" to "4" throws the exception "5010"
    And I close the current editor    

Scenario: edit_field_bumonat_sy    
    Given I'm logged in with password "sy"
    Given I open an editor "Buchung5" from table "(Entry):(Entry)" with command "NEW" for record ""  
    And I set field "monat" to ""
    Then field "monat" has value "2"
    And I close the current editor  
    
Scenario: edit_field_bubeleg_sy    
    Given I'm logged in with password "sy"
    Given I open an editor "Buchung6" from table "(Entry):(Entry)" with command "NEW" for record ""  
    And I set field "beleg" to "X X"
    Then field "beleg" has value "XX"
    Then field "such" has value "BXX"
    And I set field "beleg" to ""
    And I close the current editor  
        
Scenario: validate_field_buewbu    
    Given I'm logged in with password "sy"
    Given I open an editor "Buchung7" from table "(Entry):(Entry)" with command "NEW" for record ""  
    And setting field "ewbu" to "" throws the exception "185"
    And I close the current editor    


Scenario: edit_field_buzaartform
    Given I'm logged in with password "sy"
    Given I open an editor "Buchung8" from table "(Entry):(Entry)" with command "NEW" for record ""  
    And I set field "zaform" to "Lastschrift"
    And I set field "sepamand" to "2delm_01"
    And I set field "zaform" to ""
    Then field "sepamand" has value ""
    And I close the current editor  
        
Scenario: validate_field_bukprojekt 
    Given I'm logged in with password "sy"
    Given I open an editor "Buchung10" from table "(Entry):(Entry)" with command "NEW" for record ""  
    And setting field "kprojekt" to "100000" throws the exception "1361"
    And I close the current editor  
    
Scenario: validate_field_bukonto
	Given I open an editor "Buchung11" from table "(Entry):(Entry)" with command "NEW" for record ""
	And I create a new row at the end of the table
    And setting field "konto" to "99800" in row 1 throws the exception "99800: Statistische Kostenrechnungs-Konten nicht erlaubt"
    And I close the current editor  
    Given I open an editor "Buchung11" from table "(Entry):(Entry)" with command "NEW" for record ""
    And I set field "budat" to "31.12.01" 
    And I set field "monat" to "15" 
	And I create a new row at the end of the table
    And setting field "konto" to "K 1" in row 1 throws the exception "264"
    And setting field "konto" to "M 1" in row 1 throws the exception "264"
    And I close the current editor  
    	
Scenario: validate_field_bukstelle
	Given I open an editor "Buchung12" from table "(Entry):(Entry)" with command "NEW" for record ""
	And I set field "such" to "VALFD1"
	And I create a new row at the end of the table
	And I set field "konto" to "54000" in row 1
	And I set field "ewsbetr" to "123,96" in row 1
	And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
	Then field "prest" has value "100"
    Then saving the current editor throws the exception "1340"
	And I create a new row at the end of the table
	And I set field "kstelle" to "100" in row 1
	And I set field "proz" to "10" in row 1
	And I create a new row at the end of the table
	And I set field "kstelle" to "101" in row 2
	And I set field "proz" to "90" in row 2
	And I save the current subeditor to switch back to the parent editor
	
   # id des kostenverteilers-datensatzes dynamisch beschaffen
	And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
	And I save value from field "id" in row 0
	And I close the current subeditor to switch back to the parent editor
	
	And I create a new row at the end of the table
	And I set field "konto" to "11400" in row 2
 	And I respond with answer "Ja" to the dialog with id "1941"
	And I save the current editor
	And I close the current editor
	Given I open an editor "Buchung13" from table "(Entry):(Entry)" with command "NEW" for record ""
	And I create a new row at the end of the table
	And I set field "konto" to "54000" in row 1
	
# Achtung: Änderungen an anderen Feature Dateien können diese ID verschieben (wg. neuer VKZ)
# Daher die dynamisch ermittelte Id des dynamischen Kostenverteilers von oben verwenden
	And setting field "kstelle" in row 1 to saved value throws the exception "7705"
	And I close the current editor
 
	Given I open an editor "Buchung14" from table "(Entry):(Entry)" with command "UPDATE" for record "VALFD1"
	And I respond with answer "nein" to the dialog with id "1482"
	And setting field "kstelle" to "" in row 1 throws the exception "355" 
	And I respond with answer "nein" to the dialog with id "1482"
	And setting field "kstelle" to "100" in row 1 throws the exception "355" 
	And I respond with answer "ja" to the dialog with id "1482"
	And I set field "kstelle" to "100" in row 1 
	And I close the current editor
	

	
Scenario: validate_delete_row
    Given I'm logged in with password "annette"
    Given I open an editor "Buchung14" from table "(Entry):(Entry)" with command "UPDATE" for record "VALFD1"
	And I respond with answer "nein" to the dialog with id "1482"
	And deleting the row at position 1 throws the exception "355"
    And I close the current editor
#
