# *****************************************************************************
#  Name: crud_obj_lock_11.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet CRUD zu Objektsperren
# *****************************************************************************
@persistent
@CRUD_OBJ_LOCK_11_TEST
Feature: CRUD 193:11

Given I'm logged in with password "annette"
Given I enable the flag 298

Scenario: ObjekteFuerPflichtfelderErstellen

Given I open an editor "LOCKCONF" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "LOCKCONF-193-11"
And I set field "name" to "Sperrkonfiguration zu Objektsperre 11 CREATE nachher UPDATE"
And I set field "classname" to "MyLockConfig"
And I set field "gesperrtegruppe" to "V-02-01"
And I save the current editor
And I close the current editor

Scenario: CRUD_lebendig

# Auf lebendige Objektsperren sind nur die Kommandos READ und UPDATE zulässig.

## Beispiel C Erzeugen oder Kopieren von Objektsperren ist verboten
## Beispiel R Lesen Datensatz CREATE
## Beispiel Update Suchwort UPDATE
## Beispiel D Entfernen ist verboten

# Beispiel C Create
Then opening an editor from table "(ObjectLock):(ObjectLock)" with command "NEW" for record "" throws the exception "40"
Then opening an editor from table "(ObjectLock):(ObjectLock)" with command "NEW" for record "V1" throws the exception "40"

# Beispiel R Read
Given I open an editor "READ" from table "(ObjectLock):(ObjectLock)" with command "VIEW" for record "V1"
Then field "nummer" has value "2" in row 0
Then field "such" has value "V1" in row 0
And I close the current editor

# Beispiel U Update
Given I open an editor "UPDATE" from table "(ObjectLock):(ObjectLock)" with command "UPDATE" for record "V1"
And I set field "such" to "UPDATE"
And I set field "name" to "name"
And field "grund" is not modifiable
And I save the current editor
And I close the current editor

# Beispiel D Delete
Then opening an editor from table "(ObjectLock):(ObjectLock)" with command "DELETE" for record "UPDATE" throws the exception "40"


Scenario: CRUD_abgelegt

# Auf abgelegte Objektsperrlisten ist ur das Kommando VIEW erlaubt.

## Beispiel C Kopieren von Objektsperren ist verboten (schon oben getestet)
## Beispiel R Lesen auf abgelegte Objektsperre
## Beispiel U Ändern in der Ablage ist verboten
## Beispiel D Das Entfernen von Objektsperren ist verboten (schon oben getestet)

# Erstellen und Ablegen der Objektsperrliste durch Erstellen und Ablegen des gesperrten Artikels

Given I open an editor "EVA" from table "(Part):(Product)" with command "NEW" for record ""
And I set field "such" to "EVA"
And I set field "sperrkonfigurationneu" to "Artikelsperre"
And I set field "sperrgrundneu" to "Artikel kaputt"
And I save the current editor
And I close the current editor

Given I open an editor "Delete" from table "(Part):(Product)" with command "DELETE" for record "EVA"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

# Read
Given I open an editor "READ" from table "(ObjectLock):(ObjectLock)" with command "VIEW" for record "+EVA"
Then field "such" has value "EVA" in row 0
And I close the current editor

# Update
Given opening an editor from table "(ObjectLock):(ObjectLock)" with command "DELETE" for record "+EVA" throws the exception "40"
