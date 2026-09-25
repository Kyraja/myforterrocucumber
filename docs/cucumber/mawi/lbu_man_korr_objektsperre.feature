# *****************************************************************************
#  Name           : lbu_man_korr_objektsperre.feature   
#  Autor          : sih
#  Verantwortlich : sih
#  Funktion       : Plausibilisierung von gesperrrten Kostenverteilern in der manuellen Lagerbuchung, der Bestandskorrektur und dem Mischpreis setzen.
#
# *****************************************************************************
#
@persistent
Feature: Stamm-Kostenverteiler mit gesperrten Objekten in manueller Lagerbuchung, Bestandskorrektur, Mischpreiskorrektur
Background: 
Given I set the fake date to "20.12.1995"

Scenario: 00 Stammdaten
# Kst 1200 als Bestandteil von KV 10 bekommt Sperrkonfiguration "Standard-Kostenstellensperre" mit harter Logistiksperre
Given I open an editor "ks" from table "(Account):(CostCenter)" with command "UPDATE" for record "1200"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
And I set field "sperrgrundneu" to "Hinweis"
And I save the current editor
And I close the current editor

Scenario: 01 manueller Zugang
Given I open an editor "manuellerZugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
| artikel | E1       |
| beleg   | B_E1     |
| buart   | Zugang   |
| wert    | 12       |
| beldat  | .        |
Then setting field "kstelle" to "10" throws the exception "3602"
And I set field "kstelle" to "5500"
And I append rows
| mge | platz2 |
| 10  | F1     |
 And I save the current editor
 
Scenario: 02 Bestandskorrektur
Given I open an editor "Bestandskorrektur" for tip command "LBestand" and arguments ""
And I set fields
        | artikel       | E2    |
        | beleg         | B_E2  |
        | beldat        | .     |
Then setting field "kstelle" to "10" throws the exception "3602"
And I set field "kstelle" to "5300"
And I set field "platz" to "F1" in row 1
And I modify table
        | !row                  | mge   |
        | platz=='F1'           | 20    |
And I save the current editor

Scenario: 03 Mischpreis setzen
Given I open an editor "MprSetzen" from table "(ManualStockAdjustment):(SetMixedPrice)" with command "NEW" for record ""
And I set fields
| artikel | E1       |
| beleg   | BMPR_E1  |
| beldat  | .        |
Then setting field "kstelle" to "10" throws the exception "3602"
And I set field "kstelle" to "5500"
And I set field "mge" to "3" in row 1
And I set field "mmpr" to "30" in row 1
And I save the current editor
 
 
 
