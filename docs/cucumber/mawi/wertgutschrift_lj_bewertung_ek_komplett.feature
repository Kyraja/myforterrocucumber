# *****************************************************************************
#  Name           : wertgutschrift_lj_bewertung_ek_komplett.feature
#  Verantwortlich : bschiga
#  Kontrolle      : carue
#  Funktion       : Test der LJ und Bewertungen bei Wertgutschriften
#
# *****************************************************************************
#
@persistent
Feature: wertgutschrift_lj_bewertung_ek_komplett.feature
Background:
Given I set the fake date to "02.01.1995"

# fuer alle Szenarien wird Bewertungskonfiguration 1 verwendet, Preis des Zugangs und Vorgangspreis

Scenario: Stammdaten

Given I open an editor "firma" from table "(Company):(ValuationConfiguration)" with command "UPDATE" for record "10"
And I modify table
  | !row | bewab             | bewzu         |
  | 1    | Preis des Zugangs | Vorgangspreis |
And I save the current editor


Scenario: 05 EK - Rechnung ohne Lagerbewegung - Bestellung, Lieferscheine und Rechnungen fuer Teilmengen und unterschiedliche Preise, Komplettwertgutschrift

Given I open an editor "TE55" from table "(Part):(Product)" with command "STORE" for record "TE55"
And I set fields
    | such      | TE55                 |
    | namebspr  | Schraube 55          |
    | vpr       | 15                   |
    | epr       | 10.50                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

# Bestellung
Given I open an editor "BE-02" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE55    |
    | such   | BE-55    |
    | ebeleg | BE-55    |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis |
    | TE55    | 100 | 10    |
And I save the current editor

# Lieferscheine aus Bestellung, Teilmenge, Rechnung soll aus Bestellung erzeugt werden
Given I open an editor "LS1-ZU-BE55" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE55"
And I set fields
   | nummer | 1EKLS55   |
   | ebeleg | LS1-BE55  |
   | such   | LS1-BE55  |
   | ueb    | ja        |
   | fakt   | nein      |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "40" in row 1
Then field "preis" has value "10.00" in row 1
And I set field "preis" to "11" in row 1
And I save the current editor

Given I open an editor "LS2-ZU-BE55" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE55"
And I set fields
   | nummer | 2EKLS55   |
   | ebeleg | LS2-BE55  |
   | such   | LS2-BE55  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "35" in row 1
Then field "preis" has value "10.00" in row 1
And I set field "preis" to "11" in row 1
And I save the current editor

Given I open an editor "LS3-ZU-BE55" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE55"
And I set fields
   | nummer | 3EKLS55   |
   | ebeleg | LS3-BE55  |
   | such   | LS3-BE55  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "15" in row 1
Then field "preis" has value "10.00" in row 1
And I set field "preis" to "11,50" in row 1
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE55;buarta==Zugang;platz==F1;ebeleg==LS1-BE55"
Then fields have values
    | artikel       | TE55                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 40                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mpr           |  0.0000               |
    | mpra          |  0.0000               |
    | epr           | 11.0000               |
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE55;buarta==Zugang;platz==F1;ebeleg==LS2-BE55"
Then fields have values
    | artikel       | TE55                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 35                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mpr           |  0.0000               |
    | mpra          |  0.0000               |
    | epr           | 11.0000               |
And I close the current editor

Given I open an editor "JournalZu3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE55;buarta==Zugang;platz==F1;ebeleg==LS3-BE55"
Then fields have values
    | artikel       | TE55                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 15                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mpr           |  0.0000               |
    | mpra          |  0.0000               |
    | epr           | 11.5000               |
And I close the current editor

# Bewertungen zu den Lieferscheinen, vor Erstellung der Rechnungen
Given I open latest Valuation "BewertungZu1.1" for Product "TE55" and valuation transaction "JournalZu1" with command "VIEW"
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
    | bewwert       | 440.00                |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 40   | 11.0000 | 0.0000    | vorläufig | !JournalZu1^vom  | !JournalZu1^id    | !JournalZu1^id | !JournalZu1^id |         | !JournalZu1^stand  |
And I close the current editor

Given I open latest Valuation "BewertungZu2.1" for Product "TE55" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 35                    |
    | bewwert       | 385.00                |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 35   | 11.0000 | 0.0000    | vorläufig | !JournalZu2^vom  | !JournalZu2^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalZu2^stand  |
And I close the current editor

Given I open latest Valuation "BewertungZu3.1" for Product "TE55" and valuation transaction "JournalZu3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu3^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 15                    |
    | bewwert       | 172.50                |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 15   | 11.5000 | 0.0000    | vorläufig | !JournalZu3^vom  | !JournalZu3^id    | !JournalZu3^id | !JournalZu3^id |         | !JournalZu3^stand  |
And I close the current editor

# Erstellen und Buchen Rechnung 1
Given I open an editor "RE1-ZU-BE55" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE55"
And I set fields
   | nummer | 1EKRE55   |
   | ebeleg | RE1-BE55  |
   | such   | RE1-BE55  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "50" in row 1
Then field "preis" has value "10.00" in row 1
And I set field "preis" to "12" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 1
Given I open an editor "JournalRE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE55;buarta==Neubewertung;platz==F1;ebeleg==RE1-BE55"
Then fields have values
    | artikel       | TE55                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 50                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           |  6.6667               |
    | mpra          |  0.0000               |
    | epr           | 12.0000               |
And I close the current editor

# Bewertungen zu den Lieferscheinen, Nach Buchen der Rechnung 1
Given I open latest Valuation "BewertungZu1.2" for Product "TE55" and valuation transaction "JournalZu1" with command "VIEW"
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
    | bewwert       | 480.00                |
    | vorgaenger^id | !BewertungZu1.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   | datum              |
    | 40   | 12.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalRE1^stand  |
And I close the current editor

Given I open latest Valuation "BewertungZu2.2" for Product "TE55" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 35                    |
    | bewwert       | 395.00                |
    | vorgaenger^id | !BewertungZu2.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 10   | 12.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalRE1^stand  |
    | 25   | 11.0000 | 0.0000    | vorläufig | !JournalZu2^vom  | !JournalZu2^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalZu2^stand  |
And I close the current editor

# Erstellen und Buchen Rechnung 2
Given I open an editor "RE2-ZU-BE55" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE55"
And I set fields
   | nummer | 2EKRE55   |
   | ebeleg | RE2-BE55  |
   | such   | RE2-BE55  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "5" in row 1
Then field "preis" has value "10.00" in row 1
And I set field "preis" to "12" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 2
Given I open an editor "JournalRE2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE55;buarta==Neubewertung;platz==F1;ebeleg==RE2-BE55"
Then fields have values
    | artikel       | TE55                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 5                     |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           |  6.9630               |
    | mpra          |  6.6667               |
    | epr           | 12.0000               |
And I close the current editor

# Bewertungen zu den Lieferscheinen, Nach Buchen der Rechnung 2
Given I open latest Valuation "BewertungZu2.3" for Product "TE55" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 35                    |
    | bewwert       | 400.00                |
    | vorgaenger^id | !BewertungZu2.2^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    |  5   | 12.0000 | 0.0000    | direkt    | !JournalRE2^vom  | !JournalRE2^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalRE2^stand  |
    | 10   | 12.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalRE1^stand  |
    | 20   | 11.0000 | 0.0000    | vorläufig | !JournalZu2^vom  | !JournalZu2^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalZu2^stand  |
And I close the current editor

# Erstellen und Buchen Rechnung 3
Given I open an editor "RE3-ZU-BE55" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE55"
And I set fields
   | nummer | 3EKRE55   |
   | ebeleg | RE3-BE55  |
   | such   | RE3-BE55  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "45" in row 1
Then field "preis" has value "10.00" in row 1
And I set field "preis" to "12,50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 3
Given I open an editor "JournalRE3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE55;buarta==Neubewertung;platz==F1;ebeleg==RE3-BE55"
Then fields have values
    | artikel       | TE55                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 45                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           |  8.8086               |
    | mpra          |  6.9630               |
    | epr           | 12.5000               |
And I close the current editor

# Bewertungen zu den Lieferscheinen, Nach Buchen der Rechnung 3
Given I open latest Valuation "BewertungZu2.4" for Product "TE55" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 35                    |
    | bewwert       | 430.00                |
    | vorgaenger^id | !BewertungZu2.3^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 20   | 12.5000 | 0.0000    | direkt    | !JournalRE3^vom  | !JournalRE3^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalRE3^stand  |
    |  5   | 12.0000 | 0.0000    | direkt    | !JournalRE2^vom  | !JournalRE2^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalRE2^stand  |
    | 10   | 12.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalRE1^stand  |
And I close the current editor

Given I open latest Valuation "BewertungZu3.2" for Product "TE55" and valuation transaction "JournalZu3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu3^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 15                    |
    | bewwert       | 187.50                |
    | vorgaenger^id | !BewertungZu3.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 15   | 12.5000 | 0.0000    | direkt    | !JournalRE3^vom  | !JournalRE3^id    | !JournalZu3^id | !JournalZu3^id |         | !JournalRE3^stand  |
And I close the current editor

# Bewertungsammler pruefen 10 Stueck von Rechnung 3 warten auf den Zugang
Given I query "bewempf,mge,wert,kverur^id" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L3EKRE55"
Then query has values
    | bewempf   | mge   | wert      | kverur^id         |
    | L3EKRE55  | 10    | 12.5000   | !JournalRE3^id    |
And I close the current editor

# Mischpreis (mrp=Mischpreis, mrpr=mittlerer Rechnungspreis, lpr=letzter Einstandspreis)
Given I query "artikel,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(ProductQuantity)" where "artikel==TE55"
Then query has values
    | artikel  | bestand | dbestand    | mrpr      | lpr       | mpr      |
    | TE55     |   90    |  90         |  12.1667  | 12.5000   | 8.8086   |

Given I query "artikel,lgruppe,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(WarehouseGroupQuantity)" where "lgruppe==KARLSRUHE;artikel==TE55"
Then query has values
    | artikel  | lgruppe   | bestand | dbestand    | mrpr      | lpr       | mpr      |
    | TE55     | KARLSRUHE |  90     |  90         |  12.1667  | 12.5000   | 8.8086   |

# Komplettwertgutschrift zu Rechnung 2 erstellen und buchen
Given I open an editor "WERT-RE2-BE55" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE2-ZU-BE55"
And I set fields
    | nummer | 1WERTRE2   |
    | such   | EK1WERT55  |
    | ebeleg | EK1WERT55  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert    |
    | -5    | 12.00     | -60.00   |
And I save the current editor

# Vergleichswerte nach Buchen der Wertgutschrift
Given I query "artikel,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(ProductQuantity)" where "artikel==TE55"
Then query has values
    | artikel  | bestand | dbestand    | mrpr      | lpr       | mpr      |
    | TE55     |   90    |  90         |  12.1765  | 12.5000   | 8.6209   |

Given I query "artikel,lgruppe,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(WarehouseGroupQuantity)" where "lgruppe==KARLSRUHE;artikel==TE55"
Then query has values
    | artikel  | lgruppe   | bestand | dbestand    | mrpr     | lpr       | mpr      |
    | TE55     | KARLSRUHE |  90     |  90         |  12.1765 | 12.5000   | 8.6209   |

Given I open an editor "JournalWG1RE2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE55;buarta==Neubewertung;platz==F1;ebeleg==EK1WERT55;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE55              |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -5                |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpr           |  8.6209           |
    | mpra          |  8.8086           |
    | epr           | 12.0000           |
And I close the current editor

# Bewertung nach der Wertgutschrift 1 zu Rechnung 2
Given I open latest Valuation "BewertungZu2.5" for Product "TE55" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           |  35                   |
    | bewwert       |  425.00               |
    | vorgaenger^id | !BewertungZu2.4^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id         | orig^id        | beworig^id     | vkpos   | datum                 |
    | 20   | 12.5000 | 0.0000    | direkt    | !JournalRE3^vom      | !JournalRE3^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalRE3^stand     |
    |  5   | 11.0000 | 0.0000    | vorläufig | !JournalWG1RE2^vom   | !JournalWG1RE2^id | !JournalZu2^id | !JournalZu2^id |         | !JournalWG1RE2^stand  |
    | 10   | 12.0000 | 0.0000    | direkt    | !JournalRE1^vom      | !JournalRE1^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalRE1^stand     |
And I close the current editor

# Komplettwertgutschrift 2 zu Rechnung 3
Given I open an editor "WERT-RE3-BE55" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE3-ZU-BE55"
And I set fields
    | nummer | 2WERTRE3   |
    | such   | EK2WERT55  |
    | ebeleg | EK2WERT55  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -45   | 12.50     | -562.50   |
And I save the current editor

# Journal zu Wertgutschrift zu Rechnung 3 und Anteil ohne Lieferschein, restliche Bestellmenge wartet (10 Stueck)
Given I open an editor "JournalWG2RE3BE" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE55;buarta==Neubewertung;platz==F1;mge==-10;ebeleg==EK2WERT55;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE55              |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -10               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpr           | 8.1360            |
    | mpra          | 8.6209            |
    | epr           | 12.5000           |
And I close the current editor

# Journal zu Wertgutschrift zu Rechnung 3 und Anteil an Lieferschein 2 (20 Stueck)
Given I open an editor "JournalWG2RE3LS2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE55;buarta==Neubewertung;platz==F1;mge==-20;ebeleg==EK2WERT55;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE55              |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -20               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpr           | 6.8892            |
    | mpra          | 8.1360            |
    | epr           | 12.5000           |
And I close the current editor

# Journal zu Wertgutschrift zu Rechnung 3 und Anteil an Lieferschein 3 (15 Stueck)
Given I open an editor "JournalWG2RE3LS3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE55;buarta==Neubewertung;platz==F1;mge==-15;ebeleg==EK2WERT55;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE55              |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -15               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpr           | 5.7670            |
    | mpra          | 6.8892            |
    | epr           | 12.5000           |
And I close the current editor

# Bewertungen nach der Wertgutschrift 2 zu Rechnung 3
Given I open latest Valuation "BewertungZu2.6" for Product "TE55" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           |  35                   |
    | bewwert       |  395.00               |
    | vorgaenger^id | !BewertungZu2.5^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat                   | kverur^id             | orig^id        | beworig^id     | vkpos   | datum                     |
    | 20   | 11.0000 | 0.0000    | vorläufig | !JournalWG2RE3LS2^vom    | !JournalWG2RE3LS2^id  | !JournalZu2^id | !JournalZu2^id |         | !JournalWG2RE3LS2^stand   |
    |  5   | 11.0000 | 0.0000    | vorläufig | !JournalWG1RE2^vom       | !JournalWG1RE2^id     | !JournalZu2^id | !JournalZu2^id |         | !JournalWG1RE2^stand      |
    | 10   | 12.0000 | 0.0000    | direkt    | !JournalRE1^vom          | !JournalRE1^id        | !JournalZu2^id | !JournalZu2^id |         | !JournalRE1^stand         |
And I close the current editor

Given I open latest Valuation "BewertungZu3.3" for Product "TE55" and valuation transaction "JournalZu3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu3^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           |  15                   |
    | bewwert       |  172.50               |
    | vorgaenger^id | !BewertungZu3.2^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat                   | kverur^id             | orig^id        | beworig^id     | vkpos   | datum                     |
    | 15   | 11.5000 | 0.0000    | vorläufig | !JournalWG2RE3LS3^vom    | !JournalWG2RE3LS3^id  | !JournalZu3^id | !JournalZu3^id |         | !JournalWG2RE3LS3^stand   |
And I close the current editor

# Bewertungssammler zu Rechnung 3 wurde geloescht, da diese gutgeschrieben wurde, gibt es dazu keine wartende Menge mehr
Given I query "bewempf,mge,wert" from table "(CostingSheet):(ValuationCollector)" where "bewempf==L3EKRE55"
Then query has no hits
And I close the current editor


Scenario: 06 EK - Rechnung ohne Lagerbewegung - Bestellung, Lieferscheine und Rechnungen fuer Teilmengen, Komplettwertgutschrift, neue Rechnung mit neuem Preis

Given I open an editor "TE66" from table "(Part):(Product)" with command "STORE" for record "TE66"
And I set fields
    | such      | TE66                 |
    | namebspr  | Schraube 66          |
    | vpr       | 15                   |
    | epr       | 10.50                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

# Bestellung
Given I open an editor "BE-02" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE66    |
    | such   | BE-66    |
    | ebeleg | BE-66    |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis |
    | TE66    | 100 | 15    |
And I save the current editor

# Lieferscheine aus Bestellung, Teilmenge, Rechnung soll aus Bestellung erzeugt werden
Given I open an editor "LS1-ZU-BE66" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE66"
And I set fields
   | nummer | 1EKLS66   |
   | ebeleg | LS1-BE66  |
   | such   | LS1-BE66  |
   | ueb    | ja        |
   | fakt   | nein      |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "20" in row 1
Then field "preis" has value "15.00" in row 1
And I set field "preis" to "18" in row 1
And I save the current editor

Given I open an editor "LS2-ZU-BE66" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE66"
And I set fields
   | nummer | 2EKLS66   |
   | ebeleg | LS2-BE66  |
   | such   | LS2-BE66  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "35" in row 1
Then field "preis" has value "15.00" in row 1
And I set field "preis" to "18" in row 1
And I save the current editor

Given I open an editor "LS3-ZU-BE66" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE66"
And I set fields
   | nummer | 3EKLS66   |
   | ebeleg | LS3-BE66  |
   | such   | LS3-BE66  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "45" in row 1
Then field "preis" has value "15.00" in row 1
And I set field "preis" to "18" in row 1
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE66;buarta==Zugang;platz==F1;ebeleg==LS1-BE66"
Then fields have values
    | artikel       | TE66                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 20                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mpr           |  0.0000               |
    | mpra          |  0.0000               |
    | epr           | 18.0000               |
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE66;buarta==Zugang;platz==F1;ebeleg==LS2-BE66"
Then fields have values
    | artikel       | TE66                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 35                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mpr           |  0.0000               |
    | mpra          |  0.0000               |
    | epr           | 18.0000               |
And I close the current editor

Given I open an editor "JournalZu3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE66;buarta==Zugang;platz==F1;ebeleg==LS3-BE66"
Then fields have values
    | artikel       | TE66                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 45                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mpr           |  0.0000               |
    | mpra          |  0.0000               |
    | epr           | 18.0000               |
And I close the current editor

# Bewertungen zu den Lieferscheinen, vor Erstellung der Rechnungen
Given I open latest Valuation "BewertungZu1.1" for Product "TE66" and valuation transaction "JournalZu1" with command "VIEW"
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
    | bewwert       | 360.00                |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 20   | 18.0000 | 0.0000    | vorläufig | !JournalZu1^vom  | !JournalZu1^id    | !JournalZu1^id | !JournalZu1^id |         | !JournalZu1^stand  |
And I close the current editor

Given I open latest Valuation "BewertungZu2.1" for Product "TE66" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 35                    |
    | bewwert       | 630.00                |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 35   | 18.0000 | 0.0000    | vorläufig | !JournalZu2^vom  | !JournalZu2^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalZu2^stand  |
And I close the current editor

Given I open latest Valuation "BewertungZu3.1" for Product "TE66" and valuation transaction "JournalZu3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu3^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 45                    |
    | bewwert       | 810.00                |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 45   | 18.0000 | 0.0000    | vorläufig | !JournalZu3^vom  | !JournalZu3^id    | !JournalZu3^id | !JournalZu3^id |         | !JournalZu3^stand  |
And I close the current editor

# Erstellen und Buchen Rechnung 1
Given I open an editor "RE1-ZU-BE66" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE66"
And I set fields
   | nummer | 1EKRE66   |
   | ebeleg | RE1-BE66  |
   | such   | RE1-BE66  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "15" in row 1
Then field "preis" has value "15.00" in row 1
And I set field "preis" to "20" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 1
Given I open an editor "JournalRE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE66;buarta==Neubewertung;platz==F1;ebeleg==RE1-BE66"
Then fields have values
    | artikel       | TE66                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 15                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           |  3.0000               |
    | mpra          |  0.0000               |
    | epr           | 20.0000               |
And I close the current editor

# Bewertungen zu den Lieferscheinen, Nach Buchen der Rechnung 1
Given I open latest Valuation "BewertungZu1.2" for Product "TE66" and valuation transaction "JournalZu1" with command "VIEW"
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
    | bewwert       | 390.00                |
    | vorgaenger^id | !BewertungZu1.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   | datum              |
    | 15   | 20.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalRE1^stand  |
    |  5   | 18.0000 | 0.0000    | vorläufig | !JournalZu1^vom  | !JournalZu1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalZu1^stand  |
And I close the current editor

# Erstellen und Buchen Rechnung 2
Given I open an editor "RE2-ZU-BE66" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE66"
And I set fields
   | nummer | 2EKRE66   |
   | ebeleg | RE2-BE66  |
   | such   | RE2-BE66  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "25" in row 1
Then field "preis" has value "15.00" in row 1
And I set field "preis" to "20" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 2
Given I open an editor "JournalRE2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE66;buarta==Neubewertung;platz==F1;ebeleg==RE2-BE66"
Then fields have values
    | artikel       | TE66                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 25                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           |  7.2500               |
    | mpra          |  3.0000               |
    | epr           | 20.0000               |
And I close the current editor

# Bewertungen zu den Lieferscheinen, Nach Buchen der Rechnung 2
Given I open latest Valuation "BewertungZu1.3" for Product "TE66" and valuation transaction "JournalZu1" with command "VIEW"
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
    | bewwert       | 400.00                |
    | vorgaenger^id | !BewertungZu1.2^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   | datum              |
    |  5   | 20.0000 | 0.0000    | direkt    | !JournalRE2^vom  | !JournalRE2^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalRE2^stand  |
    | 15   | 20.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalRE1^stand  |
And I close the current editor

Given I open latest Valuation "BewertungZu2.2" for Product "TE66" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 35                    |
    | bewwert       | 670.00                |
    | vorgaenger^id | !BewertungZu2.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 20   | 20.0000 | 0.0000    | direkt    | !JournalRE2^vom  | !JournalRE2^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalRE2^stand  |
    | 15   | 18.0000 | 0.0000    | vorläufig | !JournalZu2^vom  | !JournalZu2^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalZu2^stand  |
And I close the current editor

# Vergleichswerte vor Buchen der Wertgutschrift
Given I query "artikel,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(ProductQuantity)" where "artikel==TE66"
Then query has values
    | artikel  | bestand | dbestand    | mrpr      | lpr       | mpr      |
    | TE66     |   100   |  100        | 20.0000   | 20.0000   | 7.2500   |

Given I query "artikel,lgruppe,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(WarehouseGroupQuantity)" where "lgruppe==KARLSRUHE;artikel==TE66"
Then query has values
    | artikel  | lgruppe   | bestand | dbestand    | mrpr      | lpr       | mpr      |
    | TE66     | KARLSRUHE |   100   |  100        | 20.0000   | 20.0000   | 7.2500   |

# Komplettwertgutschrift 1 zu Rechnung 1
Given I open an editor "WERT-RE1-BE66" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE66"
And I set fields
    | nummer | 1WERTRE1   |
    | such   | EK1WERT66  |
    | ebeleg | EK1WERT66  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert    |
    | -15   | 20.00     | -300.00  |
And I save the current editor

# Vergleichswerte nach Buchen der Wertgutschrift
Given I query "artikel,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(ProductQuantity)" where "artikel==TE66"
Then query has values
    | artikel  | bestand | dbestand    | mrpr      | lpr       | mpr      |
    | TE66     |   100   |  100        | 20.0000   | 20.0000   | 5.0000   |

Given I query "artikel,lgruppe,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(WarehouseGroupQuantity)" where "lgruppe==KARLSRUHE;artikel==TE66"
Then query has values
    | artikel  | lgruppe   | bestand | dbestand    | mrpr      | lpr       | mpr      |
    | TE66     | KARLSRUHE |   100   |  100        | 20.0000   | 20.0000   | 5.0000   |

Given I open an editor "JournalWG1RE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE66;buarta==Neubewertung;platz==F1;ebeleg==EK1WERT66;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE66              |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -15               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpr           |  5.0000           |
    | mpra          |  7.2500           |
    | epr           | 20.0000           |
And I close the current editor

# Bewertung nach der Wertgutschrift 1 zu Rechnung 1
Given I open latest Valuation "BewertungZu1.4" for Product "TE66" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           |  20                   |
    | bewwert       |  370.00               |
    | vorgaenger^id | !BewertungZu1.3^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id         | orig^id        | beworig^id     | vkpos   | datum                 |
    |  5   | 20.0000 | 0.0000    | direkt    | !JournalRE2^vom      | !JournalRE2^id    | !JournalZu1^id | !JournalZu1^id |         | !JournalRE2^stand     |
    | 15   | 18.0000 | 0.0000    | vorläufig | !JournalWG1RE1^vom   | !JournalWG1RE1^id | !JournalZu1^id | !JournalZu1^id |         | !JournalWG1RE1^stand  |
And I close the current editor

# Erstellen und Buchen Rechnung 3, anderer Preis
Given I open an editor "RE3-ZU-BE66" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE66"
And I set fields
   | nummer | 3EKRE66   |
   | ebeleg | RE3-BE66  |
   | such   | RE3-BE66  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "15" in row 1
Then field "preis" has value "15.00" in row 1
And I set field "preis" to "22" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 3
Given I open an editor "JournalRE3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE66;buarta==Neubewertung;platz==F1;ebeleg==RE3-BE66"
Then fields have values
    | artikel       | TE66                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 15                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           |  7.5500               |
    | mpra          |  5.0000               |
    | epr           | 22.0000               |
And I close the current editor

# Bewertung nach Buchen Rechnung 3
Given I open latest Valuation "BewertungZu1.5" for Product "TE66" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           |  20                   |
    | bewwert       |  430.00               |
    | vorgaenger^id | !BewertungZu1.4^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id         | orig^id        | beworig^id     | vkpos   | datum                 |
    | 15   | 22.0000 | 0.0000    | direkt    | !JournalRE3^vom      | !JournalRE3^id    | !JournalZu1^id | !JournalZu1^id |         | !JournalRE3^stand     |
    |  5   | 20.0000 | 0.0000    | direkt    | !JournalRE2^vom      | !JournalRE2^id    | !JournalZu1^id | !JournalZu1^id |         | !JournalRE2^stand     |
And I close the current editor

# nach Buchen der Rechnung 3 gibt es KEINE neue Bewertung zu LS2
# Bewertung entspricht der Bewertung, die zuvor getestet wurde
Given I open latest Valuation "BewertungZu2.3" for Product "TE66" and valuation transaction "JournalZu2" with command "VIEW"
Then field "id" has value "!BewertungZu2.2^id"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 35                    |
    | bewwert       | 670.00                |
    | vorgaenger^id | !BewertungZu2.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 20   | 20.0000 | 0.0000    | direkt    | !JournalRE2^vom  | !JournalRE2^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalRE2^stand  |
    | 15   | 18.0000 | 0.0000    | vorläufig | !JournalZu2^vom  | !JournalZu2^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalZu2^stand  |
And I close the current editor


Scenario: 17 EK - Rechnung ohne Lagerbewegung - Bestellung, Lieferscheine und Rechnungen fuer Teilmengen, Komplettwertgutschrift

Given I open an editor "TE77" from table "(Part):(Product)" with command "STORE" for record "TE77"
And I set fields
    | such      | TE77                 |
    | namebspr  | Schraube 77          |
    | vpr       | 15                   |
    | epr       | 10.50                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "BE-02" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE77    |
    | such   | BE-77    |
    | ebeleg | BE-77    |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis |
    | TE77    | 100 | 10    |
And I save the current editor

# Lieferscheine aus Bestellung, Gesamtmenge, Rechnung soll aus Bestellung erzeugt werden
Given I open an editor "LS1-ZU-BE77" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE77"
And I set fields
   | nummer | 1EKLS77   |
   | ebeleg | LS1-BE77  |
   | such   | LS1-BE77  |
   | ueb    | ja        |
   | fakt   | nein      |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "100" in row 1
Then field "preis" has value "10.00" in row 1
And I set field "preis" to "11" in row 1
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE77;buarta==Zugang;platz==F1;ebeleg==LS1-BE77"
Then fields have values
    | artikel       | TE77                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 100                   |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mpr           |  0.0000               |
    | mpra          |  0.0000               |
    | epr           | 11.0000               |
And I close the current editor

# Bewertungen zu den Lieferscheinen, vor Erstellung der Rechnungen
Given I open latest Valuation "BewertungZu1.1" for Product "TE77" and valuation transaction "JournalZu1" with command "VIEW"
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
    | bewwert       | 1100.00               |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 100  | 11.0000 | 0.0000    | vorläufig | !JournalZu1^vom  | !JournalZu1^id    | !JournalZu1^id | !JournalZu1^id |         | !JournalZu1^stand  |
And I close the current editor

# Rechnung 1 buchen
Given I open an editor "RE1-ZU-BE77" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE77"
And I set fields
   | nummer | 1EKRE77   |
   | ebeleg | RE1-BE77  |
   | such   | RE1-BE77  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "100" in row 1
Then field "preis" has value "10.00" in row 1
And I set field "preis" to "12" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 1
Given I open an editor "JournalRE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE77;buarta==Neubewertung;platz==F1;ebeleg==RE1-BE77"
Then fields have values
    | artikel       | TE77                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 100                   |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 12.0000               |
    | mpra          |  0.0000               |
    | epr           | 12.0000               |
And I close the current editor

# Bewertungen zu den Lieferscheinen, Nach Buchen der Rechnung 1
Given I open latest Valuation "BewertungZu1.2" for Product "TE77" and valuation transaction "JournalZu1" with command "VIEW"
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
    | bewwert       | 1200.00               |
    | vorgaenger^id | !BewertungZu1.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   | datum              |
    | 100  | 12.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalRE1^stand  |
And I close the current editor

# Komplettwertgutschrift zu Rechnung 1 buchen
Given I open an editor "WERT-RE1-BE77" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE77"
And I set fields
    | nummer | 1WERTRE2   |
    | such   | EK1WERT77  |
    | ebeleg | EK1WERT77  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -100  | 12.00     | -1200.00  |
And I save the current editor

Given I open an editor "JournalWG1RE2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE77;buarta==Neubewertung;platz==F1;ebeleg==EK1WERT77;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE77              |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -100              |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 12.0000           |
And I close the current editor

# Bewertung nach der Wertgutschrift 1 zu Rechnung 1 ist wie nach Buchen des Lieferscheins
Given I open latest Valuation "BewertungZu1.3" for Product "TE77" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 100                   |
    | bewwert       | 1100.00               |
    | vorgaenger^id | !BewertungZu1.2^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id         | orig^id        | beworig^id     | vkpos   | datum                 |
    | 100  | 11.0000 | 0.0000    | vorläufig | !JournalWG1RE2^vom   | !JournalWG1RE2^id | !JournalZu1^id | !JournalZu1^id |         | !JournalWG1RE2^stand  |
And I close the current editor

# Rechnung 2 buchen
Given I open an editor "RE2-ZU-BE77" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE77"
And I set fields
   | nummer | 1EKRE277  |
   | ebeleg | RE2-BE77  |
   | such   | RE2-BE77  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "77" in row 1
Then field "preis" has value "10.00" in row 1
And I set field "preis" to "11,50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 2
Given I open an editor "JournalRE2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE77;mge==77;buarta==Neubewertung;platz==F1;ebeleg==RE2-BE77"
Then fields have values
    | artikel       | TE77                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 77                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | epr           | 11.5000               |
And I close the current editor

# Bewertungen zu den Lieferscheinen, Nach Buchen der Rechnung 2
Given I open latest Valuation "BewertungZu1.4" for Product "TE77" and valuation transaction "JournalZu1" with command "VIEW"
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
    | bewwert       | 1138.50               |
    | vorgaenger^id | !BewertungZu1.3^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id         | orig^id        | beworig^id     | vkpos   | datum                 |
    |  77  | 11.5000 | 0.0000    | direkt    | !JournalRE2^vom      | !JournalRE2^id    | !JournalZu1^id | !JournalZu1^id |         | !JournalRE2^stand     |
    |  23  | 11.0000 | 0.0000    | vorläufig | !JournalWG1RE2^vom   | !JournalWG1RE2^id | !JournalZu1^id | !JournalZu1^id |         | !JournalWG1RE2^stand  |
And I close the current editor

Given I open an editor "STORNO-RE2" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE2-ZU-BE77"
And I save the current editor

# Journaleintrag zum Storno
Given I open an editor "JournalRE2Storno" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE77;mge==-77;buarta==Neubewertung;platz==F1;ebeleg==RE2-BE77"
And I close the current editor

# Bewertung nach Storno der Rechnung 2 ist wie nach Buchen des Lieferscheins
Given I open latest Valuation "BewertungZu1.5" for Product "TE77" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalZu1^id            |
    | beistelldaten     | nein                      |
    | bewart            | Vorgangspreis             |
    | abbewart          | Preis des Zugangs                |
    | stornoverur^id    | !JournalRE2Storno^id      |
    | buart             | Neubewertung              |
    | ursache           | Rechnung                  |
    | detursache        | Storno-Rechnung Einkauf   |
    | mge               |  100                      |
    | bewwert           |  1100.00                  |
    | vorgaenger^id     | !BewertungZu1.4^id        |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id         | orig^id        | beworig^id     | vkpos   | datum                 |
    | 100  | 11.0000 | 0.0000    | vorläufig | !JournalWG1RE2^vom   | !JournalWG1RE2^id | !JournalZu1^id | !JournalZu1^id |         | !JournalWG1RE2^stand  |
And I close the current editor

# FDA-4491 und FDA-4572
Scenario: 18 EK - Rechnung ohne Lagerbewegung - Bestellung, Lieferscheine und Rechnungen fuer Teilmengen, Komplettwertgutschrift und Rechnungsstorno

Given I open an editor "TE88" from table "(Part):(Product)" with command "STORE" for record "TE88"
And I set fields
    | such      | TE88                 |
    | namebspr  | Schraube 88          |
    | vpr       | 15                   |
    | epr       | 10.50                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "BE-18" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE88    |
    | such   | BE-88    |
    | ebeleg | BE-88    |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis |
    | TE88    | 100 | 18    |
And I save the current editor

# Lieferscheine aus Bestellung, Gesamtmenge, Rechnung soll aus Bestellung erzeugt werden
Given I open an editor "LS1-ZU-BE88" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE88"
And I set fields
   | nummer | 1EKLS88   |
   | ebeleg | LS1-BE88  |
   | such   | LS1-BE88  |
   | ueb    | ja        |
   | fakt   | nein      |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "10" in row 1
Then field "preis" has value "18.00" in row 1
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE88;buarta==Zugang;platz==F1;ebeleg==LS1-BE88"
Then fields have values
    | artikel       | TE88                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 10                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mpr           |  0.0000               |
    | mpra          |  0.0000               |
    | epr           | 18.0000               |
And I close the current editor

# Bewertungen zu den Lieferscheinen, vor Erstellung der Rechnungen
Given I open latest Valuation "BewertungZu1.1" for Product "TE88" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 10                    |
    | bewwert       | 180.00                |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 10   | 18.0000 | 0.0000    | vorläufig | !JournalZu1^vom  | !JournalZu1^id    | !JournalZu1^id | !JournalZu1^id |         | !JournalZu1^stand  |
And I close the current editor

# Rechnung 1 aus Auftrag erstellen und buchen
Given I open an editor "RE1-ZU-BE88" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE88"
And I set fields
   | nummer | 1EKRE88   |
   | ebeleg | RE1-BE88  |
   | such   | RE1-BE88  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "20" in row 1
Then field "preis" has value "18.00" in row 1
And I set field "preis" to "20" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 1
Given I open an editor "JournalRE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE88;buarta==Neubewertung;platz==F1;ebeleg==RE1-BE88"
Then fields have values
    | artikel       | TE88                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 20                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | epr           | 20.0000               |
And I close the current editor

# Bewertungen zu den Lieferscheinen, Nach Buchen der Rechnung 1
Given I open latest Valuation "BewertungZu1.2" for Product "TE88" and valuation transaction "JournalZu1" with command "VIEW"
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
    | bewwert       | 200.00                |
    | vorgaenger^id | !BewertungZu1.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   | datum              |
    | 10   | 20.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalRE1^stand  |
And I close the current editor

# Lieferscheine aus Bestellung, Teilmenge, Rechnung soll aus Bestellung erzeugt werden
Given I open an editor "LS2-ZU-BE88" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE88"
And I set fields
   | nummer | 1EKL2     |
   | ebeleg | LS2-BE88  |
   | such   | LS2-BE88  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "25" in row 1
Then field "preis" has value "18.00" in row 1
And I save the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE88;buarta==Zugang;platz==F1;ebeleg==LS2-BE88"
Then fields have values
    | artikel       | TE88                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 25                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | epr           | 18.0000               |
And I close the current editor

# Bewertungen zu den Lieferscheinen, vor Erstellung der Rechnung 2, 10 Stk noch aus RE 1 uebrig, 10 Stk noch keine Rechnung
Given I open latest Valuation "BewertungZu2.1" for Product "TE88" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 25                    |
    | bewwert       | 470.00                |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 10   | 20.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalRE1^stand  |
    | 15   | 18.0000 | 0.0000    | vorläufig | !JournalZu2^vom  | !JournalZu2^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalZu2^stand  |
And I close the current editor

# Rechnung 2 aus Auftrag erstellen und buchen
Given I open an editor "RE2-ZU-BE88" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE88"
And I set fields
   | nummer | 1EKRE2    |
   | ebeleg | RE2-BE88  |
   | such   | RE2-BE88  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "3" in row 1
Then field "preis" has value "18.00" in row 1
And I set field "preis" to "21" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 2
Given I open an editor "JournalRE2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE88;buarta==Neubewertung;platz==F1;ebeleg==RE2-BE88"
Then fields have values
    | artikel       | TE88                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 3                     |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | epr           | 21.0000               |
And I close the current editor

# Bewertungen zu den Lieferscheinen, Nach Buchen der Rechnung 2, hat sich nicht geandert
Given I open latest Valuation "BewertungZu1.3" for Product "TE88" and valuation transaction "JournalZu1" with command "VIEW"
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
    | bewwert       | 200.00                |
    | vorgaenger^id | !BewertungZu1.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   | datum              |
    | 10   | 20.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalRE1^stand  |
And I close the current editor

# Bewertungen zu den Lieferscheinen, NACH Erstellung der Rechnung 2, 10 Stk noch aus RE 1 uebrig, 3 Stk RE 2 und 12 Stk noch keine Rechnung
Given I open latest Valuation "BewertungZu2.2" for Product "TE88" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 25                    |
    | bewwert       | 479.00                |
    | vorgaenger^id | !BewertungZu2.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    |  3   | 21.0000 | 0.0000    | direkt    | !JournalRE2^vom  | !JournalRE2^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalRE2^stand  |
    | 10   | 20.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalRE1^stand  |
    | 12   | 18.0000 | 0.0000    | vorläufig | !JournalZu2^vom  | !JournalZu2^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalZu2^stand  |
And I close the current editor

# Komplettwertgutschrift zu Rechnung 1 buchen
Given I open an editor "WERT-RE1-BE88" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE88"
And I set fields
    | nummer | 1WERTRE1   |
    | such   | EK1WERT88  |
    | ebeleg | EK1WERT88  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -20   | 20.00     | -400.00   |
And I save the current editor

# es gibt 2 Journaleintraege mit jeweils Menge -10, deshalb einmal vorwaerts und einmal rueckwaerts suchen
Given I open an editor "JournalWG1RE1.1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE88;buarta==Neubewertung;platz==F1;ebeleg==EK1WERT88;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE88              |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -10               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 20.0000           |
And I close the current editor

Given I open an editor "JournalWG1RE1.2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE88;buarta==Neubewertung;platz==F1;ebeleg==EK1WERT88;@richtung=rückwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE88              |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -10               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 20.0000           |
And I close the current editor

# Bewertung nach der Wertgutschrift 1 zu Rechnung 1 ist wie nach Buchen des Lieferscheins
Given I open latest Valuation "BewertungZu1.4" for Product "TE88" and valuation transaction "JournalZu1" with command "VIEW"
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
    | bewwert       | 180.00                |
    | vorgaenger^id | !BewertungZu1.2^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id             | orig^id        | beworig^id     | vkpos   | datum                     |
    | 10   | 18.0000 | 0.0000    | vorläufig | !JournalWG1RE1.1^vom | !JournalWG1RE1.1^id   | !JournalZu1^id | !JournalZu1^id |         | !JournalWG1RE1.1^stand    |
And I close the current editor

Given I open latest Valuation "BewertungZu2.3" for Product "TE88" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 25                    |
    | bewwert       | 459.00                |
    | vorgaenger^id | !BewertungZu2.2^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id             | orig^id        | beworig^id     | vkpos   | datum                     |
    |  3   | 21.0000 | 0.0000    | direkt    | !JournalRE2^vom      | !JournalRE2^id        | !JournalZu2^id | !JournalZu2^id |         | !JournalRE2^stand         |
    | 10   | 18.0000 | 0.0000    | vorläufig | !JournalWG1RE1.2^vom | !JournalWG1RE1.2^id   | !JournalZu2^id | !JournalZu2^id |         | !JournalWG1RE1.2^stand    |
    | 12   | 18.0000 | 0.0000    | vorläufig | !JournalZu2^vom      | !JournalZu2^id        | !JournalZu2^id | !JournalZu2^id |         | !JournalZu2^stand         |
And I close the current editor

# Erstellen und Buchen Rechnung 3
Given I open an editor "RE3-ZU-BE88" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE88"
And I set fields
   | nummer | 1EKRE388  |
   | ebeleg | RE3-BE88  |
   | such   | RE3-BE88  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "30" in row 1
Then field "preis" has value "18.00" in row 1
And I set field "preis" to "19.50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 3
Given I open an editor "JournalRE3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE88;mge==30;buarta==Neubewertung;platz==F1;ebeleg==RE3-BE88"
Then fields have values
    | artikel       | TE88                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 30                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | epr           | 19.5000               |
And I close the current editor

# Bewertungen zu den Lieferscheinen, Nach Buchen der Rechnung 3
Given I open latest Valuation "BewertungZu1.5" for Product "TE88" and valuation transaction "JournalZu1" with command "VIEW"
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
    | bewwert       | 195.00                |
    | vorgaenger^id | !BewertungZu1.4^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id         | orig^id        | beworig^id     | vkpos   | datum                 |
    |  10  | 19.5000 | 0.0000    | direkt    | !JournalRE3^vom      | !JournalRE3^id    | !JournalZu1^id | !JournalZu1^id |         | !JournalRE3^stand     |
And I close the current editor

Given I open latest Valuation "BewertungZu2.4" for Product "TE88" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 25                    |
    | bewwert       | 489.00                |
    | vorgaenger^id | !BewertungZu2.3^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id             | orig^id        | beworig^id     | vkpos   | datum                     |
    | 20   | 19.5000 | 0.0000    | direkt    | !JournalRE3^vom      | !JournalRE3^id        | !JournalZu2^id | !JournalZu2^id |         | !JournalRE3^stand         |
    |  3   | 21.0000 | 0.0000    | direkt    | !JournalRE2^vom      | !JournalRE2^id        | !JournalZu2^id | !JournalZu2^id |         | !JournalRE2^stand         |
    |  2   | 18.0000 | 0.0000    | vorläufig | !JournalWG1RE1.2^vom | !JournalWG1RE1.2^id   | !JournalZu2^id | !JournalZu2^id |         | !JournalWG1RE1.2^stand    |
And I close the current editor

# Lieferscheine aus Bestellung, Teilmenge, Rechnung soll aus Bestellung erzeugt werden
Given I open an editor "LS3-ZU-BE88" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE88"
And I set fields
   | nummer | 1EKL3     |
   | ebeleg | LS3-BE88  |
   | such   | LS3-BE88  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "10" in row 1
Then field "preis" has value "18.00" in row 1
And I save the current editor

Given I open an editor "JournalZu3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE88;buarta==Zugang;platz==F1;ebeleg==LS3-BE88"
Then fields have values
    | artikel       | TE88                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 10                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | epr           | 18.0000               |
And I close the current editor

# Bewertung zu Lieferschein 3, keine Rechnungsmenge zugeordnet
Given I open latest Valuation "BewertungZu3.1" for Product "TE88" and valuation transaction "JournalZu3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu3^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 10                    |
    | bewwert       | 180.00                |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 10   | 18.0000 | 0.0000    | vorläufig | !JournalZu3^vom  | !JournalZu3^id    | !JournalZu3^id | !JournalZu3^id |         | !JournalZu3^stand  |
And I close the current editor

Given I open an editor "STORNO-RE3" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE3-ZU-BE88"
And I save the current editor

# Journaleintrag zum Storno
Given I open an editor "JournalRE3Storno" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE88;mge==-30;buarta==Neubewertung;platz==F1;ebeleg==RE3-BE88"
And I close the current editor

# Bewertung nach Storno der Rechnung 3 ist wie nach Buchen des Lieferscheins
Given I open latest Valuation "BewertungZu1.6" for Product "TE88" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalZu1^id            |
    | beistelldaten     | nein                      |
    | bewart            | Vorgangspreis             |
    | abbewart          | Preis des Zugangs         |
    | stornoverur^id    | !JournalRE3Storno^id      |
    | buart             | Neubewertung              |
    | ursache           | Rechnung                  |
    | detursache        | Storno-Rechnung Einkauf   |
    | mge               | 10                        |
    | bewwert           | 180.00                    |
    | vorgaenger^id     | !BewertungZu1.5^id        |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id             | orig^id        | beworig^id     | vkpos   | datum                     |
    | 10   | 18.0000 | 0.0000    | vorläufig | !JournalWG1RE1.1^vom | !JournalWG1RE1.1^id   | !JournalZu1^id | !JournalZu1^id |         | !JournalWG1RE1.1^stand    |
And I close the current editor

Given I open latest Valuation "BewertungZu2.5" for Product "TE88" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalZu2^id            |
    | beistelldaten     | nein                      |
    | bewart            | Vorgangspreis             |
    | abbewart          | Preis des Zugangs         |
    | stornoverur^id    | !JournalRE3Storno^id      |
    | buart             | Neubewertung              |
    | ursache           | Rechnung                  |
    | detursache        | Storno-Rechnung Einkauf   |
    | mge               | 25                        |
    | bewwert           | 459.00                    |
    | vorgaenger^id     | !BewertungZu2.4^id        |
Then table has values
    | !row  | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id             | orig^id        | beworig^id     | vkpos   | datum                 |
    | 1     | 10   | 18.0000 | 0.0000    | vorläufig | !JournalWG1RE1.2^vom | !JournalWG1RE1.2^id   | !JournalZu2^id | !JournalZu2^id |         | !JournalWG1RE1.2^stand  |
    | 2     |  3   | 21.0000 | 0.0000    | direkt    | !JournalRE2^vom      | !JournalRE2^id        | !JournalZu2^id | !JournalZu2^id |         | !JournalRE2^stand     |
    | 3     | 12   | 18.0000 | 0.0000    | vorläufig | !JournalZu2^vom      | !JournalZu2^id        | !JournalZu2^id | !JournalZu2^id |         | !JournalZu2^stand     |
And I close the current editor

# Bewertung zu Lieferschein 3, war keine Rechnungsmenge zugeordnet, hat sich nicht geandert, kein Vorgaenger
Given I open latest Valuation "BewertungZu3.2" for Product "TE88" and valuation transaction "JournalZu3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu3^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 10                    |
    | bewwert       | 180.00                |
    | vorgaenger    |                       |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 10   | 18.0000 | 0.0000    | vorläufig | !JournalZu3^vom  | !JournalZu3^id    | !JournalZu3^id | !JournalZu3^id |         | !JournalZu3^stand  |
And I close the current editor

# Lieferscheine aus Bestellung, Teilmenge, Rechnung soll aus Bestellung erzeugt werden
Given I open an editor "LS4-ZU-BE88" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE88"
And I set fields
   | nummer | 1EKL4     |
   | ebeleg | LS4-BE88  |
   | such   | LS4-BE88  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "30" in row 1
Then field "preis" has value "18.00" in row 1
And I save the current editor

Given I open an editor "JournalZu4" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE88;buarta==Zugang;platz==F1;ebeleg==LS4-BE88"
Then fields have values
    | artikel       | TE88                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 30                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | epr           | 18.0000               |
And I close the current editor

# Bewertung zu Lieferschein 4, keine Rechnungsmenge zugeordnet
Given I open latest Valuation "BewertungZu4.1" for Product "TE88" and valuation transaction "JournalZu4" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu4^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 30                    |
    | bewwert       | 540.00                |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 30   | 18.0000 | 0.0000    | vorläufig | !JournalZu4^vom  | !JournalZu4^id    | !JournalZu4^id | !JournalZu4^id |         | !JournalZu4^stand  |
And I close the current editor

# Rechnung 4 erstellen und buchen
Given I open an editor "RE4-ZU-BE88" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE88"
And I set fields
   | nummer | 1EKRE488  |
   | ebeleg | RE4-BE88  |
   | such   | RE4-BE88  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "40" in row 1
Then field "preis" has value "18.00" in row 1
And I set field "preis" to "21.00" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 4
Given I open an editor "JournalRE4" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE88;mge==40;buarta==Neubewertung;platz==F1;ebeleg==RE4-BE88"
Then fields have values
    | artikel       | TE88                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 40                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | epr           | 21.0000               |
And I close the current editor

# Bewertungen zu den Lieferscheinen, Nach Buchen der Rechnung 4
Given I open latest Valuation "BewertungZu1.7" for Product "TE88" and valuation transaction "JournalZu1" with command "VIEW"
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
    | bewwert       | 210.00                |
    | vorgaenger^id | !BewertungZu1.6^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id         | orig^id        | beworig^id     | vkpos   | datum                 |
    |  10  | 21.0000 | 0.0000    | direkt    | !JournalRE4^vom      | !JournalRE4^id    | !JournalZu1^id | !JournalZu1^id |         | !JournalRE4^stand     |
And I close the current editor

# FDA-4572
Given I open latest Valuation "BewertungZu2.6" for Product "TE88" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 25                    |
    | bewwert       | 525.00                |
    | vorgaenger^id | !BewertungZu2.5^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id         | orig^id        | beworig^id     | vkpos   | datum                 |
    | 22   | 21.0000 | 0.0000    | direkt    | !JournalRE4^vom      | !JournalRE4^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalRE4^stand     |
    |  3   | 21.0000 | 0.0000    | direkt    | !JournalRE2^vom      | !JournalRE2^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalRE2^stand     |
And I close the current editor

# Bewertung zu Lieferschein 3
Given I open latest Valuation "BewertungZu3.3" for Product "TE88" and valuation transaction "JournalZu3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu3^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 10                    |
    | bewwert       | 204.00                |
    | vorgaenger^id | !BewertungZu3.2^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    |  8   | 21.0000 | 0.0000    | direkt    | !JournalRE4^vom  | !JournalRE4^id    | !JournalZu3^id | !JournalZu3^id |         | !JournalRE4^stand  |
    |  2   | 18.0000 | 0.0000    | vorläufig | !JournalZu3^vom  | !JournalZu3^id    | !JournalZu3^id | !JournalZu3^id |         | !JournalZu3^stand  |
And I close the current editor

# Bewertung zu Lieferschein 4, noch keine Rechnungsmenge zugeordnet, noch keine Folgebewertung
Given I open latest Valuation "BewertungZu4.2" for Product "TE88" and valuation transaction "JournalZu4" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu4^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 30                    |
    | bewwert       | 540.00                |
    | vorgaenger    |                       |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 30   | 18.0000 | 0.0000    | vorläufig | !JournalZu4^vom  | !JournalZu4^id    | !JournalZu4^id | !JournalZu4^id |         | !JournalZu4^stand  |
And I close the current editor

# Komplettwertgutschrift zu Rechnung 2, Bewertung LS 2 Menge 3 Stk. aendert sich auf vorlaeufig, alles andere bleibt
Given I open an editor "WERT-RE2-BE88" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE2-ZU-BE88"
And I set fields
    | nummer | 1WERTRE2   |
    | such   | EK1WERT2   |
    | ebeleg | EK1WERT2   |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -3    | 21.00     | -63.00    |
And I save the current editor

Given I open an editor "JournalWG1RE2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE88;buarta==Neubewertung;platz==F1;ebeleg==EK1WERT2;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE88              |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -3                |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 21.0000           |
And I close the current editor

# Bewertung nach der Wertgutschrift 1 zu Rechnung 2 ist wie nach Buchen des Lieferscheins fuer die Menge 3
Given I open latest Valuation "BewertungZu2.7" for Product "TE88" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 25                    |
    | bewwert       | 516.00                |
    | vorgaenger^id | !BewertungZu2.6^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id         | orig^id        | beworig^id     | vkpos   | datum                 |
    | 22   | 21.0000 | 0.0000    | direkt    | !JournalRE4^vom      | !JournalRE4^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalRE4^stand     |
    |  3   | 18.0000 | 0.0000    | vorläufig | !JournalWG1RE2^vom   | !JournalWG1RE2^id | !JournalZu2^id | !JournalZu2^id |         | !JournalWG1RE2^stand  |
And I close the current editor

# Storno Rechnung 4 => LS 1 10 Stk ohne RE-Wert, LS 2 22 Stk ohne RE-Wert, LS 3 8 Stk ohne RE-Wert (2 hatten noch keinen RE-Wert)
Given I open an editor "STORNO-RE4" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE4-ZU-BE88"
And I save the current editor

# Journaleintrag zum Storno
Given I open an editor "JournalRE4Storno" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE88;mge==-40;buarta==Neubewertung;platz==F1;ebeleg==RE4-BE88"
And I close the current editor

# Bewertung nach Storno der Rechnung 4 ist wie nach Buchen des Lieferscheins
Given I open latest Valuation "BewertungZu1.8" for Product "TE88" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalZu1^id            |
    | beistelldaten     | nein                      |
    | bewart            | Vorgangspreis             |
    | abbewart          | Preis des Zugangs         |
    | stornoverur^id    | !JournalRE4Storno^id      |
    | buart             | Neubewertung              |
    | ursache           | Rechnung                  |
    | detursache        | Storno-Rechnung Einkauf   |
    | mge               | 10                        |
    | bewwert           | 180.00                    |
    | vorgaenger^id     | !BewertungZu1.7^id        |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id             | orig^id        | beworig^id     | vkpos   | datum                     |
    | 10   | 18.0000 | 0.0000    | vorläufig | !JournalWG1RE1.1^vom | !JournalWG1RE1.1^id   | !JournalZu1^id | !JournalZu1^id |         | !JournalWG1RE1.1^stand    |
And I close the current editor

Given I open latest Valuation "BewertungZu2.8" for Product "TE88" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalZu2^id            |
    | beistelldaten     | nein                      |
    | bewart            | Vorgangspreis             |
    | abbewart          | Preis des Zugangs         |
    | stornoverur^id    | !JournalRE4Storno^id      |
    | buart             | Neubewertung              |
    | ursache           | Rechnung                  |
    | detursache        | Storno-Rechnung Einkauf   |
    | mge               | 25                        |
    | bewwert           | 450.00                    |
    | vorgaenger^id     | !BewertungZu2.7^id        |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id             | orig^id        | beworig^id     | vkpos   | datum                     |
    |  3   | 18.0000 | 0.0000    | vorläufig | !JournalWG1RE2^vom   | !JournalWG1RE2^id     | !JournalZu2^id | !JournalZu2^id |         | !JournalWG1RE2^stand      |
    | 10   | 18.0000 | 0.0000    | vorläufig | !JournalWG1RE1.2^vom | !JournalWG1RE1.2^id   | !JournalZu2^id | !JournalZu2^id |         | !JournalWG1RE1.2^stand    |
    | 12   | 18.0000 | 0.0000    | vorläufig | !JournalZu2^vom      | !JournalZu2^id        | !JournalZu2^id | !JournalZu2^id |         | !JournalZu2^stand         |
And I close the current editor

Given I open latest Valuation "BewertungZu3.4" for Product "TE88" and valuation transaction "JournalZu3" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalZu3^id            |
    | beistelldaten     | nein                      |
    | bewart            | Vorgangspreis             |
    | abbewart          | Preis des Zugangs         |
    | stornoverur^id    | !JournalRE4Storno^id      |
    | buart             | Zugang                    |
    | ursache           | Lieferschein              |
    | detursache        | Storno-Rechnung Einkauf   |
    | mge               | 10                        |
    | bewwert           | 180.00                    |
    | vorgaenger^id     | !BewertungZu3.3^id        |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 10   | 18.0000 | 0.0000    | vorläufig | !JournalZu3^vom  | !JournalZu3^id    | !JournalZu3^id | !JournalZu3^id |         | !JournalZu3^stand  |
And I close the current editor

# Bewertung zu Lieferschein 4, noch keine Rechnungsmenge zugeordnet, noch keine Folgebewertung
Given I open latest Valuation "BewertungZu4.3" for Product "TE88" and valuation transaction "JournalZu4" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu4^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
    | mge           | 30                    |
    | bewwert       | 540.00                |
    | vorgaenger    |                       |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 30   | 18.0000 | 0.0000    | vorläufig | !JournalZu4^vom  | !JournalZu4^id    | !JournalZu4^id | !JournalZu4^id |         | !JournalZu4^stand  |
And I close the current editor

# Rechnung 5 erstellen und buchen, 50 Stk Preis 20 => LS 1 10 Stk, LS 2 25 Stk, LS 3 10 Stk, LS 4 5 Stk (Rest 25 Stk)
Given I open an editor "RE5-ZU-BE88" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE88"
And I set fields
   | nummer | 1EKRE588  |
   | ebeleg | RE5-BE88  |
   | such   | RE5-BE88  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "50" in row 1
Then field "preis" has value "18.00" in row 1
And I set field "preis" to "20.00" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 5
Given I open an editor "JournalRE5" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE88;mge==50;buarta==Neubewertung;platz==F1;ebeleg==RE5-BE88"
Then fields have values
    | artikel       | TE88                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 50                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | epr           | 20.0000               |
And I close the current editor

# Bewertungen zu den Lieferscheinen, Nach Buchen der Rechnung 5
Given I open latest Valuation "BewertungZu1.9" for Product "TE88" and valuation transaction "JournalZu1" with command "VIEW"
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
    | bewwert       | 200.00                |
    | vorgaenger^id | !BewertungZu1.8^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id         | orig^id        | beworig^id     | vkpos   | datum                 |
    |  10  | 20.0000 | 0.0000    | direkt    | !JournalRE5^vom      | !JournalRE5^id    | !JournalZu1^id | !JournalZu1^id |         | !JournalRE5^stand     |
And I close the current editor

Given I open latest Valuation "BewertungZu2.9" for Product "TE88" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 25                    |
    | bewwert       | 500.00                |
    | vorgaenger^id | !BewertungZu2.8^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id         | orig^id        | beworig^id     | vkpos   | datum             |
    | 25   | 20.0000 | 0.0000    | direkt    | !JournalRE5^vom      | !JournalRE5^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalRE5^stand |
And I close the current editor

# Bewertung zu Lieferschein 3
Given I open latest Valuation "BewertungZu3.5" for Product "TE88" and valuation transaction "JournalZu3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu3^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 10                    |
    | bewwert       | 200.00                |
    | vorgaenger^id | !BewertungZu3.4^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 10   | 20.0000 | 0.0000    | direkt    | !JournalRE5^vom  | !JournalRE5^id    | !JournalZu3^id | !JournalZu3^id |         | !JournalRE5^stand  |
And I close the current editor

# Bewertung zu Lieferschein 4
Given I open latest Valuation "BewertungZu4.4" for Product "TE88" and valuation transaction "JournalZu4" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu4^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 30                    |
    | bewwert       | 550.00                |
    | vorgaenger^id | !BewertungZu4.3^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    |  5   | 20.0000 | 0.0000    | direkt    | !JournalRE5^vom  | !JournalRE5^id    | !JournalZu4^id | !JournalZu4^id |         | !JournalRE5^stand  |
    | 25   | 18.0000 | 0.0000    | vorläufig | !JournalZu4^vom  | !JournalZu4^id    | !JournalZu4^id | !JournalZu4^id |         | !JournalZu4^stand  |
And I close the current editor

# Rechnung 6 erstellen und buchen, 10 Stk Preis 22 => LS 4 10 Stk (5 wie vorher, Rest LS 15)
Given I open an editor "RE6-ZU-BE88" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE88"
And I set fields
   | nummer | 1EKRE688  |
   | ebeleg | RE6-BE88  |
   | such   | RE6-BE88  |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "10" in row 1
Then field "preis" has value "18.00" in row 1
And I set field "preis" to "21.00" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung 6
Given I open an editor "JournalRE6" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE88;mge==10;buarta==Neubewertung;platz==F1;ebeleg==RE6-BE88"
Then fields have values
    | artikel       | TE88                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 10                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | epr           | 21.0000               |
And I close the current editor

# Bewertungen zu den Lieferscheinen, Nach Buchen der Rechnung 6, keine Veraenderung
Given I open latest Valuation "BewertungZu1.9" for Product "TE88" and valuation transaction "JournalZu1" with command "VIEW"
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
    | bewwert       | 200.00                |
    | vorgaenger^id | !BewertungZu1.8^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id         | orig^id        | beworig^id     | vkpos   | datum                 |
    |  10  | 20.0000 | 0.0000    | direkt    | !JournalRE5^vom      | !JournalRE5^id    | !JournalZu1^id | !JournalZu1^id |         | !JournalRE5^stand     |
And I close the current editor

Given I open latest Valuation "BewertungZu2.9" for Product "TE88" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 25                    |
    | bewwert       | 500.00                |
    | vorgaenger^id | !BewertungZu2.8^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id         | orig^id        | beworig^id     | vkpos   | datum                 |
    | 25   | 20.0000 | 0.0000    | direkt    | !JournalRE5^vom      | !JournalRE5^id    | !JournalZu2^id | !JournalZu2^id |         | !JournalRE5^stand     |
And I close the current editor

Given I open latest Valuation "BewertungZu3.5" for Product "TE88" and valuation transaction "JournalZu3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu3^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 10                    |
    | bewwert       | 200.00                |
    | vorgaenger^id | !BewertungZu3.4^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    |  10  | 20.0000 | 0.0000    | direkt    | !JournalRE5^vom  | !JournalRE5^id    | !JournalZu3^id | !JournalZu3^id |         | !JournalRE5^stand  |
And I close the current editor

# Bewertung zu Lieferschein 4, 10 Stk bewertet durch Rechnung 6
Given I open latest Valuation "BewertungZu4.5" for Product "TE88" and valuation transaction "JournalZu4" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu4^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 30                    |
    | bewwert       | 580.00                |
    | vorgaenger^id | !BewertungZu4.4^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 10   | 21.0000 | 0.0000    | direkt    | !JournalRE6^vom  | !JournalRE6^id    | !JournalZu4^id | !JournalZu4^id |         | !JournalRE6^stand  |
    |  5   | 20.0000 | 0.0000    | direkt    | !JournalRE5^vom  | !JournalRE5^id    | !JournalZu4^id | !JournalZu4^id |         | !JournalRE5^stand  |
    | 15   | 18.0000 | 0.0000    | vorläufig | !JournalZu4^vom  | !JournalZu4^id    | !JournalZu4^id | !JournalZu4^id |         | !JournalZu4^stand  |
And I close the current editor

# Komplettwertgutschrift zu Rechnung 5 erstellen und buchen
# KWG => LS 1, 2 und 3 ohne RE-Wert, LS 4 5 Stk ohne RE-Wert, 10 Stk mit Wert RE 6 und 15 St schon vorher ohne RE-Wert
Given I open an editor "WERT-RE5-BE88" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE5-ZU-BE88"
And I set fields
    | nummer | 1WERTRE5   |
    | such   | EK1WERT5   |
    | ebeleg | EK1WERT5   |
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

Given I open an editor "JournalWG1RE5.1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE88;mge==-10;buarta==Neubewertung;platz==F1;ebeleg==EK1WERT5;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE88              |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -10               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 20.0000           |
And I close the current editor

Given I open an editor "JournalWG1RE5.2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE88;mge==-25;buarta==Neubewertung;platz==F1;ebeleg==EK1WERT5;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE88              |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -25               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 20.0000           |
And I close the current editor

Given I open an editor "JournalWG1RE5.3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE88;mge==-10;buarta==Neubewertung;platz==F1;ebeleg==EK1WERT5;@richtung=rückwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE88              |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -10               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 20.0000           |
And I close the current editor

Given I open an editor "JournalWG1RE5.4" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE88;mge==-5;buarta==Neubewertung;platz==F1;ebeleg==EK1WERT5;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE88              |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -5                |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 20.0000           |
And I close the current editor

# Bewertung nach der Wertgutschrift 1 zu Rechnung 5 ist wie nach Buchen des Lieferscheins
Given I open latest Valuation "BewertungZu1.10" for Product "TE88" and valuation transaction "JournalZu1" with command "VIEW"
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
    | bewwert       | 180.00                |
    | vorgaenger^id | !BewertungZu1.9^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id           | orig^id        | beworig^id     | vkpos   | datum                  |
    | 10   | 18.0000 | 0.0000    | vorläufig | !JournalWG1RE5.1^vom | !JournalWG1RE5.1^id | !JournalZu1^id | !JournalZu1^id |         | !JournalWG1RE5.1^stand |
And I close the current editor

Given I open latest Valuation "BewertungZu2.10" for Product "TE88" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 25                    |
    | bewwert       | 450.00                |
    | vorgaenger^id | !BewertungZu2.9^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id           | orig^id        | beworig^id     | vkpos   | datum                   |
    | 25   | 18.0000 | 0.0000    | vorläufig | !JournalWG1RE5.2^vom | !JournalWG1RE5.2^id | !JournalZu2^id | !JournalZu2^id |         | !JournalWG1RE5.2^stand  |
And I close the current editor

Given I open latest Valuation "BewertungZu3.6" for Product "TE88" and valuation transaction "JournalZu3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu3^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 10                    |
    | bewwert       | 180.00                |
    | vorgaenger^id | !BewertungZu3.5^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id           | orig^id        | beworig^id     | vkpos   | datum                   |
    | 10   | 18.0000 | 0.0000    | vorläufig | !JournalWG1RE5.3^vom | !JournalWG1RE5.3^id | !JournalZu3^id | !JournalZu3^id |         | !JournalWG1RE5.3^stand  |
And I close the current editor

Given I open latest Valuation "BewertungZu4.6" for Product "TE88" and valuation transaction "JournalZu4" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu4^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 30                    |
    | bewwert       | 570.00                |
    | vorgaenger^id | !BewertungZu4.5^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id             | orig^id        | beworig^id     | vkpos   | datum                  |
    | 10   | 21.0000 | 0.0000    | direkt    | !JournalRE6^vom      | !JournalRE6^id        | !JournalZu4^id | !JournalZu4^id |         | !JournalRE6^stand      |
    |  5   | 18.0000 | 0.0000    | vorläufig | !JournalWG1RE5.4^vom | !JournalWG1RE5.4^id   | !JournalZu4^id | !JournalZu4^id |         | !JournalWG1RE5.4^stand |
    | 15   | 18.0000 | 0.0000    | vorläufig | !JournalZu4^vom      | !JournalZu4^id        | !JournalZu4^id | !JournalZu4^id |         | !JournalZu4^stand      |
And I close the current editor

# Storno RE 6 => LS 4 auch komplett ohne RE-Wert (keine berechnete Menge mehr, gelieferte Menge 75)
Given I open an editor "STORNO-RE6" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE6-ZU-BE88"
And I save the current editor

# Journaleintrag zum Storno
Given I open an editor "JournalRE6Storno" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE88;mge==-10;buarta==Neubewertung;platz==F1;ebeleg==RE6-BE88"
And I close the current editor

# Bewertung nach Storno der Rechnung 6, LS 1-3 nicht betroffen, nur LS 4
Given I open latest Valuation "BewertungZu1.11" for Product "TE88" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalZu1^id            |
    | beistelldaten     | nein                      |
    | bewart            | Vorgangspreis             |
    | abbewart          | Preis des Zugangs         |
    | stornoverur       |                           |
    | buart             | Neubewertung              |
    | ursache           | Rechnung                  |
    | detursache        | Wertgutschrift            |
    | mge               | 10                        |
    | bewwert           | 180.00                    |
    | vorgaenger^id     | !BewertungZu1.9^id        |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id           | orig^id        | beworig^id     | vkpos   | datum                  |
    | 10   | 18.0000 | 0.0000    | vorläufig | !JournalWG1RE5.1^vom | !JournalWG1RE5.1^id | !JournalZu1^id | !JournalZu1^id |         | !JournalWG1RE5.1^stand |
And I close the current editor

Given I open latest Valuation "BewertungZu2.11" for Product "TE88" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalZu2^id            |
    | beistelldaten     | nein                      |
    | bewart            | Vorgangspreis             |
    | abbewart          | Preis des Zugangs         |
    | stornoverur       |                           |
    | buart             | Neubewertung              |
    | ursache           | Rechnung                  |
    | detursache        | Wertgutschrift            |
    | mge               | 25                        |
    | bewwert           | 450.00                    |
    | vorgaenger^id     | !BewertungZu2.9^id        |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id           | orig^id        | beworig^id     | vkpos   | datum                   |
    | 25   | 18.0000 | 0.0000    | vorläufig | !JournalWG1RE5.2^vom | !JournalWG1RE5.2^id | !JournalZu2^id | !JournalZu2^id |         | !JournalWG1RE5.2^stand  |
And I close the current editor

Given I open latest Valuation "BewertungZu3.7" for Product "TE88" and valuation transaction "JournalZu3" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalZu3^id            |
    | beistelldaten     | nein                      |
    | bewart            | Vorgangspreis             |
    | abbewart          | Preis des Zugangs         |
    | stornoverur       |                           |
    | buart             | Neubewertung              |
    | ursache           | Rechnung                  |
    | detursache        | Wertgutschrift            |
    | mge               | 10                        |
    | bewwert           | 180.00                    |
    | vorgaenger^id     | !BewertungZu3.5^id        |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id           | orig^id        | beworig^id     | vkpos   | datum                  |
    | 10   | 18.0000 | 0.0000    | vorläufig | !JournalWG1RE5.3^vom | !JournalWG1RE5.3^id | !JournalZu3^id | !JournalZu3^id |         | !JournalWG1RE5.3^stand |
And I close the current editor

# Bewertung zu Lieferschein 4, auch komplett ohne Rechnung
Given I open latest Valuation "BewertungZu4.7" for Product "TE88" and valuation transaction "JournalZu4" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalZu4^id            |
    | beistelldaten     | nein                      |
    | bewart            | Vorgangspreis             |
    | abbewart          | Preis des Zugangs         |
    | stornoverur^id    | !JournalRE6Storno^id      |
    | buart             | Neubewertung              |
    | ursache           | Rechnung                  |
    | detursache        | Storno-Rechnung Einkauf   |
    | mge               | 30                        |
    | bewwert           | 540.00                    |
    | vorgaenger^id     | !BewertungZu4.6^id        |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat               | kverur^id             | orig^id        | beworig^id     | vkpos   | datum                  |
    |  5   | 18.0000 | 0.0000    | vorläufig | !JournalWG1RE5.4^vom | !JournalWG1RE5.4^id   | !JournalZu4^id | !JournalZu4^id |         | !JournalWG1RE5.4^stand |
    | 25   | 18.0000 | 0.0000    | vorläufig | !JournalZu4^vom      | !JournalZu4^id        | !JournalZu4^id | !JournalZu4^id |         | !JournalZu4^stand      |
And I close the current editor
