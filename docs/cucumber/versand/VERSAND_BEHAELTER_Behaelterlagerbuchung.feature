@persistent
Feature: VERSAND_BEHAELTER_Behaelterlagerbuchung.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Behaelterlagerbuchung.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet die Behaelterlagerbuchungen
#  ref				: ref_behaelter_bbuchung_cu
#
# *****************************************************************************

Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Behaelter umbuchen

Given I create a Container "behaelter_01" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "10" on StorageLocation "F1" with document "L01" and Container "!behaelter_01"
And I post a receipt via ManualStockAdjustment for Product "EK2-BEDARF" and quantity "11" on StorageLocation "F1" with document "L01" and Container "!behaelter_01"

# Behaelter umbuchen, liegt mit gleichem Inhalt auf neuem PLatz
Given I open an editor "BBuchung01" for tip command "(ContainerAdjustment)" and arguments ""
And I set field "behaelter" to "!behaelter_01"
Then the table has 2 rows
And I set fields
  | zuplatz | F2    |
  | beleg   | BB01  |
  | beldat  | .     |
And I save the current editor

And I switch the current editor to editor "behaelter_01"
Then field "platz" has value "F2"
Then table has values
   | !row                     | artikel     | mge |
   | $,,artikel==EK2-BEDARF   | EK2-BEDARF  | 11  |
   | $,,artikel==EK1-BEDARF   | EK1-BEDARF  | 10  |
And I close the current editor

And I open the infosystem "LJ"
And I set fields
  | adatum  | .     |
  | beleg   | BB01  |
And I press start
Then table has values
   | !row | art         | buart  | nplatz | vplatz | zmge | amge | verweis^behaelter^id |
   | 1    | EK1-BEDARF  | Abgang |        | F1     |      | 10   | !behaelter_01^id     |
   | 2    | EK1-BEDARF  | Zugang | F2     |        | 10   |      | !behaelter_01^id     |
   | 3    | EK2-BEDARF  | Abgang |        | F1     |      | 11   | !behaelter_01^id     |
   | 4    | EK2-BEDARF  | Zugang | F2     |        | 11   |      | !behaelter_01^id     |
And I close the current editor


Scenario: 02 Behaelter umbuchen, wenn gebindepflichtige Einheit im Behaelter liegt

Given I create a Container "behaelter_02" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "EK-GEBINDEPFL" and quantity "10" on StorageLocation "F1" with document "L02" and Container "behaelter_02"

And I open an editor "behaelter_02" from table "(Container):(ContainerShell)" with command "VIEW" for record from editor "behaelter_02"
Then field "platz" has value "F1"
Then table has values
    | !row | artikel 		| mge | gebeinh | gebf |
    | 1    | EK-GEBINDEPFL  | 10  | Paar    | 2    |
And I close the current editor

Given I open the infosystem "BESTAND"
And I set field "artikel" to "EK-GEBINDEPFL"
And I set field "klplatz" to "F1"
And I set field "behaelter" to "JA"
And I press button "bstart"
Then table has values
    | tartikel 			| gebmge | geinheit | gebf 	| tbehaelter^id    |
    | EK-GEBINDEPFL   	| 10     | Paar     | 2		| !behaelter_02^id |
And I close the current editor

Given I open an editor "BBuchung_02" for tip command "(ContainerAdjustment)" and arguments ""
And I set field "behaelter" to id from editor "behaelter_02"
Then the table has 1 rows
And I set field "zuplatz" to "L2F1"
And I set field "beleg" to "BB02"
And I set field "beldat" to "."
And I save the current editor

And I open an editor "behaelter_02" from table "(Container):(ContainerShell)" with command "VIEW" for record from editor "behaelter_02"
Then field "platz" has value "L2F1"
Then table has values
    | !row | artikel 		| mge | gebeinh | gebf 	|
    | 1    | EK-GEBINDEPFL  | 10  | Paar    | 2	  	|
And I close the current editor

Given I open the infosystem "BESTAND"
And I set field "artikel" to "EK-GEBINDEPFL"
And I set field "klplatz" to "L2F1"
And I set field "behaelter" to "JA"
And I press button "bstart"
Then table has values
    | tartikel 			| gebmge | geinheit | gebf 	| tbehaelter^id    |
    | EK-GEBINDEPFL   	| 10     | Paar     | 2  	| !behaelter_02^id |
And I close the current editor

