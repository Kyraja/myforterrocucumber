# *****************************************************************************
#  Name           : wertgutschrift_lj_bewertung_vk.feature
#  Verantwortlich : bschiga
#  Kontrolle      : carue
#  Funktion       : Test der LJ und Bewertungen bei Wertgutschriften im Verkauf
#
# *****************************************************************************
#
@persistent
Feature: wertgutschrift_lj_bewertung_vk.feature
Background:
Given I set the fake date to "02.01.1995"

Scenario: Stammdaten

Given I open an editor "firma" from table "(Company):(ValuationConfiguration)" with command "UPDATE" for record "10"
And I modify table
  | !row | bewab             | bewzu         |
  | 1    | Preis des Zugangs | Vorgangspreis |
And I save the current editor


Scenario: 07 VK - Rechnung ohne Lagerbewegung - Auftrag, Lieferscheine und Rechnungen fuer Teilmengen, Komplettwertgutschrift

Given I open an editor "VK11" from table "(Part):(Product)" with command "STORE" for record "VK11"
And I set fields
    | such      | VK11                 |
    | namebspr  | VK-Teil 11           |
    | vpr       | 15                   |
    | epr       | 10.50                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "AUF11" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 11AUF        |
   | kunde   | 1            |
   | such    | AUF11        |
   | betreff | AUF11-WERT   |
And I append rows
   | artikel | mge | preis |
   | VK11    | 10  | 15    |
And I save the current editor

# Lieferscheine aus Auftrag, Teilmenge, Rechnung soll aus Auftrag erzeugt werden
Given I open an editor "LS1-11AUF" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "11AUF"
And I set fields
   | nummer | 1VKLS11   |
   | such   | LS1-11AUF |
   | ueb    | ja        |
   | fakt   | nein      |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "5" in row 1
And I save the current editor

Given I open an editor "LS2-11AUF" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "11AUF"
And I set fields
   | nummer | 2VKLS11   |
   | such   | LS2-11AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "5" in row 1
And I save the current editor

# Journaleintraege zu den Lieferscheinen
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==VK11;buarta==Abgang;platz==F1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | VK11                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 5                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==VK11;buarta==Abgang;platz==F1;@richtung=rückwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | VK11                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 5                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

# Bewertungen zu den Lieferscheinen, vor Erstellung der Rechnungen
Given I open latest Valuation "BewertungAb1.1" for Product "VK11" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 5                     |
Then table has values
    | tmge | vkpos   |
    | 5    |         |
And I close the current editor

Given I open latest Valuation "BewertungAb2.1" for Product "VK11" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 5                     |
Then table has values
    | tmge | vkpos   |
    | 5    |         |
And I close the current editor

# Erstellen und Buchen Rechnung 1
Given I open an editor "RE1-11AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "11AUF"
And I set fields
   | nummer | 1VKRE11   |
   | such   | RE1-11AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "7" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE1-11AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE1-11AUF"
And I save value from field "id" in row 1
And I close the current editor

# Bewertungen zu den Lieferscheinen, Nach Buchen der Rechnung 1
Given I open latest Valuation "BewertungAb1.2" for Product "VK11" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 5                     |
    | vorgaenger^id | !BewertungAb1.1^id    |
Then field "tmge" has value "5" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

Given I open latest Valuation "BewertungAb2.2" for Product "VK11" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 5                     |
    | vorgaenger^id | !BewertungAb2.1^id    |
Then field "tmge" has value "2" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "3" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

# Erstellen und Buchen Rechnung 2
Given I open an editor "RE2-11AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "11AUF"
And I set fields
   | nummer | 2VKRE11   |
   | such   | RE2-11AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE2-11AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE2-11AUF"
And I save value from field "id" in row 1
And I close the current editor

# Bewertungen zu den Lieferscheinen, Nach Buchen der Rechnung 2
Given I open latest Valuation "BewertungAb2.3" for Product "VK11" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 5                     |
    | vorgaenger^id | !BewertungAb2.2^id    |
Then field "tmge" has value "2" in row 1
# vkpos hat Verweis auf Rechnungsposition der ersten Rechnung
Then field "vkpos^id" in row 1 has value equal to field "vkpos^id" from editor "BewertungAb2.2" in row 1
Then field "tmge" has value "1" in row 2
# vkpos hat Verweis auf Rechnungsposition der zweiten Rechnung
Then field "vkpos^id" in row 2 equals saved value
Then field "tmge" has value "2" in row 3
Then field "vkpos" is empty in row 3
And I close the current editor

# Komplettwertgutschrift zu Rechnung 2 buchen
Given I open an editor "WERT-RE2-11AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE2-11AUF"
And I set fields
    | nummer | 1WERTRE2   |
    | such   | VK1WERT11  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert    |
    | -1    | 15.00     | -15.00   |
And I save the current editor

# Bewertung nach der Wertgutschrift zu Rechnung 2, vkpos ist leer
Given I open latest Valuation "BewertungAb2.4" for Product "VK11" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 5                     |
    | vorgaenger^id | !BewertungAb2.3^id    |
Then table has values
    | !row  | tmge | vkpos   |
    | 2     | 1    |         |
    | 3     | 2    |         |
Then field "tmge" has value "2" in row 1
Then field "vkpos^id" in row 1 has value equal to field "vkpos^id" from editor "BewertungAb2.3" in row 1
And I close the current editor

# Komplettwertgutschrift zu Rechnung 1 buchen
Given I open an editor "WERT-RE1-11AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1-11AUF"
And I set fields
    | nummer | 2WERTRE1   |
    | such   | VK2WERT11  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -7    | 15.00     | -105.00   |
And I save the current editor

# Bewertungen nach der Wertgutschrift 2 zu Rechnung 1, vkpos ist leer
Given I open latest Valuation "BewertungAb1.3" for Product "VK11" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 5                     |
    | vorgaenger^id | !BewertungAb1.2^id    |
Then table has values
    | tmge | vkpos   |
    | 5    |         |
And I close the current editor

Given I open latest Valuation "BewertungAb2.5" for Product "VK11" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 5                     |
    | vorgaenger^id | !BewertungAb2.4^id    |
Then table has values
    | !row  | tmge | vkpos   |
    | 1     | 2    |         |
    | 2     | 1    |         |
    | 3     | 2    |         |
And I close the current editor


Scenario: 08 VK - Rechnung mit Lagerbewegung - Auftrag, Rechnung mit 2 MZ, Komplettwertgutschrift

Given I open an editor "VK22" from table "(Part):(Product)" with command "STORE" for record "VK22"
And I set fields
    | such      | VK22                 |
    | namebspr  | VK-Teil 22           |
    | vpr       | 15                   |
    | epr       | 10.50                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "AUF22" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 22AUF        |
   | kunde   | 1            |
   | such    | AUF22        |
   | betreff | AUF22-WERT   |
And I append rows
   | artikel | mge | preis |
   | VK22    | 10  | 15    |
And I save the current editor

# Rechnung aus Auftrag, 2 MZ
Given I open an editor "RE1-22AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "22AUF"
And I set fields
   | nummer | 1VKRE22   |
   | such   | RE1-22AUF |
   | ueb    | ja        |
   | fakt   | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "7" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge |
    | F1     | 3      |
    | F1     | 4      |
And I save the current editor
And I switch the current editor to editor "RE1-22AUF"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journaleintraege zu den MZ der Rechnung
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==VK22;buarta==Abgang;mge==3;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | VK22                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 3                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
And I close the current editor

Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==VK22;buarta==Abgang;mge==4;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | VK22                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 4                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
And I close the current editor

Given I open an editor "RE1-22AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE1-22AUF"
And I save value from field "id" in row 1
And I close the current editor

# Bewertungen zur Rechnung mit Lagerbewegung
Given I open latest Valuation "BewertungAb1.1" for Product "VK22" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 3                     |
Then field "tmge" has value "3" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

Given I open latest Valuation "BewertungAb2.1" for Product "VK22" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 4                     |
Then field "tmge" has value "4" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

# Komplettwertgutschrift buchen
Given I open an editor "WERT-RE1-22AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1-22AUF"
And I set fields
    | nummer | 3WERTRE1   |
    | such   | VK2WERT11  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -7    | 15.00     | -105.00   |
And I save the current editor

# Bewertungen zu den MZ der Rechnung, nach der Komplettwertgutschrit, vkpos ist leer
Given I open latest Valuation "BewertungAb1.2" for Product "VK22" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 3                     |
    | vorgaenger^id | !BewertungAb1.1^id    |
Then table has values
    | tmge | vkpos   |
    | 3    |         |
And I close the current editor

Given I open latest Valuation "BewertungAb2.2" for Product "VK22" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 4                     |
    | vorgaenger^id | !BewertungAb2.1^id    |
Then table has values
    | tmge | vkpos   |
    | 4    |         |
And I close the current editor

# Szenarien 09 - 16a aus FDA-4313
Scenario: 09 VK - Teilrechnung mit Lagerbewegung, Komplettwertgutschrift, Rechnungskorrektur Teilmenge, Komplettwertgutschrift, Rechnungskorrektur Teilmenge

Given I open an editor "VK23" from table "(Part):(Product)" with command "STORE" for record "VK23"
And I set fields
    | such      | VK23                 |
    | namebspr  | VK-Teil 23           |
    | vpr       | 15                   |
    | epr       | 10.50                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "AUF23" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 23AUF        |
   | kunde   | 1            |
   | such    | AUF23        |
   | betreff | AUF23-WERT   |
And I append rows
   | artikel | mge | preis |
   | VK23    | 10  | 15    |
And I save the current editor

# Rechnung mit Lagerbewegung aus Auftrag, Teilmenge
Given I open an editor "RE1-23AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "23AUF"
And I set fields
   | nummer | 1VKRE23   |
   | such   | RE1-23AUF |
   | ueb    | ja        |
   | fakt   | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "7" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journaleintraege zu der Rechnung
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==VK23;buarta==Abgang;mge==7;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | VK23                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 7                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
And I close the current editor

Given I open an editor "RE1-23AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE1-23AUF"
And I save value from field "id" in row 1
And I close the current editor

# Bewertungen zur Rechnung mit Lagerbewegung
Given I open latest Valuation "BewertungAb1.1" for Product "VK23" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 7                     |
Then field "tmge" has value "7" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

# Komplettwertgutschrift zur Rechnung buchen
Given I open an editor "WERT-RE1-23AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1-23AUF"
And I set fields
    | nummer | 3WERT23    |
    | such   | VK2WERT23  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -7    | 15.00     | -105.00   |
And I save the current editor

# Bewertungen zu der Rechnung, nach der Komplettwertgutschrift, vkpos ist leer
Given I open latest Valuation "BewertungAb1.2" for Product "VK23" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 7                     |
    | vorgaenger^id | !BewertungAb1.1^id    |
Then table has values
    | tmge | vkpos  |
    | 7    |        |
And I close the current editor

# Rechnungskorrektur aus der Rechnung erstellen und buchen
Given I open an editor "KORR-RE1-23AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1-23AUF"
And I set fields
    | nummer | 3KORR1     |
    | such   | VK1KORR23  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
And I press button "burekorrektur"
And I set field "mge" to "5" in row 1
And I save the current editor

# Bewertung hat 2 Zeilen, Menge 5 mit vkpos der Rechnungskorrektur und Menge 2 vkpos leer
Given I open an editor "KORR-RE1-23AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+VK1KORR23"
And I save value from field "id" in row 1
And I close the current editor

Given I open latest Valuation "BewertungAb1.3" for Product "VK23" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 7                     |
    | vorgaenger^id | !BewertungAb1.2^id    |
Then field "tmge" has value "5" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "2" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

# Komplettwertgutschrift zur Rechnungskorrektur buchen
Given I open an editor "WERT-KORR-23AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "KORR-RE1-23AUF"
And I set fields
    | nummer | 3WGKORR1   |
    | such   | VKWERT23K  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -5    | 15.00     | -75.00    |
And I save the current editor

# Bewertung hat 2 Zeilen, Menge 5 und Menge 2 jeweils vkpos leer
Given I open latest Valuation "BewertungAb1.4" for Product "VK23" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 7                     |
    | vorgaenger^id | !BewertungAb1.3^id    |
Then table has values
    | tmge | vkpos   |
    | 5    |         |
    | 2    |         |
And I close the current editor

# Rechnungskorrektur aus der Rechnung erstellen und buchen
Given I open an editor "KORR2-RE1-23AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1-23AUF"
And I set fields
    | nummer | 3KORR2     |
    | such   | VK2KORR23  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
And I press button "burekorrektur"
And I set field "mge" to "2" in row 1
And I save the current editor

Given I open an editor "KORR2-RE1-23AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+VK2KORR23"
And I save value from field "id" in row 1
And I close the current editor

# Bewertung hat 3 Zeilen, Menge 2 mit vkpos der RE-Korr, Menge 3 und Menge 2 jeweils vkpos leer
Given I open latest Valuation "BewertungAb1.5" for Product "VK23" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 7                     |
    | vorgaenger^id | !BewertungAb1.4^id    |
Then field "tmge" has value "2" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
Then table has values
    | !row  | tmge | vkpos   |
    | 2     | 3    |         |
    | 3     | 2    |         |
And I close the current editor


Scenario: 10 VK - Teilrechnung mit Lagerbewegung mit 3 MZ, Komplettwertgutschrift, Rechnungskorrektur Teilmenge, Komplettwertgutschrift, Rechnungskorrektur Teilmenge

Given I open an editor "VK24" from table "(Part):(Product)" with command "STORE" for record "VK24"
And I set fields
    | such      | VK24                 |
    | namebspr  | VK-Teil 24           |
    | vpr       | 15                   |
    | epr       | 10.50                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor


# Bestand für VK24 mittels manuellem Lagerzugang bereitstellen 
And I post a receipt via ManualStockAdjustment for Product "VK24" and quantity "1000" on StorageLocation "F1" with document "ZVK24" and price "24.0"

Given I open an editor "AUF24" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 24AUF        |
   | kunde   | 1            |
   | such    | AUF24        |
   | betreff | AUF24-WERT   |
And I append rows
   | artikel | mge | preis |
   | VK24    | 10  | 15    |
And I save the current editor

# Rechnung mit Lagerbewegung aus Auftrag, Teilmenge mit 3 MZ, buchen
Given I open an editor "RE1-24AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "24AUF"
And I set fields
   | nummer | 1VKRE24   |
   | such   | RE1-24AUF |
   | ueb    | ja        |
   | fakt   | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "7" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge |
    | F1     | 4      |
    | F1     | 2      |
    | F1     | 1      |
And I save the current editor
And I switch the current editor to editor "RE1-24AUF"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journaleintraege zu den MZ der Rechnung
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==VK24;buarta==Abgang;mge==4;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | VK24                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 4                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
And I close the current editor

Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==VK24;buarta==Abgang;mge==2;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | VK24                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 2                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
And I close the current editor

Given I open an editor "JournalAb3" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==VK24;buarta==Abgang;mge==1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | VK24                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 1                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
And I close the current editor

Given I open an editor "RE1-24AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE1-24AUF"
And I save value from field "id" in row 1
And I close the current editor

# Bewertungen zur Rechnung mit Lagerbewegung, 3 MZ, 3 Bewertungsketten
Given I open latest Valuation "BewertungAb1.1" for Product "VK24" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 4                     |
Then field "tmge" has value "4" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

Given I open latest Valuation "BewertungAb2.1" for Product "VK24" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 2                     |
Then field "tmge" has value "2" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

Given I open latest Valuation "BewertungAb3.1" for Product "VK24" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 1                     |
Then field "tmge" has value "1" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

# Komplettwertgutschrift zu Rechnung buchen
Given I open an editor "WERT-RE1-24AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1-24AUF"
And I set fields
    | nummer | 3WERT24    |
    | such   | VK2WERT24  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -7    | 15.00     | -105.00   |
And I save the current editor

# Bewertungen zu der Rechnung, nach der Komplettwertgutschrift, vkpos ist leer
Given I open latest Valuation "BewertungAb1.2" for Product "VK24" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 4                     |
    | vorgaenger^id | !BewertungAb1.1^id    |
Then table has values
    | tmge | vkpos   |
    | 4    |         |
And I close the current editor

Given I open latest Valuation "BewertungAb2.2" for Product "VK24" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 2                     |
    | vorgaenger^id | !BewertungAb2.1^id    |
Then table has values
    | tmge | vkpos  |
    | 2    |        |
And I close the current editor

Given I open latest Valuation "BewertungAb3.2" for Product "VK24" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 1                     |
    | vorgaenger^id | !BewertungAb3.1^id    |
Then table has values
    | tmge | vkpos  |
    | 1    |        |
And I close the current editor

# Rechnungskorrektur aus der Rechnung erstellen und buchen
Given I open an editor "KORR-RE1-24AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1-24AUF"
And I set fields
    | nummer | 3KORR1     |
    | such   | VK1KORR24  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
And I press button "burekorrektur"
And I set field "mge" to "5" in row 1
And I save the current editor

# Bewertung hat 2 Zeilen, Menge 5 mit vkpos der Rechnungskorrektur und Menge 2 vkpos leer
Given I open an editor "KORR-RE1-24AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+VK1KORR24"
And I save value from field "id" in row 1
And I close the current editor

Given I open latest Valuation "BewertungAb1.3" for Product "VK24" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 4                     |
    | vorgaenger^id | !BewertungAb1.2^id    |
Then field "tmge" has value "4" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

Given I open latest Valuation "BewertungAb2.3" for Product "VK24" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 2                     |
    | vorgaenger^id | !BewertungAb2.2^id    |
Then field "tmge" has value "1" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "1" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

# keine neue Bewertung, die gleiche Bewertung wie BewertungAb3.2
Given I open latest Valuation "BewertungAb3.3" for Product "VK24" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 1                     |
    | vorgaenger^id | !BewertungAb3.1^id    |
Then table has values
    | tmge | vkpos   |
    | 1    |         |
And I close the current editor

# Komplettwertgutschrift zur Rechnungskorrektur buchen
Given I open an editor "WERT-KORR-24AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "KORR-RE1-24AUF"
And I set fields
    | nummer | 3WGKORR1   |
    | such   | VKWERT24K  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge    | preis     | pwert     |
    | -5     | 15.00     | -75.00    |
And I save the current editor

Given I open latest Valuation "BewertungAb1.4" for Product "VK24" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 4                     |
    | vorgaenger^id | !BewertungAb1.3^id    |
Then table has values
    | tmge | vkpos  |
    | 4    |        |
And I close the current editor

Given I open latest Valuation "BewertungAb2.4" for Product "VK24" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 2                     |
    | vorgaenger^id | !BewertungAb2.3^id    |
Then table has values
    | tmge | vkpos  |
    | 1    |        |
    | 1    |        |
And I close the current editor

# keine neue Bewertung, die gleiche Bewertung wie BewertungAb3.2
Given I open latest Valuation "BewertungAb3.4" for Product "VK24" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 1                     |
    | vorgaenger^id | !BewertungAb3.1^id    |
Then table has values
    | tmge | vkpos  |
    | 1    |        |
And I close the current editor

# Rechnungskorrektur aus der Rechnung erstellen und buchen
Given I open an editor "KORR2-RE1-24AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1-24AUF"
And I set fields
    | nummer | 3KORR2     |
    | such   | VK2KORR24  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
And I press button "burekorrektur"
And I set field "mge" to "2" in row 1
And I save the current editor

Given I open an editor "KORR2-RE1-24AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+VK2KORR24"
And I save value from field "id" in row 1
And I close the current editor

# Bewertung hat 2 Zeilen, Menge 2 mit vkpos der RE-Korr und Menge 2 vkpos leer
Given I open latest Valuation "BewertungAb1.5" for Product "VK24" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 4                     |
    | vorgaenger^id | !BewertungAb1.4^id    |
Then field "tmge" has value "2" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
Then table has values
    | !row  | tmge | vkpos   |
    | 2     | 2    |         |
And I close the current editor

# keine neue Bewertung, die gleiche Bewertung wie BewertungAb2.4
Given I open latest Valuation "BewertungAb2.5" for Product "VK24" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 2                     |
    | vorgaenger^id | !BewertungAb2.3^id    |
Then table has values
    | tmge | vkpos  |
    | 1    |        |
    | 1    |        |
And I close the current editor

# keine neue Bewertung, die gleiche Bewertung wie BewertungAb3.2
Given I open latest Valuation "BewertungAb3.5" for Product "VK24" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 1                     |
    | vorgaenger^id | !BewertungAb3.1^id    |
Then table has values
    | tmge | vkpos  |
    | 1    |        |
And I close the current editor


Scenario: 11 VK - Teilrechnung mit Lagerbewegung, Teilwertgutschrift, Rechnungskorrektur nicht moeglich

Given I open an editor "VK25" from table "(Part):(Product)" with command "STORE" for record "VK25"
And I set fields
    | such      | VK25                 |
    | namebspr  | VK-Teil 25           |
    | vpr       | 15                   |
    | epr       | 10.50                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "AUF25" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 25AUF        |
   | kunde   | 1            |
   | such    | AUF25        |
   | betreff | AUF25-WERT   |
And I append rows
   | artikel | mge | preis  |
   | VK25    | 10  | 15     |
And I save the current editor

# Rechnung mit Lagerbewegung, aus Auftrag, Teilmenge
Given I open an editor "RE1-25AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "25AUF"
And I set fields
   | nummer | 1VKRE25   |
   | such   | RE1-25AUF |
   | ueb    | ja        |
   | fakt   | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "7" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journaleintraege zu der Rechnung
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==VK25;buarta==Abgang;mge==7;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | VK25                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 7                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
And I close the current editor

Given I open an editor "RE1-25AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE1-25AUF"
And I save value from field "id" in row 1
And I close the current editor

# Bewertungen zur Rechnung mit Lagerbewegung
Given I open latest Valuation "BewertungAb1.1" for Product "VK25" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 7                     |
Then field "tmge" has value "7" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

# Teilwertgutschrift zu Rechnung buchen
Given I open an editor "WERT-RE1-25AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1-25AUF"
And I set fields
    | nummer | 3WERT25    |
    | such   | VK2WERT25  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "buwertgutschrift"
And I set field "mge" to "-2" in row 1
Then table has values
    | mge   | preis     | pwert     |
    | -2    | 15.00     | -30.00    |
And I save the current editor

# Bewertungen zu der Rechnung, nach der Teilwertgutschrift KEINE Folgebewertung, also Vorgaenger leer
Given I open latest Valuation "BewertungAb1.2" for Product "VK25" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 7                     |
    | vorgaenger    |                       |
Then field "tmge" has value "7" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

# es wird geprueft, dass Rechnungskorrektur aus der Rechnung erstellen nicht moeglich ist, da es eine Teilwertgutschrift gibt
# es wird zwar eine Rechnung erstellt, aber die Artikelposition fehlt, es sind nur die Rechnungszusatzpositionen enthalten
Given I open an editor "KORR-RE1-25AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1-25AUF"
And I set fields
    | nummer | 3KORR1     |
    | such   | VK1KORR25  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then I press button "burekorrektur"
Then the table has 3 rows
Then table has values
    | artikel^such  |
    | NS.           |
    | ST.           |
    | ES.           |
And I close the current editor


Scenario: 12 VK - Lieferschein Teilmenge, Rechnung aus LS, Komplettwertgutschrift, Rechnungskorrektur Teilmenge, Komplettwertgutschrift, Rechnungskorrektur Teilmenge

Given I open an editor "VK26" from table "(Part):(Product)" with command "STORE" for record "VK26"
And I set fields
    | such      | VK26                 |
    | namebspr  | VK-Teil 26           |
    | vpr       | 15                   |
    | epr       | 10.50                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "AUF26" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 26AUF        |
   | kunde   | 1            |
   | such    | AUF26        |
   | betreff | AUF26-WERT   |
And I append rows
   | artikel | mge | preis |
   | VK26    | 10  | 15    |
And I save the current editor

# Lieferschein aus Auftrag, Teilmenge
Given I open an editor "LS1-26AUF" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "26AUF"
And I set fields
   | nummer | 1VKLS26   |
   | such   | LS1-26AUF |
   | ueb    | ja        |
   | fakt   | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "3" in row 1
And I save the current editor

# Rechnung aus Lieferschein, komplette Menge
Given I open an editor "RE1-26AUF" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS1-26AUF"
And I set fields
   | nummer | 1VKRE26   |
   | such   | RE1-26AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "3" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journaleintraege zum Lieferschein
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==VK26;buarta==Abgang;mge==3;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | VK26                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 3                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

Given I open an editor "RE1-26AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE1-26AUF"
And I save value from field "id" in row 1
And I close the current editor

# Bewertungen zum Lieferschein
Given I open latest Valuation "BewertungAb1.1" for Product "VK26" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 3                     |
Then field "tmge" has value "3" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

# Komplettwertgutschrift zu Rechnung buchen
Given I open an editor "WERT-RE1-26AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1-26AUF"
And I set fields
    | nummer | 3WERT26    |
    | such   | VK2WERT26  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -3    | 15.00     | -45.00    |
And I save the current editor

# Bewertungen zu der Rechnung, nach der Komplettwertgutschrift, vkpos ist leer
Given I open latest Valuation "BewertungAb1.2" for Product "VK26" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 3                     |
    | vorgaenger^id | !BewertungAb1.1^id    |
    Then table has values
    | tmge | vkpos   |
    | 3    |         |
And I close the current editor

# Rechnungskorrektur aus Lieferschein erstellen und buchen
Given I open an editor "KORR-RE1-26AUF" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS1-26AUF"
And I set fields
    | nummer | 3KORR1     |
    | such   | VK1KORR26  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then field "rekorrektur" has value "ja" in row 1
And I set field "mge" to "2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Bewertung hat 2 Zeilen, Menge 2 mit vkpos der Rechnungskorrektur und Menge 1 vkpos leer
Given I open an editor "KORR-RE1-26AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+VK1KORR26"
And I save value from field "id" in row 1
And I close the current editor

Given I open latest Valuation "BewertungAb1.3" for Product "VK26" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 3                     |
    | vorgaenger^id | !BewertungAb1.2^id    |
Then field "tmge" has value "2" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "1" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

# Komplettwertgutschrift zur Rechnungskorrektur
Given I open an editor "WERT-KORR-26AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "KORR-RE1-26AUF"
And I set fields
    | nummer | 3WGKORR1   |
    | such   | VKWERT26K  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -2    | 15.00     | -30.00    |
And I save the current editor

# Bewertung hat 2 Zeilen, Menge 2 und Menge 1 jeweils vkpos leer
Given I open latest Valuation "BewertungAb1.4" for Product "VK26" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 3                     |
    | vorgaenger^id | !BewertungAb1.3^id    |
Then table has values
    | tmge | vkpos   |
    | 2    |         |
    | 1    |         |
And I close the current editor

# Rechnungskorrektur aus Lieferschein erstellen und buchen
Given I open an editor "KORR2-RE1-26AUF" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS1-26AUF"
And I set fields
    | nummer | 3KORR2     |
    | such   | VK2KORR26  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then field "rekorrektur" has value "ja" in row 1
And I set field "mge" to "1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "KORR2-RE1-26AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+VK2KORR26"
And I save value from field "id" in row 1
And I close the current editor

# Bewertung hat 3 Zeilen, Menge 1 mit vkpos der RE-Korr, Menge 1 und Menge 1 jeweils vkpos leer
Given I open latest Valuation "BewertungAb1.5" for Product "VK26" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 3                     |
    | vorgaenger^id | !BewertungAb1.4^id    |
Then field "tmge" has value "1" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
Then table has values
    | !row  | tmge | vkpos   |
    | 2     | 1    |         |
    | 3     | 1    |         |
And I close the current editor


Scenario: 13 VK - Lieferschein Teilmenge, Rechnung aus Auftrag, Komplettwertgutschrift, Rechnungskorrektur Teilmenge, Komplettwertgutschrift, Rechnungskorrektur Teilmenge

Given I open an editor "VK27" from table "(Part):(Product)" with command "STORE" for record "VK27"
And I set fields
    | such      | VK27                 |
    | namebspr  | VK-Teil 27           |
    | vpr       | 15                   |
    | epr       | 10.50                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "AUF27" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 27AUF        |
   | kunde   | 1            |
   | such    | AUF27        |
   | betreff | AUF27-WERT   |
And I append rows
   | artikel | mge | preis |
   | VK27    | 10  | 15    |
And I save the current editor

# Lieferschein aus Auftrag, Teilmenge
Given I open an editor "LS1-27AUF" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "27AUF"
And I set fields
   | nummer | 1VKLS27   |
   | such   | LS1-27AUF |
   | ueb    | ja        |
   | fakt   | nein      |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "3" in row 1
And I save the current editor

# Rechnung aus Auftrag, fuer gelieferte Menge
Given I open an editor "RE1-27AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AUF27"
And I set fields
   | nummer | 1VKRE27   |
   | such   | RE1-27AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "3" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journaleintraege zum Lieferschein
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==VK27;buarta==Abgang;mge==3;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | VK27                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 3                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

Given I open an editor "RE1-27AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE1-27AUF"
And I save value from field "id" in row 1
And I close the current editor

# Bewertungen zum Lieferschein
Given I open latest Valuation "BewertungAb1.1" for Product "VK27" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 3                     |
Then field "tmge" has value "3" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

# Komplettwertgutschrift zu Rechnung buchen
Given I open an editor "WERT-RE1-27AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1-27AUF"
And I set fields
    | nummer | 3WERT27    |
    | such   | VK2WERT27  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -3    | 15.00     | -45.00    |
And I save the current editor

# Bewertungen zu der Rechnung, nach der Komplettwertgutschrift, vkpos ist leer
Given I open latest Valuation "BewertungAb1.2" for Product "VK27" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 3                     |
    | vorgaenger^id | !BewertungAb1.1^id    |
Then table has values
    | tmge | vkpos   |
    | 3    |         |
And I close the current editor

# Rechnungskorrektur aus Auftrag erstellen und buchen
Given I open an editor "KORR-RE1-27AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AUF27"
And I set fields
    | nummer | 3KORR1     |
    | such   | VK1KORR27  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then field "rekorrektur" has value "ja" in row 1
And I set field "mge" to "2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Bewertung hat 2 Zeilen, Menge 2 mit vkpos der Rechnungskorrektur und Menge 1 vkpos leer
Given I open an editor "KORR-RE1-27AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+VK1KORR27"
And I save value from field "id" in row 1
And I close the current editor

Given I open latest Valuation "BewertungAb1.3" for Product "VK27" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 3                     |
    | vorgaenger^id | !BewertungAb1.2^id    |
Then field "tmge" has value "2" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "1" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

# Komplettwertgutschrift zur Rechnungskorrektur buchen
Given I open an editor "WERT-KORR-27AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "KORR-RE1-27AUF"
And I set fields
    | nummer | 3WGKORR1   |
    | such   | VKWERT27K  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -2    | 15.00     | -30.00    |
And I save the current editor

# Bewertung hat 2 Zeilen, Menge 2 und Menge 1 jeweils vkpos leer
Given I open latest Valuation "BewertungAb1.4" for Product "VK27" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 3                     |
    | vorgaenger^id | !BewertungAb1.3^id    |
Then table has values
    | tmge | vkpos   |
    | 2    |         |
    | 1    |         |
And I close the current editor

# Rechnungskorrektur aus Auftrag erstellen und buchen
Given I open an editor "KORR2-RE1-27AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AUF27"
And I set fields
    | nummer | 3KORR2     |
    | such   | VK2KORR27  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then field "rekorrektur" has value "ja" in row 1
And I set field "mge" to "1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Bewertung hat 3 Zeilen, Menge 1 mit vkpos der RE-Korr, Menge 1 und Menge 1 jeweils vkpos leer
Given I open an editor "KORR2-RE1-27AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+VK2KORR27"
And I save value from field "id" in row 1
And I close the current editor

Given I open latest Valuation "BewertungAb1.5" for Product "VK27" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 3                     |
    | vorgaenger^id | !BewertungAb1.4^id    |
Then field "tmge" has value "1" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
Then table has values
    | !row  | tmge | vkpos   |
    | 2     | 1    |         |
    | 3     | 1    |         |
And I close the current editor


Scenario: 14 VK - SETARTIKEL Lieferschein Teilmenge, Rechnung aus LS, Komplettwertgutschrift, Rechnungskorrektur Teilmenge, Komplettwertgutschrift, Rechnungskorrektur Teilmenge

Given I open an editor "SET28" from table "(Part):(Product)" with command "STORE" for record "SET28"
And I set fields
    | such      | SET28                 |
    | namebspr  | VK-Teil 28            |
    | vpr       | 15                    |
    | epr       | 10.50                 |
    | bsart     | Fremdbeschaffung      |
    | dispoa    | auftragsbezogen       |
    | earta     | über Stückliste       |
    | ekbewverf | 1                     |
And I delete all rows
And I append rows
    | elex      | elanzahl  |
    | EINK      | 1         |
    | BAUT      | 2         |
And I save the current editor

Given I open an editor "AUF28" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 28AUF        |
   | kunde   | 1            |
   | such    | AUF28        |
   | betreff | AUF28-WERT   |
And I append rows
   | artikel | mge | preis |
   | SET28   | 10  | 15    |
And I save the current editor

# Lieferschein aus Auftrag, Teilmenge
Given I open an editor "LS1-28AUF" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "28AUF"
And I set fields
   | nummer | 1VKLS28   |
   | such   | LS1-28AUF |
   | ueb    | ja        |
   | fakt   | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "3" in row 1
And I save the current editor

# Rechnung aus Lieferschein, komplette Menge
Given I open an editor "RE1-28AUF" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS1-28AUF"
And I set fields
   | nummer | 1VKRE28   |
   | such   | RE1-28AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "3" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journaleintraege zum Lieferschein, Komponente EINK
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==EINK;buarta==Abgang;mge==3;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EINK                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 3                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor
# Komponente BAUT
Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==BAUT;buarta==Abgang;mge==6;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | BAUT                  |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 6                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

Given I open an editor "RE1-28AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE1-28AUF"
And I save value from field "id" in row 1
And I close the current editor

# Bewertungen zum Lieferschein
Given I open latest Valuation "BewertungAb1.1" for Product "EINK" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 3                     |
Then field "tmge" has value "3" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

Given I open latest Valuation "BewertungAb2.1" for Product "BAUT" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 6                     |
Then field "tmge" has value "6" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

# Komplettwertgutschrift zu Rechnung buchen
Given I open an editor "WERT-RE1-28AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1-28AUF"
And I set fields
    | nummer | 3WERT28    |
    | such   | VK2WERT28  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -3    | 15.00     | -45.00    |
And I save the current editor

# Bewertungen zu der Rechnung, nach der Komplettwertgutschrift, vkpos ist leer
Given I open latest Valuation "BewertungAb1.2" for Product "EINK" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 3                     |
    | vorgaenger^id | !BewertungAb1.1^id    |
Then table has values
    | tmge | vkpos   |
    | 3    |         |
And I close the current editor

Given I open latest Valuation "BewertungAb2.2" for Product "BAUT" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 6                     |
    | vorgaenger^id | !BewertungAb2.1^id    |
Then table has values
    | tmge | vkpos   |
    | 6    |         |
And I close the current editor

# Rechnungskorrektur aus Lieferschein erstellen und buchen
Given I open an editor "KORR-RE1-28AUF" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS1-28AUF"
And I set fields
    | nummer | 3KORR1     |
    | such   | VK1KORR28  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then field "rekorrektur" has value "ja" in row 1
And I set field "mge" to "2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Bewertung hat 2 Zeilen, Menge 2 mit vkpos der Rechnungskorrektur und Menge 1 vkpos leer
Given I open an editor "KORR-RE1-28AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+VK1KORR28"
And I save value from field "id" in row 1
And I close the current editor

Given I open latest Valuation "BewertungAb1.3" for Product "EINK" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 3                     |
    | vorgaenger^id | !BewertungAb1.2^id    |
Then field "tmge" has value "2" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "1" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

Given I open latest Valuation "BewertungAb2.3" for Product "BAUT" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 6                     |
    | vorgaenger^id | !BewertungAb2.2^id    |
Then field "tmge" has value "4" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "2" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

# Komplettwertgutschrift zur Rechnungskorrektur buchen
Given I open an editor "WERT-KORR-28AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "KORR-RE1-28AUF"
And I set fields
    | nummer | 3WGKORR1   |
    | such   | VKWERT28K  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -2    | 15.00     | -30.00    |
And I save the current editor

# Bewertung hat 2 Zeilen, Menge 2 und Menge 1 jeweils vkpos leer
Given I open latest Valuation "BewertungAb1.4" for Product "EINK" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 3                     |
    | vorgaenger^id | !BewertungAb1.3^id    |
Then table has values
    | tmge | vkpos   |
    | 2    |         |
    | 1    |         |
And I close the current editor

Given I open latest Valuation "BewertungAb2.4" for Product "BAUT" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 6                     |
    | vorgaenger^id | !BewertungAb2.3^id    |
Then table has values
    | tmge | vkpos   |
    | 4    |         |
    | 2    |         |
And I close the current editor

# Rechnungskorrektur aus Lieferschein erstellen und buchen
Given I open an editor "KORR2-RE1-28AUF" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS1-28AUF"
And I set fields
    | nummer | 3KORR2     |
    | such   | VK2KORR28  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then field "rekorrektur" has value "ja" in row 1
And I set field "mge" to "1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "KORR2-RE1-28AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+VK2KORR28"
And I save value from field "id" in row 1
And I close the current editor

# Bewertung hat 3 Zeilen, Menge 1 mit vkpos der RE-Korr, Menge 1 und Menge 1 jeweils vkpos leer
Given I open latest Valuation "BewertungAb1.5" for Product "EINK" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 3                     |
    | vorgaenger^id | !BewertungAb1.4^id    |
Then field "tmge" has value "1" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
Then table has values
    | !row  | tmge | vkpos   |
    | 2     | 1    |         |
    | 3     | 1    |         |
And I close the current editor

Given I open latest Valuation "BewertungAb2.5" for Product "BAUT" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 6                     |
    | vorgaenger^id | !BewertungAb2.4^id    |
Then field "tmge" has value "2" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
Then table has values
    | !row  | tmge | vkpos   |
    | 2     | 2    |         |
    | 3     | 2    |         |
And I close the current editor


Scenario: 15 VK - Rechnung ohne Lagerbewegung, Teillieferschein, Komplettwertgutschrift, 2 Teillieferscheine, RE-Korrektur, Teillieferschein, Storno RE-Korrektur

Given I open an editor "VK29" from table "(Part):(Product)" with command "STORE" for record "VK29"
And I set fields
    | such      | VK29                 |
    | namebspr  | VK-Teil 29           |
    | vpr       | 15                   |
    | epr       | 10.50                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "AUF29" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 29AUF        |
   | kunde   | 1            |
   | such    | AUF29        |
   | betreff | AUF29-WERT   |
And I append rows
   | artikel | mge | preis |
   | VK29    | 100 | 15    |
And I save the current editor

# Rechnung ohne Lagerbewegung, aus Auftrag, Teilmenge
Given I open an editor "RE1-29AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "29AUF"
And I set fields
   | nummer | 1VKRE29   |
   | such   | RE1-29AUF |
   | ueb    | ja        |
   | fakt   | nein      |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "70" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein 1 aus Auftrag, Teilmenge
Given I open an editor "LS1-29AUF" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "29AUF"
And I set fields
   | nummer | 1VKLS29   |
   | such   | LS1-29AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "11" in row 1
And I save the current editor

# Journaleintraege zum Lieferschein 1
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==VK29;buarta==Abgang;mge==11;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | VK29                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 11                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

Given I open an editor "RE1-29AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE1-29AUF"
And I save value from field "id" in row 1
And I close the current editor

# Bewertungen zum Lieferschein 1
Given I open latest Valuation "BewertungAb1.1" for Product "VK29" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 11                    |
Then field "tmge" has value "11" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

# Komplettwertgutschrift zu Rechnung buchen
Given I open an editor "WERT-RE1-29AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1-29AUF"
And I set fields
    | nummer | 3WERTRE1   |
    | such   | VK2WERT29  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -70   | 15.00     | -1050.00  |
And I save the current editor

# Bewertungen zum Lieferschein 1, nach der Komplettwertgutschrift, vkpos ist leer
Given I open latest Valuation "BewertungAb1.2" for Product "VK29" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 11                    |
    | vorgaenger^id | !BewertungAb1.1^id    |
Then table has values
    | tmge | vkpos   |
    | 11   |         |
And I close the current editor

# Lieferschein aus Auftrag, Teilmenge
Given I open an editor "LS2-29AUF" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "29AUF"
And I set fields
   | nummer | 1VKLS228  |
   | such   | LS2-28AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "22" in row 1
And I save the current editor

# Journaleintraege zum Lieferschein 2
Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==VK29;buarta==Abgang;mge==22;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | VK29                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 22                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

# Bewertungen zum Lieferschein 2, nach der Komplettwertgutschrift, vkpos ist leer
Given I open latest Valuation "BewertungAb2.1" for Product "VK29" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 22                    |
    | vorgaenger    |                       |
Then table has values
    | tmge | vkpos   |
    | 22   |         |
And I close the current editor

# Lieferschein 3 aus Auftrag, Teilmenge
Given I open an editor "LS3-29AUF" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "29AUF"
And I set fields
   | nummer | 1VKLS328  |
   | such   | LS3-28AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "33" in row 1
And I save the current editor

# Journaleintraege zum Lieferschein 3
Given I open an editor "JournalAb3" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==VK29;buarta==Abgang;mge==33;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | VK29                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 33                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

# Bewertungen zum Lieferschein 3, nach der Komplettwertgutschrift, vkpos ist leer
Given I open latest Valuation "BewertungAb3.1" for Product "VK29" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 33                    |
    | vorgaenger    |                       |
Then table has values
    | tmge | vkpos   |
    | 33   |         |
And I close the current editor

# Rechnungskorrektur aus dem Auftrag erstellen und buchen
Given I open an editor "KORR-RE1-29AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "29AUF"
And I set fields
    | nummer | 3KORR1     |
    | such   | VK1KORR29  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then field "rekorrektur" has value "ja" in row 1
And I set field "mge" to "70" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Bewertung mit vkpos der Rechnungskorrektur
Given I open an editor "KORR-RE1-29AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+VK1KORR29"
And I save value from field "id" in row 1
And I close the current editor

Given I open latest Valuation "BewertungAb1.3" for Product "VK29" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 11                    |
    | vorgaenger^id | !BewertungAb1.2^id    |
Then field "tmge" has value "11" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

Given I open latest Valuation "BewertungAb2.2" for Product "VK29" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 22                    |
    | vorgaenger^id | !BewertungAb2.1^id    |
Then field "tmge" has value "22" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

Given I open latest Valuation "BewertungAb3.2" for Product "VK29" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 33                    |
    | vorgaenger^id | !BewertungAb3.1^id    |
Then field "tmge" has value "33" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

# Lieferschein 4 aus Auftrag, Teilmenge
Given I open an editor "LS4-29AUF" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "29AUF"
And I set fields
   | nummer | 1VKLS428  |
   | such   | LS4-28AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "10" in row 1
And I save the current editor

# Journaleintraege zum Lieferschein 4
Given I open an editor "JournalAb4" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==VK29;buarta==Abgang;mge==10;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | VK29                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 10                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

# Bewertungen zum Lieferschein 4, nach der RE-Korrektur, 4 Stk vkpos der RE-KORR und 6 St vkpos ist leer
Given I open latest Valuation "BewertungAb4.1" for Product "VK29" and valuation transaction "JournalAb4" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb4^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 10                    |
    | vorgaenger    |                       |
Then field "tmge" has value "4" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "6" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

# Storno der Rechnungskorrektur
Given I open an editor "STORNO-KORR-29AUF" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "KORR-RE1-29AUF"
Then the table has 4 rows
Then table has values
    | !row  | mge   | preis     | pwert     |
    | 1     | -70   | 15.00     | -1050.00  |
And I save the current editor

# Bewertung vkpos leer
Given I open latest Valuation "BewertungAb1.4" for Product "VK29" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id            |
    | beistelldaten | nein                      |
    | stornoverur   |                           |
    | buart         | Abgang                    |
    | ursache       | Lieferschein              |
    | detursache    | Storno-Rechnung Verkauf   |
    | mge           | 11                        |
    | vorgaenger^id | !BewertungAb1.3^id        |
Then table has values
    | tmge | vkpos   |
    | 11   |         |
And I close the current editor

Given I open latest Valuation "BewertungAb2.3" for Product "VK29" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id            |
    | beistelldaten | nein                      |
    | stornoverur   |                           |
    | buart         | Abgang                    |
    | ursache       | Lieferschein              |
    | detursache    | Storno-Rechnung Verkauf   |
    | mge           | 22                        |
    | vorgaenger^id | !BewertungAb2.2^id        |
Then table has values
    | tmge | vkpos   |
    | 22   |         |
And I close the current editor

Given I open latest Valuation "BewertungAb3.3" for Product "VK29" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3^id            |
    | beistelldaten | nein                      |
    | stornoverur   |                           |
    | buart         | Abgang                    |
    | ursache       | Lieferschein              |
    | detursache    | Storno-Rechnung Verkauf   |
    | mge           | 33                        |
    | vorgaenger^id | !BewertungAb3.2^id        |
Then table has values
    | tmge | vkpos   |
    | 33   |         |
And I close the current editor

Given I open latest Valuation "BewertungAb4.2" for Product "VK29" and valuation transaction "JournalAb4" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb4^id            |
    | beistelldaten | nein                      |
    | stornoverur   |                           |
    | buart         | Abgang                    |
    | ursache       | Lieferschein              |
    | detursache    | Storno-Rechnung Verkauf   |
    | mge           | 10                        |
    | vorgaenger^id | !BewertungAb4.1^id        |
Then table has values
    | tmge | vkpos   |
    |  4   |         |
    |  6   |         |
And I close the current editor

# FDA-4499
Scenario: 16 VK - SETARTIKEL Rechnung ohne Lagerbewegung, Teillieferschein, Komplettwertgutschrift, 2 Teillieferscheine, RE-Korrektur, Teillieferschein, Storno RE-Korrektur

Given I open an editor "SET30" from table "(Part):(Product)" with command "STORE" for record "SET30"
And I set fields
    | such      | SET30                 |
    | namebspr  | Setartikel 30         |
    | vpr       | 15                    |
    | epr       | 10.50                 |
    | bsart     | Fremdbeschaffung      |
    | dispoa    | auftragsbezogen       |
    | earta     | über Stückliste       |
    | ekbewverf | 1                     |
And I delete all rows
And I append rows
    | elex      | elanzahl  |
    | EINK      | 10        |
    | BAUT      | 1         |
And I save the current editor

Given I open an editor "AUF30" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 30AUF        |
   | kunde   | 1            |
   | such    | AUF30        |
   | betreff | AUF30-WERT   |
And I append rows
   | artikel | mge | preis |
   | SET30   | 100 | 15    |
And I save the current editor

# Rechnung ohne Lagerbewegung, aus Auftrag, Teilmenge
Given I open an editor "RE1-30AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "30AUF"
And I set fields
   | nummer | 1VKRE30   |
   | such   | RE1-30AUF |
   | ueb    | ja        |
   | fakt   | nein      |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "70" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein 1 aus Auftrag, Teilmenge
Given I open an editor "LS1-30AUF" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "30AUF"
And I set fields
   | nummer | 1VKLS30   |
   | such   | LS1-30AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "11" in row 1
And I save the current editor

# Journaleintraege zum Lieferschein 1, Komponenten EINK und BAUT
Given I open an editor "JournalAb1E" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==EINK;buarta==Abgang;mge==110;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EINK                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 110                   |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

Given I open an editor "JournalAb1B" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==BAUT;buarta==Abgang;mge==11;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | BAUT                  |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 11                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

Given I open an editor "RE1-30AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE1-30AUF"
And I save value from field "id" in row 1
And I close the current editor

# Bewertungen zum Lieferschein 1
Given I open latest Valuation "BewertungAb1E.1" for Product "EINK" and valuation transaction "JournalAb1E" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1E^id       |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 110                   |
Then field "tmge" has value "110" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

Given I open latest Valuation "BewertungAb1B.1" for Product "BAUT" and valuation transaction "JournalAb1B" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1B^id       |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 11                    |
Then field "tmge" has value "11" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

# Komplettwertgutschrift zu Rechnung buchen
Given I open an editor "WERT-RE1-30AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1-30AUF"
And I set fields
    | nummer | 3WERTRE1   |
    | such   | VK2WERT30  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -70   | 15.00     | -1050.00  |
And I save the current editor

# Bewertungen zum Lieferschein 1, nach der Komplettwertgutschrift, vkpos ist leer
Given I open latest Valuation "BewertungAb1E.2" for Product "EINK" and valuation transaction "JournalAb1E" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1E^id       |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 110                   |
    | vorgaenger^id | !BewertungAb1E.1^id   |
    Then table has values
    | tmge | vkpos   |
    | 110  |         |
And I close the current editor

Given I open latest Valuation "BewertungAb1B.2" for Product "BAUT" and valuation transaction "JournalAb1B" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1B^id       |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 11                    |
    | vorgaenger^id | !BewertungAb1B.1^id   |
Then table has values
    | tmge | vkpos   |
    | 11   |         |
And I close the current editor

# Lieferschein 2 aus Auftrag, Teilmenge
Given I open an editor "LS2-30AUF" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "30AUF"
And I set fields
   | nummer | 1VKLS230  |
   | such   | LS2-30AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "22" in row 1
And I save the current editor

# Journaleintraege zum Lieferschein 2
Given I open an editor "JournalAb2E" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==EINK;buarta==Abgang;mge==220;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EINK                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 220                   |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

Given I open an editor "JournalAb2B" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==BAUT;buarta==Abgang;mge==22;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | BAUT                  |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 22                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

# Bewertungen zum Lieferschein 2
Given I open latest Valuation "BewertungAb2E.1" for Product "EINK" and valuation transaction "JournalAb2E" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2E^id       |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 220                   |
Then table has values
    | tmge | vkpos   |
    | 220  |         |
And I close the current editor

Given I open latest Valuation "BewertungAb2B.1" for Product "BAUT" and valuation transaction "JournalAb2B" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2B^id       |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 22                    |
Then table has values
    | tmge | vkpos   |
    | 22   |         |
And I close the current editor

# Lieferschein 3 aus Auftrag, Teilmenge
Given I open an editor "LS3-30AUF" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "30AUF"
And I set fields
   | nummer | 1VKLS330  |
   | such   | LS3-30AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "33" in row 1
And I save the current editor

# Journaleintraege zum Lieferschein 3
Given I open an editor "JournalAb3E" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==EINK;buarta==Abgang;mge==330;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EINK                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 330                   |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

Given I open an editor "JournalAb3B" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==BAUT;buarta==Abgang;mge==33;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | BAUT                  |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 33                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

# Bewertungen zum Lieferschein 3
Given I open latest Valuation "BewertungAb3E.1" for Product "EINK" and valuation transaction "JournalAb3E" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3E^id       |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 330                   |
Then table has values
    | tmge | vkpos   |
    | 330  |         |
And I close the current editor

Given I open latest Valuation "BewertungAb3B.1" for Product "BAUT" and valuation transaction "JournalAb3B" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3B^id       |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 33                    |
Then table has values
    | tmge | vkpos   |
    | 33   |         |
And I close the current editor

# Rechnungskorrektur aus dem Auftrag erstellen und buchen
Given I open an editor "KORR-RE1-30AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "30AUF"
And I set fields
    | nummer | 3KORR1     |
    | such   | VK1KORR30  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then field "rekorrektur" has value "ja" in row 1
And I set field "mge" to "70" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Bewertung mit vkpos der Rechnungskorrektur
Given I open an editor "KORR-RE1-30AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+VK1KORR30"
And I save value from field "id" in row 1
And I close the current editor

Given I open latest Valuation "BewertungAb1E.3" for Product "EINK" and valuation transaction "JournalAb1E" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1E^id       |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 110                   |
    | vorgaenger^id | !BewertungAb1E.2^id   |
Then field "tmge" has value "110" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

Given I open latest Valuation "BewertungAb1B.3" for Product "BAUT" and valuation transaction "JournalAb1B" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1B^id       |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 11                    |
    | vorgaenger^id | !BewertungAb1B.2^id   |
Then field "tmge" has value "11" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

# Bewertungen zum Lieferschein 2
Given I open latest Valuation "BewertungAb2E.2" for Product "EINK" and valuation transaction "JournalAb2E" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2E^id       |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 220                   |
    | vorgaenger^id | !BewertungAb2E.1^id   |
Then field "tmge" has value "220" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

Given I open latest Valuation "BewertungAb2B.2" for Product "BAUT" and valuation transaction "JournalAb2B" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2B^id       |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 22                    |
    | vorgaenger^id | !BewertungAb2B.1^id   |
Then field "tmge" has value "22" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

# Bewertungen zum Lieferschein 3
Given I open latest Valuation "BewertungAb3E.2" for Product "EINK" and valuation transaction "JournalAb3E" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3E^id       |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 330                   |
    | vorgaenger^id | !BewertungAb3E.1^id   |
Then field "tmge" has value "330" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

Given I open latest Valuation "BewertungAb3B.2" for Product "BAUT" and valuation transaction "JournalAb3B" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3B^id       |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 33                    |
    | vorgaenger^id | !BewertungAb3B.1^id   |
Then field "tmge" has value "33" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

# Lieferschein 4 aus Auftrag, Teilmenge
Given I open an editor "LS4-30AUF" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "30AUF"
And I set fields
   | nummer | 1VKLS430  |
   | such   | LS4-30AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "10" in row 1
And I save the current editor

# Journaleintraege zum Lieferschein 4
Given I open an editor "JournalAb4E" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==EINK;buarta==Abgang;mge==100;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EINK                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 100                   |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

Given I open an editor "JournalAb4B" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==BAUT;buarta==Abgang;mge==10;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | BAUT                  |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 10                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

# Bewertungen zum Lieferschein 4
Given I open latest Valuation "BewertungAb4E.1" for Product "EINK" and valuation transaction "JournalAb4E" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb4E^id       |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 100                   |
Then field "tmge" has value "40" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "60" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

Given I open latest Valuation "BewertungAb4B.1" for Product "BAUT" and valuation transaction "JournalAb4B" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb4B^id       |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 10                    |
Then field "tmge" has value "4" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "6" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

# Storno der Rechnungskorrektur
Given I open an editor "STORNO-KORR-30AUF" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "KORR-RE1-30AUF"
Then the table has 4 rows
Then table has values
    | !row  | mge   | preis     | pwert     |
    | 1     | -70   | 15.00     | -1050.00  |
And I save the current editor

# Bewertungen vkpos leer
Given I open latest Valuation "BewertungAb1E.4" for Product "EINK" and valuation transaction "JournalAb1E" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1E^id           |
    | beistelldaten | nein                      |
    | stornoverur   |                           |
    | buart         | Abgang                    |
    | ursache       | Lieferschein              |
    | detursache    | Storno-Rechnung Verkauf   |
    | mge           | 110                       |
    | vorgaenger^id | !BewertungAb1E.3^id       |
Then table has values
    | tmge | vkpos   |
    | 110  |         |
And I close the current editor

Given I open latest Valuation "BewertungAb1B.4" for Product "BAUT" and valuation transaction "JournalAb1B" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1B^id           |
    | beistelldaten | nein                      |
    | stornoverur   |                           |
    | buart         | Abgang                    |
    | ursache       | Lieferschein              |
    | detursache    | Storno-Rechnung Verkauf   |
    | mge           | 11                        |
    | vorgaenger^id | !BewertungAb1B.3^id       |
Then table has values
    | tmge | vkpos   |
    | 11   |         |
And I close the current editor

# Bewertungen zum Lieferschein 2
Given I open latest Valuation "BewertungAb2E.3" for Product "EINK" and valuation transaction "JournalAb2E" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2E^id           |
    | beistelldaten | nein                      |
    | stornoverur   |                           |
    | buart         | Abgang                    |
    | ursache       | Lieferschein              |
    | detursache    | Storno-Rechnung Verkauf   |
    | mge           | 220                       |
    | vorgaenger^id | !BewertungAb2E.2^id       |
Then table has values
    | tmge | vkpos   |
    | 220  |         |
And I close the current editor

Given I open latest Valuation "BewertungAb2B.3" for Product "BAUT" and valuation transaction "JournalAb2B" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2B^id           |
    | beistelldaten | nein                      |
    | stornoverur   |                           |
    | buart         | Abgang                    |
    | ursache       | Lieferschein              |
    | detursache    | Storno-Rechnung Verkauf   |
    | mge           | 22                        |
    | vorgaenger^id | !BewertungAb2B.2^id       |
Then table has values
    | tmge | vkpos   |
    | 22   |         |
And I close the current editor

# Bewertungen zum Lieferschein 3
Given I open latest Valuation "BewertungAb3E.3" for Product "EINK" and valuation transaction "JournalAb3E" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3E^id           |
    | beistelldaten | nein                      |
    | stornoverur   |                           |
    | buart         | Abgang                    |
    | ursache       | Lieferschein              |
    | detursache    | Storno-Rechnung Verkauf   |
    | mge           | 330                       |
    | vorgaenger^id | !BewertungAb3E.2^id       |
Then table has values
    | tmge | vkpos   |
    | 330  |         |
And I close the current editor

Given I open latest Valuation "BewertungAb3B.3" for Product "BAUT" and valuation transaction "JournalAb3B" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3B^id           |
    | beistelldaten | nein                      |
    | stornoverur   |                           |
    | buart         | Abgang                    |
    | ursache       | Lieferschein              |
    | detursache    | Storno-Rechnung Verkauf   |
    | mge           | 33                        |
    | vorgaenger^id | !BewertungAb3B.2^id       |
Then table has values
    | tmge | vkpos   |
    | 33   |         |
And I close the current editor

# Bewertungen zum Lieferschein 4
Given I open latest Valuation "BewertungAb4E.2" for Product "EINK" and valuation transaction "JournalAb4E" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb4E^id           |
    | beistelldaten | nein                      |
    | stornoverur   |                           |
    | buart         | Abgang                    |
    | ursache       | Lieferschein              |
    | detursache    | Storno-Rechnung Verkauf   |
    | mge           | 100                       |
    | vorgaenger^id | !BewertungAb4E.1^id       |
Then table has values
    | tmge | vkpos   |
    | 40   |         |
    | 60   |         |
And I close the current editor

Given I open latest Valuation "BewertungAb4B.2" for Product "BAUT" and valuation transaction "JournalAb4B" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb4B^id           |
    | beistelldaten | nein                      |
    | stornoverur   |                           |
    | buart         | Abgang                    |
    | ursache       | Lieferschein              |
    | detursache    | Storno-Rechnung Verkauf   |
    | mge           | 10                        |
    | vorgaenger^id | !BewertungAb4B.1^id       |
Then table has values
    | tmge | vkpos   |
    | 4    |         |
    | 6    |         |
And I close the current editor


Scenario: 16a VK - SETARTIKEL Lieferschein ohne Auftrag, Teilrechnung, Komplettwertgutschrift, 2 Teilrechnungen, 1 Komplettwertgutschrift

Given I open an editor "SET160" from table "(Part):(Product)" with command "STORE" for record "SET160"
And I set fields
    | such      | SET160                |
    | namebspr  | Setartikel 160        |
    | vpr       | 500                   |
    | bsart     | Eigenfertigung        |
    | dispoa    | auftragsbezogen       |
    | earta     | über Stückliste       |
    | ekbewverf | 1                     |
And I delete all rows
And I append rows
    | elex      | elanzahl  |
    | E3        | 2         |
    | E3        | 1         |
    | E3        | 2         |
And I save the current editor

# Lieferschein ohne Auftrag
Given I open an editor "LS160" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1VKLS160  |
   | such   | LS-160    |
   | kunde  | 1         |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I delete all rows
And I append rows
   | artikel | mge | preis |
   | SET160  | 100 | 500   |
And I save the current editor

# Journaleintraege zu den Set-Entnahmeartikeln
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==E3;buarta==Abgang;mge==200;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | E3                    |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 200                   |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==E3;buarta==Abgang;mge==100;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | E3                    |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 100                   |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

# Menge 200 und Richtung rueckwaerts, Entnahmeartikel E3 ist im Set in zwei Zeilen enthalten
Given I open an editor "JournalAb3" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==E3;buarta==Abgang;mge==200;@richtung=rückwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | E3                    |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 200                   |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

# Rechnung ohne Lagerbewegung, aus Lieferschein, Teilmenge
Given I open an editor "RE1-LS160" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "1VKLS160"
And I set fields
   | nummer | 1VKRE160  |
   | such   | RE1-LS160 |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "20" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE1-LS160" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE1-LS160"
And I save value from field "id" in row 1
And I close the current editor

# Bewertungen zum Lieferschein 1
Given I open latest Valuation "BewertungAb1.1" for Product "E3" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 200                   |
Then field "tmge" has value "40" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "160" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

Given I open latest Valuation "BewertungAb2.1" for Product "E3" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 100                   |
Then field "tmge" has value "20" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "80" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

Given I open latest Valuation "BewertungAb3.1" for Product "E3" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 200                   |
Then field "tmge" has value "40" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "160" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

# Komplettwertgutschrift buchen
Given I open an editor "WERT-RE1-LS160" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1-LS160"
And I set fields
    | nummer | 1WERT160   |
    | such   | V1WERT160  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -20   | 500.00    | -10000.00 |
And I save the current editor

Given I open latest Valuation "BewertungAb1.2" for Product "E3" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 200                   |
    | vorgaenger^id | !BewertungAb1.1^id    |
Then table has values
    | tmge | vkpos   |
    | 40   |         |
    | 160  |         |
And I close the current editor

Given I open latest Valuation "BewertungAb2.2" for Product "E3" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 100                   |
    | vorgaenger^id | !BewertungAb2.1^id    |
Then table has values
    | tmge | vkpos   |
    | 20   |         |
    | 80   |         |
And I close the current editor

Given I open latest Valuation "BewertungAb3.2" for Product "E3" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 200                   |
    | vorgaenger^id | !BewertungAb3.1^id    |
Then table has values
    | tmge | vkpos   |
    | 40   |         |
    | 160  |         |
And I close the current editor

# Rechnung 2 ohne Lagerbewegung, aus Lieferschein, Teilmenge
Given I open an editor "RE2-LS160" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "1VKLS160"
And I set fields
   | nummer | 2VKRE160  |
   | such   | RE2-LS160 |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "30" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE2-LS160" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE2-LS160"
And I save value from field "id" in row 1
And I close the current editor

# Bewertungen zum Lieferschein 1 nach Buchen der Rechnung 2
Given I open latest Valuation "BewertungAb1.3" for Product "E3" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 200                   |
    | vorgaenger^id | !BewertungAb1.2^id    |
Then field "tmge" has value "40" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "20" in row 2
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 2 equals saved value
Then field "tmge" has value "140" in row 3
Then field "vkpos" is empty in row 3
And I close the current editor

Given I open latest Valuation "BewertungAb2.3" for Product "E3" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 100                   |
    | vorgaenger^id | !BewertungAb2.2^id    |
Then field "tmge" has value "20" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "10" in row 2
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 2 equals saved value
Then field "tmge" has value "70" in row 3
Then field "vkpos" is empty in row 3
And I close the current editor

Given I open latest Valuation "BewertungAb3.3" for Product "E3" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 200                   |
    | vorgaenger^id | !BewertungAb3.2^id    |
Then field "tmge" has value "40" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "20" in row 2
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 2 equals saved value
Then field "tmge" has value "140" in row 3
Then field "vkpos" is empty in row 3
And I close the current editor

# Rechnung 3 ohne Lagerbewegung, aus Lieferschein, Teilmenge
Given I open an editor "RE3-LS160" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "1VKLS160"
And I set fields
   | nummer | 3VKRE160  |
   | such   | RE3-LS160 |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE3-LS160" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE3-LS160"
And I save value from field "id" in row 1
And I close the current editor

# Bewertungen zum Lieferschein 1 nach Buchen der Rechnung 3
Given I open latest Valuation "BewertungAb1.4" for Product "E3" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 200                   |
    | vorgaenger^id | !BewertungAb1.3^id    |
Then field "tmge" has value "40" in row 1
# vkpos hat Verweis auf Rechnungsposition RE 2
Then field "vkpos^id" in row 1 has value equal to field "vkpos^id" from editor "BewertungAb1.3" in row 1
Then field "tmge" has value "20" in row 2
# vkpos hat Verweis auf Rechnungsposition RE 2
Then field "vkpos^id" in row 2 has value equal to field "vkpos^id" from editor "BewertungAb1.3" in row 2
Then field "tmge" has value "100" in row 3
# vkpos hat Verweis auf Rechnungsposition RE 3
Then field "vkpos^id" in row 3 equals saved value
Then field "tmge" has value "40" in row 4
Then field "vkpos" is empty in row 4
And I close the current editor

Given I open latest Valuation "BewertungAb2.4" for Product "E3" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 100                   |
    | vorgaenger^id | !BewertungAb2.3^id    |
Then field "tmge" has value "20" in row 1
# vkpos hat Verweis auf Rechnungsposition RE 2
Then field "vkpos^id" in row 1 has value equal to field "vkpos^id" from editor "BewertungAb2.3" in row 1
Then field "tmge" has value "10" in row 2
# vkpos hat Verweis auf Rechnungsposition RE 2
Then field "vkpos^id" in row 2 has value equal to field "vkpos^id" from editor "BewertungAb2.3" in row 2
Then field "tmge" has value "50" in row 3
# vkpos hat Verweis auf Rechnungsposition RE 3
Then field "vkpos^id" in row 3 equals saved value
Then field "tmge" has value "20" in row 4
Then field "vkpos" is empty in row 4
And I close the current editor

Given I open latest Valuation "BewertungAb3.4" for Product "E3" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 200                   |
    | vorgaenger^id | !BewertungAb3.3^id    |
Then field "tmge" has value "40" in row 1
# vkpos hat Verweis auf Rechnungsposition RE 2
Then field "vkpos^id" in row 1 has value equal to field "vkpos^id" from editor "BewertungAb3.3" in row 1
Then field "tmge" has value "20" in row 2
# vkpos hat Verweis auf Rechnungsposition RE 2
Then field "vkpos^id" in row 2 has value equal to field "vkpos^id" from editor "BewertungAb3.3" in row 2
Then field "tmge" has value "100" in row 3
# vkpos hat Verweis auf Rechnungsposition RE 3
Then field "vkpos^id" in row 3 equals saved value
Then field "tmge" has value "40" in row 4
Then field "vkpos" is empty in row 4
And I close the current editor

# Komplettwertgutschrift zu Rechnung 2 buchen
Given I open an editor "WERT-RE2-LS160" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE2-LS160"
And I set fields
    | nummer | 2WERT160   |
    | such   | V2WERT160  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -30   | 500.00    | -15000.00 |
And I save the current editor

Given I open an editor "RE3-LS160" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE3-LS160"
And I save value from field "id" in row 1
And I close the current editor

# Bewertungen zum Lieferschein 1 nach Komplettwertgutschrift der Rechnung 2
Given I open latest Valuation "BewertungAb1.5" for Product "E3" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 200                   |
    | vorgaenger^id | !BewertungAb1.4^id    |
Then table has values
    | !row   | tmge | vkpos   |
    | 1      | 40   |         |
    | 2      | 20   |         |
    | 4      | 40   |         |
Then field "tmge" has value "100" in row 3
# vkpos hat Verweis auf Rechnungsposition RE 3
Then field "vkpos^id" in row 3 equals saved value
And I close the current editor

Given I open latest Valuation "BewertungAb2.5" for Product "E3" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 100                   |
    | vorgaenger^id | !BewertungAb2.4^id    |
Then table has values
    | !row   | tmge | vkpos   |
    | 1      | 20   |         |
    | 2      | 10   |         |
    | 4      | 20   |         |
Then field "tmge" has value "50" in row 3
# vkpos hat Verweis auf Rechnungsposition RE 3
Then field "vkpos^id" in row 3 equals saved value
And I close the current editor

Given I open latest Valuation "BewertungAb3.5" for Product "E3" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 200                   |
    | vorgaenger^id | !BewertungAb3.4^id    |
Then table has values
    | !row   | tmge | vkpos   |
    | 1      | 40   |         |
    | 2      | 20   |         |
    | 4      | 40   |         |
Then field "tmge" has value "100" in row 3
# vkpos hat Verweis auf Rechnungsposition RE 3
Then field "vkpos^id" in row 3 equals saved value
And I close the current editor


Scenario: 24 VK - Auftrag, Lieferschein, Rechnung, Teilwertgutschrift, keine neue Bewertung

Given I open an editor "VK31" from table "(Part):(Product)" with command "STORE" for record "VK31"
And I set fields
    | such      | VK31                 |
    | namebspr  | VK-Teil 31           |
    | vpr       | 15                   |
    | epr       | 10.50                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "AUF31" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 31AUF        |
   | kunde   | 1            |
   | such    | AUF31        |
   | betreff | AUF31-WERT   |
And I append rows
   | artikel | mge | preis |
   | VK31    | 10  | 15    |
And I save the current editor

# Lieferscheine aus Auftrag, Gesamtmenge, Rechnung soll aus Auftrag erzeugt werden
Given I open an editor "LS1-31AUF" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "31AUF"
And I set fields
   | nummer | 1VKLS31   |
   | such   | LS1-31AUF |
   | ueb    | ja        |
   | fakt   | nein      |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "10" in row 1
And I save the current editor

# Journaleintraege zum Lieferschein
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==VK31;buarta==Abgang;platz==F1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | VK31                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 10                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

# Bewertungen zum Lieferschein, vor Erstellung der Rechnung
Given I open latest Valuation "BewertungAb1.1" for Product "VK31" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 10                    |
Then table has values
    | tmge | vkpos   |
    | 10   |         |
And I close the current editor

# Rechnung Gesamtmenge buchen
Given I open an editor "RE1-31AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "31AUF"
And I set fields
   | nummer | 1VKRE31   |
   | such   | RE1-31AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "10" in row 1
Then field "preis" has value "15.00" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE1-31AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE1-31AUF"
And I save value from field "id" in row 1
And I close the current editor

# Bewertungen zum Lieferschein, Nach Buchen der Rechnung
Given I open latest Valuation "BewertungAb1.2" for Product "VK31" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 10                    |
    | vorgaenger^id | !BewertungAb1.1^id    |
Then field "tmge" has value "10" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

# Teilwertgutschrift zur Rechnung erstellen und buchen
Given I open an editor "WERT-RE1-31AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1-31AUF"
And I set fields
    | nummer | 1TEILWG    |
    | such   | VK1WERT31  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
And I press button "buwertgutschrift"
And I set field "mge" to "-2" in row 1
And I set field "preis" to "10" in row 1
Then table has values
    | mge   | preis     | pwert     |
    | -2    | 10.00     | -20.00    |
And I save the current editor

# Bewertung nach der Teilwertgutschrift, vkpos bleibt gefuellt, Bewertung hat sich nicht geaendert
Given I open latest Valuation "BewertungAb1.3" for Product "VK31" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 10                    |
    | vorgaenger^id | !BewertungAb1.1^id    |
Then field "tmge" has value "10" in row 1
# vkpos hat Verweis auf Rechnungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "vkpos^id" in row 1 has value equal to field "vkpos^id" from editor "BewertungAb1.2" in row 1
And I close the current editor


Scenario: 32 VK - Rechnung ohne Lagerbewegung - Auftrag, Lieferschein, Rechnung, Teilwertgutschrift, Storno Teilwertgutschrift

Given I open an editor "VK32" from table "(Part):(Product)" with command "STORE" for record "VK32"
And I set fields
    | such      | VK32                 |
    | namebspr  | VK-Teil 32           |
    | vpr       | 15                   |
    | epr       | 10.50                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "AUF32" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 32AUF        |
   | kunde   | 1            |
   | such    | AUF32        |
   | betreff | AUF32-WERT   |
And I append rows
   | artikel | mge | preis |
   | VK32    | 20  | 25    |
And I save the current editor

# Lieferschein aus Auftrag, komplette Menge, Rechnung soll aus Auftrag erzeugt werden
Given I open an editor "LS-32AUF" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "32AUF"
And I set fields
   | nummer | 1VKLS32   |
   | such   | LS-32AUF  |
   | ueb    | ja        |
   | fakt   | nein      |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "20" in row 1
And I save the current editor

# Journaleintrag zum Lieferschein
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==VK32;buarta==Abgang;platz==F1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | VK32                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 20                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

# Bewertung zum Lieferschein, vor Erstellung der Rechnungen
Given I open latest Valuation "BewertungAb1.1" for Product "VK32" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 20                    |
Then table has values
    | tmge | vkpos   |
    | 20   |         |
And I close the current editor

# Rechnung komplette Menge buchen
Given I open an editor "RE1-32AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "32AUF"
And I set fields
   | nummer | 1VKRE32   |
   | such   | RE1-32AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "20" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE1-32AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE1-32AUF"
And I save value from field "id" in row 1
And I close the current editor

# Bewertung zum Lieferschein, Nach Buchen der Rechnung
Given I open latest Valuation "BewertungAb1.2" for Product "VK32" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 20                    |
    | vorgaenger^id | !BewertungAb1.1^id    |
Then field "tmge" has value "20" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

# Teilwertgutschrift zu Rechnung buchen
Given I open an editor "WERT-RE1-32AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1-32AUF"
And I set fields
    | nummer | 1WERTRE2   |
    | such   | VK1WERT32  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis    |
    | 1     | -10   | 2.00     |
And I save the current editor

# Bewertung nach der Teilwertgutschrift zu Rechnung, KEINE neue Bewertung, vkpos bleibt
Given I open latest Valuation "BewertungAb1.3" for Product "VK32" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 20                    |
    | vorgaenger^id | !BewertungAb1.1^id    |
Then field "tmge" has value "20" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 has value equal to field "vkpos^id" from editor "BewertungAb1.2" in row 1
And I close the current editor

# Storno Teilwertgutschrift
Given I open an editor "STORNO-TWG" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "WERT-RE1-32AUF"
And I save the current editor

# Bewertung bleibt nach Storno, wie nach der Teilwertgutschrift zu Rechnung, vkpos bleibt, gleicher Vorgaenger
Given I open latest Valuation "BewertungAb1.4" for Product "VK32" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 20                    |
    | vorgaenger^id | !BewertungAb1.1^id    |
Then field "tmge" has value "20" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 has value equal to field "vkpos^id" from editor "BewertungAb1.2" in row 1
And I close the current editor


Scenario: 33 VK - AU, LS, RE aus LS, Komplettwertgutschrift, RE2 aus LS kleinere Menge, Komplettwertgutschrift, RE3 aus LS kleinere Menge, Komplettwertgutschrift

Given I open an editor "VK33" from table "(Part):(Product)" with command "STORE" for record "VK33"
And I set fields
    | such      | VK33                 |
    | namebspr  | VK-Teil 33           |
    | vpr       | 15                   |
    | epr       | 10.50                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "AUF33" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 33AUF        |
   | kunde   | 1            |
   | such    | AUF33        |
   | betreff | AUF33-WERT   |
And I append rows
   | artikel | mge | preis |
   | VK33    | 200 | 20    |
And I save the current editor

# Lieferschein aus Auftrag, komplette Menge, Rechnung soll aus Lieferschein erzeugt werden
Given I open an editor "LS-33AUF" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "33AUF"
And I set fields
   | nummer | 1VKLS33   |
   | such   | LS-33AUF  |
   | ueb    | ja        |
   | fakt   | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "150" in row 1
And I save the current editor

# Journaleintrag zum Lieferschein
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==VK33;buarta==Abgang;platz==F1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | VK33                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 150                   |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

# Bewertung zum Lieferschein, vor Erstellung der Rechnungen
Given I open latest Valuation "BewertungAb1.1" for Product "VK33" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 150                   |
Then table has values
    | tmge | vkpos   |
    | 150  |         |
And I close the current editor

# Rechnung 1 Teilmenge buchen
Given I open an editor "RE1-33AUF" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "1VKLS33"
And I set fields
   | nummer | 1VKRE133  |
   | such   | RE1-33AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "140" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE1-33AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE1-33AUF"
And I save value from field "id" in row 1
And I close the current editor

# Bewertung zum Lieferschein, Nach Buchen der Rechnung
Given I open latest Valuation "BewertungAb1.2" for Product "VK33" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 150                   |
    | vorgaenger^id | !BewertungAb1.1^id    |
Then field "tmge" has value "140" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "10" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

# Komplettwertgutschrift zu Rechnung buchen
Given I open an editor "KWG-RE1-33AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1-33AUF"
And I set fields
    | nummer | 1KWG33R1   |
    | such   | VK1KWG33   |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -140  | 20.00     | -2800.00  |
And I save the current editor

# Bewertung nach der Komplettwertgutschrift zu Rechnung 1, vkpos leer
Given I open latest Valuation "BewertungAb1.3" for Product "VK33" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 150                   |
    | vorgaenger^id | !BewertungAb1.2^id    |
Then table has values
    | tmge | vkpos   |
    | 140  |         |
    | 10   |         |
And I close the current editor

# Rechnung 2 buchen, kleinere Menge als in RE 1
Given I open an editor "RE2-33AUF" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "1VKLS33"
And I set fields
   | nummer | 2VKRE233  |
   | such   | RE2-33AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "130" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE2-33AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE2-33AUF"
And I save value from field "id" in row 1
And I close the current editor

# Bewertung zum Lieferschein, Nach Buchen der Rechnung 2
Given I open latest Valuation "BewertungAb1.4" for Product "VK33" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 150                   |
    | vorgaenger^id | !BewertungAb1.3^id    |
Then field "tmge" has value "130" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
Then table has values
    | !row | tmge | vkpos   |
    | 2    | 10   |         |
    | 3    | 10   |         |
And I close the current editor

# Komplettwertgutschrift zu Rechnung 2 buchen
Given I open an editor "KWG-RE2-33AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE2-33AUF"
And I set fields
    | nummer | 2KWG33R2   |
    | such   | VK2KWG33   |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -130  | 20.00     | -2600.00  |
And I save the current editor

# Bewertung nach der Komplettwertgutschrift zu Rechnung 2, vkpos leer
Given I open latest Valuation "BewertungAb1.5" for Product "VK33" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 150                   |
    | vorgaenger^id | !BewertungAb1.4^id    |
Then table has values
    | tmge | vkpos   |
    | 130  |         |
    | 10   |         |
    | 10   |         |
And I close the current editor

# Rechnung 3 buchen, kleinere Menge als in RE 2
Given I open an editor "RE3-33AUF" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "1VKLS33"
And I set fields
   | nummer | 3VKRE333  |
   | such   | RE3-33AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "120" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE3-33AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE3-33AUF"
And I save value from field "id" in row 1
And I close the current editor

# Bewertung zum Lieferschein, Nach Buchen der Rechnung 3
Given I open latest Valuation "BewertungAb1.6" for Product "VK33" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 150                   |
    | vorgaenger^id | !BewertungAb1.5^id    |
Then field "tmge" has value "120" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
Then table has values
    | !row | tmge | vkpos   |
    | 2    | 10   |         |
    | 3    | 10   |         |
    | 4    | 10   |         |
And I close the current editor

# Komplettwertgutschrift zu Rechnung 3 buchen
Given I open an editor "KWG-RE3-33AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE3-33AUF"
And I set fields
    | nummer | 3KWG33R3   |
    | such   | VK3KWG33   |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -120  | 20.00     | -2400.00  |
And I save the current editor

# Bewertung nach der Komplettwertgutschrift zu Rechnung 3, vkpos leer
Given I open latest Valuation "BewertungAb1.7" for Product "VK33" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 150                   |
    | vorgaenger^id | !BewertungAb1.6^id    |
Then table has values
    | tmge | vkpos   |
    | 120  |         |
    | 10   |         |
    | 10   |         |
    | 10   |         |
And I close the current editor

# Storno Komplettwertgutschrift 3
Given I open an editor "STORNO-KWG3" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "KWG-RE3-33AUF"
And I save the current editor

# Bewertung nach Storno, vkpos aus RE 3 fuer 120
Given I open latest Valuation "BewertungAb1.8" for Product "VK33" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 150                   |
    | vorgaenger^id | !BewertungAb1.7^id    |
Then field "tmge" has value "120" in row 1
# vkpos hat Verweis auf Rechungsposition, wie in Bewertung nach Buchen RE 3
Then field "vkpos^id" in row 1 has value equal to field "vkpos^id" from editor "BewertungAb1.6" in row 1
Then table has values
    | !row | tmge | vkpos   |
    | 2    | 10   |         |
    | 3    | 10   |         |
    | 4    | 10   |         |
And I close the current editor


Scenario: 34 VK - AU, LS, RE aus AU, Komplettwertgutschrift, RE2 aus AU kleinere Menge, Komplettwertgutschrift, RE3 aus AU kleinere Menge, Komplettwertgutschrift

Given I open an editor "VK34" from table "(Part):(Product)" with command "STORE" for record "VK34"
And I set fields
    | such      | VK34                 |
    | namebspr  | VK-Teil 34           |
    | vpr       | 15                   |
    | epr       | 10.50                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "AUF34" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 34AUF        |
   | kunde   | 1            |
   | such    | AUF34        |
   | betreff | AUF34-WERT   |
And I append rows
   | artikel | mge | preis |
   | VK34    | 200 | 20    |
And I save the current editor

# Lieferschein aus Auftrag, komplette Menge, Rechnung soll aus Auftrag erzeugt werden
Given I open an editor "LS-34AUF" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "34AUF"
And I set fields
   | nummer | 1VKLS34   |
   | such   | LS-34AUF  |
   | ueb    | ja        |
   | fakt   | nein      |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "180" in row 1
And I save the current editor

# Journaleintrag zum Lieferschein
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==VK34;buarta==Abgang;platz==F1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | VK34                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 180                   |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

# Bewertung zum Lieferschein, vor Erstellung der Rechnungen
Given I open latest Valuation "BewertungAb1.1" for Product "VK34" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 180                   |
Then table has values
    | tmge | vkpos   |
    | 180  |         |
And I close the current editor

# Rechnung 1 buchen (Teilmenge)
Given I open an editor "RE1-34AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "34AUF"
And I set fields
   | nummer | 1VKRE134  |
   | such   | RE1-34AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "150" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE1-34AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE1-34AUF"
And I save value from field "id" in row 1
And I close the current editor

# Bewertung zum Lieferschein, Nach Buchen der Rechnung
Given I open latest Valuation "BewertungAb1.2" for Product "VK34" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 180                   |
    | vorgaenger^id | !BewertungAb1.1^id    |
Then field "tmge" has value "150" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "30" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

# Komplettwertgutschrift zu Rechnung buchen
Given I open an editor "KWG-RE1-34AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1-34AUF"
And I set fields
    | nummer | 1KWG34R1   |
    | such   | VK1KWG34   |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -150  | 20.00     | -3000.00  |
And I save the current editor

# Bewertung nach der Komplettwertgutschrift zu Rechnung 1, vkpos leer
Given I open latest Valuation "BewertungAb1.3" for Product "VK34" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 180                   |
    | vorgaenger^id | !BewertungAb1.2^id    |
Then table has values
    | tmge | vkpos   |
    | 150  |         |
    | 30   |         |
And I close the current editor

# Rechnung 2 buchen, kleinere Menge als in RE 1
Given I open an editor "RE2-34AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "34AUF"
And I set fields
   | nummer | 2VKRE234  |
   | such   | RE2-34AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "130" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE2-34AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE2-34AUF"
And I save value from field "id" in row 1
And I close the current editor

# Bewertung zum Lieferschein, Nach Buchen der Rechnung 2
Given I open latest Valuation "BewertungAb1.4" for Product "VK34" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 180                   |
    | vorgaenger^id | !BewertungAb1.3^id    |
Then field "tmge" has value "130" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
Then table has values
    | !row | tmge | vkpos   |
    | 2    | 20   |         |
    | 3    | 30   |         |
And I close the current editor

# Komplettwertgutschrift zu Rechnung 2 buchen
Given I open an editor "KWG-RE2-34AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE2-34AUF"
And I set fields
    | nummer | 2KWG34R2   |
    | such   | VK2KWG34   |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -130  | 20.00     | -2600.00  |
And I save the current editor

# Bewertung nach der Komplettwertgutschrift zu Rechnung 2, vkpos leer
Given I open latest Valuation "BewertungAb1.5" for Product "VK34" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 180                   |
    | vorgaenger^id | !BewertungAb1.4^id    |
Then table has values
    | tmge | vkpos   |
    | 130  |         |
    | 20   |         |
    | 30   |         |
And I close the current editor

# Rechnung 3 buchen, kleinere Menge als in RE 2
Given I open an editor "RE3-34AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "34AUF"
And I set fields
   | nummer | 3VKRE343  |
   | such   | RE3-34AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "120" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE3-34AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE3-34AUF"
And I save value from field "id" in row 1
And I close the current editor

# Bewertung zum Lieferschein, Nach Buchen der Rechnung 3
Given I open latest Valuation "BewertungAb1.6" for Product "VK34" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 180                   |
    | vorgaenger^id | !BewertungAb1.5^id    |
Then field "tmge" has value "120" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
Then table has values
    | !row | tmge | vkpos   |
    | 2    | 10   |         |
    | 3    | 20   |         |
    | 4    | 30   |         |
And I close the current editor

# Komplettwertgutschrift zu Rechnung 3 buchen
Given I open an editor "KWG-RE3-34AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE3-34AUF"
And I set fields
    | nummer | 3KWG34R3   |
    | such   | VK3KWG34   |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -120  | 20.00     | -2400.00  |
And I save the current editor

# Bewertung nach der Komplettwertgutschrift zu Rechnung 3, vkpos leer
Given I open latest Valuation "BewertungAb1.7" for Product "VK34" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 180                   |
    | vorgaenger^id | !BewertungAb1.6^id    |
Then table has values
    | tmge | vkpos   |
    | 120  |         |
    | 10   |         |
    | 20   |         |
    | 30   |         |
And I close the current editor

# Storno Komplettwertgutschrift 3
Given I open an editor "STORNO-KWG3" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "KWG-RE3-34AUF"
And I save the current editor

# Bewertung nach Storno, vkpos aus RE 3 fuer 120
Given I open latest Valuation "BewertungAb1.8" for Product "VK34" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 180                   |
    | vorgaenger^id | !BewertungAb1.7^id    |
Then field "tmge" has value "120" in row 1
# vkpos hat Verweis auf Rechungsposition, wie in Bewertung nach Buchen RE 3
Then field "vkpos^id" in row 1 has value equal to field "vkpos^id" from editor "BewertungAb1.6" in row 1
Then table has values
    | !row | tmge | vkpos   |
    | 2    | 10   |         |
    | 3    | 20   |         |
    | 4    | 30   |         |
And I close the current editor


Scenario: 35 VK - AU, RE mit Lagerbewegung, Komplettwertgutschrift, RE2 aus AU kleinere Menge, Komplettwertgutschrift, RE3 aus AU kleinere Menge, Komplettwertgutschrift

Given I open an editor "VK35" from table "(Part):(Product)" with command "STORE" for record "VK35"
And I set fields
    | such      | VK35                 |
    | namebspr  | VK-Teil 35           |
    | vpr       | 15                   |
    | epr       | 10.50                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "AUF35" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 35AUF        |
   | kunde   | 1            |
   | such    | AUF35        |
   | betreff | AUF35-WERT   |
And I append rows
   | artikel | mge | preis |
   | VK35    | 200 | 20    |
And I save the current editor

# Rechnung mit Lagerbewegung buchen (Teilmenge)
Given I open an editor "RE1-35AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "35AUF"
And I set fields
   | nummer | 1VKRE135  |
   | such   | RE1-35AUF |
   | ueb    | ja        |
   | fakt   | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "150" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE1-35AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE1-35AUF"
And I save value from field "id" in row 1
And I close the current editor

# Journaleintrag zum Abgang durch Rechnung
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==VK35;buarta==Abgang;platz==F1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | VK35                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 150                   |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
And I close the current editor

# Bewertung zur Rechnung
Given I open latest Valuation "BewertungAb1.1" for Product "VK35" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 150                   |
Then field "tmge" has value "150" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor

# Komplettwertgutschrift zu Rechnung buchen
Given I open an editor "KWG-RE1-35AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1-35AUF"
And I set fields
    | nummer | 1KWG35R1   |
    | such   | VK1KWG35   |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -150  | 20.00     | -3000.00  |
And I save the current editor

# Bewertung nach der Komplettwertgutschrift zu Rechnung 1, vkpos leer
Given I open latest Valuation "BewertungAb1.2" for Product "VK35" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 150                   |
    | vorgaenger^id | !BewertungAb1.1^id    |
Then table has values
    | tmge | vkpos   |
    | 150  |         |
And I close the current editor

# Rechnungskorrektur buchen, kleinere Menge als in RE 1
Given I open an editor "KORR1-35AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1-35AUF"
And I set fields
    | nummer | 3KORR135   |
    | such   | VK1KORR35  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
And I press button "burekorrektur"
And I set field "mge" to "120" in row 1
And I save the current editor

Given I open an editor "KORR1-35AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+VK1KORR35"
And I save value from field "id" in row 1
And I close the current editor

# Bewertung hat 2 Zeilen, Menge 120 mit vkpos der RE-Korr und Menge 30 vkpos leer
Given I open latest Valuation "BewertungAb1.3" for Product "VK35" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 150                   |
    | vorgaenger^id | !BewertungAb1.2^id    |
Then field "tmge" has value "120" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
Then table has values
    | !row  | tmge | vkpos   |
    | 2     | 30   |         |
And I close the current editor

# Komplettwertgutschrift zu Rechnungskorrektur buchen
Given I open an editor "KWG-KORR1-35AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "KORR1-35AUF"
And I set fields
    | nummer | 1KWG35K1   |
    | such   | KO1KWG35   |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -120  | 20.00     | -2400.00  |
And I save the current editor

# Bewertung hat 2 Zeilen, Menge 120 und Menge 30 vkpos leer
Given I open latest Valuation "BewertungAb1.4" for Product "VK35" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 150                   |
    | vorgaenger^id | !BewertungAb1.3^id    |
Then table has values
    | !row  | tmge | vkpos   |
    | 1     | 120  |         |
    | 2     | 30   |         |
And I close the current editor

# Rechnungskorrektur 2 buchen, kleinere Menge als in RE-KORR 1
Given I open an editor "KORR2-35AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1-35AUF"
And I set fields
    | nummer | 3KORR235   |
    | such   | VK2KORR35  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
And I press button "burekorrektur"
And I set field "mge" to "110" in row 1
And I save the current editor

Given I open an editor "KORR2-35AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+3KORR235"
And I save value from field "id" in row 1
And I close the current editor

# Bewertung hat 3 Zeilen, Menge 110 mit vkpos der RE-Korr 2 und Menge 10 und 30 vkpos leer
Given I open latest Valuation "BewertungAb1.5" for Product "VK35" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 150                   |
    | vorgaenger^id | !BewertungAb1.4^id    |
Then field "tmge" has value "110" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
Then table has values
    | !row  | tmge | vkpos   |
    | 2     | 10   |         |
    | 3     | 30   |         |
And I close the current editor

# Komplettwertgutschrift zu Rechnungskorrektur 2 buchen
Given I open an editor "KWG-KORR2-35AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "KORR2-35AUF"
And I set fields
    | nummer | 2KWG35K2   |
    | such   | KO2KWG35   |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -110  | 20.00     | -2200.00  |
And I save the current editor

# Bewertung hat 3 Zeilen, Menge 110, 10 und 30 vkpos leer
Given I open latest Valuation "BewertungAb1.6" for Product "VK35" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 150                   |
    | vorgaenger^id | !BewertungAb1.5^id    |
Then table has values
    | !row  | tmge | vkpos   |
    | 1     | 110  |         |
    | 2     | 10   |         |
    | 3     | 30   |         |
And I close the current editor

# Storno Komplettwertgutschrift zu RE-Korrektur 2
Given I open an editor "STORNO-KWG-KORR2" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "KWG-KORR2-35AUF"
And I save the current editor

# Bewertung hat 3 Zeilen, Menge 110 mit vkpos der RE-Korr und Menge 10 und 30 vkpos leer
Given I open latest Valuation "BewertungAb1.7" for Product "VK35" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 150                   |
    | vorgaenger^id | !BewertungAb1.6^id    |
Then field "tmge" has value "110" in row 1
# vkpos hat Verweis auf Rechungsposition der RE-KORR 2
Then field "vkpos^id" in row 1 has value equal to field "vkpos^id" from editor "BewertungAb1.5" in row 1
Then table has values
    | !row  | tmge | vkpos   |
    | 2     | 10   |         |
    | 3     | 30   |         |
And I close the current editor


Scenario: 36 VK - SETARTIKEL AU, LS, RE aus AU, Komplettwertgutschrift, RE2 aus AU kleinere Menge, Komplettwertgutschrift, RE3 aus AU kleinere Menge, Komplettwertgutschrift

Given I open an editor "SET36" from table "(Part):(Product)" with command "STORE" for record "SET36"
And I set fields
    | such      | SET36                 |
    | namebspr  | Setartikel 36         |
    | vpr       | 500                   |
    | bsart     | Eigenfertigung        |
    | dispoa    | auftragsbezogen       |
    | earta     | über Stückliste       |
    | ekbewverf | 1                     |
And I delete all rows
And I append rows
    | elex      | elanzahl  |
    | TEST      | 2         |
    | TEST      | 1         |
    | TEST      | 2         |
And I save the current editor

Given I open an editor "AUF36" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 36AUF        |
   | kunde   | 1            |
   | such    | AUF36        |
   | betreff | AUF36-WERT   |
And I append rows
   | artikel | mge | preis |
   | SET36   | 200 | 20    |
And I save the current editor

# Lieferschein aus Auftrag, komplette Menge, Rechnung soll aus Auftrag erzeugt werden
Given I open an editor "LS-36AUF" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "36AUF"
And I set fields
   | nummer | 1VKLS36   |
   | such   | LS-36AUF  |
   | ueb    | ja        |
   | fakt   | nein      |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "100" in row 1
And I save the current editor

# Journaleintraege zu den Set-Entnahmeartikeln
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==TEST;buarta==Abgang;mge==200;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TEST                  |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 200                   |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==TEST;buarta==Abgang;mge==100;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TEST                  |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 100                   |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

# Menge 200 und Richtung rueckwaerts (Entnahmeartikel TEST zwei Zeilen mit gleicher Anzahl im Set enthalten)
Given I open an editor "JournalAb3" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==TEST;buarta==Abgang;mge==200;@richtung=rückwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TEST                  |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 200                   |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

# Bewertung zum Lieferschein, vor Erstellung der Rechnungen
Given I open latest Valuation "BewertungAb1.1" for Product "TEST" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 200                   |
Then table has values
    | tmge | vkpos   |
    | 200  |         |
And I close the current editor

Given I open latest Valuation "BewertungAb2.1" for Product "TEST" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 100                   |
Then table has values
    | tmge | vkpos   |
    | 100  |         |
And I close the current editor

Given I open latest Valuation "BewertungAb3.1" for Product "TEST" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 200                   |
Then table has values
    | tmge | vkpos   |
    | 200  |         |
And I close the current editor

# Rechnung 1 buchen (Teilmenge)
Given I open an editor "RE1-36AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "36AUF"
And I set fields
   | nummer | 1VKRE136  |
   | such   | RE1-36AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "80" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE1-36AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE1-36AUF"
And I save value from field "id" in row 1
And I close the current editor

# Bewertung zum Lieferschein, Nach Buchen der Rechnung
Given I open latest Valuation "BewertungAb1.2" for Product "TEST" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 200                   |
    | vorgaenger^id | !BewertungAb1.1^id    |
Then field "tmge" has value "160" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "40" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

Given I open latest Valuation "BewertungAb2.2" for Product "TEST" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 100                   |
    | vorgaenger^id | !BewertungAb2.1^id    |
Then field "tmge" has value "80" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "20" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

Given I open latest Valuation "BewertungAb3.2" for Product "TEST" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 200                   |
    | vorgaenger^id | !BewertungAb3.1^id    |
Then field "tmge" has value "160" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "40" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

# Komplettwertgutschrift zu Rechnung buchen
Given I open an editor "KWG-RE1-36AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1-36AUF"
And I set fields
    | nummer | 1KWG36R1   |
    | such   | VK1KWG36   |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -80   | 20.00     | -1600.00  |
And I save the current editor

# Bewertung nach der Komplettwertgutschrift zu Rechnung 1, vkpos leer
Given I open latest Valuation "BewertungAb1.3" for Product "TEST" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 200                   |
    | vorgaenger^id | !BewertungAb1.2^id    |
Then table has values
    | tmge | vkpos   |
    | 160  |         |
    | 40   |         |
And I close the current editor

Given I open latest Valuation "BewertungAb2.3" for Product "TEST" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 100                   |
    | vorgaenger^id | !BewertungAb2.2^id    |
Then table has values
    | tmge | vkpos   |
    | 80   |         |
    | 20   |         |
And I close the current editor

Given I open latest Valuation "BewertungAb3.3" for Product "TEST" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 200                   |
    | vorgaenger^id | !BewertungAb3.2^id    |
Then table has values
    | tmge | vkpos   |
    | 160  |         |
    | 40   |         |
And I close the current editor

# Rechnung 2 buchen, kleinere Menge als in RE 1
Given I open an editor "RE2-36AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "36AUF"
And I set fields
   | nummer | 2VKRE236  |
   | such   | RE2-36AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "70" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE2-36AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE2-36AUF"
And I save value from field "id" in row 1
And I close the current editor

Given I open latest Valuation "BewertungAb1.4" for Product "TEST" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 200                   |
    | vorgaenger^id | !BewertungAb1.3^id    |
Then field "tmge" has value "140" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
Then table has values
    | !row | tmge | vkpos   |
    | 2    | 20   |         |
    | 3    | 40   |         |
And I close the current editor

Given I open latest Valuation "BewertungAb2.4" for Product "TEST" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 100                   |
    | vorgaenger^id | !BewertungAb2.3^id    |
Then field "tmge" has value "70" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
Then table has values
    | !row | tmge | vkpos   |
    | 2    | 10   |         |
    | 3    | 20   |         |
And I close the current editor

Given I open latest Valuation "BewertungAb3.4" for Product "TEST" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 200                   |
    | vorgaenger^id | !BewertungAb3.3^id    |
Then field "tmge" has value "140" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
Then table has values
    | !row | tmge | vkpos   |
    | 2    | 20   |         |
    | 3    | 40   |         |
And I close the current editor

# Komplettwertgutschrift zu Rechnung 2 buchen
Given I open an editor "KWG-RE2-36AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE2-36AUF"
And I set fields
    | nummer | 2KWG36R2   |
    | such   | VK2KWG36   |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -70   | 20.00     | -1400.00  |
And I save the current editor

Given I open latest Valuation "BewertungAb1.5" for Product "TEST" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 200                   |
    | vorgaenger^id | !BewertungAb1.4^id    |
Then table has values
    | tmge | vkpos   |
    | 140  |         |
    | 20   |         |
    | 40   |         |
And I close the current editor

Given I open latest Valuation "BewertungAb2.5" for Product "TEST" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 100                   |
    | vorgaenger^id | !BewertungAb2.4^id    |
Then table has values
    | tmge | vkpos   |
    | 70   |         |
    | 10   |         |
    | 20   |         |
And I close the current editor

Given I open latest Valuation "BewertungAb3.5" for Product "TEST" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 200                   |
    | vorgaenger^id | !BewertungAb3.4^id    |
Then table has values
    | tmge | vkpos   |
    | 140  |         |
    | 20   |         |
    | 40   |         |
And I close the current editor

# Rechnung 3 buchen, kleinere Menge als in RE 2
Given I open an editor "RE3-36AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "36AUF"
And I set fields
   | nummer | 3VKRE363  |
   | such   | RE3-36AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE3-36AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+RE3-36AUF"
And I save value from field "id" in row 1
And I close the current editor

Given I open latest Valuation "BewertungAb1.6" for Product "TEST" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 200                   |
    | vorgaenger^id | !BewertungAb1.5^id    |
Then field "tmge" has value "100" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
Then table has values
    | !row | tmge | vkpos   |
    | 2    | 40   |         |
    | 3    | 20   |         |
    | 4    | 40   |         |
And I close the current editor

Given I open latest Valuation "BewertungAb2.6" for Product "TEST" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 100                   |
    | vorgaenger^id | !BewertungAb2.5^id    |
Then field "tmge" has value "50" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
Then table has values
    | !row | tmge | vkpos   |
    | 2    | 20   |         |
    | 3    | 10   |         |
    | 2    | 20   |         |
And I close the current editor

Given I open latest Valuation "BewertungAb3.6" for Product "TEST" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 200                   |
    | vorgaenger^id | !BewertungAb3.5^id    |
Then field "tmge" has value "100" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
Then table has values
    | !row | tmge | vkpos   |
    | 2    | 40   |         |
    | 3    | 20   |         |
    | 4    | 40   |         |
And I close the current editor

# Komplettwertgutschrift zu Rechnung 3 buchen
Given I open an editor "KWG-RE3-36AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE3-36AUF"
And I set fields
    | nummer | 3KWG36R3   |
    | such   | VK3KWG36   |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -50   | 20.00     | -1000.00  |
And I save the current editor

Given I open latest Valuation "BewertungAb1.7" for Product "TEST" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 200                   |
    | vorgaenger^id | !BewertungAb1.6^id    |
Then table has values
    | tmge | vkpos   |
    | 100  |         |
    | 40   |         |
    | 20   |         |
    | 40   |         |
And I close the current editor

Given I open latest Valuation "BewertungAb2.7" for Product "TEST" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 100                   |
    | vorgaenger^id | !BewertungAb2.6^id    |
Then table has values
    | tmge | vkpos   |
    | 50   |         |
    | 20   |         |
    | 10   |         |
    | 20   |         |
And I close the current editor

Given I open latest Valuation "BewertungAb3.7" for Product "TEST" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 200                   |
    | vorgaenger^id | !BewertungAb3.6^id    |
Then table has values
    | tmge | vkpos   |
    | 100  |         |
    | 40   |         |
    | 20   |         |
    | 40   |         |
And I close the current editor

# Storno Komplettwertgutschrift 3
Given I open an editor "STORNO-KWG3" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "KWG-RE3-36AUF"
And I save the current editor

# Bewertung nach Storno, vkpos aus RE 3 fuer 100 bzw. 200
Given I open latest Valuation "BewertungAb1.8" for Product "TEST" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 200                   |
    | vorgaenger^id | !BewertungAb1.7^id    |
Then field "tmge" has value "100" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 has value equal to field "vkpos^id" from editor "BewertungAb1.6" in row 1
Then table has values
    | !row | tmge | vkpos   |
    | 2    | 40   |         |
    | 3    | 20   |         |
    | 4    | 40   |         |
And I close the current editor

Given I open latest Valuation "BewertungAb2.8" for Product "TEST" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 100                   |
    | vorgaenger^id | !BewertungAb2.7^id    |
Then field "tmge" has value "50" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 has value equal to field "vkpos^id" from editor "BewertungAb1.6" in row 1
Then table has values
    | !row | tmge | vkpos   |
    | 2    | 20   |         |
    | 3    | 10   |         |
    | 2    | 20   |         |
And I close the current editor

Given I open latest Valuation "BewertungAb3.8" for Product "TEST" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 200                   |
    | vorgaenger^id | !BewertungAb3.7^id    |
Then field "tmge" has value "100" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 has value equal to field "vkpos^id" from editor "BewertungAb1.6" in row 1
Then table has values
    | !row | tmge | vkpos   |
    | 2    | 40   |         |
    | 3    | 20   |         |
    | 4    | 40   |         |
And I close the current editor


Scenario: 37 VK - AU, RE aus AU, Komplettwertgutschrift, Storno Wertgutschrift, Lieferschein

Given I open an editor "VK37" from table "(Part):(Product)" with command "STORE" for record "VK37"
And I set fields
    | such      | VK37                 |
    | namebspr  | VK-Teil 37           |
    | vpr       | 15                   |
    | epr       | 10.50                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "AUF37" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 37AUF        |
   | kunde   | 1            |
   | such    | AUF37        |
   | betreff | AUF37-WERT   |
And I append rows
   | artikel | mge | preis |
   | VK37    | 100 | 25    |
And I save the current editor

# Rechnung aus Auftrag erstellen und buchen, Gesamtmenge
Given I open an editor "RE-37AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "37AUF"
And I set fields
   | nummer | 1VKRE37   |
   | such   | RE-37AUF  |
   | ueb    | ja        |
   | fakt   | nein      |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift zu Rechnung buchen
Given I open an editor "KWG-RE-37AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE-37AUF"
And I set fields
    | nummer | 1KWG37RE   |
    | such   | VK1KWG37   |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -100  | 25.00     | -2500.00  |
And I save the current editor

# Storno Komplettwertgutschrift
Given I open an editor "STORNO-KWG" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "KWG-RE-37AUF"
And I save the current editor

# Lieferschein aus Auftrag erstellen und buchen, komplette Menge
Given I open an editor "LS-37AUF" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "37AUF"
And I set fields
   | nummer | 1VKLS37   |
   | such   | LS-37AUF  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
Then field "fakt" has value "nein"
And I set field "mge" to "100" in row 1
And I save the current editor

# Journaleintrag zum Lieferschein
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==VK37;buarta==Abgang;platz==F1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | VK37                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 100                   |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

Given I open an editor "RE-37AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+1VKRE37"
And I save value from field "id" in row 1
And I close the current editor

# Bewertung zum Lieferschein
Given I open latest Valuation "BewertungAb1.1" for Product "VK37" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 100                   |
    | vorgaenger    |                       |
Then field "tmge" has value "100" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor


Scenario: 38 VK - AU, RE aus AU, Teilwertgutschrift, Storno Wertgutschrift, Lieferschein

Given I open an editor "VK38" from table "(Part):(Product)" with command "STORE" for record "VK38"
And I set fields
    | such      | VK38                 |
    | namebspr  | VK-Teil 38           |
    | vpr       | 15                   |
    | epr       | 10.50                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "AUF38" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 38AUF        |
   | kunde   | 1            |
   | such    | AUF38        |
   | betreff | AUF38-WERT   |
And I append rows
   | artikel | mge | preis  |
   | VK38    | 100 | 25     |
And I save the current editor

# Rechnung aus Auftrag erstellen und buchen, Gesamtmenge
Given I open an editor "RE-38AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "38AUF"
And I set fields
   | nummer | 1VKRE38   |
   | such   | RE-38AUF  |
   | ueb    | ja        |
   | fakt   | nein      |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift zu Rechnung buchen
Given I open an editor "TWG-RE-38AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE-38AUF"
And I set fields
    | nummer | 1TWG38RE   |
    | such   | VK1TWG38   |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis    |
    | 1     | -10   | 5.00     |
And I save the current editor

# Storno Teilwertgutschrift
Given I open an editor "STORNO-TWG" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "TWG-RE-38AUF"
And I save the current editor

# Lieferschein aus Auftrag erstellen und buchen, komplette Menge
Given I open an editor "LS-38AUF" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "38AUF"
And I set fields
   | nummer | 1VKLS38   |
   | such   | LS-38AUF  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
Then field "fakt" has value "nein"
And I set field "mge" to "100" in row 1
And I save the current editor

# Journaleintrag zum Lieferschein
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==VK38;buarta==Abgang;platz==F1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | VK38                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 100                   |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

Given I open an editor "RE-38AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+1VKRE38"
And I save value from field "id" in row 1
And I close the current editor

# Bewertung zum Lieferschein
Given I open latest Valuation "BewertungAb1.1" for Product "VK38" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 100                   |
    | vorgaenger    |                       |
Then field "tmge" has value "100" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
And I close the current editor


Scenario: 39 VK - AU, Teil-RE aus AU, Teil-LS, Teil-RE, Komplettwertgutschrift, Storno Wertgutschrift, Lieferschein

Given I open an editor "VK39" from table "(Part):(Product)" with command "STORE" for record "VK39"
And I set fields
    | such      | VK39                 |
    | namebspr  | VK-Teil 39           |
    | vpr       | 15                   |
    | epr       | 10.50                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "AUF39" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 39AUF        |
   | kunde   | 1            |
   | such    | AUF39        |
   | betreff | AUF39-WERT   |
And I append rows
   | artikel | mge | preis  |
   | VK39    | 100 | 40     |
And I save the current editor

# Teil-Rechnung 1 aus Auftrag erstellen und buchen
Given I open an editor "RE1-39AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "39AUF"
And I set fields
   | nummer | 1VKRE139  |
   | such   | RE1-39AUF |
   | ueb    | ja        |
   | fakt   | nein      |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "11" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein 1 aus Auftrag erstellen und buchen, Teilmenge
Given I open an editor "LS1-39AUF" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "39AUF"
And I set fields
   | nummer | 1VKLS139  |
   | such   | LS1-39AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
Then field "fakt" has value "nein"
And I set field "mge" to "17" in row 1
And I save the current editor

# Journaleintrag zum Lieferschein 1
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==VK39;buarta==Abgang;platz==F1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | VK39                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 17                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

Given I open an editor "RE1-39AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+1VKRE139"
And I save value from field "id" in row 1
And I close the current editor

# Bewertung zum Lieferschein 1
Given I open latest Valuation "BewertungAb1.1" for Product "VK39" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 17                    |
    | vorgaenger    |                       |
Then field "tmge" has value "11" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "6" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

# Teil-Rechnung 2 aus Auftrag erstellen und buchen
Given I open an editor "RE2-39AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "39AUF"
And I set fields
   | nummer | 1VKRE239  |
   | such   | RE2-39AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
Then field "fakt" has value "nein"
And I set field "mge" to "22" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift zu Rechnung 2 buchen
Given I open an editor "KWG-RE2-39AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE2-39AUF"
And I set fields
    | nummer | 1KWG39R2   |
    | such   | VK1KWG39   |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert    |
    | -22   | 40.00     | -880.00  |
And I save the current editor

# Storno Komplettwertgutschrift
Given I open an editor "STORNO-KWG" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "KWG-RE2-39AUF"
And I save the current editor

# Lieferschein 2 aus Auftrag erstellen und buchen, Teilmenge
Given I open an editor "LS2-39AUF" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "39AUF"
And I set fields
   | nummer | 1VKLS239  |
   | such   | LS2-39AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
Then field "fakt" has value "nein"
And I set field "mge" to "22" in row 1
And I save the current editor

# Journaleintrag zum Lieferschein 2
Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==VK39;mge==22;buarta==Abgang;platz==F1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | VK39                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 22                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

Given I open an editor "RE2-39AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+1VKRE239"
And I save value from field "id" in row 1
And I close the current editor

# Bewertung zum Lieferschein 2
Given I open latest Valuation "BewertungAb2.1" for Product "VK39" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 22                    |
    | vorgaenger    |                       |
Then field "tmge" has value "16" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "6" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

# Bewertung zum Lieferschein 1, Teilmenge vkpos aus RE 1 und Restmenge vkpos aus RE 2 (das ist die vierte Bewertungen)
Given I open latest Valuation "BewertungAb1.2" for Product "VK39" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 17                    |
Then field "vorgaenger" is not empty
Then field "tmge" has value "11" in row 1
# vkpos hat Verweis auf Rechungsposition aus RE 1, wie in der Vorgaenger-Bewertung
Then field "vkpos^id" in row 1 has value equal to field "vkpos^id" from editor "BewertungAb1.1" in row 1
Then field "tmge" has value "6" in row 2
# vkpos hat Verweis auf Rechungsposition aus RE 2
Then field "vkpos^id" in row 2 equals saved value
And I close the current editor


Scenario: 40 VK - SETARTIKEL AU, Teil-RE aus AU, Teil-LS, Teil-RE, Komplettwertgutschrift, Storno Wertgutschrift, Lieferschein

Given I open an editor "EINK" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such      | EKSET40              |
    | namebspr  | Setkomponente 40     |
    | vpr       | 2                    |
    | epr       | 1                    |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "SET40" from table "(Part):(Product)" with command "STORE" for record "SET40"
And I set fields
    | such      | SET40                 |
    | namebspr  | Setartikel 40         |
    | vpr       | 500                   |
    | bsart     | Eigenfertigung        |
    | dispoa    | auftragsbezogen       |
    | earta     | über Stückliste       |
And I delete all rows
And I append rows
    | elex      | elanzahl  |
    | EKSET40   | 2         |
    | EKSET40   | 1         |
    | EKSET40   | 2         |
And I save the current editor

Given I open an editor "AUF40" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 40AUF        |
   | kunde   | 1            |
   | such    | AUF40        |
   | betreff | AUF40-WERT   |
And I append rows
   | artikel | mge | preis |
   | SET40   | 100 | 10    |
And I save the current editor

# Teil-Rechnung 1 aus Auftrag erstellen und buchen
Given I open an editor "RE1-40AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "40AUF"
And I set fields
   | nummer | 1VKRE140  |
   | such   | RE1-40AUF |
   | ueb    | ja        |
   | fakt   | nein      |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "11" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein 1 aus Auftrag erstellen und buchen, Teilmenge
Given I open an editor "LS1-40AUF" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "40AUF"
And I set fields
   | nummer | 1VKLS140  |
   | such   | LS1-40AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
Then field "fakt" has value "nein"
And I set field "mge" to "17" in row 1
And I save the current editor

# Journaleintrag 1 zum Lieferschein 1
Given I open an editor "JournalAb11" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==EKSET40;mge==34;buarta==Abgang;platz==F1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EKSET40               |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 34                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

Given I open an editor "JournalAb12" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==EKSET40;mge==17;buarta==Abgang;platz==F1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EKSET40               |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 17                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

Given I open an editor "JournalAb13" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==EKSET40;mge==34;buarta==Abgang;platz==F1;@richtung=rückwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EKSET40               |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 34                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

Given I open an editor "RE1-40AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+1VKRE140"
And I save value from field "id" in row 1
And I close the current editor

# Bewertung zum Lieferschein 1, Abgang 1
Given I open latest Valuation "BewertungAb11.1" for Product "EKSET40" and valuation transaction "JournalAb11" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb11^id       |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 34                    |
    | vorgaenger    |                       |
Then field "tmge" has value "22" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "12" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

# Bewertung zum Lieferschein 1, Abgang 2
Given I open latest Valuation "BewertungAb12.1" for Product "EKSET40" and valuation transaction "JournalAb12" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb12^id       |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 17                    |
    | vorgaenger    |                       |
Then field "tmge" has value "11" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "6" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

# Bewertung zum Lieferschein 1, Abgang 3
Given I open latest Valuation "BewertungAb13.1" for Product "EKSET40" and valuation transaction "JournalAb13" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb13^id       |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 34                    |
    | vorgaenger    |                       |
Then field "tmge" has value "22" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "12" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

# Teil-Rechnung 2 aus Auftrag erstellen und buchen
Given I open an editor "RE2-40AUF" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "40AUF"
And I set fields
   | nummer | 1VKRE240  |
   | such   | RE2-40AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
Then field "fakt" has value "nein"
And I set field "mge" to "22" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift zu Rechnung 2 buchen
Given I open an editor "KWG-RE2-40AUF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE2-40AUF"
And I set fields
    | nummer | 1KWG40R2   |
    | such   | VK1KWG40   |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert    |
    | -22   | 10.00     | -220.00  |
And I save the current editor

# Storno Komplettwertgutschrift
Given I open an editor "STORNO-KWG" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "KWG-RE2-40AUF"
And I save the current editor

# Lieferschein 2 aus Auftrag erstellen und buchen, Teilmenge
Given I open an editor "LS2-40AUF" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "40AUF"
And I set fields
   | nummer | 1VKLS240  |
   | such   | LS2-40AUF |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
Then field "fakt" has value "nein"
And I set field "mge" to "22" in row 1
And I save the current editor

# Journaleintraege zum Lieferschein 2
Given I open an editor "JournalAb21" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==EKSET40;mge==44;buarta==Abgang;platz==F1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EKSET40               |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 44                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

Given I open an editor "JournalAb22" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==EKSET40;mge==22;buarta==Abgang;platz==F1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EKSET40               |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 22                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

Given I open an editor "JournalAb23" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==EKSET40;mge==44;buarta==Abgang;platz==F1;@richtung=rückwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | EKSET40               |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 44                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
And I close the current editor

Given I open an editor "RE2-40AUF" from table "(Sales):(Invoice)" with command "VIEW" for record "+1VKRE240"
And I save value from field "id" in row 1
And I close the current editor

# Bewertung zum Lieferschein 2
Given I open latest Valuation "BewertungAb21.1" for Product "EKSET40" and valuation transaction "JournalAb21" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb21^id       |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 44                    |
    | vorgaenger    |                       |
Then field "tmge" has value "32" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "12" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

Given I open latest Valuation "BewertungAb22.1" for Product "EKSET40" and valuation transaction "JournalAb22" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb22^id       |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 22                    |
    | vorgaenger    |                       |
Then field "tmge" has value "16" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "6" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

Given I open latest Valuation "BewertungAb23.1" for Product "EKSET40" and valuation transaction "JournalAb23" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb23^id       |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
    | mge           | 44                    |
    | vorgaenger    |                       |
Then field "tmge" has value "32" in row 1
# vkpos hat Verweis auf Rechungsposition
Then field "vkpos^id" in row 1 equals saved value
Then field "tmge" has value "12" in row 2
Then field "vkpos" is empty in row 2
And I close the current editor

# Bewertung zum Lieferschein 1, Teilmenge vkpos aus RE 1 und Restmenge vkpos aus RE 2 (das ist die vierte Bewertungen)
Given I open latest Valuation "BewertungAb11.2" for Product "EKSET40" and valuation transaction "JournalAb11" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb11^id       |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 34                    |
Then field "vorgaenger" is not empty
Then field "tmge" has value "22" in row 1
# vkpos hat Verweis auf Rechungsposition aus RE 1, wie in der Vorgaenger-Bewertung
Then field "vkpos^id" in row 1 has value equal to field "vkpos^id" from editor "BewertungAb11.1" in row 1
Then field "tmge" has value "12" in row 2
# vkpos hat Verweis auf Rechungsposition aus RE 2
Then field "vkpos^id" in row 2 equals saved value
And I close the current editor

Given I open latest Valuation "BewertungAb12.2" for Product "EKSET40" and valuation transaction "JournalAb12" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb12^id       |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 17                    |
Then field "vorgaenger" is not empty
Then field "tmge" has value "11" in row 1
# vkpos hat Verweis auf Rechungsposition aus RE 1, wie in der Vorgaenger-Bewertung
Then field "vkpos^id" in row 1 has value equal to field "vkpos^id" from editor "BewertungAb12.1" in row 1
Then field "tmge" has value "6" in row 2
# vkpos hat Verweis auf Rechungsposition aus RE 2
Then field "vkpos^id" in row 2 equals saved value
And I close the current editor

Given I open latest Valuation "BewertungAb13.2" for Product "EKSET40" and valuation transaction "JournalAb13" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb13^id       |
    | beistelldaten | nein                  |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Wertgutschrift        |
    | mge           | 34                    |
Then field "vorgaenger" is not empty
Then field "tmge" has value "22" in row 1
# vkpos hat Verweis auf Rechungsposition aus RE 1, wie in der Vorgaenger-Bewertung
Then field "vkpos^id" in row 1 has value equal to field "vkpos^id" from editor "BewertungAb13.1" in row 1
Then field "tmge" has value "12" in row 2
# vkpos hat Verweis auf Rechungsposition aus RE 2
Then field "vkpos^id" in row 2 equals saved value
And I close the current editor
