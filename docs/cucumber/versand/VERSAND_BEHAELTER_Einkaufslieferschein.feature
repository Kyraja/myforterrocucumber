@persistent
Feature: VERSAND_BEHAELTER_Einkaufslieferschein.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Einkaufslieferschein.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet EK-Lieferscheine mit Behaeltern
#  ref              : ref_behaelter_einkauf_cu
#
# *****************************************************************************

Background:
Given I set the fake date to "02.01.1995"

Scenario: 01 Artikel in bestehenden Behaelter buchen

And I create a Container "behaelter_01" for packaging material "KLT"

Given I open an editor "EK-Lieferschein01" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | EKLS_01   |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   | !dialogId                                     | !dialogAnswer | exbehnum              |
    | RAHMEN    | 30    | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_01^nummer  |
And I save the current editor

Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Zugang" in row 1

And I switch the current editor to editor "behaelter_01" with command "VIEW"
Then field "behstatusaz" is empty
Then field "kl^such" is empty
Then table has values
    | artikel | mge | gebeinh |
    | RAHMEN  | 30  | kg      |
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum        | .                         |
    | beleg         | !EK-Lieferschein01^nummer |
    | kdetursache   | Lieferschein Einkauf      |    
And I press start
Then table has values
    | art    | zmge | mei | verweis^behaelter^id |
    | RAHMEN | 30   | kg  | !behaelter_01^id     |
And I close the current editor


Scenario: 02 Behaelter wird durch Lieferschein angelegt

Given I open an editor "EK-Lieferschein02" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | EKLS_02   |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   | exbehnum        | packm   |
    | RAHMEN    | 30    | BEH_KETTLER_K6  | KLT     |
And I save the current editor

Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Zugang" in row 1

Given I open an editor "behaelter_02" from table "(Container):(ContainerShell)" with command "VIEW" for record "BEH_KETTLER_K6"
Then fields have values
    | behstatusaz   |           |
    | kl^such       | KETTLER   |
Then table has values
    | artikel | mge | gebeinh |
    | RAHMEN  | 30  | kg      |
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum        | .                         |
    | beleg         | !EK-Lieferschein02^nummer |
    | kdetursache   | Lieferschein Einkauf      |
And I press start
Then table has values
    | art    | zmge | mei | verweis^behaelter^id |
    | RAHMEN | 30   | kg  | !behaelter_02^id     |
And I close the current editor


Scenario: 03 Zwei verschiedene Artikel in einen bestehenden Behaelter buchen

And I create a Container "behaelter_03" for packaging material "KLT"

Given I open an editor "EK-Lieferschein03" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER |
    | vom    | .       |
    | ebeleg | EKLS_03 |
    | ueb    | ja      |
And I delete all rows
And I append rows
    | artikel | mge | !dialogId                                     | !dialogAnswer | exbehnum             |
    | RAHMEN  | 5   | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_03^nummer |
    | SATTEL  | 2   | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_03^nummer |
And I save the current editor

Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Zugang" in row 1

And I switch the current editor to editor "behaelter_03"
Then field "behstatusaz" is empty
Then field "kl^such" is empty
Then table has values
    | artikel | mge | gebeinh |
    | RAHMEN  | 5   | kg      |
    | SATTEL  | 2   | Stück   |
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum        | .                         |
    | beleg         | !EK-Lieferschein03^nummer |
    | kdetursache   | Lieferschein Einkauf      |
And I press start
Then table has values
    | !row           | art    | zmge | mei    | behaelter^id     |
    | $,,art==RAHMEN | RAHMEN | 5    | kg     | !behaelter_03^id |
    | $,,art==SATTEL | SATTEL | 2    | Stück  | !behaelter_03^id |
And I close the current editor


Scenario: 04 Zwei verschiedene Artikel in vom Lieferschein angelegten Behaelter buchen

Given I open an editor "EK-Lieferschein04" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER |
    | vom    | .       |
    | ebeleg | EKLS_04 |
    | ueb    | ja      |
And I delete all rows
And I append rows
    | artikel | mge | exbehnum                      | packm |
    | RAHMEN  | 5   | ZWEI_ARTIKEL_IN_NEUEN_BEH_K6  | KLT   |
    | SATTEL  | 2   | ZWEI_ARTIKEL_IN_NEUEN_BEH_K6  | KLT   |
And I save the current editor

Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Zugang" in row 1

Given I open an editor "behaelter_04" from table "(Container):(ContainerShell)" with command "VIEW" for record "ZWEI_ARTIKEL_IN_NEUEN_BEH_K6"
Then fields have values
    | behstatusaz   |           |
    | kl^such       | KETTLER   |
Then table has values
    | artikel | mge | gebeinh |
    | RAHMEN  | 5   | kg      |
    | SATTEL  | 2   | Stück   |
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum        | .                         |
    | beleg         | !EK-Lieferschein04^nummer |
And I press start
Then table has values
    | art    | zmge | mei    | behaelter^id     |
    | RAHMEN | 5    | kg     | !behaelter_04^id |
    | SATTEL | 2    | Stück | !behaelter_04^id |
And I close the current editor


Scenario: 05 Zwei gleiche Artikel in einen bestehenden Behaelter buchen

And I create a Container "behaelter_05" for packaging material "KLT"

Given I open an editor "EK-Lieferschein05" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER |
    | vom    | .       |
    | ebeleg | EKLS_05 |
    | ueb    | ja      |
And I delete all rows
And I append rows
    | artikel | mge | !dialogId                                     | !dialogAnswer | exbehnum             |
    | SATTEL  | 7   | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_05^nummer |
    | SATTEL  | 3   | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_05^nummer |
And I save the current editor

Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Zugang" in row 1

And I switch the current editor to editor "behaelter_05"
Then field "behstatusaz" is empty
Then field "kl^such" is empty
Then table has values
    | artikel | mge |
    | SATTEL  | 10  |
And I close the current editor


Scenario: 06 Zwei gleiche Artikel mit unterschiedlichen Chargen in einen Behaelter buchen

And I create a Container "behaelter_06" for packaging material "KLT"

And I create a Lot "EK_CHARGE_06" for Product "SATTEL"

Given I open an editor "EK-Lieferschein06" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER |
    | vom    | .       |
    | ebeleg | EKLS_06 |
    | ueb    | ja      |
And I delete all rows
And I append rows
    | artikel | mge | !dialogId                                     | !dialogAnswer | exbehnum             | charge           |
    | SATTEL  | 7   | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_06^nummer | !dontChange      |
    | SATTEL  | 5   | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_06^nummer | !EK_CHARGE_06^id |
And I save the current editor

Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Zugang" in row 1

And I switch the current editor to editor "behaelter_06"
Then field "behstatusaz" is empty
Then field "kl^such" is empty
Then table has values
    | artikel | mge | charge^id        |
    | SATTEL  | 7   | (0,0,0)          |
    | SATTEL  | 5   | !EK_CHARGE_06^id |
And I close the current editor


Scenario: 07a ein Artikel, Artikelzeile, behaelter = BEH

Given I open an editor "EK-Lieferschein07a" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER  |
    | vom    | .        |
    | ebeleg | EKLS_07A |
    | ueb    | ja       |
And I delete all rows
And I append rows
    | artikel | mge | exbehnum  | packm |
    | RAD     | 1   | BEH10_K6  | KLT   |
Then field "exbehnum" is not empty in row 1
And I save the current editor

Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Zugang" in row 1

And I open an editor "behaelter_07a" from table "(Container):(ContainerShell)" with command "VIEW" for record "BEH10_K6"
Then fields have values
    | behstatusaz   |           |
    | such          | BEH10_K6  |
    | exbehnum      | BEH10_K6  |
Then the table has 1 rows
And I close the current editor


Scenario: 07b ein Artikel, Artikelzeile, behaelter = Beh

Given I open an editor "EK-Lieferschein07b" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER  |
    | vom    | .        |
    | ebeleg | EKLS_07B |
    | ueb    | ja       |
And I delete all rows
And I append rows
    | artikel | mge | exbehnum  | packm |
    | RAD     | 1   | Beh11_K6  | KLT   |
Then field "exbehnum" is not empty in row 1
And I save the current editor

Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Zugang" in row 1

And I open an editor "behaelter_07b" from table "(Container):(ContainerShell)" with command "VIEW" for record "Beh11_K6"
Then fields have values
    | behstatusaz   |           |
    | such          | BEH11_K6  |
    | exbehnum      | BEH11_K6  |
Then the table has 1 rows
And I close the current editor


Scenario: 07c ein Artikel, Artikelzeile, behaelter = beh

Given I open an editor "EK-Lieferschein07c" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER  |
    | vom    | .        |
    | ebeleg | EKLS_07C |
    | ueb    | ja       |
And I delete all rows
And I append rows
    | artikel | mge | exbehnum  | packm |
    | RAD     | 1   | beh12_K6  | KLT   |
Then field "exbehnum" is not empty in row 1
And I save the current editor

Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Zugang" in row 1

And I open an editor "behaelter_07c" from table "(Container):(ContainerShell)" with command "VIEW" for record "beh12_K6"
Then fields have values
    | behstatusaz   |           |
    | such          | BEH12_K6  |
    | exbehnum      | BEH12_K6  |
Then the table has 1 rows
And I close the current editor


Scenario: 08 Nur Artikel in Zeile mit Behaelter wird in den Behaelter gebucht, andere Artikel nicht

And I create a Container "behaelter_08" for packaging material "KLT"

Given I open an editor "EK-Lieferschein08" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER |
    | vom    | .       |
    | ebeleg | EKLS_08 |
    | ueb    | ja      |
And I delete all rows
And I append rows
    | artikel | mge | !dialogId                                     | !dialogAnswer | exbehnum             |
    | RAHMEN  | 3   |                                               |               |                      |
    | RAD     | 1   |                                               |               |                      |
    | RAD     | 2   | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_08^nummer |
And I save the current editor

Then field "bhbuchung^mge" has value "0" in row 1
Then field "bhbuchung^buart" is empty in row 1

And I switch the current editor to editor "behaelter_08" with command "VIEW"
Then table has values
    | artikel | mge | gebeinh |
    | RAD     | 4   | Stück   |
And I close the current editor


Scenario: 09 Lieferschein Behaelter einmal in Artikelzeile und einmal in Materialzuordnung

And I create a Container "behaelter_09" for packaging material "KLT"

Given I open an editor "EK-Lieferschein09" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER |
    | vom    | .       |
    | ebeleg | EKLS_09 |
    | ueb    | ja      |
And I delete all rows
And I append rows
    | artikel | mge | !dialogId                                     | !dialogAnswer | exbehnum             |
    | RAD     | 2   | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_09^nummer |
    | SATTEL  | 1   |                                               |               |                      |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "nummer" from editor "behaelter_09" in row 1
And I save the current editor
And I switch the current editor to editor "EK-Lieferschein09"
And I save the current editor

Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Zugang" in row 1

And I switch the current editor to editor "behaelter_09" with command "VIEW"
Then table has values
    | artikel | mge | gebeinh |
    | RAD     | 4   | Stück   |
    | SATTEL  | 1   | Stück   |
And I close the current editor


Scenario: 10 EK-Prozess - Bestellung, daraus Lieferschein, daraus Ruecklieferschein

Given I open an editor "Bestellung10" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER   |
    | such   | BESTELL10 |
And I delete all rows
And I append rows
    | artikel | mge |
    | SATTEL  | 10  |
And I save the current editor

Given I open an editor "EK-Lieferschein10" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "Bestellung10"
And I set fields
    | vom    | .       |
    | ebeleg | EKLS_10 |
    | ueb    | ja      |
And I modify table
    | !row   | mge | exbehnum           | packm    |
    | 1      | 10  | KLINGEL_PROZESS_K6 | KLT      |
And I save the current editor

And I open an editor "behaelter_10" from table "(Container):(ContainerShell)" with command "VIEW" for record "KLINGEL_PROZESS_K6"
Then the table has 1 rows
Then field "mge" has value "10" in row 1
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum        | .                         |
    | beleg         | !EK-Lieferschein10^nummer |
And I press start
Then the table has 1 rows
And I close the current editor

Given I open an editor "EK-Lieferschein10_R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "EK-Lieferschein10"
And I set fields
    | vom    | .                |
    | ebeleg | RLS_Klingel_10   |
    | ueb    | ja               |
And I modify table
    | !row   | mge | behaelter           |
    | 1      | -10 | KLINGEL_PROZESS_K6  |    
And I save the current editor

And I switch the current editor to editor "behaelter_10"
Then field "behstatusaz" has value "Rücklieferung"
Then the table has 0 rows
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum        | .                           |
    | beleg         | !EK-Lieferschein10_R^nummer |
    | kursache      | Lieferschein                |
And I press start
Then the table has 1 rows
And I close the current editor


Scenario: 11 vorhandenen Behaelter mit exbehnum verwenden

And I open an editor "behaelter_11" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set fields
    | exbehnum  | EXBEHNUM  |
    | packm     | KLT       |
And I save the current editor

Given I open an editor "EK-Lieferschein11" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER |
    | vom    | .       |
    | ebeleg | EKLS_11 |
    | ueb    | ja      |
And I delete all rows
And I append rows
    | artikel | mge | !dialogId                                     | !dialogAnswer | exbehnum             |
    | RAD     | 5   | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_11^nummer |
Then field "behaelter" in row 1 has value equal to field "nummer" from editor "behaelter_11" in row 0
And I save the current editor

And I switch the current editor to editor "behaelter_11" with command "VIEW"
Then table has values
    | artikel | mge |
    | RAD     | 10  |
And I close the current editor


Scenario: 12 Packmittel berechnen und manuell, Artikelmenge auf mehrere Behaelter aufteilen

And I create a Container "behaelter_12a" for packaging material "KLT"
And I create a Container "behaelter_12b" for packaging material "KLT"
And I create a Container "behaelter_12c" for packaging material "KLT"

Given I open an editor "EK-Lieferschein12" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER |
    | ebeleg | EKLS_12 |
    | vom    | .       |
    | ueb    | ja      |
And I delete all rows
And I append rows
    | artikel | mge | !dialogId                                     | !dialogAnswer | exbehnum              |
    | RAD     | 30  | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_12a^nummer |
And I press button "packvor"
Then table has values
    | !row     | artikel  | mge |
    | 2        | KLT      | 1   |
And I append rows
    | artikel | mge | !dialogId                                     | !dialogAnswer | exbehnum              |
    | RAD     | 10  | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_12b^nummer |
And I press button "packvor"
Then table has values
    | !row     | artikel  | mge |
    | 4        | KLT      | 1   |
    | !lastRow | SPALETTE | 1   |
And I append rows
    | artikel | mge | !dialogId                                     | !dialogAnswer | exbehnum              |
    | RAHMEN  | 10  | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_12b^nummer |
And I press button "packvor"
Then table has values
    | !row     | artikel  | mge |
    | !lastRow | KLT      | 1   |
And I append rows
    | artikel | mge | !dialogId                                     | !dialogAnswer | exbehnum              |
    | PEDALE  | 20  | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_12c^nummer |
And I press button "pmneu" in row !lastRow
And I append rows
    | artikel | mge |
    | KLT     | 2   |
And I save the current editor

And I switch the current editor to editor "behaelter_12a"
Then table has values
    | artikel | mge |
    | RAD     | 60  |
And I close the current editor

And I switch the current editor to editor "behaelter_12b"
Then table has values
    | artikel | mge |
    | RAHMEN  | 10  |
    | RAD     | 20  |
And I close the current editor

And I switch the current editor to editor "behaelter_12c"
Then table has values
    | artikel | mge |
    | PEDALE  | 40  |
And I close the current editor


Scenario: 13 Einheiten in Packmittelzeilen sind korrekt

And I create a Container "behaelter_13a" for packaging material "KLT"
And I create a Container "behaelter_13b" for packaging material "KLT"

Given I open an editor "EK-Lieferschein13" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER |
    | ebeleg | EKLS_13 |
    | vom    | .       |
And I delete all rows
And I append rows
    | artikel | mge | !dialogId                                     | !dialogAnswer | exbehnum              |
    | RAD     | 10  | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_13a^nummer |
And I press button "packvor"
Then table has values
    | !row     | artikel  | mge | he    |
    | 2        | KLT      | 1   | Stück |
    | 3        | KLT      | 3   | Stück |
    | 4        | SPALETTE | 1   | Stück |
And I append rows
    | artikel | mge | !dialogId                                     | !dialogAnswer | exbehnum              |
    | PEDALE  | 20  | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_13b^nummer |
And I press button "pmneu" in row !lastRow
And I append rows
    | artikel | mge |
    | KLT     | 2   |
Then field "he" has value "Stück" in row !lastRow
And I close the current editor


Scenario: 14 EK-Lieferschein einen Artikel in vom LS angelegten Behaelter buchen, Ablageschutz gesetzt. Berechnet. Ablageschutz entfernt.

Given I open an editor "EK-Lieferschein14" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief     | KETTLER |
    | ebeleg   | EKLS_14 |
    | vom      | .       |
    | ueb      | ja      |
    | noablage | ja      |
And I delete all rows
And I append rows
    | artikel | mge | exbehnum | packm  |
    | RAHMEN  | 5   | EK_LS_14 | KLT    |
And I save the current editor

Given I open an editor "Einkaufsrechnung14" from table "(Purchasing):(Invoice)" with command "NEW" for record from editor "EK-Lieferschein14"
And I set fields
    | ebeleg   | EKRE_14 |
    | vom      | .       |
    | ueb      | ja      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then "(Purchasing):(PackingSlip)" with the editor id "EK-Lieferschein14" is not filed

And I switch the current editor to editor "EK-Lieferschein14" with command "UPDATE"
And I set field "noablage" to "nein"
And I save the current editor

Then "(Purchasing):(PackingSlip)" with the editor id "EK-Lieferschein14" is filed
