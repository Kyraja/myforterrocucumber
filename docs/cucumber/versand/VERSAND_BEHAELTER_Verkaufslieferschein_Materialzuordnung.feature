# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Verkaufslieferschein_Materialzuordnung.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Verkaufslieferscheine mit Behaeltern und MZs
#
# *****************************************************************************
@persistent
Feature: VERSAND_BEHAELTER_Verkaufslieferschein_Materialzuordnung.feature
Background:
Given I set the fake date to "02.01.1995"

# Hinweise:

# ACHTUNG!! NUMMER ANLEGEN FUER SZENARIO 11, 12, 18, 21:
# 11 - BEHAELTER: BEH_ANLEGEN_B14
# 12 - BEHAELTER: RUECK_NEUER_BEH_B14
# 18 - BHEAELTER: RUECK_CHARGE_NEUBEH_B14
# 21 - BEHAELTER: PROZESS_RUECK_B14

##################################################################################################################

# 8.3. Lisa, Behaelterkonto wird nicht bebucht, VERSAND-836
@MZ_Verkaufslieferschein
Scenario: 01 einen Artikel in einem Behaelter versenden
Given I open an editor "behaelter1" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "EIN_ARTIKEL"
And I set field "packm" to "KLT"
And I save the current editor

Scenario: 01 Lagerbuchung
Given I open an editor "Lagerbuchung1" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "PEDALE"
And I set field "buart" to "Zugang"
And I set field "beleg" to "LM01"
And I set field "beldat" to "."
And I set field "mge" to "5" in row 1
And I set field "behaelter" to "nummer" from editor "behaelter1" in row 1
And I save the current editor

Scenario: 01 Verkaufslieferschein einen Artikel in einem Behaelter versenden
Given I open an editor "Verkaufslieferschein1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "PEDALE" in row 1
And I set field "mge" to "5" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to "nummer" from editor "behaelter1" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein1"
And I set field "ueb" to "JA"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Abgang" in row 1

Scenario: 01 Behaelter pruefen
And I open an editor "beaelterpruef" from table "(Container):(ContainerShell)" with command "VIEW" for record "EIN_ARTIKEL"
Then the table has 0 rows
Then field "kl" is empty
Then field "behstatusaz" has value "Geliefert"
Then field "behleer" has value "nein"
And I close the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "nummer" from editor "Verkaufslieferschein1"
And I press start
Then field "art" has value "PEDALE" in row 1
Then field "amge" has value "5" in row 1
Then field "verweis^behaelter" in row 1 has value equal to field "nummer" from editor "beaelterpruef" in row 0
And I close the current editor


@MZ_Verkaufslieferschein
Scenario Outline: 02 einen Artikel in zwei Behaeltern versenden
Given I open an editor "<editor>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "<packm>"
And I save the current editor

Examples: Behaelter anlegen
| editor       | such             | packm |
| behaelter2_1 | ZWEI_BEHAELTER_1 | KLT   |
| behaelter2_2 | ZWEI_BEHAELTER_2 | KLT   |

Scenario Outline: 02 Lagerbuchung einen Artikel in zwei Behaelter versenden
Given I open an editor "<editorL>" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "<artikel>"
And I set field "buart" to "Zugang"
And I set field "beleg" to "LM02"
And I set field "beldat" to "."
And I set field "mge" to "<mge>" in row 1
And I set field "behaelter" to "nummer" from editor "<editorbeh>" in row 1
And I save the current editor

Examples: Lagerbuchung
| editorL         | artikel | mge | editorbeh    |
| Lagerbuchung2_1 | PEDALE  | 5   | behaelter2_1 |
| Lagerbuchung2_1 | PEDALE  | 5   | behaelter2_2 |


# 8.3. Lisa, Behaelterkonto wird nicht bebucht, VERSAND-836
Scenario: 02 Verkaufslieferschein einen Artikel in zwei Behaelter versenden
Given I open an editor "Verkaufslieferschein2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "PEDALE" in row 1
And I set field "mge" to "20" in row 1
And I set field "he" to "Stück" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "10" in row 1
And I set field "einh" to "Stück" in row 1
And I set field "behaelter" to "nummer" from editor "behaelter2_1" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "10" in row 2
And I set field "einh" to "Stück" in row 2
And I set field "behaelter" to "nummer" from editor "behaelter2_2" in row 2
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein2"
And I set field "ueb" to "JA"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Abgang" in row 1

Scenario Outline: 02 Behaelter pruefen einen Artikel in zwei Behaelter versenden
And I open an editor "<beheditor>" from table "(Container):(ContainerShell)" with command "VIEW" for record "<behrecord>"
Then the table has 0 rows
Then field "kl" is empty
Then field "behstatusaz" has value "Geliefert"
Then field "behleer" has value "nein"
And I close the current editor

Examples: Behaelter pruefen
| beheditor   | behrecord        |
| behpruef2_1 | ZWEI_BEHAELTER_1 |
| behpruef2_2 | ZWEI_BEHAELTER_2 |

Scenario: 02 Lagerjournal einen Artikel in zwei Behaelter versenden
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "nummer" from editor "Verkaufslieferschein2"
And I press start
Then field "art" has value "PEDALE" in row 1
Then field "amge" has value "10" in row 1
Then field "verweis^behaelter" in row 1 has value equal to field "nummer" from editor "behaelter2_1" in row 0
Then field "art" has value "PEDALE" in row 2
Then field "amge" has value "10" in row 2
Then field "verweis^behaelter" in row 2 has value equal to field "nummer" from editor "behaelter2_2" in row 0
And I close the current editor


@MZ_Verkaufslieferschein
Scenario: 03 zwei unterschiedliche Artikel in einem Behaelter versenden
Given I open an editor "behaelter3" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "VERSCHIEDENE_ARTIKEL"
And I set field "packm" to "KLT"
And I save the current editor

Scenario Outline: 03 Lagerbuchung unterschiedliche Artikel in einem Behaelter versenden
Given I open an editor "Lagerbuchung3" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "<artikel>"
And I set field "buart" to "Zugang"
And I set field "beleg" to "LM03"
And I set field "beldat" to "."
And I set field "mge" to "<mge>" in row 1
And I set field "behaelter" to id from editor "<editorbeh>" in row 1
And I save the current editor

Examples: Lagerbuchung
| editorL         | artikel | mge | editorbeh  |
| Lagerbuchung3_1 | PEDALE  | 5   | behaelter3 |
| Lagerbuchung3_1 | SATTEL  | 5   | behaelter3 |


# 8.3. Lisa, Behaelterkonto wird nicht bebucht, VERSAND-836
Scenario: 03 Verkaufslieferschein zwei unterschiedliche Artikel in einem Behaelter versenden
Given I open an editor "Verkaufslieferschein3" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "PEDALE" in row 1
And I set field "mge" to "5" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 2
And I set field "mge" to "5" in row 2
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to id from editor "behaelter3" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein3"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I set field "behaelter" to id from editor "behaelter3" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein3"
And I set field "ueb" to "JA"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Abgang" in row 1
#Then field "bhbuchung^mge" has value "0" in row 2
#Then field "bhbuchung^buart" has value "" in row 2

Scenario: 03 Behaelter pruefen zwei unterschiedliche Artikel in einem Behaelter versenden
And I open an editor "beaelter" from table "(Container):(ContainerShell)" with command "VIEW" for record "VERSCHIEDENE_ARTIKEL"
Then the table has 0 rows
Then field "kl" is empty
Then field "behstatusaz" has value "Geliefert"
Then field "behleer" has value "nein"
And I close the current editor

Scenario: 03 Lagerjournal zwei unterschiedliche Artikel in einem Behaelter versenden
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "nummer" from editor "Verkaufslieferschein3"
And I press start
Then the table has 2 rows
Then field "art" has value "PEDALE" in row 1
Then field "amge" has value "5" in row 1
Then field "art" has value "SATTEL" in row 2
Then field "amge" has value "5" in row 2
And I close the current editor


@MZ_Verkaufslieferschein
Scenario: 04 Fehlermeldungen (8343 Der angegebene Behaelter ist leer; 8311 Der Artikel ist nicht mit den passenden Gebindeinformationen im Behaelter enthalten.)
Given I open an editor "Verkaufslieferschein41" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "PEDALE" in row 1
And I set field "mge" to "10" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
# Fehler 1361: Ungueltiger Feldwert - Behaelter ist noch nicht angelegt
Then setting field "behaelter" to "BEH_FEHLERMELDUNG" in row 1 throws the exception "1361"
And I close the current editor
And I switch the current editor to editor "Verkaufslieferschein41"
And I close the current editor

Scenario: 04 Behaelter anlegen
Given I open an editor "behaelter4" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "BEH_FEHLERMELDUNG"
And I set field "packm" to "KLT"
And I save the current editor

Scenario: 04 Verkaufslieferschein Fehlermeldungen (8343 Der angegebene Behaelter ist leer; 8311 Der Artikel ist nicht mit den passenden Gebindeinformationen im Behaelter enthalten.)
Given I open an editor "Verkaufslieferschein42" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "PEDALE" in row 1
And I set field "mge" to "5" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
# Fehler 8343: Der angegebene Behaelter ist leer
Then setting field "behaelter" in row 1 to "such" from editor "behaelter4" in row 0 throws the exception "8343"
And I close the current editor
And I switch the current editor to editor "Verkaufslieferschein42"
And I close the current editor

Given I open an editor "Lagerbuchung4" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "PEDALE"
And I set field "buart" to "Zugang"
And I set field "beleg" to "LM04"
And I set field "beldat" to "."
And I set field "mge" to "5" in row 1
And I set field "behaelter" to id from editor "behaelter4" in row 1
And I save the current editor

Given I open an editor "Verkaufslieferschein43" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 1
And I set field "mge" to "5" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
# Fehler 8311: Der Artikel ist nicht mit den passenden Gebindeinformationen im Behaelter enthalten
Then setting field "behaelter" in row 1 to "such" from editor "behaelter4" in row 0 throws the exception "8311"
And I close the current editor
And I switch the current editor to editor "Verkaufslieferschein43"
And I close the current editor


@MZ_Verkaufslieferschein
Scenario: 05 Fehlermeldung (8367 Es kann nur der gesamte Inhalt eines Behaelter verschickt werden.)
Given I open an editor "behaelter5" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "FEHLER_BEHINHALT"
And I set field "packm" to "KLT"
And I save the current editor

Given I open an editor "Lagerbuchung5" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "SATTEL"
And I set field "buart" to "Zugang"
And I set field "beleg" to "LM05"
And I set field "beldat" to "."
And I set field "mge" to "5" in row 1
And I set field "behaelter" to id from editor "behaelter5" in row 1
And I save the current editor

Given I open an editor "Lagerbuchung5" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "RAD"
And I set field "buart" to "Zugang"
And I set field "beleg" to "LM05"
And I set field "beldat" to "."
And I set field "mge" to "5" in row 1
And I set field "behaelter" to id from editor "behaelter5" in row 1
And I save the current editor

Given I open an editor "Verkaufslieferschein5" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "such" to "VKLS_05"
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "RAD" in row 1
And I set field "mge" to "5" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "5" in row !lastRow
And I set field "behaelter" to id from editor "behaelter5" in row !lastRow
And I save the current subeditor to switch back to the parent editor
And I set field "ueb" to "JA"
# Fehler 8367: Es kann nur der gesamte Inhalt eines Behaelter verschickt werden
Then saving the current editor throws the exception "8367"
And I close the current editor

@MZ_Verkaufslieferschein
Scenario: 06 Behaelter kann zu einer Artikelposition mehrfach mit den gleichen Details angegeben werden
Given I open an editor "behaelter6" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "BEH_EINMALIG"
And I set field "packm" to "KLT"
And I save the current editor

Given I open an editor "Lagerbuchung6" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "PEDALE"
And I set field "buart" to "Zugang"
And I set field "beleg" to "LM06"
And I set field "beldat" to "."
And I set field "mge" to "10" in row 1
And I set field "behaelter" to id from editor "behaelter6" in row 1
And I save the current editor

Given I open an editor "Verkaufslieferschein6" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "PEDALE" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "5" in row 1
And I set field "behaelter" to id from editor "behaelter6" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "5" in row 2
And I set field "behaelter" to id from editor "behaelter6" in row 2
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein6"
And I set field "ueb" to "ja"
And I save the current editor

Scenario: 06 Behaelter pruefen
And I switch the current editor to editor "behaelter6"
Then the table has 0 rows
And I close the current editor


@MZ_Verkaufslieferschein
Scenario Outline: 07 eingetragener Behaelter in Artikelzeile und MZ weichen voneinender ab
Given I open an editor "<editor>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "<packm>"
And I save the current editor

Examples: Behaelter anlegen
| editor       | such                | packm |
| behaelter7_1 | ABWEICH_MZ_ARTPOS_1 | KLT   |
| behaelter7_2 | ABWEICH_MZ_ARTPOS_2 | KLT   |

Scenario Outline: 07 Lagerbuchung eingetragener Behaelter in Artikelzeile und MZ weichen voneinender ab
Given I open an editor "<editorL>" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "PEDALE"
And I set field "buart" to "Zugang"
And I set field "beleg" to "LM071"
And I set field "beldat" to "."
And I set field "mge" to "5" in row 1
And I set field "behaelter" to id from editor "<editorbeh>" in row 1
And I save the current editor

Examples: Lagerbuchung
| editorL         | editorbeh    |
| Lagerbuchung7_1 | behaelter7_1 |
| Lagerbuchung7_1 | behaelter7_2 |


# 8.3. Lisa, Behaelterkonto wird nicht bebucht, VERSAND-836
Scenario: 07 Verkaufslieferschein eingetragener Behaelter in Artikelzeile und MZ weichen voneinender ab
Given I open an editor "Verkaufslieferschein7" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "PEDALE" in row 1
And I set field "mge" to "5" in row 1
And I set field "behaelter" to id from editor "behaelter7_1" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "5" in row 1
And I set field "behaelter" to id from editor "behaelter7_2" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein7"
And I set field "ueb" to "ja"
Then field "mge" has value "5" in row 1
Then field "behaelter" in row 1 has value equal to field "nummer" from editor "behaelter7_1" in row 0
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Abgang" in row 1

Scenario: 07 Behaelter pruefen
And I open an editor "beaelterpruef1" from table "(Container):(ContainerShell)" with command "VIEW" for record "ABWEICH_MZ_ARTPOS_1"
Then the table has 1 rows
And I close the current editor
And I open an editor "beaelterpruef2" from table "(Container):(ContainerShell)" with command "VIEW" for record "ABWEICH_MZ_ARTPOS_2"
Then the table has 0 rows
Then field "kl" is empty
Then field "behstatusaz" has value "Geliefert"
Then field "behleer" has value "nein"
And I close the current editor

Scenario: 07 Lagerjournal pruefen eingetragener Behaelter in Artikelzeile und MZ weichen voneinender ab
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "nummer" from editor "Verkaufslieferschein7"
And I press start
Then the table has 1 rows
Then field "amge" has value "5" in row 1
Then field "mei" has value "Paar" in row 1
And I close the current editor


@MZ_Verkaufslieferschein
Scenario: 08 Artikel mit Packanweisung (berechnete Packmittel) versenden
Given I open an editor "behaelter8" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "BER_PACKANWEISUNG"
And I set field "packm" to "KLT"
And I save the current editor

Scenario: 08 Lagerbuchung Artikel mit Packanweisung (berechnete Packmittel) versenden
Given I open an editor "Lagerbuchung8" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "RAD"
And I set field "buart" to "Zugang"
And I set field "beleg" to "LM08"
And I set field "beldat" to "."
And I set field "mge" to "5" in row 1
And I set field "behaelter" to id from editor "behaelter8" in row 1
And I save the current editor

# 8.3. Lisa, Behaelterkonto wird nicht bebucht, VERSAND-836
Scenario: 08 Verkaufslieferschein Artikel mit Packanweisung (berechnete Packmittel) versenden
Given I open an editor "Verkaufslieferschein8" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "RAD" in row 1
And I set field "mge" to "5" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to id from editor "behaelter8" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein8"
And I press button "packvor"

Then the table has 4 rows
Then field "behaelter" is not modifiable in row 2
Then field "behaelter" is not modifiable in row 3
Then field "behaelter" is not modifiable in row 4

And I set field "ueb" to "ja"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Abgang" in row 1

Scenario: 08 Behaelter pruefen
And I open an editor "beaelterpruef" from table "(Container):(ContainerShell)" with command "VIEW" for record "BER_PACKANWEISUNG"
Then the table has 0 rows
Then field "kl" is empty
Then field "behstatusaz" has value "Geliefert"
Then field "behleer" has value "nein"
And I close the current editor


@MZ_Verkaufslieferschein
Scenario: 09 Artikel mit manuellen Packmittelzeilen versenden
Given I open an editor "behaelter9" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "MAN_PACKMITTELZEILE"
And I set field "packm" to "KLT"
And I save the current editor

Scenario: 09 Lagerbuchung Artikel mit manuellen Packmittelzeilen versenden
Given I open an editor "Lagerbuchung9" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "RAD"
And I set field "buart" to "Zugang"
And I set field "beleg" to "806_LM09"
And I set field "beldat" to "."
And I set field "mge" to "5" in row 1
And I set field "behaelter" to id from editor "behaelter9" in row 1
And I save the current editor

# 8.3. Lisa, Behaelterkonto wird nicht bebucht, VERSAND-836
Scenario: 09 Verkaufslieferschein Artikel mit manuellen Packmittelzeilen versenden
Given I open an editor "Verkaufslieferschein9" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "RAD" in row 1
And I set field "mge" to "5" in row 1
Then field "packanw^such" has value "PACKA2" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to id from editor "behaelter9" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein9"
Then field "packanw^such" has value "PACKA2" in row 1
And I press button "pmneu" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "KLT" in row 2
And I set field "mge" to "1" in row 2
And I set field "fmenge" to "5" in row 2
And I set field "ueb" to "ja"

Then field "behaelter" is modifiable in row 1
Then field "behaelter" is not modifiable in row 2
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
Then field "behaelter" is modifiable in row 1
And I close the current editor
And I switch the current editor to editor "Verkaufslieferschein9"

And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Abgang" in row 1

Scenario: 09 Behaelter pruefen
Given I switch the current editor to editor "behaelter9" with command "VIEW"
Then the table has 0 rows
Then field "kl" is empty
Then field "behstatusaz" has value "Geliefert"
Then field "behleer" has value "nein"
And I close the current editor


@MZ_Verkaufslieferschein
Scenario: 10 Feld kl bleibt bei Versand von Behaelter gefuellt; Lieferant
Given I open an editor "behaelter10" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "KL_GEFUELLT"
And I set field "packm" to "KLT"
And I save the current editor

Scenario: 10 Einkaufslieferschein Feld kl bleibt bei Versand von Behaelter gefuellt; Lieferant
Given I open an editor "Einkaufslieferschein10" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "ebeleg" to "E-Lieferschein_10"
And I set field "lief" to "KETTLER"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 1
And I set field "mge" to "2" in row 1
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "nummer" from editor "behaelter10" in row 1
And I set field "packm" to "KLT" in row 1
And I set field "ueb" to "JA"
And I save the current editor

Scenario: 10 Verkaufslieferschein Feld kl bleibt bei Versand von Behaelter gefuellt; Lieferant
Given I open an editor "Verkaufslieferschein10" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 1
And I set field "mge" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to id from editor "behaelter10" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein10"
And I set field "ueb" to "JA"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Abgang" in row 1

Scenario: 10 Behaelter pruefen
And I open an editor "beaelter" from table "(Container):(ContainerShell)" with command "VIEW" for record "KL_GEFUELLT"
Then the table has 0 rows
Then field "kl^such" has value ""
Then field "behstatusaz" has value "Geliefert"
Then field "behleer" has value "nein"
And I close the current editor


# 8.3. Lisa, Behaelterkonto bei Ruecklieferung wird nicht bebucht, VERSAND-836
@MZ_Verkaufslieferschein
Scenario: 11 Ruecklieferung ein Artikel, Behaelter anlegen
Given I open an editor "Verkaufslieferschein11" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "RAHMEN" in row 1
And I set field "mge" to "5" in row 1
And I set field "ueb" to "JA"
And I save the current editor

Given I open an editor "VKRueck_11" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "Verkaufslieferschein11"
And I set field "vom" to "."
And I set field "mge" to "-3" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I press button "burueckmzzuord"
And I set field "zuomge" to "-3" in row 1
And I set field "exbehnum" to "BEH_ANLEGEN_B14" in row 1
And I set field "packm" to "KLT" in row 1
And I save the current editor
And I switch the current editor to editor "VKRueck_11"
And I set field "ueb" to "JA"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1

Scenario: 11 Behaelter pruefen
And I open an editor "beahelter" from table "(Container):(ContainerShell)" with command "VIEW" for record "BEH_ANLEGEN_B14"
Then the table has 1 rows
Then field "kl^such" has value "RADSHOP"
And I close the current editor


@MZ_Verkaufslieferschein
Scenario: 12 Ruecklieferung zwei Artikel, bestehender Behaelter und Behaelter anlegen
Given I open an editor "behaelter12" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "RUECK_BESTEHENDER_BEH"
And I set field "packm" to "KLT"
And I save the current editor

# 8.3. Lisa, Behaelterkonto wird nicht bebucht, VERSAND-836
Scenario: 12 Verkaufslieferschein Ruecklieferung zwei Artikel, bestehender Behaelter und Behaelter anlegen
Given I open an editor "Verkaufslieferschein12" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "RAHMEN" in row 1
And I set field "mge" to "5" in row 1
And I set field "ueb" to "JA"
And I save the current editor


Given I open an editor "VKRueck_12" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "Verkaufslieferschein12"
And I set field "vom" to "."
And I set field "mge" to "-3" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I create a new row at the end of the table
And I set field "zuomge" to "-1" in row 1
And I set field "exbehnum" to "RUECK_NEUERBEH_B14" in row 1
And I set field "packm" to "KLT" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "-2" in row 2
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "nummer" from editor "behaelter12" in row 2
And I save the current editor
And I switch the current editor to editor "VKRueck_12"
And I set field "ueb" to "JA"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1

Scenario Outline: 12 Behaelter pruefen Ruecklieferung zwei Artikel, bestehender Behaelter und Behaelter anlegen
And I open an editor "<behaelterpruef>" from table "(Container):(ContainerShell)" with command "VIEW" for record "<behrecord>"
Then the table has 1 rows
Then field "artikel" has value "<artikel>" in row 1
Then field "kl^such" has value "<kl>"
And I close the current editor

Examples: Behaelter pruefen
| editorpruef     | behrecord             | artikel | kl      |
| behaelterpruef1 | RUECK_BESTEHENDER_BEH | RAHMEN  |         |
| behaelterpruef2 | RUECK_NEUERBEH_B14    | RAHMEN  | RADSHOP |


@MZ_Verkaufslieferschein
Scenario: 13 Ruecklieferung Fehlermeldung (8370 Behaelter darf nur einmal zu einer Artikelposition angegeben werden.)
Given I open an editor "Verkaufslieferschein13" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "RAHMEN" in row 1
And I set field "mge" to "5" in row 1
And I set field "ueb" to "JA"
And I save the current editor

Given I open an editor "VKRueck_13" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "Verkaufslieferschein13"
And I set field "vom" to "."
And I set field "mge" to "-3" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I create a new row at the end of the table
And I set field "zuomge" to "-1" in row 1
And I set field "exbehnum" to "BEH_EINMAL_ANGEBEN" in row 1
And I set field "packm" to "KLT" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "-2" in row 2
And I set field "exbehnum" to "BEH_EINMAL_ANGEBEN" in row 2
And I set field "packm" to "KLT" in row 2
Then saving the current editor throws the exception "8370"
And I close the current editor
And I switch the current editor to editor "VKRueck_13"
And I close the current editor


@MZ_Verkaufslieferschein
Scenario: 14 Ruecklieferung zwei unterschiedliche Artikel, bestehender Behaelter, MZ und Artikelzeile
Given I open an editor "behaelter14" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "VERSCH_ARTIKEL"
And I set field "packm" to "KLT"
And I save the current editor

# 8.3. Lisa, Behaelterkonto wird nicht bebucht, VERSAND-836
Scenario: 14 Verkaufslieferschein Ruecklieferung zwei unterschiedliche Artikel, bestehender Behaelter, MZ und Artikelzeile
Given I open an editor "Verkaufslieferschein14" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "RAHMEN" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "RAHMEN" in row 2
And I set field "mge" to "10" in row 2
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 3
And I set field "mge" to "10" in row 3
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 4
And I set field "mge" to "10" in row 4
And I set field "ueb" to "JA"
And I save the current editor

Given I open an editor "VKRueck_14" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "Verkaufslieferschein14"
And I set field "vom" to "."
And I set field "mge" to "-5" in row 1
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "nummer" from editor "behaelter14" in row 1
And I set field "mge" to "-5" in row 2
And I set field "mge" to "-5" in row 3
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "nummer" from editor "behaelter14" in row 3
And I set field "mge" to "-5" in row 4

And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I press button "burueckmzzuord"
And I set field "zuomge" to "-5" in row 1
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "nummer" from editor "behaelter14" in row 1
And I save the current editor
And I switch the current editor to editor "VKRueck_14"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 3
And I press button "burueckmzzuord"
And I set field "zuomge" to "-5" in row 1
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "nummer" from editor "behaelter14" in row 1
And I save the current editor
And I switch the current editor to editor "VKRueck_14"

And I set field "ueb" to "ja"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1
#Then field "bhbuchung^mge" has value "0" in row 2
#Then field "bhbuchung^buart" has value "" in row 2

Scenario: 14 Behaelter pruefen Ruecklieferung zwei unterschiedliche Artikel, bestehender Behaelter, MZ und Artikelzeile
And I switch the current editor to editor "behaelter14"
Then the table has 2 rows
Then field "kl^such" has value ""
Then field "behstatusaz" has value ""
Then field "mge" has value "10" in row 1
Then field "mge" has value "5" in row 2
And I close the current editor


@MZ_Verkaufslieferschein1
Scenario: 15 ein Artikel mit Charge versenden, Pruefung der Gebindeinformationen (8367 Es kann nur der geamte Inhalt eines Behaelters verschickt werden)
Given I open an editor "behaelter15" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "ARTIKEL_MIT_CHARGE"
And I set field "packm" to "KLT"
And I save the current editor

Given I open an editor "Charge15" from table "(Lots):(Lots)" with command "STORE" for record "CHARGE_IM_VK15"
And I set field "such" to "CHARGE_IM_VK15"
And I set field "exnum" to "CHARGE_IM_VK15"
And I set field "artikel" to "SATTEL"
And I save the current editor

Given I open an editor "Lagerbuchung15" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "SATTEL"
And I set field "buart" to "Zugang"
And I set field "beleg" to "806_LM15"
And I set field "beldat" to "."
And I set field "mge" to "5" in row 1
And I set field "behaelter" to id from editor "behaelter15" in row 1
And I set field "charge2" to "CHARGE_IM_VK15" in row 1
And I save the current editor

Scenario: 15 Verkaufslieferschein ein Artikel mit Charge versenden, Pruefung der Gebindeinformationen (158: Der Artikel ist nicht oder nicht ausreichend mit passender Auspraegung im Behaelter)
Given I open an editor "Verkaufslieferschein15" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 1
And I set field "mge" to "5" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to id from editor "behaelter15" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein15"
And I set field "ueb" to "JA"
# Fehler 158: Der Artikel ist nicht oder nicht ausreichend mit passender Auspraegung im Behaelter
Then saving the current editor throws the exception "158"
And I set field "charge" to "CHARGE_IM_VK15" in row 1
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Abgang" in row 1

Scenario: 15 Behaelter pruefen
And I open an editor "beaelterpruef" from table "(Container):(ContainerShell)" with command "VIEW" for record "ARTIKEL_MIT_CHARGE"
Then the table has 0 rows
Then field "kl" has value ""
Then field "behstatusaz" has value "Geliefert"
And I close the current editor


@MZ_Verkaufslieferschein
Scenario Outline: 16 Artikel mit Charge in Artikelpos. und MZ mit und ohne Charge kann nicht gebucht werden
Given I open an editor "<cheditor>" from table "(Lots):(Lots)" with command "STORE" for record "<chargerec>"
And I set field "such" to "<such>"
And I set field "exnum" to "<exnum>"
And I set field "artikel" to "SATTEL"
And I save the current editor

Examples: Chargen anlegen
| cheditor   | chargerec           | such                | exnum               |
| Charge16_1 | CHARGE_SATTEL_VK16  | CHARGE_SATTEL_VK16  | CHARGE_SATTEL_VK16  |
| Charge16_2 | CHARGE2_SATTEL_VK16 | CHARGE_SATTEL2_VK16 | CHARGE_SATTEL2_VK16 |


Scenario: 16 Artikel mit Charge in Artikelpos. und MZ mit und ohne Charge kann nicht gebucht werden
Given I open an editor "behaelter16" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "BEH_CHARGEN"
And I set field "packm" to "KLT"
And I save the current editor


Scenario: 16 Einkaufslieferschein Artikel mit Charge in Artikelpos. und MZ mit und ohne Charge kann nicht gebucht werden
Given I open an editor "einkaufslieferschein16" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "KETTLER"
And I set field "vom" to "."
And I set field "ebeleg" to "EK-Lieferschein_16"
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 1
And I set field "mge" to "15" in row 1
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "nummer" from editor "behaelter16" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "5" in row 1
And I set field "charge" to id from editor "Charge16_1" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "5" in row 2
And I set field "charge" to id from editor "Charge16_2" in row 2
And I create a new row at the end of the table
And I set field "zuomge" to "5" in row 3
And I save the current editor
And I switch the current editor to editor "einkaufslieferschein16"
And I set field "ueb" to "JA"
And I save the current editor

Scenario: 16 Behaelter pruefen
And I open an editor "beaelterpruef1" from table "(Container):(ContainerShell)" with command "VIEW" for record "BEH_CHARGEN"
Then the table has 3 rows
Then field "charge" has value "" in row 1
Then field "charge^such" has value "CHARGE_SATTEL_VK16" in row 2
Then field "charge^such" has value "CHARGE_SATTEL2_VK16" in row 3
And I close the current editor

Scenario: 16 Verkaufslieferschein Artikel mit Charge in Artikelpos. und MZ mit und ohne Charge kann nicht gebucht werden
Given I open an editor "Verkaufslieferschein16" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 1
And I set field "mge" to "15" in row 1
And I set field "behaelter" to id from editor "behaelter16" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "5" in row 1
And I set field "charge" to id from editor "Charge16_1" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "5" in row 2
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein16"
And I set field "mge" to "15" in row 1
And I set field "charge" to id from editor "Charge16_2" in row 1
Then field "behaelter" in row 1 has value equal to field "nummer" from editor "behaelter16" in row 0
And I set field "ueb" to "ja"
# Fehler 158: Der Artikel ist nicht oder nicht ausreichend mit passender Auspraegung im Behaelter
And saving the current editor throws the exception "158"
And I close the current editor


@MZ_Verkaufslieferschein
Scenario: 17 Ruecklieferung ein Artikel mit Charge
Given I open an editor "behaelter17" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "RUECK_CHARGE"
And I set field "packm" to "KLT"
And I save the current editor

Given I open an editor "Charge17" from table "(Lots):(Lots)" with command "STORE" for record "RUECK_CHARGE_VK17"
And I set field "such" to "RUECK_CHARGE_VK17"
And I set field "exnum" to "RUECK_CHARGE_VK17"
And I set field "artikel" to "SATTEL"
And I save the current editor

# 8.3. Lisa, Behaelterkonto wird nicht bebucht, VERSAND-836
Scenario: 17 Verkaufslieferschein Ruecklieferung ein Artikel mit Charge
Given I open an editor "Verkaufslieferschein17" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 1
And I set field "mge" to "3" in row 1
And I set field "charge" to id from editor "Charge17" in row 1
And I set field "ueb" to "JA"
And I save the current editor

Given I open an editor "VKRueck_17" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "Verkaufslieferschein17"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "-2" in row 1
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "nummer" from editor "behaelter17" in row 1
And I set field "charge" to id from editor "Charge17" in row 1
And I set field "ueb" to "JA"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1

Scenario: 17 Behaelter pruefen
And I switch the current editor to editor "behaelter17" with command "VIEW"
Then the table has 1 rows
Then field "charge^such" has value "RUECK_CHARGE_VK17" in row 1
And I close the current editor


@MZ_Verkaufslieferschein
Scenario: 18 Ruecklieferung mehrere Artikel mit und ohne Charge, ueber MZ und in der Zeile, bestehender und neuer Behaelter
Given I open an editor "behaelter18" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "RUECK_CHARGE_BESTBEH"
And I set field "packm" to "KLT"
And I save the current editor

Given I open an editor "Charge18" from table "(Lots):(Lots)" with command "STORE" for record "RUECK_CHARGE_VK18"
And I set field "such" to "RUECK_CHARGE_VK18"
And I set field "exnum" to "RUECK_CHARGE_VK18"
And I set field "artikel" to "SATTEL"
And I save the current editor

Scenario: 18 Verkaufslieferschein Ruecklieferung mehrere Artikel mit und ohne Charge, ueber MZ und in der Zeile, bestehender und neuer Behaelter
Given I open an editor "Verkaufslieferschein18" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 1
And I set field "mge" to "20" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "5" in row 1
And I set field "charge" to "RUECK_CHARGE_VK18" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "15" in row 2
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein18"
And I create a new row at the end of the table
And I set field "artikel" to "RAD" in row 2
And I set field "mge" to "20" in row 2
And I set field "ueb" to "JA"
And I save the current editor


Given I open an editor "VKRueck_18" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "Verkaufslieferschein18"
And I set field "vom" to "."
And I set field "mge" to "-10" in row 1
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "nummer" from editor "behaelter18" in row 1
And I set field "mge" to "-10" in row 2
And I set field "exbehnum" to "RUECK_CHARGE_NEUBEH_B14" in row 2
And I set field "packm" to "KLT" in row 2

And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "-5" in row 1
And I set field "charge" to "RUECK_CHARGE_VK18" in row 1
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "nummer" from editor "behaelter18" in row 1
And I press button "burueckmzzuord"
And I set field "mzueb" to "nein"
And I save the current editor
And I switch the current editor to editor "VKRueck_18"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I press button "burueckmzzuord"
And I set field "zuomge" to "-5" in row 1
And I set field "exbehnum" to "RUECK_CHARGE_NEUBEH_B14" in row 1
And I set field "packm" to "KLT" in row 1
And I set field "mzueb" to "nein"
And I save the current editor
And I switch the current editor to editor "VKRueck_18"
And I set field "ueb" to "ja"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1
#Then field "bhbuchung^mge" has value "1" in row 2
#Then field "bhbuchung^buart" has value "Zugang" in row 2

Scenario: 18 Behaelter pruefen
And I open an editor "behaelterpruef1" from table "(Container):(ContainerShell)" with command "VIEW" for record "RUECK_CHARGE_BESTBEH"
Then the table has 2 rows
Then field "mge" has value "5" in row 2
Then field "charge^such" has value "RUECK_CHARGE_VK18" in row 2
Then field "charge" has value "" in row 1
Then field "mge" has value "5" in row 1
And I close the current editor

And I open an editor "behaelterpruef1" from table "(Container):(ContainerShell)" with command "VIEW" for record "RUECK_CHARGE_NEUBEH_B14"
Then the table has 1 rows
Then field "mge" has value "20" in row 1
Then field "charge" has value "" in row 1
And I close the current editor


@MZ_Verkaufslieferschein
Scenario: 19 COPY Verkaufslieferschein leert Behaelterfelder
Given I open an editor "behaelter19" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "COPY_VKLIEFERSCHEIN"
And I set field "packm" to "KLT"
And I save the current editor

Given I open an editor "Lagerbuchung19" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "SATTEL"
And I set field "buart" to "Zugang"
And I set field "beleg" to "LM19"
And I set field "beldat" to "."
And I set field "mge" to "2" in row 1
And I set field "behaelter" to id from editor "behaelter19" in row 1
And I save the current editor

Scenario: 19 Verkaufslieferschein COPY Verkaufslieferschein leert Behaelterfelder
Given I open an editor "Verkaufslieferschein19" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 1
And I set field "mge" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to id from editor "behaelter19" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein19"
And I set field "ueb" to "ja"
And I save the current editor

And I switch the current editor to editor "Verkaufslieferschein19" with command "COPY"
Then field "behaelter" is empty in row 1
Then field "exbehnum" is empty in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then field "behaelter" is empty in row 1

And I close the current editor
And I switch the current editor to editor "Verkaufslieferschein19"
And I close the current editor


# kann nicht getestet werden, da Button in MZ zum Aufrufen der naechsten Zeile nicht aufgerufen werden kann
# Fuer Setartikel kann in der Artikelposition ein Behaelter angegeben werden
#Scenario: 20 Lieferant SETL
#Scenario: 20 Setartikel anlegen
#Scenario: 20 Auftrag erstellen (ein Behaelter nur ueber MZ)
#Scenario: 20 Dispo starten (ein Behaelter nur ueber MZ)
#Scenario: 20 Bestellvorschlag freigeben (ein Behaelter nur ueber MZ)
#Scenario: 20 Bestellungen liefern in einen Behaelter (ein Behaelter nur ueber MZ)
#Scenario: 20 Fuer Setartikel kann kein Behaelter in Artikelzeile angegeben werden, Artikel kann ueber MZ aus einem Behaelter entnommen werden


@Verkaufsprozess
Scenario: 21 Verkaufsprozess - Behaelter anlegen
Given I open an editor "behaelter21" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "VERKAUFSPROZESS"
And I set field "packm" to "KLT"
And I save the current editor

Scenario: 21 Verkaufsprozess - Lagerbuchung
Given I open an editor "Lagerbuchung21" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "Fahrrad"
And I set field "buart" to "Zugang"
And I set field "beleg" to "LM21"
And I set field "beldat" to "."
And I set field "wert" to "600"
And I set field "mge" to "10" in row 1
And I set field "behaelter" to id from editor "behaelter21" in row 1
And I save the current editor

Scenario: 21 Verkaufsprozess - Auftrag
Given I open an editor "auftrag21" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "betreff" to "Bestellung Fahrrad"
And I set field "such" to "BRADSHOP"
When I create a new row at the end of the table
And I set field "artikel" to "FAHRRAD" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

Scenario: 21 Verkaufsprozess - Lieferschein
Given I open an editor "Verkaufslieferschein21" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to "id" from editor "auftrag21"
And I set field "mge" to "10" in row 1
And I set field "verw" to "" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to id from editor "behaelter21" in row 1
And I set field "verw" to "" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein21"
And I set field "such" to "PROZESS21"
And I set field "ueb" to "JA"
And I save the current editor

Scenario: 21 Behaelter VK pruefen
And I open an editor "beaelterpruef" from table "(Container):(ContainerShell)" with command "VIEW" for record "VERKAUFSPROZESS"
Then the table has 0 rows
And I close the current editor

Scenario: 21 Verkaufsprozess - Ruecklieferung neuer Behaelter
Given I open an editor "Verkaufslieferschein21_R" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "Verkaufslieferschein21"
And I set field "mge" to "-5" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "-5" in row 1
And I set field "exbehnum" to "PROZESS_RUECK_B14" in row 1
And I set field "packm" to "KLT" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein21_R"
And I set field "ueb" to "JA"
And I save the current editor

Scenario: 21 Behaelter Ruecklieferung pruefen
And I open an editor "beaelter-r-pruef" from table "(Container):(ContainerShell)" with command "VIEW" for record "PROZESS_RUECK "
Then the table has 1 rows
Then field "mge" has value "5" in row 1
And I close the current editor


Scenario: 21 Verkaufsprozess - Ruecklieferung bestehender Behaelter
Given I open an editor "behaelter21_R" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "exbehnum" to "PROZESS_RUECK_B"
And I set field "packm" to "KLT"
And I save the current editor

Given I open an editor "Verkaufslieferschein21_R2" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "Verkaufslieferschein21"
And I set field "mge" to "-5" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "-5" in row 1
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "nummer" from editor "behaelter21_R" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein21_R2"
And I set field "ueb" to "JA"
And I save the current editor

Scenario: 21 Behaelter Ruecklieferung pruefen
And I open an editor "beaelter-r2-pruef" from table "(Container):(ContainerShell)" with command "VIEW" for record "PROZESS_RUECK_B"
Then the table has 1 rows
Then field "mge" has value "5" in row 1
And I close the current editor


Scenario: 22 Behaelter anlegen
Given I open an editor "behaelter22" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "MIT_OHNECHARGE"
And I set field "packm" to "KLT"
And I save the current editor

Scenario: 22 Charge anlegen
Given I open an editor "charge22" from table "59:0" with command "STORE" for record "CHARGE_22"
And I set field "such" to "CHARGE_22"
And I set field "artikel" to "RAD"
And I save the current editor

Scenario: 22 Lagerbuchung
Given I open an editor "Lagerbuchung22" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "RAD"
And I set field "buart" to "Zugang"
And I set field "beleg" to "L22"
And I set field "beldat" to "."
And I set field "mge" to "4" in row 1
And I set field "behaelter" to id from editor "behaelter22" in row 1
And I create a new row at the end of the table
And I set field "mge" to "6" in row 2
And I set field "charge2" to id from editor "charge22" in row 2
And I set field "behaelter" to id from editor "behaelter22" in row 2
And I save the current editor

# 4.4. Lisa, behaelterkonto wird nicht bebucht, VERSAND-836
Scenario: 22 Packmittel berechnen, ein Artikel, Charge, ein Behaelter
Given I open an editor "Verkaufslieferschein22" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "RAD" in row 1
And I set field "mge" to "10" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "6" in row 1
And I set field "behaelter" to id from editor "behaelter22" in row 1
And I set field "charge" to id from editor "charge22" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "4" in row 2
And I set field "behaelter" to id from editor "behaelter22" in row 2
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein22"
And I press button "packvor"

Then the table has 4 rows
Then field "artikel^such" has value "KLT" in row 2
Then field "mge" has value "1" in row 2
Then field "artikel^such" has value "KLT" in row 3
Then field "mge" has value "3" in row 3
Then field "artikel^such" has value "SPALETTE" in row 4
Then field "mge" has value "1" in row 4

And I set field "ueb" to "ja"
And I save the current editor

#Then field "bhbuchung" has value "" in row 1
#Then field "bhbuchung^mge" has value "1" in row 2
#Then field "bhbuchung^buart" has value "Abgang" in row 2
#Then field "bhbuchung^mge" has value "3" in row 3
#Then field "bhbuchung^buart" has value "Abgang" in row 3

Scenario: 22 Behaelter pruefen
And I switch the current editor to editor "behaelter22" with command "VIEW"
Then the table has 0 rows
And I close the current editor


Scenario Outline: 23 Behaelter anlegen
Given I open an editor "<beheditor>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "KLT"
And I save the current editor

Examples: Behaelter anlegen
| beheditor     | such                |
| behaelter23_1 | RICHTIGE_FUELLMGE_1 |
| behaelter23_2 | RICHTIGE_FUELLMGE_2 |

Scenario: 23 Lagerbuchung
Given I open an editor "Lagerbuchung23" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "RAD"
And I set field "buart" to "Zugang"
And I set field "beleg" to "L23"
And I set field "beldat" to "."
And I set field "mge" to "10" in row 1
And I set field "behaelter" to id from editor "behaelter23_1" in row 1
And I create a new row at the end of the table
And I set field "mge" to "10" in row 2
And I set field "behaelter" to id from editor "behaelter23_2" in row 2
And I save the current editor

# 4.4. Lisa, behaelterkonto wird nicht bebucht, VERSAND-836
Scenario: 23 Packmittel berechnen, ein Artikel, mehrere Behaelter, richtige Fuellmenge
Given I open an editor "Verkaufslieferschein23" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "RAD" in row 1
And I set field "mge" to "20" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "10" in row 1
And I set field "behaelter" to id from editor "behaelter23_1" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "10" in row 2
And I set field "behaelter" to id from editor "behaelter23_2" in row 2
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein23"
And I press button "packvor"

Then the table has 4 rows
Then field "artikel^such" has value "RAD" in row 1
Then field "artikel^such" has value "KLT" in row 2

And I set field "ueb" to "ja"
And I save the current editor

#Then field "bhbuchung^mge" has value "2" in row 2
#Then field "bhbuchung^buart" has value "Abgang" in row 2
#Then field "bhbuchung^mge" has value "2" in row 3
#Then field "bhbuchung^buart" has value "Abgang" in row 3

Scenario: 23 Behaelter pruefen
And I switch the current editor to editor "behaelter23_1"
Then the table has 0 rows
And I close the current editor
And I switch the current editor to editor "behaelter23_2"
Then the table has 0 rows
And I close the current editor


# 4.4. Lisa, behaelterkonto wird nicht bebucht, VERSAND-836
Scenario: 24 Charge anlegen
Given I open an editor "charge24" from table "59:0" with command "STORE" for record "CHARGE_24"
And I set field "such" to "CHARGE_24"
And I set field "artikel" to "RAD"
And I save the current editor

Scenario Outline: 24 Behaelter anlegen
Given I open an editor "<such>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "<packm>"
And I save the current editor

Examples: Behaelter
| such    | packm |
| BEH24_1 | KLT   |
| BEH24_2 | KLT   |
| BEH24_3 | KLT   |
| BEH24_4 | KLT   |


Scenario Outline: 24 Lagerbuchung
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "RAD"
And I set field "buart" to "Zugang"
And I set field "beleg" to "L24"
And I set field "beldat" to "."
And I set field "mge" to "<mge>" in row 1
And I set field "behaelter" to id from editor "<behaelter>" in row 1
And I set field "charge2" to "<charge>" in row 1
And I save the current editor

Examples: Lagerbuchung
| mge | behaelter | charge      |
| 5   | BEH24_4   | CHARGE_24   |
| 6   | BEH24_3   | !dontChange |
| 2   | BEH24_1   | !dontChange |
| 2   | BEH24_2   | !dontChange |


Scenario: 24 Packmittel berechnen, ein Artikel in mehreren Zeilen, mehrere Behaelter MZ und Artikelzeile
Given I open an editor "Verkaufslieferschein24" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "RAD" in row 1
And I set field "mge" to "10" in row 1
And I set field "fmenge" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "mzueb" to "nein"
And I set field "zuomge" to "2" in row 1
And I set field "behaelter" to id from editor "BEH24_1" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "2" in row 2
And I set field "behaelter" to id from editor "BEH24_2" in row 2
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein24"
And I set field "behaelter" to id from editor "BEH24_3" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "RAD" in row 2
And I set field "mge" to "5" in row 2
And I set field "charge" to id from editor "charge24" in row 2
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I set field "zuomge" to "5" in row 1
And I set field "behaelter" to id from editor "BEH24_4" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein24"
And I create a new row at the end of the table
And I set field "artikel" to "RAD" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I press button "packvor"

Then the table has 11 rows
Then field "artikel^such" has value "KLT" in row 2
Then field "mge" has value "1" in row 2
Then field "fmenge" has value "6" in row 2
Then field "artikel^such" has value "KLT" in row 3
Then field "mge" has value "2" in row 3
Then field "fmenge" has value "2" in row 3

Then field "artikel^such" has value "KLT" in row 5
Then field "mge" has value "1" in row 5
Then field "fmenge" has value "5" in row 5
Then field "artikel^such" has value "SPALETTE" in row 7
Then field "mge" has value "1" in row 7

Then field "artikel^such" has value "KLT" in row 9
Then field "mge" has value "1" in row 9
Then field "fmenge" has value "10" in row 9
Then field "artikel^such" has value "SPALETTE" in row 11
Then field "mge" has value "1" in row 11

And I set field "ueb" to "ja"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 2
#Then field "bhbuchung^buart" has value "Abgang" in row 2
#Then field "bhbuchung^mge" has value "2" in row 3
#Then field "bhbuchung^buart" has value "Abgang" in row 3
#Then field "bhbuchung^mge" has value "1" in row 5
#Then field "bhbuchung^buart" has value "Abgang" in row 5

Scenario Outline: 24 Behaelter pruefen
And I switch the current editor to editor "<behaelter>"
Then the table has 0 rows
And I close the current editor

Examples: Behaelter pruefen
| behaelter |
| BEH24_1   |
| BEH24_2   |
| BEH24_3   |
| BEH24_4   |


Scenario Outline: 25 Kartons anlegen
Given I open an editor "<editor>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "<packm>"
And I save the current editor

Examples: Behaelter
| editor        | such        | packm   |
| behaelter25_1 | KARTON_25_1 | SKARTON |
| behaelter25_2 | KARTON_25_2 | SKARTON |


Scenario Outline: 25 Lagerbuchung
Given I open an editor "Lagerbuchung25" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "RAD"
And I set field "buart" to "Zugang"
And I set field "beleg" to "L25"
And I set field "beldat" to "."
And I set field "mge" to "<mge>" in row 1
And I set field "behaelter" to id from editor "<behaelter>" in row 1
And I save the current editor

Examples: Lagerbuchung
| mge | behaelter     |
| 6   | behaelter25_1 |
| 4   | behaelter25_2 |


Scenario: 25 Packmittel berechnen, ein Artikel, anderes Packmittel wie in packanw
Given I open an editor "Verkaufslieferschein25" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "RAD" in row 1
And I set field "mge" to "10" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "6" in row 1
And I set field "behaelter" to id from editor "behaelter25_1" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "4" in row 2
And I set field "behaelter" to id from editor "behaelter25_2" in row 2
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein25"
And I press button "packvor"

Then the table has 3 rows
Then field "artikel^such" has value "SKARTON" in row 2
Then field "mge" has value "1" in row 2
Then field "artikel^such" has value "SKARTON" in row 3
Then field "mge" has value "1" in row 3

And I set field "ueb" to "ja"
And I save the current editor

Then field "bhbuchung" has value "" in row 1
Then field "bhbuchung" has value "" in row 2
Then field "bhbuchung" has value "" in row 3

Scenario: 25 Behaelter pruefen
And I switch the current editor to editor "behaelter25_1"
Then the table has 0 rows
And I close the current editor
And I switch the current editor to editor "behaelter25_2"
Then the table has 0 rows
And I close the current editor


Scenario Outline: 26 Behaelter und Karton anlegen
Given I open an editor "<editor>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "<packm>"
And I save the current editor

Examples: Behaelter
| editor        | such        | packm   |
| behaelter26_1 | KLT_26_1    | KLT     |
| behaelter26_2 | KARTON_26_2 | SKARTON |


Scenario Outline: 26 Lagerbuchung
Given I open an editor "Lagerbuchung25" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "RAD"
And I set field "buart" to "Zugang"
And I set field "beleg" to "L26"
And I set field "beldat" to "."
And I set field "mge" to "<mge>" in row 1
And I set field "behaelter" to id from editor "<behaelter>" in row 1
And I save the current editor

Examples: Lagerbuchung
| mge | behaelter     |
| 6   | behaelter26_1 |
| 4   | behaelter26_2 |


# 4.4. Lisa, behaelterkonto wird nicht bebucht, VERSAND-836
Scenario: 26 Packmittel berechnen, ein Artikel, anderes und gleiches Packmittel wie in packanw
Given I open an editor "Verkaufslieferschein26" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "RAD" in row 1
And I set field "mge" to "10" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "6" in row 1
And I set field "behaelter" to id from editor "behaelter26_1" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "4" in row 2
And I set field "behaelter" to id from editor "behaelter26_2" in row 2
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein26"
And I press button "packvor"

Then the table has 3 rows
Then field "artikel^such" has value "KLT" in row 2
Then field "mge" has value "1" in row 2
Then field "artikel^such" has value "SKARTON" in row 3
Then field "mge" has value "1" in row 3

And I set field "ueb" to "ja"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 3
#Then field "bhbuchung^buart" has value "Abgang" in row 3

Scenario: 26 Behaelter pruefen
And I switch the current editor to editor "behaelter26_1"
Then the table has 0 rows
And I close the current editor
And I switch the current editor to editor "behaelter26_2"
Then the table has 0 rows
And I close the current editor


Scenario Outline: 27 Behaelter anlegen
Given I open an editor "<editor>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "<packm>"
And I save the current editor

Examples: Behaelter
| editor        | such	   | packm |
| behaelter27_1 | PACKM_27 | KLT   |


Scenario Outline: 27 Lagerbuchung
Given I open an editor "Lagerbuchung27" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "<artikel>"
And I set field "buart" to "Zugang"
And I set field "beleg" to "L27"
And I set field "beldat" to "."
And I set field "mge" to "<mge>" in row 1
And I set field "behaelter" to id from editor "<behaelter>" in row 1
And I save the current editor

Examples: Lagerbuchung
| artikel | mge | behaelter     |
| RAD     | 2   | behaelter27_1 |
| RAHMEN  | 1   | behaelter27_1 |


# 4.4. Lisa, behaelterkonto wird nicht bebucht, VERSAND-836
Scenario: 27 Packmittel berechnen, verschiedene Artikel, ein behaelter
Given I open an editor "Verkaufslieferschein27" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "RAD" in row 1
And I set field "mge" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "2" in row 1
And I set field "behaelter" to id from editor "behaelter27_1" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein27"
And I create a new row at the end of the table
And I set field "artikel" to "RAHMEN" in row 2
And I set field "mge" to "1" in row 2
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I set field "zuomge" to "1" in row 1
And I set field "behaelter" to id from editor "behaelter27_1" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein27"
And I press button "packvor"

Then the table has 2 rows
Then field "artikel^such" has value "RAD" in row 1
Then field "artikel^such" has value "RAHMEN" in row 2

And I set field "ueb" to "JA"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 3
#Then field "bhbuchung^buart" has value "Abgang" in row 3

Scenario: 27 Behaelter pruefen
And I switch the current editor to editor "behaelter27_1"
Then the table has 0 rows
And I close the current editor


Scenario Outline: 28 Behaelter und Karton anlegen
Given I open an editor "<editor>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "<packm>"
And I save the current editor

Examples: Behaelter
| editor        | such       | packm |
| behaelter28_1 | PACKM_28   | KLT   |
| behaelter28_2 | PACKM_28_2 | KLT   |


Scenario Outline: 28 Lagerbuchung
Given I open an editor "Lagerbuchung28" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "<artikel>"
And I set field "buart" to "Zugang"
And I set field "beleg" to "L28"
And I set field "beldat" to "."
And I set field "mge" to "<mge>" in row 1
And I set field "behaelter" to id from editor "<behaelter>" in row 1
And I save the current editor

Examples: Lagerbuchung
| artikel | mge | behaelter     |
| RAD     | 2   | behaelter28_1 |
| RAHMEN  | 1   | behaelter28_1 |
| RAHMEN  | 1   | behaelter28_2 |


# 4.4. Lisa, behaelterkonto wird nicht bebucht, VERSAND-836
Scenario: 28 Packmittel berechnen, verschiedene Artikel, mehrere Behaelter
Given I open an editor "Verkaufslieferschein28" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "RAD" in row 1
And I set field "mge" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "2" in row 1
And I set field "behaelter" to id from editor "behaelter28_1" in row 1
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein28"
And I create a new row at the end of the table
And I set field "artikel" to "RAHMEN" in row 2
And I set field "mge" to "2" in row 2
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I set field "zuomge" to "1" in row 1
And I set field "behaelter" to id from editor "behaelter28_1" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "1" in row 2
And I set field "behaelter" to id from editor "behaelter28_2" in row 2
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein28"
And I press button "packvor"

Then the table has 2 rows
Then field "artikel^such" has value "RAD" in row 1
Then field "artikel^such" has value "RAHMEN" in row 2

And I set field "ueb" to "JA"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 3
#Then field "bhbuchung^buart" has value "Abgang" in row 3
#Then field "bhbuchung^mge" has value "1" in row 4
#Then field "bhbuchung^buart" has value "Abgang" in row 4

Scenario: 28 Behaelter pruefen
And I switch the current editor to editor "behaelter28_1"
Then the table has 0 rows
And I close the current editor
And I switch the current editor to editor "behaelter28_2"
Then the table has 0 rows
And I close the current editor


Scenario Outline: 29 Packmittel aus der Fertigung werden im Lieferschein nicht noch einmal abgebucht
# Packanweisungen Lager und Versand anlegen
Given I open an editor "<such>" from table "(PackingInstructions):(PackingInstructions)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "artikel" to "KLT" in row 1
And I set field "anzahl" to "4" in row 1
And I set field "ebene" to "3" in row 1
And I set field "minebene" to "<minebene>" in row 1
And I set field "auffuell" to "ja" in row 1
And I set field "artikel" to "SPALETTE" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "ebene" to "1" in row 2
And I set field "minebene" to "1" in row 2
And I set field "auffuell" to "nein" in row 2
And I save the current editor

Examples:
| such      | minebene |
| LAGERPACK | 1        |
| VERSPACK  | 2        |

# Baugruppe anlegen
Scenario: 29 Packmittel aus der Fertigung werden im Lieferschein nicht noch einmal abgebucht
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "BUCHUNGPM"
And I set fields
    | such              | BUCHUNGPM       |
    | bsart             | Eigenfertigung  |
    | dispoa            | auftragsbezogen |
    | packanwstdla      | LAGERPACK       |
    | fmengestdla       | 5	              |
    | packanwstdversand | VERSPACK        |
    | fmengestdversand  | 5               |
And I set field "elex" to "RAD" in row 1
And I set field "anzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A SCHRAUBEN" in row 2
And I set field "packmnotw" to "ja" in row 2
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag29" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "betreff" to "Bestellung"
When I create a new row at the end of the table
And I set field "artikel" to "BUCHUNGPM" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

# Dispo starten
And I run Scheduling

# Behaelter anlegen
Scenario Outline: 29 Behaelter anlegen fuer Packmittel aus der Fertigung werden im Lieferschein nicht noch einmal abgebucht
Given I open an editor "<such>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "KLT"
And I save the current editor

Examples:
| such    |
| PM_29_1 |
| PM_29_2 |

# Fertigungsvorschlag freigeben
Scenario: 29 Packmittel aus der Fertigung werden im Lieferschein nicht noch einmal abgebucht
Given I open an editor "fvanlegen" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "BUCHUNGPM"
And I press button "ladetab"
And I set field "bisuch" to "PM" in row !lastRow
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row !lastRow
And I delete all rows
And I create a new row at the end of the table
And I set field "zuomge" to "5" in row 1
And I set field "behaelter" to id from editor "PM_29_1" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "5" in row 2
And I set field "behaelter" to id from editor "PM_29_2" in row 2
And I save the current editor
And I switch the current editor to editor "fvanlegen"
And I set field "mfreig" to "ja" in row !lastRow
And I press button "freig" to open a subeditor for "fertigung"
And I save the current editor

# Kompletttrueckmeldung
Scenario: 29 Packmittel aus der Fertigung werden im Lieferschein nicht noch einmal abgebucht
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PM001"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I set field "manrest" to "ja"
And I save the current editor

# Abbuchung Packmittel pruefen
Given I open the infosystem "LJ"
And I set field "beleg" to "barmex" from editor "rueckmelden"
And I press start
Then the table has 5 rows
Then field "art" has value "SPALETTE" in row 1
Then field "art" has value "KLT" in row 2
And I close the current editor

# Lieferschein erstellen und buchen
Given I open an editor "Verkaufslieferschein29" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to "nummer" from editor "auftrag29"
And I set field "mge" to "10" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "5" in row 1
And I set field "behaelter" to id from editor "PM_29_1" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "5" in row 2
And I set field "behaelter" to id from editor "PM_29_2" in row 2
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein29"
And I press button "packvor"
Then the table has 5 rows
And I set field "ueb" to "ja"
And I save the current editor

# Abbuchung restliche Packmittel pruefen
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "Verkaufslieferschein29"
And I press start
Then field "art" has value "KLT" in row 3
Then field "amge" has value "4" in row 3
And I close the current editor


Scenario: 30 Jokerbestand ohne Verwendung und Projekt wird Auftragsposition mit Projekt zugeordnet
# Artikel JOKER erstellen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "JOKER_PROJEKT"
And I set field "such" to "JOKER_PROJEKT"
And I save the current editor

# Projekt anlegen
Given I open an editor "projekt" from table "(Transaction):(Project)" with command "STORE" for record "JOKER_PROJEKT"
And I set field "such" to "JOKER_PROJEKT"
And I save the current editor

# Behaelter anlegen
Scenario Outline: 30 Jokerbestand ohne Verwendung und Projekt wird Auftragsposition mit Projekt zugeordnet
Given I open an editor "<such>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "Behälter"
And I save the current editor

Examples:
| such              |
| JOKERMZ_PROJEKT_1 |
| JOKERMZ_PROJEKT_2 |

# Lagerbuchung Zugang Jokerbestand
Scenario: 30 Jokerbestand ohne Verwendung und Projekt wird Auftragsposition mit Projekt zugeordnet
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | JOKER_PROJEKT |
    | buart   | Zugang        |
    | beleg   | 30            |
    | beldat  | .             |
And I append rows
    | mge | behaelter                                                                                 |
    | 5   | $,,such=JOKERMZ_PROJEKT_1;@sort=nummer;@richtung=rückwärts;@maxtreffer=1;@sort=Suchwort |
    | 2   | $,,such=JOKERMZ_PROJEKT_2;@sort=nummer;@richtung=rückwärts;@maxtreffer=1;@sort=Suchwort |
And I save the current editor

# Auftrag
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I create a new row at the end of the table
And I set field "artikel" to "JOKER_PROJEKT" in row 1
And I set field "mge" to "7" in row 1
And I set field "projekt" to id from editor "projekt" in row 1
And I save the current editor

# Dispo starten
And I run Scheduling
# Lieferschein aus Auftrag
And I switch the current editor to editor "auftrag" with command "DELIVERY"
And I set field "mge" to "5" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "5" in row 1
And I set field "behaelter" to id from editor "JOKERMZ_PROJEKT_1" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "2" in row 2
And I set field "behaelter" to id from editor "JOKERMZ_PROJEKT_2" in row 2
And I save the current editor
And I switch the current editor to editor "auftrag"
And I set field "ueb" to "ja"
And I save the current editor

# Behaelter pruefen
Scenario Outline: 30 Jokerbestand ohne Verwendung und Projekt wird Auftragsposition mit Projekt zugeordnet
And I switch the current editor to editor "<editor>" with command "VIEW"
Then the table has 0 rows
And I close the current editor

Examples:
| editor            |
| JOKERMZ_PROJEKT_1 |
| JOKERMZ_PROJEKT_2 |


Scenario: 31 Jokerbestand mit unscharfer Verwendung wird Auftragsposition mit Verwendung zugeordnet
# Artikel JOKER erstellen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "JOKER_VERWEND"
And I set field "such" to "JOKER_VERWEND"
And I set field "dispoa" to "auftragsbezogen"
And I save the current editor

# Behaelter anlegen
Scenario Outline: 31 Jokerbestand mit unscharfer Verwendung wird Auftragsposition mit Verwendung zugeordnet
Given I open an editor "<such>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "Behälter"
And I save the current editor

Examples:
| such              |
| JOKERMZ_VERWEND_1 |
| JOKERMZ_VERWEND_2 |

# Auftrag
Scenario: 31 Jokerbestand mit unscharfer Verwendung wird Auftragsposition mit Verwendung zugeordnet
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I append rows
    | artikel       | mge |
    | JOKER_VERWEND | 7   |
And I save the current editor

# Lagerbuchung Zugang Jokerbestand
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | JOKER_VERWEND |
    | buart   | Zugang        |
    | beleg   | 31            |
    | beldat  | .             |
And I set field "verw" in row 0 to "nummer" from editor "auftrag" in row 0
And I modify table
    | !row | mge | behaelter                                                                                  |
    | 1    | 5   | $,,such==JOKERMZ_VERWEND_1;@sort=nummer;@richtung=rückwärts;@maxtreffer=1;@sort=Suchwort |
    | +1   | 2   | $,,such==JOKERMZ_VERWEND_2;@sort=nummer;@richtung=rückwärts;@maxtreffer=1;@sort=Suchwort |
And I save the current editor

# Dispo starten
And I run Scheduling
# Lieferschein aus Auftrag
And I switch the current editor to editor "auftrag" with command "DELIVERY"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | zuomge | behaelter                                                                                  |
    | 5      | $,,such==JOKERMZ_VERWEND_1;@sort=nummer;@richtung=rückwärts;@maxtreffer=1;@sort=Suchwort |
    | 2      | $,,such==JOKERMZ_VERWEND_2;@sort=nummer;@richtung=rückwärts;@maxtreffer=1;@sort=Suchwort |
And I save the current editor
And I switch the current editor to editor "auftrag"
And I set field "ueb" to "ja"
And I save the current editor

# Behaelter pruefen
Scenario Outline: 31 Jokerbestand mit unscharfer Verwendung wird Auftragsposition mit Verwendung zugeordnet
And I switch the current editor to editor "<editor>" with command "VIEW"
Then the table has 0 rows
And I close the current editor

Examples:
| editor            |
| JOKERMZ_VERWEND_1 |
| JOKERMZ_VERWEND_2 |


@MZ_Verkaufslieferschein
Scenario Outline: 32 Behaelter anlegen
And I open an editor "<beheditor>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "KLT"
And I save the current editor

Examples: Behaelter pruefen
| beheditor   | such    |
| behanlage_1 | PEDALE1 |
| behanlage_2 | PEDALE2 |
| behanlage_3 | PEDALE3 |
| behanlage_4 | PEDALE4 |
| behanlage_5 | PEDALE5 |
| behanlage_6 | PEDALE6 |

Scenario: 32 Lagerbuchung
Given I open an editor "Lagerbuchung1" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "PEDALE"
And I set field "buart" to "Zugang"
And I set field "beleg" to "LM01"
And I set field "beldat" to "."
And I set field "mge" to "5" in row 1
And I set field "behaelter" to "PEDALE1" in row 1
And I create a new row at the end of the table
And I set field "mge" to "5" in row 2
And I set field "behaelter" to "PEDALE2" in row 2
And I create a new row at the end of the table
And I set field "mge" to "5" in row 3
And I set field "behaelter" to "PEDALE3" in row 3
And I create a new row at the end of the table
And I set field "mge" to "5" in row 4
And I set field "behaelter" to "PEDALE4" in row 4
And I create a new row at the end of the table
And I set field "mge" to "5" in row 5
And I set field "behaelter" to "PEDALE5" in row 5
And I create a new row at the end of the table
And I set field "mge" to "3" in row 6
And I set field "behaelter" to "PEDALE6" in row 6
And I save the current editor

Scenario: 32 Verkaufslieferschein einen Artikel in Behaelter per Mz und Packanweisung versenden. Packmittel berechnen.
Given I open an editor "Verkaufslieferschein1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "PEDALE" in row 1
And I set field "mge" to "28" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "5" in row 1
And I set field "behaelter" to "PEDALE1" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "5" in row 2
And I set field "behaelter" to "PEDALE2" in row 2
And I create a new row at the end of the table
And I set field "zuomge" to "5" in row 3
And I set field "behaelter" to "PEDALE3" in row 3
And I create a new row at the end of the table
And I set field "zuomge" to "5" in row 4
And I set field "behaelter" to "PEDALE4" in row 4
And I create a new row at the end of the table
And I set field "zuomge" to "5" in row 5
And I set field "behaelter" to "PEDALE5" in row 5
And I create a new row at the end of the table
And I set field "zuomge" to "3" in row 6
And I set field "behaelter" to "PEDALE6" in row 6
And I save the current editor
And I switch the current editor to editor "Verkaufslieferschein1"
And I set field "packanw" to "KLT-PAL-VERSAND" in row 1
And I set field "fmenge" to "5" in row 1
And I press button "packvor"
And I set field "ueb" to "JA"
# Hinweis - Packstuecknummern werden automatisch angelegt bzw. aktualisiert - ok?
And I respond with answer "ja" to the dialog with id "8186"
And I save the current editor
