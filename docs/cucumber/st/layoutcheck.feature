@persistent
@FP_TEST
Feature: Daten anlegen fuer Infosystem LAYOUTCHECK

Scenario: alle Felder checken
Given I open the infosystem "LAYOUTCHECK"
And I set field "standard" to "1"
And I set field "individuell" to "1"
And I set field "aktiv" to "1"
And I set field "ausgabekanal" to "JASPER"
And I set field "layarb" to "ev"
And I press button "bstart"
Then the table has 0 rows
And I close the current editor

Scenario: Alle Layouts laden und checken
Given I open the infosystem "LAYOUTCHECK"
And I press button "bstart"
Then the table has 7 rows
Then field "tstatus" has value "icon:minus" in row 1
Then field "tstatus" has value "icon:minus" in row 2
Then field "tstatus" has value "icon:minus" in row 3

#Then field "tfehlerinfo" has value 
#"""
#Das Feld tzukuenftig777 fehlt im LOPAPAR. Aber es wird im Layout deklariert.
#ACHTUNG! Dieses Feld wird im Layout verwendet.
#ACHTUNG! Dieses Feld mit Präfix wird im Layout verwendet.
#Das Feld faellzukint777 fehlt im LOPAPAR. Aber es wird im Layout deklariert.
#ACHTUNG! Dieses Feld wird im Layout verwendet.
#Das Feld such ist im LOPAPAR nicht in den Druckdaten enthalten. Aber es wird im Layout deklariert.
#Das Feld faellzuk ist im LOPAPAR nicht in den Druckdaten enthalten. Aber es wird im Layout deklariert.
#""" in row 1

Then field "tstatus" has value "icon:attention" in row 4
Then field "tfehlerinfo" has value "Das Feld zarttext1 fehlt im ZAHLAVIS. Aber es wird im Layout deklariert." in row 4
Then field "tstatus" has value "icon:minus" in row 5

#Then field "tfehlerinfo" has value 
#"""
#Das Feld waehr777 fehlt im BABEINZEL2. Aber es wird im Layout deklariert.
#ACHTUNG! Dieses Feld wird im Layout verwendet.
#""" in row 3

And I press button "copyall"
And I press button "repair"
Then the table has 6 rows
Then file "win/jasper/layout/op/ZAHLAVIS.TABELLE.jrxml" contains text "zarttext1" not
Then file "win/jasper/layout/op/ZAHLAVIS.TABELLE_[0-9]{14}_BACKUP.jrxml" exists
Then file "win/jasper/layout/op/LOPAPAR.STD.jrxml" contains text "faellzukint777"
Then file "win/jasper/layout/op/LOPAPAR.STD_[0-9]{14}_BACKUP.jrxml" exists not
And I close the current editor

