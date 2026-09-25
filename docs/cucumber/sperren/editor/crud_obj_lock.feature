# *****************************************************************************
#  Name: crud_obj_lock.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet CRUD auf Objektsperrlisten
# *****************************************************************************
@persistent
@CRUD_OBJ_LOCK_TEST
Feature: CRUD 193:1

Given I'm logged in with password "annette"
Given I enable the flag 298

Scenario: CRUD_lebendig

# Auf lebendige Objektsperrlisten sind nur die Kommandos READ und UPDATE zulässig.

## Beispiel C Kopieren von Objektsperrlisten ist verboten
## Beispiel R Lesen Datensatz V1
## Beispiel U Ändern Suchwort UPDATE
## Beispiel D Das Entfernen von Objektsperrlisten ist verboten

# Beispiel C Create
Given opening an editor from table "(ObjectLock):(ObjectLockList)" with command "NEW" for record "" throws the exception "40"
Then opening an editor from table "(ObjectLock):(ObjectLockList)" with command "NEW" for record "V1" throws the exception "40"

# Beispiel Read
Given I open an editor "READ" from table "(ObjectLock):(ObjectLockList)" with command "VIEW" for record "V1"
Then field "nummer" has value "1" in row 0
Then field "such" has value "V1" in row 0
And I close the current editor

# Beispiel Update
Given I open an editor "UPDATE" from table "(ObjectLock):(ObjectLockList)" with command "UPDATE" for record "V1"
And I set field "such" to "UPDATE"
And I save the current editor
And I close the current editor

# Beispiel Delete
Given opening an editor from table "(ObjectLock):(ObjectLockList)" with command "DELETE" for record "UPDATE" throws the exception "40"

Scenario: CRUD_abgelegt

# Auf abgelegte Objektsperrlisten ist ur das Kommando VIEW erlaubt.

## Beispiel C Erstellen und Kopieren von Objektsperrlisten ist verboten (schon oben getestet)
## Beispiel R Lesen auf abgelegte Objektsperrliste
## Beispiel U Ändern in der Ablage ist verboten
## Beispiel D Das Entfernen von Objektsperrlisten ist verboten (schon oben getestet)

# Erstellen und Ablegen der Objektsperrliste durch Erstellen und Ablegen des gesperrten Artikels

Given I open an editor "ADAM" from table "(Part):(Product)" with command "NEW" for record ""
And I set field "such" to "ADAM"
And I set field "sperrkonfigurationneu" to "Artikelsperre"
And I set field "sperrgrundneu" to "Artikel kaputt"
And I save the current editor
And I close the current editor

Given I open an editor "Delete" from table "(Part):(Product)" with command "DELETE" for record "ADAM"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

# Beispiel Read
Given I open an editor "READ" from table "(ObjectLock):(ObjectLock)" with command "VIEW" for record "+ADAM"
Then field "such" has value "ADAM" in row 0
And I close the current editor

# Beispiel Update
Given opening an editor from table "(ObjectLock):(ObjectLock)" with command "DELETE" for record "+ADAM" throws the exception "40"
