# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Verkaufsrechnung_Materialzuordnung_mit_Lagerbew.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Rechnungen mit Lagerbewegung und MZs im Verkauf mit Behaeltern
#
# *****************************************************************************
@persistent
Feature: VERSAND_BEHAELTER_Verkaufsrechnung_Materialzuordnung_mit_Lagerbew.feature
Background:
Given I set the fake date to "02.01.1995"

# ACHTUNG!! NUMMER ANLEGEN FUER SZENARIO 04, 05, 15:
# 04 - BEHAELTER: KLWIRDGELEERT_R9
# 05 - BEHAELTER: RECK_BEHALETERNEU_R9
# 15 - BEHAELTER: RUECK_RECHNUNG_NEUERBEH_R9

##################################################################################################################

@VKRECHNUNG
Scenario: 01 einen Artikel versenden
Given I open an editor "behaelter01" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "RE_EINEN_ARTIKEL"
And I set field "packm" to "KLT"
And I save the current editor

Scenario: 01 Lagerbuchung einen Artikel versenden
Given I open an editor "Lagerbuchung01" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "PEDALE"
And I set field "buart" to "Zugang"
And I set field "beleg" to "LRL01"
And I set field "beldat" to "."
And I set field "mge" to "5" in row 1
And I set field "behaelter" to "nummer" from editor "behaelter01" in row 1
And I save the current editor

# 7.3. Lisa, Konto wird nicht bebucht, VERSAND-836
Scenario: 01 Rechnung einen Artikel versenden
Given I open an editor "VKRechnung01" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "PEDALE" in row 1
And I set field "mge" to "5" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to "nummer" from editor "behaelter01" in row 1
And I save the current editor
And I switch the current editor to editor "VKRechnung01"
Then field "packanw" is not empty in row 1
And I set field "ueb" to "JA"
And I set field "fakt" to "ja"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Abgang" in row 1

Scenario: 01 Behaelter pruefen
And I open an editor "beaelter" from table "(Container):(ContainerShell)" with command "VIEW" for record "RE_EINEN_ARTIKEL"
Then the table has 0 rows
Then field "kl" is empty
Then field "behstatusaz" has value "Geliefert"
Then field "behleer" has value "nein"
And I close the current editor

Scenario: 01 Lagerjournal
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "nummer" from editor "VKRechnung01"
And I press start
Then field "art" has value "PEDALE" in row 1
Then field "amge" has value "5" in row 1
And I close the current editor


@Versandlieferschein
Scenario: 02 zwei unterschiedliche Artikel versenden
Given I open an editor "behaelter02" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "RE_ZWEI_ARTIKEL"
And I set field "packm" to "KLT"
And I save the current editor

Scenario Outline: 02 Lagebuchung zwei unterschiedliche Artikel
Given I open an editor "<Leditor>" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "<artikel>"
And I set field "buart" to "Zugang"
And I set field "beleg" to "LRL02"
And I set field "beldat" to "."
And I set field "mge" to "5" in row 1
And I set field "behaelter" to "nummer" from editor "<behaelter>" in row 1
And I save the current editor

Examples: Lagerbuchungen
| Leditor          | artikel | behaelter   |
| Lagerbuchung02_1 | PEDALE  | behaelter02 |
| Lagerbuchung02_2 | SATTEL  | behaelter02 |


# 7.3. Lisa, Konto wird nicht bebucht, VERSAND-836
Scenario: 02 Rechnung zwei unterschiedliche Artikel
Given I open an editor "VKRechnung02" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "PEDALE" in row 1
And I set field "mge" to "5" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to "nummer" from editor "behaelter02" in row 1
And I save the current editor
And I switch the current editor to editor "VKRechnung02"
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 2
And I set field "mge" to "5" in row 2
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I set field "behaelter" to "nummer" from editor "behaelter02" in row 1
And I save the current editor
And I switch the current editor to editor "VKRechnung02"
Then field "packanw" is not empty in row 1
Then field "packanw" is not empty in row 2
And I set field "ueb" to "JA"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Abgang" in row 1
#Then field "bhbuchung^mge" has value "0" in row 2
#Then field "bhbuchung^buart" has value "" in row 2

Scenario: 02 Behaelter pruefen
And I switch the current editor to editor "behaelter02" with command "VIEW"
Then the table has 0 rows
Then field "kl" is empty
Then field "behstatusaz" has value "Geliefert"
Then field "behleer" has value "nein"
And I close the current editor

Scenario: 02 Lagerjournal
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "nummer" from editor "VKRechnung02"
And I press start
Then the table has 2 rows
Then field "art" has value "PEDALE" in row 1
Then field "amge" has value "5" in row 1
Then field "art" has value "SATTEL" in row 2
Then field "amge" has value "5" in row 2
And I close the current editor


@VKRechnung
Scenario: 03 Fehlermeldungen 8343 Der angegebene Behaelter ist leer
#                             8801 Der Artikel ist nicht mit den passenden Gebindeinformationen im Behaelter enthalten.;
#                             8342 Die Menge im Behaelter weicht von der Menge im Lieferschein ab.Behaeltermenge uebernehmen?)
Given I open an editor "behaelter03" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "FEHLERMELDUNGEN_03"
And I set field "packm" to "KLT"
And I save the current editor

Scenario: 03 Rechnung Fehlermeldungen 8343
Given I open an editor "VKRechnung03_1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "PEDALE" in row 1
And I set field "mge" to "10" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then setting field "behaelter" in row 1 to "such" from editor "behaelter03" in row 0 throws the exception ""
And I close the current editor
And I switch the current editor to editor "VKRechnung03_1"
And I close the current editor

Scenario: 03 Lagerbuchung Fehlermeldung 8801 8342
Given I open an editor "Lagerbuchung03" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "PEDALE"
And I set field "buart" to "Zugang"
And I set field "beleg" to "LRL03"
And I set field "beldat" to "."
And I set field "mge" to "5" in row 1
And I set field "behaelter" to "nummer" from editor "behaelter03" in row 1
And I save the current editor

Scenario: 03 Rechnung Fehlermeldung 8801 8342
Given I open an editor "VKRechnung03_2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 1
And I set field "mge" to "10" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then setting field "behaelter" in row 1 to "such" from editor "behaelter03" in row 0 throws the exception ""
And I set field "behaelter" to "" in row 1
And I save the current editor
And I switch the current editor to editor "VKRechnung03_2"
And I delete all rows
And I create a new row at the end of the table
And I set field "artikel" to "PEDALE" in row 1
And I set field "mge" to "1" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to "nummer" from editor "behaelter03" in row 1
And I save the current editor
And I switch the current editor to editor "VKRechnung03_2"
And I set field "ueb" to "JA"
And saving the current editor throws the exception ""

Then field "mge" has value "1" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And field "behaelter" in row 1 has value equal to field "nummer" from editor "behaelter03" in row 0
And I save the current editor
And I switch the current editor to editor "VKRechnung03_2"

And saving the current editor throws the exception ""
And I close the current editor


@VKRechnung
Scenario: 04 Feld kl wird bei Versand von Behaelter nicht geleert, Lieferant bleibt
Given I open an editor "einkaufslieferschein04" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "KETTLER"
And I set field "vom" to "."
And I set field "ebeleg" to "EK-Lieferschein_04"
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 1
And I set field "mge" to "2" in row 1
And I set field "exbehnum" to "KLWIRDGELEERT_R9" in row 1
And I set field "packm" to "KLT" in row 1
And I set field "ueb" to "JA"
And I save the current editor

Scenario: 04 Rechnung Feld kl wird bei Versand von Behaelter nicht geleert, Lieferant bleibt
Given I open an editor "VKRechnung04" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 1
And I set field "mge" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to "$,,exbehnum=KLWIRDGELEERT_R9;@richtung=rückwärts;@maxtreffer=1" in row 1
And I save the current editor
And I switch the current editor to editor "VKRechnung04"
And I set field "ueb" to "JA"
And I save the current editor

And I open an editor "behaelter04" from table "(Container):(ContainerShell)" with command "VIEW" for record "KLWIRDGELEERT_R9"
Then the table has 0 rows
Then field "kl^such" has value "KETTLER"
Then field "behstatusaz" has value "Geliefert"
Then field "behleer" has value "nein"
And I close the current editor


# 7.3. Lisa, Konto wird nicht bebucht, VERSAND-836
@VKRechnung
Scenario: 05 Ruecklieferung ein Artikel, Behaelter anlegen
Given I open an editor "VKRechnung05" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "RAHMEN" in row 1
And I set field "mge" to "5" in row 1
And I set field "ueb" to "JA"
And I save the current editor

Given I open an editor "VKRueck_05" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "VKRechnung05"
And I set field "vom" to "."
And I set field "mge" to "-3" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "-3" in row 1
And I set field "exbehnum" to "RECK_BEHALETERNEU_R9" in row 1
And I set field "packm" to "KLT" in row 1
And I save the current editor
And I switch the current editor to editor "VKRueck_05"
And I set field "ueb" to "JA"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1

Scenario: 05 Behaelter pruefen
And I open an editor "behaelter05" from table "(Container):(ContainerShell)" with command "VIEW" for record "RECK_BEHALETERNEU_R9"
Then the table has 1 rows
Then field "kl^such" has value "RADSHOP"
And I close the current editor


@VKRechnung
Scenario: 06 Ruecklieferung zwei gleiche Artikel, bestehender Behaelter
Given I open an editor "behaelter06" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "RUECK_ZWEIGLEICHEARTIKEL"
And I set field "packm" to "KLT"
And I save the current editor

# 7.3. Lisa, Konto wird nicht bebucht, VERSAND-836
Scenario: 06  Ruecklieferung zwei gleiche Artikel, bestehender Behaelter
Given I open an editor "VKRechnung06" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "RAHMEN" in row 1
And I set field "mge" to "3" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "RAHMEN" in row 2
And I set field "mge" to "3" in row 2
And I set field "ueb" to "JA"
And I save the current editor

Given I open an editor "VKRueck_06" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "VKRechnung06"
And I set field "vom" to "."
And I set field "mge" to "-3" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "-3" in row 1
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "nummer" from editor "behaelter06" in row 1
And I save the current editor
And I switch the current editor to editor "VKRueck_06"
And I set field "mge" to "-2" in row 2
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I set field "zuomge" to "-2" in row 1
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "nummer" from editor "behaelter06" in row 1
And I save the current editor
And I switch the current editor to editor "VKRueck_06"
And I set field "ueb" to "JA"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1

Scenario: 06 Behaelter pruefen
And I switch the current editor to editor "behaelter06" with command "VIEW"
Then the table has 1 rows
Then field "kl" has value ""
Then field "behstatusaz" has value ""
Then field "mge" has value "5" in row 1
And I close the current editor


@VKRechnung
Scenario: 07 Rueklieferung zwei unterschiedliche Artikel, bestehender Behaelter
Given I open an editor "behaelter07" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "RUECK_ZWEIVERSCHARTIKEL"
And I set field "packm" to "KLT"
And I save the current editor

# 7.3. Lisa, Konto wird nicht bebucht, VERSAND-836
Scenario: 07 Rechnung Ruecklieferung zwei unterschiedliche Artikel, bestehender Behaelter
Given I open an editor "VKRechnung07" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "RAHMEN" in row 1
And I set field "mge" to "5" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 2
And I set field "mge" to "5" in row 2
And I set field "ueb" to "JA"
And I save the current editor

Given I open an editor "VKRueck_07" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "VKRechnung07"
And I set field "vom" to "."
And I set field "mge" to "-3" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "-3" in row 1
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "nummer" from editor "behaelter07" in row 1
And I save the current editor
And I switch the current editor to editor "VKRueck_07"
And I set field "mge" to "-2" in row 2
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I set field "zuomge" to "-2" in row 1
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "nummer" from editor "behaelter07" in row 1
And I save the current editor
And I switch the current editor to editor "VKRueck_07"
And I set field "ueb" to "JA"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1

Scenario: 07 Behaelter pruefen
And I switch the current editor to editor "behaelter07"
Then the table has 2 rows
Then field "kl" has value ""
Then field "behstatusaz" has value ""
And I close the current editor


@VKRechnung
Scenario: 08 ein Artikel mit Charge, Pruefung der Gebindeinformationen
Given I open an editor "behaelter08" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "RE_ARTIKEL_MIT_CHARGE"
And I set field "packm" to "KLT"
And I save the current editor

Given I open an editor "Charge08" from table "(Lots):(Lots)" with command "STORE" for record "MTLAGERB_08"
And I set field "such" to "MTLAGERB_08"
And I set field "exnum" to "MZLAGERB_08"
And I set field "artikel" to "SATTEL"
And I save the current editor

Scenario: 08 Lagerbuchung ein Artikel mit Charge, Pruefung der Gebindeinformationen
Given I open an editor "Lagerbuchung08" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "SATTEL"
And I set field "buart" to "Zugang"
And I set field "beleg" to "LRL08"
And I set field "beldat" to "."
And I set field "mge" to "5" in row 1
And I set field "behaelter" to "nummer" from editor "behaelter08" in row 1
And I set field "charge2" to id from editor "Charge08" in row 1
And I save the current editor

Scenario: 08 Rechnung ein Artikel mit Charge, Pruefung der Gebindeinformationen
Given I open an editor "VKRechnung08" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 1
And I set field "mge" to "5" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to "nummer" from editor "behaelter08" in row 1
And I save the current editor
And I switch the current editor to editor "VKRechnung08"
And I set field "ueb" to "JA"

Then saving the current editor throws the exception ""
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "charge" to id from editor "Charge08" in row 1
And I save the current editor
And I switch the current editor to editor "VKRechnung08"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Abgang" in row 1


@VKRechnung
Scenario: 09 mehrere Artikel mit und ohne Charge, Pruefung der Gebindeinformationen
Given I open an editor "behaelter09" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "GEBINDEINFOS_PRUEFEN"
And I set field "packm" to "KLT"
And I save the current editor

Given I open an editor "Charge09" from table "(Lots):(Lots)" with command "STORE" for record "RELAGERB_09"
And I set field "such" to "RELAGERB_09"
And I set field "exnum" to "RELAGERB_09"
And I set field "artikel" to "SATTEL"
And I save the current editor


Scenario: 09 EK-Lieferschein mehrere Artikel mit und ohne Charge, Pruefung der Gebindeinformationen
Given I open an editor "einkaufslieferschein09" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "KETTLER"
And I set field "vom" to "."
And I set field "ebeleg" to "EK_Lieferschein_09"
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 1
And I set field "mge" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung09" in row 1
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "nummer" from editor "behaelter09" in row 1
And I set field "charge" to id from editor "Charge09" in row 1
And I save the current editor
And I switch the current editor to editor "einkaufslieferschein09"
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 2
And I set field "mge" to "5" in row 2
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "nummer" from editor "behaelter09" in row 1
And I save the current editor
And I switch the current editor to editor "einkaufslieferschein09"
And I create a new row at the end of the table
And I set field "artikel" to "RAD" in row 3
And I set field "mge" to "1" in row 3
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 3
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "nummer" from editor "behaelter09" in row 1
And I save the current editor
And I switch the current editor to editor "einkaufslieferschein09"
And I set field "ueb" to "JA"
And I save the current editor

Scenario: 09 Verkaufslieferschein mehrere Artikel mit und ohne Charge, Pruefung der Gebindeinformationen
Given I open an editor "VKRechnung09" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 1
And I set field "mge" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to "nummer" from editor "behaelter09" in row 1
And I save the current editor
And I switch the current editor to editor "VKRechnung09"
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 2
And I set field "mge" to "5" in row 2
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I set field "behaelter" to "nummer" from editor "behaelter09" in row 1
And I save the current editor
And I switch the current editor to editor "VKRechnung09"
And I create a new row at the end of the table
And I set field "artikel" to "RAD" in row 3
And I set field "mge" to "1" in row 3
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 3
And I set field "behaelter" to "nummer" from editor "behaelter09" in row 1
And I save the current editor
And I switch the current editor to editor "VKRechnung09"
And I set field "ueb" to "JA"

Then saving the current editor throws the exception ""
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "charge" to id from editor "Charge09" in row 1
And I save the current editor
And I switch the current editor to editor "VKRechnung09"

And I save the current editor


@VKRechnung
Scenario: 10 Rueklieferung ein Artikel mit Charge
Given I open an editor "behaelter10" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "RUECK_ARTIKELMITCHARGE"
And I set field "packm" to "KLT"
And I save the current editor

Given I open an editor "Charge10" from table "(Lots):(Lots)" with command "STORE" for record "RMZLAGERB_10"
And I set field "such" to "RMZLAGERB_10"
And I set field "exnum" to "RMZLAGERB_10"
And I set field "artikel" to "SATTEL"
And I save the current editor


Scenario: 10 Rechnung Rueklieferung ein Artikel mit Charge
Given I open an editor "VKRechnung10" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 1
And I set field "mge" to "5" in row 1
And I set field "charge" to id from editor "Charge10" in row 1
And I set field "ueb" to "JA"
And I save the current editor

Given I open an editor "VKRueck_10" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "VKRechnung10"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "-2" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "-2" in row 1
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "nummer" from editor "behaelter10" in row 1
And I set field "charge" to id from editor "Charge10" in row 1
And I save the current editor
And I switch the current editor to editor "VKRueck_10"
And I set field "ueb" to "JA"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1

Scenario: 10 Behaelter pruefen
And I switch the current editor to editor "behaelter10" with command "VIEW"
Then the table has 1 rows
Then field "charge" in row 1 has value equal to field "nummer" from editor "Charge10" in row 0
And I close the current editor


@VKRechnung
Scenario: 11 mehrere Artikel mit und ohne Charge
Given I open an editor "behaelter11" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "ARTIKELMITUNDOHNECHARGE"
And I set field "packm" to "KLT"
And I save the current editor

Given I open an editor "Charge11" from table "(Lots):(Lots)" with command "STORE" for record "R_MZLAGERB_11"
And I set field "such" to "R_MZLAGERB_11"
And I set field "exnum" to "R_MZLAGERB_11"
And I set field "artikel" to "SATTEL"
And I save the current editor


Scenario: 11 Rechnung mehrere Artikle mit und ohne Charge
Given I open an editor "VKRechnung11" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I set field "fakt" to "ja"
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 1
And I set field "mge" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "charge" to id from editor "Charge11" in row 1
And I save the current editor
And I switch the current editor to editor "VKRechnung11"
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 2
And I set field "mge" to "3" in row 2
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I save the current editor
And I switch the current editor to editor "VKRechnung11"
And I create a new row at the end of the table
And I set field "artikel" to "RAD" in row 3
And I set field "mge" to "1" in row 3
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 3
And I save the current editor
And I switch the current editor to editor "VKRechnung11"
And I set field "ueb" to "JA"
And I save the current editor


Given I open an editor "VKRueck_11" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "VKRechnung11"
And I set field "vom" to "."
And I set field "mge" to "-2" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "-2" in row 1
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "nummer" from editor "behaelter11" in row 1
And I set field "charge" to id from editor "Charge11" in row 1
And I save the current editor
And I switch the current editor to editor "VKRueck_11"
And I set field "mge" to "-3" in row 2
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I set field "zuomge" to "-3" in row 1
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "nummer" from editor "behaelter11" in row 1
And I save the current editor
And I switch the current editor to editor "VKRueck_11"
And I set field "mge" to "-1" in row 3
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 3
And I set field "zuomge" to "-1" in row 1
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "nummer" from editor "behaelter11" in row 1
And I save the current editor
And I switch the current editor to editor "VKRueck_11"
And I set field "ueb" to "JA"
And I save the current editor

Scenario: 11 Behaelter pruefen
And I switch the current editor to editor "behaelter11" with command "VIEW"
Then the table has 3 rows
Then field "charge" in row 3 has value equal to field "nummer" from editor "Charge11" in row 0
And I close the current editor


@VKRechnung
Scenario: 12 COPY VKRechnung leert Behaelterfelder
Given I open an editor "behaelter12" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "COPY_BEHAELTER"
And I set field "packm" to "KLT"
And I save the current editor

Scenario: 12 Lagerbuchung COPY VKRechnung leert Behaelterfelder
Given I open an editor "Lagerbuchung12" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "SATTEL"
And I set field "buart" to "Zugang"
And I set field "beleg" to "LRL12"
And I set field "beldat" to "."
And I set field "mge" to "2" in row 1
And I set field "behaelter" to "nummer" from editor "behaelter12" in row 1
And I save the current editor

Scenario: 12 Rechnung COPY VKRechnung leert Behaelterfelder
Given I open an editor "VKRechnung12" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 1
And I set field "mge" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to "nummer" from editor "behaelter12" in row 1
And I save the current editor
And I switch the current editor to editor "VKRechnung12"
And I set field "ueb" to "ja"
And I save the current editor

And I switch the current editor to editor "VKRechnung12" with command "COPY"
Then field "behaelter" is empty in row 1
Then field "exbehnum" is empty in row 1
And I close the current editor


@VKRechnung
Scenario: 13 Behaelterfelder werden leer und schreibgeschuetzt, wenn Rechnung ohne Lagerbewegung aktiv
Given I open an editor "behaelter13" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "RE_OHNELAGERBEW_AKTIV"
And I set field "packm" to "KLT"
And I save the current editor

Scenario: 13 Lagerbuchung Behaelterfelder werden leer und schreibgeschuetzt, wenn Rechnung ohne Lagerbewegung aktiv
Given I open an editor "Lagerbuchung13" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "SATTEL"
And I set field "buart" to "Zugang"
And I set field "beleg" to "LRL13"
And I set field "beldat" to "."
And I set field "mge" to "2" in row 1
And I set field "behaelter" to "nummer" from editor "behaelter13" in row 1
And I save the current editor

Scenario: 13 Rechnung Behaelterfelder werden leer und schreibgeschuetzt, wenn Rechnung ohne Lagerbewegung aktiv
Given I open an editor "VKRechnung13" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 1
And I set field "mge" to "2" in row 1
And pressing button "mzsubm" in row 1 throws the exception ""
And I close the current editor


@Verkaufsprozess
Scenario: 15 Verkaufsprozess - Behaelter anlegen
Given I open an editor "behaelter15" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "RE_PROZESS"
And I set field "packm" to "KLT"
And I save the current editor

Scenario: 15 Verkaufsprozess - Lagerbuchung
Given I open an editor "Lagerbuchung13" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "Fahrrad"
And I set field "buart" to "Zugang"
And I set field "beleg" to "LRL15"
And I set field "beldat" to "."
And I set field "wert" to "600"
And I set field "mge" to "10" in row 1
And I set field "behaelter" to "nummer" from editor "behaelter15" in row 1
And I save the current editor

Scenario: 15 Verkaufsprozess - Auftrag
Given I open an editor "auftrag15" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I set field "such" to "ARADSHOP"
And I set field "betreff" to "Bestellung Fahrrad"
When I create a new row at the end of the table
And I set field "artikel" to "FAHRRAD" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

Scenario: 15 Verkaufsprozess - Lieferschein
Given I open an editor "VKRechnung15" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to "id" from editor "auftrag15"
And I set field "mge" to "10" in row 1
And I set field "verw" to "" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to "nummer" from editor "behaelter15" in row 1
And I set field "verw" to "" in row 1
And I save the current editor
And I switch the current editor to editor "VKRechnung15"
And I set field "ueb" to "JA"
And I save the current editor

Scenario: 15 Behaelter VK pruefen
And I switch the current editor to editor "behaelter15" with command "VIEW"
Then the table has 0 rows
And I close the current editor

Scenario: 15 Verkaufsprozess - Ruecklieferung neuer Behaelter
Given I open an editor "VKRechnung_r_15" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "VKRechnung15"
And I set field "mge" to "-5" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "-5" in row 1
And I set field "exbehnum" to "RUECK_RECHNUNG_NEUERBEH_R9" in row 1
And I set field "packm" to "KLT" in row 1
And I save the current editor
And I switch the current editor to editor "VKRechnung_r_15"
And I set field "ueb" to "JA"
And I save the current editor

Scenario: 15 Behaelter Ruecklieferung pruefen
And I open an editor "behaelterpruef_r" from table "(Container):(ContainerShell)" with command "VIEW" for record "RUECK_RECHNUNG_NEUERBEH_R9"
Then the table has 1 rows
Then field "mge" has value "5" in row 1
And I close the current editor


Scenario: 15 Verkaufsprozess - Ruecklieferung bestehender Behaelter
Given I open an editor "behaelter15_2" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "RUECK_RE_BESTEHENDER_BEH"
And I set field "packm" to "KLT"
And I save the current editor

Given I open an editor "VKRechnung_r2_15" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "VKRechnung15"
And I set field "mge" to "-5" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "-5" in row 1
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "nummer" from editor "behaelter15_2" in row 1
And I save the current editor
And I switch the current editor to editor "VKRechnung_r2_15"
And I set field "ueb" to "JA"
And I save the current editor

Scenario: 15 Behaelter Ruecklieferung pruefen
And I switch the current editor to editor "behaelter15_2" with command "VIEW"
Then the table has 1 rows
Then field "mge" has value "5" in row 1
And I close the current editor

