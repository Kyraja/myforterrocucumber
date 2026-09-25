# *****************************************************************************
#  Name             : vorgangssteuerkonfig_edit_003_subeditor.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Editierbarkeit von Vorgangssteuerkonfiguration in Subeditor
#
#
#
#
# *****************************************************************************
@persistent
Feature: vorgangssteuerkonfig_edit_003_subeditor.feature
Background: Editierbarkeit von Vorgangssteuerkonfiguration


Given I set the fake date to "10.01.2000"

Scenario: Einkauf
Given I open an editor "ek-re01" from table "(Purchasing):(Invoice)" with command "VIEW" for search criteria "$,,num4=3501;budat=29.11.99;@richtung=rückwärts;@maxtreffer=1;@ablageart=beides"
Then field "vrgstrgl" has value "TVEKEURCLE"
Then field "bvrgstrglkonfig" is modifiable
Then field "fixvrgstrgl" has value "ja"

Then field "vrgstrglustland" has value "DEUTSCHLAND"
Then field "ustart" has value "Steuersofortabzug"
Then field "stlaart" has value "EU-Staat"
#
# Rechnungsempfaenger
Then field "rechnland" has value "GROSSBRITANNIEN"
Then field "rechnlaart" has value "EU-Staat"
Then field "rechnustid" has value ""
Then field "rechnregion" has value ""
Then field "rechnustidland" has value ""
Then field "vrgstrglauskl2" has value ""
#
# Warenempfaenger / Bestimmungsland
Then field "vstaat" has value "GROSSBRITANNIEN"
Then field "vstaatregion" has value ""
Then field "versustid" has value ""
Then field "versustidland" has value ""
Then field "laarta" has value "EU-Staat"
#
And I press button "bvrgstrglkonfig" to open a subeditor for "ek-konfig-01"
# Position abfragen
Then the current line is 43
# einpaar Felder in der Zeile abfragen
Then field "ev" has value "Einkauf" in row !currentRow
Then field "ev" is not modifiable in row !currentRow
Then field "rechnlaart" has value "EU-Staat" in row !currentRow
Then field "rechnlaart" is not modifiable in row !currentRow

Then field "standard" has value "nein" in row !currentRow
Then field "standard" is not modifiable in row !currentRow
Then field "vrgstrgl" has value "TVEKEURCLE" in row !currentRow
Then field "vrgstrgl" is not modifiable in row !currentRow

# zurueck zur REchnung
And I save the current subeditor to switch back to the parent editor

# And I switch the current editor to editor "ek-re01"
And I close the current editor

Given I open an editor "ek-re02" from table "(Purchasing):(Invoice)" with command "VIEW" for search criteria "$,,num4=4516;budat=29.11.99;@richtung=rückwärts;@maxtreffer=1;@ablageart=beides"
Then field "vrgstrgl" has value "EKINL"
Then field "bvrgstrglkonfig" is modifiable
#
And I press button "bvrgstrglkonfig" to open a subeditor for "ek-konfig-02"
# Position abfragen
Then the current line is 21

# einpaar Felder in der Zeile abfragen
Then field "ev" has value "Einkauf" in row !currentRow
Then field "ev" is not modifiable in row !currentRow
Then field "standard" has value "ja" in row !currentRow
Then field "standard" is not modifiable in row !currentRow
Then field "vrgstrgl" has value "EKINL" in row !currentRow
Then field "vrgstrgl" is not modifiable in row !currentRow

And I save the current subeditor to switch back to the parent editor
And I close the current editor


# default-Fall -> Vorgangsteuerregel fehlt noch im Vorgang
Given I open an editor "ek-re03" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
Then field "vrgstrgl" has value ""
Then field "bvrgstrglkonfig" is modifiable
#
And I press button "bvrgstrglkonfig" to open a subeditor for "ek-konfig-03"
# Position abfragen -> Zeile 0
Then the current line is 0
#
And I save the current subeditor to switch back to the parent editor
And I close the current editor
# =========================================================================================

Scenario: Verkauf

Given I open an editor "vk-re01" from table "(Sales):(Invoice)" with command "UPDATE" for record "3USTART"
Then field "vrgstrgl" has value "VKINL"
Then field "bvrgstrglkonfig" is modifiable
Then field "vrgstrglustland" has value "DEUTSCHLAND"
Then field "ustart" has value "steuerrelevant"
Then field "stlaart" has value "Inland"
#
# Rechnungsempfaenger
Then field "rechnland" has value "FRANKREICH"
Then field "rechnlaart" has value "EU-Staat"
Then field "rechnustid" has value ""
Then field "rechnregion" has value ""
Then field "rechnustidland" has value ""
Then field "vrgstrglauskl2" has value ""
#
# Warenempfaenger / Bestimmungsland
Then field "vstaat" has value "DEUTSCHLAND"
Then field "vstaatregion" has value ""
Then field "versustid" has value ""
Then field "versustidland" has value ""
Then field "laarta" has value "Inland"

#
And I press button "bvrgstrglkonfig" to open a subeditor for "vk-konfig-01"
# Position abfragen
Then the current line is 3
# einpaar Felder in der Zeile abfragen
Then field "ev" has value "Verkauf" in row !currentRow
Then field "ev" is not modifiable in row !currentRow
Then field "rechnlaart" has value "EU-Staat" in row !currentRow
Then field "rechnlaart" is not modifiable in row !currentRow
Then field "standard" has value "ja" in row !currentRow
Then field "standard" is not modifiable in row !currentRow
Then field "vrgstrgl" has value "VKINL" in row !currentRow
Then field "vrgstrgl" is not modifiable in row !currentRow

# zurueck zur REchnung
And I save the current subeditor to switch back to the parent editor
# And I switch the current editor to editor "vk-re01"
# ohne Speichern
And I close the current editor


# default-Fall -> Vorgangsteuerregel fehlt noch im Vorgang
Given I open an editor "vk-re-neu" from table "(Sales):(Invoice)" with command "NEW" for record ""
Then field "vrgstrgl" has value ""
Then field "bvrgstrglkonfig" is modifiable
#
And I press button "bvrgstrglkonfig" to open a subeditor for "vk-konfig"
# Position abfragen -> Zeile 0
Then the current line is 0
#
And I save the current subeditor to switch back to the parent editor
And I close the current editor


