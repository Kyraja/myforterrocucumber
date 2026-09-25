# *****************************************************************************************************
#  Name             : ref_bw_vrgstrgl_verkauf2_002.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Vorbereitung der Testdaten
#
#                    kurze Zusammenfassung von Faellen in ref_bw_vrgstrgl_verkauf2_001.feature:
#                    =================================================================================
#                           || Auftrag    | Vorkasse? | komplett? | Menge      | laart   | RE-Nummer |
#                    Fall   || vorhanden? |           |           | geliefert? |         |           |
#                    =================================================================================
#                    1      ||    ja      |     ja    |     ja    |   nein     | Inland  | 0001rep
#                    2      ||    ja      |     ja    |     nein  |   nein     | Inland  | 0002rep
#                    3      ||    ja      |     ja    |     ja    |   ja       | Inland  | 0003rep
#                    4      ||    ja      |     ja    |     nein  |   ja       | Inland  | 0004rep
#                    5      ||    ja      |     ja    |     ja    |   nein     | Ausland | 0005rep
#                    6      ||    ja      |     ja    |     nein  |   nein     | EU      | 0006rep
#                    7      ||    ja      |     ja    |     ja    |   ja       | Ausland | 0007rep
#                    8      ||    ja      |     ja    |     nein  |   ja       | EU      | 0008n2
#                    9      ||    nein    |     ja    |     ja    |   nein     | Inland  | 0009rep
#                    10     ||    nein    |     ja    |     ja    |   ja       | Inland  | 0010rep
#                    11     ||    nein    |     ja    |     ja    |   nein     | Ausland | 0011rep
#                    12     ||    nein    |     ja    |     ja    |   ja       | EU      | 0012rep
#
#
#                    kurze Zusammenfassung von Faellen in ref_bw_vrgstrgl_verkauf2_002.feature:
#                    ========================================================================
#                           || Auftrag    | RE mit | RE aus | RE aus | Teil-RE  | RE-Nummer |
#                    Fall   || vorhanden? | LB?    | LS?    | AU?    | zu POS.? |           |
#                    ========================================================================
#                    13     ||    ja      |  ja    |  nein  |   ja   | nein     | 0013norm
#                    14     ||    ja      |  ja    |  nein  |   ja   | ja       | 0014norm, 0014n2
#                    15     ||    ja      |  nein  |  nein  |   ja   | nein     | 0015norm
#                    16     ||    ja      |  nein  |  nein  |   ja   | ja       | 0002norm, 0004norm
#                    17     ||    ja      |  nein  |  ja    |   nein | nein     | 0017norm
#                    18     ||    nein    |  ja    |  nein  |   -    | -        | 0018norm
#                    19     ||    nein    |  nein  |  ja    |   -    | nein     | 0019norm
#                    20     ||    nein    |  nein  |  ja    |   -    | ja       | 0020n1, 0020n2
#
#
#           ACHTUNG: bei Aenderungen beide .feature-Dateien pflegen!!!
#
# *****************************************************************************************************
@persistent
Feature: Testdaten
Background: Testdaten fuer ein Reparaturprogramm
Given I set the fake date to "25.02.2000"


# @FALL-13
Scenario: 13.Rechnung mit LB  (Inland) aus dem Auftrag
Given I open an editor "auftrag13" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "nummer" to "0013au"
When I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "2" in row 1
And I set field "preis" to "3" in row 1
And I set field "platz" to "F3" in row 1
When I create a new row at the end of the table
And I set field "artex" to "EINK" in row 2
And I set field "mge" to "11" in row 2
And I set field "preis" to "5" in row 2
And I set field "platz" to "F3" in row 2
And I save the current editor

# Auftrag in Rechnung ueberfuehren
Given I open an editor "rechnung13" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag13"
And I set field "nummer" to "0013norm"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "mge" to "2" in row 1
And I set field "mge" to "11" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#####################################################################################################################################


# @FALL-14
Scenario: 14.Rechnung mit LB  (Inland) aus dem Auftrag

Given I set the fake date to "27.02.2000"

Given I open an editor "auftrag14" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "nummer" to "0014au"
When I create a new row at the end of the table
And I set field "artex" to "TEST" in row 1
And I set field "mge" to "21" in row 1
And I set field "preis" to "3" in row 1
And I set field "platz" to "F3" in row 1
When I create a new row at the end of the table
And I set field "artex" to "EINK" in row 2
And I set field "mge" to "17" in row 2
And I set field "preis" to "5.51" in row 2
And I set field "platz" to "F3" in row 2
And I save the current editor

# Auftrag in Rechnung ueberfuehren
Given I open an editor "rechnung14" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag14"
And I set field "nummer" to "0014norm"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "mge" to "21" in row 1
And I delete row at position !lastRow
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Auftrag in Rechnung ueberfuehren
Given I open an editor "rechnung14" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag14"
And I set field "nummer" to "0014n2"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "mge" to "17" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#####################################################################################################################################


# @FALL-15
Scenario: 15.Rechnung mit LB  (Inland) aus dem Auftrag

Given I set the fake date to "01.03.2000"

Given I open an editor "auftrag15" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "nummer" to "0015au"
When I create a new row at the end of the table
And I set field "artex" to "V2" in row 1
And I set field "mge" to "111" in row 1
And I set field "preis" to "3.33" in row 1
And I set field "platz" to "F3" in row 1
When I create a new row at the end of the table
And I set field "artex" to "EINK" in row 2
And I set field "mge" to "19" in row 2
And I set field "preis" to "7.71" in row 2
And I set field "platz" to "F3" in row 2
And I save the current editor

# Auftrag in Lieferschein ueberfuehren
Given I open an editor "lieferschein15" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag15"
And I set field "nummer" to "0015ls"
And I set field "ueb" to "ja"
And I set field "mge" to "111" in row 1
And I set field "mge" to "19" in row 2
And I save the current editor

# Auftrag in Rechnung ueberfuehren
Given I open an editor "rechnung15" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag15"
And I set field "nummer" to "0015norm"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "mge" to "111" in row 1
And I set field "mge" to "19" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#####################################################################################################################################


# @FALL-17
Scenario: 17.Rechnung mit LB  (Inland) aus dem Auftrag

Given I set the fake date to "03.03.2000"

Given I open an editor "auftrag17" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "nummer" to "0017au"
When I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "111" in row 1
And I set field "preis" to "3.33" in row 1
And I set field "platz" to "F3" in row 1
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 2
And I set field "mge" to "19" in row 2
And I set field "preis" to "7.71" in row 2
And I set field "platz" to "F3" in row 2
And I save the current editor

# Auftrag in Lieferschein ueberfuehren
Given I open an editor "lieferschein17" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag17"
And I set field "nummer" to "0017ls"
And I set field "ueb" to "ja"
And I set field "mge" to "111" in row 1
And I set field "mge" to "19" in row 2
And I save the current editor

# Auftrag in Rechnung ueberfuehren
Given I open an editor "rechnung17" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein17"
And I set field "nummer" to "0017norm"
And I set field "ueb" to "ja"
And I set field "mge" to "111" in row 1
And I set field "mge" to "19" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#####################################################################################################################################


# @FALL-18
Scenario: 18

Given I set the fake date to "08.03.2000"

Given I open an editor "rechnung18" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "206"
And I set field "nummer" to "0018norm"
And I set field "budat" to "."
And I set field "vom" to "."
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
When I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "preis" to "335" in row 1
And I set field "mge" to "13" in row 1
And I set field "platz" to "F3" in row 1
When I create a new row at the end of the table
And I set field "artex" to "e3" in row 2
And I set field "preis" to "6673" in row 2
And I set field "mge" to "19.01" in row 2
And I set field "platz" to "F3" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#####################################################################################################################################


# @FALL-19
Scenario: 19

Given I set the fake date to "08.03.2000"

Given I open an editor "lieferschein19" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "206"
And I set field "nummer" to "0019ls"
And I set field "budat" to "."
And I set field "vom" to "."
And I set field "ueb" to "ja"
When I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "preis" to "175" in row 1
And I set field "mge" to "10" in row 1
And I set field "platz" to "F3" in row 1
And I save the current editor

Given I open an editor "rechnung19" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein19"
And I set field "nummer" to "0019norm"
And I set field "ueb" to "ja"
And I set field "mge" to "10" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#####################################################################################################################################


# @FALL-20
Scenario: 20

Given I set the fake date to "08.03.2000"

Given I open an editor "lieferschein20" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "nummer" to "0020ls"
And I set field "budat" to "."
And I set field "vom" to "."
And I set field "ueb" to "ja"
When I create a new row at the end of the table
And I set field "artex" to "V2" in row 1
And I set field "preis" to "111" in row 1
And I set field "mge" to "220" in row 1
And I set field "platz" to "F3" in row 1
And I save the current editor

Given I open an editor "rechnung20-1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein20"
And I set field "nummer" to "0020n1"
And I set field "ueb" to "ja"
And I set field "mge" to "100" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "rechnung20-2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein20"
And I set field "nummer" to "0020n2"
And I set field "ueb" to "ja"
And I set field "mge" to "120" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#####################################################################################################################################

