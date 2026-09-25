# *****************************************************************************
#  Name           : ekvk_edi.feature
#  Autor          : foe
#  Verantwortlich : foe
#  Kontrolle      : as
#  Funktion       : Testet Einkauf-/Verkaufsvorgaenge mit EDI-Nachrichten-Konfiguration
#
# *****************************************************************************
#
@persistent
Feature: EDI-Nachrichten-Konfiguration zu Kunden/Lieferanten
Background:
Given I set the fake date to "02.01.1995"

# ----------------------------------------------------------------------------------------------
Scenario: In VK-Wertgutschrift ist dfuesenden nicht gesetzt, auch wenn EDI-Nachricht konfiguriert
# Wertgutschrift kann nicht per EDI versenden werden
# ----------------------------------------------------------------------------------------------
# Rechnung
Given I open an editor "RE001" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE001  |
   | such   | RE001   |
   | kunde  | EDIKD-1 |
   | ueb    | ja      |
   | vom    | .       |
   | tterm  | .       |
And I append rows
   | artikel | mge  | preis |
   | V1      | 1    | 25    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "WG001" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE001"
And I set fields
   | nummer | 1WG001 |
   | ebeleg | WG001  |
   | such   | WG001  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
And I press button "offueb" in row 1
Then field "pwert" has value "-25.00" in row 1
Then field "komplettgutschrift" has value "ja" in row 1
Then field "vorganga" has value "Kaufmännische Gutschrift"
# Feld dfuesenden ist in Wertgutschrift nicht gesetzt und schreibgeschuetzt
Then field "dfuesenden" is not modifiable
Then field "dfuesenden" has value "nein"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK: In kaufmaennischer Gutschrift ist dfuesenden nicht gesetzt, aber aenderbar
# ----------------------------------------------------------------------------------------------
# Lieferschein
Given I open an editor "1LS002" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1LS002 |
   | kunde  | 1      |
   | such   | LS002  |
   | ueb    | ja     |
And I append rows
   | artikel | mge   | preis       |
   | V1      | 10    | 30          |
And I save the current editor

# Rechnung
Given I open an editor "1RE002" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS002"
And I set fields
   | nummer | 1RE002 |
   | such   | RE002  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "1RLS002" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS002"
And I set fields
   | nummer | 1RLS002 |
   | such   | RLS002  |
   | ueb    | ja      |
And I set field "mge" to "-2" in row 1
And I save the current editor

# Kaufmaenische Gutschrift
Given I open an editor "KG-ZU-RLS002" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1RLS002"
And I set fields
   | nummer | 1KG002   |
   | such   | KG002    |
   | ueb    | ja       |
   | tterm  | .        |
   | vom    | .        |
# Feld dfuesenden ist in kaufm. Gutschrift nicht gesetzt, aber aenderbar
Then field "dfuesenden" is modifiable
Then field "dfuesenden" has value "nein"
Then the table has 1 rows
Then table has values
   | art     | mge | remge |
   | V1      | -2  | -2    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario Outline: Im Warenenmpfaenger ist keine EDI Nachricht konfiguriert im Hauptkunden aber schon
# ----------------------------------------------------------------------------------------------
# dfuesenden soll dann auch im Hauptkunden nachschauen

# EDI Kunde anlegen mit Versandanschrift
Given I open an editor "<edi_kunde>" from table "(Customer):(Customer)" with command "COPY" for record "EDIKD-1"
And I set fields
   | such      | <edi_kunde>           |
   | namebspr  | <edi_kunde>           |
   | waehr     | EUR                   |
   | ans2      | Bismark-Center        |
   | str2      | Pottsdamer Platz 1232 |
   | plz2      | 10000                 |
   | nort2     | Berlin                |
And I save the current editor

# EDI Nachricht zum Kunden
Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "UPDATE" for record from editor "<edi_kunde>"
And I press button "edinfo" to open a subeditor for "EDIInfo"
And I create a new row at the end of the table
And I set field "edinachraz" to "<edi_nachricht_ku>" in row 1
And I set field "ieabmodell" to "<nachricht_ku_id>" in row 1
And I set field "erlaubt" to "<aktiv_ku>" in row 1
And I save the current editor
And I switch the current editor to editor "Kunde"
And I save the current editor

# EDI Kundenkontakt anlegen ohne Versandanschrift
Given I open an editor "<edi_sb_kunde>" from table "(Customer):(CustomerContact)" with command "COPY" for record "EDISB-11"
And I set fields
   | firma  | <edi_kunde>    |
   | such   | <edi_sb_kunde> |
And I save the current editor

# EDI Nachricht zum Kundenkontakt
Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "UPDATE" for record from editor "<edi_sb_kunde>"
And I press button "edinfo" to open a subeditor for "EDIInfo"
And I create a new row at the end of the table
And I set field "edinachraz" to "<edi_nachricht_sb>" in row 1
And I set field "ieabmodell" to "<nachricht_sb_id>" in row 1
And I set field "erlaubt" to "<aktiv_sb>" in row 1
And I save the current editor
And I switch the current editor to editor "Kundenkontakt"
And I save the current editor

# Auftrag zum Kundenkontakt
Given I open an editor "<ausuch>" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | such      | <ausuch>       |
   | kunde     | <edi_sb_kunde> |
   | warenempf | <edi_kunde>    |
   | vom       | .              |
   | tterm     | .              |
And I append rows
   | artikel | mge  | preis |
   | V1      | 1    | 25    |

Then field "dfuesenden" has value "<soll_dfuesenden>"
And I save the current editor

# Edi-Nachricht Versandabruf gilt nicht bei Auftrag. Es wird Auftragsbestaetigung benoetigt
Examples:
| row | edi_kunde | edi_nachricht_ku | nachricht_ku_id | aktiv_ku | edi_sb_kunde | edi_nachricht_sb | nachricht_sb_id | aktiv_sb | ausuch | soll_dfuesenden |
| 000 | EDIKD-5   | Versandabruf     | 4030            | nein     | EDISB-51     | Versandabruf     | 4030            | nein     | AU002  | nein            |
| 001 | EDIKD-6   | Versandabruf     | 4030            | nein     | EDISB-61     | Auftragsbest     | 4050            | nein     | AU003  | nein            |
| 002 | EDIKD-7   | Versandabruf     | 4030            | nein     | EDISB-71     | Auftragsbest     | 4050            | ja       | AU004  | ja              |
| 003 | EDIKD-8   | Auftragsbest     | 4050            | nein     | EDISB-81     | Versandabruf     | 4030            | nein     | AU005  | nein            |
| 004 | EDIKD-9   | Auftragsbest     | 4050            | nein     | EDISB-91     | Auftragsbest     | 4050            | nein     | AU006  | nein            |
| 005 | EDIKD-10  | Auftragsbest     | 4050            | nein     | EDISB101     | Auftragsbest     | 4050            | ja       | AU007  | nein            |
| 006 | EDIKD-11  | Auftragsbest     | 4050            | ja       | EDISB111     | Versandabruf     | 4030            | nein     | AU008  | ja              |
| 007 | EDIKD-12  | Auftragsbest     | 4050            | ja       | EDISB121     | Auftragsbest     | 4050            | nein     | AU009  | ja              |
| 008 | EDIKD-13  | Auftragsbest     | 4050            | ja       | EDISB131     | Auftragsbest     | 4050            | ja       | AU010  | ja              |


Scenario: VK: Kunde mit EDI-Nachricht, dann ZUGFeRD-Rechnung setzen: dfuesenden wird geleert
# ----------------------------------------------------------------------------------------------
# EDI-Nachricht zum Kunden anlegen
Given I open an editor "kunde1_edi" from table "(Customer):(Customer)" with command "UPDATE" for record "1"
And I press button "edinfo" to open a subeditor for "EDIInfo"
And I create a new row at the end of the table
And I set field "edinachraz" to "Rechnung" in row 1
Then field "vorgang" has value "VKRE" in row 1
And I set field "ieabmodell" to "4100" in row 1
And I set field "erlaubt" to "ja" in row 1
And I set field "protokoll" to "EDIFACT" in row 1
And I set field "uebnr" to "edi1" in row 1
And I set field "turnus" to "2" in row 1
And I save the current editor
And I switch the current editor to editor "kunde1_edi"
And I save the current editor

# Rechnung zum Kunden 1 anlegen
Given I open an editor "1RE003" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE003 |
   | kunde  | 1      |
   | kl2    | 1      | # Rechnungsempfaenger
   | such   | RE003  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
And I append rows
   | artikel | mge   | preis   |
   | V1      | 10    | 20      |
Then field "dfuesenden" has value "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Kunde: die EDI-Nachricht von Rechnung auf ZUGFeRD aendern
Given I open an editor "kunde1_edi" from table "(Customer):(Customer)" with command "UPDATE" for record "1"
And I press button "edinfo" to open a subeditor for "EDIInfo"
And I set field "edinachraz" to "ZUGFeRD-Rechnung Export" in row 1
Then field "ieabmodell" has value "" in row 1
Then field "vorgang" has value "" in row 1
Then field "zuoschema" has value "" in row 1
Then field "protokoll" has value "" in row 1
Then field "uebnr" has value "" in row 1
Then field "suchkonfig" has value "" in row 1
Then field "turnus" has value "" in row 1
And I save the current editor
And I switch the current editor to editor "kunde1_edi"
And I save the current editor

# Weitere Rechnung anlegen, Feld "dfuesenden" darf nicht gesetzt sein
Given I open an editor "1RE004" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE004 |
   | kunde  | 1      |
   | kl2    | 1      | # Rechnungsempfaenger
   | such   | RE004  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
And I append rows
   | artikel | mge   | preis   |
   | V1      | 10    | 30      |
Then field "dfuesenden" has value "nein"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
