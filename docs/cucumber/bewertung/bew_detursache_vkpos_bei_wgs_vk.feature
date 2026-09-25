# *****************************************************************************************
#  Name           : bew_detursache_vkpos_bei_wgs_vk.feature
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Test bestimmter Daten in Bewertungen im Kontext einer Wertgutschrift
#  Beschreibung   :
#  
#
# *****************************************************************************************
#
@persistent
Feature: ref_bew_detursache_vkpos_bei_wgs_vk.cu
Background:
Given I set the fake date to "10.01.1995"

#---------------------------------------------------------------------------------------------
Scenario: 01 Bewertung zu VK-Rechnung 1F-VKWG1 (Wertgutschrift)
#----------------------------------------------------------------------------------------------
# Journaleintrag selektieren
Given I open an editor "LJ_AB_WGS" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==E3;such==L1F-VKLS;buart==2;@richtung=rueckwaerts;@maxtreffer=1"
And I close the current editor

# Bewertung zu diesem Journaleintrag pruefen
Given I open latest Valuation "Bewertung_LJ_AB_E3" for Product "E3" and valuation transaction "LJ_AB_WGS" with command "VIEW"
Then field "ursache" has value "Lieferschein"
Then field "detursache" has value "Wertgutschrift"
And I close the current editor

#---------------------------------------------------------------------------------------------
Scenario: 02 Erzeguen einer Teil-Rechnung zu VK-LS 1F-VKLS und Pruefen der Detailursache in der zugehoerigen Bewertung 
#----------------------------------------------------------------------------------------------
Given I open an editor "RE1F3" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "LS1F1"
And I set fields
   | nummer | 1F-VKRE3 |
   | such   | RE1F3    |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | ja       |
And I set field "mge" to "1" in row 3
And I delete row at position 2
And I delete row at position 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Bewertung selektieren
Given I open an editor "BEW_AB_RE" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel==E3;ppsref^such==L1F-VKLS;buart==Abgang;@richtung=rueckwaerts;@maxtreffer=1"
Then field "ursache" has value "Lieferschein"
# Hier erscheint "Wertgutschrift" immer noch als Detailursache, obwohl eine VK-Teil-RE Ausl�ser dieser Bewertung ist.
# Frage: sollte hier als Detailursache "Lieferschein Verkauf" stehen?
Then field "detursache" has value "Wertgutschrift"
And I close the current editor


