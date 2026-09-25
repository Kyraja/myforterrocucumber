@persistant
Feature: Edit of the transactionFigures
Background:
Given I set the fake date to "02.01.1995"

Scenario: Edit_VKZ_Kunde

# Verkehrszahlen bei einem Kunden (Maske 114)
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "200"
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
    And I switch the current editor to editor "Kunde"
    And I close the current editor

# Planverkehrszahlen           
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "200" 	
	And I press button "pvkz" to open a subeditor for "Plan-Vkz" in row 0 with dialog "2011" and answer "Ja"
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
    Then field "saldo" is not modifiable
    And I set field "s1" to "10"
    Then field "saldo" has value "10.00"
    And I set field "h2" to "15"
    Then field "saldo" has value "-5.00"
    And I set field "vortrag" to "100.00"
    Then field "saldo" has value "95.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "Kunde"
    And I close the current editor
#
# Umsatzzahlen bei einem Kunden (Maske 115)
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "200"
# Ist Verkehrszahlen     
    And I press button "iuz" to open a subeditor for "Ist-UZ"
    Then field "u1" is not modifiable
    Then field "u2" is not modifiable
    Then field "u3" is not modifiable
    Then field "u4" is not modifiable
    Then field "u5" is not modifiable
    Then field "u6" is not modifiable
    Then field "u7" is not modifiable
    Then field "u8" is not modifiable
    Then field "u9" is not modifiable
    Then field "u10" is not modifiable
    Then field "u11" is not modifiable
    Then field "u12" is not modifiable
    Then field "pums" is not modifiable
    Then field "pums2" is not modifiable
    Then field "pums3" is not modifiable
    Then field "pums4" is not modifiable
    Then field "eums" is not modifiable
    And I close the current editor
    And I switch the current editor to editor "Kunde"
    And I close the current editor

# Planverkehrszahlen           
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "200" 	
	And I press button "puz" to open a subeditor for "Plan-Vkz" in row 0
    Then field "u1" is modifiable
    Then field "u2" is modifiable
    Then field "u3" is modifiable
    Then field "u4" is modifiable
    Then field "u5" is modifiable
    Then field "u6" is modifiable
    Then field "u7" is modifiable
    Then field "u8" is modifiable
    Then field "u9" is modifiable
    Then field "u10" is modifiable
    Then field "u11" is modifiable
    Then field "u12" is modifiable
    Then field "pums" is not modifiable
    Then field "pums2" is not modifiable
    Then field "pums3" is not modifiable
    Then field "pums4" is not modifiable
    Then field "eums" is not modifiable
    And I set field "u1" to "10"
    Then field "pums" has value "10.00"
    Then field "eums" has value "10.00"
    And I set field "u5" to "15"
    Then field "pums2" has value "15.00"
    Then field "eums" has value "25.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "Kunde"
    And I close the current editor
#
#
Scenario: Edit_VKZ_Lieferant
#
# Verkehrszahlen bei einem Lieferant (Maske 117)
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record "500"
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
    And I switch the current editor to editor "Lieferant"
    And I close the current editor

# Planverkehrszahlen           
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record "500" 	
	And I press button "pvkz" to open a subeditor for "Plan-Vkz" in row 0 with dialog "2011" and answer "Ja"
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
 #   Then field "saldo" is modifiable
    And I set field "s1" to "10"
    Then field "saldo" has value "10.00"
    And I set field "h2" to "15"
    Then field "saldo" has value "-5.00"
    And I set field "vortrag" to "100.00"
    Then field "saldo" has value "95.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor
#
#
# Umsatzzahlen bei einem Lieferanten (Maske 118)
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record "500"
# Ist Verkehrszahlen     
    And I press button "iuz" to open a subeditor for "Ist-UZ"
    Then field "u1" is not modifiable
    Then field "u2" is not modifiable
    Then field "u3" is not modifiable
    Then field "u4" is not modifiable
    Then field "u5" is not modifiable
    Then field "u6" is not modifiable
    Then field "u7" is not modifiable
    Then field "u8" is not modifiable
    Then field "u9" is not modifiable
    Then field "u10" is not modifiable
    Then field "u11" is not modifiable
    Then field "u12" is not modifiable
    Then field "pums" is not modifiable
    Then field "pums2" is not modifiable
    Then field "pums3" is not modifiable
    Then field "pums4" is not modifiable
    Then field "eums" is not modifiable
    And I close the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor

# Planverkehrszahlen           
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record "500" 	
	And I press button "puz" to open a subeditor for "Plan-Vkz" in row 0
    Then field "u1" is modifiable
    Then field "u2" is modifiable
    Then field "u3" is modifiable
    Then field "u4" is modifiable
    Then field "u5" is modifiable
    Then field "u6" is modifiable
    Then field "u7" is modifiable
    Then field "u8" is modifiable
    Then field "u9" is modifiable
    Then field "u10" is modifiable
    Then field "u11" is modifiable
    Then field "u12" is modifiable
    Then field "pums" is not modifiable
    Then field "pums2" is not modifiable
    Then field "pums3" is not modifiable
    Then field "pums4" is not modifiable
    Then field "eums" is not modifiable
    And I set field "u1" to "10"
    Then field "pums" has value "10.00"
    Then field "eums" has value "10.00"
    And I set field "u5" to "15"
    Then field "pums2" has value "15.00"
    Then field "eums" has value "25.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor
#
Scenario: Edit_VKZ_Account
#
# Verkehrszahlen bei einem Sachkonto (Maske 122)
    Given I open an editor "Konto" from table "(Account):(Account)" with command "UPDATE" for record "54000"
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
    And I switch the current editor to editor "Konto"
    And I close the current editor

# Planverkehrszahlen           
    Given I open an editor "Sachkonto" from table "(Account):(Account)" with command "UPDATE" for record "54000" 	
	And I press button "pvkz" to open a subeditor for "Plan-Vkz" in row 0 with dialog "2011" and answer "Ja"
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
 #   Then field "saldo" is modifiable
    And I set field "s1" to "10"
    Then field "saldo" has value "10.00"
    And I set field "h2" to "15"
    Then field "saldo" has value "-5.00"
    And I set field "vortrag" to "100.00"
    Then field "saldo" has value "95.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "Sachkonto"
    And I close the current editor

    # Szenarien zum Editieren von Ist-Verkehrszahlen in Wartung
 Scenario: Edit_VKZ_Customer_Wartung
    Given I'm logged in with password "annette"
 Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "200" 	
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
    Then field "saldo" is not modifiable
    And I set field "s1" to "10"
    Then field "saldo" has value "-3587983.39"
    And I set field "h2" to "15"
    Then field "saldo" has value "-3587998.39"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "Kunde"
    And I close the current editor

    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "200" 	
	And I press button "iuz" to open a subeditor for "Ist-Vkz" in row 0
    Then field "u1" is modifiable
    Then field "u2" is modifiable
    Then field "u3" is modifiable
    Then field "u4" is modifiable
    Then field "u5" is modifiable
    Then field "u6" is modifiable
    Then field "u7" is modifiable
    Then field "u8" is modifiable
    Then field "u9" is modifiable
    Then field "u10" is modifiable
    Then field "u11" is modifiable
    Then field "u12" is modifiable
    Then field "pums" is not modifiable
    Then field "pums2" is not modifiable
    Then field "pums3" is not modifiable
    Then field "pums4" is not modifiable
    Then field "eums" is not modifiable
    And I set field "u1" to "10"
    Then field "pums" has value "-654388.99"
    Then field "eums" has value "-654388.99"
    And I set field "u5" to "15"
    Then field "pums2" has value "15.00"
    Then field "eums" has value "-654373.99"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "Kunde"
    And I close the current editor
        
Scenario: Edit_VKZ_Vendor_Wartung  
    Given I'm logged in with password "annette" 
 # Istverkehrszahlen           
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record "500" 	
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
 #   Then field "saldo" is modifiable
    And I set field "s1" to "10.00"
    Then field "saldo" has value "-7369.33"
    And I set field "h2" to "15.00"
    Then field "saldo" has value "-7384.33"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor

    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record "500" 
	And I press button "iuz" to open a subeditor for "Ist-Umsatzz�hler" in row 0
    Then field "u1" is modifiable
    Then field "u2" is modifiable
    Then field "u3" is modifiable
    Then field "u4" is modifiable
    Then field "u5" is modifiable
    Then field "u6" is modifiable
    Then field "u7" is modifiable
    Then field "u8" is modifiable
    Then field "u9" is modifiable
    Then field "u10" is modifiable
    Then field "u11" is modifiable
    Then field "u12" is modifiable
    Then field "pums" is not modifiable
    Then field "pums2" is not modifiable
    Then field "pums3" is not modifiable
    Then field "pums4" is not modifiable
    Then field "eums" is not modifiable
    And I set field "u1" to "10"
    Then field "pums" has value "10.00"
    Then field "eums" has value "10.00"
    And I set field "u5" to "15"
    Then field "pums2" has value "15.00"
    Then field "eums" has value "25.00"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor
        
Scenario: Edit_VKZ_Account_Wartung 
    Given I'm logged in with password "annette"
    Given I open an editor "Sachkonto" from table "(Account):(Account)" with command "UPDATE" for record "54000" 	
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
    And I set field "s1" to "10"
    Then field "saldo" has value "-859.57"
    And I set field "h2" to "15"
    Then field "saldo" has value "-874.57"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "Sachkonto"
    And I close the current editor
    
    # Szenarien zum Editieren von Ist-Verkehrszahlen im alten Jahr in Wartung (Test Weitergabe der VortragsÄnderung)
 Scenario: Edit_VKZ_Customer_Wartung_oldYear
    Given I'm logged in with password "annette"
 	Given I open an editor "KundeWOld" from table "(Customer):(Customer)" with command "UPDATE" for record "200" 	
 	And I set field "gjahr" to "94"
	And I press button "ivkz" to open a subeditor for "Ist-Vkz"
	Then field "saldo" has value "-11499.99"
	And I set field "vortrag" to "100"
	And I set field "s1" to "10"
	Then field "saldo" has value "-11389.99"
 	And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor  
    And I switch the current editor to editor "KundeWOld"
    And I set field "gjahr" to "95"
    And I press button "ivkz" to open a subeditor for "Ist-Vkz"
    Then field "vortrag" has value "-11389.99" 
    And I close the current editor
    And I switch the current editor to editor "KundeWOld"
    And I close the current editor

    
    Scenario: Edit_VKZ_Vendor_Wartung_oldYear  
    Given I'm logged in with password "annette" 
 # Istverkehrszahlen           
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record "500" 	
    And I set field "gjahr" to "94"
	And I press button "ivkz" to open a subeditor for "Ist-Vkz" in row 0 with dialog "2011" and answer "Ja"
	And I set field "vortrag" to "100"
	And I set field "s1" to "10"
	Then field "saldo" has value "110.00"
 	And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor  
    And I switch the current editor to editor "Lieferant"
    And I set field "gjahr" to "95"
    And I press button "ivkz" to open a subeditor for "Ist-Vkz"
    Then field "vortrag" has value "110.00" 
    And I close the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor
    
    Scenario: Edit_VKZ_PL_Account_Wartung_oldYear 
    Given I'm logged in with password "annette"
    Given I open an editor "Sachkonto" from table "(Account):(Account)" with command "UPDATE" for record "54000" 	
	And I set field "gjahr" to "94"
	And I press button "ivkz" to open a subeditor for "Ist-Vkz" in row 0 with dialog "2011" and answer "Ja"
	And I set field "vortrag" to "100"
	And I set field "s1" to "10"
	Then field "saldo" has value "110.00"
 	And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor  
    And I switch the current editor to editor "Sachkonto"
    And I set field "gjahr" to "95"
    And I press button "ivkz" to open a subeditor for "Ist-Vkz"
    Then field "vortrag" has value "0.00" 
    And I close the current editor
    And I switch the current editor to editor "Sachkonto"
    And I close the current editor

    Scenario: Edit_VKZ_Gen_Account_Wartung_oldYear 
    Given I'm logged in with password "annette"
    Given I open an editor "Sachkonto" from table "(Account):(Account)" with command "UPDATE" for record "18100" 	
	And I set field "gjahr" to "94"
	And I press button "ivkz" to open a subeditor for "Ist-Vkz" in row 0 with dialog "2011" and answer "Ja"
	And I set field "vortrag" to "100"
	And I set field "s1" to "10"
	Then field "saldo" has value "110.00"
 	And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor  
    And I switch the current editor to editor "Sachkonto"
    And I set field "gjahr" to "95"
	And I press button "ivkz" to open a subeditor for "Ist-Vkz" in row 0 with dialog "2011" and answer "Ja"
    Then field "vortrag" has value "110.00" 
    And I set field "s1" to "10"
  	And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "Sachkonto"
   	And I set field "gjahr" to "94"
	And I press button "ivkz" to open a subeditor for "Ist-Vkz" in row 0
	And I set field "vortrag" to "200"
	And I set field "s1" to "20"
	Then field "saldo" has value "220.00"
 	And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor  
    And I switch the current editor to editor "Sachkonto"
    And I set field "gjahr" to "95"
	And I press button "ivkz" to open a subeditor for "Ist-Vkz" in row 0
    Then field "vortrag" has value "220.00" 
    And I close the current editor
    And I switch the current editor to editor "Sachkonto"
    And I close the current editor
    

#
Scenario: Edit_VKZ_Part
#
# Verkehrszahlen bei einer Artikel (Maske 121), 
  Given I open an editor "Artikel" from table "(Part):(Product)" with command "UPDATE" for record "1000"
# Ist Verkehrszahlen     
    And I press button "ibw" to open a subeditor for "Ist-Vkz"
    Then field "zm1" is not modifiable
    Then field "zm2" is not modifiable
    Then field "zm3" is not modifiable
    Then field "zm4" is not modifiable
    Then field "zm5" is not modifiable
    Then field "zm6" is not modifiable
    Then field "zm7" is not modifiable
    Then field "zm8" is not modifiable
    Then field "zm9" is not modifiable
    Then field "zm10" is not modifiable
    Then field "zm11" is not modifiable
    Then field "zm12" is not modifiable
    Then field "am1" is not modifiable
    Then field "am2" is not modifiable
    Then field "am3" is not modifiable
    Then field "am4" is not modifiable
    Then field "am5" is not modifiable
    Then field "am6" is not modifiable
    Then field "am7" is not modifiable
    Then field "am8" is not modifiable
    Then field "am9" is not modifiable
    Then field "am10" is not modifiable
    Then field "am11" is not modifiable
    Then field "am12" is not modifiable
    Then field "pzm" is not modifiable
    Then field "pzm2" is not modifiable
    Then field "pzm3" is not modifiable
    Then field "pzm4" is not modifiable
    Then field "jzu" is not modifiable
    Then field "pam" is not modifiable
    Then field "pam2" is not modifiable
    Then field "pam3" is not modifiable
    Then field "pam4" is not modifiable
    Then field "jab" is not modifiable
    And I close the current editor
    And I switch the current editor to editor "Artikel"
    And I close the current editor

  # Planverkehrszahlen           
    Given I open an editor "Artikel" from table "(Part):(Product)" with command "UPDATE" for record "1000"
	And I press button "pbw" to open a subeditor for "Plan-Vkz" in row 0 with dialog "2011" and answer "Ja"
	Then field "zm1" is modifiable
    Then field "zm2" is modifiable
    Then field "zm3" is modifiable
    Then field "zm4" is modifiable
    Then field "zm5" is modifiable
    Then field "zm6" is modifiable
    Then field "zm7" is modifiable
    Then field "zm8" is modifiable
    Then field "zm9" is modifiable
    Then field "zm10" is modifiable
    Then field "zm11" is modifiable
    Then field "zm12" is modifiable
    Then field "am1" is modifiable
    Then field "am2" is modifiable
    Then field "am3" is modifiable
    Then field "am4" is modifiable
    Then field "am5" is modifiable
    Then field "am6" is modifiable
    Then field "am7" is modifiable
    Then field "am8" is modifiable
    Then field "am9" is modifiable
    Then field "am10" is modifiable
    Then field "am11" is modifiable
    Then field "am12" is modifiable
    Then field "pzm" is not modifiable
    Then field "pzm2" is not modifiable
    Then field "pzm3" is not modifiable
    Then field "pzm4" is not modifiable
    Then field "jzu" is not modifiable
    Then field "pam" is not modifiable
    Then field "pam2" is not modifiable
    Then field "pam3" is not modifiable
    Then field "pam4" is not modifiable
    Then field "jab" is not modifiable
    And I set field "zm1" to "200"
    Then field "pzm" has value "200"
    Then field "jzu" has value "200"
    And I set field "zm5" to "500"
    Then field "pzm2" has value "500"
    Then field "jzu" has value "700"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "Artikel"
    And I close the current editor    

