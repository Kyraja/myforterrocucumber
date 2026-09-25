# *****************************************************************************************************
#  Name             : ref_bw_vrgstrgl_verkauf2_001.feature
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
# *****************************************************************************************************
@persistent
Feature: Testdaten
Background: Testdaten fuer ein Reparaturprogramm
Given I set the fake date to "01.02.2000"



# @FALL-1
Scenario: 1.Vorkasse (Inland) aus dem Auftrag

Given I open an editor "auftrag1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "nummer" to "0001au"
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
Given I open an editor "rechnung1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag1"
And I set field "nummer" to "0001rep"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "mge" to "2" in row 1
And I set field "mge" to "11" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#####################################################################################################################################

# @FALL-2 und @Fall-16
Scenario: 2.Rechnung (Inland) ohne LB anlegen, aber nur fuer eine Position

Given I set the fake date to "03.02.2000"

Given I open an editor "auftrag2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "200"
And I set field "nummer" to "0002au"
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

# 1. Position aus dem Auftrag liefern
Given I open an editor "lieferschein2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag2"
And I set field "nummer" to "0002ls"
And I set field "ueb" to "ja"
And I set field "mge" to "2" in row 1
And I delete row at position !lastRow
And I save the current editor

# Lieferschein in Rechnung ueberfuehren
Given I open an editor "rechnung3-0" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein2"
And I set field "nummer" to "0002norm"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# 2. Position aus dem Auftrag bezahlen -> geliefert wurde noch nix
Given I open an editor "rechnung2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag2"
And I set field "nummer" to "0002rep"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "mge" to "11" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#####################################################################################################################################


# @FALL-3
Scenario: 3.Vorkasse (Inland) aus dem Auftrag

Given I set the fake date to "05.02.2000"

Given I open an editor "auftrag3" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "nummer" to "0003au"
When I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "33" in row 1
And I set field "preis" to "3" in row 1
And I set field "platz" to "F3" in row 1
When I create a new row at the end of the table
And I set field "artex" to "EINK" in row 2
And I set field "mge" to "11" in row 2
And I set field "preis" to "5" in row 2
And I set field "platz" to "F3" in row 2
And I save the current editor

# Auftrag in Rechnung ueberfuehren
Given I open an editor "rechnung3" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag3"
And I set field "nummer" to "0003rep"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "mge" to "33" in row 1
And I set field "mge" to "11" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag beliefern
Given I open an editor "lieferschein3" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag3"
And I set field "nummer" to "0003ls"
And I set field "mge" to "33" in row 1
And I set field "mge" to "11" in row 2
And I save the current editor
#####################################################################################################################################


# @FALL-4 und @Fall-16
Scenario: 4

Given I set the fake date to "07.02.2000"

Given I open an editor "auftrag4" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "200"
And I set field "nummer" to "0004au"
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

# 1. Position aus dem Auftrag liefern
Given I open an editor "lieferschein4" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag4"
And I set field "nummer" to "0004ls"
And I set field "ueb" to "ja"
And I set field "mge" to "2" in row 1
And I delete row at position !lastRow
And I save the current editor

# Lieferschein in Rechnung ueberfuehren
Given I open an editor "rechnung4-0" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein4"
And I set field "nummer" to "0004norm"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "mge" to "2" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# 2. Position aus dem Auftrag bezahlen -> geliefert wurde noch nix
Given I open an editor "rechnung4" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag4"
And I set field "nummer" to "0004rep"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "mge" to "11" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# 2. Position aus dem Auftrag liefern
Given I open an editor "lieferschein4-1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag4"
And I set field "mge" to "11" in row 1
And I save the current editor
#####################################################################################################################################


# @FALL-5
Scenario: 1.Rechnung (Ausland) ohne LB anlegen

Given I set the fake date to "09.02.2000"

Given I open an editor "auftrag5" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "212"
And I set field "nummer" to "0005au"
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
Given I open an editor "rechnung5" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag5"
And I set field "nummer" to "0005rep"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "mge" to "2" in row 1
And I set field "mge" to "11" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#####################################################################################################################################

# @FALL-6 und @Fall-16
Scenario: 2.Rechnung (Inland) ohne LB anlegen, aber nur fuer eine Position

Given I set the fake date to "12.02.2000"

Given I open an editor "auftrag6" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "206"
And I set field "nummer" to "0006au"
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

# 1. Position aus dem Auftrag liefern
Given I open an editor "lieferschein6" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag6"
And I set field "nummer" to "0006ls"
And I set field "ueb" to "ja"
And I set field "mge" to "2" in row 1
And I delete row at position !lastRow
And I save the current editor

# Lieferschein in Rechnung ueberfuehren
Given I open an editor "rechnung6-0" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein6"
And I set field "nummer" to "0006norm"
And I set field "vom" to "."
And I set field "budat" to "."
And I set field "ueb" to "ja"
And I set field "mge" to "2" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# 2. Position aus dem Auftrag bezahlen -> geliefert wurde noch nix
Given I open an editor "rechnung6-1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag6"
And I set field "nummer" to "0006rep"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "mge" to "11" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#####################################################################################################################################


# @FALL-7
Scenario: 7.Vorkasse (Ausland) aus dem Auftrag

Given I set the fake date to "13.02.2000"

Given I open an editor "auftrag7" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "215"
And I set field "nummer" to "0007au"
When I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "33" in row 1
And I set field "preis" to "3" in row 1
And I set field "platz" to "F3" in row 1
When I create a new row at the end of the table
And I set field "artex" to "EINK" in row 2
And I set field "mge" to "11" in row 2
And I set field "preis" to "5" in row 2
And I set field "platz" to "F3" in row 2
And I save the current editor

# Auftrag in Rechnung ueberfuehren
Given I open an editor "rechnung7" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag7"
And I set field "nummer" to "0007rep"
# Bestimmungsland: Nigeria
And I set field "vstaat" to "150"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "mge" to "33" in row 1
And I set field "mge" to "11" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag beliefern
Given I open an editor "lieferschein7" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag7"
And I set field "nummer" to "0007ls"
And I set field "mge" to "33" in row 1
And I set field "mge" to "11" in row 2
And I save the current editor
#####################################################################################################################################


# @FALL-8 und @Fall-16
Scenario: 8

Given I set the fake date to "15.02.2000"

Given I open an editor "auftrag8" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "206"
And I set field "nummer" to "0008au"
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "2" in row 1
And I set field "preis" to "3" in row 1
And I set field "platz" to "F3" in row 1
When I create a new row at the end of the table
And I set field "artex" to "V1" in row 2
And I set field "mge" to "11" in row 2
And I set field "preis" to "5" in row 2
And I set field "platz" to "F3" in row 2
And I save the current editor

# 1. Position aus dem Auftrag liefern
Given I open an editor "lieferschein8" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag8"
And I set field "nummer" to "0008ls1"
And I set field "ueb" to "ja"
And I set field "mge" to "2" in row 1
And I delete row at position !lastRow
And I save the current editor

# Lieferschein in Rechnung ueberfuehren
Given I open an editor "rechnung8-0" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein8"
And I set field "nummer" to "0008n1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "mge" to "2" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# 2. Position aus dem Auftrag bezahlen -> geliefert wurde noch nix
Given I open an editor "rechnung8" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag8"
And I set field "nummer" to "0008n2"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "mge" to "11" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# 2. Position aus dem Auftrag liefern
Given I open an editor "lieferschein8-1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag8"
And I set field "nummer" to "0008ls2"
And I set field "mge" to "11" in row 1
And I save the current editor
#####################################################################################################################################

# @FALL-9
Scenario: 9

Given I set the fake date to "21.02.2000"

Given I open an editor "rechnung9" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "nummer" to "0009rep"
And I set field "ueb" to "ja"
And I set field "fakt" to "nein"
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "preis" to "5" in row 1
And I set field "mge" to "9" in row 1
And I set field "platz" to "F3" in row 1
When I create a new row at the end of the table
And I set field "artex" to "e2" in row 2
And I set field "preis" to "3" in row 2
And I set field "mge" to "9" in row 2
And I set field "platz" to "F3" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#####################################################################################################################################


# @FALL-10
Scenario: 10

Given I set the fake date to "23.02.2000"

Given I open an editor "rechnung10" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "nummer" to "0010rep"
And I set field "budat" to "."
And I set field "vom" to "."
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "preis" to "5" in row 1
And I set field "mge" to "10" in row 1
And I set field "platz" to "F3" in row 1
When I create a new row at the end of the table
And I set field "artex" to "e2" in row 2
And I set field "preis" to "3" in row 2
And I set field "mge" to "10" in row 2
And I set field "platz" to "F3" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Lieferschein in Rechnung ueberfuehren
Given I open an editor "lieferschein10" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "nummer" to "0010ls"
And I set field "kunde" to "001"
And I set field "budat" to "."
And I set field "vom" to "."
And I set field "ueb" to "ja"
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "preis" to "5" in row 1
And I set field "mge" to "13" in row 1
And I set field "platz" to "F3" in row 1
When I create a new row at the end of the table
And I set field "artex" to "e2" in row 2
And I set field "preis" to "3" in row 2
And I set field "mge" to "19" in row 2
And I set field "platz" to "F3" in row 2
And I save the current editor
#####################################################################################################################################

# @FALL-11
Scenario: 11

Given I set the fake date to "21.02.2000"

Given I open an editor "rechnung11" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "215"
And I set field "nummer" to "0011rep"
And I set field "ueb" to "ja"
And I set field "fakt" to "nein"
# Bestimmungsland: Nigeria
And I set field "vstaat" to "150"
When I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "preis" to "5" in row 1
And I set field "mge" to "13" in row 1
And I set field "platz" to "F3" in row 1
When I create a new row at the end of the table
And I set field "artex" to "e2" in row 2
And I set field "preis" to "3" in row 2
And I set field "mge" to "19" in row 2
And I set field "platz" to "F3" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#####################################################################################################################################

# @FALL-12
Scenario: 12

Given I set the fake date to "23.02.2000"

Given I open an editor "rechnung12" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "206"
And I set field "nummer" to "0012rep"
And I set field "budat" to "."
And I set field "vom" to "."
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "preis" to "5" in row 1
And I set field "mge" to "13" in row 1
And I set field "platz" to "F3" in row 1
When I create a new row at the end of the table
And I set field "artex" to "e2" in row 2
And I set field "preis" to "3" in row 2
And I set field "mge" to "19" in row 2
And I set field "platz" to "F3" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein mit gleichen Art. und Mengen.
Given I open an editor "lieferschein12" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "nummer" to "0012ls"
And I set field "kunde" to "206"
And I set field "budat" to "."
And I set field "vom" to "."
And I set field "ueb" to "ja"
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "preis" to "5" in row 1
And I set field "mge" to "13" in row 1
When I create a new row at the end of the table
And I set field "artex" to "e2" in row 2
And I set field "preis" to "3" in row 2
And I set field "mge" to "19" in row 2
And I save the current editor
#####################################################################################################################################

