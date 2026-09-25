@persistent
Feature: Stammdaten

Background: 
Given I set the fake date to "03.02.1995"

# *****************************************************************************
#  Name             : platzmge_nach_rueckbau.feature
#  Autor            : Silvia Warth
#  Verantwortlich   : sih
#  Kontrolle        : wane
#  Funktion         : Stammdaten und Gesch�ftsprozesse
#
#  SIH: noch alle Prozesse beschreiben.
#       besser der Übersicht wegen wären mehrere Referenzdateien
#
#  Einkaufsartikel E2, E4, E6 mit Bewertungsverfahren 4 (Preis des Zugangs/Vorgangspreis)
#  Einkaufsartikel E3, E5, E7 mit Bewertungsverfahren 5 (FIFO/Vorgangspreis)
#  
# *****************************************************************************
# 
@Stammdaten
Scenario: Bewertungsverfahren anlegen, Bewertungsverfahren in Artikel eintragen
Given I open an editor "bewertungskonfig" from table "(Company):(ValuationConfiguration)" with command "UPDATE" for record "10"

And I append rows
  | bewverf | bewab             | bewzu         |
  | 4       | Preis des Zugangs | Vorgangspreis |
  | 5       | frühester        | Vorgangspreis |
  | 6       | letzter           | Vorgangspreis |
And I save the current editor

Scenario: Artikel aendern und anlegen
Given I open an editor "art" from table "(Part):(Product)" with command "UPDATE" for record "E2"
And I set field "ekbewverf" to "4"
And I set field "abplatz" to "F1"
And I save the current editor

Given I open an editor "art" from table "(Part):(Product)" with command "UPDATE" for record "E3"
And I set field "ekbewverf" to "5"
And I set field "abplatz" to "F1"
And I save the current editor

Given I open an editor "art" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "num2" to "204"
And I set field "such2" to "E4"
And I set field "ekbewverf" to "4"
And I save the current editor

Given I open an editor "art" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "num2" to "205"
And I set field "such2" to "E5"
And I set field "ekbewverf" to "5"
And I save the current editor

Given I open an editor "art" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "num2" to "206"
And I set field "such2" to "E6"
And I set field "ekbewverf" to "4"
And I save the current editor

Given I open an editor "art" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "num2" to "207"
And I set field "such2" to "E7"
And I set field "ekbewverf" to "5"
And I save the current editor

# zwei neue Artikel mit Beschaffungsart Eigenfertigung
Given I open an editor "art" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "num2" to "302"
And I set field "such2" to "bg2"
And I set field "ekbewverf" to "4"
And I set field "elex" to "E6" in row 1
And I set field "elanzahl" to "2" in row 1
And I save the current editor

Given I open an editor "art" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "num2" to "303"
And I set field "such2" to "bg3"
And I set field "ekbewverf" to "5"
And I set field "elex" to "E7" in row 1
And I set field "elanzahl" to "2" in row 1
And I save the current editor

Scenario: Geschaeftsprozesse                                                                                          
# EK-Lieferschein für Artikel E2, E3, E4, E5, E6, E7
Given I open an editor "ls-100" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "num4" to "100"
And I set field "lief" to "1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I append rows
 | artikel      | mge | platz |
 | E2           |  50 | f1    |
 | E2           |  50 | f2    |
 | E3           |  50 | f1    |
 | E3           |  50 | f2    |
 | E4           |  50 | f1    |
 | E4           |  50 | f2    |
 | E5           |  50 | f1    |
 | E5           |  50 | f2    |
 | E6           |   1 | f1    |
 | E6           |   1 | f2    |
 | E7           |   1 | f1    |
 | E7           |   1 | f2    |
And I save the current editor


And I append "--- 1 Zugang ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir
And I append "--- 1 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel=e2;@ordnung=artikel,lgruppe,lager,platz" to output file "ref_platzmge_nach_rueckbau_cuE2.ref"
And I append "--- Ende 1 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir

And I append "--- 1 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir
And I export "ljfeldliste1_oh_zei" from StockMovementJournal where "artikel=e2;@ordnung=budat,artikel" to output file "ref_platzmge_nach_rueckbau_cuE2.ref"
And I append "--- Ende 1 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir

And I append "--- 1 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "kosn^such=e2;gjahr=95;waehr=DEM;dart=ist;" to output file "ref_platzmge_nach_rueckbau_cuE2.ref"
And I append "--- Ende 1 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir

And I append "--- 1 Zugang ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir
And I append "--- 1 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel=e3;@ordnung=artikel,lgruppe,lager,platz" to output file "ref_platzmge_nach_rueckbau_cuE3.ref"
And I append "--- Ende 1 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir

And I append "--- 1 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir
And I export "ljfeldliste1_oh_zei" from StockMovementJournal where "artikel=e3;@ordnung=budat,artikel" to output file "ref_platzmge_nach_rueckbau_cuE3.ref"
And I append "--- Ende 1 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir

And I append "--- 1 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "kosn^such=e3;gjahr=95;waehr=DEM;dart=ist;" to output file "ref_platzmge_nach_rueckbau_cuE3.ref"
And I append "--- Ende 1 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir

And I append "--- 1 Zugang ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir
And I append "--- 1 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel=e4;@ordnung=artikel,lgruppe,lager,platz" to output file "ref_platzmge_nach_rueckbau_cuE4.ref"
And I append "--- Ende 1 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir

And I append "--- 1 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir
And I export "ljfeldliste1_oh_zei" from StockMovementJournal where "artikel=e4;@ordnung=budat,artikel" to output file "ref_platzmge_nach_rueckbau_cuE4.ref"
And I append "--- Ende 1 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir

And I append "--- 1 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "kosn^such=e4;gjahr=95;waehr=DEM;dart=ist;" to output file "ref_platzmge_nach_rueckbau_cuE4.ref"
And I append "--- Ende 1 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir

And I append "--- 1 Zugang ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir
And I append "--- 1 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel=e5;@ordnung=artikel,lgruppe,lager,platz" to output file "ref_platzmge_nach_rueckbau_cuE5.ref"
And I append "--- Ende 1 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir

And I append "--- 1 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir
And I export "ljfeldliste1_oh_zei" from StockMovementJournal where "artikel=e5;@ordnung=budat,artikel" to output file "ref_platzmge_nach_rueckbau_cuE5.ref"
And I append "--- Ende 1 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir

And I append "--- 1 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "kosn^such=e5;gjahr=95;waehr=DEM;dart=ist;" to output file "ref_platzmge_nach_rueckbau_cuE5.ref"
And I append "--- Ende 1 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir

And I append "--- 1 Zugang ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir
And I append "--- 1 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel=e6;@ordnung=artikel,lgruppe,lager,platz" to output file "ref_platzmge_nach_rueckbau_cuE6.ref"
And I append "--- Ende 1 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir

And I append "--- 1 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir
And I export "ljfeldliste1_oh_zei" from StockMovementJournal where "artikel=e6;@ordnung=budat,artikel" to output file "ref_platzmge_nach_rueckbau_cuE6.ref"
And I append "--- Ende 1 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir

And I append "--- 1 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "kosn^such=e6;gjahr=95;waehr=DEM;dart=ist;" to output file "ref_platzmge_nach_rueckbau_cuE6.ref"
And I append "--- Ende 1 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir

And I append "--- 1 Zugang ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir
And I append "--- 1 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel=e7;@ordnung=artikel,lgruppe,lager,platz" to output file "ref_platzmge_nach_rueckbau_cuE7.ref"
And I append "--- Ende 1 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir

And I append "--- 1 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir
And I export "ljfeldliste1_oh_zei" from StockMovementJournal where "artikel=e7;@ordnung=budat,artikel" to output file "ref_platzmge_nach_rueckbau_cuE7.ref"
And I append "--- Ende 1 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir

And I append "--- 1 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "kosn^such=e7;gjahr=95;waehr=DEM;dart=ist;" to output file "ref_platzmge_nach_rueckbau_cuE7.ref"
And I append "--- Ende 1 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir


# VK-Lieferschein für Artikel E2, E3
Given I open an editor "vk-ls" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "num3" to "400"
And I set field "kunde" to "001"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I append rows
 | artikel      | mge | platz |
 | E2           | 100 | f1    |
 | E3           | 100 | f1    |
And I set field "kenn" to "FALL400 Lieferschein"
And I save the current editor

# VK-Lieferschein für Artikel E4, E5
Given I open an editor "vk2-ls" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "num3" to "500"
And I set field "kunde" to "001"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I append rows
 | artikel      | mge | platz |
 | E4           | 100 | f1    |
 | E5           | 100 | f1    |
And I set field "kenn" to "FALL500 Lieferschein"
And I save the current editor

# Fertigungsvorschlag für BG2 und BG3 und Entnahme von E6 und E7 in die Fertigung
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel   | netmge    | bisuch  | mfreig    | binoloe   |
    | bg2       | 1         | BG2_    | ja        | ja        |
    | bg3       | 1         | BG3_    | ja        | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor

# Materialentnahme: E6 und E7 abbuchen
Given I open an editor "FBU_BG2" for tip command "Fbuchung" and arguments ""
And I set field "auftrag" to "1001001"
And I append rows
 |elex   | bumge |
 | E6    |   2   |
And I save the current editor

Given I open an editor "FBU_BG3" for tip command "Fbuchung" and arguments ""
And I set field "auftrag" to "1002001"
And I append rows
 |elex   | bumge |
 | E7    |   2   |
And I save the current editor

And I append "--- 2 Abgang ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir
And I append "--- 2 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel=e2;@ordnung=artikel,lgruppe,lager,platz" to output file "ref_platzmge_nach_rueckbau_cuE2.ref"
And I append "--- Ende 2 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir

And I append "--- 2 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "artikel=e2;@ordnung=budat,artikel" to output file "ref_platzmge_nach_rueckbau_cuE2.ref"
And I append "--- Ende 2 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir

And I append "--- 2 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "kosn^such=e2;gjahr=95;waehr=DEM;dart=ist;" to output file "ref_platzmge_nach_rueckbau_cuE2.ref"
And I append "--- Ende 2 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir
#
And I append "--- 2 Abgang ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir
And I append "--- 2 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel=e3;@ordnung=artikel,lgruppe,lager,platz" to output file "ref_platzmge_nach_rueckbau_cuE3.ref"
And I append "--- Ende 2 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir

And I append "--- 2 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "artikel=e3;@ordnung=budat,artikel" to output file "ref_platzmge_nach_rueckbau_cuE3.ref"
And I append "--- Ende 2 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir

And I append "--- 2 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "kosn^such=e3;gjahr=95;waehr=DEM;dart=ist;" to output file "ref_platzmge_nach_rueckbau_cuE3.ref"
And I append "--- Ende 2 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir

And I append "--- 2 Abgang ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir
And I append "--- 2 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel=e4;@ordnung=artikel,lgruppe,lager,platz" to output file "ref_platzmge_nach_rueckbau_cuE4.ref"
And I append "--- Ende 2 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir

And I append "--- 2 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "artikel=e4;@ordnung=budat,artikel" to output file "ref_platzmge_nach_rueckbau_cuE4.ref"
And I append "--- Ende 2 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir

And I append "--- 2 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "kosn^such=e4;gjahr=95;waehr=DEM;dart=ist;" to output file "ref_platzmge_nach_rueckbau_cuE4.ref"
And I append "--- Ende 2 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir

And I append "--- 2 Abgang ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir
And I append "--- 2 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel=e5;@ordnung=artikel,lgruppe,lager,platz" to output file "ref_platzmge_nach_rueckbau_cuE5.ref"
And I append "--- Ende 2 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir

And I append "--- 2 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "artikel=e5;@ordnung=budat,artikel" to output file "ref_platzmge_nach_rueckbau_cuE5.ref"
And I append "--- Ende 2 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir

And I append "--- 2 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "kosn^such=e5;gjahr=95;waehr=DEM;dart=ist;" to output file "ref_platzmge_nach_rueckbau_cuE5.ref"
And I append "--- Ende 2 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir

And I append "--- 2 Abgang ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir
And I append "--- 2 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel=e6;@ordnung=artikel,lgruppe,lager,platz" to output file "ref_platzmge_nach_rueckbau_cuE6.ref"
And I append "--- Ende 2 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir

And I append "--- 2 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "artikel=e6;@ordnung=budat,artikel" to output file "ref_platzmge_nach_rueckbau_cuE6.ref"
And I append "--- Ende 2 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir

And I append "--- 2 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "kosn^such=e6;gjahr=95;waehr=DEM;dart=ist;" to output file "ref_platzmge_nach_rueckbau_cuE6.ref"
And I append "--- Ende 2 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir

And I append "--- 2 Abgang ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir
And I append "--- 2 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel=e7;@ordnung=artikel,lgruppe,lager,platz" to output file "ref_platzmge_nach_rueckbau_cuE7.ref"
And I append "--- Ende 2 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir

And I append "--- 2 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "artikel=e7;@ordnung=budat,artikel" to output file "ref_platzmge_nach_rueckbau_cuE7.ref"
And I append "--- Ende 2 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir

And I append "--- 2 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "kosn^such=e7;gjahr=95;waehr=DEM;dart=ist;" to output file "ref_platzmge_nach_rueckbau_cuE7.ref"
And I append "--- Ende 2 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir


# Rücklieferschein anlegen zu Fall 400
Given I open an editor "rls-vk" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "vk-ls"
And I set field "num3" to "400-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
Then the table has 2 rows
And I set field "mge" to "-100" in row 1
And I set field "platz" to "F2" in row 1
And I set field "mge" to "-100" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL400 Ruecklieferschein"
Then saving the current editor throws the exception "2037"
And I set field "platz" to "F1" in row 1
And I set field "platz" to "F1" in row 2
And I save the current editor

# Rücklieferschein anlegen zu Fall 500
Given I open an editor "rls-vk2" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "vk2-ls"
And I set field "num3" to "500-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
Then the table has 2 rows
And I set field "mge" to "-70" in row 1
And I set field "platz" to "F2" in row 1
And I set field "mge" to "-70" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL500 Ruecklieferschein"
Then saving the current editor throws the exception "2037"
And I set field "platz" to "F1" in row 1
And I set field "platz" to "F1" in row 2
And I save the current editor

# Rueckbau BG2_001 und BG3_001
# Rueckgabe vom anderen als vom Origginalplatz nicht möglich, wenn Originalplatz negativen Bestand hat.
# Fehler 2037: Aktion wegen eines negativen Bestands auf dem urspruenglichen Abgangsplatz nicht moeglich.
#			   Bitte Bestaende ausgleichen.

# Rueckbau BG2_001
Given I open an editor "RFBU_BG2" for tip command "Fbuchung" and arguments ""
And I set field "auftrag" to "1001001"
And I append rows
 |elex   | bumge | buplatz |
 | E6    |  -2   |    F2   |
Then saving the current editor throws the exception "2037"
And I close the current editor

Given I open an editor "RFBU_BG2_1" for tip command "Fbuchung" and arguments ""
And I set field "auftrag" to "1001001"
And I set field "bem" to "RFBU_BG2_1"
And I append rows
 |elex   | bumge | buplatz |
 | E6    |  -1   |    F1   |
And I save the current editor

Given I open an editor "RFBU_BG2_2" for tip command "Fbuchung" and arguments ""
And I set field "auftrag" to "1001001"
And I set field "bem" to "RFBU_BG2_2"
And I append rows
 |elex   | bumge | buplatz |
 | E6    |  -1   |    F2   |
And I save the current editor

# Rueckbau BG3_001
Given I open an editor "RFBU_BG3" for tip command "Fbuchung" and arguments ""
And I set field "auftrag" to "1002001"
And I append rows
 |elex   | bumge | buplatz |
 | E7    |  -2   |    F2   |
Then saving the current editor throws the exception "2037"
And I close the current editor

Given I open an editor "RFBU_BG3" for tip command "Fbuchung" and arguments ""
And I set field "auftrag" to "1002001"
And I set field "bem" to "RFBU_BG3_1"
And I append rows
 |elex   | bumge | buplatz |
 | E7    |  -1   |    F1   |
And I save the current editor

Given I open an editor "RFBU_BG3" for tip command "Fbuchung" and arguments ""
And I set field "auftrag" to "1002001"
And I set field "bem" to "RFBU_BG3_2"
And I append rows
 |elex   | bumge | buplatz |
 | E7    |  -1   |    F2   |
And I save the current editor

And I append "--- 3 Ruecklieferschein ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir
And I append "--- 3 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel=e2;@ordnung=artikel,lgruppe,lager,platz" to output file "ref_platzmge_nach_rueckbau_cuE2.ref"
And I append "--- Ende 3 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir

And I append "--- 3 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir
And I export "ljfeldliste1_oh_zei" from StockMovementJournal where "artikel=e2;@ordnung=budat,artikel" to output file "ref_platzmge_nach_rueckbau_cuE2.ref"
And I append "--- Ende 3 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir

And I append "--- 3 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "kosn^such=e2;gjahr=95;waehr=DEM;dart=ist;" to output file "ref_platzmge_nach_rueckbau_cuE2.ref"
And I append "--- Ende 3 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir

And I append "--- 3 Ruecklieferschein ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir
And I append "--- 3 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel=e3;@ordnung=artikel,lgruppe,lager,platz" to output file "ref_platzmge_nach_rueckbau_cuE3.ref"
And I append "--- Ende 3 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir

And I append "--- 3 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir
And I export "ljfeldliste1_oh_zei" from StockMovementJournal where "artikel=e3;@ordnung=budat,artikel" to output file "ref_platzmge_nach_rueckbau_cuE3.ref"
And I append "--- Ende 3 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir

And I append "--- 3 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "kosn^such=e3;gjahr=95;waehr=DEM;dart=ist;" to output file "ref_platzmge_nach_rueckbau_cuE3.ref"
And I append "--- Ende 3 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir

And I append "--- 3 Ruecklieferschein ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir
And I append "--- 3 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel=e4;@ordnung=artikel,lgruppe,lager,platz" to output file "ref_platzmge_nach_rueckbau_cuE4.ref"
And I append "--- Ende 3 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir

And I append "--- 3 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "artikel=e4;@ordnung=budat,artikel" to output file "ref_platzmge_nach_rueckbau_cuE4.ref"
And I append "--- Ende 3 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir

And I append "--- 3 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "kosn^such=e4;gjahr=95;waehr=DEM;dart=ist;" to output file "ref_platzmge_nach_rueckbau_cuE4.ref"
And I append "--- Ende 3 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir

And I append "--- 3 Ruecklieferschein ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir
And I append "--- 3 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel=e5;@ordnung=artikel,lgruppe,lager,platz" to output file "ref_platzmge_nach_rueckbau_cuE5.ref"
And I append "--- Ende 3 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir

And I append "--- 3 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "artikel=e5;@ordnung=budat,artikel" to output file "ref_platzmge_nach_rueckbau_cuE5.ref"
And I append "--- Ende 3 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir

And I append "--- 3 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "kosn^such=e5;gjahr=95;waehr=DEM;dart=ist;" to output file "ref_platzmge_nach_rueckbau_cuE5.ref"
And I append "--- Ende 3 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir

And I append "--- 3 Rueckbau ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir
And I append "--- 3 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel=e6;@ordnung=artikel,lgruppe,lager,platz" to output file "ref_platzmge_nach_rueckbau_cuE6.ref"
And I append "--- Ende 3 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir

And I append "--- 3 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "artikel=e6;@ordnung=budat,artikel" to output file "ref_platzmge_nach_rueckbau_cuE6.ref"
And I append "--- Ende 3 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir

And I append "--- 3 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "kosn^such=e6;gjahr=95;waehr=DEM;dart=ist;" to output file "ref_platzmge_nach_rueckbau_cuE6.ref"
And I append "--- Ende 3 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir

And I append "--- 3 Rueckbau ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir
And I append "--- 3 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel=e7;@ordnung=artikel,lgruppe,lager,platz" to output file "ref_platzmge_nach_rueckbau_cuE7.ref"
And I append "--- Ende 3 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir

And I append "--- 3 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "artikel=e7;@ordnung=budat,artikel" to output file "ref_platzmge_nach_rueckbau_cuE7.ref"
And I append "--- Ende 3 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir

And I append "--- 3 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "kosn^such=e7;gjahr=95;waehr=DEM;dart=ist;" to output file "ref_platzmge_nach_rueckbau_cuE7.ref"
And I append "--- Ende 3 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir

# Storno Ruecklieferung
And I reverse the PackingSlip "rls-vk"

And I reverse the PackingSlip "rls-vk2"

# Storno Rueckbau BG2_001 und BG3_001
Given I open an editor "Rueckgabe_BG2_1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BG2_001;bem=RFBU_BG2_1;@richtung=rueckwaerts;@ablageart=abgelegt;@maxtreffer=1"
And I close the current editor

Given I open an editor "Storno1_Rueckgabe_BG2_1" via ID from editor "Rueckgabe_BG2_1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
And I save the current editor

Given I open an editor "Rueckgabe_BG2_2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BG2_001;bem=RFBU_BG2_2;@richtung=rueckwaerts;@ablageart=abgelegt;@maxtreffer=1"
And I close the current editor

Given I open an editor "Storno1_Rueckgabe_BG2_2" via ID from editor "Rueckgabe_BG2_2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
And I save the current editor



Given I open an editor "Rueckgabe_BG3_1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BG3_001;bem=RFBU_BG3_1;@richtung=rueckwaerts;@ablageart=abgelegt;@maxtreffer=1"
And I close the current editor

Given I open an editor "Storno1_Rueckgabe_BG3_1" via ID from editor "Rueckgabe_BG3_1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
And I save the current editor

Given I open an editor "Rueckgabe_BG3_2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BG3_001;bem=RFBU_BG3_2;@richtung=rueckwaerts;@ablageart=abgelegt;@maxtreffer=1"
And I close the current editor

Given I open an editor "Storno1_Rueckgabe_BG3_2" via ID from editor "Rueckgabe_BG3_2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
And I save the current editor

And I append "--- 4 nach Storno des Ruecklieferscheins ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir
And I append "--- 4 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel=e2;@ordnung=artikel,lgruppe,lager,platz" to output file "ref_platzmge_nach_rueckbau_cuE2.ref"
And I append "--- Ende 4 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir

And I append "--- 4 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "artikel=e2;@ordnung=budat,artikel" to output file "ref_platzmge_nach_rueckbau_cuE2.ref"
And I append "--- Ende 4 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir

And I append "--- 4 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "kosn^such=e2;gjahr=95;waehr=DEM;dart=ist;" to output file "ref_platzmge_nach_rueckbau_cuE2.ref"
And I append "--- Ende 4 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE2.ref" in cucu_refs_dir

And I append "--- 4 nach Storno des Ruecklieferscheins ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir
And I append "--- 4 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel=e3;@ordnung=artikel,lgruppe,lager,platz" to output file "ref_platzmge_nach_rueckbau_cuE3.ref"
And I append "--- Ende 4 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir

And I append "--- 4 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "artikel=e3;@ordnung=budat,artikel" to output file "ref_platzmge_nach_rueckbau_cuE3.ref"
And I append "--- Ende 4 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir

And I append "--- 4 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "kosn^such=e3;gjahr=95;waehr=DEM;dart=ist;" to output file "ref_platzmge_nach_rueckbau_cuE3.ref"
And I append "--- Ende 4 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE3.ref" in cucu_refs_dir

And I append "--- 4 nach Storno des Ruecklieferscheins ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir
And I append "--- 4 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel=e4;@ordnung=artikel,lgruppe,lager,platz" to output file "ref_platzmge_nach_rueckbau_cuE4.ref"
And I append "--- Ende 4 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir

And I append "--- 4 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "artikel=e4;@ordnung=budat,artikel" to output file "ref_platzmge_nach_rueckbau_cuE4.ref"
And I append "--- Ende 4 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir

And I append "--- 4 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "kosn^such=e4;gjahr=95;waehr=DEM;dart=ist;" to output file "ref_platzmge_nach_rueckbau_cuE4.ref"
And I append "--- Ende 4 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE4.ref" in cucu_refs_dir

And I append "--- 4 nach Storno des Ruecklieferscheins ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir
And I append "--- 4 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel=e5;@ordnung=artikel,lgruppe,lager,platz" to output file "ref_platzmge_nach_rueckbau_cuE5.ref"
And I append "--- Ende 4 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir

And I append "--- 4 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "artikel=e5;@ordnung=budat,artikel" to output file "ref_platzmge_nach_rueckbau_cuE5.ref"
And I append "--- Ende 4 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir

And I append "--- 4 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "kosn^such=e5;gjahr=95;waehr=DEM;dart=ist;" to output file "ref_platzmge_nach_rueckbau_cuE5.ref"
And I append "--- Ende 4 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE5.ref" in cucu_refs_dir

And I append "--- 4 nach Storno des Rueckbaus ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir
And I append "--- 4 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel=e6;@ordnung=artikel,lgruppe,lager,platz" to output file "ref_platzmge_nach_rueckbau_cuE6.ref"
And I append "--- Ende 4 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir

And I append "--- 4 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "artikel=e6;@ordnung=budat,artikel" to output file "ref_platzmge_nach_rueckbau_cuE6.ref"
And I append "--- Ende 4 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir

And I append "--- 4 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "kosn^such=e6;gjahr=95;waehr=DEM;dart=ist;" to output file "ref_platzmge_nach_rueckbau_cuE6.ref"
And I append "--- Ende 4 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE6.ref" in cucu_refs_dir

And I append "--- 4 nach Storno des Rueckbaus ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir
And I append "--- 4 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel=e7;@ordnung=artikel,lgruppe,lager,platz" to output file "ref_platzmge_nach_rueckbau_cuE7.ref"
And I append "--- Ende 4 Platzmenge ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir

And I append "--- 4 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "artikel=e7;@ordnung=budat,artikel" to output file "ref_platzmge_nach_rueckbau_cuE7.ref"
And I append "--- Ende 4 Lagerjournal ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir

And I append "--- 4 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "kosn^such=e7;gjahr=95;waehr=DEM;dart=ist;" to output file "ref_platzmge_nach_rueckbau_cuE7.ref"
And I append "--- Ende 4 Artikelmengen ---" to output file "ref_platzmge_nach_rueckbau_cuE7.ref" in cucu_refs_dir


