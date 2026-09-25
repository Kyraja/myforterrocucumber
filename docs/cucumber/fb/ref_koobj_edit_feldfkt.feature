# *****************************************************************************
#  Name           : ref_koobj_edit_feldfkt.feature
#  Autor          : Gisela Koehne
#  Verantwortlich : sih
#  Kontrolle      : hc
#  Funktion       : Editieren des Kostenobjekte, Feldfunktionen            
#
# *****************************************************************************
@persistent
Feature: REWE-2485
Background:
Given I set the fake date to "31.12.2002"
#
Scenario: EDIT_PRUEF Verdichtungsobjekte
	Given I open an editor "Kst_200" from table "(Account):(CostCenter)" with command "UPDATE" for record "100"
	And setting field "verd" to "101" throws the exception "62"
	And setting field "verd" to "10000" throws the exception "149"
	And setting field "kverd1" to "101" throws the exception "62"
	And setting field "kverd1" to "10000" throws the exception "149"
	And setting field "kverd2" to "101" throws the exception "62"
	And setting field "kverd2" to "10000" throws the exception "149"
	And setting field "kverd3" to "101" throws the exception "62"
	And setting field "kverd3" to "10000" throws the exception "149"
	And setting field "kverd4" to "101" throws the exception "62"
	And setting field "kverd4" to "10000" throws the exception "149"
	And setting field "kverd5" to "101" throws the exception "62"
	And setting field "kverd5" to "10000" throws the exception "149"
	And I close the current editor
#
Scenario: EDIT_PRUEF Verdichtungszyklus
	Given I open an editor "KSt_201" from table "(Account):(CostCenter)" with command "UPDATE" for record "100V"
	And I set field "verd" to "102V"
	And I save the current editor
	And I close the current editor
	Scenario: EDIT_PRUEF Verdichtungsobjekte
	Given I open an editor "Konto_200" from table "(Account):(CostCenter)" with command "UPDATE" for record "102V"
	And setting field "verd" to "100V" throws the exception "267"
	And I close the current editor
#
Scenario: EDIT_PRUEF Umlagen Entlastung und Belastung
	Given I open an editor "KSt_202" from table "(Account):(CostCenter)" with command "UPDATE" for record "100"
	And setting field "umlzu" to "44000" throws the exception "4818"
	And I close the current editor
	Given I open an editor "KSt_203" from table "(Account):(CostCenter)" with command "UPDATE" for record "100"
	And setting field "umlab" to "44000" throws the exception "4819"
	And I close the current editor
#
Scenario: EDIT_PRUEF Einzelkostenbasis und Gemeinkostenbasis
	Given I open an editor "KSt_204" from table "(Account):(CostCenter)" with command "UPDATE" for record "101"
	And I create a new row at the end of the table
	And setting field "ekbasis" to "111" in row 1 throws the exception "4028"
	And I close the current editor
	Given I open an editor "KSt_205" from table "(Account):(CostCenter)" with command "UPDATE" for record "100"
    And creating a new row at position 1 throws the exception "3794"
	And I close the current editor
	Given I open an editor "KSt_206" from table "(Account):(CostCenter)" with command "UPDATE" for record "101"
	And I create a new row at the end of the table
	And setting field "gkbasis" to "100" in row 1 throws the exception "4634"
	And I close the current editor
#
Scenario:  Einzelkostenbasis darf nicht doppelt vorkommen
	Given I open an editor "KSt_300" from table "(Account):(CostCenter)" with command "UPDATE" for record "101"
	And I create a new row at the end of the table
 	And I set field "ekbasis" to "44000" in row 1
	And I create a new row at the end of the table
	And setting field "ekbasis" to "44000" in row 2 throws the exception "3855"
	And I close the current editor
#
Scenario: EDIT_PRUEF Kostenträger Verdichtungsobjekte
	Given I open an editor "Kst_207" from table "(Account):(CostObject)" with command "UPDATE" for record "REST"
	And setting field "verd" to "100001" throws the exception "62"
	And setting field "verd" to "100" throws the exception "149"
	And I close the current editor
#
Scenario: Zeilen_einfuegen
	Given I open an editor "Kst_208" from table "(Account):(CostCenter)" with command "UPDATE" for record "100"
    Then creating a new row at position 1 throws the exception "4627"
    And I close the current editor
#
Scenario: Zeilen_einfuegen
	Given I open an editor "Kst_208" from table "(Account):(CostCenter)" with command "NEW" for record ""
    And I set field "bu" to "nein"
    Then creating a new row at position 1 throws the exception "4651"
    And I close the current editor	
