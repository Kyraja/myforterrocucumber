@persistent
Feature: VERSAND_BEHAELTER_Lagerbuchungen.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Lagerbuchungen.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Lagerbuchungen mit Behaeltern
#  ref              : ref_behaelter_lbuch_cu
#  Stammdaten       : VERSAND_BEHAELTER_Stammdaten.feature
#
# *****************************************************************************

Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Artikel in einen Behaelter buchen

And I create a Container "behaelter01" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "PEDALE" and quantity "10" on StorageLocation "F1" with document "L01" and Container "!behaelter01"

And I open the infosystem "LJ"
And I set fields
    | adatum    | .             |
    | beleg     | L01           |
    | richtung  | rueckwaerts   |
And I press start
Then table has values
    | art     | buart  | nplatz | vplatz | zmge | amge | mei    | behaelter             | vorgang^id   |
    | KLT     | Abgang |        | F1     |      | 1    | Stück  | !behaelter01^nummer   | !LbuchL01^id |
    | PEDALE  | Zugang | F1     |        | 10   |      | Paar   | !behaelter01^nummer   | !LbuchL01^id |
And I close the current editor

And I switch the current editor to editor "behaelter01" with command "VIEW"
Then field "behstatusaz" has value ""
Then table has values
    | artikel | mge | gebeinh   |
    | PEDALE  | 20  | Stück     |
And I close the current editor


Scenario: 02 Artikel mit ze=Handelseinheit aus einem Behaelter herausbuchen

Given I set the fake date to "03.01.1995"
And I create a Container "behaelter02" for packaging material "KLT"

# Artikel miz ze=Paar in Behaelter buchen
Given I post a receipt via ManualStockAdjustment for Product "PEDALE" and quantity "5" on StorageLocation "F1" with document "lbuchung02" and Container "!behaelter02"
# Teilmenge des Artikel mit ze=Stück aus Behaelter herausbuchen
Given I open an editor "lbuchung02-2" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | PEDALE        |
    | buart     | Abgang        |
    | beleg     | lbuchung02    |
    | beldat    | .             |
And I append rows
    | mge   | ze    | behaelter     |
    | 2     | Stück | !behaelter02  |
And I save the current editor

And I switch the current editor to editor "behaelter02" with command "VIEW"
Then field "behstatusaz" has value ""
Then the table has 1 rows
Then field "mge" has value "8" in row 1
And I close the current editor

# Restliche Menge mit ze=Paar aus Behaelter buchen
Given I open an editor "lbuchung02-3" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | PEDALE        |
    | buart     | Abgang        |
    | beleg     | lbuchung02    |
    | beldat    | .             |
And I append rows
    | mge   | ze    | behaelter     |
    | 4     | Paar  | !behaelter02  |
And I save the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum    | .             |
    | beleg     | lbuchung02    |
    | richtung  | rueckwaerts   |
And I press start
Then table has values
    | art     | buart  | nplatz | vplatz | zmge | amge | mei    | behaelter             | vorgang^id            |
    | KLT     | Zugang | F1     |        | 1    |      | Stück  | !behaelter02^nummer   | !lbuchung02-3^id      |
    | PEDALE  | Abgang |        | F1     |      | 4    | Paar   | !behaelter02^nummer   | !lbuchung02-3^id      |
    | PEDALE  | Abgang |        | F1     |      | 2    | Stück  | !behaelter02^nummer   | !lbuchung02-2^id      |
    | KLT     | Abgang |        | F1     |      | 1    | Stück  | !behaelter02^nummer   | !Lbuchlbuchung02^id   |
    | PEDALE  | Zugang | F1     |        | 5    |      | Paar   | !behaelter02^nummer   | !Lbuchlbuchung02^id   |
And I close the current editor

Then Container from editor "behaelter02" is empty


Scenario: 03 Gebindepflichtigen Artikel in einen anderen Behaelter mit Zugangsverwendung umbuchen

Given I set the fake date to "04.01.1995"
And I create a Container "behaelter03-1" for packaging material "KLT"
And I create a Container "behaelter03-2" for packaging material "KLT"

# Artikel in Behaelter buchen, ohne Verwendung
Given I open an editor "Lagerbuchung03_zu" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | PEDALE        |
    | buart     | Zugang        |
    | beleg     | lbuchung03    |
    | beldat    | .             |
And I append rows
    | mge   | ze    | behaelter         |
    | 2     | Stück | !behaelter03-1    |
And I save the current editor

# Umbuchung Artikel in einen anderen Behaelter und mit Verwendung (Zugang)
Given I open an editor "Lagerbuchung03_um" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | PEDALE        |
    | buart     | Umbuchung     |
    | beleg     | lbuchung03    |
    | beldat    | .             |
And I append rows
    | mge | behaelter      | behaelterzu    | behabplatz | verw2          |
    | 2   | !behaelter03-1 | !behaelter03-2 | F1         | Verwendung_L03 |
And I respond with answer "ja" to the dialog with id "10520"
And I set field "platz" to "F1" in row 2
And I respond with answer "ja" to the dialog with id "10520"
And I set field "platz2" to "F2" in row 2
And I save the current editor

And I switch the current editor to editor "behaelter03-2" with command "VIEW"
Then fields have values
    | behstatusaz   |       |
    | platz         | F2    |
Then table has values
    | artikel | mge | gebeinh | verw           |
    | PEDALE  | 2   | Stück   | Verwendung_L03 |
And I close the current editor


Scenario: 04 Umbuchen Verwendung im Artikel im gleichen Behaelter

Given I set the fake date to "05.01.1995"
And I create a Container "behaelter04" for packaging material "KLT"
Given I open an editor "lbuchung-zu04" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | PEDALE        |
    | buart     | Zugang        |
    | beleg     | lbuchung04    |
    | beldat    | .             |
And I append rows
    | mge   | ze    | behaelter     | verw          |
    | 2     | Stück | !behaelter04  | lbuchung04    |
And I save the current editor

Given I open an editor "lbuchung-um04" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | PEDALE        |
    | buart     | Umbuchung     |
    | beleg     | lbuchung04    |
    | beldat    | .             |
And I append rows
    | mge   | ze    | platz | platz2 | behaelter     | behaelterzu   | verw          | verw2         |
    | 1     | Stück | F1    | F1     | !behaelter04  | !behaelter04  | lbuchung04    | umbuchung04   |
And I save the current editor

And I switch the current editor to editor "behaelter04" with command "VIEW"
Then table has values
    | artikel | mge | verw          |
    | PEDALE  | 1   | lbuchung04    |
    | PEDALE  | 1   | umbuchung04   |
And I close the current editor


Scenario: 05 Gesamten Inhalt eines Behaelters auf einen anderen Lagerplatz und Verwendung umbuchen

Given I set the fake date to "06.01.1995"
And I create a Container "behaelter05" for packaging material "KLT"
Given I open an editor "lbuchung-zu05" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | PEDALE        |
    | buart     | Zugang        |
    | beleg     | lbuchung05    |
    | beldat    | .             |
And I append rows
    | mge   | ze    | behaelter     | verw          |
    | 1     | Stück | !behaelter05  | lbuchung05    |
And I save the current editor

Given I open an editor "lbuchung-um05" for tip command "(Stockadjustment)" and arguments ""
    And I set fields
    | artikel   | PEDALE        |
    | buart     | Umbuchung     |
    | beleg     | lbuchung05    |
    | beldat    | .             |
And I append rows
    | mge   | ze    | platz | platz2 | behaelter     | behaelterzu   | verw          | verw2         |
    | 1     | Stück | F1    | F2     | !behaelter05  | !behaelter05  | lbuchung05    | umbuchung05   |
And I save the current editor

And I switch the current editor to editor "behaelter05" with command "VIEW"
Then field "platz" has value "F2"
Then table has values
    | artikel | mge | verw          |
    | PEDALE  | 1   | umbuchung05   |
And I close the current editor


Scenario: 06 Artikel ohne Verwendung uebr lbuchung mit Verwendung in einen Behaelter umbuchen

Given I set the fake date to "07.01.1995"
Given I post a receipt via ManualStockAdjustment for Product "PEDALE" and quantity "1" on StorageLocation "F1" with document "lbuchung06"
And I create a Container "behaelter06" for packaging material "KLT"
Given I open an editor "lbuchung06" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel  | PEDALE     |
    | buart    | Umbuchung  |
    | beleg    | lbuchung06 |
    | beldat   | .          |
And I modify table
    | !row | mge | ze       | platz | behaelterzu   | behabplatz | verw2       |
    | 1    | 2   | Stück    | F1    | !behaelter06  | F1         | lbuchung06  |
And I respond with answer "ja" to the dialog with id "10520"
And I set field "platz2" to "F1" in row 1
And I save the current editor

And I switch the current editor to editor "behaelter06" with command "VIEW"
Then fields have values
    | behstatusaz   |       |
    | platz         | F1    |
Then table has values
    | artikel | mge | gebeinh   | verw          |
    | PEDALE  | 2   | Stück     | lbuchung06    |
And I close the current editor


Scenario: 07 Teilmenge eines Artikels aus einem Behaelter mit mehreren Artikeln in einen leeren Behaelter umbuchen

Given I set the fake date to "08.01.1995"
And I create a Container "behaelter07-1" for packaging material "KLT"
And I create a Container "behaelter07-2" for packaging material "KLT"

And I post a receipt via ManualStockAdjustment for Product "SATTEL" and quantity "7" on StorageLocation "F1" with document "lbuchung071" and Container "!behaelter07-1"
And I post a receipt via ManualStockAdjustment for Product "RAD" and quantity "10" on StorageLocation "F1" with document "lbuchung072" and Container "!behaelter07-1"

Given I open an editor "Lagerbuchung07" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | SATTEL        |
    | buart     | Umbuchung     |
    | beleg     | lbuchung07    |
    | beldat    | .             |
And I append rows
    | mge | platz | platz2 | behaelter      | behaelterzu       |
    | 3   | F1    | F2     | !behaelter07-1 | !behaelter07-2    |
And I save the current editor

Given I switch the current editor to editor "behaelter07-1" with command "VIEW"
Then field "platz" has value "F1"
Then table has values
    | !row | artikel    | mge |
    | 1    | RAD        | 20  |
    | 2    | SATTEL     | 4   |
And I close the current editor

Given I switch the current editor to editor "behaelter07-2" with command "VIEW"
Then field "platz" has value "F2"
Then table has values
    | !row | artikel | mge |
    | 1    | SATTEL  | 3   |
And I close the current editor


Scenario: 08 Teilmenge eines Artikels aus einem Behaelter mit mehreren Artikeln in einen gefuellten Behaelter umbuchen

Given I set the fake date to "09.01.1995"
And I create a Container "behaelter08-1" for packaging material "KLT"
And I create a Container "behaelter08-2" for packaging material "KLT"

And I post a receipt via ManualStockAdjustment for Product "SATTEL" and quantity "7" on StorageLocation "F1" with document "lbuchung081" and Container "!behaelter08-1"
And I post a receipt via ManualStockAdjustment for Product "RAD" and quantity "10" on StorageLocation "F1" with document "lbuchung082" and Container "!behaelter08-1"
And I post a receipt via ManualStockAdjustment for Product "RAD" and quantity "10" on StorageLocation "F2" with document "lbuchung083" and Container "!behaelter08-2"

Given I open an editor "Lagerbuchung08" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | SATTEL        |
    | buart     | Umbuchung     |
    | beleg     | lbuchung08    |
    | beldat    | .             |
And I append rows
    | mge | platz | platz2 | behaelter      | behaelterzu       |
    | 3   | F1    | F2     | !behaelter08-1 | !behaelter08-2    |
And I save the current editor

Given I switch the current editor to editor "behaelter08-1" with command "VIEW"
Then field "platz" has value "F1"
Then table has values
    | !row | artikel    | mge |
    | 1    | RAD        | 20  |
    | 2    | SATTEL     | 4   |
And I close the current editor

Given I switch the current editor to editor "behaelter08-2" with command "VIEW"
Then field "platz" has value "F2"
Then table has values
    | !row | artikel    | mge |
    | 1    | RAD        | 20  |
    | 2    | SATTEL     | 3   |
And I close the current editor
