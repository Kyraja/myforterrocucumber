# *****************************************************************************
#  Name           : ref_koedit_postedit_ok.feature
#  Autor          : Gisela Koehne
#  Verantwortlich : uo
#  Kontrolle      : hc
#  Funktion       : Editieren des Sachkontenstammes, Maskenpr�ffunktion            
#
# *****************************************************************************
@persistent
Feature: REWE-2464
Background:
Given I set the fake date to "31.12.2002"

Scenario: VALIDATE namebspr gefuellt
	Given I open an editor "Konto_301" from table "(Account):(Account)" with command "NEW" for record ""
	And I set field "nummer" to "301"
	And I set field "such" to "K_301X"
	Then saving the current editor throws the exception "73"
	And I set field "namebspr" to "K_301X"
	And I save the current editor
	And I close the current editor
	
Scenario: VALIDATE karta steuer gefuellt
	Given I open an editor "Konto_302" from table "(Account):(Account)" with command "NEW" for record ""
	And I set field "nummer" to "302"
	And I set field "such" to "K_302X"
	And I set field "namebspr" to "K_3012"
	And I set field "karta" to "steuer"
	Then saving the current editor throws the exception "279"
	And I set field "ev" to "Einkauf"
	And I set field "steuersts" to "0"
	Then saving the current editor throws the exception "208"
	And I set field "steuersts" to "1"
	And I save the current editor
	And I close the current editor
	
Scenario: VALIDATE ev steuerlogik gefuellt
	Given I open an editor "Konto_303" from table "(Account):(Account)" with command "COPY" for record "47365"
	And I set field "nummer" to "303"
	And I set field "such" to "K_303X"
	And I set field "namebspr" to "K_303X"
	And I set field "ev" to ""
	Then saving the current editor throws the exception "234"
	And I set field "ev" to "Verkauf"
	And I save the current editor
	And I close the current editor
	
Scenario: VALIDATE konetto nichtleer bei brutto
	Given I open an editor "Konto_304" from table "(Account):(Account)" with command "UPDATE" for record "44000B"
	And I set field "netto" to ""
	Then saving the current editor throws the exception "57"
	And I set field "netto" to "44000"
	And I save the current editor
	And I close the current editor

Scenario: VALIDATE konetto nicht gefuellt bei netto
	Given I open an editor "Konto_305" from table "(Account):(Account)" with command "UPDATE" for record "44000C"
	And I set field "kenn" to "ABC"
	Then saving the current editor throws the exception "261"
	And I close the current editor

Scenario: VALIDATE steuer keine ktostrgl
	Given I open an editor "Konto_306" from table "(Account):(Account)" with command "UPDATE" for record "14060C"
	And I set field "kenn" to "ABC"
	Then saving the current editor throws the exception "1920"
	And I close the current editor
	
Scenario: VALIDATE brutto mit falschem netto
	Given I open an editor "Konto_307" from table "(Account):(Account)" with command "UPDATE" for record "44000D"
	And I set field "kenn" to "ABC"
	Then saving the current editor throws the exception "234"
	And I close the current editor
	
Scenario: VALIDATE nicht gv aber kost oder hkost
	Given I open an editor "Konto_308" from table "(Account):(Account)" with command "NEW" for record ""
	And I set field "nummer" to "308"
	And I set field "such" to "K_308X"
	And I set field "namebspr" to "K_308X"
	And I set field "gv" to "true"
	And I set field "kost" to "true"
	And I set field "hkost" to "true"
	And I set field "gv" to "false"
	Then saving the current editor throws the exception "2387"
	And I close the current editor

Scenario: VALIDATE nicht gv aber kost oder hkost
	Given I open an editor "Konto_309" from table "(Account):(Account)" with command "NEW" for record ""
	And I set field "nummer" to "309"
	And I set field "such" to "K_309X"
	And I set field "namebspr" to "K_309X"
	And I set field "gv" to "true"
    And I set field "kstelle" to "100"
	And I set field "gv" to "false"
	Then saving the current editor throws the exception "1893"
	And I close the current editor

Scenario: VALIDATE gv und kokost, aber nicht bebuchbar
	Given I open an editor "Konto_307" from table "(Account):(Account)" with command "UPDATE" for record "44000E"
	And I set field "kenn" to "ABC"
	Then saving the current editor throws the exception "3823"
	And I close the current editor

Scenario: VALIDATE Statistisches Konto mit ev
	Given I open an editor "Konto_310" from table "(Account):(Account)" with command "NEW" for record ""
	And I set field "nummer" to "310"
	And I set field "such" to "K_310X"
	And I set field "namebspr" to "K_310X"
	And I set field "gv" to "true"
	And I set field "stata" to "Entlastung sek. Kosten"
	And I set field "ev" to "Einkauf"
	Then saving the current editor throws the exception "1673"
	And I close the current editor
	
Scenario: VALIDATE Statistisches Konto mit gefuellter Kontenart
	Given I open an editor "Konto_311" from table "(Account):(Account)" with command "NEW" for record ""
	And I set field "nummer" to "311"
	And I set field "such" to "K_311X"
	And I set field "namebspr" to "K_311X"
	And I set field "gv" to "true"
	And I set field "karta" to "Geldtransit"
	And I set field "stata" to "Entlastung sek. Kosten"
	Then saving the current editor throws the exception "7122"
	And I close the current editor

Scenario: VALIDATE Statistisches Konto ohne gv
	Given I open an editor "Konto_312" from table "(Account):(Account)" with command "NEW" for record ""
	And I set field "nummer" to "312"
	And I set field "such" to "K_312X"
	And I set field "namebspr" to "K_312X"
	And I set field "gv" to "true"
	And I set field "stat" to "Entlastung sek. Kosten"
	And I set field "gv" to "false"
	Then saving the current editor throws the exception "3080"
	And I close the current editor
	
Scenario: VALIDATE Kassenkonto muss Bilanzkonto sein
	Given I open an editor "Konto_313" from table "(Account):(Account)" with command "COPY" for record "16000"
	And I set field "nummer" to "313"
	And I set field "such" to "K_313X"
	And I set field "gv" to "true"
	Then saving the current editor throws the exception "260"
	And I close the current editor	

Scenario: VALIDATE Kursdifferenzkonto muss GuV_Konto sein
	Given I open an editor "Konto_314" from table "(Account):(Account)" with command "COPY" for record "48400"
	And I set field "nummer" to "314"
	And I set field "such" to "K_314X"
	And I set field "gv" to "false"
	Then saving the current editor throws the exception "259"
	And I close the current editor	

Scenario: VALIDATE Rundungsdifferenzkonto muss GuV_Konto sein
	Given I open an editor "Konto_315" from table "(Account):(Account)" with command "COPY" for record "48420"
	And I set field "nummer" to "315"
	And I set field "such" to "K_315X"
	And I set field "gv" to "false"
	Then saving the current editor throws the exception "259"
	And I close the current editor	
	
Scenario: VALIDATE keine Kontosteuerregel bei Kursdifferenz und Rundungsdifferenzkonten
	Given I open an editor "Konto_316" from table "(Account):(Account)" with command "COPY" for record "44000"
	And I set field "nummer" to "316"
	And I set field "such" to "K_316X"
	And I set field "karta" to "Rundungsdifferenzkonto"
	Then saving the current editor throws the exception "7604"
	And I close the current editor	
	
Scenario: VALIDATE Bankkonto muss Bilanzkonto sein
	Given I open an editor "Konto_317" from table "(Account):(Account)" with command "NEW" for record ""
	And I set field "nummer" to "317"
	And I set field "such" to "K_317X"
	And I set field "namebspr" to "K_317X"
	And I set field "karta" to "Bankkonto"
	And I set field "gv" to "true"
	Then saving the current editor throws the exception "260"
	And I close the current editor		
	
Scenario: VALIDATE keine Kontosteuerregel bei Bankkonten
	Given I open an editor "Konto_318" from table "(Account):(Account)" with command "COPY" for record "44000"
	And I set field "nummer" to "318"
	And I set field "such" to "K_318X"
	And I set field "karta" to "Bankkonto"
	And I set field "kost" to "false"
	And I set field "gv" to "false"
	Then saving the current editor throws the exception "187"
	And I close the current editor	

Scenario: VALIDATE Geldtransitkonto muss oprelevvant sein
	Given I open an editor "Konto_319" from table "(Account):(Account)" with command "COPY" for record "14601"
	And I set field "nummer" to "319"
	And I set field "such" to "K_319X"
	And I set field "oprel" to "false"
	Then saving the current editor throws the exception "4875"
	And I close the current editor
	
Scenario: VALIDATE Geldtransitkonto muss Zahlungsart haben
	Given I open an editor "Konto_320" from table "(Account):(Account)" with command "COPY" for record "14601"
	And I set field "nummer" to "320"
	And I set field "such" to "K_320X"
	And I set field "zaform" to ""
	Then saving the current editor throws the exception "6399"
	And I close the current editor
	
Scenario: VALIDATE keine Kontosteuerregel bei Bankkonten
	Given I open an editor "Konto_321" from table "(Account):(Account)" with command "COPY" for record "18100"
	And I set field "nummer" to "321"
	And I set field "such" to "K_321X"
	And I set field "karta" to "Bankkonto"
	And I set field "oprel" to "true"
	Then saving the current editor throws the exception "6400"
	And I close the current editor	

Scenario: VALIDATE keine Kontosteuerregel bei Bankkonten
	Given I open an editor "Konto_322" from table "(Account):(Account)" with command "COPY" for record "18100"
	And I set field "nummer" to "322"
	And I set field "such" to "K_322X"
	And I set field "karta" to "Verrechnungskonto"
	And I set field "oprel" to "true"
	Then saving the current editor throws the exception "5604"
	And I close the current editor	

Scenario: VALIDATE Bankverbindung nicht bei Konten mit leerer karta
	Given I open an editor "Konto_323" from table "(Account):(Account)" with command "UPDATE" for record "14601"
	And I set field "karta" to ""
	Then saving the current editor throws the exception "6443"
	And I close the current editor	
	
Scenario: Button kogjahr
	Given I open an editor "Konto_324" from table "(Account):(Account)" with command "VIEW" for record "44000"
	And I respond with answer "3" to the dialog with id "Geschäftsjahr"
	And I press button "bgjahr"
	And I close the current editor	

Scenario: Button kobwaehr
	Given I open an editor "Konto_325" from table "(Account):(Account)" with command "VIEW" for record "44000"
	And I respond with answer "3" to the dialog with id "Währung"
	And I press button "bwaehr"
	And I close the current editor	

Scenario: Konto loeschen Verwendung im Kassenbuch
	Given I open an editor "Kassenbuch" from table "(CashBook):(CashBook)" with command "NEW" for record ""
	And I set field "nummer" to "1"
	And I set field "kasskto" to "16001"
 	And I create a new row at the end of the table
 	And I set field "beldat" to "1.12.02" in row 1
	And I set field "beinn" to "15" in row 1
	And I set field "gkonto" to "44000F" in row 1
	And I set field "kstelle" to "104" in row 1
    And I save the current editor
	And I close the current editor	

	Given I open an editor "Konto_326" from table "(Account):(Account)" with command "DELETE" for record "16001"
	Then saving the current editor throws the exception "7260"
	And I close the current editor	
	
    Given I open an editor "Konto_327" from table "(Account):(Account)" with command "DELETE" for record "44000F"
	Then saving the current editor throws the exception "7260"
	And I close the current editor	
	
	Given I open an editor "Konto_328" from table "(Account):(CostCenter)" with command "DELETE" for record "104"
	Then saving the current editor throws the exception "7260"
	And I close the current editor

Scenario: Konto loeschen Planverkehrszahlen vorhanden	
	Given I open an editor "Konto_329" from table "(Account):(Account)" with command "UPDATE" for record "16002" 	
	And I press button "pvkz" to open a subeditor for "Plan-Vkz" in row 0 with dialog "2011" and answer "Ja"
	And I set field "s1" to "10"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "Konto_329"
    And I save the current editor
    And I close the current editor
    
    Given I open an editor "Konto_330" from table "(Account):(Account)" with command "DELETE" for record "16002"
    And I respond with answer "Nein" to the dialog with id "2579"
	Then saving the current editor throws the exception "2743"
	And I close the current editor
	
	Given I open an editor "Konto_331" from table "(Account):(Account)" with command "DELETE" for record "16002"
    And I respond with answer "Ja" to the dialog with id "2579"
    And I respond with answer "ja" to the dialog with id "826"
    And I save the current editor
	And I close the current editor
	
Scenario: KSt loeschen Planverkehrszahlen vorhanden
    Given I open an editor "Konto_332" from table "(Account):(CostCenter)" with command "UPDATE" for record "105"
	And I press button "pvkz" to open a subeditor for "Plan-Vkz" in row 0 with dialog "2011" and answer "Ja"
	And I set field "s1" to "10"
    And I respond with answer "Ja" to the dialog with id "2012"
    And I save the current editor
    And I switch the current editor to editor "Konto_332"
	And I save the current editor
    And I close the current editor
    
    Given I open an editor "Konto_333" from table "(Account):(CostCenter)" with command "DELETE" for record "105"
    And I respond with answer "Nein" to the dialog with id "2579"
	Then saving the current editor throws the exception "2743"
	And I close the current editor
	
	Given I open an editor "Konto_334" from table "(Account):(CostCenter)" with command "DELETE" for record "105"
    And I respond with answer "Ja" to the dialog with id "2579"
    And I respond with answer "Ja" to the dialog with id "826"
    And I save the current editor
	And I close the current editor
	
Scenario: Verdichtungskonto (ohne statistische Kontenart) erstellen und ein ein statistisches Konto eintragen
    Given I open an editor "Konto_335" from table "(Account):(Account)" with command "NEW" for record ""
    And I set field "nummer" to "99V"
	And I set field "such" to "VERD1"
	And I set field "namebspr" to "K_99V"
    And I set field "bu" to "nein"
    And I set field "gv" to "nein"
    And I save the current editor
    And I close the current editor
    Given I open an editor "Konto_335" from table "(Account):(Account)" with command "NEW" for record ""
    And I set field "nummer" to "99X"
	And I set field "such" to "STAT"
	And I set field "namebspr" to "K_99X"
    And I set field "stata" to "Kostenrechnung"
    And I set field "verd" to "99V"
    Then saving the current editor throws the exception "1402"
    And I close the current editor

