# *****************************************************************************
#  Name             : steuer_vorgangssteuerkonfig_001_subeditor.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Positionbestimmung in der Vorgangssteuerkonfiguration als Subeditor
#
#
#
#
# *****************************************************************************
@persistent
Feature: steuer_vorgangssteuerkonfig_001_subeditor.feature
Background: Positionbestimmung


Scenario: aus Einkauf, 1
Given I open an editor "ek-re01" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+6.2"
Then field "vrgstrgl" has value "EKIN"
Then field "fixvrgstrgl" has value "nein"

Then field "vrgstrglustland" has value "DEUTSCHLAND"
Then field "ustart" has value "steuerrelevant"
Then field "stlaart" has value "Inland"
#
# Rechnungsempfaenger
Then field "rechnland" has value "DEUTSCHLAND"
Then field "rechnlaart" has value "Inland"
Then field "rechnustid" has value "DE561115002"
Then field "rechnregion" has value ""
Then field "rechnustidland" has value "DEUTSCHLAND"
Then field "vrgstrglauskl2" has value ""
#
# Warenempfaenger / Bestimmungsland
Then field "vstaat" has value "DEUTSCHLAND"
Then field "vstaatregion" has value ""
Then field "versustid" has value "DE561115002"
Then field "versustidland" has value "DEUTSCHLAND"
Then field "laarta" has value "Inland"
#
And I press button "bvrgstrglkonfig" to open a subeditor for "ek-konfig-01"
# Position abfragen
Then the current line is 13

# einpaar Felder in der Zeile abfragen
Then field "ev" has value "Einkauf" in row !currentRow
Then field "rechnlaart" has value "Inland" in row !currentRow
Then field "rechnland" has value "" in row !currentRow
Then field "bestlaart" has value "Inland" in row !currentRow
Then field "bestland" has value "" in row !currentRow
Then field "rechnustid" has value "leer oder aus Inland" in row !currentRow
Then field "rechnustidland" has value "" in row !currentRow
Then field "bestustid" has value "irrelevant" in row !currentRow
Then field "bestustidland" has value "" in row !currentRow
Then field "standard" has value "ja" in row !currentRow
Then field "vrgstrgl" has value "EKIN" in row !currentRow
# zurueck zur REchnung
And I save the current subeditor to switch back to the parent editor
And I close the current editor
# =========================================================================================


Scenario: aus Einkauf, 2

# eine EU-Lieferant anlegen
Given I open an editor "eu-lief" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set field "nummer" to "70021"
And I set field "such" to "TOSKANA"
And I set field "namebspr" to "Italien, RE: Toskana, Ware: Toskana"
And I set field "staat" to "ITALIEN"
And I set field "staat2" to "ITALIEN"
And I set field "region" to "TOS"
And I set field "region2" to "TOS"
And I set field "ustid" to "IT01234567896"
And I save the current editor
And I close the current editor

# RE wird nicht gespeichert
Given I open an editor "ek-re02" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "70021"
Then field "vrgstrgl" has value "EKEUSOFORT"

Then field "vrgstrglustland" has value "DEUTSCHLAND"
Then field "ustart" has value "Steuersofortabzug"
Then field "stlaart" has value "EU-Staat"
#
# Rechnungsempfaenger
Then field "rechnland" has value "ITALIEN"
Then field "rechnlaart" has value "EU-Staat"
Then field "rechnustid" has value "IT01234567896"
Then field "rechnregion" has value "TOS"
Then field "rechnustidland" has value "ITALIEN"
Then field "vrgstrglauskl2" has value ""
#
# Warenempfaenger / Bestimmungsland
Then field "vstaat" has value "ITALIEN"
Then field "vstaatregion" has value "TOS"
Then field "versustid" has value "IT01234567896"
Then field "versustidland" has value "ITALIEN"
Then field "laarta" has value "EU-Staat"
#
And I press button "bvrgstrglkonfig" to open a subeditor for "ek-konfig-01"
# Position abfragen
Then the current line is 15
Then field "standard" has value "ja" in row !currentRow
Then field "vrgstrgl" has value "EKEUSOFORT" in row !currentRow
# zurueck zur REchnung
And I save the current subeditor to switch back to the parent editor

And I set field "vstaat" to "DEUTSCHLAND"
And I set field "versustid" to "DE01234567896"
#
# VRGSTRGL hat sich geaendert
Then field "vrgstrgl" has value "EKIN"

Then field "vrgstrglustland" has value "DEUTSCHLAND"
Then field "ustart" has value "steuerrelevant"
Then field "stlaart" has value "Inland"
#
# Rechnungsempfaenger
Then field "rechnland" has value "ITALIEN"
Then field "rechnlaart" has value "EU-Staat"
Then field "rechnustid" has value "IT01234567896"
Then field "rechnregion" has value "TOS"
Then field "rechnustidland" has value "ITALIEN"
Then field "vrgstrglauskl2" has value ""
#
# Warenempfaenger / Bestimmungsland
Then field "vstaat" has value "DEUTSCHLAND"
Then field "vstaatregion" has value ""
Then field "versustid" has value "DE01234567896"
Then field "versustidland" has value "DEUTSCHLAND"
Then field "laarta" has value "Inland"
#
And I press button "bvrgstrglkonfig" to open a subeditor for "ek-konfig-01"
# Position abfragen
Then the current line is 19
# einpaar Felder in der Zeile abfragen
Then field "ev" has value "Einkauf" in row !currentRow
Then field "rechnlaart" has value "EU-Staat" in row !currentRow
Then field "rechnland" has value "" in row !currentRow
Then field "bestlaart" has value "Inland" in row !currentRow
Then field "bestland" has value "" in row !currentRow
Then field "rechnustid" has value "vorhanden und aus EU-Staat" in row !currentRow
Then field "rechnustidland" has value "" in row !currentRow
Then field "bestustid" has value "irrelevant" in row !currentRow
Then field "bestustidland" has value "" in row !currentRow
Then field "standard" has value "ja" in row !currentRow
# zurueck zur REchnung
And I save the current subeditor to switch back to the parent editor
And I close the current editor
# =========================================================================================


Scenario: aus Verkauf

Given I open an editor "vk-re01" from table "(Sales):(Invoice)" with command "VIEW" for record "+400048"
Then field "vrgstrgl" has value "VKIN"
Then field "bvrgstrglkonfig" is modifiable
Then field "vrgstrglustland" has value "DEUTSCHLAND"
Then field "ustart" has value "steuerrelevant"
Then field "stlaart" has value "Inland"
#
# Rechnungsempfaenger
Then field "rechnland" has value "DEUTSCHLAND"
Then field "rechnlaart" has value "Inland"
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
Then the current line is 1
# einpaar Felder in der Zeile abfragen
Then field "ev" has value "Verkauf" in row !currentRow
Then field "rechnlaart" has value "Inland" in row !currentRow
Then field "rechnland" has value "" in row !currentRow
Then field "bestlaart" has value "Inland" in row !currentRow
Then field "bestland" has value "" in row !currentRow
Then field "rechnustid" has value "leer oder aus Inland" in row !currentRow
Then field "rechnustidland" has value "" in row !currentRow
Then field "bestustid" has value "irrelevant" in row !currentRow
Then field "bestustidland" has value "" in row !currentRow
Then field "standard" has value "ja" in row !currentRow
Then field "vrgstrgl" has value "VKIN" in row !currentRow
#
# zurueck zur REchnung
And I save the current subeditor to switch back to the parent editor
# And I switch the current editor to editor "vk-re01"
# ohne Speichern
And I close the current editor
# =========================================================================================
