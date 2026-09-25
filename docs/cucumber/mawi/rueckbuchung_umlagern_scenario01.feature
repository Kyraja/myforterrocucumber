# **********************************************************************************
#  Name             : rueckbuchung_umlagern_scenario01.feature
#  Autor            : bschiga
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Rueckbau aus Fertigung wenn Zugang umgelagert wurde (FDA-2742)
#                     stammdaten.feature verwenden
#
# **********************************************************************************
@persistent
Feature: rueckbuchung_umlagern_scenario01.feature

Background:
And I set the fake date to "03.07.2002"

Scenario: 01 Rueckbau aus Fertigung wenn Zugang umgelagert wurde

# Lagergruppeneigenschaften im Artikelstamm anlegen, BAUGRUPPE
Given I open an editor "BAUGRUPPE" from table "(Part):(Product)" with command "UPDATE" for record "BAUGRUPPE"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
    | lgruppe | dispoa         | bsart    | zuplatz | umllg     | lief |
    | BERLIN  | bedarfsbezogen | UMLAGERN | L3F1    | KARLSRUHE | TEST |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Bestandskorrektur auf 0 fuer Artikel BAUGRUPPE
Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" 

# Material zubuchen
Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | KETTLER    |
    | fakt     | ja         |
    | vom      | .          |
    | ebeleg   | Rechnung   |
    | ueb      | ja         |
    | erfwaehr | DEM        |
    | budat    | 03.07.95   |
And I append rows
    | artikel   | mge | preis |
    | EINKAUF-1 | 20  | 20    |
    | EINKAUF-2 | 10  | 50    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Fertigungsvorschlag anlegen, 10 Stueck und freigeben, Zugang F1
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel   | netmge | bisuch  | mfreig |
    | BAUGRUPPE | 10     | FV2742_ | ja     |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Teilrueckmeldung auf Arbeitsschein, 4 Stueck
Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV2742_001"
And I set fields
    | mzeit  | 2  |
    | bzeit  | 2  |
    | sofort | ja |
And I modify table
    | !row | gutmge |
    |  1   | 4      |
And I save the current editor

# Umlagerungsvorschlag manuell erstellen und freigeben, 4 Stueck
Given I open an editor "UMLVOR" from table "(Purchasing):(RelocationSuggestions)" with command "NEW" for record ""
And I set field "lgruppe" to "BERLIN"
And I delete all rows
And I append rows
    | artikel   | mge | mfreig |
    | BAUGRUPPE |  4  | ja     |
Then field "abplatz" has value "F1" in row 1
Then field "platz" has value "L3F1" in row 1
And I press button "freig" to open a subeditor for "UML_freigeben"
And I set field "such" to "UMLBE01"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# Umlagerungslieferschein aus Umlagerungsbestellung erstellen und buchen
Given I open an editor "EK-Liefer" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "UMLBE01"
And I set fields
    | ebeleg | UMLLS_01 |
    | such   | UMLLS_01 |
    | vom    |  .       |
    | ueb    | ja       | 
And I press button "offueb" in row 1
And I set field "preis" to "2" in row 1
And I save the current editor

# Rueckbau auf Arbeitsschein 4 Stueck
Given I open an editor "RUECK_AS1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "FV2742_001"
And I set fields
   | mzeit  | 2  |
   | bzeit  | 2  |
   | sofort | ja |
And I set field "gutmge" to "-4" in row 1
And I save the current editor

# Lagerjournaleintrag pruefen
Given I open the infosystem "LJ"
And I set field "adatum" to "-10"
And I set field "edatum" to "+30"
And I set field "artikel" to "BAUGRUPPE"
And I set field "richtung" to "rueckwaerts"
And I press start
Then table has values 
    | zmge | amge | detursache                      | nplatz | vplatz |
    | -4   |      | Rückbau Fertigung              | F1     |        |
    |  4   |      | Umlagerungslieferschein Einkauf | L3F1   |        |
    |      |  4   | Umlagerungslieferschein Einkauf |        |  F1    |
    |  4   |      | Rückmeldung Fertigung          | F1     |        |
And I close the current editor

# Journaleintrag selektieren von Umlagerungslieferschein Abgang
Given I open an editor "LJ_UML_ZU" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==BAUGRUPPE;ebeleg==UMLLS_01;buart==1;@richtung=rueckwaerts;@maxtreffer=1"
And I close the current editor

# Bewertung zu diesem Journaleintrag pruefen, additive Kosten sind korrekt gefuellt, inkl. Transportkosten aus Umlagerungsrechnung
Given I open latest Valuation "Bewertung_UML_ZU" for Product "BAUGRUPPE" and valuation transaction "LJ_UML_ZU" with command "VIEW"
Then field "tbewpr" has value "2.0000" in row 1
Then field "addkosten" has value "2.0000" in row 1
And I close the current editor
