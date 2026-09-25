# *****************************************************************************
#  Name           : IS_EKBE.feature
#  Autor          : mh
#  Verantwortlich : teaminfosysteme
#  Funktion       : Testet Funktionen IS EKBE
#
# *****************************************************************************
#
@persistent
Feature: Artikelsperre im Infosystem EKBE pruefen
Background:
Given I set the fake date to "02.01.1995"

# ------------------------------------------------------
Scenario: Bestellung anlegen
# ------------------------------------------------------
Given I open an editor "bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
| lief       | 40001 |
| dfuesenden | ja    |
| dfuedat    | .     |
And I append rows
| artex   | mge | 
| 4000101 | 10  |
| 4000102 | 10  |
| 4000103 | 10  |
#And I save the current editor
#nicht speichern 
And I close the current editor

# ------------------------------------------------------
Scenario: EKBE ohne Sperre testen
# ------------------------------------------------------

#Infosystem EKBE ohne Selektion aufrufen
Given I open the infosystem "EKBE"
And I press button "bstart"
Then the table has 1 rows
And I close the current editor

#Infosystem EKBE mit Selektion nach Lieferant aufrufen
Given I open the infosystem "EKBE"
And I set field "lief" to "40001"
And I press button "bstart"
Then the table has 1 rows
And I close the current editor

Given I open the infosystem "EKBE"
And I set field "lief" to "40002"
And I press button "bstart"
Then the table has 0 rows
And I close the current editor

# ------------------------------------------------------
Scenario: EKBE ohne Sperre mit Datum testen
# ------------------------------------------------------

Given I open the infosystem "EKBE"
And I set field "vom" to "-4"
And I press button "bstart"
Then the table has 0 rows
And I close the current editor

Given I open the infosystem "EKBE"
And I set field "vom" to "+4"
And I press button "bstart"
Then the table has 0 rows
And I close the current editor

# ------------------------------------------------------
Scenario: EKBE ohne Sperre mit Datum heute testen
# ------------------------------------------------------
Given I open the infosystem "EKBE"
And I set field "vom" to "."
And I press button "bstart"
Then the table has 1 rows
And I close the current editor

# ------------------------------------------------------
Scenario: EKBE mit Sperre testen
# ------------------------------------------------------

#Artikel 4000102 sperren
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "4000102"
And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
And I save the current editor

#Infosystem EKBE aufrufen
Given I open the infosystem "EKBE"
And I press button "bstart"
Then the table has 1 rows
And table has values
	| taktiv | tnummer| tpartner | tvom       | tstatusx      |
	| nein   | 600001 | 40001    | 02.01.1995 | icon:ball_red |

And I close the current editor
