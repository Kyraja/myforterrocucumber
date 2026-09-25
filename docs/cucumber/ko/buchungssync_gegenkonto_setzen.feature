@persistent
Feature: Buchungssynchronisation bei statistischen Buchungen mit KV-Rest
Background:
Given I set the fake date to "20.12.1995"

# *****************************************************************************
#  Name             : Buchungssynchronisation bei statistischen Buchungen mit KV-Rest
#  Autor            : Silvia Warth
#  Verantwortlich   : sih
#  Kontrolle        : uo
#  Funktion         : Test 
#              * es gibt mindestens eine statistische Buchung mit einem Kostenverteiler in einer Buchungszeile, der einen Restbetrag im Kopf (kvbrest) hat
#              * der Buchungssynchronisation mit allen Arten  
#               
#
# *****************************************************************************


Scenario: 01 statistische Buchung mit Kostenverteiler
Given I open an editor "StatBuchung1" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
And I set field "budat" to "."
And I create a new row at the end of the table
And I set field "konto" to "99800" in row 1
And I set field "sbetrag" to "10608" in row 1
# dyn. KV erzeugen
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "112" in row 1
And I set field "proz" to "22.1" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "113" in row 2
And I set field "proz" to "17.3" in row 2
And I create a new row at the end of the table
And I set field "kstelle" to "114" in row 3
And I set field "proz" to "60.6" in row 3
#
And I set field "betr" to "1835,19" in row 2
And I save the current subeditor to switch back to the parent editor
#
And I create a new row at the end of the table
And I set field "konto" to "99800" in row 2
And I set field "kstelle" to "117" in row 2
And I set field "sbetrag" to "1960" in row 2
#
And I create a new row at the end of the table
And I set field "konto" to "99900" in row 3
And I set field "kstelle" to "118" in row 3
#
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

Scenario: 02 Buchungssynchronisation: Gegenkonto setzen (mit Wartung)
Given I'm logged in with password "annette"
Given I open an editor "Buchungssync" from table "(AcctngMasterFiles):(EntrySynchronisation)" with command "NEW" for record ""
And I set fields
| such  | gegen             |
| bsart | Gegenkonto setzen |
And I save the current editor
#
Given I open an editor "Buchungssync" from table "(AcctngMasterFiles):(EntrySynchronisation)" with command "UPDATE" for record "gegen"
And I press button "bstart"
And I save the current editor
Given I'm logged in with password "sy"

Scenario: 03 statistische Buchung neu mit Kostenverteiler mit Rest 0,03 Cent
Given I open an editor "kv-1" from table "(Account):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "kvstat1"
And I create a new row at the end of the table
And I set field "kstelle" to "116" in row 1
And I set field "proz" to "33.3" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "117" in row 2
And I set field "proz" to "17.8" in row 2
And I create a new row at the end of the table
And I set field "kstelle" to "118" in row 3
And I set field "proz" to "48.9" in row 3
And I save the current editor


Given I open an editor "StatBuchung2" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
And I set field "budat" to "."
And I create a new row at the end of the table
And I set field "konto" to "99800" in row 1
And I set field "sbetrag" to "1234.56" in row 1
And I set field "kstelle" to "kvstat1" in row 1
# dyn. KV erzeugen
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
And I set field "betr" to "411.08" in row 1
And I save the current subeditor to switch back to the parent editor
#
And I create a new row at the end of the table
And I set field "konto" to "99800" in row 2
And I set field "kstelle" to "117" in row 2
#
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

Scenario: 04 statistische Buchung neu mit Rest 0,01 Cent (und dann Buchung aendern und im KV Rest auf 0,03 Cent)
Given I open an editor "StatBuchung3" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
And I set field "such" to "bu-rs-2"
And I set field "budat" to "."
And I create a new row at the end of the table
And I set field "konto" to "99800" in row 1
And I set field "sbetrag" to "1234.56" in row 1
And I set field "kstelle" to "kvstat1" in row 1
# dyn. KV erzeugen
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
And I set field "betr" to "411.10" in row 1
And I save the current subeditor to switch back to the parent editor
#
And I create a new row at the end of the table
And I set field "konto" to "99800" in row 2
And I set field "kstelle" to "117" in row 2
#
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

Scenario: 05 statistische Buchung aendern und im KV Rest auf 0,03 Cent
Given I open an editor "StatBuchung4" from table "(Entry):(StatisticalEntry)" with command "UPDATE" for record "bu-rs-2"
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
And I set field "betr" to "411.08" in row 1
And I save the current subeditor to switch back to the parent editor
#
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

Scenario: 06 Konto 99800 andere Kostenart zuordnen
Given I open an editor "konto" from table "(Account):(Account)" with command "UPDATE" for record "99800"
And I set field "zkoart" to "99999999" in row 1
And I save the current editor

Scenario: 07 Buchungssynchronisation: Kostenrechnung - Ergänzung der Buchungen (ohne Wartung)
Given I open an editor "Buchungssync" from table "(AcctngMasterFiles):(EntrySynchronisation)" with command "NEW" for record ""
And I set fields
| such    | kore                                     |
| bsart   | Kostenrechnung: Ergaenzung der Buchungen |
| bspgj   | 94                                       |
| bspbukr | Alle Buchungskreise                      |

And I save the current editor
#
Given I open an editor "Buchungssync" from table "(AcctngMasterFiles):(EntrySynchronisation)" with command "UPDATE" for record "kore"
And I press button "bstart"
And I save the current editor

Scenario: 08 Buchungssynchronisation: Kostenrechnung - Ergänzung der Buchungen (mit Wartung)
Given I'm logged in with password "annette"
Given I open an editor "Buchungssync" from table "(AcctngMasterFiles):(EntrySynchronisation)" with command "NEW" for record ""
And I set fields
| such    | kore-koart                               |
| bsart   | Kostenrechnung: Ergaenzung der Buchungen |
| bspgj   | 94                                       |
| bspbukr | Alle Buchungskreise                      |

And I save the current editor
#
Given I open an editor "Buchungssync" from table "(AcctngMasterFiles):(EntrySynchronisation)" with command "UPDATE" for record "kore-koart"
And I press button "bstart"
And I save the current editor
Given I'm logged in with password "sy"

Scenario: 09 Buchungssynchronisation: Nur VKZ Kostenrechnung (mit Wartung)
Given I'm logged in with password "annette"
Given I open an editor "Buchungssync" from table "(AcctngMasterFiles):(EntrySynchronisation)" with command "NEW" for record ""
And I set fields
| such    | kore-vkz                                 |
| bsart   | Nur Verkehrszahlen Kostenrechnung        |
| bspgj   | 94                                       |
| bspbukr | Alle Buchungskreise                      |

And I save the current editor
#
Given I open an editor "Buchungssync" from table "(AcctngMasterFiles):(EntrySynchronisation)" with command "UPDATE" for record "kore-vkz"
And I respond with answer "ja" to the dialog with id "7440"
And I press button "bstart"
And I save the current editor
Given I'm logged in with password "sy"

Scenario: 10 Buchungssynchronisation: Alle VKZ und UZ (mit Wartung)
Given I'm logged in with password "annette"
Given I open an editor "Buchungssync" from table "(AcctngMasterFiles):(EntrySynchronisation)" with command "NEW" for record ""
And I set fields
| such    | alle-vkz                                 |
| bsart   | alle Verkehrszahlen und Umsatzzaehler    |
| bspgj   | 94                                       |
| bspbukr | Alle Buchungskreise                      |

And I save the current editor
#
Given I open an editor "Buchungssync" from table "(AcctngMasterFiles):(EntrySynchronisation)" with command "UPDATE" for record "alle-vkz"
And I respond with answer "ja" to the dialog with id "7440"
And I press button "bstart"
And I save the current editor
Given I'm logged in with password "sy"

Scenario: 11 Projektkostenrechnung aktivieren, Projekt und Bilanzkostenart anlegen
Given I open an editor "konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I press button "bsperremand"
And I set field "projekt" to "ja"
And I save the current editor
And I close the current editor

Given I open an editor "Termine" from table "(Company):(FinancialDates)" with command "UPDATE" for record "TERM"
And I set field "pkbabkoartgj" to "95"
And I set field "pkbabkoartgm" to "1"
And I save the current editor
And I close the current editor

Given I open an editor "pr" from table "(Transaction):(Project)" with command "NEW" for record ""
And I set field "such" to "P100"
And I save the current editor
And I close the current editor

Given I open an editor "kostenart" from table "(CostType):(CostType)" with command "NEW" for record ""
And I set field "nummer" to "999"
And I set field "such" to "bilkoart"
And I set field "bilkostart" to "ja"
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "UPDATE" for record "10000"
And I create a new row at the end of the table
And I set field "zkoart" to "999" in row 1
And I save the current editor
And I close the current editor


Scenario: 12 Buchungserzeugung Finanz- und statistische Buchung mit Projekt
# Finanzbuchung
Given I open an editor "Buchung1" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "budat" to "."
And I create a new row at the end of the table
And I set field "konto" to "10000" in row 1
And I set field "sbetrag" to "10608" in row 1
And I set field "projekt" to "P100" in row 1
#
And I create a new row at the end of the table
And I set field "konto" to "11400" in row 2
And I set field "sbetrag" to "1960" in row 2
And I set field "projekt" to "P100" in row 2
#
And I create a new row at the end of the table
And I set field "konto" to "K 1" in row 3
#
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

# Statistische Buchung
Given I open an editor "StatBuchung6" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
And I set field "budat" to "."
And I create a new row at the end of the table
And I set field "konto" to "99800" in row 1
And I set field "sbetrag" to "10608" in row 1
And I set field "projekt" to "P100" in row 1
# dyn. KV erzeugen
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "112" in row 1
And I set field "proz" to "22.1" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "113" in row 2
And I set field "proz" to "17.3" in row 2
And I create a new row at the end of the table
And I set field "kstelle" to "114" in row 3
And I set field "proz" to "60.6" in row 3
#
And I set field "betr" to "1835,19" in row 2
And I save the current subeditor to switch back to the parent editor
#
And I create a new row at the end of the table
And I set field "konto" to "99800" in row 2
And I set field "projekt" to "P100" in row 2
And I set field "kstelle" to "117" in row 2
And I set field "sbetrag" to "1960" in row 2
#
And I create a new row at the end of the table
And I set field "konto" to "99900" in row 3
And I set field "projekt" to "P100" in row 3
And I set field "kstelle" to "118" in row 3
#
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

Scenario: 13 Buchungssynchronisation: Projektkostenrechnung - Ergänzung der Buchungen (ohne Wartung)
Given I open an editor "Buchungssync" from table "(AcctngMasterFiles):(EntrySynchronisation)" with command "NEW" for record ""
And I set fields
| such    | pkr-koart                                         |
| bsart   | Projektkostenrechnung: Ergaenzung der Buchungen   |
| bspgj   | 94                                                |
| bspbukr | Alle Buchungskreise                               |

And I save the current editor
#
Given I open an editor "Buchungssync" from table "(AcctngMasterFiles):(EntrySynchronisation)" with command "UPDATE" for record "pkr-koart"
And I press button "bstart"
And I save the current editor

Scenario: 14 Buchungssynchronisation: Projektkostenrechnung - Ergänzung der Buchungen (mit Wartung)
Given I'm logged in with password "annette"
Given I open an editor "Buchungssync" from table "(AcctngMasterFiles):(EntrySynchronisation)" with command "NEW" for record ""
And I set fields
| such    | pkr-koart                                         |
| bsart   | Projektkostenrechnung: Ergaenzung der Buchungen   |
| bspgj   | 94                                                |
| bspbukr | Alle Buchungskreise                               |

And I save the current editor
#
Given I open an editor "Buchungssync" from table "(AcctngMasterFiles):(EntrySynchronisation)" with command "UPDATE" for record "pkr-koart"
And I press button "bstart"
And I save the current editor
Given I'm logged in with password "sy"









