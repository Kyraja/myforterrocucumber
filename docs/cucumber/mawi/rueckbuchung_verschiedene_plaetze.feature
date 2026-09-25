# *****************************************************************************
#  Name             : rueckbuchung_verschiedene_plaetze.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet die Rueckbuchung auf abweichende Lagerplaetze
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_verschiedene_plaetze.feature
Background:
Given I set the fake date to "05.01.95"

# Ab hier geht es los: Einkaufen, Fertigen, Verkaufen und immer mal wieder was zuruecklegen/zurueckgeben - Fertigteil sowie Material

Scenario: 01 Kunde RADSHOP bestellt 50 x FAHRRAD

Given I create a SalesOrder "BRADSHOP" for Customer "RADSHOP" with Product "FAHRRAD" and quantity "50"
And I run Scheduling


Scenario: 02a Material fuer 50 x FAHHRAD bei Lieferant PUKY bestellen
Given I open an editor "Bestellvorschlaege02" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "kl" to "PUKY"
And I press button "ladetab"
And I press button "malle"

And I press button "freig" to open a subeditor for "Bestellung02"
And I save the current editor

And I switch the current editor to editor "Bestellvorschlaege02"
And I close the current editor

Scenario: 02b Material wird mit 2 Lieferscheinen zugebucht
# Lieferung des Materials mit 2 Lieferscheinen, damit bekommt man 2 Gebindezeilen.
# Bei Rueckbuchung muss die Zuordnung stimmen
Given I open an editor "EK-LS02-1" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "Bestellung02"
And I set fields
    | ebeleg | Lieferung1 |
    | vom    | .          |
    | ueb    | ja         |

And I modify table
    | !row              | mge  | charge  |
    | artikel=='RAHMEN' | 125  | UL01RAH |
    | artikel=='RAD'    |  25  | RAD002  |
    | artikel=='SATTEL' |  25  | SATTELB |
    | artikel=='PEDALE' |  25  | PEDP471 |

And I save the current editor


Given I open an editor "EK-LS02-2" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "Bestellung02"
And I set fields
    | ebeleg | Lieferung2 |
    | vom    | .          |
    | ueb    | ja         |

And I modify table
    | !row              | mge  | charge  |
    | artikel=='RAHMEN' | 125  | UL01RAH |
    | artikel=='RAD'    |  25  | RAD002  |
    | artikel=='SATTEL' |  25  | SATTELB |
    | artikel=='PEDALE' |  25  | PEDP471 |

And I save the current editor

Scenario: 02c Bestaende auf dem Platz pruefen

# Platzmengenelement prüfen
Given I query "gebmge,bewmge,gebf,gebeinh,charge^such,lj,orig,bewlj,beworig" from StorageQuantity for Product "RAHMEN" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | bewmge | gebf | gebeinh | charge^such | lj | orig | bewlj | beworig |
    | 125    | 125    | 0.2  | kg      | UL01RAH     | L1 | L1   | L1    | L1      |
    | 125    | 125    | 0.2  | kg      | UL01RAH     | L2 | L2   | L2    | L2      |


# Platzmenge prüfen
Given I open an editor "platz01-1" from table "(StorageQuantity):(LocationQuantity)" with command "VIEW" for record "$,,artikel^such==RAHMEN;platz==MLF01;"
Then fields have values
    | artikel | RAHMEN |
    | bestand | 50     |
    | le      | Stück  |
And I close the current editor
	
Given I open an editor "platz01-2" from table "(StorageQuantity):(LocationQuantity)" with command "VIEW" for record "$,,artikel^such==RAD;platz==MLF01;"
Then fields have values
    | artikel | RAD    |
    | bestand | 100    |
    | le      | Stück  |
And I close the current editor
	
Given I query "gebmge,gebf,gebeinh,lj,orig,bewmge,bewlj,beworig,charge^such" from StorageQuantity for Product "RAD" on StorageLocation "MLF01"
Then StorageQuantities have values
    | !row | gebmge | bewmge | gebf | gebeinh | charge^such | lj | orig | bewlj | beworig |
    | 1    | 50     | 50     | 1    | Stück  | RAD002      | L1 | L1   | L1    | L1      |
    | 2    | 50     | 50     | 1    | Stück  | RAD002      | L2 | L2   | L2    | L2      |


# Ruecklieferung im EK geht nur vom Originalplatz, da sonst die Bestandspruefung zuschlaegt
# Bei diesem Testfall prueft man auf den aktuellen Fehler. Wenn abgeschafft, muss der Test scheitern
