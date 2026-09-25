# *****************************************************************************
#  Name           : ev_editierbarkeit_fibufelder_001_kopf1.feature
#  Autor          : wane
#  Verantwortlich : wane
#  Kontrolle      :
#  Funktion       : Testet die Editierbarkeit von Kopffelder in EK/VK
#                   - Journalkennzeichen
#
#
# *****************************************************************************
@persistent
Feature: Editierbarkeit in EK-/VK-Rechnung
Background:
Given I set the fake date to "02.01.1995"

Scenario: Rechnungen anlegen und verbuchten: EK und VK

### Verkauf ###
Given I open an editor "vkre-uebertragen" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "10fertig"
And I set field "kunde" to "001"
And I set field "such" to "FERTIG"
And I set field "ueb" to "ja"
Then field "bukenn" is modifiable
Then field "bukenn" has value "DI"
# Journalkennzeichen bewusst leeren
And I set field "bukenn" to ""
And I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "1" in row 1
And I set field "preis" to "5" in row 1
And I create a new row at the end of the table
And I set field "artex" to "e2" in row 2
And I set field "mge" to "1" in row 2
And I set field "preis" to "15" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Buchung kontrollieren
Given I open an editor "buchung" from table "(Entry):(Entry)" with command "VIEW" for record "$,,@richtung=rückwärts;@maxtreffer=1"
Then field "kenn" has value "DI"
Then field "ursache" has value "Verkauf"
Then field "klm" has value "K 001"
Then field "beleg" has value "10fertig"
Then field "ursacheref" is not empty in row 0
Then field "stornoobjekt" is empty in row 0
Then field "stornovorlobjekt" is empty in row 0
And I close the current editor

### Einkauf ###
Given I open an editor "ekre-uebertragen" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "10fertig"
And I set field "lief" to "1"
And I set field "such" to "FERTIG"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then field "bukenn" is modifiable
Then field "bukenn" has value "DI"
# Journalkennzeichen bewusst leeren
And I set field "bukenn" to ""
And I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "1" in row 1
And I set field "preis" to "22" in row 1
And I create a new row at the end of the table
And I set field "artex" to "e2" in row 2
And I set field "mge" to "1" in row 2
And I set field "preis" to "900" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Buchung kontrollieren
Given I open an editor "buchung2" from table "(Entry):(Entry)" with command "VIEW" for record "$,,@richtung=rückwärts;@maxtreffer=1"
Then field "kenn" has value "DI"
Then field "ursache" has value "Einkauf"
Then field "klm" has value "L 1"
Then field "beleg" has value "10fertig"
Then field "ursacheref" is not empty in row 0
Then field "stornoobjekt" is empty in row 0
Then field "stornovorlobjekt" is empty in row 0
And I close the current editor

Given I open an editor "ekre2-uebertragen" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "20fertig"
And I set field "lief" to "001"
And I set field "such" to "FERTIG"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then field "bukenn" is modifiable
Then field "bukenn" has value "DI"
# Journalkennzeichen bewusst aendern
And I set field "bukenn" to "ZU"
And I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "1" in row 1
And I set field "preis" to "22" in row 1
And I create a new row at the end of the table
And I set field "artex" to "e2" in row 2
And I set field "mge" to "1" in row 2
And I set field "preis" to "70" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Buchung kontrollieren
Given I open an editor "buchung3" from table "(Entry):(Entry)" with command "VIEW" for record "$,,@richtung=rückwärts;@maxtreffer=1"
Then field "kenn" has value "ZU"
Then field "ursache" has value "Einkauf"
Then field "klm" has value "L 001"
Then field "beleg" has value "20fertig"
Then field "ursacheref" is not empty in row 0
Then field "stornoobjekt" is empty in row 0
Then field "stornovorlobjekt" is empty in row 0
And I close the current editor
#####################################################################################################################################


Scenario: Rechnungen stornieren: EK und VK

Given I set the fake date to "05.01.1995"


### Verkauf ###
Given I open an editor "vk-storno" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+10fertig"
Then I set field "nummer" to "10stor"
Then field "bem" is modifiable
Then field "bukenn" is modifiable
Then field "bukenn" has value "DI"
# Journalkennzeichen bewusst leeren
And I set field "schlag" to "falsche Menge"
And I save the current editor
And I close the current editor

# Buchung kontrollieren
Given I open an editor "buchung" from table "(Entry):(Entry)" with command "VIEW" for record "$,,@richtung=rückwärts;@maxtreffer=1"
Then field "kenn" has value "DI"
Then field "ursache" has value "Verkauf"
Then field "klm" has value "K 001"
Then field "beleg" has value "10stor"
Then field "ursacheref" is not empty in row 0
Then field "stornoobjekt" is empty in row 0
Then field "stornovorlobjekt" is not empty in row 0
And I close the current editor


### Einkauf ###
Given I open an editor "ek-storno" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+10fertig"
Then I set field "nummer" to "10stor"
Then field "bem" is modifiable
Then field "bukenn" is modifiable
Then field "bukenn" has value "DI"
# Journalkennzeichen bewusst aendern: macht kein Sinn, aber moeglich
And I set field "bukenn" to "AAB"
And I set field "schlag" to "Preis war falsch"
And I save the current editor
And I close the current editor

# Buchung kontrollieren
Given I open an editor "buchung" from table "(Entry):(Entry)" with command "VIEW" for record "$,,@richtung=rückwärts;@maxtreffer=1"
Then field "kenn" has value "AAB"
Then field "ursache" has value "Einkauf"
Then field "klm" has value "L 1"
Then field "beleg" has value "10stor"
Then field "ursacheref" is not empty in row 0
Then field "stornoobjekt" is empty in row 0
Then field "stornovorlobjekt" is not empty in row 0
And I close the current editor

Given I open an editor "ek2-storno" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+20fertig"
Then I set field "nummer" to "20stor"
Then field "bem" is modifiable
Then field "bukenn" is modifiable
Then field "bukenn" has value "ZU"
And I set field "schlag" to "Preis war falsch"
And I save the current editor
And I close the current editor

# Buchung kontrollieren
Given I open an editor "buchung" from table "(Entry):(Entry)" with command "VIEW" for record "$,,@richtung=rückwärts;@maxtreffer=1"
Then field "kenn" has value "ZU"
Then field "ursache" has value "Einkauf"
Then field "klm" has value "L 001"
Then field "beleg" has value "20stor"
Then field "ursacheref" is not empty in row 0
Then field "stornoobjekt" is empty in row 0
Then field "stornovorlobjekt" is not empty in row 0
And I close the current editor
#####################################################################################################################################

