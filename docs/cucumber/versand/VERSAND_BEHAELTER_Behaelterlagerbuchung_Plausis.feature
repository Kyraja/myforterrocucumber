@persistent
Feature: VERSAND_BEHAELTER_Behaelterlagerbuchung_Plausis.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Behaelterlagerbuchung_Plausis.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Plausis bei Behaelterlagerbuchungen
#  ref              : ref_behaelter_bbuchung_cu
#
# *****************************************************************************

Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Felder in der Tabelle der Behaelterlagerbuchung sind schreibgeschuetzt

Given I create a Container "behaelter_felder" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "10" on StorageLocation "F1" with document "L01-P" and Container "behaelter_felder"

Given I open an editor "BBuchung1" for tip command "(ContainerAdjustment)" and arguments ""
And I set field "behaelter" to "!behaelter_felder"
Then the table has 1 rows
Then field "artikel" is not modifiable in row 1
Then field "mge" is not modifiable in row 1
Then field "gebf" is not modifiable in row 1
Then field "gebeinh" is not modifiable in row 1
Then field "charge" is not modifiable in row 1
Then field "verw" is not modifiable in row 1
Then field "projekt" is not modifiable in row 1
Then field "lffert" is not modifiable in row 1
And I close the current editor


Scenario: 02 Feld behaelter darf nicht leer sein

Given I create a Container "behaelter_leer" for packaging material "KLT"

# Behaelterlagerbuchung - Fehler 8343: Der angegebene Behaelter ist leer
Given I open an editor "BBuchung2" for tip command "(ContainerAdjustment)" and arguments ""
Then setting field "behaelter" in row 0 to "id" from editor "behaelter_leer" in row 0 throws the exception "8343"
And I close the current editor


Scenario: 03 Zugangslagerplatz darf nicht leer sein

Given I create a Container "behaelter_zplatz" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "10" on StorageLocation "F1" with document "L03-P" and Container "behaelter_zplatz"

# Behaelterlagerbuchung - Fehler 593: Zugangslagerplatz fehlt
Given I open an editor "BBuchung3" for tip command "(ContainerAdjustment)" and arguments ""
And I set fields
    | behaelter | !behaelter_zplatz |
    | buart     | Umbuchung         |
    | beleg     | BB03-P            |
    | beldat    | .                 |
Then saving the current editor throws the exception "593"
And I close the current editor


Scenario: 04 Zugangs- und Abgangslagerplatz duerfen nicht gleich sein

Given I create a Container "behaelter_gleich" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "10" on StorageLocation "F2" with document "L04-P" and Container "behaelter_gleich"

# Behaelterlagerbuchung - Fehler 8332: Zugangs- und Abgangslagerplatz duerfen nicht gleich sein
Given I open an editor "BBuchung4" for tip command "(ContainerAdjustment)" and arguments ""
And I set fields
    | behaelter | !behaelter_gleich |
    | buart     | Umbuchung         |
    | beleg     | BB04-P            |
    | beldat    | .                 |
    | zuplatz   | F2                |
Then saving the current editor throws the exception "8332"
And I close the current editor


Scenario: 05 Beleg darf nicht leer sein

Given I create a Container "behaelter_beleg" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "10" on StorageLocation "F1" with document "L05-P" and Container "behaelter_beleg"

# Behaelterlagerbuchung - Fehler 1107: Beleg und Belegdatum eintragen
Given I open an editor "BBuchung5" for tip command "(ContainerAdjustment)" and arguments ""
And I set fields
    | behaelter | !behaelter_beleg |
    | buart     | Umbuchung        |
    | beleg     |                  |
    | beldat    | .                |
    | zuplatz   | F4               |
Then saving the current editor throws the exception "1107"
And I close the current editor


Scenario: 06 Belegdatum darf nicht leer sein

Given I create a Container "behaelter_beldat" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "10" on StorageLocation "F1" with document "L06-P" and Container "behaelter_beldat"

# Behaelterlagerbuchung - Fehler 1107: Beleg und Belegdatum eintragen
Given I open an editor "BBuchung6" for tip command "(ContainerAdjustment)" and arguments ""
And I set fields
    | behaelter | !behaelter_beldat |
    | buart     | Umbuchung         |
    | beleg     | BB06-P            |
    | beldat    |                   |
    | zuplatz   | F4                |
Then saving the current editor throws the exception "1107"
And I close the current editor


Scenario: 07 Fehler bei neue Zeile einfuegen und Zeile loeschen

Given I create a Container "behaelter_loesch" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "10" on StorageLocation "F1" with document "L07-P" and Container "behaelter_loesch"

# Behaelterlagerbuchung - Fehler bei neue Zeile einfuegen
# Fehler 3794: Zeile kann nicht eingefuegt werden
Given I open an editor "BBuchung7a" for tip command "(ContainerAdjustment)" and arguments ""
And I set fields
    | behaelter | !behaelter_loesch |
Then the table has 1 rows
Then creating a new row at position 1 throws the exception "3794"
And I close the current editor

# Behaelterlagerbuchung - Fehler bei Zeile loeschen
# Fehler 3885: Zeile kann nicht geloescht werden
Given I open an editor "BBuchung7b" for tip command "(ContainerAdjustment)" and arguments ""
And I set fields
    | behaelter | !behaelter_loesch |
Then the table has 1 rows
Then deleting the row at position 1 throws the exception "3885"
And I close the current editor
