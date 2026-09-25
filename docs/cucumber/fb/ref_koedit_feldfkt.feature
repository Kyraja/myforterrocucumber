# *****************************************************************************
#  Name           : ref_koedit_feldfkt.feature
#  Autor          : Gisela Koehne
#  Verantwortlich : uo
#  Kontrolle      : hc
#  Funktion       : Editieren des Sachkontenstammes, Feldfunktionen            
#
# *****************************************************************************
@persistent
Feature: REWE-2464
Background:
Given I set the fake date to "31.12.2002"
#
Scenario: EDIT_PRUEF kosteuersts
	Given I open an editor "Konto_200" from table "(Account):(Account)" with command "UPDATE" for record "BRUTTOS"
	And setting field "steuersts" to "6" throws the exception "3300"
	And I close the current editor
	Given I open an editor "Konto_201" from table "(Account):(Account)" with command "UPDATE" for record "BRUTTOS"
	And setting field "steuersts" to "" throws the exception "279"
	And I close the current editor
#
Scenario: EDIT_PRUEF kokstelle
	Given I open an editor "Kostenstelle" from table "(Account):(CostCenter)" with command "NEW" for record ""
	And I set field "nummer" to "102"
	And I set field "such" to "X102"
	And I set field "bu" to "nein"
	And I save the current editor
	And I close the current editor
	Given I open an editor "Konto_202" from table "(Account):(Account)" with command "UPDATE" for record "44000"
	And setting field "kstelle" to "X102" throws the exception "7624"
	And I close the current editor
#
Scenario: EDIT_PRUEF kobu
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
  	And I create a new row at the end of the table
    And I set field "konto" to "16000" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "10X" in row 2
    And I set field "ewhbetr" to "100" in row 2
    And I respond with answer "Ja" to the dialog with id "1941"
    And I save the current editor
    And I close the current editor
    Given I'm logged in with password "annette"
	Given I open an editor "Konto_203" from table "(Account):(Account)" with command "UPDATE" for record "10X"
	And setting field "bu" to "nein" throws the exception "5478"
	And I close the current editor
#
Scenario: EDIT_NACH kobu
	Given I open an editor "Konto_204" from table "(Account):(Account)" with command "COPY" for record "44000"
	And I set field "nummer" to "105X1"
	And I set field "w2ist" to "USD"
	And I set field "w2gjahr" to "2002"
	And I set field "w2asaldo" to "100.00"
	And I save the current editor
	And I close the current editor
	Given I'm logged in with password "annette"
    Given I open an editor "Konto_203" from table "(Account):(Account)" with command "UPDATE" for record "105X1"
    Then field "vrgktotsch" has value "44000"
    Then field "ktostrgl" has value "VKINLREGEL"
	Then field "kost" has value "ja"
	And I set field "bu" to "nein"
	Then field "vrgktotsch" has value ""
    Then field "ktostrgl" has value ""
	Then field "kost" has value "nein"
	Then saving the current editor throws the exception "4069"
	And I close the current editor
#
Scenario: EDIT_PRUEF kostat
	Given I'm logged in with password "annette"
    Given I open an editor "Konto_205" from table "(Account):(Account)" with command "UPDATE" for record "105X1"
	And setting field "stata" to "Kostenrechnung" throws the exception "3254"
	And I close the current editor
 Scenario: EDIT_NACH kostat
 Given I open an editor "Konto_206" from table "(Account):(Account)" with command "COPY" for record "44000"
	And I set field "nummer" to "106X1"
	And I set field "w2ist" to "USD"
	And I set field "w2gjahr" to "2002"
	And I set field "w2asaldo" to "100.00"
    Then field "vrgktotsch" has value "44000"
    Then field "ktostrgl" has value "VKINLREGEL"
    Then field "w2ist" has value "USD"
    Then field "w2gjahr" has value "02"
	Then field "w2asaldo" has value "100.00"
	And I set field "stata" to "Kostenrechnung"
	Then field "vrgktotsch" has value ""
    Then field "ktostrgl" has value ""
    Then field "w2ist" has value ""
    Then field "w2gjahr" has value ""
    Then field "w2asaldo" has value "0.00"
	Then saving the current editor throws the exception "4038"
	And I close the current editor	
#
Scenario: EDIT_PRUEF kosammelart
	Given I'm logged in with password "sy"
 	Given I open an editor "Konto_207" from table "(Account):(Account)" with command "COPY" for record "16000"
 	Then setting field "zasammelart" to "" throws the exception "1361"
 	And I close the current editor

Scenario: EDIT_NACH koev
	Given I'm logged in with password "sy"
	Given I open an editor "Konto_208" from table "(Account):(Account)" with command "COPY" for record "105X1"
	And I set field "nummer" to "107X1"
	Then field "vrgktotsch" has value "44000"
    Then field "ktostrgl" has value "VKINLREGEL"
    And I set field "ev" to ""
    Then field "vrgktotsch" has value ""
    Then field "ktostrgl" has value ""
    And I save the current editor
 	And I close the current editor

Scenario: EDIT_NACH kokart
	Given I'm logged in with password "sy"
	Given I open an editor "Konto_209" from table "(Account):(Account)" with command "COPY" for record "14060"
	And I set field "nummer" to "108X1"
	Then field "steuersts" has value "1"
    And I set field "karta" to ""
    Then field "steuersts" has value ""
    And I save the current editor
 	And I close the current editor
	Given I open an editor "Konto_210" from table "(Account):(Account)" with command "COPY" for record "44000"
	And I set field "nummer" to "109X1"
	Then field "ktostrgl" has value "VKINLREGEL"
    And I set field "karta" to "Steuer"
    Then field "ktostrgl" has value ""
    Then field "vrgktotsch" has value ""
	Then field "vrgktotsch" is not modifiable
    And I set field "steuersts" to "1"
    And I save the current editor
 	And I close the current editor



# Ende	
