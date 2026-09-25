# *****************************************************************************
#  Name             : ref_rdiff_fw_f288_002_buchung.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Rundungsdifferenzen in Buchungen unter Flagge 288 (Bulgarienflagge)
#
#
# *****************************************************************************

@persistent
Feature: Rundungsdifferenzen in Buchungen unter Flagge 288
Background: Rundungsdifferenzen in Buchungen unter Flagge 288


Scenario: Rundungsdifferenz auf Bemessungsgrundlage addieren

# #########    Start: Vorbereitung      #########

# Art der Verbuchng von Rundungsdifferenzen auf "Rundungsdifferenz auf Bemessungsgrundlage addieren" umstellen
Given I open an editor "zposition" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "4"
And I set field "verbrdiff" to "Rundungsdifferenz auf Bemessungsgrundlage addieren"
And I save the current editor
And I close the current editor

# OP-Relevanz einschalten
Given I open an editor "zposition" from table "(Account):(Account)" with command "UPDATE" for record "54000"
And I set field "oprel" to "ja"
And I save the current editor
And I close the current editor
# #########    Ende: Vorbereitung      #########

#Given I'm logged in with password "annette"

Given I enable the flag 288

Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "budat" to "07.01.95"
And I set field "butyp" to "Allgemeine Finanzbuchung"
And I set field "inbukreis1" to "ja"
And I set field "inbukreis2" to "ja"

Then field "buartrdiff" has value "Rundungsdifferenz auf Bemessungsgrundlage addieren"
Then field "budat" is not empty in row 0
Then field "butyp" is not empty in row 0
Then field "kenn" has value "DI"

And I set field "erfwaehr" to "DKK"
And I set field "ewekurs" to "4.645100"
Then field "ewekurs" has value "4.645100"
Then field "eweinh" has value "100"
Then field "uw" has value "DEM"
Then field "kursfix" has value "ja"
And I create a new row at the end of the table
And I set field "konto" to "L 004" in row 1
And I set field "ewhbetr" to "-448.50" in row 1
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 2
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

# ########   Pruefen   ########
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,ursache=manuell;kenn=DI;@richtung=rückwärts;@maxtreffer=1"
# Kopf
Then field "ewekurs" has value "4.645100"
Then field "eweinh" has value "100"
Then field "uw" has value "DEM"
Then field "kursfix" has value "ja"
Then field "ursache" has value "manuell"
Then field "buartrdiff" has value "Rundungsdifferenz auf Bemessungsgrundlage addieren"
Then field "artst" has value "Steuer pro Nettobetrag"
# Tabelle
Then the table has 4 rows
Then table has values
|konto  |karta                 |ewsbetr |ewhbetr |steuer|sbetrag|hbetrag|
|L 004  |                      |   0.00 |-448.50 |    0 |  0.00 |-20.83 |
|54000  |                      |-390.00 |   0.00 |    1 |-18.12 |  0.00 |
|14060  |Steuerkonto           | -58.50 |   0.00 |    1 | -2.72 |  0.00 |
|48420  |Rundungsdifferenzkonto|   0.00 |   0.00 |    0 |  0.00 | -0.01 |
And I close the current editor
##############################################################################################################


Scenario: Rundungsdifferenz auf Steuerbetrag addieren

# #########    Start: Vorbereitung      #########

# Art der Verbuchng von Rundungsdifferenzen auf "Rundungsdifferenz auf Bemessungsgrundlage addieren" umstellen
Given I open an editor "zposition" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "4"
And I set field "verbrdiff" to "Rundungsdifferenz auf Steuerbetrag addieren"
And I save the current editor
And I close the current editor

# OP-Relevanz einschalten
Given I open an editor "zposition" from table "(Account):(Account)" with command "UPDATE" for record "14060"
And I set field "oprel" to "ja"
And I save the current editor
And I close the current editor
# #########    Ende: Vorbereitung      #########


Given I enable the flag 288

Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "budat" to "07.01.95"
And I set field "butyp" to "Allgemeine Finanzbuchung"
And I set field "inbukreis1" to "ja"
And I set field "inbukreis2" to "ja"

Then field "buartrdiff" has value "Rundungsdifferenz auf Steuerbetrag addieren"
Then field "budat" is not empty in row 0
Then field "butyp" is not empty in row 0
Then field "kenn" has value "DI"

And I set field "erfwaehr" to "DKK"
And I set field "ewekurs" to "4.645100"
Then field "ewekurs" has value "4.645100"
Then field "eweinh" has value "100"
Then field "uw" has value "DEM"
Then field "kursfix" has value "ja"
And I create a new row at the end of the table
And I set field "konto" to "L 004" in row 1
And I set field "ewhbetr" to "-448.50" in row 1
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 2
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

# ########   Pruefen   ########
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,ursache=manuell;kenn=DI;@richtung=rückwärts;@maxtreffer=1"
# Kopf
Then field "ewekurs" has value "4.645100"
Then field "eweinh" has value "100"
Then field "uw" has value "DEM"
Then field "kursfix" has value "ja"
Then field "ursache" has value "manuell"
Then field "buartrdiff" has value "Rundungsdifferenz auf Steuerbetrag addieren"
Then field "artst" has value "Steuer pro Nettobetrag"

# Tabelle
Then the table has 4 rows
Then table has values
|konto  |karta                 |ewsbetr |ewhbetr |steuer|sbetrag|hbetrag|
|L 004  |                      |   0.00 |-448.50 |    0 |  0.00 |-20.83 |
|54000  |                      |-390.00 |   0.00 |    1 |-18.12 |  0.00 |
|14060  |Steuerkonto           | -58.50 |   0.00 |    1 | -2.72 |  0.00 |
|48420  |Rundungsdifferenzkonto|   0.00 |   0.00 |    0 |  0.00 | -0.01 |
And I close the current editor
##############################################################################################################


