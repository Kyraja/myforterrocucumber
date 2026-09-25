# *****************************************************************************
#  Name           : ctc_test.feature
#  Autor          : lclaus
#  Verantwortlich : lclaus
#  Kontrolle      : mibr
#  Funktion       : Versuchstest zur Reaktivierung der Testabdeckungsreports mit Cucumber-Beruecksichtigung
#
# *****************************************************************************
#
@persistent
Feature: Kunden Stammdaten
Background:
Given I set the fake date to "05.01.1995"
#
# Vorhaben: Kunde anlegen - Anfrage zu Kunde anlegen - Anfrage zu AU - AU zu LS - LS zu RE - RLS auf LS - WGS auf RLS - Storno auf WGS
#--------------------------------------------------------------------------
Scenario: Kunde KCTC Anlegen
#--------------------------------------------------------------------------
Given I open an editor "KundeKunde-1" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set fields
	| nummer   | 2221                        |
	| such     | KCTC                        |
	| name     | CTC Experte                 |
	| ans      | CTC AG                      |
	| str      | Hinterm sauren Apfel 39-41  |
	| staat    | DEUTSCHLAND                 |
	| plz      | 33940                       |
	| nort     | Kastroprauxel               |
	| ans2     | CTC Werk                    |
	| str2     | Hinterm sauren Apfel 42     |
	| plz2     | 33940                       |
	| nort2    | Kastroprauxel               |
	| waehr    | DEM                         |
	| ustid    | DE200                       |
	| rechnung | 6                           |
	| gewaehr  | 17                          |
	| lbed     | CPT                         |
	| pbed     |                             |
	| zbed     |  201                        |
	| anrede   | 51                          |
And I save the current editor


#--------------------------------------------------------------------------
Scenario: Angebot zu KCTC
#--------------------------------------------------------------------------
Given I open an editor "VerkaufAngebot-2" from table "(Sales):(Quotation)" with command "NEW" for record ""
And I set fields
	| kunde  | KCTC    |
	| nummer | 1AN011  |
And I append rows
	| artikel | mge |
	| E2      | 11  |
And I save the current editor


#--------------------------------------------------------------------------
Scenario: Auftrag zum Angebot
#--------------------------------------------------------------------------
Given I open an editor "VerkaufAuftrag-3" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| beleg  | 1AN011  |
	| nummer | 1AU011  |
And I save the current editor


#--------------------------------------------------------------------------
Scenario: Lieferschein zum Auftrag
#--------------------------------------------------------------------------
Given I open an editor "Verkaufauftrag-3.4" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "VerkaufAuftrag-3"
And I set fields
	| nummer | 999911  |
	| vom    | .       |
	| ueb    | ja      |
# TO DO: ZEILENANFANG <uebertragen> (propably done)
And I set field "mge" to "11" in row 1
And I save the current editor


#--------------------------------------------------------------------------
Scenario: Rechnung zum Lieferschein
#--------------------------------------------------------------------------
Given I open an editor "" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "999911"
And I set fields
	| nummer | 11r  |
	| vom    | .    |
	| ueb    | ja   |
And I set field "mge" to "11" in row 1
And I save the current editor
# TO DO: <?> ja (Dialogabfrage catchen)
#And I respond with answer "ja" to the dialog with id "4841"
And I close the current editor


#--------------------------------------------------------------------------
Scenario: Ruecklieferschein zum Lieferschein
#--------------------------------------------------------------------------
Given I open an editor "" from table "(Sales):(PackingSlip)" with command "RETURN" for record "+999911"
And I set fields
	| nummer | 999911R  |
	| ueb    | ja       |
And I set field "mge" to "-11" in row 1
And I save the current editor


#--------------------------------------------------------------------------
Scenario: Kaufm.GS zum RLS
#--------------------------------------------------------------------------
Given I open an editor "" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "999911R"
And I set fields
	| nummer | 999911GS   |
	| vom    | .          |
	| tterm  | .          |
	| ueb    | ja         |
And I save the current editor
# TO DO: <?> ja (Dialogabfrage catchen)
And I close the current editor


#--------------------------------------------------------------------------
Scenario: Kaufm.GS stornieren
#--------------------------------------------------------------------------
Given I open an editor "" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+999911GS"
And I set fields
	| nummer | 999911ST     |
And I save the current editor
