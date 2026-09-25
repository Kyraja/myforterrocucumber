# *****************************************************************************
#  Name           : vk_offene_menge.feature
#  Autor          : dago
#  Verantwortlich : teampss
#  Funktion       : Test der Menge in Ein- und Verkauf (Offene Rechnungsmenge berechnen)
#
# *****************************************************************************
#
@persistent
Feature: Mengen im VK
Background: Test fuer die Werte in den Mengenpositionen im Verkauf
Given I set the fake date to "02.01.1995"

################################################################################
# V E R K A U F
################################################################################


#------------------------------------------------------------------------------
# TSQ-OFMENGE-001: VK - Offene Rechnungsmenge im Auftrag.
#------------------------------------------------------------------------------

@Auftrag
Scenario: Im Auftrag die Positionen auf rechnungsrelevant setzen.
Given I open an editor "1AU002" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "1AU002"
# Position 1 mit V1
Then field "remge" has value "2" in row 1
And I set field "rerelev" to "nein" in row 1
Then field "remge" has value "0" in row 1
And I set field "rerelev" to "ja" in row 1
Then field "remge" has value "2" in row 1
# Position 2 mit V2
Then field "remge" has value "20" in row 3
And I set field "rerelev" to "nein" in row 3
Then field "remge" has value "0" in row 3
And I set field "rerelev" to "ja" in row 3
Then field "remge" has value "20" in row 3
And I set field "mge" to "9" in row 3
Then field "remge" has value "9" in row 3
And I close the current editor

#------------------------------------------------------------------------------
# TSQ-OFMENGE-002: VK - Offene Rechnungsmenge im Lieferschein.
#------------------------------------------------------------------------------

@Lieferschein
Scenario: Im Lieferschein die Positionen auf rechnungsrelevant setzen.
Given I open an editor "1LS003" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "1LS003"
Then field "remge" has value "0" in row 1
And I set field "rerelev" to "nein" in row 1
Then field "remge" has value "0" in row 1
And I set field "rerelev" to "ja" in row 1
Then field "remge" has value "0" in row 1
Then field "remge" has value "0" in row 3
And I set field "rerelev" to "nein" in row 3
Then field "remge" has value "0" in row 3
And I set field "rerelev" to "ja" in row 3
Then field "remge" has value "0" in row 3
And I close the current editor

#------------------------------------------------------------------------------
# TSQ-OFMENGE-003: VK - Offene Rechnungsmenge im Gutschriftsfall (Ruecklieferschein).
#------------------------------------------------------------------------------

@Lieferschein
Scenario: Im Ruecklieferschein die Position auf rechnungsrelevant (Gutschrift) setzen.
Given I open an editor "1LS001R" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "1LS001R"
Then field "remge" has value "0" in row 1
And I set field "rerelev" to "nein" in row 1
Then field "remge" has value "0" in row 1
And I set field "rerelev" to "ja" in row 1
Then field "remge" has value "0" in row 1
And field "remge" has value "0" in row 2
And I set field "rerelev" to "nein" in row 2
Then field "remge" has value "0" in row 2
And I close the current editor

#################################################################################
# E I N K A U F
#################################################################################

#------------------------------------------------------------------------------
# TSQ-OFMENGE-004: EK - Offene Rechnungsmenge im Gutschriftsfall (Ruecklieferschein).
#------------------------------------------------------------------------------

@Lieferschein
Scenario: EK: Im Ruecklieferschein die Position auf rechnungsrelevant (Gutschrift) setzen.
Given I open an editor "1LS020R" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "1LS020R"
Then field "remge" has value "0" in row 1
And I set field "rerelev" to "nein" in row 1
Then field "remge" has value "0" in row 1
And I set field "rerelev" to "ja" in row 1
Then field "remge" has value "0" in row 1
And I close the current editor
