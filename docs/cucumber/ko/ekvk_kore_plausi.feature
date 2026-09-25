# *****************************************************************************
#  Name           : ekvk_kore_plausi.feature
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Plausibilisierung von Ein-/Verkaufspoitionen, die ein Verdichtungskostenobjekt enthalten
#
# *****************************************************************************
#
@persistent
Feature: Verdichtungsobjekte in E-/V-Positionen
Background: 
Given I set the fake date to "22.01.1995"

Scenario: 01 Stammdaten
Given I open an editor "ks" from table "(Account):(CostCenter)" with command "COPY" for record "101"
And I set field "nummer" to "201"
And I set field "such" to "ks201"
And I save the current editor
And I close the current editor

Given I open an editor "kt" from table "(Account):(CostObject)" with command "COPY" for record "100000"
And I set field "nummer" to "200001"
And I set field "such" to "kt200001"
And I save the current editor
And I close the current editor

Given I open an editor "wg" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "550"
And I set field "such" to "nbgwg"
And I set field "befuehr" to "nein"
And I save the current editor
And I close the current editor

Given I open an editor "teil" from table "(Part):(Product)" with command "COPY" for record "1000"
And I set field "nummer" to "2000"
And I set field "such" to "teil2000"
And I set field "aufgrp" to "nbgwg"
And I save the current editor
And I close the current editor

Scenario: 02 Einkaufsvorgänge
Given I open an editor "1BE01" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE01 |
   | lief    | 1     |
   | such    | BE01  |
And I append rows
   | artikel | mge | preis | kstelle |
   | 2000    | 20  | 10    | 200001  |
And I save the current editor

Given I open an editor "2LS01" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE01"
And I set fields
   | nummer | 2LS01  |
   | such   | LS01   |
   | ueb    | nein   |
   | vom    | .      |
And I set field "mge" to "10" in row 1
And I set field "platz" to "F2" in row 1
And I save the current editor

Given I open an editor "3RE01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 3RE01  |
   | such   | RE01   |
   | ueb    | nein   |
   | vom    | .      |
   | lief   |   1    |
   | fakt   | ja     |
And I append rows
   | artikel | mge | preis | kstelle |
   | 2000    | 50  | 15    | 200001  |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


Scenario: 03 Verkaufsvorgänge
Given I open an editor "1AU01" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 1     |
   | nummer  | 1AU01 |
   | such    | AU01  |
And I append rows
   | artikel | mge | preis | kstelle |
   | 2000    | 100 |   100 |  201    |
And I save the current editor

Given I open an editor "LS01" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU01"
And I set fields
   | nummer | 1LS01 |
   | such   | LS01  |
   | ueb    | nein  |
   | vom    | .     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE02" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
| kunde  |   1   |
| nummer | 1RE02 |
| such   | RE02  |
| ueb    | nein  |
| tterm  | .     |
| fakt   |  ja   |
And I append rows
   | artikel | mge | preis | kstelle |
   | 2000    | 200 |   150 |  201    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario: 04 Bebuchbarkeit von Kst 201 und Ktr 20001 ändern
Given I'm logged in with password "annette"

Given I open an editor "ks" from table "(Account):(CostCenter)" with command "UPDATE" for record "201"
And I set field "bebuchbar" to "nein"
And I save the current editor
And I close the current editor

Given I open an editor "kt" from table "(Account):(CostObject)" with command "UPDATE" for record "200001"
And I set field "bebuchbar" to "nein"
And I save the current editor
And I close the current editor

Given I'm logged in with password "sy"

Scenario: 05 Plausi VK
# Auftrag ändern
Given I open an editor "1AU01" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "1AU01"
Then saving the current editor throws the exception "7624"
And I close the current editor

# Lieferschein buchen
Given I open an editor "LS01" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "1LS01"
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "7624"
And I close the current editor

# Rechnung buchen
Given I open an editor "RE02" from table "(Sales):(Invoice)" with command "UPDATE" for record "1RE02"
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "7624"
And I close the current editor

Scenario: 06 Plausi EK
# Bestellung ändern
Given I open an editor "1BE01" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "1BE01"
Then saving the current editor throws the exception "7624"
And I close the current editor

# Lieferschein buchen
Given I open an editor "LS01" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "2LS01"
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "7624"
And I close the current editor

# Rechnung buchen
Given I open an editor "RE01" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "3RE01"
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "7624"
And I close the current editor



