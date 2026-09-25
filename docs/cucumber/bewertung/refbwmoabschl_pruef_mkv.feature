# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      : sih
# *****************************************************************************
@persistent
Feature: Monatsabschlussplausibilisierung für Materialkostenverbuchungen 

# Herstellung der notwendigen uE-Verbuchbarkeit vorgelagert im Testbett per fake
# Modulweise Prüfung auf Kostenbuchungen und JEWEILIGES SCHEITERN des versuchten Monatsabschlusses.
# Modulweise Verbuchung um das nächste Modul auf Kostenbuchungen zu prüfen
# Am Ende erfolgreicher Monatsabschluss
# Prüftdaten exportieren separat nachgelagert, weil das hier mal wieder nicht einfach ging. 

Background:
Given I set the fake date to "1.02.2002"

# ---------------------------------------------------------------------------------------------
Scenario: alle kostenarten starten 
# ---------------------------------------------------------------------------------------------
Given I'm logged in with password "sy"
Given I set the fake date to "1.04.2002"

Given I open an editor "startdat_lb" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "adat" to "01.01.2002" 
And I set field "edat" to "01.01.2002"
And I set field "kosart" to "Verbuchung Lagerbestand"
# CONFIRMATION dialog: id=[5567] title=[] prompt=[Kostenbuchungsvorschlag speichern und Startdatum auf den 01.01.02 setzen. Weiter?]
# defaultAnswer=[dialogId=[5567] answer=[1]]
And I respond with answer "yes" to the dialog with id "5567"
And I save the current editor

Given I open an editor "startdat_lbue" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "adat" to "01.01.2002" 
And I set field "edat" to "01.01.2002"
And I set field "kosart" to "Verbuchung Bestand unfertige Erzeugnisse"
# CONFIRMATION dialog: id=[5567] title=[] prompt=[Kostenbuchungsvorschlag speichern und Startdatum auf den 01.01.02 setzen. Weiter?]
# defaultAnswer=[dialogId=[5567] answer=[1]]
And I respond with answer "yes" to the dialog with id "5567"
And I save the current editor


Given I open an editor "startdat_fk" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "adat" to "01.01.2002" 
And I set field "edat" to "01.01.2002"
And I set field "kosart" to "Verbuchung Fertigungskosten"
# CONFIRMATION dialog: id=[5567] title=[] prompt=[Kostenbuchungsvorschlag speichern und Startdatum auf den 01.01.02 setzen. Weiter?]
# defaultAnswer=[dialogId=[5567] answer=[1]]
And I respond with answer "yes" to the dialog with id "5567"
And I save the current editor


Given I open an editor "startdat_fkue" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "adat" to "01.01.2002" 
And I set field "edat" to "01.01.2002"
And I set field "kosart" to "Verbuchung Fertigungskosten unfertige Erzeugnisse"
# CONFIRMATION dialog: id=[5567] title=[] prompt=[Kostenbuchungsvorschlag speichern und Startdatum auf den 01.01.02 setzen. Weiter?]
# defaultAnswer=[dialogId=[5567] answer=[1]]
And I respond with answer "yes" to the dialog with id "5567"
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: mk-noch-offen-mkue-noch-offen 
# ---------------------------------------------------------------------------------------------
Given I'm logged in with password "sy"
Given I set the fake date to "1.04.2002"


Given I open an editor "eine-bew-ni-verbuchbar-machen" from table "(Valuation):(Valuation)" with command "UPDATE" for search criteria "$,,historisch==nein;beistelldaten==ja;artikel==BGLIEFBEI1;ursache==Rechnung;tetlbkto==15;lbstatus==verbuchbar;@maxtreffer=1"
And I set field "tbewpr" to "0" in row 1
And I save the current editor

And I run Revaluation 

Given I open an editor "Monatsabschluss1" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
And I set fields
    | such | SCHEITERT-MAE-MKLB   |
And I press button "mbbbu" in row 6
And I respond with answer "Ja" to the dialog with id "7626"
And I save the current editor


Given I open an editor "Monatsabschluss1v" from table "(FiscalYearManagement):(Closings)" with command "VIEW" for record "+SCHEITERT-MAE-MKLB"
# steht auch in der referenz
Then field "ergcodetxt" has value "Abschlüsse nicht erfolgreich durchgeführt."
And I close the current editor

# ---------------------------------------------------------------------------------------------
Scenario: mk-gebucht mkue-noch-offen moab
# ---------------------------------------------------------------------------------------------

Given I'm logged in with password "sy"
Given I set the fake date to "1.04.2002"

Given I open an editor "kosbu-mae-mk" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "adat" to "01.03.2002" 
And I set field "edat" to "31.03.2002"
# And I set field "niverbausw" to "nein"
And I set field "kosart" to "Verbuchung Lagerbestand"
And I press button "kosvor"
And I respond with answer "ja" to the dialog with id "2324"
And I save the current editor

Given I open an editor "Monatsabschluss2" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
And I set fields
    | such | SCHEITERT-MAE-MKUE |
And I press button "mbbbu" in row 6
And I respond with answer "Ja" to the dialog with id "7626"
And I save the current editor

Given I open an editor "Monatsabschluss2v" from table "(FiscalYearManagement):(Closings)" with command "VIEW" for record "+SCHEITERT-MAE-MKUE"
And I close the current editor

Given I execute shell command "echo '==== ausgabe aus cucumber-skript'   >>refbwmoabschl_pruef_mkv.ref  2>>refbwmoabschl_pruef_mkv.cucu.err"
Given I execute shell command "echo 'Pruefung Lagerbestand im Moab OK, trotz dieser Konfliktbewertung:'   >>refbwmoabschl_pruef_mkv.ref  2>>refbwmoabschl_pruef_mkv.cucu.err"
Given I execute shell command "echo 'DIE KONFLIKTBEWERTUNG 8 VERBLEIBT NICHT IM GESPEICHERTEN KOSBUVOR OBWOHL SIE SELEKTIERT WIRD'   >>refbwmoabschl_pruef_mkv.ref  2>>refbwmoabschl_pruef_mkv.cucu.err"
Given I execute shell command "PATESTFLAGGEN=\"-f 261 -f 2\" edpexport.sh -o date=1.4.02 -p sy -l 130:1 -f nummer,konfliktda,konfliktvorg,zn,tlbstatus,tbudat -F -t'|' -k konfliktda==ja -Z  | ${HOMESRC}/std/tbin/addHeadAndSepRowsToCsv.sh nummer | ${HOMESRC}/std/tbin/csv2fix.sh '|'  >>refbwmoabschl_pruef_mkv.ref 2>>refbwmoabschl_pruef_mkv.cucu.err"

# ---------------------------------------------------------------------------------------------
Scenario: mk-gebucht-mkue-gebucht-moab 
# ---------------------------------------------------------------------------------------------

Given I'm logged in with password "sy"
Given I set the fake date to "1.04.2002"

Given I open an editor "kosbu-mae-mkue" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "adat" to "01.03.2002" 
And I set field "edat" to "31.03.2002"
# And I set field "niverbausw" to "nein"
And I set field "kosart" to "Verbuchung Bestand unfertige Erzeugnisse"
And I press button "kosvor"
And I respond with answer "ja" to the dialog with id "2324"
And I save the current editor

Given I open an editor "Monatsabschluss3" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
And I set fields
    | such | ERFOLGREICH-MAE-MKV |
And I press button "mbbbu" in row 6
And I respond with answer "Ja" to the dialog with id "7626"
And I save the current editor

Given I open an editor "Monatsabschluss3v" from table "(FiscalYearManagement):(Closings)" with command "VIEW" for record "+ERFOLGREICH-MAE-MKV"
And I close the current editor
