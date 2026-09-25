# *****************************************************************************
#  Name             : rueckbuchung_verw_geaendert.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Rueckbuchung mit durch Umbuchung geaenderter Verwendung
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_verw_geaendert.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: Rueckbau auf BA nach Aenderung von Verwendung der gebuchten Gutmenge
Given I set StorageQuantity to zero for Product "BG-AUFTRAG" on StorageLocation "F1" with document "korr1"

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel       | netmge    | verw      | bisuch    | mfreig    |
    | BG-AUFTRAG    | 50        | test1     | TEST1     | ja        |
And I press button "freig" to open a subeditor for "fv_freigeben"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Teil-Rueckmeldung auf BA
Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEST1000"
And I set fields
    | sofort    | ja    |
    | mgr       | 112   |
And I set field "gutmge" to "10" in row 1
And I save the current editor

# Bestand liegt mit Verwendung am Lager
Given I open the infosystem "BESTAND"
And I set field "artikel" to "BG-AUFTRAG"
And I set field "details" to "nein"
And I press start
And I press button "taufzu" in row 1
Then table has values
    | tartikel      | lemge | gebmge    | verw  |
    | BG-AUFTRAG    | 10    |           |       |
    | BG-AUFTRAG    |       | 10        | test1 |
And I close the current editor

# Gesamte Menge auf unscharfe Verwendung umbuchen
Given I open an editor "ManuelleLagerbuchung" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
    | artikel   | BG-AUFTRAG    |
    | buart     | Umbuchung     |
    | beldat    | .             |
And I modify table
    | !row  | mge   | verw  | verw2 | platz | platz2    |
    | 1     | 10    | test1 | test  | F1    | F1        |
And I save the current editor

# Bestand liegt mit unscharfer Verwendung am Lager
Given I open the infosystem "BESTAND"
And I set field "artikel" to "BG-AUFTRAG"
And I set field "details" to "nein"
And I press start
And I press button "taufzu" in row 1
Then table has values
    | tartikel      | lemge | gebmge    | verw  |
    | BG-AUFTRAG    | 10    |           |       |
    | BG-AUFTRAG    |       | 10        | test  |
And I close the current editor

# Teil-Rueckbau auf BA
Given I open an editor "Rueckbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "TEST1000"
And I set fields
    | sofort    | ja    |
    | mgr       | 112   |
And I set field "gutmge" to "-3" in row 1
And I save the current editor

# Bestand hat sich um 3 verringert
Given I open the infosystem "BESTAND"
And I set field "artikel" to "BG-AUFTRAG"
And I set field "details" to "nein"
And I press start
And I press button "taufzu" in row 1
Then table has values
    | tartikel      | lemge | gebmge    | verw  |
    | BG-AUFTRAG    | 7     |           |       |
    | BG-AUFTRAG    |       | 7         | test  |
And I close the current editor

# Rueckbau stornieren
Given I open an editor "Storno_Rueckbau1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=test1000;typa279=Rueckbau auf Betriebsauftrag;@richtung=rueckwaerts;@maxtreffer=1"
And I save the current editor

# Bestand hat sich um 3 erhoeht
Given I open the infosystem "BESTAND"
And I set field "artikel" to "BG-AUFTRAG"
And I set field "details" to "nein"
And I press start
And I press button "taufzu" in row 1
Then table has values
    | tartikel      | lemge | gebmge    | verw  |
    | BG-AUFTRAG    | 10    |           |       |
    | BG-AUFTRAG    |       | 7         | test  |
    | BG-AUFTRAG    |       | 3         | test1 |
And I close the current editor

# Rueckbau auf BA
Given I open an editor "Rueckbau2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "TEST1000"
And I set fields
    | sofort    | ja    |
    | mgr       | 112   |
And I set field "gutmge" to "-10" in row 1
And I save the current editor

# Bestand ist null
Given I open the infosystem "BESTAND"
And I set field "artikel" to "BG-AUFTRAG"
And I set field "details" to "nein"
And I press start
And I press button "taufzu" in row 1
Then table has values
    | tartikel      | lemge | gebmge    | verw  |
    | BG-AUFTRAG    |       |           |       |
And I close the current editor

# Rueckgabe2 stornieren
Given I open an editor "Storno_Rueckbau2" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=test1000;typa279=Rueckbau auf Betriebsauftrag;@richtung=rueckwaerts;@maxtreffer=1"
And I save the current editor

# Bestand ist 10
Given I open the infosystem "BESTAND"
And I set field "artikel" to "BG-AUFTRAG"
And I set field "details" to "nein"
And I press start
And I press button "taufzu" in row 1
Then table has values
    | tartikel      | lemge | gebmge    | verw  |
    | BG-AUFTRAG    | 10    |           |       |
    | BG-AUFTRAG    |       | 10        | test1 |
And I close the current editor

# BA loeschen
Given I open an editor "BA_test1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=TEST1000;verw=test1;@richtung=rueckwaerts;@maxtreffer=1"
And I respond with answer "ja" to the dialog with id "345"
And I set field "status" to "s"
And I save the current editor



Scenario: Rueckbau auf BA nach Aenderung von Projekt und Verwendung der gebuchten Gutmenge
Given I set StorageQuantity to zero for Product "BG-AUFTRAG" on StorageLocation "F1" with document "korr1"

Given I open an editor "PROJEKT-T" from table "(Transaction):(Project)" with command "STORE" for record "PROJEKT-T"
And I set field "such" to "PROJEKT-T"
And I save the current editor

Given I open an editor "PROJEKT2" from table "(Transaction):(Project)" with command "STORE" for record "PROJEKT2"
And I set field "such" to "PROJEKT2"
And I save the current editor

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel       | netmge    | verw      | projekt   | bisuch    | mfreig    |
    | BG-AUFTRAG    | 50        | test2     | PROJEKT-T | TEST2     | ja        |
And I press button "freig" to open a subeditor for "fv_freigeben"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Teil-Rueckmeldung auf BA
Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEST2000"
And I set fields
    | sofort    | ja    |
    | mgr       | 112   |
And I set field "gutmge" to "10" in row 1
And I save the current editor

# Bestand liegt mit Verwendung am Lager
Given I open the infosystem "BESTAND"
And I set field "artikel" to "BG-AUFTRAG"
And I set field "details" to "nein"
And I press start
And I press button "taufzu" in row 1
Then table has values
    | tartikel      | lemge | gebmge    | verw  | projekt   |
    | BG-AUFTRAG    | 10    |           |       |           |
    | BG-AUFTRAG    |       | 10        | test2 | PROJEKT-T |
And I close the current editor

# Gesamte Menge auf unscharfe Verwendung umbuchen
Given I open an editor "ManuelleLagerbuchung" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
    | artikel   | BG-AUFTRAG    |
    | buart     | Umbuchung     |
    | beldat    | .             |
And I modify table
    | !row  | mge   | verw  | verw2 | projekt   | projekt2  | platz | platz2    |
    | 1     | 10    | test2 | verw  | PROJEKT-T | PROJEKT2  | F1    | F1        |
And I save the current editor

# Bestand liegt mit unscharfer Verwendung am Lager
Given I open the infosystem "BESTAND"
And I set field "artikel" to "BG-AUFTRAG"
And I set field "details" to "nein"
And I press start
And I press button "taufzu" in row 1
Then table has values
    | tartikel      | lemge | gebmge    | verw  | projekt   |
    | BG-AUFTRAG    | 10    |           |       |           |
    | BG-AUFTRAG    |       | 10        | verw  | PROJEKT2  |
And I close the current editor

# Teil-Rueckbau auf BA
Given I open an editor "Rueckbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "TEST2000"
And I set fields
    | sofort    | ja    |
    | mgr       | 112   |
And I set field "gutmge" to "-3" in row 1
And I save the current editor

# Bestand hat sich um 3 verringert
Given I open the infosystem "BESTAND"
And I set field "artikel" to "BG-AUFTRAG"
And I set field "details" to "nein"
And I press start
And I press button "taufzu" in row 1
Then table has values
    | tartikel      | lemge | gebmge    | verw  | projekt  |
    | BG-AUFTRAG    | 7     |           |       |          |
    | BG-AUFTRAG    |       | 7         | verw  | PROJEKT2 |
And I close the current editor

# Rueckbau stornieren
Given I open an editor "Storno_Rueckbau1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=test2000;typa279=Rueckbau auf Betriebsauftrag;@richtung=rueckwaerts;@maxtreffer=1"
And I save the current editor

# Bestand hat sich um 3 erhoeht
Given I open the infosystem "BESTAND"
And I set field "artikel" to "BG-AUFTRAG"
And I set field "details" to "nein"
And I press start
And I press button "taufzu" in row 1
Then table has values
    | tartikel      | lemge | gebmge    | verw  | projekt   |
    | BG-AUFTRAG    | 10    |           |       |           |
    | BG-AUFTRAG    |       | 3         | test2 | PROJEKT-T |
    | BG-AUFTRAG    |       | 7         | verw  | PROJEKT2  |
And I close the current editor

# Rueckbau auf BA
Given I open an editor "Rueckbau2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "TEST2000"
And I set fields
    | sofort    | ja    |
    | mgr       | 112   |
And I set field "gutmge" to "-10" in row 1
And I save the current editor

# Bestand ist null
Given I open the infosystem "BESTAND"
And I set field "artikel" to "BG-AUFTRAG"
And I set field "details" to "nein"
And I press start
And I press button "taufzu" in row 1
Then table has values
    | tartikel      | lemge | gebmge    | verw  | projekt  |
    | BG-AUFTRAG    |       |           |       |          |
And I close the current editor

# Rueckgabe2 stornieren
Given I open an editor "Storno_Rueckbau2" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=test2000;typa279=Rueckbau auf Betriebsauftrag;@richtung=rueckwaerts;@maxtreffer=1"
And I save the current editor

# Bestand ist 10
Given I open the infosystem "BESTAND"
And I set field "artikel" to "BG-AUFTRAG"
And I set field "details" to "nein"
And I press start
And I press button "taufzu" in row 1
Then table has values
    | tartikel      | lemge | gebmge    | verw  | projekt   |
    | BG-AUFTRAG    | 10    |           |       |           |
    | BG-AUFTRAG    |       | 10        | test2 | PROJEKT-T |
And I close the current editor

# BA loeschen
Given I open an editor "BA_test1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=TEST2000;verw=test2;@richtung=rueckwaerts;@maxtreffer=1"
And I respond with answer "ja" to the dialog with id "345"
And I set field "status" to "s"
And I save the current editor



Scenario: Rueckbau auf BA nach aenderung von Verwendung auf leere Verwendung der gebuchten Gutmenge
Given I set StorageQuantity to zero for Product "BG-AUFTRAG" on StorageLocation "F1" with document "korr1"

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel       | netmge    | verw      | bisuch    | mfreig    |
    | BG-AUFTRAG    | 50        | test3     | TEST3     | ja        |
And I press button "freig" to open a subeditor for "fv_freigeben"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Teil-Rueckmeldung auf BA
Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEST3000"
And I set fields
    | sofort    | ja    |
    | mgr       | 112   |
And I set field "gutmge" to "10" in row 1
And I save the current editor

# Bestand liegt mit Verwendung am Lager
Given I open the infosystem "BESTAND"
And I set field "artikel" to "BG-AUFTRAG"
And I set field "details" to "nein"
And I press start
And I press button "taufzu" in row 1
Then table has values
    | tartikel      | lemge | gebmge    | verw  |
    | BG-AUFTRAG    | 10    |           |       |
    | BG-AUFTRAG    |       | 10        | test3 |
And I close the current editor

# Gesamte Menge auf unscharfe Verwendung umbuchen
Given I open an editor "ManuelleLagerbuchung" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
    | artikel   | BG-AUFTRAG    |
    | buart     | Umbuchung     |
    | beldat    | .             |
And I modify table
    | !row  | mge   | verw  | verw2 | platz | platz2    |
    | 1     | 10    | test3 |       | F1    | F1        |
And I save the current editor

# Bestand liegt mit unscharfer Verwendung am Lager
Given I open the infosystem "BESTAND"
And I set field "artikel" to "BG-AUFTRAG"
And I set field "details" to "nein"
And I press start
And I press button "taufzu" in row 1
Then table has values
    | tartikel      | lemge | gebmge    | verw  |
    | BG-AUFTRAG    | 10    |           |       |
    | BG-AUFTRAG    |       | 10        |       |
And I close the current editor

# Teil-Rueckbau auf BA
Given I open an editor "Rueckbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "TEST3000"
And I set fields
    | sofort    | ja    |
    | mgr       | 112   |
And I set field "gutmge" to "-3" in row 1
And I save the current editor

# Bestand hat sich um 3 verringert
Given I open the infosystem "BESTAND"
And I set field "artikel" to "BG-AUFTRAG"
And I set field "details" to "nein"
And I press start
And I press button "taufzu" in row 1
Then table has values
    | tartikel      | lemge | gebmge    | verw  |
    | BG-AUFTRAG    | 7     |           |       |
    | BG-AUFTRAG    |       | 7         |       |
And I close the current editor

# Rueckbau stornieren
Given I open an editor "Storno_Rueckbau1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=test3000;typa279=Rueckbau auf Betriebsauftrag;@richtung=rueckwaerts;@maxtreffer=1"
And I save the current editor

# Bestand hat sich um 3 erhoeht
Given I open the infosystem "BESTAND"
And I set field "artikel" to "BG-AUFTRAG"
And I set field "details" to "nein"
And I press start
And I press button "taufzu" in row 1
Then table has values
    | tartikel      | lemge | gebmge    | verw  |
    | BG-AUFTRAG    | 10    |           |       |
    | BG-AUFTRAG    |       | 7         |       |
    | BG-AUFTRAG    |       | 3         | test3 |
And I close the current editor

# Rueckbau auf BA
Given I open an editor "Rueckbau2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "TEST3000"
And I set fields
    | sofort    | ja    |
    | mgr       | 112   |
And I set field "gutmge" to "-10" in row 1
And I save the current editor

# Bestand ist null
Given I open the infosystem "BESTAND"
And I set field "artikel" to "BG-AUFTRAG"
And I set field "details" to "nein"
And I press start
And I press button "taufzu" in row 1
Then table has values
    | tartikel      | lemge | gebmge    | verw  |
    | BG-AUFTRAG    |       |           |       |
And I close the current editor

# Rueckgabe2 stornieren
Given I open an editor "Storno_Rueckbau2" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=test3000;typa279=Rueckbau auf Betriebsauftrag;@richtung=rueckwaerts;@maxtreffer=1"
And I save the current editor

# Bestand ist 10
Given I open the infosystem "BESTAND"
And I set field "artikel" to "BG-AUFTRAG"
And I set field "details" to "nein"
And I press start
And I press button "taufzu" in row 1
Then table has values
    | tartikel      | lemge | gebmge    | verw  |
    | BG-AUFTRAG    | 10    |           |       |
    | BG-AUFTRAG    |       | 10        | test3 |
And I close the current editor

# BA loeschen
Given I open an editor "BA_test1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=TEST3000;@richtung=rueckwaerts;@maxtreffer=1"
And I respond with answer "ja" to the dialog with id "345"
And I set field "status" to "s"
And I save the current editor
