# *****************************************************************************
#  Name: obj_lock_conflict.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet Sperrsituation bei Objektsperre
# *****************************************************************************
@persistent
Feature: Conflict_obj_lock

Scenario: CreateTestData

Given I'm logged in with password "admin"

# Wir erstellen eine harte Sperrkonfiguration für Artikel.
Given I open an editor "HardLockConf" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "HARD"
And I set field "nummer" to "100000"
And I set field "classname" to "HardProductLock"
And I set field "gesperrtegruppe" to "V-02-01"
And I save the current editor
And I close the current editor

# Wir erweitern die Aufzählung Sperrkonfigurationen im Artikel um die neue.
Given I open an editor "ExtendEnum" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "22001"
And I append rows
   | vaufzelem                    | aebez         | aekbez        | aebezeichner   |
   | Sperrkonfiguration HARD | Artikelsperre | Artikelsperre | Artikelsperre  |
And I respond with answer "Ja" to the dialog with id "10951"
And I save the current editor

# Wir erstellen ein mit dieser Sperrkonfiguration hart gesperrten Artikel.
Given I open an editor "LockProduct" from table "(Part):(Product)" with command "NEW" for record ""
And I set field "such" to "HARD_LOCKED_PRODUCT"
And I set field "sperrkonfigurationneu" to "Artikelsperre"
And I set field "sperrgrundneu" to "Artikel kaputt"
And I save the current editor
And I close the current editor


##Scenario: CreateLock

##Given I'm logged in with password "admin"

# Wir bearbeiten die Sperrkonfiguration und lassen den Editor aktiv.
##Given I open an editor "ObjLock" from table "(ObjectLock):(ObjectLock)" with command "UPDATE" for record "HARD"

##Given I'm logged in with password "admin"

# Wir bearbeiten den Artikel und füllen einen neuen Sperrgrund ein.
# Beim Speichern muss dadurch auch Objektsperre geschrieben werden -> Konflikt!
##Given I open an editor "Hard_Locked_Product" from table "(Part):(Product)" with command "UPDATE" for record "HARD_LOCKED_PRODUCT"
##And I set field "sperrgrundneu" to "Artikel ist defekt"
##And I save the current editor

##Given I'm logged in with password "admin"

# Wir beseitigen den Konflikt, indem die Transaktion des Blockierers beendet wird.
##Given I switch the current editor to editor "ObjLock"
##And I close the current editor

##Given I'm logged in with password "admin"

# Artikel wieder bearbeiten, wodurch klar ist, dass vorher gespeichert wurde.
##Given I open an editor "Hard_Locked_Product_Again" from table "(Part):(Product" with command "UPDATE" for record "HARD_LOCKED_PRODUCT"
##And I close the current editor
