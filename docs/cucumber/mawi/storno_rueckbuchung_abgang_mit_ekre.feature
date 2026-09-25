# *****************************************************************************
#  Name             : storno_rueckbuchung_abgang_mit_ekre.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet ob beim Storno einer RB auf Abgang die Bewertung
#                     analog der Zugangsbewertung wieder hergestellt wird.
#
# Test zu Scenario aus BW2-1101
#
# *****************************************************************************
@persistent
Feature: storno_rueckbuchung_abgang_mit_ekre.feature
Background:
Given I set the fake date to "12.01.95"

Scenario: Testvorbereitung
# Artikel LENKER anlegen
Given I open an editor "LENKER" from table "(Part):(Product)" with command "STORE" for record "LENKER"

And I set fields
    | such      | LENKER                 |
    | namebspr  | Lenker Fahrrad classic |
    | lief      | PUKY                   |
    | zuplatz   | MLF01                  |
    | abplatz   | MLF01                  |
    | ekbewverf | 5                      |

And I save the current editor

# Auftrag anlegen
Given I open an editor "Auftrag1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde     | RADSHOP |
And I append rows
    | artikel | mge     | verw   | platz |
    | LENKER  | 50      | 2222_1 | MLF01 |
And I save the current editor

# ---------------------------------------------------------------------------------------------------

Scenario: Bedarfe einkaufen und berechnen
# Bestellung
Given I open an editor "Bestellung1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | nummer    | 1be     |
    | lief      | PUKY    |
    | vom       | .       |
    | erfwaehr  | DEM     |
And I append rows
    | artikel   | mge     | preis | platz |
    | LENKER    | 50      | 10.00 | MLF01 |
And I save the current editor

# Lieferschein
Given I open an editor "EK-LS1" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "Bestellung1"
And I set fields
    | nummer    | 1ls     |
    | vom       | .       |
    | ebeleg    | 1LS     |
    | ueb       | ja      |
    | erfwaehr  | DEM     |
And I append rows
    | artikel   | mge     | preis | platz |
    | LENKER    | 50      | 10.00 | MLF01 |
And I save the current editor

# Journal zu Zugang
Given I open an editor "LJ_1ls" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=LENKER;ebeleg==1LS;buarta==Zugang;@richtung=rückwärts;@maxtreffer=1"
Then fields have values
    | artikel    | LENKER               |
    | buarta     | Zugang               |
    | detursache | Lieferschein Einkauf |
    | mge        | 50                   |
And I close the current editor

# Bewertung zu Zugang
Given I open an editor "Bewertung_1ls" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=LENKER;detursache==Lieferschein Einkauf;buart==Zugang;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "artikel" has value "LENKER"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Lieferschein Einkauf"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then field "ppsref^id" has value equal to field "id" from editor "LJ_1ls"
Then table has values
    | tmge | bewertet   | tbewpr   | orig^id    | beworig^id |
    | 50   | vorläufig | 10.0000  | !LJ_1ls^id | !LJ_1ls^id |
And I close the current editor

Scenario: 1. Teilrechnung im Einkauf
Given I open an editor "EK-Re1" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "EK-LS1"
And I set fields
    | nummer    | 1tre      |
    | vom       | .         |
    | budat     | 12.01.95  |
    | ebeleg    | 1TRE      |
    | ueb       | ja        |
    | erfwaehr  | DEM       |
And I modify table
    | !row | mge | preis |
    | 1    | 25  | 9.00  |
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

Given I open an editor "Bewertung_1tre" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=LENKER;detursache==Rechnung;buart==Neubewertung;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "artikel" has value "LENKER"
Then field "buart" has value "Neubewertung"
Then field "detursache" has value "Rechnung"
Then field "vorgaenger^id" has value equal to field "id" from editor "Bewertung_1ls"
Then field "nachfolger" is empty
Then field "ppsref^id" has value equal to field "id" from editor "LJ_1ls"
Then table has values
    | kart              | tmge | bewertet   | tbewpr   | orig^id    | beworig^id |
    | Rechnungs-Wert    | 25   | direkt     | 9.0000   | !LJ_1ls^id | !LJ_1ls^id |
    | Lieferschein-Wert | 25   | vorläufig | 10.0000  | !LJ_1ls^id | !LJ_1ls^id |
And I close the current editor

Scenario: 2. Teilrechnung im Einkauf
Given I open an editor "EK-Re2" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "EK-LS1"
And I set fields
    | nummer    | 2tre      |
    | vom       | .         |
    | budat     | 12.01.95  |
    | ebeleg    | 2TRE      |
    | ueb       | ja        |
    | erfwaehr  | DEM       |
And I modify table
    | !row | mge | preis |
    | 1    | 15  | 8.00  |
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

Given I open an editor "Bewertung_2tre" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=LENKER;detursache==Rechnung;buart==Neubewertung;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "artikel" has value "LENKER"
Then field "buart" has value "Neubewertung"
Then field "detursache" has value "Rechnung"
Then field "vorgaenger^id" has value equal to field "id" from editor "Bewertung_1tre"
Then field "nachfolger" is empty
Then field "ppsref^id" has value equal to field "id" from editor "LJ_1ls"
Then table has values
    | kart              | tmge | bewertet   | tbewpr   | orig^id    | beworig^id |
    | Rechnungs-Wert    | 15   | direkt     | 8.0000   | !LJ_1ls^id | !LJ_1ls^id |
    | Rechnungs-Wert    | 25   | direkt     | 9.0000   | !LJ_1ls^id | !LJ_1ls^id |
    | Lieferschein-Wert | 10   | vorläufig | 10.0000  | !LJ_1ls^id | !LJ_1ls^id |
And I close the current editor

Scenario: LENKER ausliefern
Given I open an editor "VK-LS1" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "Auftrag1"
And I set fields
    | nummer | 1vkls |
    | ueb    | ja    |
And I modify table
    | !row | mge | platz |
    | 1    | 50  | MLF01 |
And I save the current editor

# Journal zu Zugang
Given I open an editor "LJ_1vkls" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=LENKER;buarta==Abgang;@richtung=rückwärts;@maxtreffer=1"
Then fields have values
    | artikel    | LENKER               |
    | buarta     | Abgang               |
    | detursache | Lieferschein Verkauf |
    | mge        | 50                   |
Then table has values
     | mge | orig^id    | lj^id      | bewmge | beworig^id | bewlj^id   |
     | 50  | !LJ_1ls^id | !LJ_1ls^id | 50     | !LJ_1ls^id | !LJ_1ls^id |
And I close the current editor

# Bewertung Abgang
Given I open an editor "Bewertung_1vkls" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=LENKER;detursache==Lieferschein Verkauf;buart==Abgang;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "artikel" has value "LENKER"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Lieferschein Verkauf"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then field "ppsref^id" has value equal to field "id" from editor "LJ_1vkls"
Then table has values
    | kart     | tmge | bewertet   | tbewpr   | orig^id    | beworig^id | zugbew^id          |
    | Entnahme | 15   | direkt     | 8.0000   | !LJ_1ls^id | !LJ_1ls^id | !Bewertung_2tre^id |
    | Entnahme | 25   | direkt     | 9.0000   | !LJ_1ls^id | !LJ_1ls^id | !Bewertung_2tre^id |
    | Entnahme | 10   | vorläufig | 10.0000  | !LJ_1ls^id | !LJ_1ls^id | !Bewertung_2tre^id |
And I close the current editor

Scenario: LENKER wird zurueckgeliefert
Given I open an editor "VK-RLS1" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "VK-LS1"
And I set fields
    | nummer | 1vkrls |
    | ueb    | ja     |
And I modify table
    | !row | mge | platz |
    | 1    | -40 | MLF01 |
And I save the current editor

# Journal zu Zugang
Given I open an editor "LJ_1vkls" from table "(Journal):(Journal)" with command "VIEW" for record from editor "LJ_1vkls"
Then fields have values
    | artikel    | LENKER               |
    | buarta     | Abgang               |
    | detursache | Lieferschein Verkauf |
    | mge        | 50                   |
    | rueckmge   | 40                   |
    | restmge    | 10                   |
Then table has values
     | mge | orig^id    | lj^id      | bewmge | beworig^id | bewlj^id   |
     | 10  | !LJ_1ls^id | !LJ_1ls^id | 10     | !LJ_1ls^id | !LJ_1ls^id |
And I close the current editor

# Journal zu Ruecklieferung
Given I open an editor "LJ_1rueck" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=LENKER;buarta==Abgang;detursache=Rücklieferung Verkauf;@richtung=rückwärts;@maxtreffer=1"
Then fields have values
    | artikel      | LENKER                 |
    | buarta       | Abgang                 |
    | detursache   | Rücklieferung Verkauf |
    | mge          | -40                    |
    | rueckorig^id | !LJ_1vkls^id           |
And I close the current editor

# Bewertung Abgang
Given I open an editor "Bewertung_1rueck" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=LENKER;detursache==Rücklieferung Verkauf;buart==Abgang;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "artikel" has value "LENKER"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Rücklieferung Verkauf"
Then field "vorgaenger^id" has value equal to field "id" from editor "Bewertung_1vkls"
Then field "rueckverur^id" has value equal to field "id" from editor "LJ_1rueck"
Then field "nachfolger" is empty
Then field "ppsref^id" has value equal to field "id" from editor "LJ_1vkls"
Then table has values
    | kart     | tmge | bewertet   | tbewpr   | orig^id    | beworig^id | zugbew^id          |
    | Entnahme | 10   | direkt     | 8.0000   | !LJ_1ls^id | !LJ_1ls^id | !Bewertung_2tre^id |
And I close the current editor

Scenario: Ruecklieferung wird wieder storniert
Given I open an editor "VK-SRLS1" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "VK-RLS1"
And I set field "nummer" to "1storno"
And I save the current editor

# Journal zu Zugang
Given I open an editor "LJ_1vkls" from table "(Journal):(Journal)" with command "VIEW" for record from editor "LJ_1vkls"
Then fields have values
    | artikel    | LENKER               |
    | buarta     | Abgang               |
    | detursache | Lieferschein Verkauf |
    | mge        | 50                   |
    | rueckmge   | 0                    |
    | restmge    | 50                   |
Then table has values
     | mge | orig^id    | lj^id      | bewmge | beworig^id | bewlj^id   |
     | 50  | !LJ_1ls^id | !LJ_1ls^id | 50     | !LJ_1ls^id | !LJ_1ls^id |
And I close the current editor

# Journal zu Ruecklieferung
Given I open an editor "LJ_1rueck" from table "(Journal):(Journal)" with command "VIEW" for record from editor "LJ_1rueck"
Then fields have values
    | artikel      | LENKER                 |
    | buarta       | Abgang                 |
    | detursache   | Rücklieferung Verkauf |
    | mge          | -40                    |
    | rueckorig^id | !LJ_1vkls^id           |
    | storniert    | ja                     |
And I close the current editor

# Journal zu Storno der Ruecklieferung
Given I open an editor "LJ_1storno" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=LENKER;buarta==Abgang;detursache=Storno-Rücklieferung Verkauf;@richtung=rückwärts;@maxtreffer=1"
Then fields have values
    | artikel      | LENKER                        |
    | buarta       | Abgang                        |
    | detursache   | Storno-Rücklieferung Verkauf |
    | mge          | 40                            |
    | stornolj^id  | !LJ_1rueck^id                 |
And I close the current editor

# Bewertung Abgang
Given I open an editor "Bewertung_1storno" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=LENKER;detursache==Storno-Rücklieferung Verkauf;buart==Abgang;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "artikel" has value "LENKER"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Storno-Rücklieferung Verkauf"
Then field "vorgaenger^id" has value equal to field "id" from editor "Bewertung_1rueck"
Then field "stornoverur^id" has value equal to field "id" from editor "LJ_1storno"
Then field "nachfolger" is empty
Then field "ppsref^id" has value equal to field "id" from editor "LJ_1vkls"
Then table has values
    | kart     | tmge | bewertet   | tbewpr   | orig^id    | beworig^id | zugbew^id          |
    | Entnahme | 15   | direkt     | 8.0000   | !LJ_1ls^id | !LJ_1ls^id | !Bewertung_2tre^id |
    | Entnahme | 25   | direkt     | 9.0000   | !LJ_1ls^id | !LJ_1ls^id | !Bewertung_2tre^id |
    | Entnahme | 10   | vorläufig | 10.0000  | !LJ_1ls^id | !LJ_1ls^id | !Bewertung_2tre^id |
And I close the current editor
