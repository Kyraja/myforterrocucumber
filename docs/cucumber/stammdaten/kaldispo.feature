#***************************************************************************
#  Name           : kaldispo.feature
#  Datum          : 26.11.2012
#  Vers.          :
#  Autor          : foe
#  Verantwortlich : foe
#  Funktion       : Laderscript zum Testen des Dispoanstoss bei Kalenderänderungen
#
#***************************************************************************
#
@persistent
Feature: Dispo und Kalender

Background:
Given I set the fake date to "01.02.1995"

Scenario: Prüfen des Dispostatus vor dem Kalenderaenderungen
Given I execute shell command "echo \"Dispostatus vor Änderung des Standardkalenders (0 Einträge)\" >> KALDISPO2.REF"
Given I execute shell command "echo \"---------------------------------------------------------------\" >> KALDISPO2.REF"
# Dispostatus ausgeben und Dispo starten
Given I execute shell command "PATESTFLAGGEN=\"-f 261 -f 2\" edpimport.sh -o date=2.1.95 -p sy dispo.edp -H KALDISPO2.REF >> KALDISPO2.REF 2>> ref_kaldispo.err"
Given I execute shell command "echo \"---------------------------------------------------------------\" >> KALDISPO2.REF"
#
Scenario: Neuer Feiertag in Standardkalender
Given I open an editor "KALSTD" from table "(Calendar):(SchedulingCalendar)" with command "UPDATE" for record "KALSTD"
And I create a new row at the end of the table
And I set field "anf" to "01.01.1996" in row 1
And I set field "end" to "01.01.1996" in row 1
And I save the current editor
#
Given I execute shell command "echo \"Dispostatus nach Änderung des Standardkalenders (6 Einträge)\" >> KALDISPO2.REF"
Given I execute shell command "echo \"---------------------------------------------------------------\" >> KALDISPO2.REF"
# Dispostatus ausgeben und Dispo starten
Given I execute shell command "PATESTFLAGGEN=\"-f 261 -f 2\" edpimport.sh -o date=2.1.95 -p sy dispo.edp -H KALDISPO2.REF >> KALDISPO2.REF 2>> ref_kaldispo.err"
Given I execute shell command "echo \"---------------------------------------------------------------\" >> KALDISPO2.REF"
#
Scenario: Änderung des Kapazitätsangebot einer Abteilung und einer Maschinengruppe
# Abteilungskalender aendern
Given I open an editor "ABTKAL" from table "(Calendar):(AvailableCapacity)" with command "UPDATE" for record "C1"
And I create a new row at the end of the table
And I set field "anf" to "06.01.1995" in row 1
And I set field "end" to "06.01.1995" in row 1
And I set field "abzu" to "-1" in row 1
And I save the current editor
#
# Kapazitaetsangebot C111 aendern
Given I open an editor "MGRKAL" from table "(Calendar):(AvailableCapacity)" with command "UPDATE" for record "C111"
# Zuschlag in Zeile auf Einzelkapazität -> Gesamtkapazität
And I set field "abzugesamt" to "ja" in row 1
And I save the current editor
#
Given I execute shell command "echo \"Dispostatus nach Änderung des Kapazitätsangebot einer Abteilung und einer Maschinengruppe (3 Einträge)\" >> KALDISPO2.REF"
Given I execute shell command "echo \"---------------------------------------------------------------\" >> KALDISPO2.REF"
# Dispostatus ausgeben und Dispo starten
Given I execute shell command "PATESTFLAGGEN=\"-f 261 -f 2\" edpimport.sh -o date=2.1.95 -p sy dispo.edp -H KALDISPO2.REF >> KALDISPO2.REF 2>> ref_kaldispo.err"
Given I execute shell command "echo \"---------------------------------------------------------------\" >> KALDISPO2.REF"
#
Scenario: Fertigunsvorschlag mit grossem Kapazitätsbedarf anlegen
Given I open an editor "Fertigungsvorschlag1" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
   | artikel | mge |
   | BG1     | 1   |
And I press button "absteig" to open a subeditor for "afl" in row 1
And I set field "elanzahl" to "4000" in row 1
And I save the current editor
# Aufsteigen in Fertigungsliste
And I switch the current editor to editor "Fertigungsvorschlag1"
And I set field "mge" to "6000" in row 1
And I save the current editor
#
Given I execute shell command "echo \"Dispostatus nach Erzeugen eines Fertigunsvorschlag (2 Teile)\" >> KALDISPO2.REF"
Given I execute shell command "echo \"---------------------------------------------------------------\" >> KALDISPO2.REF"
# Dispostatus ausgeben und Dispo starten
Given I execute shell command "PATESTFLAGGEN=\"-f 261 -f 2\" edpimport.sh -o date=2.1.95 -p sy dispo.edp -H KALDISPO2.REF >> KALDISPO2.REF 2>> ref_kaldispo.err"
Given I execute shell command "echo \"---------------------------------------------------------------\" >> KALDISPO2.REF"
#
Scenario: Auftrag mit BG2 in grosser Menge anlegen
# Artikel BG2 erzeugen
# Grosser Umrechnungsfaktor Preiseinheit in Lagereinheit (fvle)
Given I open an editor "TeilBG2" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set fields
	| such   | BG2        |
	| name   | Bauteil 2  |
	| fvhle  | 99999      |
	| fvple  | 99999      |
And I save the current editor
#
# Auftrag mit BG2 in grosser Menge anlegen
Given I open an editor "VerkaufAuftrag-3" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I append rows
	| artikel | mge    |
	| BG2     | 999999 |
And I save the current editor
#
Given I execute shell command "echo \"Dispostatus nach Erzeugen eines Auftrags (1 Teil)\" >> KALDISPO2.REF"
Given I execute shell command "echo \"---------------------------------------------------------------\" >> KALDISPO2.REF"
# Dispostatus ausgeben und Dispo starten
Given I execute shell command "PATESTFLAGGEN=\"-f 261 -f 2\" edpimport.sh -o date=2.1.95 -p sy dispo.edp -H KALDISPO2.REF >> KALDISPO2.REF 2>> ref_kaldispo.err"
Given I execute shell command "echo \"---------------------------------------------------------------\" >> KALDISPO2.REF"
