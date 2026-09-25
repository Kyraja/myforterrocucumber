@persistant
Feature: Edit of the transactionFigures
Background:
Given I set the fake date to "02.01.2003"
 #
Scenario: Edit_Set_kogv_non_standard
    Given I open an editor "Kostenstelle" from table "(Account):(CostCenter)" with command "COPY" for record "1121"
    And I set field "nummer" to "1121V"
    And I set field "gv" to "nein"
    And I set field "verd" to ""
    And I save the current editor
    And I close the current editor
    Given I open an editor "Kostentraeger" from table "(Account):(CostObject)" with command "COPY" for record "100000"
    And I set field "nummer" to "100000V"
    And I set field "verd" to ""
    And I set field "gv" to "ja"
    And I save the current editor
    And I close the current editor
    
Scenario: Create_Posting
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
    And I set field "budat" to "30.11.02"
  	And I create a new row at the end of the table
    And I set field "konto" to "k 1" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "44000" in row 2
    And I set field "ewhbetr" to "100" in row 2
    And I set field "kstelle" to "1121V" in row 2
    And I respond with answer "Ja" to the dialog with id "1941"
    And I save the current editor
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
    And I set field "budat" to "31.01.03"
  	And I create a new row at the end of the table
    And I set field "konto" to "k 1" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "44000" in row 2
    And I set field "ewhbetr" to "100" in row 2
    And I set field "kstelle" to "1121V" in row 2
    And I respond with answer "Ja" to the dialog with id "1941"
    And I save the current editor
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
    And I set field "budat" to "30.11.02"
  	And I create a new row at the end of the table
    And I set field "konto" to "k 1" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "44000" in row 2
    And I set field "ewhbetr" to "100" in row 2
    And I set field "kstelle" to "100000V" in row 2
    And I respond with answer "Ja" to the dialog with id "1941"
    And I save the current editor
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
    And I set field "budat" to "31.01.03"
  	And I create a new row at the end of the table
    And I set field "konto" to "k 1" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "44000" in row 2
    And I set field "ewhbetr" to "100" in row 2
    And I set field "kstelle" to "100000V" in row 2
    And I respond with answer "Ja" to the dialog with id "1941"
    And I save the current editor
     Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
    And I set field "budat" to "31.01.03"
  	And I create a new row at the end of the table
    And I set field "konto" to "k 1" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "44000" in row 2
    And I set field "ewhbetr" to "100" in row 2
    And I set field "kstelle" to "100000" in row 2
    And I respond with answer "Ja" to the dialog with id "1941"
    And I save the current editor
 #
 #
Scenario: Edit_VKZ_CostCenter
#
# Verkehrszahlen bei einem Kostenstelle (Maske 122)
    Given I open an editor "Kostenstelle" from table "(Account):(CostCenter)" with command "UPDATE" for record "1121"
# Ist Verkehrszahlen     
    And I press button "ivkz" to open a subeditor for "Ist-Vkz"
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
    Then field "vortrag" is not modifiable
    Then field "saldo" is not modifiable
    And I close the current editor
    And I switch the current editor to editor "Kostenstelle"
    And I close the current editor

# Planverkehrszahlen, änderbar sind nur die Monate, die noch nicht abgeschlosssen sind           
    Given I open an editor "Kostenstelle" from table "(Account):(CostCenter)" with command "UPDATE" for record "1121" 	
    And I set field "gjahr" to "02"
	And I press button "pvkz" to open a subeditor for "Plan-Vkz" in row 0 with dialog "2011" and answer "Ja"
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
    Then field "s11" is modifiable
    Then field "s12" is modifiable
    Then field "s13" is modifiable
    Then field "s14" is modifiable
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
    Then field "h11" is modifiable
    Then field "h12" is modifiable
    Then field "h13" is modifiable
    Then field "h14" is modifiable
    Then field "vortrag" is modifiable
 #  Then field "saldo" is modifiable
    And I set field "s11" to "10"
    Then field "saldo" has value "10.00"
    And I set field "h12" to "15"
    Then field "saldo" has value "-5.00"
    And I set field "vortrag" to "100.00"
    Then field "saldo" has value "95.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
    And I close the current editor
 #
    Given I open an editor "Kostenstelle" from table "(Account):(CostCenter)" with command "UPDATE" for record "1121" 	
	Then pressing button "bgivkz1" in row 0 to open a subeditor throws the exception "3826"
 	Then pressing button "bgpvkz1" in row 0 to open a subeditor throws the exception "3826"
 	And I set field "bez1" to "1000"
 	And I press button "bgivkz1" to open a subeditor for "BG-Ist-Vkz" in row 0 with dialog "2011" and answer "Ja"
 	And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
 	And I press button "bgpvkz1" to open a subeditor for "BG-Plan-Vkz" in row 0 with dialog "2011" and answer "Ja"
 	And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
#
	Then pressing button "bgivkz2" in row 0 to open a subeditor throws the exception "3826"
 	Then pressing button "bgpvkz2" in row 0 to open a subeditor throws the exception "3826"
 	And I set field "bez2" to "1000"
 	And I press button "bgivkz2" to open a subeditor for "BG-Ist-Vkz" in row 0  
 	And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
 	And I press button "bgpvkz2" to open a subeditor for "BG-Plan-Vkz" in row 0  
 	And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
#
	Then pressing button "bgivkz3" in row 0 to open a subeditor throws the exception "3826"
 	Then pressing button "bgpvkz3" in row 0 to open a subeditor throws the exception "3826"
 	And I set field "bez3" to "1000"
 	And I press button "bgivkz3" to open a subeditor for "BG-Ist-Vkz" in row 0  
 	And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
 	And I press button "bgpvkz3" to open a subeditor for "BG-Plan-Vkz" in row 0 
 	And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
# 
	Then pressing button "bgivkz4" in row 0 to open a subeditor throws the exception "3826"
 	Then pressing button "bgpvkz4" in row 0 to open a subeditor throws the exception "3826"
 	And I set field "bez4" to "1000"
 	And I press button "bgivkz4" to open a subeditor for "BG-Ist-Vkz" in row 0  
 	And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
 	And I press button "bgpvkz4" to open a subeditor for "BG-Plan-Vkz" in row 0  
 	And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"    
# 
	Then pressing button "bgivkz5" in row 0 to open a subeditor throws the exception "3826"
 	Then pressing button "bgpvkz5" in row 0 to open a subeditor throws the exception "3826"
 	And I set field "bez5" to "1000"
 	And I press button "bgivkz5" to open a subeditor for "BG-Ist-Vkz" in row 0  
 	And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
 	And I press button "bgpvkz5" to open a subeditor for "BG-Plan-Vkz" in row 0  
 	And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"    
 	And I close the current editor
#
#
Scenario: Edit_VKZ_CostObject
#
# Verkehrszahlen bei einem Kostentr�ger (Maske 122)
    Given I open an editor "Kostentraeger" from table "(Account):(CostObject)" with command "UPDATE" for record "100000"
# Ist Verkehrszahlen     
    And I press button "ivkz" to open a subeditor for "Ist-Vkz"
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
    Then field "vortrag" is not modifiable
    Then field "saldo" is not modifiable
    And I close the current editor
    And I switch the current editor to editor "Kostentraeger"
    And I close the current editor

# Planverkehrszahlen,  änderbar sind nur die Monate, die noch nicht abgeschlosssen sind             
    Given I open an editor "Kostentraeger" from table "(Account):(CostObject)" with command "UPDATE" for record "100000" 	
	And I press button "pvkz" to open a subeditor for "Plan-Vkz" in row 0 with dialog "2011" and answer "Ja"
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
    Then field "s11" is modifiable
    Then field "s12" is modifiable
    Then field "s13" is modifiable
    Then field "s14" is modifiable
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
    Then field "h11" is modifiable
    Then field "h12" is modifiable
    Then field "h13" is modifiable
    Then field "h14" is modifiable
    Then field "vortrag" is modifiable
 #  Then field "saldo" is modifiable
    And I set field "s11" to "10"
    Then field "saldo" has value "10.00"
    And I set field "h12" to "15"
    Then field "saldo" has value "-5.00"
    And I set field "vortrag" to "100.00"
    Then field "saldo" has value "95.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "Kostentraeger"
    And I close the current editor
#
Scenario: Edit_VKZ_CostType
#
# Verkehrszahlen bei einer Kostenart (Maske 471)
    Given I open an editor "Kostenart" from table "(CostType):(CostType)" with command "UPDATE" for record "500"
# Ist Verkehrszahlen     
    And I press button "ivkz" to open a subeditor for "Ist-Vkz"
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
    Then field "vortrag" is not modifiable
    Then field "saldo" is not modifiable
    And I close the current editor
    And I switch the current editor to editor "Kostenart"
    And I close the current editor

# Planverkehrszahlen           
    Given I open an editor "Kostenart" from table "(CostType):(CostType)" with command "UPDATE" for record "500" 	
	And I press button "pvkz" to open a subeditor for "Plan-Vkz" in row 0 with dialog "2011" and answer "Ja"
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
    Then field "s11" is modifiable
    Then field "s12" is modifiable
    Then field "s13" is modifiable
    Then field "s14" is modifiable
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
    Then field "h11" is modifiable
    Then field "h12" is modifiable
    Then field "h13" is modifiable
    Then field "h14" is modifiable
    Then field "vortrag" is modifiable
 #  Then field "saldo" is modifiable
    And I set field "s11" to "10"
    Then field "saldo" has value "10.00"
    And I set field "h12" to "15"
    Then field "saldo" has value "-5.00"
    And I set field "vortrag" to "100.00"
    Then field "saldo" has value "95.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "Kostenart"
    And I close the current editor

    #
# Verkehrszahlen bei einem BAB-Formular (Maske 478)
    Given I open an editor "BABFORMULAR" from table "(EDS):(EDS)" with command "UPDATE" for record "100"
# Ist Verkehrszahlen     
    And I press button "istkost" to open a subeditor for "Ist-Vkz" in row 6
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

# Planverkehrszahlen           
    Given I open an editor "BABFORMULAR" from table "(EDS):(EDS)" with command "UPDATE" for record "100" 	
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
    And I close the current editor

    #
#
Scenario: Edit_VKZ_Assessment
#
# Verkehrszahlen bei einer Kostenstellenumlage (Maske 79)
  Given I open an editor "Umlage" from table "(Assessment):(CostCenterAssessment)" with command "UPDATE" for record "1121"
# Ist Verkehrszahlen     
    And I press button "kszuist" to open a subeditor for "Ist-Vkz" in row 1
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
    Then field "abkos1" is not modifiable
    Then field "abkos2" is not modifiable
    Then field "abkos3" is not modifiable
    Then field "abkos4" is not modifiable
    Then field "abkos5" is not modifiable
    Then field "abkos6" is not modifiable
    Then field "abkos7" is not modifiable
    Then field "abkos8" is not modifiable
    Then field "abkos9" is not modifiable
    Then field "abkos10" is not modifiable
    Then field "abkos11" is not modifiable
    Then field "abkos12" is not modifiable
    Then field "saldo" is not modifiable
    And I set field "s1" to "10.00"
    Then field "abkos1" has value "90.00"
    And I close the current editor
    And I switch the current editor to editor "Umlage"
    And I close the current editor

  # Planverkehrszahlen           
    Given I open an editor "Umlage" from table "(Assessment):(CostCenterAssessment)" with command "UPDATE" for record "1121" 	
	And I press button "kszupfix" to open a subeditor for "Plan-Vkz" in row 1
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
    Then field "abkos1" is not modifiable
    Then field "abkos2" is not modifiable
    Then field "abkos3" is not modifiable
    Then field "abkos4" is not modifiable
    Then field "abkos5" is not modifiable
    Then field "abkos6" is not modifiable
    Then field "abkos7" is not modifiable
    Then field "abkos8" is not modifiable
    Then field "abkos9" is not modifiable
    Then field "abkos10" is not modifiable
    Then field "abkos11" is not modifiable
    Then field "abkos12" is not modifiable
    Then field "saldo" is not modifiable
    And I set field "s1" to "10.00"
    Then field "abkos1" has value "90.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "Umlage"
    And I close the current editor

    #
    # Verkehrszahlen für Bezugsgr��en bei einer Kostenstellenumlage (Maske 79)
  	Given I open an editor "Umlage" from table "(Assessment):(CostCenterAssessment)" with command "UPDATE" for record "1121"
    And I press button "bgivkz" to open a subeditor for "BG-Ist-VKZ" in row 0 
    And I close the current editor
    And I switch the current editor to editor "Umlage"
    And I press button "bgpvkz" to open a subeditor for "BG-Plan-VKZ" in row 0
    And I close the current editor
    And I switch the current editor to editor "Umlage"
    And I close the current editor
    
Scenario: Edit_VKZ_ActivityBase
#
# Verkehrszahlen bei einer Bezugsgr��e (Maske Ist 483, Plan479), hier eine Saldierbare Bezugsgr��e
  Given I open an editor "Bezugsgroesse" from table "(ActivityBase):(ActivityBase)" with command "UPDATE" for record "1121"
# Ist Verkehrszahlen     
	And I set field "gjahr" to "02"
    And I press button "ivkz" to open a subeditor for "Ist-Vkz"
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
    Then field "s11" is modifiable
    Then field "s12" is modifiable
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
    Then field "h11" is modifiable
    Then field "h12" is modifiable
    And I close the current editor
    And I switch the current editor to editor "Bezugsgroesse"
	And I set field "gjahr" to "03"
    And I press button "ivkz" to open a subeditor for "Ist-Vkz"
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
    Then field "bgsa1" is not modifiable
    Then field "bgsa2" is not modifiable
    Then field "bgsa3" is not modifiable
    Then field "bgsa4" is not modifiable
    Then field "bgsa5" is not modifiable
    Then field "bgsa6" is not modifiable
    Then field "bgsa7" is not modifiable
    Then field "bgsa8" is not modifiable
    Then field "bgsa9" is not modifiable
    Then field "bgsa10" is not modifiable
    Then field "bgsa11" is not modifiable
    Then field "bgsa12" is not modifiable
    Then field "saldo" is not modifiable
    And I set field "s1" to "1.00"
    Then field "bgsa1" has value "-999.00"
    And I close the current editor
    And I switch the current editor to editor "Bezugsgroesse"
    And I close the current editor

  # Planverkehrszahlen           
    Given I open an editor "Bezugsgroesse" from table "(ActivityBase):(ActivityBase)" with command "UPDATE" for record "1121" 	
	And I press button "pvkz" to open a subeditor for "Plan-Vkz"
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
    Then field "s11" is modifiable
    Then field "s12" is modifiable
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
    Then field "h11" is modifiable
    Then field "h12" is modifiable
    Then field "bgsa1" is not modifiable
    Then field "bgsa2" is not modifiable
    Then field "bgsa3" is not modifiable
    Then field "bgsa4" is not modifiable
    Then field "bgsa5" is not modifiable
    Then field "bgsa6" is not modifiable
    Then field "bgsa7" is not modifiable
    Then field "bgsa8" is not modifiable
    Then field "bgsa9" is not modifiable
    Then field "bgsa10" is not modifiable
    Then field "bgsa11" is not modifiable
    Then field "bgsa12" is not modifiable
    Then field "saldo" is not modifiable
    And I set field "s11" to "20.00"
    Then field "bgsa11" has value "-980.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "Bezugsgroesse"
    And I close the current editor    

    Scenario: Edit_VKZ_CostCenter_Wartung 
    Given I'm logged in with password "annette"
 # Istverkehrszahlen in Wartung ändern, gv = false           
    Given I open an editor "Kostenstelle" from table "(Account):(CostCenter)" with command "UPDATE" for record "1121" 	
    And I set field "gjahr" to "02"
	And I press button "ivkz" to open a subeditor for "Ist-Vkz" in row 0 
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
    Then field "vortrag" is modifiable
 #  Then field "saldo" is modifiable
    And I set field "s1" to "10"
    Then field "saldo" has value "3010.00"
    And I set field "h2" to "15"
    Then field "saldo" has value "3995.00"
    And I set field "vortrag" to "100.00"
    Then field "saldo" has value "4095.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
    And I set field "gjahr" to "03"
	And I press button "ivkz" to open a subeditor for "Ist-Vkz" in row 0 
	Then field "vortrag" has value "0.00"
    Then field "saldo" has value "12000.00"
    And I close the current editor
    
Scenario: Edit_VKZ_CostCenter_Wartung 
    Given I'm logged in with password "annette"
 # Istverkehrszahlen in Wartung ändern, gv = true           
    Given I open an editor "Kostenstelle" from table "(Account):(CostCenter)" with command "UPDATE" for record "1121V" 	
    And I set field "gjahr" to "02"
	And I press button "ivkz" to open a subeditor for "Ist-Vkz" in row 0 
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
    Then field "vortrag" is modifiable
 #  Then field "saldo" is modifiable
    And I set field "s1" to "10"
    Then field "saldo" has value "-90.00"
    And I set field "h2" to "15"
    Then field "saldo" has value "-105.00"
    And I set field "vortrag" to "100.00"
    Then field "saldo" has value "-5.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
    And I set field "gjahr" to "03"
	And I press button "ivkz" to open a subeditor for "Ist-Vkz" in row 0 
	Then field "vortrag" has value "-5.00"
    Then field "saldo" has value "-105.00"
    And I close the current editor
    And I switch the current editor to editor "Kostenstelle"
    And I close the current editor
        
        
Scenario: Edit_VKZ_CostCenter_Wartung2 
    Given I'm logged in with password "annette"
 # Istverkehrszahlen in Wartung ändern, gv = true           
    Given I open an editor "Kostenstelle" from table "(Account):(CostCenter)" with command "UPDATE" for record "1121V"   	
 	# 
 	And I press button "ivkv" to open a subeditor for "IstVollkostensatz-Vkz" in row 0 with dialog "2011" and answer "Ja" 
  	And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
    #
  	And I press button "pvkv" to open a subeditor for "PlanVollkostensatz-Vkz" in row 0 with dialog "2011" and answer "Ja"   
    And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
 	# 
 	And I press button "gikv" to open a subeditor for "IstGrenzkostensatz-Vkz" in row 0 with dialog "2011" and answer "Ja" 
  	And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
    #
  	And I press button "gpkv" to open a subeditor for "PlanGrenzkostensatz-Vkz" in row 0 with dialog "2011" and answer "Ja"   
    And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
 	# 
 	And I press button "fikv" to open a subeditor for "IstFixkostensatz-Vkz" in row 0 with dialog "2011" and answer "Ja" 
  	And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
    #
  	And I press button "fpkv" to open a subeditor for "PlanFixkostensatz-Vkz" in row 0 with dialog "2011" and answer "Ja"   
    And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
 	# 
 	And I press button "pfixabw" to open a subeditor for "Fixkostenabweichungssatz" in row 0 with dialog "2011" and answer "Ja" 
  	And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
    #
  	And I press button "vabw" to open a subeditor for "Verbrauchsabweichungsstz" in row 0 with dialog "2011" and answer "Ja"   
    And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
  	# 
 	And I press button "babw" to open a subeditor for "Besch�ftigungsabweichungsstz" in row 0 with dialog "2011" and answer "Ja" 
  	And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
    #
  	And I press button "ipr" to open a subeditor for "Prim�rkostenIst" in row 0 with dialog "2011" and answer "Ja"   
    And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
    #
  	And I press button "ige" to open a subeditor for "GesamtkostenIst" in row 0 with dialog "2011" and answer "Ja"   
    And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
     #
  	And I press button "pfpr" to open a subeditor for "PrimaerkostenFP" in row 0 with dialog "2011" and answer "Ja"   
    And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
    #
  	And I press button "pfge" to open a subeditor for "GesamtkostenFP" in row 0 with dialog "2011" and answer "Ja"   
    And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
    #
  	And I press button "pppr" to open a subeditor for "Prim�rkostenPP" in row 0 with dialog "2011" and answer "Ja"   
    And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
    #
  	And I press button "ppge" to open a subeditor for "GesamtkostenPP" in row 0 with dialog "2011" and answer "Ja"   
    And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
     #
  	And I press button "sopr" to open a subeditor for "Prim�rkostenSoll" in row 0 with dialog "2011" and answer "Ja"   
    And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
    #
  	And I press button "soge" to open a subeditor for "GesamtkostenSoll" in row 0 with dialog "2011" and answer "Ja"   
    And I respond with answer "Ja" to the dialog with id "2012"
 	And I save the current editor
    And I switch the current editor to editor "Kostenstelle"
    #
 	And I close the current editor
 	
 # Istverkehrszahlen in Wartung ändern, gv = false                 
    Given I open an editor "Kostentraeger" from table "(Account):(CostObject)" with command "UPDATE" for record "100000" 
    And I set field "gjahr" to "02"	
	And I press button "ivkz" to open a subeditor for "Istr-Vkz" in row 0
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
    Then field "vortrag" is modifiable
 #  Then field "saldo" is modifiable
    And I set field "s11" to "10"
    Then field "saldo" has value "23020.00"
    And I set field "h12" to "15"
    Then field "saldo" has value "23005.00"
    And I set field "vortrag" to "100.00"
    Then field "saldo" has value "23105.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "Kostentraeger"
    And I set field "gjahr" to "03"	
	And I press button "ivkz" to open a subeditor for "Ist-Vkz" in row 0
	Then field "vortrag" has value "23105.00"
	Then field "saldo" has value "23005.00"
	And I close the current editor
    And I switch the current editor to editor "Kostentraeger"
    And I close the current editor

# Istverkehrszahlen in Wartung ändern, gv = true                 
    Given I open an editor "Kostentraeger" from table "(Account):(CostObject)" with command "UPDATE" for record "100000V" 
    And I set field "gjahr" to "02"	
	And I press button "ivkz" to open a subeditor for "Istr-Vkz" in row 0
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
    Then field "vortrag" is modifiable
 #  Then field "saldo" is modifiable
    And I set field "s11" to "10"
    Then field "saldo" has value "-90.00"
    And I set field "h12" to "15"
    Then field "saldo" has value "-105.00"
    And I set field "vortrag" to "100.00"
    Then field "saldo" has value "-5.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "Kostentraeger"
    And I set field "gjahr" to "03"	
	And I press button "ivkz" to open a subeditor for "Ist-Vkz" in row 0
	Then field "vortrag" has value "0.00"
	Then field "saldo" has value "-100.00"
	And I close the current editor
    And I switch the current editor to editor "Kostentraeger"
    And I close the current editor    

Scenario: Edit_VKZ_CostType_Wartung 
    Given I'm logged in with password "annette"
Given I open an editor "Kostenart" from table "(CostType):(CostType)" with command "UPDATE" for record "400" 	
	And I press button "ivkz" to open a subeditor for "Ist-Vkz" in row 0 
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
    Then field "vortrag" is modifiable
 #  Then field "saldo" is modifiable
    And I set field "s1" to "10"
    Then field "saldo" has value "-190.00"
    And I set field "h2" to "15"
    Then field "saldo" has value "-205.00"
    And I set field "vortrag" to "100.00"
    Then field "saldo" has value "-105.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "Kostenart"
    And I set field "gjahr" to "03"	
   	And I press button "ivkz" to open a subeditor for "Ist-Vkz" in row 0 
   	Then field "saldo" has value "-300.00"
    And I close the current editor

# Istverkehrszahlen in Wartung ändern, gv = false, d.h., Vortrag ber�cksichtigen  
# Da die Datenart bei BAB-Feldern Istko ist (und nicht Ist) wird der Vortrag nicht ber�cksichtigt
Scenario: Edit_VKZ_EDS_Wartung_Actual 
    Given I'm logged in with password "annette"
    Given I open an editor "BABFORMULAR" from table "(EDS):(EDS)" with command "UPDATE" for record "200" 	
    And I set field "gjahr" to "02"	
    And I set field "skoobj" to "1121V"	
	And I press button "istkost" to open a subeditor for "Ist-Vkz" in row 1
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
    Then field "vortrag" is modifiable
    Then field "saldo" is not modifiable
    And I set field "s1" to "10"
    Then field "saldo" has value "-90.00"
    Then field "sa1" has value "10.00"
    And I set field "h2" to "15"
    Then field "sa2" has value "-15.00"
    Then field "saldo" has value "-105.00"
    And I set field "vortrag" to "100.00"
    Then field "saldo" has value "-5.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "BABFORMULAR"
    And I close the current editor
    
# Planverkehrszahlen in Wartung ändern, gv = false, d.h., Vortrag ber�cksichtigen  
# Aber: Vortraege werden bei Planzahlen nicht ber�cksichtigt.
Scenario: Edit_VKZ_EDS_Wartung_Plan 
    Given I'm logged in with password "annette"
    Given I open an editor "BABFORMULAR" from table "(EDS):(EDS)" with command "UPDATE" for record "200" 	
    And I set field "gjahr" to "02"	
    And I set field "skoobj" to "1121V"	
	And I press button "planfix" to open a subeditor for "Plan-Vkz" in row 1 with dialog "2011" and answer "Ja"
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
    Then field "s11" is modifiable
    Then field "s12" is modifiable
    Then field "s13" is modifiable
    Then field "s14" is modifiable
    Then field "s15" is modifiable
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
    Then field "vortrag" is modifiable
    Then field "saldo" is not modifiable
    And I set field "s11" to "10"
    Then field "saldo" has value "10.00"
    Then field "sa11" has value "10.00"
    And I set field "h12" to "15"
    Then field "sa12" has value "-15.00"
    Then field "saldo" has value "-5.00"
    And I set field "vortrag" to "100.00"
    Then field "saldo" has value "95.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "BABFORMULAR"
    And I set field "gjahr" to "03"	
    And I set field "skoobj" to "1121V"	
    And I press button "planfix" to open a subeditor for "Plan-Vkz" in row 1 with dialog "2011" and answer "Ja"
    Then field "saldo" has value "95.00"
    And I set field "s1" to "10"
    Then field "saldo" has value "105.00"
    Then field "sa1" has value "10.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "BABFORMULAR"
    And I set field "gjahr" to "02"	
    And I set field "skoobj" to "1121V"	
    And I press button "planfix" to open a subeditor for "Plan-Vkz" in row 1
    And I set field "s12" to "10"
    Then field "saldo" has value "105.00"
    And I close the current editor
    And I switch the current editor to editor "BABFORMULAR"
    And I set field "gjahr" to "03"	
    And I set field "skoobj" to "1121V"	
    And I press button "planfix" to open a subeditor for "Plan-Vkz" in row 1
    Then field "vortrag" has value "95.00"
    And I close the current editor
    And I switch the current editor to editor "BABFORMULAR"
    And I close the current editor

        
Scenario: Edit_VKZ_Assessment_Wartung 
    Given I open an editor "Umlage" from table "(Assessment):(CostCenterAssessment)" with command "UPDATE" for record "1121" 	
    And I set field "gjahr" to "02"
	And I press button "kszuist" to open a subeditor for "Ist-Vkz" in row 1
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
    Then field "s11" is modifiable
    Then field "s12" is modifiable
    Then field "abkos1" is not modifiable
    Then field "abkos2" is not modifiable
    Then field "abkos3" is not modifiable
    Then field "abkos4" is not modifiable
    Then field "abkos5" is not modifiable
    Then field "abkos6" is not modifiable
    Then field "abkos7" is not modifiable
    Then field "abkos8" is not modifiable
    Then field "abkos9" is not modifiable
    Then field "abkos10" is not modifiable
    Then field "abkos11" is not modifiable
    Then field "abkos12" is not modifiable
    Then field "saldo" is not modifiable
    And I set field "s11" to "10.00"
    Then field "abkos11" has value "90.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "Umlage"
    And I press button "kszupfix" to open a subeditor for "FixePlan-Vkz" in row 1
    Then field "abkos1" has value "0.00"
    And I close the current editor
