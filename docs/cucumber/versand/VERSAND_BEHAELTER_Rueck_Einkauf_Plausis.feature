# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Rueck_Einkauf_Plausis.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Ruecklieferungen im Einkauf mit Behaeltern
#  ref              : ref_behaelter_rueckliefern_cu
#
# *****************************************************************************
@persistent
Feature: VERSAND_BEHAELTER_Rueck_Einkauf_Plausis.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 00 Basislieferschein und -rechnung fuer Ruecklieferungen anlegen

Given I open an editor "EKLS_00p" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | EKLS_00p  |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | SATTEL    | 5     |
    | KLINGEL   | 5     |
And I save the current editor

Given I open an editor "EKRE_00p" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | EKRE_00p  |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | SATTEL    | 5     |
    | KLINGEL   | 5     |
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor


Scenario: 01 Ruecklieferschein nur gefuellten Behaelter eintragen, Meldung Der angegebene Behaelter ist leer

And I create a Container "behaelter_01ekp" for packaging material "KLT"

Given I open an editor "EKLS_01p" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "EKLS_00p"
And I set fields
    | ebeleg    | EKLS_01p  |
    | vom       | .         |
And I set field "mge" to "-1" in row 1
# Fehler 8343: Der angegebene Behaelter ist leer
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_01ekp" in row 0 throws the exception "8343"
And I close the current editor

Given I open an editor "EKRE_01p" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "EKRE_00p"
And I set fields
    | ebeleg    | EKRE_01p  |
    | vom       | .         |
And I set field "mge" to "-1" in row 1
# Fehler 8343: Der angegebene Behaelter ist leer
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_01ekp" in row 0 throws the exception "8343"
And I close the current editor


Scenario: 02 Ruecklieferung Artikel und Gebindeinformation der rueckgelieferten Position muss mit Behaelterinhalt uebereinstimmen

And I create a Container "behaelter_02ekp" for packaging material "KLT"

And I post a receipt via ManualStockAdjustment for Product "RAD" and quantity "5" on StorageLocation "F1" with document "L02-PZU" and Container "behaelter_02ekp"

Given I open an editor "EKLS_02p" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "EKLS_00p"
And I set fields
    | ebeleg    | EKLS_02p  |
    | vom       | .         |
And I set field "mge" to "-1" in row 1
# Fehler 8311: Der Artikel ist nicht mit den passenden Gebindeinformationen im Behaelter enthalten
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_02ekp" in row 0 throws the exception "8311"
And I close the current editor

Given I open an editor "EKRE_02p" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "EKRE_00p"
And I set fields
    | ebeleg    | EKRE_02p  |
    | vom       | .         |
And I set field "mge" to "-1" in row 1
# Fehler 8311: Der Artikel ist nicht mit den passenden Gebindeinformationen im Behaelter enthalten
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_02ekp" in row 0 throws the exception "8311"
And I close the current editor


Scenario: 03 Rueckgelieferte Menge muss mit der Menge im Behaelter uebereinstimmen

And I create a Container "behaelter_03ekp" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "KLINGEL" and quantity "7" on StorageLocation "F1" with document "L03-PZU" and Container "behaelter_03ekp"

Given I open an editor "EKLS_03p" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "EKLS_00p"
And I set fields
    | ebeleg    | EKLS_03p  |
    | vom       | .         |
    | ueb       | ja        |
And I set field "mge" to "-1" in row 2
And I set field "behaelter" in row 2 to "id" from editor "behaelter_03ekp" in row 0
# Fehler 8637: Es kann nur der gesamte Inhalt eines Behälters verschickt werden.
Then saving the current editor throws the exception "8367"
And I close the current editor

Given I open an editor "EKRE_03p" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "EKRE_00p"
And I set fields
    | ebeleg    | EKRE_03p  |
    | vom       | .         |
    | ueb       | ja        |
And I set field "mge" to "-1" in row 2
And I set field "behaelter" in row 2 to "id" from editor "behaelter_03ekp" in row 0
# And I respond with answer "JA" to the dialog with id "4841"
# Fehler 8637: Es kann nur der gesamte Inhalt eines Behälters verschickt werden.
Then saving the current editor throws the exception "8367"
And I close the current editor

