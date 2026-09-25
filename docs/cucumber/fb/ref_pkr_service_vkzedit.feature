@persistant
Feature: Edit of the transactionFigures
Background:
Given I set the fake date to "02.01.2003"

# Buchung nach 2003
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
    And I set field "budat" to "30.01.03"
  	And I create a new row at the end of the table
    And I set field "konto" to "52004" in row 1
    And I set field "Projekt" to "P120" in row 1
    And I set field "ewsbetr" to "100" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "10000" in row 2
    And I set field "ewhbetr" to "100" in row 2
    And I respond with answer "Ja" to the dialog with id "1941"
    And I save the current editor

# Vortraege werden beim nachträglichen Editieren von VKZ nicht berücksichtigt
# wohl aber bei der Neuanlage der VKZ im Folgejahr, anscheinend unabhängig von der bilkostart der Kostenart
Scenario: Edit_VKZ_EDS_Plan_bilkostart_False
    Given I open an editor "BABFORMULAR" from table "(EDS):(EDS)" with command "UPDATE" for record "100" 	
    And I set field "gjahr" to "02"	
    And I set field "skoobj" to "P 120"	
	And I press button "planfix" to open a subeditor for "Plan-Vkz" in row 1 with dialog "2011" and answer "Ja"
    Then field "s1" is modifiable
    Then field "s2" is modifiable
    Then field "s3" is modifiable
    Then field "s4" is modifiable
    Then field "s5" is modifiable
    Then field "s6" is modifiable
    Then field "s7" is modifiable
    Then field "s8" is modifiable
    Then field "s9" is modifiable
    Then field "s10" is modifiable
    Then field "s11" is modifiable
    Then field "s12" is modifiable
    Then field "s13" is modifiable
    Then field "s14" is modifiable
    Then field "s15" is modifiable
    Then field "h1" is modifiable
    Then field "h2" is modifiable
    Then field "h3" is modifiable
    Then field "h4" is modifiable
    Then field "h5" is modifiable
    Then field "h6" is modifiable
    Then field "h7" is modifiable
    Then field "h8" is modifiable
    Then field "h9" is modifiable
    Then field "h10" is modifiable
    Then field "h11" is modifiable
    Then field "h12" is modifiable
    Then field "h13" is modifiable
    Then field "h14" is modifiable
    Then field "h15" is modifiable
    Then field "sa1" is not modifiable
    Then field "sa2" is not modifiable
    Then field "sa3" is not modifiable
    Then field "sa4" is not modifiable
    Then field "sa5" is not modifiable
    Then field "sa6" is not modifiable
    Then field "sa7" is not modifiable
    Then field "sa8" is not modifiable
    Then field "sa9" is not modifiable
    Then field "sa10" is not modifiable
    Then field "sa11" is not modifiable
    Then field "sa12" is not modifiable
    Then field "vortrag" is not modifiable
    Then field "saldo" is not modifiable
    And I set field "s1" to "10"
    Then field "saldo" has value "10.00"
    Then field "sa1" has value "10.00"
    And I set field "h2" to "15"
    Then field "sa2" has value "-15.00"
    Then field "saldo" has value "-5.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "BABFORMULAR"
#
    And I set field "gjahr" to "03"	
    And I set field "skoobj" to "P 120"	
	And I press button "planfix" to open a subeditor for "Plan-Vkz" in row 1 with dialog "2011" and answer "Ja"
    Then field "vortrag" has value "-5.00"
    And I close the current editor
    And I switch the current editor to editor "BABFORMULAR"
#
    And I set field "gjahr" to "03"	
    And I set field "skoobj" to "P 120"	
	And I press button "planprop" to open a subeditor for "Plan-Vkz" in row 1 with dialog "2011" and answer "Ja"
    And I set field "s1" to "10"
    Then field "saldo" has value "10.00"
    Then field "sa1" has value "10.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I close the current editor
    And I switch the current editor to editor "BABFORMULAR"
    And I set field "gjahr" to "02"	
    And I set field "skoobj" to "P 120"	
	And I press button "planprop" to open a subeditor for "Plan-Vkz" in row 1 with dialog "2011" and answer "Ja"
    And I set field "s1" to "10"
    Then field "saldo" has value "10.00"
    Then field "sa1" has value "10.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "BABFORMULAR"
    And I set field "gjahr" to "03"	
    And I set field "skoobj" to "P 120"	
	And I press button "planprop" to open a subeditor for "Plan-Vkz" in row 1
    Then field "vortrag" has value "0.00"
    Then field "saldo" has value "10.00"

    # Vortraege werden beim nachträglichen Editieren von VKZ nicht berücksichtigt
    # wohl aber bei der Neuanlage der VKZ im Folgejahr
Scenario: Edit_VKZ_EDS_Plan_bilkostart_True
    Given I open an editor "BABFORMULAR" from table "(EDS):(EDS)" with command "UPDATE" for record "100" 	
    And I set field "gjahr" to "02"	
    And I set field "skoobj" to "P 120"	
	And I press button "planfix" to open a subeditor for "Plan-Vkz" in row 5 with dialog "2011" and answer "Ja"
    And I set field "s1" to "10"
    Then field "saldo" has value "10.00"
    Then field "sa1" has value "10.00"
    And I set field "h2" to "15"
    Then field "sa2" has value "-15.00"
    Then field "saldo" has value "-5.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "BABFORMULAR"
#
    And I set field "gjahr" to "03"	
    And I set field "skoobj" to "P 120"	
	And I press button "planfix" to open a subeditor for "Plan-Vkz" in row 5 with dialog "2011" and answer "Ja"
    Then field "vortrag" has value "-5.00"
    And I close the current editor
    And I switch the current editor to editor "BABFORMULAR"
#
    And I set field "gjahr" to "03"	
    And I set field "skoobj" to "P 120"	
	And I press button "planprop" to open a subeditor for "Plan-Vkz" in row 5 with dialog "2011" and answer "Ja"
    And I set field "s1" to "10"
    Then field "saldo" has value "10.00"
    Then field "sa1" has value "10.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I close the current editor
    And I switch the current editor to editor "BABFORMULAR"
    And I set field "gjahr" to "02"	
    And I set field "skoobj" to "P 120"	
	And I press button "planprop" to open a subeditor for "Plan-Vkz" in row 5 with dialog "2011" and answer "Ja"
    And I set field "s1" to "10"
    Then field "saldo" has value "10.00"
    Then field "sa1" has value "10.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "BABFORMULAR"
    And I set field "gjahr" to "03"	
    And I set field "skoobj" to "P 120"	
	And I press button "planprop" to open a subeditor for "Plan-Vkz" in row 5
    Then field "vortrag" has value "0.00"
    Then field "saldo" has value "10.00"
    And I close the current editor
    And I switch the current editor to editor "BABFORMULAR"
    And I close the current editor
        
Scenario: Edit_VKZ_EDS_Sollkost
    Given I open an editor "BABFORMULAR" from table "(EDS):(EDS)" with command "UPDATE" for record "100" 	
    And I set field "gjahr" to "02"	
    And I set field "skoobj" to "P 120"	
	And I press button "sollkost" to open a subeditor for "Sollkost-Vkz" in row 1
    Then field "s1" is not modifiable
    Then field "s2" is not modifiable
    Then field "s3" is not modifiable
    Then field "s4" is not modifiable
    Then field "s5" is not modifiable
    Then field "s6" is not modifiable
    Then field "s7" is not modifiable
    Then field "s8" is not modifiable
    Then field "s9" is not modifiable
    Then field "s10" is not modifiable
    Then field "s11" is not modifiable
    Then field "s12" is not modifiable
    Then field "s13" is not modifiable
    Then field "s14" is not modifiable
    Then field "s15" is not modifiable
    Then field "h1" is not modifiable
    Then field "h2" is not modifiable
    Then field "h3" is not modifiable
    Then field "h4" is not modifiable
    Then field "h5" is not modifiable
    Then field "h6" is not modifiable
    Then field "h7" is not modifiable
    Then field "h8" is not modifiable
    Then field "h9" is not modifiable
    Then field "h10" is not modifiable
    Then field "h11" is not modifiable
    Then field "h12" is not modifiable
    Then field "h13" is not modifiable
    Then field "h14" is not modifiable
    Then field "h15" is not modifiable
    Then field "sa1" is not modifiable
    Then field "sa2" is not modifiable
    Then field "sa3" is not modifiable
    Then field "sa4" is not modifiable
    Then field "sa5" is not modifiable
    Then field "sa6" is not modifiable
    Then field "sa7" is not modifiable
    Then field "sa8" is not modifiable
    Then field "sa9" is not modifiable
    Then field "sa10" is not modifiable
    Then field "sa11" is not modifiable
    Then field "sa12" is not modifiable
    Then field "vortrag" is not modifiable
    Then field "saldo" is not modifiable
    And I close the current editor
    And I switch the current editor to editor "BABFORMULAR"
    And I close the current editor

Scenario: Edit_VKZ_EDS_SollIstAbw
    Given I open an editor "BABFORMULAR" from table "(EDS):(EDS)" with command "UPDATE" for record "100" 	
    And I set field "gjahr" to "02"	
    And I set field "skoobj" to "P 120"	
	And I press button "siabwa" to open a subeditor for "Sollist-Abweichung-Vkz" in row 1
    Then field "s1" is not modifiable
    Then field "s2" is not modifiable
    Then field "s3" is not modifiable
    Then field "s4" is not modifiable
    Then field "s5" is not modifiable
    Then field "s6" is not modifiable
    Then field "s7" is not modifiable
    Then field "s8" is not modifiable
    Then field "s9" is not modifiable
    Then field "s10" is not modifiable
    Then field "s11" is not modifiable
    Then field "s12" is not modifiable
    Then field "s13" is not modifiable
    Then field "s14" is not modifiable
    Then field "s15" is not modifiable
    Then field "h1" is not modifiable
    Then field "h2" is not modifiable
    Then field "h3" is not modifiable
    Then field "h4" is not modifiable
    Then field "h5" is not modifiable
    Then field "h6" is not modifiable
    Then field "h7" is not modifiable
    Then field "h8" is not modifiable
    Then field "h9" is not modifiable
    Then field "h10" is not modifiable
    Then field "h11" is not modifiable
    Then field "h12" is not modifiable
    Then field "h13" is not modifiable
    Then field "h14" is not modifiable
    Then field "h15" is not modifiable
    Then field "sa1" is not modifiable
    Then field "sa2" is not modifiable
    Then field "sa3" is not modifiable
    Then field "sa4" is not modifiable
    Then field "sa5" is not modifiable
    Then field "sa6" is not modifiable
    Then field "sa7" is not modifiable
    Then field "sa8" is not modifiable
    Then field "sa9" is not modifiable
    Then field "sa10" is not modifiable
    Then field "sa11" is not modifiable
    Then field "sa12" is not modifiable
    Then field "vortrag" is not modifiable
    Then field "saldo" is not modifiable
    And I close the current editor
    And I switch the current editor to editor "BABFORMULAR"
    And I close the current editor

Scenario: Edit_VKZ_EDS_SollIstAbw
    Given I open an editor "BABFORMULAR" from table "(EDS):(EDS)" with command "UPDATE" for record "100" 	
    And I set field "gjahr" to "02"	
    And I set field "skoobj" to "P 120"	
	And I press button "siabwr" to open a subeditor for "SollistRel-Abweichung-Vkz" in row 1
    Then field "s1" is not modifiable
    Then field "s2" is not modifiable
    Then field "s3" is not modifiable
    Then field "s4" is not modifiable
    Then field "s5" is not modifiable
    Then field "s6" is not modifiable
    Then field "s7" is not modifiable
    Then field "s8" is not modifiable
    Then field "s9" is not modifiable
    Then field "s10" is not modifiable
    Then field "s11" is not modifiable
    Then field "s12" is not modifiable
    Then field "s13" is not modifiable
    Then field "s14" is not modifiable
    Then field "s15" is not modifiable
    Then field "h1" is not modifiable
    Then field "h2" is not modifiable
    Then field "h3" is not modifiable
    Then field "h4" is not modifiable
    Then field "h5" is not modifiable
    Then field "h6" is not modifiable
    Then field "h7" is not modifiable
    Then field "h8" is not modifiable
    Then field "h9" is not modifiable
    Then field "h10" is not modifiable
    Then field "h11" is not modifiable
    Then field "h12" is not modifiable
    Then field "h13" is not modifiable
    Then field "h14" is not modifiable
    Then field "h15" is not modifiable
    Then field "sa1" is not modifiable
    Then field "sa2" is not modifiable
    Then field "sa3" is not modifiable
    Then field "sa4" is not modifiable
    Then field "sa5" is not modifiable
    Then field "sa6" is not modifiable
    Then field "sa7" is not modifiable
    Then field "sa8" is not modifiable
    Then field "sa9" is not modifiable
    Then field "sa10" is not modifiable
    Then field "sa11" is not modifiable
    Then field "sa12" is not modifiable
    Then field "vortrag" is not modifiable
    Then field "saldo" is not modifiable
    And I close the current editor
    And I switch the current editor to editor "BABFORMULAR"
    And I close the current editor

