# *****************************************************************************
#  Name           : ref_koedit_x1_KOEDIT.feature
#  Autor          : Gisela Koehne
#  Verantwortlich : uo
#  Kontrolle      : hc
#  Funktion       : Editieren des Sachkontenstammes, Ersatz für den Lader KOEDIT         
#
# *****************************************************************************
@persistent
Feature: REWE-2464
Background:
Given I set the fake date to "01.01.1995"
Scenario: Konto_10000_aendern
	Given I open an editor "Konto_301" from table "(Account):(Account)" with command "UPDATE" for record "10000"
	And I set field "such" to "XXX"
    And I set field "name" to "Kleinzeugs"
	And I set field "verd" to "33000"
	Then field "gv" is not modifiable
    And I set field "umsatz" to "ja"
    And I set field "kart" to "Steuerkonto" 
    And I set field "bukenn" to "" 
    And I set field "stat" to "" 
    And I set field "kvrel" to "ja" 
    And setting field "kost" to "ja" throws the exception "1893"
    And setting field "kstelle" to "ja" throws the exception "1893"
	Then field "gv" is not modifiable
    And I set field "kart" to "" 
    And I set field "umsatz" to "nein"
	Then field "gv" is not modifiable
    And setting field "kost" to "ja" throws the exception "1893"
    And setting field "kstelle" to "ja" throws the exception "1893"
    Then field "gv" is not modifiable
	And I save the current editor
	And I close the current editor
#
Scenario: Konto_33000_aendern
	Given I open an editor "Konto_302" from table "(Account):(Account)" with command "UPDATE" for record "33000"
    And I set field "such" to "XXX"
    And I set field "name" to "Kleinzeugs"
	And setting field "verd" to "33000" throws the exception "267"
	Then field "gv" is not modifiable
	And I set field "umsatz" to "ja"
	And I set field "kart" to "Steuerkonto" 
	And I set field "kart" to "Skontokonto" 
    And I set field "bukenn" to "" 
    And I set field "stat" to "" 
    And I set field "kvrel" to "ja" 
    And setting field "kost" to "ja" throws the exception "1893"
    And setting field "kstelle" to "ja" throws the exception "1893"
    And I set field "kart" to "" 
	And I save the current editor
	And I close the current editor
#
Scenario: Konto_33000_aendern_2
	Given I open an editor "Konto_303" from table "(Account):(Account)" with command "UPDATE" for record "33000"
   	And I set field "umsatz" to "nein"
	Then field "gv" is not modifiable
	And setting field "kost" to "nein" throws the exception "1893"
    And setting field "kstelle" to "" throws the exception "1893"
	Then field "gv" is not modifiable
	And I save the current editor
	And I close the current editor
#
Scenario: Konto_14050_aendern_1
	Given I open an editor "Konto_304" from table "(Account):(Account)" with command "UPDATE" for record "14050"
    And I set field "such" to "XXX"
    And I set field "name" to "Kleinzeugs"
	Then field "gv" is not modifiable
	And I set field "umsatz" to "ja"
	Then field "kart" is not modifiable
 	Then field "steuer" is not modifiable
    And I set field "stat" to "" 
    And I set field "kvrel" to "ja" 
    And setting field "kost" to "ja" throws the exception "1893"
    And setting field "kstelle" to "" throws the exception "1893"
	Then field "kart" is not modifiable
	And I save the current editor
	And I close the current editor

Scenario: Konto_14050_aendern_2
	Given I open an editor "Konto_305" from table "(Account):(Account)" with command "UPDATE" for record "14050"
    And I set field "bukenn" to ""
    And I set field "stat" to ""
    And setting field "kost" to "ja" throws the exception "1893"
    And setting field "kstelle" to "" throws the exception "1893"
	Then field "gv" is not modifiable
	Then field "kart" is not modifiable
    And I set field "umsatz" to "nein" 
	Then field "gv" is not modifiable
    And setting field "kost" to "ja" throws the exception "1893"
    And setting field "kstelle" to "" throws the exception "1893"
	Then field "gv" is not modifiable
	And I save the current editor
	And I close the current editor
#
Scenario: Konto_57355_aendern_1
	Given I open an editor "Konto_306" from table "(Account):(Account)" with command "UPDATE" for record "57355"
    And I set field "such" to "XXX"
    And I set field "name" to "Kleinzeugs"
	Then field "gv" is not modifiable
	And I set field "umsatz" to "ja"
	Then field "kart" is not modifiable
	And I save the current editor
	And I close the current editor	
#
Scenario: Konto_57355_aendern_2
	Given I open an editor "Konto_307" from table "(Account):(Account)" with command "UPDATE" for record "57355"
    And I set field "bukenn" to ""
    And I set field "stat" to ""
    And I set field "kvrel" to "ja"
    And I set field "kost" to "ja"
    And I set field "kstelle" to "100"
	Then field "gv" is not modifiable
	And I set field "umsatz" to "nein"
	Then field "kart" is not modifiable
	And I save the current editor
	And I close the current editor
#
Scenario: Konto_12345678_neu
	Given I open an editor "Kostenstelle" from table "(Account):(Account)" with command "NEW" for record ""
	And I set field "nummer" to "12345678"
	And I set field "such" to "XXX"
	And I set field "name" to "XXX"
	And I set field "bu" to "nein"
	And I save the current editor
	And I close the current editor
#
Scenario: Konto_12345678_aendern_1
	Given I open an editor "Konto_307" from table "(Account):(Account)" with command "UPDATE" for record "12345678"
	Then field "bu" is not modifiable
	Then field "gv" is not modifiable
	And I save the current editor
	And I close the current editor
#
Scenario: Konto_12345679_neu
	Given I open an editor "Kostenstelle" from table "(Account):(Account)" with command "NEW" for record ""
	And I set field "nummer" to "12345679"
	And I set field "such" to "XXX"
	And I set field "name" to "XXX"
	Then field "ktostrgl" is not modifiable
	Then field "steuersts" is not modifiable
	And I save the current editor
	And I close the current editor
#
