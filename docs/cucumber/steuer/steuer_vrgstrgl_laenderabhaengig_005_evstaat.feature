# *****************************************************************************
#  Name             : steuer_vrgstrgl_laenderabhaengig_005_evstaat.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Vorbelegung der VRGSTRGL in Einkauf mit Beruecksichtigung
#                     von Laender/Regionen der Lieferanten
#
#
# *****************************************************************************
@persistent
Feature: steuer_vrgstrgl_laenderabhaengig_005_evstaat.feature
Background:


Scenario: EK-Rechnung

# Lieferant und Rechnungssteller sind gleich
Given I open an editor "ek-Rechnung1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "10010"
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "vrgstrglauskl2" has value "EKIN" in row 0
Then field "staat" has value "DEUTSCHLAND" in row 0
Then field "region" has value "RHEINLAND-PFALZ" in row 0
Then field "staat2" has value "DEUTSCHLAND" in row 0
Then field "region2" has value "RHEINLAND-PFALZ" in row 0
Then field "vstaat" has value "DEUTSCHLAND" in row 0
Then field "rechnustid" has value "DE123456" in row 0
Then field "versustid" has value "DE123456" in row 0
#
And I set field "staat" to "ANGOLA"
Then field "vrgstrglauskl2" has value "EKIN" in row 0
Then field "rechnland" has value "ANGOLA" in row 0
Then field "rechnregion" is empty in row 0
Then field "region" is empty in row 0
Then field "rechnlaart" has value "Ausland" in row 0
#
And I set field "staat" to "DEUTSCHLAND"
Then field "vrgstrglauskl2" has value "EKIN" in row 0
Then field "rechnland" has value "DEUTSCHLAND" in row 0
Then field "rechnregion" is empty in row 0
Then field "region" is empty in row 0
Then field "rechnlaart" has value "Inland" in row 0
#
And I close the current editor


# Lieferant und Rechnungssteller sind unterschiedlich
Given I open an editor "ek-Rechnung2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "10010"
Then field "staat" has value "DEUTSCHLAND" in row 0
Then field "region" has value "RHEINLAND-PFALZ" in row 0
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "vrgstrglauskl2" has value "EKIN" in row 0
# --
And I set field "kl2" to "10011"
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "rechnland" has value "DEUTSCHLAND" in row 0
Then field "rechnregion" has value "BADEN-WUERTTEMBERG" in row 0
Then field "rechnlaart" has value "Inland" in row 0
# --
And I set field "staat" to "ANGOLA"
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "rechnland" has value "ANGOLA" in row 0
Then field "rechnregion" is empty in row 0
Then field "region" is empty in row 0
Then field "rechnlaart" has value "Ausland" in row 0
#
And I set field "staat" to "DEUTSCHLAND"
Then field "vrgstrglauskl2" is empty in row 0
Then field "rechnland" has value "DEUTSCHLAND" in row 0
Then field "rechnregion" is empty in row 0
Then field "region" is empty in row 0
Then field "rechnlaart" has value "Inland" in row 0

And I set field "region" to "RHEINLAND-PFALZ"
Then field "vrgstrglauskl2" is empty in row 0
Then field "rechnland" has value "DEUTSCHLAND" in row 0
Then field "rechnregion" has value "RHEINLAND-PFALZ" in row 0
Then field "region" is not empty in row 0
Then field "rechnlaart" has value "Inland" in row 0
#
And I close the current editor
###############################################################################


Scenario: EK-Lieferschein

# Lieferant und Rechnungssteller sind gleich
Given I open an editor "ek-Lieferschein1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "10010"
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "vrgstrglauskl2" has value "EKIN" in row 0
Then field "staat" has value "DEUTSCHLAND" in row 0
Then field "region" has value "RHEINLAND-PFALZ" in row 0
Then field "staat2" has value "DEUTSCHLAND" in row 0
Then field "region2" has value "RHEINLAND-PFALZ" in row 0
Then field "vstaat" has value "DEUTSCHLAND" in row 0
Then field "rechnustid" has value "DE123456" in row 0
Then field "versustid" has value "DE123456" in row 0
#
And I set field "staat" to "ANGOLA"
Then field "vrgstrglauskl2" has value "EKIN" in row 0
Then field "rechnland" has value "ANGOLA" in row 0
Then field "rechnregion" is empty in row 0
Then field "region" is empty in row 0
Then field "rechnlaart" has value "Ausland" in row 0
#
And I set field "staat" to "DEUTSCHLAND"
Then field "vrgstrglauskl2" has value "EKIN" in row 0
Then field "rechnland" has value "DEUTSCHLAND" in row 0
Then field "rechnregion" is empty in row 0
Then field "region" is empty in row 0
Then field "rechnlaart" has value "Inland" in row 0
#
And I close the current editor



# Lieferant und Rechnungssteller sind unterschiedlich
Given I open an editor "ek-Lieferschein2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "10010"
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "vrgstrglauskl2" has value "EKIN" in row 0
Then field "staat" has value "DEUTSCHLAND" in row 0
Then field "region" has value "RHEINLAND-PFALZ" in row 0
Then field "staat2" has value "DEUTSCHLAND" in row 0
Then field "region2" has value "RHEINLAND-PFALZ" in row 0
Then field "vstaat" has value "DEUTSCHLAND" in row 0
Then field "rechnustid" has value "DE123456" in row 0
Then field "versustid" has value "DE123456" in row 0
# --
And I set field "kl2" to "10011"
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "rechnland" has value "DEUTSCHLAND" in row 0
Then field "rechnregion" has value "BADEN-WUERTTEMBERG" in row 0
Then field "rechnlaart" has value "Inland" in row 0
#
And I set field "staat" to "ANGOLA"
Then field "vrgstrglauskl2" is empty in row 0
Then field "rechnland" has value "DEUTSCHLAND" in row 0
Then field "rechnregion" has value "BADEN-WUERTTEMBERG" in row 0
Then field "region" is empty in row 0
Then field "rechnlaart" has value "Inland" in row 0
#
And I set field "staat" to "DEUTSCHLAND"
Then field "vrgstrglauskl2" is empty in row 0
Then field "rechnland" has value "DEUTSCHLAND" in row 0
Then field "rechnregion" has value "BADEN-WUERTTEMBERG" in row 0
Then field "region" is empty in row 0
Then field "rechnlaart" has value "Inland" in row 0
#
And I set field "region" to "BERLIN"
Then field "vrgstrglauskl2" is empty in row 0
Then field "rechnland" has value "DEUTSCHLAND" in row 0
Then field "rechnregion" has value "BADEN-WUERTTEMBERG" in row 0
Then field "region" is not empty in row 0
#
And I close the current editor
###############################################################################


Scenario: EK-Bestellung

# Lieferant und Rechnungssteller sind gleich
Given I open an editor "ek-Bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "10010"
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "vrgstrglauskl2" has value "EKIN" in row 0
Then field "staat" has value "DEUTSCHLAND" in row 0
Then field "region" has value "RHEINLAND-PFALZ" in row 0
Then field "staat2" has value "DEUTSCHLAND" in row 0
Then field "region2" has value "RHEINLAND-PFALZ" in row 0
Then field "vstaat" has value "DEUTSCHLAND" in row 0
Then field "rechnustid" has value "DE123456" in row 0
Then field "versustid" has value "DE123456" in row 0
#
And I set field "staat" to "ANGOLA"
Then field "vrgstrglauskl2" has value "EKIN" in row 0
Then field "rechnland" has value "ANGOLA" in row 0
Then field "rechnregion" is empty in row 0
Then field "region" is empty in row 0
Then field "rechnlaart" has value "Ausland" in row 0
#
And I set field "staat" to "DEUTSCHLAND"
Then field "vrgstrglauskl2" has value "EKIN" in row 0
Then field "rechnland" has value "DEUTSCHLAND" in row 0
Then field "rechnregion" is empty in row 0
Then field "region" is empty in row 0
Then field "rechnlaart" has value "Inland" in row 0
#
And I close the current editor

# Lieferant und Rechnungssteller sind unterschiedlich
Given I open an editor "ek-Bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "10010"
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "vrgstrglauskl2" has value "EKIN" in row 0
Then field "staat" has value "DEUTSCHLAND" in row 0
Then field "region" has value "RHEINLAND-PFALZ" in row 0
Then field "staat2" has value "DEUTSCHLAND" in row 0
Then field "region2" has value "RHEINLAND-PFALZ" in row 0
Then field "vstaat" has value "DEUTSCHLAND" in row 0
Then field "rechnustid" has value "DE123456" in row 0
Then field "versustid" has value "DE123456" in row 0
# --
And I set field "kl2" to "10011"
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "rechnland" has value "DEUTSCHLAND" in row 0
Then field "rechnregion" has value "BADEN-WUERTTEMBERG" in row 0
Then field "rechnlaart" has value "Inland" in row 0
#
And I set field "staat" to "ANGOLA"
Then field "vrgstrglauskl2" is empty in row 0
Then field "rechnland" has value "DEUTSCHLAND" in row 0
Then field "rechnregion" has value "BADEN-WUERTTEMBERG" in row 0
Then field "region" is empty in row 0
Then field "rechnlaart" has value "Inland" in row 0
#
And I set field "staat" to "DEUTSCHLAND"
Then field "vrgstrglauskl2" is empty in row 0
Then field "rechnland" has value "DEUTSCHLAND" in row 0
Then field "rechnregion" has value "BADEN-WUERTTEMBERG" in row 0
Then field "region" is empty in row 0
Then field "rechnlaart" has value "Inland" in row 0
#
And I set field "region" to "BERLIN"
Then field "vrgstrglauskl2" is empty in row 0
Then field "rechnland" has value "DEUTSCHLAND" in row 0
Then field "rechnregion" has value "BADEN-WUERTTEMBERG" in row 0
Then field "region" is not empty in row 0
#
And I close the current editor
###############################################################################


Scenario: VK-Rechnung

# Kunde und Rechnungsempfaenger sind gleich
Given I open an editor "vk-Rechnung1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "20587"
Then field "vrgstrgl" has value "VKBAD" in row 0
Then field "vrgstrglauskl2" has value "VKBAD" in row 0
Then field "staat" has value "DEUTSCHLAND" in row 0
Then field "region" has value "BADEN-WUERTTEMBERG" in row 0
Then field "staat2" has value "DEUTSCHLAND" in row 0
Then field "region2" has value "BADEN-WUERTTEMBERG" in row 0
Then field "vstaat" has value "DEUTSCHLAND" in row 0
Then field "rechnustid" has value "DE123456" in row 0
Then field "versustid" has value "DE123456" in row 0


# ---
And I set field "staat" to "ANGOLA"
Then field "vrgstrglauskl2" has value "VKBAD" in row 0
Then field "rechnland" has value "ANGOLA" in row 0
Then field "rechnregion" is empty in row 0
Then field "region" is empty in row 0
Then field "rechnlaart" has value "Ausland" in row 0
#
And I set field "staat" to "DEUTSCHLAND"
Then field "vrgstrglauskl2" has value "VKBAD" in row 0
Then field "rechnland" has value "DEUTSCHLAND" in row 0
Then field "rechnregion" is empty in row 0
Then field "region" is empty in row 0
Then field "rechnlaart" has value "Inland" in row 0
And I close the current editor


# Kunde und Rechnungsempfaenger sind unterschiedlich
Given I open an editor "vk-Rechnung2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "20587"
Then field "vrgstrgl" has value "VKBAD" in row 0
Then field "vrgstrglauskl2" has value "VKBAD" in row 0
Then field "staat" has value "DEUTSCHLAND" in row 0
Then field "region" has value "BADEN-WUERTTEMBERG" in row 0
Then field "staat2" has value "DEUTSCHLAND" in row 0
Then field "region2" has value "BADEN-WUERTTEMBERG" in row 0
Then field "vstaat" has value "DEUTSCHLAND" in row 0
Then field "rechnustid" has value "DE123456" in row 0
Then field "versustid" has value "DE123456" in row 0
# --
And I set field "kl2" to "40002"
Then field "vrgstrglauskl2" is empty in row 0
Then field "rechnland" has value "USA" in row 0
Then field "rechnregion" has value "NY" in row 0
Then field "rechnlaart" has value "Ausland" in row 0
# ---
And I set field "staat" to "ANGOLA"
Then field "vrgstrglauskl2" is empty in row 0
Then field "rechnland" has value "ANGOLA" in row 0
Then field "rechnregion" is empty in row 0
Then field "region" is empty in row 0
Then field "rechnlaart" has value "Ausland" in row 0
#
And I set field "staat" to "DEUTSCHLAND"
Then field "vrgstrglauskl2" is empty in row 0
Then field "rechnland" has value "DEUTSCHLAND" in row 0
Then field "rechnregion" is empty in row 0
Then field "region" is empty in row 0
Then field "rechnlaart" has value "Inland" in row 0
And I close the current editor
###############################################################################


Scenario: VK-Lieferschein

# Kunde und Rechnungsempfaenger sind gleich
Given I open an editor "vk-Lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "20587"
Then field "vrgstrgl" has value "VKBAD" in row 0
Then field "vrgstrglauskl2" has value "VKBAD" in row 0
Then field "staat" has value "DEUTSCHLAND" in row 0
Then field "region" has value "BADEN-WUERTTEMBERG" in row 0
Then field "staat2" has value "DEUTSCHLAND" in row 0
Then field "region2" has value "BADEN-WUERTTEMBERG" in row 0
Then field "vstaat" has value "DEUTSCHLAND" in row 0
Then field "rechnustid" has value "DE123456" in row 0
Then field "versustid" has value "DE123456" in row 0
# ---
And I set field "staat" to "ANGOLA"
Then field "vrgstrglauskl2" has value "VKBAD" in row 0
Then field "rechnland" has value "ANGOLA" in row 0
Then field "rechnregion" is empty in row 0
Then field "region" is empty in row 0
Then field "rechnlaart" has value "Ausland" in row 0
#
And I set field "staat" to "DEUTSCHLAND"
Then field "vrgstrglauskl2" has value "VKBAD" in row 0
Then field "rechnland" has value "DEUTSCHLAND" in row 0
Then field "rechnregion" is empty in row 0
Then field "region" is empty in row 0
Then field "rechnlaart" has value "Inland" in row 0
And I close the current editor


# Kunde und Rechnungsempfaenger sind unterschiedlich
Given I open an editor "vk-Lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "20587"
Then field "vrgstrgl" has value "VKBAD" in row 0
Then field "vrgstrglauskl2" has value "VKBAD" in row 0
Then field "staat" has value "DEUTSCHLAND" in row 0
Then field "region" has value "BADEN-WUERTTEMBERG" in row 0
Then field "staat2" has value "DEUTSCHLAND" in row 0
Then field "region2" has value "BADEN-WUERTTEMBERG" in row 0
Then field "vstaat" has value "DEUTSCHLAND" in row 0
Then field "rechnustid" has value "DE123456" in row 0
Then field "versustid" has value "DE123456" in row 0
# --
And I set field "kl2" to "40002"
Then field "vrgstrglauskl2" is empty in row 0
Then field "rechnland" has value "USA" in row 0
Then field "rechnregion" has value "NY" in row 0
Then field "rechnlaart" has value "Ausland" in row 0
# ---
And I set field "staat" to "ANGOLA"
Then field "vrgstrglauskl2" is empty in row 0
Then field "rechnland" has value "USA" in row 0
Then field "rechnregion" has value "NY" in row 0
Then field "rechnlaart" has value "Ausland" in row 0
Then field "region" is empty in row 0
#
And I set field "staat" to "DEUTSCHLAND"
Then field "vrgstrglauskl2" is empty in row 0
Then field "rechnland" has value "USA" in row 0
Then field "rechnregion" has value "NY" in row 0
Then field "rechnlaart" has value "Ausland" in row 0
Then field "region" is empty in row 0
And I close the current editor
###############################################################################
