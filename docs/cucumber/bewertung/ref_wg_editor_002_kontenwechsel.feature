# *****************************************************************************
#  Name             : ref_wg_editor_002_kontenwechsel.feature
#  Autor            : wane
#  Verantwortlich   : sih
#  Kontrolle        : 
#  Funktion         : das Editieren von WG und Auswirkung auf die Bewertungen
#
#                    kurze Zusammenfassung von Bewertungsketten:
#                    ===========================================
#
# *****************************************************************************
@persistent
Feature: WG; Kontierungsfall M
Background: Test von Kontierungsfall 'M' -> besonders die Ersetzung der Konten
Given I set the fake date to "07.01.2002"


@FALL-Inland/EU/Ausland/mitLS
Scenario: Stammdaten; Lieferantenbeistellung Inland/EU/Ausland; mit LS
#
# Beschreibung:
#     1. Stammdaten werden vorbereitet
#     2. 2 LS vor der Umstellung angelegt/verbucht: 500LS1 und 600LS1
#     3. Konten in WG umgestellt
#     4. noch ein LS angelegt/verbucht: 500LS2
#     5. alle LS bezahlt -> uber RE
#

## ******* Start: Vorbereitung **********
#
# 2 neue Bestandskonten durch Kopieren angelegt
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "num5" to "10009"
And I set field "such" to "ROH_VERK"
And I set field "namebspr" to "Bestandskonto 9; Fertigung"
And I save the current editor
And I close the current editor
#
Given I open an editor "konto2" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "num5" to "10008"
And I set field "such" to "ROH_EINK"
And I set field "namebspr" to "Bestandskonto 8; Einkauf" 
And I save the current editor
And I close the current editor
#
# vorbereitete Warengruppe 65 bei einigen Artikeln einpflegen
Given I open an editor "artikel1" from table "(Part):(Product)" with command "COPY" for record "400beist"
And I set field "num2" to "500beist"
And I set field "such" to "EK-BEIST2"
And I set field "namebspr" to "EK-Teil2: mit Lief.-Beistellung"
And I set field "wgruppe" to "65"
And I save the current editor
And I close the current editor
#
Given I open an editor "artikel2" from table "(Part):(Product)" with command "UPDATE" for record "e1"
And I set field "wgruppe" to "65"
And I save the current editor
And I close the current editor
#
## ******* End: Vorbereitung **********

## ******* Start: Beistellartikel einkaufen/liefern **********
#
# Artikel mit Beistellung bestellen -> Inland
# Bestellung 1 anlegen
Given I open an editor "500beist-bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "num4" to "500BE"
And I set field "kenn" to "Inland"
And I set field "erfwaehr" to "EUR"
And I create a new row at the end of the table
And I set field "artex" to "500beist" in row 1
And I set field "mge" to "130" in row 1
And I set field "preis" to "75" in row 1
And I save the current editor
#
#
# EK-Lieferschein zu Bestellung 1 anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "500beist-bestellung"
And I set field "num4" to "500LS1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "30" in row 1
And I save the current editor
#
# 'einfachen' Artikel 'e1' bestellen
# Bestellung 2 anlegen
Given I open an editor "e1-bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "num4" to "600BE"
And I set field "kenn" to "Inland"
And I set field "erfwaehr" to "EUR"
And I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "50" in row 1
And I set field "preis" to "11" in row 1
And I save the current editor
#
#
# EK-Lieferschein zu Bestellung 2 anlegen
Given I open an editor "lieferschein-3" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "e1-bestellung"
And I set field "num4" to "600LS1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "50" in row 1
And I save the current editor
#
#
# =================  Start: WG; Kontenumstellung  =================
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
#
# Warengruppe: Bestandskonten austauschen
Given I open an editor "wgruppe" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "65"
And I set field "bestausekso" to "10008"
And I set field "bestausfert" to "10009"
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# =================  End: WG; Kontenumstellung  =================
# ab jetzt nur neue Ketten duerfen neu Konten haben.
# Alte/angefangenen Ketten muessen mit 'alten' Bestanskonten gefuehrt werden, 
# wenn der Vorgang keine Kontenaenderung (Konto bzw. VRGSTRGL anders) mitbringt
#
# EK-Lieferschein zu Bestellung 1 anlegen
Given I open an editor "lieferschein-2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "500beist-bestellung"
And I set field "num4" to "500LS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I save the current editor
#
# EK-Rechnung bezahlen
Given I open an editor "rechnung1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "500RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
Then field "artex" has value "EK-BEIST2" in row 1
And I set field "mge" to "30" in row 1
And I set field "preis" to "80" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#
#
# EK-Rechnung bezahlen
Given I open an editor "rechnung2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2"
And I set field "num4" to "500RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
Then field "artex" has value "EK-BEIST2" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "90" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#
# EK-Rechnung bezahlen
Given I open an editor "rechnung3" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-3"
And I set field "num4" to "600RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
Then field "artex" has value "E1" in row 1
And I set field "mge" to "50" in row 1
And I set field "preis" to "20" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
#
