# *****************************************************************************
#  Name             : steuer_sonderposition_edit_001_zeile_plausi.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Plausis im Editor fuer Sonderposition (V-54-02) - Berechnung mit Zeilen
#
#
# *****************************************************************************
@persistent
Feature: steuer_sonderposition_edit_001_zeile_plausi.feature
Background: Berechnung mit Zeilen




Scenario: Neuanlegen SP mit Zeilenberechnung


Given I open an editor "sonderpos_new1" from table "(Evaluation):(SpecialItem)" with command "NEW" for record ""
Then saving the current editor throws the exception "10179"
# TODO: abfragen in welchen Feld aktuell der Kursor steht -> muesste "nummer" sein
Then setting field "nummer" to "1zeileSUMME" in row 0 throws the exception "131"
And I set field "nummer" to "1zeileSU"
Then field "bkselvar" is modifiable
# 2985 TX=de   |Ungültige Eingabe!
Then setting field "ergspalte" to "1zeileSUMME" in row 0 throws the exception "2985"
Then saving the current editor throws the exception "10179"
# TODO: abfragen in welchen Feld aktuell der Kursor steht ->  "optyp"
And I set field "optyp" to "Summierung"
Then saving the current editor throws the exception "10179"
# TODO: abfragen in welchen Feld aktuell der Kursor steht ->  "zeispal"
And I set field "zeispal" to "Zeile"
Then saving the current editor throws the exception "279"
# TODO: abfragen in welchen Feld aktuell der Kursor steht ->  "bervonzeile"
And I set field "bervonzeile" to "20"
Then saving the current editor throws the exception "279"
# TODO: abfragen in welchen Feld aktuell der Kursor steht ->  "berbiszeile"
And I set field "berbiszeile" to "22"
And I create a new row at the end of the table
Then the table has 1 rows
# 3001 : "für Funktion mindestens eine Zeile in Tabelle notwendig!"
Then saving the current editor throws the exception "3001"
# TODO: abfragen in welchen Feld aktuell der Kursor steht ->  "nspalte" in Zeile 1
And I set field "nspalte" to "bemgr" in row 1
And I save the current editor
And I close the current editor


# exception "3002"
Given I open an editor "sonderpos_new111" from table "(Evaluation):(SpecialItem)" with command "NEW" for record ""
And I set field "name" to "Berechnung: Zeile; Übertrag"
And I set field "nummer" to "77ZLueb"
And I set field "zeispal" to "Zeile"
And I set field "optyp" to "Übertrag"
And I set field "bervonzeile" to "20"
And I set field "berbiszeile" to "20"
And I create a new row at the end of the table
Then the table has 1 rows
# 3002 TX=de   |für Funktion genau eine Zeile in Tabelle notwendig!
Then saving the current editor throws the exception "3002"
And I set field "nspalte" to "bemgr" in row 1
And I save the current editor
And I close the current editor


# exception "1380" und "3001"
Given I open an editor "sonderpos_new222" from table "(Evaluation):(SpecialItem)" with command "NEW" for record ""
And I set field "name" to "Berechnung: Zeile; Multiplikation"
And I set field "nummer" to "22ZLmult"
And I set field "zeispal" to "Zeile"
And I set field "optyp" to "Multiplikation"
And I set field "bervonzeile" to "20"
And I set field "berbiszeile" to "20"
Then the table has 0 rows
# 1380 TX=de   |Falsche Eingabe
Then saving the current editor throws the exception "1380"
And I set field "berbiszeile" to "22"
And I create a new row at the end of the table
# 3001 TX=de   |für Funktion mindestens eine Zeile in Tabelle notwendig!
Then saving the current editor throws the exception "3001"
And I set field "nspalte" to "bemgr" in row 1
And I save the current editor
And I close the current editor


# exception "2983"
Given I open an editor "sonderpos_new555" from table "(Evaluation):(SpecialItem)" with command "NEW" for record ""
And I set field "name" to "Berechnung: Zeile; Multiplikation"
And I set field "nummer" to "55ZLmult"
And I set field "zeispal" to "Zeile"
And I set field "optyp" to "Multiplikation"
And I set field "bervonzeile" to "20"
And I set field "berbiszeile" to "25"
And I set field "prozm" to "Promille"
And I create a new row at the end of the table
And I set field "nspalte" to "bemgr" in row 1
Then the table has 1 rows
# 2983 de      |Nur 2 Spalten/Zeilen bei Prozent- oder Promillerechnung!
Then saving the current editor throws the exception "2983"
And I set field "berbiszeile" to "21"
And I save the current editor
And I close the current editor


#	OP_MULT   = 'm', /** Multiplikation */
Given I open an editor "sonderpos_new20" from table "(Evaluation):(SpecialItem)" with command "NEW" for record ""
And I set field "name" to "Berechnung: Zeile; Multiplikation"
And I set field "nummer" to "20ZLmult"
And I set field "zeispal" to "Zeile"
And I set field "optyp" to "Multiplikation"
And I set field "bervonzeile" to "20"
And I set field "berbiszeile" to "22"
And I create a new row at the end of the table
And I set field "nspalte" to "bemgr" in row 1
Then the table has 1 rows
# Hier muss eigentlich die Meldung kommen : "für Funktion mindestens zwei Zeilen in Tabelle notwendig!
# KOMMT ABER NICHT!!!!   ->Fehler!!!
# Then saving the current editor throws the exception "2999"
And I create a new row at the end of the table
And I set field "nspalte" to "stbetrag" in row 2
Then the table has 2 rows
And I save the current editor
And I close the current editor


#	OP_SUMM   = 's', /** Summierung     */
Given I open an editor "sonderpos_new30" from table "(Evaluation):(SpecialItem)" with command "NEW" for record ""
And I set field "name" to "Berechnung: Zeile; Summierung"
And I set field "nummer" to "30ZLsum"
And I set field "zeispal" to "Zeile"
And I set field "optyp" to "Summierung"
And I set field "bervonzeile" to "20"
And I set field "berbiszeile" to "22"
And I create a new row at the end of the table
# 3001 TX=de   |für Funktion mindestens eine Zeile in Tabelle notwendig!
Then saving the current editor throws the exception "3001"
And I set field "nspalte" to "bemgr" in row 1
And I close the current editor


#	OP_DIV    = 'd', /** Division       */
Given I open an editor "sonderpos_new40" from table "(Evaluation):(SpecialItem)" with command "NEW" for record ""
And I set field "name" to "Berechnung: Zeile; Division"
And I set field "nummer" to "40ZLdivi"
And I set field "zeispal" to "Zeile"
And I set field "optyp" to "Division"
And I set field "bervonzeile" to "20"
And I set field "berbiszeile" to "22"
And I create a new row at the end of the table
# 3001 TX=de   |für Funktion mindestens eine Zeile in Tabelle notwendig!
Then saving the current editor throws the exception "3001"
And I set field "nspalte" to "bemgr" in row 1
And I save the current editor
And I close the current editor


#	OP_SUB    = 'a', /** Subtraktion    */
Given I open an editor "sonderpos_new50" from table "(Evaluation):(SpecialItem)" with command "NEW" for record ""
And I set field "name" to "Berechnung: Zeile; Subtraktion"
And I set field "nummer" to "50ZLsub"
And I set field "zeispal" to "Zeile"
And I set field "optyp" to "Subtraktion"
And I set field "bervonzeile" to "20"
And I set field "berbiszeile" to "22"
And I create a new row at the end of the table
# 3001 TX=de   |für Funktion mindestens eine Zeile in Tabelle notwendig!
Then saving the current editor throws the exception "3001"
And I set field "nspalte" to "bemgr" in row 1
And I save the current editor
And I close the current editor


#	OP_FREIF  = 'f', /** Freifeld       */
Given I open an editor "sonderpos_new60" from table "(Evaluation):(SpecialItem)" with command "NEW" for record ""
And I set field "name" to "Berechnung: Zeile; Freifeld"
And I set field "nummer" to "60ZLfrei"
And I set field "zeispal" to "Zeile"
And I set field "optyp" to "Freifeld"
And I set field "bervonzeile" to "20"
And I set field "berbiszeile" to "22"
And I create a new row at the end of the table
# 3001 TX=de   |für Funktion mindestens eine Zeile in Tabelle notwendig!
# Then saving the current editor throws the exception "3001"
And I set field "nspalte" to "bemgr" in row 1
And I save the current editor
And I close the current editor


#	OP_UEBERTR = 'u', /** Übertrag       */
Given I open an editor "sonderpos_new70" from table "(Evaluation):(SpecialItem)" with command "NEW" for record ""
And I set field "name" to "Berechnung: Zeile; Übertrag"
And I set field "nummer" to "70ZLueb"
And I set field "zeispal" to "Zeile"
And I set field "optyp" to "Übertrag"
And I set field "bervonzeile" to "20"
And I set field "berbiszeile" to "22"
#  2976 TX=de   |Zeilen müssen für übertragsfelder gleich sein!
Then saving the current editor throws the exception "2976"
And I set field "berbiszeile" to "20"
And I create a new row at the end of the table
# 3002 TX=de   |für Funktion genau eine Zeile in Tabelle notwendig!
Then saving the current editor throws the exception "3002"
And I set field "nspalte" to "bemgr" in row 1
And I save the current editor
And I close the current editor


#	OP_LEERZ  = 'l'  /** Leerzeile      */  -> existiert nicht bei SP
Given I open an editor "sonderpos_new80" from table "(Evaluation):(SpecialItem)" with command "NEW" for record ""
And I set field "name" to "Berechnung: Zeile; Leerzeile"
And I set field "nummer" to "80ZLleer"
And I set field "zeispal" to "Zeile"
#  131 TX=de   |unzulässige Angabe
Then setting field "optyp" to "Leerzeile" in row 0 throws the exception "131"
# And I save the current editor
And I close the current editor
# =========================================================================================



Scenario: AENDERN SP mit Zeilenberechnung


Given I open an editor "sonderpos_update1" from table "(Evaluation):(SpecialItem)" with command "UPDATE" for record "1zeileSU"
And I set field "zeispal" to "Spalte"
#  2997 TX=de   |Keine Zeilenangaben notwendig! Bitte löschen!
Then saving the current editor throws the exception "2997"
And I set field "zeispal" to "Zeile"
And I set field "optyp" to "Übertrag"
#  2976 TX=de   |Zeilen müssen für übertragsfelder gleich sein!
Then saving the current editor throws the exception "2976"
And I set field "bervonzeile" to "27"
And I set field "berbiszeile" to "27"
And I set field "nummer" to "99geaend"
And I save the current editor
And I close the current editor
# =========================================================================================



Scenario: ZEIGEN SP mit Zeilenberechnung


Given I open an editor "sonderpos_view1" from table "(Evaluation):(SpecialItem)" with command "VIEW" for record "99geaend"
# FEHLER: der Button ist im Zeigen druckbar!!!
Then field "bkselvar" is modifiable
Then the table has 1 rows
# 291 TX=de   |Kommando erlaubt keine Änderungen
Then creating a new row at position 1 throws the exception "291"
And deleting the row at position 1 throws the exception "291"
And I save the current editor
And I close the current editor
# =========================================================================================



Scenario: LOESCHEN SP mit Zeilenberechnung


# nicht verwendetes Objekt
Given I open an editor "sonderpos_delete1" from table "(Evaluation):(SpecialItem)" with command "DELETE" for record "99geaend"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor
# =========================================================================================


