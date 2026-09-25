# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Storno_Verkauf.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Storno im Verkauf mit Behaeltern
#  ref              : ref_behaelter_evstorno_cu
#  Stammdaten       : VERSAND_BEHAELTER_Stammdaten.feature
#
# *****************************************************************************
@persistent
Feature: VERSAND_BEHAELTER_Storno_Verkauf.feature
Background:
Given I set the fake date to "02.01.1995"

###############################################################################
# Scenarien 13-25 in VERSAND_BEHAELTER_Storno_Verkauf.feature

Scenario: 01 Storno VK Lieferschein mit einem Behaelter und einem Artikel

Given I create a Container "Behaelter01" for packaging material "KLT"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | FAHRRAD   |
    | buart     | Zugang    |
    | beleg     | 06        |
    | beldat    | .         |
And I delete all rows
And I append rows
    | mge       | behaelter         |
    | 10        | !Behaelter01^id   |
And I save the current editor

Given I open an editor "Lieferschein01" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde     | WRADSHOP  |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   | behaelter         |
    | FAHRRAD   | 10    | !Behaelter01^id   |
And I save the current editor

And I reverse the PackingSlip "Lieferschein01"

Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Zugang" in row 1
Then field "bhbuchung^bhkto^such" has value "KNTRADSHOP" in row 1

And I switch the current editor to editor "Behaelter01" with command "VIEW"
Then fields have values
    | behstatusaz   |       |
    | behleer       | nein  |
Then the table has 1 rows
Then table has values
    | artikel | mge |
    | FAHRRAD | 10  |
And I close the current editor


Scenario: 02 Storno VK Lieferschein mit einem Behaelter und mehreren Artikeln

Given I create a Container "Behaelter02" for packaging material "KLT"

Scenario Outline: 02
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | <artikel> |
    | buart     | Zugang    |
    | beleg     | 06        |
    | beldat    | .         |
And I delete all rows
And I append rows
    | mge       | behaelter         |
    | <mge>     | !Behaelter02^id   |
And I save the current editor

Examples:
    | artikel | mge |
    | FAHRRAD | 10  |
    | PEDALE  | 5   |

Scenario: 02
Given I open an editor "Lieferschein02" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde   | WRADSHOP |
    | ueb     | ja       |
And I delete all rows
And I append rows
    | artikel   | mge   | behaelter         |
    | FAHRRAD   | 10    | !Behaelter02^id   |
    | PEDALE    | 5     | !Behaelter02^id   |
And I save the current editor

And I reverse the PackingSlip "Lieferschein02"

Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Zugang" in row 1
Then field "bhbuchung^bhkto^such" has value "KNTRADSHOP" in row 1

And I switch the current editor to editor "Behaelter02" with command "VIEW"
Then fields have values
    | behstatusaz   |      |
    | behleer       | nein |
Then the table has 2 rows
Then table has values
    | artikel | mge |
    | PEDALE  | 10  |
    | FAHRRAD | 10  |
And I close the current editor


Scenario: 03 Storno VK Lieferschein mit mehreren Behaeltern und mehreren Artikeln

Given I create a Container "STORNO3_1_VK" for packaging material "KLT"
Given I create a Container "STORNO3_2_VK" for packaging material "KLT"
Given I create a Container "STORNO3_3_VK" for packaging material "KLT"

Scenario Outline: 03
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | <artikel> |
    | buart     | Zugang    |
    | beleg     | 06        |
    | beldat    | .         |
And I delete all rows
And I append rows
    | mge       | behaelter     |
    | <mge>     | <behaelter>   |
And I save the current editor

Examples:
    | artikel | mge | behaelter        |
    | FAHRRAD | 10  | !STORNO3_1_VK^id |
    | FAHRRAD | 7   | !STORNO3_2_VK^id |
    | PEDALE  | 5   | !STORNO3_3_VK^id |
    | PEDALE  | 2   | !STORNO3_2_VK^id |

Scenario: 03
Given I open an editor "Lieferschein03" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde | WRADSHOP |
    | ueb   | ja       |
And I delete all rows
And I append rows
    | artikel   | mge   | behaelter        |
    | FAHRRAD   | 10    | !STORNO3_1_VK^id |
    | FAHRRAD   | 7     | !STORNO3_2_VK^id |
    | PEDALE    | 5     | !STORNO3_3_VK^id |
    | PEDALE    | 2     | !STORNO3_2_VK^id |
And I save the current editor

And I reverse the PackingSlip "Lieferschein03"

# Zeile 4 keine Behaelterbuchung, da der selbe Behaelter wie in Zeile 2, also kein weiterer KLT verwendet
Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Zugang" in row 1
Then field "bhbuchung^bhkto^such" has value "KNTRADSHOP" in row 1
Then field "bhbuchung^mge" has value "1" in row 2
Then field "bhbuchung^buart" has value "Zugang" in row 2
Then field "bhbuchung^mge" has value "1" in row 3
Then field "bhbuchung^buart" has value "Zugang" in row 3
Then field "bhbuchung" is empty in row 4

Scenario Outline: 03
And I switch the current editor to editor "<such>" with command "VIEW"
Then fields have values
    | behstatusaz   |       |
    | behleer       | nein  |
Then the table has <sollrow> rows
Then table has values
    | !row  | artikel   | mge   |
    | <row> | <artikel> | <mge> |
And I close the current editor

Examples:
    | such         | sollrow | row | artikel | mge |
    | STORNO3_1_VK | 1       | 1   | FAHRRAD | 10  |
    | STORNO3_2_VK | 2       | 1   | PEDALE  | 4   |
    | STORNO3_2_VK | 2       | 2   | FAHRRAD | 7   |
    | STORNO3_3_VK | 1       | 1   | PEDALE  | 10  |


# keine Buchung auf Behaelterkonto, wenn der Behaelter in der Materialzuordnung eingetragen ist
# VERSAND-836
Scenario: 04 Storno VK MZ Lieferschein mit einem Behaelter und einem Artikel

Given I create a Container "Behaelter04" for packaging material "KLT"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | FAHRRAD   |
    | buart     | Zugang    |
    | beleg     | 06        |
    | beldat    | .         |
And I delete all rows
And I append rows
    | mge       | behaelter         |
    | 10        | !Behaelter04^id   |
And I save the current editor

Given I open an editor "Lieferschein04" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde     | WRADSHOP  |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | FAHRRAD   | 10    |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to "!Behaelter04^id" in row 1
And I save the current editor 
And I switch the current editor to editor "Lieferschein04"
And I save the current editor

And I reverse the PackingSlip "Lieferschein04"

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1
#Then field "bhbuchung^bhkto^such" has value "KNTRADSHOP" in row 1

And I switch the current editor to editor "Behaelter04" with command "VIEW"
Then fields have values
    | behstatusaz   |       |
    | behleer       | nein  |
Then the table has 1 rows
Then table has values
    | artikel | mge |
    | FAHRRAD | 10  |
And I close the current editor


# keine Buchung auf Behaelterkonto, wenn der Behaelter in der Materialzuordnung eingetragen ist
# VERSAND-836
Scenario: 05 Storno VK MZ Lieferschein mit Behaelter und mehreren Artikeln

Given I create a Container "Behaelter05" for packaging material "KLT"

Scenario Outline: 05
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | <artikel> |
    | buart     | Zugang    |
    | beleg     | 06        |
    | beldat    | .         |
And I delete all rows
And I append rows
    | mge       | behaelter         |
    | <mge>     | !Behaelter05^id   |
And I save the current editor

Examples:
    | artikel | mge |
    | FAHRRAD | 10  |
    | PEDALE  | 5   |

Scenario: 05
Given I open an editor "Lieferschein05" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde     | WRADSHOP  |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | FAHRRAD   | 10    |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to "!Behaelter05^id" in row 1
And I save the current editor 
And I switch the current editor to editor "Lieferschein05"
And I append rows
    | artikel   | mge   |
    | PEDALE    | 5     |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I set field "behaelter" to "!Behaelter05^id" in row 1
And I save the current editor 
And I switch the current editor to editor "Lieferschein05"
And I save the current editor

And I reverse the PackingSlip "Lieferschein05"

## keine Behaelterbuchung in Zeile 2, da der selbe Behaelter wie in Zeile 1, also kein weiterer KLT
#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1
#Then field "bhbuchung^bhkto^such" has value "KNTRADSHOP" in row 1
#Then field "bhbuchung" is empty in row 2

And I switch the current editor to editor "Behaelter05" with command "VIEW"
Then fields have values
    | behstatusaz   |       |
    | behleer       | nein  |
Then the table has 2 rows
Then table has values
    | artikel | mge |
    | PEDALE  | 10  |
    | FAHRRAD | 10  |
And I close the current editor


# keine Buchung auf Behaelterkonto, wenn der Behaelter in der Materialzuordnung eingetragen ist
# VERSAND-836
Scenario: 06 Storno VK MZ Lieferschein mit mehreren Behaeltern und mehreren Artikeln

Given I create a Container "STORNO6_1_VKMZ " for packaging material "KLT"
Given I create a Container "STORNO6_2_VKMZ " for packaging material "KLT"
Given I create a Container "STORNO6_3_VKMZ " for packaging material "KLT"

Scenario Outline: 06
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | <artikel> |
    | buart     | Zugang    |
    | beleg     | 06        |
    | beldat    | .         |
And I delete all rows
And I append rows
    | mge       | behaelter     |
    | <mge>     | <behaelter>   |
And I save the current editor

Examples:
    | artikel | mge | behaelter          |
    | FAHRRAD | 10  | !STORNO6_1_VKMZ^id |
    | FAHRRAD | 7   | !STORNO6_2_VKMZ^id |
    | PEDALE  | 5   | !STORNO6_3_VKMZ^id |
    | PEDALE  | 2   | !STORNO6_2_VKMZ^id |

Scenario: 06
Given I open an editor "Lieferschein06" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde     | WRADSHOP  |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | FAHRRAD   | 17    |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | zuomge    | behaelter             |
    | 1     | 10        | !STORNO6_1_VKMZ^id    |
    | +2    | 7         | !STORNO6_2_VKMZ^id    |
And I save the current editor
And I switch the current editor to editor "Lieferschein06"
And I append rows
    | artikel   | mge   |
    | PEDALE    | 7     |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I modify table
    | !row  | zuomge    | behaelter             |
    | 1     | 5         | !STORNO6_3_VKMZ^id    |
    | +2    | 2         | !STORNO6_2_VKMZ^id    |
And I save the current editor
And I switch the current editor to editor "Lieferschein06"
And I save the current editor

And I reverse the PackingSlip "Lieferschein06"

#Then field "bhbuchung^mge" has value "2" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1
#Then field "bhbuchung^bhkto^such" has value "KNTRADSHOP" in row 1
#Then field "bhbuchung^mge" has value "1" in row 2
#Then field "bhbuchung^buart" has value "Zugang" in row 2
#Then field "bhbuchung^bhkto^such" has value "KNTRADSHOP" in row 2

Scenario Outline: 06
And I switch the current editor to editor "<such>" with command "VIEW"
Then fields have values
    | behstatusaz   |       |
    | behleer       | nein  |
Then the table has <sollrow> rows
Then table has values
    | !row  | artikel   | mge   |
    | <row> | <artikel> | <mge> |
And I close the current editor

Examples:
    | such           | sollrow | row | artikel | mge |
    | STORNO6_1_VKMZ | 1       | 1   | FAHRRAD | 10  |
    | STORNO6_2_VKMZ | 2       | 1   | PEDALE  | 4   |
    | STORNO6_2_VKMZ | 2       | 2   | FAHRRAD | 7   |
    | STORNO6_3_VKMZ | 1       | 1   | PEDALE  | 10  |


Scenario: 07 Storno VK Rechnung mit einem Behaelter und einem Artikel

Given I create a Container "Behaelter07" for packaging material "KLT"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | FAHRRAD   |
    | buart     | Zugang    |
    | beleg     | 06        |
    | beldat    | .         |
And I delete all rows
And I append rows
    | mge       | behaelter         |
    | 10        | !Behaelter07^id   |
And I save the current editor

Given I open an editor "Rechnung07" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde     | WRADSHOP  |
    | fakt      | ja        |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   | behaelter         |
    | FAHRRAD   | 10    | !Behaelter07^id   |
Then I save the current editor

And I reverse the Invoice "Rechnung07"

Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Zugang" in row 1
Then field "bhbuchung^bhkto^such" has value "KNTRADSHOP" in row 1

And I switch the current editor to editor "Behaelter07" with command "VIEW"
Then fields have values
    | behstatusaz   |       |
    | behleer       | nein  |
Then the table has 1 rows
Then table has values
    | artikel | mge |
    | FAHRRAD | 10  |
And I close the current editor


Scenario: 08 Storno VK Rechnung mit einem Behaelter und mehreren Artikeln

Given I create a Container "Behaelter08" for packaging material "KLT"

Scenario Outline: 08
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | <artikel> |
    | buart     | Zugang    |
    | beleg     | 06        |
    | beldat    | .         |
And I delete all rows
And I append rows
    | mge       | behaelter         |
    | <mge>     | !Behaelter08^id   |
And I save the current editor

Examples:
    | artikel | mge |
    | FAHRRAD | 10  |
    | PEDALE  | 5   |

Scenario: 08
Given I open an editor "Rechnung08" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde     | WRADSHOP  |
    | fakt      | ja        |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   | behaelter         |
    | FAHRRAD   | 10    | !Behaelter08^id   |
    | PEDALE    | 5     | !Behaelter08^id   |
Then I save the current editor

And I reverse the Invoice "Rechnung08"

Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Zugang" in row 1
Then field "bhbuchung^bhkto^such" has value "KNTRADSHOP" in row 1
Then field "bhbuchung" is empty in row 2

And I switch the current editor to editor "Behaelter08" with command "VIEW"
Then fields have values
    | behstatusaz   |       |
    | behleer       | nein  |
Then the table has 2 rows
Then table has values
    | artikel | mge |
    | PEDALE  | 10  |
    | FAHRRAD | 10  |
And I close the current editor


Scenario: 09 Storno VK Rechnung mit mehreren Behaeltern und mehreren Artikeln

Given I create a Container "STORNO9_1_VKR" for packaging material "KLT"
Given I create a Container "STORNO9_2_VKR" for packaging material "KLT"
Given I create a Container "STORNO9_3_VKR" for packaging material "KLT"

Scenario Outline: 09
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | <artikel> |
    | buart     | Zugang    |
    | beleg     | 06        |
    | beldat    | .         |
And I delete all rows
And I append rows
    | mge       | behaelter     |
    | <mge>     | <behaelter>   |
And I save the current editor

Examples:
    | artikel | mge | behaelter     |
    | FAHRRAD | 10  | STORNO9_1_VKR |
    | FAHRRAD | 7   | STORNO9_2_VKR |
    | PEDALE  | 5   | STORNO9_3_VKR |
    | PEDALE  | 2   | STORNO9_2_VKR |

Scenario: 09
Given I open an editor "Rechnung09" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde   | WRADSHOP  |
    | fakt    | ja        |
    | ueb     | ja        |
And I delete all rows
And I append rows
    | artikel | mge | behaelter         |
    | FAHRRAD | 10  | !STORNO9_1_VKR^id |
    | FAHRRAD |  7  | !STORNO9_2_VKR^id |
    | PEDALE  |  5  | !STORNO9_3_VKR^id |
    | PEDALE  |  2  | !STORNO9_2_VKR^id |
Then I save the current editor

And I reverse the Invoice "Rechnung09"

Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Zugang" in row 1
Then field "bhbuchung^bhkto^such" has value "KNTRADSHOP" in row 1
Then field "bhbuchung^mge" has value "1" in row 2
Then field "bhbuchung^buart" has value "Zugang" in row 2
Then field "bhbuchung^mge" has value "1" in row 3
Then field "bhbuchung^buart" has value "Zugang" in row 3
Then field "bhbuchung" is empty in row 4

Scenario Outline: 09
And I switch the current editor to editor "<such>" with command "VIEW"
Then fields have values
    | behstatusaz   |       |
    | behleer       | nein  |
Then the table has <sollrow> rows
Then table has values
    | !row  | artikel   | mge   |
    | <row> | <artikel> | <mge> |
And I close the current editor

Examples:
    | such          | sollrow | row | artikel | mge |
    | STORNO9_1_VKR | 1       | 1   | FAHRRAD | 10  |
    | STORNO9_2_VKR | 2       | 1   | PEDALE  | 4   |
    | STORNO9_2_VKR | 2       | 2   | FAHRRAD | 7   |
    | STORNO9_3_VKR | 1       | 1   | PEDALE  | 10  |


# keine Buchung auf Behaelterkonto, wenn der Behaelter in der Materialzuordnung eingetragen ist
# VERSAND-836
Scenario: 10 Storno VK MZ Rechnung mit einem Behaelter und einem Artikel

Given I create a Container "Behaelter10" for packaging material "KLT"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | FAHRRAD   |
    | buart     | Zugang    |
    | beleg     | 06        |
    | beldat    | .         |
And I delete all rows
And I append rows
    | mge | behaelter       |
    | 10  | !Behaelter10^id |
And I save the current editor

Given I open an editor "Rechnung10" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde     | WRADSHOP |
    | ueb       | ja       |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | FAHRRAD   | 10    |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to "!Behaelter10^id" in row 1
And I save the current editor 
And I switch the current editor to editor "Rechnung10"
Then I save the current editor

And I reverse the Invoice "Rechnung10"

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1
#Then field "bhbuchung^bhkto^such" has value "KNTRADSHOP" in row 1

And I switch the current editor to editor "Behaelter10" with command "VIEW"
Then fields have values
    | behstatusaz   |       |
    | behleer       | nein  |
Then the table has 1 rows
Then table has values
    | artikel | mge |
    | FAHRRAD | 10  |
And I close the current editor


# keine Buchung auf Behaelterkonto, wenn der Behaelter in der Materialzuordnung eingetragen ist
# VERSAND-836
Scenario: 11 Storno VK MZ Rechnung mit Behaelter und mehreren Artikeln

Given I create a Container "Behaelter11" for packaging material "KLT"

Scenario Outline: 11
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | <artikel> |
    | buart     | Zugang    |
    | beleg     | 06        |
    | beldat    | .         |
And I delete all rows
And I append rows
    | mge   | behaelter         |
    | <mge> | !Behaelter11^id   |
And I save the current editor

Examples:
    | artikel | mge |
    | FAHRRAD | 10  |
    | PEDALE  | 5   |

Scenario: 11
Given I open an editor "Rechnung11" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde | WRADSHOP  |
    | fakt  | ja        |
    | ueb   | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | FAHRRAD   | 10    |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "behaelter" to "!Behaelter11^id" in row 1
And I save the current editor
And I switch the current editor to editor "Rechnung11"
And I append rows
    | artikel   | mge   |
    | PEDALE    | 5     |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I set field "behaelter" to "!Behaelter11^id" in row 1
And I save the current editor 
And I switch the current editor to editor "Rechnung11"
Then I save the current editor

And I reverse the Invoice "Rechnung11"

#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1
#Then field "bhbuchung^bhkto^such" has value "KNTRADSHOP" in row 1
#Then field "bhbuchung" is empty in row 2

And I switch the current editor to editor "Behaelter11" with command "VIEW"
Then fields have values
    | behstatusaz   |       |
    | behleer       | nein  |
Then the table has 2 rows
Then table has values
    | artikel | mge |
    | PEDALE  | 10  |
    | FAHRRAD | 10  |
And I close the current editor


# keine Buchung auf Behaelterkonto, wenn der Behaelter in der Materialzuordnung eingetragen ist
# VERSAND-836
Scenario: 12 Storno VK MZ Rechnung mit mehreren Behaeltern und mehreren Artikeln

Given I create a Container "STORNO12_1_VKRMZ" for packaging material "KLT"
Given I create a Container "STORNO12_2_VKRMZ" for packaging material "KLT"
Given I create a Container "STORNO12_3_VKRMZ" for packaging material "KLT"

Scenario Outline: 12 Lagerbuchung - Material in Behaelter buchen
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | <artikel> |
    | buart     | Zugang    |
    | beleg     | 06        |
    | beldat    | .         |
And I delete all rows
And I append rows
    | mge   | behaelter     |
    | <mge> | <behaelter>   |
And I save the current editor

Examples:
    | artikel | mge | behaelter            |
    | FAHRRAD | 10  | !STORNO12_1_VKRMZ^id |
    | FAHRRAD | 7   | !STORNO12_2_VKRMZ^id |
    | PEDALE  | 5   | !STORNO12_3_VKRMZ^id |
    | PEDALE  | 2   | !STORNO12_2_VKRMZ^id |

Scenario: 12 Rechnung mit Lagerbewegung und mehreren Behaeltern

Given I open an editor "Rechnung12" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde     | WRADSHOP |
    | fakt      | ja       |
    | ueb       | ja       |
And I delete all rows
And I append rows
    | artikel   | mge     |
    | FAHRRAD   | 17      |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | zuomge    | behaelter             |
    | 1     | 10        | !STORNO12_1_VKRMZ^id  |
    | +2    | 7         | !STORNO12_2_VKRMZ^id  |
And I save the current editor
And I switch the current editor to editor "Rechnung12"
And I append rows
    | artikel   | mge   |
    | PEDALE    | 7     |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I modify table
    | !row  | zuomge    | behaelter             |
    | 1     |  5        | !STORNO12_3_VKRMZ^id  |
    | +2    |  2        | !STORNO12_2_VKRMZ^id  |
And I save the current editor
And I switch the current editor to editor "Rechnung12"
Then I save the current editor

And I reverse the Invoice "Rechnung12"

#Then field "bhbuchung^mge" has value "2" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1
#Then field "bhbuchung^bhkto^such" has value "KNTRADSHOP" in row 1
#Then field "bhbuchung^mge" has value "1" in row 2
#Then field "bhbuchung^buart" has value "Zugang" in row 2
#Then field "bhbuchung^bhkto^such" has value "KNTRADSHOP" in row 2
##Then field "bhbuchung" is empty in row 2

Scenario Outline: 12
And I switch the current editor to editor "<such>" with command "VIEW"
Then fields have values
    | behstatusaz  |       |
    | behleer      | nein  |
Then the table has <sollrow> rows
Then table has values
    | !row     | artikel   | mge   |
    | <row>    | <artikel> | <mge> |
And I close the current editor

Examples:
    | such             | sollrow | row | artikel | mge |
    | STORNO12_1_VKRMZ | 1       | 1   | FAHRRAD | 10  |
    | STORNO12_2_VKRMZ | 2       | 1   | PEDALE  | 4   |
    | STORNO12_2_VKRMZ | 2       | 2   | FAHRRAD | 7   |
    | STORNO12_3_VKRMZ | 1       | 1   | PEDALE  | 10  |


Scenario: 26 Gebindepflichtiger Artikel bei Storno eines VK-Lieferscheins

Given I create a Container "Behaelter26" for packaging material "KLT" and search word "GEBINDE_26"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | SCHUHE    |
    | buart     | Zugang    |
    | beleg     | 26        |
    | beldat    | .         |
And I delete all rows
And I append rows
    | mge   | behaelter         |
    | 10    | !Behaelter26^id   |
And I save the current editor

And I switch the current editor to editor "Behaelter26" with command "VIEW"
Then the table has 1 rows
Then table has values
    | artikel | mge | gebeinh   |
    | SCHUHE  | 10  | Paar      |
And I close the current editor

Given I open an editor "Lieferschein26" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde   | WRADSHOP  |
    | vom     | .         |
    | ueb     | ja        |
And I delete all rows
And I append rows
    | artikel | mge | he   | behaelter          |
    | SCHUHE  | 10  | Paar | !Behaelter26^id    |
And I save the current editor

And I reverse the PackingSlip "Lieferschein26"

# Behaelter hat Zustand vor der Buchung des Lieferscheins
And I switch the current editor to editor "Behaelter26" with command "VIEW"
Then the table has 1 rows
Then table has values
    | artikel | mge | gebeinh   |
    | SCHUHE  | 10  | Paar      |
And I close the current editor


Scenario: 27 Kundenanlieferung + Storno der Kundenanlieferung mit Behaelter

Given I open an editor "KANL27" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde | 1                 |
    | such  | KANL27            |
    | lsart | Kundenanlieferung |
    | ueb   | ja                |
And I append rows
    | artikel | mge   | platz   | exbehnum    | packm |
    | V1      | -10   | KONSILP | Behaelter27 | KLT   |
And I save the current editor

# Behaelter pruefen, der durch Kundenanlieferung angelegt wurde
Given I open an editor "Behaelter27" from table "(Container):(ContainerHead)" with command "VIEW" for record "Behaelter27"
Then fields have values
    | behstatusaz   |       |
    | behleer       | nein  |
Then the table has 1 rows
Then table has values
    | artikel | mge |
    | V1      | 10  |
And I close the current editor

And I reverse the PackingSlip "KANL27"

Then Container from editor "Behaelter27" is empty
