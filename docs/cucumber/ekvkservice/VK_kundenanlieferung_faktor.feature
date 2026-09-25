Feature: Storno und Ruecklieferungen hier nur Verkauf
Background:
Given I set the fake date to "02.01.2002"
# Given I enable the flag 198

#####################################################################################################################################
# Bewertungsverfahren 6 Preis des Zugangs und Vorgangspreis
# in allen Artikeln
#####################################################################################################################################

@Stammdaten
Scenario: Stammdaten Lagergruppen, Lagerplätze, Lohnfertiger, Beistellung

# Lieferant 1 Währung EUR
Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "STORE" for record "1"
And I set field "waehr" to "EUR"
And I save the current editor

# Kunde 1 Währung EUR
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "1"
And I set field "waehr" to "EUR"
And I save the current editor

# Kunde 4 Währung EUR und Zahlungsbedingung
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "4"
And I set field "waehr" to "EUR"
And I set field "zbed" to "201"
And I save the current editor

# Zusatzposition Anzahlung mit richtigen Konten
Given I open an editor "zuspos" from table "(Part):(SupplementaryItem)" with command "STORE" for record "ANZAHLUNG"
And I set field "ekonto" to "07800"
And I set field "vkonto" to "32700"
And I save the current editor

# Konto 32700 mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "STORE" for record "32700"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

# Konto 11840 mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "STORE" for record "11840"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

######################################

# Lagergruppe Kundenanlieferung
Given I open an editor "K-Lagergruppe" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "KUNDENAN"
And I set field "such" to "KUNDENAN"
And I set field "namebspr" to "Kundenanlieferung"
And I set field "zkonsilg" to "JA"
And I save the current editor

# Konsignationslager Lieferanten Lagerplatz
Given I open an editor "K-Lager" from table "(Warehouse):(Warehouse)" with command "STORE" for record "KUNDENAN"
And I set field "such" to "KUNDENAN"
And I set field "namebspr" to "Kundenanlieferung"
And I set field "lgruppe" to "KUNDENAN"
And I set field "disporel" to "NEIN"
And I save the current editor

# Lieferanten Lagerplatz
Given I open an editor "K-Lagerplatz" from table "(Location):(Location)" with command "STORE" for record "KUNDENAN"
And I set field "such" to "KUNDENAN"
And I set field "namebspr" to "Kundenanlieferung-Platz"
And I set field "lager" to "KUNDENAN"
And I save the current editor


#####################################################################################################################################

@FALL-901
Scenario: FALL-901 VK Kundenanlieferung 

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "901-FALL"
And I set field "num2" to "901-FALL"
And I set field "such" to "FALL-901"
And I set field "namebspr" to "FALL-901"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen" 
And I set field "fvhle" to "2" 
And I set field "fvple" to "2" 
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "55"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 


# Lieferschein Kundenanlieferung anlegen
Given I open an editor "lieferschein-1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "lsart" to "(CustomerDelivery)"
And I set field "kunde" to "1"
And I set field "num3" to "901-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "art" to "901-FALL" in row 1
And I set field "mge" to "-901" in row 1
And I set field "platz" to "KUNDENAN" in row 1
And I set field "kenn" to "FALL-901"
And I save the current editor

# # Materialkostenverbuchung
# Given I open an editor "mkv-901" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
# And I set field "such" to "FALL-901"
# And I set field "kosart" to "Verbuchung Lagerbestand"
# And I set field "adat" to "."
# And I set field "edat" to "."
# # And I set field "labudat" to "01.01.95"
# And I press button "kosvor"
# #And I press button "kosbu"
# And I respond with answer "JA" to the dialog with id "2324"
# # And I respond with answer "JA" to the dialog with id "7332"
# And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "901-LS"
And I close the current editor


#####################################################################################################################################


#####################################################################################################################################

# 
# Hier ist dann das ENDE
# 
# 
