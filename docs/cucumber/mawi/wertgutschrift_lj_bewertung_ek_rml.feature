# *****************************************************************************
#  Name           : wertgutschrift_lj_bewertung_ek_rml.feature
#  Verantwortlich : bschiga
#  Kontrolle      : carue
#  Funktion       : Test der LJ und Bewertungen bei Wertgutschriften
#
# *****************************************************************************
#
@persistent
Feature: wertgutschrift_lj_bewertung_ek_rml.feature
Background:
Given I set the fake date to "02.01.1995"

# fuer alle Szenarien wird Bewertungskonfiguration 1 verwendet, Preis des Zugangs und Vorgangspreis

Scenario: Stammdaten

Given I open an editor "firma" from table "(Company):(ValuationConfiguration)" with command "UPDATE" for record "10"
And I modify table
  | !row | bewab             | bewzu         |
  | 1    | Preis des Zugangs | Vorgangspreis |
And I save the current editor


Scenario: 01 EK - Rechnung mit Lagerbewegung und 2 MZ, Komplettwertgutschrift

Given I open an editor "TE111" from table "(Part):(Product)" with command "STORE" for record "TE111"
And I set fields
    | such      | TE111                |
    | namebspr  | Schraube 111         |
    | vpr       | 15                   |
    | epr       | 10.50                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

# Bestellung Preis 11,00
Given I open an editor "BE-01" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE111   |
    | such   | BE-111   |
    | ebeleg | BE-111   |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis | verw  |
    | TE111   |  10 | 11    | EK111 |
And I save the current editor

# Rechnung mit Lagerbewegung und 2 MZ buchen, komplette Menge und abweichender Preis 10,00
Given I open an editor "RE-ZU-BE111" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE111"
And I set fields
    | nummer | 1EKRE111    |
    | ebeleg | RE-LB-BE111 |
    | such   | RE-BE111    |
    | ueb    | ja          |
    | vom    | .           |
    | tterm  | .           |
    | fakt   | ja          |
And I set field "mge" to "10" in row 1
Then field "preis" has value "11.00" in row 1
And I set field "preis" to "10" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge |
    | F1     | 7      |
    | F2     | 3      |
And I save the current editor
And I switch the current editor to editor "RE-ZU-BE111"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Vergleichswerte vor Buchen der Wertgutschrift
Given I query "artikel,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(ProductQuantity)" where "artikel==TE111"
Then query has values
    | artikel   | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE111     |   10    |  7          | 10.0000   | 10.0000   | 10.0000   |

Given I query "artikel,lgruppe,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(WarehouseGroupQuantity)" where "lgruppe==KARLSRUHE;artikel==TE111"
Then query has values
    | artikel   | lgruppe   | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE111     | KARLSRUHE |  10     |  7          | 10.0000   | 10.0000   | 10.0000   |

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE111;buarta==Zugang;platz==F1;ebeleg==RE-LB-BE111"
Then fields have values
    | artikel       | TE111      |
    | platz         | F1         |
    | lgruppe       | KARLSRUHE  |
    | mge           | 7          |
    | buart         | 1          |
    | buarta        | Zugang     |
    | ursache       | Rechnung   |
    | detursache    | Rechnung   |
    | mpr           | 10.0000    |
    | mpra          |  0.0000    |
    | epr           | 10.0000    |
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE111;buarta==Zugang;platz==F2;ebeleg==RE-LB-BE111"
Then fields have values
    | artikel       | TE111      |
    | platz         | F2         |
    | lgruppe       | KARLSRUHE  |
    | mge           | 3          |
    | buart         | 1          |
    | buarta        | Zugang     |
    | ursache       | Rechnung   |
    | detursache    | Rechnung   |
    | mpr           | 10.0000    |
    | mpra          | 10.0000    |
    | epr           | 10.0000    |
And I close the current editor

# Bewertungen
Given I open latest Valuation "BewertungZu1" for Product "TE111" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id    |
    | beistelldaten | nein              |
    | bewart        | Vorgangspreis     |
    | abbewart      | Preis des Zugangs |
    | stornoverur   |                   |
    | buart         | Zugang            |
    | ursache       | Rechnung          |
    | detursache    | Rechnung          |
    | mge           | 7                 |
    | bewwert       | 70.00             |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id        | orig^id        | beworig^id     | vkpos   | datum              |
    | 7    | 10.0000 | 0.0000    | direkt    | !JournalZu1^vom  | !JournalZu1^id   | !JournalZu1^id | !JournalZu1^id |         | !JournalZu1^stand  |
And I close the current editor

Given I open latest Valuation "BewertungZu2" for Product "TE111" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id    |
    | beistelldaten | nein              |
    | bewart        | Vorgangspreis     |
    | abbewart      | Preis des Zugangs |
    | stornoverur   |                   |
    | buart         | Zugang            |
    | ursache       | Rechnung          |
    | detursache    | Rechnung          |
    | mge           | 3                 |
    | bewwert       | 30.00             |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id        | orig^id        | beworig^id     | vkpos   | datum              |
    | 3    | 10.0000 | 0.0000    | direkt    | !JournalZu2^vom  | !JournalZu2^id   | !JournalZu2^id | !JournalZu2^id |         | !JournalZu2^stand  |
And I close the current editor

# Komplettwertgutschrift buchen
Given I open an editor "WERT-ZU-BE111" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-ZU-BE111"
And I set fields
    | nummer | 1WERT111   |
    | such   | EKWERT111  |
    | ebeleg | EKWERT111  |
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

# Vergleichswerte nach Buchen der Wertgutschrift
Given I query "artikel,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(ProductQuantity)" where "artikel==TE111"
Then query has values
    | artikel   | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE111     |   10    |  7          | 10.0000   | 10.0000   | 10.0000   |

Given I query "artikel,lgruppe,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(WarehouseGroupQuantity)" where "lgruppe==KARLSRUHE;artikel==TE111"
Then query has values
    | artikel   | lgruppe   | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE111     | KARLSRUHE |   10    |  7          | 10.0000   | 10.0000   | 10.0000   |

Given I open an editor "JournalWG1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE111;buarta==Neubewertung;platz==F1;ebeleg==EKWERT111;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE111             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -7                |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpr           | 10.0000           |
    | mpra          | 10.0000           |
    | epr           | 10.0000           |
And I close the current editor

Given I open an editor "JournalWG2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE111;buarta==Neubewertung;platz==F2;ebeleg==EKWERT111;@richtung=rückwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE111             |
    | platz         | F2                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -3                |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpr           | 10.0000           |
    | mpra          | 10.0000           |
    | epr           | 10.0000           |
And I close the current editor

# Bewertungen, Bewertungspreis aendert sich auf den Bestellpreis nach der Wertgutschrift
Given I open latest Valuation "BewertungWG1" for Product "TE111" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id    |
    | beistelldaten | nein              |
    | bewart        | Vorgangspreis     |
    | abbewart      | Preis des Zugangs |
    | stornoverur   |                   |
    | buart         | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mge           |  7                |
    | bewwert       |  77.00            |
    | vorgaenger^id | !BewertungZu1^id  |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id        | orig^id        | beworig^id     | vkpos   | datum              |
    | 7    | 11.0000 | 0.0000    | vorläufig | !JournalZu1^vom  | !JournalWG1^id   | !JournalZu1^id | !JournalZu1^id |         | !JournalWG1^stand  |
And I close the current editor

Given I open latest Valuation "BewertungWG2" for Product "TE111" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id    |
    | beistelldaten | nein              |
    | bewart        | Vorgangspreis     |
    | abbewart      | Preis des Zugangs |
    | stornoverur   |                   |
    | buart         | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mge           |  3                |
    | bewwert       |  33.00            |
    | vorgaenger^id | !BewertungZu2^id  |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id        | orig^id        | beworig^id     | vkpos   | datum              |
    | 3    | 11.0000 | 0.0000    | vorläufig | !JournalZu2^vom  | !JournalWG2^id   | !JournalZu2^id | !JournalZu2^id |         | !JournalWG2^stand  |
And I close the current editor


Scenario: 02 EK - manuelle LBU mit Preis, Rechnung mit Lagerbewegung, Kostenumlage, Komplettwertgutschrift

Given I open an editor "TE222" from table "(Part):(Product)" with command "STORE" for record "TE222"
And I set fields
    | such      | TE222                |
    | namebspr  | Schraube 222         |
    | vpr       | 15                   |
    | epr       | 10.50                |
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

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | TE222     |
    | buart     | Zugang    |
    | beleg     | LBU_TE222 |
    | beldat    | .         |
    | wert      | 10.0000   |
And I delete all rows
And I append rows
    | mge    | platz2   |
    | 10     | F1       |
And I save the current editor

# Mischpreis nach der LBU (mrp=Mischpreis, mrpr=mittlerer Rechnungspreis, lpr=letzter Einstandspreis)
Given I query "artikel,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(ProductQuantity)" where "artikel==TE222"
Then query has values
    | artikel   | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE222     |   10    |  10         |  0.0000   | 10.0000   | 10.0000   |

Given I query "artikel,lgruppe,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(WarehouseGroupQuantity)" where "lgruppe==KARLSRUHE;artikel==TE222"
Then query has values
    | artikel   | lgruppe   | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE222     | KARLSRUHE |  10     |  10         |  0.0000   | 10.0000   | 10.0000   |

# Bestellung, Preis 9,00
Given I open an editor "BE-02" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE222   |
    | such   | BE-222   |
    | ebeleg | BE-222   |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis | verw  |
    | TE222   |  10 | 9     | EK222 |
And I save the current editor

# Rechnung mit Lagerbewegung aus der Bestellung, Gesamtmenge und abweichender Preis 12,00
Given I open an editor "RE-ZU-BE222" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE222"
And I set fields
    | nummer | 1EKRE222    |
    | ebeleg | RE-LB-BE222 |
    | such   | RE-BE222    |
    | ueb    | ja          |
    | vom    | .           |
    | tterm  | .           |
    | fakt   | ja          |
And I set field "mge" to "10" in row 1
Then field "preis" has value "9.00" in row 1
And I set field "preis" to "12" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Vergleichswerte ausgeben, Mischpreis hat sich durch die Rechnung geaendert, gegenueber der LBU
Given I query "artikel,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(ProductQuantity)" where "artikel==TE222"
Then query has values
    | artikel   | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE222     |   20    |  20         | 12.0000   | 12.0000   | 11.0000   |

Given I query "artikel,lgruppe,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(WarehouseGroupQuantity)" where "lgruppe==KARLSRUHE;artikel==TE222"
Then query has values
    | artikel   | lgruppe   | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE222     | KARLSRUHE |  20     |  20         | 12.0000   | 12.0000   | 11.0000   |

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE222;buarta==Zugang;platz==F1;ebeleg==RE-LB-BE222"
Then fields have values
    | artikel       | TE222      |
    | platz         | F1         |
    | lgruppe       | KARLSRUHE  |
    | mge           | 10         |
    | buart         | 1          |
    | buarta        | Zugang     |
    | ursache       | Rechnung   |
    | detursache    | Rechnung   |
    | mpr           | 11.0000    |
    | mpra          | 10.0000    |
    | epr           | 12.0000    |
And I close the current editor

# Bewertung
Given I open latest Valuation "BewertungZu1.1" for Product "TE222" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id    |
    | beistelldaten | nein              |
    | bewart        | Vorgangspreis     |
    | abbewart      | Preis des Zugangs |
    | stornoverur   |                   |
    | buart         | Zugang            |
    | ursache       | Rechnung          |
    | detursache    | Rechnung          |
    | mge           | 10                |
    | bewwert       | 120.00            |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id        | orig^id        | beworig^id     | vkpos   | datum              |
    | 10   | 12.0000 | 0.0000    | direkt    | !JournalZu1^vom  | !JournalZu1^id   | !JournalZu1^id | !JournalZu1^id |         | !JournalZu1^stand  |
And I close the current editor

# Rechnung mit Transportkosten anlegen
Given I open an editor "RE-FRACHT222" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | 001           |
    | nummer | 1FRACHT       |
    | ebeleg | RE-FRACHT222  |
    | such   | FRACHT222     |
    | ueb    | ja            |
    | vom    | .             |
    | tterm  | .             |
And I delete all rows
And I append rows
    | artikel   | pwert | ptext         |
    | FRACHT    | 5     | kostuml_RE222 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Kostenumlage erzeugen
Given I open an editor "kostenuml-222" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "222"
And I set field "such" to "kuml222"
And I set field "pos" to "$,,ptext==kostuml_RE222;art==FRACHT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,artikel==TE222;mge==10;pwert==120.00;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor

# Bewertung nach der Kostenumlage
Given I open latest Valuation "BewertungZu1.2" for Product "TE222" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 10                    |
    | bewwert       | 125.00                |
    | vorgaenger^id | !BewertungZu1.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id             | orig^id        | beworig^id     | vkpos   | datum              |
    | 10   | 12.5000 | 0.5000    | direkt    | !JournalZu1^vom  | !kostenuml-222^id     | !JournalZu1^id | !JournalZu1^id |         | !JournalZu1^stand  |
And I close the current editor

# Komplettwertgutschrift buchen
Given I open an editor "WERT-ZU-BE222" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-ZU-BE222"
And I set fields
    | nummer | 1WERT222   |
    | such   | EKWERT222  |
    | ebeleg | EKWERT222  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -10   | 12.00     | -120.00   |
And I save the current editor

# Vergleichswerte nach Buchen der Wertgutschrift
Given I query "artikel,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(ProductQuantity)" where "artikel==TE222"
Then query has values
    | artikel   | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE222     |   20    |  20         | 12.0000   | 12.0000   | 10.0000   |

Given I query "artikel,lgruppe,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(WarehouseGroupQuantity)" where "lgruppe==KARLSRUHE;artikel==TE222"
Then query has values
    | artikel   | lgruppe   | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE222     | KARLSRUHE |   20    |  20         | 12.0000   | 12.0000   | 10.0000   |

Given I open an editor "JournalWG1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE222;buarta==Neubewertung;platz==F1;ebeleg==EKWERT222;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE222             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -10               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpr           | 10.0000           |
    | mpra          | 11.0000           |
    | epr           | 12.0000           |
And I close the current editor

# Bewertung
Given I open latest Valuation "BewertungWG1" for Product "TE222" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           |  10                   |
    | bewwert       |  95.00                |
    | vorgaenger^id | !BewertungZu1.2^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id        | orig^id        | beworig^id     | vkpos   | datum              |
    | 10   | 9.5000  | 0.5000    | vorläufig | !JournalZu1^vom  | !JournalWG1^id   | !JournalZu1^id | !JournalZu1^id |         | !JournalWG1^stand  |
And I close the current editor


Scenario: 03 EK - Rechnung mit Lagerbewegung, Abgang Teilmenge, Mengenneubewertung, Storno Mengenneubewertung, Komplettwertgutschrift

Given I open an editor "TE333" from table "(Part):(Product)" with command "STORE" for record "TE333"
And I set fields
    | such      | TE333                |
    | namebspr  | Schraube 333         |
    | vpr       | 15                   |
    | epr       | 10.50                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

# Bestellung, Preis 11,00
Given I open an editor "BE-02" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE333   |
    | such   | BE-333   |
    | ebeleg | BE-333   |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis |
    | TE333   |  10 | 11    |
And I save the current editor

# Rechnung mit Lagerbewegung aus der Bestellung, Gesamtmenge und abweichender Preis 12,00
Given I open an editor "RE-ZU-BE333" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE333"
And I set fields
   | nummer | 1EKRE333    |
   | ebeleg | RE-LB-BE333 |
   | such   | RE-BE333    |
   | ueb    | ja          |
   | vom    | .           |
   | tterm  | .           |
   | fakt   | ja          |
And I set field "mge" to "10" in row 1
Then field "preis" has value "11.00" in row 1
And I set field "preis" to "12" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Mischpreis (mrp=Mischpreis, mrpr=mittlerer Rechnungspreis, lpr=letzter Einstandspreis)
Given I query "artikel,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(ProductQuantity)" where "artikel==TE333"
Then query has values
    | artikel   | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE333     |   10    |  10         |  12.0000  | 12.0000   | 12.0000   |

Given I query "artikel,lgruppe,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(WarehouseGroupQuantity)" where "lgruppe==KARLSRUHE;artikel==TE333"
Then query has values
    | artikel   | lgruppe   | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE333     | KARLSRUHE |  10     |  10         |  12.0000  | 12.0000   | 12.0000   |

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE333;buarta==Zugang;platz==F1;ebeleg==RE-LB-BE333"
Then fields have values
    | artikel       | TE333      |
    | platz         | F1         |
    | lgruppe       | KARLSRUHE  |
    | mge           | 10         |
    | buart         | 1          |
    | buarta        | Zugang     |
    | ursache       | Rechnung   |
    | detursache    | Rechnung   |
    | mpr           | 12.0000    |
    | mpra          |  0.0000    |
    | epr           | 12.0000    |
And I close the current editor

# Abgang Teilmenge durch LBU
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | TE333     |
    | buart     | Abgang    |
    | beleg     | LBU_TE333 |
    | beldat    | .         |
And I delete all rows
And I append rows
    | mge    | platz    |
    | 2      | F1       |
And I save the current editor

# Bewertung vor der Mengenneubewertung
Given I open latest Valuation "BewertungZu1.1" for Product "TE333" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id    |
    | beistelldaten | nein              |
    | bewart        | Vorgangspreis     |
    | abbewart      | Preis des Zugangs |
    | stornoverur   |                   |
    | buart         | Zugang            |
    | ursache       | Rechnung          |
    | detursache    | Rechnung          |
    | mge           | 10                |
    | bewwert       | 120.00            |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id      | orig^id        | beworig^id     | vkpos   | datum              |
    | 10   | 12.0000 | 0.0000    | direkt    | !JournalZu1^vom  | !JournalZu1^id | !JournalZu1^id | !JournalZu1^id |         | !JournalZu1^stand  |
And I close the current editor

# Mengenneubewertung anlegen fuer den Restbestand auf dem Platz
Given I open an editor "mgeneubew-333" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "FALL-333"
And I set field "vorgang" to "$,,artikel=TE333;platz=F1;@datenbank=40;@gruppe=4;" in row 1
And I set field "ntbewpr" to "11,50" in row 1
And I save the current editor

# Vergleichswerte ausgeben, Mischpreis bleibt nach der Mengenneubewertung gleich (Bewertungspreis hat sich geaendert)
Given I query "artikel,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(ProductQuantity)" where "artikel==TE333"
Then query has values
    | artikel   | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE333     |   8     |  8          | 12.0000   | 12.0000   | 12.0000   |

Given I query "artikel,lgruppe,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(WarehouseGroupQuantity)" where "lgruppe==KARLSRUHE;artikel==TE333"
Then query has values
    | artikel   | lgruppe   | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE333     | KARLSRUHE |  8      |  8          | 12.0000   | 12.0000   | 12.0000   |

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE333;buarta==Zugang;platz==F1;ebeleg==RE-LB-BE333"
Then fields have values
    | artikel       | TE333      |
    | platz         | F1         |
    | lgruppe       | KARLSRUHE  |
    | mge           | 10         |
    | buart         | 1          |
    | buarta        | Zugang     |
    | ursache       | Rechnung   |
    | detursache    | Rechnung   |
    | mpr           | 12.0000    |
    | mpra          |  0.0000    |
    | epr           | 12.0000    |
And I close the current editor

# Bewertung nach der Mengenneubewertung
Given I open latest Valuation "BewertungZu1.2" for Product "TE333" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 10                    |
    | bewwert       | 116.00                |
    | vorgaenger^id | !BewertungZu1.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 2    | 12.0000 | 0.0000    | direkt    | !JournalZu1^vom  | !JournalZu1^id    | !JournalZu1^id | !JournalZu1^id |         | !JournalZu1^stand  |
    | 8    | 11.5000 | 0.0000    | direkt    | !JournalZu1^vom  | !mgeneubew-333^id | !JournalZu1^id | !JournalZu1^id |         | !JournalZu1^stand  |
And I close the current editor

# Komplettwertgutschrift erstellen, noch nicht buchen
Given I open an editor "WERT-ZU-BE333" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-ZU-BE333"
And I set fields
    | nummer | 1WERT333   |
    | such   | EKWERT333  |
    | ebeleg | EKWERT333  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -10   | 12.00     | -120.00   |
And I save the current editor

# Komplettwertgutschrift buchen - schlaegt fehl wegen Mengenneubewertung
Given I open an editor "WERT-ZU-BE333" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "WERT-ZU-BE333"
And I set fields
    | ueb    | ja       |
# 2792 de      |Gutzuschreibender Betrag zu hoch.
Then saving the current editor throws the exception "2792"
And I close the current editor

# Mengenneubewertung stornieren
Given I open an editor "mgeneubew-333s" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record from editor "mgeneubew-333"
And I set field "such" to "FALL-333S"
And I save the current editor

# Bewertung nach Stornierung der Mengenneubewertung
Given I open latest Valuation "BewertungZu1.3" for Product "TE333" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id      | !JournalZu1^id        |
    | beistelldaten  | nein                  |
    | bewart         | Vorgangspreis         |
    | abbewart       | Preis des Zugangs     |
    | stornoverur^id | !mgeneubew-333s^id    |
    | buart          | Zugang                |
    | ursache        | Rechnung              |
    | detursache     | Rechnung              |
    | mge            | 10                    |
    | bewwert        | 120.00                |
    | vorgaenger^id  | !BewertungZu1.2^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum              |
    | 10   | 12.0000 | 0.0000    | direkt    | !JournalZu1^vom  | !JournalZu1^id    | !JournalZu1^id | !JournalZu1^id |         | !JournalZu1^stand  |
And I close the current editor

# Komplettwertgutschrift buchen
Given I open an editor "WERT-ZU-BE333" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "WERT-ZU-BE333"
And I set fields
    | ueb    | ja       |
And I save the current editor

# Vergleichswerte nach Buchen der Wertgutschrift
Given I query "artikel,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(ProductQuantity)" where "artikel==TE333"
Then query has values
    | artikel   | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE333     |   8     |  8          | 12.0000   | 12.0000   | 12.0000   |

Given I query "artikel,lgruppe,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(WarehouseGroupQuantity)" where "lgruppe==KARLSRUHE;artikel==TE333"
Then query has values
    | artikel   | lgruppe   | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE333     | KARLSRUHE |   8     |  8          | 12.0000   | 12.0000   | 12.0000   |

Given I open an editor "JournalWG1.1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE333;buarta==Neubewertung;platz==F1;ebeleg==EKWERT333;mge==-10;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE333             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -10               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpr           | 12.0000           |
    | mpra          | 12.0000           |
    | epr           | 12.0000           |
And I close the current editor

# Bewertung nach der Wertgutschrift, Bewertungspreis geht zurueck auf Bestellpreis fuer die abgebuchte Menge
Given I open latest Valuation "BewertungWG1" for Product "TE333" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           |  10                   |
    | bewwert       |  110.00               |
    | vorgaenger^id | !BewertungZu1.3^id    |
Then table has values
    | tmge | tbewpr  | mnbpreisdiff | addkosten | bewertet  | tbudat           | kverur^id         | orig^id        | beworig^id     | vkpos   | datum                  |
    | 10   | 11.0000 | 0.0000       | 0.0000    | vorläufig | !JournalZu1^vom  | !JournalWG1.1^id  | !JournalZu1^id | !JournalZu1^id |         | !JournalWG1.1^stand    |
And I close the current editor


Scenario: 04 EK - Rechnung NEU mit Lagerbewegung, Komplettwertgutschrift

Given I open an editor "TE444" from table "(Part):(Product)" with command "STORE" for record "TE444"
And I set fields
    | such      | TE444                |
    | namebspr  | Schraube 444         |
    | vpr       | 15                   |
    | epr       | 10.50                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

# Rechnung mit Lagerbewegung, ohne Bestellung
Given I open an editor "RE-ZU-BE444" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | 001         |
    | nummer | 1EKRE444    |
    | ebeleg | RE-LB-BE444 |
    | such   | RE-BE444    |
    | ueb    | ja          |
    | vom    | .           |
    | tterm  | .           |
    | fakt   | ja          |
And I append rows
    | artikel | mge | preis |
    | TE444   |  10 | 11    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Vergleichswerte ausgeben vor der Wertgutschrift
Given I query "artikel,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(ProductQuantity)" where "artikel==TE444"
Then query has values
    | artikel   | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE444     |   10    |  10         | 11.0000   | 11.0000   | 11.0000   |

Given I query "artikel,lgruppe,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(WarehouseGroupQuantity)" where "lgruppe==KARLSRUHE;artikel==TE444"
Then query has values
    | artikel   | lgruppe   | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE444     | KARLSRUHE |  10     |  10         | 11.0000   | 11.0000   | 11.0000   |

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE444;buarta==Zugang;platz==F1;ebeleg==RE-LB-BE444"
Then fields have values
    | artikel       | TE444      |
    | platz         | F1         |
    | lgruppe       | KARLSRUHE  |
    | mge           | 10         |
    | buart         | 1          |
    | buarta        | Zugang     |
    | ursache       | Rechnung   |
    | detursache    | Rechnung   |
    | mpr           | 11.0000    |
    | mpra          |  0.0000    |
    | epr           | 11.0000    |
And I close the current editor

# Bewertung
Given I open latest Valuation "BewertungZu1" for Product "TE444" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id    |
    | beistelldaten | nein              |
    | bewart        | Vorgangspreis     |
    | abbewart      | Preis des Zugangs |
    | stornoverur   |                   |
    | buart         | Zugang            |
    | ursache       | Rechnung          |
    | detursache    | Rechnung          |
    | mge           | 10                |
    | bewwert       | 110.00            |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id        | orig^id        | beworig^id     | vkpos   | datum              |
    | 10   | 11.0000 | 0.0000    | direkt    | !JournalZu1^vom  | !JournalZu1^id   | !JournalZu1^id | !JournalZu1^id |         | !JournalZu1^stand  |
And I close the current editor

# Komplettwertgutschrift buchen
Given I open an editor "WERT-ZU-BE444" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-ZU-BE444"
And I set fields
    | nummer | 1WERT444   |
    | such   | EKWERT444  |
    | ebeleg | EKWERT444  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -10   | 11.00     | -110.00   |
And I save the current editor

# Vergleichswerte nach Buchen der Wertgutschrift
Given I query "artikel,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(ProductQuantity)" where "artikel==TE444"
Then query has values
    | artikel   | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE444     |   10    |  10         | 11.0000   | 11.0000   | 11.0000   |

Given I query "artikel,lgruppe,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(WarehouseGroupQuantity)" where "lgruppe==KARLSRUHE;artikel==TE444"
Then query has values
    | artikel   | lgruppe   | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE444     | KARLSRUHE |   10    |  10         | 11.0000   | 11.0000   | 11.0000   |

Given I open an editor "JournalWG1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE444;buarta==Neubewertung;platz==F1;ebeleg==EKWERT444;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE444             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -10               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpr           | 11.0000           |
    | mpra          | 11.0000           |
    | epr           | 11.0000           |
And I close the current editor

# Bewertungen, Bewertungspreis aendert sich auf 0 nach der Wertgutschrift, da kein Bestellpreis vorhanden ist
Given I open latest Valuation "BewertungWG1" for Product "TE444" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id    |
    | beistelldaten | nein              |
    | bewart        | Vorgangspreis     |
    | abbewart      | Preis des Zugangs |
    | stornoverur   |                   |
    | buart         | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mge           |  10               |
    | bewwert       |  0.00             |
    | vorgaenger^id | !BewertungZu1^id  |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet   | tbudat           | kverur^id        | orig^id        | beworig^id     | vkpos   | datum              |
    | 10   |  0.0000 | 0.0000    | unbewertet | !JournalZu1^vom  | !JournalWG1^id   | !JournalZu1^id | !JournalZu1^id |         | !JournalWG1^stand  |
And I close the current editor


# FDA-4496
Scenario: 19 EK - Rechnung mit Lagerbewegung - Bestellung, RE mit MZ, Komplett-WG, RE-Korrektur, Komplett-WG und RE-Storno

Given I open an editor "TE99" from table "(Part):(Product)" with command "STORE" for record "TE99"
And I set fields
    | such      | TE99                 |
    | namebspr  | Schraube 99          |
    | vpr       | 15                   |
    | epr       | 10.50                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

# Bestellung mit Preis 18,00
Given I open an editor "BE-19" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE99    |
    | such   | BE-99    |
    | ebeleg | BE-99    |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis |
    | TE99    | 100 | 18    |
And I save the current editor

# Rechnung mit Lagerbewegung und 3 MZ buchen, gesamte Menge und abweichender Preis 20,00
Given I open an editor "RE-ZU-BE99" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE99"
And I set fields
    | nummer | 1EKRE99    |
    | ebeleg | RE-LB-BE99 |
    | such   | RE-BE99    |
    | ueb    | ja         |
    | vom    | .          |
    | tterm  | .          |
    | fakt   | ja         |
And I set field "mge" to "100" in row 1
Then field "preis" has value "18.00" in row 1
And I set field "preis" to "20" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge |
    | F1     | 20     |
    | F2     | 30     |
    | F3     | 50     |
And I save the current editor
And I switch the current editor to editor "RE-ZU-BE99"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Vergleichswerte vor Buchen der Wertgutschrift
Given I query "artikel,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(ProductQuantity)" where "artikel==TE99"
Then query has values
    | artikel  | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE99     |   100   |  20         | 20.0000   | 20.0000   | 20.0000   |

Given I query "artikel,lgruppe,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(WarehouseGroupQuantity)" where "lgruppe==KARLSRUHE;artikel==TE99"
Then query has values
    | artikel  | lgruppe   | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE99     | KARLSRUHE |  100    |  20         | 20.0000   | 20.0000   | 20.0000   |

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE99;buarta==Zugang;platz==F1;ebeleg==RE-LB-BE99"
Then fields have values
    | artikel       | TE99       |
    | platz         | F1         |
    | lgruppe       | KARLSRUHE  |
    | mge           | 20         |
    | buart         | 1          |
    | buarta        | Zugang     |
    | ursache       | Rechnung   |
    | detursache    | Rechnung   |
    | mpr           | 20.0000    |
    | mpra          |  0.0000    |
    | epr           | 20.0000    |
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE99;buarta==Zugang;platz==F2;ebeleg==RE-LB-BE99"
Then fields have values
    | artikel       | TE99       |
    | platz         | F2         |
    | lgruppe       | KARLSRUHE  |
    | mge           | 30         |
    | buart         | 1          |
    | buarta        | Zugang     |
    | ursache       | Rechnung   |
    | detursache    | Rechnung   |
    | mpr           | 20.0000    |
    | mpra          | 20.0000    |
    | epr           | 20.0000    |
And I close the current editor

Given I open an editor "JournalZu3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE99;buarta==Zugang;platz==F3;ebeleg==RE-LB-BE99"
Then fields have values
    | artikel       | TE99       |
    | platz         | F3         |
    | lgruppe       | KARLSRUHE  |
    | mge           | 50         |
    | buart         | 1          |
    | buarta        | Zugang     |
    | ursache       | Rechnung   |
    | detursache    | Rechnung   |
    | mpr           | 20.0000    |
    | mpra          | 20.0000    |
    | epr           | 20.0000    |
And I close the current editor

# Bewertungen
Given I open latest Valuation "BewertungZu1.1" for Product "TE99" and valuation transaction "JournalZu1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu1^id    |
    | beistelldaten | nein              |
    | bewart        | Vorgangspreis     |
    | abbewart      | Preis des Zugangs |
    | stornoverur   |                   |
    | buart         | Zugang            |
    | ursache       | Rechnung          |
    | detursache    | Rechnung          |
    | mge           | 20                |
    | bewwert       | 400.00            |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id        | orig^id        | beworig^id     | vkpos   | datum              |
    | 20   | 20.0000 | 0.0000    | direkt    | !JournalZu1^vom  | !JournalZu1^id   | !JournalZu1^id | !JournalZu1^id |         | !JournalZu1^stand  |
And I close the current editor

Given I open latest Valuation "BewertungZu2.1" for Product "TE99" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id    |
    | beistelldaten | nein              |
    | bewart        | Vorgangspreis     |
    | abbewart      | Preis des Zugangs |
    | stornoverur   |                   |
    | buart         | Zugang            |
    | ursache       | Rechnung          |
    | detursache    | Rechnung          |
    | mge           | 30                |
    | bewwert       | 600.00            |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id        | orig^id        | beworig^id     | vkpos   | datum              |
    | 30   | 20.0000 | 0.0000    | direkt    | !JournalZu2^vom  | !JournalZu2^id   | !JournalZu2^id | !JournalZu2^id |         | !JournalZu2^stand  |
And I close the current editor

Given I open latest Valuation "BewertungZu3.1" for Product "TE99" and valuation transaction "JournalZu3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu3^id    |
    | beistelldaten | nein              |
    | bewart        | Vorgangspreis     |
    | abbewart      | Preis des Zugangs |
    | stornoverur   |                   |
    | buart         | Zugang            |
    | ursache       | Rechnung          |
    | detursache    | Rechnung          |
    | mge           | 50                |
    | bewwert       | 1000.00           |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id        | orig^id        | beworig^id     | vkpos   | datum              |
    | 50   | 20.0000 | 0.0000    | direkt    | !JournalZu3^vom  | !JournalZu3^id   | !JournalZu3^id | !JournalZu3^id |         | !JournalZu3^stand  |
And I close the current editor

# Komplettwertgutschrift buchen
Given I open an editor "WERT-ZU-BE99" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-ZU-BE99"
And I set fields
    | nummer | 1WERT99   |
    | such   | EKWERT99  |
    | ebeleg | EKWERT99  |
    | tterm  | .         |
    | budat  | .         |
    | vom    | .         |
    | ueb    | ja        |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -100  | 20.00     | -2000.00  |
And I save the current editor

# Vergleichswerte nach Buchen der Wertgutschrift
Given I query "artikel,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(ProductQuantity)" where "artikel==TE99"
Then query has values
    | artikel  | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE99     |   100   |  20         | 20.0000   | 20.0000   | 20.0000   |

Given I query "artikel,lgruppe,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(WarehouseGroupQuantity)" where "lgruppe==KARLSRUHE;artikel==TE99"
Then query has values
    | artikel  | lgruppe   | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE99     | KARLSRUHE |   100   |  20         | 20.0000   | 20.0000   | 20.0000   |

Given I open an editor "JournalWG1.1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE99;buarta==Neubewertung;platz==F1;ebeleg==EKWERT99;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE99              |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -20               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpr           | 20.0000           |
    | mpra          | 20.0000           |
    | epr           | 20.0000           |
And I close the current editor

Given I open an editor "JournalWG1.2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE99;buarta==Neubewertung;platz==F2;ebeleg==EKWERT99;@richtung=rückwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE99              |
    | platz         | F2                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -30               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpr           | 20.0000           |
    | mpra          | 20.0000           |
    | epr           | 20.0000           |
And I close the current editor

Given I open an editor "JournalWG1.3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE99;buarta==Neubewertung;platz==F3;ebeleg==EKWERT99;@richtung=rückwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE99              |
    | platz         | F3                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -50               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpr           | 20.0000           |
    | mpra          | 20.0000           |
    | epr           | 20.0000           |
And I close the current editor

# Bewertungen, Bewertungspreis aendert sich auf den Bestellpreis nach der Wertgutschrift
Given I open latest Valuation "BewertungZu1.2" for Product "TE99" and valuation transaction "JournalZu1" with command "VIEW"
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
    | bewwert       |  360.00               |
    | vorgaenger^id | !BewertungZu1.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id        | orig^id        | beworig^id     | vkpos   | datum               |
    | 20   | 18.0000 | 0.0000    | vorläufig | !JournalZu1^vom  | !JournalWG1.1^id | !JournalZu1^id | !JournalZu1^id |         | !JournalWG1.1^stand |
And I close the current editor

Given I open latest Valuation "BewertungZu2.2" for Product "TE99" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           |  30                   |
    | bewwert       |  540.00               |
    | vorgaenger^id | !BewertungZu2.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id        | orig^id        | beworig^id     | vkpos   | datum               |
    | 30   | 18.0000 | 0.0000    | vorläufig | !JournalZu2^vom  | !JournalWG1.2^id | !JournalZu2^id | !JournalZu2^id |         | !JournalWG1.2^stand |
And I close the current editor

Given I open latest Valuation "BewertungZu3.2" for Product "TE99" and valuation transaction "JournalZu3" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu3^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           |  50                   |
    | bewwert       |  900.00               |
    | vorgaenger^id | !BewertungZu3.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id        | orig^id        | beworig^id     | vkpos   | datum               |
    | 50   | 18.0000 | 0.0000    | vorläufig | !JournalZu3^vom  | !JournalWG1.3^id | !JournalZu3^id | !JournalZu3^id |         | !JournalWG1.3^stand |
And I close the current editor

# neue Rechnung nach Komplettwertgutschrift ist eine Rechnungskorrektur aus der 1. Rechnung
Given I open an editor "KORR-RE1-ZU-BE99" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-ZU-BE99"
And I set fields
    | nummer | 3KORR1           |
    | such   | EK1KORR99        |
    | ebeleg | KORR_RE1_BE99    |
    | tterm  | .                |
    | budat  | .                |
    | vom    | .                |
    | ueb    | ja               |
And I press button "burekorrektur"
And I set field "mge" to "30" in row 1
Then field "preis" has value "20.00" in row 1
And I save the current editor

Given I open an editor "JournalKORR1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE99;mge==30;buarta==Neubewertung;platz==F1;ebeleg==KORR_RE1_BE99"
Then fields have values
    | artikel       | TE99                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 30                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | epr           | 20.0000               |
And I close the current editor

Given I open latest Valuation "BewertungZu1.3" for Product "TE99" and valuation transaction "JournalZu1" with command "VIEW"
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
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id        | orig^id        | beworig^id     | vkpos   | datum              |
    | 20   | 20.0000 | 0.0000    | direkt    | !JournalKORR1^vom  | !JournalKORR1^id   | !JournalZu1^id | !JournalZu1^id |         | !JournalKORR1^stand  |
And I close the current editor

Given I open latest Valuation "BewertungZu2.3" for Product "TE99" and valuation transaction "JournalZu2" with command "VIEW"
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
    | bewwert       | 560.00                |
    | vorgaenger^id | !BewertungZu2.2^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id        | orig^id        | beworig^id     | vkpos   | datum               |
    | 10   | 20.0000 | 0.0000    | direkt    | !JournalKORR1^vom  | !JournalKORR1^id   | !JournalZu2^id | !JournalZu2^id |         | !JournalKORR1^stand   |
    | 20   | 18.0000 | 0.0000    | vorläufig | !JournalZu2^vom  | !JournalWG1.2^id | !JournalZu2^id | !JournalZu2^id |         | !JournalWG1.2^stand |
And I close the current editor

# hat keinen weiteren Nachfolger, ist identisch mit BewertungZu3.2
Given I open latest Valuation "BewertungZu3.3" for Product "TE99" and valuation transaction "JournalZu3" with command "VIEW"
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
    | bewwert       | 900.00                |
    | vorgaenger^id | !BewertungZu3.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id        | orig^id        | beworig^id     | vkpos   | datum               |
    | 50   | 18.0000 | 0.0000    | vorläufig | !JournalZu3^vom  | !JournalWG1.3^id | !JournalZu3^id | !JournalZu3^id |         | !JournalWG1.3^stand |
And I close the current editor

# 3. Rechnung ist Korrekturrechnung 2
Given I open an editor "KORR2-RE1-ZU-BE99" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-ZU-BE99"
And I set fields
    | nummer | 3KORR2           |
    | such   | EK1KORR2         |
    | ebeleg | KORR2_RE1_BE99   |
    | tterm  | .                |
    | budat  | .                |
    | vom    | .                |
    | ueb    | ja               |
And I press button "burekorrektur"
And I set field "mge" to "30" in row 1
Then field "preis" has value "20.00" in row 1
And I save the current editor

Given I open an editor "JournalKORR2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE99;mge==30;buarta==Neubewertung;platz==F1;ebeleg==KORR2_RE1_BE99"
Then fields have values
    | artikel       | TE99                  |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 30                    |
    | buart         | 6                     |
    | buarta        | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | epr           | 20.0000               |
And I close the current editor

# Bewertung bekommt keinen neuen Nachfolger, bleibt wie 1.3
Given I open latest Valuation "BewertungZu1.4" for Product "TE99" and valuation transaction "JournalZu1" with command "VIEW"
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
    | tmge | tbewpr  | addkosten | bewertet  | tbudat             | kverur^id        | orig^id        | beworig^id     | vkpos   | datum               |
    | 20   | 20.0000 | 0.0000    | direkt    | !JournalKORR1^vom  | !JournalKORR1^id | !JournalZu1^id | !JournalZu1^id |         | !JournalKORR1^stand |
And I close the current editor

Given I open latest Valuation "BewertungZu2.4" for Product "TE99" and valuation transaction "JournalZu2" with command "VIEW"
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
    | bewwert       | 600.00                |
    | vorgaenger^id | !BewertungZu2.3^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat            | kverur^id        | orig^id        | beworig^id     | vkpos   | datum               |
    | 20   | 20.0000 | 0.0000    | direkt    | !JournalKORR2^vom | !JournalKORR2^id | !JournalZu2^id | !JournalZu2^id |         | !JournalKORR2^stand |
    | 10   | 20.0000 | 0.0000    | direkt    | !JournalKORR1^vom | !JournalKORR1^id | !JournalZu2^id | !JournalZu2^id |         | !JournalKORR1^stand |
And I close the current editor

Given I open latest Valuation "BewertungZu3.4" for Product "TE99" and valuation transaction "JournalZu3" with command "VIEW"
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
    | bewwert       | 920.00                |
    | vorgaenger^id | !BewertungZu3.3^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat            | kverur^id        | orig^id        | beworig^id     | vkpos   | datum               |
    | 10   | 20.0000 | 0.0000    | direkt    | !JournalKORR2^vom | !JournalKORR2^id | !JournalZu3^id | !JournalZu3^id |         | !JournalKORR2^stand |
    | 40   | 18.0000 | 0.0000    | vorläufig | !JournalZu3^vom   | !JournalWG1.3^id | !JournalZu3^id | !JournalZu3^id |         | !JournalWG1.3^stand |
And I close the current editor

# Komplettwertgutschrift zu RE 2 (KORR1) buchen
Given I open an editor "WERT-ZU-BE99" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "KORR-RE1-ZU-BE99"
And I set fields
    | nummer | 1WERT299  |
    | such   | EKWERT299 |
    | ebeleg | EKWERT299 |
    | tterm  | .         |
    | budat  | .         |
    | vom    | .         |
    | ueb    | ja        |
Then the table has 4 rows
And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert    |
    | -30   | 20.00     | -600.00  |
And I save the current editor

# Vergleichswerte nach Buchen der Wertgutschrift
Given I query "artikel,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(ProductQuantity)" where "artikel==TE99"
Then query has values
    | artikel  | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE99     |   100   |  20         | 20.0000   | 20.0000   | 20.0000   |

Given I query "artikel,lgruppe,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(WarehouseGroupQuantity)" where "lgruppe==KARLSRUHE;artikel==TE99"
Then query has values
    | artikel  | lgruppe   | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE99     | KARLSRUHE |   100   |  20         | 20.0000   | 20.0000   | 20.0000   |

Given I open an editor "JournalWGRE2.1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE99;buarta==Neubewertung;platz==F1;mge=-20;ebeleg==EKWERT299;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE99              |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -20               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpr           | 20.0000           |
    | mpra          | 20.0000           |
    | epr           | 20.0000           |
And I close the current editor

Given I open an editor "JournalWGRE2.2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE99;buarta==Neubewertung;platz==F2;mge=-10;ebeleg==EKWERT299;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE99              |
    | platz         | F2                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -10               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | mpr           | 20.0000           |
    | mpra          | 20.0000           |
    | epr           | 20.0000           |
And I close the current editor

# Bewertungen, Bewertungspreis aendert sich auf den Bestellpreis nach der Wertgutschrift
Given I open latest Valuation "BewertungZu1.5" for Product "TE99" and valuation transaction "JournalZu1" with command "VIEW"
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
    | bewwert       |  360.00               |
    | vorgaenger^id | !BewertungZu1.4^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id          | orig^id        | beworig^id     | vkpos   | datum                 |
    | 20   | 18.0000 | 0.0000    | vorläufig | !JournalZu1^vom  | !JournalWGRE2.1^id | !JournalZu1^id | !JournalZu1^id |         | !JournalWGRE2.1^stand |
And I close the current editor

Given I open latest Valuation "BewertungZu2.5" for Product "TE99" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           |  30                   |
    | bewwert       |  580.00               |
    | vorgaenger^id | !BewertungZu2.4^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat            | kverur^id          | orig^id        | beworig^id     | vkpos   | datum                 |
    | 20   | 20.0000 | 0.0000    | direkt    | !JournalKORR2^vom | !JournalKORR2^id   | !JournalZu2^id | !JournalZu2^id |         | !JournalKORR2^stand   |
    | 10   | 18.0000 | 0.0000    | vorläufig | !JournalZu2^vom   | !JournalWGRE2.2^id | !JournalZu2^id | !JournalZu2^id |         | !JournalWGRE2.2^stand |
And I close the current editor

# kein weiterer Nachfolger, bleibt wie 3.4
Given I open latest Valuation "BewertungZu3.5" for Product "TE99" and valuation transaction "JournalZu3" with command "VIEW"
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
    | bewwert       | 920.00                |
    | vorgaenger^id | !BewertungZu3.3^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat            | kverur^id        | orig^id        | beworig^id     | vkpos   | datum               |
    | 10   | 20.0000 | 0.0000    | direkt    | !JournalKORR2^vom | !JournalKORR2^id | !JournalZu3^id | !JournalZu3^id |         | !JournalKORR2^stand |
    | 40   | 18.0000 | 0.0000    | vorläufig | !JournalZu3^vom   | !JournalWG1.3^id | !JournalZu3^id | !JournalZu3^id |         | !JournalWG1.3^stand |
And I close the current editor

# Storno RE 3 (Korrekturrechnung 2)
Given I open an editor "STORNO-RE3" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KORR2-RE1-ZU-BE99"
And I save the current editor

# Journaleintrag zum Storno
Given I open an editor "JournalRE3Storno" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE99;mge==-30;buarta==Neubewertung;platz==F1;ebeleg==KORR2_RE1_BE99"
And I close the current editor

# Bewertung nach Storno der Rechnung 3, bleibt wie bei 1.5
Given I open latest Valuation "BewertungZu1.6" for Product "TE99" and valuation transaction "JournalZu1" with command "VIEW"
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
    | bewwert       |  360.00               |
    | vorgaenger^id | !BewertungZu1.4^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id          | orig^id        | beworig^id     | vkpos   | datum                 |
    | 20   | 18.0000 | 0.0000    | vorläufig | !JournalZu1^vom  | !JournalWGRE2.1^id | !JournalZu1^id | !JournalZu1^id |         | !JournalWGRE2.1^stand |
And I close the current editor

# 10 Stk. wie bei 2.5 und 20 Stk. wie bei 2.3
Given I open latest Valuation "BewertungZu2.6" for Product "TE99" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalZu2^id            |
    | beistelldaten     | nein                      |
    | bewart            | Vorgangspreis             |
    | abbewart          | Preis des Zugangs         |
    | stornoverur^id    | !JournalRE3Storno^id      |
    | buart             | Neubewertung              |
    | ursache           | Rechnung                  |
    | detursache        | Storno-Rechnung Einkauf   |
    | mge               | 30                        |
    | bewwert           | 540.00                    |
    | vorgaenger^id     | !BewertungZu2.5^id        |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id          | orig^id        | beworig^id     | vkpos   | datum                 |
    | 10   | 18.0000 | 0.0000    | vorläufig | !JournalZu2^vom  | !JournalWGRE2.2^id | !JournalZu2^id | !JournalZu2^id |         | !JournalWGRE2.2^stand |
    | 20   | 18.0000 | 0.0000    | vorläufig | !JournalZu2^vom  | !JournalWG1.2^id   | !JournalZu2^id | !JournalZu2^id |         | !JournalWG1.2^stand   |
And I close the current editor

# 10 Stk und 40 Stk wie bei 3.2
Given I open latest Valuation "BewertungZu3.6" for Product "TE99" and valuation transaction "JournalZu3" with command "VIEW"
Then fields have values
    | ppsref^id         | !JournalZu3^id            |
    | beistelldaten     | nein                      |
    | bewart            | Vorgangspreis             |
    | abbewart          | Preis des Zugangs         |
    | stornoverur^id    | !JournalRE3Storno^id      |
    | buart             | Neubewertung              |
    | ursache           | Rechnung                  |
    | detursache        | Storno-Rechnung Einkauf   |
    | mge               |  50                       |
    | bewwert           |  900.00                   |
    | vorgaenger^id     | !BewertungZu3.5^id        |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id        | orig^id        | beworig^id     | vkpos   | datum               |
    | 50   | 18.0000 | 0.0000    | vorläufig | !JournalZu3^vom  | !JournalWG1.3^id | !JournalZu3^id | !JournalZu3^id |         | !JournalWG1.3^stand |
And I close the current editor


Scenario: 21 EK - Bestellung, Rechnungen mit Lagerbewegung und 2 MZ, Teilwertgutschriften

Given I open an editor "TE101" from table "(Part):(Product)" with command "STORE" for record "TE101"
And I set fields
    | such      | TE101                |
    | namebspr  | Schraube 101         |
    | vpr       | 15                   |
    | epr       | 75.00                |
    | bsart     | Fremdbeschaffung     |
    | dispoa    | auftragsbezogen      |
    | ekbewverf | 1                    |
And I save the current editor

Given I open an editor "BE-101" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE101   |
    | such   | BE-101   |
    | ebeleg | BE-101   |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis |
    | TE101   | 100 | 80    |
And I save the current editor

# Rechnung mit Lagerbewegung und 2 MZ buchen
Given I open an editor "RE1-ZU-BE101" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE101"
And I set fields
   | nummer | 1EKRE101  |
   | ebeleg | RE1-BE101 |
   | such   | RE1-BE101 |
   | fakt   | ja        |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "100" in row 1
Then field "preis" has value "80.00" in row 1
And I set field "preis" to "88" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge |
    | F1     | 40     |
    | F2     | 60     |
And I save the current editor
And I switch the current editor to editor "RE1-ZU-BE101"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journal zur Rechnung MZ 1
Given I open an editor "JournalRE1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE101;buarta==Zugang;platz==F1;ebeleg==RE1-BE101"
Then fields have values
    | artikel       | TE101                 |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 40                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 88.0000               |
    | mpra          | 0.0000                |
    | epr           | 88.0000               |
And I close the current editor

# Journal zur Rechnung MZ 2
Given I open an editor "JournalRE2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE101;buarta==Zugang;platz==F2;ebeleg==RE1-BE101"
Then fields have values
    | artikel       | TE101                 |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 60                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mpr           | 88.0000               |
    | mpra          | 88.0000               |
    | epr           | 88.0000               |
And I close the current editor

# Bewertungen zur Rechnung MZ 1
Given I open latest Valuation "BewertungZu1.1" for Product "TE101" and valuation transaction "JournalRE1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalRE1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 40                    |
    | bewwert       | 3520.00               |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   | datum              |
    | 40   | 88.0000 | 0.0000    | direkt    | !JournalRE1^vom  | !JournalRE1^id  | !JournalRE1^id | !JournalRE1^id |         | !JournalRE1^stand  |
And I close the current editor

# Bewertungen zur Rechnung MZ 2
Given I open latest Valuation "BewertungZu2.1" for Product "TE101" and valuation transaction "JournalRE2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalRE2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
    | mge           | 60                    |
    | bewwert       | 5280.00               |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id       | orig^id        | beworig^id     | vkpos   | datum              |
    | 60   | 88.0000 | 0.0000    | direkt    | !JournalRE2^vom  | !JournalRE2^id  | !JournalRE2^id | !JournalRE2^id |         | !JournalRE2^stand  |
And I close the current editor

# Teilwertgutschrift zu Rechnung 1 buchen, Teilmenge, reduzierter Preis, es wird die gesamte Rechnungsmenge pauschalisiert reduziert
Given I open an editor "WERT-RE1-BE101" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE101"
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
    | 1     | -10   | 10.00     |
And I save the current editor

Given I open an editor "JournalWG1.F1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE101;buarta==Neubewertung;platz==F1;ebeleg==EK1TEILWG1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE101             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -40               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 1.0000            |
And I close the current editor

Given I open an editor "JournalWG1.F2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE101;buarta==Neubewertung;platz==F2;ebeleg==EK1TEILWG1;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE101             |
    | platz         | F2                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -60               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 1.0000            |
And I close the current editor

Given I open latest Valuation "BewertungZu1.2" for Product "TE101" and valuation transaction "JournalRE1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalRE1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 40                    |
    | bewwert       | 3480.00               |
    | vorgaenger^id | !BewertungZu1.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat                | kverur^id          | orig^id        | beworig^id     | vkpos   | datum                  |
    | 40   | 87.0000 | 0.0000    | direkt    | !JournalWG1.F1^vom    | !JournalWG1.F1^id  | !JournalRE1^id | !JournalRE1^id |         | !JournalWG1.F1^stand   |
And I close the current editor

Given I open latest Valuation "BewertungZu2.2" for Product "TE101" and valuation transaction "JournalRE2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalRE2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 60                    |
    | bewwert       | 5220.00               |
    | vorgaenger^id | !BewertungZu2.1^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat                | kverur^id          | orig^id        | beworig^id     | vkpos   | datum                  |
    | 60   | 87.0000 | 0.0000    | direkt    | !JournalWG1.F2^vom    | !JournalWG1.F2^id  | !JournalRE2^id | !JournalRE2^id |         | !JournalWG1.F2^stand   |
And I close the current editor

# 2. Teilwertgutschrift zu Rechnung 1 buchen, ganze Menge, reduzierter (restlicher) Preis
Given I open an editor "WERT2-RE1-BE101" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE101"
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
    | 1     | -100  | 87.00     |
And I save the current editor

Given I open an editor "JournalWG2.F1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE101;buarta==Neubewertung;platz==F1;ebeleg==EKTEILWG2;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE101             |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -40               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 87.0000           |
And I close the current editor

Given I open an editor "JournalWG2.F2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==TE101;buarta==Neubewertung;platz==F2;ebeleg==EKTEILWG2;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | TE101             |
    | platz         | F2                |
    | lgruppe       | KARLSRUHE         |
    | mge           | -60               |
    | buart         | 6                 |
    | buarta        | Neubewertung      |
    | ursache       | Rechnung          |
    | detursache    | Wertgutschrift    |
    | epr           | 87.0000           |
And I close the current editor

Given I open latest Valuation "BewertungZu1.3" for Product "TE101" and valuation transaction "JournalRE1" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalRE1^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 40                    |
    | bewwert       | 0.00                  |
    | vorgaenger^id | !BewertungZu1.2^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat              | kverur^id            | orig^id        | beworig^id     | vkpos   | datum                  |
    | 40   | 0.0000  | 0.0000    | direkt    | !JournalWG2.F1^vom  | !JournalWG2.F1^id    | !JournalRE1^id | !JournalRE1^id |         | !JournalWG2.F1^stand   |
And I close the current editor

Given I open latest Valuation "BewertungZu2.3" for Product "TE101" and valuation transaction "JournalRE2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalRE2^id        |
    | beistelldaten | nein                  |
    | bewart        | Vorgangspreis         |
    | abbewart      | Preis des Zugangs     |
    | stornoverur   |                       |
    | buart         | Neubewertung          |
    | ursache       | Rechnung              |
    | detursache    | Wertgutschrift        |
    | mge           | 60                    |
    | bewwert       | 0.00                  |
    | vorgaenger^id | !BewertungZu2.2^id    |
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat                | kverur^id          | orig^id        | beworig^id     | vkpos   | datum                  |
    | 60   | 0.0000  | 0.0000    | direkt    | !JournalWG2.F2^vom    | !JournalWG2.F2^id  | !JournalRE2^id | !JournalRE2^id |         | !JournalWG2.F2^stand   |
And I close the current editor
