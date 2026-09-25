# *****************************************************************************
#  Name           : kundenanlieferung_plausi.feature
#  Autor          : mibr
#  Verantwortlich : teampss
#  Funktion       : Plausi Cucumber Tests fuer Kundenanlieferungen.
#                   Kundenanlieferungen sind Lieferungen im Verkauf die vom Kunden kommen,
#                   z.B. wenn eine Maschine in Zahlung gegeben wird.
#                   Wenn beim Reparaturauftrag, das zu reparierende Teil angeliefert wird,
#                   Wenn Behaelter zurueckkommen.
#                   Pruefungen, wie
#                   - die Mengen sind negativ,
#                   - nur Konsilagerplatz erlaubt.
#
# *****************************************************************************
#
@persistent
Feature: Kundenanlieferung Plausi
Background:
Given I set the fake date to "02.01.1995"

@Testdaten
Scenario: Testdaten (Stammdaten) anlegen
# Konsilager, Konsilagergruppe anlegen
Given I open an editor "Lagergruppe" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "KONSILG"
And I set field "such" to "KONSILG"
And I set field "zkonsilg" to "Ja"
And I save the current editor

Given I open an editor "Lager" from table "(Warehouse):(Warehouse)" with command "STORE" for record "KONSILAGER"
And I set field "such" to "KONSILAGER"
And I set field "lgruppe" to "KONSILG"
And I save the current editor

Given I open an editor "Lagerplatz" from table "(Location):(Location)" with command "STORE" for record "KONSILP"
And I set field "such" to "KONSILP"
And I set field "lager" to "KONSILAGER"
And I save the current editor

# Lagergruppe mit Lagerplatz: Platz fuer Kundenanlieferung (Konsilager) eintragen
Given I open an editor "LagergruppeKA" from table "(Warehouse):(WarehouseGroup)" with command "UPDATE" for record "KARLSRUHE"
And I set field "vkkundenanlieferung" to "KONSILP"
And I save the current editor

Scenario Outline: STAMMDATEN - Zusatzposition anlegen
Given I open an editor "<zusatzpos>" from table "(Part):(SupplementaryItem)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "zptyp" to "<zptyp>"
And I set field "vkbez" to "<vkbez>"
And I set field "vbez" to "<vbez>"
And I set field "ebez" to "<ebez>"
And I set field "vpr" to "<vpr>"
And I set field "epr" to "<epr>"
And I save the current editor
Examples: Artikel
| zusatzpos       | such    | namebspr             | zptyp             | vkbez                   | vbez                 | ebez                  | vpr   | epr  |
| zusatzAUBE      | AUBE    | Zusatzposition AU/BE | AU/BE-Position,BV | Zusatzposition AU/BE    | Zusatzposition AU/BE | Zusatzposition AU/BE  | 1100  | 1000 |
| neutralePOS     | NEUPOS  | Neutrale Position    | Neutrale Position | Neutrale Position       | Neutrale Position    | Neutrale Position     | 500   | 400  |

Scenario: STAMMDATEN - Neue Dienstleistung anlegen
Given I open an editor "dienstl" from table "(Part):(Service)" with command "STORE" for record "dl-analyse"
And I set field "such" to "dl-analyse"
And I set field "namebspr" to "Analyse"
And I set field "vpr" to "50.00"
And I create a new row at the end of the table
And I set field "elex" to "A AG1" in row 1
And I save the current editor

@kundenanlieferung
Scenario: KuAnl Aendern lstyp, umplatz, umlgruppe
Given I open an editor "KundenanlieferungNeu" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "such" to "KANLPL"
And I set field "ueb" to "ja"
And I set field "umplatz" to "L2F1"
Then field "umplatz" has value "L2F1"
Then field "umlgruppe" has value "HONGKONG"
# umplatz, umlgruppe leeren, wenn Kundenanlieferung
And I set field "lsart" to "Kundenanlieferung"
Then field "umplatz" is empty
Then field "umplatz" is not modifiable
Then field "umlgruppe" is empty
Then field "umlgruppe" is not modifiable
And I set field "lsart" to "Lieferschein"
Then field "umplatz" is modifiable
Then field "umlgruppe" is modifiable
And I set field "lsart" to "Kundenanlieferung"
And I create a new row at the end of the table
And I set field "artikel" to "v1" in row !lastRow
And I set field "preis" to "5" in row !lastRow
# Positive Menge bei Kundenanlieferung nicht erlaubt.
And setting field "mge" to "10" in row !lastRow throws the exception "75"
And I set field "mge" to "-10" in row !lastRow
Then field "lsart" has value "Kundenanlieferung"
# lsart darf nicht mehr geaendert werden
Then setting field "lsart" to "Lieferschein" throws the exception "203"
# EVS-1324: Abgangslager-gruppe/platz schreibgeschuetzt
Then field "ablgruppe" is not modifiable in row !lastRow
Then field "abplatz" is not modifiable in row !lastRow
And I delete row at position !lastRow
And I set field "lsart" to "Lieferschein"
And I create a new row at the end of the table
And I set field "artikel" to "v2" in row !lastRow
And I set field "mge" to "2" in row !lastRow
Then field "ablgruppe" is modifiable in row !lastRow
Then field "abplatz" is modifiable in row !lastRow
And I save the current editor

Scenario: KuAnl mit Konsignationslagerplatz
Given I open an editor "Kundenanlieferung1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "such" to "KUANLIEF1"
And I set field "lsart" to "Kundenanlieferung"
And I create a new row at the end of the table
And I set field "artikel" to "v1" in row 1
And I set field "mge" to "-1" in row 1
Then field "platz" has value "KONSILP" in row 1
And setting field "platz" to "F2" in row 1 throws the exception "312"
And I create a new row at the end of the table
And I set field "artex" to id from editor "zusatzAUBE" in row 2
And I set field "platz" to "F2" in row 2
# Leer ist erlaubt bei AU/BE ZP
And I set field "platz" to "" in row 2
And I create a new row at the end of the table
And I set field "artex" to "dl-analyse" in row 3
And I set field "platz" to "F2" in row 3
And I set field "platz" to "" in row 3
And I set field "platz" to "KONSILP" in row 3
And I save the current editor

Scenario: KuAnl aus Auftrag prueft platz = konsilp beim Speichern
Given I open an editor "KAnlAuftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde | 1         |
   | such  | KANLAUFT1 |
   | vom   | .         |
And I append rows
   | artikel | mge  | preis | platz |
   | V1      | -20  | 6     | F1    |
   | V2      | 13   | 3     | F1    |
And I save the current editor

Given I open an editor "KAnlAusAuftrag" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | ueb   | ja                |
   | lsart | Kundenanlieferung |
Then field "kunde" has value ""
And I set field "beleg" to id from editor "KAnlAuftrag"
And I set field "such" to "KANLS2"
Then field "kunde" has value "1"
Then the table has 1 rows
And I press button "offueb" in row 1
Then field "mge" has value "-20" in row 1
# Beim Anfuegen wird u.U. der bei der int. Lagergruppe hinterlegte Konsilagerplatz gesetzt
Then field "platz" has value "KONSILP" in row 1
And I save the current editor

Scenario: KuAnl mit MZs
Given I open an editor "KAnlAuftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde | 1         |
   | such  | KANLAUFT1 |
   | vom   | .         |
And I append rows
   | artikel | mge  | preis | platz   |
   | V1      | -20  | 6     | F1      |
And I save the current editor

Given I open an editor "KANLMZ" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | ueb   | ja                |
   | lsart | Kundenanlieferung |
And I set field "beleg" to id from editor "KAnlAuftrag"
And I set field "such" to "KANLMZ"
# Beim Anfuegen wird u.U. der bei der int. Lagergruppe hinterlegte Konsilagerplatz gesetzt
Then field "platz" has value "KONSILP" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
# Bei Kundenanlieferung nur Konsi-Lagerplatz
And setting field "platz" to "F1" in row !lastRow throws the exception "312"
And I set field "platz" to "KONSILP" in row !lastRow
# Nur negative Mengen bei Kundenanlieferung
And setting field "zuomge" to "3" in row !lastRow throws the exception "75"
And I set field "zuomge" to "-3" in row !lastRow
And I create a new row at the end of the table
And I set field "platz" to "KONSILP" in row !lastRow
And I set field "zuomge" to "-2" in row !lastRow
And I save the current editor
And I switch the current editor to editor "KANLMZ"
And I close the current editor

@kundenanlieferung
Scenario: KuAnl -> Kaufm. GS bei rerelev teilw. = nein
Given I open an editor "KANLLSRR" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde | 1                 |
   | such  | KANLLSRR          |
   | lsart | Kundenanlieferung |
   | ueb   | ja                |
Then field "fakt" has value "ja"
Then field "fakt" is not modifiable
And I append rows
    | artikel | mge  | preis |platz   | rerelev |
    | V1      | -10  | 5     |KONSILP | nein    |
    | V2      | -20  | 6.55  |KONSILP | ja      |
And I save the current editor

Given I open an editor "KANLKGRR" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "KANLLSRR"
And I set field "such" to "KANLKGRR"
Then field "vorganga" has value "Kaufmännische Gutschrift"
# Nur die Rechnungsrelvante Position wird uebernommen
Then the table has 1 rows
And field "mge" has value "-20" in row 1
And I set fields
  | ueb    | ja |
  | tterm  | .  |
  | budat  | .  |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "KANLKGRR2" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "KANLLSRR"
And I set field "such" to "KANLKGRR2"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then the table has 1 rows
# Keine Restmenge mehr
And field "mge" has value "0" in row 1
And I close the current editor

@kundenanlieferung
Scenario: Vorbelegung RE mit Lagerbew. (fakt) bei Kundenlieferung
Given I open an editor "KANLAUFT4" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde | 1         |
   | such  | KANLAUFT4 |
   | vom   | .         |
And I append rows
   | artikel | mge  | preis | platz       |
   | V1      | -3   | 6     | KONSILP     |
   | V2      | 2    | 3     | !dontChange |
And I save the current editor

Given I open an editor "REKANL4" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "KANLAUFT4"
And I set field "such" to "REKANL4"
Then the table has 2 rows
Then field "vorganga" has value "Rechnung"
# Da eine Negativmenge enthalten ist, ist Lagerbewegung nicht moeglich
Then field "fakt" has value "nein"
And I set fields
  | ueb    | ja |
  | tterm  | .  |
  | budat  | .  |
And I set field "mge" in row 1 to "mge" from editor "KANLAUFT4" in row 1
And I set field "mge" in row 2 to "mge" from editor "KANLAUFT4" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# LS Kundenanlieferung wird separat abgerechnet
Given I open an editor "KANLAUFT5" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde | 1         |
   | such  | KANLAUFT5 |
   | vom   | .         |
And I append rows
   | artikel | mge  | preis | platz       |
   | V1      | -4   | 6.60  | KONSILP     |
   | V2      | 5    | 3.10  | !dontChange |
And I save the current editor

Given I open an editor "KANLLS5" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lsart | Kundenanlieferung |
And I set field "beleg" to id from editor "KANLAUFT5"
And I set field "such" to "KANLLS5"
And I set field "ueb" to "ja"
And the table has 1 rows
# Mengen uebertragen
And I set field "mge" in row 1 to "mge" from editor "KANLAUFT5" in row 1
And I save the current editor

And I invoice the PackingSlip "KANLLS5" with Invoice "REKANL5A"

Given I open an editor "REKANL5B" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "KANLAUFT5"
And I set field "such" to "REKANL5B"
Then the table has 1 rows
Then field "vorganga" has value "Rechnung"
# Rechnung mit Lagerbew. ist moeglich, da keine Negativposition
Then field "fakt" has value "ja"
And I set fields
  | ueb    | ja |
  | tterm  | .  |
  | budat  | .  |
And I set field "mge" in row 1 to "mge" from editor "KANLAUFT5" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: Kaufm. Gutschrift darf keine positiven Positionen enthalten
Given I open an editor "KANLLS6" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "such" to "KANLLS6"
And I set field "lsart" to "Kundenanlieferung"
And I set field "ueb" to "ja"
And I append rows
    | artikel | mge  | preis |platz |
    | V1      | -2   | 5     |KONSILP|
Then field "lsart" has value "Kundenanlieferung"
And I save the current editor

Given I open an editor "KGUT" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "KANLLS6"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then field "fakt" has value "nein"
And the table has 1 rows
And I set fields
   | such      | KGUT |
   | ueb       | ja   |
   | tterm     | .    |
   | budat     | .    |
And I create a new row at the end of the table
And I set field "artikel" to "V2" in row !lastRow
# Werden Positive Werte eingegben, so wird auf Rechnung gewechselt
And I set field "mge" to "111" in row 2
Then field "vorganga" has value "Rechnung"
And I set field "mge" to "-111" in row 2
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I create a SalesOrder "KANLAUFT7" for Customer "1" with Product "v1" and quantity "-1"

Given I open an editor "KANLLS7" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "lsart" to "Kundenanlieferung"
And I set field "beleg" to id from editor "KANLAUFT7"
And I set field "such" to "KANLLS7"
And I set field "ueb" to "ja"
Then the table has 1 rows
And I press button "offueb" in row 1
Then field "mge" has value "-1" in row 1
And I save the current editor

Given I open an editor "KANLRE7" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "KANLLS7"
Then field "fakt" has value "nein"
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I set fields
  | such   | KANLRE7 |
  | ueb    | ja      |
  | tterm  | .       |
  | budat  | .       |
And I create a new row at the end of the table
And I set field "artikel" to "V2" in row !lastRow

# Werden Positive Werte eingegben, so wird auf Rechnung gewechselt
And I set field "mge" to "111" in row 2
Then field "vorganga" has value "Rechnung"
And I set field "mge" to "-111" in row 2
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

@kundenanlieferung
Scenario: Kaufm. Gutschrift erlaubte Aktionen
# Setzen auf Rechnungsart Kaufm. Gutschrift, nur wenn entsprechende Positionen angefuegt wurden
Given I open an editor "KANLLS8" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde | 1                 |
   | such  | KANLLS8           |
   | lsart | Kundenanlieferung |
   | ueb   | ja                |
And I append rows
    | artikel | mge  | preis |platz   |
    | V1      | -7   | 5     |KONSILP |
And I save the current editor

Given I open an editor "REKANL" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "KANLLS8"
And I set field "such" to "REKANL"
Then the table has 1 rows
# Kaufm. Gutschrift ist nach Beleg anfuegen vorbelegt
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I set fields
  | ueb    | ja |
  | tterm  | .  |
  | budat  | .  |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "KANLLS9" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "KANLLS8"
And I set field "such" to "KANLLS9"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "REKANL" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "1"
Then field "vorganga" has value "Rechnung"
And I set field "beleg" to id from editor "KANLLS9"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then the table has 1 rows
And I delete all rows
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I close the current editor

Given I open an editor "KANLLS10" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "KANLLS8"
And I set field "such" to "KANLLS10"
And I set field "ueb" to "ja"
And I set field "rerelev" to "nein" in row 1
And I save the current editor

Given I open an editor "REKANL" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "KANLLS10"
Then the table has 0 rows
Then field "vorganga" has value "Rechnung"
And I close the current editor


@kundenanlieferung
Scenario: Mischen verbieten: KuAnl und Ruecklieferung
# Neg. Auftrag anlegen
Given I create a SalesOrder "AuftNeg11" for Customer "1" with Product "V1" and quantity "-3"
Given I create a SalesOrder "AuftPos11" for Customer "1" with Product "V1" and quantity "2"

#Auftrag + RL anlegen
Given I create a SalesOrder "AuftRL11" for Customer "1" with Product "V2" and quantity "7"
Given I deliver the SalesOrder "AuftRL11" with PackingSlip "LS11"
Given I return the PackingSlip "LS11" with ReturnPackingSlip "RLS11"

# KuAnl anlegen und Belege anfuegen
Given I open an editor "KUANL11" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
  | kunde | 1                 |
  | such  | KUANL11           |
  | lsart | Kundenanlieferung |
  | ueb   | ja                |
And I append rows
    | artikel | mge  | preis |platz  |
    | V1      | -22  | 5     |KONSILP|
# Normale negative Menge darf angehaengt werden
And I set field "beleg" to id from editor "AuftNeg11"
And I set field "mge" to "-3" in row 3
# Keine Pos wird angefuegt, da positive Menge
And I set field "beleg" to id from editor "AuftPos11"

# Dieser Beleg (RLS) darf nicht angefuegt werden
Then setting field "beleg" in row 0 to "id" from editor "RLS11" in row 0 throws the exception "4615"
# Position darf auch nicht angefuegt werden (Erste Position ueber pos Verweis anfuegen)
Then setting field "beleg" in row 0 to "pos^id" from editor "RLS11" in row 0 throws the exception "4615"
And I set field "kenn" in row 0 to "pos^mge" from editor "RLS11" in row 0
Then field "kenn" has value "-7"
# Positionen ueberpruefen
Then the table has 3 rows
Then table has values
    | artikel^such | mge  | platz  |
    | V1           | -22  | KONSILP|
    | TR.          | 0    |        |
    | V1           | -3   | KONSILP|
And I save the current editor

# Umgekehrter Fall KuAnl an RL anfuegen
# Auftrag + RL anlegen
Given I create a SalesOrder "AuftRL12" for Customer "1" with Product "V2" and quantity "8"
Given I deliver the SalesOrder "AuftRL12" with PackingSlip "LS12"
Given I open an editor "RLS12" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS12"
Then field "lsart" has value "Rücklieferschein"
And I set field "such" to "RLS12"
# Dieser Beleg (KuAnl) darf nicht angefuegt werden
And I set field "beleg" to id from editor "KUANL11"
Then field "ofmge" has value "-8" in row 1
And I set field "mge" to "-8" in row 1
And the table has 1 rows
And I save the current editor


# Kunde 1: Konsi-Platz zuordnen
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "1"
And I set field "konsi" to "L2F1"
And I save the current editor
# Artikel anlegen
Given I open an editor "VK_Artikel" from table "(Part):(Product)" with command "STORE" for record "VK_Art"
And I set fields
    | such      | VK_ART           |
    | namebspr  | VK-Teil          |
    | vpr       | 15               |
    | epr       | 11               |
    | bsart     | Fremdbeschaffung |
    | dispoa    | auftragsbezogen  |
And I save the current editor

Scenario: Auftrag mit einem Kunde mit Konsi-Platz -> Lieferschein daraus erzeugen.
Given I open an editor "AU1_KU_Konsi" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde | 1         |
   | num3  | 1AUKONSI  |
   | such  | AU1KUKONS |
   | vom   | .         |
And I append rows
   | artikel | mge  | preis |
   | V3      | 33   | 6     |
And I save the current editor

Given I open an editor "LS_aus_AU1" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU1_KU_Konsi"
And I set fields
   | ueb   | ja |
And I set field "mge" to "30" in row 1
Then field "verw" has value "1AUKONSI_1" in row 1
Then field "verw2" has value "1AUKONSI_1" in row 1
And I save the current editor

# Lagerjournalabfrage zu verw, verwla
# Abgang
Given I open the infosystem "LJ"
And I set fields
   | artikel  | V3           |
   | richtung | vorwärts     |
   | kursache | Lieferschein |
   | abgang   | ja           |
   | umlag    | ja           |
And I press start
Then table has values
    | !row | amge | verw       | verwla     |
    | 1    | 30   | 1AUKONSI_1 | 1AUKONSI_1 |
And I close the current editor
# Zugang
Given I open the infosystem "LJ"
And I set fields
   | artikel  | V3           |
   | richtung | vorwärts     |
   | kursache | Lieferschein |
   | zugang   | ja           |
   | umlag    | ja           |
And I press start
Then table has values
    | !row | zmge | verw       | verwla     |
    | 1    | 30   | 1AUKONSI_1 | 1AUKONSI_1 |
And I close the current editor

Scenario: Lieferschein mit Konsi-Platz beim Kunden
Given I open an editor "LS_KU_KONSI" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "such" to "LSKUKONS"
And I set field "ueb" to "ja"
Then field "umplatz" has value "L2F1"
Then field "umlgruppe" has value "HONGKONG"
And I create a new row at the end of the table
And I set field "artikel" to "V3" in row !lastRow
And I set field "mge" to "3" in row !lastRow
And I set field "verw" to "LAGER_1" in row !lastRow
Then field "verw2" has value "LAGER_1" in row !lastRow
And I save the current editor

# Lagerjournalabfrage zu verw, verwla
# Abgang
Given I open the infosystem "LJ"
And I set fields
   | artikel  | V3           |
   | richtung | vorwärts     |
   | kursache | Lieferschein |
   | abgang   | ja           |
   | umlag    | ja           |
And I press start
Then table has values
    | !row | amge | verw    | verwla     |
    | 2    | 3    | LAGER_1 | LAGER_1 |
And I close the current editor
# Zugang
Given I open the infosystem "LJ"
And I set fields
   | artikel  | V3           |
   | richtung | vorwärts     |
   | kursache | Lieferschein |
   | zugang   | ja           |
   | umlag    | ja           |
And I press start
Then table has values
    | !row | zmge | verw    | verwla     |
    | 2    | 3    | LAGER_1 | LAGER_1 |
And I close the current editor

