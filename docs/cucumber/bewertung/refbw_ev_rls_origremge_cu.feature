# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      : 
# *****************************************************************************
@persistent
Feature: Komplexe Prozesse mit Originalrechnungsmenge nach Rücklieferungen  

Background:
Given I set the fake date to "09.01.2002"

# graf:

# ----------------------------------------------------------------------------------------------
Scenario: BE - LS - RLS - RE - Storno RE - Storno RLS - TREa - TREb 
# ----------------------------------------------------------------------------------------------

# Bestellung
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "09.01.2002" with Command Revalue
Given I set the fake date to "10.01.2002"
Given I open an editor "1BE015" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE015 |
   | lief   | 1      |
   |erfwaehr| EUR    |
And I append rows
   | artikel | mge | preis |
   | 14vm    | 10  | 12.00 | 
And I save the current editor

# Lieferschein
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "10.01.2002" with Command Revalue
Given I set the fake date to "11.01.2002"
Given I open an editor "1LS015" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "1BE015"
And I set fields
   | nummer | 1LS015 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I save the current editor

# Ruecklieferschein
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "11.01.2002" with Command Revalue
Given I set the fake date to "12.01.2002"
Given I open an editor "1RLS015" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS015"
And I set fields
   | nummer | 1RLS015 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-4" in row 1
And I save the current editor

# Rechnung
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "12.01.2002" with Command Revalue
Given I set the fake date to "13.01.2002"
Given I open an editor "1RE015" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS015"
And I set fields
   | nummer   | 1RE015 |
   | ueb      | ja     |
   | vom      | .      |
And I set field "mge" to "10" in row 1
# And I create a new row at the end of the table
# And I set field "artikel" to "TEXT" in row 2
# And I set field "pwert" to "-2000" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Storno Ruecklieferschein - nicht erlaubt, erst Rechnung stornieren
# Given opening an editor from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "1RLS015" throws the exception "3335"

# Storno Rechnung
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "13.01.2002" with Command Revalue
Given I set the fake date to "14.01.2002"
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+1RE015"
And I set field "num4" to "1RE015S"
And I save the current editor

# Storno Ruecklieferschein
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "14.01.2002" with Command Revalue
Given I set the fake date to "15.01.2002"
Given I open an editor "rechnungsstorno" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+1RLS015"
And I set field "num4" to "1RLS015S"
And I save the current editor


# Rechnung-2
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "15.01.2002" with Command Revalue
Given I set the fake date to "16.01.2002"
Given I open an editor "1RE015b" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS015"
And I set fields
   | nummer   | 1RE015b |
   | ueb      | ja      |
   | vom      | .       |
And I set field "mge" to "7" in row 1
And I set field "preis" to "8" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung-3
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "16.01.2002" with Command Revalue
Given I set the fake date to "17.01.2002"
Given I open an editor "1RE015c" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS015"
And I set fields
   | nummer   | 1RE015c |
   | ueb      | ja      |
   | vom      | .       |
And I set field "preis" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "17.01.2002" with Command Revalue

# ------------------------------------------------------------------------------------------------
Scenario: AU100-VKLS100-TRLS40-TRE1(10)-TRE2(60)-STO RLS(verboten)-STO TRE1-Storno RLS-RestRE(30)
# ------------------------------------------------------------------------------------------------
# Bewertungen:      100     60   10+50   10+50                     10+50     40+60      40+60                      

# Bestand mit Wert herstellen
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "17.01.2002" with Command Revalue
Given I set the fake date to "18.01.2002"
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | 13vo      |
    | buart     | Zugang    |
    | beleg     | LBU_22  |
    | beldat    | .         |
    | wert      | 12.0000   |
And I delete all rows
And I append rows
    | mge    | platz2   |
    | 100    | F1       |
And I save the current editor

# Auftrag
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "18.01.2002" with Command Revalue
Given I set the fake date to "19.01.2002"
Given I open an editor "1AU015" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU015 |
   | kunde  | 1      |
   | waehr  | EUR    |
And I append rows
   | artikel | mge | preis |
   | 13vo    | 100 | 20.00 | 
And I save the current editor

# Lieferschein
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "19.01.2002" with Command Revalue
Given I set the fake date to "20.01.2002"
Given I open an editor "1VLS015" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "1AU015"
And I set fields
   | nummer | 1VKLS1|
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "100" in row 1
And I set field "platz" to "F1" in row 1
And I save the current editor

# Ruecklieferschein
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "20.01.2002" with Command Revalue
Given I set the fake date to "21.01.2002"
Given I open an editor "1VRLS015" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1VKLS1"
And I set fields
   | nummer | 1VKRLS1 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-40" in row 1
And I save the current editor

# Teilrechnung1
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "21.01.2002" with Command Revalue
Given I set the fake date to "22.01.2002"
Given I open an editor "1VRE015" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "1VKLS1"
And I set fields
   | nummer   | 1VKRE1 |
   | ueb      | ja     |
   | vom      | .      |
   | tterm    | +10    |
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilrechnung2
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "22.01.2002" with Command Revalue
Given I set the fake date to "23.01.2002"
Given I open an editor "2VRE015" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "1VKLS1"
And I set fields
   | nummer   | 2VKRE1 |
   | ueb      | ja     |
   | vom      | .      |
   | tterm    | +12    |
And I set field "mge" to "60" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Storno Ruecklieferschein - nicht erlaubt, erst Rechnung stornieren
Given opening an editor from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "+1VKRLS1" throws the exception "149"
Given opening an editor from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "1VKRLS1" throws the exception "3335"

# Storno VK Teilrechnung1
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "23.01.2002" with Command Revalue
Given I set the fake date to "24.01.2002"
Given I open an editor "sto-trechnung1" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+1VKRE1"
And I set field "nummer" to "1VKRE1S"
And I save the current editor

# die plausis im VK richten sich meist auch nach denen im EK bzw. einheitlich in beiden modulen
# nicht abgelegte RLS können nicht storniert werden, wenn eine RE nach dem RLS gebucht wurde. 
# Hinweis: dieses Plausi kam aus dem Einkauf wg. Bewertungen 

# Storno VK-Ruecklieferschein
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "24.01.2002" with Command Revalue
Given I set the fake date to "25.01.2002"
Given I open an editor "vk-rlsstorno" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "+1VKRLS1"
And I set field "nummer" to "1VKRLS1S"
And I save the current editor

# VK-Restrechnung
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "25.01.2002" with Command Revalue
Given I set the fake date to "26.01.2002"
Given I open an editor "3VRE015" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "1VKLS1"
And I set fields
   | nummer   | 3VKRE1 |
   | ueb      | ja     |
   | vom      | .      |
   | tterm    | +12    |
And I set field "preis" to "15" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "31.01.2002" with Command Revalue

