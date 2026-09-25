@persistent
Feature: kostenobjekt_sperren_im_fevorschlag

Background:
And I set the fake date to "03.02.2002"

# *****************************************************************************
#  Autor            : uo
#  Verantwortlich   : uo
#  Kontrolle        : 
#  Funktion         : Rechungswesensperren in Fertigungsvorschlägen
#  Jira-Issue       : BW2-2070 + BW2-2094
# *****************************************************************************

Scenario: gesperrte kst in FV - freigabe testen

    # -------- sperrfähige kostenstelle anlegen ---------
	Given I open an editor "freie_Kostenstelle" from table "(Account):(CostCenter)" with command "COPY" for record "111"
	And I set field "nummer" to "211"
	And I save the current editor


    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | kstelle | mfreig |
      | BG1       | 10     |   211   | nein   |
    And I save the current editor


	Given I open an editor "Kstelle1-sperren" from table "(Account):(CostCenter)" with command "UPDATE" for record "211"
	And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
	And I save the current editor
 	Given I open an editor "Kostenstelle-absichern" from table "(Account):(CostCenter)" with command "VIEW" for record "211"
    Then field "sperrkonfigurationneu" has value "Standard-Kostenstellensperre"
 	And I close the current editor

#
# @uo: Dieser Test funktioniert so nicht mehr. Wenn die Sperre sitzt, ist das Feld schreibgeschützt
#
#	Given I open an editor "fvor2_upd" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
#	And I set field "artikel" to "BG1"
#	And I press button "ladetab"
#	And I press button "malle"
#	Then pressing button "freig" in row 0 to open a subeditor throws the exception "4806"
#	Then saving the current editor throws the exception "4806"
#	And I close the current editor
#

# anmerk. uo:
# vorher wurde beim freigben explizit die Fehlermeldung 4806 angezeigt/ausgegeben
# jetzt kommt gar keine meldung mehr. nur das feld mfreig ist schreibgeschützt
# früher war es verständlicher und damit besser, aber das verhalten dieses editors 
# ist letztlich entscheidung des teams MPS.

	Given I open an editor "fvor2_upd1" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
	And I set field "artikel" to "BG1"
	And I press button "ladetab"
	And I press button "malle"
	Then the table has 1 rows
	Then field "mfreig" is not modifiable in row 1
	Then field "mfreig" has value "nein" in row 1
	And setting field "mfreig" to "ja" in row 1 throws the exception "203"
	# "mfreig" kann nicht gedrückt werden
	# und speichern macht keinen sinn, weil speichern ja nicht freigibt.
	And I close the current editor


	# Es existiert kein BA, also wurde auch kein BA erzeugt:
    # funktioniert nicht!! Given opening an editor from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,@maxtreffer=1" throws the exception "149"
    # funktioniert nicht!! Given opening an editor from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV000;@maxtreffer=1" throws the exception "149"
    Given opening an editor from table "(Workorder):(WorkOrders)" with command "VIEW" for record "FV000" throws the exception "149"
    Given opening an editor from table "(Workorder):(WorkOrders)" with command "VIEW" for record "FV000" throws the exception "1582"

	# gegenprobe müsste scheitern
    # Given I open an editor "ba-suche1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "FV000"
	# And I close the current editor


	# Sperre entfernen
	Given I open an editor "Kstelle1-sperren" from table "(Account):(CostCenter)" with command "UPDATE" for record "211"
	And I set field "sperrkonfigurationneu" to ""
	And I save the current editor
 	Given I open an editor "Kostenstelle-absichern" from table "(Account):(CostCenter)" with command "VIEW" for record "211"
    Then field "sperrkonfigurationneu" has value ""
 	And I close the current editor

	# BA erzeugen
	Given I open an editor "fv-freigeben" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
	And I set field "artikel" to "BG1"
	And I press button "ladetab"
	And I set field "bisuch" to "FV" in row 1
	And I press button "malle"
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fv-freigeben"
    And I save the current editor

	# BA existiert u. ist lebendig
    Given I open an editor "ba-suche1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "FV000"
	And I close the current editor
	# gegenprobe müsste scheitern: 
	#Given opening an editor from table "(Workorder):(WorkOrders)" with command "VIEW" for record "FV000" throws the exception "149"

	# und ein storno der fv-freigabe gibt es nicht. das muss also nicht getestet werden.


Scenario: kv mit gesperrter kst in tabelle in FV - freigabe testen

    # -------- sperrfähige kostenstelle anlegen ---------
	Given I open an editor "freie_Kostenstelle" from table "(Account):(CostCenter)" with command "COPY" for record "111"
	And I set field "nummer" to "231"
	And I save the current editor


	# Stamm-Kostenverteiler anlegen
	Given I open an editor "kostenverteiler-10" from table "(Account):(CostDistribution)" with command "NEW" for record ""
	And I set field "nummer" to "10"
	And I set field "such" to "kv10"
	And I create a new row at the end of the table
	And I set field "kstelle" to "112" in row 1
	And I set field "proz" to "10" in row 1
	And I create a new row at the end of the table
	And I set field "kstelle" to "115" in row 2
	And I set field "proz" to "5" in row 2
	And I create a new row at the end of the table
	# diese kst wird gesperrt
	And I set field "kstelle" to "231" in row 3
	And I set field "proz" to "85" in row 3
	And I save the current editor

	# KV-Element DANACH sperren
	Given I open an editor "Kstelle1-sperren" from table "(Account):(CostCenter)" with command "UPDATE" for record "231"
	And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
	And I save the current editor
	Given I open an editor "Kostenstelle-absichern" from table "(Account):(CostCenter)" with command "VIEW" for record "231"
    Then field "sperrkonfigurationneu" has value "Standard-Kostenstellensperre"
	And I close the current editor

    Given I open an editor "fvor-kv" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | kstelle | bisuch    | mfreig |
      | BG1       | 30     |   kv10  | KVRM      | ja     |
	Then pressing button "freig" in row 0 to open a subeditor throws the exception "3602"
	Then saving the current editor throws the exception "3602"
    And I switch the current editor to editor "fvor-kv"
    And I close the current editor

    Given opening an editor from table "(Workorder):(WorkOrders)" with command "VIEW" for record "KVRM000" throws the exception "149"
    Given opening an editor from table "(Workorder):(WorkOrders)" with command "VIEW" for record "KVRM000" throws the exception "1582"
	# gegenprobe müsste scheitern
    # Given I open an editor "ba-suche2" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "KVRM000"
	# And I close the current editor

    # mit search criteria funktioniert nicht!! # Es existiert kein BA  KVRM..., also wurde auch kein BA erzeugt:
    # mit search criteria funktioniert nicht!! Given opening an editor from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV000;maxtreffer=1" throws the exception "1582"
    # mit search criteria funktioniert nicht!! Given I open an editor "ba-suche1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV000;@maxtreffer=1"
	# mit search criteria funktioniert nicht!! And I close the current editor

	# ---------  dass ein nicht gesperrter KV verwendet werden kann ist alte Funktionalität. das muss hier nicht getestet werden

	#    # Sperre entfernen
	#    Given I open an editor "Kstelle1-sperren" from table "(Account):(CostCenter)" with command "UPDATE" for record "231"
	#    And I set field "sperrkonfigurationneu" to ""
	#    And I save the current editor
 	#    Given I open an editor "Kostenstelle-absichern" from table "(Account):(CostCenter)" with command "VIEW" for record "231"
    #    Then field "sperrkonfigurationneu" has value ""
 	#    And I close the current editor
    #    
	#    # BA erzeugen
    #    Given I open an editor "fvor-kv2" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    #    And I append rows
    #      | artikel   | netmge | kstelle | bisuch    | mfreig |
    #      | BG1       | 30     |   kv10  | KVRM      | ja     |
    #    And I press button "freig" to open a subeditor for "BA-freigeben-kv"
    #    And I close the current editor
    #    And I switch the current editor to editor "fvor-kv2"
    #    And I save the current editor
    #    
	#    # BA existiert u. ist lebendig
    #    Given I open an editor "ba-suche1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "KVRM000"
	#    And I close the current editor
	#    # gegenprobe müsste scheitern: 
	#    #Given opening an editor from table "(Workorder):(WorkOrders)" with command "VIEW" for record "KVRM000" throws the exception "149"

	# ---------- und ein storno der fv-freigabe gibt es nicht. das muss also nicht getestet werden.
