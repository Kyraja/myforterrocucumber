# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Packstuecknummern_MZ_VDA.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Generierung von Packstuecknummern wenn Behaelter vorhanden sind
#
# *****************************************************************************
@persistent
Feature: VERSAND_BEHAELTER_Packstuecknummern_MZ_VDA.feature
Background:
Given I set the fake date to "02.01.1995"

# ACHTUNG!! NUMMER ANLEGEN FUER SZENARIO 13:

# 13 - Identnummer Lieferschein 13-VDA4_

##################################################################################################################

@PackstuecknummernStammdaten
Scenario: Packanweisung WARENANHAENGER_1, einstufig
Given I open an editor "Packanweisung" from table "(PackingInstructions):(PackingInstructions)" with command "STORE" for record "WARENANHAENGER_1"
And I set field "such" to "WARENANHAENGER_1"
And I set field "namebspr" to "Warenanhänger 1 VDA-4992"
And I delete all rows
And I create a new row at the end of the table
And I set field "artikel" to "KLT" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "ebene" to "1" in row 1
And I set field "minebene" to "1" in row 1
And I set field "auffuell" to "nein" in row 1
And I set field "walayout" to "VDA-4992" in row 1
And I save the current editor

@Stammdaten
Scenario: Packanweisung WARENANHAENGER_2, zweistufig
Given I open an editor "Packanweisung" from table "(PackingInstructions):(PackingInstructions)" with command "STORE" for record "WARENANHAENGER_2"
And I set field "such" to "WARENANHAENGER_2"
And I set field "namebspr" to "Warenanhänger 2 VDA-4992"
And I delete all rows
And I create a new row at the end of the table
And I set field "artikel" to "KLT" in row 1
And I set field "anzahl" to "4" in row 1
And I set field "ebene" to "4" in row 1
And I set field "minebene" to "1" in row 1
And I set field "auffuell" to "Ebene" in row 1
And I set field "walayout" to "VDA-4992" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "SPALETTE" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "minebene" to "1" in row 2
And I set field "auffuell" to "nein" in row 2
And I set field "walayout" to "VDA-4992" in row 2
And I save the current editor

@PackstuecknummernStammdaten
Scenario: Verkaufsteil VDA_ARTIKEL
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "VDA_ARTIKEL"
And I set field "such" to "VDA_ARTIKEL"
And I set field "namebspr" to "VDA Artikel zum Verkauf"
And I set field "bsart" to "Eigenfertigung"
And I set field "packanwstdversand" to "WARENANHAENGER_1"
And I set field "fmengestdversand" to "5"
And I set field "chverfolgung" to "Chargenverfolgung"
And I set field "chimlager" to "JA"
And I save the current editor

Scenario: Verkaufsteil VDA_ARTIKEL_2
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "VDA_ARTIKEL_2"
And I set field "such" to "VDA_ARTIKEL_2"
And I set field "namebspr" to "VDA Artikel zum Verkauf 2"
And I set field "bsart" to "Eigenfertigung"
And I set field "packanwstdversand" to "WARENANHAENGER_2"
And I set field "fmengestdversand" to "2"
And I set field "chverfolgung" to "Chargenverfolgung"
And I set field "chimlager" to "JA"
And I save the current editor


### Tests ###

Scenario Outline: 01 Behaelter anlegen
Given I open an editor "<behaeltereditor>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "<packm>"
And I save the current editor

Examples: Behaelter anlegen
| behaeltereditor | such            | packm |
| behaelter01_1   | VDA_BEHAELTER_1 | KLT   |
| behaelter01_2   | VDA_BEHAELTER_2 | KLT   |


Scenario Outline: 01 Lagerbuchung VDA_ARTIKEL in BEHAELTER
Given I open an editor "<editor>" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "<artikel>"
And I set field "buart" to "<buart>"
And I set field "beleg" to "L01"
And I set field "beldat" to "."
And I set field "mge" to "<mge>" in row 1
And I set field "platz2" to "<platz2>" in row 1
And I set field "behaelter" to id from editor "<behaelter>" in row 1
And I save the current editor

Examples: Lagebruchung
| editor           | artikel       | buart  | mge | platz2 | behaelter     |
| Lagerbuchung01_1 | VDA_ARTIKEL   | Zugang | 10  | F1     | behaelter01_1 |
| Lagerbuchung01_2 | VDA_ARTIKEL_2 | Zugang | 10  | F1     | behaelter01_2 |


Scenario: 01 Verkaufslieferschein VDA-Layout eintragen, wenn packm aus PA passt, aber Fuellmenge nicht
Given I open an editor "Verkaufslieferschein1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "VDA_ARTIKEL" in row 1
And I set field "mge" to "10" in row 1
Then field "maxfmenge" has value "5" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to id from editor "behaelter01_1" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein1"
And I create a new row at the end of the table
And I set field "artikel" to "VDA_ARTIKEL_2" in row 2
And I set field "mge" to "10" in row 2
Then field "maxfmenge" has value "2" in row 2
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I set field "behaelter" to id from editor "behaelter01_2" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein1"
And I press button "packvor"
Then field "walayout" is not empty in row 2
Then field "fmenge" has value "10" in row 2
Then field "walayout" is not empty in row 4
Then field "fmenge" has value "10" in row 4
And I close the current editor


Scenario Outline: 02 Behaelter anlegen
Given I open an editor "<behaeltereditor>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "<packm>"
And I save the current editor

Examples: Behaelter anlegen
| behaeltereditor | such              | packm |
| behaelter02_1   | VDA_RICHTIGEMGE_1 | KLT   |
| behaelter02_2   | VDA_RICHTIGEMGE_2 | KLT   |

Scenario Outline: 02 Lagerbuchung VDA_ARTIKEL, VDA_AERIKEL_2 in BEHAELTER
Given I open an editor "<editor>" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "<artikel>"
And I set field "buart" to "<buart>"
And I set field "beleg" to "L02"
And I set field "beldat" to "."
And I set field "mge" to "<mge>" in row 1
And I set field "platz2" to "<platz2>" in row 1
And I set field "behaelter" to id from editor "<behaelter>" in row 1
And I save the current editor

Examples: Lagebruchung
| editor           | artikel       | buart  | mge | platz2 | behaelter     |
| Lagerbuchung02_1 | VDA_ARTIKEL   | Zugang | 5   | F1     | behaelter02_1 |
| Lagerbuchung02_2 | VDA_ARTIKEL_2 | Zugang | 2   | F1     | behaelter02_2 |

Scenario: 02 MZs werden in den Packstuecknummern beruecksichtigt, Packstuecknummer = Behaelter-Identnummer
Given I open an editor "Verkaufslieferschein2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "VDA_ARTIKEL" in row 1
And I set field "mge" to "5" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to id from editor "behaelter02_1" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein2"
And I create a new row at the end of the table
And I set field "artikel" to "VDA_ARTIKEL_2" in row 2
And I set field "mge" to "2" in row 2
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I set field "behaelter" to id from editor "behaelter02_2" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein2"
And I press button "packvor"
Then the table has 6 rows
And I press button "pastnrgen" to open a subeditor for "Packstuecknummern2"
Then the table has 3 rows
And I set field "uebbehnum" to "JA"
And I press button "genpmnum"
Then field "pastnr" in row 1 has value equal to field "nummer" from editor "behaelter02_1" in row 0
Then field "pastnr" in row 2 has value equal to field "nummer" from editor "behaelter02_2" in row 0
Then field "pastnr" in row 3 has value equal to field "pastnr1" from editor "Packstuecknummern2" in row 0
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein2"
And I set field "ueb" to "JA"
And I save the current editor

Scenario Outline: 02 Behaelter pruefen
Given I open an editor "<behaeltereditor>" from table "(Container):(ContainerShell)" with command "VIEW" for record "<such>"
Then the table has 0 rows
Then field "behstatusaz" has value "Geliefert"
Then field "behleer" has value "nein"
And I close the current editor

Examples: Behaelter pruefen
| behaeltereditor | such              |
| behaelter02_1   | VDA_RICHTIGEMGE_1 |
| behaelter02_2   | VDA_RICHTIGEMGE_2 |


Scenario: 02 Lagerjournal pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "nummer" from editor "Verkaufslieferschein2"
And I press start
Then the table has 4 rows
And I close the current editor


Scenario Outline: 03 Behaelter anlegen
Given I open an editor "<behaeltereditor>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "<packm>"
And I save the current editor

Examples: Behaelter anlegen
| behaeltereditor | such                | packm |
| behaelter03_1   | VDA_GEM1            | KLT   |
| behaelter03_2   | VDA_GEM2            | KLT   |
| behaelter03_3   | OHNELAYOUT_GEMISCHT | KLT   |


Scenario Outline: 03 Lagerbuchung VDA_ARTIKEL, VDA_AERIKEL_2 in BEHAELTER
Given I open an editor "<editor>" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "<artikel>"
And I set field "buart" to "<buart>"
And I set field "beleg" to "L03"
And I set field "beldat" to "."
And I set field "mge" to "<mge>" in row 1
And I set field "platz2" to "<platz2>" in row 1
And I set field "behaelter" to id from editor "<behaelter>" in row 1
And I save the current editor

Examples: Lagebruchung
| editor           | artikel       | buart  | mge | platz2 | behaelter     |
| Lagerbuchung03_1 | VDA_ARTIKEL   | Zugang | 5   | F1     | behaelter03_1 |
| Lagerbuchung03_1 | SATTEL        | Zugang | 10  | F1     | behaelter03_1 |
| Lagerbuchung03_2 | VDA_ARTIKEL   | Zugang | 5   | F1     | behaelter03_2 |
| Lagerbuchung03_2 | VDA_ARTIKEL_2 | Zugang | 2   | F1     | behaelter03_2 |
| Lagerbuchung03_2 | PEDALE        | Zugang | 4   | F1     | behaelter03_2 |
| Lagerbuchung03_3 | PEDALE        | Zugang | 2   | F1     | behaelter03_3 |
| Lagerbuchung03_3 | RAHMEN        | Zugang | 5   | F1     | behaelter03_3 |


# 6.3. Lisa, Behaelterbuchung stimmt noch nicht, es wird der Behaelter in der Zeile und der KLT darunter auf das Konto gebucht, VERSAND-836
Scenario: 03 Verkaufslieferschein gemischte Behaelter mit und ohne VDA-Layout, manuelle Packmittelzeilen
Given I open an editor "Verkaufslieferschein3" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "VDA_ARTIKEL" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "VDA_ARTIKEL_2" in row 2
And I set field "mge" to "2" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 3
And I set field "mge" to "10" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "PEDALE" in row 4
And I set field "mge" to "6" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "RAHMEN" in row 5
And I set field "mge" to "5" in row !lastRow

And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "5" in row 1
And I set field "behaelter" to id from editor "behaelter03_1" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "5" in row 2
And I set field "behaelter" to id from editor "behaelter03_2" in row 2
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein3"

And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I set field "behaelter" to id from editor "behaelter03_2" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein3"

And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 3
And I set field "behaelter" to id from editor "behaelter03_1" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein3"

And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 4
And I set field "zuomge" to "4" in row 1
And I set field "behaelter" to id from editor "behaelter03_2" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "2" in row 2
And I set field "behaelter" to id from editor "behaelter03_3" in row 2
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein3"

And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 5
And I set field "behaelter" to id from editor "behaelter03_3" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein3"


And I press button "pmneu" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "KLT" in row !lastRow
And I set field "mge" to "2" in row !lastRow
And I set field "walayout" to "VDA-4992" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "KLT" in row !lastRow
And I set field "mge" to "1" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "SPALETTE" in row !lastRow
And I set field "mge" to "1" in row !lastRow
And I set field "walayout" to "VDA-4992" in row !lastRow

And I press button "pastnrgen" to open a subeditor for "Packstuecknummern3"
Then the table has 3 rows
And I set field "uebbehnum" to "ja"
And I press button "genpmnum"
Then field "pastnr" in row 1 has value equal to field "pastnr1" from editor "Packstuecknummern3" in row 0

And I set field "pastnr" to "such" from editor "behaelter03_1" in row 1
And I set field "pastnr" to "such" from editor "behaelter03_2" in row 2
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein3"

And I set field "ueb" to "ja"
And I save the current editor

#Then field "bhbuchung^mge" has value "0" in row 1
#Then field "bhbuchung^mge" has value "0" in row 2
#Then field "bhbuchung^mge" has value "0" in row 3
#Then field "bhbuchung^buart" has value "Abgang" in row 6
#Then field "bhbuchung^mge" has value "2" in row 6
#Then field "bhbuchung^buart" has value "Abgang" in row 7
#Then field "bhbuchung^mge" has value "1" in row 7


Scenario Outline: 04 Behaelter anlegen
Given I open an editor "<behaeltereditor>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "<packm>"
And I save the current editor

Examples: Behaelter anlegen
| behaeltereditor | such          | packm   |
| behaelter04_1   | ANDERES_PACKM | SKARTON |


Scenario Outline: 04 Lagerbuchung VDA_ARTIKEL in KARTON
Given I open an editor "<editor>" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "<artikel>"
And I set field "buart" to "<buart>"
And I set field "beleg" to "L04"
And I set field "beldat" to "."
And I set field "mge" to "<mge>" in row 1
And I set field "platz2" to "<platz2>" in row 1
And I set field "behaelter" to id from editor "<behaelter>" in row 1
And I save the current editor

Examples: Lagebruchung
| editor           | artikel     | buart  | mge | platz2 | behaelter     |
| Lagerbuchung04_1 | VDA_ARTIKEL | Zugang | 5   | F1     | behaelter04_1 |


Scenario: 04 Verkaufslieferschein VDA-Layout nicht eintragen, wenn packm aus PA nicht passt
Given I open an editor "Verkaufslieferschein4" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "VDA_ARTIKEL" in row 1
And I set field "mge" to "5" in row 1
Then field "maxfmenge" has value "5" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to id from editor "behaelter04_1" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein4"
And I press button "packvor"
Then the table has 2 rows
Then field "walayout" is empty in row 2
Then field "fmenge" has value "5" in row 2
And I close the current editor


Scenario Outline: 05 Behaelter anlegen
Given I open an editor "<behaeltereditor>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "<packm>"
And I save the current editor

Examples: Behaelter anlegen
| behaeltereditor | such     | packm |
| behaelter05_1   | PACKMVDA | KLT   |


Scenario Outline: 05 Lagerbuchung VDA_ARTIKEL in KARTON
Given I open an editor "<editor>" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "<artikel>"
And I set field "buart" to "<buart>"
And I set field "beleg" to "L05"
And I set field "beldat" to "."
And I set field "mge" to "<mge>" in row 1
And I set field "platz2" to "<platz2>" in row 1
And I set field "behaelter" to id from editor "<behaelter>" in row 1
And I save the current editor

Examples: Lagebruchung
| editor           | artikel     | buart  | mge | platz2 | behaelter     |
| Lagerbuchung05_1 | VDA_ARTIKEL | Zugang | 5   | F1     | behaelter05_1 |


Scenario: 05 Nummern nur fuer Zeilen ohne Inhalt oder manuell angelegte Nummern, Trigger packm aus MZ nutzen
Given I open an editor "Verkaufslieferschein5" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "VDA_ARTIKEL" in row 1
And I set field "mge" to "5" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "VDA_ARTIKEL_2" in row 2
And I set field "mge" to "4" in row 2

And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to id from editor "behaelter05_1" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein5"
And I press button "packvor"

Then the table has 6 rows

And I press button "pastnrgen" to open a subeditor for "Packstuecknummern5"
Then the table has 4 rows
And I press button "genpmnum"
Then field "pastnr" in row 1 has value equal to field "pastnr1" from editor "Packstuecknummern5" in row 0

And I set field "uebbehnum" to "ja"
And I press button "genpmnum"
Then field "pastnr" in row 1 has value equal to field "nummer" from editor "behaelter05_1" in row 0
Then field "pastnr" in row 2 has value equal to field "pastnr1" from editor "Packstuecknummern5" in row 0

And I close the current editor
And I close the current editor


Scenario Outline: 06 Behaelter anlegen
Given I open an editor "<behaeltereditor>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "<packm>"
And I save the current editor

Examples: Behaelter anlegen
| behaeltereditor | such     | packm |
| behaelter6_1    | PACKNR_1 | KLT   |
| behaelter6_2    | PACKNR_2 | KLT   |
| behaelter6_3    | PACKNR_3 | KLT   |


Scenario Outline: 06 Lagerbuchung VDA_ARTIKEL in KARTON
Given I open an editor "<editor>" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "<artikel>"
And I set field "buart" to "<buart>"
And I set field "beleg" to "L06"
And I set field "beldat" to "."
And I set field "mge" to "<mge>" in row 1
And I set field "platz2" to "<platz2>" in row 1
And I set field "behaelter" to id from editor "<behaelter>" in row 1
And I save the current editor

Examples: Lagebruchung
| editor           | artikel     | buart  | mge | platz2 | behaelter    |
| Lagerbuchung06_1 | VDA_ARTIKEL | Zugang | 5   | F1     | behaelter6_1 |
| Lagerbuchung06_2 | VDA_ARTIKEL | Zugang | 5   | F1     | behaelter6_2 |
| Lagerbuchung06_3 | VDA_ARTIKEL | Zugang | 5   | F1     | behaelter6_3 |


Scenario: 06 Erste Ziffer fuer Packstuecknummer vorgeben
Given I open an editor "Verkaufslieferschein6" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "VDA_ARTIKEL" in row 1
And I set field "mge" to "15" in row 1

And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "5" in row 1
And I set field "behaelter" to id from editor "behaelter6_1" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "5" in row 2
And I set field "behaelter" to id from editor "behaelter6_2" in row 2
And I create a new row at the end of the table
And I set field "zuomge" to "5" in row 3
And I set field "behaelter" to id from editor "behaelter6_3" in row 3
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein6"
And I press button "packvor"

Then the table has 2 rows

And I press button "pastnrgen" to open a subeditor for "Packstuecknummern6"
Then the table has 3 rows
And I set field "pastnr1" to "KLT001"
And I press button "genpmnum"
Then field "pastnr" has value "KLT001" in row 1
Then field "pastnr" has value "KLT002" in row 2
Then field "pastnr" has value "KLT003" in row 3

And I close the current editor
And I close the current editor


Scenario Outline: 07 Behaelter anlegen
Given I open an editor "<behaeltereditor>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "<packm>"
And I save the current editor

Examples: Behaelter anlegen
| behaeltereditor | such      | packm |
| behaelter7_1    | VDA_BEH1  | KLT   |
| behaelter7_2    | VDA_BEH2  | KLT   |
| behaelter7_3    | VDA_BEH3  | KLT   |
| behaelter7_4    | ANDERERB1 | KLT   |
| behaelter7_5    | ANDERERB2 | KLT   |


Scenario Outline: 07 Lagerbuchung ARTIKEL in KLT
Given I open an editor "<editor>" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "<artikel>"
And I set field "buart" to "<buart>"
And I set field "beleg" to "L07"
And I set field "beldat" to "."
And I set field "mge" to "<mge>" in row 1
And I set field "platz2" to "<platz2>" in row 1
And I set field "behaelter" to id from editor "<behaelter>" in row 1
And I save the current editor

Examples: Lagerbuchung
| editor           | artikel       | buart  | mge | platz2 | behaelter    |
| Lagerbuchung07_1 | VDA_ARTIKEL   | Zugang | 5   | F1     | behaelter7_1|
| Lagerbuchung07_2 | VDA_ARTIKEL   | Zugang | 5   | F1     | behaelter7_4|
| Lagerbuchung07_3 | VDA_ARTIKEL   | Zugang | 5   | F1     | behaelter7_3|
| Lagerbuchung07_4 | VDA_ARTIKEL_2 | Zugang | 2   | F1     | behaelter7_2|
| Lagerbuchung07_5 | VDA_ARTIKEL_2 | Zugang | 2   | F1     | behaelter7_5|


Scenario: 07 Pruefung auf geaenderte Behaelterverweise beim Speichern des Lieferscheins
Given I open an editor "Verkaufslieferschein7" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I set field "such" to "TESTLIEF"
And I create a new row at the end of the table
And I set field "artikel" to "VDA_ARTIKEL" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "VDA_ARTIKEL_2" in row 2
And I set field "mge" to "2" in row 2

And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "5" in row 1
And I set field "behaelter" to id from editor "behaelter7_1" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "5" in row 2
And I set field "behaelter" to id from editor "behaelter7_3" in row 2
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein7"

And I press button "mzsubm" to open a subeditor for "Materialzuordnung_2" in row 2
And I set field "behaelter" to id from editor "behaelter7_2" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein7"

And I press button "packvor"

And I press button "pastnrgen" to open a subeditor for "Packstuecknummern7"
And I set field "uebbehnum" to "ja"
And I press button "genpmnum"
Then field "pastnr" in row 1 has value equal to field "nummer" from editor "behaelter7_1" in row 0
Then field "pastnr" in row 2 has value equal to field "nummer" from editor "behaelter7_3" in row 0
Then field "pastnr" in row 3 has value equal to field "nummer" from editor "behaelter7_2" in row 0
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein7"

And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to id from editor "behaelter7_4" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein7"

And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I set field "behaelter" to "$,,such=ANDERERB2;@richtung=rückwärts;@maxtreffer=1" from editor "behaelter7_5" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein7"

And I set field "ueb" to "JA"
# Meldung 8076: Packmittel muessen neu berechnet werden. Trotzdem speichern?
And I respond with answer "1" to the dialog with id "8076"
# Hinweis - Packstuecknummern werden automatisch angelegt bzw. aktualisiert - ok?
And I respond with answer "ja" to the dialog with id "8186"
And I save the current editor

Scenario: 07 Packstuecknummern pruefen
And I switch the current editor to editor "Verkaufslieferschein7" with command "VIEW"
And I press button "pastnrgen" to open a subeditor for "Packstuecknummern7-pruef"
Then field "pastnr" in row 1 has value equal to field "pastnr1" from editor "Packstuecknummern7-pruef" in row 0
And I close the current editor
And I switch the current editor to editor "Verkaufslieferschein7"
And I close the current editor


Scenario Outline: 08 Behaelter anlegen
Given I open an editor "<behaeltereditor>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "<packm>"
And I save the current editor

Examples: Behaelter anlegen
| behaeltereditor | such          | packm |
| behaelter8_1    | behnum=pastnr | KLT   |

Scenario Outline: 08 Lagerbuchung ARTIKEL in KLT
Given I open an editor "<editor>" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "<artikel>"
And I set field "buart" to "<buart>"
And I set field "beleg" to "L08"
And I set field "beldat" to "."
And I set field "mge" to "<mge>" in row 1
And I set field "platz2" to "<platz2>" in row 1
And I set field "behaelter" to id from editor "<behaelter>" in row 1
And I save the current editor

Examples: Lagebruchung
| editor           | artikel       | buart  | mge | platz2 | behaelter    |
| Lagerbuchung08_1 | VDA_ARTIKEL_2 | Zugang | 2   | F1     | behaelter8_1 |


Scenario: 08 Fehlermeldung bei doppelt angelegten Packstuecknummern
Given I open an editor "Verkaufslieferschein8" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "VDA_ARTIKEL_2" in row 1
And I set field "mge" to "8" in row 1

And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "2" in row 1
And I set field "behaelter" to id from editor "behaelter8_1" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "2" in row 2
And I create a new row at the end of the table
And I set field "zuomge" to "2" in row 3
And I create a new row at the end of the table
And I set field "zuomge" to "2" in row 4
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein8"

And I press button "packvor"

And I press button "pastnrgen" to open a subeditor for "Packstuecknummern8"
And I set field "pastnr1" to "nummer" from editor "behaelter8_1"
And I set field "uebbehnum" to "ja"
And I press button "genpmnum"
Then field "pastnr" in row 1 has value equal to field "nummer" from editor "behaelter8_1" in row 0
Then field "pastnr" in row 2 has value equal to field "nummer" from editor "behaelter8_1" in row 0
# Fehler 2091: doppelte Nummer nicht erlaubt
And saving the current editor throws the exception "2091"
And I close the current editor
And I switch the current editor to editor "Verkaufslieferschein8"
# Hinweis - Packstuecknummern werden automatisch angelegt bzw. aktualisiert - ok?
And I respond with answer "ja" to the dialog with id "8186"
And I save the current editor


Scenario Outline: 09 Behaelter anlegen
Given I open an editor "<behaeltereditor>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "<packm>"
And I save the current editor

Examples: Behaelter anlegen
| behaeltereditor | such      | packm |
| behaelter9_1    | AUTOMAT_1 | KLT   |
| behaelter9_2    | AUTOMAT_2 | KLT   |
| behaelter9_3    | AUTOMAT_3 | KLT   |

Scenario Outline: 09 Lagerbuchung ARTIKEL in KLT
Given I open an editor "<editor>" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "<artikel>"
And I set field "buart" to "<buart>"
And I set field "beleg" to "L09"
And I set field "beldat" to "."
And I set field "mge" to "<mge>" in row 1
And I set field "platz2" to "<platz2>" in row 1
And I set field "behaelter" to id from editor "<behaelter>" in row 1
And I save the current editor

Examples: Lagebruchung
| editor           | artikel     | buart  | mge | platz2 | behaelter    |
| Lagerbuchung09_1 | VDA_ARTIKEL | Zugang | 5   | F1     | behaelter9_1 |
| Lagerbuchung09_2 | VDA_ARTIKEL | Zugang | 5   | F1     | behaelter9_2 |
| Lagerbuchung09_3 | VDA_ARTIKEL | Zugang | 5   | F1     | behaelter9_3 |


Scenario: 09 Packstuecknummern beim Speichern automatisch eintragen, wenn noch nicht erstellt
Given I open an editor "Verkaufslieferschein9" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "VDA_ARTIKEL" in row 1
And I set field "mge" to "15" in row 1

And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "5" in row 1
And I set field "behaelter" to id from editor "behaelter9_1" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "5" in row 2
And I set field "behaelter" to id from editor "behaelter9_2" in row 2
And I create a new row at the end of the table
And I set field "zuomge" to "5" in row 3
And I set field "behaelter" to id from editor "behaelter9_3" in row 3
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein9"

And I press button "packvor"
And I set field "ueb" to "JA"
# Hinweis - Packstuecknummern werden automatisch angelegt bzw. aktualisiert - ok?
And I respond with answer "ja" to the dialog with id "8186"
And I save the current editor

Scenario: 09 Packstuecknummern pruefen
And I switch the current editor to editor "Verkaufslieferschein9" with command "VIEW"
And I press button "pastnrgen" to open a subeditor for "Packstuecknummern9"
Then field "pastnr" in row 1 has value equal to field "pastnr1" from editor "Packstuecknummern9" in row 0
And I close the current editor
And I close the current editor


Scenario Outline: 10 Behaelter anlegen
Given I open an editor "<behaeltereditor>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "<packm>"
And I save the current editor

Examples: Behaelter anlegen
| behaeltereditor | such      | packm |
| behaelter10_1   | POSITION1 | KLT   |
| behaelter10_2   | POSITION2 | KLT   |


Scenario Outline: 10 Lagerbuchung ARTIKEL in KLT
Given I open an editor "<editor>" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "<artikel>"
And I set field "buart" to "<buart>"
And I set field "beleg" to "L10"
And I set field "beldat" to "."
And I set field "mge" to "<mge>" in row 1
And I set field "platz2" to "<platz2>" in row 1
And I set field "behaelter" to id from editor "<behaelter>" in row 1
And I save the current editor

Examples: Lagebruchung
| editor           | artikel       | buart  | mge | platz2 | behaelter     |
| Lagerbuchung10_1 | VDA_ARTIKEL   | Zugang | 5   | F1     | behaelter10_1 |
| Lagerbuchung10_2 | VDA_ARTIKEL_2 | Zugang | 2   | F1     | behaelter10_2 |


Scenario: 10 Packstuecknummern in Artikelposition wird ueber MZ zu Packstuecknummer
Given I open an editor "Verkaufslieferschein10" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "VDA_ARTIKEL" in row 1
And I set field "mge" to "5" in row 1
And I set field "behaelter" to id from editor "behaelter10_1" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "VDA_ARTIKEL_2" in row 2
And I set field "mge" to "2" in row 2
And I set field "behaelter" to id from editor "behaelter10_2" in row 2

And I press button "packvor"
Then the table has 6 rows

And I press button "pastnrgen" to open a subeditor for "Packstuecknummern10"
And I set field "uebbehnum" to "JA"
And I press button "genpmnum"
Then field "pastnr" in row 1 has value equal to field "nummer" from editor "behaelter10_1" in row 0
Then field "pastnr" in row 2 has value equal to field "nummer" from editor "behaelter10_2" in row 0
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein10"

And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to "" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein10"
Then field "behaelter" in row 1 has value equal to field "nummer" from editor "behaelter10_1" in row 0
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then field "behaelter" in row 1 has value equal to field "nummer" from editor "behaelter10_1" in row 0
And I close the current editor
And I switch the current editor to editor "Verkaufslieferschein10"

And I close the current editor


Scenario Outline: 11 Behaelter anlegen
Given I open an editor "<behaeltereditor>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "<packm>"
And I save the current editor

Examples: Behaelter anlegen
| behaeltereditor | such   | packm   |
| behaelter11_1   | KARTON | SKARTON |

Scenario Outline: 11 Lagerbuchung ARTIKEL in KLT
Given I open an editor "<editor>" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "<artikel>"
And I set field "buart" to "<buart>"
And I set field "beleg" to "L11"
And I set field "beldat" to "."
And I set field "mge" to "<mge>" in row 1
And I set field "platz2" to "<platz2>" in row 1
And I set field "behaelter" to id from editor "<behaelter>" in row 1
And I save the current editor

Examples: Lagebruchung
| editor           | artikel       | buart  | mge | platz2 | behaelter     |
| Lagerbuchung11_1 | VDA_ARTIKEL_2 | Zugang | 2   | F1     | behaelter11_1 |

Scenario: 11 Packmittel in MZ passt nicht zu Packmittel in Packanweisung
Given I open an editor "Verkaufslieferschein11" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "VDA_ARTIKEL_2" in row 1
And I set field "mge" to "2" in row 1

And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to id from editor "behaelter11_1" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein11"

And I press button "packvor"
Then the table has 2 rows

And I set field "walayout" to "VDA-4992" in row 2

And I press button "pastnrgen" to open a subeditor for "Packstuecknummern11"
And I set field "uebbehnum" to "JA"
And I press button "genpmnum"
Then field "packm" has value "SKARTON" in row 1
Then field "pastnr" in row 1 has value equal to field "nummer" from editor "behaelter11_1" in row 0
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein11"

And I set field "ueb" to "ja"
And I save the current editor


Scenario: 12 Packstuecknummern koennen bis 17 Zeichen lang sein
Given I open an editor "Verkaufslieferschein12" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "VDA_ARTIKEL_2" in row 1
And I set field "mge" to "10" in row 1
And I press button "packvor"
And I press button "pastnrgen" to open a subeditor for "Packstuecknummern12"
And I set field "pastnr1" to "PACK-NUMMER120001"
And I press button "genpmnum"
Then field "pastnr" has value "PACK-NUMMER120001" in row 1
Then field "pastnr" has value "PACK-NUMMER120002" in row 2
And I close the current editor
And I switch the current editor to editor "Verkaufslieferschein12"
And I close the current editor


Scenario: 13 Nach Fehlermeldung verneinen koennnen keine pastnr groesser 17 Zeichen generiert werden
Given I open an editor "Verkaufslieferschein13" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I set field "nummer" to "13-VDA4_"
And I create a new row at the end of the table
And I set field "artikel" to "VDA_ARTIKEL_2" in row 1
And I set field "mge" to "10" in row 1
And I press button "packvor"
And I press button "pastnrgen" to open a subeditor for "Packstuecknummern13"
And I respond with answer "nein" to the dialog with id "6413"
# Fehler 1361: Ungueltiger Feldwert
And setting field "pastnr1" to "PACK-NUMMER13XX0001" throws the exception "1361"
When I press button "genpmnum"
Then field "pastnr1" has value "13-VDA4_001"
And I close the current editor
And I switch the current editor to editor "Verkaufslieferschein13"
And I set field "mge" to "0" in row 1
And I close the current editor


Scenario: 14 Nach Fehlermeldung bejaht koennen pastnr groesser 17 Zeichen generiert werden
Given I open an editor "Verkaufslieferschein14" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "VDA_ARTIKEL_2" in row 1
And I set field "mge" to "10" in row 1
And I press button "packvor"
And I press button "pastnrgen" to open a subeditor for "Packstuecknummern14"
# Dialog 6413: Packstuecknummer nicht VDA konform (max. 17 Stellen)
And I respond with answer "1" to the dialog with id "6413"
And I set field "pastnr1" to "123PACK-NUMMER13001"
And I press button "genpmnum"
Then field "pastnr" has value "123PACK-NUMMER13001" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein14"
And I save the current editor


Scenario: 15 Button pastnrgen im EK-Lieferschein editierbar machen

# STAMMDATEN - 15 Warenanhaengerlayout in Packanweisung hinterlegen
Given I open an editor "packanweisung" from table "(PackingInstructions):(PackingInstructions)" with command "STORE" for record "501"
And I set field "walayout" to "GTL-GROSS-4994" in row 1
And I set field "walayout" to "GTL-GROSS-4994" in row 2
And I save the current editor

# STAMMDATEN - 15 Packanweisung in Artikel eintragen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "E2"
And I set fields
    | packanwstdversand | 501 |
    | fmengestdversand  | 10  |
And I save the current editor

# 15 EK-Lieferschein anlegen und Packstuecknummer eintragen
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | bsart   | Umlagern                                  |
    | lief    | 1                                         |
    | nummer  | 1UMLS                                     |
    | betreff | Umlagerungslieferschein mit Packanweisung |
    | ebeleg  | 1UMLS                                     |
    | vom     | .                                         |
And I create a new row at the end of the table
And I set field "artex" to "E2" in row 1
And I set field "mge" to "10" in row 1
And I set field "platz" to "L3F2" in row 1
And I press button "packvor"
Then the table has 4 rows
And I press button "pastnrgen" to open a subeditor for "packstuecknummer"
Then the table has 2 rows
And I close the current editor
And I switch the current editor to editor "lieferschein"
# Hinweis - Packstuecknummern werden automatisch angelegt bzw. aktualisiert - ok?
And I respond with answer "ja" to the dialog with id "8186"
And I save the current editor

Scenario: 16 Stammdaten fuer Umlagerungslieferschein mit MZs zu Behaeltern

Given I open an editor "Packanweisung" from table "(PackingInstructions):(PackingInstructions)" with command "NEW" for record ""
And I set field "such" to "WARENANHAENGER_3"
And I set field "namebspr" to "Warenanhänger 3"
And I delete all rows
And I create a new row at the end of the table
And I set field "artikel" to "BEHAELTER" in row 1
And I set field "anzahl" to "6" in row 1
And I set field "ebene" to "2" in row 1
And I set field "minebene" to "1" in row 1
And I set field "auffuell" to "Ebene" in row 1
And I set field "walayout" to "GTL-GROSS-4994" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "SPALETTE" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "auffuell" to "nein" in row 2
And I set field "walayout" to "GTL-GROSS-4994" in row 2
And I save the current editor

Given I open an editor "artikel3" from table "(Part):(Product)" with command "NEW" for record ""
And I set field "such" to "VDA_ARTIKEL_3"
And I set field "namebspr" to "VDA Artikel zum Einkauf"
And I set field "bsart" to "Eigenfertigung"
And I set field "packanwstdversand" to "WARENANHAENGER_3"
And I set field "fmengestdversand" to "20"
And I set field "chverfolgung" to "Chargenverfolgung"
And I set field "chimlager" to "JA"
And I save the current editor

Scenario Outline: 16 Mehr Behaelter anlegen

Given I open an editor "<behaeltereditor>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "<packm>"
And I save the current editor

Examples: Mehr Behaelter anlegen
| behaeltereditor | such              | packm     |
| behaelter02_A   | VDA_BEHAELTER_2_A | BEHAELTER |
| behaelter02_B   | VDA_BEHAELTER_2_B | BEHAELTER |

Scenario Outline: 16 Lagerbuchung VDA_ARTIKEL_3 in BEHAELTER
Given I open an editor "<editor>" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "<artikel>"
And I set field "buart" to "<buart>"
And I set field "beleg" to "L01"
And I set field "beldat" to "."
And I set field "mge" to "<mge>" in row 1
And I set field "platz2" to "<platz2>" in row 1
And I set field "behaelter" to id from editor "<behaelter>" in row 1
And I save the current editor

Examples: Lagerbuchung
| editor           | artikel       | buart  | mge | platz2 | behaelter     |
| Lagerbuchung02_A | VDA_ARTIKEL_3 | Zugang | 60  | L2F2   | behaelter02_A |
| Lagerbuchung02_B | VDA_ARTIKEL_3 | Zugang | 40  | L2F2   | behaelter02_B |

Scenario: 16 Umlagerungslieferschein mit MZs zu Behaeltern erzeugen

Given I open an editor "Einkaufslieferschein2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | bsart   | Umlagern                        |
    | lief    | 1                               |
    | nummer  | 2UMLS                           |
    | betreff | Umlagerungslieferschein mit MZs |
    | ebeleg  | 2UMLS                           |
    | vom     | .                               |
And I create a new row at the end of the table
And I set field "artikel" to "VDA_ARTIKEL_3" in row 1
And I set field "mge" to "100" in row 1
Then field "maxfmenge" has value "20" in row 1
And I set field "platz" to "F1" in row 1
And I set field "abplatz" to "L2F2" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "60" in row 1
And I set field "behaelter" to id from editor "behaelter02_A" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "40" in row 2
And I set field "behaelter" to id from editor "behaelter02_B" in row 2
And I save the current editor
And I switch the current editor to editor "Einkaufslieferschein2"
And I press button "packvor"
Then the table has 3 rows
# TODO: Abganglagerplatz wird in Packmittelzeilen nicht uebernommen, muss noch seperat gesetzt werden
And I set field "abplatz" to "L2F2" in row 2
And I set field "abplatz" to "L2F2" in row 3
And I press button "pastnrgen" to open a subeditor for "packstuecknummer"
Then the table has 2 rows
When I press button "genpmnum"
Then field "pastnr" has value "2UMLS001" in row 1
Then field "pastnr" has value "2UMLS002" in row 2
And I close the current editor
And I switch the current editor to editor "Einkaufslieferschein2"
# Hinweis - Packstuecknummern werden automatisch angelegt bzw. aktualisiert - ok?
And I respond with answer "ja" to the dialog with id "8186"
And I save the current editor

