# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Umlagern_Plausis.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Plausis bei Umlagerungen mit Behaeltern
#  ref              : ref_behaelter_umlagern_cu
#  Stammdaten       : VERSAND_BEHAELTER_Stammdaten.feature
#
# *****************************************************************************
@persistent
Feature: VERSAND_BEHAELTER_Umlagern_Plausis.feature
Background:
Given I set the fake date to "02.01.1995"

##################################################################################################################

Scenario: 01 Leerer Behaelter in Umlagerungsvorschlag, -bestellung oder -lieferschein nicht erlaubt

And I create a Container "behaelter_01p" for packaging material "KLT"

# leerer Behaelter in Umlagerungsvorschlag bringt Fehlermeldung
Given I open an editor "Umlagerungsvorschlag01_a" from table "(Purchasing):(RelocationSuggestions)" with command "NEW" for record ""
And I modify table
    | !row | artikel | lief     | mge | abplatz | platz |
    | +1   | KLINGEL | KETTLER  | 2   | F1      | L2F1  |
# Fehler 8343: Der angegebene Behaelter ist leer
Then setting field "behaelter" to "!behaelter_01p^id" in row 1 throws the exception "8343"
And I close the current editor

# leerer Behaelter in Umlagerungsbestellung bringt Fehlermeldung
Given I open an editor "Bestellung01_b" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | such  | B01_A    |
    | lief  | KETTLER  |
    | bsart | Umlagern |
And I append rows
    | artikel | mge | abplatz | platz |
    | SATTEL  | 10  | F1      | L2F1  |
# Fehler 8343: Der angegebene Behaelter ist leer
Then setting field "behaelter" to "!behaelter_01p^id" in row 1 throws the exception "8343"
And I close the current editor

# leerer Behaelter in Umlagerungslieferschein im Einkauf bringt Fehlermeldung
Given I open an editor "Einkaufslieferschein01_c" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | ebeleg | L01_C    |
    | lief   | KETTLER  |
    | bsart  | Umlagern |
    | vom    | .        |
And I append rows
    | artikel | mge | abplatz | platz |
    | RAHMEN  | 30  | F1      | L2F1  |
# Fehler 8343: Der angegebene Behaelter ist leer
Then setting field "behaelter" to "!behaelter_01p^id" in row 1 throws the exception "8343"
And I close the current editor


Scenario: 02 Artikel ist nicht im Behaelter

And I create a Container "behaelter_02p" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "SATTEL" and quantity "5" on StorageLocation "F1" with document "L02-PZU" and Container "behaelter_02p"

# Artikel ist nicht im Behaelter bei Umlagerungsvorschlag
Given I open an editor "Umlagerungsvorschlag02_a" from table "(Purchasing):(RelocationSuggestions)" with command "NEW" for record ""
And I modify table
    | !row | artikel | lief     | mge | abplatz | platz |
    |  +1  | KLINGEL | KETTLER  | 2   | F1      | L2F1  |
# Fehler 8311: Der Artikel ist nicht mit den passenden Gebindeinformationen im Behaelter enthalten.
Then setting field "behaelter" to "!behaelter_02p^id" in row 1 throws the exception "8311"
And I close the current editor

# Artikel ist nicht im Behaelter bei Bestellung
Given I open an editor "Bestellung02_b" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | such  | B02_A    |
    | lief  | KETTLER  |
    | bsart | Umlagern |
And I delete all rows
And I append rows
    | artikel | mge | abplatz | platz |
    | RAD     | 10  | F1      | L2F1  |
# Fehler 8311: Der Artikel ist nicht mit den passenden Gebindeinformationen im Behaelter enthalten.
Then setting field "behaelter" to "!behaelter_02p^id" in row 1 throws the exception "8311"
And I close the current editor

# Artikel ist nicht im Behaelter bei Umlagerungslieferschein im Einkauf
Given I open an editor "Einkaufslieferschein02_c" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | ebeleg | L02_C    |
    | lief   | KETTLER  |
    | bsart  | Umlagern |
    | vom    | .        |
And I delete all rows
And I append rows
    | artikel | mge | abplatz | platz |
    | RAHMEN  | 30  | F1      | L2F1  |
# Fehler 8311: Der Artikel ist nicht mit den passenden Gebindeinformationen im Behaelter enthalten.
Then setting field "behaelter" to "!behaelter_02p^id" in row 1 throws the exception "8311"
And I close the current editor

# FDA-4085 nach Behebung des Bugs die Zeilen einkommentieren
Scenario: 03 Artikel ist nicht mit passenden Gebindeinfos im Behaelter

And I create a Container "behaelter_03p" for packaging material "KLT"

And I create a Lot "CHARGE_03p1" for Product "SATTEL"
And I create a Lot "CHARGE_03p2" for Product "SATTEL"

Given I open an editor "Lagerbuchung_03p" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | SATTEL  |
    | buart   | Zugang  |
    | beleg   | L03-PZU |
    | beldat  | .       |
And I modify table
    | !row | mge | platz2 | charge2     | behaelter             |
    |   1  | 5   | F1     | CHARGE_03p1 | !behaelter_03p^id     |
And I save the current editor

Given I open an editor "Umlagerungsvorschlag03_a" from table "(Purchasing):(RelocationSuggestions)" with command "NEW" for record ""
And I set fields
    | beleg   | Umbuchen_03a |
    | beldat  | .            |
And I modify table
    | !row | artikel | lief    | mge | charge      | abplatz | platz | behaelter         | mfreig |
    | +1   | SATTEL  | KETTLER | 5   | CHARGE_03p2 | F1      | L2F1  | !behaelter_03p^id | ja     |
# Fehler 158: Der Artikel ist nicht oder nicht ausreichend mit passender Auspraegung im Behaelter
# Button "umbuchen" - direktes Umbuchen
Then pressing button "umbuchen" in row 0 to open a subeditor throws the exception "158"
# Fehler 158: Der Artikel ist nicht oder nicht ausreichend mit passender Auspraegung im Behaelter
# Button "freig" - Umlagerungsbestellung anlegen
And I press button "freig" to open a subeditor for "Bestellung_03a"
Then message "Der Artikel ist nicht oder nicht ausreichend mit passender Ausprägung im Behälter." was displayed
And I close the current editor
And I switch the current editor to editor "Umlagerungsvorschlag03_a"
And I close the current editor

# Artikel ist nicht mit Gebindeinfos im Behaelter bei Bestellung
Given I open an editor "Bestellung03_b" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | such  | B03_B    |
    | lief  | KETTLER  |
    | bsart | Umlagern |
And I modify table
    | !row | artikel | mge | charge      | abplatz | platz | behaelter         |
    | +1   | SATTEL  | 5   | CHARGE_03p2 | F1      | L2F1  | !behaelter_03p^id |
# Fehler 158: Der Artikel ist nicht oder nicht ausreichend mit passender Auspraegung im Behaelter
And I save the current editor
Then message "Der Artikel ist nicht oder nicht ausreichend mit passender Ausprägung im Behälter." was displayed

# Artikel ist nicht mit Gebindeinfos im Behaelter bei Umlagerungslieferschein im Einkauf
Given I open an editor "Einkaufslieferschein03_c" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | ebeleg | L03_C    |
    | lief   | KETTLER  |
    | bsart  | Umlagern |
    | vom    | .        |
    | ueb    | ja       |
And I modify table
    | !row | artikel | mge | charge      | abplatz | platz | behaelter         |
    | +1   | SATTEL  | 5   | CHARGE_03p2 | F1      | L2F1  | !behaelter_03p^id |
# Fehler 158: Der Artikel ist nicht oder nicht ausreichend mit passender Auspraegung im Behaelter
Then saving the current editor throws the exception "158"
And I close the current editor

# FDA-4085 nach Behebung des Bugs die Zeilen einkommentieren
Scenario: 04 Gesamte Menge im Behaelter muss versendet werden

And I create a Container "behaelter_04p" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "SATTEL" and quantity "5" on StorageLocation "F1" with document "L04PZU" and Container "behaelter_04p"

# Gesamte Menge im Behaelter muss versendet werden bei Umlagerungsvorschlag
Given I open an editor "Umlagerungsvorschlag04_a" from table "(Purchasing):(RelocationSuggestions)" with command "NEW" for record ""
And I set fields
    | beleg   | Umbuchen_04a |
    | beldat  | .            |
And I modify table
    | !row | artikel | lief    | mge | abplatz | platz | behaelter         | mfreig |
    | +1   | SATTEL  | KETTLER | 2   | F1      | L2F1  | !behaelter_04p^id | ja     |
# Fehler 8367: Es kann nur der gesamte Inhalt eines Behaelters verschickt werden.
# Button "umbuchen" - direktes Umbuchen
Then pressing button "umbuchen" in row 0 to open a subeditor throws the exception "8367"
# Fehler 8367: Es kann nur der gesamte Inhalt eines Behaelters verschickt werden.
# Button "freig" - Umlagerungsbestellung anlegen
And I press button "freig" to open a subeditor for "Bestellung_04a"
Then message "Es kann nur der gesamte Inhalt eines Behälters verschickt werden." was displayed
And I close the current editor
And I switch the current editor to editor "Umlagerungsvorschlag04_a"
And I close the current editor

# Gesamte Menge im Behaelter muss versendet werden bei Bestellung
Given I open an editor "Bestellung04_b" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | such  | B04_B    |
    | lief  | KETTLER  |
    | bsart | Umlagern |
And I modify table
    | !row | artikel | mge | abplatz | platz | behaelter         |
    | +1   | SATTEL  | 2   | F1      | L2F1  | !behaelter_04p^id |
# Fehler 8637: Es kann nur der gesamte Inhalt eines Behälters verschickt werden.
And I save the current editor
Then message "Es kann nur der gesamte Inhalt eines Behälters verschickt werden." was displayed

# Gesamte Menge im Behaelter muss versendet werden bei Umlagerungslieferschein im Einkauf
Given I open an editor "Einkaufslieferschein04_c" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | ebeleg | L04_C    |
    | lief   | KETTLER  |
    | bsart  | Umlagern |
    | vom    | .        |
    | ueb    | ja       |
And I modify table
    | !row | artikel | mge | abplatz | platz | behaelter         |
    | +1   | SATTEL  | 2   | F1      | L2F1  | !behaelter_04p^id |
# Fehler 8637: Es kann nur der gesamte Inhalt eines Behälters verschickt werden.
Then saving the current editor throws the exception "8367"
And I close the current editor

# FDA-4085 nach Behebung des Bugs die Zeilen einkommentieren
Scenario: 05 Gesamter Behaelterinhalt muss versendet werden

And I create a Container "behaelter_05p" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "RAHMEN" and quantity "5" on StorageLocation "F1" with document "L05PZU" and Container "behaelter_05p"
And I post a receipt via ManualStockAdjustment for Product "RAD" and quantity "5" on StorageLocation "F1" with document "L05PZU" and Container "behaelter_05p"

# Gesamter Behaelterinhalt muss versendet werden bei Umlagerungsvorschlag
Given I open an editor "Umlagerungsvorschlag05_a" from table "(Purchasing):(RelocationSuggestions)" with command "NEW" for record ""
And I set fields
    | beleg   | Umbuchen_05a |
    | beldat  | .            |
And I modify table
    | !row | artikel | lief    | mge | abplatz | platz | behaelter         | mfreig |
    | +1   | RAHMEN  | KETTLER | 5   | F1      | L2F1  | !behaelter_05p^id | ja     |
# Fehler 8367: Es kann nur der gesamte Inhalt eines Behaelters verschickt werden.
# Button "umbuchen" - direktes Umbuchen
Then pressing button "umbuchen" in row 0 to open a subeditor throws the exception "8367"
# Fehler 8367: Es kann nur der gesamte Inhalt eines Behaelters verschickt werden.
# Button "freig" - Umlagerungsbestellung anlegen
And I press button "freig" to open a subeditor for "Bestellung_05a"
Then message "Es kann nur der gesamte Inhalt eines Behälters verschickt werden." was displayed
And I close the current editor
And I switch the current editor to editor "Umlagerungsvorschlag05_a"
And I close the current editor

# Gesamter Behaelterinhalt muss versendet werden bei Bestellung
Given I open an editor "Bestellung05_b" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | such  | B05_B    |
    | lief  | KETTLER  |
    | bsart | Umlagern |
And I modify table
    | !row | artikel | mge | abplatz | platz | behaelter         |
    | +1   | RAHMEN  | 5   | F1      | L2F1  | !behaelter_05p^id |
# Fehler 8367: Es kann nur der gesamte Inhalt eines Behaelters verschickt werden.
And I save the current editor
Then message "Es kann nur der gesamte Inhalt eines Behälters verschickt werden." was displayed

# Gesamter Behaelterinhalt muss versendet werden bei Umlagerungslieferschein im Einkauf
Given I open an editor "Einkaufslieferschein05_c" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | ebeleg | L05_C    |
    | lief   | KETTLER  |
    | bsart  | Umlagern |
    | vom    | .        |
    | ueb    | ja       |
And I modify table
    | !row | artikel | mge | abplatz | platz | behaelter         |
    | +1   | RAHMEN  | 5   | F1      | L2F1  | !behaelter_05p^id |
# Fehler 8367: Es kann nur der gesamte Inhalt eines Behaelters verschickt werden.
Then saving the current editor throws the exception "8367"
And I close the current editor


Scenario: 06 Behaelter liegt nicht auf Abgangslagerplatz

And I create a Container "behaelter_06p" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "RAHMEN" and quantity "5" on StorageLocation "F2" with document "L06PZU" and Container "behaelter_06p"

# Behaelter liegt nicht auf Abgangslagerplatz bei Umlagerungsvorschlag
Given I open an editor "Umlagerungsvorschlag06_a" from table "(Purchasing):(RelocationSuggestions)" with command "NEW" for record ""
And I set fields
    | beleg   | Umbuchen_06a |
    | beldat  | .            |
And I modify table
    | !row | artikel | lief    | mge | abplatz | platz |
    | +1   | RAHMEN  | KETTLER | 5   | F1      | L2F1  |
# Fehler 8334: Behaelter liegt nicht auf dem Abgangslagerplatz.
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_06p" in row 0 throws the exception "8334"
And I close the current editor

# Behaelter liegt nicht auf Abgangslagerplatz bei Bestellung
Given I open an editor "Bestellung06_b" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | such  | B06_B    |
    | lief  | KETTLER  |
    | bsart | Umlagern |
And I modify table
    | !row | artikel | mge | abplatz | platz |
    | +1   | RAHMEN  | 5   | F1      | L2F1  |
# Fehler 8334: Behaelter liegt nicht auf dem Abgangslagerplatz.
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_06p" in row 0 throws the exception "8334"
And I close the current editor

# Behaelter liegt nicht auf Abgangslagerplatz bei Umlagerungslieferschein im Einkauf
Given I open an editor "Einkaufslieferschein06_c" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | ebeleg | L06_C    |
    | lief   | KETTLER  |
    | bsart  | Umlagern |
    | vom    | .        |
    | ueb    | ja       |
And I modify table
    | !row | artikel | mge | abplatz | platz |
    | +1   | RAHMEN  | 5   | F1      | L2F1  |
# Fehler 8334: Behaelter liegt nicht auf dem Abgangslagerplatz.
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_06p" in row 0 throws the exception "8334"
And I close the current editor


Scenario: 07 Behaelter in mehreren Zeilen mit unterschiedlichen Zugangsplaetzen eingetragen
# Behaelter anlegen und befuellen
And I create a Container "behaelter_07p" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "RAHMEN" and quantity "5" on StorageLocation "F1" with document "L07PZU" and Container "behaelter_07p"

# Behaelter in mehreren Zeilen mit unterschiedlichen Zugangsplaetzen eingetragen bei Umlagerungsvorschlag
Given I open an editor "Umlagerungsvorschlag07_a" from table "(Purchasing):(RelocationSuggestions)" with command "NEW" for record ""
And I set field "beleg" to "Umbuchen_07a"
And I set field "beldat" to "."
And I modify table
    | !row | artikel | lief    | mge | abplatz | platz | behaelter         | mfreig |
    | +1   | RAHMEN  | KETTLER | 3   | F1      | L2F1  | !behaelter_07p^id | ja     |
    | +1   | RAHMEN  | KETTLER | 2   | F1      | L3F1  | !behaelter_07p^id | ja     |
# Fehler 8391: Gleiche Behaelternummer, abweichender Lagerplatz
Then pressing button "umbuchen" in row 0 to open a subeditor throws the exception "8391"
And I close the current editor

# Behaelter in mehreren Zeilen mit unterschiedlichen Zugangsplaetzen eingetragen bei Bestellung
Given I open an editor "Bestellung07_b" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | such  | B07_B    |
    | lief  | KETTLER  |
    | bsart | Umlagern |
And I modify table
    | !row | artikel | mge | abplatz | platz | behaelter         |
    | +1   | RAHMEN  | 2   | F1      | L2F1  | !behaelter_07p^id |
    | +1   | RAHMEN  | 3   | F1      | L3F1  | !behaelter_07p^id |
# Fehler 8391: Gleiche Behaelternummer, abweichender Lagerplatz
Then saving the current editor throws the exception "8391"
And I close the current editor

# Behaelter in mehreren Zeilen mit unterschiedlichen Zugangsplaetzen eingetragen bei Umlagerungslieferschein im Einkauf
Given I open an editor "Einkaufslieferschein07_c" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | ebeleg | L07_C    |
    | lief   | KETTLER  |
    | bsart  | Umlagern |
    | vom    | .        |
    | ueb    | ja       |
And I modify table
    | !row | artikel | mge | abplatz | platz | behaelter         |
    | +1   | RAHMEN  | 4   | F1      | L2F1  | !behaelter_07p^id |
    | +1   | RAHMEN  | 1   | F1      | L3F1  | !behaelter_07p^id |
# Fehler 8391: Gleiche Behaelternummer, abweichender Lagerplatz
Then saving the current editor throws the exception "8391"
And I close the current editor


Scenario: 08 Leerer Behaelter im Abgangsbehaelterfeld beim Umbuchen mit umplatz wird abgelehnt
# Behaelter anlegen und befuellen
And I create a Container "behaelter_08p" for packaging material "KLT"

# Leerer Behaelter im Abgangsbehaelterfeld beim Umbuchen mit umplatz wird abgelehnt im Einkaufslieferschein
Given I open an editor "EKLS_08ap" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | EKLS_08ap |
    | ueb       | ja        |
    | umplatz   | F1        |
And I modify table
    | !row    | artikel     | mge | platz |
    | +1      | SATTEL      | 5   | L2F1  |
And I press button "mzsubm" to open a subeditor for "MatZu_08ap" in row 1
And I delete all rows
And I append rows
    | zuomge | platz |
    | 5      | L2F1  |
# Fehler 8343: Der angegebene Behaelter ist leer
Then setting field "behaelterzu" in row 1 to "id" from editor "behaelter_08p" in row 0 throws the exception "8343"
And I close the current editor
And I switch the current editor to editor "EKLS_08ap"
And I close the current editor

# Leerer Behaelter im Abgangsbehaelterfeld beim Umbuchen mit umplatz wird abgelehnt im Verkaufslieferschein
Given I open an editor "VKLS_08bp" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde     | RADSHOP   |
    | such      | VKLS_08bp |
    | ueb       | ja        |
    | umplatz   | F1        |
And I modify table
    | !row    | artikel     | mge |
    | +1      | SATTEL      | 5   |
And I press button "mzsubm" to open a subeditor for "MatZu_08bp" in row 1
And I delete all rows
And I append rows
    | zuomge | platz |
    | 5      | L2F1  |
# Fehler 8343: Der angegebene Behaelter ist leer
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_08p" in row 0 throws the exception "8343"
And I close the current editor
And I switch the current editor to editor "VKLS_08bp"
And I close the current editor


Scenario: 09 Feld Abgangsbehaelter ist bereits gefuellt und ein gefuellter Behaelter auf Abgangsplatz wird in den Zugangsbehaelter eingtragen
# Behaelter anlegen und befuellen
And I create a Container "behaelter_09p-1" for packaging material "KLT"
And I create a Container "behaelter_09p-2" for packaging material "KLT"

And I post a receipt via ManualStockAdjustment for Product "RAHMEN" and quantity "5" on StorageLocation "F1" with document "L09PZU" and Container "behaelter_09p-1"
And I post a receipt via ManualStockAdjustment for Product "RAD" and quantity "5" on StorageLocation "F1" with document "L09PZU" and Container "behaelter_09p-2"

# Feld Abgangsbehaelter ist bereits gefuellt und ein gefuellter Behaelter auf Abgangsplatz wird in den Zugangsbehaelter eingtragen im Einkaufslieferschein
Given I open an editor "EKLS_09ap" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | EKLS_09ap |
    | ueb       | ja        |
    | umplatz   | F1        |
And I modify table
    | !row    | artikel | mge | platz |
    | +1      | RAHMEN  | 5   | L2F1  |
And I press button "mzsubm" to open a subeditor for "MatZu_09ap" in row 1
And I delete all rows
And I append rows
    | zuomge | platz | behaelterzu         |
    | 5      | L2F1  | !behaelter_09p-1^id |
# Fehler 11069: Gefuellter Behaelter auf einem anderen Lagerplatz
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_09p-2" in row 0 throws the exception "11069"
And I close the current editor
And I switch the current editor to editor "EKLS_09ap"
And I close the current editor

# Abgangsbehaelter ist bereits gefuellt und ein gefuellter Behaelter auf Abgangsplatz wird in den Zugangsbehaelter eingtragen im Verkaufslieferschein
Given I open an editor "VKLS_09bp" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde     | RADSHOP   |
    | such      | VKLS_09bp |
    | ueb       | ja        |
    | umplatz   | L2F1      |
And I modify table
    | !row    | artikel | mge |
    | +1      | RAHMEN  | 5   |
And I press button "mzsubm" to open a subeditor for "MatZu_09p" in row 1
And I delete all rows
And I append rows
    | zuomge | platz | behaelter           |
    | 5      | F1    | !behaelter_09p-1^id |
# Fehler 11069: Gefuellter Behaelter auf einem anderen Lagerplatz
Then setting field "behaelterzu" in row 1 to "id" from editor "behaelter_09p-2" in row 0 throws the exception "11069"
And I close the current editor
And I switch the current editor to editor "VKLS_09bp"
And I close the current editor
