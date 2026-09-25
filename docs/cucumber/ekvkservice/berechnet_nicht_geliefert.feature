# ***************************************************************************
#
#  Name      : berechnet_nicht_geliefert.feature
#  Datum     : 21.06.2024
#  Autor     : as
#  Verantwortlich : teampss
#
#  Funktion  : Cucumber Skript zum Zwischenkonto "Berechnet, nicht geliefert"
#              Ausgabe der Finanzbuchungen nach berechnet_nicht_geliefert.ref
#              Verwendete Konten:
#                    36301 Zwischenkonto
#                    10000 Roh- ,Hilfs- und Betriebsstoffe - ROH-
#                    14060 Anrechenbare Vorsteuer 15%
#
# ***************************************************************************
@persistent
Feature: Zwischenkonto Berechnet, nicht geliefert
Background:
Given I set the fake date to "02.01.1995"


# ----------------------------------------------------------------------------------------------
Scenario: Stammdaten
# ----------------------------------------------------------------------------------------------

# Materialzuschlag anlegen
Given I open an editor "matzuschlag" from table "(Company):(MaterialSurchargeHeader)" with command "STORE" for record "30"
And I append rows
	| matart | matbasis | matnotiz |
	| CU     | 100      | 110      |
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
   | fehe      | 2                |
   | ehe       | kg               |
And I save the current editor

# Artikel mit Materialzuschlag anlegen
Given I open an editor "AMATZU" from table "(Part):(Product)" with command "COPY" for record from editor "A100"
And I set fields
   | such      | AMATZU         |
   | name      | Artikel AMATZU |
   | matart    | CU             |
   | zmge      | 0,5            |
   | matvrel   | ja             |
   | materel   | ja             |
And I save the current editor

# Zusatzposition Transportkosten
Given I open an editor "FRACHT" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set fields
    | such      | FRACHT            |
    | namebspr  | Frachtkosten      |
    | zptyp     | Neutrale Position |
    | lirelev   | ja                |
    | rerelev   | ja                |
And I save the current editor

# Zusatzposition vom Typ AU/BE anlegen
Given I open an editor "zusatzAUBE" from table "(Part):(SupplementaryItem)" with command "STORE" for record "AUBE"
And I set fields
   | such      | AUBE                 |
   | namebspr  | Zusatzposition AU/BE |
   | zptyp     | AU/BE-Position,BV    |
   | vkbez     | Zusatzposition AU/BE |
   | vbez      | Zusatzposition AU/BE |
   | ebez      | Zusatzposition AU/BE |
   | vpr       | 1100                 |
   | epr       | 1000                 |
And I save the current editor

# Artikel mit Beistellung anlegen
Given I open an editor "ABEIST" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | ABEIST                  |
   | namebspr | Artikel mit Beistellung |
   | lief     | 1                       |
   | epr      | 1000                    |
   | bsart    | Fremdbeschaffung        |
   | dispoa   | bedarfsbezogen          |
And I save the current editor

Given I open an editor "BEIST" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | BEIST                   |
   | namebspr | Beistellartikel         |
   | lief     | 1                       |
   | epr      | 100                     |
   | bsart    | Fremdbeschaffung        |
   | dispoa   | bedarfsbezogen          |
And I save the current editor

# Beistellung im Artikel eintragen
Given I open an editor "ABEIST" from table "(Part):(Product)" with command "UPDATE" for record from editor "ABEIST"
And I append rows
   | elex  | elanzahl | bua                    |
   | BEIST | 2        | Lieferantenbeistellung |
And I save the current editor

# Lohnfertigungsartikel anlegen
Given I open an editor "LOHNFERT" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| such		| LOHNFERT      |
	| namebspr	| Lohnfertigung |
	| bsart		| Lohnfertigung |
And I save the current editor

# Artikel anlegen
Given I open an editor "A200" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such      | A200             |
   | name      | Artikel A200     |
   | bsart     | Fremdbeschaffung |
   | dispoa    | auftragsbezogen  |
   | vpr       | 10               |
   | lief      | 1                |
   | chimlager | ja               |
   | epr       | 10               |
And I save the current editor

# Dienstleistung
Given I open an editor "DL001" from table "(Part):(Service)" with command "NEW" for record ""
And I set fields
  | such | REPARIEREN |
  | vpr  | 50         |
  | epr  | 60         |
And I append rows
  | elex  | anzahl |
  | A200  | 1      |
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: Teilrechnungen, unterschiedliche Einheiten
# ----------------------------------------------------------------------------------------------
#
#
#  (ev)ngeliefertremge = BNG
#
#      / ------- 1LS001 ------ 1RE001
#     /          20 St.        20 kg  (BNG = 0 kg)
#    /
#  1BE001 ------------------------- 2LS001 ------ 1RLS001
#  100 St.                          40 St.        20 St.
#    \
#     \ ---------------------------------------------- 2RE001
#      \                                               60 kg (BNG = 20 kg)
#       \
#        \ ------------------------------------------------ 3RE001
#         \                                                 20 kg (BNG = 20 kg)
#          \
#           \ -------------------------------------------------- 3LS001
#            \                                                   30 St.
#             \
#              \ ---------------------------------------------------- 4RE001
#                                                                     10 St. (BNG = 0 St.)
#

# Bestellung
Given I open an editor "1BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE001 |
   | lief    | 1      |
And I append rows
   | artikel | mge | he    |
   | A100    | 100 | Stück |
And I save the current editor

# Lieferschein
Given I open an editor "1LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE001"
And I set fields
   | nummer | 1LS001 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "20" in row 1
And I set field "he" to "Stück" in row 1
And I save the current editor

# Rechnung
Given I open an editor "1RE001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS001"
And I set fields
   | nummer | 1RE001  |
   | ueb    | nein    |
   | vom    | .       |
And I set field "mge" to "20" in row 1
And I set field "he" to "kg" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "remehrberechneticon" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein
Given I open an editor "2LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE001"
And I set fields
   | nummer | 2LS001 |
   | fakt   | nein   |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "40" in row 1
And I set field "he" to "Stück" in row 1
And I save the current editor

# Ruecklieferschein
Given I open an editor "1RLS001" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "2LS001"
And I set fields
   | nummer | 1RLS001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-20" in row 1
And I set field "he" to "Stück" in row 1
And I save the current editor

# Rechnung
Given I open an editor "2RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE001"
And I set fields
   | nummer | 2RE001  |
   | ueb    | nein    |
   | vom    | .       |
And I set field "mge" to "60" in row 1
And I set field "he" to "kg" in row 1
Then field "ngeliefertremgeges" has value "-40" in row 1
Then field "ngeliefertremge" has value "20" in row 1
Then field "remehrberechneticon" has value "icon:ball_yellow" in row 1
Then field "posnsammel" has value "ja"
Then field "posnsammel" is not modifiable
And I set field "mge" to "40" in row 1
Then field "posnsammel" has value "ja"
Then field "posnsammel" is modifiable
And I set field "posnsammel" to "nein"
And I set field "mge" to "60" in row 1
Then field "posnsammel" has value "ja"
Then field "posnsammel" is not modifiable
And I set field "mge" to "40" in row 1
Then field "posnsammel" has value "ja"
Then field "posnsammel" is modifiable
And I set field "posnsammel" to "nein"
And I set field "mge" to "60" in row 1
Then field "posnsammel" has value "ja"
Then field "posnsammel" is not modifiable
#
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "60" in row 1
Then field "zwischenkonto" has value "36301" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung
Given I open an editor "3RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE001"
And I set fields
   | nummer | 3RE001  |
   | ueb    | nein    |
   | vom    | .       |
And I set field "mge" to "20" in row 1
And I set field "he" to "kg" in row 1
Then field "ngeliefertremgeges" has value "-40" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "remehrberechneticon" has value "" in row 1
Then field "konto" has value "10000" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "20" in row 1
Then field "zwischenkonto" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung 2RE001 buchen
Given I open an editor "2RE001" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "2RE001"
And I set fields
   | ueb    | ja      |
Then field "ngeliefertremgeges" has value "-40" in row 1
Then field "ngeliefertremge" has value "20" in row 1
Then field "remehrberechneticon" has value "icon:ball_yellow" in row 1
#
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "60" in row 1
Then field "zwischenkonto" has value "36301" in row 1
And I save the current editor

# Rechnung 3RE001 buchen
Given I open an editor "2RE001" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "3RE001"
And I set fields
   | ueb    | ja      |
Then field "ngeliefertremgeges" has value "20" in row 1
Then field "ngeliefertremge" has value "20" in row 1
Then field "remehrberechneticon" has value "icon:ball_yellow" in row 1
#
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "20" in row 1
Then field "zwischenkonto" has value "36301" in row 1
And I save the current editor

# Lieferschein
Given I open an editor "3LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE001"
And I set fields
   | nummer | 3LS001 |
   | fakt   | nein   |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "30" in row 1
And I set field "he" to "Stück" in row 1
And I save the current editor

# Rechnung
Given I open an editor "4RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE001"
And I set fields
   | nummer | 4RE001  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "10" in row 1
And I set field "he" to "Stück" in row 1
Then field "ngeliefertremgeges" has value "-10" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "remehrberechneticon" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Teilrechnungen, Kostenumlagen
# ----------------------------------------------------------------------------------------------
#
#  1BE002 ------- 1RE002
#  100 kg         20 kg (BNG = 20 kg)
#    \
#     \ -------------- 2RE002
#      \               40 kg (BNG = 40 kg)
#       \
#        \ --------------- 3RE002 (Transportkosten -> 2RE002)
#         \
#          \
#           \ ----------------- 4RE002  (Transportkosten -> 2RE002)
#            \
#             \
#              \ ------------------ 1LS002
#                                   40 kg
#

# Bestellung
Given I open an editor "1BE002" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE002 |
   | lief    | 1      |
And I append rows
   | artikel | mge | he  |
   | A100    | 100 | kg  |
And I save the current editor

# Rechnung
Given I open an editor "1RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE002"
And I set fields
   | nummer | 1RE002  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "20" in row 1
And I set field "he" to "kg" in row 1
Then field "ngeliefertremgeges" has value "0" in row 1
Then field "ngeliefertremge" has value "20" in row 1
Then field "remehrberechneticon" has value "icon:ball_yellow" in row 1
Then field "konto" has value "36301" in row 1
And I set field "fakt" to "ja"
Then field "ngeliefertremgeges" has value "0" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "remehrberechneticon" has value "" in row 1
Then field "konto" has value "10000" in row 1
Then field "posnsammel" has value "ja"
Then field "posnsammel" is modifiable
And I set field "posnsammel" to "nein"
And I set field "fakt" to "nein"
Then field "ngeliefertremgeges" has value "0" in row 1
Then field "ngeliefertremge" has value "20" in row 1
Then field "remehrberechneticon" has value "icon:ball_yellow" in row 1
Then field "konto" has value "36301" in row 1
Then field "posnsammel" has value "ja"
Then field "posnsammel" is not modifiable
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung
Given I open an editor "2RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE002"
And I set fields
   | nummer | 2RE002  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "40" in row 1
And I set field "he" to "kg" in row 1
Then field "ngeliefertremgeges" has value "20" in row 1
Then field "ngeliefertremge" has value "40" in row 1
Then field "remehrberechneticon" has value "icon:ball_yellow" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung (Transportkosten)
Given I open an editor "3RE002" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer | 3RE002  |
    | lief   | 1       |
    | ueb    | ja      |
    | vom    | .       |
And I append rows
    | artikel   | pwert |
    | FRACHT    | 5     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Kostenumlage 3RE002 -> 2RE002
Given I open an editor "1KU002" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "nummer" to "1KU002"
And I set field "pos" to "$,,@gruppe=4:2;artikel=FRACHT;kopf^nummer=3RE002;@ablageart=abgelegt"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,@gruppe=4:2;artikel=A100;kopf^nummer=2RE002;@ablageart=abgelegt" in row !lastRow
And I save the current editor

# Rechnung (Transportkosten)
Given I open an editor "4RE002" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer | 4RE002  |
    | lief   | 1       |
    | ueb    | ja      |
    | vom    | .       |
And I append rows
    | artikel   | pwert |
    | FRACHT    | 5     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Kostenumlage 4RE002 -> 2RE002
Given I open an editor "2KU002" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "nummer" to "2KU002"
And I set field "pos" to "$,,@gruppe=4:2;artikel=FRACHT;kopf^nummer=4RE002;@ablageart=abgelegt"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,@gruppe=4:2;artikel=A100;kopf^nummer=2RE002;@ablageart=abgelegt" in row !lastRow
And I save the current editor

# Lieferschein
Given I open an editor "1LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE002"
And I set fields
   | nummer | 1LS002 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "40" in row 1
And I set field "he" to "kg" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Lohnfertigung Beistellung nicht lieferrelevant keine Auswirkung
# ----------------------------------------------------------------------------------------------
# Lohnfertigung, Beistellung und nicht lieferrelevant, Menge 'Berechnet, nicht geliefert' = 0
#
# Bestellung
Given I open an editor "1BE003" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE003 |
   | lief    | 1      |
And I append rows
   | artikel  | mge | he    | lirelev |
   | ABEIST   | 100 | Stück | ja      |
   | A100     | 100 | Stück | nein    |
   | LOHNFERT | 100 | Stück | nein    |
And I save the current editor

# Rechnung
Given I open an editor "1RE003" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE003"
And I set fields
	| nummer | 1RE003 |
	| fakt   | nein   |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "100" in row 1
Then table has values
	| lbeist | ngeliefertremgeges | ngeliefertremge |
	| ja     | 0                  | 0               |
	| nein   | 0                  | 0               |
	| nein   | 0                  | 0               |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Lieferscheinstorno, Lieferschein vor Rechnung
# ----------------------------------------------------------------------------------------------
#
#  1BE004 ----- 1LS004 ------ 1LS004S
#  100 kg       100 kg       -100 kg
#    \
#     \ -------------- 1RE004
#                      100 kg

# Bestellung
Given I open an editor "1BE004" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
	| nummer  | 1BE004 |
	| lief    | 1      |
And I append rows
	| artikel | mge |
	| A100    | 100 |
And I save the current editor

# Lieferschein
Given I open an editor "1LS004" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE004"
And I set fields
	| nummer | 1LS004 |
	| fakt   | nein   |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "100" in row 1
And I save the current editor

# Rechnung
Given I open an editor "1RE004" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE004"
And I set fields
	| nummer | 1RE004 |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "100" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "remehrberechneticon" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferscheinstorno
Given I open an editor "1LS004S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "1LS004"
And I set fields
	| nummer | 1LS004S |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Lieferscheinstorno, Rechnung vor Lieferschein
# ----------------------------------------------------------------------------------------------
#
#  1BE005 ----- 1RE005
#  100 kg       100 kg
#    \
#     \ -------------- 1LS005 ------ 1LS005S
#                      100 kg       -100 kg

# Bestellung
Given I open an editor "1BE005" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
	| nummer  | 1BE005 |
	| lief    | 1      |
And I append rows
	| artikel | mge |
	| A100    | 100 |
And I save the current editor

# Rechnung
Given I open an editor "1RE005" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE005"
And I set fields
	| nummer | 1RE005 |
	| fakt   | nein   |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein
Given I open an editor "1LS005" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE005"
And I set fields
	| nummer | 1LS005 |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "100" in row 1
And I save the current editor

# Lieferscheinstorno
Given I open an editor "1LS005S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "1LS005"
And I set fields
	| nummer | 1LS005S |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Lieferscheinstorno, Rechnung vor und nach dem Lieferschein
# ----------------------------------------------------------------------------------------------
#
#  1BE006 ----- 1RE006
#  100 kg       50 kg
#    \
#     \ -------------- 1LS006 ------ 1LS006S
#      \               100 kg       -100 kg
#       \
#        \ ------------------ 2RE006
#                             50 kg

# Bestellung
Given I open an editor "1BE006" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
	| nummer  | 1BE006 |
	| lief    | 1      |
And I append rows
	| artikel | mge |
	| A100    | 100 |
And I save the current editor

# Rechnung
Given I open an editor "1RE006" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE006"
And I set fields
	| nummer | 1RE006 |
	| fakt   | nein   |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein
Given I open an editor "1LS006" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE006"
And I set fields
	| nummer | 1LS006 |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "100" in row 1
And I save the current editor

# Rechnung
Given I open an editor "2RE006" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE006"
And I set fields
	| nummer | 2RE006 |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferscheinstorno
Given I open an editor "1LS006S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "1LS006"
And I set fields
	| nummer | 1LS006S |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Ruecklieferung und Ersatzlieferung
# ----------------------------------------------------------------------------------------------
#
#  1BE007 ----------------------- 1RE007
#  10 kg                          10 kg
#    \
#     \ ------- 1LS007
#      \        10 kg
#       \         \
#        \         \ ----- 1RLS007
#         \                -2 kg
#          \
#           \ ---------------------------- 2LS007 (Ersatzlieferung)
#                                          2 kg

# Bestellung
Given I open an editor "1BE007" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
	| nummer  | 1BE007 |
	| lief    | 1      |
And I append rows
	| artikel | mge | preis |
	| A100    | 10  | 100   |
And I save the current editor

# Lieferschein
Given I open an editor "1LS007" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE007"
And I set fields
	| nummer | 1LS007 |
	| ueb    | ja     |
	| vom    | .      |
	| fakt   | nein   |
And I set field "mge" to "10" in row 1
And I save the current editor

# Ruecklieferung
Given I open an editor "1RLS007" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS007"
And I set fields
	| nummer | 1RLS007 |
	| ueb    | ja      |
	| vom    | .       |
And I set field "mge" to "-2" in row 1
And I set field "rerelev" to "false" in row 1
And I save the current editor

# Rechnung
Given I open an editor "1RE007" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE007"
And I set fields
	| nummer | 1RE007 |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ersatzlieferung
Given I open an editor "2LS007" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE007"
And I set fields
	| nummer | 2LS007 |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "2" in row 1
And I set field "rerelev" to "false" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Rechnung ungebucht Lieferschein gebucht Rechnungsbuchung mit uebertragen
# ----------------------------------------------------------------------------------------------
# Rechnung (ungebucht), Lieferschein (gebucht), Rechnungsbuchung mit Kommando <uebertragen>
#
# Bestellung
Given I open an editor "1BE008" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
	| nummer  | 1BE008 |
	| lief    | 1      |
And I append rows
	| artikel | mge |
	| A100    | 100 |
And I save the current editor

# Rechnung
Given I open an editor "1RE008" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE008"
And I set fields
	| nummer | 1RE008 |
	| fakt   | nein   |
	| ueb    | nein   |
	| vom    | .      |
And I set field "mge" to "100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein
Given I open an editor "1LS008" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE008"
And I set fields
	| nummer | 1LS008 |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "100" in row 1
And I save the current editor

Given I open an editor "1RE008" from table "(Purchasing):(Invoice)" with command "TRANSFER" for record "1RE008"
And I save the current editor

Given I open an editor "1RE008" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1RE008"
Then field "ngeliefertremgeges" has value "-100" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "remehrberechneticon" has value "" in row 1
Then field "posnsammel" has value "ja"
Then field "konto" has value "10000" in row 1
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Rechnungsstorno, Bestellung mit MZs
# ----------------------------------------------------------------------------------------------
#
#  1BE009 ----------------------- 1RE009 ----------------- 1RE009S
#  100 kg                         100 kg                  -100 kg
#    \
#     \ ------- 1LS009 ------------------ 1LS009S
#      \        20 kg                    -20 kg
#       \
#        \ --------------- 2LS009
#         \                30 kg
#          \
#           \ ------------------------------------- 3LS009
#            \                                      40 kg
#             \
#              \ ------------------------------------------------- 2RE009
#               \                                                  100 kg
#                \
#                 \ ----------------------------------------------------- 4LS009
#                                                                         30 kg

# Bestellung
Given I open an editor "1BE009" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE009 |
   | lief    | 1      |
And I append rows
   | artikel | mge |
   | A100    | 100 |
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | zuomge |
    | F1     | 50     |
    | F2     | 50     |
And I save the current editor
And I switch the current editor to editor "1BE009"
And I save the current editor

# Lieferschein
Given I open an editor "1LS009" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE009"
And I set fields
	| nummer | 1LS009 |
	| fakt	| nein   |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "20" in row 1
And I save the current editor

# Lieferschein
Given I open an editor "2LS009" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE009"
And I set fields
	| nummer | 2LS009 |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "30" in row 1
And I save the current editor

# Rechnung
Given I open an editor "1RE009" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE009"
And I set fields
	| nummer | 1RE009 |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferscheinstorno
Given I open an editor "1LS009S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "1LS009"
And I set fields
	| nummer | 1LS009S |
And I save the current editor

# Lieferschein
Given I open an editor "3LS009" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE009"
And I set fields
	| nummer | 3LS009 |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "40" in row 1
And I save the current editor

# Rechnungsstorno
Given I open an editor "1RE009S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1RE009"
And I set fields
   | nummer | 1RE009S |
And I save the current editor

# Rechnung
Given I open an editor "2RE009" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE009"
And I set fields
	| nummer | 1RE009 |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein
Given I open an editor "4LS009" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE009"
And I set fields
	| nummer | 4LS009 |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "30" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Bestellung mit MZs, Rechnungen vor und nach dem Lieferschein, Ruecklieferung
# ----------------------------------------------------------------------------------------------
#
#  1BE010 ------ 1RE010
#  100 kg        50 kg
#    \
#     \ --------------- 1LS010 -------- 1RLS010
#      \                100 kg         -60 kg
#       \
#        \ -------------------- 2RE010
#                               50 kg
#

# Bestellung
Given I open an editor "1BE010" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE010 |
   | lief    | 1      |
And I append rows
   | artikel | mge |
   | A100    | 100 |
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | zuomge |
    | F1     | 50     |
    | F1     | 50     |
And I save the current editor
And I switch the current editor to editor "1BE010"
And I save the current editor

# Rechnung
Given I open an editor "1RE010" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE010"
And I set fields
	| nummer | 1RE010 |
	| ueb    | ja     |
	| vom    | .      |
	| fakt   | nein   |
And I set field "mge" to "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein
Given I open an editor "1LS010" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE010"
And I set fields
	| nummer | 1LS010 |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "100" in row 1
And I save the current editor

# Rechnung
Given I open an editor "2RE010" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE010"
And I set fields
	| nummer | 2RE010 |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "1RLS010" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS010"
And I set fields
	| nummer | 1RLS010 |
	| ueb    | nein    |
	| vom    | .       |
And I set field "mge" to "-60" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Bestellung mit MZs, Rechnung, Lieferung
# ----------------------------------------------------------------------------------------------
#
#  1BE011 ------ 1RE011
#  100 kg        70 kg
#    \
#     \ --------------- 2RE011
#      \                30 kg
#       \
#        \ -------------------- 1LS011
#                               100 kg
#

# Bestellung
Given I open an editor "1BE011" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE011 |
   | lief    | 1      |
And I append rows
   | artikel | mge |
   | A100    | 100 |
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | zuomge |
    | F1     | 50     |
    | F2     | 50     |
And I save the current editor
And I switch the current editor to editor "1BE011"
And I save the current editor

# Rechnung
Given I open an editor "1RE011" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE011"
And I set fields
	| nummer | 1RE011 |
	| fakt   | nein   |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "70" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung
Given I open an editor "2RE011" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE011"
And I set fields
	| nummer | 2RE011 |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "30" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein
Given I open an editor "1LS011" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE011"
And I set fields
	| nummer | 1LS011 |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "100" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Bestellung mit MZs, Rechnung, Lieferscheinstorno
# ----------------------------------------------------------------------------------------------
#
#  1BE012 ------ 1RE012
#  100 kg        50 kg
#    \
#     \ --------------- 2RE012
#      \                50 kg
#       \
#        \ -------------------- 1LS012 ------ 1LS012S
#         \                     100 kg       -100 kg
#          \
#           \ --------------------------------------- 2LS012
#                                                     100 kg

# Bestellung
Given I open an editor "1BE012" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE012 |
   | lief    | 1      |
And I append rows
   | artikel | mge |
   | A100    | 100 |
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | zuomge |
    | F1     | 50     |
    | F2     | 50     |
And I save the current editor
And I switch the current editor to editor "1BE012"
And I save the current editor

# Rechnung
Given I open an editor "1RE012" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE012"
And I set fields
	| nummer | 1RE012 |
	| fakt   | nein   |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "70" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung
Given I open an editor "2RE012" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE012"
And I set fields
	| nummer | 2RE012 |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "30" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein
Given I open an editor "1LS012" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE012"
And I set fields
	| nummer | 1LS012 |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "100" in row 1
And I save the current editor

# Lieferscheinstorno
Given I open an editor "1LS012S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "1LS012"
And I set fields
	| nummer | 1LS012S |
And I save the current editor

# Lieferschein
Given I open an editor "2LS012" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE012"
And I set fields
	| nummer | 2LS012 |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "100" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Bestellung, Rechnung, Rechnung, Lieferschein, Rücklieferschein, Storno-Ruecklieferschein
# ----------------------------------------------------------------------------------------------
#
#  1BE013 ------ 1RE013
#  100 kg        60 kg
#    \
#     \ --------------- 2RE013
#      \                40 kg
#       \
#        \ -------------------- 1LS013 ------ 1RLS013 ------ 1RLS013S
#                               90 kg          -50 kg        50 kg
#

# Bestellung
Given I open an editor "1BE013" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE013 |
   | lief    | 1      |
And I append rows
   | artikel | mge |
   | A100    | 100 |
And I save the current editor

# Rechnung
Given I open an editor "1RE013" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE013"
And I set fields
	| nummer | 1RE013 |
	| fakt   | nein   |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "60" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung
Given I open an editor "2RE013" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE013"
And I set fields
	| nummer | 2RE013 |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "40" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein
Given I open an editor "1LS013" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE013"
And I set fields
	| nummer | 1LS013 |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "100" in row 1
And I save the current editor

# Ruecklieferung
Given I open an editor "1RLS013" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS013"
And I set fields
	| nummer | 1RLS013 |
	| ueb    | ja      |
	| vom    | .       |
And I set field "mge" to "-50" in row 1
And I save the current editor

# Ruecklieferscheinstorno
Given I open an editor "1RLS013S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "1RLS013"
And I set fields
    | nummer | 1RLS013S |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Rechnung, Lieferschein, Kostenumlage, ..
# ----------------------------------------------------------------------------------------------
#
#  1BE014 ------- 1RE014
#  100 kg         100 kg (BNG = 100 kg)
#    \              \
#     \              \
#      \              \
#       \              \ -----------  2RE014 (Transportkosten -> 1RE014)
#        \
#         \
#          \ ----------------- 1LS014  ------- 1RLS014 -------- 1SRL01
#                              80 kg           -50 kg           50 kg
#

# Bestellung
Given I open an editor "1BE014" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE014 |
   | lief    | 1      |
And I append rows
   | artikel | mge | he  | preis |
   | A100    | 100 | kg  | 10    |
And I save the current editor

# Rechnung
Given I open an editor "1RE014" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE014"
And I set fields
   | nummer | 1RE014  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "100" in row 1
And I set field "preis" to "10" in row 1
And I set field "he" to "kg" in row 1
Then field "ngeliefertremgeges" has value "0" in row 1
Then field "ngeliefertremge" has value "100" in row 1
Then field "remehrberechneticon" has value "icon:ball_yellow" in row 1
Then field "konto" has value "36301" in row 1
Then field "posnsammel" has value "ja"
Then field "posnsammel" is not modifiable
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein
Given I open an editor "1LS014" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE014"
And I set fields
   | nummer | 1LS014 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "80" in row 1
And I set field "he" to "kg" in row 1
And I save the current editor

# Rechnung (Transportkosten)
Given I open an editor "2RE014" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer | 2RE014  |
    | lief   | 1       |
    | ueb    | ja      |
    | vom    | .       |
And I append rows
    | artikel   | pwert |
    | FRACHT    | 10    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Kostenumlage 2RE014 -> 1RE014
Given I open an editor "1KU014" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "nummer" to "1KU014"
And I set field "pos" to "$,,@gruppe=4:2;artikel=FRACHT;kopf^nummer=2RE014;@ablageart=abgelegt"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,@gruppe=4:2;artikel=A100;kopf^nummer=1RE014;@ablageart=abgelegt" in row !lastRow
And I save the current editor

# Ruecklieferschein
Given I open an editor "1RLS014" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS014"
And I set fields
   | nummer | 1RLS014 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-50" in row 1
And I set field "he" to "kg" in row 1
And I save the current editor

# Ruecklieferscheinstorno
Given I open an editor "1RLS014S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "1RLS014"
And I set fields
    | nummer | 1RLS014S |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Rechnung, Kostenumlage, Lieferschein, ..
# ----------------------------------------------------------------------------------------------
#
#  1BE015 ------- 1RE015
#  20 kg          20 kg
#    \              \
#     \              \
#      \              \
#       \              \ 2RE015 (Transportkosten -> 1RE015)
#        \
#         \
#          \ ----------------- 1LS015  ------- 1LS015S
#                              20 kg           -20 kg
#

# Bestellung
Given I open an editor "1BE015" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE015 |
   | lief    | 1      |
And I append rows
   | artikel | mge | he  | preis |
   | A100    | 20  | kg  | 10    |
And I save the current editor

# Rechnung
Given I open an editor "1RE015" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE015"
And I set fields
   | nummer | 1RE015  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "20" in row 1
And I set field "preis" to "10" in row 1
And I set field "he" to "kg" in row 1
Then field "ngeliefertremgeges" has value "0" in row 1
Then field "ngeliefertremge" has value "20" in row 1
Then field "remehrberechneticon" has value "icon:ball_yellow" in row 1
Then field "konto" has value "36301" in row 1
Then field "posnsammel" has value "ja"
Then field "posnsammel" is not modifiable
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung (Transportkosten)
Given I open an editor "2RE015" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer | 2RE015  |
    | lief   | 1       |
    | ueb    | ja      |
    | vom    | .       |
And I append rows
    | artikel   | pwert |
    | FRACHT    | 10    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein
Given I open an editor "1LS015" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE015"
And I set fields
   | nummer | 1LS015 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "20" in row 1
And I set field "he" to "kg" in row 1
And I save the current editor

# Kostenumlage 2RE015 -> 1RE015
Given I open an editor "1KU015" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "nummer" to "1KU015"
And I set field "pos" to "$,,@gruppe=4:2;artikel=FRACHT;kopf^nummer=2RE015;@ablageart=abgelegt"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,@gruppe=4:2;artikel=A100;kopf^nummer=1RE015;@ablageart=abgelegt" in row !lastRow
And I save the current editor

# Lieferscheinstorno
Given I open an editor "1LS015S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "1LS015"
And I set fields
    | nummer | 1LS015S |
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: Rechnung, Lieferschein, Neubewertung
# ----------------------------------------------------------------------------------------------
#
#  1BE016 ------- 1RE016
#  50 St.         50 St. * 10 Euro
#    \-------------------------- MNB
#     \                          10,5 Euro
#      \
#       \ --------------- 1LS016  ------- 1RLS016
#                        50 St.          -10 St.
#

# Bestellung
Given I open an editor "1BE016" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE016 |
   | lief    | 1      |
And I append rows
   | artikel | mge | he     |
   | A200    | 50  | Stück  |
And I save the current editor

# Rechnung
Given I open an editor "1RE016" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE016"
And I set fields
   | nummer | 1RE016  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "50" in row 1
And I set field "he" to "Stück" in row 1
Then field "ngeliefertremgeges" has value "0" in row 1
Then field "ngeliefertremge" has value "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein
Given I open an editor "1LS016" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE016"
And I set fields
   | nummer | 1LS016 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "50" in row 1
And I save the current editor

# Mengenneubewertung anlegen
Given I open an editor "mgebewneu-820" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "nummer" to "016-MGN"
And I set field "such" to "MGN-016"
# And I create a new row at the end of the table
And I set field "vorgang" to "$,,artikel=A200;platz=F1;@datei=40;@gruppe=4;" in row 1
And I set field "ntbewpr" to "10,50" in row 1
And I save the current editor

# Ruecklieferschein
Given I open an editor "1RLS016" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS016"
And I set fields
   | nummer | 1RLS016 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-10" in row 1
And I set field "he" to "Stück" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Rechnung, Lieferschein, Neubewertung
# ----------------------------------------------------------------------------------------------
#
#  1BE017 ------- 1RE017
#  70 St.         70 St.
#    \------------------------------- MNB
#     \                               11 Euro
#      \
#       \ --------------- 1LS017  --------- 1LS017S -------
#                         50 St.            -50 St.
#

# Bestellung
Given I open an editor "1BE017" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE017 |
   | lief    | 1      |
And I append rows
   | artikel | mge | he     |
   | A200    | 70  | Stück  |
And I save the current editor

# Rechnung
Given I open an editor "1RE017" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE017"
And I set fields
   | nummer | 1RE017  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "70" in row 1
And I set field "preis" to "10" in row 1
And I set field "he" to "Stück" in row 1
Then field "ngeliefertremgeges" has value "0" in row 1
Then field "ngeliefertremge" has value "70" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein
Given I open an editor "1LS017" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE017"
And I set fields
   | nummer | 1LS017 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "50" in row 1
And I set field "platz" to "F2" in row 1
And I save the current editor

# Mengenneubewertung anlegen
Given I open an editor "mgebewneu-820" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "nummer" to "017-MGN"
And I set field "such" to "MGN-017"
# And I create a new row at the end of the table
And I set field "vorgang" to "$,,artikel=A200;platz=F2;@datei=40;@gruppe=4;" in row 1
And I set field "ntbewpr" to "11,50" in row 1
And I save the current editor

# Storno-Lieferschein
Given I open an editor "1LS017S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "1LS017"
And I set fields
   | nummer | 1LS017S |
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario Outline: Verschiedene Positionstypen und Umrechnungen
# ----------------------------------------------------------------------------------------------
#
#  1BExxx ------ 1RExxx
#  100 kg        20 kg
#    \
#      \
#       \ -------------------- 1LSxxx
#                              10 kg
#

# Bestellung
Given I open an editor "1BE<nummer>" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE<nummer> |
   | lief    | 1      |
And I append rows
   | artikel   | mge         | preis       |
   # In erster Zeile steht immer ein Artikel
   | A100      | 1           | 1           |
   | <artikel> | <mge>       | <preis>     |
And I save the current editor

# Rechnung
Given I open an editor "1RE<nummer>" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE<nummer>"
And I set fields
       | nummer   | 1RE<nummer> |
       | fakt     | nein        |
       | ueb      | ja          |
       | vom      | .           |
       | erfwaehr | <erfwaehr>  |
And I set field "mge" to "1" in row 1
And I set field "mge" to "<remge>" in row 2
And I set field "proz" to "<proz>" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "1LS<nummer>" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE<nummer>"
And I set fields
       | nummer | 1LS<nummer> |
       | ueb    | ja     |
       | vom    | .      |
And I set field "mge" to "1" in row 1
And I set field "mge" to "<limge>" in row 2
And I save the current editor

Examples:
| row | nummer | mge         | remge       | limge       | artikel    | preis       | pwert       | erfwaehr    | proz        | Info                   |
| 001 | 018    | 100         | 10          | 20          | A100       | !dontChange | !dontChange | EUR         | !dontChange | abw. Rechnungswaehrung |
| 002 | 019    | 100         | 10          | 20          | A100       | !dontChange | !dontChange | !dontChange | -10         | Inline Rabatt          |
| 003 | 020    | 100         | 10          | 20          | REPARIEREN | !dontChange | !dontChange | !dontChange | !dontChange | Dienstleistung         |
| 004 | 021    | !dontChange | !dontChange | !dontChange | FRACHT     | !dontChange | 100         | !dontChange | !dontChange | Neutrale Position      |
| 005 | 022    | !dontChange | !dontChange | !dontChange | TEXT       | !dontChange | 100         | !dontChange | !dontChange | Textposition           |
| 006 | 023    | !dontChange | !dontChange | !dontChange | PR.        | !dontChange | 10          | !dontChange | !dontChange | Gesamtrabatt           |
| 007 | 024    | 100         | 10          | 20          | AUBE       | !dontChange | !dontChange | !dontChange | !dontChange | AUBE                   |
| 008 | 025    | 100         | 10          | 20          | AMATZU     | !dontChange | !dontChange | !dontChange | !dontChange | mit Materialzuschlag   |

# ----------------------------------------------------------------------------------------------
Scenario: 2. Teilrechnungen, Lieferschein, Kostenumlage, ..
# ----------------------------------------------------------------------------------------------
#
#  1BE026 ------- 1RE026 ----\
#  50 kg          30 kg       \
#    \                         \
#     \ ---------------- 2RE026 \
#      \                  20 kg  \
#       \                  \      \
#        \                  \      \
#         \                  \ 3RE026 (Transportkosten -> 1RE026 + 2RE026)
#          \
#           \
#            \ ----------------- 1LS026  ------- 1RLS026
#                                50 kg           -35 kg
#                                 \
#                                  \ ---------------- 2RLS026
#                                                     -5 kg


# Bestellung
Given I open an editor "1BE026" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE026 |
   | lief    | 1      |
And I append rows
   | artikel | mge | he  | preis |
   | A100    | 50  | kg  | 20    |
And I save the current editor

# 1. Teilrechnung
Given I open an editor "1RE026" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE026"
And I set fields
   | nummer | 1RE026  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "30" in row 1
And I set field "preis" to "20" in row 1
And I set field "he" to "kg" in row 1
Then field "ngeliefertremgeges" has value "0" in row 1
Then field "ngeliefertremge" has value "30" in row 1
Then field "remehrberechneticon" has value "icon:ball_yellow" in row 1
Then field "konto" has value "36301" in row 1
Then field "posnsammel" has value "ja"
Then field "posnsammel" is not modifiable
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 2. Teilrechnung
Given I open an editor "2RE026" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE026"
And I set fields
   | nummer | 2RE026  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "20" in row 1
And I set field "preis" to "22" in row 1
And I set field "he" to "kg" in row 1
Then field "ngeliefertremgeges" has value "30" in row 1
Then field "ngeliefertremge" has value "20" in row 1
Then field "remehrberechneticon" has value "icon:ball_yellow" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung (Transportkosten)
Given I open an editor "3RE026" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer | 3RE026  |
    | lief   | 1       |
    | ueb    | ja      |
    | vom    | .       |
And I append rows
    | artikel   | pwert |
    | FRACHT    | 20    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein
Given I open an editor "1LS026" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE026"
And I set fields
   | nummer | 1LS026 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "50" in row 1
And I set field "he" to "kg" in row 1
And I save the current editor

# Kostenumlage 3RE026 -> 1RE026 + 2RE026
Given I open an editor "1KU026" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "nummer" to "1KU026"
And I set field "pos" to "$,,@gruppe=4:2;artikel=FRACHT;kopf^nummer=3RE026;@ablageart=abgelegt"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,@gruppe=4:2;artikel=A100;kopf^nummer=1RE026;@ablageart=abgelegt" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,@gruppe=4:2;artikel=A100;kopf^nummer=2RE026;@ablageart=abgelegt" in row !lastRow
And I save the current editor

# Rücklieferung 1
Given I open an editor "1RLS026" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS026"
And I set fields
   | nummer | 1RLS026 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-35" in row 1
And I set field "he" to "kg" in row 1
And I save the current editor

# Rücklieferung 2
Given I open an editor "2RLS026" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS026"
And I set fields
   | nummer | 2RLS026 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-5" in row 1
And I set field "he" to "kg" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: 2. Teilrechnungen, Lieferschein, 2 Kostenumlagen
# ----------------------------------------------------------------------------------------------
#
#  1BE027 ------- 1RE027 ----\
#  60 kg          40 kg       \
#    \                         \
#     \ ---------------- 2RE027 \
#      \                  20 kg  \
#       \                  \ \    \
#        \                  \ \    \
#         \                  \ \ 3RE027 (Transportkosten -> 1RE027 )
#          \                  \      \
#           \                  \      \
#            \                  \      \
#             \                  \ 4RE027 (Frachtkosten -> 1RE027 + 2RE027)
#              \
#               \
#                \ ----------------- 1LS027  ------- 1RLS027
#                                    60 kg           -30 kg
#                                     \
#                                      \ ---------------- 2RLS027
#                                                     -20 kg


# Bestellung
Given I open an editor "1BE027" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE027 |
   | lief    | 1      |
And I append rows
   | artikel | mge | he  | preis |
   | A100    | 60  | kg  | 10    |
And I save the current editor

# 1. Teilrechnung
Given I open an editor "1RE027" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE027"
And I set fields
   | nummer | 1RE027  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "40" in row 1
And I set field "preis" to "10" in row 1
And I set field "he" to "kg" in row 1
Then field "ngeliefertremgeges" has value "0" in row 1
Then field "ngeliefertremge" has value "40" in row 1
Then field "remehrberechneticon" has value "icon:ball_yellow" in row 1
Then field "konto" has value "36301" in row 1
Then field "posnsammel" has value "ja"
Then field "posnsammel" is not modifiable
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 2. Teilrechnung
Given I open an editor "2RE027" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE027"
And I set fields
   | nummer | 2RE027  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "20" in row 1
And I set field "preis" to "12" in row 1
And I set field "he" to "kg" in row 1
Then field "ngeliefertremgeges" has value "40" in row 1
Then field "ngeliefertremge" has value "20" in row 1
Then field "remehrberechneticon" has value "icon:ball_yellow" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung (Transportkosten)
Given I open an editor "3RE027" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer | 3RE027  |
    | lief   | 1       |
    | ueb    | ja      |
    | vom    | .       |
And I append rows
    | artikel   | pwert |
    | FRACHT    | 20    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung (Frachtkosten)
Given I open an editor "4RE027" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer | 4RE027  |
    | lief   | 1       |
    | ueb    | ja      |
    | vom    | .       |
And I append rows
    | artikel   | pwert |
    | FRACHT    | 50    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# Lieferschein
Given I open an editor "1LS027" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE027"
And I set fields
   | nummer | 1LS027 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "60" in row 1
And I set field "he" to "kg" in row 1
And I save the current editor

# 1. Kostenumlage 3RE027 -> 1RE027
Given I open an editor "1KU027" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "nummer" to "1KU027"
And I set field "pos" to "$,,@gruppe=4:2;artikel=FRACHT;kopf^nummer=3RE027;@ablageart=abgelegt"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,@gruppe=4:2;artikel=A100;kopf^nummer=1RE027;@ablageart=abgelegt" in row !lastRow
And I save the current editor

# 2. Kostenumlage 4RE027 -> 1RE027 + 2RE027
Given I open an editor "1KU027" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "nummer" to "1KU027"
And I set field "pos" to "$,,@gruppe=4:2;artikel=FRACHT;kopf^nummer=4RE027;@ablageart=abgelegt"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,@gruppe=4:2;artikel=A100;kopf^nummer=1RE027;@ablageart=abgelegt" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,@gruppe=4:2;artikel=A100;kopf^nummer=2RE027;@ablageart=abgelegt" in row !lastRow
And I save the current editor

# Rücklieferung 1
Given I open an editor "1RLS027" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS027"
And I set fields
   | nummer | 1RLS027 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-30" in row 1
And I set field "he" to "kg" in row 1
And I save the current editor

# Rücklieferung 2
Given I open an editor "2RLS027" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS027"
And I set fields
   | nummer | 2RLS027 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-20" in row 1
And I set field "he" to "kg" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Rechnung, Lieferschein, Kostenumlage, Wertgutschrift
# ----------------------------------------------------------------------------------------------
#
#  1BE028 ------- 1RE028 ---------------- 1WGS028
#  40 kg          40 kg * 6 EUR           -40 kg *0,3 EUR
#    \              \
#     \              \
#      \              \----------- 2RE028 (Transportkosten -> 1RE028)
#       \                          15 Euro
#        \
#         \ --------------- 1LS028  ----------- 1RLS028
#                           40 kg               -30 kg
#
#

# Bestellung
Given I open an editor "1BE028" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE028 |
   | lief    | 1      |
And I append rows
   | artikel | mge | he  | preis |
   | A100    | 40  | kg  | 6     |
And I save the current editor

# Rechnung
Given I open an editor "1RE028" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE028"
And I set fields
   | nummer | 1RE028  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "40" in row 1
And I set field "preis" to "6" in row 1
And I set field "he" to "kg" in row 1
Then field "ngeliefertremgeges" has value "0" in row 1
Then field "ngeliefertremge" has value "40" in row 1
Then field "remehrberechneticon" has value "icon:ball_yellow" in row 1
Then field "konto" has value "36301" in row 1
Then field "konto" is not modifiable in row 1
Then field "fixkonto" is not modifiable in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung (Transportkosten)
Given I open an editor "2RE028" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer | 2RE028  |
    | lief   | 1       |
    | ueb    | ja      |
    | vom    | .       |
And I append rows
    | artikel   | pwert |
    | FRACHT    | 15    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein
Given I open an editor "1LS028" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE028"
And I set fields
   | nummer | 1LS028 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "40" in row 1
And I set field "he" to "kg" in row 1
And I save the current editor

# 1. Kostenumlage 2RE028 -> 1RE027
Given I open an editor "1KU028" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "nummer" to "1KU028"
And I set field "pos" to "$,,@gruppe=4:2;artikel=FRACHT;kopf^nummer=2RE028;@ablageart=abgelegt"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,@gruppe=4:2;artikel=A100;kopf^nummer=1RE028;@ablageart=abgelegt" in row !lastRow
And I save the current editor

# Wertgutschrift zur Rechnung 1RE028
Given I open an editor "1WGS028" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE028"
And I set fields
   | nummer | 1WGS028 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-40" in row 1
And I set field "preis" to "0,3" in row 1
And I save the current editor

# Rücklieferschein
Given I open an editor "1RLS028" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS028"
And I set fields
   | nummer | 1RLS028 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-30" in row 1
And I set field "he" to "kg" in row 1
And I save the current editor
