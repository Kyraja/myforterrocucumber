# *****************************************************************************
#  Name           : sammelrechnung_ek.feature
#  Autor          : mibr
#  Verantwortlich : teampss
#  Funktion       : Tests zur Zusammensetzung von Sammelrechnungen im Einkauf
#                   Sammelrechnungen koennen ueber Beleg anfuegen aus Lieferscheinen,
#                   Auftraegen, Rucklieferscheinen und Kundenanlieferungen bestehen.
#                   Hierbei muss die Rechnungsart korrekt gesetzt sein.
#
# *****************************************************************************
#
@persistent
Feature: Sammelrechnung
Background:
Given I set the fake date to "02.01.1995"

@Testdaten
Scenario: Testdaten (Stammdaten) anlegen - Konsignationslagerplatz, Dienstleistung
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

# Dienstleistung REPARIEREN anlegen
Given I open an editor "dienstl" from table "(Part):(Service)" with command "STORE" for record "REPARIEREN"
And I set field "such" to "REPARIEREN"
And I set field "namebspr" to "Reparieren"
And I set field "vpr" to "40.00"
And I save the current editor

# Neutrale Zusatzposition anlegen
Given I open an editor "zusatzposition" from table "(Part):(SupplementaryItem)" with command "STORE" for record "NEUTRAL"
And I set field "such" to "NEUTRAL"
And I set field "namebspr" to "Neutrale Position"
And I set field "zptyp" to "neutrale Position"
And I save the current editor


@Rechnung
@Sammelrechnung
@FALL-1550
Scenario: FALL-1570	EK	Bestellung pos+neg	Lieferschein Ruecklieferschein Rechnung RLS + LS
# Bestellung anlegen
Given I open an editor "BE-1570" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
 | lief  | 1         |
 | such  | BE-1570   |
 | kenn  | FALL-1570 |
And I append rows
| artex | mge   | preis |
| E1    |  1570 | 1570  |
| E1    | -1570 | 1570  |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "LS-1570" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "BE-1570"
And I set fields
 | such   | LS-1570   |
 | ueb    | ja        |
 | kenn   | FALL-1570 |
 | ebeleg | FALL-1570 |
 | vom    | .         |
And I set field "mge" to "1570" in row 1
# Negative Werte sind nicht erlaubt
And setting field "mge" to "-1570" in row 2 throws the exception "2158"
And I save the current editor

# Rechnung anlegen
Given I open an editor "RE-1570" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS-1570"
And I set fields
 | such   | RE-1570             |
 | ueb    | ja                  |
 | vom    | .                   |
 | tterm  | .                   |
 | kenn   | FALL-1570 Rechnung  |
 | ebeleg | FALL-1570RE         |
And I set field "mge" to "1570" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein anlegen
Given I open an editor "RLS-1570" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS-1570"
And I set fields
 | such   | RLS-1570                    |
 | ueb    | ja                          |
 | vom    | .                           |
 | kenn   | FALL-1570 Ruecklieferschein |
 | ebeleg | FALL-1570RLS                |
And I set field "mge" to "-31" in row 1
And I save the current editor

# Weiterer LS
Given I open an editor "LS-1570B" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
 | lief   | 1                 |
 | such   | LS-1570B          |
 | ebeleg | LS-1570B          |
 | ueb    | ja                |
 | vom    | .                 |
And I append rows
| artex | mge   | preis |
| E1    |  100  | 1570  |
And I save the current editor

# Rechnung anlegen aus Ruecklieferschein und sonstigem LS
Given I open an editor "RE-1570" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
Then field "fakt" has value "ja"
Then field "fakt" is modifiable
And I set field "beleg" to id from editor "RLS-1570"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then field "fakt" has value "nein"
Then field "fakt" is not modifiable
Then setting field "fakt" to "ja" throws the exception "203"
And I set field "beleg" to id from editor "LS-1570B"
Then field "vorganga" has value "Rechnung"
And I set fields
 | such   | RE-1570   |
 | kenn   | Fall-1570 |
 | ebeleg | Fall-1570 |
 | ueb    | ja        |
 | vom    | .         |
 | budat  | .         |
 | tterm  | .         |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

@Rechnung
@Sammelrechnung
@FALL-1550
Scenario Outline: Vorgangsart anpassen beim Editieren auf Rechnung bzw. kaufm. GS

# Betriebsdaten: 3 moegliche Einstellungen fuer das Kriterium fuer kaufm. GS durchspielen
Given I open an editor "Betriebsdaten" from table "(Company):(CompanyData)" with command "STORE" for record "1"
And I set fields
    | kgskriterium      | <kgskriterium>              |
And I save the current editor

# Pruefen der Vorgangsart beim Loeschen/Aendern von Tabellenzeilen
Given I open an editor "RE-1570-KOPIE" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "RE-1570"
Then field "vorganga" has value "<soll_vorganga1>"
Then field "fakt" has value "nein"
Then field "fakt" is not modifiable
Then setting field "fakt" to "ja" throws the exception "203"
And I delete row at position 3
Then field "vorganga" has value "<soll_vorganga2>"
Then field "fakt" has value "nein"
Then field "fakt" is not modifiable
Then setting field "fakt" to "ja" throws the exception "203"
And I create a new row at the end of the table
And I set field "artikel" to "TR." in row !lastRow
Then field "vorganga" has value "<soll_vorganga3>"
Then field "fakt" has value "nein"
Then field "fakt" is not modifiable
Then setting field "fakt" to "ja" throws the exception "203"
And I create a new row at the end of the table
And setting field "artex" to "E1" in row !lastRow throws the exception "1678"
Then field "vorganga" has value "<soll_vorganga4>"
Then field "fakt" has value "nein"
Then field "fakt" is not modifiable
Then setting field "fakt" to "ja" throws the exception "203"
And I close the current editor

Examples:
| kgskriterium                            | soll_vorganga1 | soll_vorganga2            | soll_vorganga3            | soll_vorganga4           |
| Nettosumme kleiner null                 | Rechnung       | Kaufmännische Gutschrift  | Kaufmännische Gutschrift  | Kaufmännische Gutschrift |
| Keine kaufmännische Gutschrift          | Rechnung       | Rechnung                  | Rechnung                  | Rechnung                 |
| Werte aller Rechnungspositionen negativ | Rechnung       | Kaufmännische Gutschrift  | Kaufmännische Gutschrift  | Kaufmännische Gutschrift |

Scenario: Besonderheiten kgskriterium = NIE
# Das Programm soll sich wie kaufm. GS verhalten, es soll aber nie Rechnungsart = Kaufm. GS gesetzt werden

# Betriebsdaten: Kaufm. GS nicht verwenden
Given I open an editor "Betriebsdaten" from table "(Company):(CompanyData)" with command "STORE" for record "1"
And I set field "kgskriterium" to "Keine kaufmännische Gutschrift"
And I save the current editor

# Bestellung anlegen
Given I open an editor "BE-438" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
 | lief  | 1        |
 | such  | BE-438   |
And I append rows
| artex | mge  | preis |
| E1    | 300  | 438   |
| E2    | 400  | 400   |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "LS-438" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "BE-438"
And I set fields
 | such  | LS-438   |
 | ueb   | ja       |
 | ebeleg| LS438    |
 | vom   | .        |
And I set field "mge" to "300" in row 1
And I delete row at position 2
And I save the current editor

# Lieferschein anlegen
Given I open an editor "LS-438B" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "BE-438"
And I set fields
 | such  | LS-438B  |
 | ueb   | ja       |
 | ebeleg| LS438B   |
 | vom   | .        |
And I set field "mge" to "400" in row 1
And I save the current editor

# Rechnung anlegen
Given I open an editor "RE-438B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS-438B"
And I set fields
 | such   | RE-438B  |
 | ebeleg | RE-438B  |
 | ueb    | ja       |
 | vom    | .        |
 | tterm  | .        |
And I set field "mge" to "400" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein anlegen
Given I open an editor "RLS-438B" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS-438B"
And I set fields
 | such   | RLS-438B   |
 | ueb    | ja         |
 | vom    | .          |
 | ebeleg | RLS-438B   |
And I set field "mge" to "-400" in row 1
And I save the current editor

# Rechnung erstellen
Given I open an editor "RE-438" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to "id" from editor "LS-438"
And field "vorganga" has value "Rechnung"
And I set field "beleg" to "id" from editor "RLS-438B"
And field "sumnetto" has value "-28600.00"
# Obwohl Summe negativ, bleibt der Rechnungsart=Rechnung wegen kgskriterium = NIE
And field "vorganga" has value "Rechnung"
And I set fields
 | such  | RE-438   |
 | ebeleg| RE-438   |
 | ueb   | ja       |
 | vom   | .        |
 | budat | .        |
 | tterm | .        |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Weiterer Fall:
# Pruefung, ob Rechnungsart richtig als "Rechnung" angezeigt wird, in der folgenden Vorgehensweise:
# Rechnung anlegen -> Ruecklieferschein -> Rechnung
Given I open an editor "rechnung-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I append rows
| artex | mge   | preis |
| E1    |  22   |    22 |
And I set field "kenn" to "RE-2"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein anlegen aus Rechnung
Given I open an editor "RLS-2" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "rechnung-2"
And I set fields
 | such  | RLS-2   |
 | ueb   | ja      |
 | vom   | .       |
 |ebeleg | RLS-2   |
And I set field "mge" to "-12" in row 1
And I save the current editor

# Rechnung anlegen aus Ruecklieferschein
Given I open an editor "RE-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS-2"
Then field "vorganga" has value "Rechnung"
# Unzulaessig
Then setting field "vorganga" to "Kaufm��nnische Gutschrift" throws the exception "131"
And I close the current editor

# Weiterer Fall:
# Rechnung mit Warenbewegung
Given I open an editor "RE-439" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
 | lief  | 1        |
 | such  | RE-439   |
 | ebeleg| RE-439   |
 | ueb   | Ja       |
 | vom   | .        |
 | budat | .        |
 | tterm | .        |
And I append rows
| artex | mge  | preis |
| E1    | 10   | 438   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung (5 Artikel gutschreiben) -> Wertgutschrift
Given I open an editor "RE-439B" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to "id" from editor "RE-439"
Then field "vorganga" has value "Rechnung"
Then field "fakt" has value "nein"
And I set fields
 | such  | RE-439B  |
 | ebeleg| RE-439B  |
 | ueb   | ja       |
 | vom   | .        |
 | budat | .        |
 | tterm | .        |
# Obwohl Summe negativ, bleibt der Rechnungsart=Rechnung wegen kgskriterium = NIE
And field "vorganga" has value "Rechnung"
And I set field "mge" to "-5" in row 1
And I save the current editor

# Betriebsdaten: Zuruecksetzen
Given I open an editor "Betriebsdaten" from table "(Company):(CompanyData)" with command "STORE" for record "1"
And I set field "kgskriterium" to "Werte aller Rechnungspositionen negativ"
And I save the current editor

@FALL-338
Scenario: FALL-338	EK Bestellung neg Pos + Ruecklieferschein Rechnung neg. Pos+RLS
# Bestellung anlegen
Given I open an editor "BE-338" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
 | lief  | 1        |
 | such  | BE-338   |
 | kenn  | FALL-338 |
And I append rows
| artex | mge  | preis |
| E1    | 338  | 338   |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "LS-338" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "BE-338"
And I set fields
 | such  | LS-338   |
 | fakt  | nein     |
 | ueb   | ja       |
 | kenn  | FALL-338 |
 | ebeleg| FALL-338 |
 | vom   | .        |
And I set field "mge" to "338" in row 1
And I save the current editor

# Rechnung anlegen
Given I open an editor "RE-338" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE-338"
And I set fields
 | such   | RE-338   |
 | ebeleg | RE-338   |
 | ueb    | ja       |
 | vom    | .        |
 | tterm  | .        |
And I set field "mge" to "338" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein anlegen
Given I open an editor "RLS-338" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS-338"
And I set fields
 | such   | RLS-338                    |
 | ueb    | ja                         |
 | vom    | .                          |
 | kenn   | FALL-338 Ruecklieferschein |
 | ebeleg | FALL-338                   |
And I set field "mge" to "-33" in row 1
And I save the current editor

# Rechnung anlegen aus neg. Pos + Ruecklieferschein -> kaufm. GS
Given I open an editor "RE-338" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
Then field "vorganga" has value "Rechnung"
Then field "lsart" has value ""
And I set field "beleg" to id from editor "RLS-338"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then field "fakt" has value "nein"
Then field "fakt" is not modifiable
Then setting field "fakt" to "ja" throws the exception "203"
And I create a new row at the end of the table
And setting field "artex" to "E1" in row !lastRow throws the exception "1678"
And I set field "artex" to "NEUTRAL" in row !lastRow
And I set field "pwert" to "-338" in row !lastRow
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I set fields
 | such  | RE-338   |
 | kenn  | Fall-338 |
 | ebeleg| Fall-338 |
 | ueb   | ja       |
 | vom   | .        |
 | budat | .        |
 | tterm | .        |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

@FALL-339
Scenario: FALL-339	EK Bestellung neg Pos + Ruecklieferschein Rechnung neg. Pos+RLS
# Bestellung anlegen
Given I open an editor "BE-339" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
 | lief  | 1        |
 | such  | BE-339   |
 | kenn  | FALL-339 |
And I append rows
| artex | mge  | preis |
| E1    | 339  | 339   |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "LS-339" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "BE-339"
And I set fields
 | such  | LS-339   |
 | fakt  | nein     |
 | ueb   | ja       |
 | kenn  | FALL-339 |
 | ebeleg| FALL-339 |
 | vom   | .        |
And I set field "mge" to "339" in row 1
And I save the current editor

# Rechnung anlegen
Given I open an editor "RE-339" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE-339"
And I set fields
 | such   | RE-339   |
 | ebeleg | RE-339   |
 | ueb    | ja       |
 | vom    | .        |
 | tterm  | .        |
And I set field "mge" to "339" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein anlegen
Given I open an editor "RLS-339" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS-339"
And I set fields
 | such   | RLS-339                    |
 | ueb    | ja                         |
 | vom    | .                          |
 | kenn   | FALL-339 Ruecklieferschein |
 | ebeleg | FALL-339                   |
And I set field "mge" to "-33" in row 1
And I save the current editor

# Rechnung anlegen aus neg. Pos + Ruecklieferschein -> kaufm. GS
Given I open an editor "RE-339" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
Then field "vorganga" has value "Rechnung"
Then field "lsart" has value ""
And I set field "beleg" to id from editor "RLS-339"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then field "fakt" has value "nein"
Then field "fakt" is not modifiable
Then setting field "fakt" to "ja" throws the exception "203"
And I create a new row at the end of the table
And setting field "artex" to "E1" in row !lastRow throws the exception "1678"
And I set field "artex" to "NEUTRAL" in row !lastRow
And I set field "pwert" to "-339" in row !lastRow
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I set fields
 | such  | RE-339   |
 | kenn  | Fall-339 |
 | ebeleg| Fall-339 |
 | ueb   | ja       |
 | vom   | .        |
 | budat | .        |
 | tterm | .        |
# Pruefen der Vorgangsart beim Loeschen von Tabellenzeilen
And I delete row at position 1
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I create a new row at the end of the table
And I set field "artikel" to "TR." in row !lastRow
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I create a new row at the end of the table
And I set field "artikel" to "NEUTRAL" in row !lastRow
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I set field "pwert" to "-100" in row !lastRow
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then field "fakt" has value "nein"
Then field "fakt" is not modifiable
Then setting field "fakt" to "ja" throws the exception "203"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


Scenario: EK Rechnung keine negativen pwert erlauben
# Plausi
# Lieferschein anlegen
Given I open an editor "LS-538" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
 | lief  | 1        |
 | such  | LS-538   |
 | ueb   | ja       |
 | ebeleg| LS538    |
 | vom   | .        |
And I append rows
 | artikel | mge |
 | E1      | 4   |
And I save the current editor

# Rechnung erstellen
Given I open an editor "RE-538" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "fakt" to "nein"
And I set field "beleg" to "id" from editor "LS-538"
# Negativer Preis
And I set field "preis" to "-10" in row 1
# pwert darf nicht positiv gesetzt werden bei Artikelposition
And setting field "pwert" to "10" in row 1 throws the exception "131"
And I set field "pwert" to "-20" in row 1
# Abschlag wird angepasst
Then field "proz" has value "-50" in row 1
# Nullpreis
And I set field "preis" to "0" in row 1
# pwert darf nicht negativ gesetzt werden bei Artikelposition
And setting field "pwert" to "-1" in row 1 throws the exception "131"
And I create a new row at the end of the table
And setting field "artex" to "E1" in row 2 throws the exception "1678"
And I set field "artikel" to "NEUTRAL" in row 2
# Neutrale Positionen duerfen negativen pwert haben
And I set field "pwert" to "-10" in row 2
And field "vorganga" has value "Kaufmännische Gutschrift"
And I set fields
 | such  | RE-538   |
 | ebeleg| RE-538   |
 | ueb   | ja       |
 | vom   | .        |
 | budat | .        |
 | tterm | .        |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario: FALL-2000: Gutschrift zu Ruecklieferschein mit Zusatzpositionen, KGS-Kriterium: Nettosumme ist kleiner als null

# Betriebsdaten
Given I open an editor "Betriebsdaten" from table "(Company):(CompanyData)" with command "STORE" for record "1"
And I set fields
    | kgskriterium | Nettosumme kleiner null |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "LS-2000" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
 | lief  | 1         |
 | such  | LS-2000   |
 | ueb   | ja        |
 | kenn  | FALL-2000 |
 | ebeleg| FALL-2000 |
 | vom   | .         |
And I create a new row at the end of the table
And I set field "artikel" to "E2" in row 1
And I set field "mge" to "2000" in row 1
And I save the current editor

# Rechnung anlegen
Given I open an editor "RE-2000" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS-2000"
And I set fields
 | such   | RE-2000  |
 | ebeleg | RE-2000  |
 | ueb    | ja       |
 | vom    | .        |
 | tterm  | .        |
And I set field "mge" to "2000" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein anlegen
Given I open an editor "RLS-2000" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS-2000"
And I set fields
 | such   | RLS-2000                    |
 | ueb    | ja                          |
 | vom    | .                           |
 | kenn   | FALL-2000 Ruecklieferschein |
 | ebeleg | FALL-2000                   |
And I set field "mge" to "-1000" in row 1
And I save the current editor

# Rechnung anlegen aus Ruecklieferschein + Zusatzposition mit pos. Menge + buchen
Given I open an editor "RE-2000" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS-2000"
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I set fields
 | such  | KGS-2000             |
 | kenn  | FALL-2000 Gutschrift |
 | ebeleg| FALL-2000            |
 | ueb   | ja                   |
 | vom   | .                    |
 | budat | .                    |
 | tterm | .                    |
And I create a new row at the end of the table
And I set field "artikel" to "NEUTRAL" in row !lastRow
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I set field "pwert" to "100" in row !lastRow
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then field "fakt" has value "nein"
Then field "fakt" is not modifiable
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario: FALL-2005: Anfuegen einer Rechnung an eine Rechnung mit Lagerbewegung ist nicht moeglich

# Lieferschein anlegen
Given I open an editor "LS-2005" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
 | lief  | 1         |
 | such  | LS-2005   |
 | ueb   | ja        |
 | kenn  | FALL-2005 |
 | ebeleg| FALL-2005 |
 | vom   | .         |
And I create a new row at the end of the table
And I set field "artikel" to "E2" in row 1
And I set field "mge" to "2005" in row 1
And I save the current editor

# Rechnung anlegen
Given I open an editor "RE-2005" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS-2005"
And I set fields
 | such   | RE-2005  |
 | ebeleg | RE-2005  |
 | ueb    | ja       |
 | vom    | .        |
 | tterm  | .        |
And I set field "mge" to "2005" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung mit Lagerbewegung anlegen
Given I open an editor "RE-2006" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
 | lief  | 1         |
 | such  | RE-2006   |
 | fakt  | ja        |
 | kenn  | FALL-2005 |
 | ebeleg| FALL-2005 |
 | vom   | .         |
And I create a new row at the end of the table
And I set field "artikel" to "E2" in row 1
And I set field "mge" to "2006" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung an Rechnung mit Lagerbewegung anfuegen ist nicht moeglich
Given I open an editor "RE-2006" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE-2006"
Then setting field "beleg" to "+RE-2005" throws the exception "4615"
Then the table has 4 rows
And I close the current editor

Scenario: FALL-2010: Mehrfaches anfuegen einer Ruecklieferung an eine Rechnung/Gutschrift

# Lieferschein anlegen
Given I open an editor "LS-2010" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
 | lief  | 1         |
 | such  | LS-2010   |
 | ueb   | ja        |
 | kenn  | FALL-2010 |
 | ebeleg| FALL-2010 |
 | vom   | .         |
And I create a new row at the end of the table
And I set field "artikel" to "E2" in row 1
And I set field "mge" to "2010" in row 1
And I save the current editor

# Rechnung anlegen
Given I open an editor "RE-2010" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS-2010"
And I set fields
 | such   | RE-2010  |
 | ebeleg | RE-2010  |
 | ueb    | ja       |
 | vom    | .        |
 | tterm  | .        |
And I set field "mge" to "2010" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein anlegen
Given I open an editor "RLS-2010" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS-2010"
And I set fields
 | such   | RLS-2010                    |
 | ueb    | ja                          |
 | vom    | .                           |
 | kenn   | FALL-2010 Ruecklieferschein |
 | ebeleg | FALL-2010                   |
And I set field "mge" to "-1000" in row 1
And I save the current editor

#  Ruecklieferung an eine Rechnung/Gutschrift
Given I open an editor "KGS-2010" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS-2010"
And I set field "beleg" to "RLS-2010"
Then the table has 1 rows
And I close the current editor

Given I open an editor "KGS-2010" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to "RLS-2010"
And I set field "beleg" to "RLS-2010"
Then the table has 1 rows
And I set fields
 | such   | KGS-2010  |
 | ebeleg | KGS-2010  |
 | ueb    | ja        |
 | vom    | .         |
 | tterm  | .         |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
