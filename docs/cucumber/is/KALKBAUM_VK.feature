@persistent
Feature: KALKBAUM_VK.feature

Background:
And I set the fake date to "16.01.1995"

# **********************************************************************************
#  Name             : KALKBAUM_VK.feature
#  Autor            : bschiga
#  Verantwortlich   : bschiga
#  Kontrolle        : cl
#  Funktion         : IS KALKBAUM fuer Auftraege mit nicht kalkulierten Positionen
#  ref              : ref_vo_kbaum_cu
#
# **********************************************************************************
# verwendete Stammdaten aus Vorgaenger refeks0
####################################################################################

Scenario: 01 Auftrag mit nicht kalkulierten Positionen

# Auftrag mit kalkulierten und nicht kalkulierten Positionen
Given I open an editor "AUF_MISCH" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | TEST      |
    | such  | AUF_MISCH |
    | vom   | .         |
And I append rows
    | artikel   | mge   | kalk  | einplan |
    | V1        | 10    | ja    |  ja     |
    | V2        | 10    | nein  |  ja     |
    | V3        | 10    | ja    |  ja     |
And I press button "kalkul" to open a subeditor for "kalkulieren" in row 0 with dialog "" and answer "1"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Auftrag erste Position nicht kalkuliert, zweite Position kalkuliert
Given I open an editor "AUF_1NEIN" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | TEST      |
    | such  | AUF_1NEIN |
    | vom   | .         |
And I append rows
    | artikel   | mge   | kalk  | einplan |
    | V1        | 10    | nein  |  ja     |
    | EINK      | 10    | ja    |  ja     |
And I press button "kalkul" to open a subeditor for "kalkulieren" in row 0 with dialog "" and answer "1"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Auftrag nur nicht kalkulierten Positionen
Given I open an editor "AUF_NOKAL" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | TEST      |
    | such  | AUF_NOKAL |
    | vom   | .         |
And I append rows
    | artikel   | mge   | kalk  | einplan |
    | V1        | 10    | nein  |  ja     |
    | EINK      | 10    | nein  |  ja     |
And I save the current editor

Given I open the infosystem "KALKBAUM"
And I set field "kauftrag" to "!AUF_MISCH^id"
And I press start
Then the table has 8 rows
Then table has values
    | !row | tbaumstufe | elem  |
    | 1    | 1          | V1    |
    | 5    | 1          | V3    |
And I close the current editor

Given I open the infosystem "KALKBAUM"
And I set field "kauftrag" to "!AUF_1NEIN^id"
And I press start
Then the table has 1 rows
Then table has values
    | !row | tbaumstufe | elem  |
    | 1    | 1          | EINK  |
And I close the current editor

Given I open the infosystem "KALKBAUM"
And I set field "kauftrag" to "!AUF_NOKAL^id"
And I press start
Then the table has 0 rows
And I close the current editor
