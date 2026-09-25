# *****************************************************************************************************
#  Name             : ref_bw_vrgstrgl_verkauf2_004.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Mit manipulierten Daten weiter arbeiten
#
#
# *****************************************************************************************************
@persistent
Feature: Mit manipulierten Daten weiter arbeiten
Background:  Abgangsketten verlaengern

Given I set the fake date to "10.03.2000"

# @FALL-VORKASSE-BELIEFERN
Scenario: schon bezahlten Mengen liefern


# Auftrag beliefern
Given I open an editor "lieferschein1" from table "(Sales):(PackingSlip)" with command "NEW" for record "0001au"
And I set field "nummer" to "1LSnach"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

Given I open an editor "lieferschein2" from table "(Sales):(PackingSlip)" with command "NEW" for record "0002au"
And I set field "nummer" to "2LSnach"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "lieferschein5" from table "(Sales):(PackingSlip)" with command "NEW" for record "0005au"
And I set field "nummer" to "5LSnach"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

Given I open an editor "lieferschein6" from table "(Sales):(PackingSlip)" with command "NEW" for record "0006au"
And I set field "nummer" to "6LSnach"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
# And I press button "offueb" in row 2
And I save the current editor
#####################################################################################################################################

# @FALL-WARTENDE-MENGE
Scenario: wartende Menge (auf dem Platz F3) mit Zugaengen versorgen

Given I set the fake date to "11.03.2000"

# wartende Mengen versorgen
Given I open an editor "ek-rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "01alles"
And I set field "lief" to "001"
And I set field "budat" to "."
And I set field "vom" to "."
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
# "E1"
When I create a new row at the end of the table
And I set field "artikel" to "E1" in row 1
And I set field "preis" to "1.1" in row 1
And I set field "platz" to "F3" in row 1
And I set field "mge" to "34" in row 1
And I set field "platz" to "F3" in row 1
# "E2"
When I create a new row at the end of the table
And I set field "artikel" to "E2" in row 2
And I set field "preis" to "1.2" in row 2
And I set field "platz" to "F3" in row 2
And I set field "mge" to "19" in row 2
And I set field "platz" to "F3" in row 2
# "E3"
When I create a new row at the end of the table
And I set field "artikel" to "E3" in row 3
And I set field "preis" to "1.3" in row 3
And I set field "platz" to "F3" in row 3
And I set field "mge" to "31.01" in row 3
And I set field "platz" to "F3" in row 3
# "EINK"
When I create a new row at the end of the table
And I set field "artikel" to "EINK" in row 4
And I set field "preis" to "1.0" in row 4
And I set field "platz" to "F3" in row 4
And I set field "mge" to "110" in row 4
And I set field "platz" to "F3" in row 4
# "V1"
When I create a new row at the end of the table
And I set field "artikel" to "V1" in row 5
And I set field "preis" to "1.0" in row 5
And I set field "platz" to "F3" in row 5
And I set field "mge" to "134" in row 5
And I set field "platz" to "F3" in row 5
# "V2"
When I create a new row at the end of the table
And I set field "artikel" to "V2" in row 6
And I set field "preis" to "1.0" in row 6
And I set field "platz" to "F3" in row 6
And I set field "mge" to "442" in row 6
And I set field "platz" to "F3" in row 6
# "TEST"
When I create a new row at the end of the table
And I set field "artikel" to "TEST" in row 7
And I set field "preis" to "2.0" in row 7
And I set field "platz" to "F3" in row 7
And I set field "mge" to "21" in row 7
And I set field "platz" to "F3" in row 7
#
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#####################################################################################################################################


@Fall-KBV
Scenario: KBV am 12.03.2000

Given I set the fake date to "12.03.2000"

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################
