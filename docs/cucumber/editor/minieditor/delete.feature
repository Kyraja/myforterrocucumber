# *****************************************************************************
#  Name: delete.feature
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet für Minieditoren iZhg mit Löschen
# *****************************************************************************
@persistent
@Minieditor_loeschen
Feature: Minieditor_loeschen

Scenario: Kunde anlegen und dann via <loeschen> mit Minieditor entfernen
# Das geht, weil der Maskeneintritt-EFOP beim Kunden mit 0 endet.

Given I'm logged in with password "sy"
Given I open an editor "<Kunde><neu>" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set field "nummer" to "666"
And I set field "such" to "BEAST"
And I save the current editor
And I close the current editor
Given I'm logged in with password "sy"
Given I open an editor "<Kunde><loeschen>" from table "(Customer):(Customer)" with command "DELETE" for record "BEAST"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor
Then opening an editor from table "(Customer):(Customer)" with command "VIEW" for record "666" throws the exception "149"

Scenario: Lieferant  anlegen und dann via <loeschen> mit Minieditor entfernen
# Das scheitert, weil der Maskeneintritt-EFOP beim Lieferantten mit 2 endet.

Given I'm logged in with password "sy"
Given I open an editor "<Lieferant><neu>" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set field "nummer" to "666"
And I set field "such" to "BEAST"
And I save the current editor
And I close the current editor
Given I'm logged in with password "sy"
Given opening an editor from table "(Vendor):(Vendor)" with command "DELETE" for record "BEAST" throws the exception "2620"
And I close the current editor
Given I open an editor "<Lieferant><zeigen>" from table "(Vendor):(Vendor)" with command "VIEW" for record "666"
And I close the current editor


Scenario: Kunde anlegen und mit FO entfernen
# Das geht, weil der das FO-Kommando zwar mit einem Minieditor entfernt, aber die EFOP nicht laufen.

Given I'm logged in with password "sy"
Given I open an editor "<Kunde><neu>" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set field "nummer" to "666"
And I set field "such" to "FOBEAST"
And I save the current editor
And I close the current editor
Given I execute FOP "FO.DEL.CUSTOMER.OK.FOP"
Then opening an editor from table "(Customer):(Customer)" with command "VIEW" for record "666" throws the exception "149"

Scenario: Verbliebenen Lieferant  666 mit FO entfernen
# Das geht, weil der das FO-Kommando zwar mit einem Minieditor entfernt, aber die EFOP nicht laufen.

Given I'm logged in with password "sy"
Given I execute FOP "FO.DEL.SUPPLIER.OK.FOP"
Then opening an editor from table "(Vendor):(Vendor)" with command "VIEW" for record "666" throws the exception "149"
