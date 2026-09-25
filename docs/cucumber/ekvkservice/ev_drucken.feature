@persistent
Feature: Druckmatrix

Background:
Given I set the fake date to "02.01.1995"
# *****************************************************************************
#  Name           : ev_drucken.feature
#  Autor          : cl
#  Verantwortlich : cl
#  Kontrolle      : teampss
#  Funktion       : Cucumber Tests fuer Druck im Einkauf und Verkauf zu allen Vorgängen
#                 : Anzeigen der Faelle Ruecklieferung, Kundenanlieferung, Kaufmaennische Gutschrift,
#                   Anzahlung und Barzahlung in den Infosystemen KDINFO, LFINFO und BELEGVORKOMMEN
#
# *****************************************************************************

Scenario: STAMMDATEN - Kunde / Lieferant / Materialzuschlag anlegen
# Kunde anlegen
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "Bayram"
# Anschrift Rechnung
And I set fields
  | such      | Bayram                      |
  | namebspr  | Bayram Werkzeugbau, Rastatt |
  | ans       | Bayram Werkzeugbau GmbH     |
  | str       | Riedstr. 24-28              |
  | plz       | 76437                       |
  | nort      | Rastatt                     |
  | tele      | +49 (0) 7222/9456-0         |
  | email     | info@bayram-corp.de         |
  | betreuer  | .                           |

# Anschrift Versand
And I set fields
  | ans2      | Bayram Fabrik GmbH          |
  | str2      | Schlossstr. 24-28           |
  | plz2      | 76135                       |
  | nort2     | Karlsruhe                   |
  | ustid     | DE56454651                  |
  | lbed      | EXW                         |
  | zbed      | 201                         |

And I save the current editor
Then field "name" has value "Bayram Werkzeugbau, Rastatt"
Then field "zbed" has value "201"

# Lieferanten anlegen
Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "STORE" for record "REUS"
# Anschrift Bestellung
And I set fields
  | such      | REUS                        |
  | namebspr  | Reus Werkzeugbau, Rastatt   |
  | ans       | Reus Werkzeugbau GmbH       |
  | str       | Riedstr. 24-28              |
  | plz       | 76437                       |
  | nort      | Rastatt                     |
  | tele      | +49 (0) 7222/9456-0         |
  | email     | info@bayram-corp.de         |
  | betreuer  | .                           |

# Anschrift Versand
And I set fields
  | ans2      | Reus Fussball GmbH          |
  | str2      | Bvbstr. 24-28               |
  | plz2      | 33333                       |
  | nort2     | Dortmund                    |
  | ustid     | DE56454651                  |
  | lbed      | EXW                         |
  | zbed      | 201                         |

And I save the current editor
Then field "name" has value "Reus Werkzeugbau, Rastatt"
Then field "zbed" has value "201"

# Materialzuschlag anlegen
Given I open an editor "matzuschlag" from table "(Company):(MaterialSurchargeHeader)" with command "STORE" for record "30"
And I create a new row at the end of the table
And I set field "matart" to "CU" in row 1
And I set field "matbasis" to "100" in row 1
And I set field "matnotiz" to "110" in row 1
And I save the current editor

Scenario Outline: STAMMDATEN - Zwei neue Artikel anlegen. Artikel 2 bekommt Materialzuschlag
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields

| such     | <such>     |
| namebspr | <namebspr> |
| vkbez    | <vkbez>    |
| vbez     | <vbez>     |
| ebez     | <ebez>     |
| vpr      | <vpr>      |
| bsart    | <bsart>    |
| dispoa   | <dispoa>   |
| lief     | <lief>     |
| epr      | <epr>      |
| efrist   | <efrist>   |
| matart   | <matart>   |
| zmge     | <zmge>     |
| matvrel  | <matvrel>  |
| materel  | <materel>  |

And I save the current editor
Examples: Artikel
| such            | namebspr     | vkbez     | vbez       | ebez      | vpr    | bsart             | dispoa          | lief | epr  | efrist   | matart | zmge | matvrel | materel |
| artikel1        | Artikel 1    | Artikel 1 | Artikel 1  | Artikel 1 | 10000  | Fremdbeschaffung  | bedarfsbezogen  | reus | 9000 | 15       | CU     | 1    | ja      | ja      |
| artikel2        | Artikel 2    | Artikel 2 | Artikel 2  | Artikel 2 | 9000   | Fremdbeschaffung  | bedarfsbezogen  | reus | 7000 | 10       | CU     | 1    | ja      | ja      |

Scenario: STAMMDATEN - Konsignationslagergruppe / Externe Lagergruppe anlegen
# Konsignationslagergruppe anlegen
Given I open an editor "Konsignationslg" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "konsi"
And I set field "such" to "konsi"
And I set field "namebspr" to "Konsignationslagergruppe"
And I set field "zkonsilg" to "ja"
Then field "vkruecklieferung" is not modifiable
Then field "vkkundenanlieferung" is not modifiable
And I save the current editor

# Externe_Lagergruppe anlegen
Given I open an editor "Externelg" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "extern"
And I set field "such" to "extern"
And I set field "namebspr" to "Externe Lagergruppe"
And I set field "zkonsilg" to "nein"
Then field "vkruecklieferung" is modifiable
Then field "vkkundenanlieferung" is modifiable
And I save the current editor

Scenario Outline: STAMMDATEN - Konsignationslager und externes Lager anlegen
Given I open an editor "<lager>" from table "(Warehouse):(Warehouse)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "lgruppe" to id from editor "<lgruppe>"
And I save the current editor

Examples: Lager
| lager           | such   | namebspr           | lgruppe         |
| Konsignationsla | konsi  | Konsignationslager | Konsignationslg |
| Externesla      | extern | Externes Lager     | Externelg       |

Scenario Outline: STAMMDATEN - Konsignationslagerplatz und externen Lagerplatz anlegen
Given I open an editor "<lagerplatz>" from table "(Location):(Location)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "lager" to id from editor "<lager>"
And I set field "lgruppe" to id from editor "<lgruppe>"
And I save the current editor

Examples: Lagerplatz
| lagerplatz      | such   | namebspr            | lager           | lgruppe         |
| Konsignationslp | konsi  | Konsignationslager  | Konsignationsla | Konsignationslg |
| Externerlp      | extern | Externer Lagerplatz | Externesla      | Externelg       |

Scenario Outline: STAMMDATEN - Zusatzpositionen
# Zusatzpositionen
Given I open an editor "zusatzposition" from table "(Part):(SupplementaryItem)" with command "STORE" for record "<such2>"
And I set field "num2" to "<num2>"
And I set field "such" to "<such2>"
And I set field "namebspr" to "<namebspr>"
And I set field "zptyp" to "<zptyp>"
And I set field "kategorie" to "<kategorie>"
And I save the current editor

Examples:
 |num2         | such2          | namebspr                        |zptyp                          |kategorie      |
 |1-FALL-AS    | FALL-1-AS      | FALL-1 Absatz                   |Absatz                         |               |
 |1-FALL-ST    | FALL-1-ST      | FALL-1 Seite                    |Seite                          |               |
 |1-FALL-TP    | FALL-1-TP      | FALL-1 Trennposition            |Trennposition                  |               |


Scenario Outline: STAMMDATEN - Zusatzpositionen die nicht rechnungsrelevant bzw. lieferscheinrelevant sind
# Zusatzpositionen
Given I open an editor "zusatzposition" from table "(Part):(SupplementaryItem)" with command "STORE" for record "<such2>"
And I set field "num2" to "<num2>"
And I set field "such" to "<such2>"
And I set field "namebspr" to "<namebspr>"
And I set field "zptyp" to "<zptyp>"
And I set field "rerelev" to "<rerelev>"
And I set field "lirelev" to "<lirelev>"
And I set field "kategorie" to "<kategorie>"
And I save the current editor

Examples:
 |num2       | such2    | namebspr                | zptyp  | rerelev | lirelev | kategorie |
 |1-AS-NICHT | AS-NICHT | Absatz (nicht relevant) | Absatz | nein    | nein    |           |
 |1-ST-NICHT | ST-NICHT | Seite (nicht relevant)  | Seite  | nein    | nein    |           |

Scenario: VK Auftrag anlegen
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row 3
And I set field "mge" to "-10" in row 3
And I save the current editor

# VK Lieferschein erzeugen
Given I open an editor "vklieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag"
And I set field "ueb" to "ja"
Then the table has 2 rows
And I press button "offueb" in row 1
And I save the current editor

Scenario: VK-Lieferschein drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "vklieferschein"
And I press start
Then field "ans" has value "Bayram Fabrik GmbH"
Then field "str" has value "Schlossstr. 24-28"
Then field "plz" has value "76135"
Then field "nort" has value "Karlsruhe"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value "Bayram Werkzeugbau GmbH"
Then field "str2" has value "Riedstr. 24-28"
Then field "plz2" has value "76437"
Then field "nort2" has value "Rastatt"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Lieferschein"
Then field "buart2" has value "Lieferschein"
Then field "lakenn2" has value "D"
Then field "atext" has value "Vielen Dank für Ihre Bestellung. Wir liefern Ihnen wie vereinbart folgende Ware/n:"
Then field "etext" has value "Es gelten ausschließlich unsere allgemeinen Verkaufs- und Lieferbedingungen."
Then the table has 4 rows
Then field "mge" has value "10" in row 2
Then field "epreis" has value "5112.92" in row 2
Then field "gpreis" has value "51129.20" in row 2
Then field "mzda" has value "0" in row 2
Then field "artikelsuch" in row 2 has value equal to field "such" from editor "artikel1" in row 0
And I close the current editor

# VK-Lieferschein stornieren
Given I open an editor "stornovkls" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "vklieferschein"
And I save the current editor

Scenario: VK-Stornolieferschein drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "stornovkls"
And I press start
Then field "ans" has value "Bayram Fabrik GmbH"
Then field "str" has value "Schlossstr. 24-28"
Then field "plz" has value "76135"
Then field "nort" has value "Karlsruhe"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value "Bayram Werkzeugbau GmbH"
Then field "str2" has value "Riedstr. 24-28"
Then field "plz2" has value "76437"
Then field "nort2" has value "Rastatt"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" contains value "Storno zu Lieferschein Nr."
Then field "buart2" contains value "Storno zu Lieferschein Nr."
Then field "lakenn2" has value "D"
Then field "atext" is empty
Then field "etext" has value "Es gelten ausschließlich unsere allgemeinen Verkaufs- und Lieferbedingungen."
Then the table has 4 rows
Then field "mge" has value "10" in row 2
Then field "epreis" has value "5112.92" in row 2
Then field "gpreis" has value "51129.20" in row 2
Then field "mzda" has value "0" in row 2
Then field "artikelsuch" in row 2 has value equal to field "such" from editor "artikel1" in row 0
And I close the current editor

Scenario: Stornierter VK-Lieferschein drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "vklieferschein"
And I press start
Then field "ans" has value "Bayram Fabrik GmbH"
Then field "str" has value "Schlossstr. 24-28"
Then field "plz" has value "76135"
Then field "nort" has value "Karlsruhe"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value "Bayram Werkzeugbau GmbH"
Then field "str2" has value "Riedstr. 24-28"
Then field "plz2" has value "76437"
Then field "nort2" has value "Rastatt"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Lieferschein"
Then field "buart2" has value "Lieferschein"
Then field "lakenn2" has value "D"
Then field "atext" has value "Vielen Dank für Ihre Bestellung. Wir liefern Ihnen wie vereinbart folgende Ware/n:"
Then field "etext" has value "Es gelten ausschließlich unsere allgemeinen Verkaufs- und Lieferbedingungen."
Then the table has 4 rows
Then field "mge" has value "10" in row 2
Then field "epreis" has value "5112.92" in row 2
Then field "gpreis" has value "51129.20" in row 2
Then field "mzda" has value "0" in row 2
Then field "artikelsuch" in row 2 has value equal to field "such" from editor "artikel1" in row 0
And I close the current editor

# VK-Lieferschein erzeugen
Given I open an editor "LS100" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag"
And I set field "ueb" to "ja"
And I set field "such" to "LS100"
Then the table has 2 rows
And I press button "offueb" in row 1
And I save the current editor

# VK-Lieferschein rueckliefern
Given I open an editor "RLS100" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS100"
And I set field "ueb" to "ja"
And I set field "such" to "RLS100"
Then the table has 2 rows
And I press button "offueb" in row 1
And I save the current editor

Scenario: VK-Ruecklieferschein drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "RLS100"
And I press start
Then field "ans" has value "Bayram Fabrik GmbH"
Then field "str" has value "Schlossstr. 24-28"
Then field "plz" has value "76135"
Then field "nort" has value "Karlsruhe"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value "Bayram Werkzeugbau GmbH"
Then field "str2" has value "Riedstr. 24-28"
Then field "plz2" has value "76437"
Then field "nort2" has value "Rastatt"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Rücksendebestätigung"
Then field "buart2" has value "Rücksendebestätigung"
Then field "lakenn2" has value "D"
Then field "atext" has value "Wir haben Ihre Rücklieferung erhalten, die wir wie folgt bestätigen:"
Then field "etext" has value "Es gelten ausschließlich unsere allgemeinen Verkaufs- und Lieferbedingungen."
Then the table has 5 rows
Then field "textgrwechsel" contains value "Auftrag" in row 1
Then field "textgrwechsel" contains value "Lieferschein" in row 2
Then field "mge" has value "10" in row 3
Then field "epreis" has value "5112.92" in row 3
Then field "gpreis" has value "51129.20" in row 3
Then field "mzda" has value "1" in row 3
Then field "artikelsuch" in row 3 has value equal to field "such" from editor "artikel1" in row 0
And I close the current editor

# VK-Ruecklieferschen stornieren
Given I open an editor "stornovkrls" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS100"
And I save the current editor

Scenario: VK-Storno-Ruecklieferschein drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "stornovkrls"
And I press start
Then field "ans" has value "Bayram Fabrik GmbH"
Then field "str" has value "Schlossstr. 24-28"
Then field "plz" has value "76135"
Then field "nort" has value "Karlsruhe"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value "Bayram Werkzeugbau GmbH"
Then field "str2" has value "Riedstr. 24-28"
Then field "plz2" has value "76437"
Then field "nort2" has value "Rastatt"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" contains value "Storno zu Rücksendebestätigung Nr."
Then field "buart2" contains value "Storno zu Rücksendebestätigung Nr."
Then field "lakenn2" has value "D"
Then field "atext" is empty
Then field "etext" has value "Es gelten ausschließlich unsere allgemeinen Verkaufs- und Lieferbedingungen."
Then the table has 4 rows
Then field "textgrwechsel" contains value "Lieferschein" in row 1
Then field "mge" has value "10" in row 2
Then field "epreis" has value "5112.92" in row 2
Then field "gpreis" has value "51129.20" in row 2
Then field "mzda" has value "0" in row 2
Then field "artikelsuch" in row 2 has value equal to field "such" from editor "artikel1" in row 0
And I close the current editor

Scenario: Stornierter VK-Ruecklieferschein drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "RLS100"
And I press start
Then field "ans" has value "Bayram Fabrik GmbH"
Then field "str" has value "Schlossstr. 24-28"
Then field "plz" has value "76135"
Then field "nort" has value "Karlsruhe"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value "Bayram Werkzeugbau GmbH"
Then field "str2" has value "Riedstr. 24-28"
Then field "plz2" has value "76437"
Then field "nort2" has value "Rastatt"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Rücksendebestätigung"
Then field "buart2" has value "Rücksendebestätigung"
Then field "lakenn2" has value "D"
Then field "atext" has value "Wir haben Ihre Rücklieferung erhalten, die wir wie folgt bestätigen:"
Then field "etext" has value "Es gelten ausschließlich unsere allgemeinen Verkaufs- und Lieferbedingungen."
Then the table has 4 rows
Then field "mge" has value "10" in row 2
Then field "epreis" has value "5112.92" in row 2
Then field "gpreis" has value "-51129.20" in row 2
Then field "mzda" has value "0" in row 2
Then field "artikelsuch" in row 2 has value equal to field "such" from editor "artikel1" in row 0
And I close the current editor

# VK-Kundenanlieferung aus Auftrag erzeugen
Given I open an editor "kundenanlieferung" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "lsart" to "Kundenanlieferung"
And I set field "beleg" to id from editor "auftrag"
And I set field "ueb" to "ja"
Then the table has 2 rows
And I press button "offueb" in row 1
And I set field "platz" to id from editor "Konsignationslp" in row 1
And I save the current editor

Scenario: VK-Kundananlieferung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "kundenanlieferung"
And I press start
Then field "ans" has value "Bayram Fabrik GmbH"
Then field "str" has value "Schlossstr. 24-28"
Then field "plz" has value "76135"
Then field "nort" has value "Karlsruhe"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value "Bayram Werkzeugbau GmbH"
Then field "str2" has value "Riedstr. 24-28"
Then field "plz2" has value "76437"
Then field "nort2" has value "Rastatt"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Kundenanlieferung"
Then field "buart2" has value "Kundenanlieferung"
Then field "lakenn2" has value "D"
Then field "atext" has value "Vielen Dank für Ihre Anlieferung. Wir bestätigen Ihnen den Erhalt folgender Ware/n:"
Then field "etext" has value "Es gelten ausschließlich unsere allgemeinen Verkaufs- und Lieferbedingungen."
Then the table has 4 rows
Then field "mge" has value "10" in row 2
Then field "epreis" has value "4601.63" in row 2
Then field "gpreis" has value "-46016.30" in row 2
Then field "mzda" has value "0" in row 2
Then field "artikelsuch" in row 2 has value equal to field "such" from editor "artikel2" in row 0
And I close the current editor

# VK-Kundenanlieferung stornieren
Given I open an editor "stornoka" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "kundenanlieferung"
And I save the current editor

Scenario: VK-Storno-Kundenanlieferung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "stornoka"
And I press start
Then field "ans" has value "Bayram Fabrik GmbH"
Then field "str" has value "Schlossstr. 24-28"
Then field "plz" has value "76135"
Then field "nort" has value "Karlsruhe"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value "Bayram Werkzeugbau GmbH"
Then field "str2" has value "Riedstr. 24-28"
Then field "plz2" has value "76437"
Then field "nort2" has value "Rastatt"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" contains value "Storno zu Kundenanlieferung Nr."
Then field "buart2" contains value "Storno zu Kundenanlieferung Nr."
Then field "lakenn2" has value "D"
Then field "atext" is empty
Then field "etext" has value "Es gelten ausschließlich unsere allgemeinen Verkaufs- und Lieferbedingungen."
Then the table has 4 rows
Then field "mge" has value "10" in row 2
Then field "epreis" has value "4601.63" in row 2
Then field "gpreis" has value "46016.30" in row 2
Then field "mzda" has value "0" in row 2
Then field "artikelsuch" in row 2 has value equal to field "such" from editor "artikel2" in row 0
And I close the current editor

Scenario: Stornierte VK-Kundenanlieferung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "kundenanlieferung"
And I press start
Then field "ans" has value "Bayram Fabrik GmbH"
Then field "str" has value "Schlossstr. 24-28"
Then field "plz" has value "76135"
Then field "nort" has value "Karlsruhe"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value "Bayram Werkzeugbau GmbH"
Then field "str2" has value "Riedstr. 24-28"
Then field "plz2" has value "76437"
Then field "nort2" has value "Rastatt"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Kundenanlieferung"
Then field "buart2" has value "Kundenanlieferung"
Then field "lakenn2" has value "D"
Then field "atext" has value "Vielen Dank für Ihre Anlieferung. Wir bestätigen Ihnen den Erhalt folgender Ware/n:"
Then field "etext" has value "Es gelten ausschließlich unsere allgemeinen Verkaufs- und Lieferbedingungen."
Then the table has 4 rows
Then field "mge" has value "10" in row 2
Then field "epreis" has value "4601.63" in row 2
Then field "gpreis" has value "-46016.30" in row 2
Then field "mzda" has value "0" in row 2
Then field "artikelsuch" in row 2 has value equal to field "such" from editor "artikel2" in row 0
And I close the current editor

# VK-Rechnung erzeugen
Given I open an editor "vkrechnung-1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS100"
Then the table has 2 rows
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# VK-Rechnung: Zusatzposition hinzufuegen: es darf keine Endsumme danach kommen.
Given I open an editor "vkrechnung-1" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "vkrechnung-1"
Then the table has 5 rows
And I create a new row at the end of the table
And I set field "artex" to "1-FALL-AS" in row !lastRow
And I save the current editor

Given I open an editor "vkrechnung-1" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "vkrechnung-1"
Then the table has 6 rows
And I create a new row at the end of the table
And I set field "artex" to "1-FALL-ST" in row !lastRow
And I save the current editor

Given I open an editor "vkrechnung-1" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "vkrechnung-1"
Then the table has 7 rows
And I create a new row at the end of the table
And I set field "artex" to "1-FALL-TP" in row !lastRow
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "vkrechnung-1"
And I close the current editor

Given I open an editor "vkrechnung-1" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "vkrechnung-1"
Then the table has 8 rows
And I delete row at position !lastRow
And I delete row at position !lastRow
And I delete row at position !lastRow
And I set field "ueb" to "ja"
And I save the current editor

Scenario: VK-Rechnung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "vkrechnung-1"
And I press start
Then field "ans" has value "Bayram Werkzeugbau GmbH"
Then field "str" has value "Riedstr. 24-28"
Then field "plz" has value "76437"
Then field "nort" has value "Rastatt"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value "Bayram Fabrik GmbH"
Then field "str2" has value "Schlossstr. 24-28"
Then field "plz2" has value "76135"
Then field "nort2" has value "Karlsruhe"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Rechnung"
Then field "buart2" has value "Rechnung"
Then field "lakenn2" has value "D"
Then field "atext" has value "Wir bedanken uns für die gute Zusammenarbeit und stellen Ihnen vereinbarungsgemäß folgende Lieferungen und Leistungen in Rechnung:"
Then field "etext" has value "Es gelten ausschließlich unsere allgemeinen Verkaufs- und Lieferbedingungen."
Then the table has 9 rows
Then field "textgrwechsel" contains value "Auftragsbestätigung" in row 1
Then field "textgrwechsel" contains value "Lieferschein" in row 2
Then field "mge" has value "10" in row 3
Then field "epreis" has value "5112.92" in row 3
Then field "gpreis" has value "51129.20" in row 3
Then field "mzda" has value "0" in row 3
Then field "artikelsuch" in row 3 has value equal to field "such" from editor "artikel1" in row 0
And I close the current editor

# VK-Rechnung stornieren
Given I open an editor "stornovkre" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "vkrechnung-1"
And I save the current editor

Scenario: VK-Storno-Rechnung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "stornovkre"
And I press start
Then field "ans" has value "Bayram Werkzeugbau GmbH"
Then field "str" has value "Riedstr. 24-28"
Then field "plz" has value "76437"
Then field "nort" has value "Rastatt"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value "Bayram Fabrik GmbH"
Then field "str2" has value "Schlossstr. 24-28"
Then field "plz2" has value "76135"
Then field "nort2" has value "Karlsruhe"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" contains value "Storno zu Rechnung Nr."
Then field "buart2" contains value "Storno zu Rechnung Nr."
Then field "lakenn2" has value "D"
Then field "atext" contains value "Wir schreiben Ihnen folgenden Betrag aus Rechnung"
Then field "etext" has value "Es gelten ausschließlich unsere allgemeinen Verkaufs- und Lieferbedingungen."
Then the table has 9 rows
Then field "textgrwechsel" contains value "Auftragsbestätigung" in row 1
Then field "textgrwechsel" contains value "Lieferschein" in row 2
Then field "mge" has value "10" in row 3
Then field "epreis" has value "-5112.92" in row 3
Then field "gpreis" has value "-51129.20" in row 3
Then field "mzda" has value "0" in row 3
Then field "artikelsuch" in row 3 has value equal to field "such" from editor "artikel1" in row 0
# Steuerposition
Then field "artikelsuch" has value "ST." in row 6
Then field "epreis" has value "-51180.30" in row 6
And I close the current editor

Scenario: Stornierte VK-Rechnung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "vkrechnung-1"
And I press start
Then field "ans" has value "Bayram Werkzeugbau GmbH"
Then field "str" has value "Riedstr. 24-28"
Then field "plz" has value "76437"
Then field "nort" has value "Rastatt"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value "Bayram Fabrik GmbH"
Then field "str2" has value "Schlossstr. 24-28"
Then field "plz2" has value "76135"
Then field "nort2" has value "Karlsruhe"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Rechnung"
Then field "buart2" has value "Rechnung"
Then field "lakenn2" has value "D"
Then field "atext" has value "Wir bedanken uns für die gute Zusammenarbeit und stellen Ihnen vereinbarungsgemäß folgende Lieferungen und Leistungen in Rechnung:"
Then field "etext" has value "Es gelten ausschließlich unsere allgemeinen Verkaufs- und Lieferbedingungen."
Then the table has 9 rows
Then field "textgrwechsel" contains value "Auftragsbestätigung" in row 1
Then field "textgrwechsel" contains value "Lieferschein" in row 2
Then field "mge" has value "10" in row 3
Then field "epreis" has value "5112.92" in row 3
Then field "gpreis" has value "51129.20" in row 3
Then field "mzda" has value "0" in row 3
Then field "artikelsuch" in row 3 has value equal to field "such" from editor "artikel1" in row 0
And I close the current editor

# Auftrag mit Fakturaplan anlegen
Given I open an editor "AU102" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "AU102"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row 3
And I set field "mge" to "10" in row 3
And I save the current editor

# Fakturaplan anlegen und Anzahlungsrechnung buchen
Given I open an editor "fakturaplan" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "AU102"
And I create a new row at the end of the table
And I set field "reart" to "Anzahlung" in row 1
And I set field "proz" to "10" in row 1
And I press button "anzahlungsrechn" to open a subeditor for "REA102A" in row 1
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "fakturaplan"
And I save the current editor

Scenario: VK-Anzahlungsrechnung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "REA102A"
And I press start
Then field "ans" has value "Bayram Werkzeugbau GmbH"
Then field "str" has value "Riedstr. 24-28"
Then field "plz" has value "76437"
Then field "nort" has value "Rastatt"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value "Bayram Fabrik GmbH"
Then field "str2" has value "Schlossstr. 24-28"
Then field "plz2" has value "76135"
Then field "nort2" has value "Karlsruhe"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Anzahlungsrechnung"
Then field "buart2" has value "Anzahlungsrechnung"
Then field "lakenn2" has value "D"
Then field "atext" has value "Vereinbarungsgemäß berechnen wir die Anzahlung wie folgt:"
Then field "etext" has value "Es gelten ausschließlich unsere allgemeinen Verkaufs- und Lieferbedingungen."
Then the table has 7 rows
Then field "textgrwechsel" contains value "Auftragsbestätigung" in row 1
Then field "mge" is empty in row 2
Then field "epreis" is empty in row 2
Then field "gpreis" has value "9724.77" in row 2
Then field "mzda" has value "0" in row 2
Then field "artikelsuch" in row 2 has value equal to field "artikel" from editor "REA102A" in row 1
And I close the current editor

# VK-Barrechnung erstellen und buchen
Given I open an editor "RE101" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "RE101"
And I set field "vorganga" to "Barzahlung"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row 3
And I set field "mge" to "10" in row 3
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: VK-Barrechnung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "RE101"
And I press start
Then field "ans" has value "Bayram Werkzeugbau GmbH"
Then field "str" has value "Riedstr. 24-28"
Then field "plz" has value "76437"
Then field "nort" has value "Rastatt"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value "Bayram Fabrik GmbH"
Then field "str2" has value "Schlossstr. 24-28"
Then field "plz2" has value "76135"
Then field "nort2" has value "Karlsruhe"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Rechnung"
Then field "buart2" has value "Rechnung"
Then field "lakenn2" has value "D"
Then field "atext" has value "Wir bedanken uns für die gute Zusammenarbeit und stellen Ihnen vereinbarungsgemäß folgende Lieferungen und Leistungen in Rechnung:"
Then field "etext" has value "Es gelten ausschließlich unsere allgemeinen Verkaufs- und Lieferbedingungen."
Then the table has 9 rows
Then field "textgrwechsel" is empty in row 1
Then field "textgrwechsel" is empty in row 2
Then field "mge" has value "10" in row 1
Then field "epreis" has value "5112.92" in row 1
Then field "gpreis" has value "51129.20" in row 1
Then field "mzda" has value "0" in row 1
Then field "artikelsuch" in row 1 has value equal to field "such" from editor "artikel1" in row 0
And I close the current editor

# VK-Barrechnung stornieren
Given I open an editor "stornovkrls" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE101"
And I save the current editor

Scenario: VK-Storno-Barrechnung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "stornovkrls"
And I press start
Then field "ans" has value "Bayram Werkzeugbau GmbH"
Then field "str" has value "Riedstr. 24-28"
Then field "plz" has value "76437"
Then field "nort" has value "Rastatt"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value "Bayram Fabrik GmbH"
Then field "str2" has value "Schlossstr. 24-28"
Then field "plz2" has value "76135"
Then field "nort2" has value "Karlsruhe"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" contains value "Storno zu Rechnung Nr."
Then field "buart2" contains value "Storno zu Rechnung Nr."
Then field "lakenn2" has value "D"
Then field "atext" contains value "Wir schreiben Ihnen folgenden Betrag aus Rechnung"
Then field "etext" has value "Es gelten ausschließlich unsere allgemeinen Verkaufs- und Lieferbedingungen."
Then the table has 9 rows
Then field "textgrwechsel" is empty in row 1
Then field "textgrwechsel" is empty in row 2
# Artikel1
Then field "mge" has value "10" in row 1
Then field "epreis" has value "-5112.92" in row 1
Then field "gpreis" has value "-51129.20" in row 1
Then field "mzda" has value "0" in row 1
Then field "artikelsuch" in row 1 has value equal to field "such" from editor "artikel1" in row 0
# Zeile mit Materialzuschlag
Then field "artikelsuch" has value "MATZU" in row 2
Then field "mge" has value "10" in row 2
Then field "epreis" has value "-5.11" in row 2
Then field "gpreis" has value "-51.10" in row 2
# Artikel2
Then field "mge" has value "10" in row 3
Then field "epreis" has value "-4601.63" in row 3
Then field "gpreis" has value "-46016.30" in row 3
Then field "mzda" has value "0" in row 3
Then field "artikelsuch" in row 3 has value equal to field "such" from editor "artikel2" in row 0
# Zeile mit Materialzuschlag
Then field "artikelsuch" has value "MATZU" in row 4
Then field "mge" has value "10" in row 4
Then field "epreis" has value "-5.11" in row 4
Then field "gpreis" has value "-51.10" in row 4
# Steurpos
Then field "epreis" has value "-97247.70" in row 6
Then field "gpreis" has value "-14587.16" in row 6
Then field "artikelsuch" has value "ST." in row 6
And I close the current editor

Scenario: Stornierte VK-Barrechnung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "RE101"
And I press start
Then field "ans" has value "Bayram Werkzeugbau GmbH"
Then field "str" has value "Riedstr. 24-28"
Then field "plz" has value "76437"
Then field "nort" has value "Rastatt"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value "Bayram Fabrik GmbH"
Then field "str2" has value "Schlossstr. 24-28"
Then field "plz2" has value "76135"
Then field "nort2" has value "Karlsruhe"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Rechnung"
Then field "buart2" has value "Rechnung"
Then field "lakenn2" has value "D"
Then field "atext" has value "Wir bedanken uns für die gute Zusammenarbeit und stellen Ihnen vereinbarungsgemäß folgende Lieferungen und Leistungen in Rechnung:"
Then field "etext" has value "Es gelten ausschließlich unsere allgemeinen Verkaufs- und Lieferbedingungen."
Then the table has 9 rows
Then field "textgrwechsel" is empty in row 1
Then field "textgrwechsel" is empty in row 2
Then field "mge" has value "10" in row 1
Then field "epreis" has value "5112.92" in row 1
Then field "gpreis" has value "51129.20" in row 1
Then field "mzda" has value "0" in row 1
Then field "artikelsuch" in row 1 has value equal to field "such" from editor "artikel1" in row 0
And I close the current editor

# VK-Kundenanlieferung erstellen und buchen
Given I open an editor "LKS101" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "lsart" to "Kundenanlieferung"
And I set field "beleg" to id from editor "auftrag"
And I set field "such" to "LKS101"
And I set field "ueb" to "ja"
Then the table has 2 rows
And I press button "offueb" in row 1
And I set field "platz" to id from editor "Konsignationslp" in row 1
And I save the current editor

# Kaufmännische VK-Gutschrift aus Kundenanlieferung erstellen
Given I open an editor "KGS101" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LKS101"
And I set field "such" to "KGS101"
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I set field "ueb" to "ja"
Then the table has 2 rows
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: Kaufmaennische VK-Gutschrift drucken aus Kundenanlieferung
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "KGS101"
And I press start
Then field "ans" has value "Bayram Werkzeugbau GmbH"
Then field "str" has value "Riedstr. 24-28"
Then field "plz" has value "76437"
Then field "nort" has value "Rastatt"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value "Bayram Fabrik GmbH"
Then field "str2" has value "Schlossstr. 24-28"
Then field "plz2" has value "76135"
Then field "nort2" has value "Karlsruhe"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Kaufmännische Gutschrift"
Then field "buart2" has value "Kaufmännische Gutschrift"
Then field "lakenn2" has value "D"
Then field "atext" has value "Folgende Beträge schreiben wir Ihnen gut:"
Then field "etext" has value "Es gelten ausschließlich unsere allgemeinen Verkaufs- und Lieferbedingungen."
Then the table has 9 rows
Then field "textgrwechsel" contains value "Auftragsbestätigung" in row 1
Then field "textgrwechsel" contains value "Kundenanlieferung" in row 2
Then field "mge" has value "10" in row 3
Then field "epreis" has value "-4601.63" in row 3
Then field "gpreis" has value "-46016.30" in row 3
Then field "mzda" has value "0" in row 3
Then field "artikelsuch" in row 3 has value equal to field "such" from editor "artikel2" in row 0
# Zeile mit Materialzuschlag
Then field "vktypa" has value "Materialzuschlag" in row 4
Then field "artikelsuch" has value "MATZU" in row 4
Then field "mge" has value "10" in row 4
Then field "epreis" has value "-5.11" in row 4
Then field "ebetragnet" has value "-5.110000000" in row 4
Then field "bdel" has value "ja" in row 4
Then field "gpreis" has value "-51.10" in row 4
# Steurpos
Then field "artikelsuch" has value "ST." in row 6
Then field "epreis" has value "-46067.40" in row 6
Then field "gpreis" has value "-6910.11" in row 6
And I close the current editor

# Kaufmännische VK-Gutschrift stornieren
Given I open an editor "stornovkrls" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "KGS101"
And I save the current editor

Scenario: Storno kaufmaennische VK-Gutschrift drucken aus Kundenanlieferung
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "stornovkrls"
And I press start
Then field "ans" has value "Bayram Werkzeugbau GmbH"
Then field "str" has value "Riedstr. 24-28"
Then field "plz" has value "76437"
Then field "nort" has value "Rastatt"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value "Bayram Fabrik GmbH"
Then field "str2" has value "Schlossstr. 24-28"
Then field "plz2" has value "76135"
Then field "nort2" has value "Karlsruhe"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" contains value "Storno zu Kaufmännischer Gutschrift Nr."
Then field "buart2" contains value "Storno zu Kaufmännischer Gutschrift Nr."
Then field "lakenn2" has value "D"
Then field "atext" is empty
Then field "etext" has value "Es gelten ausschließlich unsere allgemeinen Verkaufs- und Lieferbedingungen."
Then the table has 9 rows
Then field "textgrwechsel" contains value "Auftragsbestätigung" in row 1
Then field "textgrwechsel" contains value "Kundenanlieferung" in row 2
Then field "mge" has value "10" in row 3
Then field "epreis" has value "4601.63" in row 3
Then field "gpreis" has value "46016.30" in row 3
Then field "mzda" has value "0" in row 3
Then field "artikelsuch" in row 3 has value equal to field "such" from editor "artikel2" in row 0
# Materialzuschlag
Then field "epreis" has value "5.11" in row 4
Then field "gpreis" has value "51.10" in row 4
Then field "artikelsuch" has value "MATZU" in row 4
# Steuerpos
Then field "epreis" has value "46067.40" in row 6
Then field "gpreis" has value "6910.11" in row 6
Then field "artikelsuch" has value "ST." in row 6
And I close the current editor

Scenario: Stornierte kaufmaennische VK-Gutschrift drucken aus Kundenanlieferung
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "KGS101"
And I press start
Then field "ans" has value "Bayram Werkzeugbau GmbH"
Then field "str" has value "Riedstr. 24-28"
Then field "plz" has value "76437"
Then field "nort" has value "Rastatt"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value "Bayram Fabrik GmbH"
Then field "str2" has value "Schlossstr. 24-28"
Then field "plz2" has value "76135"
Then field "nort2" has value "Karlsruhe"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Kaufmännische Gutschrift"
Then field "buart2" has value "Kaufmännische Gutschrift"
Then field "lakenn2" has value "D"
Then field "atext" has value "Folgende Beträge schreiben wir Ihnen gut:"
Then field "etext" has value "Es gelten ausschließlich unsere allgemeinen Verkaufs- und Lieferbedingungen."
Then the table has 9 rows
Then field "textgrwechsel" contains value "Auftragsbestätigung" in row 1
Then field "textgrwechsel" contains value "Kundenanlieferung" in row 2
Then field "mge" has value "10" in row 3
Then field "epreis" has value "-4601.63" in row 3
Then field "gpreis" has value "-46016.30" in row 3
Then field "mzda" has value "0" in row 3
Then field "artikelsuch" in row 3 has value equal to field "such" from editor "artikel2" in row 0
# Materialzuschlag
Then field "epreis" has value "-5.11" in row 4
Then field "gpreis" has value "-51.10" in row 4
Then field "artikelsuch" has value "MATZU" in row 4
Then field "vktyp" has value "14" in row 4
# Steuerpos
Then field "epreis" has value "-46067.40" in row 6
Then field "gpreis" has value "-6910.11" in row 6
Then field "artikelsuch" has value "ST." in row 6
And I close the current editor

# VK-Lieferschein aus Auftrag mit Fakturaplan anlegen
Given I open an editor "vklieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU102"
And I set field "ueb" to "ja"
Then the table has 4 rows
And I press button "offueb" in row 1
And I save the current editor

# LS berrechnen, damit kauf. GS moeglich ist
Given I open an editor "rechtemp" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "vklieferschein"
And I set field "such" to "RETEMP"
And I set field "ueb" to "ja"
# Nur die erste Pos berechnen
And I delete row at position 3
And I delete row at position 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# VK-Lieferschein Teil-rueckliefern
Given I open an editor "RLS001" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "vklieferschein"
And I set field "such" to "RLS001"
And I set field "ueb" to "ja"
Then the table has 2 rows
And I set field "mge" to "-5" in row 1
And I save the current editor

# Kaufmaennische VK-Gutschrift aus VK-Ruecklieferschein erstellen
Given I open an editor "kaufmgut" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS001"
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I set field "such" to "KGS001"
And I set field "ueb" to "ja"
Then the table has 3 rows
Then field "mge" has value "-5" in row 1
And I delete row at position 3
And I delete row at position 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario: Kaufmaennische VK-Gutschrift drucken aus Ruecknahmeschein
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "kaufmgut"
And I press start
Then field "ans" has value "Bayram Werkzeugbau GmbH"
Then field "str" has value "Riedstr. 24-28"
Then field "plz" has value "76437"
Then field "nort" has value "Rastatt"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value "Bayram Fabrik GmbH"
Then field "str2" has value "Schlossstr. 24-28"
Then field "plz2" has value "76135"
Then field "nort2" has value "Karlsruhe"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Kaufmännische Gutschrift"
Then field "buart2" has value "Kaufmännische Gutschrift"
Then field "lakenn2" has value "D"
Then field "atext" has value "Folgende Beträge schreiben wir Ihnen gut:"
Then field "etext" has value "Es gelten ausschließlich unsere allgemeinen Verkaufs- und Lieferbedingungen."
Then the table has 9 rows
Then field "textgrwechsel" contains value "Auftragsbestätigung" in row 1
Then field "textgrwechsel" contains value "Lieferschein" in row 2
Then field "textgrwechsel" contains value "Rücknahmeschein" in row 3
Then field "mge" has value "5" in row 4
Then field "epreis" has value "-5112.92" in row 4
Then field "gpreis" has value "-25564.60" in row 4
Then field "mzda" has value "0" in row 4
Then field "artikelsuch" in row 4 has value equal to field "such" from editor "artikel1" in row 0
# Keine Zeile mit Materialzuschlag
#
Then field "artikelsuch" has value "NS." in row 5
# Steurpos
Then field "artikelsuch" has value "ST." in row 6
Then field "epreis" has value "-25564.60" in row 6
Then field "gpreis" has value "-3834.69" in row 6
And I close the current editor

# Kaufmaennische VK-Gutschrift stornieren
Given I open an editor "stornovkkm" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "kaufmgut"
And I save the current editor

Scenario: Storno Kaufmaennische VK-Gutschrift drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "stornovkkm"
And I press start
Then field "ans" has value "Bayram Werkzeugbau GmbH"
Then field "str" has value "Riedstr. 24-28"
Then field "plz" has value "76437"
Then field "nort" has value "Rastatt"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value "Bayram Fabrik GmbH"
Then field "str2" has value "Schlossstr. 24-28"
Then field "plz2" has value "76135"
Then field "nort2" has value "Karlsruhe"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" contains value "Storno zu Kaufmännischer Gutschrift Nr."
Then field "buart2" contains value "Storno zu Kaufmännischer Gutschrift Nr."
Then field "lakenn2" has value "D"
Then field "atext" is empty
Then field "etext" has value "Es gelten ausschließlich unsere allgemeinen Verkaufs- und Lieferbedingungen."
Then the table has 9 rows
Then field "textgrwechsel" contains value "Auftragsbestätigung" in row 1
Then field "textgrwechsel" contains value "Lieferschein" in row 2
Then field "textgrwechsel" contains value "Rücknahmeschein" in row 3
Then field "mge" has value "5" in row 4
Then field "epreis" has value "5112.92" in row 4
Then field "gpreis" has value "25564.60" in row 4
Then field "mzda" has value "0" in row 4
Then field "artikelsuch" in row 4 has value equal to field "such" from editor "artikel1" in row 0
Then field "artikelsuch" has value "NS." in row 5
Then field "artikelsuch" has value "ST." in row 6
Then field "epreis" has value "25564.60" in row 6
Then field "gpreis" has value "3834.69" in row 6
And I close the current editor

Scenario: Stornierte kaufmaennische VK-Gutschrift drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "kaufmgut"
And I press start
Then field "ans" has value "Bayram Werkzeugbau GmbH"
Then field "str" has value "Riedstr. 24-28"
Then field "plz" has value "76437"
Then field "nort" has value "Rastatt"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value "Bayram Fabrik GmbH"
Then field "str2" has value "Schlossstr. 24-28"
Then field "plz2" has value "76135"
Then field "nort2" has value "Karlsruhe"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Kaufmännische Gutschrift"
Then field "buart2" has value "Kaufmännische Gutschrift"
Then field "lakenn2" has value "D"
Then field "atext" has value "Folgende Beträge schreiben wir Ihnen gut:"
Then field "etext" has value "Es gelten ausschließlich unsere allgemeinen Verkaufs- und Lieferbedingungen."
Then the table has 9 rows
Then field "textgrwechsel" contains value "Auftragsbestätigung" in row 1
Then field "textgrwechsel" contains value "Lieferschein" in row 2
Then field "textgrwechsel" contains value "Rücknahmeschein" in row 3
Then field "mge" has value "5" in row 4
Then field "epreis" has value "-5112.92" in row 4
Then field "gpreis" has value "-25564.60" in row 4
Then field "mzda" has value "0" in row 4
Then field "artikelsuch" in row 4 has value equal to field "such" from editor "artikel1" in row 0
And I close the current editor

# Einkauf

# EK-Bestellung anlegen
Given I open an editor "bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to id from editor "lieferant"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row 3
And I set field "mge" to "10" in row 3
And I save the current editor

# EK-Lieferschein erzeugen
Given I open an editor "eklieferschein" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung"
And I set field "ebeleg" to "123"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 4 rows
And I press button "offueb" in row 1
And I press button "offueb" in row 3
And I save the current editor

Scenario: EK-Lieferschein drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "eklieferschein"
And I press start
Then field "ans" is empty
Then field "str" has value "INTERN"
Then field "plz" is empty
Then field "nort" is empty
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" is empty
Then field "ans2" has value "Reus Fussball GmbH"
Then field "str2" has value "Bvbstr. 24-28"
Then field "plz2" has value "33333"
Then field "nort2" has value "Dortmund"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Lieferschein"
Then field "buart2" has value "Lieferschein"
Then field "lakenn2" has value "D"
Then field "atext" is empty
Then field "etext" is empty
Then the table has 5 rows
Then field "textgrwechsel" contains value "Bestellung" in row 1
Then field "mge" has value "10" in row 2
Then field "epreis" has value "9000.00" in row 2
Then field "gpreis" has value "90000.00" in row 2
Then field "mzda" has value "0" in row 2
Then field "artikelsuch" in row 2 has value equal to field "such" from editor "artikel1" in row 0
Then field "mge" has value "10" in row 3
Then field "epreis" has value "7000.00" in row 3
Then field "gpreis" has value "70000.00" in row 3
Then field "mzda" has value "0" in row 3
Then field "artikelsuch" in row 3 has value equal to field "such" from editor "artikel2" in row 0
And I close the current editor

# EK-Lieferschein stornieren
Given I open an editor "stornoekls" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "eklieferschein"
And I save the current editor

Scenario: EK-Storno-Lieferschein drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "stornoekls"
And I press start
Then field "ans" is empty
Then field "str" has value "INTERN"
Then field "plz" is empty
Then field "nort" is empty
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" is empty
Then field "ans2" has value "Reus Fussball GmbH"
Then field "str2" has value "Bvbstr. 24-28"
Then field "plz2" has value "33333"
Then field "nort2" has value "Dortmund"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" contains value "Storno zu Lieferschein Nr."
Then field "buart2" contains value "Storno zu Lieferschein Nr."
Then field "lakenn2" has value "D"
Then field "atext" is empty
Then field "etext" is empty
Then the table has 5 rows
Then field "textgrwechsel" contains value "Bestellung" in row 1
Then field "mge" has value "10" in row 2
Then field "epreis" has value "9000.00" in row 2
Then field "gpreis" has value "90000.00" in row 2
Then field "mzda" has value "0" in row 2
Then field "artikelsuch" in row 2 has value equal to field "such" from editor "artikel1" in row 0
Then field "mge" has value "10" in row 3
Then field "epreis" has value "7000.00" in row 3
Then field "gpreis" has value "70000.00" in row 3
Then field "mzda" has value "0" in row 3
Then field "artikelsuch" in row 3 has value equal to field "such" from editor "artikel2" in row 0
And I close the current editor

Scenario: Stornierter EK-Lieferschein drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "eklieferschein"
And I press start
Then field "ans" is empty
Then field "str" has value "INTERN"
Then field "plz" is empty
Then field "nort" is empty
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" is empty
Then field "ans2" has value "Reus Fussball GmbH"
Then field "str2" has value "Bvbstr. 24-28"
Then field "plz2" has value "33333"
Then field "nort2" has value "Dortmund"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Lieferschein"
Then field "buart2" has value "Lieferschein"
Then field "lakenn2" has value "D"
Then field "atext" is empty
Then field "etext" is empty
Then the table has 5 rows
Then field "textgrwechsel" contains value "Bestellung" in row 1
Then field "mge" has value "10" in row 2
Then field "epreis" has value "9000.00" in row 2
Then field "gpreis" has value "90000.00" in row 2
Then field "mzda" has value "0" in row 2
Then field "artikelsuch" in row 2 has value equal to field "such" from editor "artikel1" in row 0
Then field "mge" has value "10" in row 3
Then field "epreis" has value "7000.00" in row 3
Then field "gpreis" has value "70000.00" in row 3
Then field "mzda" has value "0" in row 3
Then field "artikelsuch" in row 3 has value equal to field "such" from editor "artikel2" in row 0
And I close the current editor

# EK-Lieferschein erzeugen
Given I open an editor "eklieferschein" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung"
And I set field "ebeleg" to "123"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 4 rows
And I press button "offueb" in row 1
And I press button "offueb" in row 3
And I save the current editor

# Rechnung zu LS erzeugen, sonst ist keine KGS moeglich
Given I open an editor "ekrechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "eklieferschein"
And I set field "ebeleg" to "444"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "term" to "."
And I set field "such" to "EKRECH1"
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# EK-Lieferschein rueckliefern
Given I open an editor "ekrueckls" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "eklieferschein"
And I set field "ebeleg" to "456"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 4 rows
And I press button "offueb" in row 3
And I save the current editor

Scenario: EK-Ruecklieferschein drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "ekrueckls"
And I press start
Then field "ans" has value "Reus Fussball GmbH"
Then field "str" has value "Bvbstr. 24-28"
Then field "plz" has value "33333"
Then field "nort" has value "Dortmund"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value ""
Then field "str2" has value ""
Then field "plz2" has value ""
Then field "nort2" has value ""
Then field "staat2" has value ""
Then field "buart" has value "Rücklieferschein"
Then field "buart2" has value "Rücklieferschein"
Then field "lakenn2" has value ""
Then field "atext" has value "Wir senden Ihnen folgende Ware/n zurück:"
Then field "etext" is empty
Then the table has 5 rows
Then field "textgrwechsel" contains value "Bestellung 600001 vom 02.01.1995" in row 1
Then field "textgrwechsel" contains value "Lieferschein 123" in row 2
Then field "mge" has value "10" in row 3
Then field "epreis" has value "7000.00" in row 3
Then field "gpreis" has value "70000.00" in row 3
Then field "mzda" has value "1" in row 3
Then field "artikelsuch" in row 3 has value equal to field "such" from editor "artikel2" in row 0
And I close the current editor

# EK-Ruecklieferschein stornieren
Given I open an editor "stornoekrls" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "ekrueckls"
And I save the current editor

Scenario: Storno EK-Ruecklieferschein drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "stornoekrls"
And I press start
Then field "ans" has value "Reus Fussball GmbH"
Then field "str" has value "Bvbstr. 24-28"
Then field "plz" has value "33333"
Then field "nort" has value "Dortmund"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value ""
Then field "str2" has value ""
Then field "plz2" has value ""
Then field "nort2" has value ""
Then field "staat2" has value ""
Then field "buart" contains value "Storno zu Rücklieferschein Nr."
Then field "buart2" contains value "Storno zu Rücklieferschein Nr."
Then field "lakenn2" has value ""
Then field "atext" has value "Wir senden Ihnen folgende Ware/n zurück:"
Then field "etext" is empty
Then the table has 4 rows
Then field "textgrwechsel" contains value "Lieferschein 123" in row 1
Then field "mge" has value "10" in row 2
Then field "epreis" has value "7000.00" in row 2
Then field "gpreis" has value "70000.00" in row 2
Then field "mzda" has value "1" in row 2
Then field "artikelsuch" in row 2 has value equal to field "such" from editor "artikel2" in row 0
And I close the current editor

Scenario: Stornierten EK-Rückieferschein drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "ekrueckls"
And I press start
Then field "ans" has value "Reus Fussball GmbH"
Then field "str" has value "Bvbstr. 24-28"
Then field "plz" has value "33333"
Then field "nort" has value "Dortmund"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value ""
Then field "str2" has value ""
Then field "plz2" has value ""
Then field "nort2" has value ""
Then field "staat2" has value ""
Then field "buart" has value "Rücklieferschein"
Then field "buart2" has value "Rücklieferschein"
Then field "lakenn2" has value ""
Then field "atext" has value "Wir senden Ihnen folgende Ware/n zurück:"
Then field "etext" is empty
Then the table has 4 rows
Then field "textgrwechsel" contains value "Lieferschein 123" in row 1
Then field "mge" has value "10" in row 2
Then field "epreis" has value "7000.00" in row 2
Then field "gpreis" has value "70000.00" in row 2
Then field "mzda" has value "1" in row 2
Then field "artikelsuch" in row 2 has value equal to field "such" from editor "artikel2" in row 0
And I close the current editor

# EK-Lieferschein nochmals rückliefern und EK-Kaufmännische Gutschrift anlegen
Given I open an editor "ekrueckls" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "eklieferschein"
And I set field "ebeleg" to "456"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 4 rows
And I press button "offueb" in row 3
And I save the current editor

# Kaufmännische EK-Gutschrift anlegen
Given I open an editor "ekkaufmgut" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ekrueckls"
And I set field "ebeleg" to "789"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 2 rows
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: Kaufmännische EK-Gutschrift drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "ekkaufmgut"
And I press start
Then field "ans" is empty
Then field "str" has value "INTERN"
Then field "plz" is empty
Then field "nort" is empty
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" is empty
Then field "ans2" has value "Reus Werkzeugbau GmbH"
Then field "str2" has value "Riedstr. 24-28"
Then field "plz2" has value "76437"
Then field "nort2" has value "Rastatt"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Kaufmännische Gutschrift"
Then field "buart2" has value "Kaufmännische Gutschrift"
Then field "lakenn2" has value "D"
Then field "atext" is empty
Then field "etext" is empty
Then the table has 10 rows
Then field "textgrwechsel" contains value "Bestellung" in row 1
Then field "textgrwechsel" contains value "Lieferschein 123" in row 2
Then field "textgrwechsel" contains value "Rücklieferschein 6" in row 3
Then field "mge" has value "10" in row 4
Then field "epreis" has value "-7000.00" in row 4
Then field "gpreis" has value "-70000.00" in row 4
Then field "mzda" has value "1" in row 4
Then field "artikelsuch" in row 4 has value equal to field "such" from editor "artikel2" in row 0
And I close the current editor

# Kaufmaennische EK-Gutschrift stornieren
Given I open an editor "stornoekkaufmgut" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "ekkaufmgut"
And I save the current editor

Scenario: Storno kaufmaennische EK-Gutschrift drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "stornoekkaufmgut"
And I press start
Then field "ans" is empty
Then field "str" has value "INTERN"
Then field "plz" is empty
Then field "nort" is empty
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" is empty
Then field "ans2" has value "Reus Werkzeugbau GmbH"
Then field "str2" has value "Riedstr. 24-28"
Then field "plz2" has value "76437"
Then field "nort2" has value "Rastatt"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" contains value "Storno zu Kaufmännischer Gutschrift Nr."
Then field "buart2" contains value "Storno zu Kaufmännischer Gutschrift Nr."
Then field "lakenn2" has value "D"
Then field "atext" is empty
Then field "etext" is empty
Then the table has 10 rows
Then field "textgrwechsel" contains value "Bestellung" in row 1
Then field "textgrwechsel" contains value "Lieferschein 123" in row 2
Then field "textgrwechsel" contains value "Rücklieferschein 6" in row 3
Then field "mge" has value "10" in row 4
Then field "epreis" has value "7000.00" in row 4
Then field "gpreis" has value "70000.00" in row 4
Then field "mzda" has value "0" in row 4
Then field "artikelsuch" in row 4 has value equal to field "such" from editor "artikel2" in row 0
Then field "artikelsuch" has value "ST." in row 7
Then field "epreis" has value "70051.10" in row 7
Then field "gpreis" has value "10507.67" in row 7
And I close the current editor

Scenario: Stornierte kaufmaennische EK-Gutschrift drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "ekkaufmgut"
And I press start
Then field "ans" is empty
Then field "str" has value "INTERN"
Then field "plz" is empty
Then field "nort" is empty
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" is empty
Then field "ans2" has value "Reus Werkzeugbau GmbH"
Then field "str2" has value "Riedstr. 24-28"
Then field "plz2" has value "76437"
Then field "nort2" has value "Rastatt"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Kaufmännische Gutschrift"
Then field "buart2" has value "Kaufmännische Gutschrift"
Then field "lakenn2" has value "D"
Then field "atext" is empty
Then field "etext" is empty
Then the table has 10 rows
Then field "textgrwechsel" contains value "Bestellung" in row 1
Then field "textgrwechsel" contains value "Lieferschein 123" in row 2
Then field "textgrwechsel" contains value "Rücklieferschein 6" in row 3
Then field "mge" has value "10" in row 4
Then field "epreis" has value "-7000.00" in row 4
Then field "gpreis" has value "-70000.00" in row 4
Then field "mzda" has value "1" in row 4
Then field "artikelsuch" in row 4 has value equal to field "such" from editor "artikel2" in row 0
Then field "artikelsuch" has value "ST." in row 7
Then field "epreis" has value "-70051.10" in row 7
Then field "gpreis" has value "-10507.67" in row 7
And I close the current editor


Scenario: EK-Rechnung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "ekrechnung"
And I press start
Then field "ans" is empty
Then field "str" has value "INTERN"
Then field "plz" is empty
Then field "nort" is empty
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" is empty
Then field "ans2" has value "Reus Werkzeugbau GmbH"
Then field "str2" has value "Riedstr. 24-28"
Then field "plz2" has value "76437"
Then field "nort2" has value "Rastatt"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Rechnung"
Then field "buart2" has value "Rechnung"
Then field "lakenn2" has value "D"
Then field "atext" is empty
Then field "etext" is empty
Then the table has 11 rows
Then field "textgrwechsel" contains value "Bestellung" in row 1
Then field "textgrwechsel" contains value "Lieferschein 123" in row 2
Then field "mge" has value "10" in row 3
Then field "epreis" has value "9000.00" in row 3
Then field "gpreis" has value "90000.00" in row 3
Then field "mzda" has value "0" in row 3
Then field "artikelsuch" in row 3 has value equal to field "such" from editor "artikel1" in row 0
# Materialzuordnung
Then field "mge" has value "10" in row 4
Then field "epreis" has value "5.11" in row 4
Then field "gpreis" has value "51.10" in row 4
Then field "artikelsuch" has value "MATZU" in row 4
#
Then field "mge" has value "10" in row 5
Then field "epreis" has value "7000.00" in row 5
Then field "gpreis" has value "70000.00" in row 5
Then field "mzda" has value "0" in row 5
Then field "artikelsuch" in row 5 has value equal to field "such" from editor "artikel2" in row 0
And I close the current editor

# EK-Rechnung stornieren
Given I open an editor "stornoekrech" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "ekrechnung"
And I save the current editor

Scenario: Storno-EK-Rechnung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "stornoekrech"
And I press start
Then field "ans" is empty
Then field "str" has value "INTERN"
Then field "plz" is empty
Then field "nort" is empty
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" is empty
Then field "ans2" has value "Reus Werkzeugbau GmbH"
Then field "str2" has value "Riedstr. 24-28"
Then field "plz2" has value "76437"
Then field "nort2" has value "Rastatt"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" contains value "Storno zu Rechnung Nr."
Then field "buart2" contains value "Storno zu Rechnung Nr."
Then field "lakenn2" has value "D"
Then field "atext" is empty
Then field "etext" is empty
Then the table has 11 rows
Then field "textgrwechsel" contains value "Bestellung" in row 1
Then field "textgrwechsel" contains value "Lieferschein 123" in row 2
Then field "mge" has value "10" in row 3
Then field "epreis" has value "-9000.00" in row 3
Then field "gpreis" has value "-90000.00" in row 3
Then field "mzda" has value "0" in row 3
Then field "artikelsuch" in row 3 has value equal to field "such" from editor "artikel1" in row 0
# Materialzuordnung
Then field "mge" has value "10" in row 4
Then field "epreis" has value "-5.11" in row 4
Then field "gpreis" has value "-51.10" in row 4
Then field "artikelsuch" has value "MATZU" in row 4
#
Then field "mge" has value "10" in row 5
Then field "epreis" has value "-7000.00" in row 5
Then field "gpreis" has value "-70000.00" in row 5
Then field "mzda" has value "0" in row 5
Then field "artikelsuch" in row 5 has value equal to field "such" from editor "artikel2" in row 0
And I close the current editor

Scenario: Stornierte EK-Rechnung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "ekrechnung"
And I press start
Then field "ans" is empty
Then field "str" has value "INTERN"
Then field "plz" is empty
Then field "nort" is empty
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" is empty
Then field "ans2" has value "Reus Werkzeugbau GmbH"
Then field "str2" has value "Riedstr. 24-28"
Then field "plz2" has value "76437"
Then field "nort2" has value "Rastatt"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Rechnung"
Then field "buart2" has value "Rechnung"
Then field "lakenn2" has value "D"
Then field "atext" is empty
Then field "etext" is empty
Then the table has 11 rows
Then field "textgrwechsel" contains value "Bestellung" in row 1
Then field "textgrwechsel" contains value "Lieferschein 123" in row 2
Then field "mge" has value "10" in row 3
Then field "epreis" has value "9000.00" in row 3
Then field "gpreis" has value "90000.00" in row 3
Then field "mzda" has value "0" in row 3
Then field "artikelsuch" in row 3 has value equal to field "such" from editor "artikel1" in row 0
# Materialzuordnung
Then field "mge" has value "10" in row 4
Then field "epreis" has value "5.11" in row 4
Then field "gpreis" has value "51.10" in row 4
Then field "artikelsuch" has value "MATZU" in row 4
#
Then field "mge" has value "10" in row 5
Then field "epreis" has value "7000.00" in row 5
Then field "gpreis" has value "70000.00" in row 5
Then field "mzda" has value "0" in row 5
Then field "artikelsuch" in row 5 has value equal to field "such" from editor "artikel2" in row 0
And I close the current editor

# Bestellung mit Fakturaplan anlegen
Given I open an editor "bestellungf" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to id from editor "lieferant"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row 3
And I set field "mge" to "10" in row 3
And I save the current editor

# Fakturaplan anlegen und Anzahlungsrechnung buchen
Given I open an editor "fakturaplan" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "bestellungf"
And I create a new row at the end of the table
And I set field "reart" to "Anzahlung" in row 1
And I set field "proz" to "10" in row 1
And I press button "anzahlungsrechn" to open a subeditor for "anzahlung" in row 1
And I set field "ebeleg" to "789"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "fakturaplan"
And I save the current editor

Scenario: Anzahlungsrechnung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "anzahlung"
And I press start
Then field "ans" is empty
Then field "str" has value "INTERN"
Then field "plz" is empty
Then field "nort" is empty
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" is empty
Then field "ans2" has value "Reus Werkzeugbau GmbH"
Then field "str2" has value "Riedstr. 24-28"
Then field "plz2" has value "76437"
Then field "nort2" has value "Rastatt"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Anzahlungsrechnung"
Then field "buart2" has value "Anzahlungsrechnung"
Then field "lakenn2" has value "D"
Then field "atext" is empty
Then field "etext" is empty
Then the table has 7 rows
Then field "textgrwechsel" contains value "Bestellung" in row 1
Then field "mge" is empty in row 2
Then field "epreis" is empty in row 2
Then field "gpreis" has value "16010.22" in row 2
Then field "mzda" has value "0" in row 2
Then field "artikelsuch" has value "ANZAHLUNG" in row 2
And I close the current editor

# EK-Barrechnung anlegen
Given I open an editor "ekbrechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to id from editor "lieferant"
And I set field "vorganga" to "Barzahlung"
And I set field "ebeleg" to "789"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row 3
And I set field "mge" to "10" in row 3
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: EK-Barrechnung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "ekbrechnung"
And I press start
Then field "ans" is empty
Then field "str" has value "INTERN"
Then field "plz" is empty
Then field "nort" is empty
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" is empty
Then field "ans2" has value "Reus Werkzeugbau GmbH"
Then field "str2" has value "Riedstr. 24-28"
Then field "plz2" has value "76437"
Then field "nort2" has value "Rastatt"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Rechnung"
Then field "buart2" has value "Rechnung"
Then field "lakenn2" has value "D"
Then field "atext" is empty
Then field "etext" is empty
Then the table has 9 rows
Then field "mge" has value "10" in row 1
Then field "epreis" has value "9000.00" in row 1
Then field "gpreis" has value "90000.00" in row 1
Then field "mzda" has value "0" in row 1
Then field "artikelsuch" in row 1 has value equal to field "such" from editor "artikel1" in row 0
# Materialzuschlag
Then field "mge" has value "10" in row 2
Then field "epreis" has value "5.11" in row 2
Then field "gpreis" has value "51.10" in row 2
Then field "artikelsuch" has value "MATZU" in row 2
#
Then field "mge" has value "10" in row 3
Then field "epreis" has value "7000.00" in row 3
Then field "gpreis" has value "70000.00" in row 3
Then field "mzda" has value "0" in row 3
Then field "artikelsuch" in row 3 has value equal to field "such" from editor "artikel2" in row 0
And I close the current editor

# EK-Barrechnung stornieren
Given I open an editor "stornoekbrech" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "ekbrechnung"
And I save the current editor

Scenario: Storno EK-Barrechnung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "stornoekbrech"
And I press start
Then field "ans" is empty
Then field "str" has value "INTERN"
Then field "plz" is empty
Then field "nort" is empty
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" is empty
Then field "ans2" has value "Reus Werkzeugbau GmbH"
Then field "str2" has value "Riedstr. 24-28"
Then field "plz2" has value "76437"
Then field "nort2" has value "Rastatt"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" contains value "Storno zu Rechnung Nr."
Then field "buart2" contains value "Storno zu Rechnung Nr."
Then field "lakenn2" has value "D"
Then field "atext" is empty
Then field "etext" is empty
Then the table has 9 rows
Then field "mge" has value "10" in row 1
Then field "epreis" has value "-9000.00" in row 1
Then field "gpreis" has value "-90000.00" in row 1
Then field "mzda" has value "0" in row 1
Then field "artikelsuch" in row 1 has value equal to field "such" from editor "artikel1" in row 0
# Materialzuschlag
Then field "mge" has value "10" in row 2
Then field "epreis" has value "-5.11" in row 2
Then field "gpreis" has value "-51.10" in row 2
Then field "artikelsuch" has value "MATZU" in row 2
#
Then field "mge" has value "10" in row 3
Then field "epreis" has value "-7000.00" in row 3
Then field "gpreis" has value "-70000.00" in row 3
Then field "mzda" has value "0" in row 3
Then field "artikelsuch" in row 3 has value equal to field "such" from editor "artikel2" in row 0
Then field "artikelsuch" has value "ST." in row 6
Then field "epreis" has value "-160102.20" in row 6
Then field "gpreis" has value "-24015.33" in row 6
And I close the current editor

Scenario: Stornierte EK-Barrechnung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "ekbrechnung"
And I press start
Then field "ans" is empty
Then field "str" has value "INTERN"
Then field "plz" is empty
Then field "nort" is empty
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" is empty
Then field "ans2" has value "Reus Werkzeugbau GmbH"
Then field "str2" has value "Riedstr. 24-28"
Then field "plz2" has value "76437"
Then field "nort2" has value "Rastatt"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Rechnung"
Then field "buart2" has value "Rechnung"
Then field "lakenn2" has value "D"
Then field "atext" is empty
Then field "etext" is empty
Then the table has 9 rows
Then field "mge" has value "10" in row 1
Then field "epreis" has value "9000.00" in row 1
Then field "gpreis" has value "90000.00" in row 1
Then field "mzda" has value "0" in row 1
Then field "artikelsuch" in row 1 has value equal to field "such" from editor "artikel1" in row 0
# Zeile 2 ist Materialzuschlagszeile
Then field "mge" has value "10" in row 3
Then field "epreis" has value "7000.00" in row 3
Then field "gpreis" has value "70000.00" in row 3
Then field "mzda" has value "0" in row 3
Then field "artikelsuch" in row 3 has value equal to field "such" from editor "artikel2" in row 0
And I close the current editor

Scenario: EK-Barrechnung anlegen, rueckliefern und EK-Ruecklieferung drucken
Given I open an editor "ekbrechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to id from editor "lieferant"
And I set field "vorganga" to "Barzahlung"
And I set field "ebeleg" to "789"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "such" to "EKBR01"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row 3
And I set field "mge" to "10" in row 3
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: Kaufmaennische EK-Gutschrift fuer EK-Rechnung erstellen und drucken
Given I open an editor "ekkaufmgut" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ekbrechnung"
And I set fields
   | ebeleg | 789     |
   | such   | EKBWG01 |
   | vom    | .       |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "-10" in row 1
And I set field "preis" to "0" in row 1
Then field "preis" is not modifiable in row 2
And I create a new row at position 3
And I set field "artex" to "TEXT" in row 3
Then field "pwert" is not modifiable in row 3
And I set field "mge" to "-10" in row 4
And I set field "preis" to "0" in row 4
Then field "preis" is not modifiable in row 5
And I save the current editor

Scenario: EK - kaufmaennische Gutschrift drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "ekkaufmgut"
And I press start
Then field "ans" is empty
Then field "str" has value "INTERN"
Then field "plz" is empty
Then field "nort" is empty
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" is empty
Then field "ans2" has value "Reus Werkzeugbau GmbH"
Then field "str2" has value "Riedstr. 24-28"
Then field "plz2" has value "76437"
Then field "nort2" has value "Rastatt"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Kaufmännische Gutschrift"
Then field "buart2" has value "Kaufmännische Gutschrift"
Then field "lakenn2" has value "D"
Then field "atext" is empty
Then field "etext" is empty
Then the table has 11 rows
Then field "textgrwechsel" contains value "Rechnung" in row 1
Then field "mge" has value "10" in row 2
Then field "epreis" is empty in row 2
Then field "gpreis" is empty in row 2
Then field "mzda" has value "0" in row 2
Then field "artikelsuch" in row 2 has value equal to field "such" from editor "artikel1" in row 0
# Zeile 3 ist Materialzuordnung zu Artikel 1
Then field "artikelsuch" has value "MATZU" in row 3
Then field "mge" has value "10" in row 3
# Zeile 4 Textzeile
Then field "artikelsuch" has value "TEXT" in row 4
Then field "mge" has value "" in row 4
Then field "epreis" is empty in row 4
Then field "gpreis" has value "" in row 4
Then field "mzda" has value "0" in row 4
# Artikel 2
Then field "artikelsuch" in row 5 has value equal to field "such" from editor "artikel2" in row 0
Then field "mge" has value "10" in row 5
Then field "epreis" is empty in row 5
Then field "gpreis" is empty in row 5
# Zeile 6 ist Materialzuordnung zu Artikel 2
Then field "artikelsuch" has value "MATZU" in row 6
And I close the current editor

# EK Barrechnung artikel 2 rueckliefern
Given I open an editor "ekbrueckls" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "ekbrechnung"
And I set field "ebeleg" to "456"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "such" to "EKBSR01"
Then the table has 4 rows
And I press button "offueb" in row 3
And I save the current editor

Scenario: EK Ruecklieferschein drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "ekbrueckls"
And I press start
Then field "ans" has value "Reus Fussball GmbH"
Then field "str" has value "Bvbstr. 24-28"
Then field "plz" has value "33333"
Then field "nort" has value "Dortmund"
Then field "staat" has value "DEUTSCHLAND"
Then field "buart" has value "Rücklieferschein"
Then field "buart" has value "Rücklieferschein"
Then field "lakenn" has value "D"
Then field "ans2" has value ""
Then field "str2" has value ""
Then field "plz2" has value ""
Then field "nort2" has value ""
Then field "staat2" has value ""
Then field "lakenn2" has value ""
Then field "atext" has value "Wir senden Ihnen folgende Ware/n zurück:"
Then field "etext" is empty
Then the table has 4 rows
Then field "textgrwechsel" contains value "Rechnung" in row 1
Then field "mge" has value "10" in row 2
Then field "epreis" has value "7000.00" in row 2
Then field "gpreis" has value "70000.00" in row 2
Then field "mzda" has value "1" in row 2
Then field "artikelsuch" in row 2 has value equal to field "such" from editor "artikel2" in row 0
And I close the current editor


# Verkauf
# VK-Auftrag anlegen fuer Anzahlungsrechnungsdruck
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "betreff" to "Auftrag mit Fakturaplan"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row !lastRow
And I set field "mge" to "1" in row !lastRow
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row !lastRow
And I set field "mge" to "1" in row !lastRow
And I save the current editor
Then field "fktaplan" is empty
Then field "zbed" has value "201"

# Fakturaplan fuer Auftrag anlegen
Given I open an editor "vkfakturaplan" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "auftrag"
And I set field "namebspr" to "Fakturaplan zu Auftrag"
And I create a new row at the end of the table
And I set field "reart" to "Anzahlung" in row 1
And I set field "proz" to "20" in row 1
And I set field "ptext" to "1. Anzahlung" in row 1
And I set field "zbed" to "203" in row 1
And I create a new row at the end of the table
And I set field "reart" to "Anzahlung" in row 2
And I set field "proz" to "10" in row 2
And I set field "ptext" to "2. Anzahlung" in row 2
And I set field "zbed" to "203" in row 2
# Anzahlungsrechnung anlegen
And I press button "anzahlungsrechn" to open a subeditor for "vkanzahlung" in row 1
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "vkfakturaplan"
Then field "sumfakturiert" has value "1944.95" in row 1
And I save the current editor

Scenario: Anzahlungsrechnung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "vkanzahlung"
And I press start
Then field "ans" has value "Bayram Werkzeugbau GmbH"
Then field "str" has value "Riedstr. 24-28"
Then field "plz" has value "76437"
Then field "nort" has value "Rastatt"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value "Bayram Fabrik GmbH"
Then field "str2" has value "Schlossstr. 24-28"
Then field "plz2" has value "76135"
Then field "nort2" has value "Karlsruhe"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Anzahlungsrechnung"
Then field "buart2" has value "Anzahlungsrechnung"
Then field "lakenn2" has value "D"
Then field "atext" has value "Vereinbarungsgemäß berechnen wir die Anzahlung wie folgt:"
Then field "etext" has value "Es gelten ausschließlich unsere allgemeinen Verkaufs- und Lieferbedingungen."
Then the table has 7 rows
Then field "textgrwechsel" contains value "Auftragsbestätigung" in row 1
Then field "artikelsuch" has value "ANZAHLUNG" in row 2
And I close the current editor

# VK Anzahlungsrechnung stornieren
Given I open an editor "anzrechstorno" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "vkanzahlung"
Then field "vorganga" has value "Storno-Anzahlung"
And I save the current editor

# Rechnungsart der urspruenglichen Anzahlungsrechnung pruefen
Given I open an editor "anzrech" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "vkanzahlung"
Then field "vorganga" has value "Stornierte Anzahlung"
And I close the current editor

Scenario: VK Storno-Anzahlungsrechnung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "anzrechstorno"
And I press start
Then field "ans" has value "Bayram Werkzeugbau GmbH"
Then field "str" has value "Riedstr. 24-28"
Then field "plz" has value "76437"
Then field "nort" has value "Rastatt"
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" has value "D"
Then field "ans2" has value "Bayram Fabrik GmbH"
Then field "str2" has value "Schlossstr. 24-28"
Then field "plz2" has value "76135"
Then field "nort2" has value "Karlsruhe"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Storno zu Rechnung Nr. 400011"
Then field "buart2" has value "Storno zu Rechnung Nr. 400011"
Then field "lakenn2" has value "D"
Then field "atext" has value "Wir schreiben Ihnen folgenden Betrag aus Anzahlungsrechnung Nr. 400011 gut:"
Then field "etext" has value "Es gelten ausschließlich unsere allgemeinen Verkaufs- und Lieferbedingungen."
Then the table has 7 rows
Then field "textgrwechsel" contains value "Auftragsbestätigung" in row 1
Then field "artikelsuch" has value "ANZAHLUNG" in row 2
And I close the current editor

# Einkauf
# Bestellung EK anlegen fuer Anzahlungsrechnungsdruck
Given I open an editor "bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to id from editor "lieferant"
And I set field "betreff" to "Bestellung mit Fakturaplan"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row !lastRow
And I set field "mge" to "1" in row !lastRow
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row !lastRow
And I set field "mge" to "1" in row !lastRow
And I save the current editor
Then field "fktaplan" is empty
Then field "zbed" has value "201"

# Fakturaplan fuer Bestellung anlegen
Given I open an editor "ekfakturaplan" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "bestellung"
And I set field "namebspr" to "Fakturaplan zu Bestellung"
And I create a new row at the end of the table
And I set field "reart" to "Anzahlung" in row 1
And I set field "proz" to "20" in row 1
And I set field "ptext" to "1. Anzahlung" in row 1
And I set field "zbed" to "203" in row 1
And I create a new row at the end of the table
And I set field "reart" to "Anzahlung" in row 2
And I set field "proz" to "10" in row 2
And I set field "ptext" to "2. Anzahlung" in row 2
And I set field "zbed" to "203" in row 2
# Anzahlungsrechnung anlegen
And I press button "anzahlungsrechn" to open a subeditor for "ekanzahlung" in row 1
And I set field "ueb" to "ja"
And I set field "ebeleg" to "Anzahlungsrechnung"
And I set field "vom" to "."
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "ekfakturaplan"
Then field "sumfakturiert" has value "3202.04" in row 1
And I save the current editor

Scenario: EK Anzahlungsrechnung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "ekanzahlung"
And I press start
Then field "ans" is empty
Then field "str" has value "INTERN"
Then field "plz" is empty
Then field "nort" is empty
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" is empty
Then field "ans2" has value "Reus Werkzeugbau GmbH"
Then field "str2" has value "Riedstr. 24-28"
Then field "plz2" has value "76437"
Then field "nort2" has value "Rastatt"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Anzahlungsrechnung"
Then field "buart2" has value "Anzahlungsrechnung"
Then field "lakenn2" has value "D"
Then field "atext" is empty
Then field "etext" is empty
Then the table has 7 rows
Then field "textgrwechsel" contains value "Bestellung" in row 1
Then field "artikelsuch" has value "ANZAHLUNG" in row 2
And I close the current editor

# EK Anzahlungsrechnung stornieren
Given I open an editor "anzrechstorno" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "ekanzahlung"
Then field "vorganga" has value "Storno-Anzahlung"
And I save the current editor

# Rechnungsart der urspruenglichen Anzahlungsrechnung pruefen
Given I open an editor "anzrech" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "ekanzahlung"
Then field "vorganga" has value "Stornierte Anzahlung"
And I close the current editor

Scenario: EK Storno-Anzahlungsrechnung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "anzrechstorno"
And I press start
Then field "ans" is empty
Then field "str" has value "INTERN"
Then field "plz" is empty
Then field "nort" is empty
Then field "staat" has value "DEUTSCHLAND"
Then field "lakenn" is empty
Then field "ans2" has value "Reus Werkzeugbau GmbH"
Then field "str2" has value "Riedstr. 24-28"
Then field "plz2" has value "76437"
Then field "nort2" has value "Rastatt"
Then field "staat2" has value "DEUTSCHLAND"
Then field "buart" has value "Storno zu Rechnung Nr. 10"
Then field "buart2" has value "Storno zu Rechnung Nr. 10"
Then field "lakenn2" has value "D"
Then field "atext" has value ""
Then field "etext" has value ""
Then the table has 7 rows
Then field "textgrwechsel" contains value "Bestellung" in row 1
Then field "artikelsuch" has value "ANZAHLUNG" in row 2
And I close the current editor


Scenario: KDINFO starten
# Ruecklieferschein, Kundenanlieferung ueber Lieferscheine
Given I open the infosystem "KDINFO"
And I set field "kboffer" to "nein"
And I set field "kbblanket" to "nein"
And I set field "kborder" to "nein"
And I set field "kbinvoice" to "nein"
And I set field "kbabl" to "ja"
And I press start
Then the table has 10 rows
Then field "tvortyp" contains value "Stornierter Lieferschein, abgelegt" in row 1
Then field "tvortyp" contains value "Storno-Lieferschein, abgelegt" in row 2
Then field "tvortyp" contains value "Lieferschein" in row 3
Then field "tvortyp" contains value "Stornierter Rücklieferschein, abgelegt" in row 4
Then field "tvortyp" contains value "Storno-Rücklieferschein, abgelegt" in row 5
Then field "tvortyp" contains value "Stornierte Kundenanlieferung, abgelegt" in row 6
Then field "tvortyp" contains value "Storno-Kundenanlieferung, abgelegt" in row 7
Then field "tvortyp" contains value "Kundenanlieferung" in row 8
Then field "tvortyp" contains value "Lieferschein" in row 9
Then field "tvortyp" contains value "Rücklieferschein" in row 10

# Anzahlung, Barzahlung, Kaufmaennische Gutschrift, Kundenanlieferung über Rechnung
Given I open the infosystem "KDINFO"
And I set field "kbinvoice" to "ja"
And I set field "kbdelivery" to "nein"
And I set field "kbabl" to "ja"
And I press start
Then the table has 12 rows
Then field "tvortyp" contains value "Stornierte Rechnung, abgelegt" in row 1
Then field "tvortyp" contains value "Storno-Rechnung, abgelegt" in row 2
Then field "tvortyp" contains value "Anzahlung, abgelegt" in row 3
Then field "tvortyp" contains value "Stornierte Barzahlung, abgelegt" in row 4
Then field "tvortyp" contains value "Storno-Barzahlung, abgelegt" in row 5
Then field "tvortyp" contains value "Stornierte kaufmännische Gutschrift, abgelegt" in row 6
Then field "tvortyp" contains value "Storno kaufmännische Gutschrift, abgelegt" in row 7
Then field "tvortyp" contains value "Rechnung, abgelegt" in row 8
Then field "tvortyp" contains value "Stornierte kaufmännische Gutschrift, abgelegt" in row 9
Then field "tvortyp" contains value "Storno kaufmännische Gutschrift, abgelegt" in row 10
Then field "tvortyp" contains value "Stornierte Anzahlung, abgelegt" in row 11
Then field "tvortyp" contains value "Storno-Anzahlung, abgelegt" in row 12
And I close the current editor

Scenario: LFINFO starten
# Ruecklieferschein über Lieferscheine
Given I open the infosystem "LFINFO"
And I set field "kboffer" to "nein"
And I set field "kborder" to "nein"
And I set field "kbblanket" to "nein"
And I set field "kbinvoice" to "nein"
And I set field "kbabl" to "ja"
And I press start
Then the table has 7 rows
Then field "tvortyp" contains value "Stornierter Lieferschein, abgelegt" in row 1
Then field "tvortyp" contains value "Storno-Lieferschein, abgelegt" in row 2
Then field "tvortyp" contains value "Lieferschein" in row 3
Then field "tvortyp" contains value "Stornierter Rücklieferschein, abgelegt" in row 4
Then field "tvortyp" contains value "Storno-Rücklieferschein, abgelegt" in row 5
Then field "tvortyp" contains value "Rücklieferschein" in row 6
Then field "tvortyp" contains value "Rücklieferschein" in row 6

# Anzahlung, Barzahlung, Kaufmaennische Gutschrift über Rechnung
Given I open the infosystem "LFINFO"
And I set field "kbdelivery" to "nein"
And I set field "kbinvoice" to "ja"
And I press start
Then the table has 11 rows
Then field "tvortyp" contains value "Stornierte Rechnung, abgelegt" in row 1
Then field "tvortyp" contains value "Stornierte kaufmännische Gutschrift, abgelegt" in row 2
Then field "tvortyp" contains value "Storno kaufmännische Gutschrift, abgelegt" in row 3
Then field "tvortyp" contains value "Storno-Rechnung, abgelegt" in row 4
Then field "tvortyp" contains value "Anzahlung, abgelegt" in row 5
Then field "tvortyp" contains value "Stornierte Barzahlung, abgelegt" in row 6
Then field "tvortyp" contains value "Storno-Barzahlung, abgelegt" in row 7
Then field "tvortyp" contains value "Barzahlung, abgelegt" in row 8
Then field "tvortyp" contains value "Kaufmännische Gutschrift, abgelegt" in row 9
Then field "tvortyp" contains value "Stornierte Anzahlung, abgelegt" in row 10
Then field "tvortyp" contains value "Storno-Anzahlung, abgelegt" in row 11
And I close the current editor


Scenario: BELEGVORKOMMEN Verkauf starten
# Ruecklieferung
Given I open the infosystem "BELEGVORKOMMEN"
And I set field "chko" to "nein"
And I set field "rueli" to "ja"
And I set field "ablageart" to "beides"
And I press start
Then the table has 1 rows

# Kundenanlieferung
Given I open the infosystem "BELEGVORKOMMEN"
And I set field "kuli" to "ja"
And I press start
Then the table has 2 rows

# Kaufmaennische Gutschrift
Given I open the infosystem "BELEGVORKOMMEN"
And I set field "kaufgut" to "ja"
And I press start
Then the table has 3 rows

# Anzahlung
Given I open the infosystem "BELEGVORKOMMEN"
And I set field "anz" to "ja"
And I press start
Then the table has 4 rows

# Barzahlung
Given I open the infosystem "BELEGVORKOMMEN"
And I set field "bar" to "ja"
And I press start
Then the table has 5 rows

Then table has values
    | tvktypa      | tvklsart          | treart                   | tabsvorkommen | tnettowert |
    | Lieferschein | Rücklieferschein  |                          | 1             | -50049.98  |
    | Lieferschein | Kundenanlieferung |                          | 1             | -90100.00  |
    | Rechnung     |                   | Kaufmännische Gutschrift | 0             | 0.00       |
    | Rechnung     |                   | Barzahlung               | 0             | 0.00       |
    | Rechnung     |                   | Anzahlung                | 1             | 19020.00   |

And I close the current editor

Scenario: BELEGVORKOMMEN Einkauf starten
# Ruecklieferung
Given I open the infosystem "BELEGVORKOMMEN"
And I set field "abteilung" to "Einkauf"
And I set field "rueli" to "ja"
And I set field "ablageart" to "beides"
And I press start
Then the table has 1 rows

# Kaufmaennische Gutschrift
Given I open the infosystem "BELEGVORKOMMEN"
And I set field "kaufgut" to "ja"
And I press start
Then the table has 2 rows

# Anzahlung
Given I open the infosystem "BELEGVORKOMMEN"
And I set field "anz" to "ja"
And I press start
Then the table has 3 rows

# Barzahlung
Given I open the infosystem "BELEGVORKOMMEN"
And I set field "bar" to "ja"
And I press start

Then table has values
    | tektypa      | teklsart         | treart                   | tabsvorkommen | tnettowert |
    | Lieferschein | Rücklieferschein |                          | 2             | -274016.08 |
    | Rechnung     |                  | Kaufmännische Gutschrift | 1             |    -199.89 |
    | Rechnung     |                  | Barzahlung               | 1             |  313132.69 |
    | Rechnung     |                  | Anzahlung                | 1             |   31313.27 |
Then the table has 4 rows
And I close the current editor


# EK Rechnung anlegen mit Zusatzpositionen
# 1. Trenn-,
# 2. Absatz-,
# 3. Seiten-Position
# Jeweils pruefen, dass keine Endsummenposition erzeugt wird
Given I open an editor "ekrechnung-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to id from editor "lieferant"
And I set field "num4" to "2-RE"
Then field "vorganga" has value "Rechnung"
And I set field "ebeleg" to "1"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "2" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Trennposition anfuegen
Given I open an editor "ekrechnung-2" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "ekrechnung-2"
Then the table has 5 rows
And I create a new row at the end of the table
And I set field "artex" to "1-FALL-TP" in row !lastRow
And I save the current editor

# Absatzposition anfuegen
Given I open an editor "ekrechnung-2" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "ekrechnung-2"
Then the table has 6 rows
And I create a new row at position 1
And I set field "artex" to "1-FALL-AS" in row 1
And I save the current editor

# Seitenposition anfuegen
Given I open an editor "ekrechnung-2" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "ekrechnung-2"
Then the table has 7 rows
And I create a new row at the end of the table
And I set field "artex" to "1-FALL-ST" in row !lastRow
And I save the current editor

Given I open an editor "ekrechnung-2" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "ekrechnung-2"
Then the table has 8 rows
And I delete row at position 8
And I delete row at position 7
And I delete row at position 6
And I delete row at position 5
And I delete row at position 4
And I delete row at position 3
And I delete row at position 2
And I save the current editor

Given I open an editor "ekrechnung-2" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "ekrechnung-2"
Then the table has 1 rows
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "ekre-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "ekrechnung-2"
And I close the current editor

Scenario: VK Nicht rechnungs-/lieferscheinrelevante Zusatzpositionen werden nicht uebernommen.
# VK Auftrag anlegen mit nicht rechnungs-/lieferscheinrelevanten Zusatzpositionen
# 1. Trenn-,
# 2. Absatz-,
# Jeweils pruefen, dass diese nicht in die RE bzw. den LS uebernommen werden
Given I open an editor "auftrag-2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
 | kunde | 1    |
 | num3  | 2-AU |
 | vom   | .    |
And I create a new row at the end of the table
And I set field "artex" to "artikel1" in row !lastRow
And I set field "mge" to "22" in row !lastRow
And I create a new row at the end of the table
And I set field "artex" to "1-AS-NICHT" in row !lastRow
Then field "lirelev" is modifiable in row !lastRow
Then field "rerelev" is modifiable in row !lastRow
And I create a new row at the end of the table
And I set field "artex" to "1-ST-NICHT" in row !lastRow
Then field "lirelev" is modifiable in row !lastRow
Then field "rerelev" is modifiable in row !lastRow
# Seitenposition auf rechnungsrelevant setzen
And I set field "rerelev" to "ja" in row !lastRow
And I create a new row at the end of the table
And I set field "artex" to "artikel2" in row !lastRow
And I set field "mge" to "22" in row !lastRow
Then the table has 6 rows
And I save the current editor

# Lieferschein aus Auftrag erzeugen
Given I open an editor "vk-ls-2" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "auftrag-2"
Then the table has 4 rows
And I set field "mge" to "12" in row 1
And I press button "offueb" in row 2
And I save the current editor

# Rechnung aus Auftrag erzeugen
Given I open an editor "vk-re-2" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "auftrag-2"
Then the table has 5 rows
And I set field "term" to "."
And I press button "offueb" in row 1
# Seitenumbruch wurde rechnungsrelevant gesetzt
Then field "artex" has value "ST-NICHT" in row 3
And I press button "offueb" in row 4
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
