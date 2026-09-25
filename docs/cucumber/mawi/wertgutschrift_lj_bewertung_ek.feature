# *****************************************************************************
#  Name           : wertgutschrift_lj_bewertung_ek.feature
#  Verantwortlich : bschiga
#  Kontrolle      : carue
#  Funktion       : Test der LJ und Bewertungen bei Wertgutschriften
#
# *****************************************************************************
#
@persistent
Feature: wertgutschrift_lj_bewertung_ek.feature
Background:
Given I set the fake date to "02.01.1995"

# fuer alle Szenarien wird Bewertungskonfiguration 1 verwendet, Preis des Zugangs und Vorgangspreis

Scenario: Stammdaten

Given I open an editor "firma" from table "(Company):(ValuationConfiguration)" with command "UPDATE" for record "10"
And I modify table
  | !row | bewab             | bewzu         |
  | 1    | Preis des Zugangs | Vorgangspreis |
And I save the current editor


Scenario: 20 EK - Bestellung, Lieferscheine mit MZ und Rechnungen fuer Teilmengen, Teilwertgutschrift

Given I open an editor "TE100" from table "(Part):(Product)" with command "STORE" for record "TE100"
And I set fields
    | such      | TE100                |
    | namebspr  | Schraube 100         |
    | vpr       | 15                   |
    | epr       | 10.50                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "BE-10" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE100   |
    | such   | BE-100   |
    | ebeleg | BE-100   |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis |
    | TE100   | 100 | 9     |
And I save the current editor

# Lieferscheine aus Bestellung, Gesamtmenge mit 3 MZ, Rechnung soll aus Bestellung erzeugt werden
Given I open an editor "LS1-ZU-BE100" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE100"
And I set fields
   | nummer | 1EKLS100  |
   | ebeleg | LS1-BE100 |
   | such   | LS1-BE100 |
   | ueb    | ja        |
   | fakt   | nein      |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "100" in row 1
Then field "preis" has value "9.00" in row 1
And I set field "preis" to "9.50" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge |
    | F1     | 20     |
    | F2     | 30     |
    | F3     | 50     |
And I save the current editor
And I switch the current editor to editor "LS1-ZU-BE100"
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE100;mge==20;buarta==Zugang;platz==F1;ebeleg==LS1-BE100"
Then fields have values
    | artikel       | TE100                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 20                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mpr           | 0.0000                |
    | mpra          | 0.0000                |
    | epr           | 9.5000                |
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE100;mge==30;buarta==Zugang;platz==F2;ebeleg==LS1-BE100"
Then fields have values
    | artikel       | TE100                 |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 30                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mpr           | 0.0000                |
    | mpra          | 0.0000                |
    | epr           | 9.5000                |
And I close the current editor

Given I open an editor "JournalZu3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE100;mge==50;buarta==Zugang;platz==F3;ebeleg==LS1-BE100"
Then fields have values
    | artikel       | TE100                 |
    | platz         | F3                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 50                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mpr           | 0.0000                |
    | mpra          | 0.0000                |
    | epr           | 9.5000                |
And I close the current editor

# Bewertungen zu den Lieferscheinen, vor Buchen der Rechnungen
Given I open latest Valuation "BewertungZu1.1" for Product "TE100" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 20                    |
    | bewwert       | 190.00                |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 20   | 9.5000  | 0.0000    | vorläufig | !JournalZu1^vom  | !JournalZu1^id    | !JournalZu1^id | !JournalZu1^id |         | !JournalZu1^stand  |
And I close the current editor

Given I open latest Valuation "BewertungZu2.1" for Product "TE100" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 30                    |
    | bewwert       | 285.00                |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 30   | 9.5000  | 0.0000    | vorläufig | !JournalZu2^vom  | !JournalZu2^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalZu2^stand  |
And I close the current editor

Given I open latest Valuation "BewertungZu3.1" for Product "TE100" and valuation transaction "JournalZu3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu3^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 50                    |
    | bewwert       | 475.00                |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 50   | 9.5000  | 0.0000    | vorläufig | !JournalZu3^vom  | !JournalZu3^id    | !JournalZu3^id | !JournalZu3^id |         | !JournalZu3^stand  |
And I close the current editor

# Rechnung 1 buchen
Given I open an editor "RE1-ZU-BE100" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE100"
And I set fields
   | nummer | 1EKRE100  |
   | ebeleg | RE1-BE100 |
   | such   | RE1-BE100 |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "10" in row 1
Then field "preis" has value "9.00" in row 1
And I set field "preis" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 1
Given I open an editor "JournalRE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE100;buarta==Neubewertung;platz==F1;ebeleg==RE1-BE100"
Then fields have values
    | artikel       | TE100                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 10                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 1.0000                |
    | mpra          | 0.0000                |
    | epr           | 10.0000               |
And I close the current editor

# Bewertungen zu den Lieferscheinen, Nach Buchen der Rechnung 1
Given I open latest Valuation "BewertungZu1.2" for Product "TE100" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 20                    |
    | bewwert       | 195.00                |
    | vorgaenger^id | !BewertungZu1.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   | datum              |
    | 10   | 10.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalRE1^stand  |
    | 10   | 9.5000  | 0.0000    | vorläufig | !JournalZu1^vom  | !JournalZu1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalZu1^stand  |
And I close the current editor

# Rechnung 2 buchen
Given I open an editor "RE2-ZU-BE100" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE100"
And I set fields
   | nummer | 1EKRE210  |
   | ebeleg | RE2-BE100 |
   | such   | RE2-BE100 |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "50" in row 1
Then field "preis" has value "9.00" in row 1
And I set field "preis" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 2
Given I open an editor "JournalRE2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE100;buarta==Neubewertung;platz==F1;ebeleg==RE2-BE100"
Then fields have values
    | artikel       | TE100                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 50                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 5.5000                |
    | mpra          | 1.0000                |
    | epr           | 10.0000               |
And I close the current editor

# Bewertungen zu den Lieferscheinen, Nach Buchen der Rechnung 2
Given I open latest Valuation "BewertungZu1.3" for Product "TE100" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 20                    |
    | bewwert       | 200.00                |
    | vorgaenger^id | !BewertungZu1.2^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   | datum              |
    | 10   | 10.0000 | 0.0000    | direkt    | !JournalRE2^vom  | !JournalRE2^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalRE2^stand  |
    | 10   | 10.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalRE1^stand  |
And I close the current editor

Given I open latest Valuation "BewertungZu2.2" for Product "TE100" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 30                    |
    | bewwert       | 300.00                |
    | vorgaenger^id | !BewertungZu2.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   | datum              |
    | 30   | 10.0000 | 0.0000    | direkt    | !JournalRE2^vom  | !JournalRE2^id  | !JournalZu2^id | !JournalZu2^id |         | !JournalRE2^stand  |
And I close the current editor

Given I open latest Valuation "BewertungZu3.2" for Product "TE100" and valuation transaction "JournalZu3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu3^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 50                    |
    | bewwert       | 480.00                |
    | vorgaenger^id | !BewertungZu3.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   | datum              |
    | 10   | 10.0000 | 0.0000    | direkt    | !JournalRE2^vom  | !JournalRE2^id  | !JournalZu3^id | !JournalZu3^id |         | !JournalRE2^stand  |
    | 40   | 9.5000  | 0.0000    | vorläufig | !JournalZu3^vom  | !JournalZu3^id  | !JournalZu3^id | !JournalZu3^id |         | !JournalZu3^stand  |
And I close the current editor

# Rechnung 3 buchen
Given I open an editor "RE3-ZU-BE100" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE100"
And I set fields
   | nummer | 1EKRE310  |
   | ebeleg | RE3-BE100 |
   | such   | RE3-BE100 |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "30" in row 1
Then field "preis" has value "9.00" in row 1
And I set field "preis" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 3
Given I open an editor "JournalRE3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE100;buarta==Neubewertung;platz==F1;ebeleg==RE3-BE100"
Then fields have values
    | artikel       | TE100                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 30                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 6.8500                |
    | mpra          | 5.5000                |
    | epr           | 10.0000               |
And I close the current editor

# Bewertungen zu den Lieferscheinen, Nach Buchen der Rechnung 3, BW-Kette 1 keine Veraenderung
Given I open latest Valuation "BewertungZu1.4" for Product "TE100" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 20                    |
    | bewwert       | 200.00                |
    | vorgaenger^id | !BewertungZu1.2^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   | datum              |
    | 10   | 10.0000 | 0.0000    | direkt    | !JournalRE2^vom  | !JournalRE2^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalRE2^stand  |
    | 10   | 10.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalRE1^stand  |
And I close the current editor

# BW-Kette 2 keine Veraenderung
Given I open latest Valuation "BewertungZu2.3" for Product "TE100" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 30                    |
    | bewwert       | 300.00                |
    | vorgaenger^id | !BewertungZu2.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   | datum              |
    | 30   | 10.0000 | 0.0000    | direkt    | !JournalRE2^vom  | !JournalRE2^id  | !JournalZu2^id | !JournalZu2^id |         | !JournalRE2^stand  |
And I close the current editor

# BW-Kette 3 hat sich geaendert
Given I open latest Valuation "BewertungZu3.3" for Product "TE100" and valuation transaction "JournalZu3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu3^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 50                    |
    | bewwert       | 495.00                |
    | vorgaenger^id | !BewertungZu3.2^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   | datum              |
    | 30   | 10.0000 | 0.0000    | direkt    | !JournalRE3^vom  | !JournalRE3^id  | !JournalZu3^id | !JournalZu3^id |         | !JournalRE3^stand  |
    | 10   | 10.0000 | 0.0000    | direkt    | !JournalRE2^vom  | !JournalRE2^id  | !JournalZu3^id | !JournalZu3^id |         | !JournalRE2^stand  |
    | 10   | 9.5000  | 0.0000    | vorläufig | !JournalZu3^vom  | !JournalZu3^id  | !JournalZu3^id | !JournalZu3^id |         | !JournalZu3^stand  |
And I close the current editor

# Teilwertgutschrift zu Rechnung 2 erstellen und buchen, Teilmenge, gesamter Preis, es wird die gesamte Rechnungsmenge pauschalisiert reduziert
Given I open an editor "WERT-RE2-BE100" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE2-ZU-BE100"
And I set fields
    | nummer | 1WERTRE2   |
    | such   | EK1TEILWG  |
    | ebeleg | EK1TEILWG1 |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis     |
    | 1     | -10   | 10.00     |
And I save the current editor

Given I open an editor "JournalWG1RE2.F1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE100;buarta==Neubewertung;platz==F1;ebeleg==EK1TEILWG1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE100             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -10               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpra          | 6.8500            |
    | epr           | 2.0000            |
And I close the current editor

Given I open an editor "JournalWG1RE2.F2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE100;buarta==Neubewertung;platz==F2;ebeleg==EK1TEILWG1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE100             |
    | platz         | F2                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -30               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpra          | 6.8500            |
    | epr           | 2.0000            |
And I close the current editor

Given I open an editor "JournalWG1RE2.F3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE100;buarta==Neubewertung;platz==F3;ebeleg==EK1TEILWG1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE100             |
    | platz         | F3                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -10               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpra          | 6.8500            |
    | epr           | 2.0000            |
And I close the current editor

Given I open latest Valuation "BewertungZu1.5" for Product "TE100" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 20                    |
    | bewwert       | 180.00                |
    | vorgaenger^id | !BewertungZu1.3^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat                   | kverur^id             | orig^id        | beworig^id     | vkpos   | datum                     |
    | 10   | 8.0000  | 0.0000    | direkt    | !JournalWG1RE2.F1^vom    | !JournalWG1RE2.F1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalWG1RE2.F1^stand   |
    | 10   | 10.0000 | 0.0000    | direkt    | !JournalRE1^vom          | !JournalRE1^id        | !JournalZu1^id | !JournalZu1^id |         | !JournalRE1^stand         |
And I close the current editor

Given I open latest Valuation "BewertungZu2.4" for Product "TE100" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 30                    |
    | bewwert       | 240.00                |
    | vorgaenger^id | !BewertungZu2.3^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat                   | kverur^id             | orig^id        | beworig^id     | vkpos   | datum                     |
    | 30   | 8.0000  | 0.0000    | direkt    | !JournalWG1RE2.F2^vom    | !JournalWG1RE2.F2^id  | !JournalZu2^id | !JournalZu2^id |         | !JournalWG1RE2.F2^stand   |
And I close the current editor

Given I open latest Valuation "BewertungZu3.4" for Product "TE100" and valuation transaction "JournalZu3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu3^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 50                    |
    | bewwert       | 475.00                |
    | vorgaenger^id | !BewertungZu3.3^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat                   | kverur^id             | orig^id        | beworig^id     | vkpos   | datum                     |
    | 30   | 10.0000 | 0.0000    | direkt    | !JournalRE3^vom          | !JournalRE3^id        | !JournalZu3^id | !JournalZu3^id |         | !JournalRE3^stand         |
    | 10   | 8.0000  | 0.0000    | direkt    | !JournalWG1RE2.F3^vom    | !JournalWG1RE2.F3^id  | !JournalZu3^id | !JournalZu3^id |         | !JournalWG1RE2.F3^stand   |
    | 10   | 9.5000  | 0.0000    | vorläufig | !JournalZu3^vom          | !JournalZu3^id        | !JournalZu3^id | !JournalZu3^id |         | !JournalZu3^stand         |
And I close the current editor

# 2. Teilwertgutschrift zu Rechnung 2 erstellen und buchen, Teilmenge, gesamter Preis
Given I open an editor "WERT2-RE2-BE100" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE2-ZU-BE100"
And I set fields
    | nummer | 1TWG2RE2   |
    | such   | EKTEILWG2  |
    | ebeleg | EKTEILWG2  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis     |
    | 1     | -10   | 10.00     |
And I save the current editor

Given I open an editor "JournalWG2RE2.F1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE100;buarta==Neubewertung;platz==F1;ebeleg==EKTEILWG2;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE100             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -10               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 2.0000            |
And I close the current editor

Given I open an editor "JournalWG2RE2.F2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE100;buarta==Neubewertung;platz==F2;ebeleg==EKTEILWG2;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE100             |
    | platz         | F2                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -30               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 2.0000            |
And I close the current editor

Given I open an editor "JournalWG2RE2.F3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE100;buarta==Neubewertung;platz==F3;ebeleg==EKTEILWG2;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE100             |
    | platz         | F3                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -10               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 2.0000            |
And I close the current editor

Given I open latest Valuation "BewertungZu1.6" for Product "TE100" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 20                    |
    | bewwert       | 160.00                |
    | vorgaenger^id | !BewertungZu1.5^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat                   | kverur^id             | orig^id        | beworig^id     | vkpos   | datum                     |
    | 10   | 6.0000  | 0.0000    | direkt    | !JournalWG2RE2.F1^vom    | !JournalWG2RE2.F1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalWG2RE2.F1^stand   |
    | 10   | 10.0000 | 0.0000    | direkt    | !JournalRE1^vom          | !JournalRE1^id        | !JournalZu1^id | !JournalZu1^id |         | !JournalRE1^stand         |
And I close the current editor

Given I open latest Valuation "BewertungZu2.5" for Product "TE100" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 30                    |
    | bewwert       | 180.00                |
    | vorgaenger^id | !BewertungZu2.4^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat                   | kverur^id             | orig^id        | beworig^id     | vkpos   | datum                     |
    | 30   | 6.0000  | 0.0000    | direkt    | !JournalWG2RE2.F2^vom    | !JournalWG2RE2.F2^id  | !JournalZu2^id | !JournalZu2^id |         | !JournalWG2RE2.F2^stand   |
And I close the current editor

Given I open latest Valuation "BewertungZu3.5" for Product "TE100" and valuation transaction "JournalZu3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu3^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 50                    |
    | bewwert       | 455.00                |
    | vorgaenger^id | !BewertungZu3.4^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat                   | kverur^id             | orig^id        | beworig^id     | vkpos   | datum                     |
    | 30   | 10.0000 | 0.0000    | direkt    | !JournalRE3^vom          | !JournalRE3^id        | !JournalZu3^id | !JournalZu3^id |         | !JournalRE3^stand         |
    | 10   | 6.0000  | 0.0000    | direkt    | !JournalWG2RE2.F3^vom    | !JournalWG2RE2.F3^id  | !JournalZu3^id | !JournalZu3^id |         | !JournalWG2RE2.F3^stand   |
    | 10   | 9.5000  | 0.0000    | vorläufig | !JournalZu3^vom          | !JournalZu3^id        | !JournalZu3^id | !JournalZu3^id |         | !JournalZu3^stand         |
And I close the current editor

# 3. Teilwertgutschrift zu Rechnung 2 erstellen und buchen, ganze Menge, reduzierter (restlicher) Preis
Given I open an editor "WERT3-RE2-BE100" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE2-ZU-BE100"
And I set fields
    | nummer | 1TWG3RE2   |
    | such   | EKTEILWG3  |
    | ebeleg | EKTEILWG3  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis     |
    | 1     | -50   | 6.00      |
And I save the current editor

Given I open an editor "JournalWG3RE2.F1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE100;buarta==Neubewertung;platz==F1;ebeleg==EKTEILWG3;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE100             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -10               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 6.0000            |
And I close the current editor

Given I open an editor "JournalWG3RE2.F2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE100;buarta==Neubewertung;platz==F2;ebeleg==EKTEILWG3;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE100             |
    | platz         | F2                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -30               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 6.0000            |
And I close the current editor

Given I open an editor "JournalWG3RE2.F3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE100;buarta==Neubewertung;platz==F3;ebeleg==EKTEILWG3;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE100             |
    | platz         | F3                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -10               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 6.0000            |
And I close the current editor

Given I open latest Valuation "BewertungZu1.7" for Product "TE100" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 20                    |
    | bewwert       | 100.00                |
    | vorgaenger^id | !BewertungZu1.6^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat                 | kverur^id               | orig^id        | beworig^id     | vkpos   | datum                     |
    | 10   | 0.0000  | 0.0000    | direkt    | !JournalWG3RE2.F1^vom  | !JournalWG3RE2.F1^id    | !JournalZu1^id | !JournalZu1^id |         | !JournalWG3RE2.F1^stand   |
    | 10   | 10.0000 | 0.0000    | direkt    | !JournalRE1^vom        | !JournalRE1^id          | !JournalZu1^id | !JournalZu1^id |         | !JournalRE1^stand         |
And I close the current editor

Given I open latest Valuation "BewertungZu2.6" for Product "TE100" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 30                    |
    | bewwert       | 0.00                  |
    | vorgaenger^id | !BewertungZu2.5^id    |
Then table has values
    | tmge | tbewpr | addkosten | bewertet  | tbudat                   | kverur^id             | orig^id        | beworig^id     | vkpos   | datum                     |
    | 30   | 0.0000 | 0.0000    | direkt    | !JournalWG3RE2.F2^vom    | !JournalWG3RE2.F2^id  | !JournalZu2^id | !JournalZu2^id |         | !JournalWG3RE2.F2^stand   |
And I close the current editor

Given I open latest Valuation "BewertungZu3.6" for Product "TE100" and valuation transaction "JournalZu3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu3^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 50                    |
    | bewwert       | 395.00                |
    | vorgaenger^id | !BewertungZu3.5^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat                   | kverur^id             | orig^id        | beworig^id     | vkpos   | datum                     |
    | 30   | 10.0000 | 0.0000    | direkt    | !JournalRE3^vom          | !JournalRE3^id        | !JournalZu3^id | !JournalZu3^id |         | !JournalRE3^stand         |
    | 10   | 0.0000  | 0.0000    | direkt    | !JournalWG3RE2.F3^vom    | !JournalWG3RE2.F3^id  | !JournalZu3^id | !JournalZu3^id |         | !JournalWG3RE2.F3^stand   |
    | 10   | 9.5000  | 0.0000    | vorläufig | !JournalZu3^vom          | !JournalZu3^id        | !JournalZu3^id | !JournalZu3^id |         | !JournalZu3^stand         |
And I close the current editor


Scenario: 22 EK - Bestellung, Lieferscheine mit MZ und Charge, Verwendung, Rechnungen Gesamtmenge, Teilwertgutschrift

Given I open an editor "TE102" from table "(Part):(Product)" with command "STORE" for record "TE102"
And I set fields
    | such      | TE102                 |
    | namebspr  | Schraube 102          |
    | vpr       | 15                    |
    | epr       | 10.50                 |
    | bsart     | Fremdbeschaffung      |
    | dispoa    | auftragsbezogen       |
    | chverfolgung | Chargenverfolgung                    |
    | chimlager | ja                    |
    | ekbewverf | 1                     |
And I save the current editor

Given I create a Lot "CH1" for Product "TE102"

Given I open an editor "BE-102" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE102   |
    | such   | BE-102   |
    | ebeleg | BE-102   |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis |
    | TE102   | 100 | 9     |
And I save the current editor

# Lieferscheine aus Bestellung, Gesamtmenge mit 2 MZ, Charge und Verwendung, Rechnung soll aus Bestellung erzeugt werden
Given I open an editor "LS1-ZU-BE102" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE102"
And I set fields
   | nummer | 1EKLS102  |
   | ebeleg | LS1-BE102 |
   | such   | LS1-BE102 |
   | ueb    | ja        |
   | fakt   | nein      |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "100" in row 1
Then field "preis" has value "9.00" in row 1
And I set field "preis" to "10" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge | charge  | verw  |
    | F1     | 40     | CH1     |       |
    | F2     | 60     | CH1     | xms   |
And I save the current editor
And I switch the current editor to editor "LS1-ZU-BE102"
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE102;mge==40;buarta==Zugang;platz==F1;ebeleg==LS1-BE102"
Then fields have values
    | artikel       | TE102                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 40                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mpr           | 0.0000                |
    | mpra          | 0.0000                |
    | epr           | 10.0000               |
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE102;mge==60;buarta==Zugang;platz==F2;ebeleg==LS1-BE102"
Then fields have values
    | artikel       | TE102                 |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 60                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mpr           | 0.0000                |
    | mpra          | 0.0000                |
    | epr           | 10.0000               |
And I close the current editor

# Bewertungen zu den Lieferscheinen, vor Erstellung der Rechnungen
Given I open latest Valuation "BewertungZu1.1" for Product "TE102" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 40                    |
    | bewwert       | 400.00                |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 40   | 10.0000 | 0.0000    | vorläufig | !JournalZu1^vom  | !JournalZu1^id    | !JournalZu1^id | !JournalZu1^id |         | !JournalZu1^stand  |
And I close the current editor

Given I open latest Valuation "BewertungZu2.1" for Product "TE102" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 60                    |
    | bewwert       | 600.00                |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 60   | 10.0000 | 0.0000    | vorläufig | !JournalZu2^vom  | !JournalZu2^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalZu2^stand  |
And I close the current editor

# Erstellen und Buchen Rechnung 1 Gesamtmenge
Given I open an editor "RE1-ZU-BE102" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE102"
And I set fields
   | nummer | 1EKRE102  |
   | ebeleg | RE1-BE102 |
   | such   | RE1-BE102 |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "100" in row 1
Then field "preis" has value "9.00" in row 1
And I set field "preis" to "11" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 1
Given I open an editor "JournalRE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE102;buarta==Neubewertung;platz==F1;ebeleg==RE1-BE102"
Then fields have values
    | artikel       | TE102                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 100                   |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 11.0000               |
    | mpra          | 0.0000                |
    | epr           | 11.0000               |
And I close the current editor

# Bewertungen zu den Lieferscheinen, Nach Buchen der Rechnung 1
Given I open latest Valuation "BewertungZu1.2" for Product "TE102" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 40                    |
    | bewwert       | 440.00                |
    | vorgaenger^id | !BewertungZu1.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   | datum              |
    | 40   | 11.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalRE1^stand  |
And I close the current editor

Given I open latest Valuation "BewertungZu2.2" for Product "TE102" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 60                    |
    | bewwert       | 660.00                |
    | vorgaenger^id | !BewertungZu2.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   | datum              |
    | 60   | 11.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id  | !JournalZu2^id | !JournalZu2^id |         | !JournalRE1^stand  |
And I close the current editor

# Teilwertgutschrift zu Rechnung 1 buchen, fuer CH1 und Verwendung xms, 60 Stueck, Preis 2,00
Given I open an editor "WERT-RE1-BE102" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE102"
And I set fields
    | nummer | 1WERTRE1   |
    | such   | EK1TEILWG  |
    | ebeleg | EK1TEILWG1 |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis     | charge    | verw  |
    | 1     | -60   | 2.00      | CH1       | xms   |
And I save the current editor

# Pruefen dass kein Journaleintrag zur Menge auf Platz F1, da die Wertgutschrift nur die Menge auf Platz F2 betrifft
# Meldung: 149 nicht gefunden bzw. 1582 Ungültige Objektangabe
Then opening an editor from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==TE102;buarta==Neubewertung;platz==F1;ebeleg==EK1TEILWG1;@richtung=vorwärts;@maxordtreffer=1" throws the exception "149"

Given I open an editor "JournalWG1RE1.F2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE102;buarta==Neubewertung;platz==F2;ebeleg==EK1TEILWG1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE102             |
    | platz         | F2                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -60               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpra          | 11.0000           |
    | epr           | 2.0000            |
And I close the current editor

# keine Veraenderung
Given I open latest Valuation "BewertungZu1.3" for Product "TE102" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 40                    |
    | bewwert       | 440.00                |
    | vorgaenger^id | !BewertungZu1.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   | datum              |
    | 40   | 11.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalRE1^stand  |
And I close the current editor

# die Menge mit Charge und Verwendung wurde neu bewertet
Given I open latest Valuation "BewertungZu2.3" for Product "TE102" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 60                    |
    | bewwert       | 540.00                |
    | vorgaenger^id | !BewertungZu2.2^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat                   | kverur^id             | orig^id        | beworig^id     | vkpos   | datum                     |
    | 60   | 9.0000  | 0.0000    | direkt    | !JournalWG1RE1.F2^vom    | !JournalWG1RE1.F2^id  | !JournalZu2^id | !JournalZu2^id |         | !JournalWG1RE1.F2^stand   |
And I close the current editor


Scenario: 23 EK - Rechnung wird vor dem Zugang gebucht, Bewertungssammler pruefen, BE, RE, BS, LS, Teil-WG, BS, LS

Given I open an editor "TE103" from table "(Part):(Product)" with command "STORE" for record "TE103"
And I set fields
    | such      | TE103                |
    | namebspr  | Schraube 103         |
    | vpr       | 15                   |
    | epr       | 75.00                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "BE-103" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE103   |
    | such   | BE-103   |
    | ebeleg | BE-103   |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis |
    | TE103   | 100 | 80    |
And I save the current editor

# Rechnung OHNE Lagerbewegung aus der Bestellung erstellen und buchen
Given I open an editor "RE1-ZU-BE103" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE103"
And I set fields
   | nummer | 1EKRE103  |
   | ebeleg | RE1-BE103 |
   | such   | RE1-BE103 |
   | fakt   | nein      |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "100" in row 1
Then field "preis" has value "80.00" in row 1
And I set field "preis" to "90" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 1
Given I open an editor "JournalRE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE103;buarta==Neubewertung;platz==F1;ebeleg==RE1-BE103"
Then fields have values
    | artikel       | TE103                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 100                   |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 90.0000               |
    | mpra          | 0.0000                |
    | epr           | 90.0000               |
And I close the current editor

# Bewertungsammler pruefen 100 Stueck aus der Rechnung warten auf den Zugang
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE103"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L1EKRE103 | 100   | 90.0000   | !JournalRE1^id    |
And I close the current editor

# Teilwertgutschrift zu Rechnung erstellen und buchen, Gesamtmenge, reduzierter Preis
Given I open an editor "WERT-RE1-BE103" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE103"
And I set fields
    | nummer | 1WERTRE1   |
    | such   | EK1TEILWG  |
    | ebeleg | EK1TEILWG1 |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis     |
    | 1     | -100  | 2.00      |
And I save the current editor

Given I open an editor "JournalWG1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE103;buarta==Neubewertung;platz==F1;ebeleg==EK1TEILWG1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE103             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -100              |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 2.0000            |
And I close the current editor

# Bewertungsammler pruefen 100 Stueck aus der Rechnung warten auf den Zugang, Preis ist NICHT reduziert
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE103"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L1EKRE103 | 100   | 90.0000   | !JournalRE1^id    |
And I close the current editor

# Lieferschein 1 aus Bestellung, Teilmenge
Given I open an editor "LS1-ZU-BE103" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE103"
And I set fields
   | nummer | 1EKLS103  |
   | ebeleg | LS1-BE103 |
   | such   | LS1-BE103 |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
Then field "fakt" has value "nein"
And I set field "mge" to "20" in row 1
Then field "preis" has value "80.00" in row 1
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE103;mge==20;buarta==Zugang;platz==F1;ebeleg==LS1-BE103"
Then fields have values
    | artikel       | TE103                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 20                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mpr           | 90.0000               |
    | mpra          | 90.0000               |
    | epr           | 80.0000               |
And I close the current editor

# Bewertungsammler pruefen 80 Stueck aus der Rechnung warten auf den Zugang, Preis bleibt
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE103"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L1EKRE103 | 80    | 90.0000   | !JournalRE1^id    |
And I close the current editor

# entstehen gleich 2 Bewertungen
# 1. BW mit Wert aus der Rechnung und Kostenverursacher Rechnung (Vorgaenger)
# 2. BW mit reduziertem Wert von 88 und Kostenverursacher Wertgutschrift (aktuelle Bewertung)

# Bewertungen zum Lieferschein, die aktuelle Bewertung hat den Kostenverursacher Wertgutschrift
Given I open latest Valuation "BewertungZu1.1" for Product "TE103" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 20                    |
    | bewwert       | 1760.00               |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 20   | 88.0000 | 0.0000    | direkt    | !JournalWG1^vom  | !JournalWG1^id    | !JournalZu1^id | !JournalZu1^id |         | !JournalWG1^stand  |
And I close the current editor

# ueber das Feld "vorgaenger" die erste Bewertung zum Lieferschein pruefen
Given I open an editor "VorgaengerBW" via ID from editor "BewertungZu1.1" from field "vorgaenger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 20                    |
    | bewwert       | 1800.00               |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 20   | 90.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id    | !JournalZu1^id | !JournalZu1^id |         | !JournalRE1^stand  |
And I close the current editor

# 2. Teilwertgutschrift zu Rechnung erstellen und buchen, Gesamtmenge, restlicher Preis
Given I open an editor "WERT2-RE1-BE103" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE103"
And I set fields
    | nummer | 1WERT2RE   |
    | such   | EKTEILWG2  |
    | ebeleg | EKTEILWG2  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis     |
    | 1     | -100  | 88.00     |
And I save the current editor

# es entstehen 2 Journaleintraege 80 (Menge ohne Zugang) und 20 (Menge mit Zugang aus LS)
Given I open an editor "JournalWG2.1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE103;buarta==Neubewertung;mge==-20;platz==F1;ebeleg==EKTEILWG2;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE103             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -20               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpr           | 90.0000           |
    | mpra          | 90.0000           |
    | epr           | 88.0000           |
And I close the current editor

Given I open an editor "JournalWG2.2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE103;buarta==Neubewertung;mge==-80;platz==F1;ebeleg==EKTEILWG2;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE103             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -80               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpr           | 90.0000           |
    | mpra          | 90.0000           |
    | epr           | 88.0000           |
And I close the current editor

# Bewertungsammler pruefen 80 Stueck aus der Rechnung warten auf den Zugang, Preis unveraendert
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE103"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L1EKRE103 | 80    | 90.0000   | !JournalRE1^id    |
And I close the current editor

# Bewertungen zum Lieferschein
Given I open latest Valuation "BewertungZu1.2" for Product "TE103" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 20                    |
    | bewwert       | 0.00                  |
    | vorgaenger^id | !BewertungZu1.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat            | kverur^id         | orig^id        | beworig^id     | vkpos   | datum               |
    | 20   | 0.0000  | 0.0000    | direkt    | !JournalWG2.1^vom | !JournalWG2.1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalWG2.1^stand |
And I close the current editor

# Lieferschein 2 aus Bestellung, Teilmenge
Given I open an editor "LS2-ZU-BE103" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE103"
And I set fields
   | nummer | 1EKLS203  |
   | ebeleg | LS2-BE103 |
   | such   | LS2-BE103 |
   | vom    | .         |
   | tterm  | .         |
   | ueb    | ja        |
Then field "fakt" has value "nein"
And I set field "mge" to "30" in row 1
Then field "preis" has value "80.00" in row 1
And I save the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE103;mge==30;buarta==Zugang;platz==F1;ebeleg==LS2-BE103"
Then fields have values
    | artikel       | TE103                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 30                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mpr           | 90.0000               |
    | mpra          | 90.0000               |
    | epr           | 80.0000               |
And I close the current editor

# Bewertungsammler pruefen nur noch 50 Stueck aus der Rechnung warten auf den Zugang, Preis unveraendert
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE103"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L1EKRE103 | 50    | 90.0000   | !JournalRE1^id    |
And I close the current editor

# Bewertung zum Lieferschein 2, Kostenverursacher Wertgutschrift 2 und LJ mit Menge 80
Given I open latest Valuation "BewertungZu2.1" for Product "TE103" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 30                    |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat            | kverur^id         | orig^id        | beworig^id     | vkpos   | datum               |
    | 30   | 0.0000  | 0.0000    | direkt    | !JournalWG2.2^vom | !JournalWG2.2^id  | !JournalZu2^id | !JournalZu2^id |         | !JournalWG2.2^stand |
And I close the current editor

# Vorgaenger hat den Wert aus der Wertgutschrift 1
Given I open an editor "VorgaengerBW2" via ID from editor "BewertungZu2.1" from field "vorgaenger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 30                    |
    | bewwert       | 2640.00               |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   |
    | 30   | 88.0000 | 0.0000    | direkt    | !JournalWG1^vom  | !JournalWG1^id    | !JournalZu2^id | !JournalZu2^id |         |
And I close the current editor


Scenario: 25 EK - RE ohne Lagerbewegung, Kostenumlage, Teilwertgutschrift, Lieferschein Storno Teilwertgutschrift, Storno Rechnung

Given I open an editor "TE225" from table "(Part):(Product)" with command "STORE" for record "TE225"
And I set fields
    | such      | TE225                |
    | namebspr  | Schraube 225         |
    | vpr       | 15                   |
    | epr       | 50.00                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

# Zusatzposition Transport vom Typ neutrale Position anlegen
Given I open an editor "FRACHT" from table "(Part):(SupplementaryItem)" with command "STORE" for record "FRACHT"
And I set fields
    | such      | FRACHT            |
    | namebspr  | Frachtkosten      |
    | zptyp     | Neutrale Position |
    | lirelev   | ja                |
    | rerelev   | ja                |
And I save the current editor

Given I open an editor "BE225" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE225   |
    | such   | BE-225   |
    | ebeleg | BE-225   |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis | verw  |
    | TE225   | 100 | 78    | EK225 |
And I save the current editor

# Rechnung ohne Lagerbewegung, aus Bestellung erstellen und buchen
Given I open an editor "RE-BE225" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE225"
And I set fields
    | nummer | 1EKRE225    |
    | ebeleg | RE-BE225    |
    | such   | RE-BE225    |
    | ueb    | ja          |
    | vom    | .           |
    | tterm  | .           |
    | fakt   | nein        |
And I modify table
    | !row  | mge   | preis     |
    | 1     | 100   | 80.00     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 1
Given I open an editor "JournalRE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE225;buarta==Neubewertung;platz==F1;ebeleg==RE-BE225"
Then fields have values
    | artikel       | TE225                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 100                   |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 80.0000               |
    | mpra          | 0.0000                |
    | epr           | 80.0000               |
And I close the current editor

# Bewertungsammler pruefen 100 Stueck aus der Rechnung warten auf den Zugang
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE225"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L1EKRE225 | 100   | 80.0000   | !JournalRE1^id    |
And I close the current editor

# Rechnung mit Transportkosten anlegen
Given I open an editor "RE-FRACHT225" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | 001           |
    | nummer | 1FRACHT       |
    | ebeleg | RE-FRACHT225  |
    | such   | FRACHT225     |
    | ueb    | ja            |
    | vom    | .             |
    | tterm  | .             |
And I delete all rows
And I append rows
    | artikel   | pwert | ptext         |
    | FRACHT    | 200   | kostuml_RE225 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Kostenumlage erzeugen
Given I open an editor "kostenuml-225" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "225"
And I set field "such" to "kuml225"
And I set field "pos" to "$,,ptext==kostuml_RE225;art==FRACHT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,artikel==TE225;mge==100;pwert==8000.00;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor

# Teilwertgutschrift gesamte Menge, reduzierter Preis
Given I open an editor "TEILWERT1-RE-BE225" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-BE225"
And I set fields
    | nummer | 1WERTRE    |
    | such   | EK1TEILWG  |
    | ebeleg | EK1TEILWG1 |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis     |
    | 1     | -100  | 1.00      |
And I save the current editor

# Teilwertgutschrift Teilmenge, reduzierter Preis
Given I open an editor "TEILWERT2-RE-BE225" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-BE225"
And I set fields
    | nummer | 1WERT2RE   |
    | such   | EK2TEILWG  |
    | ebeleg | EK2TEILWG2 |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis     |
    | 1     | -50   | 4.00      |
And I save the current editor

# Bewertungsammler pruefen 100 Stueck aus der Rechnung warten auf den Zugang, Teilwertgutschrift reduziert den Wert im Bewertungsammler NICHT
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE225"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L1EKRE225 | 100   | 80.0000   | !JournalRE1^id    |
And I close the current editor

Given I open an editor "LS-ZU-BE225" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE225"
And I set fields
   | nummer | 1EKLS225  |
   | ebeleg | LS-BE225  |
   | such   | LS-BE225  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
Then field "fakt" has value "nein"
And I set field "mge" to "100" in row 1
Then field "preis" has value "78.00" in row 1
And I save the current editor

# Bewertungssammler zu Rechnung 3 wurde geloescht, da komplette Menge geliefert
Given I query "bewempf,mge,wert" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE225"
Then query has no hits
And I close the current editor

# Journaleintraege
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE225;buarta==Zugang;platz==F1;ebeleg==LS-BE225"
Then fields have values
    | artikel       | TE225                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 100                   |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | epr           | 78.0000               |
And I close the current editor

Given I open an editor "JournalRE" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE225;buarta==Neubewertung;platz==F1;ebeleg==RE-BE225;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE225             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | 100               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Rechnung          |
    | epr           | 80.0000           |
And I close the current editor

Given I open an editor "JournalTWG1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE225;buarta==Neubewertung;platz==F1;ebeleg==EK1TEILWG1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE225             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -100              |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 1.0000            |
And I close the current editor

Given I open an editor "JournalTWG2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE225;buarta==Neubewertung;platz==F1;ebeleg==EK2TEILWG2;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE225             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -100              |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 2.0000            |
And I close the current editor

# Bewertung
Given I open latest Valuation "BewertungZu1.3" for Product "TE225" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id    |
    | beistelldaten | nein              |
    | bewart        | Vorgangspreis     |
    | abbewart      | Preis des Zugangs |
    | stornoverur   |                   |
    | buart         | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mge           | 100               |
    | bewwert       | 7900.00           |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id        | orig^id        | beworig^id     | vkpos   | datum              |
    | 100  | 79.0000 | 2.0000    | direkt    | !JournalTWG2^vom | !JournalTWG2^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalTWG2^stand |
And I close the current editor

Given I open an editor "VorgaengerBW2" via ID from editor "BewertungZu1.3" from field "vorgaenger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id    |
    | beistelldaten | nein              |
    | bewart        | Vorgangspreis     |
    | abbewart      | Preis des Zugangs |
    | stornoverur   |                   |
    | buart         | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mge           | 100               |
    | bewwert       | 8100.00           |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id        | orig^id        | beworig^id     | vkpos   | datum              |
    | 100  | 81.0000 | 2.0000    | direkt    | !JournalTWG1^vom | !JournalTWG1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalTWG1^stand |
And I close the current editor

Given I open an editor "VorgaengerBW1" via ID from editor "VorgaengerBW2" from field "vorgaenger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 100                   |
    | bewwert       | 8200.00               |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id      | orig^id        | beworig^id     | vkpos   | datum            |
    | 100  | 82.0000 | 2.0000    | direkt    | !JournalRE^vom   | !JournalRE^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalRE^stand |
And I close the current editor

# Storno Teilwertgutschrift 2
Given I open an editor "STORNO-TEILWERT2" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "TEILWERT2-RE-BE225"
And I save the current editor

## Journaleintrag zum Storno
#Given I open an editor "JournalTEILWERT2Storno" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE225;mge==50;buarta==Neubewertung;platz==F1;ebeleg==EK1TEILWG2"
#And I close the current editor

# Storno Teilwertgutschrift 1
Given I open an editor "STORNO-TEILWERT1" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "TEILWERT1-RE-BE225"
And I save the current editor

## Journaleintrag zum Storno
#Given I open an editor "JournalTEILWERT1Storno" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE225;mge==100;buarta==Neubewertung;platz==F1;ebeleg==EK1TEILWG1"
#And I close the current editor

# Storno der Kostenumlage, damit die Rechnung storniert werden kann
Given I open an editor "STORNO-KM" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record from editor "kostenuml-225"
And I save the current editor

# Storno Rechnung
Given I open an editor "STORNO-RE" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE-BE225"
And I save the current editor

# Journaleintrag zum Storno
Given I open an editor "JournalRE1Storno" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE225;mge==-100;buarta==Neubewertung;platz==F1;ebeleg==RE-BE225"
And I close the current editor

# Bewertung zum Lieferschein
Given I open latest Valuation "BewertungZu1.4" for Product "TE225" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalZu1^id            |
    | beistelldaten     | nein                      |
    | bewart            | Vorgangspreis             |
    | abbewart          | Preis des Zugangs         |
    | stornoverur^id    | !JournalRE1Storno^id      |
    | buart             | Zugang                    |
    | ursache           | Lieferschein              |
    | detursache        | Storno-Rechnung Einkauf   |
    | mge               | 100                       |
    | bewwert           | 7800.00                   |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat          | kverur^id       | orig^id        | beworig^id     | vkpos   | datum             |
    | 100  | 78.0000 | 0.0000    | vorläufig | !JournalZu1^vom | !JournalZu1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalZu1^stand |
And I close the current editor


Scenario: 26 EK - RE ohne Lagerbewegung, Kostenumlage, Komplettwertgutschrift, Lieferschein, Storno Wertgutschrift, Storno Rechnung

Given I open an editor "TE226" from table "(Part):(Product)" with command "STORE" for record "TE226"
And I set fields
    | such      | TE226                |
    | namebspr  | Schraube 226         |
    | vpr       | 15                   |
    | epr       | 50.00                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

# Zusatzposition Transport vom Typ neutrale Position anlegen
Given I open an editor "FRACHT" from table "(Part):(SupplementaryItem)" with command "STORE" for record "FRACHT"
And I set fields
    | such      | FRACHT            |
    | namebspr  | Frachtkosten      |
    | zptyp     | Neutrale Position |
    | lirelev   | ja                |
    | rerelev   | ja                |
And I save the current editor

Given I open an editor "BE226" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE226   |
    | such   | BE-226   |
    | ebeleg | BE-226   |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis | verw  |
    | TE226   | 100 | 78    | EK226 |
And I save the current editor

# Rechnung ohne Lagerbewegung, aus Bestellung erstellen und buchen
Given I open an editor "RE-BE226" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE226"
And I set fields
    | nummer | 1EKRE226    |
    | ebeleg | RE-BE226    |
    | such   | RE-BE226    |
    | ueb    | ja          |
    | vom    | .           |
    | tterm  | .           |
    | fakt   | nein        |
And I modify table
    | !row  | mge   | preis     |
    | 1     | 100   | 80.00     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 1
Given I open an editor "JournalRE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE226;buarta==Neubewertung;platz==F1;ebeleg==RE-BE226"
Then fields have values
    | artikel       | TE226                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 100                   |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 80.0000               |
    | mpra          | 0.0000                |
    | epr           | 80.0000               |
And I close the current editor

# Bewertungsammler pruefen 100 Stueck aus der Rechnung warten auf den Zugang
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE226"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L1EKRE226 | 100   | 80.0000   | !JournalRE1^id    |
And I close the current editor

# Rechnung fuer Transportkosten anlegen
Given I open an editor "RE-FRACHT226" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | 001           |
    | nummer | 1FRACHT       |
    | ebeleg | RE-FRACHT226  |
    | such   | FRACHT226     |
    | ueb    | ja            |
    | vom    | .             |
    | tterm  | .             |
And I delete all rows
And I append rows
    | artikel   | pwert | ptext         |
    | FRACHT    | 200   | kostuml_RE226 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Kostenumlage erzeugen
Given I open an editor "kostenuml-226" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "226"
And I set field "such" to "kuml226"
And I set field "pos" to "$,,ptext==kostuml_RE226;art==FRACHT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,artikel==TE226;mge==100;pwert==8000.00;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor

# Komplettwertgutschrift scheitert an Plausi wegen Kostenumlage
Given I open an editor "WERT-RE-BE226-EXCEPTION" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-BE226"
And I set fields
    | nummer | 226WGERR   |
    | such   | EK226WERR  |
    | ebeleg | EK226WERR  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -100  | 80.00     | -8000.00  |
# 2888 de      |Stornieren Sie zuerst die ursächliche(n) Kostenumlage(n) oder führen Sie diese zurück.
And saving the current editor throws the exception "2888"
And I close the current editor

Given I open an editor "kostenumlagerueckfuehrung-1" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "401" 
And I set field "name" to "KMRF" 
And I set field "origvorg" to "+226"
And I set field "such" to "RF226" 
And I save the current editor

# Komplettwertgutschrift buchen
Given I open an editor "WERT-RE-BE226" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-BE226"
And I set fields
    | nummer | 1WERTRE    |
    | such   | EK1WERT    |
    | ebeleg | EK1WERT    |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -100  | 80.00     | -8000.00  |
And I save the current editor

# Bewertungssammler zu Rechnung wurde geloescht, da komplette Menge gutgeschrieben
Given I query "bewempf,mge,wert" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE226"
Then query has no hits
And I close the current editor

Given I open an editor "LS-ZU-BE226" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE226"
And I set fields
   | nummer | 1EKLS226  |
   | ebeleg | LS-BE226  |
   | such   | LS-BE226  |
   | fakt   | nein      |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "100" in row 1
Then field "preis" has value "78.00" in row 1
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE226;buarta==Zugang;platz==F1;ebeleg==LS-BE226"
Then fields have values
    | artikel       | TE226                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 100                   |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | epr           | 78.0000               |
And I close the current editor

Given I open an editor "JournalRE" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE226;buarta==Neubewertung;platz==F1;ebeleg==RE-BE226;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE226             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | 100               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Rechnung          |
    | epr           | 80.0000           |
And I close the current editor

Given I open an editor "JournalWERT" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE226;buarta==Neubewertung;platz==F1;ebeleg==EK1WERT;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE226             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -100              |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 80.0000           |
And I close the current editor

# Bewertung, Preis aus dem Lieferschein
Given I open latest Valuation "BewertungZu1.2" for Product "TE226" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 100                   |
    | bewwert       | 7800.00               |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat          | kverur^id       | orig^id        | beworig^id     | vkpos   | datum             |
    | 100  | 78.0000 | 0.0000    | vorläufig | !JournalZu1^vom | !JournalZu1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalZu1^stand |
And I close the current editor

# Storno Wertgutschrift
Given I open an editor "STORNO-WERT" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "WERT-RE-BE226"
And I save the current editor

# Journaleintrag zum Storno
Given I open an editor "JournalWERTStorno" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE226;mge==100;buarta==Neubewertung;platz==F1;ebeleg==EK1WERT"
And I close the current editor

# Bewertung zum Lieferschein hat den Preis aus der Rechnung
Given I open latest Valuation "BewertungZu1.4" for Product "TE226" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalZu1^id            |
    | beistelldaten     | nein                      |
    | bewart            | Vorgangspreis             |
    | abbewart          | Preis des Zugangs         |
    | stornoverur       |                           |
    | buart             | Neubewertung              |
    | ursache           | Rechnung                  |
    | detursache        | Rechnung                  |
    | mge               | 100                       |
    | bewwert           | 8000.00                   |

# KEINE addkosten aus der Kostenumlage, weil dieser Stand nur nach Storno/Rueckfuehrung der KM erreichbar ist. 
# s. Plausi oben "2888"
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat         | kverur^id      | orig^id        | beworig^id     | vkpos   | datum             |
    | 100  | 80.0000 | 0.0000    | direkt    | !JournalRE^vom | !JournalRE^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalZu1^stand |
And I close the current editor

# storno wg. rueckfuehrung nicht mehr moeglich. und die exception muss hier auch nicht geprueft werden: # Storno der Kostenumlage, damit die Rechnung storniert werden kann
# storno wg. rueckfuehrung nicht mehr moeglich. und die exception muss hier auch nicht geprueft werden: Given I open an editor "STORNO-KM" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record from editor "kostenuml-226"
# storno wg. rueckfuehrung nicht mehr moeglich. und die exception muss hier auch nicht geprueft werden: And I save the current editor

# Storno Rechnung
Given I open an editor "STORNO-RE" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE-BE226"
And I save the current editor

# Journaleintrag zum Storno
Given I open an editor "JournalREStorno" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE226;mge==-100;buarta==Neubewertung;platz==F1;ebeleg==RE-BE226"
And I close the current editor

# Bewertung zum Lieferschein
Given I open latest Valuation "BewertungZu1.5" for Product "TE226" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalZu1^id            |
    | beistelldaten     | nein                      |
    | bewart            | Vorgangspreis             |
    | abbewart          | Preis des Zugangs         |
    | stornoverur^id    | !JournalREStorno^id       |
    | buart             | Zugang                    |
    | ursache           | Lieferschein              |
    | detursache        | Storno-Rechnung Einkauf   |
    | mge               | 100                       |
    | bewwert           | 7800.00                   |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat          | kverur^id       | orig^id        | beworig^id     | vkpos   | datum             |
    | 100  | 78.0000 | 0.0000    | vorläufig | !JournalZu1^vom | !JournalZu1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalZu1^stand |
And I close the current editor


Scenario: 27 EK - RE ohne Lagerbewegung, Teilwertgutschriften, Lieferschein, Storno Teilwertgutschriften

Given I open an editor "TE227" from table "(Part):(Product)" with command "STORE" for record "TE227"
And I set fields
    | such      | TE227                |
    | namebspr  | Schraube 227         |
    | vpr       | 15                   |
    | epr       | 50.00                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "BE227" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE227   |
    | such   | BE-227   |
    | ebeleg | BE-227   |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis | verw  |
    | TE227   | 100 | 90    | EK227 |
And I save the current editor

# Rechnung ohne Lagerbewegung, aus Bestellung erstellen und buchen
Given I open an editor "RE-BE227" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE227"
And I set fields
    | nummer | 1EKRE227    |
    | ebeleg | RE-BE227    |
    | such   | RE-BE227    |
    | ueb    | ja          |
    | vom    | .           |
    | tterm  | .           |
    | fakt   | nein        |
And I modify table
    | !row  | mge   | preis     |
    | 1     | 100   | 100.00    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 1
Given I open an editor "JournalRE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE227;buarta==Neubewertung;platz==F1;ebeleg==RE-BE227"
Then fields have values
    | artikel       | TE227                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 100                   |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 100.0000              |
    | mpra          | 0.0000                |
    | epr           | 100.0000              |
And I close the current editor

# Bewertungsammler pruefen 100 Stueck aus der Rechnung warten auf den Zugang
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE227"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L1EKRE227 | 100   | 100.0000  | !JournalRE1^id    |
And I close the current editor

# Teilwertgutschrift 1 gesamte Menge, reduzierter Preis
Given I open an editor "TWG1-RE-BE227" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-BE227"
And I set fields
    | nummer | 1WERTRE    |
    | such   | EK1TWG1    |
    | ebeleg | EK1TEILWG1 |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis     |
    | 1     | -100  | 10.00     |
And I save the current editor

# Teilwertgutschrift 2 gesamte Menge, reduzierter Preis
Given I open an editor "TWG2-RE-BE227" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-BE227"
And I set fields
    | nummer | 1WERT2RE   |
    | such   | EK2TWG2    |
    | ebeleg | EK2TEILWG2 |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis     |
    | 1     | -100  | 20.00     |
And I save the current editor

# Bewertungsammler pruefen 100 Stueck aus der Rechnung warten auf den Zugang, Wert bleibt bei TWG
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE227"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L1EKRE227 | 100   | 100.0000  | !JournalRE1^id    |
And I close the current editor

# Teilwertgutschrift 3 gesamte Menge, reduzierter Preis
Given I open an editor "TWG3-RE-BE227" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-BE227"
And I set fields
    | nummer | 1WERT3RE   |
    | such   | EK3TWG3    |
    | ebeleg | EK3TEILWG3 |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis |
    | 1     | -100  | 30.00 |
And I save the current editor

# Bewertungsammler pruefen 100 Stueck aus der Rechnung warten auf den Zugang, Wert bleibt bei TWG
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE227"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L1EKRE227 | 100   | 100.0000  | !JournalRE1^id    |
And I close the current editor

# Storno Teilwertgutschrift 3
Given I open an editor "STORNO-TWG3" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "TWG3-RE-BE227"
And I save the current editor

# Bewertungsammler pruefen 100 Stueck aus der Rechnung warten auf den Zugang, Wert bleibt bei TWG
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE227"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L1EKRE227 | 100   | 100.0000  | !JournalRE1^id    |
And I close the current editor

# Journaleintrag zum Storno
Given I open an editor "JournalTWG3Storno" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE227;mge==100;buarta==Neubewertung;platz==F1;ebeleg==EK3TEILWG3"
And I close the current editor

Given I open an editor "LS-ZU-BE227" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE227"
And I set fields
   | nummer | 1EKLS227  |
   | ebeleg | LS-BE227  |
   | such   | LS-BE227  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
Then field "fakt" has value "nein"
And I set field "mge" to "100" in row 1
Then field "preis" has value "90.00" in row 1
And I save the current editor

# Journaleintraege
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE227;buarta==Zugang;platz==F1;ebeleg==LS-BE227"
Then fields have values
    | artikel       | TE227                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 100                   |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | epr           | 90.0000               |
And I close the current editor

Given I open an editor "JournalRE" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE227;buarta==Neubewertung;platz==F1;ebeleg==RE-BE227;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE227             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | 100               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Rechnung          |
    | epr           | 100.0000          |
And I close the current editor

Given I open an editor "JournalTWG1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE227;buarta==Neubewertung;platz==F1;ebeleg==EK1TEILWG1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE227             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -100              |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 10.0000           |
And I close the current editor

Given I open an editor "JournalTWG2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE227;buarta==Neubewertung;platz==F1;ebeleg==EK2TEILWG2;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE227             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -100              |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 20.0000           |
And I close the current editor

Given I open an editor "JournalTWG3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE227;buarta==Neubewertung;platz==F1;ebeleg==EK3TEILWG3;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE227             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -100              |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 30.0000           |
And I close the current editor

# Bewertung, Wertgutschrift 2
Given I open latest Valuation "BewertungZu1.3" for Product "TE227" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id    |
    | beistelldaten | nein              |
    | bewart        | Vorgangspreis     |
    | abbewart      | Preis des Zugangs |
    | stornoverur   |                   |
    | buart         | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mge           | 100               |
    | bewwert       | 7000.00           |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id        | orig^id        | beworig^id     | vkpos   | datum              |
    | 100  | 70.0000 | 0.0000    | direkt    | !JournalTWG2^vom | !JournalTWG2^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalTWG2^stand |
And I close the current editor

# Bewertung, Wertgutschrift 1
Given I open an editor "VorgaengerBW2" via ID from editor "BewertungZu1.3" from field "vorgaenger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id    |
    | beistelldaten | nein              |
    | bewart        | Vorgangspreis     |
    | abbewart      | Preis des Zugangs |
    | stornoverur   |                   |
    | buart         | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mge           | 100               |
    | bewwert       | 9000.00           |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id        | orig^id        | beworig^id     | vkpos   | datum              |
    | 100  | 90.0000 | 0.0000    | direkt    | !JournalTWG1^vom | !JournalTWG1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalTWG1^stand |
And I close the current editor

# Bewertung, Rechnung
Given I open an editor "VorgaengerBW1" via ID from editor "VorgaengerBW2" from field "vorgaenger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 100                   |
    | bewwert       | 10000.00              |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet  | tbudat           | kverur^id      | orig^id        | beworig^id     | vkpos   | datum            |
    | 100  | 100.0000 | 0.0000    | direkt    | !JournalRE^vom   | !JournalRE^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalRE^stand |
And I close the current editor

# Storno Teilwertgutschrift 2
Given I open an editor "STORNO-TWG2" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "TWG2-RE-BE227"
And I save the current editor

# Journaleintrag zum Storno
Given I open an editor "JournalTWG2Storno" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE227;mge==100;buarta==Neubewertung;platz==F1;ebeleg==EK2TEILWG2"
And I close the current editor

# Bewertung zum Lieferschein, Preis nach Wertgutschrift 1
Given I open latest Valuation "BewertungZu1.4" for Product "TE227" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalZu1^id            |
    | beistelldaten     | nein                      |
    | bewart            | Vorgangspreis             |
    | abbewart          | Preis des Zugangs         |
    | stornoverur^id    | !JournalTWG2Storno^id     |
    | buart             | Neubewertung              |
    | ursache           | Rechnung                  |
    | detursache        | Storno Wertgutschrift     |
    | mge               | 100                       |
    | bewwert           | 9000.00                   |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   | datum              |
    | 100  | 90.0000 | 0.0000    | direkt    | !JournalTWG1^vom | !JournalTWG1^id | !JournalZu1^id | !JournalZu1^id |         | !JournalTWG1^stand |
And I close the current editor


Scenario: 28 EK - RE ohne Lagerbewegung, Teilwertgutschriften, Lieferschein, Storno Teilwertgutschriften

Given I open an editor "TE228" from table "(Part):(Product)" with command "STORE" for record "TE228"
And I set fields
    | such      | TE228                |
    | namebspr  | Schraube 228         |
    | vpr       | 15                   |
    | epr       | 50.00                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "BE228" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE228   |
    | such   | BE-228   |
    | ebeleg | BE-228   |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis | verw  |
    | TE228   | 100 | 90    | EK228 |
And I save the current editor

# Rechnung ohne Lagerbewegung, aus Bestellung
Given I open an editor "RE-BE228" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE228"
And I set fields
    | nummer | 1EKRE228    |
    | ebeleg | RE-BE228    |
    | such   | RE-BE228    |
    | ueb    | ja          |
    | vom    | .           |
    | tterm  | .           |
    | fakt   | nein        |
And I modify table
    | !row  | mge   | preis     |
    | 1     | 100   | 100.00    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 1
Given I open an editor "JournalRE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE228;buarta==Neubewertung;platz==F1;ebeleg==RE-BE228"
Then fields have values
    | artikel       | TE228                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 100                   |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 100.0000              |
    | mpra          | 0.0000                |
    | epr           | 100.0000              |
And I close the current editor

# Bewertungsammler pruefen 100 Stueck aus der Rechnung warten auf den Zugang
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE228"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L1EKRE228 | 100   | 100.0000  | !JournalRE1^id    |
And I close the current editor

# Komplettwertgutschrift buchen
Given I open an editor "WG1-RE-BE228" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-BE228"
And I set fields
    | nummer | 1WERTRE    |
    | such   | EKWERT228  |
    | ebeleg | EKWERT228  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -100  | 100.00    | -10000.00 |
And I save the current editor

# Bewertungssammler wurde geloescht, da RE komplett gutgeschrieben wurde, gibt es dazu keine wartende Menge mehr
Given I query "bewempf,mge,wert" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE228"
Then query has no hits
And I close the current editor

Given I open an editor "LS-ZU-BE228" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE228"
And I set fields
   | nummer | 1EKLS228  |
   | ebeleg | LS-BE228  |
   | such   | LS-BE228  |
   | fakt   | nein      |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "100" in row 1
Then field "preis" has value "90.00" in row 1
And I save the current editor

# Journaleintraege
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE228;buarta==Zugang;platz==F1;ebeleg==LS-BE228"
Then fields have values
    | artikel       | TE228                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 100                   |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | epr           | 90.0000               |
And I close the current editor

Given I open an editor "JournalRE" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE228;buarta==Neubewertung;platz==F1;ebeleg==RE-BE228;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE228             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | 100               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Rechnung          |
    | epr           | 100.0000          |
And I close the current editor

Given I open an editor "JournalWG1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE228;buarta==Neubewertung;platz==F1;ebeleg==EKWERT228;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE228             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -100              |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 100.0000          |
And I close the current editor

# Bewertung, Wertgutschrift, vorlaeufig und Preis aus Lieferschein
Given I open latest Valuation "BewertungZu1.1" for Product "TE228" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 100                   |
    | bewwert       | 9000.00               |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat          | kverur^id       | orig^id        | beworig^id     | vkpos   | datum             |
    | 100  | 90.0000 | 0.0000    | vorläufig | !JournalZu1^vom | !JournalZu1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalZu1^stand |
And I close the current editor

# Storno Komplettwertgutschrift
Given I open an editor "STORNO-WG1" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "WG1-RE-BE228"
And I save the current editor

# Journaleintrag zum Storno
Given I open an editor "JournalWG1Storno" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE228;mge==100;buarta==Neubewertung;platz==F1;ebeleg==EKWERT228"
And I close the current editor

# Bewertung zum Lieferschein, Preis aus Rechnung
Given I open latest Valuation "BewertungZu1.2" for Product "TE228" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalZu1^id    |
    | beistelldaten     | nein              |
    | bewart            | Vorgangspreis     |
    | abbewart          | Preis des Zugangs |
    | stornoverur       |                   |
    | buart             | Neubewertung      |
    | ursache           | Rechnung          |
    | detursache        | Rechnung          |
    | mge               | 100               |
    | bewwert           | 10000.00          |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet  | tbudat         | kverur^id     | orig^id        | beworig^id     | vkpos   | datum            |
    | 100  | 100.0000 | 0.0000    | direkt    | !JournalRE^vom | !JournalRE^id | !JournalZu1^id | !JournalZu1^id |         | !JournalRE^stand |
And I close the current editor


Scenario: 29 EK - BE, Teil-RE ohne Lagerbewegung, Teilwertgutschriften, Gesamt-LS aus BE, Storno Teilwertgutschriften

Given I open an editor "TE229" from table "(Part):(Product)" with command "STORE" for record "TE229"
And I set fields
    | such      | TE229                |
    | namebspr  | Schraube 229         |
    | vpr       | 15                   |
    | epr       | 50.00                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "BE229" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE229   |
    | such   | BE-229   |
    | ebeleg | BE-229   |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis | verw  |
    | TE229   | 100 | 100   | EK229 |
And I save the current editor

# Rechnung 1 ohne Lagerbewegung, aus Bestellung erstellen und buchen
Given I open an editor "RE1-BE229" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE229"
And I set fields
    | nummer | 1EKRE229    |
    | ebeleg | RE1-BE229   |
    | such   | RE1-BE229   |
    | ueb    | ja          |
    | vom    | .           |
    | tterm  | .           |
    | fakt   | nein        |
And I modify table
    | !row  | mge   | preis    |
    | 1     | 33    | 33.00    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 1
Given I open an editor "JournalRE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE229;buarta==Neubewertung;platz==F1;ebeleg==RE1-BE229"
Then fields have values
    | artikel       | TE229                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 33                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 33.0000               |
    | mpra          | 0.0000                |
    | epr           | 33.0000               |
And I close the current editor

# Bewertungsammler pruefen 33 Stueck aus der RE 1 warten auf den Zugang
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE229"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L1EKRE229 | 33    | 33.0000   | !JournalRE1^id    |
And I close the current editor

# Rechnung 2 ohne Lagerbewegung, aus Bestellung erstellen und buchen
Given I open an editor "RE2-BE229" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE229"
And I set fields
    | nummer | 2EKRE229    |
    | ebeleg | RE2-BE229   |
    | such   | RE2-BE229   |
    | ueb    | ja          |
    | vom    | .           |
    | tterm  | .           |
Then field "fakt" has value "nein"
And I modify table
    | !row  | mge   | preis    |
    | 1     | 67    | 67.00    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 2
Given I open an editor "JournalRE2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE229;buarta==Neubewertung;platz==F1;ebeleg==RE2-BE229"
Then fields have values
    | artikel       | TE229                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 67                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | epr           | 67.0000               |
And I close the current editor

# Bewertungsammler pruefen 67 Stueck aus der RE 2 warten auf den Zugang
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L2EKRE229"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L2EKRE229 | 67    | 67.0000   | !JournalRE2^id    |
And I close the current editor

# Komplettwertgutschrift zu RE 1 gesamte Menge, reduzierter Preis
Given I open an editor "WG1-RE1-BE229" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-BE229"
And I set fields
    | nummer | 1WERTRE1   |
    | such   | EK1WG1RE1  |
    | ebeleg | EK1WG1RE1  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert    |
    | -33   | 33.00     | -1089.00 |
And I save the current editor

# Bewertungssammler wurde geloescht, da RE 1 gutgeschrieben wurde, gibt es dazu keine wartende Menge mehr
Given I query "bewempf,mge,wert" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE229"
Then query has no hits
And I close the current editor

# Teilwertgutschrift RE 2 gesamte Menge, reduzierter Preis
Given I open an editor "TWG-RE2-BE229" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE2-BE229"
And I set fields
    | nummer | 1TWG1RE2   |
    | such   | EK1TWGRE2  |
    | ebeleg | EK1TWGRE2  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis     |
    | 1     | -67   | 10.00     |
And I save the current editor

# Bewertungsammler pruefen 67 Stueck aus der RE 2 warten auf den Zugang, Wert bleibt unveraendert
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L2EKRE229"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L2EKRE229 | 67    | 67.0000   | !JournalRE2^id    |
And I close the current editor

# Lieferschein aus Bestellung erstellen und buchen
Given I open an editor "LS-ZU-BE229" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE229"
And I set fields
   | nummer | 1EKLS229  |
   | ebeleg | LS-BE229  |
   | such   | LS-BE229  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
Then field "fakt" has value "nein"
And I set field "mge" to "100" in row 1
Then field "preis" has value "100.00" in row 1
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE229;buarta==Zugang;platz==F1;ebeleg==LS-BE229"
Then fields have values
    | artikel       | TE229                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 100                   |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | epr           | 100.0000              |
And I close the current editor

Given I open an editor "JournalRE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE229;buarta==Neubewertung;platz==F1;ebeleg==RE1-BE229;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE229             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | 33                |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Rechnung          |
    | epr           | 33.0000           |
And I close the current editor

Given I open an editor "JournalRE2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE229;buarta==Neubewertung;platz==F1;ebeleg==RE2-BE229;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE229             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | 67                |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Rechnung          |
    | epr           | 67.0000           |
And I close the current editor

Given I open an editor "JournalKWG" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE229;buarta==Neubewertung;platz==F1;ebeleg==EK1WG1RE1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE229             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -33               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 33.0000           |
And I close the current editor

Given I open an editor "JournalTWG" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE229;buarta==Neubewertung;platz==F1;ebeleg==EK1TWGRE2;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE229             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -67               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 10.0000           |
And I close the current editor

# Bewertung zum Lieferschein
Given I open latest Valuation "BewertungZu1.1" for Product "TE229" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id    |
    | beistelldaten | nein              |
    | bewart        | Vorgangspreis     |
    | abbewart      | Preis des Zugangs |
    | stornoverur   |                   |
    | buart         | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mge           | 100               |
    | bewwert       | 7119.00           |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet  | tbudat          | kverur^id       | orig^id        | beworig^id     | vkpos   |
    |  67  | 57.0000  | 0.0000    | direkt    | !JournalTWG^vom | !JournalTWG^id  | !JournalZu1^id | !JournalZu1^id |         |
    |  33  | 100.0000 | 0.0000    | vorläufig | !JournalZu1^vom | !JournalZu1^id  | !JournalZu1^id | !JournalZu1^id |         |
And I close the current editor

# Storno Komplettwertgutschrift
Given I open an editor "STORNO-KWG" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "WG1-RE1-BE229"
And I save the current editor

# Journaleintrag zum Storno
Given I open an editor "JournalKWGStorno" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE229;mge==33;buarta==Neubewertung;platz==F1;ebeleg==EK1WG1RE1"
And I close the current editor

# Bewertung zum Lieferschein
Given I open latest Valuation "BewertungZu1.2" for Product "TE229" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 100                   |
    | bewwert       | 4908.00               |
    | vorgaenger^id | !BewertungZu1.1^id    |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet  | tbudat          | kverur^id       | orig^id        | beworig^id     | vkpos   |
    |  33  | 33.0000  | 0.0000    | direkt    | !JournalRE1^vom | !JournalRE1^id  | !JournalZu1^id | !JournalZu1^id |         |
    |  67  | 57.0000  | 0.0000    | direkt    | !JournalTWG^vom | !JournalTWG^id  | !JournalZu1^id | !JournalZu1^id |         |
And I close the current editor

# Storno Teilwertgutschrift
Given I open an editor "STORNO-TWG" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "TWG-RE2-BE229"
And I save the current editor

# Journaleintrag zum Storno
Given I open an editor "JournalTWGStorno" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE229;mge==67;buarta==Neubewertung;platz==F1;ebeleg==EK1TWGRE2"
And I close the current editor

# Bewertung zum Lieferschein
Given I open latest Valuation "BewertungZu1.3" for Product "TE229" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalZu1^id        |
    | beistelldaten     | nein                  |
    | bewart            | Vorgangspreis         |
    | abbewart          | Preis des Zugangs     |
    | stornoverur^id    | !JournalTWGStorno^id  |
    | buart             | Neubewertung          |
    | ursache           | Rechnung              |
    | detursache        | Storno Wertgutschrift |
    | mge               | 100                   |
    | bewwert           | 5578.00               |
    | vorgaenger^id     | !BewertungZu1.2^id    |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet  | tbudat          | kverur^id       | orig^id        | beworig^id     | vkpos   |
    |  33  | 33.0000  | 0.0000    | direkt    | !JournalRE1^vom | !JournalRE1^id  | !JournalZu1^id | !JournalZu1^id |         |
    |  67  | 67.0000  | 0.0000    | direkt    | !JournalRE2^vom | !JournalRE2^id  | !JournalZu1^id | !JournalZu1^id |         |
And I close the current editor


Scenario: 30 EK - BE, Teil-RE ohne Lagerbewegung, Teilwertgutschriften, LS Teilmenge aus BE, Storno Teilwertgutschriften

Given I open an editor "TE230" from table "(Part):(Product)" with command "STORE" for record "TE230"
And I set fields
    | such      | TE230                |
    | namebspr  | Schraube 230         |
    | vpr       | 15                   |
    | epr       | 50.00                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "BE230" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE230   |
    | such   | BE-230   |
    | ebeleg | BE-230   |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis | verw  |
    | TE230   | 100 | 80    | EK230 |
And I save the current editor

# Rechnung 1 ohne Lagerbewegung, aus Bestellung erstellen und buchen
Given I open an editor "RE1-BE230" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE230"
And I set fields
    | nummer | 1EKRE230    |
    | ebeleg | RE1-BE230   |
    | such   | RE1-BE230   |
    | ueb    | ja          |
    | vom    | .           |
    | tterm  | .           |
    | fakt   | nein        |
And I modify table
    | !row  | mge   | preis   |
    | 1     | 6     | 6.00    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 1
Given I open an editor "JournalRE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE230;buarta==Neubewertung;platz==F1;ebeleg==RE1-BE230"
Then fields have values
    | artikel       | TE230                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 6                     |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 6.0000                |
    | mpra          | 0.0000                |
    | epr           | 6.0000                |
And I close the current editor

# Bewertungsammler pruefen 6 Stueck aus der RE 1 warten auf den Zugang
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE230"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L1EKRE230 | 6     | 6.0000    | !JournalRE1^id    |
And I close the current editor

# Rechnung 2 ohne Lagerbewegung, aus Bestellung erstellen und buchen
Given I open an editor "RE2-BE230" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE230"
And I set fields
    | nummer | 2EKRE230    |
    | ebeleg | RE2-BE230   |
    | such   | RE2-BE230   |
    | ueb    | ja          |
    | vom    | .           |
    | tterm  | .           |
Then field "fakt" has value "nein"
And I modify table
    | !row  | mge   | preis    |
    | 1     | 12    | 12.00    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 2
Given I open an editor "JournalRE2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE230;buarta==Neubewertung;platz==F1;ebeleg==RE2-BE230"
Then fields have values
    | artikel       | TE230                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 12                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | epr           | 12.0000               |
And I close the current editor

# Bewertungsammler pruefen 12 Stueck aus der RE 2 warten auf den Zugang
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L2EKRE230"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L2EKRE230 | 12    | 12.0000   | !JournalRE2^id    |
And I close the current editor

# Teilwertgutschrift 1 RE 1 gesamte Menge, reduzierter Preis
Given I open an editor "TWG1-RE1-BE230" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-BE230"
And I set fields
    | nummer | 1TWG1230   |
    | such   | TWG1BE230  |
    | ebeleg | TWG1BE230  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis    |
    | 1     | -6    | 1.00     |
And I save the current editor

# Bewertungsammler zu RE 1 bleibt unveraendert
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE230"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L1EKRE230 | 6     | 6.0000    | !JournalRE1^id    |
And I close the current editor

# Komplettwertgutschrift zu RE 2 gesamte Menge, reduzierter Preis
Given I open an editor "KWG-RE2-BE230" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE2-BE230"
And I set fields
    | nummer | 2KWG230    |
    | such   | KWG230RE2  |
    | ebeleg | KWG230RE2  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
    And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert   |
    | -12   | 12.00     | -144.00 |
And I save the current editor

# Bewertungssammler wurde geloescht, da RE 2 komplett gutgeschrieben wurde, gibt es dazu keine wartende Menge mehr
Given I query "bewempf,mge,wert" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L2EKRE230"
Then query has no hits
And I close the current editor

# Teilwertgutschrift 2 RE 1 gesamte Menge, reduzierter Preis
Given I open an editor "TWG2-RE1-BE230" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-BE230"
And I set fields
    | nummer | 2TWG2230   |
    | such   | TWG2BE230  |
    | ebeleg | TWG2BE230  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis    |
    | 1     | -6    | 2.00     |
And I save the current editor

# Lieferschein aus Bestellung, Teilmenge
Given I open an editor "LS-ZU-BE230" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE230"
And I set fields
   | nummer | 1EKLS230  |
   | ebeleg | LS-BE230  |
   | such   | LS-BE230  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
Then field "fakt" has value "nein"
And I set field "mge" to "25" in row 1
Then field "preis" has value "80.00" in row 1
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE230;buarta==Zugang;platz==F1;ebeleg==LS-BE230"
Then fields have values
    | artikel       | TE230                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 25                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | epr           | 80.0000               |
And I close the current editor

Given I open an editor "JournalRE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE230;buarta==Neubewertung;platz==F1;ebeleg==RE1-BE230;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE230             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | 6                 |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Rechnung          |
    | epr           | 6.0000            |
And I close the current editor

Given I open an editor "JournalRE2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE230;buarta==Neubewertung;platz==F1;ebeleg==RE2-BE230;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE230             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | 12                |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Rechnung          |
    | epr           | 12.0000           |
And I close the current editor

Given I open an editor "JournalTWG1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE230;buarta==Neubewertung;platz==F1;ebeleg==TWG1BE230;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE230             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -6                |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 1.0000            |
And I close the current editor

Given I open an editor "JournalKWG" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE230;buarta==Neubewertung;platz==F1;ebeleg==KWG230RE2;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE230             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -12               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 12.0000           |
And I close the current editor

Given I open an editor "JournalTWG2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE230;buarta==Neubewertung;platz==F1;ebeleg==TWG2BE230;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE230             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -6                |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 2.0000            |
And I close the current editor

# aktuelle (dritte) Bewertung zum Lieferschein
Given I open latest Valuation "BewertungZu1.3" for Product "TE230" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id    |
    | beistelldaten | nein              |
    | bewart        | Vorgangspreis     |
    | abbewart      | Preis des Zugangs |
    | stornoverur   |                   |
    | buart         | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mge           | 25                |
    | bewwert       | 1538.00           |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   |
    |  6   | 3.0000   | 0.0000    | direkt    | !JournalTWG2^vom | !JournalTWG2^id | !JournalZu1^id | !JournalZu1^id |         |
    |  19  | 80.0000  | 0.0000    | vorläufig | !JournalZu1^vom  | !JournalZu1^id  | !JournalZu1^id | !JournalZu1^id |         |
And I close the current editor

# ueber das Feld "vorgaenger" die zweite Bewertung zum Lieferschein pruefen
Given I open an editor "VorgaengerBW1" via ID from editor "BewertungZu1.3" from field "vorgaenger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id    |
    | beistelldaten | nein              |
    | bewart        | Vorgangspreis     |
    | abbewart      | Preis des Zugangs |
    | stornoverur   |                   |
    | buart         | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mge           | 25                |
    | bewwert       | 1550.00           |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   |
    |  6   | 5.0000   | 0.0000    | direkt    | !JournalTWG1^vom | !JournalTWG1^id | !JournalZu1^id | !JournalZu1^id |         |
    |  19  | 80.0000  | 0.0000    | vorläufig | !JournalZu1^vom  | !JournalZu1^id  | !JournalZu1^id | !JournalZu1^id |         |
And I close the current editor

# ueber das Feld "vorgaenger" die erste Bewertung zum Lieferschein pruefen
Given I open an editor "VorgaengerBW" via ID from editor "VorgaengerBW1" from field "vorgaenger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 25                    |
    | bewwert       | 1556.00               |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet  | tbudat          | kverur^id      | orig^id        | beworig^id     | vkpos   |
    |  6   | 6.0000   | 0.0000    | direkt    | !JournalRE1^vom | !JournalRE1^id | !JournalZu1^id | !JournalZu1^id |         |
    |  19  | 80.0000  | 0.0000    | vorläufig | !JournalZu1^vom | !JournalZu1^id | !JournalZu1^id | !JournalZu1^id |         |
And I close the current editor

# Storno Komplettwertgutschrift
Given I open an editor "STORNO-KWG" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KWG-RE2-BE230"
And I save the current editor

# Journaleintrag zum Storno
Given I open an editor "JournalKWGStorno" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE230;mge==12;buarta==Neubewertung;platz==F1;ebeleg==KWG230RE2"
And I close the current editor

# Bewertung zum Lieferschein
Given I open latest Valuation "BewertungZu1.4" for Product "TE230" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 25                    |
    | bewwert       | 722.00                |
    | vorgaenger^id | !BewertungZu1.3^id    |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   |
    | 12   | 12.0000  | 0.0000    | direkt    | !JournalRE2^vom  | !JournalRE2^id  | !JournalZu1^id | !JournalZu1^id |         |
    |  6   | 3.0000   | 0.0000    | direkt    | !JournalTWG2^vom | !JournalTWG2^id | !JournalZu1^id | !JournalZu1^id |         |
    |  7   | 80.0000  | 0.0000    | vorläufig | !JournalZu1^vom  | !JournalZu1^id  | !JournalZu1^id | !JournalZu1^id |         |
And I close the current editor

# Storno Teilwertgutschrift
Given I open an editor "STORNO-TWG2" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "TWG2-RE1-BE230"
And I save the current editor

# Journaleintrag zum Storno
Given I open an editor "JournalTWG2Storno" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE230;mge==6;buarta==Neubewertung;platz==F1;ebeleg==TWG2BE230"
And I close the current editor

# Bewertung zum Lieferschein
Given I open latest Valuation "BewertungZu1.5" for Product "TE230" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalZu1^id        |
    | beistelldaten     | nein                  |
    | bewart            | Vorgangspreis         |
    | abbewart          | Preis des Zugangs     |
    | stornoverur^id    | !JournalTWG2Storno^id |
    | buart             | Neubewertung          |
    | ursache           | Rechnung              |
    | detursache        | Storno Wertgutschrift |
    | mge               | 25                    |
    | bewwert           | 734.00                |
    | vorgaenger^id     | !BewertungZu1.4^id    |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   |
    | 12   | 12.0000  | 0.0000    | direkt    | !JournalRE2^vom  | !JournalRE2^id  | !JournalZu1^id | !JournalZu1^id |         |
    |  6   | 5.0000   | 0.0000    | direkt    | !JournalTWG1^vom | !JournalTWG1^id | !JournalZu1^id | !JournalZu1^id |         |
    |  7   | 80.0000  | 0.0000    | vorläufig | !JournalZu1^vom  | !JournalZu1^id  | !JournalZu1^id | !JournalZu1^id |         |
And I close the current editor


Scenario: 31 EK - BE, Teil-RE ohne Lagerbewegung, Teil-LS aus BE, Teilwertgutschrift, Teil-LS aus BE

Given I open an editor "TE231" from table "(Part):(Product)" with command "STORE" for record "TE231"
And I set fields
    | such      | TE231                |
    | namebspr  | Schraube 231         |
    | vpr       | 15                   |
    | epr       | 50.00                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "BE231" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE231   |
    | such   | BE-231   |
    | ebeleg | BE-231   |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis | verw  |
    | TE231   | 100 | 50    | EK231 |
And I save the current editor

# Teilrechnung 1 ohne Lagerbewegung, aus Bestellung erstellen und buchen
Given I open an editor "RE1-BE231" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE231"
And I set fields
    | nummer | 1EKRE231    |
    | ebeleg | RE1-BE231   |
    | such   | RE1-BE231   |
    | ueb    | ja          |
    | vom    | .           |
    | tterm  | .           |
    | fakt   | nein        |
And I modify table
    | !row  | mge   | preis   |
    | 1     | 50    | 24.00   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "JournalRE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE231;buarta==Neubewertung;platz==F1;ebeleg==RE1-BE231;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE231             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | 50                |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Rechnung          |
    | epr           | 24.0000           |
And I close the current editor

# Bewertungsammler pruefen 50 Stueck aus der RE 1 warten auf den Zugang
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE231"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L1EKRE231 | 50    | 24.0000   | !JournalRE1^id    |
And I close the current editor

# Lieferschein 1 aus Bestellung, Teilmenge
Given I open an editor "LS1-ZU-BE231" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE231"
And I set fields
   | nummer | 1EKLS231  |
   | ebeleg | LS1-BE231 |
   | such   | LS1-BE231 |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
Then field "fakt" has value "nein"
And I set field "mge" to "20" in row 1
Then field "preis" has value "50.00" in row 1
And I save the current editor

# Journaleintraege
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE231;buarta==Zugang;platz==F1;ebeleg==LS1-BE231"
Then fields have values
    | artikel       | TE231                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 20                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | epr           | 50.0000               |
And I close the current editor

# Bewertungsammler pruefen 30 Stueck aus der RE 1 warten auf den Zugang, 20 geliefert
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE231"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L1EKRE231 | 30    | 24.0000   | !JournalRE1^id    |
And I close the current editor

# Bewertung zum Lieferschein
Given I open latest Valuation "BewertungZu1.1" for Product "TE231" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 20                    |
    | bewwert       | 480.00                |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet  | tbudat          | kverur^id      | orig^id        | beworig^id     | vkpos   |
    | 20   | 24.0000  | 0.0000    | direkt    | !JournalRE1^vom | !JournalRE1^id | !JournalZu1^id | !JournalZu1^id |         |
And I close the current editor

# Teilwertgutschrift zu RE 1 gesamte Menge, reduzierter Preis
Given I open an editor "TWG-RE1-BE231" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-BE231"
And I set fields
    | nummer | 1TWG231    |
    | such   | TWGBE231   |
    | ebeleg | TWGBE231   |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis    |
    | 1     | -50   | 1.00     |
And I save the current editor

# Bewertungsammler bleibt unveraendert
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE231"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L1EKRE231 | 30    | 24.0000   | !JournalRE1^id    |
And I close the current editor

# Journaleintrag Teilwertgutschrift 1 (es entstehen 2 Journaleitnraege, 20 fuer gelieferte Menge und 30 fuer nicht gelieferte Menge)
Given I open an editor "JournalTWG1.1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE231;mge==-20;buarta==Neubewertung;platz==F1;ebeleg==TWGBE231;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE231             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -20               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 1.0000            |
And I close the current editor

Given I open an editor "JournalTWG1.2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE231;mge==-30;buarta==Neubewertung;platz==F1;ebeleg==TWGBE231;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE231             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -30               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 1.0000            |
And I close the current editor

# Bewertung zu Lieferschein 1
Given I open latest Valuation "BewertungZu1.2" for Product "TE231" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 20                    |
    | bewwert       | 460.00                |
    | vorgaenger^id | !BewertungZu1.1^id    |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet  | tbudat             | kverur^id         | orig^id        | beworig^id     | vkpos   |
    | 20   | 23.0000  | 0.0000    | direkt    | !JournalTWG1.1^vom | !JournalTWG1.1^id | !JournalZu1^id | !JournalZu1^id |         |
And I close the current editor

# Lieferschein 2 aus Bestellung, Teilmenge
Given I open an editor "LS2-ZU-BE231" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE231"
And I set fields
   | nummer | 2EKLS231  |
   | ebeleg | LS2-BE231 |
   | such   | LS2-BE231 |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
Then field "fakt" has value "nein"
And I set field "mge" to "10" in row 1
Then field "preis" has value "50.00" in row 1
And I save the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE231;buarta==Zugang;platz==F1;ebeleg==LS2-BE231"
Then fields have values
    | artikel       | TE231                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 10                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | epr           | 50.0000               |
And I close the current editor

# Bewertungsammler pruefen 20 Stueck aus der RE 1 warten auf den Zugang, 30 geliefert
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE231"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L1EKRE231 | 20    | 24.0000   | !JournalRE1^id    |
And I close the current editor

# aktuelle Bewertung zum Lieferschein 2
Given I open latest Valuation "BewertungZu2.2" for Product "TE231" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id    |
    | beistelldaten | nein              |
    | bewart        | Vorgangspreis     |
    | abbewart      | Preis des Zugangs |
    | stornoverur   |                   |
    | buart         | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mge           | 10                |
    | bewwert       | 230.00            |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet  | tbudat             | kverur^id         | orig^id        | beworig^id     | vkpos   |
    | 10   | 23.0000  | 0.0000    | direkt    | !JournalTWG1.2^vom | !JournalTWG1.2^id | !JournalZu2^id | !JournalZu2^id |         |
And I close the current editor

# ueber das Feld "vorgaenger" die abgelegte Bewertung zum Lieferschein pruefen
Given I open an editor "VorgaengerBW" via ID from editor "BewertungZu2.2" from field "vorgaenger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 10                    |
    | bewwert       | 240.00                |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet  | tbudat          | kverur^id      | orig^id        | beworig^id     | vkpos   |
    |  10  | 24.0000  | 0.0000    | direkt    | !JournalRE1^vom | !JournalRE1^id | !JournalZu2^id | !JournalZu2^id |         |
And I close the current editor


Scenario: 47 EK - RE ohne Lagerbewegung, Teilwertgutschriften, Lieferschein, Storno Teilwertgutschriften

Given I open an editor "TE247" from table "(Part):(Product)" with command "STORE" for record "TE247"
And I set fields
    | such      | TE247                |
    | namebspr  | Schraube 247         |
    | vpr       | 15                   |
    | epr       | 50.00                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "BE247" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief      | 001      |
    | nummer    | 1BE247   |
    | such      | BE-247   |
    | ebeleg    | BE-247   |
    | tterm     | .        |
    | budat     | .        |
And I append rows
    | artikel   | mge | preis | verw  |
    | TE247     | 100 | 9     | EK247 |
And I save the current editor

# Rechnung ohne Lagerbewegung, aus Bestellung
Given I open an editor "RE-BE247" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE247"
And I set fields
    | nummer    | 1EKRE247    |
    | ebeleg    | RE-BE247    |
    | such      | RE-BE247    |
    | ueb       | ja          |
    | vom       | .           |
    | tterm     | .           |
    | fakt      | nein        |
And I modify table
    | !row      | mge | preis |
    | 1         | 100 | 10.00 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 1
Given I open an editor "JournalRE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE247;buarta==Neubewertung;platz==F1;ebeleg==RE-BE247"
Then fields have values
    | artikel    | TE247                 |
    | platz      | F1                    |
    | lgruppe    | KARLSRUHE             |
    | mge        | 100                   |
    | buart      | 6                     |
    | buarta     | Neubewertung          |
    | ursache    | Rechnung              |
    | detursache | Rechnung              |
    | mpr        | 10.0000               |
    | mpra       | 0.0000                |
    | epr        | 10.0000               |
And I close the current editor

# Bewertungsammler pruefen 100 Stueck aus der Rechnung warten auf den Zugang
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE247"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L1EKRE247 | 100   | 10.0000   | !JournalRE1^id    |
And I close the current editor

# Lieferschein Teilmenge
Given I open an editor "LS1-ZU-BE247" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE247"
And I set fields
   | nummer | 1EKLS247  |
   | ebeleg | LS1-BE247 |
   | such   | LS1-BE247 |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
Then field "fakt" has value "nein"
And I set field "mge" to "50" in row 1
And I save the current editor

# Journaleintraege
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE247;buarta==Zugang;platz==F1;ebeleg==LS1-BE247"
Then fields have values
    | artikel       | TE247                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 50                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | epr           | 9.0000                |
And I close the current editor

# Bewertungsammler pruefen 50 Stueck aus der Rechnung warten auf den Zugang
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE247"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L1EKRE247 | 50    | 10.0000   | !JournalRE1^id    |
And I close the current editor

# Bewertung Lieferschein 1
Given I open latest Valuation "BewertungZu1.1" for Product "TE247" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 50                    |
    | bewwert       | 500.00                |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet | tbudat          | kverur^id       | orig^id        | beworig^id     | vkpos   | datum             |
    | 50   | 10.0000 | 0.0000    | direkt   | !JournalRE1^vom | !JournalRE1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalRE1^stand |
And I close the current editor

# Teilwertgutschrift 1 gesamte Menge, reduzierter Preis
Given I open an editor "TWG1-RE-BE247" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-BE247"
And I set fields
    | nummer    | 1WERTRE    |
    | such      | EK1TWG1    |
    | ebeleg    | EK1TEILWG1 |
    | tterm     | .          |
    | budat     | .          |
    | vom       | .          |
    | ueb       | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis  |
    | 1     | -100  | 1.00   |
And I save the current editor

# Teilwertgutschrift 2 gesamte Menge, reduzierter Preis
Given I open an editor "TWG2-RE-BE247" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-BE247"
And I set fields
    | nummer    | 1WERT2RE   |
    | such      | EK2TWG2    |
    | ebeleg    | EK2TEILWG2 |
    | tterm     | .          |
    | budat     | .          |
    | vom       | .          |
    | ueb       | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis  |
    | 1     | -100  | 1.00   |
And I save the current editor

# Teilwertgutschrift 3 gesamte Menge, reduzierter Preis
Given I open an editor "TWG3-RE-BE247" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-BE247"
And I set fields
    | nummer    | 1WERT3RE   |
    | such      | EK3TWG3    |
    | ebeleg    | EK3TEILWG3 |
    | tterm     | .          |
    | budat     | .          |
    | vom       | .          |
    | ueb       | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis  |
    | 1     | -100  | 1.00   |
And I save the current editor

Given I open an editor "JournalTWG1.1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE247;buarta==Neubewertung;platz==F1;ebeleg==EK1TEILWG1;@richtung=rückwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE247             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -50               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 1.0000            |
And I close the current editor

Given I open an editor "JournalTWG1.2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE247;buarta==Neubewertung;platz==F1;ebeleg==EK1TEILWG1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE247             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -50               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 1.0000            |
And I close the current editor

Given I open an editor "JournalTWG2.1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE247;buarta==Neubewertung;platz==F1;ebeleg==EK2TEILWG2;@richtung=rückwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE247             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -50               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 1.0000            |
And I close the current editor

Given I open an editor "JournalTWG2.2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE247;buarta==Neubewertung;platz==F1;ebeleg==EK2TEILWG2;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE247             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -50               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 1.0000            |
And I close the current editor

Given I open an editor "JournalTWG3.1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE247;buarta==Neubewertung;platz==F1;ebeleg==EK3TEILWG3;@richtung=rückwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE247             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -50               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 1.0000            |
And I close the current editor

Given I open an editor "JournalTWG3.2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE247;buarta==Neubewertung;platz==F1;ebeleg==EK3TEILWG3;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE247             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -50               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 1.0000            |
And I close the current editor

# Bewertung Lieferschein 1
Given I open latest Valuation "BewertungZu1.2" for Product "TE247" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id    |
    | beistelldaten | nein              |
    | bewart        | Vorgangspreis     |
    | abbewart      | Preis des Zugangs |
    | stornoverur   |                   |
    | buart         | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mge           | 50                |
    | bewwert       | 350.00            |
Then table has values
    | tmge | tbewpr | addkosten | bewertet | tbudat             | kverur^id         | orig^id        | beworig^id     | vkpos   | datum                |
    | 50   | 7.0000 | 0.0000    | direkt   | !JournalTWG3.1^vom | !JournalTWG3.1^id | !JournalZu1^id | !JournalZu1^id |         | !JournalTWG3.1^stand |
And I close the current editor

# Bewertungsammler pruefen 50 Stueck aus der Rechnung warten auf den Zugang, Wert bleibt bei TWG
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE247"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L1EKRE247 | 50    | 10.0000   | !JournalRE1^id    |
And I close the current editor

# Lieferschein ueber Restmenge
Given I open an editor "LS2-ZU-BE247" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE247"
And I set fields
   | nummer     | 2EKLS247  |
   | ebeleg     | LS2-BE247 |
   | such       | LS2-BE247 |
   | ueb        | ja        |
   | vom        | .         |
   | tterm      | .         |
Then field "fakt" has value "nein"
And I set field "mge" to "50" in row 1
And I save the current editor

# Journaleintraege
Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE247;buarta==Zugang;platz==F1;ebeleg==LS2-BE247"
Then fields have values
    | artikel       | TE247                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 50                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | epr           | 9.0000                |
And I close the current editor

# Bewertungsammler ist weg, gesamte Menge geliefert
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L1EKRE247"
Then query has no hits
And I close the current editor

# Bewertung Lieferschein 2, Wertgutschrift 3
Given I open latest Valuation "BewertungZu1.4" for Product "TE247" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id    |
    | beistelldaten | nein              |
    | bewart        | Vorgangspreis     |
    | abbewart      | Preis des Zugangs |
    | stornoverur   |                   |
    | buart         | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mge           | 50                |
    | bewwert       | 350.00            |
Then table has values
    | tmge | tbewpr | addkosten | bewertet | tbudat             | kverur^id          | orig^id        | beworig^id     | vkpos   | datum                |
    | 50   | 7.0000 | 0.0000    | direkt   | !JournalTWG3.2^vom | !JournalTWG3.2^id  | !JournalZu2^id | !JournalZu2^id |         | !JournalTWG3.2^stand |
And I close the current editor

# Bewertung, Wertgutschrift 2
Given I open an editor "VorgaengerBW2" via ID from editor "BewertungZu1.4" from field "vorgaenger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id    |
    | beistelldaten | nein              |
    | bewart        | Vorgangspreis     |
    | abbewart      | Preis des Zugangs |
    | stornoverur   |                   |
    | buart         | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mge           | 50                |
    | bewwert       | 400.00            |
Then table has values
    | tmge | tbewpr | addkosten | bewertet | tbudat             | kverur^id          | orig^id        | beworig^id     | vkpos   | datum                |
    | 50   | 8.0000 | 0.0000    | direkt   | !JournalTWG2.2^vom | !JournalTWG2.2^id  | !JournalZu2^id | !JournalZu2^id |         | !JournalTWG2.2^stand |
And I close the current editor

# Bewertung, Wertgutschrift 1
Given I open an editor "VorgaengerBW1" via ID from editor "VorgaengerBW2" from field "vorgaenger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id    |
    | beistelldaten | nein              |
    | bewart        | Vorgangspreis     |
    | abbewart      | Preis des Zugangs |
    | stornoverur   |                   |
    | buart         | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mge           | 50                |
    | bewwert       | 450.00            |
Then table has values
    | tmge | tbewpr | addkosten | bewertet | tbudat             | kverur^id          | orig^id        | beworig^id     | vkpos   | datum                |
    | 50   | 9.0000 | 0.0000    | direkt   | !JournalTWG1.2^vom | !JournalTWG1.2^id  | !JournalZu2^id | !JournalZu2^id |         | !JournalTWG1.2^stand |
And I close the current editor

# Bewertung zu Lieferschein 2, Rechnung
Given I open an editor "VorgaengerBW-RE" via ID from editor "VorgaengerBW1" from field "vorgaenger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 50                    |
    | bewwert       | 500.00                |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet | tbudat          | kverur^id       | orig^id        | beworig^id     | vkpos   |
    | 50   | 10.0000 | 0.0000    | direkt   | !JournalRE1^vom | !JournalRE1^id  | !JournalZu2^id | !JournalZu2^id |         |
And I close the current editor
