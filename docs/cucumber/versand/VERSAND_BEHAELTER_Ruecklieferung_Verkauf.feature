# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Ruecklieferung_Verkauf.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Ruecklieferungen im Verkauf mit Behaeltern
#  ref              : ref_behaelter_rueckliefern_cu
#
# *****************************************************************************
@persistent
Feature: VERSAND_BEHAELTER_Ruecklieferung_Verkauf.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Ruecklieferung, ein Artikel, neuer Behaelter

Given I open an editor "VKLS_01" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde     | RADSHOP   |
    | such      | LS01      |
    | vom       | .         |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | RAHMEN    | 10    |
And I save the current editor

Given I open an editor "VKRLS_01" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "VKLS_01"
And I set fields
    | such      | RUECK01 |
    | vom       | .       |
    | ueb       | ja      |
And I modify table
    | !row  | mge   | exbehnum      | packm |
    | 1     | -3    | RUECK_EIN_B01 | KLT   |
And I save the current editor

# 7.3. Lisa, Behaelterkonto wird nicht bebucht, VERSAND-836
#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1

And I open an editor "behaelter01" from table "(Container):(ContainerShell)" with command "VIEW" for record "RUECK_EIN_B01"
Then field "kl^such" has value "RADSHOP"
Then the table has 1 rows
Then table has values
    | artikel   | mge   |
    | RAHMEN    | 3     |
And I close the current editor

Given I open an editor "VKRE_01" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde     | RADSHOP   |
    | such      | VKRE_01   |
    | vom       | .         |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | RAHMEN    | 5     |
And I save the current editor

Given I open an editor "VKRueck01" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "VKRE_01"
And I set fields
    | such      | VKRueck01 |
    | ueb       | ja        |
And I modify table
    | !row  | mge   | exbehnum         | packm  |
    | 1     | -3    | RUECK_EINART_V01 | KLT    |
And I save the current editor

# 7.3. Lisa, Behaelterkonto wird nicht bebucht, VERSAND-836
#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1

And I open an editor "behaelter" from table "(Container):(ContainerShell)" with command "VIEW" for record "RUECK_EINART_V01"
Then table has values
    | artikel | mge |
    | RAHMEN  | 3   |
And I close the current editor


Scenario: 02 Ruecklieferung zwei gleiche Artikel, bestehender Behaelter

And I create a Container "behaelter_02vk" for packaging material "KLT" and external container number "2BEH_VK"

Given I open an editor "VKLS_02" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde     | RADSHOP   |
    | such      | BEH_02    |
    | vom       | .         |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | RAHMEN    | 8     |
    | RAHMEN    | 5     |
And I save the current editor

Given I open an editor "VKRLS_02" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "VKLS_02"
And I set fields
    | such      | RUECK_02 |
    | vom       | .        |
    | ueb       | ja       |
And I modify table
    | !row  | mge   | !dialogId                                     | !dialogAnswer | exbehnum                 | packm |
    | 1     | -3    | Externe Behälternummer ist bereits vergeben. | ja            | !behaelter_02vk^exbehnum | KLT   |
    | 2     | -2    | Externe Behälternummer ist bereits vergeben. | ja            | !behaelter_02vk^exbehnum | KLT   |
And I save the current editor

# 7.3. Lisa, Behaelterkonto wird nicht bebucht, VERSAND-836
#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1
#Then field "bhbuchung^mge" has value "0" in row 2
#Then field "bhbuchung^buart" has value "" in row 2

And I switch the current editor to editor "behaelter_02vk"
Then the table has 0 rows
And I close the current editor

Given I open an editor "2beh_vk" from table "(Container):(ContainerShell)" with command "VIEW" for record "$,,nummer<>2BEH_VK;exbehnum/2BEH_VK"
Then field "behstatusaz" has value ""
Then table has values
    | artikel | mge |
    | RAHMEN  | 5   |
And I close the current editor


Scenario: 03a Ruecklieferung zwei unterschiedliche Artikel, bestehender Behaelter

And I create a Container "behaelter_03vk" for packaging material "KLT"

And I post a receipt via ManualStockAdjustment for Product "RAHMEN" and quantity "3" on StorageLocation "F1" with document "L03VKZU" and Container "behaelter_03vk"
And I post a receipt via ManualStockAdjustment for Product "SATTEL" and quantity "2" on StorageLocation "F1" with document "L03VKZU" and Container "behaelter_03vk"

Given I open an editor "VKLS_03" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde     | RADSHOP   |
    | such      | BEH_03    |
    | vom       | .         |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel | mge | behaelter          |
    | RAHMEN  | 3   | !behaelter_03vk^id |
    | SATTEL  | 2   | !behaelter_03vk^id |
And I save the current editor

# Behaelter aktivieren
And I switch the current editor to editor "behaelter_03vk" with command "UPDATE"
And I set field "behstatus" to ""
And I save the current editor

# Behaelter kann nun in Ruecklieferschein eingetragen und dieser gespeichert werden
Given I open an editor "VKRLS_032" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "VKLS_03"
And I set fields
    | such      | RUECK_03  |
    | vom       | .         |
    | ueb       | ja        |
And I modify table
    | !row  | mge | !dialogId                                     | !dialogAnswer | exbehnum               |
    | 1     | -3  | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_03vk^nummer |
    | 2     | -2  | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_03vk^nummer |   
And I save the current editor

# 7.3. Lisa, Behaelterkonto wird nicht bebucht, VERSAND-836
#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1
#Then field "bhbuchung^mge" has value "0" in row 2
#Then field "bhbuchung^buart" has value "" in row 2

And I switch the current editor to editor "behaelter_03vk"
Then the table has 2 rows
Then fields have values
    | behstatusaz   |       |
    | behleer       | nein  |
And I close the current editor

Scenario: 03b Ruecklieferung zwei unterschiedliche Artikel, bestehender Behaelter

And I create a Container "behaelter_03bvk" for packaging material "KLT"

And I post a receipt via ManualStockAdjustment for Product "RAHMEN" and quantity "3" on StorageLocation "F1" with document "L03VKZU" and Container "behaelter_03bvk"
And I post a receipt via ManualStockAdjustment for Product "SATTEL" and quantity "2" on StorageLocation "F1" with document "L03VKZU" and Container "behaelter_03bvk"

Given I open an editor "VKLS_03B" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde     | RADSHOP   |
    | such      | BEH_03B   |
    | vom       | .         |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel | mge | behaelter          |
    | RAHMEN  | 3   | !behaelter_03bvk^id |
    | SATTEL  | 2   | !behaelter_03bvk^id |
And I save the current editor

# Behaelter kann nun in Ruecklieferschein eingetragen und dieser gespeichert werden
Given I open an editor "VKRLS_032B" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "VKLS_03B"
And I set fields
    | such      | RUECK_03B |
    | vom       | .         |
    | ueb       | ja        |
And I modify table
    | !row  | mge | !dialogId                                     | !dialogAnswer | exbehnum               |
    | 1     | -3  | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_03bvk^nummer |
    | 2     | -2  | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_03bvk^nummer |   
And I save the current editor

# 7.3. Lisa, Behaelterkonto wird nicht bebucht, VERSAND-836
#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1
#Then field "bhbuchung^mge" has value "0" in row 2
#Then field "bhbuchung^buart" has value "" in row 2

And I switch the current editor to editor "behaelter_03bvk"
Then the table has 2 rows
Then fields have values
    | behstatusaz   |       |
    | behleer       | nein  |
And I close the current editor

Scenario: 04 Ruecklieferung ein Artikel mit Charge

And I create a Container "behaelter_04vk" for packaging material "KLT"
And I create a Lot "CH_VK_04" for Product "SATTEL"

# Verkaufslieferschein
Given I open an editor "VKLS_04" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde     | RADSHOP   |
    | such      | A_CH_11   |
    | vom       | .         |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel | mge | charge       |
    | SATTEL  | 8   | !CH_VK_04^id |
And I save the current editor

Given I open an editor "VKRLS_04" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "VKLS_04"
And I set fields
    | such      | RUECK_04  |
    | vom       | .         |
    | ueb       | ja        |
And I modify table
    | !row  | mge | charge         | !dialogId                                     | !dialogAnswer | exbehnum               |
    | 1     | -2  | !CH_VK_04^id   | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_04vk^nummer |
And I save the current editor

# 7.3. Lisa, Behaelterkonto wird nicht bebucht, VERSAND-836
#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1

And I switch the current editor to editor "behaelter_04vk"
Then table has values
    | artikel | mge | charge^such |
    | SATTEL  | 2   | CH_VK_04    |
And I close the current editor


Scenario: 05 Ruecklieferung mehrere Artikel mit und ohne Charge

And I create a Container "behaelter_05vk" for packaging material "KLT"
And I create a Lot "CH_VK_05" for Product "SATTEL"

Given I open an editor "VKLS_05" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde     | RADSHOP   |
    | such      | R_V_05    |
    | vom       | .         |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel | mge | charge      |
    | SATTEL  | 10  | CH_VK_05    |
    | SATTEL  |  5  | !dontChange |
    | RAD     |  3  | !dontChange |
And I save the current editor

Given I open an editor "VKRLS_05" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "VKLS_05"
And I set fields
    | such      | RUECK_05  |
    | vom       | .         |
    | ueb       | ja        |
And I modify table
    | !row | mge | charge      | !dialogId                                     | !dialogAnswer | exbehnum               |
    | 1    | -2  | CH_VK_05    | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_05vk^nummer |
    | 2    | -3  | !dontChange | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_05vk^nummer |
    | 3    | -1  | !dontChange | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_05vk^nummer |
And I save the current editor

# 7.3. Lisa, Behaelterkonto wird nicht bebucht, VERSAND-836
#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1
#Then field "bhbuchung^mge" has value "0" in row 2
#Then field "bhbuchung^buart" has value "" in row 2
#Then field "bhbuchung^mge" has value "0" in row 3
#Then field "bhbuchung^buart" has value "" in row 3

And I switch the current editor to editor "behaelter_05vk"
Then the table has 3 rows
Then table has values
    | !row  | artikel | mge | charge^such |
    | 3     | SATTEL  | 2   | CH_VK_05    |
And I close the current editor


Scenario: 06 Ruecklieferung zwei gleiche Artikel, bestehender Behaelter, Rechnung mL

And I create a Container "behaelter_06vk" for packaging material "KLT"

Given I open an editor "VKRE_06" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde     | RADSHOP   |
    | such      | VKRE_06   |
    | vom       | .         |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel | mge |
    | RAHMEN  | 5   |
    | RAHMEN  | 5   |
And I save the current editor

Given I open an editor "VKRueck06" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "VKRE_06"
And I set fields
    | such      | VRueck06  |
    | vom       | .         |
    | ueb       | ja        |
And I modify table
    | !row | mge | !dialogId                                     | !dialogAnswer | exbehnum               |
    | 1    | -3  | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_06vk^nummer |
    | 2    | -2  | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_06vk^nummer |
And I save the current editor

# 7.3. Lisa, Behaelterkonto wird nicht bebucht, VERSAND-836
#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1

And I switch the current editor to editor "behaelter_06vk"
Then field "kl" is empty
Then field "behstatusaz" is empty
Then table has values
    | artikel | mge |
    | RAHMEN  | 5   |
And I close the current editor


Scenario: 07 Ruecklieferung zwei unterschiedliche Artikel, bestehender Behaelter, Rechnung mL

And I create a Container "behaelter_07vk" for packaging material "KLT"

And I open an editor "VKRE_07" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde     | RADSHOP   |
    | such      | VKR_07    |
    | vom       | .         |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel | mge |
    | RAHMEN  | 5   |
    | SATTEL  | 5   |
And I save the current editor

And I open an editor "VKRueck07" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "VKRE_07"
And I set fields
    | such      | VRueck07  |
    | vom       | .         |
    | ueb       | ja        |
And I modify table
    | !row | mge | !dialogId                                     | !dialogAnswer | exbehnum               | 
    | 1    | -3  | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_07vk^nummer | 
    | 2    | -2  | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_07vk^nummer | 
And I save the current editor

# 7.3. Lisa, Behaelterkonto wird nicht bebucht, VERSAND-836
#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1

And I switch the current editor to editor "behaelter_07vk"
Then the table has 2 rows
Then field "kl" is empty
Then field "behstatusaz" is empty
Then table has values
    | artikel | mge |
    | RAHMEN  | 3   |
    | SATTEL  | 2   |
And I close the current editor


Scenario: 08 Ruecklieferung ein Artikel mit Charge, Rechnung mL

And I create a Container "behaelter_08vk" for packaging material "KLT"
And I create a Lot "CH_VK_08" for Product "SATTEL"

Given I open an editor "VKRE_08" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde     | RADSHOP   |
    | such      | VKRE_08   |
    | vom       | .         |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel | mge | charge        |
    | SATTEL  | 8   | !CH_VK_08^id  |
And I save the current editor

Given I open an editor "VKRueck08" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "VKRE_08"
And I set fields
    | such      | VRueck08  |
    | vom       | .         |
    | ueb       | ja        |
And I modify table
    | !row | mge | charge        | !dialogId                                     | !dialogAnswer | exbehnum               | 
    | 1    | -2  | !CH_VK_08^id  | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_08vk^nummer | 
And I save the current editor

# 7.3. Lisa, Behaelterkonto wird nicht bebucht, VERSAND-836
#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1

And I switch the current editor to editor "behaelter_08vk"
Then the table has 1 rows
Then field "charge^such" has value "CH_VK_08" in row 1
And I close the current editor


Scenario: 09 mehrere Artikel mit und ohne Charge

And I create a Container "behaelter_09vk" for packaging material "KLT" and external container number "9BEH_VK"
And I create a Lot "CH_VK_09" for Product "SATTEL"

Given I open an editor "VKRE_09" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde     | RADSHOP   |
    | such      | VKRE_09   |
    | vom       | .         |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel | mge | charge        |
    | SATTEL  | 5   | !CH_VK_09^id  |
    | SATTEL  | 5   |               |
    | RAD     | 5   |               |
And I save the current editor

Given I open an editor "VKRueck09" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "VKRE_09"
And I set fields
    | such      | VRueck09  |
    | vom       | .         |
    | ueb       | ja        |
And I modify table
    | !row | mge | charge        | !dialogId                                     | !dialogAnswer | exbehnum                 | packm     |
    | 1    | -2  | !CH_VK_09^id  | Externe Behälternummer ist bereits vergeben. | ja            | !behaelter_09vk^exbehnum | BEHAELTER |
    | 2    | -3  |               | Externe Behälternummer ist bereits vergeben. | ja            | !behaelter_09vk^exbehnum | BEHAELTER |
    | 3    | -1  |               | Externe Behälternummer ist bereits vergeben. | ja            | !behaelter_09vk^exbehnum | BEHAELTER |
And I save the current editor

And I switch the current editor to editor "behaelter_09vk"
Then the table has 0 rows
And I close the current editor

Given I open an editor "9beh_vk" from table "(Container):(ContainerShell)" with command "VIEW" for record "$,,nummer<>9BEH_VK;exbehnum/9BEH_VK"
Then field "behstatusaz" has value ""
Then table has values
    | artikel | mge |
    | RAD     | 2   |
    | SATTEL  | 3   |
    | SATTEL  | 2   |
Then field "charge^such" has value "CH_VK_09" in row 3
And I close the current editor

