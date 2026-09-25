# *****************************************************************************************
#  Name           : steuer_aktuell_stammdaten_002_ausland.feature
#  Verantwortlich : wane
#  Funktion       : legt Stammdaten fuer die Tests mit Ausland
#
#
# ****************************************************************************************
@persistant

Feature: Stammdaten fuer ref_steuer_aktuell_cu

Background:


Scenario: Steuerschluessel

# MWST in der Schweiz
Given I open an editor "sts-001" from table "(TaxCode):(TaxCode)" with command "COPY" for record "1"
And I set field "nummer" to "50"
And I set field "such" to "CH50"
And I set field "ustland" to "Schweiz"
And I set field "name" to "Steuerpflichtige Umsaetze, 8,1%"
#
And I set field "psatz" to "8,1" in row 1
And I save the current editor
And I close the current editor
# ================================================================================================

Scenario: USTVA-Positionen

# USTVA-Position fuer Schweiz
Given I open an editor "ustva-001" from table "(Evaluation):(ItemNumber)" with command "COPY" for record "81"
And I set field "nummer" to "81ch"
And I set field "such" to "P81CH"
And I set field "ustland" to "Schweiz"
And I set field "name" to "Regelsatz in Schweiz: 8,1%"
And I set field "text" to "Steuerpflichtige Umsaetze zum Regelsatz in Schweiz: 8,1%"
#
And I set field "sts" to "50" in row 1
And I save the current editor
And I close the current editor


# USTVA-Position (Kontrolle) fuer Schweiz
Given I open an editor "ustva-005" from table "(Evaluation):(ItemNumber)" with command "COPY" for record "581"
And I set field "nummer" to "581ch"
And I set field "such" to "K581CH"
And I set field "ustland" to "Schweiz"
And I set field "name" to "Kontroll, Regelsatz in Schweiz: 8,1%"
And I set field "text" to "Kontrolle, Steuerpflichtige Umsaetze zum Regelsatz in Schweiz: 8,1%"
#
And I set field "sts" to "50" in row 1
And I save the current editor
And I close the current editor
# ================================================================================================

