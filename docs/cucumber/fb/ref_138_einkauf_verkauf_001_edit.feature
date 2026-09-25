# *****************************************************************************
#  Name             : ref_138_einkauf_verkauf_001_edit.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : "evkvnum" in EK/VK: Editierbarkeit, Plausis, ...
#
# *****************************************************************************
@persistent
Feature: ref_138_einkauf_verkauf_001_edit.feature
Background:


# Scenario: Vorbereitung

Scenario Outline: STAMMDATEN - Neue Kunden anlegen

Given I open an editor "konto<num>" from table "(Account):(Account)" with command "UPDATE" for record "<num>"
And I set field "kvrel" to "ja"
And I save the current editor

Examples: Konto
| num   |
| 43370 |
| 44000 |
########################################################################################################

Scenario: Editieren vom Feld "evkvnum" in Verkauf 1

Given I open an editor "auftrag1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "nummer" to "0001au"
When I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "25" in row 1
And I set field "preis" to "31" in row 1
And I set field "platz" to "F3" in row 1
Then field "kvnum" is modifiable in row 1
Then field "kvnum" has value "" in row 1
Then field "konto" has value "44000" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
And I set field "kvnum" to "teilE3" in row 1
When I create a new row at the end of the table
And I set field "artex" to "EINK" in row 2
And I set field "mge" to "11" in row 2
And I set field "preis" to "35" in row 2
And I set field "platz" to "F3" in row 2
Then field "kvnum" is modifiable in row 2
Then field "kvnum" has value "" in row 2
Then field "konto" has value "44000" in row 2
Then field "strgl" has value "VKINSTPF-1-81" in row 2
# kv-relevantes Konto eintragen
And I set field "konto" to "43370" in row 2
And I set field "kvnum" to "hurra" in row 2
Then field "konto" has value "43370" in row 2
Then field "kvnum" is modifiable in row 2
Then field "kvnum" has value "hurra" in row 2
# STRGL ist leer, weil VRGSTRGL passt nicht zum Konto
Then field "strgl" has value "" in row 2
When I create a new row at the end of the table
And I set field "artex" to "ANZ" in row 3
Then field "kvnum" is modifiable in row 3
Then field "kvnum" has value "" in row 3
And I save the current editor


# 1. Position aus dem Auftrag liefern
Given I open an editor "lieferschein1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag1"
And I set field "nummer" to "0001ls"
And I set field "ueb" to "ja"
# Zeile 1
And I press button "offueb" in row 1
Then field "kvnum" is modifiable in row 1
Then field "kvnum" has value "teilE3" in row 1
Then field "konto" has value "44000" in row 1
# Zeile 2
Then field "artex" has value "10001" in row 2
Then field "konto" has value "43370" in row 2
Then field "kvnum" is modifiable in row 2
Then field "kvnum" has value "hurra" in row 2
# STRGL ist leer, weil VRGSTRGL passt nicht zum Konto
Then field "strgl" has value "" in row 2
And I press button "offueb" in row 2
#
And I save the current editor


# Anzahlung
Given I open an editor "anzahlung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag1"
And I set field "nummer" to "0002anz"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "vorgang" to "Anzahlung"
And I set field "pwert" to "77" in row 1
Then field "kvnum" is modifiable in row 1
Then field "kvnum" has value "0001au" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Lieferschein in Rechnung ueberfuehren: nur Zeile 1 aus editor "lieferschein1"
Given I open an editor "rechnung1-1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein1"
And I set field "nummer" to "0001re"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I delete row at position 3
And I delete row at position 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Lieferschein in Rechnung ueberfuehren: nur Zeile 2 aus editor "lieferschein1"
Given I open an editor "rechnung1-2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein1"
And I set field "nummer" to "0002re"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then field "artex" has value "10001" in row 1
Then field "konto" has value "43370" in row 1
Then field "kvnum" is modifiable in row 1
Then field "kvnum" has value "hurra" in row 1
Then field "strgl" has value "" in row 1
Then field "fixkonto" has value "ja" in row 1
And I press button "offueb" in row 1
#
# 8617: Buchung ohne Steuerregel nicht möglich. In der Kontosteuerregel des Kontos ist keine zul�ssige Steuerregel definiert. Bitte pr�fen.
Then saving the current editor throws the exception "8617"
#
And I set field "fixkonto" to "nein" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "konto" has value "44000" in row 1
#
# And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
########################################################################################################


Scenario: Kopieren und "kvnum"

Given I open an editor "auftrag-copy" from table "(Sales):(SalesOrder)" with command "COPY" for record "+0001au"
Then the table has 3 rows
Then field "kvnum" is modifiable in row 1
Then field "kvnum" has value "" in row 1
Then field "kvnum" is modifiable in row 2
Then field "kvnum" has value "" in row 2
Then field "kvnum" is modifiable in row 3
Then field "kvnum" has value "" in row 3
# Objekt wird nicht gespeichert
And I close the current editor

Given I open an editor "lieferschein-copy" from table "(Sales):(PackingSlip)" with command "COPY" for record "+0001ls"
Then the table has 2 rows
Then field "kvnum" is modifiable in row 1
Then field "kvnum" has value "teilE3" in row 1
Then field "kvnum" is modifiable in row 2
Then field "kvnum" has value "hurra" in row 2
# Objekt wird nicht gespeichert
And I close the current editor
########################################################################################################

