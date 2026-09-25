# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      : sih
# *****************************************************************************
@persistent
Feature: Monatsabschlussplausibilisierung für Fertigungskostenverbuchungen 

# Modulweise Prüfung auf Kostenbuchungen und JEWEILIGES SCHEITERN des versuchten Monatsabschlusses.
# Modulweise Verbuchung um das nächste Modul auf Kostenbuchungen zu prüfen
# Am Ende erfolgreicher Monatsabschluss
# Prüftdaten separat, weil das hier mal wieder nicht ging. 

Background:
Given I set the fake date to "1.02.2002"

# ---------------------------------------------------------------------------------------------
Scenario: alle startdatuemer fkv mkv setzen 
# ---------------------------------------------------------------------------------------------
Given I'm logged in with password "sy"
Given I set the fake date to "1.02.2002"

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
Scenario: fk-noch-offen-fkue-noch-offen 
# ---------------------------------------------------------------------------------------------
Given I'm logged in with password "sy"
Given I set the fake date to "1.02.2002"


Given I open an editor "Monatsabschluss1" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
And I set fields
    | such | SCHEITERT-JAN-FKLB   |
And I press button "mbbbu" in row 4
And I respond with answer "Ja" to the dialog with id "7626"
And I save the current editor


Given I open an editor "Monatsabschluss1v" from table "(FiscalYearManagement):(Closings)" with command "VIEW" for record "+SCHEITERT-JAN-FKLB"
# steht auch in der referenz
Then field "ergcodetxt" has value "Abschlüsse nicht erfolgreich durchgeführt."

#  And I press button "abprt" to open a subeditor for "gaga1"
#  # msg 8485
#  Then field "opfehltxt" has value "Es stehen Kostenbuchungen Fertigungskosten an. Bitte verbuchen." in row 4
#  And I close the current subeditor to switch back to the parent editor

And I close the current editor

## tut alles nicht!!!!!   auch nicht mit   DIR  cucumber/refs      im testbett 
# And I delete file "protokollmeldung_fertigungskosten_januar.txt" in cucu_refs_dir
# And I append "jodel3" to output file "protokollmeldung_fertigungskosten_januar.txt"
# And I export "nummer,such" from table "(FiscalYearManagement):(ClosingLog)" where "@ablageart=beides" to output file "protokollmeldung_fertigungskosten_januar22.txt"
# And I append text "" to output file "cucumber/refs/alternativpos.out"
# And I export "lgruppe,lager,platz,charge,projekt,verw,gebmge,lffert,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==E1;gebmge<>0;@ordnung=artikel,lgruppe.rueckw,platz.rueckw,charge,projekt,verw,gebmge.rueckw,lj^id" to output file "cucu_export_in_datei.ref"


# ---------------------------------------------------------------------------------------------
Scenario: fk-gebucht-fkue-noch-offen 
# ---------------------------------------------------------------------------------------------

Given I'm logged in with password "sy"
Given I set the fake date to "1.02.2002"

Given I open an editor "kosbu-jan-fk" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "adat" to "01.01.2002" 
And I set field "edat" to "31.01.2002"
And I set field "niverbausw" to "nein"
And I set field "kosart" to "Verbuchung Fertigungskosten"
And I press button "kosvor"
And I respond with answer "ja" to the dialog with id "2324"
And I save the current editor

Given I open an editor "Monatsabschluss2" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
And I set fields
    | such | SCHEITERT-JAN-FKUE |
And I press button "mbbbu" in row 4
And I respond with answer "Ja" to the dialog with id "7626"
And I save the current editor

Given I open an editor "Monatsabschluss2v" from table "(FiscalYearManagement):(Closings)" with command "VIEW" for record "+SCHEITERT-JAN-FKUE"
And I close the current editor

# ---------------------------------------------------------------------------------------------
Scenario: fk-gebucht-fkue-gebucht 
# ---------------------------------------------------------------------------------------------

Given I'm logged in with password "sy"
Given I set the fake date to "1.02.2002"

Given I open an editor "kosbu-jan-fkue" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "adat" to "01.01.2002" 
And I set field "edat" to "31.01.2002"
And I set field "niverbausw" to "nein"
And I set field "kosart" to "Verbuchung Fertigungskosten unfertige Erzeugnisse"
And I press button "kosvor"
And I respond with answer "ja" to the dialog with id "2324"
And I save the current editor

Given I open an editor "Monatsabschluss3" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
And I set fields
    | such | ERFOLGREICH-JAN-FKV |
And I press button "fbbbu" in row 4
And I respond with answer "Ja" to the dialog with id "7626"
And I save the current editor

Given I open an editor "Monatsabschluss3v" from table "(FiscalYearManagement):(Closings)" with command "VIEW" for record "+ERFOLGREICH-JAN-FKV"
And I close the current editor
