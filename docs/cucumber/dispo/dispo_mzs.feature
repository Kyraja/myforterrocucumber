@persistent
Feature: dispo_mzs.feature

Background:
And I set the fake date to "02.01.95"

# **********************************************************************************
#  Name             : dispo_mzs.feature
#  Autor            : bheim
#  Verantwortlich   : bheim
#  Kontrolle        : bheim
#  Funktion         : Testet unterschiedliche Konstellationen von MZs
#  ref              : ref_dispo_misc_cu
#
# **********************************************************************************
# verwendete Stammdaten: basis_stammdaten.feature


Scenario: 01 Fertigungsvorschlag bleibt bei Terminfixierung unveraendert

# Fertigungsteil FTEST mit Losgroesse, Beschaffungsfrist und Standardmenge anlegen
Given I open an editor "FTEST" from table "(Part):(Product)" with command "STORE" for record "FTEST"
And I set fields
	| such      | FTEST             |
	| namebspr  | Fertigungsteil    |
	| bsart     | Eigenfertigung    |
	| dispoa    | bedarfsbezogen    |
	| losgr     | 50                |
	| efrist    | 23                |
	| basis     | 100               |
And I delete all rows
And I append rows
	| elex    | lge | breite | anzahl |
	| A AG1   | 20  | 20     | 1      |
	| A AG2   | 60  | 15     | 1      |
	| A AG3   | 60  | 10     | 1      |
And I save the current editor

# Kundenauftrag mit 1. Position anlegen
Given I open an editor "AUF_FTEST" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE1"
And I append rows
	| artikel | mge | wtterm   |
	| FTEST   | 30  | 31.03.95 |
And I save the current editor

And I run Scheduling

# Erzeugter Fertigungsvorschlag ist auf 18.03.95 terminiert
Given I open an editor "FV_FTEST" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "FTEST"
And I press button "ladetab"

# Termin fixieren und Vorgang fix entfernen
And I set field "fixterm" to "ja" in row 1
And I set field "sterm" to "16.03.95" in row 1
And I set field "term" to "18.03.95" in row 1
And I set field "fix" to "nein" in row 1
And I save the current editor

And I run Scheduling

# Fertigungsvorschlag bleibt unveraendert auf 18.03.95
Given I open an editor "FV_FTEST" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "FTEST"
And I press button "ladetab"
Then the table has 1 rows
Then table has values
	| !row       | mge | wtterm   |
	| $,,mge==50 | 50  | 18.03.95 |
And I close the current editor

# 2. Verkaufsposition fuer FTEST ueber 10 Stueck mit Termin 31.03.95 anlegen
Given I switch the current editor to editor "AUF_FTEST" with command "UPDATE"
And I append rows
	| artikel | mge | wtterm   |
	| FTEST   | 10  | 31.03.95 |
And I save the current editor

And I run Scheduling

# Fertigungsvorschlag bleibt unveraendert auf 18.03.95
Given I open an editor "FV_FTEST" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "FTEST"
And I press button "ladetab"
Then the table has 1 rows
Then table has values
	| !row       | mge | wtterm   |
	| $,,mge==50 | 50  | 18.03.95 |
And I close the current editor


# 3. Verkaufsposition fuer FTEST ueber 10 Stueck mit Termin 31.03.95 anlegen
Given I switch the current editor to editor "AUF_FTEST" with command "UPDATE"
And I append rows
	| artikel | mge | wtterm   |
	| FTEST   | 10  | 31.03.95 |
And I save the current editor

And I run Scheduling

# Fertigungsvorschlag bleibt unveraendert auf 18.03.95
Given I open an editor "FV_FTEST" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "FTEST"
And I press button "ladetab"
Then the table has 1 rows
Then table has values
	| !row       | mge | wtterm   |
	| $,,mge==50 | 50  | 18.03.95 |
And I close the current editor

