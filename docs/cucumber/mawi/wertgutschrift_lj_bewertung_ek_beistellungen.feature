# *****************************************************************************
#  Name           : wertgutschrift_lj_bewertung_ek_beistellungen.feature
#  Verantwortlich : bschiga
#  Kontrolle      : carue
#  Funktion       : Test der LJ und Bewertungen bei Wertgutschriften
#
# *****************************************************************************
#
@persistent
Feature: wertgutschrift_lj_bewertung_ek_beistellungen.feature
Background:
Given I set the fake date to "02.01.1995"

Scenario: Stammdaten

Given I open an editor "firma" from table "(Company):(ValuationConfiguration)" with command "UPDATE" for record "10"
And I modify table
  | !row | bewab             | bewzu         |
  | 1    | Preis des Zugangs | Vorgangspreis |
And I save the current editor


Scenario: 41 EK mit Beistellung - Bestellung, Lieferschein mit MZ und Charge, Rechnung Gesamtmenge, zwei Teilwertgutschriften

Given I open an editor "TE141" from table "(Part):(Product)" with command "STORE" for record "TE141"
And I set fields
    | such      | TE141                 |
    | namebspr  | Schraube 141          |
    | vpr       | 15                    |
    | epr       | 10.50                 |
    | bsart     | Fremdbeschaffung      |
    | dispoa    | auftragsbezogen       |
    | chverfolgung | Chargenverfolgung                    |
    | chimlager | ja                    |
    | ekbewverf | 1                     |
And I delete all rows
And I append rows
    | elex  | elanzahl  | bua                       |
    | E3    | 2         | Lieferantenbeistellung    |
And I save the current editor

Given I create a Lot "CH1" for Product "TE141"
Given I create a Lot "CH2" for Product "TE141"
Given I create a Lot "CH3" for Product "TE141"
Given I create a Lot "CH4" for Product "TE141"

Given I open an editor "BE-141" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE141   |
    | such   | BE-141   |
    | ebeleg | BE-141   |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis |
    | TE141   | 10  | 10    |
And I save the current editor

# Lieferscheine aus Bestellung, Gesamtmenge mit 4 MZ, Charge, Rechnung soll aus Bestellung erzeugt werden
Given I open an editor "LS1-ZU-BE141" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE141"
And I set fields
   | nummer | 1EKLS141  |
   | ebeleg | LS1-BE141 |
   | such   | LS1-BE141 |
   | ueb    | ja        |
   | fakt   | nein      |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "10" in row 1
Then field "preis" has value "10.00" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge | charge  |
    | F1     |  1     | !CH1^id |
    | F2     |  2     | !CH2^id |
    | F3     |  3     | !CH3^id |
    | F2     |  4     | !CH4^id |
And I save the current editor
And I switch the current editor to editor "LS1-ZU-BE141"
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE141;mge==1;buarta==Zugang;platz==F1;ebeleg==LS1-BE141"
Then fields have values
    | artikel       | TE141                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 1                     |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mpr           | 0.0000                |
    | mpra          | 0.0000                |
    | epr           | 10.0000               |
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE141;mge==2;buarta==Zugang;platz==F2;ebeleg==LS1-BE141"
Then fields have values
    | artikel       | TE141                 |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 2                     |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mpr           | 0.0000                |
    | mpra          | 0.0000                |
    | epr           | 10.0000               |
And I close the current editor

Given I open an editor "JournalZu3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE141;mge==3;buarta==Zugang;platz==F3;ebeleg==LS1-BE141"
Then fields have values
    | artikel       | TE141                 |
    | platz         | F3                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 3                     |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mpr           | 0.0000                |
    | mpra          | 0.0000                |
    | epr           | 10.0000               |
And I close the current editor

Given I open an editor "JournalZu4" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE141;mge==4;buarta==Zugang;platz==F2;ebeleg==LS1-BE141"
Then fields have values
    | artikel       | TE141                 |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 4                     |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mpr           | 0.0000                |
    | mpra          | 0.0000                |
    | epr           | 10.0000               |
And I close the current editor

# Journal Abgaenge Beistellteil
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==E3;mge==2;buarta==Abgang;platz==F2;ebeleg==LS1-BE141"
Then fields have values
    | artikel       | E3                    |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 2                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | epr           | 0.0000                |
And I close the current editor

Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==E3;mge==4;buarta==Abgang;platz==F2;ebeleg==LS1-BE141"
Then fields have values
    | artikel       | E3                    |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 4                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | epr           | 0.0000                |
And I close the current editor

Given I open an editor "JournalAb3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==E3;mge==6;buarta==Abgang;platz==F2;ebeleg==LS1-BE141"
Then fields have values
    | artikel       | E3                    |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 6                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | epr           | 0.0000                |
And I close the current editor

Given I open an editor "JournalAb4" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==E3;mge==8;buarta==Abgang;platz==F2;ebeleg==LS1-BE141"
Then fields have values
    | artikel       | E3                    |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 8                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | epr           | 0.0000                |
And I close the current editor

# Rechnung 1 erstellen und buchen, Gesamtmenge
Given I open an editor "RE1-ZU-BE141" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE141"
And I set fields
    | nummer | 1EKRE141  |
    | ebeleg | RE1-BE141 |
    | such   | RE1-BE141 |
    | ueb    | ja        |
    | vom    | .         |
    | tterm  | .         |
And I set field "mge" to "10" in row 1
Then field "preis" has value "10.00" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 1
Given I open an editor "JournalRE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE141;buarta==Neubewertung;platz==F1;ebeleg==RE1-BE141"
Then fields have values
    | artikel       | TE141                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 10                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 10.0000               |
    | mpra          | 0.0000                |
    | epr           | 10.0000               |
And I close the current editor

# Bewertungen zu den Lieferscheinen, Nach Buchen der Rechnung 1, Kenner beistelldaten=nein
Given I open latest Valuation "BewertungZu1.2" for Product "TE141" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 1                     |
    | bewwert       | 10.00                 |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   |
    | 1    | 10.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id  | !JournalZu1^id | !JournalZu1^id |         |
And I close the current editor

Given I open latest Valuation "BewertungZu2.2" for Product "TE141" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 2                     |
    | bewwert       | 20.00                 |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   |
    | 2    | 10.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id  | !JournalZu2^id | !JournalZu2^id |         |
And I close the current editor

Given I open latest Valuation "BewertungZu3.2" for Product "TE141" and valuation transaction "JournalZu3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu3^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 3                     |
    | bewwert       | 30.00                 |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   |
    | 3    | 10.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id  | !JournalZu3^id | !JournalZu3^id |         |
And I close the current editor

Given I open latest Valuation "BewertungZu4.2" for Product "TE141" and valuation transaction "JournalZu4" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu4^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 4                     |
    | bewwert       | 40.00                 |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   |
    | 4    | 10.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id  | !JournalZu4^id | !JournalZu4^id |         |
And I close the current editor

# Bewertungen zu den Lieferscheinen, Nach Buchen der Rechnung 1, Kenner beistelldaten=ja
Given I open latest Valuation "BewertungBei1.2" for Product "TE141" and valuation transaction "JournalZu1" with command "VIEW" for material provided
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | ja                    |
    | bewart        |                       |
    | abbewart      |                       |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 1                     |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat          | kverur^id       | orig  | beworig  | vkpos   |
    | 1    | 0.0000   | 0.0000    | unbewertet  | !JournalZu1^vom | !JournalZu1^id  |       |          |         |
And I close the current editor

Given I open latest Valuation "BewertungBei2.2" for Product "TE141" and valuation transaction "JournalZu2" with command "VIEW" for material provided
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | ja                    |
    | bewart        |                       |
    | abbewart      |                       |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 2                     |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat          | kverur^id        | orig  | beworig  | vkpos   |
    | 2    | 0.0000   | 0.0000    | unbewertet  | !JournalZu2^vom | !JournalZu2^id   |       |          |         |
And I close the current editor

Given I open latest Valuation "BewertungBei3.2" for Product "TE141" and valuation transaction "JournalZu3" with command "VIEW" for material provided
Then fields have values
    | ppsref^id     | !JournalZu3^id        |
    | beistelldaten | ja                    |
    | bewart        |                       |
    | abbewart      |                       |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 3                     |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat          | kverur^id       | orig  | beworig  | vkpos   |
    | 3    | 0.0000   | 0.0000    | unbewertet  | !JournalZu3^vom | !JournalZu3^id  |       |          |         |
And I close the current editor

Given I open latest Valuation "BewertungBei4.2" for Product "TE141" and valuation transaction "JournalZu4" with command "VIEW" for material provided
Then fields have values
    | ppsref^id     | !JournalZu4^id        |
    | beistelldaten | ja                    |
    | bewart        |                       |
    | abbewart      |                       |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 4                     |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat          | kverur^id       | orig  | beworig  | vkpos   |
    | 4    | 0.0000   | 0.0000    | unbewertet  | !JournalZu4^vom | !JournalZu4^id  |       |          |         |
And I close the current editor

# Bewertung zum Abgang Beistellteil
Given I open latest Valuation "BewertungAb1" for Product "E3" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | bewart        | Preis des Zugangs     |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 2                     |
    | bewwert       | 0.00                  |
    | vorgaenger    |                       |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat          | kverur   | orig  | beworig  | vkpos   | datum              |
    | 2    | 0.0000   | 0.0000    | unbewertet  | !JournalAb1^vom |          |       |          |         | !JournalAb1^stand  |
And I close the current editor

Given I open latest Valuation "BewertungAb2" for Product "E3" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | bewart        | Preis des Zugangs     |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 4                     |
    | bewwert       | 0.00                  |
    | vorgaenger    |                       |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat          | kverur   | orig  | beworig  | vkpos   | datum              |
    | 4    | 0.0000   | 0.0000    | unbewertet  | !JournalAb2^vom |          |       |          |         | !JournalAb2^stand  |
And I close the current editor

Given I open latest Valuation "BewertungAb3" for Product "E3" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3^id        |
    | beistelldaten | nein                  |
    | bewart        | Preis des Zugangs     |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 6                     |
    | bewwert       | 0.00                  |
    | vorgaenger    |                       |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat          | kverur   | orig  | beworig  | vkpos   | datum              |
    | 6    | 0.0000   | 0.0000    | unbewertet  | !JournalAb3^vom |          |       |          |         | !JournalAb3^stand  |
And I close the current editor

Given I open latest Valuation "BewertungAb4" for Product "E3" and valuation transaction "JournalAb4" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb4^id        |
    | beistelldaten | nein                  |
    | bewart        | Preis des Zugangs     |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 8                     |
    | bewwert       | 0.00                  |
    | vorgaenger    |                       |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat          | kverur   | orig  | beworig  | vkpos   | datum              |
    | 8    | 0.0000   | 0.0000    | unbewertet  | !JournalAb4^vom |          |       |          |         | !JournalAb4^stand  |
And I close the current editor


# Teilwertgutschrift zu Rechnung 1 buchen, fuer 1 Stueck mit CH1, Preis 10,00
Given I open an editor "WERT-RE1-BE141" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE141"
And I set fields
    | nummer | 1TWGRE1    |
    | such   | EK1TWG141  |
    | ebeleg | EK1TWG141  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis     | charge    |
    | 1     | -1    | 10.00     | !CH1^id   |
And I save the current editor

# die Wertgutschrift betrifft nur die Menge auf Platz F1
Given I open an editor "JournalTWG1RE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE141;buarta==Neubewertung;platz==F1;ebeleg==EK1TWG141;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE141             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -1                |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpra          | 10.0000           |
    | epr           | 10.0000           |
And I close the current editor

# die Menge mit Charge CH1 wurde neu bewertet
Given I open latest Valuation "BewertungZu1.3" for Product "TE141" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 1                     |
    | bewwert       | 0.00                  |
    | vorgaenger^id | !BewertungZu1.2^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id           | orig^id        | beworig^id     | vkpos   | datum                   |
    | 1    | 0.0000  | 0.0000    | direkt    | !JournalTWG1RE1^vom  | !JournalTWG1RE1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalTWG1RE1^stand   |
And I close the current editor

# keine Veraenderung
Given I open latest Valuation "BewertungZu2.3" for Product "TE141" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 2                     |
    | bewwert       | 20.00                 |
    | nachfolger    |                       |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   | datum              |
    | 2    | 10.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id  | !JournalZu2^id | !JournalZu2^id |         | !JournalRE1^stand  |
And I close the current editor

# keine Veraenderung
Given I open latest Valuation "BewertungZu3.2" for Product "TE141" and valuation transaction "JournalZu3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu3^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 3                     |
    | bewwert       | 30.00                 |
    | nachfolger    |                       |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   | datum              |
    | 3    | 10.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id  | !JournalZu3^id | !JournalZu3^id |         | !JournalRE1^stand  |
And I close the current editor

# keine Veraenderung
Given I open latest Valuation "BewertungZu4.2" for Product "TE141" and valuation transaction "JournalZu4" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu4^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 4                     |
    | bewwert       | 40.00                 |
    | nachfolger    |                       |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   | datum              |
    | 4    | 10.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id  | !JournalZu4^id | !JournalZu4^id |         | !JournalRE1^stand  |
And I close the current editor

# Bewertung zum Abgang des Beistellteils hat sich nicht veraendert, es gibt keinen Vorgaenger oder Nachfolger
Given I open latest Valuation "BewertungAb1" for Product "E3" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | bewart        | Preis des Zugangs     |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 2                     |
    | bewwert       | 0.00                  |
    | vorgaenger    |                       |
    | nachfolger    |                       |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat          | kverur   | orig   | beworig  | vkpos   | datum              |
    | 2    | 0.0000   | 0.0000    | unbewertet  | !JournalAb1^vom |          |        |          |         | !JournalAb1^stand  |
And I close the current editor

# Teilwertgutschrift 2 zu Rechnung 1 buchen, OHNE Charge, 3 Stueck zu Preis 10, insgesamt Wert 30,- (wird auf alle restliche Chargen verteilt)
Given I open an editor "WERT-RE1-BE141" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE141"
And I set fields
    | nummer | 1TWG2RE1   |
    | such   | EK2TWG141  |
    | ebeleg | EK2TWG141  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis     |
    | 1     | -3    | 10.00     |
And I save the current editor

Given I open an editor "JournalTWG2RE1.1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE141;buarta==Neubewertung;platz==F1;mge==-1;ebeleg==EK2TWG141;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE141             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -1                |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpra          | 10.0000           |
    | epr           |  0.0000           |
And I close the current editor

Given I open an editor "JournalTWG2RE1.2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE141;buarta==Neubewertung;platz==F2;mge==-2;ebeleg==EK2TWG141;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE141             |
    | platz         | F2                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -2                |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpra          | 10.0000           |
    | epr           |  3.3333           |
And I close the current editor

Given I open an editor "JournalTWG2RE1.3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE141;buarta==Neubewertung;platz==F3;mge==-3;ebeleg==EK2TWG141;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE141             |
    | platz         | F3                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -3                |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpra          | 10.0000           |
    | epr           |  3.3333           |
And I close the current editor

Given I open an editor "JournalTWG2RE1.4" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE141;buarta==Neubewertung;platz==F2;mge==-4;ebeleg==EK2TWG141;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE141             |
    | platz         | F2                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -4                |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpra          | 10.0000           |
    | epr           |  3.3333           |
And I close the current editor

# ist schon komplett gutgeschrieben
Given I open latest Valuation "BewertungZu1.4" for Product "TE141" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 1                     |
    | bewwert       | 0.00                  |
    | vorgaenger^id | !BewertungZu1.3^id    |
    | nachfolger    |                       |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat                | kverur^id            | orig^id        | beworig^id     | vkpos   | datum                   |
    | 1    | 0.0000  | 0.0000    | direkt    | !JournalTWG2RE1.1^vom | !JournalTWG2RE1.1^id | !JournalZu1^id | !JournalZu1^id |         | !JournalTWG1RE1^stand   |
And I close the current editor

# pauschalisiert gutgeschrieben
Given I open latest Valuation "BewertungZu2.4" for Product "TE141" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 2                     |
    | bewwert       | 13.33                 |
    | vorgaenger^id | !BewertungZu2.3^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat                 | kverur^id             | orig^id        | beworig^id     | vkpos   | datum                    |
    | 2    | 6.6667  | 0.0000    | direkt    | !JournalTWG2RE1.2^vom  | !JournalTWG2RE1.2^id  | !JournalZu2^id | !JournalZu2^id |         | !JournalTWG2RE1.2^stand  |
And I close the current editor

Given I open latest Valuation "BewertungZu3.4" for Product "TE141" and valuation transaction "JournalZu3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu3^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 3                     |
    | bewwert       | 20.00                 |
    | vorgaenger^id | !BewertungZu3.2^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat                 | kverur^id             | orig^id        | beworig^id     | vkpos   | datum                    |
    | 3    | 6.6667  | 0.0000    | direkt    | !JournalTWG2RE1.3^vom  | !JournalTWG2RE1.3^id  | !JournalZu3^id | !JournalZu3^id |         | !JournalTWG2RE1.3^stand  |
And I close the current editor

Given I open latest Valuation "BewertungZu4.4" for Product "TE141" and valuation transaction "JournalZu4" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu4^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 4                     |
    | bewwert       | 26.67                 |
    | vorgaenger^id | !BewertungZu4.2^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat                   | kverur^id             | orig^id        | beworig^id     | vkpos   | datum                    |
    | 4    | 6.6667  | 0.0000    | direkt    |  !JournalTWG2RE1.4^vom   | !JournalTWG2RE1.4^id  | !JournalZu4^id | !JournalZu4^id |         | !JournalTWG2RE1.4^stand  |
And I close the current editor

# Bewertungen zu den Zugaengen des Kaufteils mit Kenner beistelldaten=ja haben sich nicht veraendert, es gibt keine Bewertung dazu mit buart Neubewertung
Then opening an editor from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel==TE141;buart==Neubewertung;beistelldaten==ja;@richtung=vorwärts;@maxordtreffer=1" throws the exception "149"

# Bewertungen mit Kenner beistelldaten=ja und buart=Zugang
Given I open latest Valuation "BewertungBei1.2" for Product "TE141" and valuation transaction "JournalZu1" with command "VIEW" for material provided
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | ja                    |
    | bewart        |                       |
    | abbewart      |                       |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 1                     |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat          | kverur^id       | orig  | beworig  | vkpos   |
    | 1    | 0.0000   | 0.0000    | unbewertet  | !JournalZu1^vom | !JournalZu1^id  |       |          |         |
And I close the current editor

Given I open latest Valuation "BewertungBei2.2" for Product "TE141" and valuation transaction "JournalZu2" with command "VIEW" for material provided
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | ja                    |
    | bewart        |                       |
    | abbewart      |                       |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 2                     |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat          | kverur^id       | orig  | beworig  | vkpos   |
    | 2    | 0.0000   | 0.0000    | unbewertet  | !JournalZu2^vom | !JournalZu2^id  |       |          |         |
And I close the current editor

Given I open latest Valuation "BewertungBei3.2" for Product "TE141" and valuation transaction "JournalZu3" with command "VIEW" for material provided
Then fields have values
    | ppsref^id     | !JournalZu3^id        |
    | beistelldaten | ja                    |
    | bewart        |                       |
    | abbewart      |                       |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 3                     |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat          | kverur^id       | orig  | beworig  | vkpos   |
    | 3    | 0.0000   | 0.0000    | unbewertet  | !JournalZu3^vom | !JournalZu3^id  |       |          |         |
And I close the current editor

Given I open latest Valuation "BewertungBei4.2" for Product "TE141" and valuation transaction "JournalZu4" with command "VIEW" for material provided
Then fields have values
    | ppsref^id     | !JournalZu4^id        |
    | beistelldaten | ja                    |
    | bewart        |                       |
    | abbewart      |                       |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 4                     |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat          | kverur^id       | orig  | beworig  | vkpos   |
    | 4    | 0.0000   | 0.0000    | unbewertet  | !JournalZu4^vom | !JournalZu4^id  |       |          |         |
And I close the current editor

# Bewertung zum Abgang des Beistellteils hat sich nicht veraendert, es gibt keinen Vorgaenger oder Nachfolger
Given I open latest Valuation "BewertungAb1" for Product "E3" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | bewart        | Preis des Zugangs     |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 2                     |
    | bewwert       | 0.00                  |
    | vorgaenger    |                       |
    | nachfolger    |                       |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat          | kverur   | orig  | beworig  | vkpos   | datum              |
    | 2    | 0.0000   | 0.0000    | unbewertet  | !JournalAb1^vom |          |       |          |         | !JournalAb1^stand  |
And I close the current editor


Scenario: 42 EK mit Beistellung - BE, LS, RE, Komplettwertgutschrift, Storno WG, Teilwertgutschrift, Storno TWG, Storno RE

Given I open an editor "TE142" from table "(Part):(Product)" with command "STORE" for record "TE142"
And I set fields
    | such      | TE142                 |
    | namebspr  | Schraube 142          |
    | vpr       | 15                    |
    | epr       | 10.50                 |
    | bsart     | Fremdbeschaffung      |
    | dispoa    | auftragsbezogen       |
    | ekbewverf | 1                     |
And I delete all rows
And I append rows
    | elex  | elanzahl  | bua                       |
    | EINK  | 2         | Lieferantenbeistellung    |
And I save the current editor

Given I open an editor "BE-142" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE142   |
    | such   | BE-142   |
    | ebeleg | BE-142   |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis |
    | TE142   | 10  | 9     |
And I save the current editor

# Lieferscheine aus Bestellung, Gesamtmenge, Rechnung soll aus Bestellung erzeugt werden
Given I open an editor "LS1-ZU-BE142" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE142"
And I set fields
   | nummer | 1EKLS142  |
   | ebeleg | LS1-BE142 |
   | such   | LS1-BE142 |
   | ueb    | ja        |
   | fakt   | nein      |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "10" in row 1
Then field "preis" has value "9.00" in row 1
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE142;buarta==Zugang;platz==F1;ebeleg==LS1-BE142"
Then fields have values
    | artikel       | TE142                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 10                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mpr           | 0.0000                |
    | mpra          | 0.0000                |
    | epr           | 9.0000                |
And I close the current editor

# Journal Abgang Beistellteil
Given I open an editor "JournalAb" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EINK;buarta==Abgang;platz==F1;ebeleg==LS1-BE142"
Then fields have values
    | artikel       | EINK                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 20                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mpr           | 0.0000                |
    | mpra          | 0.0000                |
    | epr           | 0.0000                |
And I close the current editor

# Rechnung 1 erstellen und buchen, Gesamtmenge
Given I open an editor "RE1-ZU-BE142" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE142"
And I set fields
    | nummer | 1EKRE142  |
    | ebeleg | RE1-BE142 |
    | such   | RE1-BE142 |
    | ueb    | ja        |
    | vom    | .         |
    | tterm  | .         |
And I set field "mge" to "10" in row 1
And I set field "preis" to "10.00" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 1
Given I open an editor "JournalRE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE142;buarta==Neubewertung;platz==F1;ebeleg==RE1-BE142"
Then fields have values
    | artikel       | TE142                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 10                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 10.0000               |
    | mpra          | 0.0000                |
    | epr           | 10.0000               |
And I close the current editor

# Bewertungen zum Lieferschein, Nach Buchen der Rechnung 1
Given I open latest Valuation "BewertungZu1.2" for Product "TE142" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 10                    |
    | bewwert       | 100.00                |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   |
    | 10   | 10.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id  | !JournalZu1^id | !JournalZu1^id |         |
And I close the current editor

# es gibt keine Bewertung mit buart Neubewertung und beistelldaten=ja
Then opening an editor from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel==TE142;buart==Neubewertung;beistelldaten==ja;@richtung=vorwärts;@maxordtreffer=1" throws the exception "149"

# Bewertungen mit Kenner beistelldaten=ja und buart=Zugang
Given I open latest Valuation "BewertungBei1.2" for Product "TE142" and valuation transaction "JournalZu1" with command "VIEW" for material provided
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | ja                    |
    | bewart        |                       |
    | abbewart      |                       |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 10                    |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat          | kverur^id       | orig  | beworig  | vkpos   |
    | 10   | 0.0000   | 0.0000    | unbewertet  | !JournalZu1^vom | !JournalZu1^id  |       |          |         |
And I close the current editor

# Bewertung zum Abgang des Beistellteils
Given I open latest Valuation "BewertungAb1" for Product "EINK" and valuation transaction "JournalAb" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb^id         |
    | beistelldaten | nein                  |
    | bewart        | Preis des Zugangs     |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 20                    |
    | bewwert       | 0.00                  |
    | vorgaenger    |                       |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat         | kverur   | orig  | beworig  | vkpos   |
    | 20   | 0.0000   | 0.0000    | unbewertet  | !JournalAb^vom |          |       |          |         |
And I close the current editor

# Komplettwertgutschrift zu Rechnung 1 buchen
Given I open an editor "KWG-RE1-BE142" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE142"
And I set fields
    | nummer | 1KWGRE1    |
    | such   | EK1KWG142  |
    | ebeleg | EK1KWG142  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -10   | 10.00     | -100.00   |
And I save the current editor

# Storno Komplettwertgutschrift
Given I open an editor "STORNO-KWG" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KWG-RE1-BE142"
And I save the current editor

# Teilwertgutschrift 1 zu Rechnung 1 buchen
Given I open an editor "TWG-RE1-BE142" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE142"
And I set fields
    | nummer | 1TWG1RE1   |
    | such   | EK1TWG142  |
    | ebeleg | EK1TWG142  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
And I modify table
    | !row  | mge   | preis     |
    | 1     | -2    | 10.00     |
And I save the current editor

# Journaleintrag zur Wertgutschrift
Given I open an editor "JournalTWG1RE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE142;buarta==Neubewertung;platz==F1;ebeleg==EK1TWG142;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE142             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -10               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpra          | 10.0000           |
    | epr           | 2.0000            |
And I close the current editor

Given I open latest Valuation "BewertungZu1.3" for Product "TE142" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 10                    |
    | bewwert       | 80.00                 |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id           | orig^id        | beworig^id     | vkpos   | datum                   |
    | 10   | 8.0000  | 0.0000    | direkt    | !JournalTWG1RE1^vom  | !JournalTWG1RE1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalTWG1RE1^stand   |
And I close the current editor

# Bewertung zum Abgang des Beistellteils hat sich nicht veraendert, es gibt keinen Vorgaenger oder Nachfolger
Given I open latest Valuation "BewertungAb" for Product "EINK" and valuation transaction "JournalAb" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb^id         |
    | beistelldaten | nein                  |
    | bewart        | Preis des Zugangs     |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 20                    |
    | bewwert       | 0.00                  |
    | vorgaenger    |                       |
    | nachfolger    |                       |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat         | kverur   | orig   | beworig  | vkpos   | datum             |
    | 20   | 0.0000   | 0.0000    | unbewertet  | !JournalAb^vom |          |        |          |         | !JournalAb^stand  |
And I close the current editor

# Storno Teilwertgutschrift
Given I open an editor "STORNO-TWG" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "TWG-RE1-BE142"
And I save the current editor

# Journal zum Storno der Teilwertgutschrift 1
Given I open an editor "JournalStornoTWG" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE142;mge==10;buarta==Neubewertung;platz==F1;ebeleg==EK1TWG142"
And I close the current editor

Given I open latest Valuation "BewertungZu1.4" for Product "TE142" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalZu1^id        |
    | beistelldaten     | nein                  |
    | bewart            | Vorgangspreis         |
    | abbewart          | Preis des Zugangs     |
    | stornoverur^id    | !JournalStornoTWG^id  |
    | buart             | Neubewertung          |
    | ursache           | Rechnung              |
    | detursache        | Storno Wertgutschrift |
    | mge               | 10                    |
    | bewwert           | 100.00                |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   |
    | 10   | 10.0000  | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id  | !JournalZu1^id | !JournalZu1^id |         |
And I close the current editor

# es gibt keine Bewertung mit buart Neubewertung und beistelldaten=ja
Then opening an editor from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel==TE142;buart==Neubewertung;beistelldaten==ja;@richtung=vorwärts;@maxordtreffer=1" throws the exception "149"

# Bewertung mit Kenner beistelldaten=ja und buart=Zugang
Given I open latest Valuation "BewertungBei1.2" for Product "TE142" and valuation transaction "JournalZu1" with command "VIEW" for material provided
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | ja                    |
    | bewart        |                       |
    | abbewart      |                       |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 10                    |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat          | kverur^id       | orig  | beworig  | vkpos   |
    | 10   | 0.0000   | 0.0000    | unbewertet  | !JournalZu1^vom | !JournalZu1^id  |       |          |         |
And I close the current editor

# Storno der Rechnung
Given I open an editor "STORNO-RE1" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE1-ZU-BE142"
And I save the current editor

# Journal zum Storno Rechnung 1
Given I open an editor "JournalStornoRE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE142;mge==-10;buarta==Neubewertung;platz==F1;ebeleg==RE1-BE142"
And I close the current editor

Given I open latest Valuation "BewertungZu1.5" for Product "TE142" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalZu1^id            |
    | beistelldaten     | nein                      |
    | bewart            | Vorgangspreis             |
    | abbewart          | Preis des Zugangs         |
    | stornoverur^id    | !JournalStornoRE1^id      |
    | buart             | Zugang                    |
    | ursache           | Lieferschein              |
    | detursache        | Storno-Rechnung Einkauf   |
    | mge               | 10                        |
    | bewwert           | 90.00                     |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat          | kverur^id       | orig^id        | beworig^id     | vkpos   |
    | 10   | 9.0000  | 0.0000    | vorläufig | !JournalZu1^vom | !JournalZu1^id  | !JournalZu1^id | !JournalZu1^id |         |
And I close the current editor

Given I open latest Valuation "BewertungBei1.2" for Product "TE142" and valuation transaction "JournalZu1" with command "VIEW" for material provided
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | ja                    |
    | bewart        |                       |
    | abbewart      |                       |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 10                    |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat          | kverur^id       | orig  | beworig  | vkpos   |
    | 10   | 0.0000   | 0.0000    | unbewertet  | !JournalZu1^vom | !JournalZu1^id  |       |          |         |
And I close the current editor


Scenario: 43 EK mit Beistellung - BE, LS, RE, Teilwertgutschrift, Storno TWG, Komplettwertgutschrift, Storno WG, Storno RE

Given I open an editor "TE143" from table "(Part):(Product)" with command "STORE" for record "TE143"
And I set fields
    | such      | TE143                 |
    | namebspr  | Schraube 143          |
    | vpr       | 15                    |
    | epr       | 10.50                 |
    | bsart     | Fremdbeschaffung      |
    | dispoa    | auftragsbezogen       |
    | ekbewverf | 1                     |
And I delete all rows
And I append rows
    | elex  | elanzahl  | bua                       |
    | EINK  | 2         | Lieferantenbeistellung    |
And I save the current editor

Given I open an editor "BE-143" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE143   |
    | such   | BE-143   |
    | ebeleg | BE-143   |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis |
    | TE143   | 10  | 9     |
And I save the current editor

# Lieferscheine aus Bestellung, Gesamtmenge, Rechnung soll aus Bestellung erzeugt werden
Given I open an editor "LS1-ZU-BE143" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE143"
And I set fields
   | nummer | 1EKLS143  |
   | ebeleg | LS1-BE143 |
   | such   | LS1-BE143 |
   | ueb    | ja        |
   | fakt   | nein      |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "10" in row 1
Then field "preis" has value "9.00" in row 1
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE143;buarta==Zugang;platz==F1;ebeleg==LS1-BE143"
Then fields have values
    | artikel       | TE143                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 10                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mpr           | 0.0000                |
    | mpra          | 0.0000                |
    | epr           | 9.0000                |
And I close the current editor

# Journal Abgang Beistellteil
Given I open an editor "JournalAb" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EINK;buarta==Abgang;platz==F1;ebeleg==LS1-BE143"
Then fields have values
    | artikel       | EINK                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 20                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mpr           | 0.0000                |
    | mpra          | 0.0000                |
    | epr           | 0.0000                |
And I close the current editor

# Rechnung 1 erstellen und buchen, Gesamtmenge
Given I open an editor "RE1-ZU-BE143" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE143"
And I set fields
    | nummer | 1EKRE143  |
    | ebeleg | RE1-BE143 |
    | such   | RE1-BE143 |
    | ueb    | ja        |
    | vom    | .         |
    | tterm  | .         |
And I set field "mge" to "10" in row 1
And I set field "preis" to "10.00" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 1
Given I open an editor "JournalRE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE143;buarta==Neubewertung;platz==F1;ebeleg==RE1-BE143"
Then fields have values
    | artikel       | TE143                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 10                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 10.0000               |
    | mpra          | 0.0000                |
    | epr           | 10.0000               |
And I close the current editor

# Bewertungen zum Lieferschein, Nach Buchen der Rechnung 1
Given I open latest Valuation "BewertungZu1.2" for Product "TE143" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 10                    |
    | bewwert       | 100.00                |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   |
    | 10   | 10.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id  | !JournalZu1^id | !JournalZu1^id |         |
And I close the current editor

# es gibt keine Bewertung mit buart Neubewertung und beistelldaten=ja
Then opening an editor from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel==TE143;buart==Neubewertung;beistelldaten==ja;@richtung=vorwärts;@maxordtreffer=1" throws the exception "149"

# Bewertung mit Kenner beistelldaten=ja und buart=Zugang
Given I open latest Valuation "BewertungBei1.2" for Product "TE143" and valuation transaction "JournalZu1" with command "VIEW" for material provided
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | ja                    |
    | bewart        |                       |
    | abbewart      |                       |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 10                    |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat          | kverur^id       | orig  | beworig  | vkpos   |
    | 10   | 0.0000   | 0.0000    | unbewertet  | !JournalZu1^vom | !JournalZu1^id  |       |          |         |
And I close the current editor

# Bewertung zum Abgang des Beistellteils
Given I open latest Valuation "BewertungAb" for Product "EINK" and valuation transaction "JournalAb" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb^id         |
    | beistelldaten | nein                  |
    | bewart        | Preis des Zugangs     |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 20                    |
    | bewwert       | 0.00                  |
    | vorgaenger    |                       |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat         | kverur   | orig  | beworig  | vkpos   |
    | 20   | 0.0000   | 0.0000    | unbewertet  | !JournalAb^vom |          |       |          |         |
And I close the current editor

# Teilwertgutschrift 1 zu Rechnung 1 buchen
Given I open an editor "TWG-RE1-BE143" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE143"
And I set fields
    | nummer | 1TWG1RE1     |
    | such   | EK1TWG143    |
    | ebeleg | EK1TWG143    |
    | tterm  | .            |
    | budat  | .            |
    | vom    | .            |
    | ueb    | ja           |
And I modify table
    | !row  | mge   | preis |
    | 1     | -2    | 10.00 |
And I save the current editor

# Journaleintrag zur Wertgutschrift
Given I open an editor "JournalTWG1RE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE143;buarta==Neubewertung;platz==F1;ebeleg==EK1TWG143;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE143             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -10               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpra          | 10.0000           |
    | epr           | 2.0000            |
And I close the current editor

# Storno Teilwertgutschrift
Given I open an editor "STORNO-TWG" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "TWG-RE1-BE143"
And I save the current editor

# Journal zum Storno der Teilwertgutschrift 1
Given I open an editor "JournalStornoTWG" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE143;mge==10;buarta==Neubewertung;platz==F1;ebeleg==EK1TWG143"
And I close the current editor

Given I open latest Valuation "BewertungZu1.3" for Product "TE143" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalZu1^id        |
    | beistelldaten     | nein                  |
    | bewart            | Vorgangspreis         |
    | abbewart          | Preis des Zugangs     |
    | stornoverur^id    | !JournalStornoTWG^id  |
    | buart             | Neubewertung          |
    | ursache           | Rechnung              |
    | detursache        | Storno Wertgutschrift |
    | mge               | 10                    |
    | bewwert           | 100.00                |
Then table has values
    | tmge | tbewpr     | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   |
    | 10   | 10.0000    | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id  | !JournalZu1^id | !JournalZu1^id |         |
And I close the current editor

# es gibt keine Bewertung mit buart Neubewertung und beistelldaten=ja
Then opening an editor from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel==TE143;buart==Neubewertung;beistelldaten==ja;@richtung=vorwärts;@maxordtreffer=1" throws the exception "149"

# Bewertung mit Kenner beistelldaten=ja und buart=Zugang
Given I open latest Valuation "BewertungBei1.2" for Product "TE143" and valuation transaction "JournalZu1" with command "VIEW" for material provided
Then fields have values
    | ppsref^id          | !JournalZu1^id        |
    | beistelldaten      | ja                    |
    | bewart             |                       |
    | abbewart           |                       |
    | stornoverur        |                       |
    | buart              | Zugang                |
    | ursache            | Lieferschein          |
    | detursache         | Lieferschein Einkauf  |
    | mge                | 10                    |
    | bewwert            | 0.00                  |
Then table has values
    | tmge  | tbewpr     | addkosten | bewertet   | tbudat          | kverur^id       | orig  | beworig  | vkpos   |
    | 10    | 0.0000     | 0.0000    | unbewertet | !JournalZu1^vom | !JournalZu1^id  |       |          |         |
And I close the current editor

# Komplettwertgutschrift zu Rechnung 1 buchen
Given I open an editor "KWG-RE1-BE143" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE143"
And I set fields
    | nummer | 1KWGRE1   |
    | such   | EK1KWG143 |
    | ebeleg | EK1KWG143 |
    | tterm  | .         |
    | budat  | .         |
    | vom    | .         |
    | ueb    | ja        |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis      | pwert     |
    | -10   | 10.00      | -100.00   |
And I save the current editor

# Storno Komplettwertgutschrift
Given I open an editor "STORNO-KWG" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KWG-RE1-BE143"
And I save the current editor

# Journal zum Storno der Komplettwertgutschrift
Given I open an editor "JournalStornoKWG" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE143;mge==10;buarta==Neubewertung;platz==F1;ebeleg==EK1KWG143"
And I close the current editor

Given I open latest Valuation "BewertungZu1.3" for Product "TE143" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalZu1^id        |
    | beistelldaten     | nein                  |
    | bewart            | Vorgangspreis         |
    | abbewart          | Preis des Zugangs     |
    | stornoverur^id    | !JournalStornoKWG^id  |
    | buart             | Neubewertung          |
    | ursache           | Rechnung              |
    | detursache        | Storno Wertgutschrift |
    | mge               | 10                    |
    | bewwert           | 100.00                |
Then table has values
    | tmge  | tbewpr    | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   |
    | 10    | 10.0000   | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id  | !JournalZu1^id | !JournalZu1^id |         |
And I close the current editor

# Bewertung zum Beistellteil hat sich nicht veraendert, es gibt keinen Vorgaenger oder Nachfolger
Given I open latest Valuation "BewertungAb" for Product "EINK" and valuation transaction "JournalAb" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb^id         |
    | beistelldaten | nein                  |
    | bewart        | Preis des Zugangs     |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 20                    |
    | bewwert       | 0.00                  |
    | vorgaenger    |                       |
    | nachfolger    |                       |
Then table has values
    | tmge | tbewpr | addkosten | bewertet   | tbudat         | kverur   | orig   | beworig  | vkpos   | datum             |
    | 20   | 0.0000 | 0.0000    | unbewertet | !JournalAb^vom |          |        |          |         | !JournalAb^stand  |
And I close the current editor

# Storno der Rechnung
Given I open an editor "STORNO-RE1" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE1-ZU-BE143"
And I save the current editor

# Journal zum Storno Rechnung 1
Given I open an editor "JournalStornoRE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE143;mge==-10;buarta==Neubewertung;platz==F1;ebeleg==RE1-BE143"
And I close the current editor

Given I open latest Valuation "BewertungZu1.5" for Product "TE143" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalZu1^id            |
    | beistelldaten     | nein                      |
    | bewart            | Vorgangspreis             |
    | abbewart          | Preis des Zugangs         |
    | stornoverur^id    | !JournalStornoRE1^id      |
    | buart             | Zugang                    |
    | ursache           | Lieferschein              |
    | detursache        | Storno-Rechnung Einkauf   |
    | mge               | 10                        |
    | bewwert           | 90.00                     |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat          | kverur^id       | orig^id        | beworig^id     | vkpos   |
    | 10   | 9.0000  | 0.0000    | vorläufig | !JournalZu1^vom | !JournalZu1^id  | !JournalZu1^id | !JournalZu1^id |         |
And I close the current editor

Given I open latest Valuation "BewertungBei1.2" for Product "TE143" and valuation transaction "JournalZu1" with command "VIEW" for material provided
Then fields have values
    | ppsref^id         | !JournalZu1^id        |
    | beistelldaten     | ja                    |
    | bewart            |                       |
    | abbewart          |                       |
    | stornoverur       |                       |
    | buart             | Zugang                |
    | ursache           | Lieferschein          |
    | detursache        | Lieferschein Einkauf  |
    | mge               | 10                    |
    | bewwert           | 0.00                  |
Then table has values
    | tmge  | tbewpr   | addkosten | bewertet   | tbudat          | kverur^id       | orig  | beworig  | vkpos   |
    | 10    | 0.0000   | 0.0000    | unbewertet | !JournalZu1^vom | !JournalZu1^id  |       |          |         |
And I close the current editor


Scenario: 44 EK mit Beistellung - Rechnung mit MZ, ohne Bestellung davor, Komplettwertgutschrift, Storno WG, Teilwertgutschrift

Given I open an editor "TEB44" from table "(Part):(Product)" with command "STORE" for record "TEB44"
And I set fields
    | such      | TEB44                 |
    | namebspr  | Schraube B44          |
    | vpr       | 15                    |
    | epr       | 10.50                 |
    | bsart     | Fremdbeschaffung      |
    | dispoa    | auftragsbezogen       |
    | ekbewverf | 1                     |
And I delete all rows
And I append rows
    | elex  | elanzahl  | bua                       |
    | E3    | 2         | Lieferantenbeistellung    |
And I save the current editor

# Rechnung mit Lagerbewegung buchen, 3 MZ, ohne Bestellung vorher
Given I open an editor "RE-ZU-TEB44" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | 001         |
    | nummer | 1EKREB44    |
    | ebeleg | RE-LB-TEB44 |
    | such   | RE-TEB44    |
    | ueb    | ja          |
    | vom    | .           |
    | tterm  | .           |
    | fakt   | ja          |
And I append rows
    | artikel | mge | preis |
    | TEB44   |  6  | 11    |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge |
    | F1     |  1     |
    | F2     |  2     |
    | F3     |  3     |
And I save the current editor
And I switch the current editor to editor "RE-ZU-TEB44"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "JournalREZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB44;mge==1;buarta==Zugang;platz==F1;ebeleg==RE-LB-TEB44"
Then fields have values
    | artikel       | TEB44                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 1                     |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 11.0000               |
    | mpra          | 0.0000                |
    | epr           | 11.0000               |
And I close the current editor

Given I open an editor "JournalREZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB44;mge==2;buarta==Zugang;platz==F2;ebeleg==RE-LB-TEB44"
Then fields have values
    | artikel       | TEB44                 |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 2                     |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 11.0000               |
    | mpra          | 11.0000               |
    | epr           | 11.0000               |
And I close the current editor

Given I open an editor "JournalREZu3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB44;mge==3;buarta==Zugang;platz==F3;ebeleg==RE-LB-TEB44"
Then fields have values
    | artikel       | TEB44                 |
    | platz         | F3                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 3                     |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 11.0000               |
    | mpra          | 11.0000               |
    | epr           | 11.0000               |
And I close the current editor

# Journal Abgang Beistellteil
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==E3;mge==2;buarta==Abgang;platz==F2;ebeleg==RE-LB-TEB44"
Then fields have values
    | artikel       | E3                    |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 2                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 0.0000                |
    | mpra          | 0.0000                |
    | epr           | 0.0000                |
And I close the current editor

Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==E3;mge==4;buarta==Abgang;platz==F2;ebeleg==RE-LB-TEB44"
Then fields have values
    | artikel       | E3                    |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 4                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 0.0000                |
    | mpra          | 0.0000                |
    | epr           | 0.0000                |
And I close the current editor

Given I open an editor "JournalAb3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==E3;mge==6;buarta==Abgang;platz==F2;ebeleg==RE-LB-TEB44"
Then fields have values
    | artikel       | E3                    |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 6                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 0.0000                |
    | mpra          | 0.0000                |
    | epr           | 0.0000                |
And I close the current editor

# Bewertungen zu den Zugaengen aus der Rechnung, Kenner beistelldaten=nein
Given I open latest Valuation "BewertungZu1.1" for Product "TEB44" and valuation transaction "JournalREZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalREZu1^id      |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 1                     |
    | bewwert       | 11.00                 |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat             | kverur^id         | orig^id          | beworig^id       | vkpos   |
    | 1    | 11.0000 | 0.0000    | direkt    | !JournalREZu1^vom  | !JournalREZu1^id  | !JournalREZu1^id | !JournalREZu1^id |         |
And I close the current editor

Given I open latest Valuation "BewertungZu2.1" for Product "TEB44" and valuation transaction "JournalREZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalREZu2^id      |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 2                     |
    | bewwert       | 22.00                 |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat             | kverur^id         | orig^id          | beworig^id       | vkpos   |
    | 2    | 11.0000 | 0.0000    | direkt    | !JournalREZu2^vom  | !JournalREZu2^id  | !JournalREZu2^id | !JournalREZu2^id |         |
And I close the current editor

Given I open latest Valuation "BewertungZu3.1" for Product "TEB44" and valuation transaction "JournalREZu3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalREZu3^id      |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 3                     |
    | bewwert       | 33.00                 |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat             | kverur^id         | orig^id          | beworig^id       | vkpos   |
    | 3    | 11.0000 | 0.0000    | direkt    | !JournalREZu3^vom  | !JournalREZu3^id  | !JournalREZu3^id | !JournalREZu3^id |         |
And I close the current editor

# Bewertungen zu den Lieferscheinen, Nach Buchen der Rechnung 1, Kenner beistelldaten=ja
Given I open latest Valuation "BewertungBei1.1" for Product "TEB44" and valuation transaction "JournalREZu1" with command "VIEW" for material provided
Then fields have values
    | ppsref^id     | !JournalREZu1^id      |
    | beistelldaten | ja                    |
    | bewart        |                       |
    | abbewart      |                       |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 1                     |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat            | kverur^id         | orig  | beworig  | vkpos   |
    | 1    | 0.0000   | 0.0000    | unbewertet  | !JournalREZu1^vom | !JournalREZu1^id  |       |          |         |
And I close the current editor

Given I open latest Valuation "BewertungBei2.1" for Product "TEB44" and valuation transaction "JournalREZu2" with command "VIEW" for material provided
Then fields have values
    | ppsref^id     | !JournalREZu2^id      |
    | beistelldaten | ja                    |
    | bewart        |                       |
    | abbewart      |                       |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 2                     |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat            | kverur^id          | orig  | beworig  | vkpos   |
    | 2    | 0.0000   | 0.0000    | unbewertet  | !JournalREZu2^vom | !JournalREZu2^id   |       |          |         |
And I close the current editor

Given I open latest Valuation "BewertungBei3.1" for Product "TEB44" and valuation transaction "JournalREZu3" with command "VIEW" for material provided
Then fields have values
    | ppsref^id     | !JournalREZu3^id      |
    | beistelldaten | ja                    |
    | bewart        |                       |
    | abbewart      |                       |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 3                     |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat            | kverur^id         | orig  | beworig  | vkpos   |
    | 3    | 0.0000   | 0.0000    | unbewertet  | !JournalREZu3^vom | !JournalREZu3^id  |       |          |         |
And I close the current editor

# Bewertung zum Abgang des Beistellteils
Given I open latest Valuation "BewertungAb1" for Product "E3" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalAb1^id        |
    | beistelldaten     | nein                  |
    | bewart            | Preis des Zugangs     |
    | abbewart          | Preis des Zugangs     |
    | stornoverur       |                       |
    | buart             | Abgang                |
    | ursache           | Rechnung              |
    | detursache        | Rechnung              |
    | mge               | 2                     |
    | bewwert           | 0.00                  |
    | vorgaenger        |                       |
Then table has values
    | tmge  | tbewpr   | addkosten | bewertet   | tbudat          | kverur   | orig  | beworig  | vkpos   | datum              |
    | 2     | 0.0000   | 0.0000    | unbewertet | !JournalAb1^vom |          |       |          |         | !JournalAb1^stand  |
And I close the current editor

Given I open latest Valuation "BewertungAb2" for Product "E3" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalAb2^id        |
    | beistelldaten     | nein                  |
    | bewart            | Preis des Zugangs     |
    | abbewart          | Preis des Zugangs     |
    | stornoverur       |                       |
    | buart             | Abgang                |
    | ursache           | Rechnung              |
    | detursache        | Rechnung              |
    | mge               | 4                     |
    | bewwert           | 0.00                  |
    | vorgaenger        |                       |
Then table has values
    | tmge  | tbewpr   | addkosten | bewertet   | tbudat          | kverur   | orig  | beworig  | vkpos   | datum              |
    | 4     | 0.0000   | 0.0000    | unbewertet | !JournalAb2^vom |          |       |          |         | !JournalAb2^stand  |
And I close the current editor

Given I open latest Valuation "BewertungAb3" for Product "E3" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalAb3^id        |
    | beistelldaten     | nein                  |
    | bewart            | Preis des Zugangs     |
    | abbewart          | Preis des Zugangs     |
    | stornoverur       |                       |
    | buart             | Abgang                |
    | ursache           | Rechnung              |
    | detursache        | Rechnung              |
    | mge               | 6                     |
    | bewwert           | 0.00                  |
    | vorgaenger        |                       |
Then table has values
    | tmge  | tbewpr   | addkosten | bewertet   | tbudat          | kverur   | orig  | beworig  | vkpos   | datum              |
    | 6     | 0.0000   | 0.0000    | unbewertet | !JournalAb3^vom |          |       |          |         | !JournalAb3^stand  |
And I close the current editor

# Komplettwertgutschrift zu Rechnung buchen
Given I open an editor "KWG-RE1-BEB44" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-ZU-TEB44"
And I set fields
    | nummer    | 1KWGRE1    |
    | such      | EK1KWGB44  |
    | ebeleg    | EK1KWGB44  |
    | tterm     | .          |
    | budat     | .          |
    | vom       | .          |
    | ueb       | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis  |
    | 1     | -6    | 11.00  |
And I save the current editor

# Storno Komplettwertgutschrift
Given I open an editor "STORNO-KWG" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KWG-RE1-BEB44"
And I save the current editor

# Journaleintraege zum Storno der Komplettwertgutschrift (3 MZ, versch. Lagerplaetze)
Given I open an editor "JournalStornoKWG1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB44;mge==1;buarta==Neubewertung;platz==F1;ebeleg==EK1KWGB44"
And I close the current editor

Given I open an editor "JournalStornoKWG2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB44;mge==2;buarta==Neubewertung;platz==F2;ebeleg==EK1KWGB44"
And I close the current editor

Given I open an editor "JournalStornoKWG3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB44;mge==3;buarta==Neubewertung;platz==F3;ebeleg==EK1KWGB44"
And I close the current editor

# Teilwertgutschrift zu Rechnung 1 buchen
Given I open an editor "TWG-RE1-BEB44" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-ZU-TEB44"
And I set fields
    | nummer    | 1TWG1RE1   |
    | such      | EK1TWGB44  |
    | ebeleg    | EK1TWGB44  |
    | tterm     | .          |
    | budat     | .          |
    | vom       | .          |
    | ueb       | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis  |
    | 1     | -3    | 4.00   |
And I save the current editor

# Teilwertgutschrift pauschalisiert auf alle 3 MZ
Given I open an editor "JournalTWG1.1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB44;mge==-1;buarta==Neubewertung;platz==F1;ebeleg==EK1TWGB44"
Then fields have values
    | artikel       | TEB44                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | -1                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | epr           | 2.0000                |
And I close the current editor

Given I open an editor "JournalTWG1.2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB44;mge==-2;buarta==Neubewertung;platz==F2;ebeleg==EK1TWGB44"
Then fields have values
    | artikel       | TEB44                 |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | -2                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | epr           | 2.0000                |
And I close the current editor

Given I open an editor "JournalTWG1.3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB44;mge==-3;buarta==Neubewertung;platz==F3;ebeleg==EK1TWGB44"
Then fields have values
    | artikel       | TEB44                 |
    | platz         | F3                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | -3                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | epr           | 2.0000                |
And I close the current editor

# Bewertungen zu den Zugaengen aus der Rechnung, nach Buchen der Teilwertgutschrift 1, Kenner beistelldaten=nein
Given I open latest Valuation "BewertungZu1.2" for Product "TEB44" and valuation transaction "JournalREZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalREZu1^id      |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 1                     |
    | bewwert       | 9.00                  |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat             | kverur^id         | orig^id          | beworig^id        | vkpos   |
    | 1    | 9.0000  | 0.0000    | direkt    | !JournalTWG1.1^vom | !JournalTWG1.1^id | !JournalREZu1^id | !JournalREZu1^id  |         |
And I close the current editor

Given I open latest Valuation "BewertungZu2.2" for Product "TEB44" and valuation transaction "JournalREZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalREZu2^id      |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 2                     |
    | bewwert       | 18.00                 |
Then table has values
    | tmge | tbewpr | addkosten | bewertet  | tbudat             | kverur^id         | orig^id          | beworig^id        | vkpos   |
    | 2    | 9.0000 | 0.0000    | direkt    | !JournalTWG1.2^vom | !JournalTWG1.2^id | !JournalREZu2^id | !JournalREZu2^id  |         |
And I close the current editor

Given I open latest Valuation "BewertungZu3.2" for Product "TEB44" and valuation transaction "JournalREZu3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalREZu3^id      |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 3                     |
    | bewwert       | 27.00                 |
Then table has values
    | tmge | tbewpr | addkosten | bewertet  | tbudat             | kverur^id         | orig^id          | beworig^id       | vkpos   |
    | 3    | 9.0000 | 0.0000    | direkt    | !JournalTWG1.3^vom | !JournalTWG1.3^id | !JournalREZu3^id | !JournalREZu3^id |         |
And I close the current editor

# buart Zugang, keine Bewertung mit buart=Neubewertung
Then opening an editor from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel==TEB44;buart==Neubewertung;beistelldaten==ja;@richtung=vorwärts;@maxordtreffer=1" throws the exception "149"

# Bewertungen zu den Lieferscheinen, Nach Buchen der Teilwertgutschrift 1, Kenner beistelldaten=ja
Given I open latest Valuation "BewertungBei1.2" for Product "TEB44" and valuation transaction "JournalREZu1" with command "VIEW" for material provided
Then fields have values
    | ppsref^id     | !JournalREZu1^id      |
    | beistelldaten | ja                    |
    | bewart        |                       |
    | abbewart      |                       |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 1                     |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat            | kverur^id         | orig  | beworig  | vkpos   |
    | 1    | 0.0000   | 0.0000    | unbewertet  | !JournalREZu1^vom | !JournalREZu1^id  |       |          |         |
And I close the current editor

Given I open latest Valuation "BewertungBei2.2" for Product "TEB44" and valuation transaction "JournalREZu2" with command "VIEW" for material provided
Then fields have values
    | ppsref^id     | !JournalREZu2^id      |
    | beistelldaten | ja                    |
    | bewart        |                       |
    | abbewart      |                       |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 2                     |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat            | kverur^id          | orig  | beworig  | vkpos   |
    | 2    | 0.0000   | 0.0000    | unbewertet  | !JournalREZu2^vom | !JournalREZu2^id   |       |          |         |
And I close the current editor

Given I open latest Valuation "BewertungBei3.2" for Product "TEB44" and valuation transaction "JournalREZu3" with command "VIEW" for material provided
Then fields have values
    | ppsref^id     | !JournalREZu3^id      |
    | beistelldaten | ja                    |
    | bewart        |                       |
    | abbewart      |                       |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 3                     |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat            | kverur^id         | orig  | beworig  | vkpos   |
    | 3    | 0.0000   | 0.0000    | unbewertet  | !JournalREZu3^vom | !JournalREZu3^id  |       |          |         |
And I close the current editor

# Bewertung zum Abgang des Beistellteils
Given I open latest Valuation "BewertungAb1" for Product "E3" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalAb1^id        |
    | beistelldaten     | nein                  |
    | bewart            | Preis des Zugangs     |
    | abbewart          | Preis des Zugangs     |
    | stornoverur       |                       |
    | buart             | Abgang                |
    | ursache           | Rechnung              |
    | detursache        | Rechnung              |
    | mge               | 2                     |
    | bewwert           | 0.00                  |
    | vorgaenger        |                       |
Then table has values
    | tmge  | tbewpr   | addkosten | bewertet   | tbudat          | kverur   | orig  | beworig  | vkpos   | datum              |
    | 2     | 0.0000   | 0.0000    | unbewertet | !JournalAb1^vom |          |       |          |         | !JournalAb1^stand  |
And I close the current editor

Given I open latest Valuation "BewertungAb2" for Product "E3" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalAb2^id        |
    | beistelldaten     | nein                  |
    | bewart            | Preis des Zugangs     |
    | abbewart          | Preis des Zugangs     |
    | stornoverur       |                       |
    | buart             | Abgang                |
    | ursache           | Rechnung              |
    | detursache        | Rechnung              |
    | mge               | 4                     |
    | bewwert           | 0.00                  |
    | vorgaenger        |                       |
Then table has values
    | tmge  | tbewpr   | addkosten | bewertet   | tbudat          | kverur   | orig  | beworig  | vkpos   | datum              |
    | 4     | 0.0000   | 0.0000    | unbewertet | !JournalAb2^vom |          |       |          |         | !JournalAb2^stand  |
And I close the current editor

Given I open latest Valuation "BewertungAb3" for Product "E3" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalAb3^id        |
    | beistelldaten     | nein                  |
    | bewart            | Preis des Zugangs     |
    | abbewart          | Preis des Zugangs     |
    | stornoverur       |                       |
    | buart             | Abgang                |
    | ursache           | Rechnung              |
    | detursache        | Rechnung              |
    | mge               | 6                     |
    | bewwert           | 0.00                  |
    | vorgaenger        |                       |
Then table has values
    | tmge  | tbewpr   | addkosten | bewertet   | tbudat          | kverur   | orig  | beworig  | vkpos   | datum              |
    | 6     | 0.0000   | 0.0000    | unbewertet | !JournalAb3^vom |          |       |          |         | !JournalAb3^stand  |
And I close the current editor


Scenario: 45 EK mit Beistellung - Rechnung mit MZ, ohne Bestellung davor, Teilwertgutschrift, Storno TWG, Komplettwertgutschrift, Storno WG, Teilwertgutschrift

Given I open an editor "TEB45" from table "(Part):(Product)" with command "STORE" for record "TEB45"
And I set fields
    | such      | TEB45                 |
    | namebspr  | Schraube B45          |
    | vpr       | 15                    |
    | epr       | 10.50                 |
    | bsart     | Fremdbeschaffung      |
    | dispoa    | auftragsbezogen       |
    | ekbewverf | 1                     |
And I delete all rows
And I append rows
    | elex  | elanzahl  | bua                       |
    | E3    | 2         | Lieferantenbeistellung    |
And I save the current editor

# Rechnung mit Lagerbewegung buchen, 3 MZ, ohne Bestellung vorher
Given I open an editor "RE-ZU-TEB45" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | 001         |
    | nummer | 1EKREB45    |
    | ebeleg | RE-LB-TEB45 |
    | such   | RE-TEB45    |
    | ueb    | ja          |
    | vom    | .           |
    | tterm  | .           |
    | fakt   | ja          |
And I append rows
    | artikel | mge | preis |
    | TEB45   | 15  | 10    |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge |
    | F1     |  10    |
    | F2     |  2     |
    | F3     |  3     |
And I save the current editor
And I switch the current editor to editor "RE-ZU-TEB45"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "JournalREZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB45;mge==10;buarta==Zugang;platz==F1;ebeleg==RE-LB-TEB45"
Then fields have values
    | artikel       | TEB45                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 10                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 10.0000               |
    | mpra          | 0.0000                |
    | epr           | 10.0000               |
And I close the current editor

Given I open an editor "JournalREZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB45;mge==2;buarta==Zugang;platz==F2;ebeleg==RE-LB-TEB45"
Then fields have values
    | artikel       | TEB45                 |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 2                     |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 10.0000               |
    | mpra          | 10.0000               |
    | epr           | 10.0000               |
And I close the current editor

Given I open an editor "JournalREZu3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB45;mge==3;buarta==Zugang;platz==F3;ebeleg==RE-LB-TEB45"
Then fields have values
    | artikel       | TEB45                 |
    | platz         | F3                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 3                     |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 10.0000               |
    | mpra          | 10.0000               |
    | epr           | 10.0000               |
And I close the current editor

# Journal Abgang Beistellteil
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==E3;mge==20;buarta==Abgang;platz==F2;ebeleg==RE-LB-TEB45"
Then fields have values
    | artikel       | E3                    |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 20                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 0.0000                |
    | mpra          | 0.0000                |
    | epr           | 0.0000                |
And I close the current editor

Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==E3;mge==4;buarta==Abgang;platz==F2;ebeleg==RE-LB-TEB45"
Then fields have values
    | artikel       | E3                    |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 4                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 0.0000                |
    | mpra          | 0.0000                |
    | epr           | 0.0000                |
And I close the current editor

Given I open an editor "JournalAb3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==E3;mge==6;buarta==Abgang;platz==F2;ebeleg==RE-LB-TEB45"
Then fields have values
    | artikel       | E3                    |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 6                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 0.0000                |
    | mpra          | 0.0000                |
    | epr           | 0.0000                |
And I close the current editor

# Bewertungen zu den Zugaengen aus der Rechnung, Kenner beistelldaten=nein
Given I open latest Valuation "BewertungZu1.1" for Product "TEB45" and valuation transaction "JournalREZu1" with command "VIEW"
Then fields have values
    | ppsref^id      | !JournalREZu1^id      |
    | beistelldaten  | nein                  |
    | bewart         | Vorgangspreis         |
    | abbewart       | Preis des Zugangs     |
    | stornoverur    |                       |
    | buart          | Zugang                |
    | ursache        | Rechnung              |
    | detursache     | Rechnung              |
    | mge            | 10                    |
    | bewwert        | 100.00                |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat             | kverur^id         | orig^id          | beworig^id       | vkpos   |
    | 10   | 10.0000 | 0.0000    | direkt    | !JournalREZu1^vom  | !JournalREZu1^id  | !JournalREZu1^id | !JournalREZu1^id |         |
And I close the current editor

Given I open latest Valuation "BewertungZu2.1" for Product "TEB45" and valuation transaction "JournalREZu2" with command "VIEW"
Then fields have values
    | ppsref^id      | !JournalREZu2^id      |
    | beistelldaten  | nein                  |
    | bewart         | Vorgangspreis         |
    | abbewart       | Preis des Zugangs     |
    | stornoverur    |                       |
    | buart          | Zugang                |
    | ursache        | Rechnung              |
    | detursache     | Rechnung              |
    | mge            | 2                     |
    | bewwert        | 20.00                 |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat             | kverur^id         | orig^id          | beworig^id       | vkpos   |
    | 2    | 10.0000 | 0.0000    | direkt    | !JournalREZu2^vom  | !JournalREZu2^id  | !JournalREZu2^id | !JournalREZu2^id |         |
And I close the current editor

Given I open latest Valuation "BewertungZu3.1" for Product "TEB45" and valuation transaction "JournalREZu3" with command "VIEW"
Then fields have values
    | ppsref^id      | !JournalREZu3^id      |
    | beistelldaten  | nein                  |
    | bewart         | Vorgangspreis         |
    | abbewart       | Preis des Zugangs     |
    | stornoverur    |                       |
    | buart          | Zugang                |
    | ursache        | Rechnung              |
    | detursache     | Rechnung              |
    | mge            | 3                     |
    | bewwert        | 30.00                 |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat             | kverur^id         | orig^id          | beworig^id       | vkpos   |
    | 3    | 10.0000 | 0.0000    | direkt    | !JournalREZu3^vom  | !JournalREZu3^id  | !JournalREZu3^id | !JournalREZu3^id |         |
And I close the current editor

# Bewertungen zu den Lieferscheinen, Nach Buchen der Rechnung 1, Kenner beistelldaten=ja
Given I open latest Valuation "BewertungBei1.1" for Product "TEB45" and valuation transaction "JournalREZu1" with command "VIEW" for material provided
Then fields have values
    | ppsref^id      | !JournalREZu1^id      |
    | beistelldaten  | ja                    |
    | bewart         |                       |
    | abbewart       |                       |
    | stornoverur    |                       |
    | buart          | Zugang                |
    | ursache        | Rechnung              |
    | detursache     | Rechnung              |
    | mge            | 10                    |
    | bewwert        | 0.00                  |
Then table has values
    | tmge | tbewpr | addkosten | bewertet   | tbudat            | kverur^id         | orig  | beworig  | vkpos   |
    | 10   | 0.0000 | 0.0000    | unbewertet | !JournalREZu1^vom | !JournalREZu1^id  |       |          |         |
And I close the current editor

Given I open latest Valuation "BewertungBei2.1" for Product "TEB45" and valuation transaction "JournalREZu2" with command "VIEW" for material provided
Then fields have values
    | ppsref^id      | !JournalREZu2^id      |
    | beistelldaten  | ja                    |
    | bewart         |                       |
    | abbewart       |                       |
    | stornoverur    |                       |
    | buart          | Zugang                |
    | ursache        | Rechnung              |
    | detursache     | Rechnung              |
    | mge            | 2                     |
    | bewwert        | 0.00                  |
Then table has values
    | tmge | tbewpr | addkosten | bewertet   | tbudat            | kverur^id          | orig  | beworig  | vkpos   |
    | 2    | 0.0000 | 0.0000    | unbewertet | !JournalREZu2^vom | !JournalREZu2^id   |       |          |         |
And I close the current editor

Given I open latest Valuation "BewertungBei3.1" for Product "TEB45" and valuation transaction "JournalREZu3" with command "VIEW" for material provided
Then fields have values
    | ppsref^id      | !JournalREZu3^id      |
    | beistelldaten  | ja                    |
    | bewart         |                       |
    | abbewart       |                       |
    | stornoverur    |                       |
    | buart          | Zugang                |
    | ursache        | Rechnung              |
    | detursache     | Rechnung              |
    | mge            | 3                     |
    | bewwert        | 0.00                  |
Then table has values
    | tmge | tbewpr | addkosten | bewertet   | tbudat            | kverur^id         | orig  | beworig  | vkpos   |
    | 3    | 0.0000 | 0.0000    | unbewertet | !JournalREZu3^vom | !JournalREZu3^id  |       |          |         |
And I close the current editor

# Bewertung zum Abgang des Beistellteils
Given I open latest Valuation "BewertungAb1" for Product "E3" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id      | !JournalAb1^id        |
    | beistelldaten  | nein                  |
    | bewart         | Preis des Zugangs     |
    | abbewart       | Preis des Zugangs     |
    | stornoverur    |                       |
    | buart          | Abgang                |
    | ursache        | Rechnung              |
    | detursache     | Rechnung              |
    | mge            | 20                    |
    | bewwert        | 0.00                  |
    | vorgaenger     |                       |
Then table has values
    | tmge | tbewpr | addkosten | bewertet   | tbudat          | kverur   | orig  | beworig  | vkpos   | datum              |
    | 20   | 0.0000 | 0.0000    | unbewertet | !JournalAb1^vom |          |       |          |         | !JournalAb1^stand  |
And I close the current editor

Given I open latest Valuation "BewertungAb2" for Product "E3" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id      | !JournalAb2^id        |
    | beistelldaten  | nein                  |
    | bewart         | Preis des Zugangs     |
    | abbewart       | Preis des Zugangs     |
    | stornoverur    |                       |
    | buart          | Abgang                |
    | ursache        | Rechnung              |
    | detursache     | Rechnung              |
    | mge            | 4                     |
    | bewwert        | 0.00                  |
    | vorgaenger     |                       |
Then table has values
    | tmge | tbewpr | addkosten | bewertet   | tbudat          | kverur   | orig  | beworig  | vkpos   | datum              |
    | 4    | 0.0000 | 0.0000    | unbewertet | !JournalAb2^vom |          |       |          |         | !JournalAb2^stand  |
And I close the current editor

Given I open latest Valuation "BewertungAb3" for Product "E3" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id      | !JournalAb3^id        |
    | beistelldaten  | nein                  |
    | bewart         | Preis des Zugangs     |
    | abbewart       | Preis des Zugangs     |
    | stornoverur    |                       |
    | buart          | Abgang                |
    | ursache        | Rechnung              |
    | detursache     | Rechnung              |
    | mge            | 6                     |
    | bewwert        | 0.00                  |
    | vorgaenger     |                       |
Then table has values
    | tmge | tbewpr | addkosten | bewertet   | tbudat          | kverur   | orig  | beworig  | vkpos   | datum              |
    | 6    | 0.0000 | 0.0000    | unbewertet | !JournalAb3^vom |          |       |          |         | !JournalAb3^stand  |
And I close the current editor

Given I open an editor "TWG1-RE1-BEB45" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-ZU-TEB45"
And I set fields
    | nummer    | 1TWG1RE1   |
    | such      | EK1TWGB45  |
    | ebeleg    | EK1TWGB45  |
    | tterm     | .          |
    | budat     | .          |
    | vom       | .          |
    | ueb       | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis  |
    | 1     | -3    | 5.00   |
And I save the current editor

# Storno Teilwertgutschrift 1
Given I open an editor "STORNO-TWG1" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "TWG1-RE1-BEB45"
And I save the current editor

# Journal zum Storno der Teilwertgutschrift 1, alle 3 MZs betroffen, wegen Pauschalisierung
Given I open an editor "JournalStornoTWG1.1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB45;mge==10;buarta==Neubewertung;platz==F1;ebeleg==EK1TWGB45"
And I close the current editor

Given I open an editor "JournalStornoTWG1.2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB45;mge==2;buarta==Neubewertung;platz==F2;ebeleg==EK1TWGB45"
And I close the current editor

Given I open an editor "JournalStornoTWG1.3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB45;mge==3;buarta==Neubewertung;platz==F3;ebeleg==EK1TWGB45"
And I close the current editor

# Komplettwertgutschrift zu Rechnung buchen
Given I open an editor "KWG-RE1-BEB45" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-ZU-TEB45"
And I set fields
    | nummer    | 1KWGRE1    |
    | such      | EK1KWGB45  |
    | ebeleg    | EK1KWGB45  |
    | tterm     | .          |
    | budat     | .          |
    | vom       | .          |
    | ueb       | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis  |
    | 1     | -15   | 10.00  |
And I save the current editor

# Storno Komplettwertgutschrift
Given I open an editor "STORNO-KWG" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KWG-RE1-BEB45"
And I save the current editor

# Journal zum Storno der Komplettwertgutschrift
Given I open an editor "JournalStornoKWG1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB45;mge==10;buarta==Neubewertung;platz==F1;ebeleg==EK1KWGB45"
And I close the current editor

Given I open an editor "JournalStornoKWG2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB45;mge==2;buarta==Neubewertung;platz==F2;ebeleg==EK1KWGB45"
And I close the current editor

Given I open an editor "JournalStornoKWG3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB45;mge==3;buarta==Neubewertung;platz==F3;ebeleg==EK1KWGB45"
And I close the current editor

# Teilwertgutschrift 2 zu Rechnung 1 buchen
Given I open an editor "TWG2-RE1-BEB45" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-ZU-TEB45"
And I set fields
    | nummer    | 1TWG2RE1   |
    | such      | EKTWG2B45  |
    | ebeleg    | EKTWG2B45  |
    | tterm     | .          |
    | budat     | .          |
    | vom       | .          |
    | ueb       | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis  |
    | 1     | -3    | 5.00   |
And I save the current editor

# Journaleintraege zur Teilwertgutschrift 2, pauschalisiert auf alle 3 MZ
Given I open an editor "JournalTWG2.1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB45;mge==-10;buarta==Neubewertung;platz==F1;ebeleg==EKTWG2B45"
Then fields have values
    | artikel       | TEB45                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | -10                   |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | epr           | 1.0000                |
And I close the current editor

Given I open an editor "JournalTWG2.2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB45;mge==-2;buarta==Neubewertung;platz==F2;ebeleg==EKTWG2B45"
Then fields have values
    | artikel       | TEB45                 |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | -2                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | epr           | 1.0000                |
And I close the current editor

Given I open an editor "JournalTWG2.3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB45;mge==-3;buarta==Neubewertung;platz==F3;ebeleg==EKTWG2B45"
Then fields have values
    | artikel       | TEB45                 |
    | platz         | F3                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | -3                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | epr           | 1.0000                |
And I close the current editor

# Bewertungen zu den Zugaengen aus der Rechnung, nach Buchen der Wertgutschrift 2, Kenner beistelldaten=nein
Given I open latest Valuation "BewertungZu1.2" for Product "TEB45" and valuation transaction "JournalREZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalREZu1^id      |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 10                    |
    | bewwert       | 90.00                 |
Then table has values
    | tmge | tbewpr | addkosten | bewertet  | tbudat             | kverur^id         | orig^id          | beworig^id        | vkpos   |
    | 10   | 9.0000 | 0.0000    | direkt    | !JournalTWG2.1^vom | !JournalTWG2.1^id | !JournalREZu1^id | !JournalREZu1^id |         |
And I close the current editor

Given I open latest Valuation "BewertungZu2.2" for Product "TEB45" and valuation transaction "JournalREZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalREZu2^id      |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 2                     |
    | bewwert       | 18.00                 |
Then table has values
    | tmge | tbewpr | addkosten | bewertet  | tbudat             | kverur^id         | orig^id          | beworig^id       | vkpos   |
    | 2    | 9.0000 | 0.0000    | direkt    | !JournalTWG2.2^vom | !JournalTWG2.2^id | !JournalREZu2^id | !JournalREZu2^id |         |
And I close the current editor

Given I open latest Valuation "BewertungZu3.2" for Product "TEB45" and valuation transaction "JournalREZu3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalREZu3^id      |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 3                     |
    | bewwert       | 27.00                 |
Then table has values
    | tmge | tbewpr | addkosten | bewertet  | tbudat             | kverur^id         | orig^id          | beworig^id       | vkpos   |
    | 3    | 9.0000 | 0.0000    | direkt    | !JournalTWG2.3^vom | !JournalTWG2.3^id | !JournalREZu3^id | !JournalREZu3^id |         |
And I close the current editor

# keine Bewertung mit buart=Neubewertung
Then opening an editor from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel==TEB45;buart==Neubewertung;beistelldaten==ja;@richtung=vorwärts;@maxordtreffer=1" throws the exception "149"

# Bewertungen zu den Lieferscheinen, Nach Buchen der Teilwertgutschrift 2, Kenner beistelldaten=ja
Given I open latest Valuation "BewertungBei1.2" for Product "TEB45" and valuation transaction "JournalREZu1" with command "VIEW" for material provided
Then fields have values
    | ppsref^id     | !JournalREZu1^id      |
    | beistelldaten | ja                    |
    | bewart        |                       |
    | abbewart      |                       |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 10                    |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat            | kverur^id         | orig  | beworig  | vkpos   |
    | 10   | 0.0000   | 0.0000    | unbewertet  | !JournalREZu1^vom | !JournalREZu1^id  |       |          |         |
And I close the current editor

Given I open latest Valuation "BewertungBei2.2" for Product "TEB45" and valuation transaction "JournalREZu2" with command "VIEW" for material provided
Then fields have values
    | ppsref^id     | !JournalREZu2^id      |
    | beistelldaten | ja                    |
    | bewart        |                       |
    | abbewart      |                       |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 2                     |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat            | kverur^id          | orig  | beworig  | vkpos   |
    | 2    | 0.0000   | 0.0000    | unbewertet  | !JournalREZu2^vom | !JournalREZu2^id   |       |          |         |
And I close the current editor

Given I open latest Valuation "BewertungBei3.2" for Product "TEB45" and valuation transaction "JournalREZu3" with command "VIEW" for material provided
Then fields have values
    | ppsref^id     | !JournalREZu3^id      |
    | beistelldaten | ja                    |
    | bewart        |                       |
    | abbewart      |                       |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 3                     |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat            | kverur^id         | orig  | beworig  | vkpos   |
    | 3    | 0.0000   | 0.0000    | unbewertet  | !JournalREZu3^vom | !JournalREZu3^id  |       |          |         |
And I close the current editor

# Bewertung zum Abgang des Beistellteils
Given I open latest Valuation "BewertungAb1" for Product "E3" and valuation transaction "JournalAb1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb1^id        |
    | beistelldaten | nein                  |
    | bewart        | Preis des Zugangs     |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 20                    |
    | bewwert       | 0.00                  |
    | vorgaenger    |                       |
Then table has values
    | tmge | tbewpr | addkosten | bewertet   | tbudat          | kverur   | orig  | beworig  | vkpos   | datum              |
    | 20   | 0.0000 | 0.0000    | unbewertet | !JournalAb1^vom |          |       |          |         | !JournalAb1^stand  |
And I close the current editor

Given I open latest Valuation "BewertungAb2" for Product "E3" and valuation transaction "JournalAb2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb2^id        |
    | beistelldaten | nein                  |
    | bewart        | Preis des Zugangs     |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 4                     |
    | bewwert       | 0.00                  |
    | vorgaenger    |                       |
Then table has values
    | tmge | tbewpr | addkosten | bewertet   | tbudat          | kverur   | orig  | beworig  | vkpos   | datum              |
    | 4    | 0.0000 | 0.0000    | unbewertet | !JournalAb2^vom |          |       |          |         | !JournalAb2^stand  |
And I close the current editor

Given I open latest Valuation "BewertungAb3" for Product "E3" and valuation transaction "JournalAb3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb3^id        |
    | beistelldaten | nein                  |
    | bewart        | Preis des Zugangs     |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 6                     |
    | bewwert       | 0.00                  |
    | vorgaenger    |                       |
Then table has values
    | tmge | tbewpr | addkosten | bewertet   | tbudat          | kverur   | orig  | beworig  | vkpos   | datum              |
    | 6    | 0.0000 | 0.0000    | unbewertet | !JournalAb3^vom |          |       |          |         | !JournalAb3^stand  |
And I close the current editor


Scenario: 46 EK mit Beistellung - BE, RE, mehrere Teilwertgutschriften, LS Teilmenge, Storno TWG

Given I open an editor "TEB46" from table "(Part):(Product)" with command "STORE" for record "TEB46"
And I set fields
    | such      | TEB46                 |
    | namebspr  | Schraube B46          |
    | vpr       | 15                    |
    | epr       | 10.50                 |
    | bsart     | Fremdbeschaffung      |
    | dispoa    | auftragsbezogen       |
    | ekbewverf | 1                     |
And I delete all rows
And I append rows
    | elex  | elanzahl  | bua                       |
    | EINK  | 2         | Lieferantenbeistellung    |
And I save the current editor

Given I open an editor "BE-146" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief    | 001         |
    | nummer  | 1BE146      |
    | such    | BE-146      |
    | ebeleg  | BE-146      |
    | tterm   | .           |
    | budat   | .           |
And I append rows
    | artikel | mge | preis |
    | TEB46   | 100 | 18    |
And I save the current editor

# Rechnung ohne Lagerbewegung erstellen und buchen, Gesamtmenge
Given I open an editor "RE1-ZU-BE146" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE146"
And I set fields
    | nummer  | 1EKRE146    |
    | ebeleg  | RE1-BE146   |
    | such    | RE1-BE146   |
    | ueb     | ja          |
    | fakt    | nein        |
    | vom     | .           |
    | tterm   | .           |
And I set field "mge" to "100" in row 1
And I set field "preis" to "20.00" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 1
Given I open an editor "JournalRE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB46;buarta==Neubewertung;platz==F1;ebeleg==RE1-BE146"
Then fields have values
    | artikel       | TEB46                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 100                   |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 20.0000               |
    | mpra          | 0.0000                |
    | epr           | 20.0000               |
And I close the current editor

# Teilwertgutschrift 1 zu Rechnung 1 erstellen und buchen
Given I open an editor "TWG1-RE1-BE146" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE146"
And I set fields
    | nummer    | 1TWG1RE1   |
    | such      | EK1TWG146  |
    | ebeleg    | EK1TWG146  |
    | tterm     | .          |
    | budat     | .          |
    | vom       | .          |
    | ueb       | ja         |
And I modify table
    | !row  | mge   | preis  |
    | 1     | -100  | 1.00   |
And I save the current editor

# Journaleintrag zur Wertgutschrift
Given I open an editor "JournalTWG1RE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB46;buarta==Neubewertung;platz==F1;ebeleg==EK1TWG146;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TEB46             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -100              |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 1.0000            |
And I close the current editor

# Teilwertgutschrift 2 zu Rechnung 1 buchen
Given I open an editor "TWG2-RE1-BE146" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE146"
And I set fields
    | nummer    | 1TWG2RE1   |
    | such      | EK2TWG146  |
    | ebeleg    | EK2TWG146  |
    | tterm     | .          |
    | budat     | .          |
    | vom       | .          |
    | ueb       | ja         |
And I modify table
    | !row  | mge   | preis  |
    | 1     | -10   | 10.00  |
And I save the current editor

# Journaleintrag zur Wertgutschrift 2
Given I open an editor "JournalTWG2RE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB46;buarta==Neubewertung;platz==F1;ebeleg==EK2TWG146;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TEB46             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -100              |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 1.0000            |
And I close the current editor

# Teilwertgutschrift 3 zu Rechnung 1 buchen
Given I open an editor "TWG3-RE1-BE146" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE146"
And I set fields
    | nummer    | 1TWG3RE1   |
    | such      | EK3TWG146  |
    | ebeleg    | EK3TWG146  |
    | tterm     | .          |
    | budat     | .          |
    | vom       | .          |
    | ueb       | ja         |
And I modify table
    | !row  | mge   | preis  |
    | 1     | -50   | 2.00   |
And I save the current editor

# Journaleintrag zur Wertgutschrift 3
Given I open an editor "JournalTWG3RE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB46;buarta==Neubewertung;platz==F1;ebeleg==EK3TWG146;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TEB46             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -100              |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 1.0000            |
And I close the current editor

# Lieferscheine aus Bestellung, Teilmenge
Given I open an editor "LS1-ZU-BE146" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE146"
And I set fields
   | nummer     | 1EKLS146  |
   | ebeleg     | LS1-BE146 |
   | such       | LS1-BE146 |
   | ueb        | ja        |
   | vom        | .         |
   | tterm      | .         |
Then field "fakt" has value "nein"
And I set field "mge" to "25" in row 1
Then field "preis" has value "18.00" in row 1
And I save the current editor

# Journal zum Lieferschein
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB46;mge==25;buarta==Zugang;platz==F1;ebeleg==LS1-BE146"
Then fields have values
    | artikel       | TEB46                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 25                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | epr           | 18.0000               |
And I close the current editor

# Journal Abgang Beistellteil
Given I open an editor "JournalAb" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EINK;mge==50;buarta==Abgang;platz==F1;ebeleg==LS1-BE146"
Then fields have values
    | artikel       | EINK                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 50                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mpr           | 0.0000                |
    | mpra          | 0.0000                |
    | epr           | 0.0000                |
And I close the current editor

# Bewertungen zum Lieferschein, nach Teilwertgutschriften
Given I open latest Valuation "BewertungZu1.2" for Product "TEB46" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 25                    |
    | bewwert       | 425.00                |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet | tbudat               | kverur^id           | orig^id        | beworig^id     | vkpos   |
    | 25   | 17.0000 | 0.0000    | direkt   | !JournalTWG3RE1^vom  | !JournalTWG3RE1^id  | !JournalZu1^id | !JournalZu1^id |         |
And I close the current editor

# es gibt keine Bewertung mit buart Neubewertung und beistelldaten=ja
Then opening an editor from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel==TEB46;buart==Neubewertung;beistelldaten==ja;@richtung=vorwärts;@maxordtreffer=1" throws the exception "149"

# Bewertungen mit Kenner beistelldaten=ja und buart=Zugang
Given I open latest Valuation "BewertungBei1.1" for Product "TEB46" and valuation transaction "JournalZu1" with command "VIEW" for material provided
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | ja                    |
    | bewart        |                       |
    | abbewart      |                       |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 25                    |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr | addkosten | bewertet   | tbudat          | kverur^id       | orig  | beworig  | vkpos   |
    | 25   | 0.0000 | 0.0000    | unbewertet | !JournalRE1^vom | !JournalRE1^id  |       |          |         |
And I close the current editor

# Bewertung zum Abgang des Beistellteils
Given I open latest Valuation "BewertungAb" for Product "EINK" and valuation transaction "JournalAb" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalAb^id         |
    | beistelldaten | nein                  |
    | bewart        | Preis des Zugangs     |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 50                    |
    | bewwert       | 0.00                  |
    | vorgaenger    |                       |
Then table has values
    | tmge | tbewpr | addkosten | bewertet   | tbudat         | kverur   | orig  | beworig  | vkpos   |
    | 50   | 0.0000 | 0.0000    | unbewertet | !JournalAb^vom |          |       |          |         |
And I close the current editor

# Pruefen dass Storno Teilwertgutschrift 1 nicht moeglich ist, da es weitere Teilwertgutschriften gibt
# 6742 de      |Zuerst müssen Teilwertgutschriften storniert werden.
Then opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "TWG1-RE1-BE146" throws the exception "3335"

# Storno Teilwertgutschrift 3
Given I open an editor "STORNO-TWG3" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "TWG3-RE1-BE146"
And I save the current editor

# Journaleintraege zum Storno der Teilwertgutschrift 3, es gibt 2 Eintraege, 25 Stk zum Zugang aus Lieferschein und 75 Stk ohne Lieferschein
Given I open an editor "JournalStornoTWG3.1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB46;mge==25;buarta==Neubewertung;platz==F1;ebeleg==EK3TWG146"
And I close the current editor

Given I open an editor "JournalStornoTWG3.2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TEB46;mge==75;buarta==Neubewertung;platz==F1;ebeleg==EK3TWG146"
And I close the current editor

# Kostenverursacher ist jetzt Teilwertgutschrift 2, da diese vor der Teilwertgutschrift 3 gebucht wurde
Given I open latest Valuation "BewertungZu1.2" for Product "TEB46" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id      | !JournalZu1^id            |
    | beistelldaten  | nein                      |
    | bewart         | Vorgangspreis             |
    | abbewart       | Preis des Zugangs         |
    | stornoverur^id | !JournalStornoTWG3.1^id   |
    | buart          | Neubewertung              |
    | ursache        | Rechnung                  |
    | detursache     | Storno Wertgutschrift     |
    | mge            | 25                        |
    | bewwert        | 450.00                    |
Then table has values
    | tmge  | tbewpr   | addkosten  | bewertet   | tbudat              | kverur^id           | orig^id        | beworig^id     | vkpos   |
    | 25    | 18.0000  | 0.0000     | direkt     | !JournalTWG2RE1^vom | !JournalTWG2RE1^id  | !JournalZu1^id | !JournalZu1^id |         |
And I close the current editor

# es gibt keine Bewertung mit buart Neubewertung und beistelldaten=ja
Then opening an editor from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel==TEB46;buart==Neubewertung;beistelldaten==ja;@richtung=vorwärts;@maxordtreffer=1" throws the exception "149"

# Bewertungen mit Kenner beistelldaten=ja und buart=Zugang
Given I open latest Valuation "BewertungBei1.2" for Product "TEB46" and valuation transaction "JournalZu1" with command "VIEW" for material provided
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | ja                    |
    | bewart        |                       |
    | abbewart      |                       |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 25                    |
    | bewwert       | 0.00                  |
Then table has values
    | tmge | tbewpr   | addkosten | bewertet    | tbudat          | kverur^id       | orig  | beworig  | vkpos   |
    | 25   | 0.0000   | 0.0000    | unbewertet  | !JournalRE1^vom | !JournalRE1^id  |       |          |         |
And I close the current editor

# Pruefen dass Storno Teilwertgutschrift 1 noch nicht moeglich ist, es muesste erst noch Teilwertgutschrift 2 storniert werden
Then opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "TWG1-RE1-BE146" throws the exception "3335"
