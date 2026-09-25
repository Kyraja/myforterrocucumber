# *****************************************************************************
#  Name           : sammelrechnung_vk.feature
#  Autor          : mibr
#  Verantwortlich : teampss
#  Funktion       : Tests zur Zusammensetzung von Sammelrechnungen im Verkauf
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

@Rechnung
@Sammelrechnung
@FALL-1550
Scenario: FALL-1550	VK	Auftrag	Lieferschein	Kundenanlieferung zum Auftrag	Rechnung gemischt
# Auftrag anlegen
Given I open an editor "AU-1550" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
 | kunde | 1         |
 | such  | AU-1550   |
 | kenn  | FALL-1550 |
And I append rows
| artex | mge   | preis |
| V1    |  1550 | 1550  |
| V1    | -1550 | 1550  |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "LS-1550" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "AU-1550"
And I set fields
 | such  | LS-1550   |
 | ueb   | ja        |
 | kenn  | FALL-1550 |
And I append rows
| artex | mge   | preis |
| V1    | 1550  | 1550  |
And I save the current editor

# Kundenanlieferung
Given I open an editor "KDA-1550" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
 | lsart | Kundenanlieferung |
 | beleg | !AU-1550          |
 | such  | KDA-1550          |
 | ueb   | ja                |
And I set field "mge" to "-1550" in row 1
And I set field "platz" to "KONSILP" in row 1
And I save the current editor

# Rechnung anlegen aus Lieferschein und Kundenanlieferung
Given I open an editor "RE-1550" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS-1550"
And I set field "beleg" to id from editor "KDA-1550"
And I set fields
 | such  | RE-1550   |
 | kenn  | Fall-1550 |
 | ueb   | ja        |
 | vom   | .         |
 | budat | .         |
 | tterm | .         |
Then field "vorganga" has value "Rechnung"
Then field "lsart" has value ""
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

#
# Das Ganze noch einmal in anderer Reihenfolge RE = KDA dann LS
#

Given I open an editor "AU-1550B" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
 | kunde | 1         |
 | such  | AU-1550B  |
 | kenn  | FALL-1550 |
And I append rows
| artex | mge   | preis |
| V1    |  1550 | 1550  |
| V1    | -1550 | 1550  |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "LS-1550B" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "AU-1550B"
And I set fields
 | such  | LS-1550B  |
 | ueb   | ja        |
 | kenn  | FALL-1550 |
And I append rows
| artex | mge   | preis |
| V1    | 1550  | 1550  |
And I save the current editor

# Kundenanlieferung
Given I open an editor "KDA-1550B" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
 | lsart | Kundenanlieferung |
 | beleg | !AU-1550B         |
 | such  | KDA-1550B         |
 | ueb   | ja                |
And I set field "mge" to "-1550" in row 1
And I set field "platz" to "KONSILP" in row 1
And I save the current editor

# Rechnung anlegen aus Lieferschein und Kundenanlieferung
Given I open an editor "RE-1550B" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "KDA-1550B"
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I set field "beleg" to id from editor "LS-1550B"
And I set fields
 | such  | RE-1550B  |
 | kenn  | Fall-1550 |
 | ueb   | ja        |
 | vom   | .         |
 | budat | .         |
 | tterm | .         |
Then field "vorganga" has value "Rechnung"
# Erwartet Ungueltiger Feldwert (Eintrag ist wieder aus der Combo Box entfernt worden)
Then setting field "vorganga" to "Kaufmännische Gutschrift" throws the exception "1361"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

@Rechnung
@Sammelrechnung
Scenario: Gutschrift Kriterium = Nie - kaufm. Gutschrift ist nicht auswaehlbar
# Betriebsdaten: 3 moegliche Einstellungen fuer das Kriterium fuer kaufm. GS durchspielen
Given I open an editor "Betriebsdaten" from table "(Company):(CompanyData)" with command "STORE" for record "1"
And I set field "kgskriterium" to "Keine kaufmännische Gutschrift"
And I save the current editor

# Lieferschein anlegen
Given I open an editor "LS-NIE" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
 | such  | LS-NIE    |
 | kunde | 1         |
 | ueb   | ja        |
And I append rows
| artex | mge   | preis |
| V1    | 777   | 777   |
And I save the current editor

# Ruecklieferschein anlegen
Given I open an editor "RLS-NIE" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS-NIE"
And I set fields
 | such  | RLS-NIE |
 | ueb   | ja      |
 | vom   | .       |
And I set field "mge" to "-777" in row 1
And I save the current editor
 
# Rechnung anlegen aus Ruecklieferschein
Given I open an editor "RE-NIE" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS-NIE"
Then field "vorganga" has value "Rechnung" 
# Unzulaessig
Then setting field "vorganga" to "Kaufmännische Gutschrift" throws the exception "131"
And I close the current editor

# Weiterer Fall:
# Pruefung, ob Rechnungsart richtig als "Rechnung" angezeigt wird, in der folgenden Vorgehensweise:
# Rechnung anlegen -> Ruecklieferschein -> Rechnung
Given I open an editor "rechnung-1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "1-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I append rows
| artex | mge   | preis |
| V1    |  22   |    22 |
And I set field "kenn" to "RE-1"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein anlegen aus Rechnung
Given I open an editor "RLS-1" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "rechnung-1"
And I set fields
 | such  | RLS-1   |
 | ueb   | ja      |
 | vom   | .       |
And I set field "mge" to "-12" in row 1
And I save the current editor

# Rechnung anlegen aus Ruecklieferschein
Given I open an editor "RE-2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS-1"
Then field "vorganga" has value "Rechnung"
# Unzulaessig
Then setting field "vorganga" to "Kaufmännische Gutschrift" throws the exception "131"
And I close the current editor

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
Given I open an editor "RE-1550-KOPIE" from table "(Sales):(Invoice)" with command "COPY" for record from editor "RE-1550"
Then field "vorganga" has value "<soll_vorganga1>"
Then field "lsart" has value ""
And I delete row at position 1
Then field "vorganga" has value "<soll_vorganga2>"
And I create a new row at the end of the table
And I set field "artikel" to "TR." in row !lastRow
Then field "vorganga" has value "<soll_vorganga3>"
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row !lastRow
Then field "vorganga" has value "<soll_vorganga4>"
And I set field "mge" to "11" in row !lastRow
Then field "vorganga" has value "<soll_vorganga5>"
And I close the current editor

Examples:
| kgskriterium                            | soll_vorganga1 | soll_vorganga2            | soll_vorganga3            | soll_vorganga4            | soll_vorganga5           |
| Nettosumme kleiner null                 | Rechnung       | Kaufmännische Gutschrift  | Kaufmännische Gutschrift  | Kaufmännische Gutschrift  | Kaufmännische Gutschrift |
| Keine kaufmännische Gutschrift          | Rechnung       | Rechnung                  | Rechnung                  | Rechnung                  | Rechnung                 |
| Werte aller Rechnungspositionen negativ | Rechnung       | Kaufmännische Gutschrift  | Kaufmännische Gutschrift  | Kaufmännische Gutschrift  | Rechnung                 |

@FALL-1570
Scenario: FALL-1570	VK	Auftrag pos+neg	Lieferschein Ruecklieferschein Kundenanlieferung Rechnung RLS + KDA
# Auftrag anlegen
Given I open an editor "AU-1570" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
 | kunde | 1         |
 | such  | AU-1570   |
 | kenn  | FALL-1570 |
And I append rows
| artex | mge   | preis |
| V1    |  1570 | 1570  |
| V1    | -1570 | 1570  |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "LS-1570" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "AU-1570"
And I set fields
 | such  | LS-1570   |
 | ueb   | ja        |
 | kenn  | FALL-1570 |
And I append rows
| artex | mge   | preis |
| V1    | 1550  | 1550  |
And I save the current editor

# Ruecklieferschein anlegen
Given I open an editor "RLS-1570" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS-1570"
And I set fields
 | such  | RLS-1570                    |
 | ueb   | ja                          |
 | vom   | .                           |
 | kenn  | FALL-1570 Ruecklieferschein |
And I set field "mge" to "-31" in row 1
And I save the current editor

# Kundenanlieferung
Given I open an editor "KDA-1570" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
 | lsart | Kundenanlieferung |
 | beleg | !AU-1570          |
 | such  | KDA-1570          |
 | ueb   | ja                |
And I set field "mge" to "-1570" in row 1
And I set field "platz" to "KONSILP" in row 1
And I save the current editor
 
# Rechnung anlegen aus Ruecklieferschein und Kundenanlieferung
Given I open an editor "RE-1570" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS-1570"
And I set field "beleg" to id from editor "KDA-1570"
And I set fields
 | such  | RE-1570   |
 | kenn  | Fall-1570 |
 | ueb   | ja        |
 | vom   | .         |
 | budat | .         |
 | tterm | .         |
#Ergibt Gutschrift
Then field "vorganga" has value "Kaufmännische Gutschrift" 
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

@FALL-1580
Scenario: FALL-1580	VK Auftrag pos+neg Lieferschein Ruecklieferschein Kundenanlieferung	Rechnung LS+RLS+KDA
# Auftrag anlegen
Given I open an editor "AU-1580" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
 | kunde | 1         |
 | such  | AU-1580   |
 | kenn  | FALL-1580 |
And I append rows
| artex | mge   | preis |
| V1    |  1570 | 1580  |
| V1    | -1570 | 1580  |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "LS-1580" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "AU-1580"
And I set fields
 | such  | LS-1580   |
 | ueb   | ja        |
 | kenn  | FALL-1580 |
And I append rows
| artex | mge   | preis |
| V1    | 1580  | 1580  |
And I save the current editor

# Ruecklieferschein anlegen
Given I open an editor "RLS-1580" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS-1580"
And I set fields
 | such  | RLS-1580                    |
 | ueb   | ja                          |
 | vom   | .                           |
 | kenn  | FALL-1580 Ruecklieferschein |
And I set field "mge" to "-31" in row 1
And I save the current editor 

# Kundenanlieferung
Given I open an editor "KDA-1580" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
 | lsart | Kundenanlieferung |
 | beleg | !AU-1580          |
 | such  | KDA-1580          |
 | ueb   | ja                |
And I set field "mge" to "-1580" in row 1
And I set field "platz" to "KONSILP" in row 1
And I save the current editor

# Rechnung anlegen aus Lieferschein + Ruecklieferschein und Kundenanlieferung
Given I open an editor "RE-1580" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS-1580"
And I set field "beleg" to id from editor "RLS-1580"
And I set field "beleg" to id from editor "KDA-1580"
And I set fields
 | such  | RE-1580   |
 | kenn  | Fall-1580 |
 | ueb   | ja        |
 | vom   | .         |
 | budat | .         |
 | tterm | .         |
Then field "vorganga" has value "Rechnung"
Then field "lsart" has value ""
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

@Rechnung
@Sammelrechnung
Scenario: Gutschrift Kriterium = Nettosumme kleiner null
# Betriebsdaten: Einstellungen fuer das Kriterium fuer kaufm. GS = "Nettosumme kleiner Null"
Given I open an editor "Betriebsdaten" from table "(Company):(CompanyData)" with command "STORE" for record "1"
And I set field "kgskriterium" to "Nettosumme kleiner null"
And I save the current editor

Given I open an editor "rechnung-kgs1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "1re-kgs"
And I set field "such" to "re-kgs1"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I append rows
| artex |    mge     | preis     | pwert       |
| V1    |     11     |    11     | !dontChange |
| Text  |!dontChange |!dontChange|  -400       |
And I set field "kenn" to "REKGS-1"
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein aus KGS anlegen
Given I open an editor "RLS-KGS1" from table "(Sales):(Invoice)" with command "RETURN" for record "+re-kgs1"
And I set fields
 | such  | RLS-KGS1                    |
 | ueb   | ja                          |
 | vom   | .                           |
 | kenn  | FALL-KGS1 Ruecklieferschein |
And I press button "offueb" in row 1
And I save the current editor

@Rechnung
@Sammelrechnung
Scenario: Gutschrift Kriterium = Werte aller Rechnungspositionen negativ
# Betriebsdaten: Einstellungen fuer das Kriterium fuer kaufm. GS = "Werte aller Rechnungspositionen negativ"
Given I open an editor "Betriebsdaten" from table "(Company):(CompanyData)" with command "STORE" for record "1"
And I set field "kgskriterium" to "Werte aller Rechnungspositionen negativ"
And I save the current editor

Given I open an editor "rechnung-kgs2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "2re-kgs"
And I set field "such" to "re-kgs2"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I append rows
| artex | pwert |
| Text  |  -22  |
And I set field "kenn" to "REKGS-2"
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein 2 aus KGS anlegen
Given I open an editor "RLS-KGS2" from table "(Sales):(Invoice)" with command "RETURN" for record "+re-kgs2"
And I set fields
 | such  | RLS-KGS2                    |
 | ueb   | ja                          |
 | vom   | .                           |
 | kenn  | FALL-KGS2 Ruecklieferschein |
And I save the current editor
