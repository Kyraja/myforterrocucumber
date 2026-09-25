# *****************************************************************************
#  Name           : versandplanung.feature
#  Autor          : mibr
#  Verantwortlich : dago
#  Kontrolle      : foe
#  Funktion       : Versandplanung testen
#
# *****************************************************************************
#
Feature: Versandplanung ausloesen, Zusammenspiel zw. Versandplanung und Lieferscheinen
Background:
Given I set the fake date to "02.01.1995"

# ----------------------------------------------------------------------------------------------
Scenario Outline: STAMMDATEN - neutrale Zusatzposition / AU/BE anlegen
# ----------------------------------------------------------------------------------------------

Given I open an editor "<zusatzpos>" from table "(Part):(SupplementaryItem)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "zptyp" to "<zptyp>"
And I set field "vkbez" to "<vkbez>"
And I set field "vbez" to "<vbez>"
And I set field "ebez" to "<ebez>"
And I set field "vpr" to "<vpr>"
And I set field "epr" to "<epr>"
And I save the current editor

Examples: Artikel
| zusatzpos   | such    | namebspr          | zptyp             | vkbez             | vbez              | ebez              | vpr | epr |
| neutralePOS | NEUPOS  | Neutrale Position | Neutrale Position | Neutrale Position | Neutrale Position | Neutrale Position | 500 | 400 |
| AUBEPOS     | AUBEPOS | AUBE              | AU/BE             | AUBE Position     | AUBE Position     | AUBE Position     | 200 | 175 |


# ----------------------------------------------------------------------------------------------
Scenario: 01 Auftrag mit 2 Artikelpositionen, Zusatzpositionen, Versandplanung mit Ueberlieferung der ersten Position
# ----------------------------------------------------------------------------------------------
# Auftrag
Given I open an editor "1AU01" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU01 |
   | kunde   | 1     |
   | such    | AU01  |
And I append rows
   | artikel |     mge     |   preis     |
   | FAHRRAD |     100     |     100     |
   | a.      |      10     |       0     |
   | NEUPOS  | !dontChange | !dontChange |
   | TEXT    | !dontChange | !dontChange |
   | AUBEPOS |      5      |       1     |
   | FAHRRAD |     200     |      99     |
   | a.      |      10     |       0     |
And I save the current editor

# Versandplanung anlegen
Given I open an editor "Versandplanung" from table "(ShippingPlanning):(ShippingPlanning)" with command "NEW" for record ""
And I set fields
   | beleganfuegen | 1AU01 |
   | pstermvon     |     . |
   | pstermbis     |     . |
And I set field "planlmge" to "152" in row 1
And I press button "offueballe"
And I set field "belegposmitzp" to "ja"
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "VP"
And I close the current editor
And I switch the current editor to editor "Versandplanung"
Then the table has 2 rows
And I save the current editor

# Von der Versandplanung erstellten Lieferschein pruefen
Given I open an editor "LS-01" from table "(Sales):(PackingSlip)" with command "VIEW" for record "300001"
Then field "ofmge" has value "0" in row 1
Then field "mge" has value "152" in row 1
Then field "ofmge" has value "148" in row 6
Then field "mge" has value "0" in row 6
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: 02 Auftrag mit 2 Artikelpositionen, Zusatzpositionen, dann LS Ueberlieferung der ersten Position
# ----------------------------------------------------------------------------------------------
# Auftrag
Given I open an editor "1AU02" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU02 |
   | kunde   | 1     |
   | such    | AU02  |
And I append rows
   | artikel |     mge     |    preis    |
   | FAHRRAD |     100     |     100     |
   | a.      |      10     |       0     |
   | NEUPOS  | !dontChange | !dontChange |
   | TEXT    | !dontChange | !dontChange |
   | 4       | !dontChange | !dontChange | # Gesamtrabatt
   | AUBEPOS |      5      |       1     |
   | FAHRRAD |     200     |      99     |
   | a.      |      10     |       0     |
And I save the current editor

# Lieferschein
Given I open an editor "LS-02" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "1AU02"
And I set fields
   | such   | LS02 |
   | ueb    | true |
Then the table has 8 rows
And I set field "mge" to "155" in row 1
Then field "ofmge" has value "-55" in row 1
And I press button "offueb" in row 1
Then field "ofmge" has value "0" in row 1
Then field "ofmge" has value "145" in row 7
Then field "mge" has value "0" in row 7
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: 03 Auftrag mit 2 Artikel Positionen, Zusatzpositionen, dann RE+LB Ueberlieferung der ersten Position
# ----------------------------------------------------------------------------------------------
# Auftrag
Given I open an editor "1AU03" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU03 |
   | kunde   | 1     |
   | such    | AU03  |
And I append rows
   | artikel |     mge     | preis       |
   | FAHRRAD |     100     | 100         |
   | a.      |      10     |   0         |
   | NEUPOS  | !dontChange | !dontChange |
   | TEXT    | !dontChange | !dontChange |
   | 3       | !dontChange | !dontChange | # Zwischensumme
   | AUBEPOS |      5      |       1     |
   | FAHRRAD |     200     |  99         |
   | a.      |      10     |   0         |
And I save the current editor

# Rechnung mit LB
Given I open an editor "RE-03" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "1AU03"
And I set fields
   | such   | RE023 |
   | ueb    | true  |
   | vom    | .     |
   | tterm  | .     |
Then the table has 8 rows
Then field "fakt" has value "ja"
And I set field "mge" to "156" in row 1
Then field "ofmge" has value "-56" in row 1
And I press button "offueb" in row 1
Then field "ofmge" has value "0" in row 1
Then field "ofmge" has value "144" in row 7
Then field "mge" has value "0" in row 7
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: 04 Auftrag mit 2 Artikel-/Zusatzpositionen, Versandplanung mit Ueberlieferung, Zeige-/Aendern-Modus
# ----------------------------------------------------------------------------------------------
# Auftrag
Given I open an editor "1AU04" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU04 |
   | kunde   | 1     |
   | such    | AU04  |
And I append rows
   | artikel | mge | preis |
   | FAHRRAD | 100 |   100 |
   | a.      |  10 |     1 |
   | FAHRRAD | 200 |    99 |
   | a.      |  10 |     2 |
And I save the current editor

# Versandplanung anlegen ohne diese freizugeben
Given I open an editor "VP_04" from table "(ShippingPlanning):(ShippingPlanning)" with command "NEW" for record ""
And I set fields
   | beleganfuegen | 1AU04 |
   | pstermvon     |     . |
   | pstermbis     |     . |
Then the table has 2 rows
And I set field "planlmge" to "102" in row 1
And I press button "offueballe"
And I set field "belegposmitzp" to "ja"
And I set field "mfreig" to "ja" in row 1
Then field "mfreig" is not modifiable in row 2
Then field "mfreig" has value "ja" in row 2
And I save the current editor

# Zeige-Modus: Feld mfreig ueberpruefen
Given I open an editor "VP_04_View" from table "(ShippingPlanning):(ShippingPlanning)" with command "VIEW" for record from editor "VP_04"
Then field "mfreig" has value "ja" in row 1
Then field "mfreig" has value "ja" in row 2
And I close the current editor

# Aendern-Modus: Feld mfreig ueberpruefen
Given I open an editor "VP_04_Update" from table "(ShippingPlanning):(ShippingPlanning)" with command "UPDATE" for record from editor "VP_04"
Then field "mfreig" has value "ja" in row 1
Then field "mfreig" has value "ja" in row 2
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: 05 Auftrag mit 5 Artikelpositionen, 2 von 5 in neue Versandplanung uebernehmen
# ----------------------------------------------------------------------------------------------
# Auftrag
Given I open an editor "1AU05" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU05 |
   | kunde   | 1     |
   | such    | AU05  |
And I append rows
   | artikel | mge | preis |
   | E1      | 10  |    10 |
   | E1      | 20  |    10 |
   | V1      | 10  |   100 |
   | E2      | 10  |    25 |
   | V3      | 15  |    75 |
And I save the current editor

# Versandplanung anlegen
Given I open an editor "VP_05" from table "(ShippingPlanning):(ShippingPlanning)" with command "NEW" for record ""
And I set fields
   | beleganfuegen | 1AU05 |
   | pstermvon     |     . |
   | pstermbis     |     . |
Then the table has 5 rows
And I save the current editor

Given I open an editor "VP_05_Update" from table "(ShippingPlanning):(ShippingPlanning)" with command "UPDATE" for record from editor "VP_05"
Then the table has 5 rows
And I set field "invplanneu" to "ja" in row 3
And I set field "invplanneu" to "ja" in row 5
And I press button "planneu" to open a subeditor for "VP"
And I close the current editor
# Hier kommt der Hinweis 3584: Versandplanung 4 wurde erzeugt.
And I switch the current editor to editor "VP_05_Update"
Then the table has 3 rows
And I save the current editor

# Verbliebene Positionen in Versandplanung pruefen
Given I open an editor "VP_05_View" from table "(ShippingPlanning):(ShippingPlanning)" with command "VIEW" for record from editor "VP_05"
Then the table has 3 rows
Then field "artikel" has value "E1" in row 1
Then field "artikel" has value "E2" in row 3
And I close the current editor

# Neue Versandplanung ueberpruefen
Given I open an editor "VP_04_Update" from table "(ShippingPlanning):(ShippingPlanning)" with command "UPDATE" for record "4"
Then the table has 2 rows
Then field "artikel" has value "V3" in row 1
Then field "artikel" has value "V1" in row 2
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: 06 Auftrag mit 1 Artikelposition, Position in Versandplanung splitten
# ----------------------------------------------------------------------------------------------

Scenario: Auftrag anlegen
Given I open an editor "AU06" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU06 |
   | kunde   | 1     |
   | such    | AU06  |
And I append rows
    | pnum | artex  | mge         | preis       |
    | 1    | v1     | 10          | 10,5        |
And I save the current editor

# Neue Versandplanung anlegen, bearbeiten und Position splitten
Given I open an editor "versand1" from table "(ShippingPlanning):(ShippingPlanning)" with command "NEW" for record ""
#And I set field "such" to "versand"
And I set field "pstermvon" to "."
And I set field "pstermbis" to "."
And I set field "beleganfuegen" to id from editor "AU06"
Then the table has 1 rows
And I press button "splitposbild" in row 1
And I set field "planlmge" to "7" in row 1
And I set field "planlmge" to "3" in row 2
And I save the current editor

#1 Position aus Versandplanung freigeben
Given I open an editor "versand2" from table "(ShippingPlanning):(ShippingPlanning)" with command "UPDATE" for record from editor "versand1"
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "ls"
And I close the current subeditor to switch back to the parent editor
And I save the current editor

#Lieferschein buchen
Given I open an editor "lief" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "LTEST"
And I set field "ueb" to "ja"
And I save the current editor

#Versandplanung wieder aufrufen
Given I open an editor "versand3" from table "(ShippingPlanning):(ShippingPlanning)" with command "VIEW" for record from editor "versand1"
Then field "evplanung" is not empty in row 1
Then field "evplanung" is not empty in row 2
And I close the current editor
