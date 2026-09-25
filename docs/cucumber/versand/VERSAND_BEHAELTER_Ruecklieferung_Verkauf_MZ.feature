# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Ruecklieferung_Verkauf_MZ.feature
#  Verantwortlich   : as
#  Kontrolle        : drpf
#  Funktion         : Testet Ruecklieferungen im Verkauf mit MZ und Behaeltern
#  ref              : ref_behaelter_rueckliefern_mz_cu
#
# *****************************************************************************
@persistent
Feature: VERSAND_BEHAELTER_Ruecklieferung_Verkauf.feature
Background:
Given I set the fake date to "02.01.1995"

# -----------------------------------------------------------------------------
Scenario: 00 Ruecklieferung von Artikel mit Behaelter
# -----------------------------------------------------------------------------

# Lagerplatz anlegen
Given I open an editor "F140" from table "(Location):(Location)" with command "COPY" for record "F1"
And I set fields
    | such     | F140           |
    | namebspr | Lagerplatz 140 |
And I save the current editor

# Artikel anlegen
Given I open an editor "A140" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such   | A140             |
   | bsart  | Fremdbeschaffung |
   | dispoa | auftragsbezogen  |
   | lief   | 1                |
   | epr    | 100              |
And I save the current editor

# Behaelter anlegen
Given I open an editor "1BH140" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set fields
    | nummer  | 1BH140        |
    | such    | BH140         |
    | name    | Behaelter 140 |
	 | kl      | RADSHOP       |
    | packm   | KLT           |
And I save the current editor

# Behaelter fuellen
Given I open an editor "Lagerbuchung" for tip command "LBuchung" and arguments ""
And I set fields
    | nummer  | 1ZU140      |
    | artikel | A140        |
    | buart   | Zugang      |
    | beleg   | 1ZU140      |
    | beldat  | .           |
And I append rows
    | mge  | ze    | platz2 | behaelter | verw     |
    | 3    | Stück | F140   | 1BH140    | 1AU140_1 |
And I save the current editor

# Behaelter pruefen
Given I open an editor "1BH140" from table "(Container):(ContainerShell)" with command "VIEW" for record "1BH140"
Then field "behstatusaz" is empty
Then table has values
    | !row | artikel       | mge |
    | 1    | A140          | 3   |
And I close the current editor

# Auftrag anlegen
Given I open an editor "1AU140" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde  | WRADSHOP |
    | nummer | 1AU140   |
And I append rows
    | artikel     | mge | he     | verw     |
    | A140        | 3   | Stück  | 1AU140_1 |
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete all rows
And I append rows
    | lpsuch | einh  | zuomge | behaelter |
    | F140   | Stück | 1      | 1BH140    |
    | F140   | Stück | 1      | 1BH140    |
    | F140   | Stück | 1      | 1BH140    |
And I save the current editor
And I switch the current editor to editor "1AU140"
And I save the current editor

# Lieferschein anlegen
Given I open an editor "1LS140" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU140"
And I set fields
    | nummer  | 1LS140 |
    | such    | LS140  |
    | ueb     | ja     |
And I press button "offueb" in row 1
And I press button "pmneu" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "KLT" in row 2
And I set field "mge" to "1" in row 2
And I save the current editor

# Behaelter pruefen
Given I open an editor "1BH140" from table "(Container):(ContainerShell)" with command "VIEW" for record "1BH140"
Then field "behstatusaz" has value "Geliefert"
Then the table has 0 rows
And I close the current editor

# Behaelterkonto pruefen, Abgang
Given I open an editor "KNTRADSHOP" from table "(ContainerAccount):(ContainerAccount)" with command "VIEW" for record "KNTRADSHOP"
Then field "ainternm1" has value "1.00"
And I close the current editor

# Ruecklieferung anlegen
Given I open an editor "1RLS140" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS140"
And I set fields
    | nummer  | 1RLS140 |
    | such    | RLS140  |
    | ueb     | ja      |
And I set field "mge" to "-3" in row 1
And I set field "mge" to "-1" in row 2
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete all rows
And I append rows
    | lpsuch | einh  | zuomge | behaelter |
    | F140   | Stück | -3     | 1BH140    |
And I save the current editor
And I switch the current editor to editor "1RLS140"
And I save the current editor

# Behaelter pruefen
Given I open an editor "1BH140" from table "(Container):(ContainerShell)" with command "VIEW" for record "1BH140"
Then field "behstatusaz" is empty
Then table has values
    | !row | artikel       | mge |
    | 1    | A140          | 3   |
And I close the current editor

# Behaelterkonto pruefen, Abgang aus LS und Zugang aus RLS
Given I open an editor "KNTRADSHOP" from table "(ContainerAccount):(ContainerAccount)" with command "VIEW" for record "KNTRADSHOP"
Then field "ainternm1" has value "1.00"
Then field "zinternm1" has value "1.00"
And I close the current editor

# -----------------------------------------------------------------------------
Scenario: 01 Ruecklieferung von Setartikel mit Behaelter
# -----------------------------------------------------------------------------

# Lagerplatz anlegen
Given I open an editor "F141" from table "(Location):(Location)" with command "COPY" for record "F1"
And I set fields
    | such     | F141           |
    | namebspr | Lagerplatz 141 |
And I save the current editor

# Setartikel und Komponenten anlegen
Given I open an editor "KOMP1" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | KOMP1            |
   | namebspr | Komp1            |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
   | vpr      | 1                |
	| zuplatz  | F141             |
	| abplatz  | F141             |
And I save the current editor

Given I open an editor "KOMP2" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | KOMP2            |
   | namebspr | Komp2            |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
   | vpr      | 2                |
	| zuplatz  | F141             |
	| abplatz  | F141             |
And I save the current editor

Given I open an editor "KOMP3" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | KOMP3            |
   | namebspr | Komp3            |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
   | vpr      | 3                |
	| zuplatz  | F141             |
	| abplatz  | F141             |
And I save the current editor

# Setartikel
Given I open an editor "SETART141" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | SETART141        |
   | namebspr | Setartikel 141   |
   | bsart    | Eigenfertigung   |
   | dispoa   | auftragsbezogen  |
   | vpr      | 10               |
   | eart     | (UsingBOM)       |
	| zuplatz  | F141             |
	| abplatz  | F141             |
And I append rows
   | elex  | anzahl |
   | KOMP1 | 4      |
	| KOMP2 | 1      |
   | KOMP3 | 0.5    |
And I save the current editor

# Behaelter anlegen
Given I open an editor "1BH141" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set fields
    | nummer  | 1BH141        |
    | such    | BH141         |
    | name    | Behaelter 141 |
    | packm   | KLT           |
    | kl      | RADSHOP       |
And I save the current editor

# Behaelter mit Setartikel-Komponenten fuellen
Given I open an editor "Lagerbuchung" for tip command "LBuchung" and arguments ""
And I set fields
    | nummer  | 1ZU141    |
    | artikel | KOMP1     |
    | buart   | Zugang    |
    | beleg   | 1ZU141    |
    | beldat  | .         |
And I append rows
    | mge  | ze    | platz2 | behaelter | verw     |
    | 8    | Stück | F141   | 1BH141    | 1AU141_1 |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "LBuchung" and arguments ""
And I set fields
    | nummer  | 2ZU141    |
    | artikel | KOMP2     |
    | buart   | Zugang    |
    | beleg   | 2ZU141    |
    | beldat  | .         |
And I append rows
    | mge  | ze    | platz2 | behaelter | verw     |
    | 2    | Stück | F141   | 1BH141    | 1AU141_1 |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "LBuchung" and arguments ""
And I set fields
    | nummer  | 3ZU141    |
    | artikel | KOMP3     |
    | buart   | Zugang    |
    | beleg   | 3ZU141    |
    | beldat  | .         |
And I append rows
    | mge  | ze    | platz2 | behaelter | verw     |
    | 1    | Stück | F141   | 1BH141    | 1AU141_1 |
And I save the current editor

# Behaelter pruefen
Given I open an editor "1BH141" from table "(Container):(ContainerShell)" with command "VIEW" for record "1BH141"
Then field "behstatusaz" is empty
Then table has values
    | !row | artikel | mge |
    | 1    | KOMP1   | 8   |
    | 2    | KOMP2   | 2   |
    | 3    | KOMP3   | 1   |
And I close the current editor

# Auftrag mit Setartikel anlegen
Given I open an editor "1AU141" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde  | WRADSHOP |
    | nummer | 1AU141   |
And I append rows
    | artikel    | mge | verw     |
    | SETART141  | 2   | 1AU141_1 |
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge | behaelter |
    | F141   | Stück | 8      | 1BH141    |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge | behaelter |
    | F141   | Stück | 2      | 1BH141    |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge | behaelter |
    | F141   | Stück | 1      | 1BH141    |
And I save the current editor
And I switch the current editor to editor "1AU141"
And I save the current editor

# Lieferschein anlegen
Given I open an editor "1LS141" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU141"
And I set fields
    | nummer  | 1LS141 |
    | such    | LS141  |
    | ueb     | ja     |
And I press button "offueb" in row 1
And I press button "pmneu" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "KLT" in row 2
And I set field "mge" to "1" in row 2
And I save the current editor

# Behaelter pruefen
Given I open an editor "1BH141" from table "(Container):(ContainerShell)" with command "VIEW" for record "1BH141"
Then field "behstatusaz" has value "Geliefert"
Then the table has 0 rows
And I close the current editor

# Behaelterkonto pruefen, Abgang
Given I open an editor "KNTRADSHOP" from table "(ContainerAccount):(ContainerAccount)" with command "VIEW" for record "KNTRADSHOP"
Then field "ainternm1" has value "2.00"
And I close the current editor

# Ruecklieferung anlegen
Given I open an editor "1RLS141" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS141"
And I set fields
    | nummer  | 1RLS141 |
    | such    | RLS141  |
And I set field "mge" to "-2" in row 1
And I set field "mge" to "-1" in row 2
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge | behaelter |
    | F141   | Stück | -8     | 1BH141    |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge | behaelter |
    | F141   | Stück | -2     | 1BH141    |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge | behaelter |
    | F141   | Stück | -1     | 1BH141    |
And I save the current editor
And I switch the current editor to editor "1RLS141"
And I set field "ueb" to "ja"
And I save the current editor

# Behaelter pruefen
Given I open an editor "1BH141" from table "(Container):(ContainerShell)" with command "VIEW" for record "1BH141"
Then field "behstatusaz" is empty
Then table has values
    | !row | artikel | mge |
    | 1    | KOMP1   | 8   |
    | 2    | KOMP2   | 2   |
    | 3    | KOMP3   | 1   |
And I close the current editor

# Behaelterkonto pruefen, Abgang aus LS und Zugang aus RLS
Given I open an editor "KNTRADSHOP" from table "(ContainerAccount):(ContainerAccount)" with command "VIEW" for record "KNTRADSHOP"
Then field "ainternm1" has value "2.00"
Then field "zinternm1" has value "2.00"
And I close the current editor
