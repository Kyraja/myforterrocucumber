# **********************************************************************************
#  Name             : rueckbuchung_umlagern_scenario02.feature
#  Autor            : bschiga
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Ruecklieferschein Einkauf wenn Zugang umgelagert wurde (FDA-2742)
#                     stammdaten.feature verwenden
#
# **********************************************************************************
@persistent
Feature: rueckbuchung_umlagern_scenario02.feature

Background:
And I set the fake date to "03.07.95"

Scenario: 02 Ruecklieferschein Einkauf wenn Zugang umgelagert wurde

# Lagergruppeneigenschaften im Artikelstamm anlegen, EINKAUF-1
Given I open an editor "EINKAUF-1" from table "(Part):(Product)" with command "UPDATE" for record "EINKAUF-1"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
    | lgruppe | dispoa         | bsart    | zuplatz | umllg     | lief |
    | BERLIN  | bedarfsbezogen | UMLAGERN | L3F1    | KARLSRUHE | TEST |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Bestandskorrektur auf 0 fuer Artikel EINKAUF-1
Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1"

# EK-Bestellung anlegen, 10
Given I create a PurchaseOrder "BE02" for Vendor "KETTLER" with Product "EINKAUF-1" and quantity "10"

# EK-LS aus EK-Bestellung erstellen und buchen
And I deliver the PurchaseOrder "BE02" with PackingSlip "LS-BE02"

# Umlagerungsvorschlag manuell erstellen und freigeben, 10 Stueck
Given I open an editor "UMLVOR" from table "(Purchasing):(RelocationSuggestions)" with command "NEW" for record ""
And I set field "lgruppe" to "BERLIN"
And I delete all rows
And I append rows
    | artikel   | mge | mfreig |
    | EINKAUF-1 |  10 | ja     |
Then field "abplatz" has value "F1" in row 1
Then field "platz" has value "L3F1" in row 1
And I press button "freig" to open a subeditor for "UML_freigeben"
And I set field "such" to "UMLBE02"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# Umlagerungslieferschein aus Umlagerungsbestellung erstellen und buchen, 10 Stueck
Given I open an editor "EK-Liefer" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "UMLBE02"
And I set fields
    | ebeleg | UMLLS_02 |
    | such   | UMLLS_02 |
    | vom    |  .       |
    | ueb    | ja       |
And I press button "offueb" in row 1
And I save the current editor

# Umlagerungsrechnung erstellen mit Transportkosten
Given I open an editor "EK-Rechnung" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "UMLLS_02"
And I set fields
     | ebeleg   | UMLRE_02 |
     | such     | UMLRE_02 |
     | vom      |  .       |
     | ueb      | ja       |
     | erfwaehr | DEM      |
And I set field "preis" to "2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein zum EK-LS, 10 Stueck
And I return the PurchasingPackingSlip "LS-BE02" with ReturnPackingSlip "RLS-BE02"

# Lagerjournaleintrag pruefen
Given I open the infosystem "LJ"
And I set field "adatum" to "-10"
And I set field "edatum" to "+30"
And I set field "artikel" to "EINKAUF-1"
And I set field "richtung" to "rueckwaerts"
And I press start
Then table has values
    | zmge | amge | detursache                      | nplatz | vplatz |
    | -10  |      | Rücklieferung Einkauf          | F1     |        |
    |  10  |      | Umlagerungsrechnung Einkauf     | L3F1   |        |
    |  10  |      | Umlagerungslieferschein Einkauf | L3F1   |        |
    |      |  10  | Umlagerungslieferschein Einkauf |        |  F1    |
    |  10  |      | Lieferschein Einkauf            | F1     |        |
And I close the current editor

# Journaleintrag selektieren von Umlagerungslieferschein Abgang
Given I open an editor "LJ_UML_ZU" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;ebeleg=UMLLS_02;buart=1;@richtung=rueckwaerts;@maxtreffer=1"
And I close the current editor

# Bewertung zu diesem Journaleintrag pruefen, additive Kosten sind korrekt gefuellt, inkl. Transportkosten aus Umlagerungsrechnung
Given I open latest Valuation "Bewertung_UML_ZU" for Product "EINKAUF-1" and valuation transaction "LJ_UML_ZU" with command "VIEW"
Then field "tbewpr" has value "7.2381" in row 1
Then field "addkosten" has value "2.0000" in row 1
And I close the current editor
