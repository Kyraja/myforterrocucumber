# *****************************************************************************
#  Name: check_generic_locked_refs.feature
#  Autor: tf
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet die generische Sperrpruefung
# *****************************************************************************
@persistent
Feature: Generische Sperrpruefung

Scenario: Set Lock 

Given I'm logged in with password "sy"

Given I open an editor "SalesNote" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "V-02-01-VERKAUF-Hinweis"
And I set field "gesperrtegruppe" to "V-02-01"
And I append rows
   | verweisfeldingruppe | verweisfeldintabelle | verweisfeldname |
   | v-03-21                      | ja                               | artikel                    |
   | v-03-22                      | ja                               | artikel                    |
   | v-03-23                      | ja                               | artikel                    |
   | v-03-24                      | ja                               | artikel                    |
And I save the current editor
And I close the current editor

Given I open an editor "SalesLock" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "V-02-01-VERKAUF-Sperre"
And I set field "gesperrtegruppe" to "V-02-01"
And I append rows
   | verweisfeldingruppe | verweisfeldintabelle | verweisfeldname |
   | v-03-21                      | ja                               | artikel                    |
   | v-03-22                      | ja                               | artikel                    |
   | v-03-23                      | ja                               | artikel                    |
   | v-03-24                      | ja                               | artikel                    |
And I save the current editor
And I close the current editor

Given I open an editor "Lock" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "PRODUCT_LOCK"
And I set field "name" to "Artikel unbrauchbar"
And I set field "classname" to "ArtikelSperre"
And I set field "gesperrtegruppe" to "V-02-01"
And I set field "hinweis" to "Das Produkt ist nicht lieferbar."
And I set field "hinweis2" to "Product is not available."
And I append rows
   | verweissperrstellen               | sperrwirkung | sperrhinweis1                                        | sperrhinweis2 |
   | V-02-01-VERKAUF-Sperre  | gesperrt        |                                                                 |                          |
And I save the current editor
And I close the current editor

Given I open an editor "Lock" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "PRODUCT_NOTE"
And I set field "name" to "Artikel in QS"
And I set field "classname" to "ArtikelHinweis"
And I set field "gesperrtegruppe" to "V-02-01"
And I set field "hinweis" to "Das Produkt ist verspätet lieferbar."
And I set field "hinweis2" to "Product is delayed in delivery."
And I append rows
   | verweissperrstellen                | sperrwirkung | sperrhinweis1                                        | sperrhinweis2                                     |
   | V-02-01-VERKAUF-Hinweis | Hinweis          | Das Produkt ist abweichend lieferbar. |  The product is available differently. |
And I save the current editor
And I close the current editor

Scenario: Enumeration 22001 erweitern
Given I open an editor "Enumeration" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "22001"
And I append rows
   | vaufzelem                        | aebez          | aekbez         | aebezeichner   |
   | Sperrkonfiguration PRODUCT_LOCK  | Artikelsperre  | Artikelsperre  | Artikelsperre  |
   | Sperrkonfiguration PRODUCT_NOTE  | Artikelhinweis | Artikelhinweis | Artikelhinweis |   
And I respond with answer "Ja" to the dialog with id "10951"
And I save the current editor

Scenario: SML erstellen
Given I open an editor "SML" from table "(Company):(CharacteristicsBar)" with command "NEW" for record ""
And I set field "such" to "SMLPART"
And I append rows
   | benennibspr  | zusatzart  | vname   |
   | Artikel             | PS2:1       | qartikel  |
And I save the current editor
And I close the current editor

Scenario: SML eintragen und ausfuellen
Given I open an editor "Artikel" from table "(Part):(Product)" with command "UPDATE" for record "V1"
And I set field "sperrkonfigurationneu" to "Artikelsperre"
And I set field "sperrgrundneu" to "Defekt"
And I set field "sach" to "SMLPART"
And I press button "bmerk" to open a subeditor for "Sachmerkmale"
And I set field "qartikel" to "V1"
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "Artikel" from table "(Part):(Product)" with command "UPDATE" for record "V2"
And I set field "sperrkonfigurationneu" to "Artikelhinweis"
And I set field "sperrgrundneu" to "Keine QS-Freigabe"
And I set field "sach" to "SMLPART"
And I press button "bmerk" to open a subeditor for "Sachmerkmale"
And I set field "qartikel" to "V2"
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Scenario: Verkaufsrechnung erfassen, Artikel gesperrt
Given I open an editor "vkrechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I create a new row at the end of the table
And I set field "artex" to "V2" in row 1
And I set field "mge" to "1" in row 1
And I create a new row at the end of the table
And setting field "artex" to "V1" in row 2 throws the exception "4806"
And I close the current editor

Scenario: Verkaufsauftrag erfassen, Artikel mit Hinweissperre
Given I open an editor "vkauftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I create a new row at the end of the table
And I set field "artex" to "V2" in row 1
And I set field "mge" to "1" in row 1
And I create a new row at the end of the table
And setting field "artex" to "V1" in row 2 throws the exception "4806"
And I close the current editor
