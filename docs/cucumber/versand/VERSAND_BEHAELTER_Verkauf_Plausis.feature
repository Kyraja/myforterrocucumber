# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Verkauf_Plausis.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Plausis im Verkauf mit Behaeltern
#  ref              : ref_behaelter_verkauf_cu
#  Stammdaten       : VERSAND_BEHAELTER_Stammdaten.feature
#
# *****************************************************************************
@persistent
Feature: VERSAND_BEHAELTER_Verkauf_Plausis.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 leerer Behaelter in VK Lieferschein oder Rechnung bringt Fehlermeldung

And I create a Container "behaelter_01p" for packaging material "KLT"

Given I open an editor "VKLS_01p" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde | RADSHOP   |
    | such  | LS01_P    |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | RAHMEN    | 1     |
# Fehler 8343: Der angegebene Behaelter ist leer
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_01p" in row 0 throws the exception "8343"
And I close the current editor

Given I open an editor "RML01b_p" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde | RADSHOP   |
    | such  | RE01B_P   |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | SATTEL    | 1     |
# Fehler 8343: Der angegebene Behaelter ist leer
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_01p" in row 0 throws the exception "8343"
And I close the current editor


Scenario: 02 Artikel in der VK Lieferschein- oder Rechnungsposition muss im Behaelter enthalten sein

# Behaelter anlegen und fuellen
And I create a Container "behaelter_02p" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "PEDALE" and quantity "5" on StorageLocation "F1" with document "L02-PZU" and Container "behaelter_02p"

Given I open an editor "VKLS_02p" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde | RADSHOP   |
    | such  | LS02_P    |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | RAHMEN    | 1     |
# Fehler 8311: Der Artikel ist nicht mit den passenden Gebindeinformationen im Behaelter enthalten
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_02p" in row 0 throws the exception "8311"
And I close the current editor

Given I open an editor "RML02b_p" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde | RADSHOP   |
    | such  | RE02B_P   |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | SATTEL    | 1     |
# Fehler 8311: Der Artikel ist nicht mit den passenden Gebindeinformationen im Behaelter enthalten
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_02p" in row 0 throws the exception "8311"
And I close the current editor


Scenario: 03 Lieferschein bzw. Rechnung mit Lagerbewegung kopieren. behnum, exbehnum und packm werden in Artikelzeile geleert
# Behaelter anlegen und befuellen
And I create a Container "behaelter_03p-1" for packaging material "KLT"
And I create a Container "behaelter_03p-2" for packaging material "KLT"

And I post a receipt via ManualStockAdjustment for Product "RAHMEN" and quantity "1" on StorageLocation "F1" with document "L03-PZU" and Container "behaelter_03p-1"
And I post a receipt via ManualStockAdjustment for Product "SATTEL" and quantity "1" on StorageLocation "F1" with document "L03-PZU" and Container "behaelter_03p-2"

# Verkaufslieferschein erstellen mit Behaelter
Given I open an editor "VKLS_03p" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde | RADSHOP   |
    | such  | LS03_P    |
    | ueb   | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   | behaelter             |
    | RAHMEN    | 1     | !behaelter_03p-1^id   |
And I save the current editor

# im kopierten Verkaufslieferschein pruefen, dass die "Behaelter-Felder" geleert wurden
And I switch the current editor to editor "VKLS_03p" with command "COPY"
Then field "behaelter" is empty in row 1
Then field "exbehnum" is empty in row 1
Then field "packm" is empty in row 1
And I close the current editor

# Rechnung mit Lagerbewegung erstellen mit Behaelter
Given I open an editor "RML03b_p" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde | RADSHOP   |
    | such  | RE03B_P   |
    | ueb   | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   | behaelter             |
    | SATTEL    | 1     | !behaelter_03p-2^id   |
And I save the current editor

# in der kopierten Rechnung pruefen, dass die "Behaelter-Felder" geleert wurden
And I switch the current editor to editor "RML03b_p" with command "COPY"
Then field "behaelter" is empty in row 1
Then field "exbehnum" is empty in row 1
Then field "packm" is empty in row 1
And I close the current editor


Scenario: 04 Behaelterfelder sind nur in Rechnung mit Lagerbewegung aenderbar, bei Aenderung des Feldes "fakt" werden die Felder geleert
# Behaelter anlegen und befuellen
And I create a Container "behaelter_04p" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "RAHMEN" and quantity "30" on StorageLocation "F1" with document "L04-PZU" and Container "behaelter_04p"

Given I open an editor "RML04_p" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde | RADSHOP   |
    | such  | RE04_P    |
    | budat | .         |
    | fakt  | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   | behaelter         |
    | RAHMEN    | 30    | !behaelter_04p^id |
# Lagerbewegung deaktivieren
And I set field "fakt" to "nein"
# Felder werden geleert und sind nicht mehr aenderbar
Then field "behaelter" is empty in row 1
Then field "packm" is empty in row 1
Then field "behaelter" is not modifiable in row 1
Then field "packm" is not modifiable in row 1
And I close the current editor


Scenario: 05 In Packmittelzeilen ist das Behaelterfeld schreibgeschuetzt, manuell oder ueber Packanweisung
# Behaelter anlegen und befuellen
And I create a Container "behaelter_05p" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "RAD" and quantity "2" on StorageLocation "F1" with document "L05-PZU" and Container "behaelter_05p"

# Verkaufslieferschein - manuelle Packmittelzeile
Given I open an editor "VKLS_05_1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I delete all rows
And I append rows
    | artikel   | mge   | behaelter         |
    | RAD       | 2     | !behaelter_05p^id |
And I press button "pmneu" in row 1
And I modify table
    | !row      | artikel   | mge   |
    | +2        | KLT       | 1     |
Then field "behaelter^id" in row 1 has value equal to field "id" from editor "behaelter_05p" in row 0
Then field "behaelter" is not modifiable in row 2
And I close the current editor

# Verkaufslieferschein - berechnete Packmittelzeile
Given I open an editor "VKLS_05_2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I delete all rows
And I append rows
    | artikel   | mge   | behaelter         |
    | RAD       | 2     | !behaelter_05p^id |
And I press button "packvor"
Then field "behaelter^id" in row 1 has value equal to field "id" from editor "behaelter_05p" in row 0
Then field "behaelter" is not modifiable in row 2
And I close the current editor


Scenario: 06 Artikel ist nicht mit passenden Gebindeinformationen im Behaelter

And I create a Container "behaelter_06p" for packaging material "KLT"
And I create a Lot "CH_VK_06" for Product "SATTEL"

# Zugang mit Charge in Behaelter buchen
Given I open an editor "Lagerbuchung_06" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | SATTEL    |
    | buart     | Zugang    |
    | beleg     | L06ZU     |
    | beldat    | .         |
And I delete all rows
And I append rows
    | mge   | behaelter         | charge2       |
    | 5     | !behaelter_06p^id | !CH_VK_06^id  |
And I save the current editor

# Verkaufslieferschein ohne Charge erfassen
Given I open an editor "VKLS_06" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde | RADSHOP   |
    | such  | BEH_CH_06 |
    | vom   | .         |
    | ueb   | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   | behaelter         |
    | SATTEL    | 5     | !behaelter_06p^id |
# Fehler 158: Der Artikel ist nicht oder nicht ausreichend mit passender Auspraegung im Behaelter
Then saving the current editor throws the exception "158"
And I close the current editor

# Rechnung mL ohne Charge erfassen
Given I open an editor "VKRE_06" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde | RADSHOP   |
    | such  | VKRE_06   |
    | vom   | .         |
    | ueb   | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   | behaelter         |
    | SATTEL    | 5     | !behaelter_06p^id |
# Fehler 158: Der Artikel ist nicht oder nicht ausreichend mit passender Auspraegung im Behaelter
Then saving the current editor throws the exception "158"
And I close the current editor


Scenario: 07 mehrere Artikel mit und ohne Charge in einem Behaelter, Pruefung der Gebindeinformationen
# Gebindeinformationen des Behaelterbestand muessen mit Auspraegungen in der Lieferscheinposition oder Rechnungsposition uebereinstimmen

And I create a Container "behaelter_07p" for packaging material "KLT"
And I create a Lot "CH_VK_07" for Product "SATTEL"

# Einkaufslieferschein Artikel mit und ohne Charge in gleichen Behaelter buchen
Given I open an editor "EKLS_07" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER   |
    | ebeleg | EKLS 07   |
    | vom    | .         |
    | ueb    | ja        |
And I delete all rows
And I append rows
    | artikel | mge | !dialogId                                     | !dialogAnswer | exbehnum              | charge       |
    | SATTEL  | 2   | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_07p^nummer | !CH_VK_07^id |
    | SATTEL  | 5   | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_07p^nummer |              |
    | RAD     | 1   | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_07p^nummer |              |
And I save the current editor

# Verkaufslieferschein Artikelpositionen ohne Charge erfassen
Given I open an editor "VKLS_07" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde | RADSHOP   |
    | vom   | .         |
    | ueb   | ja        |
And I delete all rows
And I append rows
    | artikel | mge | behaelter         |
    | SATTEL  | 2   | !behaelter_07p^id |
    | SATTEL  | 5   | !behaelter_07p^id |
    | RAD     | 1   | !behaelter_07p^id |
# Fehler 158: Der Artikel ist nicht oder nicht ausreichend mit passender Auspraegung im Behaelter
Then saving the current editor throws the exception "158"
And I close the current editor

# Rechnung mL Artikelpositionen ohne Charge erfassen
Given I open an editor "VKRE_07" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde | RADSHOP   |
    | such  | VKRE_07   |
    | vom   | .         |
    | ueb   | ja        |
And I delete all rows
And I append rows
    | artikel | mge | behaelter         |
    | SATTEL  | 2   | !behaelter_07p^id |
    | SATTEL  | 5   | !behaelter_07p^id |
    | RAD     | 1   | !behaelter_07p^id |
# Fehler 158: Der Artikel ist nicht oder nicht ausreichend mit passender Auspraegung im Behaelter
Then saving the current editor throws the exception "158"
And I close the current editor


Scenario: 08 Packanweisung im Lieferschein wird nicht geleert, wenn Behaelter eingetragen wird
# Behaelter anlegen und befuellen
And I create a Container "behaelter_08p" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "RAD" and quantity "2" on StorageLocation "F1" with document "L08-PZU" and Container "behaelter_08p"

# Verkaufslieferschein - in Position erst Packanweisung dann Behaelter eintragen
Given I open an editor "VKLS_08" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde | RADSHOP   |
    | vom   | .         |
    | ueb   | ja        |
And I delete all rows
And I append rows
    | artikel | mge | packanw   | behaelter         |
    | RAD     | 2   | PACKA1    | !behaelter_08p^id |
Then field "packanw^such" has value "PACKA1" in row 1
And I close the current editor


Scenario: 09 Es kann nur der gesamte Inhalt eines Behaelters verschickt werden

# Behaelter anlegen und fuellen
And I create a Container "behaelter_09p" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "PEDALE" and quantity "6" on StorageLocation "F1" with document "L02-PZU" and Container "behaelter_09p"
And I post a receipt via ManualStockAdjustment for Product "SATTEL" and quantity "3" on StorageLocation "F1" with document "L02-PZU" and Container "behaelter_09p"

Given I open an editor "VKLS_09p" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde | RADSHOP   |
    | such  | LS09_P    |
    | ueb   | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   | behaelter         |
    | PEDALE    | 6     | !behaelter_09p^id |
# Fehler 8367: Es kann nur der gesamte Inhalt eines Behaelters verschickt werden.
Then saving the current editor throws the exception "8367"
And I close the current editor
