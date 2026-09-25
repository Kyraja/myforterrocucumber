# *****************************************************************************
#  Name           : koppel_lbei_be_oder_ls.feature
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : wane
#  Funktion       : Test des Erzeugens einer Zubuchung einer Lieferantenbeistellung mit Koppelprodukt.
#                   Einmal wird ein Lieferschein auf Basis einer Bestellung erzeugt und einmal wird
#                   direkt ein Lieferschein erzeugt.
#                   Beides sollte zu denselben Bewertungen führen.              
#
# *****************************************************************************
@persistent
Feature: BW2-973 (Koppelprodukt wird falsch abgebildet)
Background:
Given I set the fake date to "03.02.1995"

Scenario: Stammdaten pflegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "koppel"
# Bewertungsverfahren hier auf "Planpreis
And I set field "ekbewverf" to "3"
And I set field "planpr1" to "3.5"
And I save the current editor

Given I open an editor "wg" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "55"
# Bewertungsverfahren hier auf "Planpreis
And I set field "ekbewverf" to "4"
And I save the current editor

Scenario: EK-LS auf Basis einer Bestellung
Given I open an editor "be-111" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "lohnf"
And I set field "num4" to "111-BE"
And I create a new row at the end of the table
And I set field "artex" to "kt-beist" in row 1
And I set field "mge" to "010" in row 1
And I set field "preis" to "5" in row 1
And I save the current editor
                       
Given I open an editor "ls-111.1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "be-111"
And I set field "num4" to "111-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I save the current editor
And I close the current editor

Scenario: EK-LS direkt erstellen
Given I open an editor "ls-222" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "num4" to "222-LS"
And I set field "lief" to "lohnf"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "kt-beist" in row 1
And I set field "mge" to "020" in row 1
And I set field "preis" to "8" in row 1
And I save the current editor

