# *****************************************************************************
#  Name             : ref_ktoauszug_betragsstatus.feature
#  Autor            : jeffler
#  Verantwortlich   : hc
#  Kontrolle        : wane
#  Funktion         :  Der Test prüft die Belegung des Skipfeldes Betragsstatus im Bankkontoauszug (90:1).   
#                      Feld zeigt Icon:Ball an, sobald eine Zuordnung existiert (der Button Zuordnen gedrückt wurde).
#                      Icon ist:
#                      - BLAU  - wenn der die Zeile ganz oder teilweise ausgeschlossen ist.
#                      - ROT   - wenn der nicht zugeordnete Betrag gleich dem Zahlungsbetrag ist.
#                      - GELB  - wenn der nicht zugeordnete Betrag ungleich null und ungleich dem Zahlungsbetrag ist.
#                      - GRÜN  - wenn der nicht zugeordnete Betrag gleich null ist.
#
# *****************************************************************************
@persistent

Feature: ref_ktoauszug_betragsstatus
Background: Zahlungsverkehr

# #############################################################################

Scenario Outline: Nicht zugeordnet
Given I open an editor "Bankkontoauszug" from table "(Bankimport):(BankStatement)" with command "UPDATE" for record "3"
Then field "tztr" is empty in row <row>
Then field "toffen" has value "<toffen>" in row <row>
Then field "tbubetr" has value "<tbubetr>" in row <row>
Then field "tausbetr" has value "<tausbetr>" in row <row>
Then field "tbetragsstatus" is empty in row <row>
And I close the current editor

Examples:

|  toffen | tbubetr | tausbetr | row |
|  202.61 |  202.61 |     0.00 |   1 |
|  293.48 |  293.48 |     0.00 |   2 |
|  658.66 |  658.66 |     0.00 |   3 |
| 4139.38 | 4139.38 |     0.00 |   4 |

# #############################################################################

Scenario Outline: Automatische Zuordnung

Given I open an editor "Bankkontoauszug" from table "(Bankimport):(BankStatement)" with command "UPDATE" for record "3"
And I press button "bauto" to open a subeditor for "" in row 0
And I close the current subeditor to switch back to the parent editor
Then field "tztr" is not empty in row <row>
Then field "toffen" has value "<toffen>" in row <row>
Then field "tbubetr" has value "<tbubetr>" in row <row>
Then field "tausbetr" has value "<tausbetr>" in row <row>
Then field "tbetragsstatus" has value "<status>" in row <row>
And I save the current editor
And I close the current editor

Examples:

|  toffen | tbubetr | tausbetr |        status | row |
|  202.61 |  202.61 |     0.00 | icon:ball_red |   1 |
|  293.48 |  293.48 |     0.00 | icon:ball_red |   2 |
|  658.66 |  658.66 |     0.00 | icon:ball_red |   3 |
| 4139.38 | 4139.38 |     0.00 | icon:ball_red |   4 |

# #############################################################################

Scenario: Zeile vollständig ausschließen

Given I open an editor "Bankkontoauszug" from table "(Bankimport):(BankStatement)" with command "UPDATE" for record "3"
And I press button "tmanuell" to open a subeditor for "auszug_mzuord_1" in row 1
And I set field "ausschl" to "ja" in row 0
And I save the current editor
And I close the current subeditor to switch back to the parent editor

Then field "toffen" has value "202.61" in row 1
Then field "tbubetr" has value "202.61" in row 1
Then field "tausbetr" has value "202.61" in row 1
Then field "tbetragsstatus" has value "icon:ball_blue" in row 1
And I save the current editor
And I close the current editor

# #############################################################################

Scenario: Zeile teilweise ausschließen

Given I open an editor "Bankkontoauszug" from table "(Bankimport):(BankStatement)" with command "UPDATE" for record "3"
And I press button "tmanuell" to open a subeditor for "auszug_mzuord_2" in row 2
And I set field "ausschl" to "ja" in row 0
And I create a new row at the end of the table
And I set field "zmarke" to "ja" in row 1
And I set field "tkonto" to "18100" in row 1
And I set field "tbeleg" to "teilaus" in row 1
And I set field "tzabetr" to "50,48" in row 1
And I save the current editor
And I close the current subeditor to switch back to the parent editor

Then field "toffen" has value "243.00" in row 2
Then field "tbubetr" has value "293.48" in row 2
Then field "tausbetr" has value "243.00" in row 2
Then field "tbetragsstatus" has value "icon:ball_blue" in row 2
And I save the current editor
And I close the current editor

# #############################################################################

Scenario: Zeile vollständig zugeordnet

Given I open an editor "Bankkontoauszug" from table "(Bankimport):(BankStatement)" with command "UPDATE" for record "3"
And I press button "tmanuell" to open a subeditor for "auszug_mzuord_3" in row 3
And I create a new row at the end of the table
And I set field "zmarke" to "ja" in row 1
And I set field "tkonto" to "18100" in row 1
And I set field "tbeleg" to "komplzuo" in row 1
And I set field "tzabetr" to "658,66" in row 1
And I save the current editor
And I close the current subeditor to switch back to the parent editor

Then field "toffen" has value "0.00" in row 3
Then field "tbubetr" has value "658.66" in row 3
Then field "tausbetr" has value "0.00" in row 3
Then field "tbetragsstatus" has value "icon:ball_green" in row 3
And I save the current editor
And I close the current editor

# #############################################################################

Scenario: Zeile teilweise zugeordnet

Given I open an editor "Bankkontoauszug" from table "(Bankimport):(BankStatement)" with command "UPDATE" for record "3"
And I press button "tmanuell" to open a subeditor for "auszug_mzuord_4" in row 4
And I create a new row at the end of the table
And I set field "zmarke" to "ja" in row 1
And I set field "tkonto" to "18100" in row 1
And I set field "tbeleg" to "teilzuo" in row 1
And I set field "tzabetr" to "2100,24" in row 1
And I save the current editor
And I close the current subeditor to switch back to the parent editor

Then field "toffen" has value "2039.14" in row 4
Then field "tbubetr" has value "4139.38" in row 4
Then field "tausbetr" has value "0.00" in row 4
Then field "tbetragsstatus" has value "icon:ball_yellow" in row 4
And I save the current editor
And I close the current editor

# #############################################################################

Scenario: Zeile nicht zugeordnet

Given I open an editor "Bankkontoauszug" from table "(Bankimport):(BankStatement)" with command "UPDATE" for record "3"
And I press button "tmanuell" to open a subeditor for "auszug_mzuord_5" in row 1
And I set field "ausschl" to "nein" in row 0
And I save the current editor
And I close the current subeditor to switch back to the parent editor

Then field "toffen" has value "202.61" in row 1
Then field "tbubetr" has value "202.61" in row 1
Then field "tausbetr" has value "0.00" in row 1
Then field "tbetragsstatus" has value "icon:ball_red" in row 1

And I press button "tmanuell" to open a subeditor for "auszug_mzuord_5" in row 3
And I set field "zmarke" to "nein" in row 1
And I save the current editor
And I close the current subeditor to switch back to the parent editor

Then field "toffen" has value "658.66" in row 3
Then field "tbubetr" has value "658.66" in row 3
Then field "tausbetr" has value "0.00" in row 3
Then field "tbetragsstatus" has value "icon:ball_red" in row 3
And I save the current editor
And I close the current editor

# #############################################################################

Scenario: Ausschließen über Button

Given I open an editor "Bankkontoauszug" from table "(Bankimport):(BankStatement)" with command "UPDATE" for record "3"
And I press button "bausschl" to open a subeditor for "" in row 0
And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Scenario Outline: Prüfen der Werte nach Auschließen über Button

Given I open an editor "Bankkontoauszug" from table "(Bankimport):(BankStatement)" with command "UPDATE" for record "+3"
Then field "tztr" is empty in row <row>
Then field "toffen" has value "<toffen>" in row <row>
Then field "tbubetr" has value "<tbubetr>" in row <row>
Then field "tausbetr" has value "<tausbetr>" in row <row>
Then field "tbetragsstatus" has value "icon:ball_blue" in row <row>
And I save the current editor
And I close the current editor

Examples:

|  toffen | tbubetr | tausbetr | row |
|  202.61 |  202.61 |   202.61 |   1 |
|  293.48 |  293.48 |   293.48 |   2 |
|  658.66 |  658.66 |   658.66 |   3 |
| 4139.38 | 4139.38 |  4139.38 |   4 |

# #############################################################################

Scenario: Wiederaufleben

Given I open an editor "Bankkontoauszug" from table "(Bankimport):(BankStatement)" with command "UPDATE" for record "+3"
And I press button "baufleben" to open a subeditor for "" in row 0
And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Scenario Outline: Feldwerte prüfen nach Wiederaufleben

Given I open an editor "Bankkontoauszug" from table "(Bankimport):(BankStatement)" with command "UPDATE" for record "3"
Then field "tztr" is empty in row <row>
Then field "toffen" has value "<toffen>" in row <row>
Then field "tbubetr" has value "<tbubetr>" in row <row>
Then field "tausbetr" has value "<tausbetr>" in row <row>
Then field "tbetragsstatus" is empty in row <row>
And I save the current editor
And I close the current editor

Examples:

|  toffen | tbubetr | tausbetr | row |
|  202.61 |  202.61 |     0.00 |   1 |
|  293.48 |  293.48 |     0.00 |   2 |
|  658.66 |  658.66 |     0.00 |   3 |
| 4139.38 | 4139.38 |     0.00 |   4 |

# #############################################################################
