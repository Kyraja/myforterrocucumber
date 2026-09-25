# *****************************************************************************
#  Name             : ref_rdiff_fw_f288_001_einkauf.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Rundungsdifferenzen im Einkauf unter Flagge 288 (Bulgarienflagge)
#
#
# *****************************************************************************

@persistent
Feature: Rundungsdifferenzen im Einkauf unter Flagge 288
Background: Rundungsdifferenzen im Einkauf unter Flagge 288

Scenario: "Rundungsdifferenz auf Bemessungsgrundlage addieren" im Einkauf

# #########    Start: Vorbereitung      #########

# Art der Verbuchng von Rundungsdifferenzen auf "Rundungsdifferenz auf Bemessungsgrundlage addieren" umstellen
Given I open an editor "zposition" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "4"
And I set field "verbrdiff" to "Rundungsdifferenz auf Bemessungsgrundlage addieren"
And I save the current editor
And I close the current editor

# OP-Relevanz einschalten
Given I open an editor "zposition" from table "(Account):(Account)" with command "UPDATE" for record "50000"
And I set field "oprel" to "ja"
And I save the current editor
And I close the current editor
# #########    Ende: Vorbereitung      #########

# Given I'm logged in with password "sy"

Given I enable the flag 288


# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "num4" to "777PP"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "erfwaehr" to "DKK"
And I set field "ewekurs" to "4.645100"
Then field "iwbu" has value "DEM"
Then field "kursfix" has value "ja"
And I set field "vom" to "."
And I set field "budat" to "15.01.95"
And I create a new row at the end of the table
And I set field "artikel" to "TEXT" in row 1
And I set field "pwert" to "-390.00" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# ########   Pruefen   ########
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,ursache=Einkauf;kenn=DI;@richtung=rückwärts;@maxtreffer=1"
# Kopf
Then field "ewekurs" has value "4.645100"
Then field "eweinh" has value "100"
Then field "uw" has value "DEM"
Then field "kursfix" has value "ja"
Then field "ursache" has value "Einkauf"
Then field "buartrdiff" has value "Rundungsdifferenzzeile"
Then field "artst" has value "Steuer pro Summe der Nettobeträge"
# Tabelle
Then the table has 4 rows
Then table has values
|konto  |karta                 |ewsbetr |ewhbetr |steuer|sbetrag|hbetrag|
|L 001  |                      |   0.00 |-448.50 |    0 |  0.00 |-20.83 |
|50000  |                      |-390.00 |   0.00 |    1 |-18.12 |  0.00 |
|14060  |Steuerkonto           | -58.50 |   0.00 |    1 | -2.72 |  0.00 |
|48420  |Rundungsdifferenzkonto|   0.00 |   0.00 |    0 |  0.00 | -0.01 |
And I close the current editor
##############################################################################################################

Scenario: "Rundungsdifferenz auf Steuerbetrag addieren" im Einkauf

# #########    Start: Vorbereitung      #########

# Art der Verbuchng von Rundungsdifferenzen auf "Rundungsdifferenz auf Bemessungsgrundlage addieren" umstellen
Given I open an editor "zposition" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "4"
And I set field "verbrdiff" to "Rundungsdifferenz auf Steuerbetrag addieren"
And I save the current editor
And I close the current editor

# OP-Relevanz einschalten
Given I open an editor "zposition" from table "(Account):(Account)" with command "UPDATE" for record "50000"
And I set field "oprel" to "ja"
And I save the current editor
And I close the current editor

# OP-Relevanz einschalten
Given I open an editor "zposition" from table "(Account):(Account)" with command "UPDATE" for record "14060"
And I set field "oprel" to "ja"
And I save the current editor
And I close the current editor
# #########    Ende: Vorbereitung      #########

Given I enable the flag 288

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "num4" to "777PP"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "erfwaehr" to "DKK"
And I set field "ewekurs" to "4.645100"
Then field "iwbu" has value "DEM"
Then field "kursfix" has value "ja"
And I set field "vom" to "."
And I set field "budat" to "15.01.95"
And I create a new row at the end of the table
And I set field "artikel" to "TEXT" in row 1
And I set field "pwert" to "-390.00" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# ########   Pruefen   ########
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,ursache=Einkauf;kenn=DI;@richtung=rückwärts;@maxtreffer=1"
# Kopf
Then field "ewekurs" has value "4.645100"
Then field "eweinh" has value "100"
Then field "uw" has value "DEM"
Then field "kursfix" has value "ja"
Then field "ursache" has value "Einkauf"
Then field "buartrdiff" has value "Rundungsdifferenzzeile"
Then field "artst" has value "Steuer pro Summe der Nettobeträge"
# Tabelle
Then the table has 4 rows
Then table has values
|konto  |karta                 |ewsbetr |ewhbetr |steuer|sbetrag|hbetrag|
|L 001  |                      |   0.00 |-448.50 |    0 |  0.00 |-20.83 |
|50000  |                      |-390.00 |   0.00 |    1 |-18.12 |  0.00 |
|14060  |Steuerkonto           | -58.50 |   0.00 |    1 | -2.72 |  0.00 |
|48420  |Rundungsdifferenzkonto|   0.00 |   0.00 |    0 |  0.00 | -0.01 |
And I close the current editor
##############################################################################################################

