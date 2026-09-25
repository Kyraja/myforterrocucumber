@persistent
Feature: VERSAND_BEHAELTER_Lagerbuchungen_Plausis.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Lagerbuchungen_Plausis.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Plausis bei Lagerbuchungen mit Behaeltern
#  ref              : ref_behaelter_lbuch_cu
#  Stammdaten       : VERSAND_BEHAELTER_Stammdaten.feature
#
# *****************************************************************************

Background:
Given I set the fake date to "01.03.1995"


Scenario: 01 Ein Behaelter mit unterschiedlichen Artikeln kann nicht auf einen anderen Lagerplatz umgebucht werden

And I create a Container "behaelter_01p" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "PEDALE" and quantity "2" on StorageLocation "F1" with document "L01-PZU1" and Container "!behaelter_01p"
And I post a receipt via ManualStockAdjustment for Product "SATTEL" and quantity "2" on StorageLocation "F1" with document "L01-PZU2" and Container "!behaelter_01p"

Given I open an editor "Lagerbuchung01" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | SATTEL    |
    | buart   | Umbuchung |
    | beleg   | L01-PUM   |
    | beldat  | .         |
And I append rows
    | mge | platz | platz2 | behaelter      | behaelterzu       |
    | 1   | F1    | F2     | !behaelter_01p | !behaelter_01p    |
# Fehler 8313:Bei Umbuchung des gesamten Behaelters darf nur ein Artikel im Behaelter enthalten sein
Then saving the current editor throws the exception "8313"
And I close the current editor


Scenario: 02 Zu- und Abgangsinformationen muessen sich bei Umbuchung unterscheiden

Given I set the fake date to "02.03.1995"
And I create a Container "behaelter_02p" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "PEDALE" and quantity "2" on StorageLocation "F1" with document "L02-PZU" and Container "!behaelter_02p"

Given I open an editor "Lagerbuchung02" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | PEDALE    |
    | buart   | Umbuchung |
    | beleg   | L02-PUM   |
    | beldat  | .         |
And I append rows
    | mge | platz | platz2 | behaelter      | behaelterzu       |
    | 2   | F1    | F1     | !behaelter_02p | !behaelter_02p    |
# Fehler 7856: Umbuchen auf einem Platz nur mit Aenderung der Einheit, Charge, Verwendung oder des Projekts erlaubt
Then saving the current editor throws the exception "7856"
And I close the current editor


Scenario: 03 Behaelter benoetigt Informationen zu Abgangslagerplatz

Given I set the fake date to "03.03.1995"
And I create a Container "behaelter_03p" for packaging material "KLT"

Given I open an editor "Lagerbuchung03" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | PEDALE |
    | buart   | Zugang |
    | beleg   | L03-P  |
    | beldat  | .      |
And I append rows
    | mge | platz2 | behaelter      | behplatz |
    | 10  | F1     | !behaelter_03p |          |
# Fehler 7927: Lagerplatz des Behaelters darf nicht leer sein
Then saving the current editor throws the exception "7927"
And I close the current editor


Scenario: 04 Fuer einen gefuellten Behaelter kann im Zugang kein abweichender Zugangslagerplatz angegeben werden

Given I set the fake date to "04.03.1995"
And I create a Container "behaelter_04p" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "PEDALE" and quantity "2" on StorageLocation "F2" with document "L04-PZU1" and Container "!behaelter_04p"

Given I open an editor "Lagerbuchung04" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | PEDALE   |
    | buart   | Zugang   |
    | beleg   | L04-PZU2 |
    | beldat  | .        |
And I append rows
    | mge   | platz2    |
    | 10    | F1        |
# Fehler 10687: Behaelter hat Inhalt und Lagerplatz des Behaelters passt nicht zu Zugangslagerplatz
Then setting field "behaelter" to "!behaelter_04p" in row !lastRow throws the exception "10687"
And I close the current editor


Scenario: 05 Zugangslagerplatz fuer den Behaelter darf ueber mehrere Zeilen nicht abweichen

Given I set the fake date to "05.03.1995"
And I create a Container "behaelter_05p" for packaging material "KLT"

Given I open an editor "Lagerbuchung05" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | PEDALE |
    | buart   | Zugang |
    | beleg   | L05-P  |
    | beldat  | .      |
And I append rows
    | mge   | platz2    | behaelter         |
    | 11    | F1        | !behaelter_05p    |
    | 12    | F2        | !dontChange       |
# Fehler 10688: Behaelter wird bereits in anderer Zeile mit abweichendem Lagerplatz verwendet
Then setting field "behaelter" to "!behaelter_05p" in row !lastRow throws the exception "10688"
And I close the current editor


Scenario: 06 Umbuchung mit leerem Behaelter ist nicht moeglich

Given I set the fake date to "06.03.1995"
And I create a Container "behaelter_06p" for packaging material "KLT"

Given I open an editor "Lagerbuchung06" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | SATTEL    |
    | buart   | Umbuchung |
    | beleg   | L06-P     |
    | beldat  | .         |
And I append rows
    | mge   | platz |
    | 10    | F1    |
# Fehler 8343: Der angegebene Behaelter ist leer
Then setting field "behaelter" to "!behaelter_06p" in row !lastRow throws the exception "8343"
And I close the current editor


Scenario: 07 Keine Umbuchung moeglich, Behaelter nicht auf angegebenem Abgangslagerplatz liegt

Given I set the fake date to "07.03.1995"
And I create a Container "behaelter_07p" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "SATTEL" and quantity "2" on StorageLocation "F2" with document "L07-PZU1" and Container "!behaelter_07p"

Given I open an editor "Lagerbuchung07" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | SATTEL    |
    | buart   | Umbuchung |
    | beleg   | L07-PUM   |
    | beldat  | .         |
And I append rows
    | mge   | platz |
    | 10    | F1    |
# Fehler 8310: Der Lagerplatz des Behaelters passt nicht zum Abgangslagerplatz des Artikels
Then setting field "behaelter" to "!behaelter_07p" in row !lastRow throws the exception "8310"
And I close the current editor


Scenario: 08 Umbuchung nicht moeglich, wenn Artikel nicht mit passenden Gebindeinformationen im Behaelter liegt

Given I set the fake date to "08.03.1995"
And I create a Container "behaelter_08p" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "PEDALE" and quantity "2" on StorageLocation "F2" with document "L08-PZU1" and Container "!behaelter_08p"

Given I open an editor "Lagerbuchung08" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | SATTEL    |
    | buart   | Umbuchung |
    | beleg   | L08-PUM   |
    | beldat  | .         |
And I append rows
    | mge   | platz |
    | 10    | F2    |
# Fehler 8311: Der Artikel ist nicht mit den passenden Gebindeinformationen im Behaelter enthalten
Then setting field "behaelter" to "!behaelter_08p" in row !lastRow throws the exception "8311"
And I close the current editor


Scenario: 09 Artikel, der in verschiedenen Auspraegungen im Behaelter liegt, darf nicht umgebucht werden

Given I set the fake date to "09.03.1995"
And I create a Container "behaelter_09p" for packaging material "KLT"

Given I open an editor "Lagerbuchung09" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | PEDALE  |
    | buart   | Zugang  |
    | beleg   | L09-PZU |
    | beldat  | .       |
And I append rows
    | mge | platz2 | behaelter      | verw     |
    | 10  | F1     | !behaelter_09p | verw_091 |
    | 11  | F1     | !behaelter_09p | verw_092 |
And I save the current editor

Given I open an editor "Lagerbuchung09" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | PEDALE    |
    | buart   | Umbuchung |
    | beleg   | L09-PUM   |
    | beldat  | .         |
And I append rows
    | mge   | platz | platz2    | verw      | behaelter         | behaelterzu       |
    | 5     | F1    | F2        | verw_091  | !behaelter_09p    | !behaelter_09p    |
# Fehler 158: Der Artikel ist nicht oder nicht ausreichend mit passender Auspraegung im Behaelter
Then saving the current editor throws the exception "158"
And I close the current editor


Scenario: 10 Leere Behaelter koennen nicht abgebucht werden

Given I set the fake date to "10.03.1995"
And I create a Container "behaelter_10p" for packaging material "KLT"

Given I open an editor "Lagerbuchung10" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | PEDALE  |
    | buart   | Abgang  |
    | beleg   | L10-PAB |
    | beldat  | .       |
And I append rows
    | mge   | platz |
    | 5     | F1    |
# Fehler 8343: Der angegebene Behaelter ist leer
Then setting field "behaelter" to "!behaelter_10p" in row !lastRow throws the exception "8343"
And I close the current editor


Scenario: 11 Abgang kann nicht gebucht werden, wenn Behaelter nicht auf dem Abgangslagerplatz des Artikels liegt

Given I set the fake date to "11.03.1995"
And I create a Container "behaelter_11p" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "SATTEL" and quantity "2" on StorageLocation "F2" with document "L11-PZU" and Container "!behaelter_11p"

Given I open an editor "Lagerbuchung11" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | SATTEL  |
    | buart   | Abgang  |
    | beleg   | L11-PAB |
    | beldat  | .       |
And I append rows
    | mge   | platz |
    | 10    | F1    |
# Fehler 8310: Der Lagerplatz des Behaelters passt nicht zum Abgangslagerplatz des Artikels
Then setting field "behaelter" to "!behaelter_11p" in row !lastRow throws the exception "8310"
And I close the current editor


Scenario: 12 Abgangsbuchung nicht moeglich, wenn Artikel nicht mit passenden Gebindeinfos im Behaelter enthalten ist

Given I set the fake date to "12.03.1995"
And I create a Container "behaelter_12p" for packaging material "KLT"

Given I open an editor "Lagerbuchung12" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | PEDALE  |
    | buart   | Zugang  |
    | beleg   | L12-PZU |
    | beldat  | .       |
And I append rows
    | mge | platz2 | behaelter              | verw     |
    | 10  | F1     | !behaelter_12p^nummer  | verw_091 |
And I save the current editor

Given I open an editor "Lagerbuchung12" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | PEDALE  |
    | buart   | Abgang  |
    | beleg   | L09-PAB |
    | beldat  | .       |
And I append rows
    | mge | platz   | behaelter               | verw     |
    | 10  | F1      | !behaelter_12p^nummer   | verw_092 |
# Fehler 8311: Der Artikel ist nicht mit den passenden Gebindeinformationen im Behaelter enthalten
Then saving the current editor throws the exception "8311"
And I close the current editor


Scenario: 13 Abgangsbuchung nicht moeglich, wenn Artikel nicht mit der angegebenen Menge im Behaelter enthalten ist

Given I set the fake date to "13.03.1995"
And I create a Container "behaelter_13p" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "SATTEL" and quantity "2" on StorageLocation "F2" with document "L13-PZU" and Container "!behaelter_13p"

Given I open an editor "Lagerbuchung13" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | SATTEL  |
    | buart   | Abgang  |
    | beleg   | L13-PAB |
    | beldat  | .       |
And I append rows
    | mge   | platz | behaelter         |
    | 5     | F2    | !behaelter_13p    |
# Fehler 8312: Die Buchungsmenge ist groesser als die im Behaelter verpackte Menge
Then saving the current editor throws the exception "8312"
And I close the current editor
