@persistent
Feature: sup.feature

Background:
And I set the fake date to "16.01.1995"

# **********************************************************************************
#  Name             : sup.feature
#  Autor            : bschiga
#  Verantwortlich   : bschiga
#  Kontrolle        : carue
#  Funktion         : Testet Infosystem SUP - Single Use Plastic (EWK)
#  ref              : ref_sk_infosys_sup_cu
#
# **********************************************************************************

Scenario: Stammdaten anlegen

Given I open an editor "EK_TEIL_EWK" from table "(Part):(Product)" with command "STORE" for record "EK_TEIL_EWK"
And I set fields
    | such              | EK_TEIL_EWK                   |
    | namebspr          | Kaufteil mit Einwegkunststoff |
    | bsart             | Fremdbeschaffung              |
    | lief              | TEST                          |
    | efrist            | 5                             |
    | epr               | 10                            |
    | ewkgewicht        | 200                           |
    | ewkgewichteinh    | g                             |
And I save the current editor

Given I open an editor "BG_EWK" from table "(Part):(Product)" with command "STORE" for record "BG_EWK"
And I set fields
    | such              | BG_EWK                            |
    | namebspr          | Baugruppe mit Einwegkunststoff    |
    | bsart             | Eigenfertigung                    |
    | ewkgewichteinh    | kg                                |
And I delete all rows
And I append rows
    | elex          | elanzahl  |
    | EK_TEIL_EWK   | 2         |
    | A AG1         | 1         |
And I save the current editor

Given I open an editor "BG_EWK" from table "(Part):(Product)" with command "UPDATE" for record "BG_EWK"
And I press button "kalkul" to open a subeditor for "Kblatt"
And I save the current subeditor to switch back to the parent editor
Then field "ewkgewicht" has value "0.4"
And I save the current editor


Scenario: 01 SUP oeffnen - keine Zeile in der Tabelle
Given I open the infosystem "SUP"
And I press start
Then the table has 0 rows
And I close the current editor


Scenario: 02 Abgaenge buchen und im Infosystem den aufsummierten Kunststoffanteil fuer verschiedene Zeitraeume pruefen

# Bestand zubuchen
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK_TEIL_EWK   |
    | buart     | Zugang        |
    | beleg     | LBU_02_1      |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz2   |
    | 200    | F1       |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | BG_EWK        |
    | buart     | Zugang        |
    | beleg     | LBU_02_2      |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz2   |
    | 200    | F1       |
And I save the current editor

And I set the fake date to "21.01.1995"

Given I open an editor "VKLS" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde  | TEST     |
    | such   | VKLS_01  |
    | vom    | .        |
    | ueb    | ja       |
And I append rows
    | artikel       | mge |
    | EK_TEIL_EWK   | 10  |
    | BG_EWK        | 1   |
And I save the current editor

Given I open an editor "VKRE" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde  | TEST     |
    | such   | VKRE_01  |
    | vom    | .        |
    | tterm  | .        |
    | ueb    | ja       |
    | fakt   | ja       |
And I append rows
    | artikel       | mge | preis   |
    | EK_TEIL_EWK   | 10  | 10      |
    | BG_EWK        | 10  | 50      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I set the fake date to "03.03.1995"

Given I open an editor "VKLS" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde  | TEST     |
    | such   | VKLS_02  |
    | vom    | .        |
    | ueb    | ja       |
And I append rows
    | artikel       | mge |
    | EK_TEIL_EWK   | 2   |
    | BG_EWK        | 10  |
And I save the current editor

Given I open an editor "VKRE" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde  | TEST     |
    | such   | VKRE_02  |
    | vom    | .        |
    | tterm  | .        |
    | ueb    | ja       |
    | fakt   | ja       |
And I append rows
    | artikel       | mge | preis   |
    | EK_TEIL_EWK   | 100 | 10      |
    | BG_EWK        | 50  | 50      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I set the fake date to "07.03.1995"

Given I open an editor "VKLS" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde  | TEST     |
    | such   | VKLS_03  |
    | vom    | .        |
    | ueb    | ja       |
And I append rows
    | artikel       | mge |
    | EK_TEIL_EWK   | 1   |
    | BG_EWK        | 20  |
And I save the current editor

Given I open an editor "VKRE" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde  | TEST     |
    | such   | VKRE_03  |
    | vom    | .        |
    | tterm  | .        |
    | ueb    | ja       |
    | fakt   | ja       |
And I append rows
    | artikel       | mge | preis   |
    | EK_TEIL_EWK   | 10  | 10      |
    | BG_EWK        | 20  | 50      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open the infosystem "SUP"
And I set fields
    | von   | 01.01.1995    |
    | bis   | 07.03.1995    |
And I press start
Then field "summekg" has value "71"
Then the table has 12 rows
And I close the current editor

Given I open the infosystem "SUP"
And I set fields
    | von   | 01.03.1995    |
    | bis   | 07.03.1995    |
And I press start
Then field "summekg" has value "62.6"
Then the table has 8 rows
And I close the current editor

# Ruecklieferung buchen
Given I open an editor "VKRLS" from table "(Sales):(PackingSlip)" with command "RETURN" for record "VKLS_01"
And I set fields
    | such      | RLS1_01   |
    | ueb       | ja        |
Then table has values
    | artikel       |
    | EK_TEIL_EWK   |
    | BG_EWK        |
And I set field "mge" to "-2" in row 1
And I set field "mge" to "-1" in row 2
And I save the current editor

# die rueckgelieferten Mengen werden zum 07.03. (Buchungsdatum) beruecksichtigt und nicht zum Datum des Ursprungs-LS
Given I open the infosystem "SUP"
And I set fields
    | von   | 01.01.1995    |
    | bis   | 31.01.1995    |
And I press start
Then field "summekg" has value "8.4"
Then the table has 4 rows
And I close the current editor

Given I open the infosystem "SUP"
And I set fields
    | von   | 01.03.1995    |
    | bis   | 07.03.1995    |
And I press start
Then field "summekg" has value "61.8"
Then the table has 10 rows
And I close the current editor

Given I open an editor "STORNOVKRE" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+VKRE_02"
And I save the current editor

Given I open the infosystem "SUP"
And I set fields
    | von   | 01.03.1995    |
    | bis   | 07.03.1995    |
And I press start
Then field "summekg" has value "21.8"
Then the table has 12 rows
And I close the current editor
