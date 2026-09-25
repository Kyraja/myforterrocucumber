@persistent
Feature: VERSAND_BEHAELTER_Einkaufsrechnung_mit_Lagerbewegung.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Einkaufsrechnung_mit_Lagerbewegung.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Einkaufsrechnungen mit Lagerbewegung und Behaeltern
#  ref              : ref_behaelter_einkauf_cu
#
# *****************************************************************************

Background:
Given I set the fake date to "02.01.1995"

Scenario: 01  Rechnung mL, ein Artikel, Artikelzeile

And I create a Container "behaelter_01" for packaging material "KLT" and external container number "1BEH_EK"

Given I open an editor "RechnungmL_01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | WKETTLER  |
    | vom       | .         |
    | ebeleg    | RE_01     |
    | budat     | .         |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   | !dialogId                                     | !dialogAnswer | exbehnum               | packm |
    | RAHMEN    | 30    | Externe Behälternummer ist bereits vergeben. | ja            | !behaelter_01^exbehnum | KLT   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "bhbuchung" has value "28" in row 1
And I close the current editor

Then Container from editor "behaelter_01" is empty

Given I open an editor "behaelter_01a" from table "(Container):(ContainerShell)" with command "VIEW" for record "$,,nummer<>1BEH_EK;exbehnum/1BEH_EK"
Then field "behstatusaz" is empty
Then table has values
    | artikel | mge | gebeinh |
    | RAHMEN  | 30  | kg      |
And I close the current editor


Scenario: 02 Rechnung mL, mehrere unterschiedliche Artikel, Artikelzeile, eine behnum

Given I open an editor "RechnungmL_02" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | ebeleg | RE_02   |
    | lief   | KETTLER |
    | vom    | .       |
    | ueb    | ja      |
    | budat  | .       |
And I delete all rows
And I append rows
    | artikel | mge | exbehnum          | packm |
    | RAD     | 1   | UNTERSCH_ART1_J48 | KLT   |
    | RAD     | 1   | UNTERSCH_ART1_J48 | KLT   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then table has values
    | bhbuchung^mge | bhbuchung^buart   | bhbuchung^bhkto^such  |
    | 1             | Zugang            | KNTKETTLER            |
 And I close the current editor   

And I open an editor "behaelter_02" from table "(Container):(ContainerShell)" with command "VIEW" for record "UNTERSCH_ART1_J48"
Then field "behstatusaz" is empty
Then field "kl^such" has value "KETTLER"
Then table has values
    | artikel | mge | gebeinh |
    | RAD     | 4   | Stück   |
And I close the current editor


Scenario: 03 Rechnung mL, mehrere unterschiedliche Artikel, Artikelzeile, mehrere behnum

Given I open an editor "RechnungmL_03" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | ebeleg | RE_03   |
    | lief   | KETTLER |
    | vom    | .       |
    | ueb    | ja      |
    | budat  | .       |
And I delete all rows
And I append rows
    | artikel | mge | exbehnum          | packm |
    | SATTEL  | 30  | MEHRERE_ART_J48_2 | KLT   |
    | RAHMEN  | 30  | MEHRERE_ART_J48_1 | KLT   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then table has values
    | bhbuchung^mge | bhbuchung^buart   | bhbuchung^bhkto^such  |
    | 1             | Zugang            | KNTKETTLER            |
    | 1             | Zugang            | KNTKETTLER            |
And I close the current editor

And I open an editor "behaelter_03a" from table "(Container):(ContainerShell)" with command "VIEW" for record "MEHRERE_ART_J48_1"
Then field "behstatusaz" is empty
Then field "kl^such" has value "KETTLER"
Then table has values
    | artikel | mge | gebeinh |
    | RAHMEN  | 30  | kg      |
And I close the current editor

And I open an editor "behaelter_03b" from table "(Container):(ContainerShell)" with command "VIEW" for record "MEHRERE_ART_J48_2"
Then field "behstatusaz" is empty
Then field "kl^such" has value "KETTLER"
Then table has values
    | artikel | mge | gebeinh |
    | SATTEL  | 30  | Stück  | 
And I close the current editor


Scenario: 04 Rechnung mL, ein Artikel, Artikelzeile, bestehende behnum

And I create a Container "behaelter_04" for packaging material "KLT"

Given I open an editor "RechnungmL_04" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | ebeleg | RE_04   |
    | lief   | KETTLER |
    | vom    | .       |
    | ueb    | ja      |
    | budat  | .       |
And I delete all rows
And I append rows
    | artikel | mge | !dialogId                                     | !dialogAnswer | exbehnum             |
    | RAD     | 5   | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_04^nummer |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "bhbuchung" has value "32" in row 1
And I close the current editor

And I switch the current editor to editor "behaelter_04" with command "VIEW"
Then field "behstatusaz" is empty
Then table has values
    | artikel | mge | gebeinh |
    | RAD     | 10  | Stück   |
And I close the current editor


Scenario: 05 Rechnung mL, mehrere gleiche Artikel, Artikelzeile, eine bestehende behnum

And I create a Container "behaelter_05" for packaging material "KLT"

Given I open an editor "RechnungmL_05" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | ebeleg | RE_05   |
    | lief   | KETTLER |
    | vom    | .       |
    | ueb    | ja      |
    | budat  | .       |
And I delete all rows
And I append rows
    | artikel | mge | !dialogId                                     | !dialogAnswer | exbehnum             |
    | SATTEL  | 30  | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_05^nummer |
    | SATTEL  | 10  | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_05^nummer |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "bhbuchung" has value "33" in row 1
And I close the current editor

And I switch the current editor to editor "behaelter_05" with command "VIEW"
Then field "behstatusaz" is empty
Then table has values
    | artikel | mge | gebeinh |
    | SATTEL  | 40  | Stück   |
And I close the current editor


Scenario: 06 Rechnung mL, mehrere unterschiedliche Artikel, Artikelzeile, eine bestehende behnum

And I create a Container "behaelter_06" for packaging material "KLT"

Given I open an editor "RechnungmL_06" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | ebeleg | RE_06   |
    | lief   | KETTLER |
    | vom    | .       |
    | ueb    | ja      |
    | budat  | .       |
And I delete all rows
And I append rows
    | artikel | mge | !dialogId                                     | !dialogAnswer | exbehnum             |
    | RAD     | 30  | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_06^nummer |
    | RAHMEN  | 30  | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_06^nummer |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "bhbuchung" has value "34" in row 1
And I close the current editor

And I switch the current editor to editor "behaelter_06" with command "VIEW"
Then field "behstatusaz" is empty
Then table has values
    | artikel | mge | gebeinh |
    | RAHMEN  | 30  | kg      |
    | RAD     | 60  | Stück   |
And I close the current editor


Scenario: 07 Rechnung mL, mehrere gleiche Artikel, Artikelzeile, mehrere bestehende behnum

And I create a Container "behaelter_07a" for packaging material "KLT"
And I create a Container "behaelter_07b" for packaging material "KLT"

Given I open an editor "RechnungmL_07" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | ebeleg | RE_07   |
    | lief   | KETTLER |
    | vom    | .       |
    | ueb    | ja      |
    | budat  | .       |
And I delete all rows
And I append rows
    | artikel | mge | !dialogId                                     | !dialogAnswer | exbehnum              |
    | SATTEL  | 30  | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_07b^nummer |
    | SATTEL  | 10  | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_07a^nummer |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "bhbuchung" has value "35" in row 1
Then field "bhbuchung" has value "36" in row 2
And I close the current editor

And I switch the current editor to editor "behaelter_07a" with command "VIEW"
Then field "behstatusaz" is empty
Then table has values
    | artikel | mge | gebeinh |
    | SATTEL  | 10  | Stück   |
And I close the current editor

And I switch the current editor to editor "behaelter_07b" with command "VIEW"
Then field "behstatusaz" is empty
Then table has values
    | artikel | mge | gebeinh |
    | SATTEL  | 30  | Stück   |
And I close the current editor


Scenario: 08 Rechnung mL, mehrere unterschiedliche Artikel, Artikelzeile, mehrere bestehende behnum

And I create a Container "behaelter_08a" for packaging material "KLT"
And I create a Container "behaelter_08b" for packaging material "KLT"

Given I open an editor "RechnungmL_08" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | ebeleg | RE_08   |
    | lief   | KETTLER |
    | vom    | .       |
    | ueb    | ja      |
    | budat  | .       |
And I delete all rows
And I append rows
    | artikel | mge | !dialogId                                     | !dialogAnswer | exbehnum              |
    | SATTEL  | 30  | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_08b^nummer |
    | RAHMEN  | 30  | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_08a^nummer |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "bhbuchung" has value "37" in row 1
Then field "bhbuchung" has value "38" in row 2
And I close the current editor

And I switch the current editor to editor "behaelter_08a" with command "VIEW"
Then field "behstatusaz" is empty
Then table has values
    | artikel | mge | gebeinh |
    | RAHMEN  | 30  | kg      |
And I close the current editor

And I switch the current editor to editor "behaelter_08b" with command "VIEW"
Then field "behstatusaz" is empty
Then table has values
    | artikel | mge | gebeinh |
    | SATTEL  | 30  | Stück   |
And I close the current editor


Scenario: 09 Rechnung mL, ein Artikel, Artikelzeile, Behnum mit Buchstabe

Given I open an editor "RechnungmL_09" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | ebeleg | RE_09   |
    | lief   | KETTLER |
    | vom    | .       |
    | ueb    | ja      |
    | budat  | .       |
And I delete all rows
And I append rows
    | artikel | mge | exbehnum           | packm |
    | RAHMEN  | 30  | BEH_NORMIERUNG_J48 | KLT   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then table has values
    | bhbuchung^mge | bhbuchung^buart   | bhbuchung^bhkto^such  |
    | 1             | Zugang            | KNTKETTLER            |
And I close the current editor

And I open an editor "behaelter_09" from table "(Container):(ContainerShell)" with command "VIEW" for record "BEH_NORMIERUNG_J48"
Then field "behstatusaz" is empty
Then field "kl^such" has value "KETTLER"
Then table has values
    | artikel | mge | gebeinh |
    | RAHMEN  | 30  | kg      |
And I close the current editor


Scenario: 10 Rechnung mL, mehrere gleiche Artikel, Artikelzeile, gleiche Behnum

Given I open an editor "RechnungmL_10" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | ebeleg | RE_10   |
    | lief   | KETTLER |
    | vom    | .       |
    | ueb    | ja      |
    | budat  | .       |
And I delete all rows
And I append rows
    | artikel | mge | exbehnum      | packm |
    | RAD     | 1   | GLEICHE_NR_10 | KLT   |
    | RAD     | 1   | GLEICHE_NR_10 | KLT   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "behaelter_10" from table "(Container):(ContainerShell)" with command "VIEW" for record "GLEICHE_NR_10"
Then field "behstatusaz" is empty
Then table has values
    | artikel | mge | gebeinh |
    | RAD     | 4   | Stück   |
And I close the current editor


Scenario: 11 Rechnung mL, mehrere versch. Artikel, Artikelzeile, gleiche Behnum

Given I open an editor "RechnungmL_11" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | ebeleg | RE_11   |
    | lief   | KETTLER |
    | vom    | .       |
    | ueb    | ja      |
    | budat  | .       |
And I delete all rows
And I append rows
    | artikel | mge | exbehnum     | packm |
    | RAHMEN  | 30  | VERSCH_BEH11 | KLT   |
    | SATTEL  | 30  | VERSCH_BEH11 | KLT   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then table has values
    | bhbuchung^mge | bhbuchung^buart   | bhbuchung^bhkto^such  |
    | 1             | Zugang            | KNTKETTLER            |
And I close the current editor

Given I open an editor "behaelter_11" from table "(Container):(ContainerShell)" with command "VIEW" for record "VERSCH_BEH11"
Then field "behstatusaz" is empty
Then table has values
    | artikel | mge | gebeinh |
    | RAHMEN  | 30  | kg      |
    | SATTEL  | 30  | Stück   |
And I close the current editor


Scenario: 12 Rechnung mL, mehrere gleiche Artikel, Artikelzeile, versch. Behnum (num. & alphanum.)

Given I open an editor "RechnungmL_12" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | ebeleg | RE_12   |
    | lief   | KETTLER |
    | vom    | .       |
    | ueb    | ja      |
    | budat  | .       |
And I delete all rows
And I append rows
    | artikel | mge | exbehnum          | packm |
    | RAD     | 2   | BEHANLEGEN12_J48  | KLT   |
    | RAD     | 2   | 12_BEHANLEGEN_J48 | KLT   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then table has values
    | bhbuchung^mge | bhbuchung^buart   | bhbuchung^bhkto^such  |
    | 1             | Zugang            | KNTKETTLER            |
    | 1             | Zugang            | KNTKETTLER            |
And I close the current editor

Given I open an editor "behaelter_12a" from table "(Container):(ContainerShell)" with command "VIEW" for record "12_BEHANLEGEN_J48"
Then field "nummer" has value "12_BEHANLEGEN_J48"
Then field "behstatusaz" is empty
Then table has values
    | artikel | mge | gebeinh |
    | RAD     | 4   | Stück   |
And I close the current editor

Given I open an editor "behaelter_12b" from table "(Container):(ContainerShell)" with command "VIEW" for record "BEHANLEGEN12_J48"
Then field "behstatusaz" is empty
Then field "exbehnum" has value "BEHANLEGEN12_J48"
Then field "kl^such" has value "KETTLER"
Then table has values
    | artikel | mge | gebeinh |
    | RAD     | 4   | Stück   |
And I close the current editor


Scenario: 13 Rechnung mL, mehrere versch. Artikel, Artikelzeile, versch. Behnum (num. & alphanum.)

Given I open an editor "RechnungmL_13" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | ebeleg | RE_13   |
    | lief   | KETTLER |
    | vom    | .       |
    | ueb    | ja      |
    | budat  | .       |
And I delete all rows
And I append rows
    | artikel | mge | exbehnum             | packm |
    | SATTEL  | 30  | VERSCH_BEHNUM13_J48  | KLT   |
    | RAHMEN  | 30  | 13_VERSCH_BEHNUM_J48 | KLT   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then table has values
    | bhbuchung^mge | bhbuchung^buart   | bhbuchung^bhkto^such  |
    | 1             | Zugang            | KNTKETTLER            |
    | 1             | Zugang            | KNTKETTLER            |
And I close the current editor

Given I open an editor "behaelter_13a" from table "(Container):(ContainerShell)" with command "VIEW" for record "13_VERSCH_BEHNUM_J48"
Then field "nummer" has value "13_VERSCH_BEHNUM_J48"
Then field "behstatusaz" is empty
Then table has values
    | artikel | mge | gebeinh |
    | RAHMEN  | 30  | kg      |
And I close the current editor

Given I open an editor "behaelter_13b" from table "(Container):(ContainerShell)" with command "VIEW" for record "VERSCH_BEHNUM13_J48"
Then field "behstatusaz" is empty
Then field "exbehnum" has value "VERSCH_BEHNUM13_J48"
Then field "kl^such" has value "KETTLER"
Then table has values
    | artikel | mge | gebeinh |
    | SATTEL  | 30  | Stück   |
And I close the current editor

