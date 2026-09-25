# *****************************************************************************
#  Name           : wertgutschrift_mz.feature
#  Verantwortlich : as
#  Kontrolle      : ak
#  Funktion       : Test der Materialzuordnungen in Wertgutschriften
#
# *****************************************************************************
#
@persistent
Feature: Test der Materialzuordnungen in Wertgutschriften
Background:
Given I set the fake date to "02.01.1995"
Given I enable the flag 39

Scenario: Stammdaten

# Projektkostenrechnung einschalten
Given I open an editor "config" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "projekt" to "ja"
And I save the current editor

# Nicht bestandsgefuehrte Warengruppe
Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set fields
| nummer  | 56NB |
| befuehr | nein |
And I save the current editor

# Artikel anlegen
Given I open an editor "A100" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such      | A100             |
   | name      | Artikel A100     |
   | bsart     | Fremdbeschaffung |
   | dispoa    | auftragsbezogen  |
   | vpr       | 100              |
   | lief      | 1                |
   | chimlager | ja               |
   | epr       | 100              |
   | fvhe      | 2                |
   | vhe       | kg               |
And I save the current editor

Given I open an editor "TK100" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set fields
   | such   | TK100             |
   | zptyp  | neutrale Position |
   | name   | Transportkosten   |
   | epr    | 100               |
And I save the current editor

# Bestand fuer Artikel A100
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | A100      |
    | buart     | Zugang    |
    | beleg     | LBU_A100  |
    | beldat    | .         |
    | wert      | 50.0000   |
And I delete all rows
And I append rows
    | mge    | platz2   |
    | 100    | F1       |
And I save the current editor

# Artikel mit nicht bestandsgefuehrter Warengruppe
Given I open an editor "A200" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
| such     | A200             |
| namebspr | Artikel A200     |
| bsart    | Fremdbeschaffung |
| dispoa   | auftragsbezogen  |
| vpr      | 10               |
| epr      | 10               |
| wgruppe  | 56NB             |
And I save the current editor

# Artikel mit Dispoart bedarfsbezogen
Given I open an editor "A300" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such      | A300             |
   | name      | Artikel A300     |
   | bsart     | Fremdbeschaffung |
   | dispoa    | bedarfsbezogen   |
   | vpr       | 30               |
   | epr       | 30               |
And I save the current editor


# 2. Artikel mit Chargenpflicht anlegen
Given I open an editor "A400" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such      | A400             |
   | name      | Artikel A400     |
   | bsart     | Fremdbeschaffung |
   | dispoa    | auftragsbezogen  |
   | vpr       | 10               |
   | lief      | 1                |
   | chimlager | ja               |
   | epr       | 10               |
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Fakturierung ueber Bestellung, unterschiedliche Mengen in Lieferscheinen und Rechnungen, Kostenumlage
#----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE001 |
   | lief   | 1      |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 100 |
And I save the current editor

# Lieferschein aus Bestellung
Given I open an editor "1LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE001"
And I set fields
   | nummer | 1LS001 |
   | vom    | .      |
   | ueb    | ja     |
   | fakt   | nein   |
And I set field "mge" to "50" in row 1
And I save the current editor

# Lieferschein aus Bestellung
Given I open an editor "2LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE001"
And I set fields
   | nummer | 2LS001 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "50" in row 1
And I save the current editor

# Rechnung aus Bestellung
Given I open an editor "1RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE001"
And I set fields
   | nummer | 1RE001 |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "70" in row 1
And I set field "preis" to "90" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung aus Bestellung
Given I open an editor "2RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE001"
And I set fields
   | nummer | 2RE001 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "20" in row 1
And I set field "preis" to "80" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung Transportkosten
Given I open an editor "3RE001" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 3RE001 |
   | lief   | 1      |
   | vom    | .      |
   | ueb    | ja     |
And I create a new row at the end of the table
And I set field "artikel" to "TK100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Kostenumlage
Given I open an editor "1KM001" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set fields
   | nummer     | 1KM001                                                  |
   | pos        | $,,kopf^nummer=3RE001;artikel=TK100;@ablageart=abgelegt |
   | fibuumbuch | ja                                                      |
   | umlagemeth | Wert                                                    |
And I append rows
   | pos                                                                           |
   | $,,@gruppe=2;@datenbank=4;kopf^nummer=1RE001;artikel=A100;@ablageart=abgelegt |
And I save the current editor

# Komplettwertgutschrift
Given I open an editor "1WG001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE001"
And I set fields
   | nummer | 1WG001 |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

# Komplettwertgutschrift stornieren
Given I open an editor "1WG001S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1WG001"
And I set fields
   | nummer | 1WG001S  |
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Fakturierung ueber Bestellung, unterschiedliche Chargen, Verwendungen, Projekte in MZs
#----------------------------------------------------------------------------------------------

# Lagerplaetze anlegen
Given I open an editor "F002-1" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F002-1 |
   | lager | L1     |
And I save the current editor

Given I open an editor "F002-2" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F002-2 |
   | lager | L1     |
And I save the current editor

Given I open an editor "F002-3" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F002-3 |
   | lager | L1     |
And I save the current editor

# Chargen anlegen
Given I open an editor "C002-1" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
   | such    | C002-1 |
   | exnum   | C002-1 |
   | artikel | A100   |
And I save the current editor

Given I open an editor "C002-2" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
   | such    | C002-2 |
   | exnum   | C002-2 |
   | artikel | A100   |
And I save the current editor

Given I open an editor "C002-3" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
   | such    | C002-3 |
   | exnum   | C002-3 |
   | artikel | A100   |
And I save the current editor

# Projekte anlegen
Given I open an editor "projekt" from table "(Transaction):(Project)" with command "NEW" for record ""
And I set fields
   | such    | P002-1 |
And I save the current editor

Given I open an editor "projekt" from table "(Transaction):(Project)" with command "NEW" for record ""
And I set fields
   | such    | P002-2 |
And I save the current editor

Given I open an editor "projekt" from table "(Transaction):(Project)" with command "NEW" for record ""
And I set fields
   | such    | P002-3 |
And I save the current editor

# Bestellung
Given I open an editor "1BE002" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE002 |
   | lief   | 1      |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 60  |
And I save the current editor

# Lieferschein aus Bestellung
Given I open an editor "1LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE002"
And I set fields
   | nummer | 1LS002 |
   | vom    | .      |
   | ueb    | ja     |
   | fakt   | nein   |
And I set field "mge" to "60" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | zuomge | charge | verw   | projekt |
    | F002-1 | 10     | C002-1 | V002_1 | P002-1  |
    | F002-2 | 20     | C002-2 | V002_2 | P002-2  |
    | F002-3 | 30     | C002-3 | V002_3 | P002-3  |
And I save the current editor
And I switch the current editor to editor "1LS002"
And I save the current editor

# Rechnung aus Bestellung
Given I open an editor "1RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE002"
And I set fields
   | nummer | 1RE002 |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "40" in row 1
And I set field "preis" to "90" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung aus Bestellung
Given I open an editor "2RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE002"
And I set fields
   | nummer | 2RE002 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "20" in row 1
And I set field "preis" to "80" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift
Given I open an editor "1WG002" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE002"
And I set fields
   | nummer | 1WG002 |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

# Komplettwertgutschrift stornieren
Given I open an editor "1WG002S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1WG002"
And I set fields
   | nummer | 1WG002S  |
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Fakturierung ueber Lieferschein, Komplettwertgutschrift, Ruecklieferung
#----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE003" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE003 |
   | lief   | 1      |
And I append rows
   | artikel | he    | mge | preis |
   | A100    | Stück | 10  | 90    |
And I save the current editor

# Lieferschein aus Bestellung
Given I open an editor "1LS003" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE003"
And I set fields
   | nummer | 1LS003 |
   | vom    | .      |
   | ueb    | ja     |
   | fakt   | ja     |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung aus Lieferschein
Given I open an editor "1RE003" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS003"
And I set fields
   | nummer | 1RE003 |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift
Given I open an editor "1WG003" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE003"
And I set fields
   | nummer | 1WG003 |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

# Ruecklieferung
Given I open an editor "1RL003" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS003"
And I set fields
   | nummer | 1RL003 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-10" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Fakturierung ueber Bestellung, Erfassungswaehrung ungleich Buchungswaehrung, Teilwertgutschriften
#----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE004" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer   | 1BE004 |
   | lief     | 1      |
   | erfwaehr | SEK    |
And I append rows
   | artikel | he    | mge | preis |
   | A100    | Stück | 100 | 100   |
And I save the current editor

# Lieferschein aus Bestellung
Given I open an editor "1LS004" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE004"
And I set fields
   | nummer | 1LS004 |
   | vom    | .      |
   | ueb    | ja     |
   | fakt   | nein   |
And I set field "mge" to "50" in row 1
And I save the current editor

# Lieferschein aus Bestellung
Given I open an editor "2LS004" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE004"
And I set fields
   | nummer | 2LS004 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "50" in row 1
And I save the current editor

# Rechnung aus Bestellung
Given I open an editor "1RE004" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE004"
And I set fields
   | nummer | 1RE004 |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "30" in row 1
And I set field "preis" to "90" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung aus Bestellung
Given I open an editor "2RE004" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE004"
And I set fields
   | nummer | 2RE004 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "70" in row 1
And I set field "preis" to "80" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift 1
Given I open an editor "1WG004" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "2RE004"
And I set fields
   | nummer | 1WG004 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-40" in row 1
And I set field "preis" to "20" in row 1
And I save the current editor

# Teilwertgutschrift 2
Given I open an editor "2WG004" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "2RE004"
And I set fields
   | nummer | 2WG004 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-40" in row 1
And I set field "preis" to "60" in row 1
And I save the current editor

# Teilwertgutschrift 3
Given I open an editor "3WG004" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "2RE004"
And I set fields
   | nummer | 3WG004 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-30" in row 1
And I set field "preis" to "60" in row 1
And I save the current editor

# Teilwertgutschrift 4 - es ist alles gutgeschrieben
Given I open an editor "4WG004" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "2RE004"
And I set fields
   | nummer | 4WG004 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-30" in row 1
And I set field "preis" to "20" in row 1
And I save the current editor

# Teilwertgutschrift 5
Given I open an editor "5WG004" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "2RE004"
And I set fields
   | nummer | 5WG004 |
   | vom    | .      |
   | ueb    | ja     |
Then setting field "mge" to "-1" in row 1 throws the exception "3227"
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: Fakturierung ueber Bestellung, unterschiedliche Chargen, Teilwertgutschriften
#----------------------------------------------------------------------------------------------

# Chargen anlegen
Given I open an editor "C002-1" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
   | such    | C005-1 |
   | exnum   | C005-1 |
   | artikel | A100   |
And I save the current editor

Given I open an editor "C002-2" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
   | such    | C005-2 |
   | exnum   | C005-2 |
   | artikel | A100   |
And I save the current editor

# Bestellung
Given I open an editor "1BE005" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE005 |
   | lief   | 1      |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 100 |
And I save the current editor

# Lieferschein aus Bestellung
Given I open an editor "1LS005" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE005"
And I set fields
   | nummer | 1LS005 |
   | vom    | .      |
   | ueb    | ja     |
   | fakt   | nein   |
And I set field "mge" to "50" in row 1
And I set field "charge" to "C005-1" in row 1
And I save the current editor

# Lieferschein aus Bestellung
Given I open an editor "2LS005" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE005"
And I set fields
   | nummer | 2LS005 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "50" in row 1
And I set field "charge" to "C005-2" in row 1
And I save the current editor

# Rechnung aus Bestellung
Given I open an editor "1RE005" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE005"
And I set fields
   | nummer | 1RE005 |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift 1
Given I open an editor "1WG005" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE005"
And I set fields
   | nummer | 1WG005 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-70" in row 1
And I set field "charge" to "C005-1" in row 1
Then saving the current editor throws the exception "2022"
And I set field "charge" to "C005-2" in row 1
Then saving the current editor throws the exception "2022"
And I set field "charge" to "" in row 1
And I save the current editor

# Teilwertgutschrift 2
Given I open an editor "2WG005" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE005"
And I set fields
   | nummer | 2WG005 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-50" in row 1
And I set field "charge" to "C005-1" in row 1
And I set field "preis" to "31" in row 1
Then saving the current editor throws the exception "2792"
And I set field "preis" to "30" in row 1
And I save the current editor

# Teilwertgutschrift 3 - es ist alles gutgeschrieben
Given I open an editor "3WG005" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE005"
And I set fields
   | nummer | 3WG005 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-50" in row 1
And I set field "charge" to "C005-2" in row 1
And I set field "preis" to "31" in row 1
Then field "proz" has value "-3.23" in row 1
And I set field "preis" to "30" in row 1
And I save the current editor

# Teilwertgutschrift 4
Given I open an editor "4WG005" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE005"
And I set fields
   | nummer | 4WG005 |
   | vom    | .      |
   | ueb    | ja     |
Then setting field "mge" to "-1" in row 1 throws the exception "3227"
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: Fakturierung ueber Bestellung, unterschiedliche Projekte, Teilwertgutschriften
#----------------------------------------------------------------------------------------------

# Projekte anlegen
Given I open an editor "projekt" from table "(Transaction):(Project)" with command "NEW" for record ""
And I set fields
   | such    | P006-1 |
And I save the current editor

Given I open an editor "projekt" from table "(Transaction):(Project)" with command "NEW" for record ""
And I set fields
   | such    | P006-2 |
And I save the current editor

# Bestellung
Given I open an editor "1BE006" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE006 |
   | lief   | 1      |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 100 |
And I save the current editor

# Lieferschein aus Bestellung
Given I open an editor "1LS006" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE006"
And I set fields
   | nummer | 1LS006 |
   | vom    | .      |
   | ueb    | ja     |
   | fakt   | nein   |
And I set field "mge" to "50" in row 1
And I set field "projekt" to "P006-1" in row 1
And I save the current editor

# Lieferschein aus Bestellung
Given I open an editor "2LS006" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE006"
And I set fields
   | nummer | 2LS006 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "50" in row 1
And I set field "projekt" to "P006-2" in row 1
And I save the current editor

# Rechnung aus Bestellung
Given I open an editor "1RE006" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE006"
And I set fields
   | nummer | 1RE006 |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift 1
Given I open an editor "1WG006" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE006"
And I set fields
   | nummer | 1WG006 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-70" in row 1
And I set field "projekt" to "P006-1" in row 1
Then saving the current editor throws the exception "2022"
And I set field "projekt" to "P006-2" in row 1
Then saving the current editor throws the exception "2022"
And I set field "projekt" to "" in row 1
And I save the current editor

# Teilwertgutschrift 2
Given I open an editor "2WG006" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE006"
And I set fields
   | nummer | 2WG006 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-50" in row 1
And I set field "projekt" to "P006-1" in row 1
And I set field "preis" to "31" in row 1
Then saving the current editor throws the exception "2792"
And I set field "preis" to "30" in row 1
And I save the current editor

# Teilwertgutschrift 3 - es ist alles gutgeschrieben
Given I open an editor "3WG006" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE006"
And I set fields
   | nummer | 3WG006 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-50" in row 1
And I set field "projekt" to "P006-2" in row 1
And I set field "preis" to "31" in row 1
Then field "proz" has value "-3.23" in row 1
And I set field "preis" to "30" in row 1
And I save the current editor

# Teilwertgutschrift 4
Given I open an editor "4WG006" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE006"
And I set fields
   | nummer | 4WG006 |
   | vom    | .      |
   | ueb    | ja     |
Then setting field "mge" to "-1" in row 1 throws the exception "3227"
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: Fakturierung ueber Bestellung, unterschiedliche Verwendungen, Teilwertgutschriften
#----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE007" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE007 |
   | lief   | 1      |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 100 |
And I save the current editor

# Lieferschein aus Bestellung
Given I open an editor "1LS007" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE007"
And I set fields
   | nummer | 1LS007 |
   | vom    | .      |
   | ueb    | ja     |
   | fakt   | nein   |
And I set field "mge" to "50" in row 1
And I set field "verw" to "V007_1" in row 1
And I save the current editor

# Lieferschein aus Bestellung
Given I open an editor "2LS007" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE007"
And I set fields
   | nummer | 2LS007 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "50" in row 1
And I set field "verw" to "V007_2" in row 1
And I save the current editor

# Rechnung aus Bestellung
Given I open an editor "1RE007" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE007"
And I set fields
   | nummer | 1RE007 |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift 1
Given I open an editor "1WG007" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE007"
And I set fields
   | nummer | 1WG007 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-70" in row 1
And I set field "verw" to "V007_1" in row 1
Then saving the current editor throws the exception "2022"
And I set field "verw" to "V007_2" in row 1
Then saving the current editor throws the exception "2022"
And I set field "verw" to "V007" in row 1
And I save the current editor

# Teilwertgutschrift 2
Given I open an editor "2WG007" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE007"
And I set fields
   | nummer | 2WG007 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-50" in row 1
And I set field "verw" to "V007_1" in row 1
And I set field "preis" to "31" in row 1
Then saving the current editor throws the exception "2792"
And I set field "preis" to "30" in row 1
And I save the current editor

# Teilwertgutschrift 3 - es ist alles gutgeschrieben
Given I open an editor "3WG007" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE007"
And I set fields
   | nummer | 3WG007 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-50" in row 1
And I set field "verw" to "V007_2" in row 1
And I set field "preis" to "31" in row 1
Then field "proz" has value "-3.23" in row 1
And I set field "preis" to "30" in row 1
And I save the current editor

# Teilwertgutschrift 4
Given I open an editor "4WG007" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE007"
And I set fields
   | nummer | 4WG007 |
   | vom    | .      |
   | ueb    | ja     |
Then setting field "mge" to "-1" in row 1 throws the exception "3227"
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: Fakturierung ueber Bestellung, unterschiedliche Verwendungen, Handelseinheit ungleich Lagereinheit, Teilwertgutschriften
#----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE008" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE008 |
   | lief   | 1      |
And I append rows
   | artikel | he    | mge |
   | A100    | kg    | 100 |
And I save the current editor

# Lieferschein aus Bestellung
Given I open an editor "1LS008" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE008"
And I set fields
   | nummer | 1LS008 |
   | vom    | .      |
   | ueb    | ja     |
   | fakt   | nein   |
And I set field "mge" to "50" in row 1
And I set field "verw" to "V008_1" in row 1
And I save the current editor

# Lieferschein aus Bestellung
Given I open an editor "2LS008" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE008"
And I set fields
   | nummer | 2LS008 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "50" in row 1
And I set field "verw" to "V008_2" in row 1
And I save the current editor

# Rechnung aus Bestellung
Given I open an editor "1RE008" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE008"
And I set fields
   | nummer | 1RE008 |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift 1
Given I open an editor "1WG008" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE008"
And I set fields
   | nummer | 1WG008 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-70" in row 1
And I set field "verw" to "V008_1" in row 1
Then saving the current editor throws the exception "2022"
And I set field "verw" to "V008_2" in row 1
Then saving the current editor throws the exception "2022"
And I set field "verw" to "V008" in row 1
And I save the current editor

# Teilwertgutschrift 2
Given I open an editor "2WG008" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE008"
And I set fields
   | nummer | 2WG008 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-50" in row 1
And I set field "verw" to "V008_1" in row 1
And I set field "preis" to "31" in row 1
Then saving the current editor throws the exception "2792"
And I set field "preis" to "30" in row 1
And I save the current editor

# Teilwertgutschrift 3 - es ist alles gutgeschrieben
Given I open an editor "3WG008" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE008"
And I set fields
   | nummer | 3WG008 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-50" in row 1
And I set field "verw" to "V008_2" in row 1
And I set field "preis" to "31" in row 1
Then field "proz" has value "-3.23" in row 1
And I set field "preis" to "30" in row 1
And I save the current editor

# Teilwertgutschrift 4
Given I open an editor "4WG008" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE008"
And I set fields
   | nummer | 4WG008 |
   | vom    | .      |
   | ueb    | ja     |
Then setting field "mge" to "-1" in row 1 throws the exception "3227"
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: Fakturierung ueber Bestellung, Charge und Verwendung, Teilwertgutschrift
#----------------------------------------------------------------------------------------------

# Charge anlegen
Given I open an editor "C009-1" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
   | such    | C009-1 |
   | exnum   | C009-1 |
   | artikel | A100   |
And I save the current editor

# Bestellung
Given I open an editor "1BE009" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE009 |
   | lief   | 1      |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 100 |
And I save the current editor

# Lieferschein aus Bestellung
Given I open an editor "1LS009" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE009"
And I set fields
   | nummer | 1LS009 |
   | vom    | .      |
   | ueb    | ja     |
   | fakt   | nein   |
And I set field "mge" to "100" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | zuomge | charge | verw   |
    | 40     | C009-1 |        |
    | 60     | C009-1 | V009   |
And I save the current editor
And I switch the current editor to editor "1LS009"
And I save the current editor

# Rechnung aus Bestellung
Given I open an editor "1RE009" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE009"
And I set fields
   | nummer | 1RE009 |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift
Given I open an editor "1WG009" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE009"
And I set fields
   | nummer | 1WG009 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "preis" to "5" in row 1
And I set field "charge" to "C009-1" in row 1
And I set field "verw" to "V009" in row 1
And I set field "mge" to "-61" in row 1
Then saving the current editor throws the exception "2022"
And I set field "mge" to "-60" in row 1
And I save the current editor

# Teilwertgutschrift stornieren
Given I open an editor "1WG009S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1WG009"
And I set fields
   | nummer | 1WG009S  |
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Fakturierung ueber Bestellung, Teilwertgutschrift mit und ohne Auspraegung
#----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE010" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE010 |
   | lief   | 1      |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 250 |
And I save the current editor

# Lieferschein aus Bestellung
Given I open an editor "1LS010" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE010"
And I set fields
   | nummer | 1LS010 |
   | vom    | .      |
   | ueb    | ja     |
   | fakt   | nein   |
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | zuomge | verw   |
    | 50     | V010_1 |
    | 50     | V010_2 |
    | 50     | V010_3 |
    | 50     | V010_4 |
    | 50     | V010_5 |
And I save the current editor
And I switch the current editor to editor "1LS010"
And I save the current editor

# Rechnung aus Bestellung
Given I open an editor "1RE010" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE010"
And I set fields
   | nummer | 1RE010 |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift 1
Given I open an editor "1WG010" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE010"
And I set fields
   | nummer | 1WG010 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-50" in row 1
And I set field "preis" to "20" in row 1
And I set field "verw" to "V010_1" in row 1
And I save the current editor

# Teilwertgutschrift 2
Given I open an editor "2WG010" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE010"
And I set fields
   | nummer | 2WG010 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-50" in row 1
And I set field "preis" to "40" in row 1
And I set field "verw" to "V010_2" in row 1
And I save the current editor

# Teilwertgutschrift 3
Given I open an editor "3WG010" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE010"
And I set fields
   | nummer | 3WG010 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-50" in row 1
And I set field "preis" to "60" in row 1
And I set field "verw" to "V010_3" in row 1
And I save the current editor

# Teilwertgutschrift 4
Given I open an editor "4WG010" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE010"
And I set fields
   | nummer | 4WG010 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-50" in row 1
And I set field "preis" to "80" in row 1
And I set field "verw" to "V010_4" in row 1
And I save the current editor

# Teilwertgutschrift 5
Given I open an editor "5WG010" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE010"
And I set fields
   | nummer | 5WG010 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-50" in row 1
And I set field "preis" to "100" in row 1
And I set field "verw" to "V010_5" in row 1
And I save the current editor

# Teilwertgutschrift 6
Given I open an editor "6WG010" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE010"
And I set fields
   | nummer | 6WG010 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-100" in row 1
And I set field "preis" to "90" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Fakturierung ueber Bestellung, Zugang mit unscharfer Verwendung, Teilwertgutschrift mit scharfer Verwendung
#----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE011" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE011 |
   | lief   | 1      |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 100 |
And I save the current editor

# Lieferschein aus Bestellung
Given I open an editor "1LS011" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE011"
And I set fields
   | nummer | 1LS011 |
   | vom    | .      |
   | ueb    | ja     |
   | fakt   | nein   |
And I set field "mge" to "100" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | zuomge | verw   |
    | 50     | V011   |
    | 50     | V011_1 |
And I save the current editor
And I switch the current editor to editor "1LS011"
And I save the current editor

# Rechnung aus Bestellung
Given I open an editor "1RE011" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE011"
And I set fields
   | nummer | 1RE011 |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift
Given I open an editor "1WG011" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE011"
And I set fields
   | nummer | 1WG011 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-50" in row 1
And I set field "preis" to "50" in row 1
And I set field "verw" to "V011_1" in row 1
And I save the current editor

# Teilwertgutschrift stornieren
Given I open an editor "1WG011S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1WG011"
And I set fields
   | nummer | 1WG011S  |
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: 100%-Wertgutschrift zu Rechnung mit Lagerbewegung, Storno Wertgutschrift, Teilwertgutschrift
#----------------------------------------------------------------------------------------------

# Rechnung mit Lagerbewegung
Given I open an editor "1RE012" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE012 |
   | lief   | 1      |
   | vom    | .      |
   | ueb    | ja     |
   | fakt   | ja     |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 100 |
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
   | zuomge |
   | 10     |
   | 20     |
   | 70     |
And I save the current editor
And I switch the current editor to editor "1RE012"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift
Given I open an editor "1WG012" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE012"
And I set fields
   | nummer | 1WG012 |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

# Komplettwertgutschrift stornieren
Given I open an editor "1WG012S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1WG012"
And I set fields
   | nummer | 1WG012S  |
And I save the current editor

# Teilwertgutschrift
Given I open an editor "2WG012" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE012"
And I set fields
   | nummer | 2WG012 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-50" in row 1
And I set field "preis" to "50" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Fakturierung ueber Lieferschein, Bruttopreise, Komplettwertgutschrift
#----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE013" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE013 |
   | lief   | 1      |
   | brutto | ja     |
And I append rows
   | artikel | he    | mge | preis |
   | A100    | Stück | 10  | 90    |
And I save the current editor

# Lieferschein aus Bestellung
Given I open an editor "1LS013" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE013"
And I set fields
   | nummer | 1LS013 |
   | vom    | .      |
   | ueb    | ja     |
   | fakt   | ja     |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung aus Lieferschein
Given I open an editor "1RE013" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS013"
And I set fields
   | nummer | 1RE013 |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift
Given I open an editor "1WG013" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE013"
And I set fields
   | nummer | 1WG013 |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

# Komplettwertgutschrift stornieren
Given I open an editor "1WG013S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1WG013"
And I set fields
   | nummer | 1WG013S  |
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Fakturierung ueber Bestellung, Bruttopreise, Teilwertgutschriften
#----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE014" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer   | 1BE014 |
   | lief     | 1      |
   | brutto   | ja     |
And I append rows
   | artikel | he    | mge | preis |
   | A100    | Stück | 100 | 100   |
And I save the current editor

# Lieferschein aus Bestellung
Given I open an editor "1LS014" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE014"
And I set fields
   | nummer | 1LS014 |
   | vom    | .      |
   | ueb    | ja     |
   | fakt   | nein   |
And I set field "mge" to "50" in row 1
And I save the current editor

# Lieferschein aus Bestellung
Given I open an editor "2LS014" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE014"
And I set fields
   | nummer | 2LS014 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "50" in row 1
And I save the current editor

# Rechnung aus Bestellung
Given I open an editor "1RE014" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE014"
And I set fields
   | nummer | 1RE014 |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "30" in row 1
And I set field "preis" to "90" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung aus Bestellung
Given I open an editor "2RE014" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE014"
And I set fields
   | nummer | 2RE014 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "70" in row 1
And I set field "preis" to "80" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift 1
Given I open an editor "1WG014" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "2RE014"
And I set fields
   | nummer | 1WG014 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-40" in row 1
And I set field "preis" to "20" in row 1
And I save the current editor

# Teilwertgutschrift 2
Given I open an editor "2WG014" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "2RE014"
And I set fields
   | nummer | 2WG014 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-40" in row 1
And I set field "preis" to "60" in row 1
And I save the current editor

# Teilwertgutschrift 3
Given I open an editor "3WG014" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "2RE014"
And I set fields
   | nummer | 3WG014 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-30" in row 1
And I set field "preis" to "60" in row 1
And I save the current editor

# Teilwertgutschrift 4 - es ist alles gutgeschrieben
Given I open an editor "4WG014" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "2RE014"
And I set fields
   | nummer | 4WG014 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-30" in row 1
And I set field "preis" to "20" in row 1
And I save the current editor

# Teilwertgutschrift 5
Given I open an editor "5WG014" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "2RE014"
And I set fields
   | nummer | 5WG014 |
   | vom    | .      |
   | ueb    | ja     |
Then setting field "mge" to "-1" in row 1 throws the exception "3227"
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: Fakturierung ueber Bestellung, gebrochene Preise, Gesamtrechnungsrabatt
#----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE015" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer   | 1BE015 |
   | lief     | 1      |
And I append rows
   | artikel | he          | mge         | preis       | proz        |
   | A100    | Stück       | 3           | 12,34       | !dontChange |
   | A100    | Stück       | 3           | 67,89       | !dontChange |
   | SU.     | !dontChange | !dontChange | !dontChange | !dontChange |
   | PR.     | !dontChange | !dontChange | !dontChange | -20         |
And I save the current editor

# Lieferschein aus Bestellung
Given I open an editor "1LS015" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE015"
And I set fields
   | nummer | 1LS015 |
   | vom    | .      |
   | ueb    | ja     |
   | fakt   | nein   |
And I set field "mge" to "3" in row 1
And I set field "mge" to "3" in row 2
And I save the current editor

# Rechnung aus Bestellung
Given I open an editor "1RE015" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE015"
And I set fields
   | nummer | 1RE015 |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "3" in row 1
And I set field "mge" to "3" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift 1
Given I open an editor "1WG015" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE015"
And I set fields
   | nummer | 1WG015 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-1" in row 1
And I set field "mge" to "-1" in row 2
And I save the current editor

# Teilwertgutschrift 2
Given I open an editor "2WG015" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE015"
And I set fields
   | nummer | 2WG015 |
   | vom    | .      |
   | ueb    | nein   |
And I set field "mge" to "-1" in row 1
And I set field "mge" to "-1" in row 2
And I save the current editor

# Teilwertgutschrift 2 buchen
Given I open an editor "2WG015" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "2WG015"
And I set fields
	| ueb    | ja     |
And I save the current editor

# Teilwertgutschrift 3
Given I open an editor "3WG015" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE015"
And I set fields
   | nummer | 3WG015 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-1" in row 1
And I set field "mge" to "-1" in row 2
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Rechnung mit Lagerbewegung, gebrochene Preise, Rabatt
#----------------------------------------------------------------------------------------------

# Rechnung mit Lagerbewegung
Given I open an editor "1RE016" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer   | 1RE016 |
   | lief     | 1      |
   | fakt     | ja     |
   | ueb      | ja     |
   | vom      | .      |
And I append rows
   | artikel | he          | mge         | preis       | proz        |
   | A100    | Stück       | 3           | 12,34       | !dontChange |
   | PR.     | !dontChange | !dontChange | !dontChange | -20         |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift 1
Given I open an editor "1WG016" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE016"
And I set fields
   | nummer | 1WG016 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-1" in row 1
And I save the current editor

# Teilwertgutschrift 2
Given I open an editor "2WG016" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE016"
And I set fields
   | nummer | 2WG016 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-1" in row 1
And I save the current editor

# Teilwertgutschrift 3
Given I open an editor "3WG016" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE016"
And I set fields
   | nummer | 3WG016 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-1" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Rechnung ohne Lagerbewegung, Artikel mit nicht bestandsgefuehrter Warengruppe
#----------------------------------------------------------------------------------------------

# Rechnung, Artikel mit nicht bestandsgefuehrter Warengruppe
Given I open an editor "1RE017" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer   | 1RE017 |
   | lief     | 1      |
   | fakt     | nein   |
   | ueb      | ja     |
   | vom      | .      |
And I append rows
   | artikel | he     | mge |
   | A200    | Stück  | 10  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift
Given I open an editor "1WG017" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE017"
And I set fields
   | nummer | 1WG017 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Teilwertgutschrift stornieren
Given I open an editor "1WG017S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1WG017"
And I set fields
   | nummer | 1WG017S |
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Fekturierung ueber Bestellung, Artikel mit nicht bestandsgefuehrter Warengruppe
#----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE018" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE018 |
   | lief   | 1      |
And I append rows
   | artikel | he    | mge |
   | A200    | Stück | 10  |
And I save the current editor

# Rechnung aus Bestellung
Given I open an editor "1RE018" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE018"
And I set fields
   | nummer | 1RE018 |
   | vom    | .      |
   | fakt   | nein   |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift
Given I open an editor "1WG018" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE018"
And I set fields
   | nummer | 1WG018 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Teilwertgutschrift stornieren
Given I open an editor "1WG018S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1WG018"
And I set fields
   | nummer | 1WG018S |
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Verwendung im Vorgang, aber nicht im Lager gebucht
#----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE019" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE019 |
   | lief   | 1      |
And I append rows
   | artikel | he    | mge | verw   |
   | A300    | Stück | 10  | 1BE019 |
And I save the current editor

# Rechnung aus Bestellung
Given I open an editor "1RE019" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE019"
And I set fields
   | nummer | 1RE019 |
   | vom    | .      |
   | fakt   | nein   |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift
Given I open an editor "1WG019" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE019"
And I set fields
   | nummer | 1WG019 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Bestellung
Given I open an editor "2BE019" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 2BE019 |
   | lief   | 1      |
And I append rows
   | artikel | he    | mge | verw   |
   | A300    | Stück | 10  | 2BE019 |
And I save the current editor

# Lieferschein aus Bestellung
Given I open an editor "2LS019" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "2BE019"
And I set fields
   | nummer | 2LS019 |
   | vom    | .      |
   | ueb    | ja     |
   | fakt   | ja     |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung aus Lieferschein
Given I open an editor "2RE019" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "2LS019"
And I set fields
   | nummer | 2RE019 |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift
Given I open an editor "2WG019" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "2RE019"
And I set fields
   | nummer | 2WG019 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "-5" in row 1
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: EK - Fakturierung ueber den Lieferschein - Unterschiedliche Chargen in Position und MZ - Komplettwertgutschrift zu Rechnung
# ----------------------------------------------------------------------------------------------

# BE  ----------------- LS  (buchen)------------------ RE (buchen) ----------- RE (WGS 100%)
# 2 St.                  2 St.                          2 St. (1!)             -2 St.

# Chargen anlegen
Given I open an editor "C020-1" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
   | such    | C020-1 |
   | exnum   | C020-1 |
   | artikel | A400   |
And I save the current editor

Given I open an editor "C020-2" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
   | such    | C020-2 |
   | exnum   | C020-2 |
   | artikel | A400   |
And I save the current editor

# Bestellung
Given I open an editor "1BE020" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 1          |
    | nummer | 1BE020     |
    | such   | BE020      |
    | vom    | .          |
And I append rows
    | artikel | mge | charge | einplan |
    | A400    | 5   | C020-1 | ja      |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | tcharge  |
    | 1     | F1     | C020-2   |
And I save the current editor
And I switch the current editor to editor "1BE020"
And I save the current editor

# Lieferschein
Given I open an editor "1LS020" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE020"
And I set fields
   | ebeleg | LS1020 |
   | such   | LS1020 |
   | nummer | 1LS020 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "5" in row 1
And I save the current editor

# Rechnung
Given I open an editor "1RE020" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS020"
And I set fields
   | ebeleg | RE1020 |
   | such   | RE1020 |
   | nummer | 1RE020 |
   | ueb    | ja     |
   | vom    | .      |
# Nicht verwendete Charge in Rechnungsposition
Then field "charge" has value "7" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "1WG020" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE020"
And I set fields
   | ebeleg | WG1020 |
   | such   | WG1020 |
   | nummer | 1WG020 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "-5" in row 1
# Nicht verwendete Charge in Wertgutschriftsposition
Then field "charge" has value "7" in row 1
# Pruefung auf tatsaetliche gebuchte Charge
# Gutschrift für diese Charge nicht moeglich
Then saving the current editor throws the exception "2022"
And I set field "charge" to "" in row 1
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK - Fakturierung ueber den Lieferschein - Unterschiedliche Chargen in Position und MZ - Komplettwertgutschrift zu Rechnung
# ----------------------------------------------------------------------------------------------

# AU  ----------------- LS  (buchen)------------------ RE (buchen) ----------- RE (WGS 100%)
# 2 St.                 2 St.                          2 St.                   -2 St.

# Auftrag
Given I open an editor "1AU020" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU1020 |
   | nummer | 1AU020 |
   | vom    | .      |
And I append rows
   | artikel | mge | charge | verw    |
   | A400    | 2   | C020-1 | 1AU020  |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
   | !row  | lpsuch | tcharge |
   | 1     | F1     | C020-2  |
And I save the current editor
And I switch the current editor to editor "1AU020"
And I save the current editor

# Lieferschein
Given I open an editor "1LS020" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU020"
And I set fields
   | such   | LS1020 |
   | nummer | 1LS020 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "2" in row 1
And I save the current editor

# Rechnung
Given I open an editor "1RE020" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS020"
And I set fields
   | such   | RE1020 |
   | nummer | 1RE020 |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "1WG020" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE020"
And I set fields
   | such   | WG1020 |
   | nummer | 1WG020 |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "-2" in row 1
# Nicht verwendete Charge in Wertgutschriftsposition
Then field "charge" has value "7" in row 1
# Im Verkauf kann trotzdem gebucht werden, keine Pruefung
And I save the current editor
