# *****************************************************************************
#  Name             : steuer_sonderposition_edit_002_spalte_plausi.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Plausis im Editor fuer Sonderposition (V-54-02) - Berechnung mit Spalten
#
#
# *****************************************************************************
@persistent
Feature: steuer_sonderposition_edit_002_spalte_plausi.feature
Background: Berechnung mit Spalten




Scenario: Neuanlegen SP mit Spaltenberechnung


Given I open an editor "sonderpos_new10" from table "(Evaluation):(SpecialItem)" with command "NEW" for record ""
Then saving the current editor throws the exception "10179"
# TODO: abfragen in welchen Feld aktuell der Kursor steht -> muesste "nummer" sein
Then setting field "nummer" to "1spalteSUMME" in row 0 throws the exception "131"
And I set field "nummer" to "1spalteS"
Then saving the current editor throws the exception "10179"
# TODO: abfragen in welchen Feld aktuell der Kursor steht ->  "optyp"
And I set field "optyp" to "Summierung"
Then saving the current editor throws the exception "10179"
# TODO: abfragen in welchen Feld aktuell der Kursor steht ->  "zeispal"
And I set field "zeispal" to "Spalte"
And I set field "fueralle" to "ja"
#  2997 TX=de   |Keine Zeilenangaben notwendig! Bitte löschen!
Then saving the current editor throws the exception "2997"
And I set field "fueralle" to "nein"
#  2999 TX=de   |für Funktion mindestens zwei Zeilen in Tabelle notwendig!
Then saving the current editor throws the exception "2999"
And I create a new row at the end of the table
And I set field "nspalte" to "stbetrag" in row 1
Then saving the current editor throws the exception "2999"
And I create a new row at the end of the table
# 2985 TX=de   |Ungültige Eingabe!
Then setting field "nspalte" to "ststeuer1" in row 2 throws the exception "2985"
And I set field "nspalte" to "stbetrag" in row 2
And I save the current editor
And I close the current editor


# 2983
Given I open an editor "sonderpos_new567" from table "(Evaluation):(SpecialItem)" with command "NEW" for record ""
And I set field "name" to "Berechnung: Spalte; Multiplikation"
And I set field "nummer" to "95SPmult"
And I set field "zeispal" to "Spalte"
And I set field "optyp" to "Multiplikation"
And I set field "prozm" to "Promille"
#  2983 TX=de   |Nur 2 Spalten/Zeilen bei Prozent- oder Promillerechnung!
Then saving the current editor throws the exception "2983"
And I close the current editor


#	OP_MULT   = 'm', /** Multiplikation */
Given I open an editor "sonderpos_new20" from table "(Evaluation):(SpecialItem)" with command "NEW" for record ""
And I set field "name" to "Berechnung: Spalte; Multiplikation"
And I set field "nummer" to "20SPmult"
And I set field "zeispal" to "Spalte"
And I set field "optyp" to "Multiplikation"


#  2999 TX=de   |für Funktion mindestens zwei Zeilen in Tabelle notwendig!
Then saving the current editor throws the exception "2999"
And I create a new row at the end of the table
And I set field "nspalte" to "bemgr" in row 1
Then the table has 1 rows
Then saving the current editor throws the exception "2999"
Then the table has 1 rows
And I create a new row at the end of the table
And I set field "nspalte" to "stbetrag" in row 2
Then the table has 2 rows
And I save the current editor
And I close the current editor


#	OP_SUMM   = 's', /** Summierung     */
Given I open an editor "sonderpos_new30" from table "(Evaluation):(SpecialItem)" with command "NEW" for record ""
And I set field "name" to "Berechnung: Spalte; Summierung"
And I set field "nummer" to "30SPsum"
And I set field "zeispal" to "Spalte"
And I set field "optyp" to "Summierung"
And I create a new row at the end of the table
And I set field "nspalte" to "bemgr" in row 1
Then the table has 1 rows
And I create a new row at the end of the table
And I set field "nspalte" to "stbetrag" in row 2
And I save the current editor
And I close the current editor


#	OP_DIV    = 'd', /** Division       */
Given I open an editor "sonderpos_new40" from table "(Evaluation):(SpecialItem)" with command "NEW" for record ""
And I set field "name" to "Berechnung: Spalte; Division"
And I set field "nummer" to "40SPdivi"
And I set field "zeispal" to "Spalte"
And I set field "optyp" to "Division"
And I create a new row at the end of the table
And I set field "nspalte" to "bemgr" in row 1
Then the table has 1 rows
And I create a new row at the end of the table
And I set field "nspalte" to "stbetrag" in row 2
Then field "nspalte" has value "bemgr" in row 1
Then field "nspalte" has value "stbetrag" in row 2
Then moving rows "2" to position "1" throws the exception "9871"
Then field "nspalte" has value "bemgr" in row 1
Then field "nspalte" has value "stbetrag" in row 2
And I save the current editor
And I close the current editor


#	OP_SUB    = 'a', /** Subtraktion    */
Given I open an editor "sonderpos_new50" from table "(Evaluation):(SpecialItem)" with command "NEW" for record ""
And I set field "name" to "Berechnung: Spalte; Subtraktion"
And I set field "nummer" to "50SPsub"
And I set field "zeispal" to "Spalte"
And I set field "optyp" to "Subtraktion"
And I create a new row at the end of the table
And I set field "nspalte" to "bemgr" in row 1
Then the table has 1 rows
And I create a new row at the end of the table
And I set field "nspalte" to "stbetrag" in row 2
And I save the current editor
And I close the current editor


#	OP_FREIF  = 'f', /** Freifeld       */
Given I open an editor "sonderpos_new60" from table "(Evaluation):(SpecialItem)" with command "NEW" for record ""
And I set field "name" to "Berechnung: Spalte; Freifeld"
And I set field "nummer" to "60SPfrei"
And I set field "zeispal" to "Spalte"
And I set field "optyp" to "Freifeld"
And I create a new row at the end of the table
And I set field "nspalte" to "bemgr" in row 1
Then the table has 1 rows
And I create a new row at the end of the table
And I set field "nspalte" to "stbetrag" in row 2
And I save the current editor
And I close the current editor


#	OP_UEBERTR = 'u', /** Übertrag       */
Given I open an editor "sonderpos_new70" from table "(Evaluation):(SpecialItem)" with command "NEW" for record ""
And I set field "name" to "Berechnung: Spalte; Übertrag"
And I set field "nummer" to "70SPueb"
And I set field "zeispal" to "Spalte"
And I set field "optyp" to "Übertrag"
And I create a new row at the end of the table
And I set field "nspalte" to "bemgr" in row 1
Then the table has 1 rows
And I create a new row at the end of the table
And I set field "nspalte" to "stbetrag" in row 2
# 3002 TX=de   |für Funktion genau eine Zeile in Tabelle notwendig!
Then saving the current editor throws the exception "3002"
And I delete row at position !lastRow
And I save the current editor
And I close the current editor


#	OP_LEERZ  = 'l'  /** Leerzeile      */
Given I open an editor "sonderpos_new80" from table "(Evaluation):(SpecialItem)" with command "NEW" for record ""
And I set field "name" to "Berechnung: Spalte; Leerzeile"
And I set field "nummer" to "80SPleer"
And I set field "zeispal" to "Spalte"
#  131 TX=de   |unzulässige Angabe
Then setting field "optyp" to "Leerzeile" in row 0 throws the exception "131"
# And I save the current editor
And I close the current editor
# =========================================================================================



Scenario: AENDERN SP mit Spaltenberechnung


Given I open an editor "sonderpos_upd1" from table "(Evaluation):(SpecialItem)" with command "UPDATE" for record "40SPdivi"
And I set field "fueralle" to "ja"
#  2997 TX=de   |Keine Zeilenangaben notwendig! Bitte löschen!
Then saving the current editor throws the exception "2997"
And I set field "fueralle" to "nein"
And I set field "nummer" to "11geaend"
Then field "nspalte" has value "bemgr" in row 1
Then field "nspalte" has value "stbetrag" in row 2
Then moving rows "2" to position "1" throws the exception "9871"
And I save the current editor
And I close the current editor
# =========================================================================================



Scenario: ZEIGEN SP mit Spaltenberechnung


Given I open an editor "sonderpos_upd1" from table "(Evaluation):(SpecialItem)" with command "VIEW" for record "11geaend"
# 291 TX=de   |Kommando erlaubt keine Änderungen
Then moving rows "2" to position "1" throws the exception "291"
Then creating a new row at position 1 throws the exception "291"
And I close the current editor
# =========================================================================================



Scenario: LOESCHEN SP mit Spaltenberechnung


# nicht verwendetes Objekt
Given I open an editor "sonderpos_delete1" from table "(Evaluation):(SpecialItem)" with command "DELETE" for record "11geaend"

And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor
# =========================================================================================


