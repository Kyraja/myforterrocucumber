# *****************************************************************************
#  Name           : bu_vorschau_vk.feature
#  Autor          : sb, rem
#  Verantwortlich : teampss
#  Funktion       : Testet die Buchungsvorschau aus einer VK-Rechnung
#                   in gebuchtem und ungebuchten Zustand.
#                   
#
# *****************************************************************************
@persistent
Feature:  Buchungsvorschau aus VK Rechnung
Background:
Given I set the fake date to "02.01.1995"
 
Scenario: STAMMDATEN - Neuen Kunden anlegen
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "Bayram"
And I set field "such" to "Bayram"
And I set field "namebspr" to "Bayram Werkzeugbau, Rastatt"
And I set field "ans" to "Bayram Werkzeugbau GmbH"
And I set field "str" to "Riedstr. 24-28"
And I set field "plz" to "76437"
And I set field "nort" to "Rastatt"
And I set field "region" to "BADEN"
And I set field "tele" to "+49 (0) 7222/9456-0"
And I set field "email" to "info@bayram-corp.de"
And I set field "betreuer" to "."
And I set field "ustid" to "DE56454651"
And I set field "lbed" to "EXW"
And I set field "zbed" to "201"
And I save the current editor
Then field "name" has value "Bayram Werkzeugbau, Rastatt"
Then field "zbed" has value "201"

Scenario Outline: STAMMDATEN - Zwei neue Artikel anlegen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "vkbez" to "<vkbez>"
And I set field "vbez" to "<vbez>"
And I set field "ebez" to "<ebez>"
And I set field "vpr" to "<vpr>"
And I set field "bsart" to "<bsart>"
And I set field "dispoa" to "<dispoa>"
And I save the current editor 
Examples: Artikel
| such            | namebspr     | vkbez     | vbez       | ebez         | vpr    | bsart             | dispoa          |
| artikel1        | Artikel 1    | Artikel 1 | Artikel 1  | Artikel 1    | 10000  | Fremdbeschaffung  | bedarfsbezogen  |
| artikel2        | Artikel 2    | Artikel 2 | Artikel 2  | Artikel 2    | 9000   | Fremdbeschaffung  | bedarfsbezogen  |

Scenario: Rechnung anlegen
Given I open an editor "vkrechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "RECH1"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "1" in row 1
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row 2
And I set field "mge" to "1" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#Rechnung oeffnen und Buchungsvorschau aufrufen
Given I open an editor "vkrechnung" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "vkrechnung"
#Given I open an editor "vkrechnung" from table "(Sales):(Invoice)" with command "UPDATE" for record "RECH1"
And I press button "buvo" to open a subeditor for "buchungsvorschau"
Then field "betrag" has value "21850.00" in row 1
Then field "id" has value "(0,0,0)"
And I close the current editor
And I switch the current editor to editor "vkrechnung"
And I set field "ueb" to "ja"
And I save the current editor

#Rechnung und Buchungsvorschau aufrufen
Given I open an editor "vkrechnung" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "vkrechnung"
#Given I open an editor "vkrechnung" from table "(Sales):(Invoice)" with command "VIEW" for record "+RECH1"
And I press button "buvo" to open a subeditor for "buchungsvorschau"
Then field "betrag" has value "21850.00" in row 1
Then field "id" has value "(154,6,0)"
Then field "nummer" is not empty
And I close the current editor
And I switch the current editor to editor "vkrechnung"
And I close the current editor

Scenario: Null-Rechnung anlegen
Given I open an editor "vkrechnung2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "RECH2"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "ueb" to "ja"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
