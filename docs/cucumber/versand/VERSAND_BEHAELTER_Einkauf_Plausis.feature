@persistent
Feature: VERSAND_BEHAELTER_Einkauf_Plausis.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Einkauf_Plausis.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Plausis im Einkauf mit Behaeltern
#  ref              : ref_behaelter_einkauf_cu
#
# *****************************************************************************

Background:
Given I set the fake date to "02.01.1995"

Scenario: 01a Behaelter bei Einkaufslieferschein ueber exbehnum anlegen, Fehler 6613: Bitte Packmittel eintragen!

Given I open an editor "EKLS01a_p" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | LS01A_P   |
And I delete all rows
And I append rows
    | artikel   | mge   | exbehnum              |
    | RAHMEN    | 30    | PACKMITTEL_EINTRAGEN  |
# Fehler 6613: Bitte Packmittel eintragen!
Then saving the current editor throws the exception "6613"
And I close the current editor


Scenario: 01b Behaelter bei Rechnung mit Lagerbewegung ueber exbehnum anlegen, Fehler 6613: Bitte Packmittel eintragen!

Given I open an editor "RML01b_p" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | RE01B_P   |
    | budat     | .         |
    | fakt      | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   | exbehnum              |
    | RAHMEN    | 30    | PACKMITTEL_EINTRAGEN  |
And I respond with answer "ja" to the dialog with id "4841"
# Fehler 6613: Bitte Packmittel eintragen!
Then saving the current editor throws the exception "6613"
And I close the current editor


Scenario: 02a Artikel bei Einkaufslieferschein in gefuellten Behaelter buchen, Fehler 8346: Die Behaelternummer ist bereits vorhanden und nicht leer.

And I create a Container "behaelter_02p" for packaging material "KLT"

# Lagerbuchung Artikel in Behaelter buchen
And I post a receipt via ManualStockAdjustment for Product "SATTEL" and quantity "5" on StorageLocation "F1" with document "L02-PZU" and Container "behaelter_02p"

# Einkaufslieferschein mit gefuelltem Behaelter nicht moeglich
Given I open an editor "EKLS02a_p" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | LS01_P    |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | RAD       | 5     |
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
# Fehler 8346: Die Behaelternummer ist bereits vorhanden und nicht leer.
Then setting field "exbehnum" to "behaelter_02p" in row 1 throws the exception "8346"
And I set field "artikel" to "SATTEL" in row 1
And I set field "mge" to "1" in row 1
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
# Fehler 8346: Die Behaelternummer ist bereits vorhanden und nicht leer.
Then setting field "exbehnum" to "behaelter_02p" in row 1 throws the exception "8346"
And I close the current editor


Scenario: 02b Artikel bei Rechnung mit Lagerbewegung in gefuellten Behaelter buchen, Fehler 8346: Die Behaelternummer ist bereits vorhanden und nicht leer.

Given I open an editor "RML02b_p" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | RE02B_P   |
    | budat     | .         |
    | fakt      | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | SATTEL    | 1     |
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
# Fehler 8346: Die Behaelternummer ist bereits vorhanden und nicht leer.
Then setting field "exbehnum" to "behaelter_02p" in row 1 throws the exception "8346"
And I close the current editor


Scenario: 03a Lieferschein kopieren. behnum, exbehnum und packm werden in Artikelzeile geleert

And I create a Container "behaelter_03p" for packaging material "KLT"

Given I open an editor "EKLS_04p" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | LS04_P    |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   | !dialogId                                     | !dialogAnswer | exbehnum              |
    | RAHMEN    | 1     | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_03p^nummer |
And I save the current editor

# Einkaufslieferschein kopieren, behnum, exbehnum und packm sind in Artikelzeile leer
And I switch the current editor to editor "EKLS_04p" with command "COPY"
Then field "behaelter" is empty in row 1
Then field "exbehnum" is empty in row 1
Then field "packm" is empty in row 1
And I close the current editor


Scenario: 03b Rechnung mit Lagerbewegung kopieren. behnum, exbehnum und packm werden in Artikelzeile geleert

Given I open an editor "RML03b_p" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | RE03B_P   |
    | budat     | .         |
    | fakt      | ja        |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   | exbehnum              | packm |
    | RAHMEN    | 1     | RECHNUNG_FEHLER_J48   | KLT   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I switch the current editor to editor "RML03b_p" with command "COPY"
Then field "behaelter" is empty in row 1
Then field "exbehnum" is empty in row 1
Then field "packm" is empty in row 1
And I close the current editor


Scenario: 04 Behaelterfelder sind nur in Rechnung mit Lagerbewegung aenderbar, bei Aenderung werden die Felder geleert

Given I open an editor "RML04_p" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | RE04_P    |
    | budat     | .         |
    | fakt      | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   | exbehnum         | packm |
    | RAHMEN    | 30    | SCHREIBSCHUTZ04  | KLT   |
# mit Lagerbewegung deaktivieren
And I set field "fakt" to "nein"
# Felder werden geleert und sind nicht mehr aenderbar
Then field "exbehnum" is empty in row 1
Then field "packm" is empty in row 1
Then field "exbehnum" is not modifiable in row 1
Then field "packm" is not modifiable in row 1
And I close the current editor


Scenario: 05a Lieferschein - Packmittel muss Behaelter, Palette oder Container sein

Given I open an editor "EKLS05a_p" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | EKLS05A_P |
And I delete all rows
And I append rows
    | artikel   | mge   | exbehnum  |
    | RAHMEN    | 1     | PACKM_05A |
# Fehler 1361: Ungueltiger Feldwert
Then setting field "packm" to "KLT-DECKEL" in row 1 throws the exception "1361"
And I close the current editor


Scenario: 05b Rechnung mL - Packmittel muss Behaelter, Palette oder Container sein

Given I open an editor "EKRE05b_p" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | EKRE05B_P |
And I delete all rows
And I append rows
    | artikel   | mge   | exbehnum   |
    | RAHMEN    | 1     | PACKM_05B  |
# Fehler 1361: Ungueltiger Feldwert
Then setting field "packm" to "KLT-DECKEL" in row 1 throws the exception "1361"
And I close the current editor


Scenario: 06a Lieferschein - Gleiche Behaelternummer mit unterschiedlichen Packmitteln

Given I open an editor "EKLS_06ap" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | EKLS06A_P |
And I delete all rows
And I append rows
    | artikel | mge | exbehnum   | packm     |
    | RAHMEN  | 1   | BEHNUM_06A | KLT       |
    | RAD     | 1   | BEHNUM_06A | BEHAELTER |
# Fehler 8371: Gleiche Behaelternummer, unterschiedliche Packmittel.
Then saving the current editor throws the exception "8371"
And I close the current editor


Scenario: 06b Rechnung mL - Gleiche Behaelternummer mit unterschiedlichen Packmitteln

Given I open an editor "EKRE06b_p" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | EKRE06B_P |
And I delete all rows
And I append rows
    | artikel | mge | exbehnum   | packm     |
    | RAHMEN  | 1   | BEHNUM_06B | KLT       |
    | RAD     | 1   | BEHNUM_06B | BEHAELTER |
And I respond with answer "ja" to the dialog with id "4841"
# Fehler 8371: Gleiche Behaelternummer, unterschiedliche Packmittel.
Then saving the current editor throws the exception "8371"
And I close the current editor


Scenario: 07a Lieferschein - Gleiche Behaelternummer mit abweichendem Lagerplatz

Given I open an editor "EKLS_07ap" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | EKLS07A_P |
And I delete all rows
And I append rows
    | artikel | mge | exbehnum   | packm | platz |
    | RAHMEN  | 1   | BEHNUM_07A | KLT   | F1    |
    | RAD     | 1   | BEHNUM_07A | KLT   | F2    |
# Fehler 8391: Gleiche Behaelternummer, abweichender Lagerplatz.
Then saving the current editor throws the exception "8391"
And I close the current editor


Scenario: 07b Rechnung mL - Gleiche Behaelternummer mit abweichendem Lagerplatz

Given I open an editor "EKRE07b_p" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | EKRE07B_P |
And I delete all rows
And I append rows
    | artikel | mge | exbehnum   | packm | platz |
    | RAHMEN  | 1   | BEHNUM_07B | KLT   | F1    |
    | RAD     | 1   | BEHNUM_07B | KLT   | F2    |
And I respond with answer "ja" to the dialog with id "4841"
# Fehler 8391: Gleiche Behaelternummer mit abweichendem Lagerplatz
Then saving the current editor throws the exception "8391"
And I close the current editor


Scenario: 08a Lieferschein - Keine Behaelter in Packmittelzeilen

And I create a Container "behaelter_08p" for packaging material "KLT"

# in Zeilen mit Packmitteln kann kein Behaelter eingetragen werden
Given I open an editor "EKLS_08ap" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | EKLS08A_P |
And I delete all rows
And I append rows
    | artikel | mge | fmenge |
    | RAD     | 5   | 5      |
And I press button "pmneubu" in row 1
And I append rows
    | artikel   | mge   |
    | KLT       | 1     |
Then field "exbehnum" is not modifiable in row !lastRow
And I close the current editor


Scenario: 08b Rechnung mL - Keine Packmittelzeilen in Rechnung mit Lagerbewegung

Given I open an editor "EKRE_08bp" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | EKRE08B_P |
    | fakt      | ja        |
    | budat     | .         |
And I delete all rows
And I append rows
    | artikel | mge | fmenge |
    | RAD     | 5   | 5      |
# Fehler 551: Feld ist nicht aenderbar
Then pressing button "pmneubu" in row 1 throws the exception "551"
And I close the current editor


Scenario: 09 Lieferschein Behaelternummer nicht leeren, wenn neue Packmittelzeile in der Gruppe erfasst wird

Given I open an editor "EKLS_09p" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | EKLS09_P  |
And I delete all rows
And I append rows
    | artikel | mge | exbehnum      | packm |
    | RAD     | 5   | BEHAELTER_09P | KLT   |
    | RAHMEN  | 5   |               |       |
And I press button "pmneubu" in row 2
And I append rows
    | artikel | mge |
    | KLT     | 1   |
Then field "exbehnum" is not empty in row 1
Then field "packm" is not empty in row 1
And I close the current editor


Scenario: 10a Lieferschein - Dienstleistungen koennen nicht verpackt werden

Given I open an editor "dl_beh_10p" from table "(Part):(Service)" with command "STORE" for record "DL-BEH_10"
And I set field "such" to "DL-BEH_10"
And I save the current editor

# im Lieferschein fuer Dienstleistung kann kein Behaelter oder Packmittel eingetragen werden
Given I open an editor "EKLS_10ap" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | EKLS10A_P |
And I delete all rows
And I append rows
    | artikel           | mge |
    | !dl_beh_10p^id    | 1   |
Then field "exbehnum" is not modifiable in row 1
Then field "packm" is not modifiable in row 1
And I close the current editor


Scenario: 10b Rechnung mL - Dienstleistungen koennen nicht verpackt werden

Given I open an editor "EKRE_10bp" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | EKRE10B_P |
    | fakt      | ja        |
    | budat     | .         |
And I delete all rows
And I append rows
    | artikel           | mge |
    | !dl_beh_10p^id    | 1   |
Then field "exbehnum" is not modifiable in row 1
Then field "packm" is not modifiable in row 1
And I close the current editor


Scenario: 11 Lieferschein - Gleiche Behaelternummer in mehreren Lieferscheinen -> es werden 2 Behaelter angelegt

# Lieferschein 1 anlegen - aber noch nicht buchen
Given I open an editor "EKLS_11ap" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | EKLS11A_P |
And I delete all rows
And I append rows
    | artikel | mge | exbehnum     | packm |
    | RAD     | 1   | 11behaelter  | KLT   |
And I save the current editor

# Lieferschein 2 anlegen - aber noch nicht buchen
Given I open an editor "EKLS_11bp" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | EKLS11B_P |
And I delete all rows
And I append rows
    | artikel | mge | exbehnum     | packm |
    | SATTEL  | 1   | 11behaelter  | KLT   |
And I save the current editor

# 1. Lieferschein buchen
Given I open an editor "EKLS_11ap" from table "(Purchasing):(PackingSlip)" with command "TRANSFER" for record from editor "EKLS_11ap"
And I save the current editor

# 2. Lieferschein buchen
Given I open an editor "EKLS_11bp" from table "(Purchasing):(PackingSlip)" with command "TRANSFER" for record from editor "EKLS_11bp"
And I save the current editor

# Nach dem Buchen beider Lieferscheine gibt es 2 Behaelter mit exbehnum = 11behaelter
Given I open an editor "11behaelter_1" from table "(Container):(ContainerShell)" with command "VIEW" for record "$,,nummer=11BEHAELTER;exbehnum/11BEHAELTER"
Then table has values
    | artikel | mge |
    | RAD     | 2   |
And I close the current editor

Given I open an editor "11behaelter_2" from table "(Container):(ContainerShell)" with command "VIEW" for record "$,,nummer<>11BEHAELTER;exbehnum/11BEHAELTER"
Then table has values
    | artikel | mge |
    | SATTEL  | 1   |
And I close the current editor

Scenario: 12 Rechnung mL - Gleiche Behaelternummer in mehreren Rechnungen - wie Scenario 11

# Rechnung mL 1 anlegen - aber noch nicht buchen
Given I open an editor "EKRE_12ap" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | EKRE12A_P |
    | fakt      | ja        |
    | budat     | .         |
And I delete all rows
And I append rows
    | artikel | mge | exbehnum     | packm |
    | RAD     | 1   | 12behaelter  | KLT   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung mL 2 anlegen - aber noch nicht buchen
Given I open an editor "EKRE_12bp" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | EKRE12B_P |
    | fakt      | ja        |
    | budat     | .         |
And I delete all rows
And I append rows
    | artikel | mge | exbehnum     | packm |
    | SATTEL  | 1   | 12behaelter  | KLT   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 1. Rechnung buchen
Given I open an editor "EKRE_12ap" from table "(Purchasing):(Invoice)" with command "TRANSFER" for record from editor "EKRE_12ap"
And I save the current editor

# 2. Rechnung buchen
Given I open an editor "EKRE_12bp" from table "(Purchasing):(Invoice)" with command "TRANSFER" for record from editor "EKRE_12bp"
And I save the current editor

# Nach dem Buchen der beiden Rechnungen gibt es zwei Behaelter mit exbehnum = 12behaelter
Given I open an editor "12behaelter_1" from table "(Container):(ContainerShell)" with command "VIEW" for record "$,,nummer=12BEHAELTER;exbehnum/12BEHAELTER"
Then table has values
    | artikel | mge |
    | RAD     | 2  |
And I close the current editor

Given I open an editor "12behaelter_2" from table "(Container):(ContainerShell)" with command "VIEW" for record "$,,nummer<>12BEHAELTER;exbehnum/12BEHAELTER"
Then table has values
    | artikel | mge |
    | SATTEL  | 1   |
And I close the current editor


# FDA-3427
Scenario: 13 Erfassdatum und Erfasser werden bei Neuanlage eines Behaelters ueber Lieferschein und Rechnung gefuellt

# Lieferschein
Given I open an editor "Lieferschein" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | ERFASS1   |
    | ueb       | ja        |
And I append rows
    | artikel   | mge   | exbehnum  | packm     |
    | SATTEL    | 10    | ERFASS1   | BEHAELTER |
    | PEDALE    | 10    |           |           |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I append rows
    | zuomge    | exbehnum  | packm     |
    | 10        | ERFASS2   | BEHAELTER |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Behaelter pruefen
Given I open an editor "ERFASS1" from table "(Container):(ContainerShell)" with command "VIEW" for record "ERFASS1"
Then field "erfass" contains value "02.01.1995"
Then field "erfasserzeichen" has value "SY"
And I close the current editor

Given I open an editor "ERFASS2" from table "(Container):(ContainerShell)" with command "VIEW" for record "ERFASS2"
Then field "erfass" contains value "02.01.1995"
Then field "erfasserzeichen" has value "SY"
And I close the current editor

# Rechnung
Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | ERFASS2   |
    | budat     | .         |
    | ueb       | ja        |
And I append rows
    | artikel   | mge   | exbehnum  | packm     |
    | SATTEL    | 10    | ERFASS3   | BEHAELTER |
    | PEDALE    | 10    |           |           |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I append rows
    | zuomge    | exbehnum  | packm     |
    | 10        | ERFASS4   | BEHAELTER |
And I save the current subeditor to switch back to the parent editor
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Behaelter pruefen
Given I open an editor "ERFASS3" from table "(Container):(ContainerShell)" with command "VIEW" for record "ERFASS3"
Then field "erfass" contains value "02.01.1995"
Then field "erfasserzeichen" has value "SY"
And I close the current editor

Given I open an editor "ERFASS4" from table "(Container):(ContainerShell)" with command "VIEW" for record "ERFASS4"
Then field "erfass" contains value "02.01.1995"
Then field "erfasserzeichen" has value "SY"
And I close the current editor

