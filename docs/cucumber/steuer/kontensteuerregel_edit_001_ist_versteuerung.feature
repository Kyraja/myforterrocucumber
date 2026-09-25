# *****************************************************************************
#  Name             : kontensteuerregel_edit_001_ist_versteuerung.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Editierbarkeit von Kontensteuerregel mit
#                     dem Hintergrung "IST-Versteuerung":
#                     * Zusammenspiel von tkvrgstrgl <-> tkstrgl
#
#
# *****************************************************************************
@persistent
Feature: kontensteuerregel_edit_001_ist_versteuerung.feature
Background: Editierbarkeit von Kontensteuerregel


Scenario: Daten vorbereiten

# Vorgangsteuerregel mit Ist-Versteuerung
Given I open an editor "vrgstrgl-1" from table "(ProcessTaxRule):(ProcessTaxRule)" with command "COPY" for record "6000"
And I set fields
 | nummer           | 6000ist |
 | such             | EKINL-I |
 | namebspr         | Einkauf, Inland, steuerpflichtig/-frei, Ist-Versteuerung |
 | versteuerungsart | Ist-Versteuerung |
And I save the current editor
And I close the current editor

# Steuerregel mit Ist-Versteuerung
Given I open an editor "steuerregel" from table "(TaxCode):(TaxRule)" with command "COPY" for record "6000"
And I set field "namebspr" to "STRGL fuer Ist-Versteuerung"
And I set field "such" to "EKIN-IST"
And I set field "nummer" to "6000ist"
Then the table has 3 rows
And I set field "steuerzwischenkonto" to "14060" in row 1
And I set field "steuerzwischenkonto" to "14060" in row 2
And I set field "steuerzwischenkonto" to "14340" in row 3
And I save the current editor
And I close the current editor

# noch eine Steuerregel mit Ist-Versteuerung
Given I open an editor "steuerregel" from table "(TaxCode):(TaxRule)" with command "COPY" for record "6002"
And I set field "namebspr" to "STRGL fuer Ist-Versteuerung, NULL-Steuer-Schluessel"
And I set field "such" to "EKINFR-I"
And I set field "nummer" to "6002ist2"
And I set field "sts" to "0"
Then the table has 1 rows
And I set field "steuerzwischenkonto" to "" in row 1
And I save the current editor
And I close the current editor
# =========================================================================================


Scenario: KTSTRGL: wenn Ist-Versteuerung, dann nur STRGL mit Steuer-Zwischenkonten in allen Zeilen

# Kontensteuerregel mit Ist-Versteuerung
Given I open an editor "ktstrgl-1" from table "(TaxCode):(AccountTaxRule)" with command "COPY" for record "7012"
And I set field "nummer" to "7012i"
#
Then the table has 1 rows
And I set field "vrgstrgl" to "6000ist" in row 1
#   743 de  |Vorgang abgebrochen
# 10036 de  |Steuerbuchungsart der Steuerregel passt nicht zur Steuerbuchungsart der Vorgangssteuerregel.
Then saving the current editor throws the exception "10036"
And I set field "strgl" to "6000ist" in row 1
And I save the current editor
And I close the current editor
# =========================================================================================


Scenario: KTSTRGL: wenn Ist-Versteuerung, dann nur STRGL mit Steuer-Zwischenkonten in allen Zeilen

# Kontensteuerregel mit Ist-Versteuerung
Given I open an editor "ktstrgl-1" from table "(TaxCode):(AccountTaxRule)" with command "COPY" for record "7012"
And I set field "nummer" to "7012i2"
And I set field "namebspr" to "Ist-Versteuerung; NULL-Steuer-Schluessel"
#
Then the table has 1 rows
And I set field "vrgstrgl" to "6000ist" in row 1
#   743 de  |Vorgang abgebrochen
# 10036 de  |Steuerbuchungsart der Steuerregel passt nicht zur Steuerbuchungsart der Vorgangssteuerregel.
Then saving the current editor throws the exception "10036"
And I set field "strgl" to "6002ist2" in row 1
And I save the current editor
And I close the current editor
# =========================================================================================
