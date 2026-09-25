# *****************************************************************************
#  Name: product_obj_lock.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet die Anzeige der Objektsperren-Skips im Artikel
# *****************************************************************************
@persistent
@CRUD_OBJ_LOCK_SKIP_TEST
Feature: OBJ_LOCK_SKIPS

Given I'm logged in with password "sy"
Given I set the fake date to "02.01.2022"

Scenario: SkipsInEinemAnwendungsobjektVerwenden

# Sperrkonfigurationen anlegen
Given I open an editor "CreateLockConf1" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "nummer" to "111111"
And I set field "such" to "LOCKCONF-002-01"
And I set field "name" to "Artikelsperre"
And I set field "classname" to "MyProductLock"
And I set field "gesperrtegruppe" to "V-02-01"
And I set field "hinweisbspr" to "Bitte melden."
And I save the current editor
And I close the current editor
Given I open an editor "CreateLockConf2" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "nummer" to "222222"
And I set field "such" to "SERVICELOCKCONF-002-01"
And I set field "name" to "Service-Sperre"
And I set field "classname" to "MyProductServiceLock"
And I set field "gesperrtegruppe" to "V-02-01"
And I set field "hinweisbspr" to "Bitte beim Service melden."
And I save the current editor
And I close the current editor


Given I open an editor "Enumeration" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "22001"
And I append rows
   | vaufzelem                                  | aebez          | aekbez         | aebezeichner    |
   | Sperrkonfiguration LOCKCONF-002-01         | Artikelsperre  | Artikelsperre  | Artikelsperre   |
   | Sperrkonfiguration SERVICELOCKCONF-002-01  | Service-Sperre | Service-Sperre | Service-Sperre  |
And I respond with answer "Ja" to the dialog with id "10951"
And I save the current editor


################### Artikel gleich mit Sperre anlegen CREATE

Given I open an editor "CreateProduct" from table "(Part):(Product)" with command "NEW" for record ""
And I set field "nummer" to "4711"
And I set field "such" to "PRODUCT"
And I set field "sperrkonfigurationneu" to "Artikelsperre"
And I set field "sperrgrundneu" to "Verkaufsstopp"
And I save the current editor
And I close the current editor

Given I open an editor "ViewProductAfterCreate" from table "(Part):(Product)" with command "VIEW" for record "PRODUCT"
Then field "objektsperrliste^such" has value "PRODUCT" in row 0
Then field "sperrkonfiguration" has value "Artikelsperre" in row 0
Then field "sperrgrund" has value "Verkaufsstopp" in row 0
Then field "sperrkonfigurationneu" has value "Artikelsperre" in row 0
Then field "sperrgrundneu" has value "Verkaufsstopp" in row 0
And I close the current editor

Given I open an editor "ViewObjectLockAfterCreate" from table "(ObjectLock):(ObjectLock)" with command "VIEW" for record "PRODUCT"
Then field "name" has value "Artikelsperre" in row 0
Then field "erfasserzeichen" has value "SY" in row 0
Then field "zeichen" has value "SY" in row 0
Then field "sperrliste^such" has value "PRODUCT" in row 0
Then field "sperrkonfiguration" has value "LOCKCONF-002-01" in row 0
Then field "grund" has value "Verkaufsstopp" in row 0
And I close the current editor

Given I open an editor "ViewObjectLockListAfterCreate" from table "(ObjectLock):(ObjectLockList)" with command "VIEW" for record "PRODUCT"
Then field "name" has value "Sperrliste für Artikel 4711" in row 0
And I close the current editor


#################### Ändern des Sperrgrundes

Given I'm logged in with password "adm"

Given I set the fake date to "02.01.2022"

Given I open an editor "UpdateReasonInProduct" from table "(Part):(Product)" with command "UPDATE" for record "PRODUCT"
Then field "objektsperrliste^such" has value "PRODUCT" in row 0
Then field "sperrkonfiguration" has value "Artikelsperre" in row 0
Then field "sperrgrund" has value "Verkaufsstopp" in row 0
Then field "sperrkonfigurationneu" has value "Artikelsperre" in row 0
Then field "sperrgrundneu" has value "Verkaufsstopp" in row 0
And I set field "sperrgrundneu" to "Verkaufsstopp, weil der Artikel nicht mehr bestellbar ist."
And I save the current editor
And I close the current editor

Given I open an editor "ViewObjectLockAfterUpdate" from table "(ObjectLock):(ObjectLock)" with command "VIEW" for record "PRODUCT"
Then field "name" has value "Artikelsperre" in row 0
Then field "erfasserzeichen" has value "SY" in row 0
Then field "zeichen" has value "adm" in row 0
Then field "sperrliste^such" has value "PRODUCT" in row 0
Then field "sperrkonfiguration" has value "LOCKCONF-002-01" in row 0
Then field "grund" has value "Verkaufsstopp, weil der Artikel nicht mehr bestellbar ist." in row 0
And I close the current editor


############ Ersetzen der Sperre

Given I open an editor "ReplaceLockInProduct" from table "(Part):(Product)" with command "UPDATE" for record "PRODUCT"
Then field "objektsperrliste^such" has value "PRODUCT" in row 0
Then field "sperrkonfiguration" has value "Artikelsperre" in row 0
Then field "sperrgrund" has value "Verkaufsstopp, weil der Artikel nicht mehr bestellbar ist." in row 0
Then field "sperrkonfigurationneu" has value "Artikelsperre" in row 0
Then field "sperrgrundneu" has value "Verkaufsstopp, weil der Artikel nicht mehr bestellbar ist." in row 0
And I set field "sperrkonfigurationneu" to "Service-Sperre"
And I set field "sperrgrundneu" to "Verkaufsstopp, weil keine Serviceleistung erbracht werden kann."
And I save the current editor
And I close the current editor

Given I open an editor "ViewObjectLockAfterReplace" from table "(ObjectLock):(ObjectLock)" with command "VIEW" for record "PRODUCT"
Then field "name" has value "Service-Sperre" in row 0
Then field "erfasserzeichen" has value "adm" in row 0
Then field "zeichen" has value "adm" in row 0
Then field "sperrliste^such" has value "PRODUCT" in row 0
Then field "sperrkonfiguration" has value "SERVICELOCKCONF-002-01" in row 0
Then field "grund" has value "Verkaufsstopp, weil keine Serviceleistung erbracht werden kann." in row 0
And I close the current editor

Given I open an editor "ViewDeletedLockAfterReplace" from table "(ObjectLock):(ObjectLock)" with command "VIEW" for record "+PRODUCT"
Then field "name" has value "Artikelsperre" in row 0
Then field "erfasserzeichen" has value "SY" in row 0
Then field "zeichen" has value "adm" in row 0
Then field "sperrliste^such" has value "PRODUCT" in row 0
Then field "sperrkonfiguration" has value "LOCKCONF-002-01" in row 0
Then field "grund" has value "Verkaufsstopp, weil der Artikel nicht mehr bestellbar ist." in row 0
And I close the current editor


############ Kopieren des gesperrten Artikels

Given I open an editor "CopyLockedProduct" from table "(Part):(Product)" with command "NEW" for record "PRODUCT"
And I set field "nummer" to "4712"
And I set field "such" to "COPYPRODUCT"
Then field "objektsperrliste" is empty in row 0
Then field "sperrkonfiguration" is empty in row 0
Then field "sperrgrund" is empty in row 0
Then field "sperrkonfigurationneu" is empty in row 0
Then field "sperrgrundneu" is empty in row 0
And I save the current editor
And I close the current editor


############ Sperren des kopierten Artikels

Given I open an editor "LockCopiedProduct" from table "(Part):(Product)" with command "UPDATE" for record "COPYPRODUCT"
Then field "objektsperrliste" is empty in row 0
Then field "sperrkonfiguration" is empty in row 0
Then field "sperrgrund" is empty in row 0
Then field "sperrkonfigurationneu" is empty in row 0
Then field "sperrgrundneu" is empty in row 0
And I set field "sperrkonfigurationneu" to "Service-Sperre"
And I set field "sperrgrundneu" to "Verkaufsstopp, auch die Kopie kann nicht gewartet werden."
And I save the current editor
And I close the current editor

Given I open an editor "ViewObjectLockListAfterLockingCopy" from table "(ObjectLock):(ObjectLockList)" with command "VIEW" for record "COPYPRODUCT"
Then field "name" has value "Sperrliste für Artikel 4712" in row 0
And I close the current editor

Given I open an editor "ViewLockOfCopiedProduct" from table "(ObjectLock):(ObjectLock)" with command "VIEW" for record "COPYPRODUCT"
Then field "name" has value "Service-Sperre" in row 0
Then field "sperrliste^such" has value "COPYPRODUCT" in row 0
Then field "sperrkonfiguration" has value "SERVICELOCKCONF-002-01" in row 0
Then field "grund" has value "Verkaufsstopp, auch die Kopie kann nicht gewartet werden." in row 0
And I close the current editor


############ Sperre des kopierten Artikels entfernen

Given I open an editor "RemoveLockCopiedProduct" from table "(Part):(Product)" with command "UPDATE" for record "COPYPRODUCT"
Then field "objektsperrliste^such" has value "COPYPRODUCT" in row 0
Then field "sperrkonfiguration" has value "Service-Sperre" in row 0
Then field "sperrgrund" has value "Verkaufsstopp, auch die Kopie kann nicht gewartet werden." in row 0
Then field "sperrkonfigurationneu" has value "Service-Sperre" in row 0
Then field "sperrgrundneu" has value "Verkaufsstopp, auch die Kopie kann nicht gewartet werden." in row 0
And I set field "sperrkonfigurationneu" to ""
Then field "sperrgrundneu" has value ""
And I save the current editor
And I close the current editor

Given I open an editor "ViewCopiedProductAfterUnlock" from table "(Part):(Product)" with command "VIEW" for record "COPYPRODUCT"
Then field "objektsperrliste^such" has value "COPYPRODUCT" in row 0
Then field "sperrkonfiguration" is empty in row 0
Then field "sperrgrund" is empty in row 0
Then field "sperrkonfigurationneu" is empty in row 0
Then field "sperrgrundneu" is empty in row 0
And I close the current editor

Given I open an editor "ViewDeletedLockAfterUnlock" from table "(ObjectLock):(ObjectLock)" with command "VIEW" for record "+COPYPRODUCT"
Then field "name" has value "Service-Sperre" in row 0
Then field "sperrliste^such" has value "COPYPRODUCT" in row 0
Then field "sperrkonfiguration" has value "SERVICELOCKCONF-002-01" in row 0
Then field "grund" has value "Verkaufsstopp, auch die Kopie kann nicht gewartet werden." in row 0
And I close the current editor

Scenario: QueryOfSkips

Given I query "such,ablagef,enddatum" from table "(ObjectLock):(ObjectLock)" where "@ablageart=beides;such=PRODUCT"
Then query has values
| such     | ablagef |  enddatum            |
| PRODUCT  |   ja    |  02.01.2022 10:54:00 |
| PRODUCT  |   nein  |                      |
