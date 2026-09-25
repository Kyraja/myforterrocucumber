# *****************************************************************************
#  Name             : LIQPLAN_steuer_02_01_edit_szenario.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : IS LIQPLAN: Angabe von Zeile im Szenario
#
#
#                     Parallel werden auch IS LIQPLANDETAILS-Aufrufe bzw Uebergaenge
#                     aus IS LIQPLAN nach IS LIQPLANDETAILS getestet.
#                     indirekt: Test von FO-Funktion F|taxamount
#
#
# *****************************************************************************

@persistent
Feature: LIQPLAN_steuer_02_01_edit_szenario.feature
Background: MMM

Given I set the fake date to "07.01.1995"

Scenario: zu grosse Zeile angegeben
# Liqui-Planung + Steuer

Given I open an editor "LiquiPlan" from table "(PaymentMasterFiles):(LiquidityPlanningScenario)" with command "STORE" for record "ABC1"
And I set fields
| such           | abc1               |
| ekredataktdat  | ja                 |
| vkredataktdat  | ja                 |
| ustvazeitraum  | monatlich          |
| ustzahltag     | 15                 |
| ustzahlmon     | 1                  |
| ustvaakt       | 2020               |
| ustpossteuer   | 242G               |
| ustpossteuerzn | 200                |
Then saving the current editor throws the exception "2007"
And I set field "ustpossteuerzn" to "0"
And I save the current editor

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Scenario: keine Zeile angegeben

Given I open an editor "LiquiPlan" from table "(PaymentMasterFiles):(LiquidityPlanningScenario)" with command "UPDATE" for record "STD"
Then field "ustpossteuerzn" has value "37" in row 0
And I set field "ustpossteuerzn" to "0"
And I save the current editor


# Liquiditätsplanung öffnen (Planung monatlich, Formular monatlich)
# (Infosystem) LIQPLAN
Given I open the infosystem "LIQPLAN"
And I press button "bstart"
Then table has values
|tposition                       |tekvk  |twert0|twert1|twert2|twert3|twert4  |twert5  |twert6  |twert7  |twert8  |twert9  |twert10 |twert11 |twert12 |twert13  |tzeilensum|
|Eigene liquide Mittel (AB)      |       |      |      |      |-11.15|-11.15  |4117.70 |4117.70 |4117.70 |3654.55 |3654.55 |9163.40 |9163.40 |8520.25 |8520.25  |          |
|Kreditlinie (AB)                |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zahlungsmittel (AB)             |       |      |      |      |-11.15|-11.15  |4117.70 |4117.70 |4117.70 |3654.55 |3654.55 |9163.40 |9163.40 |8520.25 |8520.25  |          |
|Offene Posten                   |Verkauf|      |      |      |      |        |        |        |115.00  |        |        |        |115.00  |        |2530.00  |2760.00   |
|Rechnungsobligo                 |Verkauf|      |      |      |      |4140.00 |        |        |        |        |5520.00 |        |        |        |-9660.00 |          |
|Lieferobligo                    |Verkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |13800.00 |13800.00  |
|Sonstige Einzahlungen           |Verkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Einzahlungen gesamt             |       |      |      |      |      |4140.00 |        |        |115.00  |        |5520.00 |        |115.00  |        |6670.00  |16560.00  |
|Offene Posten                   |Einkauf|      |      |11.15 |      |11.15   |        |        |11.15   |        |11.15   |        |11.15   |        |211.94   |267.69    |
|Rechnungsobligo                 |Einkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Lieferobligo                    |Einkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Sonstige Auszahlungen           |Einkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Auszahlungen gesamt             |       |      |      |11.15 |      |11.15   |        |        |11.15   |        |11.15   |        |11.15   |        |211.94   |267.69    |
|Liquiditätssaldo I             |       |      |      |-11.15|      |4128.85 |        |        |103.85  |        |5508.85 |        |103.85  |        |6458.06  |          |
|Gebuchte Umsatzsteuerzahllast   |       |      |      |      |      |        |        |        |27.00   |        |        |        |27.00   |        |297.00   |351.00    |
|Umsatzsteuerzahllast aus Obligos|       |      |      |      |      |        |        |        |540.00  |        |        |        |720.00  |        |540.00   |1800.00   |
|Zinssatz Bereitstellung (%)     |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zinsen Bereitstellung           |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zinssatz Inanspruchnahme (%)    |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zinsen Inanspruchnahme          |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Weitere Belastungen gesamt      |       |      |      |      |      |        |        |        |567.00  |        |        |        |747.00  |        |837.00   |2151.00   |
|Liquiditätssaldo II            |       |      |      |-11.15|      |4128.85 |        |        |-463.15 |        |5508.85 |        |-643.15 |        |5621.06  |          |
|Eigene liquide Mittel (EB)      |       |      |      |-11.15|-11.15|4117.70 |4117.70 |4117.70 |3654.55 |3654.55 |9163.40 |9163.40 |8520.25 |8520.25 |14141.31 |          |
|Kreditlinie (EB)                |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zahlungsmittel (EB)             |       |      |      |-11.15|-11.15|4117.70 |4117.70 |4117.70 |3654.55 |3654.55 |9163.40 |9163.40 |8520.25 |8520.25 |14141.31 |          |
|Inanspruchnahme Kreditlinie abs.|       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Inanspruchnahme Kreditlinie (%) |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Änderung Kreditvolumen         |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
# Wechsel in LIQPLANDETAILS
And I press button "twertnachws7" to open a subeditor for "" in row 15
And I press button "bstart"
Then the table has 1 rows
# Kopffelder
Then field "stichtag" has value "07.01.1995" in row 0
Then field "position" has value "Gebuchte Umsatzsteuerzahllast" in row 0
Then field "periodevon" has value "7" in row 0
Then field "periodebis" has value "7" in row 0
Then field "planszenario" has value "STD" in row 0
Then field "zeiteinheit" has value "Woche" in row 0
# Tabellenfelder
Then field "tterm" has value "15.02.1995" in row 1
Then field "tzabetr" has value "27.00" in row 1
Then field "tbelegtyp" has value "Umsatzsteuervoranmeldung" in row 1
#
Then field "tbelzeigen" is modifiable in row 1
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Scenario: falsche Zeile angegeben

Given I open an editor "LiquiPlan" from table "(PaymentMasterFiles):(LiquidityPlanningScenario)" with command "UPDATE" for record "STD"
Then field "ustpossteuerzn" has value "0" in row 0
# richtige Zeile waere 37
And I set field "ustpossteuerzn" to "2"
And I save the current editor


# Liquiditätsplanung öffnen (Planung monatlich, Formular monatlich)
# (Infosystem) LIQPLAN
Given I open the infosystem "LIQPLAN"
And I press button "bstart"
Then table has values
|tposition                       |tekvk  |twert0|twert1|twert2|twert3|twert4  |twert5  |twert6  |twert7  |twert8  |twert9  |twert10 |twert11 |twert12 |twert13  |tzeilensum|
|Eigene liquide Mittel (AB)      |       |      |      |      |-11.15|-11.15  |4117.70 |4117.70 |4117.70 |3654.55 |3654.55 |9163.40 |9163.40 |8520.25 |8520.25  |          |
|Kreditlinie (AB)                |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zahlungsmittel (AB)             |       |      |      |      |-11.15|-11.15  |4117.70 |4117.70 |4117.70 |3654.55 |3654.55 |9163.40 |9163.40 |8520.25 |8520.25  |          |
|Offene Posten                   |Verkauf|      |      |      |      |        |        |        |115.00  |        |        |        |115.00  |        |2530.00  |2760.00   |
|Rechnungsobligo                 |Verkauf|      |      |      |      |4140.00 |        |        |        |        |5520.00 |        |        |        |-9660.00 |          |
|Lieferobligo                    |Verkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |13800.00 |13800.00  |
|Sonstige Einzahlungen           |Verkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Einzahlungen gesamt             |       |      |      |      |      |4140.00 |        |        |115.00  |        |5520.00 |        |115.00  |        |6670.00  |16560.00  |
|Offene Posten                   |Einkauf|      |      |11.15 |      |11.15   |        |        |11.15   |        |11.15   |        |11.15   |        |211.94   |267.69    |
|Rechnungsobligo                 |Einkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Lieferobligo                    |Einkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Sonstige Auszahlungen           |Einkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Auszahlungen gesamt             |       |      |      |11.15 |      |11.15   |        |        |11.15   |        |11.15   |        |11.15   |        |211.94   |267.69    |
|Liquiditätssaldo I             |       |      |      |-11.15|      |4128.85 |        |        |103.85  |        |5508.85 |        |103.85  |        |6458.06  |          |
|Gebuchte Umsatzsteuerzahllast   |       |      |      |      |      |        |        |        |27.00   |        |        |        |27.00   |        |297.00   |351.00    |
|Umsatzsteuerzahllast aus Obligos|       |      |      |      |      |        |        |        |540.00  |        |        |        |720.00  |        |540.00   |1800.00   |
|Zinssatz Bereitstellung (%)     |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zinsen Bereitstellung           |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zinssatz Inanspruchnahme (%)    |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zinsen Inanspruchnahme          |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Weitere Belastungen gesamt      |       |      |      |      |      |        |        |        |567.00  |        |        |        |747.00  |        |837.00   |2151.00   |
|Liquiditätssaldo II            |       |      |      |-11.15|      |4128.85 |        |        |-463.15 |        |5508.85 |        |-643.15 |        |5621.06  |          |
|Eigene liquide Mittel (EB)      |       |      |      |-11.15|-11.15|4117.70 |4117.70 |4117.70 |3654.55 |3654.55 |9163.40 |9163.40 |8520.25 |8520.25 |14141.31 |          |
|Kreditlinie (EB)                |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zahlungsmittel (EB)             |       |      |      |-11.15|-11.15|4117.70 |4117.70 |4117.70 |3654.55 |3654.55 |9163.40 |9163.40 |8520.25 |8520.25 |14141.31 |          |
|Inanspruchnahme Kreditlinie abs.|       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Inanspruchnahme Kreditlinie (%) |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Änderung Kreditvolumen         |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
# Wechsel in LIQPLANDETAILS
And I press button "twertnachws7" to open a subeditor for "" in row 15
And I press button "bstart"
Then the table has 1 rows
# Kopffelder
Then field "stichtag" has value "07.01.1995" in row 0
Then field "position" has value "Gebuchte Umsatzsteuerzahllast" in row 0
Then field "periodevon" has value "7" in row 0
Then field "periodebis" has value "7" in row 0
Then field "planszenario" has value "STD" in row 0
Then field "zeiteinheit" has value "Woche" in row 0
# Tabellenfelder
Then field "tterm" has value "15.02.1995" in row 1
Then field "tzabetr" has value "27.00" in row 1
Then field "tbelegtyp" has value "Umsatzsteuervoranmeldung" in row 1
#
Then field "tbelzeigen" is modifiable in row 1
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

