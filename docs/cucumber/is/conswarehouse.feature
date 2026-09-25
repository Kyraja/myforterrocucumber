@persistent
Feature: Infosystem CONSWAREHOUSE - Analyse von Umbuchungen auf Konsignationslagerplätzen

Scenario: STAMMDATEN - Neuen Lieferanten anlegen
Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "STORE" for record "REUS"
And I set field "such" to "REUS"
And I set field "namebspr" to "Reus Werkzeugbau, Rastatt"
And I set field "ans" to "Reus Werkzeugbau GmbH"
And I set field "str" to "Riedstr. 24-28"
And I set field "plz" to "76437"
And I set field "nort" to "Rastatt"
And I set field "tele" to "+49 (0) 7222/9456-0"
And I set field "email" to "info@bayram-corp.de"
And I set field "betreuer" to "."
And I set field "ans2" to "Reus Fussball GmbH"
And I set field "str2" to "Bvbstr. 24-28"
And I set field "plz2" to "33333"
And I set field "nort2" to "Dortmund"
And I set field "ustid" to "DE56454651"
And I set field "lbed" to "EXW"
And I set field "zbed" to "201"
And I save the current editor 

Scenario: STAMMDATEN - Neuen Kunden anlegen UNSERE FIRMA
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "Wir"
And I set field "such" to "Wir"
And I set field "namebspr" to "Unsere Firma"
And I set field "ans" to "Unsere Firma"
And I set field "str" to "Musterweg"
And I set field "plz" to "71263"
And I set field "nort" to "Weil der Stadt"
And I set field "staat" to "Deutschland"
And I set field "tele" to "+49 (0) 7222/9456-0"
And I set field "email" to "info@unserefirma.de"
And I set field "betreuer" to "."
And I set field "lbed" to "EXW"
And I set field "zbed" to "201"
And I set field "ustid" to "ES123456"
And I save the current editor 

Scenario: STAMMDATEN - Neuen Kunden anlegen BOSCH SPANIEN
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "Bosch"
And I set field "such" to "Bosch"
And I set field "namebspr" to "Bosch, Spanien"
And I set field "ans" to "Bosch Spanien GmbH"
And I set field "str" to "Estrada el Timon"
And I set field "plz" to "32651"
And I set field "nort" to "Barcelona"
And I set field "staat" to "Spanien"
And I set field "tele" to "+49 (0) 7222/9456-0"
And I set field "email" to "info@bosch.es"
And I set field "betreuer" to "."
And I set field "lbed" to "EXW"
And I set field "zbed" to "201"
And I set field "ustid" to "ES123456"
And I save the current editor 

Scenario: STAMMDATEN - Neuen Kunden anlegen Mercedes Italien
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "Daimler"
And I set field "such" to "Daimler"
And I set field "namebspr" to "Daimler, Italien"
And I set field "ans" to "Daimler Italien AG"
And I set field "str" to "Palazzo de Mercedes"
And I set field "plz" to "51261"
And I set field "nort" to "Rom"
And I set field "staat" to "Italien"
And I set field "tele" to "+49 (0) 7222/9456-0"
And I set field "email" to "info@daimler.it"
And I set field "betreuer" to "."
And I set field "lbed" to "EXW"
And I set field "zbed" to "201"
And I set field "ustid" to "IT987645"
And I save the current editor

Scenario: STAMMDATEN - Neuen Kunden anlegen Volkswagen
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "Vw"
And I set field "such" to "Vw"
And I set field "namebspr" to "Volkswagen, Frankreich"
And I set field "ans" to "Volkswagen AG Frankreich"
And I set field "str" to "Avenue de Paris"
And I set field "plz" to "44444"
And I set field "nort" to "Marseille"
And I set field "staat" to "Frankreich"
And I set field "tele" to "+49 (0) 7222/9456-0"
And I set field "email" to "info@vw.fr"
And I set field "betreuer" to "."
And I set field "lbed" to "EXW"
And I set field "zbed" to "201"
And I set field "ustid" to "FR666666"
And I save the current editor

Scenario: STAMMDATEN - Neuen Kunden anlegen Tesla im Ausland also nicht EU
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "Tesla"
And I set field "such" to "Tesla"
And I set field "namebspr" to "Tesla, USA"
And I set field "ans" to "Tesla Inc. USA"
And I set field "str" to "Tesla Parc 1"
And I set field "plz" to "12345"
And I set field "nort" to "Washington"
And I set field "staat" to "USA"
And I set field "tele" to "+01 (0) 7222/9456-0"
And I set field "email" to "info@tesla.us"
And I set field "betreuer" to "."
And I set field "lbed" to "EXW"
And I set field "zbed" to "201"
And I set field "ustid" to "ES47235"
And I save the current editor

Scenario: STAMMDATEN - Lagergruppe Bosch Spanien

Given I open an editor "Bosch_LG" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "Bosch"
And I set field "such" to "Bosch"
And I set field "namebspr" to "Bosch Spanien"
And I set field "konsilager" to "ja"
And I set field "geschaeftspartner" to "Bosch"
And I save the current editor

Scenario: STAMMDATEN - Lagergruppe Daimler Italien

Given I open an editor "Daimler_LG" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "Daimler"
And I set field "such" to "Daimler"
And I set field "namebspr" to "Daimler Italien"
And I set field "konsilager" to "ja"
And I set field "geschaeftspartner" to "DAIMLER"
And I save the current editor

Scenario: STAMMDATEN - Lagergruppe VW Frankreich

Given I open an editor "Volkswagen_LG" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "Vw"
And I set field "such" to "Vw"
And I set field "namebspr" to "VW Frankreich"
And I set field "konsilager" to "nein"
And I save the current editor

Scenario: STAMMDATEN - Lagergruppe Tesla USA

Given I open an editor "Tesla_LG" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "Tesla"
And I set field "such" to "Tesla"
And I set field "namebspr" to "Tesla USA"
And I set field "konsilager" to "ja"
And I set field "geschaeftspartner" to "Tesla"
And I save the current editor


Scenario Outline: STAMMDATEN - Lager
Given I open an editor "<lager>" from table "(Warehouse):(Warehouse)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "lgruppe" to id from editor "<lgruppe>"
And I save the current editor

Examples: Lager
| lager           | such    | namebspr           | lgruppe          |
| BOSCH_LA        | Bosch   | Bosch Spanien      | Bosch_LG         |
| DAIMLER_LA      | DAIMLER | Daimler Itailien   | Daimler_LG       |
| VOLKSWAGEN_LA   | VW      | VW Frankreich      | Volkswagen_LG    |
| TESLA_LA        | TESLA   | Tesla USA          | Tesla_LG         |

Scenario Outline: STAMMDATEN - Lagerplatz
Given I open an editor "<lagerplatz>" from table "(Location):(Location)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "lager" to id from editor "<lager>"
And I save the current editor

Examples: Lagerplatz
| lagerplatz      | such   | namebspr            | lager           |
| BOSCH           | BOSCH  | Bosch Spanien       | BOSCH_LA        | 
| DAIMLER         | DAIMLER| Daimler Italien     | DAIMLER_LA      | 
| VW              | VW     | VW Frankreich       | VOLKSWAGEN_LA   |
| TESLA           | TESLA  | Tesla USA           | TESLA_LA        |


Scenario Outline: STAMMDATEN - Zwei neue Artikel anlegen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "vkbez" to "<vkbez>"
And I set field "vbez" to "<vbez>"
And I set field "ebez" to "<ebez>"
And I set field "vpr" to "<vpr>"
And I set field "bsart" to "<bsart>"
And I set field "dispoa" to "<dispoa>"
And I set field "lief" to "<lief>"
And I set field "epr" to "<epr>"
And I set field "efrist" to "<efrist>"
And I save the current editor 

Examples: Artikel
| such            | namebspr     | vkbez     | vbez       | ebez      | vpr    | bsart             | dispoa          | lief | epr  | efrist   |
| UMLAG           | Umlagern     | Umlagern  | Umlagern   | Umlagern  | 10000  | Fremdbeschaffung  | bedarfsbezogen  | reus | 9000 | 15       | 

Scenario: CONSWAREHOUSE prüfen
Given I open the infosystem "CONSWAREHOUSE"
And I press start
Then the table has 0 rows
And I close the current editor

Scenario: Lagerbuchung Zugang auf Konsilagerplatz - Tatbestand 1
Given I open an editor "LBuchung" for tip command "Lbuchung" and arguments ""
And I set fields
      | artikel     | UMLAG   |
      | beleg       | T1         |
      | beldat      | .           |
      | buart       | Umbuchung   |
And I modify table
      | !row  | mge   | platz | platz2  |
      | +1    | 1     | F1    | BOSCH   | 
And I save the current editor

Given I open the infosystem "CONSWAREHOUSE"
And I press start
Then the table has 1 rows
Then table has values
 |tartikel|tmge|tbuarta|tplatz| ttatbestand|  tdetursache          | tlaart  |tlandkuerzel|tustid  |
 |UMLAG   |1   |Zugang |BOSCH | 1          | Manuelle Umbuchung    | EU-Staat| ES         |ES123456|
Then field "tlj" is not empty in row 1
And I close the current editor

Scenario: Lagerbuchung Abgang von Konsilagerplatz - Tatbestand 2
Given I open an editor "LBuchung" for tip command "Lbuchung" and arguments ""
And I set fields
      | artikel     | UMLAG       |
      | beleg       | T2          |
      | beldat      | .           |
      | buart       | Umbuchung   |
And I modify table
      | !row  | mge   | platz | platz2  |
      | +1    | 1     | BOSCH | F1      | 
And I save the current editor

Given I open the infosystem "CONSWAREHOUSE"
And I press start
Then the table has 2 rows
Then table has values
 |tartikel|tmge|tbuarta|tplatz| ttatbestand|  tdetursache         |tlaart   |tlandkuerzel|tustid  |
 |UMLAG  |1   |Zugang |BOSCH | 1          | Manuelle Umbuchung    |EU-Staat | ES         |ES123456|
 |UMLAG  |1   |Abgang |BOSCH | 2          | Manuelle Umbuchung    |EU-Staat | ES         |ES123456|
Then field "tlj" is not empty in row 1
Then field "tlj" is not empty in row 2
And I close the current editor


Scenario: Lagerbuchung Umbuchung von Konsilagerplatz zu Konsilagerplatz - Tatbestand 3
Given I open an editor "LBuchung" for tip command "Lbuchung" and arguments ""
And I set fields
      | artikel     | UMLAG       |
      | beleg       | T3          |
      | beldat      | .           |
      | buart       | Umbuchung   |
And I modify table
      | !row  | mge   | platz | platz2  |
      | +1    | 1     | BOSCH | DAIMLER | 
And I save the current editor

Given I open the infosystem "CONSWAREHOUSE"
And I press start
Then the table has 3 rows
Then table has values
 |tartikel|tmge|tbuarta|tplatz   | ttatbestand|  tdetursache          | tlaart  |tlandkuerzel|tustid  |tplatzursprung|
 |UMLAG   |1   |Zugang |BOSCH    | 1          | Manuelle Umbuchung    | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Abgang |BOSCH    | 2          | Manuelle Umbuchung    | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Zugang |DAIMLER  | 3          | Manuelle Umbuchung    | EU-Staat| IT         |IT987645|BOSCH         |
Then field "tlj" is not empty in row 1
Then field "tlj" is not empty in row 2
Then field "tlj" is not empty in row 3
And I close the current editor

Scenario: Lagerbuchung Zugang auf einem Lagerplatz, der den Haken Konsiplatz nicht hat
Given I open an editor "LBuchung" for tip command "Lbuchung" and arguments ""
And I set fields
      | artikel     | UMLAG   |
      | beleg       | T1         |
      | beldat      | .           |
      | buart       | Umbuchung   |
And I modify table
      | !row  | mge   | platz | platz2  |
      | +1    | 1     | F1    | VW      | 
And I save the current editor

Given I open the infosystem "CONSWAREHOUSE"
#Diese Umbuchung darf nicht auftauchen
And I press start
Then the table has 3 rows
Then table has values
 |tartikel|tmge|tbuarta|tplatz   | ttatbestand|  tdetursache         | tlaart  |tlandkuerzel|tustid  |tplatzursprung|
 |UMLAG   |1   |Zugang |BOSCH    | 1          | Manuelle Umbuchung   | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Abgang |BOSCH    | 2          | Manuelle Umbuchung   | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Zugang |DAIMLER  | 3          | Manuelle Umbuchung   | EU-Staat| IT         |IT987645|BOSCH         |
Then field "tlj" is not empty in row 1
Then field "tlj" is not empty in row 2
Then field "tlj" is not empty in row 3
And I close the current editor


Scenario: Umlagerungsvorschlag anlegen und umbuchen - Zugang auf Konsiplatz - Tatbestand 1
Given I open an editor "umvorschlag" from table "(Purchasing):(RelocationSuggestions)" with command "NEW" for record ""
And I set field "beleg" to "T1"
And I set field "beldat" to "."
And I create a new row at the end of the table
And I set field "artikel" to "UMLAG" in row 1
And I set field "lief" to id from editor "lieferant" in row 1
And I set field "mge" to "10" in row 1
And I set field "platz" to "BOSCH" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "umbuchen" to open a subeditor for "lagerbuch"
And I close the current editor
And I close the current editor

Scenario: gebuchten Umlagerungsvorschlag pruefen
Given I open the infosystem "CONSWAREHOUSE"
And I press start
Then the table has 4 rows
Then table has values
 |tartikel|tmge|tbuarta|tplatz   | ttatbestand|  tdetursache          | tlaart  |tlandkuerzel|tustid  |tplatzursprung|
 |UMLAG   |1   |Zugang |BOSCH    | 1          | Manuelle Umbuchung    | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Abgang |BOSCH    | 2          | Manuelle Umbuchung    | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Zugang |DAIMLER  | 3          | Manuelle Umbuchung    | EU-Staat| IT         |IT987645|BOSCH         |
 |UMLAG   |10  |Zugang |BOSCH    | 1          | Umlagerungsvorschlag  | EU-Staat| ES         |ES123456|              |
Then field "tlj" is not empty in row 1
Then field "tlj" is not empty in row 2
Then field "tlj" is not empty in row 3
Then field "tlj" is not empty in row 4
And I close the current editor

Scenario: Umlagerungsvorschlag anlegen und umbuchen - Abgang von Konsiplatz - Tatbestand 2
Given I open an editor "umvorschlag" from table "(Purchasing):(RelocationSuggestions)" with command "NEW" for record ""
And I set field "beleg" to "T2"
And I set field "beldat" to "."
And I create a new row at the end of the table
And I set field "artikel" to "UMLAG" in row 1
And I set field "lief" to id from editor "lieferant" in row 1
And I set field "mge" to "10" in row 1
And I set field "abplatz" to "BOSCH" in row 1
And I set field "platz" to "F1" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "umbuchen" to open a subeditor for "lagerbuch"
And I close the current editor
And I close the current editor

Scenario: gebuchten Umlagerungsvorschlag pruefen
Given I open the infosystem "CONSWAREHOUSE"
And I press start
Then the table has 5 rows
Then table has values
 |tartikel|tmge|tbuarta|tplatz   | ttatbestand|  tdetursache          | tlaart  |tlandkuerzel|tustid  |tplatzursprung|
 |UMLAG   |1   |Zugang |BOSCH    | 1          | Manuelle Umbuchung    | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Abgang |BOSCH    | 2          | Manuelle Umbuchung    | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Zugang |DAIMLER  | 3          | Manuelle Umbuchung    | EU-Staat| IT         |IT987645|BOSCH         |
 |UMLAG   |10  |Zugang |BOSCH    | 1          | Umlagerungsvorschlag  | EU-Staat| ES         |ES123456|              |
 |UMLAG   |10  |Abgang |BOSCH    | 2          | Umlagerungsvorschlag  | EU-Staat| ES         |ES123456|              |
Then field "tlj" is not empty in row 1
Then field "tlj" is not empty in row 2
Then field "tlj" is not empty in row 3
Then field "tlj" is not empty in row 4
Then field "tlj" is not empty in row 5
And I close the current editor

Scenario: Umlagerungsvorschlag anlegen und umbuchen - Abgang von einem exteren Lagerplatz ohne Haken Konsi
Given I open an editor "umvorschlag" from table "(Purchasing):(RelocationSuggestions)" with command "NEW" for record ""
And I set field "beleg" to "T2"
And I set field "beldat" to "."
And I create a new row at the end of the table
And I set field "artikel" to "UMLAG" in row 1
And I set field "lief" to id from editor "lieferant" in row 1
And I set field "mge" to "10" in row 1
And I set field "abplatz" to "VW" in row 1
And I set field "platz" to "F1" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "umbuchen" to open a subeditor for "lagerbuch"
And I close the current editor
And I close the current editor

Scenario: gebuchten Umlagerungsvorschlag pruefen
Given I open the infosystem "CONSWAREHOUSE"
#Diese Umbuchung darf nicht auftauchen
And I press start
Then the table has 5 rows
Then table has values
 |tartikel|tmge|tbuarta|tplatz   | ttatbestand|  tdetursache          | tlaart  |tlandkuerzel|tustid  |tplatzursprung|
 |UMLAG   |1   |Zugang |BOSCH    | 1          | Manuelle Umbuchung    | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Abgang |BOSCH    | 2          | Manuelle Umbuchung    | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Zugang |DAIMLER  | 3          | Manuelle Umbuchung    | EU-Staat| IT         |IT987645|BOSCH         |
 |UMLAG   |10  |Zugang |BOSCH    | 1          | Umlagerungsvorschlag  | EU-Staat| ES         |ES123456|              |
 |UMLAG   |10  |Abgang |BOSCH    | 2          | Umlagerungsvorschlag  | EU-Staat| ES         |ES123456|              |
Then field "tlj" is not empty in row 1
Then field "tlj" is not empty in row 2
Then field "tlj" is not empty in row 3
Then field "tlj" is not empty in row 4
Then field "tlj" is not empty in row 5
And I close the current editor


Scenario: Umlagerungsvorschlag anlegen und umbuchen - Umbuchung von Konsiplatz zu Konsiplatz - Tatbestand 3
Given I open an editor "umvorschlag" from table "(Purchasing):(RelocationSuggestions)" with command "NEW" for record ""
And I set field "beleg" to "T3"
And I set field "beldat" to "."
And I create a new row at the end of the table
And I set field "artikel" to "UMLAG" in row 1
And I set field "lief" to id from editor "lieferant" in row 1
And I set field "mge" to "10" in row 1
And I set field "abplatz" to "BOSCH" in row 1
And I set field "platz" to "DAIMLER" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "umbuchen" to open a subeditor for "lagerbuch"
And I close the current editor
And I close the current editor

Scenario: gebuchten Umlagerungsvorschlag pruefen
Given I open the infosystem "CONSWAREHOUSE"
And I press start
Then the table has 6 rows
Then table has values
 |tartikel|tmge|tbuarta|tplatz   | ttatbestand|  tdetursache          | tlaart  |tlandkuerzel|tustid  |tplatzursprung|
 |UMLAG   |1   |Zugang |BOSCH    | 1          | Manuelle Umbuchung    | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Abgang |BOSCH    | 2          | Manuelle Umbuchung    | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Zugang |DAIMLER  | 3          | Manuelle Umbuchung    | EU-Staat| IT         |IT987645|BOSCH         |
 |UMLAG   |10  |Zugang |BOSCH    | 1          | Umlagerungsvorschlag  | EU-Staat| ES         |ES123456|              |
 |UMLAG   |10  |Abgang |BOSCH    | 2          | Umlagerungsvorschlag  | EU-Staat| ES         |ES123456|              |
 |UMLAG   |10  |Zugang |DAIMLER  | 3          | Umlagerungsvorschlag  | EU-Staat| IT         |IT987645|BOSCH         |
Then field "tlj" is not empty in row 1
Then field "tlj" is not empty in row 2
Then field "tlj" is not empty in row 3
Then field "tlj" is not empty in row 4
Then field "tlj" is not empty in row 5
Then field "tlj" is not empty in row 6
And I close the current editor

Scenario: Kommissionslieferschein anlegen - Zugang auf Konsiplatz - Tatbestand 1
Given I open an editor "kommls1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "Bosch"
And I set field "umplatz" to "Bosch"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "UMLAG" in row 1
And I set field "mge" to "100" in row 1
And I save the current editor

Given I open the infosystem "CONSWAREHOUSE"
And I press start
Then the table has 7 rows
Then table has values
 |tartikel|tmge|tbuarta|tplatz   | ttatbestand|  tdetursache                     | tlaart  |tlandkuerzel|tustid  |tplatzursprung|
 |UMLAG   |1   |Zugang |BOSCH    | 1          | Manuelle Umbuchung               | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Abgang |BOSCH    | 2          | Manuelle Umbuchung               | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Zugang |DAIMLER  | 3          | Manuelle Umbuchung               | EU-Staat| IT         |IT987645|BOSCH         |
 |UMLAG   |10  |Zugang |BOSCH    | 1          | Umlagerungsvorschlag             | EU-Staat| ES         |ES123456|              |
 |UMLAG   |10  |Abgang |BOSCH    | 2          | Umlagerungsvorschlag             | EU-Staat| ES         |ES123456|              |
 |UMLAG   |10  |Zugang |DAIMLER  | 3          | Umlagerungsvorschlag             | EU-Staat| IT         |IT987645|BOSCH         |
 |UMLAG   |100 |Zugang |BOSCH    | 1          | Kommissionslieferschein Verkauf  | EU-Staat| ES         |ES123456|              |
Then field "tlj" is not empty in row 1
Then field "tlj" is not empty in row 2
Then field "tlj" is not empty in row 3
Then field "tlj" is not empty in row 4
Then field "tlj" is not empty in row 5
Then field "tlj" is not empty in row 6
Then field "tlj" is not empty in row 7
Then field "tvorgang" is not empty in row 1
Then field "tvorgang" is not empty in row 2
Then field "tvorgang" is not empty in row 3
Then field "tvorgang" is not empty in row 4
Then field "tvorgang" is not empty in row 5
Then field "tvorgang" is not empty in row 6
Then field "tvorgang" is not empty in row 7
And I close the current editor

Scenario: Kommissionslieferschein anlegen - Abgang von Konsiplatz - Tatbestand 2
Given I open an editor "kommls2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "WIR"
And I set field "umplatz" to "F1"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "UMLAG" in row 1
And I set field "mge" to "100" in row 1
And I set field "platz" to "Bosch" in row 1
And I save the current editor

Given I open the infosystem "CONSWAREHOUSE"
And I press start
Then the table has 8 rows
Then table has values
 |tartikel|tmge|tbuarta|tplatz   | ttatbestand|  tdetursache                      | tlaart  |tlandkuerzel|tustid  |tplatzursprung|
 |UMLAG   |1   |Zugang |BOSCH    | 1          | Manuelle Umbuchung                | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Abgang |BOSCH    | 2          | Manuelle Umbuchung                | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Zugang |DAIMLER  | 3          | Manuelle Umbuchung                | EU-Staat| IT         |IT987645|BOSCH         |
 |UMLAG   |10  |Zugang |BOSCH    | 1          | Umlagerungsvorschlag              | EU-Staat| ES         |ES123456|              |
 |UMLAG   |10  |Abgang |BOSCH    | 2          | Umlagerungsvorschlag              | EU-Staat| ES         |ES123456|              |
 |UMLAG   |10  |Zugang |DAIMLER  | 3          | Umlagerungsvorschlag              | EU-Staat| IT         |IT987645|BOSCH         |
 |UMLAG   |100 |Zugang |BOSCH    | 1          | Kommissionslieferschein Verkauf   | EU-Staat| ES         |ES123456|              |
 |UMLAG   |100 |Abgang |BOSCH    | 2          | Kommissionslieferschein Verkauf   | EU-Staat| ES         |ES123456|              |
Then field "tlj" is not empty in row 1
Then field "tlj" is not empty in row 2
Then field "tlj" is not empty in row 3
Then field "tlj" is not empty in row 4
Then field "tlj" is not empty in row 5
Then field "tlj" is not empty in row 6
Then field "tlj" is not empty in row 7
Then field "tlj" is not empty in row 8
Then field "tvorgang" is not empty in row 1
Then field "tvorgang" is not empty in row 2
Then field "tvorgang" is not empty in row 3
Then field "tvorgang" is not empty in row 4
Then field "tvorgang" is not empty in row 5
Then field "tvorgang" is not empty in row 6
Then field "tvorgang" is not empty in row 7
Then field "tvorgang" is not empty in row 8
And I close the current editor

Scenario: Kommissionslieferschein anlegen - Umbuchen von Konsi zu Konsiplatz - Tatbestand 3
Given I open an editor "kommls3" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "DAIMLER"
And I set field "umplatz" to "DAIMLER"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "UMLAG" in row 1
And I set field "mge" to "100" in row 1
And I set field "platz" to "BOSCH" in row 1
And I save the current editor

Given I open the infosystem "CONSWAREHOUSE"
And I press start
Then the table has 9 rows
Then table has values
 |tartikel|tmge|tbuarta|tplatz   | ttatbestand|  tdetursache                     | tlaart  |tlandkuerzel|tustid  |tplatzursprung|
 |UMLAG   |1   |Zugang |BOSCH    | 1          | Manuelle Umbuchung               | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Abgang |BOSCH    | 2          | Manuelle Umbuchung               | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Zugang |DAIMLER  | 3          | Manuelle Umbuchung               | EU-Staat| IT         |IT987645|BOSCH         |
 |UMLAG   |10  |Zugang |BOSCH    | 1          | Umlagerungsvorschlag             | EU-Staat| ES         |ES123456|              |
 |UMLAG   |10  |Abgang |BOSCH    | 2          | Umlagerungsvorschlag             | EU-Staat| ES         |ES123456|              |
 |UMLAG   |10  |Zugang |DAIMLER  | 3          | Umlagerungsvorschlag             | EU-Staat| IT         |IT987645|BOSCH         |
 |UMLAG   |100 |Zugang |BOSCH    | 1          | Kommissionslieferschein Verkauf  | EU-Staat| ES         |ES123456|              |
 |UMLAG   |100 |Abgang |BOSCH    | 2          | Kommissionslieferschein Verkauf  | EU-Staat| ES         |ES123456|              |
 |UMLAG   |100 |Zugang |DAIMLER  | 3          | Kommissionslieferschein Verkauf  | EU-Staat| IT         |IT987645|BOSCH         |
Then field "tlj" is not empty in row 1
Then field "tlj" is not empty in row 2
Then field "tlj" is not empty in row 3
Then field "tlj" is not empty in row 4
Then field "tlj" is not empty in row 5
Then field "tlj" is not empty in row 6
Then field "tlj" is not empty in row 7
Then field "tlj" is not empty in row 8
Then field "tlj" is not empty in row 9
Then field "tvorgang" is not empty in row 1
Then field "tvorgang" is not empty in row 2
Then field "tvorgang" is not empty in row 3
Then field "tvorgang" is not empty in row 4
Then field "tvorgang" is not empty in row 5
Then field "tvorgang" is not empty in row 6
Then field "tvorgang" is not empty in row 7
Then field "tvorgang" is not empty in row 8
Then field "tvorgang" is not empty in row 9
And I close the current editor


Scenario: Kommissionslieferschein anlegen - Umbuchen von Konsi zu einem externen Lagerplatz ohne Konsi-Haken - Tatbestand 3
Given I open an editor "kommls4" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "DAIMLER"
And I set field "umplatz" to "DAIMLER"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "UMLAG" in row 1
And I set field "mge" to "100" in row 1
And I set field "platz" to "VW" in row 1
And I save the current editor

Given I open the infosystem "CONSWAREHOUSE"
#Diese Umbuchung darf nicht auftauchen
And I press start
Then the table has 9 rows
Then table has values
 |tartikel|tmge|tbuarta|tplatz   | ttatbestand|  tdetursache                     | tlaart  |tlandkuerzel|tustid  |tplatzursprung|
 |UMLAG   |1   |Zugang |BOSCH    | 1          | Manuelle Umbuchung               | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Abgang |BOSCH    | 2          | Manuelle Umbuchung               | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Zugang |DAIMLER  | 3          | Manuelle Umbuchung               | EU-Staat| IT         |IT987645|BOSCH         |
 |UMLAG   |10  |Zugang |BOSCH    | 1          | Umlagerungsvorschlag             | EU-Staat| ES         |ES123456|              |
 |UMLAG   |10  |Abgang |BOSCH    | 2          | Umlagerungsvorschlag             | EU-Staat| ES         |ES123456|              |
 |UMLAG   |10  |Zugang |DAIMLER  | 3          | Umlagerungsvorschlag             | EU-Staat| IT         |IT987645|BOSCH         |
 |UMLAG   |100 |Zugang |BOSCH    | 1          | Kommissionslieferschein Verkauf  | EU-Staat| ES         |ES123456|              |
 |UMLAG   |100 |Abgang |BOSCH    | 2          | Kommissionslieferschein Verkauf  | EU-Staat| ES         |ES123456|              |
 |UMLAG   |100 |Zugang |DAIMLER  | 3          | Kommissionslieferschein Verkauf  | EU-Staat| IT         |IT987645|BOSCH         |
And I close the current editor

Scenario: Kommissionslieferschein stornieren
Given I open an editor "stornokommls" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "kommls1"
And I save the current editor

Given I open the infosystem "CONSWAREHOUSE"
#Diese Umbuchung darf nicht auftauchen
And I press start
Then the table has 8 rows
Then table has values
 |tartikel|tmge|tbuarta|tplatz   | ttatbestand|  tdetursache                     | tlaart  |tlandkuerzel|tustid  |tplatzursprung|
 |UMLAG   |1   |Zugang |BOSCH    | 1          | Manuelle Umbuchung               | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Abgang |BOSCH    | 2          | Manuelle Umbuchung               | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Zugang |DAIMLER  | 3          | Manuelle Umbuchung               | EU-Staat| IT         |IT987645|BOSCH         |
 |UMLAG   |10  |Zugang |BOSCH    | 1          | Umlagerungsvorschlag             | EU-Staat| ES         |ES123456|              |
 |UMLAG   |10  |Abgang |BOSCH    | 2          | Umlagerungsvorschlag             | EU-Staat| ES         |ES123456|              |
 |UMLAG   |10  |Zugang |DAIMLER  | 3          | Umlagerungsvorschlag             | EU-Staat| IT         |IT987645|BOSCH         |
 |UMLAG   |100 |Abgang |BOSCH    | 2          | Kommissionslieferschein Verkauf  | EU-Staat| ES         |ES123456|              |
 |UMLAG   |100 |Zugang |DAIMLER  | 3          | Kommissionslieferschein Verkauf  | EU-Staat| IT         |IT987645|BOSCH         |

Scenario Outline: Lagerbuchung stornieren
# Lagerbuchungen buchen
Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel   | UMLAG |
    | buart     | <buart>   |
    | beleg     | <beleg>   |
    | beldat    | .         |
And I modify table
    | mge   | platz     | platz2    | !row  |
    | 10    | <platz>   | <platz2>  | +1    |
And I save the current editor

# Lagerbuchungen stornieren
#Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
#And I set field "stornolj" to "$,,such=L;artikel=UMLAG;detursache=manuelle Umbuchung;@richtung=rückwärts;@maxtreffer=1"

#Given I open an editor "LBuchungSt" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "REVERSAL" for search criteria "$,,such=L;artikel=UMLAG;detursache=manuelle Umbuchung;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
Given I open an editor "LBuchungSt" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "REVERSAL" for record from editor "LBuchung"
And I set field "beleg" to "<beleg>"
Then field "buart" has value "<buart>"
Then table has values
    | mge   | platz     | platz2    | 
    | -10   | <platz>   | <platz2>  |
And I save the current editor

Examples:
| buart     | beleg       | platz         | platz2  |      
| Umbuchung | ST_UMB_001  |  F1           | BOSCH   |

Scenario: Pruefen der Lagerbuchung und der Storno-Buchung
Given I open the infosystem "CONSWAREHOUSE"
#Storno und stornierte Buchung darf nicht auftauchen
And I press start
Then the table has 8 rows
Then table has values
 |tartikel|tmge|tbuarta|tplatz   | ttatbestand|  tdetursache                      | tlaart  |tlandkuerzel|tustid  |tplatzursprung|
 |UMLAG   |1   |Zugang |BOSCH    | 1          | Manuelle Umbuchung                | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Abgang |BOSCH    | 2          | Manuelle Umbuchung                | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Zugang |DAIMLER  | 3          | Manuelle Umbuchung                | EU-Staat| IT         |IT987645|BOSCH         |
 |UMLAG   |10  |Zugang |BOSCH    | 1          | Umlagerungsvorschlag              | EU-Staat| ES         |ES123456|              |
 |UMLAG   |10  |Abgang |BOSCH    | 2          | Umlagerungsvorschlag              | EU-Staat| ES         |ES123456|              |
 |UMLAG   |10  |Zugang |DAIMLER  | 3          | Umlagerungsvorschlag              | EU-Staat| IT         |IT987645|BOSCH         |
 |UMLAG   |100 |Abgang |BOSCH    | 2          | Kommissionslieferschein Verkauf   | EU-Staat| ES         |ES123456|              |
 |UMLAG   |100 |Zugang |DAIMLER  | 3          | Kommissionslieferschein Verkauf   | EU-Staat| IT         |IT987645|BOSCH         |

Scenario: Meldeansicht testen
Given I open the infosystem "CONSWAREHOUSE"
And I set field "meldung" to "ja" 
And I press start
Then the table has 3 rows
Then table has values
|tlandkuerzel | tustid   | ttatbestand |tlandkuerzelurspru |tustidursprung|
|ES           | ES123456 | 1           |                   |              |
|ES           | ES123456 | 2           |                   |              |
|IT           | IT987645 | 3           | ES                | ES123456     |

Scenario: Lagerbuchung Zugang auf Konsilagerplatz - nicht Tatbestand 1, denn Kunde sitzt in den USA
Given I open an editor "LBuchung" for tip command "Lbuchung" and arguments ""
And I set fields
      | artikel     | UMLAG   |
      | beleg       | T1         |
      | beldat      | .           |
      | buart       | Umbuchung   |
And I modify table
      | !row  | mge   | platz | platz2  |
      | +1    | 1     | F1    | TESLA   | 
And I save the current editor

Scenario: Pruefen der Umlagerung ins Ausland
Given I open the infosystem "CONSWAREHOUSE"
#Diese Umlagerung darf nicht auftauchen
And I press start
Then the table has 8 rows
Then table has values
 |tartikel|tmge|tbuarta|tplatz   | ttatbestand|  tdetursache                      | tlaart  |tlandkuerzel|tustid  |tplatzursprung|
 |UMLAG   |1   |Zugang |BOSCH    | 1          | Manuelle Umbuchung                | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Abgang |BOSCH    | 2          | Manuelle Umbuchung                | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Zugang |DAIMLER  | 3          | Manuelle Umbuchung                | EU-Staat| IT         |IT987645|BOSCH         |
 |UMLAG   |10  |Zugang |BOSCH    | 1          | Umlagerungsvorschlag              | EU-Staat| ES         |ES123456|              |
 |UMLAG   |10  |Abgang |BOSCH    | 2          | Umlagerungsvorschlag              | EU-Staat| ES         |ES123456|              |
 |UMLAG   |10  |Zugang |DAIMLER  | 3          | Umlagerungsvorschlag              | EU-Staat| IT         |IT987645|BOSCH         |
 |UMLAG   |100 |Abgang |BOSCH    | 2          | Kommissionslieferschein Verkauf   | EU-Staat| ES         |ES123456|              |
 |UMLAG   |100 |Zugang |DAIMLER  | 3          | Kommissionslieferschein Verkauf   | EU-Staat| IT         |IT987645|BOSCH         |

Scenario: Umlagerungsvorschlag anlegen und umbuchen - Abgang von Konsiplatz - nicht Tatbestand 2 Kunde sitzt in den USA
Given I open an editor "umvorschlag" from table "(Purchasing):(RelocationSuggestions)" with command "NEW" for record ""
And I set field "beleg" to "T2"
And I set field "beldat" to "."
And I create a new row at the end of the table
And I set field "artikel" to "UMLAG" in row 1
And I set field "lief" to id from editor "lieferant" in row 1
And I set field "mge" to "10" in row 1
And I set field "abplatz" to "TESLA" in row 1
And I set field "platz" to "F1" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "umbuchen" to open a subeditor for "lagerbuch"
And I close the current editor
And I close the current editor

Scenario: Pruefen der Umlagerung ins Ausland
Given I open the infosystem "CONSWAREHOUSE"
#Diese Umlagerung darf nicht auftauchen
And I press start
Then the table has 8 rows
Then table has values
 |tartikel|tmge|tbuarta|tplatz   | ttatbestand|  tdetursache                      | tlaart  |tlandkuerzel|tustid  |tplatzursprung|
 |UMLAG   |1   |Zugang |BOSCH    | 1          | Manuelle Umbuchung                | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Abgang |BOSCH    | 2          | Manuelle Umbuchung                | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Zugang |DAIMLER  | 3          | Manuelle Umbuchung                | EU-Staat| IT         |IT987645|BOSCH         |
 |UMLAG   |10  |Zugang |BOSCH    | 1          | Umlagerungsvorschlag              | EU-Staat| ES         |ES123456|              |
 |UMLAG   |10  |Abgang |BOSCH    | 2          | Umlagerungsvorschlag              | EU-Staat| ES         |ES123456|              |
 |UMLAG   |10  |Zugang |DAIMLER  | 3          | Umlagerungsvorschlag              | EU-Staat| IT         |IT987645|BOSCH         |
 |UMLAG   |100 |Abgang |BOSCH    | 2          | Kommissionslieferschein Verkauf   | EU-Staat| ES         |ES123456|              |
 |UMLAG   |100 |Zugang |DAIMLER  | 3          | Kommissionslieferschein Verkauf   | EU-Staat| IT         |IT987645|BOSCH         |
 
 Scenario: Kommissionslieferschein anlegen - Umbuchen von Konsi zu Konsiplatz - Abgang im Ausland
Given I open an editor "kommls3" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "DAIMLER"
And I set field "umplatz" to "DAIMLER"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "UMLAG" in row 1
And I set field "mge" to "100" in row 1
And I set field "platz" to "TESLA" in row 1
And I save the current editor

Scenario: Pruefen der Umlagerung ins Ausland
Given I open the infosystem "CONSWAREHOUSE"
#Diese Umlagerung darf nicht auftauchen
And I press start
Then the table has 8 rows
Then table has values
 |tartikel|tmge|tbuarta|tplatz   | ttatbestand|  tdetursache                      | tlaart  |tlandkuerzel|tustid  |tplatzursprung|
 |UMLAG   |1   |Zugang |BOSCH    | 1          | Manuelle Umbuchung                | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Abgang |BOSCH    | 2          | Manuelle Umbuchung                | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Zugang |DAIMLER  | 3          | Manuelle Umbuchung                | EU-Staat| IT         |IT987645|BOSCH         |
 |UMLAG   |10  |Zugang |BOSCH    | 1          | Umlagerungsvorschlag              | EU-Staat| ES         |ES123456|              |
 |UMLAG   |10  |Abgang |BOSCH    | 2          | Umlagerungsvorschlag              | EU-Staat| ES         |ES123456|              |
 |UMLAG   |10  |Zugang |DAIMLER  | 3          | Umlagerungsvorschlag              | EU-Staat| IT         |IT987645|BOSCH         |
 |UMLAG   |100 |Abgang |BOSCH    | 2          | Kommissionslieferschein Verkauf   | EU-Staat| ES         |ES123456|              |
 |UMLAG   |100 |Zugang |DAIMLER  | 3          | Kommissionslieferschein Verkauf   | EU-Staat| IT         |IT987645|BOSCH         |
 
  Scenario: Kommissionslieferschein anlegen - Umbuchen von Konsi zu Konsiplatz - Zugang im Ausland
Given I open an editor "kommls3" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "TESLA"
And I set field "umplatz" to "TESLA"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "UMLAG" in row 1
And I set field "mge" to "100" in row 1
And I set field "platz" to "DAIMLER" in row 1
And I save the current editor

Scenario: Pruefen der Umlagerung ins Ausland
Given I open the infosystem "CONSWAREHOUSE"
#Diese Umlagerung darf nicht auftauchen
And I press start
Then the table has 8 rows
Then table has values
 |tartikel|tmge|tbuarta|tplatz   | ttatbestand|  tdetursache                     | tlaart  |tlandkuerzel|tustid  |tplatzursprung|
 |UMLAG   |1   |Zugang |BOSCH    | 1          | Manuelle Umbuchung               | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Abgang |BOSCH    | 2          | Manuelle Umbuchung               | EU-Staat| ES         |ES123456|              |
 |UMLAG   |1   |Zugang |DAIMLER  | 3          | Manuelle Umbuchung               | EU-Staat| IT         |IT987645|BOSCH         |
 |UMLAG   |10  |Zugang |BOSCH    | 1          | Umlagerungsvorschlag             | EU-Staat| ES         |ES123456|              |
 |UMLAG   |10  |Abgang |BOSCH    | 2          | Umlagerungsvorschlag             | EU-Staat| ES         |ES123456|              |
 |UMLAG   |10  |Zugang |DAIMLER  | 3          | Umlagerungsvorschlag             | EU-Staat| IT         |IT987645|BOSCH         |
 |UMLAG   |100 |Abgang |BOSCH    | 2          | Kommissionslieferschein Verkauf  | EU-Staat| ES         |ES123456|              |
 |UMLAG   |100 |Zugang |DAIMLER  | 3          | Kommissionslieferschein Verkauf  | EU-Staat| IT         |IT987645|BOSCH         |


Scenario: abgelegter Lagerplatz, wird weiterhin im Infosystem angezeigt

# Bestand auf Null setzen und Nullmengen loeschen, damit Lagerplatz geloescht werden kann
Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | UMLAG         |
    | beleg     | KORR_LPLATZ   |
    | beldat    | .             |
And I modify table
    | !row| platz     | mge   |
    | 1   | DAIMLER   | 0     |
And I save the current editor

Given I open the infosystem "SQDELETE"
And I set field "lplatz" to "DAIMLER"
And I press start
And I press button "allean"
And I press button "auswahlloeschen"
And I close the current editor

# neuen Standardlagerplatz anlegen
Given I open an editor "DAIMLER" from table "(Location):(Location)" with command "COPY" for record "DAIMLER"
And I set field "such" to "DAIMLERNEU"
And I set field "namebspr" to "DAIMLER neu"
And I set field "zuplatz" to "ja"
And I set field "abplatz" to "ja"
And I save the current editor

Given I open an editor "DAIMLER" from table "(Location):(Location)" with command "DELETE" for record "DAIMLER"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

Given I open the infosystem "CONSWAREHOUSE"
# abgelegter Lagerplatz wird weiterhin angezeigt
And I press start
Then the table has 8 rows
Then table has values
    | tartikel | tmge  | tbuarta   | tplatz    | ttatbestand   | tdetursache                       | tlaart    | tlandkuerzel  | tustid    | tplatzursprung    |
    | UMLAG    | 1     | Zugang    | BOSCH     | 1             | Manuelle Umbuchung                | EU-Staat  | ES            | ES123456  |                   |
    | UMLAG    | 1     | Abgang    | BOSCH     | 2             | Manuelle Umbuchung                | EU-Staat  | ES            | ES123456  |                   |
    | UMLAG    | 1     | Zugang    | +DAIMLER  | 3             | Manuelle Umbuchung                | EU-Staat  | IT            | IT987645  | BOSCH             |
    | UMLAG    | 10    | Zugang    | BOSCH     | 1             | Umlagerungsvorschlag              | EU-Staat  | ES            | ES123456  |                   |
    | UMLAG    | 10    | Abgang    | BOSCH     | 2             | Umlagerungsvorschlag              | EU-Staat  | ES            | ES123456  |                   |
    | UMLAG    | 10    | Zugang    | +DAIMLER  | 3             | Umlagerungsvorschlag              | EU-Staat  | IT            | IT987645  | BOSCH             |
    | UMLAG    | 100   | Abgang    | BOSCH     | 2             | Kommissionslieferschein Verkauf   | EU-Staat  | ES            | ES123456  |                   |
    | UMLAG    | 100   | Zugang    | +DAIMLER  | 3             | Kommissionslieferschein Verkauf   | EU-Staat  | IT            | IT987645  | BOSCH             |
And I close the current editor
