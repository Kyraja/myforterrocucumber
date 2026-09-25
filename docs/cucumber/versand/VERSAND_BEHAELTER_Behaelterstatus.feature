@persistent
Feature: VERSAND_BEHAELTER_Behaelterstatus.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Behaelterstatus.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Statusuebergaenge im Behaelter
#  ref              : ref_behaelter_eigenschaften_cu
#
# *****************************************************************************

Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Status Geliefert, Rueckgeliefert kann in neuem Behaelter nicht gesetzt werden

# Fehler 11071 de      |Dieser Status darf nicht manuell gesetzt werden.
Given I open an editor "behaelter01" from table "(Container):(ContainerShell)" with command "NEW" for record ""
Then setting field "behstatusaz" to "Geliefert" throws the exception "11071"
Then setting field "behstatusaz" to "Rücklieferung" throws the exception "11071"
And I close the current editor


Scenario: 02 Status Geliefert, Rueckgeliefert kann in leerem Behaelter nicht gesetzt werden

Given I create a Container "behaelter02" for packaging material "KLT"

# Fehler 11071 de      |Dieser Status darf nicht manuell gesetzt werden.
And I switch the current editor to editor "behaelter02" with command "UPDATE"
Then setting field "behstatusaz" to "Geliefert" throws the exception "11071"
Then setting field "behstatusaz" to "Rücklieferung" throws the exception "11071"
And I close the current editor


Scenario: 03 Status Geliefert, Rueckgeliefert kann in gefuelltem Behaelter nicht gesetzt werden

Given I create a Container "behaelter03" for packaging material "KLT"
Given I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "5" on StorageLocation "F1" with document "03" and Container "!behaelter03"

# Fehler 11071 de      |Dieser Status darf nicht manuell gesetzt werden.
And I switch the current editor to editor "behaelter03" with command "UPDATE"
Then setting field "behstatusaz" to "Geliefert" throws the exception "11071"
Then setting field "behstatusaz" to "Rücklieferung" throws the exception "11071"
And I close the current editor


Scenario: 04 Gelieferten Behaelter auf Status leer setzen, behleer=ja; Status Rueckgeliefert nicht setzbar

Given  I create a Container "behaelter04" for packaging material "KLT"
Given I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "10" on StorageLocation "F1" with document "04" and Container "!behaelter04"

Given I open an editor "Verkaufslieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
  | kunde   | KUNDE1  |
  | vom     | .       |
  | ueb     | ja      |
And I append rows
  | artikel     | mge   | behaelter     |
  | EK1-BEDARF  | 10    | !behaelter04  |
And I save the current editor

# Fehler 11071 de      |Dieser Status darf nicht manuell gesetzt werden.
And I switch the current editor to editor "behaelter04" with command "UPDATE"
Then setting field "behstatusaz" to "Rücklieferung" throws the exception "11071"
And I set field "behstatusaz" to ""
And I save the current editor
Then field "behstatusaz" is empty
Then field "behleer" has value "ja"


Scenario: 05 Rueckgelieferten Behaelter auf Status leer setzen, behleer=ja; Status Geliefert nicht setzbar

Given  I create a Container "behaelter05" for packaging material "KLT"

Given I open an editor "Einkaufslieferschein05" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
  | ebeleg    | EK-LS_05  |
  | lief      | LIEFER1   |
  | vom       | .         |
  | ueb       | ja        |
And I append rows
  | artikel     | mge   | !dialogId                                     | !dialogAnswer | exbehnum            |
  | EK1-BEDARF  | 20    | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter05^nummer |
And I save the current editor

Given I switch the current editor to editor "Einkaufslieferschein05" with command "RETURN"
And I set fields
  | ebeleg    | Rueck_05  |
  | vom       | .         |
  | ueb       | ja        |
And I modify table
  | !row  | mge   | behaelter     |
  | 1     | -20   | !behaelter05  |
And I save the current editor

# Fehler 11071 de      |Dieser Status darf nicht manuell gesetzt werden.
And I switch the current editor to editor "behaelter05" with command "UPDATE"
Then setting field "behstatusaz" to "Geliefert" throws the exception "11071"
And I set field "behstatusaz" to ""
And I save the current editor
Then field "behstatusaz" is empty
Then field "behleer" has value "ja"


Scenario: 06 Status Gesperrt kann bei leerem Behaelter gesetzt und entfernt werden; Fehlermeldung, wenn gefuellt

Given I open an editor "behaelter06" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set fields
  | such        | behaelter06 |
  | packm       | KLT         |
  | behstatusaz | Gesperrt    |
And I save the current editor
Then field "behleer" has value "nein"

And I switch the current editor to editor "behaelter06" with command "UPDATE"
And I set field "behstatusaz" to ""
And I save the current editor
Then field "behleer" has value "ja"
Then field "bhestatusaz" is empty

Given I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "10" on StorageLocation "F1" with document "06" and Container "!behaelter06"

# Fehler 11070 de      |Der Behälter muss leer sein.
And I switch the current editor to editor "behaelter06" with command "UPDATE"
Then setting field "behstatusaz" to "Gesperrt" throws the exception "11070"
And I close the current editor


Scenario: 07 Ehemals gesperrter Behaelter kann wieder verwendet werden

Given I open an editor "behaelter07" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set fields
  | such        | behaelter07 |
  | packm       | KLT         |
  | behstatusaz | Gesperrt    |
And I save the current editor

And I switch the current editor to editor "behaelter07" with command "UPDATE"
And I set field "behstatusaz" to ""
And I save the current editor

# EK-Lieferschein mit vormals gesperrtem Behaelter
Given I open an editor "einkaufslieferschein07" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
  | lief    | LIEFER1             |
  | vom     | .                   |
  | ebeleg  | EK-Lieferschein_07  |
  | ueb     | ja                  |
And I append rows
  | artikel     | mge   | !dialogId                                     | !dialogAnswer | exbehnum            |
  | EK1-BEDARF  | 10    | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter07^nummer |
And I save the current editor


Scenario: 08 Behaelter mit Status Geliefert, Rueckgeliefert, Gesperrt koennen nicht als Zugangsbehaelter angegeben werden

Given I create a Container "GELIEFERT" for packaging material "KLT"
Given I create a Container "RUECKLIEFERUNG" for packaging material "KLT"
Given I open an editor "GESPERRT" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set fields
  | such        | GESPERRT |
  | packm       | KLT      |
  | behstatusaz | Gesperrt |
And I save the current editor

# Lagerbuchungen fuer Behaelter GELIEFERT und VK-Lieferschein setzt Status "Geliefert"
Given I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "10" on StorageLocation "F1" with document "LB01" and Container "!GELIEFERT"

Given I open an editor "Verkaufslieferschein08" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
  | kunde   | KUNDE1    |
  | vom     | .         |
  | ueb     | ja        |
And I append rows
  | artikel     | mge   | behaelter   |
  | EK1-BEDARF  | 10    | !GELIEFERT  |
And I save the current editor

And I switch the current editor to editor "GELIEFERT"
Then field "behstatusaz" has value "Geliefert"
And I save the current editor

# EK-Lieferschein und EK-Ruecklieferung fuer Behaelter RUECKLIEFERUNG
Given I open an editor "Einkaufslieferschein08" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
  | lief    | LIEFER1           |
  | ebeleg  | EK-Lieferschein08 |
  | vom     | .                 |
  | ueb     | ja                |
And I append rows
  | artikel     | mge   | !dialogId                                     | !dialogAnswer | exbehnum               |
  | EK1-BEDARF  | 10    | Externe Behälternummer ist bereits vergeben. | nein          | !RUECKLIEFERUNG^nummer |
And I save the current editor

Given I switch the current editor to editor "Einkaufslieferschein08" with command "RETURN"
And I set fields
  | vom     | .                       |
  | ebeleg  | EK-Ruecklieferschein08  |
  | ueb     | ja                      |
And I modify table
  | !row  | mge   |
  | 1     | -10   |
And I set field "behaelter" to "nummer" from editor "RUECKLIEFERUNG" in row 1
And I save the current editor

And I switch the current editor to editor "RUECKLIEFERUNG"
Then field "behstatusaz" has value "Rücklieferung"
And I save the current editor

# Behaelter koennen nicht als Zugangsbehaelter angegeben werden
# EK-Lieferschein
# Fehler 8413 de      |Behälter ist außer Haus.
# 11072 de      |Der Behälter ist gesperrt.
Given I open an editor "einkaufslieferschein08_P" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
  | lief    | LIEFER1             |
  | ebeleg  | EK-Lieferschein08P  |
  | vom     | .                   |
  | ueb     | ja                  |
And I append rows
  | artikel     | mge   |
  | EK1-BEDARF  | 10    |
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
Then setting field "exbehnum" to "!GELIEFERT^nummer" in row 1 throws the exception "8413"
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
Then setting field "exbehnum" to "!RUECKLIEFERUNG^nummer" in row 1 throws the exception "8413"
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
Then setting field "exbehnum" to "!GESPERRT^nummer" in row 1 throws the exception "11072"
And I close the current editor

# EK-Rechnung
# Fehler 8413 de      |Behälter ist außer Haus.
# 11072 de      |Der Behälter ist gesperrt.
Given I open an editor "Rechnung mL08" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
  And I set fields
  | lief    | LIEFER1         |
  | ebeleg  | EK-Rechnung_08  |
  | vom     | .               |
  | ueb     | ja              |
And I append rows
  | artikel     | mge   |
  | EK1-BEDARF  | 10    |
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
Then setting field "exbehnum" to "!GELIEFERT^nummer" in row 1 throws the exception "8413"
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
Then setting field "exbehnum" to "!RUECKLIEFERUNG^nummer" in row 1 throws the exception "8413"
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
Then setting field "exbehnum" to "!GESPERRT^nummer" in row 1 throws the exception "11072"
And I close the current editor

# VK-Ruecklieferung aus Lieferschein
# Fehler 8413 de      |Behälter ist außer Haus.
# 11072 de      |Der Behälter ist gesperrt.
Given I open an editor "Verkaufslieferschein08" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
  | kunde   | KUNDE1    |
  | vom     | .         |
  | ueb     | ja        |
And I append rows
  | artikel     | mge   |
  | EK1-BEDARF  | 10    |
And I save the current editor

Given I switch the current editor to editor "Verkaufslieferschein08" with command "RETURN"
And I set field "vom" to "."
And I set field "mge" to "-10" in row 1
# And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
# Then setting field "exbehnum" to "!GELIEFERT^nummer" in row 1 throws the exception "8413"
# And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
# Then setting field "exbehnum" to "!RUECKLIEFERUNG^nummer" in row 1 throws the exception "8413"
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
Then setting field "exbehnum" to "!GESPERRT^nummer" in row 1 throws the exception "11072"
And I close the current editor

# VK-Ruecklieferung aus Rechnung
# Fehler 8413 de      |Behälter ist außer Haus.
# 11072 de      |Der Behälter ist gesperrt.
Given I open an editor "VKRechnung08" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
  | kunde   | KUNDE1  |
  | vom     | .       |
  | budat   | .       |
  | ueb     | ja      |
And I append rows
  | artikel    | mge   |
  | EK1-BEDARF | 20    |
And I save the current editor

Given I switch the current editor to editor "VKRechnung08" with command "RETURN"
And I set field "vom" to "."
And I set field "mge" to "-10" in row 1
# And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
# Then setting field "exbehnum" to "!GELIEFERT^nummer" in row 1 throws the exception "8413"
# And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
# Then setting field "exbehnum" to "!RUECKLIEFERUNG^nummer" in row 1 throws the exception "8413"
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
Then setting field "exbehnum" to "!GESPERRT^nummer" in row 1 throws the exception "11072"
And I close the current editor

