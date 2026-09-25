@persistent
Feature: BEZUGSGROESSE_Skipfeldertest
Background:
Given I set the fake date to "02.01.2002"

# *****************************************************************************
#  Name             : Bezugsgröße: Test der Skipfelder
#  Autor            : Silvia Warth
#  Verantwortlich   : sih
#  Kontrolle        : wane
#  Funktion         : Test der korrekten Belegung der Skipfelder in einer Bezugsgröße
#
# *****************************************************************************

Scenario: Bezugsgroesse laden und Skipfelder ausgeben
Given I open an editor "eh" from table "(Unit):(Unit)" with command "UPDATE" for record "maschin"
# 6-stellig
And I set field "einheit" to "maschi"
And I respond with answer "no" to the dialog with id "10951"
And I save the current editor

Given I open an editor "eh" from table "(Unit):(Unit)" with command "UPDATE" for record "anzma"
# 6-stellig
And I set field "einheit" to "anzmar"
And I respond with answer "no" to the dialog with id "10951"
And I save the current editor

Given I open an editor "bg" from table "(ActivityBase):(ActivityBase)" with command "NEW" for record ""
And I set field "such" to "bg-km"
And I set field "einheitbz" to "km"
And I save the current editor

Given I open an editor "bg" from table "(ActivityBase):(ActivityBase)" with command "NEW" for record ""
And I set field "such" to "bg-ma"
And I set field "einheit" to "maschin"
And I save the current editor

Given I open an editor "bg" from table "(ActivityBase):(ActivityBase)" with command "NEW" for record ""
And I set field "such" to "bg-am"
And I set field "einheit" to "anzma"
And I save the current editor

# Bezugsgröße in Kostenstelle eintragen
Given I open an editor "ks" from table "(Account):(CostCenter)" with command "UPDATE" for record "100"
And I set field "bezug" to "bg-am"
And I save the current editor

Given I open an editor "ks" from table "(Account):(CostCenter)" with command "UPDATE" for record "101"
And I set field "bezug" to "bg-ma"
And I save the current editor

# Bezugsgröße laden und Skipfelder ausgeben
Given I open an editor "bg" from table "(ActivityBase):(ActivityBase)" with command "VIEW" for record "bg-km"
Then field "abk" has value "km"
Then field "sald" has value "ja"
Then field "rest" has value "nein"
And I close the current editor

# Bezugsgröße laden und Skipfelder ausgeben: insbesondere die Abkürzung der Einheit
Given I open an editor "bg" from table "(ActivityBase):(ActivityBase)" with command "VIEW" for record "bg-ma"
Then field "abk" has value "maschi"
Then field "sald" has value "ja"
Then field "rest" has value "nein"
And I close the current editor

Given I open an editor "bg" from table "(ActivityBase):(ActivityBase)" with command "VIEW" for record "bg-am"
Then field "abk" has value "anzmar"
Then field "sald" has value "nein"
Then field "rest" has value "nein"
And I close the current editor

# Kostenstelle laden und ausgeben: insbesondere die Abkürzung der Einheit der Bezugsgröße
Given I open an editor "ks" from table "(Account):(CostCenter)" with command "VIEW" for record "100"
Then field "bezug" has value "3"
Then field "abk" has value "anzmar"
And I close the current editor

Given I open an editor "ks" from table "(Account):(CostCenter)" with command "VIEW" for record "101"
Then field "bezug" has value "2"
Then field "abk" has value "maschi"
And I close the current editor

