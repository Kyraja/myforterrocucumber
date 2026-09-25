# verantwortlich: uo
# teile aus wertgutschrift_mz.feature kopiert 

@persistent
Feature: Test von std/tbin/aufsteigendes_sysdat_in_cucumber.pl
Background:
Given I set the fake date to "25.12.1995"

Scenario: Stammdaten

# diese und andere kommentarzeilen davon bleibt derzeit noch erhalten...
Then opening an editor from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,blabal-bedingung1" 
# Projektkostenrechnung einschalten
Given I open an editor "config" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "projekt" to "ja"
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
   | fvhe      | 2                |
   | vhe       | kg               |
And I save the current editor

Given I open an editor "TK100" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set fields
   | such   | TK100             |
   | zptyp  | neutrale Position |
   | name   | Transportkosten   |
   | epr    | 100               |
And I save the current editor


# diese und andere kommentarzeilen davon bleibt derzeit noch erhalten...
Then opening an editor from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel==TE141;buart==Neubewertung;beistelldaten==ja;@richtung=vorwärts;@maxordtreffer=1" throws the exception "149"


Scenario: 01 Rechnung mit Lagerbewegung und 2 MZ, Komplettwertgutschrift

# diese und andere kommentarzeilen davon bleibt derzeit noch erhalten...
Then opening an editor from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,blabal-bedingung1" 
Given I open an editor "TE111" from table "(Part):(Product)" with command "STORE" for record "TE111"
And I set fields
    | such     | TE111                |
    | namebspr | Schraube 111         |
    | vpr      | 15                   |
    | epr      | 10.50                |
    | bsart    | Fremdbeschaffung     |
    | dispoa   | auftragsbezogen      |
And I save the current editor

# Bestellung 10 Stueck, Preis 11,00
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

# Rechnung mit Lagerbewegung und 2 MZ buchen, Menge 10 und Preis 10,00
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
Then saving the current editor throws the exception "112"
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
    | abbewart      | Mischpreis        |
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


# diese und andere kommentarzeilen davon bleibt derzeit noch erhalten...
Then opening an editor from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,blabal-bedingung1" 
Given I open latest Valuation "BewertungZu2" for Product "TE111" and valuation transaction "JournalZu2" with command "VIEW"
Then fields have values
    | ppsref^id     | !JournalZu2^id    |
    | beistelldaten | nein              |
    | bewart        | Vorgangspreis     |
    | abbewart      | Mischpreis        |
    | stornoverur   |                   |
    | buart         | Zugang            |
    | ursache       | Rechnung          |
    | detursache    | Rechnung          |
    | mge           | 3                 |
    | bewwert       | 30.00             |
Then saving the current editor throws the exception "114"
Then table has values
    | tmge | tbewpr  | addkosten | bewertet  | tbudat           | kverur^id        | orig^id        | beworig^id     | vkpos   | datum              |
    | 3    | 10.0000 | 0.0000    | direkt    | !JournalZu2^vom  | !JournalZu2^id   | !JournalZu2^id | !JournalZu2^id |         | !JournalZu2^stand  |
Then saving the current editor throws the exception "115"
And I close the current editor
# diese und andere kommentarzeilen davon bleibt derzeit noch erhalten...
Then opening an editor from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,blabal-bedingung1" 


# Komplettwertgutschrift erstellen und buchen
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

# dummy nur zum testen von skript aufsteigendes_sysdat_in_cucumber.pl!  passt inhaltlich nicht hierher.
Then saving the current editor throws the exception "113"
Then field "mpr" has value "50.0000"
Then field "mpra" has value "0.0000"
Then field "epr" has value "10.0000"

And I press button "komplettieren"
Then table has values
    | mge   | preis     | pwert     |
    | -10   | 10.00     | -100.00   |
And I save the current editor
Then opening an editor from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,blabal-bedingung1" 

# Vergleichswerte nach Buchen der Wertgutschrift
Given I query "artikel,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(ProductQuantity)" where "artikel==TE111"
Then query has values
    | artikel   | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE111     |   10    |  7          | 10.0000   | 10.0000   | 10.0000   |
Then opening an editor from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,blabal-bedingung1"
Then saving the current editor throws the exception "111"

# diese und andere kommentarzeilen davon bleibt derzeit noch erhalten...
Then opening an editor from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,blabal-bedingung1" 
Given I query "artikel,lgruppe,bestand,dbestand,mrpr,lpr,mpr" from table "(StorageQuantity):(WarehouseGroupQuantity)" where "lgruppe==KARLSRUHE;artikel==TE111"
Then query has values
    | artikel   | lgruppe   | bestand | dbestand    | mrpr      | lpr       | mpr       |
    | TE111     | KARLSRUHE |   10    |  7          | 10.0000   | 10.0000   | 10.0000   |
Then saving the current editor throws the exception "111"
Then opening an editor from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,blabal-bedingung1"
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
Then opening an editor from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,blabal-bedingung1"
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
Then opening an editor from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,blabal-bedingung1"


Scenario: Exceptions

Given I set the fake date to "23.7.1996"
Given I open an editor "WERT-ZU-RE76" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE76"

Then saving the current editor throws the exception "111"
And I set fields
    | nummer | 1WGS76 |
    | such   | WGS76  |
    | ueb    | ja     |
    | vom    | -1     |
    | budat  | -1     |
    | ophist |        |
And I press button "komplettieren"
Then saving the current editor throws the exception "3268"
And I set field "vom" to "."
Then saving the current editor throws the exception "3238"
Then saving the current editor throws the exception "345"

And I set field "budat" to "."
Then saving the current editor throws the exception "345"

And I save the current editor

#kommentarzeile..
#Then saving the current editor throws the exception "345"

Then opening an editor from table "(Valuation):(Valuation)" with command "UPDATE" for search criteria "$,,artikel==TE141;buart==Neubewertung;beistelldaten==ja;@richtung=vorwärts;@maxordtreffer=1" throws the exception "149"
