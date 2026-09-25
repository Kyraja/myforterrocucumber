# *****************************************************************************
#  Name             : rueckbuchung_zugang_austauschen.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet das Austauschen vonn Zugaengen bei Storno von
#                     Rueckbuchungen auf Abgaenge, wenn die zuerst verwendeten
#                     Zugaenge bereits durch andere Abgaenge verbraucht wurden.
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_zugang_austauschen.feature
Background:
Given I set the fake date to "12.01.95"

Scenario: Zugaenge buchen und verkaufen

# --------------------------- Testvorbereitungen -----------------------------------------------

# Bestand auf 0 setzen
And I set StorageQuantity to zero for Product "PEDALE" on StorageLocation "MLF01"

# Bewertungsverfahren im Artikel anpassen
Given I open an editor "Artikel" from table "(Part):(Product)" with command "STORE" for record "PEDALE"
And I set field "ekbewverf" to "5"
And I save the current editor

# --------------------------- Auftraege anlegen -----------------------------------------------

Given I open an editor "Auftrag1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde     | RADSHOP |
And I append rows
    | artikel   | mge     | verw   | platz |
    | PEDALE    | 50      | 1111_1 | MLF01 |
And I save the current editor

Given I open an editor "Auftrag2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde     | RADSHOP |
And I append rows
    | artikel   | mge     | verw   | platz |
    | PEDALE    | 30      | 2222_1 | MLF01 |
And I save the current editor

# --------------------------- Bedarfe einkaufen -----------------------------------------------

Given I open an editor "RechnungmL1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | PUKY    |
    | nummer    | 1re     |
    | vom       | .       |
    | fakt      | ja      |
    | ebeleg    | 01R     |
    | ueb       | ja      |
    | budat     | 12.1.95 |
And I append rows
    | artikel   | mge     | preis | platz |
    | PEDALE    | 25      | 25.00 | MLF01 |
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RechnungmL2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | PUKY    |
    | nummer    | 2re     |
    | vom       | .       |
    | fakt      | ja      |
    | ebeleg    | 02R     |
    | ueb       | ja      |
    | budat     | 12.1.95 |
And I append rows
    | artikel   | mge     | preis | platz |
    | PEDALE    | 25      | 26.00 | MLF01 |
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Journal pruefen
Given I open an editor "LJ_1re" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=PEDALE;ebeleg==01R;@richtung=rückwärts;@maxtreffer=1"
Then fields have values
    | artikel    | PEDALE   |
    | buarta     | Zugang   |
    | detursache | Rechnung |
    | mge        | 50       |
    | gmge       | 25       |
    | me         | Paar     |
And I close the current editor

Given I open an editor "LJ_2re" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=PEDALE;ebeleg==02R;@richtung=rückwärts;@maxtreffer=1"
Then fields have values
    | artikel    | PEDALE   |
    | buarta     | Zugang   |
    | detursache | Rechnung |
    | mge        | 50       |
    | gmge       | 25       |
    | me         | Paar     |
And I close the current editor

# Bestand pruefen
Given I query StorageQuantity for Product "PEDALE" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | gebeinh | orig^id    | lj^id      | bewmge | beworig^id | bewlj^id   |
    | 25     | 2    | Paar    | !LJ_1re^id | !LJ_1re^id | 25     | !LJ_1re^id | !LJ_1re^id |
    | 25     | 2    | Paar    | !LJ_2re^id | !LJ_2re^id | 25     | !LJ_2re^id | !LJ_2re^id |
And I close the current editor

# --------------------------- Ersten Auftrag ausliefern -----------------------------------------------

Given I open an editor "Lieferschein1" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "Auftrag1"
And I set field "ueb" to "ja"
And I set field "mge" to "50" in row 1
And I save the current editor

# Bestand pruefen
Given I query StorageQuantity for Product "PEDALE" on StorageLocation "MLF01"
Then StorageQuantity is zero
And I close the current editor

# Journal pruefen
Given I open an editor "LJ_1au" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=PEDALE;detursache==Lieferschein Verkauf;@richtung=rückwärts;@maxtreffer=1"
Then fields have values
    | artikel    | PEDALE               |
    | buarta     | Abgang               |
    | detursache | Lieferschein Verkauf |
    | mge        | 100                  |
    | gmge       | 50                   |
    | me         | Paar                 |
Then table has values
    | mge | le     | orig^id    | bewmge | beworig^id |
    | 50  | Stück | !LJ_1re^id | 50     | !LJ_1re^id |
    | 50  | Stück | !LJ_2re^id | 50     | !LJ_2re^id |
And I close the current editor

# Bewertung pruefen
Given I open an editor "Bewertung_1au-1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=PEDALE;detursache==Lieferschein Verkauf;buart==Abgang;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "artikel" has value "PEDALE"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Lieferschein Verkauf"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then field "ppsref^id" has value equal to field "id" from editor "LJ_1au"
Then table has values
    | tmge | bewertet | orig^id    | beworig^id |
    | 50   | direkt   | !LJ_1re^id | !LJ_1re^id |
    | 50   | direkt   | !LJ_2re^id | !LJ_2re^id |
And I close the current editor

# --------------------------- Ruecklieferung auf ersten LS -----------------------------------------------

Given I open an editor "RLS1" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "Lieferschein1"
And I set field "ueb" to "ja"
And I set field "mge" to "-35" in row 1
And I save the current editor

# Bestand pruefen
Given I query StorageQuantity for Product "PEDALE" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | gebeinh | orig^id    | lj^id      | bewmge | beworig^id | bewlj^id   |
    | 25     | 2    | Paar    | !LJ_2re^id | !LJ_2re^id | 25     | !LJ_2re^id | !LJ_2re^id |
    | 10     | 2    | Paar    | !LJ_1re^id | !LJ_1re^id | 10     | !LJ_1re^id | !LJ_1re^id |
And I close the current editor

# Journal pruefen
Given I open an editor "LJ_1au" from table "(Journal):(Journal)" with command "VIEW" for record from editor "LJ_1au"
Then fields have values
    | rueckmge        | 70 |
    | rueckgmge       | 35 |
Then table has values
    | mge | le     | orig^id    | bewmge | beworig^id |
    | 30  | Stück | !LJ_1re^id | 30     | !LJ_1re^id |
And I close the current editor

Given I open an editor "LJ_1rueck" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=PEDALE;detursache==Rücklieferung Verkauf;@richtung=rückwärts;@maxtreffer=1"
Then fields have values
    | artikel      | PEDALE                 |
    | buarta       | Abgang                 |
    | detursache   | Rücklieferung Verkauf |
    | mge          | -70                    |
    | gmge         | -35                    |
    | me           | Paar                   |
    | rueckmge     | -70                    |
    | rueckorig^id | !LJ_1au^id             |
And I close the current editor

# Bewertung pruefen
Given I open an editor "Bewertung_1au-2" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=PEDALE;detursache==Rücklieferung Verkauf;buart==Abgang;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "artikel" has value "PEDALE"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Rücklieferung Verkauf"
Then field "vorgaenger^id" has value equal to field "id" from editor "Bewertung_1au-1"
Then field "nachfolger" is empty
Then field "ppsref^id" has value equal to field "id" from editor "LJ_1au"
Then field "rueckverur^id" has value equal to field "id" from editor "LJ_1rueck"
Then table has values
    | tmge | bewertet | orig^id    | beworig^id |
    | 30   | direkt   | !LJ_1re^id | !LJ_1re^id |
And I close the current editor

# --------------------------- Zweiten Auftrag ausliefern -----------------------------------------------

Given I open an editor "Lieferschein2" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "Auftrag2"
And I set field "ueb" to "ja"
And I set field "mge" to "30" in row 1
And I save the current editor

# Bestand pruefen
Given I query StorageQuantity for Product "PEDALE" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | gebeinh | orig^id    | lj^id      | bewmge | beworig^id | bewlj^id   |
    | 5      | 2    | Paar    | !LJ_1re^id | !LJ_1re^id | 5      | !LJ_1re^id | !LJ_1re^id |
And I close the current editor

# Journal pruefen
Given I open an editor "LJ_2au" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=PEDALE;detursache==Lieferschein Verkauf;@richtung=rückwärts;@maxtreffer=1"
Then fields have values
    | artikel    | PEDALE               |
    | buarta     | Abgang               |
    | detursache | Lieferschein Verkauf |
    | mge        | 60                   |
    | gmge       | 30                   |
    | me         | Paar                 |
Then table has values
    | mge | le     | orig^id    | bewmge | beworig^id |
    | 50  | Stück | !LJ_2re^id | 50     | !LJ_2re^id |
    | 10  | Stück | !LJ_1re^id | 10     | !LJ_1re^id |
And I close the current editor

# Bewertung pruefen
Given I open an editor "Bewertung_2au" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=PEDALE;detursache==Lieferschein Verkauf;buart==Abgang;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "artikel" has value "PEDALE"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Lieferschein Verkauf"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then field "ppsref^id" has value equal to field "id" from editor "LJ_2au"
Then table has values
    | tmge | bewertet | orig^id    | beworig^id |
    | 50   | direkt   | !LJ_2re^id | !LJ_2re^id |
    | 10   | direkt   | !LJ_1re^id | !LJ_1re^id |
And I close the current editor

# --------------------------- Neue Zugaenge buchen -----------------------------------------------

Given I open an editor "RechnungmL3" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | PUKY    |
    | nummer    | 3re     |
    | vom       | .       |
    | fakt      | ja      |
    | ebeleg    | 03R     |
    | ueb       | ja      |
    | budat     | 12.1.95 |
And I append rows
    | artikel   | mge     | preis | platz |
    | PEDALE    | 20      | 27.00 | MLF01 |
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RechnungmL4" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | PUKY    |
    | nummer    | 4re     |
    | vom       | .       |
    | fakt      | ja      |
    | ebeleg    | 04R     |
    | ueb       | ja      |
    | budat     | 12.1.95 |
And I append rows
    | artikel   | mge     | preis | platz |
    | PEDALE    | 20      | 28.00 | MLF01 |
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Journal pruefen
Given I open an editor "LJ_3re" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=PEDALE;ebeleg==03R;@richtung=rückwärts;@maxtreffer=1"
Then fields have values
    | artikel    | PEDALE   |
    | buarta     | Zugang   |
    | detursache | Rechnung |
    | mge        | 40       |
    | gmge       | 20       |
    | me         | Paar     |
And I close the current editor

Given I open an editor "LJ_4re" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=PEDALE;ebeleg==04R;@richtung=rückwärts;@maxtreffer=1"
Then fields have values
    | artikel    | PEDALE   |
    | buarta     | Zugang   |
    | detursache | Rechnung |
    | mge        | 40       |
    | gmge       | 20       |
    | me         | Paar     |
And I close the current editor

# Bestand pruefen
Given I query StorageQuantity for Product "PEDALE" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | gebeinh | orig^id    | lj^id      | bewmge | beworig^id | bewlj^id   |
    | 5      | 2    | Paar    | !LJ_1re^id | !LJ_1re^id | 5      | !LJ_1re^id | !LJ_1re^id |
    | 20     | 2    | Paar    | !LJ_3re^id | !LJ_3re^id | 20     | !LJ_3re^id | !LJ_3re^id |
    | 20     | 2    | Paar    | !LJ_4re^id | !LJ_4re^id | 20     | !LJ_4re^id | !LJ_4re^id |
And I close the current editor

# --------------------------- Ruecklieferung stornieren -----------------------------------------------

Given I open an editor "SRLS1" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS1"
And I save the current editor

# Bestand pruefen
Given I query StorageQuantity for Product "PEDALE" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | gebeinh | orig^id    | lj^id      | bewmge | beworig^id | bewlj^id   |
    | 10     | 2    | Paar    | !LJ_4re^id | !LJ_4re^id | 10     | !LJ_4re^id | !LJ_4re^id |
And I close the current editor

# Journal pruefen
Given I open an editor "LJ_1au" from table "(Journal):(Journal)" with command "VIEW" for record from editor "LJ_1au"
Then fields have values
    | rueckmge        | 0 |
    | rueckgmge       | 0 |
Then table has values
    | mge | le     | orig^id    | bewmge | beworig^id |
    | 40  | Stück | !LJ_1re^id | 40     | !LJ_1re^id |
    | 40  | Stück | !LJ_3re^id | 40     | !LJ_3re^id |
    | 20  | Stück | !LJ_4re^id | 20     | !LJ_4re^id |
And I close the current editor

Given I open an editor "LJ_1rueck" from table "(Journal):(Journal)" with command "VIEW" for record from editor "LJ_1rueck"
Then fields have values
    | artikel      | PEDALE                 |
    | buarta       | Abgang                 |
    | detursache   | Rücklieferung Verkauf |
    | mge          | -70                    |
    | gmge         | -35                    |
    | me           | Paar                   |
    | rueckmge     | -70                    |
    | rueckorig^id | !LJ_1au^id             |
    | storniert    | ja                     |
And I close the current editor

Given I open an editor "LJ_1storno" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=PEDALE;detursache==Storno-Rücklieferung Verkauf;@richtung=rückwärts;@maxtreffer=1"
Then fields have values
    | artikel      | PEDALE                        |
    | buarta       | Abgang                        |
    | detursache   | Storno-Rücklieferung Verkauf |
    | mge          | 70                            |
    | gmge         | 35                            |
    | me           | Paar                          |
    | stornolj^id  | !LJ_1rueck^id                 |
And I close the current editor

# Bewertung pruefen
Given I open an editor "Bewertung_1au-3" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=PEDALE;detursache==Storno-Rücklieferung Verkauf;buart==Abgang;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "artikel" has value "PEDALE"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Storno-Rücklieferung Verkauf"
Then field "vorgaenger^id" has value equal to field "id" from editor "Bewertung_1au-2"
Then field "nachfolger" is empty
Then field "ppsref^id" has value equal to field "id" from editor "LJ_1au"
Then field "stornoverur^id" has value equal to field "id" from editor "LJ_1storno"
Then table has values
    | tmge | bewertet | orig^id    | beworig^id |
    | 40   | direkt   | !LJ_1re^id | !LJ_1re^id |
    | 40   | direkt   | !LJ_3re^id | !LJ_3re^id |
    | 20   | direkt   | !LJ_4re^id | !LJ_4re^id |
And I close the current editor

Given I open an editor "Bewertung_1au-2" from table "(Valuation):(Valuation)" with command "VIEW" for record from editor "Bewertung_1au-2"
Then field "nachfolger^id" has value equal to field "id" from editor "Bewertung_1au-3"
And I close the current editor
