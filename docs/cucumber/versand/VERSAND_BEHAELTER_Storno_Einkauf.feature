# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Storno_Einkauf.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Storno im Einkauf mit Behaeltern
#  ref              : ref_behaelter_evstorno_cu
#  Stammdaten       : VERSAND_BEHAELTER_Stammdaten.feature
#
# *****************************************************************************
@persistent
Feature: VERSAND_BEHAELTER_Storno_Einkauf.feature
Background:
Given I set the fake date to "02.01.1995"

###############################################################################
# Scenarien 1-12 und 26-27 in VERSAND_BEHAELTER_Storno_Verkauf.feature

Scenario: 13 Storno EK Lieferschein mit einem Behaelter und einem Artikel

Given I create a Container "Behaelter13" for packaging material "KLT"

Given I open an editor "Lieferschein13" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER                 |
    | vom       | .                       |
    | ebeleg    | Storno Lieferschein 13  |
    | ueb       | ja                      |
And I delete all rows
And I append rows
    | artikel   | mge   | !dialogId                                     | !dialogAnswer | exbehnum              |
    | SATTEL    | 10    | Externe Behälternummer ist bereits vergeben. | nein          | !Behaelter13^nummer   |
And I save the current editor

And I switch the current editor to editor "Lieferschein13" with command "REVERSAL"
And I save the current editor

Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Abgang" in row 1
Then field "bhbuchung^bhkto^such" has value "KNTKETTLER" in row 1

Then Container from editor "Behaelter13" is empty


Scenario: 14 Storno EK Lieferschein mit einem Behaelter und mehreren Artikeln

Given I create a Container "Behaelter14" for packaging material "KLT"

Given I open an editor "Lieferschein14" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER                 |
    | vom       | .                       |
    | ebeleg    | Storno Lieferschein 14  |
    | ueb       | ja                      |
And I delete all rows
And I append rows
    | artikel   | mge   | !dialogId                                     | !dialogAnswer | exbehnum              |
    | SATTEL    | 10    | Externe Behälternummer ist bereits vergeben. | nein          | !Behaelter14^nummer   |
    | PEDALE    | 10    | Externe Behälternummer ist bereits vergeben. | nein          | !Behaelter14^nummer   |
And I save the current editor

And I switch the current editor to editor "Lieferschein14" with command "REVERSAL"
And I save the current editor

# in Zeile 2 keine Behaelterbuchung, da der selbe Behaelter wie in Zeile 1, es wird kein weiterer KLT verwendet
Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Abgang" in row 1
Then field "bhbuchung^bhkto^such" has value "KNTKETTLER" in row 1
Then field "bhbuchung" is empty in row 2

Then Container from editor "Behaelter14" is empty


Scenario: 15 Storno EK Lieferschein mit mehreren Behaeltern und mehreren Artikeln

Given I create a Container "STORNO15_1_EK" for packaging material "KLT"
Given I create a Container "STORNO15_2_EK" for packaging material "KLT"
Given I create a Container "STORNO15_3_EK" for packaging material "KLT"

Given I open an editor "Lieferschein15" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER                 |
    | vom       | .                       |
    | ebeleg    | Storno Lieferschein 15  |
    | ueb       | ja                      |
And I delete all rows
And I append rows
    | artikel   | mge   | !dialogId                                     | !dialogAnswer | exbehnum              |
    | SATTEL    | 10    | Externe Behälternummer ist bereits vergeben. | nein          | !STORNO15_1_EK^nummer |
    | SATTEL    | 7     | Externe Behälternummer ist bereits vergeben. | nein          | !STORNO15_2_EK^nummer |
    | PEDALE    | 5     | Externe Behälternummer ist bereits vergeben. | nein          | !STORNO15_3_EK^nummer |
    | PEDALE    | 2     | Externe Behälternummer ist bereits vergeben. | nein          | !STORNO15_2_EK^nummer |
And I save the current editor

And I switch the current editor to editor "Lieferschein15" with command "REVERSAL"
And I save the current editor

Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Abgang" in row 1
Then field "bhbuchung^bhkto^such" has value "KNTKETTLER" in row 1
Then field "bhbuchung^mge" has value "1" in row 2
Then field "bhbuchung^buart" has value "Abgang" in row 2
Then field "bhbuchung^bhkto^such" has value "KNTKETTLER" in row 2
Then field "bhbuchung^mge" has value "1" in row 3
Then field "bhbuchung^buart" has value "Abgang" in row 3
Then field "bhbuchung^bhkto^such" has value "KNTKETTLER" in row 3
Then field "bhbuchung" is empty in row 4

Then Container from editor "STORNO15_1_EK" is empty
Then Container from editor "STORNO15_2_EK" is empty
Then Container from editor "STORNO15_3_EK" is empty


# keine Buchung auf Behaelterkonto, wenn der Behaelter in der Materialzuordnung eingetragen ist
# VERSAND-836 Behaelterkonten
Scenario: 16 Storno EK Lieferschein MZ mit einem Behaelter und einem Artikel

Given I create a Container "Behaelter16" for packaging material "KLT"

Given I open an editor "Lieferschein16" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER                 |
    | vom       | .                       |
    | ebeleg    | Storno Lieferschein 16  |
    | ueb       | ja                      |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | SATTEL    | 10    |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "!Behaelter16^nummer" in row 1
And I save the current editor
And I switch the current editor to editor "Lieferschein16"
And I save the current editor

And I switch the current editor to editor "Lieferschein16" with command "REVERSAL"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Abgang" in row 1
#Then field "bhbuchung^bhkto^such" has value "KNTKETTLER" in row 1

Then Container from editor "Behaelter16" is empty

# keine Buchung auf Behaelterkonto, wenn der Behaelter in der Materialzuordnung eingetragen ist
# VERSAND-836 Behaelterkonten
Scenario: 17 Storno EK Lieferschein MZ mit einem Behaelter und mehreren Artikeln

Given I create a Container "Behaelter17" for packaging material "KLT"

Given I open an editor "Lieferschein17" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER                 |
    | vom       | .                       |
    | ebeleg    | Storno Lieferschein 17  |
    | ueb       | ja                      |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | SATTEL    | 10    |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "!Behaelter17^nummer" in row 1
And I save the current editor
And I switch the current editor to editor "Lieferschein17"
And I append rows
    | artikel   | mge   |
    | PEDALE    | 10    |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "!Behaelter17^nummer" in row 1
And I save the current editor
And I switch the current editor to editor "Lieferschein17"
And I save the current editor

And I switch the current editor to editor "Lieferschein17" with command "REVERSAL"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Abgang" in row 1
#Then field "bhbuchung^bhkto^such" has value "KNTKETTLER" in row 1

Then Container from editor "Behaelter17" is empty

# keine Buchung auf Behaelterkonto, wenn der Behaelter in der Materialzuordnung eingetragen ist
# VERSAND-836 Behaelterkonten
Scenario: 18 Storno EK Lieferschein MZ mit mehreren Behaeltern und mehreren Artikeln

Given I create a Container "STORNO18_1_EK_MZ" for packaging material "KLT"
Given I create a Container "STORNO18_2_EK_MZ" for packaging material "KLT"
Given I create a Container "STORNO18_3_EK_MZ" for packaging material "KLT"

Given I open an editor "Lieferschein18" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER                 |
    | vom       | .                       |
    | ebeleg    | Storno Lieferschein 18  |
    | ueb       | ja                      |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | SATTEL    | 17    |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | zuomge    | !dialogId                                     | !dialogAnswer | exbehnum                    |
    | 1     | 10        | Externe Behälternummer ist bereits vergeben. | nein          | !STORNO18_1_EK_MZ^nummer    |
    | +2    |  7        | Externe Behälternummer ist bereits vergeben. | nein          | !STORNO18_2_EK_MZ^nummer    |
And I save the current editor
And I switch the current editor to editor "Lieferschein18"
And I append rows
    | artikel   | mge   |
    | PEDALE    | 7     |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I modify table
    | !row  | zuomge    | !dialogId                                     | !dialogAnswer | exbehnum                    |
    | 1     | 5         | Externe Behälternummer ist bereits vergeben. | nein          | !STORNO18_3_EK_MZ^nummer    |
    | +2    | 2         | Externe Behälternummer ist bereits vergeben. | nein          | !STORNO18_2_EK_MZ^nummer    |
And I save the current editor
And I switch the current editor to editor "Lieferschein18"
And I save the current editor

And I switch the current editor to editor "Lieferschein18" with command "REVERSAL"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Abgang" in row 1
#Then field "bhbuchung^bhkto^such" has value "KNTKETTLER" in row 1

Then Container from editor "STORNO18_1_EK_MZ" is empty
Then Container from editor "STORNO18_2_EK_MZ" is empty
Then Container from editor "STORNO18_3_EK_MZ" is empty


Scenario: 19 Storno EK Rechnung mit einem Behaelter und einem Artikel

Given I create a Container "Behaelter19" for packaging material "KLT"

Given I open an editor "Rechnung19" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER             |
    | vom       | .                   |
    | ebeleg    | Storno Rechnung 19  |
    | ueb       | ja                  |
And I delete all rows
And I append rows
    | artikel   | mge   | !dialogId                                     | !dialogAnswer | exbehnum              |
    | SATTEL    | 10    | Externe Behälternummer ist bereits vergeben. | nein          | !Behaelter19^nummer   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I switch the current editor to editor "Rechnung19" with command "REVERSAL"
And I save the current editor

Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Abgang" in row 1
Then field "bhbuchung^bhkto^such" has value "KNTKETTLER" in row 1

Then Container from editor "Behaelter19" is empty


Scenario: 20 Storno EK Rechnung mit einem Behaelter und mehreren Artikeln

Given I create a Container "Behaelter20" for packaging material "KLT"

Given I open an editor "Rechnung20" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER             |
    | vom       | .                   |
    | ebeleg    | Storno Rechnung 20  |
    | ueb       | ja                  |
And I delete all rows
And I append rows
    | artikel   | mge   | !dialogId                                     | !dialogAnswer | exbehnum              |
    | SATTEL    | 10    | Externe Behälternummer ist bereits vergeben. | nein          | !Behaelter20^nummer   |
    | PEDALE    | 10    | Externe Behälternummer ist bereits vergeben. | nein          | !Behaelter20^nummer   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I switch the current editor to editor "Rechnung20" with command "REVERSAL"
And I save the current editor

# keine Behaelterbuchung in Zeile 2, da der selbe Behaelter wie in Zeile 1
Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Abgang" in row 1
Then field "bhbuchung^bhkto^such" has value "KNTKETTLER" in row 1
Then field "bhbuchung" is empty in row 2

Then Container from editor "Behaelter20" is empty


Scenario: 21 Storno EK Rechnung mit mehreren Behaeltern und mehreren Artikeln

Given I create a Container "STORNO21_1_EKR" for packaging material "KLT"
Given I create a Container "STORNO21_2_EKR" for packaging material "KLT"
Given I create a Container "STORNO21_3_EKR" for packaging material "KLT"

Given I open an editor "Rechnung21" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER             |
    | vom       | .                   |
    | ebeleg    | Storno Rechnung 21  |
    | ueb       | ja                  |
And I delete all rows
And I append rows
    | artikel   | mge   | !dialogId                                     | !dialogAnswer | exbehnum                  |
    | SATTEL    | 10    | Externe Behälternummer ist bereits vergeben. | nein          | !STORNO21_1_EKR^nummer    |
    | SATTEL    |  7    | Externe Behälternummer ist bereits vergeben. | nein          | !STORNO21_2_EKR^nummer    |
    | PEDALE    |  5    | Externe Behälternummer ist bereits vergeben. | nein          | !STORNO21_3_EKR^nummer    |
    | PEDALE    |  2    | Externe Behälternummer ist bereits vergeben. | nein          | !STORNO21_2_EKR^nummer    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I switch the current editor to editor "Rechnung21" with command "REVERSAL"
And I save the current editor

# keine Behaelterbuchung in Zeile 4, da der selbe Behaelter wie in Zeile 2
Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Abgang" in row 1
Then field "bhbuchung^bhkto^such" has value "KNTKETTLER" in row 1
Then field "bhbuchung^mge" has value "1" in row 2
Then field "bhbuchung^buart" has value "Abgang" in row 2
Then field "bhbuchung^bhkto^such" has value "KNTKETTLER" in row 2
Then field "bhbuchung^mge" has value "1" in row 3
Then field "bhbuchung^buart" has value "Abgang" in row 3
Then field "bhbuchung^bhkto^such" has value "KNTKETTLER" in row 3
Then field "bhbuchung" is empty in row 4

Then Container from editor "STORNO21_1_EKR" is empty
Then Container from editor "STORNO21_2_EKR" is empty
Then Container from editor "STORNO21_3_EKR" is empty

# keine Buchung auf Behaelterkonto, wenn der Behaelter in der Materialzuordnung eingetragen ist
# VERSAND-836 Behaelterkonten
Scenario: 22 Storno EK Rechnung MZ mit einem Behaelter und einem Artikel

Given I create a Container "Behaelter22" for packaging material "KLT"

Given I open an editor "Rechnung22" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER             |
    | vom       | .                   |
    | ebeleg    | Storno Rechnung 22  |
    | ueb       | ja                  |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | SATTEL    | 10    |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "!Behaelter22^nummer" in row 1
And I save the current editor
And I switch the current editor to editor "Rechnung22"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I switch the current editor to editor "Rechnung22" with command "REVERSAL"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Abgang" in row 1
#Then field "bhbuchung^bhkto^such" has value "KNTKETTLER" in row 1

Then Container from editor "Behaelter22" is empty


# keine Buchung auf Behaelterkonto, wenn der Behaelter in der Materialzuordnung eingetragen ist
# VERSAND-836 Behaelterkonten
Scenario: 23 Storno EK Rechnung MZ mit einem Behaelter und mehreren Artikeln

Given I create a Container "Behaelter23" for packaging material "KLT"

Given I open an editor "Rechnung23" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER             |
    | vom       | .                   |
    | ebeleg    | Storno Rechnung 23  |
    | ueb       | ja                  |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | SATTEL    | 10    |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "!Behaelter23^nummer" in row 1
And I save the current editor
And I switch the current editor to editor "Rechnung23"
And I append rows
    | artikel   | mge   |
    | PEDALE    | 10    |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
And I set field "exbehnum" to "!Behaelter23^nummer" in row 1
And I save the current editor
And I switch the current editor to editor "Rechnung23"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I switch the current editor to editor "Rechnung23" with command "REVERSAL"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Abgang" in row 1
#Then field "bhbuchung^bhkto^such" has value "KNTKETTLER" in row 1

Then Container from editor "Behaelter23" is empty


# keine Buchung auf Behaelterkonto, wenn der Behaelter in der Materialzuordnung eingetragen ist
# VERSAND-836 Behaelterkonten
Scenario: 24 Storno EK Rechnug MZ mit mehreren Behaeltern und mehreren Artikeln

Given I create a Container "STORNO24_1_EKR_MZ" for packaging material "KLT"
Given I create a Container "STORNO24_2_EKR_MZ" for packaging material "KLT"
Given I create a Container "STORNO24_3_EKR_MZ" for packaging material "KLT"

Given I open an editor "Rechnung24" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER             |
    | vom       | .                   |
    | ebeleg    | Storno Rechnung 24  |
    | ueb       | ja                  |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | SATTEL    | 17    |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | zuomge    | !dialogId                                     | !dialogAnswer | exbehnum                  |
    | 1     | 10        | Externe Behälternummer ist bereits vergeben. | nein          | !STORNO24_1_EKR_MZ^nummer |
    | +2    | 7         | Externe Behälternummer ist bereits vergeben. | nein          | !STORNO24_2_EKR_MZ^nummer |
And I save the current editor
And I switch the current editor to editor "Rechnung24"
And I append rows
    | artikel   | mge   |
    | PEDALE    | 7     |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I modify table
    | !row  | zuomge    | !dialogId                                     | !dialogAnswer | exbehnum                  |
    | 1     | 5         | Externe Behälternummer ist bereits vergeben. | nein          | !STORNO24_3_EKR_MZ^nummer |
    | +2    | 2         | Externe Behälternummer ist bereits vergeben. | nein          | !STORNO24_2_EKR_MZ^nummer |
And I save the current editor
And I switch the current editor to editor "Rechnung24"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I switch the current editor to editor "Rechnung24" with command "REVERSAL"
And I save the current editor

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Abgang" in row 1
#Then field "bhbuchung^bhkto^such" has value "KNTKETTLER" in row 1

Then Container from editor "STORNO24_1_EKR_MZ" is empty
Then Container from editor "STORNO24_2_EKR_MZ" is empty
Then Container from editor "STORNO24_3_EKR_MZ" is empty


Scenario: 25 Gebindepflichtiger Artikel bei Storno eines EK-Lieferscheins

Given I create a Container "Behaelter25" for packaging material "KLT" and search word "GEBINDE_25"

Given I open an editor "Lieferschein25" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER                     |
    | vom       | .                           |
    | ebeleg    | Storno Lieferschein 25      |
    | ueb       | ja                          |
And I delete all rows
And I append rows
    | artikel   | mge   | he    | !dialogId                                     | !dialogAnswer | exbehnum              |
    | SCHUHE    | 10    | Paar  | Externe Behälternummer ist bereits vergeben. | nein          | !Behaelter25^nummer   |
And I save the current editor

And I switch the current editor to editor "Lieferschein25" with command "REVERSAL"
And I save the current editor

Then Container from editor "Behaelter25" is empty
