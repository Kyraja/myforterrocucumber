# *****************************************************************************
#  Name           : confirm_cancel.feature
#  Autor          : fwester
#  Verantwortlich : @forterro-prd/t024-abas-core
#  Funktion       : Tests zum deklaratives Einstellen der Abbruchbestaetigung
# *****************************************************************************
@persistent
@CONFIRM_CANCEL_TEST
Feature: CONFIRM_CANCEL

  Background:
    Given I'm logged in with password "sy"

Scenario: Create new infosystem

Given I open an editor "Infosystem neu" from table "(Infosystem):(Infosystem)" with command "NEW" for record ""
And I set field "such" to "CONFIRMCANCEL"
And I set field "arb" to "owdemo"
And I set field "maskorigin" to "Automatisch erzeugen"
And I set field "layoutorigin" to "Keine Ausgabe"
And I modify table
    | !row                                     | inmask | buttonnach                                 | feldaus                |
    | vname=='isabbrfragetxt'    | 1           | !dontChange                              | owdemo/CONFIRMCANCEL.FX  |
    | vname=='isbstart'               | 1           | owdemo/CONFIRMCANCEL.BA   | !dontChange            |
And I save the current editor
And I close the current editor

################################################################################

Scenario: Create new customer

Given I open an editor "Kunde neu" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set field "such" to "CONFCAN"
And I save the current editor
And I close the current editor

################################################################################

Scenario: Get editor status in a infosystem

Given I open the infosystem "CONFIRMCANCEL"
Then editor status "CONFIRMCANCELHEAD" has value "0"
Then editor status "CONFIRMCANCELTABLE" has value "0"
Then editor status "CONFIRMCANCELTEXT" has value ""
# Feldaustritt aktiviert Feld abbrfrage
And I set field "abbrfragetxt" to "Es wurden Eingaben vorgenommen!"
Then editor status "CONFIRMCANCELHEAD" has value "1"
Then editor status "CONFIRMCANCELTABLE" has value "1"
# Das funktioniert wegen des Umbruchs nicht!
#Then editor status "CONFIRMCANCELTEXT" has value "Es wurden Eingaben vorgenommen!\nWirklich abbrechen?"
And I set field "abbrfragetxt" to ""
Then editor status "CONFIRMCANCELTEXT" has value "Wirklich abbrechen?"
# Buttonnach deaktiviert Feld abbrfrage
And I press button "bstart"
Then editor status "CONFIRMCANCELHEAD" has value "0"
Then editor status "CONFIRMCANCELTABLE" has value "0"
Then editor status "CONFIRMCANCELTEXT" has value ""
And I save the current editor
And I close the current editor

################################################################################

Scenario: Get editor status in a customer

Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "VIEW" for record "CONFCAN"
Then editor status "CONFIRMCANCELHEAD" has value "1"
Then editor status "CONFIRMCANCELTABLE" has value "1"
Then editor status "CONFIRMCANCELTEXT" has value ""
And I close the current editor


################################################################################

Scenario: Get editor status in a subeditor

Given I open an editor "DruckKunde" from table "(Customer):(Customer)" with command "VIEW" for record "CONFCAN"
Then editor status "CONFIRMCANCELHEAD" has value "1"
Then editor status "CONFIRMCANCELTABLE" has value "1"
Then editor status "CONFIRMCANCELTEXT" has value ""
And I press button "budruck" to open a subeditor for "Druckdialog"
Then editor status "CONFIRMCANCELHEAD" has value "0"
Then editor status "CONFIRMCANCELTABLE" has value "0"
Then editor status "CONFIRMCANCELTEXT" has value ""
And I close the current subeditor to switch back to the parent editor
Then editor status "CONFIRMCANCELHEAD" has value "1"
Then editor status "CONFIRMCANCELTABLE" has value "1"
Then editor status "CONFIRMCANCELTEXT" has value ""
And I close the current editor

################################################################################

Scenario: Get editor status in a skip editor

Given I open an editor "Druckeinstellungen" for tip command "(PrinterSettings)" and arguments ""
Then editor status "CONFIRMCANCELHEAD" has value "1"
Then editor status "CONFIRMCANCELTABLE" has value "1"
Then editor status "CONFIRMCANCELTEXT" has value ""
And I close the current editor

################################################################################

Scenario: Get editor status in a sml editor

Given I open an editor "Product" from table "(Part):(Product)" with command "NEW" for record ""
And I set field "sach" to "0s"
And I press button "bmerk" to open a subeditor for "Sml"
Then editor status "CONFIRMCANCELHEAD" has value "1"
Then editor status "CONFIRMCANCELTABLE" has value "1"
Then editor status "CONFIRMCANCELTEXT" has value ""
And I close the current subeditor to switch back to the parent editor
And I close the current editor
