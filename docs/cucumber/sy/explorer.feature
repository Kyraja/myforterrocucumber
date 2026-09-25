@persistent
Feature: explorer.feature
# letzter Test: 20200424 laeuft ohne Fehler durch
# Funktion:
# 1. Aufrufen der Dateien fuer sy/EXPLORER
# 2. Ein Verzeichnis zurueck gehen und die fop.txt suchen    
Scenario: 1 Testen der FOPs fuer sy/EXPLORER     
################################################################################
#01 Testen der FOPs fuer sy/EXPLORER 
Given I'm logged in with password "adm"
Given I open the infosystem "EXPLORER"
And I set field "verzeichnis1" to "sy"
And I set field "suchbegriff" to "explorer"
And I press start
Then the table has 6 rows
Then table has values
    | tzeilenicon       | tdattyp1  | 
    | icon:text_edit    | FOP       |
    | icon:text_edit    | FOP       |
    | icon:text_edit    | FOP       |
    | icon:text_edit    | FOP       |
    | icon:text_edit    | FOP       |
	| icon:text_edit    | FOP       |
#01 Ein Verzeichnis zurueck gehen und die fop.txt suchen
And I press button "einszurueck" 
And I set field "suchbegriff" to "fop.txt"
And I press start
And I set field "indatsuch" to "42"
Then the table has 1 rows
Then table has values
    | tzeilenicon            | tdattyp1  | ttreffer  | tdatei1|
    | icon:text_edit_disabled|           | icon:ok   | fop.txt|
And I close the current editor

Scenario: 2 rekursives suchen 

Given I'm logged in with password "adm"
Given I open the infosystem "EXPLORER"
And I set field "rekursiv" to "nein"
And I set field "suchbegriff" to "explorer.test"
And I press start
Then the table has 0 rows
And I set field "rekursiv" to "ja"
And I set field "suchbegriff" to "explorer.test"
And I press start
Then the table has 1 rows
Then table has values
    | tzeilenicon            | tdattyp1   |   tdatei1   |
    | icon:text_edit         | FOP        |EXPLORER.TEST|
And I close the current editor

Scenario: 3 nur Treffer anzeigen

Given I'm logged in with password "adm"
Given I open the infosystem "EXPLORER"
And I set field "nurtrefferzeigen" to "ja"
And I set field "verzeichnis1" to "sy"
And I set field "suchbegriff" to "explorer"
And I press start
Then the table has 6 rows
And I set field "indatsuch" to "regreplace"
Then the table has 2 rows
Then table has values
    | tzeilenicon       | tdattyp1  | 
    | icon:text_edit    | FOP       |
    | icon:text_edit    | FOP       |
And I close the current editor

Scenario: 4 Syntax-Prüfung der Vorbelegung
Given I'm logged in with password "adm"
Given I open the infosystem "EXPLORER"
Then field "statuspfad1" has value ""
Then field "statusdattyp1" has value "icon:ball_green"
Then field "statussich" has value ""
And I close the current editor










