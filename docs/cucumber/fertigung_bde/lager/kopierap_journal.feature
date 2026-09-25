@persistent
Feature: kopierap_journal.feature

Background:
And I set the fake date to "03.02.1995"

# *****************************************************************************
#  Name           : kopierap_journal.feature
#  Autor          : bschiga
#  Verantwortlich : bschiga
#  Kontrolle      : ak
#  Funktion       : Testet KopierAP aus Lagerbuchungen ans Journal
#  ref            : ref_kopierap_journal_cu
# *****************************************************************************

Scenario: 01 Individuelles Feld aus manueller Lagerbuchung an Journal vererben

Given I open an editor "KopierAP" from table "(DataExport):(CallParameter)" with command "UPDATE" for record "MLBUCH2LJ"
And I append rows
    | zielvar       | aufrwtyp  | aufrwert      |
    | ytextauslagbu | Kopffeld  | ylbutextindiv |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel           | EINK          |
    | buart             | Zugang        |
    | beleg             | LBU_01        |
    | beldat            | .             |
    | wert              | 10.0000       |
    | ylbutextindiv     | mein Text     |
And I delete all rows
And I append rows
    | mge    | platz2   |
    | 11     | F1       |
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EINK;buarta==Zugang;platz==F1;mge==11"
Then fields have values
    | artikel       | EINK              |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | 11                |
    | buart         | 1                 |
    | buarta        | Zugang            |
    | ursache       | erfasst           |
    | detursache    | Manueller Zugang  |
    | ytextauslagbu | mein Text         |
And I close the current editor


Scenario: 02 Individuelles Feld aus Position des EK-Lieferscheins an LJ vererben

Given I open an editor "KopierAP" from table "(DataExport):(CallParameter)" with command "UPDATE" for record "EKLSPOS2LJ"
And I append rows
    | zielvar       | aufrwtyp      | aufrwert      |
    | ytextauslagbu | Tabellenfeld  | ypostextekls  |
And I save the current editor

Given I open an editor "EKLS" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | TEST     |
    | such   | LSEK_02  |
    | ebeleg | LSEK_02  |
    | vom    | .        |
    | ueb    | ja       |
And I append rows
    | artikel   | mge | ypostextekls                    |
    | EINK      | 15  | mein Text im EK Lieferschein    |
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EINK;buarta==Zugang;platz==F1;mge==15"
Then fields have values
    | artikel       | EINK                          |
    | platz         | F1                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 15                            |
    | buart         | 1                             |
    | buarta        | Zugang                        |
    | ursache       | Lieferschein                  |
    | detursache    | Lieferschein Einkauf          |
    | ytextauslagbu | mein Text im EK Lieferschein  |
And I close the current editor


Scenario: 03 Individuelles Feld aus Zeile der MZ an Journal vererben

Given I open an editor "KopierAP" from table "(DataExport):(CallParameter)" with command "UPDATE" for record "MZ2LJ"
And I append rows
    | zielvar       | aufrwtyp      | aufrwert      |
    | ytextauslagbu | Tabellenfeld  | ypostextmz    |
And I save the current editor

Given I open an editor "EKBE03" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief      | TEST      |
    | such      | EKBE03    |
    | vom       | .         |
And I append rows
    | artikel   | mge | einplan |
    | EINK      | 100 | ja      |
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge | ypostextmz                    |
    | 1     | F1     | 70     | mein Text aus Zeile 1 der MZ  |
    | +2    | F2     | 30     | neuer Text aus Zeile 2 der MZ |
And I save the current editor
And I switch the current editor to editor "EKBE03"
And I save the current editor

And I deliver the PurchaseOrder "EKBE03" with PackingSlip "EKLS03"

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EINK;buarta==Zugang;platz==F1;mge==70"
Then fields have values
    | artikel       | EINK                          |
    | platz         | F1                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 70                            |
    | buart         | 1                             |
    | buarta        | Zugang                        |
    | ursache       | Lieferschein                  |
    | detursache    | Lieferschein Einkauf          |
    | ytextauslagbu | mein Text aus Zeile 1 der MZ  |
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EINK;buarta==Zugang;platz==F2;mge==30"
Then fields have values
    | artikel       | EINK                          |
    | platz         | F2                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 30                            |
    | buart         | 1                             |
    | buarta        | Zugang                        |
    | ursache       | Lieferschein                  |
    | detursache    | Lieferschein Einkauf          |
    | ytextauslagbu | neuer Text aus Zeile 2 der MZ |
And I close the current editor


Scenario: 04 Individuelles Feld aus Kopf des VKLS an MZ und dann an Journal vererben

Given I open an editor "KopierAP" from table "(DataExport):(CallParameter)" with command "UPDATE" for record "VKLI2MZ"
And I append rows
    | zielvar       | zielwerttyp       | aufrwtyp  | aufrwert  |
    | ypostextmz    | Aktuelle Zeile    | Kopffeld  | ytextvkls |
And I save the current editor

Given I open an editor "VKAUF04" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde     | TEST      |
    | such      | VKAUF04   |
    | vom       | .         |
And I append rows
    | artikel   | mge | einplan |
    | EINK      | 20  | ja      |
And I save the current editor

# Lieferschein aus Auftrag und MZ anlegen
Given I open an editor "VKAUF04" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "VKAUF04"
And I set fields
    | such      | VKLS04                |
    | ytextvkls | Text aus Kopf VKLS    |
    | ueb       | ja                    |
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge |
    | 1     | F1     | 12     |
    | +2    | F2     |  8     |
And I save the current editor
And I switch the current editor to editor "VKAUF04"
And I save the current editor

Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EINK;buarta==Abgang;platz==F1;mge==12"
Then fields have values
    | artikel       | EINK                          |
    | platz         | F1                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 12                            |
    | buart         | 2                             |
    | buarta        | Abgang                        |
    | ursache       | Lieferschein                  |
    | detursache    | Lieferschein Verkauf          |
    | ytextauslagbu | Text aus Kopf VKLS            |
And I close the current editor

Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EINK;buarta==Abgang;platz==F2;mge==8"
Then fields have values
    | artikel       | EINK                          |
    | platz         | F2                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 8                             |
    | buart         | 2                             |
    | buarta        | Abgang                        |
    | ursache       | Lieferschein                  |
    | detursache    | Lieferschein Verkauf          |
    | ytextauslagbu | Text aus Kopf VKLS            |
And I close the current editor
