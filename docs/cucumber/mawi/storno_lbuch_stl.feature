@persistent
Feature: storno_lbuch_stl.feature

# *****************************************************************************
#  Name             : storno_lbuch_stl.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Storno einer manuellen Lagerbuchung mit stl gesetzt
#  ref              : ref_storno_lbuch_stl_cu
#
# Testszenario:
#  - Zugang EK-Rechnung mit Lagerbewegung auf Platz WELA
#  - Umbuchung je 2x auf MLF01 und 2x auf ZLQM
#  - Umlagerung je 1x 50 Stueck von MLF01 nach L3F1 und 1x 50 Stueck von ZLQM nach L3F1
#  - Ruecklieferung des Zugangs von L3F1
#  - Storno der Ruecklieferung
#  - Storno Abgang eines Setartikels
#
# *****************************************************************************

Background:
Given I set the fake date to "07.01.95"


Scenario: Lagerbuchungsstorno mit stl gesetzt
# Bestandskorrektur fuer BG-BEDARF und EK1-BEDARF
And I set StorageQuantity to zero for Product "BG-BEDARF" on StorageLocation "F1" with document "1KORR"
And I set StorageQuantity to zero for Product "EK1-BEDARF" on StorageLocation "F1" with document "2KORR"

# Lagerbuchung mit Buchung der Stueckliste
Given I open an editor "Lbuchung1" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
    | artikel | BG-BEDARF |
    | beleg   | 1000      |
    | beldat  | .         |
    | buart   | Zugang    |
    | stl     | ja        |
And I create a new row at the end of the table
And I set field "mge" to "10" in row !lastRow
And I save the current editor

# Journaleintrag zur Buchung
Given I open the infosystem "LJ"
And I set field "beleg" to "1000"
And I set field "richtung" to "rueckwaerts"
And I press start
Then table has values
    | art         | buart   | detursache        | artbest |
    | BG-BEDARF   | Zugang  | Manueller Zugang  | 10      |
    | EK1-BEDARF  | Abgang  | Manueller Abgang  | -10     |
And I close the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "BG-BEDARF" on StorageLocation "F1"
Then StorageQuantities have values
    | gebmge | gebeinh  |
    | 10     | Stück    |

Given I query StorageQuantity for Product "EK1-BEDARF" on StorageLocation "F1"
Then StorageQuantities have values
    | gebmge | gebeinh  |
    | -10    | Stück    |

# Journaleintrag stornieren
Given I switch the current editor to editor "Lbuchung1" with command "REVERSAL"
And I set field "beleg" to "1000S"
And I save the current editor

# Journaleintrag zur Buchung
Given I open the infosystem "LJ"
And I set field "beleg" to "1000S"
And I set field "richtung" to "rueckwaerts"
And I press start
Then table has values
    | art         | buart   | detursache                    | artbest |
    | BG-BEDARF   | Zugang  | Storno manuelle Lagerbuchung  |  0      |
And I close the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "BG-BEDARF" on StorageLocation "F1"

Given I query StorageQuantity for Product "EK1-BEDARF" on StorageLocation "F1"
Then StorageQuantity is zero


# FDA-3805
Scenario: Storno Abgang eines Setartikels
Given I set the fake date to "08.01.95"
Given I set StorageQuantity to zero for Product "EK1-BEDARF" on StorageLocation "F1"
Given I set StorageQuantity to zero for Product "EK1-BEDARF" on StorageLocation "F1"
Given I set StorageQuantity to zero for Product "EK1-BEDARF" on StorageLocation "F1"

# Zu- und Teilabgang Setartikel
Given I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "10" on StorageLocation "F1" with document "Set_ZU1"
Given I post a receipt via ManualStockAdjustment for Product "EK2-BEDARF" and quantity "10" on StorageLocation "F1" with document "Set_ZU2"
Given I post a receipt via ManualStockAdjustment for Product "EK3-BEDARF" and quantity "10" on StorageLocation "F1" with document "Set_ZU3"

Given I post an issue via ManualStockAdjustment "mSetABGANG" for Product "SETARTIKEL" and quantity "5" on StorageLocation "F1" with document "SetABGANG"

Given I open an editor "SetABGANG" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "VIEW" for search criteria "$,,artikel=SETARTIKEL;@ablageart=abgelegt;@richtung=rueckwaerts;@maxtreffer=1"
And I close the current editor
    
# Storno SetABGANG
Given I switch the current editor to editor "SetABGANG" with command "REVERSAL"
And I save the current editor

# Bestand und LJ prüfen
Given I open the infosystem "BESTAND"
And I set field "artikel" to "EK1-BEDARF"
And I set field "details" to "nein"
And I press start
Then the table has 1 rows
Then field "lemge" has value "10" in row 1
And I close the current editor
    
Given I open the infosystem "LJ"
And I set fields
    | adatum    | 08.01.95      |
    | edatum    | 08.01.95      |
    | richtung  | rueckwaerts   |
And I press start
Then table has values
    | art           | buart     | detursache                    | zmge  | amge  | stornolj^vorgang^id  |
    | SETARTIKEL    | Durchgang | Durchgang Setartikel          | -5    | -5    | !dontChange          |
    | EK3-BEDARF    | Abgang    | Storno manuelle Lagerbuchung  |       | -5    | !mSetABGANG^id        |
    | EK2-BEDARF    | Abgang    | Storno manuelle Lagerbuchung  |       | -5    | !mSetABGANG^id        |
    | EK1-BEDARF    | Abgang    | Storno manuelle Lagerbuchung  |       | -5    | !mSetABGANG^id        |
And I close the current editor
