# *****************************************************************************
#  Name             : steuer_ustva_edit_003_plausis.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Plausis bei Editieren/Speichern von USTVA-Positionen
#
#
# *****************************************************************************
@persistent
Feature: steuer_ustva_edit_003_plausis.feature
Background: Plausis in USTVA-Positionen


Scenario: Aenderbarkeit im Kopf

# 
Given I open an editor "postion81_edit" from table "(Evaluation):(ItemNumber)" with command "UPDATE" for record "81"
Then field "nummer" is modifiable
Then field "such" is modifiable
Then field "meldungsnr" is modifiable
Then field "anteil" is modifiable
Then field "zmart" is modifiable
Then field "strund" is modifiable
Then field "waehr" is modifiable
Then field "w2ist" is modifiable
Then field "kenn" is modifiable
Then field "text" is modifiable
Then field "gjahr" is modifiable
Then field "selbukreis" is modifiable
Then field "bgjahr" is modifiable
Then field "bwaehr" is modifiable
Then field "ivkz" is modifiable
Then field "pvkz" is modifiable
#
Then field "ev" is not modifiable
Then field "postyp" is not modifiable
Then field "hatsteuer" is not modifiable
#
And I close the current editor


# als Wartung unterwegs
Given I'm logged in with password "annette"

Given I open an editor "postion81_edit2" from table "(Evaluation):(ItemNumber)" with command "UPDATE" for record "81"
Then field "nummer" is modifiable
Then field "such" is modifiable
Then field "meldungsnr" is modifiable
#
Then field "ev" is modifiable
Then field "postyp" is modifiable
Then field "hatsteuer" is modifiable
And I close the current editor

# Wartung aufgeben
Given I'm logged in with password "sy"


Given I open an editor "postion550_edit" from table "(Evaluation):(ItemNumber)" with command "UPDATE" for record "550"
#
Then field "nummer" is modifiable
Then field "such" is modifiable
Then field "meldungsnr" is not modifiable
#
Then field "ev" is modifiable
Then field "postyp" is modifiable
Then field "hatsteuer" is modifiable
#
And I close the current editor
#############################################################################################################################


Scenario: Kopf editieren: Buttons

Given I open an editor "postion81_edit2" from table "(Evaluation):(ItemNumber)" with command "UPDATE" for record "81"
#
# IST-VKZ
And I press button "ivkz" to open a subeditor for "IST_VKZ"
Then field "darta" is not modifiable
Then field "darta" has value "Ist"
Then field "awnum" is not modifiable
Then field "awnum" has value "81"
Then field "h1" is not empty
Then field "gjahr" is not modifiable
Then field "bukreis" is not modifiable
Then field "waehr" is not modifiable
#
And I close the current editor
And I switch the current editor to editor "postion81_edit2"
#
# PLAN-VKZ
# erwartet:  2919 TX=de   |Bewegungsdatensatz nicht vorhanden
# kommt:
# 2620 TX=de   |Objekt kann nicht geladen werden
# 2736 TX=de   |Aktion wurde wegen unbeantwortetem Dialog abgebrochen.
Then pressing button "pvkz" in row 0 to open a subeditor throws the exception "2620"
#
# aktuelles GJ
And I respond with answer "1" to the dialog with id "Geschäftsjahr"
And I press button "bgjahr"
#
And I respond with answer "2" to the dialog with id "Währung"
And I press button "bwaehr"
#
And I save the current editor
And I close the current editor
#############################################################################################################################


Scenario: Kopf editieren: itnummer

Given I open an editor "postion81_edit5" from table "(Evaluation):(ItemNumber)" with command "UPDATE" for record "81"
#
# gleiche Nummer wieder eintragen - geht nicht!!!
Then setting field "nummer" to "81" in row 0 throws the exception "148"
And I save the current editor
And I close the current editor
#############################################################################################################################


Scenario: Kopf editieren: Waehrung

Given I open an editor "postion81_edit6" from table "(Evaluation):(ItemNumber)" with command "UPDATE" for record "81"
Then field "waehr" is modifiable
Then field "w2ist" is modifiable

Then field "waehr" has value "EUR" in row 0
Then field "w2ist" has value "" in row 0
#
# waehr ist aenderbar in GUI, aber die Aenderung wird nicht uebernommen
And I set field "waehr" to "USD"
And I set field "w2ist" to "USD"
#
And I save the current editor
And I close the current editor


Given I open an editor "postion81_edit6" from table "(Evaluation):(ItemNumber)" with command "VIEW" for record "81"
# 
Then field "waehr" has value "EUR" in row 0
Then field "w2ist" has value "USD" in row 0
And I close the current editor

#############################################################################################################################


Scenario: STORNO

Then opening an editor from table "(Evaluation):(ItemNumber)" with command "REVERSAL" for record from editor "81" throws the exception "1582"
#############################################################################################################################



