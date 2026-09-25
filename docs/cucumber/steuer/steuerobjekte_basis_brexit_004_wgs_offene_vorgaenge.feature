# *****************************************************************************
#  Name             : steuerobjekte_basis_brexit_004_wgs_offene_vorgaenge.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Test des Verhalten der steuerlichen Objekten in EK/VK bei EU-Austritt
#
#
# *****************************************************************************

@persistent
Feature: WGS und steuerliche Daten bei EU-Austritt
Background: Test von 
Given I set the fake date to "27.01.2002"


@FALL-24EK-VOR
@FALL-24VK-VOR
Scenario: 24 VOR: BE->LS->TRE1->   *EU-Austritt* ->TRE2->WGS1         Lief. aus GB
#         24 VOR: AU->TRE1->TLS1-> *EU-Austritt* ->TRE2->WGS1->TLS2   Kunde aus GB


######################
# Bestellung anlegen
Given I open an editor "bestellung-24ek" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "9brexit"
And I set field "num4" to "24ek-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall24" in row 1
And I set field "mge" to "240" in row 1
And I set field "preis" to "240" in row 1
And I set field "bem" to "FALL-24EK"
And I save the current editor
And I close the current editor

# Lieferschein anlegen und verbuchen
Given I open an editor "lieferschein-24ek" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "bestellung-24ek"
And I set field "num4" to "24ek-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-24EK"
And I create a new row at the end of the table
And I set field "mge" to "240" in row 1
And I save the current editor
And I close the current editor

# Teil-Rechnung anlegen und verbuchen
Given I open an editor "rechnung-24ek" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "lieferschein-24ek"
And I set field "num4" to "24ek-RE"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-24EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "180" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

######################
# Auftrag anlegen und verbuchen
Given I open an editor "auftrag-24vk" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1brexit"
And I set field "num3" to "24vk-AU"
And I create a new row at the end of the table
And I set field "artex" to "0efall24" in row 1
And I set field "mge" to "200" in row 1
And I set field "preis" to "200" in row 1
And I set field "bem" to "FALL-24VK"
And I save the current editor
And I close the current editor

# Teil-Rechnung1 anlegen und verbuchen
Given I open an editor "trechnung1-024vk" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-24vk"
And I set field "num3" to "24vk-RE"
And I set field "fakt" to "nein"
And I set field "bem" to "FALL-24VK"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "120" in row 1
And I set field "preis" to "200" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Lieferschein anlegen
Given I open an editor "tlieferschein-024vk" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-24vk"
And I set field "num3" to "24vk-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "180" in row 1
And I set field "bem" to "FALL-24VK"
And I save the current editor
And I close the current editor


# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################


@FALL-25EK-VOR
@FALL-25VK-VOR
Scenario: 25 VOR: BE LS  RE   *EU-Austritt* WGS  TRLS GS       Lief. aus GB
#         25 VOR: LS RLS TRE1 *EU-Austritt* WGS1 TRE2 GS       Lief. aus GB

Given I set the fake date to "27.01.2002"

######################
# Bestellung anlegen
Given I open an editor "bestellung-25ek" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "9brexit"
And I set field "num4" to "25ek-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall25" in row 1
And I set field "mge" to "25" in row 1
And I set field "preis" to "4" in row 1
And I set field "bem" to "FALL-25EK"
And I save the current editor
And I close the current editor

# Lieferschein anlegen und verbuchen
Given I open an editor "lieferschein-25ek" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "bestellung-25ek"
And I set field "num4" to "25ek-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-25EK"
And I create a new row at the end of the table
And I set field "mge" to "25" in row 1
And I save the current editor
And I close the current editor

# Rechnung anlegen und verbuchen
Given I open an editor "rechnung-25ek" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "lieferschein-25ek"
And I set field "num4" to "25ek-RE1"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-25EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "25" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

######################
# Lieferschein anlegen
Given I open an editor "lieferschein-25vk" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "4brexit"
And I set field "num3" to "25vk-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to "0efall25" in row 1
And I set field "mge" to "100" in row 1
And I set field "bem" to "FALL-25VK"
And I save the current editor
And I close the current editor

# Ruecklieferung von 20 Stk. -> von LS
Given I open an editor "ruecklief-25vk" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-25vk"
Then field "lsart" has value "Rücklieferschein"
And I set field "num3" to "25vk-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "EK1-FALL25" in row 1
And I set field "mge" to "-20" in row 1
And I save the current editor
And I close the current editor

# Teil-Rechnung1 anlegen
Given I open an editor "rechnung-25vk" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-25vk"
And I set field "num3" to "25vk-RE1"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-25VK"
And I set field "ueb" to "ja"
And I set field "mge" to "30" in row 1
And I set field "preis" to "5" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################


@FALL-26EK-VOR
Scenario: 26 VOR: LS->TRE1->TWGS1-> *EU-Austritt* ->TRE2->RLS->GS    Lief aus Nordirland

Given I set the fake date to "27.01.2002"

######################
# Lieferschein anlegen
Given I open an editor "lieferschein-26ek" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "5brexit"
And I set field "num4" to "26ek-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "0efall26" in row 1
And I set field "mge" to "100" in row 1
And I set field "bem" to "FALL-26EK"
And I save the current editor
And I close the current editor

# Teil-Rechnung1 anlegen
Given I open an editor "rechnung-26ek" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "lieferschein-26ek"
And I set field "num4" to "26ek-RE1"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-26EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "30" in row 1
And I set field "preis" to "5" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


Given I open an editor "re-26ek-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+26ek-RE1"
Then field "wertgutschrift" has value "nein" in row 0
Then the table has 5 rows
Then field "intrarel" has value "nein" in row 1
And I close the current editor

# Teil-Wertgutschrift1: Kommando Rechnung auf eine Rechnung
Given I open an editor "wgs-26ek" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+26ek-RE1"
And I set fields
   | nummer | 26ek-wgs|
   | such   | wgs26   |
   | tterm  | .       |
#   | budat  | .       |
   | vom    | .       |
   | ueb    |  ja     |
Then field "wertgutschrift" has value "ja" in row 0
Then the table has 5 rows
Then field "intrarel" has value "nein" in row 1
Then field "ofmge" has value "-30" in row 1
And I set field "mge" to "-10" in row 1
Then field "ofmge" has value "-20" in row 1
Then field "artikel" has value "EK1-FALL26" in row 1
Then field "ofwert" has value "-150.00" in row 1
Then field "intrarel" has value "nein" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################


@FALL-27EK-VOR
Scenario: 27 VOR: LS->TRE1->WGS1(anlegen)-> *EU-Austritt* ->WGS1(verbuchen)->TRE2->RLS->GS    Lief aus Nordirland

Given I set the fake date to "27.01.2002"

######################
# Lieferschein anlegen
Given I open an editor "lieferschein-27ek" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "5brexit"
And I set field "num4" to "27ek-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "0efall27" in row 1
And I set field "mge" to "100" in row 1
And I set field "bem" to "FALL-27EK"
And I save the current editor
And I close the current editor

# Teil-Rechnung1 anlegen
Given I open an editor "rechnung-27ek" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "lieferschein-27ek"
And I set field "num4" to "27ek-RE1"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-27EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "30" in row 1
And I set field "preis" to "5" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Voll-Wertgutschrift1: Kommando Rechnung auf eine Rechnung
# nur anlegen - nicht verbuchen!!!
Given I open an editor "wgs-27ek" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+27ek-RE1"
And I set fields
   | nummer | 27ek-wgs|
   | such   | wgs27   |
   | tterm  | .       |
#   | budat  | .       |
   | vom    | .       |
   | ueb    |  nein   |
Then field "wertgutschrift" has value "ja" in row 0
Then the table has 5 rows
Then field "artikel" has value "EK1-FALL27" in row 1
Then field "ofmge" has value "-30" in row 1
Then field "ofwert" has value "-150.00" in row 1
And I press button "offueb" in row 1
Then field "intrarel" has value "nein" in row 1
And I save the current editor
And I close the current editor

# Kontrolle: wird nicht gespeichert
Given I open an editor "wgs-27ek-update" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "27ek-wgs"
Then field "wertgutschrift" has value "ja" in row 0
# noch nicht gebucht
Then field "uebertr" has value "ja" in row 0
#
#    Reiter "Umsatzsteuer"
#    =====================
Then field "vrgstrgl" has value "EKEUSOFORT" in row 0
Then field "vrgstrgl" is modifiable in row 0
Then field "vrgstrglname" is not modifiable in row 0
Then field "fixvrgstrgl" has value "nein" in row 0
Then field "fixvrgstrgl" is modifiable in row 0
And I set field "fixvrgstrgl" to "ja"
And I set field "fixvrgstrgl" to "nein"
# Wert des Feldes "vrgstrgl" darf sich nicht ändern
Then field "vrgstrgl" has value "EKEUSOFORT" in row 0
#
# wird nicht gespeichert!!!
And I close the current editor


Then the table has 5 rows
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################


@FALL-28EK-VOR
Scenario: 28 VOR: LS->TRE1->WGS1(anlegen uber Beleg)-> *EU-Austritt* ->WGS1(verbuchen)->TRE2->RLS->GS    Lief aus Nordirland

Given I set the fake date to "27.01.2002"

######################
# Lieferschein anlegen
Given I open an editor "lieferschein-28ek" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "5brexit"
And I set field "num4" to "28ek-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "0efall28" in row 1
And I set field "mge" to "170" in row 1
And I set field "bem" to "FALL-28EK"
And I save the current editor
And I close the current editor

# Teil-Rechnung1 anlegen
Given I open an editor "rechnung-28ek" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "lieferschein-28ek"
And I set field "num4" to "28ek-RE1"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-28EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "30" in row 1
And I set field "preis" to "5" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Festhaltung des Fehlerzustandes > wird nicht gespeichert
Given I open an editor "wgs-28ek" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+28ek-RE1"
Then field "wertgutschrift" has value "ja" in row 0
Then field "intrarel" has value "nein" in row 1
Then field "intrarel" is not modifiable in row 1
And I set field "budat" to "."
# Bei WGS darf "intrarel" nicht neu ermittelt, wenn "budat" geändert wird.
# Das Feld "intrarel" bleibt nicht änderbar -> Soll so bleiben???
Then field "intrarel" has value "nein" in row 1
Then field "intrarel" is not modifiable in row 1
# ohne zu Speichern den Editor verlassen
And I close the current editor


# Voll-Wertgutschrift1: Kommando Rechnung auf eine Rechnung
# nur anlegen - nicht verbuchen!!!
Given I open an editor "wgs-28ek" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
Then field "wertgutschrift" has value "nein" in row 0
And I set field "beleg" to "+28ek-RE1"
Then field "wertgutschrift" has value "ja" in row 0
And I set fields
   | nummer | 28ek-wgs|
   | such   | wgs28   |
   | tterm  | .       |
#   | budat  | .       |  zur Zeit fehlerhaft: -> (ev)intrarel wird neu ermittelt
   | vom    | .       |
   | ueb    |  nein   |
Then the table has 5 rows
Then field "artikel" has value "EK1-FALL28" in row 1
Then field "ofmge" has value "-30" in row 1
Then field "ofwert" has value "-150.00" in row 1
And I press button "offueb" in row 1
Then field "intrarel" has value "nein" in row 1
And I save the current editor
And I close the current editor


# Kontrolle: was noch theoretisch wertgutgeschrieben werden kann
Given I open an editor "wgs-28ek" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "28ek-wgs"
Then field "wertgutschrift" has value "ja" in row 0
# noch nicht gebucht
Then field "uebertr" has value "ja" in row 0
#
#    Reiter "Umsatzsteuer"
#    =====================
Then field "vrgstrgl" has value "EKEUSOFORT" in row 0
Then field "vrgstrgl" is modifiable in row 0
Then field "vrgstrglname" is not modifiable in row 0
Then field "fixvrgstrgl" has value "nein" in row 0
Then field "fixvrgstrgl" is modifiable in row 0
And I set field "fixvrgstrgl" to "ja"
And I set field "fixvrgstrgl" to "nein"
# Wert des Feldes "vrgstrgl" darf sich nicht ändern
Then field "vrgstrgl" has value "EKEUSOFORT" in row 0
#
Then field "vrgstrglustland" is not modifiable in row 0
Then field "ustart" is not modifiable in row 0
Then field "ustart" has value "Steuersofortabzug" in row 0
Then field "ustid" is not modifiable in row 0
Then field "ustidfa" is not modifiable in row 0
Then field "stlaart" is not modifiable in row 0
Then field "stlaart" has value "EU-Staat" in row 0
Then field "zmrel" is not modifiable in row 0
#
# Rechnungssteller
Then field "rechnland" is not modifiable in row 0
Then field "rechnland" has value "GROSSBRITANNIEN" in row 0
Then field "rechnregion" is not modifiable in row 0
Then field "rechnregion" has value "NORDIRL" in row 0
Then field "rechnlaart" is not modifiable in row 0
Then field "rechnustid" is modifiable in row 0
Then field "rechnustidland" is not modifiable in row 0
Then field "vrgstrglauskl2" is not modifiable in row 0
#
# Lieferent, Versendungsland
Then field "vstaat" is modifiable in row 0
Then field "vstaatregion" is not modifiable in row 0
Then field "laarta" is not modifiable in row 0
Then field "versustid" is modifiable in row 0
Then field "versustidland" is not modifiable in row 0
#
Then field "klsteunr" is modifiable in row 0
Then field "steunr" is not modifiable in row 0

#    TABELLE
Then the table has 5 rows
Then field "artikel" has value "EK1-FALL28" in row 1
Then field "artikel" is not modifiable in row 1
Then field "komplettgutschrift" has value "ja" in row 1
Then field "komplettgutschrift" is not modifiable in row 1

Then field "ktostrgl" has value "EKEUSOF" in row 1
Then field "ktostrgl" is not modifiable in row 1
Then field "kstelle" is empty in row 1
Then field "kstelle" is not modifiable in row 1
Then field "fixkstelle" is not modifiable in row 1
Then field "fixkstelle" has value "nein" in row 1
#
#
Then field "strgl" has value "EKEUWARE" in row 1
Then field "strgl" is modifiable in row 1
Then field "strglname" is not modifiable in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "fixstrgl" is modifiable in row 1
# test: "strgl" darf sich nicht ändern
And I set field "fixstrgl" to "ja" in row 1
And I set field "fixstrgl" to "nein" in row 1
Then field "strgl" has value "EKEUWARE" in row 1
#
Then field "zstrgl" is not modifiable in row 1
Then field "tustart" has value "Steuersofortabzug" in row 1
Then field "tustart" is not modifiable in row 1
#
Then field "steuer" has value "1" in row 1
Then field "steuer" is not modifiable in row 1
#
Then field "ustva" has value "89" in row 1
Then field "ustva" is not modifiable in row 1
#
# wird nicht gespeichert!!!
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################




