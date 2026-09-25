# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Rueck_Verkauf_Plausis.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Plausis bei Ruecklieferungen im Verkauf mit Behaeltern
#  ref              : ref_behaelter_rueckliefern_cu
#
# *****************************************************************************
@persistent
Feature: VERSAND_BEHAELTER_Rueck_Verkauf_Plausis.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 00 Basislieferschein und -rechnung fuer Ruecklieferungen anlegen

Given I open an editor "VKLS00_p" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | such      | VKLS00_P  |
    | kunde     | RADSHOP   |
    | vom       | .         |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | RAHMEN    | 1     |
    | RAD       | 1     |
And I save the current editor

Given I open an editor "VKRE00_p" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | such      | VKRE00_P  |
    | kunde     | RADSHOP   |
    | vom       | .         |
    | ueb       | ja        |
    | budat     | .         |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | RAHMEN    | 1     |
    | RAD       | 1     |
And I save the current editor


Scenario: 01a Lieferschein - Packmittel muss Behaelter, Palette oder Container sein

Given I open an editor "VKLS01a_p" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "VKLS00_p"
And I set fields
    | such      | VKLS01A_P |
    | vom       | .         |
Then field "artikel^such" has value "RAHMEN" in row 1
And I modify table
    | !row  | mge   | exbehnum  |
    | 1     | -1    | PACKM_01A |
# Fehler 1361: Ungueltiger Feldwert
Then setting field "packm" to "KLT-DECKEL" in row 1 throws the exception "1361"
And I close the current editor


Scenario: 01b Rechnung mL - Packmittel muss Behaelter, Palette oder Container sein

Given I open an editor "VKRE01b_p" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "VKRE00_p"
And I set fields
    | such      | VKRE01B_P |
    | vom       | .         |
Then field "artikel^such" has value "RAHMEN" in row 1
And I modify table
    | !row  | mge   | exbehnum  |
    | 1     | -1    | PACKM_01B |
# Fehler 1361: Ungueltiger Feldwert
Then setting field "packm" to "KLT-DECKEL" in row 1 throws the exception "1361"
And I close the current editor


Scenario: 02a Lieferschein - Gleiche Behaelternummer mit unterschiedlichen Packmitteln

Given I open an editor "VKLS_02ap" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "VKLS00_p"
And I set fields
    | such      | VKLS02A_P |
    | vom       | .         |
And I modify table
    | !row              | mge | exbehnum   | packm     |
    | artikel=='RAHMEN' | -1  | BEHNUM_02A | KLT       |
    | artikel=='RAD'    | -1  | BEHNUM_02A | BEHAELTER |
# Fehler 8371: Gleiche Behaelternummer, unterschiedliche Packmittel.
Then saving the current editor throws the exception "8371"
And I close the current editor


Scenario: 02b Rechnung mL - Gleiche Behaelternummer mit unterschiedlichen Packmitteln

Given I open an editor "VKRE02b_p" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "VKRE00_p"
And I set fields
    | such      | VKRE02B_P |
    | vom       | .         |
And I modify table
    | !row              | mge | exbehnum   | packm     |
    | artikel=='RAHMEN' | -1  | BEHNUM_02B | KLT       |
    | artikel=='RAD'    | -1  | BEHNUM_02B | BEHAELTER |
#And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
# Fehler 8371: Gleiche Behaelternummer, unterschiedliche Packmittel.
Then saving the current editor throws the exception "8371"
And I close the current editor


Scenario: 03a Lieferschein - Gleiche Behaelternummer mit abweichendem Lagerplatz

Given I open an editor "VKLS_03ap" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "VKLS00_p"
And I set fields
    | such      | VKLS03A_P |
    | vom       | .         |
And I modify table
    | !row              | mge | exbehnum   | packm | platz |
    | artikel=='RAHMEN' | -1  | BEHNUM_03B | KLT   | F1    |
    | artikel=='RAD'    | -1  | BEHNUM_03B | KLT   | F2    |
# Fehler 8391: Gleiche Behaelternummer, abweichender Lagerplatz.
Then saving the current editor throws the exception "8391"
And I close the current editor


Scenario: 03b Rechnung mL - Gleiche Behaelternummer mit abweichendem Lagerplatz

Given I open an editor "VKRE03b_p" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "VKRE00_p"
And I set fields
    | such      | VKRE03B_P |
    | vom       | .         |
And I modify table
    | !row              | mge | exbehnum   | packm | platz |
    | artikel=='RAHMEN' | -1  | BEHNUM_03B | KLT   | F1    |
    | artikel=='RAD'    | -1  | BEHNUM_03B | KLT   | F2    |
# Fehler 8391: Gleiche Behaelternummer mit abweichendem Lagerplatz
Then saving the current editor throws the exception "8391"
And I close the current editor


Scenario: 04 Gefuellter Behaelter bei Ruecklieferung im Verkauf, Fehler 8346: Die Behaelternummer ist bereits vorhanden und nicht leer.

And I create a Container "behaelter_04p" for packaging material "KLT"

And I post a receipt via ManualStockAdjustment for Product "PEDALE" and quantity "5" on StorageLocation "F1" with document "L04-PZU" and Container "behaelter_04p"

Given I open an editor "VKLS_04ap" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "VKLS00_p"
And I set fields
    | such      | VKLS04A_P |
    | vom       | .         |
Then field "artikel^such" has value "RAHMEN" in row 1
And I set field "mge" to "-1" in row 1
# Dialog mit ja beantworten -> es wuerde ein neuer Behaelter angelegt.
And I respond with answer "yes" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "behaelter_04p" in row 1
And I close the current editor

Given I open an editor "VKRE04b_p" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "VKRE00_p"
And I set fields
    | such      | VKRE04B_P |
    | vom       | .         |
Then field "artikel^such" has value "RAHMEN" in row 1
And I set field "mge" to "-1" in row 1
# Dialog mit nein beantworten -> vorhandener Behaelter wird eingetragen
# And I respond with answer "no" to the dialog with id "Externe Behälternummer ist bereits vergeben."
# Fehler 8346: Die Behaelternummer ist bereits vorhanden und nicht leer.
# Then setting field "exbehnum" to "behaelter_04p" in row 1 throws the exception "8346"
And I close the current editor


Scenario: 05a Behaelter bei Lieferschein ueber exbehnum anlegen, Fehler 6613: Bitte Packmittel eintragen!

Given I open an editor "VKLS_05ap" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "VKLS00_p"
And I set fields
    | such      | VKLS05A_P |
    | vom       | .         |
Then field "artikel^such" has value "RAHMEN" in row 1
And I modify table
    | !row  | mge   | exbehnum              |
    | 1     | -1    | PACKMITTEL_EINTRAGEN  |
# Fehler 6613: Bitte Packmittel eintragen!
Then saving the current editor throws the exception "6613"
And I close the current editor


Scenario: 05b Behaelter bei Rechnung mit Lagerbewegung ueber exbehnum anlegen, Fehler 6613: Bitte Packmittel eintragen!

Given I open an editor "VKRE05b_p" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "VKRE00_p"
And I set fields
    | such      | VKRE05B_P |
    | vom       | .         |
Then field "artikel^such" has value "RAHMEN" in row 1
And I modify table
    | !row  | mge   | exbehnum              |
    | 1     | -1    | PACKMITTEL_EINTRAGEN  |
# Fehler 6613: Bitte Packmittel eintragen!
Then saving the current editor throws the exception "6613"
And I close the current editor


Scenario: 06 Dienstleistungen koennen nicht verpackt werden

Given I open an editor "dl_beh_06p" from table "(Part):(Service)" with command "STORE" for record "DL-BEH_06"
And I set field "such" to "DL-BEH_06"
And I save the current editor

Given I open an editor "VKLS_06p" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | such      | VKLS05A_P |
    | kunde     | RADSHOP   |
    | vom       | .         |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel           | mge   |
    | !dl_beh_06p^id    | 1     |
And I save the current editor

Given I open an editor "VKRLS_06p" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "VKLS_06p"
And I set fields
    | such      | VKRLS_06p |
    | vom       | .         |
Then field "artikel^such" has value "DL-BEH_06" in row 1
And I set field "mge" to "-1" in row 1
# in Positionen mit Dienstleistungen koennen keine Behaelter oder Packmittel eingetragen werden
Then field "exbehnum" is not modifiable in row 1
Then field "packm" is not modifiable in row 1
And I close the current editor


Scenario: 07 Lieferschein - Gleiche Behaelternummer in mehreren Lieferscheinen -> mehrere Behaelter mit exbehnum anlegen

# 1. Ruecklieferschein anlegen - aber noch nicht buchen
Given I open an editor "VKLS_07p_1" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "VKLS00_p"
And I set fields
    | such      | VKLS071_P |
    | vom       | .         |
Then field "artikel^such" has value "RAHMEN" in row 1
And I modify table
    | !row  | mge   | exbehnum       | packm    |
    | 1     | -1    | 07behaelter_p  | KLT      |
And I save the current editor

# 2. Ruecklieferschein anlegen - aber noch nicht buchen
Given I open an editor "VKLS_07p_2" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "VKLS00_p"
And I set fields
    | such      | VKLS072_P |
    | vom       | .         |
Then field "artikel^such" has value "RAD" in row 1
And I modify table
    | !row  | mge   | exbehnum       | packm    |
    | 1     | -1    | 07behaelter_p  | KLT      |
And I save the current editor

# 1. Lieferschein buchen
Given I open an editor "VKLS_07p_1" from table "(Sales):(PackingSlip)" with command "TRANSFER" for record from editor "VKLS_07p_1"
And I save the current editor

# # 2. Lieferschein buchen
Given I open an editor "VKLS_07p_2" from table "(Sales):(PackingSlip)" with command "TRANSFER" for record from editor "VKLS_07p_2"
And I save the current editor

# Nach dem Buchen der beiden Ruecklieferscheine gibt es zwei Behaelter mit exbehnum = 07behaelter_p
Given I open an editor "07behaelter_1" from table "(Container):(ContainerShell)" with command "VIEW" for record "$,,nummer=07BEHAELTER_P;exbehnum/07BEHAELTER_P"
Then table has values
    | artikel | mge |
    | RAHMEN  | 1   |
And I close the current editor

Given I open an editor "07behaelter_2" from table "(Container):(ContainerShell)" with command "VIEW" for record "$,,nummer<>07BEHAELTER_P;exbehnum/07BEHAELTER_P"
Then table has values
    | artikel | mge |
    | RAD     | 2   |
And I close the current editor


Scenario: 08 Rechnung mL - Gleiche Behaelternummer in mehreren Rechnungen -> es werden 2 Behaelter mit exbehnum angelegt

# 1. Rechnung mL anlegen - aber noch nicht buchen
Given I open an editor "VKRE_08p_1" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "VKRE00_p"
And I set fields
    | such      | VKLS081_P |
    | vom       | .         |
Then field "artikel^such" has value "RAHMEN" in row 1
And I modify table
    | !row  | mge   | exbehnum       | packm    |
    | 1     | -1    | 08behaelter_p  | KLT      |
And I save the current editor

# 2. Rechnung mL anlegen - aber noch nicht buchen
Given I open an editor "VKRE_08p_2" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "VKRE00_p"
And I set fields
    | such      | VKLS082_P |
    | vom       | .         |
Then field "artikel^such" has value "RAD" in row 1
And I modify table
    | !row  | mge   | exbehnum       | packm    |
    | 1     | -1    | 08behaelter_p  | KLT      |
And I save the current editor

# 1. Rechnung mL  buchen
Given I open an editor "VKRE_08p_1" from table "(Sales):(PackingSlip)" with command "TRANSFER" for record from editor "VKRE_08p_1"
And I save the current editor

# # 2. Rechnung mL  buchen
Given I open an editor "VKRE_08p_2" from table "(Sales):(PackingSlip)" with command "TRANSFER" for record from editor "VKRE_08p_2"
And I save the current editor

# Nach dem Buchen der beiden Ruecklieferscheine gibt es zwei Behaelter mit exbehnum = 08behaelter_p
Given I open an editor "08behaelter_1" from table "(Container):(ContainerShell)" with command "VIEW" for record "$,,nummer=08BEHAELTER_P;exbehnum/08BEHAELTER_P"
Then table has values
    | artikel | mge |
    | RAHMEN  | 1   |
And I close the current editor

Given I open an editor "08behaelter_2" from table "(Container):(ContainerShell)" with command "VIEW" for record "$,,nummer<>08BEHAELTER_P;exbehnum/08BEHAELTER_P"
Then table has values
    | artikel | mge |
    | RAD     | 2   |
And I close the current editor
