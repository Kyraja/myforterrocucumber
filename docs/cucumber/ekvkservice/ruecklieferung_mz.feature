# *****************************************************************************
#  Name           : ruecklieferung_mz.feature
#  Autor          : as
#  Verantwortlich : teampss
#  Funktion       : Test der MZ-Generierung und -Zuordnung bei Ruecklieferungen
#                   und Storno.
#
# *****************************************************************************

@persistent
Feature: MZ-Generierung und -Zuordnung bei Ruecklieferungen und Storno
Background:
Given I set the fake date to "02.01.1995"

# -----------------------------------------------------------------------------
#  V E R K A U F
# -----------------------------------------------------------------------------

Scenario: Storno VK-Lieferschein mit Verwendung und Projekt

Given I open an editor "1LS1001" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "1LS1001"
And I set field "nummer" to "1LS1001S"
And I save the current editor

Given I open an editor "1LS1001S" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1001S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1001S"
And I close the current editor

Given I open an editor "1LS1001" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1001"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1001"
And I close the current editor

Scenario: Ruecklieferung VK-Lieferschein mit Verwendung und Projekt, Plausibilitaetspruefungen und Buttons

Given I open an editor "1LS1002" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1002"
And I set field "nummer" to "1LS1002R"
And I set field "ueb" to "true"
And I set field "mge" to "-30" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then setting field "zuomge" to "1" in row 1 throws the exception ""
And I delete all rows
And I press button "burueckmzerg"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I delete all rows
And I append rows
    | lpsuch | zuomge |
    | F1     | -5     |
And I press button "burueckmzzuord"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I append rows
    | lpsuch | zuomge |
    | F2     | -10    |
And I press button "burueckmzzuord"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I append rows
    | lpsuch | zuomge |
    | F3     | -15    |
And I press button "burueckmzzuord"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I delete all rows
And I append rows
    | lpsuch | zuomge | verw     |
    | F1     | -5     | 1AU100   |
    | F2     | -10    | 1AU100   |
    | F3     | -15    | 1AU100   |
Then pressing button "burueckmzzuord" throws the exception "2036"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I delete all rows
And I append rows
    | lpsuch | zuomge | verw     |
    | F1     | -5     | 1AU100   |
    | F2     | -10    | 4711     |
    | F3     | -15    |          |
Then pressing button "burueckmzzuord" throws the exception "4068"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1002"
And I close the current editor

Scenario: Ruecklieferung VK-Lieferschein mit Verwendung und Projekt, ohne MZs

Given I open an editor "1LS1002R" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1002"
And I set field "nummer" to "1LS1002R"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete all rows
And I append rows
    | zuomge |
    | -30    |
And I save the current editor
And I switch the current editor to editor "1LS1002R"
And I save the current editor

Given I open an editor "1LS1002R" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "1LS1002R"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I set field "zuomge" to "0" in row 1
And I press button "burueckmzerg"
And I close the current editor
And I switch the current editor to editor "1LS1002R"
And I close the current editor

Given I open an editor "1LS1002R" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "1LS1002R"
And I set field "ueb" to "true"
And I save the current editor

Given I open an editor "1LS1002R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1002R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1002R"
And I close the current editor

Given I open an editor "1LS1002" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS1002"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1002"
And I close the current editor


Scenario: Ruecklieferung VK-Lieferschein mit Verwendung und Projekt, MZ-Menge < Pos-Menge

# ----------------------------------------------------------------
# gebindemengen prüfen nach rücklieferung und storno-rücklierung
# zugehörigkeit/prüflogik:
# ----------------------------------------------------------------
# die platzmengen wurden vor dem storno des rücklieferung auf 0 gebracht. 
# die tabellenmengen müssen sich also  genau spiegelbildlich zu den tabellenmengen 
# weiter unten verhalten, weil auch vor dem rückbau die platzmengen auf 
# 0 gebracht wurden. einziger unterschied im spiegelbild: die zeilensortierung nach den mengen
# (oder die reihenfolge muss bei @ordnung gedreht werden, weil die VZ jeweils anders sind)

And I append "prozess in std/test/cucumber/ekvkservice/ruecklieferung_mz.feature" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.10.ref" in cucu_refs_dir
And I append "Scenario: Ruecklieferung VK-Lieferschein mit Verwendung und Projekt, MZ-Menge < Pos-Menge" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.10.ref" in cucu_refs_dir
And I append "--- platzmengen vor return ---" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.10.ref" in cucu_refs_dir
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==AUFTRAGSBEZ;gebmge<>0;platz==F12" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.10.ref" 

Given I open an editor "1LS1003" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1003"
And I set field "nummer" to "1LS1003R"
And I set field "ueb" to "true"
And I set field "mge" to "-30" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I set field "mzueb" to "nein"
And I delete row at position 1
And I append rows
    | lpsuch | zuomge | verw     |
    | F12    | -10    |          |
    | F12    | -5     | 1AU100   |
And I save the current editor
And I switch the current editor to editor "1LS1003"
And I save the current editor

And I append "prozessquelle siehe: std/test/cucumber/ekvkservice/ruecklieferung_mz.feature, od. suche ggf. nach dem ref-dateinamen in cucu-skripten" to output file "ref_ev_ruecklieferung_mz_cu.lj.10.ref" in cucu_refs_dir
And I append "--- alle LJ zu return L1LS1003R (zur Sortierung s. Feldliste und MawiSteps.java)" to output file "ref_ev_ruecklieferung_mz_cu.lj.10.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "vorgang^kopf^nummer==1LS1003R;vorgang^kopf^objdbez=Verkauf" to output file "ref_ev_ruecklieferung_mz_cu.lj.10.ref"

Given I open an editor "1LS1003R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1003R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1003R"
And I close the current editor

Scenario: Ruecklieferung VK-Lieferschein mit Verwendung und Projekt, MZ-Menge > Pos-Menge

And I append "--- platzmengen nach return ---" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.10.ref"
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==AUFTRAGSBEZ;gebmge<>0;platz==F12" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.10.ref" 

Given I open an editor "1LS1003S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "+1LS1003R"
And I set field "nummer" to "1LS1003S"
And I save the current editor

And I append "--- alle LJ zu storno.return L1LS1003S (zur Sortierung s. Feldliste und MawiSteps.java)" to output file "ref_ev_ruecklieferung_mz_cu.lj.10.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "vorgang^kopf^nummer==1LS1003S;vorgang^kopf^objdbez=Verkauf" to output file "ref_ev_ruecklieferung_mz_cu.lj.10.ref"

And I append "--- platzmengen nach storno.return ---" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.10.ref" in cucu_refs_dir
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==AUFTRAGSBEZ;gebmge<>0;platz==F12" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.10.ref" 


Given I open an editor "1LS1004" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1004"
And I set field "nummer" to "1LS1004R"
And I set field "mge" to "-30" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I set field "mzueb" to "nein"
And I delete row at position 1
And I append rows
    | lpsuch | zuomge | verw     |
    | F13    | -10    | 1AU100_4 |
    | F13    | -10    | 1AU100   |
    | F13    | -10    |          |
And I save the current editor
And I switch the current editor to editor "1LS1004"
And I set field "mge" to "-15" in row 1
And I save the current editor

Given I open an editor "1LS1004R" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "1LS1004R"
And I set field "ueb" to "true"
And I save the current editor

Given I open an editor "1LS1004R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1004R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1004R"
And I close the current editor

Scenario: Ruecklieferung VK-Lieferschein mit Verwendung und Projekt, Split von MZs

Given I open an editor "1LS1005" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1005"
And I set field "nummer" to "1LS1005R"
And I set field "ueb" to "true"
And I set field "mge" to "-30" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I set field "mzueb" to "nein"
And I delete row at position 1
And I append rows
    | lpsuch | zuomge | verw     |
    | F14    | -3     | 1AU100   |
    | F14    | -7     |          |
    | F14    | -6     | 1AU100_5 |
    | F14    | -4     | 1AU100   |
    | F14    | -8     |          |
    | F14    | -2     | 1AU100_5 |
And I save the current editor
And I switch the current editor to editor "1LS1005"
And I save the current editor

Given I open an editor "1LS1005R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1005R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1005R"
And I close the current editor

Scenario: Storno VK-Lieferschein mit Verwendung und Projekt, unterschiedliche Einheiten

Given I open an editor "1LS1006" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "1LS1006"
And I set field "nummer" to "1LS1006S"
And I save the current editor

Given I open an editor "1LS1006S" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1006S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1006S"
And I close the current editor

Scenario: Ruecklieferung VK-Lieferschein, unterschiedliche Einheiten, Plausibilitaetspruefungen

Given I open an editor "1LS1007" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1007"
And I set field "nummer" to "1LS1007R"
And I set field "ueb" to "true"
And I set field "he" to "kg" in row 1
And I set field "mge" to "-30" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I press button "burueckmzerg"
And I set field "einh" to "kg" in row 1
And I set field "zuomge" to "-15" in row 1
Then setting field "einh" to "Stück" in row 1 throws the exception ""
And I set field "einh" to "kg" in row 1
Then setting field "faktor" to "2" in row 1 throws the exception ""
And I set field "faktor" to "0,25" in row 1
And I set field "zuomge" to "-30" in row 1
And I save the current editor
And I switch the current editor to editor "1LS1007"
And I close the current editor

Given I open an editor "2LS1007" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 2LS1007 |
   | kunde  | 1       |
   | vom    | .       |
   | ueb    | ja      |
And I append rows
   | artikel | mge | he |
   | V3      | 6   | m  |
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete all rows
And I append rows
   | zuomge | einh  |
   | 5      | m     |
   | 20     | Stück |
And I save the current editor
And I switch the current editor to editor "2LS1007"
And I save the current editor

Given I open an editor "2LS1007R" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "2LS1007"
And I set field "nummer" to "2LS1007R"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I press button "burueckmzerg"
And I delete row at position 2
And I set field "zuomge" to "-10" in row 1
And I save the current editor
And I switch the current editor to editor "2LS1007R"
Then field "mge" has value "-10" in row 1
Then field "he" has value "Stück" in row 1
And I close the current editor

Scenario: Ruecklieferung VK-Lieferschein mit Verwendung und Projekt, ohne MZs, unterschiedliche Einheiten

And I append "prozess in std/test/cucumber/ekvkservice/ruecklieferung_mz.feature" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.15.ref" in cucu_refs_dir
And I append "Scenario: Ruecklieferung VK-Lieferschein mit Verwendung und Projekt, ohne MZs, unterschiedliche Einheiten" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.15.ref" in cucu_refs_dir
And I append "--- platzmengen vor return ---" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.15.ref" in cucu_refs_dir
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==AUFTRAGSBEZ;gebmge<>0;platz==F17" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.15.ref" 


Given I open an editor "1LS1008" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1008"
And I set field "nummer" to "1LS1008R"
And I set field "ueb" to "true"
And I set field "he" to "kg" in row 1
And I set field "mge" to "-30" in row 1
And I save the current editor

Given I open an editor "1LS1008R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1008R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1008R"
And I close the current editor

# ---- zwischenzustand nach rücklieferung ----
# zugehörigkeit/prüflogik: prinzip spiegelbild: die doku findest Du wenn Du i.d. datei nach "zugehörigkeit/prüflogik" suchst  

And I append "prozessquelle siehe: std/test/cucumber/ekvkservice/ruecklieferung_mz.feature, od. suche ggf. nach dem ref-dateinamen in cucu-skripten" to output file "ref_ev_ruecklieferung_mz_cu.lj.15.ref" in cucu_refs_dir
And I append "--- alle LJ zu return L1LS1008R (zur Sortierung s. Feldliste und MawiSteps.java)" to output file "ref_ev_ruecklieferung_mz_cu.lj.15.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "vorgang^kopf^nummer==1LS1008R;vorgang^kopf^objdbez=Verkauf" to output file "ref_ev_ruecklieferung_mz_cu.lj.15.ref"

And I append "--- nach return vor storno ---" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.15.ref" in cucu_refs_dir
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==AUFTRAGSBEZ;gebmge<>0;platz==F17" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.15.ref" 


Given I open an editor "1LS1008S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "+1LS1008R"
And I set field "nummer" to "1LS1008S"
And I save the current editor

And I append "--- alle LJ zu storno.return L1LS1008S (zur Sortierung s. Feldliste und MawiSteps.java)" to output file "ref_ev_ruecklieferung_mz_cu.lj.15.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "vorgang^kopf^nummer==1LS1008S;vorgang^kopf^objdbez=Verkauf" to output file "ref_ev_ruecklieferung_mz_cu.lj.15.ref"

And I append "--- nach storno.return ---" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.15.ref" in cucu_refs_dir
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==AUFTRAGSBEZ;gebmge<>0;platz==F17" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.15.ref" 

# alternativ bei 0-mengen waere dieses kommando verwendbar, dann sieht man aber den verlauf nicht in der ref-datei
# es ist eher sinnvoll alles in der ref-datei zu haben  (oder wer will alles hier im cucu-skript) 
Given I query "bewertungslagermengen1" from StorageQuantities where "artikel==AUFTRAGSBEZ;gebmge<>0;platz==F17"
Then StorageQuantity is zero


Scenario: Ruecklieferung VK-Lieferschein, unterschiedliche Einheiten

Given I open an editor "1LS1009" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1009"
And I set field "nummer" to "1LS1009R"
And I set field "he" to "kg" in row 1
And I set field "mge" to "-30" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | zuomge | einh | faktor |
    | F18    | -3,123 | kg   | 0,0123 |
    | F18    | -3,234 | kg   | 0,1234 |
    | F18    | -3,345 | kg   | 0,2345 |
    | F18    | -3,456 | kg   | 0,3456 |
    | F18    | -3,567 | kg   | 0,4567 |
    | F18    | -3,678 | kg   | 0,5678 |
    | F18    | -3,789 | kg   | 0,6789 |
    | F18    | -3,890 | kg   | 0,7890 |
And I press button "burueckmzzuord"
And I press button "burueckmzerg"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I set field "zuomge" to "0" in row 1
And I set field "zuomge" to "0" in row 2
And I set field "zuomge" to "0" in row 3
And I set field "zuomge" to "0" in row 4
And I set field "zuomge" to "0" in row 5
And I set field "zuomge" to "0" in row 6
And I set field "zuomge" to "0" in row 7
And I set field "zuomge" to "0" in row 8
And I set field "zuomge" to "0" in row 9
And I set field "zuomge" to "0" in row 10
And I set field "zuomge" to "0" in row 11
And I set field "zuomge" to "0" in row 12
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I set field "zuomge" to "-203.252" in row 1
And I set field "zuomge" to "-7.233" in row 4
And I set field "zuomge" to "-4.402" in row 7
And I set field "zuomge" to "-3.682" in row 9
And I set field "zuomge" to "-3.168" in row 11
And I set field "zuomge" to "-0.001" in row 14
And I set field "zuomge" to "-2.5" in row 18
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I save the current editor
And I switch the current editor to editor "1LS1009"
And I save the current editor

Given I open an editor "1LS1009R" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "1LS1009R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1009R"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1009R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1009R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1009R"
And I close the current editor

Scenario: Teilruecklieferungen VK

# 1. Teilruecklieferung, keine Buchung
Given I open an editor "1LS1010" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1010"
And I set field "nummer" to "1LS1010R"
And I set field "he" to "kg" in row 1
And I set field "mge" to "-6" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I set field "zuomge" to "-6" in row 1
And I press button "burueckmzzuord"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I save the current editor
And I switch the current editor to editor "1LS1010"
And I save the current editor

# 2. Teilruecklieferung, keine Buchung
Given I open an editor "1LS1010" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1010"
And I set field "nummer" to "2LS1010R"
And I set field "he" to "kg" in row 1
And I set field "mge" to "-11" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I press button "burueckmzerg"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1010"
And I save the current editor

# 3. Teilruecklieferung, keine Buchung
Given I open an editor "1LS1010" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1010"
And I set field "nummer" to "3LS1010R"
And I set field "he" to "kg" in row 1
And I set field "mge" to "-13" in row 1
And I save the current editor

# 2. Teilruecklieferung zuruecknehmen
Given I open an editor "2LS1010R" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "2LS1010R"
And I set field "mge" to "0" in row 1
And I save the current editor

# 1. Teilruecklieferung buchen
Given I open an editor "1LS1010R" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "1LS1010R"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1010R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1010R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1010R"
And I close the current editor

# 4. Teilruecklieferung, buchen
Given I open an editor "1LS1010" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1010"
And I set field "nummer" to "4LS1010R"
And I set field "ueb" to "ja"
And I set field "he" to "kg" in row 1
And I set field "mge" to "-11" in row 1
And I save the current editor

Given I open an editor "4LS1010R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+4LS1010R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "4LS1010R"
And I close the current editor

# 3. Teilruecklieferung buchen
Given I open an editor "3LS1010R" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "3LS1010R"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "3LS1010R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+3LS1010R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "3LS1010R"
And I close the current editor

Scenario: Teilruecklieferungen VK, Chargen

# 1. Teilruecklieferung, buchen
Given I open an editor "1LS1011" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1011"
And I set field "nummer" to "1LS1011R"
And I set field "ueb" to "ja"
And I set field "he" to "kg" in row 1
And I set field "mge" to "-13" in row 1
And I save the current editor

Given I open an editor "1LS1011R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1011R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1011R"
And I close the current editor

# 2. Teilruecklieferung, buchen
Given I open an editor "1LS1011" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1011"
And I set field "nummer" to "2LS1011R"
And I set field "ueb" to "ja"
And I set field "he" to "kg" in row 1
And I set field "mge" to "-17" in row 1
And I save the current editor

Given I open an editor "2LS1011R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+2LS1011R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "2LS1011R"
And I close the current editor

# Storno 1. Teilruecklieferung
Given I open an editor "1LS1011R" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "+1LS1011R"
And I set field "nummer" to "1LS1011S"
And I save the current editor

Given I open an editor "1LS1011S" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1011S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1011S"
And I close the current editor

Scenario: Materialzuordnungen im Auftrag bei Lieferscheinstorno

Given I open an editor "1AU100" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "1AU100"
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 6
And I save the current editor

Given I open an editor "1AU100" from table "(Sales):(SalesOrder)" with command "VIEW" for record "+1AU100"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 6
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1AU100"
And I close the current editor

Scenario: Storno VK-Ruecklieferung

Given I open an editor "1LS1002R" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "+1LS1002R"
And I set field "nummer" to "1LS1002S"
Then pressing button "mzsubm" in row 1 to open a subeditor throws the exception "1272"
And I save the current editor

Given I open an editor "1LS1002S" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1002S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1002S"
And I close the current editor

Scenario: Storno VK-Rechnung mit Lagerbewegung, Verwendung und Projekt

Given I open an editor "1RE1012" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+1RE1012"
And I set field "nummer" to "1RE1012S"
And I save the current editor

Given I open an editor "1RE1012S" from table "(Sales):(Invoice)" with command "VIEW" for record "+1RE1012S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1RE1012S"
And I close the current editor

Scenario: Ruecklieferung VK-Rechnung mit Lagerbewegung, Verwendung und Projekt, ohne MZs

Given I open an editor "1RE1013" from table "(Sales):(Invoice)" with command "RETURN" for record "+1RE1013"
And I set field "nummer" to "1LS1013R"
And I set field "ueb" to "true"
And I set field "mge" to "-30" in row 1
And I save the current editor

Given I open an editor "1LS1013R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS1013R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1013R"
And I close the current editor

Scenario: Storno VK-Rechnung mit Lagerbewegung, Verwendung und Projekt, kein Auftrag

Given I open an editor "1RE1014" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+1RE1014"
And I set field "nummer" to "1RE1014S"
And I save the current editor

Given I open an editor "1RE1014S" from table "(Sales):(Invoice)" with command "VIEW" for record "+1RE1014S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1RE1014S"
And I close the current editor

Scenario: Ruecklieferung VK-Rechnung mit Lagerbewegung, Verwendung und Projekt, ohne MZs, kein Auftrag

Given I open an editor "1RE1015" from table "(Sales):(Invoice)" with command "RETURN" for record "+1RE1015"
And I set field "nummer" to "1LS1015R"
And I set field "ueb" to "true"
And I set field "mge" to "-30" in row 1
And I save the current editor

Given I open an editor "1LS1015R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS1015R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1015R"
And I close the current editor

Scenario: Ruecklieferung VK-Lieferschein, Lagerplatzvergabe

Given I open an editor "1LS1016" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1016"
And I set field "nummer" to "1LS1016R"
And I set field "vom" to "."
And I set field "mge" to "-30" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | einh  | zuomge |
    | F3     | kg    | -5     |
    |        | kg    | -10    |
    | F4     | kg    | -10    |
    |        | kg    | -5     |
And I save the current editor
And I switch the current editor to editor "1LS1016"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1016R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1016R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1016R"
And I close the current editor

Scenario: Ruecklieferung VK-Lieferschein mit Verwendung und Projekt, unterschiedliche Lagerplaetze

Given I open an editor "1LS1017" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1017"
And I set field "nummer" to "1LS1017R"
And I set field "ueb" to "true"
And I set field "mge" to "-30" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | einh  | zuomge |
    | F28    | kg    | -10    |
    | F26    | kg    | -10    |
    | F27    | kg    | -10    |
And I save the current editor
And I switch the current editor to editor "1LS1017"
And I save the current editor

Given I open an editor "1LS1017R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1017R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1017R"
And I close the current editor

Scenario: Pruefung auf negativen Bestand bei der Ruecklieferung von Abgaengen

Given I open an editor "1LS1072R" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1072"
And I set field "nummer" to "1LS1072R"
And I set field "ueb" to "true"
And I set field "mge" to "-15" in row 1
And I set field "platz" to "F1" in row 1
Then saving the current editor throws the exception "2037"
And I set field "platz" to "F520" in row 1
And I save the current editor

Scenario: Ruecklieferung VK-Lieferschein mit Serviceprodukt

Given I open an editor "1AU130" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde  | 1      |
    | nummer | 1AU130 |
And I append rows
    | artikel     | mge | he    | serprod | platz |
    | SERVICETEIL | 1   | Stück | SP130   | F530  |
And I save the current editor

Given I open an editor "1LS130" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU130"
And I set fields
    | nummer | 1LS130 |
    | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "SP130" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "SP130"
Then I fill template "EV_SERPROD.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor

Given I open an editor "1RLS130" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS130"
And I set fields
    | nummer | 1RLS130 |
    | ueb    | ja      |
And I set field "platz" to "F531" in row 1
And I set field "serprod" to "SP135" in row 1
And I press button "offueb" in row 1
Then saving the current editor throws the exception "692"
And I set field "serprod" to "SP130" in row 1
And I save the current editor

Given I open an editor "SP130" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "SP130"
Then I fill template "EV_SERPROD.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor

Scenario: Stornierung VK-Lieferschein mit Serviceprodukt

Given I open an editor "2AU130" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde  | 1      |
    | nummer | 2AU130 |
And I append rows
    | artikel     | mge | he    | platz |
    | SERVICETEIL | 1   | Stück | F530  |
And I save the current editor

Given I open an editor "2LS130" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "2AU130"
And I set fields
    | nummer | 2LS130 |
    | ueb    | ja     |
And I press button "offueb" in row 1
And I set field "serprod" to "SP130" in row 1
And I save the current editor

Given I open an editor "SP130" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "SP130"
Then I fill template "EV_SERPROD.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor

Given I open an editor "2LS130S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "2LS130"
And I set field "nummer" to "2LS130S"
And I save the current editor

Given I open an editor "SP130" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "SP130"
Then I fill template "EV_SERPROD.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor

Given I open an editor "2AU130" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "2AU130"
And I set field "serprod" to "" in row 1
And I save the current editor

Scenario: Stornierung VK-Rechnung mit Lagerbewegung und Serviceprodukt

Given I open an editor "3RE130" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde  | 001    |
    | nummer | 3RE130 |
    | ueb    | ja     |
And I append rows
    | artikel     | mge | he    | serprod | platz |
    | SERVICETEIL | 1   | Stück | SP131   | F530  |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "SP131" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "SP131"
Then I fill template "EV_SERPROD.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor

Given I open an editor "3RE130S" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "3RE130"
And I set field "nummer" to "3RE130S"
And I save the current editor

Given I open an editor "SP131" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "SP131"
Then I fill template "EV_SERPROD.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor

Scenario: Ruecklieferung VK-Lieferschein mit Serviceprodukten in MZs

Given I open an editor "1AU132" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde  | 1      |
    | nummer | 1AU132 |
And I append rows
    | artikel     | mge | he    | platz |
    | SERVICETEIL | 3   | Stück | F530  |
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | zuomge | serprod |
    | 1      | SP132   |
    | 1      | SP133   |
    | 1      | SP134   |
And I save the current editor
And I switch the current editor to editor "1AU132"
And I save the current editor

Given I open an editor "1LS132" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU132"
And I set fields
    | nummer | 1LS132 |
    | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "SP132" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "SP132"
Then I fill template "EV_SERPROD.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor

Given I open an editor "SP133" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "SP133"
Then I fill template "EV_SERPROD.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor

Given I open an editor "SP134" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "SP134"
Then I fill template "EV_SERPROD.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor

Given I open an editor "1RLS132" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS132"
And I set fields
    | nummer | 1RLS132 |
    | ueb    | ja      |
And I set field "platz" to "F531" in row 1
And I press button "offueb" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I press button "burueckmzerg"
Then table has values
    | serprod |
    | SP134   |
    | SP133   |
    | SP132   |
And I delete all rows
And I append rows
    | zuomge | serprod |
    | -1     | 134     |
    | -1     | 135     |
    | -1     |         |
Then pressing button "burueckmzzuord" throws the exception "4068"
Then field "serprod" is modifiable in row 1
And I set field "serprod" to "SP133" in row 2
And I press button "burueckmzzuord"
Then field "serprod" is not modifiable in row 1
And I save the current editor
And I switch the current editor to editor "1RLS132"
And I save the current editor

Given I open an editor "SP132" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "SP132"
Then I fill template "EV_SERPROD.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor

Given I open an editor "SP133" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "SP133"
Then I fill template "EV_SERPROD.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor

Given I open an editor "SP134" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "SP134"
Then I fill template "EV_SERPROD.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor

Scenario: Storno VK-Lieferschein mit Serviceprodukten in MZs

Given I open an editor "1AU135" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde  | 001    |
    | nummer | 1AU135 |
And I append rows
    | artikel     | mge | he    | platz |
    | SERVICETEIL | 3   | Stück | F530  |
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | zuomge | serprod |
    | 1      | SP132   |
    | 1      | SP133   |
    | 1      | SP134   |
And I save the current editor
And I switch the current editor to editor "1AU135"
And I save the current editor

Given I open an editor "1LS135" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU135"
And I set fields
    | nummer | 1LS135 |
    | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "SP132" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "SP132"
Then I fill template "EV_SERPROD.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor

Given I open an editor "SP133" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "SP133"
Then I fill template "EV_SERPROD.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor

Given I open an editor "SP134" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "SP134"
Then I fill template "EV_SERPROD.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor

Given I open an editor "1LS135S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "1LS135"
And I set field "nummer" to "1LS135S"
And I save the current editor

Given I open an editor "SP132" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "SP132"
Then I fill template "EV_SERPROD.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor

Given I open an editor "SP133" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "SP133"
Then I fill template "EV_SERPROD.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor

Given I open an editor "SP134" from table "(ServiceProduct):(ServiceProduct)" with command "VIEW" for record "SP134"
Then I fill template "EV_SERPROD.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor

Scenario: Materialzuordnungen im Lieferschein bei Ruecklieferung und Ueberbelieferung

# Artikel mit Charge im Lager anlegen
Given I open an editor "ARTCH1" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| such         | ARTCH1                       |
	| namebspr     | Chargenpflichtiger Artikel 1 |
	| vpr          | 120                          |
	| bsart        | Eigenfertigung               |
	| dispoa       | Auftragsbezogen              |
	| chimlager    | ja                           |
And I save the current editor

# Charge anlegen
Given I create a Lot "CH1-ARTCH1" for Product "ARTCH1"
Given I create a Lot "CH2-ARTCH1" for Product "ARTCH1"

# Manuellen Zugang buchen
Given I open an editor "lbuchung" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
	| artikel | ARTCH1 |
	| buart   | ZUGANG |
	| beleg   | .      |
	| beldat  | .      |
And I append rows
	| platz2 | mge  | charge2    |
	| F1     | 90   | CH1-ARTCH1 |
	| F1	 | 14   | CH2-ARTCH1 |
And I save the current editor

# Auftrag anlegen
Given I open an editor "1AU045" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| nummer  | 1AU045 |
	| kunde   | 1      |
	| such    | AU045  |
And I append rows
	| artikel | mge |
	| ARTCH1  | 100 |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "1LS045" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU045"
And I set fields
	| nummer  | 1LS045 |
	| such    | LS045  |
	| ueb     | ja     |
And I press button "mzsubm" to open a subeditor for "mzuord" in row 1
And I append rows
	| charge     | zuomge | platz |
	| CH1-ARTCH1 | 90     | F1    |
	| CH2-ARTCH1 | 14     |	F1    |
And I save the current editor
And I switch the current editor to editor "1LS045"
And I save the current editor

# Ruecklieferung anlegen
Given I open an editor "1LS045R" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS045"
And I set fields
	| nummer  | 1LS045R |
	| such    | LS045R  |
	| ueb     | ja      |
And I set field "mge" to "-104" in row 1
And I press button "mzsubm" to open a subeditor for "mzuord" in row 1
And I append rows
	| charge     | zuomge | platz |
	| CH1-ARTCH1 | -90    | F1    |
	| CH2-ARTCH1 | -14    | F1    |
And I save the current editor
And I switch the current editor to editor "1LS045R"
And I save the current editor

# Weiteren Lieferschein anlegen, nicht buchen
Given I open an editor "2LS045" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "+1AU045"
And I set fields
	| nummer  | 2LS045  |
	| such    | LS045-2 |
	| ueb     | nein    |
And I press button "mzsubm" to open a subeditor for "mzuord" in row 1
And I append rows
	| charge     | zuomge | platz |
	| CH1-ARTCH1 | 90     | F1    |
	| CH2-ARTCH1 | 14     | F1    |
And I save the current editor
And I switch the current editor to editor "2LS045"
And I save the current editor

# Lieferscheein buchen
Given I open an editor "2LS045" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "2LS045"
And I set field "ueb" to "ja"
And I save the current editor

# -----------------------------------------------------------------------------
#  E I N K A U F
# -----------------------------------------------------------------------------

Scenario Outline: Storno EK-Lieferschein, Rueckumlagerung der umgelagerten Bestaende

Given I open an editor "1LS1001U" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "nummer" to "<nummer>"
And I set field "lief" to "1"
And I set field "vom" to "."
And I set field "umplatz" to "<umplatz>"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artikel" to "AUFTRAGSBEZ" in row 1
And I set field "mge" to "<mge>" in row 1
And I set field "he" to "<he>" in row 1
And I set field "platz" to "<platz>" in row 1
And I set field "verw" to "1BE100_1" in row 1
And I set field "projekt" to "100" in row 1
# Aktion nicht moeglich, da der Buchungsvorgang aktiv ist.
Then pressing button "mzabsm" in row 1 throws the exception "11236"
And I save the current editor

Examples:
 |nummer   |umplatz |mge  |he     |platz   |
 |1LS1001U |F112    |20   |kg     |F110    |
 |2LS1001U |F113    |26   |Stück  |F111    |

Scenario: Storno EK-Lieferschein mit Verwendung und Projekt, Teil 2

Given I open an editor "1LS1001" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "1LS1001"
And I set field "nummer" to "1LS1001S"
And I save the current editor

Given I open an editor "1LS1001S" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1001S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1001S"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit Verwendung und Projekt, mit Umlagerungen

Given I open an editor "1LS1002" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1002"
And I set field "nummer" to "1LS1002R"
And I set field "vom" to "."
And I set field "mge" to "-36" in row 1
And I set field "ueb" to "ja"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | zuomge | einh  |
    | F116   | -3     | Stück |
    | F117   | -7     | Stück |
    | F116   | -7     | Stück |
    | F117   | -19    | Stück |
And I save the current editor
And I switch the current editor to editor "1LS1002"
And I save the current editor

Given I open an editor "1LS1002R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1002R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1002R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein, unterschiedliche Einheiten

Given I open an editor "1LS1003" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1003"
And I set field "nummer" to "1LS1003R"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "mge" to "-36" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | zuomge | einh | faktor |
    | F120   | -2,123 | kg   | 1,0123 |
    | F121   | -2,234 | kg   | 1,1234 |
    | F120   | -2,345 | kg   | 1,2345 |
    | F121   | -2,456 | kg   | 1,3456 |
    | F120   | -2,567 | kg   | 1,4567 |
    | F121   | -2,678 | kg   | 1,5678 |
    | F120   | -2,789 | kg   | 1,6789 |
    | F121   | -2,890 | kg   | 1,7890 |
And I press button "burueckmzzuord"
And I press button "burueckmzerg"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I set field "zuomge" to "0" in row 1
And I set field "zuomge" to "0" in row 2
And I set field "zuomge" to "0" in row 3
And I set field "zuomge" to "0" in row 4
And I set field "zuomge" to "0" in row 5
And I set field "zuomge" to "0" in row 6
And I set field "zuomge" to "0" in row 7
And I set field "zuomge" to "0" in row 8
And I set field "zuomge" to "0" in row 9
And I set field "zuomge" to "0" in row 10
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I set field "zuomge" to "-14,817" in row 1
And I set field "zuomge" to "-9,791" in row 2
And I set field "zuomge" to "-1,786" in row 8
And I set field "zuomge" to "-3,912" in row 10
And I set field "zuomge" to "-0,001" in row 12
And I set field "zuomge" to "-0,001" in row 13
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I save the current editor
And I switch the current editor to editor "1LS1003"
And I save the current editor

Given I open an editor "1LS1003R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1003R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1003R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit Verwendung und Projekt, ohne MZs

And I append "prozess in std/test/cucumber/ekvkservice/ruecklieferung_mz.feature" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.40.ref" in cucu_refs_dir
And I append "Scenario: Ruecklieferung EK-Lieferschein mit Verwendung und Projekt, ohne MZs" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.40.ref" in cucu_refs_dir
And I append "--- vor return ---" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.40.ref" in cucu_refs_dir
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==AUFTRAGSBEZ;gebmge<>0;platz==F122" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.40.ref" 

Given I open an editor "1LS1004" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1004"
And I set field "nummer" to "1LS1004R"
And I set field "vom" to "."
And I set field "ueb" to "true"
And I set field "mge" to "-36" in row 1
And I set field "platz" to "F122" in row 1
And I save the current editor

And I append "prozessquelle siehe: std/test/cucumber/ekvkservice/ruecklieferung_mz.feature, od. suche ggf. nach dem ref-dateinamen in cucu-skripten" to output file "ref_ev_ruecklieferung_mz_cu.lj.40.ref" in cucu_refs_dir
And I append "--- alle LJ zu return L1LS1004R (zur Sortierung s. Feldliste und MawiSteps.java)" to output file "ref_ev_ruecklieferung_mz_cu.lj.40.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "vorgang^kopf^nummer==1LS1004R;vorgang^kopf^objdbez=Einkauf" to output file "ref_ev_ruecklieferung_mz_cu.lj.40.ref"

And I append "--- nach return vor storno ---" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.40.ref" in cucu_refs_dir
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==AUFTRAGSBEZ;gebmge<>0;platz==F122" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.40.ref" 

Given I open an editor "1LS1004R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1004R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1004R"
And I close the current editor

Given I open an editor "1LS1004S" from table "(Purchasing)::(PackingSlip)" with command "REVERSAL" for record "+1LS1004R"
And I set field "nummer" to "1LS1004S"
And I save the current editor

And I append "--- alle LJ zu storno.return L1LS1004S (zur Sortierung s. Feldliste und MawiSteps.java)" to output file "ref_ev_ruecklieferung_mz_cu.lj.40.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "vorgang^kopf^nummer==1LS1004S;vorgang^kopf^objdbez=Einkauf" to output file "ref_ev_ruecklieferung_mz_cu.lj.40.ref"

And I append "--- nach storno.return ---" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.40.ref" in cucu_refs_dir
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==AUFTRAGSBEZ;gebmge<>0;platz==F122" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.40.ref" 


Scenario: Ruecklieferung EK-Lieferschein mit Verwendung und Projekt, MZ-Menge < Pos-Menge

Given I open an editor "1LS1005" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1005"
And I set field "nummer" to "1LS1005R"
And I set field "vom" to "."
And I set field "mge" to "-20" in row 1
And I set field "platz" to "F123" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I set field "mzueb" to "nein"
And I delete row at position 1
And I append rows
    | lpsuch | zuomge | verw     |
    | F124   | -10    |          |
    | F124   | -5     | 1BE100   |
And I press button "burueckmzzuord"
And I save the current editor
And I switch the current editor to editor "1LS1005"
And I save the current editor

Given I open an editor "1LS1005R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS1005R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1005R"
And I close the current editor

Given I open an editor "1LS1005R" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "1LS1005R"
And I set field "ueb" to "true"
And I save the current editor

Given I open an editor "1LS1005R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1005R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1005R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit Verwendung und Projekt, MZ-Menge > Pos-Menge

Given I open an editor "1LS1006" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1006"
And I set field "nummer" to "1LS1006R"
And I set field "vom" to "."
And I set field "mge" to "-36" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I set field "mzueb" to "nein"
And I delete row at position 1
And I append rows
    | lpsuch | zuomge | verw     |
    | F125   | -12    | 1BE100_6 |
    | F125   | -12    | 1BE100   |
    | F125   | -12    |          |
And I save the current editor
And I switch the current editor to editor "1LS1006"
And I set field "mge" to "-18" in row 1
And I save the current editor

Given I open an editor "1LS1006R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS1006R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1006R"
And I close the current editor

Given I open an editor "1LS1006R" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "1LS1006R"
And I set field "ueb" to "true"
And I save the current editor

Given I open an editor "1LS1006R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1006R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1006R"
And I close the current editor

Scenario: Teilruecklieferungen EK

# 1. Teilruecklieferung, keine Buchung
Given I open an editor "1LS1007" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1007"
And I set field "nummer" to "1LS1007R"
And I set field "vom" to "."
And I set field "he" to "kg" in row 1
And I set field "mge" to "-5" in row 1
And I set field "platz" to "F126" in row 1
And I save the current editor

# 2. Teilruecklieferung, keine Buchung
Given I open an editor "1LS1007" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1007"
And I set field "nummer" to "2LS1007R"
And I set field "vom" to "."
And I set field "he" to "kg" in row 1
And I set field "mge" to "-10" in row 1
And I set field "platz" to "F126" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I set field "zuomge" to "-10" in row 1
And I press button "burueckmzzuord"
And I save the current editor
And I switch the current editor to editor "1LS1007"
And I save the current editor

# 3. Teilruecklieferung, keine Buchung
Given I open an editor "1LS1007" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1007"
And I set field "nummer" to "3LS1007R"
And I set field "vom" to "."
And I set field "he" to "kg" in row 1
And I set field "mge" to "-15" in row 1
And I set field "platz" to "F126" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I set field "zuomge" to "-15" in row 1
And I press button "burueckmzzuord"
And I save the current editor
And I switch the current editor to editor "1LS1007"
And I save the current editor

# 2. Teilruecklieferung zuruecknehmen
Given I open an editor "2LS1007R" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "2LS1007R"
And I set field "mge" to "0" in row 1
And I save the current editor

# 1. Teilruecklieferung buchen
Given I open an editor "1LS1007R" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "1LS1007R"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1007R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1007R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1007R"
And I close the current editor

Given I open an editor "3LS1007R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "3LS1007R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "3LS1007R"
And I close the current editor

# 4. Teilruecklieferung, buchen
Given I open an editor "1LS1007" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1007"
And I set field "nummer" to "4LS1007R"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "he" to "kg" in row 1
And I set field "mge" to "-10" in row 1
And I set field "platz" to "F126" in row 1
And I save the current editor

Given I open an editor "4LS1007R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+4LS1007R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "4LS1007R"
And I close the current editor

Given I open an editor "3LS1007R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "3LS1007R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "3LS1007R"
And I close the current editor

# 3. Teilruecklieferung buchen
Given I open an editor "3LS1007R" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "3LS1007R"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "3LS1007R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+3LS1007R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "3LS1007R"
And I close the current editor

Given I open an editor "4LS1007R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+4LS1007R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "4LS1007R"
And I close the current editor

Scenario: Teilruecklieferungen EK, Chargen

# 1. Teilruecklieferung, buchen
Given I open an editor "1LS1008" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1008"
And I set field "nummer" to "1LS1008R"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "he" to "kg" in row 1
And I set field "mge" to "-17" in row 1
And I set field "platz" to "F127" in row 1
And I save the current editor

Given I open an editor "1LS1008R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1008R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1008R"
And I close the current editor

# 2. Teilruecklieferung, buchen
Given I open an editor "1LS1008" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1008"
And I set field "nummer" to "2LS1008R"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "he" to "kg" in row 1
And I set field "mge" to "-13" in row 1
And I set field "platz" to "F127" in row 1
And I save the current editor

Given I open an editor "2LS1008R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2LS1008R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "2LS1008R"
And I close the current editor

Given I open an editor "1LS1008R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1008R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1008R"
And I close the current editor

# Storno 1. Teilruecklieferung
Given I open an editor "1LS1008R" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+1LS1008R"
And I set field "nummer" to "1LS1008S"
And I save the current editor

Given I open an editor "1LS1008S" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1008S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1008S"
And I close the current editor

Scenario: Teilruecklieferungen EK, Zugeordneten Bestand wegnehmen

Given I open an editor "1LS1009" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1009"
And I set field "nummer" to "1LS1009R"
And I set field "vom" to "."
And I set field "mge" to "-36" in row 1
And I set field "platz" to "F128" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I set field "zuomge" to "-36" in row 1
And I press button "burueckmzzuord"
And I save the current editor
And I switch the current editor to editor "1LS1009"
And I save the current editor

Given I open an editor "1LS1009U" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "nummer" to "1LS1009U"
And I set field "lief" to "1"
And I set field "vom" to "."
And I set field "umplatz" to "F128"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artikel" to "AUFTRAGSBEZ" in row 1
And I set field "mge" to "36" in row 1
And I set field "he" to "Stück" in row 1
And I set field "platz" to "F129" in row 1
And I set field "verw" to "1BE100_9" in row 1
And I set field "projekt" to "100" in row 1
And I save the current editor

Given I open an editor "1LS1009R" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "1LS1009R"
And I set field "ueb" to "ja"
And I save the current editor

Scenario: Teilruecklieferungen EK, Abgaenge buchen

Given I open an editor "1LS1010A" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "nummer" to "1LS1010A"
And I set field "kunde" to "1"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artikel" to "AUFTRAGSBEZ" in row 1
And I set field "mge" to "9" in row 1
And I set field "he" to "kg" in row 1
And I set field "platz" to "F131" in row 1
And I set field "verw" to "1BE100_10" in row 1
And I set field "projekt" to "100" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "AUFTRAGSBEZ" in row 2
And I set field "mge" to "11" in row 2
And I set field "he" to "kg" in row 2
And I set field "platz" to "F132" in row 2
And I set field "verw" to "1BE100_10" in row 2
And I set field "projekt" to "100" in row 2
And I save the current editor

Given I open an editor "1LS1010" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1010"
And I set field "nummer" to "1LS1010R"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "mge" to "-36" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I set field "mzueb" to "ja"
And I delete row at position 1
And I append rows
    | lpsuch | zuomge |
    | F130   | -10    |
    | F131   | -7,5   |
    | F132   | -8,5   |
And I save the current editor
And I switch the current editor to editor "1LS1010"
And I save the current editor

Given I open an editor "1LS1010R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1010R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1010R"
And I close the current editor

Scenario: Materialzuordnungen in der Bestellung bei Lieferscheinstorno

Given I open an editor "1BE100" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "1BE100"
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I save the current editor

Given I open an editor "1BE100" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "+1BE100"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1BE100"
And I close the current editor

Scenario: Storno EK-Ruecklieferung

Given I open an editor "1LS1002R" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+1LS1002R"
And I set field "nummer" to "1LS1002S"
Then pressing button "mzsubm" in row 1 to open a subeditor throws the exception "1272"
And I save the current editor

Given I open an editor "1LS1002S" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1002S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1002S"
And I close the current editor

Scenario: Storno EK-Rechnung mit Lagerbewegung, Verwendung und Projekt

Given I open an editor "1RE1011" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+1RE1011"
And I set field "nummer" to "1RE1011S"
And I save the current editor

Given I open an editor "1RE1011S" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1RE1011S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1RE1011S"
And I close the current editor

Scenario: Ruecklieferung EK-Rechnung mit Lagerbewegung, Verwendung und Projekt, ohne MZs

Given I open an editor "1RE1012" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+1RE1012"
And I set field "nummer" to "1LS1012R"
And I set field "ueb" to "true"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "mge" to "-36" in row 1
And I set field "platz" to "F134" in row 1
And I save the current editor

Given I open an editor "1LS1012R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS1012R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1012R"
And I close the current editor

Scenario: Storno EK-Rechnung mit Lagerbewegung, Verwendung und Projekt, keine Bestellung

Given I open an editor "1RE1013" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+1RE1013"
And I set field "nummer" to "1RE1013S"
And I save the current editor

Given I open an editor "1RE1013S" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1RE1013S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1RE1013S"
And I close the current editor

Scenario: Ruecklieferung EK-Rechnung mit Lagerbewegung, Verwendung und Projekt, ohne MZs, keien Bestellung

Given I open an editor "1RE1014" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+1RE1014"
And I set field "nummer" to "1LS1014R"
And I set field "ueb" to "true"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "mge" to "-36" in row 1
And I set field "platz" to "F136" in row 1
And I save the current editor

Given I open an editor "1LS1014R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS1014R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1014R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein, Lagerplatzvergabe

Given I open an editor "1LS1015" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1015"
And I set field "nummer" to "1LS1015R"
And I set field "vom" to "."
And I set field "mge" to "-36" in row 1
And I set field "platz" to "F137" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I set field "mzueb" to "nein"
And I delete row at position 1
And I append rows
    | lpsuch | einh  | zuomge |
    | F137   | kg    | -5     |
    |        | kg    | -10    |
    | F137   | kg    | -10    |
    |        | kg    | -5     |
And I save the current editor
And I switch the current editor to editor "1LS1015"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1015R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1015R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1015R"
And I close the current editor

Given I open an editor "1LS1016" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1016"
And I set field "nummer" to "1LS1016R"
And I set field "vom" to "."
And I set field "mge" to "-36" in row 1
And I set field "platz" to "F138" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I set field "mzueb" to "nein"
And I delete row at position 1
And I append rows
    | lpsuch | einh  | zuomge |
    | F138   | kg    | -72    |
And I save the current editor
And I switch the current editor to editor "1LS1016"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1016R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1016R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1016R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit Verwendung und Projekt, unterschiedliche Lagerplaetze

Given I open an editor "1LS1017" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1017"
And I set field "nummer" to "1LS1017R"
And I set field "vom" to "."
And I set field "ueb" to "true"
And I set field "he" to "Stück" in row 1
And I set field "mge" to "-15" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | einh  | zuomge |
    | F142   | kg    | -10    |
    | F141   | kg    | -5     |
    | F140   | kg    | -5     |
    | F139   | kg    | -10    |
And I press button "burueckmzzuord"
And I save the current editor
And I switch the current editor to editor "1LS1017"
And I save the current editor

Given I open an editor "1LS1017R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1017R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1017R"
And I close the current editor

# -----------------------------------------------------------------------------
#  S E T A R T I K E L
# -----------------------------------------------------------------------------

Scenario: Storno VK-Lieferschein mit Setartikel, ohne Reservierungen

Given I open an editor "1AU109" from table "(Sales):(ServiceOrder)" with command "DELIVERY" for record "1AU109"
And I set field "nummer" to "1LS1049"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "1LS1049" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "1LS1049"
And I set field "nummer" to "1LS1049S"
And I save the current editor

Given I open an editor "1LS1049S" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1049S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1049S"
And I close the current editor

Scenario: Storno VK-Lieferschein mit Setartikel, Verwendung und Projekt

Given I open an editor "KOMP1" from table "(Part):(Product)" with command "UPDATE" for record "KOMP1"
And I set field "zuplatz" to "F210"
And I save the current editor
Given I open an editor "KOMP2" from table "(Part):(Product)" with command "UPDATE" for record "KOMP2"
And I set field "zuplatz" to "F211"
And I save the current editor
Given I open an editor "KOMP3" from table "(Part):(Product)" with command "UPDATE" for record "KOMP3"
And I set field "zuplatz" to "F212"
And I save the current editor

Given I open an editor "1AU110" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU110"
And I set field "nummer" to "1LS1050"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge |
    | F210   | kg    | 40     |
    | F210   | Stück | 20     |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F211   | Stück | 10     |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F212   | Stück | 5      |
And I save the current editor
And I switch the current editor to editor "1AU110"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1050" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "1LS1050"
And I set field "nummer" to "1LS1050S"
And I save the current editor

Given I open an editor "1LS1050S" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1050S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1050S"
And I close the current editor

Scenario: Ruecklieferung VK-Lieferschein mit Setartikel, Verwendung und Projekt, ohne MZs

Given I open an editor "KOMP1" from table "(Part):(Product)" with command "UPDATE" for record "KOMP1"
And I set field "zuplatz" to "F213"
And I save the current editor
Given I open an editor "KOMP2" from table "(Part):(Product)" with command "UPDATE" for record "KOMP2"
And I set field "zuplatz" to "F214"
And I save the current editor
Given I open an editor "KOMP3" from table "(Part):(Product)" with command "UPDATE" for record "KOMP3"
And I set field "zuplatz" to "F215"
And I save the current editor

Given I open an editor "1AU111" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU111"
And I set field "nummer" to "1LS1051"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge |
    | F213   | kg    | 80     |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F214   | kg    | 20     |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F215   | kg    | 10     |
And I save the current editor
And I switch the current editor to editor "1AU111"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1051" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1051"
And I set field "nummer" to "1LS1051R"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "1LS1051R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1051R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1051R"
And I close the current editor

Scenario: Ruecklieferung VK-Lieferschein mit Setartikel, Verwendung und Projekt, MZ-Menge kleiner Pos-Menge

Given I open an editor "KOMP1" from table "(Part):(Product)" with command "UPDATE" for record "KOMP1"
And I set field "zuplatz" to "F216"
And I save the current editor
Given I open an editor "KOMP2" from table "(Part):(Product)" with command "UPDATE" for record "KOMP2"
And I set field "zuplatz" to "F217"
And I save the current editor
Given I open an editor "KOMP3" from table "(Part):(Product)" with command "UPDATE" for record "KOMP3"
And I set field "zuplatz" to "F218"
And I save the current editor

Given I open an editor "1AU112" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU112"
And I set field "nummer" to "1LS1052"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge |
    | F216   | kg    | 80     |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F217   | kg    | 20     |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F218   | kg    | 10     |
And I save the current editor
And I switch the current editor to editor "1AU112"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1052" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1052"
And I set field "nummer" to "1LS1052R"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge |
    | F216   | kg    | -40    |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F217   | kg    | -10    |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F218   | kg    | -5     |
And I save the current editor
And I switch the current editor to editor "1LS1052"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1052R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1052R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1052R"
And I close the current editor

Scenario: Ruecklieferung VK-Lieferschein mit Setartikel, Verwendung und Projekt, Pos-Menge kleiner MZ-Menge

Given I open an editor "KOMP1" from table "(Part):(Product)" with command "UPDATE" for record "KOMP1"
And I set field "zuplatz" to "F219"
And I save the current editor
Given I open an editor "KOMP2" from table "(Part):(Product)" with command "UPDATE" for record "KOMP2"
And I set field "zuplatz" to "F220"
And I save the current editor
Given I open an editor "KOMP3" from table "(Part):(Product)" with command "UPDATE" for record "KOMP3"
And I set field "zuplatz" to "F221"
And I save the current editor

Given I open an editor "1AU113" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU113"
And I set field "nummer" to "1LS1053"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge |
    | F219   | kg    | 80     |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F220   | kg    | 20     |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F221   | kg    | 10     |
And I save the current editor
And I switch the current editor to editor "1AU113"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1053" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1053"
And I set field "nummer" to "1LS1053R"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge |
    | F219   | kg    | -80    |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F220   | kg    | -20    |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F221   | kg    | -10    |
And I save the current editor
And I switch the current editor to editor "1LS1053"
And I set field "mge" to "-7" in row 1
And I save the current editor

Given I open an editor "1LS1053R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS1053R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1053R"
And I close the current editor

Given I open an editor "1LS1053R" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "1LS1053R"
And I set field "ueb" to "true"
And I set field "mge" to "-5" in row 1
And I save the current editor

Given I open an editor "1LS1053R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1053R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1053R"
And I close the current editor

Scenario: Teilruecklieferungen VK-Lieferschein mit Setartikel, Verwendung und Projekt, Chargen

Given I open an editor "KOMP1" from table "(Part):(Product)" with command "UPDATE" for record "KOMP1"
And I set field "zuplatz" to "F222"
And I save the current editor
Given I open an editor "KOMP2" from table "(Part):(Product)" with command "UPDATE" for record "KOMP2"
And I set field "zuplatz" to "F223"
And I save the current editor
Given I open an editor "KOMP3" from table "(Part):(Product)" with command "UPDATE" for record "KOMP3"
And I set field "zuplatz" to "F224"
And I save the current editor

Given I open an editor "1AU114" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU114"
And I set field "nummer" to "1LS1054"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh | zuomge | charge |
    | F222   | kg   | 10     | CH210  |
    | F222   | kg   | 20     | CH211  |
    | F222   | kg   | 50     | CH212  |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh | zuomge | charge |
    | F223   | kg   | 12     | CH215  |
    | F223   | kg   | 6      | CH214  |
    | F223   | kg   | 2      | CH213  |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh | zuomge | charge |
    | F224   | kg   | 2      | CH216  |
    | F224   | kg   | 4      | CH217  |
    | F224   | kg   | 4      | CH218  |
And I save the current editor
And I switch the current editor to editor "1AU114"
And I set field "ueb" to "ja"
And I save the current editor

# 1.Teilruecklieferung, keine Buchung
Given I open an editor "1LS1054" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1054"
And I set field "nummer" to "1LS1054R"
And I set field "vom" to "."
And I set field "mge" to "-2" in row 1
And I save the current editor

# 2. Teilruecklieferung, keine Buchung
Given I open an editor "1LS1054" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1054"
And I set field "nummer" to "2LS1054R"
And I set field "vom" to "."
And I set field "mge" to "-3" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F223   | kg    | -6     |
And I press button "burueckmzzuord"
And I save the current editor
And I switch the current editor to editor "1LS1054"
And I save the current editor

# 3. Teilruecklieferung, keine Buchung
Given I open an editor "1LS1054" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1054"
And I set field "nummer" to "3LS1054R"
And I set field "vom" to "."
And I set field "mge" to "-5" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge |
    | F222   | kg    | -10    |
And I press button "burueckmzzuord"
And I save the current editor
And I switch the current editor to editor "1LS1054"
And I save the current editor

# 2. Teilruecklieferung zuruecknehmen
Given I open an editor "2LS1054R" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "2LS1054R"
And I set field "mge" to "0" in row 1
And I save the current editor

# 1. Teilruecklieferung buchen
Given I open an editor "1LS1054R" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "1LS1054R"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1054R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1054R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1054R"
And I close the current editor

Given I open an editor "3LS1054R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "3LS1054R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "3LS1054R"
And I close the current editor

# 4. Teilruecklieferung, direkte Buchung
Given I open an editor "1LS1054" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1054"
And I set field "nummer" to "4LS1054R"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "mge" to "-3" in row 1
And I save the current editor

# 3. Teilruecklieferung buchen
Given I open an editor "3LS1054R" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "3LS1054R"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "3LS1054R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+3LS1054R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "3LS1054R"
And I close the current editor

Given I open an editor "4LS1054R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+4LS1054R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "4LS1054R"
And I close the current editor

Scenario: Setartikel-Materialzuordnungen im Auftrag bei Lieferscheinstorno

Given I open an editor "1AU110" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "1AU110"
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I save the current editor

Given I open an editor "1AU110" from table "(Sales):(SalesOrder)" with command "VIEW" for record "+1AU110"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1AU110"
And I close the current editor

Scenario: Storno VK-Ruecklieferung mit Setartikel

Given I open an editor "1LS1051R" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "+1LS1051R"
And I set field "nummer" to "1LS1051S"
Then pressing button "mzabsm" in row 1 to open a subeditor throws the exception "1272"
And I save the current editor

Given I open an editor "1LS1051S" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1051S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1051S"
And I close the current editor

Scenario: Ruecklieferung VK-Lieferschein mit Setartikel, Lagerplatzvergabe

Given I open an editor "1LS1020" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1020"
And I set field "nummer" to "1LS1020R"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "mge" to "-1" in row 1
And I set field "abplatz" to "EXTERN2" in row 1
And I save the current editor

Given I open an editor "1LS1020R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1020R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1020R"
And I close the current editor

Given I open an editor "1LS1020" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1020"
And I set field "nummer" to "2LS1020R"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "mge" to "-2" in row 1
And I save the current editor

Given I open an editor "2LS1020R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+2LS1020R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "2LS1020R"
And I close the current editor

Given I open an editor "EXTERN" from table "(Warehouse):(WarehouseGroup)" with command "UPDATE" for record "EXTERN"
And I set field "vkruecklieferung" to ""
And I set field "vkkundenanlieferung" to ""
And I save the current editor

Given I open an editor "1LS1020" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1020"
And I set field "nummer" to "3LS1020R"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "mge" to "-1" in row 1
And I set field "abplatz" to "EXTERN2" in row 1
And I save the current editor

Given I open an editor "3LS1020R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+3LS1020R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "3LS1020R"
And I close the current editor

Given I open an editor "1LS1020" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1020"
And I set field "nummer" to "4LS1020R"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "mge" to "-2" in row 1
And I save the current editor

Given I open an editor "4LS1020R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+4LS1020R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "4LS1020R"
And I close the current editor

Given I open an editor "1LS1020" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1020"
And I set field "nummer" to "5LS1020R"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "mge" to "-1" in row 1
And I save the current editor

Given I open an editor "5LS1020R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+5LS1020R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "5LS1020R"
And I close the current editor

Given I open an editor "1LS1020" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1020"
And I set field "nummer" to "6LS1020R"
And I set field "vom" to "."
And I set field "mge" to "-2" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | einh  | zuomge |
    | kg    | -8     |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | -2     |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | -1     |
And I save the current editor
And I switch the current editor to editor "1LS1020"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "6LS1020R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+6LS1020R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "6LS1020R"
And I close the current editor

Given I open an editor "1LS1020" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1020"
And I set field "nummer" to "7LS1020R"
And I set field "vom" to "."
And I set field "mge" to "-1" in row 1
And I set field "platz" to "EXTERN" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge |
    | EXTERN | kg    | -8     |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | EXTERN | kg    | -2     |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | EXTERN | kg    | -1     |
And I save the current editor
And I switch the current editor to editor "1LS1020"
And I set field "ueb" to "true"
And I save the current editor

Given I open an editor "7LS1020R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+7LS1020R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "7LS1020R"
And I close the current editor

Scenario: Externer Lagerplatz in Setartikel-MZs

Given I open an editor "1AU126" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "nummer" to "1AU126"
And I create a new row at the end of the table
And I set field "artex" to "SETART" in row 1
And I set field "mge" to "15" in row 1
And I set field "he" to "Stück" in row 1
And I set field "platz" to "F1" in row 1
And I set field "verw" to "1AU126_1" in row 1
And I set field "projekt" to "100" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge |
    | extern | kg    | 15     |
Then saving the current editor throws the exception "4170"
And I set field "lpsuch" to "F1" in row 1
And I save the current editor
And I switch the current editor to editor "1AU126"
And I save the current editor

Given I open an editor "1RE126" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "1AU126"
And I set field "nummer" to "1RE126"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
# Aktion nicht meoglich, da der Buchungsvorgang aktiv ist.
Then pressing button "mzabsm" in row 1 throws the exception "11236"
And I set field "ueb" to "nein"
# Zwischenspeichern
And I respond with answer "ja" to the dialog with id "4841"
And I press button "schreib"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I close the current editor
And I switch the current editor to editor "1RE126"
And I close the current editor

Scenario: Storno VK-Lieferschein mit Setartikel, Verwendung und Projekt, kein Auftrag

Given I open an editor "KOMP1" from table "(Part):(Product)" with command "UPDATE" for record "KOMP1"
And I set field "abplatz" to "F230"
And I set field "zuplatz" to "F230"
And I save the current editor
Given I open an editor "KOMP2" from table "(Part):(Product)" with command "UPDATE" for record "KOMP2"
And I set field "abplatz" to "F231"
And I set field "zuplatz" to "F231"
And I save the current editor
Given I open an editor "KOMP3" from table "(Part):(Product)" with command "UPDATE" for record "KOMP3"
And I set field "abplatz" to "F232"
And I set field "zuplatz" to "F232"
And I save the current editor

Given I open an editor "1LS1021" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "nummer" to "1LS1021"
And I set field "kunde" to "1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artikel" to "SETART" in row 1
And I set field "mge" to "10" in row 1
And I set field "platz" to "F1" in row 1
And I set field "verw" to "1LS121_1" in row 1
And I set field "projekt" to "100" in row 1
And I save the current editor

Given I open an editor "1LS1021" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "1LS1021"
And I set field "nummer" to "1LS1021S"
And I save the current editor

Given I open an editor "1LS1021S" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1021S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1021S"
And I close the current editor

Scenario: Ruecklieferung VK-Lieferschein mit Setartikel, Verwendung und Projekt, kein Auftrag

Given I open an editor "KOMP1" from table "(Part):(Product)" with command "UPDATE" for record "KOMP1"
And I set field "abplatz" to "F233"
And I set field "zuplatz" to "F233"
And I save the current editor
Given I open an editor "KOMP2" from table "(Part):(Product)" with command "UPDATE" for record "KOMP2"
And I set field "abplatz" to "F234"
And I set field "zuplatz" to "F234"
And I save the current editor
Given I open an editor "KOMP3" from table "(Part):(Product)" with command "UPDATE" for record "KOMP3"
And I set field "abplatz" to "F235"
And I set field "zuplatz" to "F235"
And I save the current editor

Given I open an editor "1LS1022" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "nummer" to "1LS1022"
And I set field "kunde" to "1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artikel" to "SETART" in row 1
And I set field "mge" to "10" in row 1
And I set field "platz" to "F1" in row 1
And I set field "verw" to "1LS122_1" in row 1
And I set field "projekt" to "100" in row 1
And I save the current editor

Given I open an editor "1LS1022" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1022"
And I set field "nummer" to "1LS1022R"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "1LS1022R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1022R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1022R"
And I close the current editor

Scenario: Storno VK-Rechnung mit Lagerbewegung und Setartikel, Verwendung und Projekt, ohne MZs

Given I open an editor "KOMP1" from table "(Part):(Product)" with command "UPDATE" for record "KOMP1"
And I set field "zuplatz" to "F236"
And I save the current editor
Given I open an editor "KOMP2" from table "(Part):(Product)" with command "UPDATE" for record "KOMP2"
And I set field "zuplatz" to "F237"
And I save the current editor
Given I open an editor "KOMP3" from table "(Part):(Product)" with command "UPDATE" for record "KOMP3"
And I set field "zuplatz" to "F238"
And I save the current editor

Given I open an editor "1AU115" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "1AU115"
And I set field "nummer" to "1RE1023"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I press button "offueb" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "NS." in row 2
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge |
    | F236   | kg    | 80     |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F237   | kg    | 20     |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F238   | kg    | 10     |
And I save the current editor
And I switch the current editor to editor "1AU115"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1RE1023" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+1RE1023"
And I set field "nummer" to "1RE1023S"
And I save the current editor

Given I open an editor "1RE1023S" from table "(Sales):(Invoice)" with command "VIEW" for record "+1RE1023S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1RE1023S"
And I close the current editor

Scenario: Ruecklieferung VK-Rechnung mit Lagerbewegung und Setartikel, Verwendung und Projekt, ohne MZs

Given I open an editor "KOMP1" from table "(Part):(Product)" with command "UPDATE" for record "KOMP1"
And I set field "zuplatz" to "F239"
And I save the current editor
Given I open an editor "KOMP2" from table "(Part):(Product)" with command "UPDATE" for record "KOMP2"
And I set field "zuplatz" to "F240"
And I save the current editor
Given I open an editor "KOMP3" from table "(Part):(Product)" with command "UPDATE" for record "KOMP3"
And I set field "zuplatz" to "F241"
And I save the current editor

Given I open an editor "1AU116" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "1AU116"
And I set field "nummer" to "1RE1024"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I press button "offueb" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "NS." in row 2
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge |
    | F239   | kg    | 80     |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F240   | kg    | 20     |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F241   | kg    | 10     |
And I save the current editor
And I switch the current editor to editor "1AU116"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1RE1024" from table "(Sales):(Invoice)" with command "RETURN" for record "+1RE1024"
And I set field "nummer" to "1LS1024R"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "1LS1024R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS1024R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1024R"
And I close the current editor

Scenario: Storno VK-Rechnung mit Lagerbewegung und Setartikel, Verwendung und Projekt, ohne MZs, kein Auftrag

Given I open an editor "KOMP1" from table "(Part):(Product)" with command "UPDATE" for record "KOMP1"
And I set field "zuplatz" to "F242"
And I set field "abplatz" to "F242"
And I save the current editor
Given I open an editor "KOMP2" from table "(Part):(Product)" with command "UPDATE" for record "KOMP2"
And I set field "zuplatz" to "F243"
And I set field "abplatz" to "F243"
And I save the current editor
Given I open an editor "KOMP3" from table "(Part):(Product)" with command "UPDATE" for record "KOMP3"
And I set field "zuplatz" to "F244"
And I set field "abplatz" to "F244"
And I save the current editor

Given I open an editor "1RE1025" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "1RE1025"
And I set field "kunde" to "1"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artikel" to "SETART" in row 1
And I set field "mge" to "10" in row 1
And I set field "he" to "Stück" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "NS." in row 2
# Aktion nicht erlaubt, da der Buchungsvorgang aktiv ist.
Then pressing button "mzabsm" in row 1 throws the exception "11236"
And I save the current editor

Given I open an editor "1RE1025" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+1RE1025"
And I set field "nummer" to "1RE1025S"
And I save the current editor

Given I open an editor "1RE1025S" from table "(Sales):(Invoice)" with command "VIEW" for record "+1RE1025S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1RE1025S"
And I close the current editor

Scenario: Ruecklieferung VK-Rechnung mit Lagerbewegung und Setartikel, Verwendung und Projekt, ohne MZs, kein Auftrag

Given I open an editor "KOMP1" from table "(Part):(Product)" with command "UPDATE" for record "KOMP1"
And I set field "zuplatz" to "F245"
And I set field "abplatz" to "F245"
And I save the current editor
Given I open an editor "KOMP2" from table "(Part):(Product)" with command "UPDATE" for record "KOMP2"
And I set field "zuplatz" to "F246"
And I set field "abplatz" to "F246"
And I save the current editor
Given I open an editor "KOMP3" from table "(Part):(Product)" with command "UPDATE" for record "KOMP3"
And I set field "zuplatz" to "F247"
And I set field "abplatz" to "F247"
And I save the current editor

Given I open an editor "1RE1026" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "1RE1026"
And I set field "kunde" to "1"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artikel" to "SETART" in row 1
And I set field "mge" to "10" in row 1
And I set field "he" to "Stück" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "NS." in row 2
And I save the current editor

Given I open an editor "1RE1026" from table "(Sales):(Invoice)" with command "RETURN" for record "+1RE1026"
And I set field "nummer" to "1LS1026R"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "1LS1026R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS1026R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1026R"
And I close the current editor

Scenario: Storno VK-Lieferschein mit Setartikel und Koppelproduktkomponenten

Given I open an editor "KOMP1" from table "(Part):(Product)" with command "UPDATE" for record "KOMP1"
And I set field "abplatz" to "F256"
And I set field "zuplatz" to "F256"
And I save the current editor
Given I open an editor "KOMP2" from table "(Part):(Product)" with command "UPDATE" for record "KOMP2"
And I set field "abplatz" to "F257"
And I set field "zuplatz" to "F257"
And I save the current editor
Given I open an editor "KOMP3" from table "(Part):(Product)" with command "UPDATE" for record "KOMP3"
And I set field "abplatz" to "F258"
And I set field "zuplatz" to "F258"
And I save the current editor
Given I open an editor "KOMP4" from table "(Part):(Product)" with command "UPDATE" for record "KOMP4"
And I set field "abplatz" to "F259"
And I set field "zuplatz" to "F259"
And I save the current editor
Given I open an editor "KOMP5" from table "(Part):(Product)" with command "UPDATE" for record "KOMP5"
And I set field "abplatz" to "F260"
And I set field "zuplatz" to "F260"
And I save the current editor
Given I open an editor "KOMP6" from table "(Part):(Product)" with command "UPDATE" for record "KOMP6"
And I set field "abplatz" to "F261"
And I set field "zuplatz" to "F261"
And I save the current editor

Given I open an editor "1AU124" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "nummer" to "1AU124"
And I create a new row at the end of the table
And I set field "artex" to "SETARTKOP" in row 1
And I set field "mge" to "10" in row 1
And I set field "he" to "Stück" in row 1
And I set field "platz" to "F1" in row 1
And I set field "verw" to "1AU124_1" in row 1
And I set field "projekt" to "100" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | einh  | zuomge |
    | kg    | 60     |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | 15     |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | 7,5    |
And I press button "abv" to open a subeditor for "mz4"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | 30     |
And I press button "abv" to open a subeditor for "mz5"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | 15     |
And I press button "abv" to open a subeditor for "mz6"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | 7,5    |
And I save the current editor
And I switch the current editor to editor "1AU124"
And I save the current editor

Given I open an editor "1AU124" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU124"
And I set field "nummer" to "1LS1030"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "1LS1030" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS1030"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz4"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz5"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz6"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1030"
And I close the current editor

Given I open an editor "1LS1030" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "1LS1030"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1030" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS1030"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz4"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz5"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz6"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1030"
And I close the current editor

Given I open an editor "1LS1030" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "1LS1030"
And I set field "nummer" to "1LS1030S"
And I save the current editor

Given I open an editor "1LS1030S" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1030S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz4"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz5"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz6"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1030S"
And I close the current editor

Scenario: Storno VK-Lieferschein mit Setartikel und Koppelproduktkomponenten, kein Auftrag

Given I open an editor "KOMP1" from table "(Part):(Product)" with command "UPDATE" for record "KOMP1"
And I set field "abplatz" to "F362"
And I set field "zuplatz" to "F362"
And I save the current editor
Given I open an editor "KOMP2" from table "(Part):(Product)" with command "UPDATE" for record "KOMP2"
And I set field "abplatz" to "F363"
And I set field "zuplatz" to "F363"
And I save the current editor
Given I open an editor "KOMP3" from table "(Part):(Product)" with command "UPDATE" for record "KOMP3"
And I set field "abplatz" to "F364"
And I set field "zuplatz" to "F364"
And I save the current editor
Given I open an editor "KOMP4" from table "(Part):(Product)" with command "UPDATE" for record "KOMP4"
And I set field "abplatz" to "F365"
And I set field "zuplatz" to "F365"
And I save the current editor
Given I open an editor "KOMP5" from table "(Part):(Product)" with command "UPDATE" for record "KOMP5"
And I set field "abplatz" to "F366"
And I set field "zuplatz" to "F366"
And I save the current editor
Given I open an editor "KOMP6" from table "(Part):(Product)" with command "UPDATE" for record "KOMP6"
And I set field "abplatz" to "F367"
And I set field "zuplatz" to "F367"
And I save the current editor

Given I open an editor "1LS1031" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "nummer" to "1LS1031"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "SETARTKOP" in row 1
And I set field "mge" to "10" in row 1
And I set field "he" to "Stück" in row 1
And I set field "platz" to "F1" in row 1
And I set field "verw" to "1LS131_1" in row 1
And I set field "projekt" to "100" in row 1
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1031" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "1LS1031"
And I set field "nummer" to "1LS1031S"
And I save the current editor

Given I open an editor "1LS1031S" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1031S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz4"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz5"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz6"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1031S"
And I close the current editor

Scenario: Ruecklieferung VK-Lieferschein mit Setartikel und Koppelproduktkomponenten

Given I open an editor "KOMP1" from table "(Part):(Product)" with command "UPDATE" for record "KOMP1"
And I set field "abplatz" to "F268"
And I set field "zuplatz" to "F268"
And I save the current editor
Given I open an editor "KOMP2" from table "(Part):(Product)" with command "UPDATE" for record "KOMP2"
And I set field "abplatz" to "F269"
And I set field "zuplatz" to "F269"
And I save the current editor
Given I open an editor "KOMP3" from table "(Part):(Product)" with command "UPDATE" for record "KOMP3"
And I set field "abplatz" to "F270"
And I set field "zuplatz" to "F270"
And I save the current editor
Given I open an editor "KOMP4" from table "(Part):(Product)" with command "UPDATE" for record "KOMP1"
And I set field "abplatz" to "F271"
And I set field "zuplatz" to "F271"
And I save the current editor
Given I open an editor "KOMP5" from table "(Part):(Product)" with command "UPDATE" for record "KOMP2"
And I set field "abplatz" to "F272"
And I set field "zuplatz" to "F272"
And I save the current editor
Given I open an editor "KOMP6" from table "(Part):(Product)" with command "UPDATE" for record "KOMP3"
And I set field "abplatz" to "F273"
And I set field "zuplatz" to "F273"
And I save the current editor

Given I open an editor "1AU125" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "nummer" to "1AU125"
And I create a new row at the end of the table
And I set field "artex" to "SETARTKOP" in row 1
And I set field "mge" to "10" in row 1
And I set field "he" to "Stück" in row 1
And I set field "platz" to "F1" in row 1
And I set field "verw" to "1AU125_1" in row 1
And I set field "projekt" to "100" in row 1
And I save the current editor

Given I open an editor "1AU125" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU125"
And I set field "nummer" to "1LS1032"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | einh  | zuomge |
    | kg    | 60     |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | 15     |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | 7,5    |
And I press button "abv" to open a subeditor for "mz4"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | 30     |
And I press button "abv" to open a subeditor for "mz5"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | 15     |
And I press button "abv" to open a subeditor for "mz6"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | 7,5    |
And I save the current editor
And I switch the current editor to editor "1AU125"
And I save the current editor

Given I open an editor "1LS1032" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS1032"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz4"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz5"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz6"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1032"
And I close the current editor

Given I open an editor "1LS1032" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "1LS1032"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1032" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS1032"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz4"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz5"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz6"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1032"
And I close the current editor

Given I open an editor "1LS1032R" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1032"
And I set field "nummer" to "1LS1032R"
And I set field "vom" to "."
And I press button "offueb" in row 1
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | einh  | zuomge |
    | kg    | -60    |
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | -15    |
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | -7,5   |
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz4"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1032R"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1032R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1032R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz4"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1032R"
And I close the current editor

Scenario: Ruecklieferung VK-Lieferschein mit Setartikel und Koppelproduktkomponenten, keine Bestellung

Given I open an editor "KOMP1" from table "(Part):(Product)" with command "UPDATE" for record "KOMP1"
And I set field "abplatz" to "F274"
And I set field "zuplatz" to "F274"
And I save the current editor
Given I open an editor "KOMP2" from table "(Part):(Product)" with command "UPDATE" for record "KOMP2"
And I set field "abplatz" to "F275"
And I set field "zuplatz" to "F275"
And I save the current editor
Given I open an editor "KOMP3" from table "(Part):(Product)" with command "UPDATE" for record "KOMP3"
And I set field "abplatz" to "F276"
And I set field "zuplatz" to "F276"
And I save the current editor
Given I open an editor "KOMP4" from table "(Part):(Product)" with command "UPDATE" for record "KOMP4"
And I set field "abplatz" to "F277"
And I set field "zuplatz" to "F277"
And I save the current editor
Given I open an editor "KOMP5" from table "(Part):(Product)" with command "UPDATE" for record "KOMP5"
And I set field "abplatz" to "F278"
And I set field "zuplatz" to "F278"
And I save the current editor
Given I open an editor "KOMP6" from table "(Part):(Product)" with command "UPDATE" for record "KOMP6"
And I set field "abplatz" to "F279"
And I set field "zuplatz" to "F279"
And I save the current editor

Given I open an editor "1LS1033" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "nummer" to "1LS1033"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "SETARTKOP" in row 1
And I set field "mge" to "10" in row 1
And I set field "he" to "Stück" in row 1
And I set field "platz" to "F1" in row 1
And I set field "verw" to "1LS133_1" in row 1
And I set field "projekt" to "100" in row 1
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1033R" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1033"
And I set field "nummer" to "1LS1033R"
And I set field "vom" to "."
And I press button "offueb" in row 1
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | einh  | zuomge |
    | kg    | -60    |
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | -15    |
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | -7,5   |
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz4"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1033R"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1033R" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1033R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz4"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1033R"
And I close the current editor

Scenario: Pruefung auf negativen Bestand bei der Ruecklieferung von Abgaengen

Given I open an editor "KOMP1" from table "(Part):(Product)" with command "UPDATE" for record "KOMP1"
And I set field "abplatz" to "F521"
And I set field "zuplatz" to "F522"
And I save the current editor
Given I open an editor "KOMP2" from table "(Part):(Product)" with command "UPDATE" for record "KOMP2"
And I set field "abplatz" to "F521"
And I set field "zuplatz" to "F522"
And I save the current editor
Given I open an editor "KOMP3" from table "(Part):(Product)" with command "UPDATE" for record "KOMP3"
And I set field "abplatz" to "F521"
And I set field "zuplatz" to "F522"
And I save the current editor

Given I open an editor "1LS1034" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "nummer" to "1LS1034"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "SETART" in row 1
And I set field "mge" to "10" in row 1
And I set field "he" to "Stück" in row 1
And I set field "platz" to "F1" in row 1
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1034R" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS1034"
And I set field "nummer" to "1LS1034R"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "2037"
And I set field "ueb" to "nein"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | platz | einh  | zuomge |
    | F521  | Stück | -40    |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | platz | einh  | zuomge |
    | F521  | Stück | -10    |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | platz | einh  | zuomge |
    | F521  | Stück | -5     |
And I save the current editor
And I switch the current editor to editor "1LS1034R"
And I set field "ueb" to "ja"
And I save the current editor

Scenario: Storno VK-Liefeschein mit weiteren Artikeln in der ersten Stufe der AFL

Given I open an editor "KOMP1" from table "(Part):(Product)" with command "UPDATE" for record "KOMP1"
And I set field "abplatz" to "F280"
And I set field "zuplatz" to "F280"
And I save the current editor
Given I open an editor "KOMP2" from table "(Part):(Product)" with command "UPDATE" for record "KOMP2"
And I set field "abplatz" to "F280"
And I set field "zuplatz" to "F280"
And I save the current editor

Given I open an editor "1AU128" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde  | 1      |
    | nummer | 1AU128 |
And I append rows
    | artikel     | mge | he    | platz |
    | AUFTRAGSBEZ | 10  | Stück | F280  |
And I set field "beres" to "true" in row 1
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I append rows
    | elex  | elanzahl |
    | KOMP1 | 1        |
    | KOMP2 | 1        |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "1LS128" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU128"
And I set fields
    | nummer | 1LS128 |
    | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "1LS128" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "1LS128"
And I set field "nummer" to "1LS128S"
And I save the current editor

Given I open an editor "KOMP1" from table "(Part):(Product)" with command "UPDATE" for record "KOMP1"
And I set field "abplatz" to "F281"
And I set field "zuplatz" to "F281"
And I save the current editor
Given I open an editor "KOMP2" from table "(Part):(Product)" with command "UPDATE" for record "KOMP2"
And I set field "abplatz" to "F281"
And I set field "zuplatz" to "F281"
And I save the current editor

Given I open an editor "1AU129" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde  | 1      |
    | nummer | 1AU129 |
And I append rows
    | artikel     | mge | he    | platz |
    | AUFTRAGSBEZ | 10  | Stück | F281  |
And I set field "beres" to "true" in row 1
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I create a new row at position 1
And I set field "elex" to "KOMP2" in row 1
And I set field "elanzahl" to "1" in row 1
And I create a new row at position 1
And I set field "elex" to "KOMP1" in row 1
And I set field "elanzahl" to "1" in row 1
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "1LS129" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU129"
And I set fields
    | nummer | 1LS129 |
    | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "1LS129" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "1LS129"
And I set field "nummer" to "1LS129S"
And I save the current editor

# -----------------------------------------------------------------------------
#  B E I S T E L L U N G E N
# -----------------------------------------------------------------------------

Scenario: Storno EK-Lieferschein mit Beistellungen, Verwendung und Projekt

Given I open an editor "1BE110" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE110"
And I set field "nummer" to "1LS1050"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge |
    | F310   | kg    | 40     |
    | F310   | Stück | 20     |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F311   | Stück | 10     |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F312   | Stück | 5      |
And I save the current editor
And I switch the current editor to editor "1BE110"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1050" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "1LS1050"
And I set field "nummer" to "1LS1050S"
And I save the current editor

Given I open an editor "1LS1050S" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1050S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1050S"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1050S"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit Beistellungen, Verwendung und Projekt, Ruecklieferung ohne MZs
# Projekt kann ich nicht erkennen, es ist kein projekt in den gebindemengen (uo)

Given I open an editor "1BE111" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE111"
#               editor "1BE111" ?? 
#               EIGENTLICH IST DAS HIER DOCH DER LS-EDITOR
And I set field "nummer" to "1LS1051"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge |
    | F313   | kg    | 80     |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F314   | Stück | 20     |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F315   | Stück | 10     |
And I save the current editor
And I switch the current editor to editor "1BE111"
And I set field "ueb" to "ja"
And I save the current editor

# vorbereitung der datenprüfung
# zugehörigkeit/prüflogik: prinzip spiegelbild: die doku findest Du wenn Du i.d. datei nach "zugehörigkeit/prüflogik" suchst  
Given I set StorageQuantity to zero for Product "BEIST1" on StorageLocation "F313" with document "E_RLS_BEIVP"
Given I set StorageQuantity to zero for Product "BEIST2" on StorageLocation "F314" with document "E_RLS_BEIVP"
Given I set StorageQuantity to zero for Product "BEIST3" on StorageLocation "F315" with document "E_RLS_BEIVP"
Given I set StorageQuantity to zero for Product "ARTMITBEIST" on StorageLocation "F1" with document "E_RLS_BEIVP"

# sicher keine bestände mehr!
Given I query "bewertungslagermengen1" from StorageQuantities where "artikel==BEIST1;platz==F313;gebmge<>0;"
Then StorageQuantity is zero
Given I query "bewertungslagermengen1" from StorageQuantities where "artikel==BEIST2;platz==F314;gebmge<>0;"
Then StorageQuantity is zero
Given I query "bewertungslagermengen1" from StorageQuantities where "artikel==BEIST3;platz==F315;gebmge<>0;"
Then StorageQuantity is zero
Given I query "bewertungslagermengen1" from StorageQuantities where "artikel==ARTMITBEIST;platz==F1;gebmge<>0;"
Then StorageQuantity is zero

And I append "prozess in std/test/cucumber/ekvkservice/ruecklieferung_mz.feature" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.50.ref" in cucu_refs_dir
And I append "Scenario: Ruecklieferung EK-Lieferschein mit Beistellungen, Verwendung und Projekt, Ruecklieferung ohne MZs" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.50.ref" in cucu_refs_dir
And I append "--- platzmengen vor return ---" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.50.ref" in cucu_refs_dir
# BEIST1
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==BEIST1;gebmge<>0;platz==F313" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.50.ref" 
# BEIST2
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==BEIST2;gebmge<>0;platz==F314" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.50.ref" 
# BEIST3
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==BEIST3;gebmge<>0;platz==F315" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.50.ref" 
# ARTMITBEIST
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==ARTMITBEIST;gebmge<>0;platz==F1" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.50.ref"

Given I open an editor "1LS1051" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1051"
And I set field "nummer" to "1LS1051R"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "1LS1051RV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1051R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1051RV"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1051RV"
And I close the current editor

And I append "prozessquelle siehe: std/test/cucumber/ekvkservice/ruecklieferung_mz.feature, od. suche ggf. nach dem ref-dateinamen in cucu-skripten" to output file "ref_ev_ruecklieferung_mz_cu.lj.50.ref" in cucu_refs_dir
And I append "--- alle LJ zu return L1LS1051R (zur Sortierung s. Feldliste und MawiSteps.java)" to output file "ref_ev_ruecklieferung_mz_cu.lj.50.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "vorgang^kopf^nummer==1LS1051R;vorgang^kopf^objdbez=Einkauf" to output file "ref_ev_ruecklieferung_mz_cu.lj.50.ref"

# --- gebindemengen
And I append "--- platzmengen nach return ---" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.50.ref" in cucu_refs_dir
# BEIST1
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==BEIST1;gebmge<>0;platz==F313" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.50.ref" 
# BEIST2
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==BEIST2;gebmge<>0;platz==F314" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.50.ref" 
# BEIST3
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==BEIST3;gebmge<>0;platz==F315" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.50.ref" 
# ARTMITBEIST
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==ARTMITBEIST;gebmge<>0;platz==F1" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.50.ref"

# -------------------- ende: gebindemengen prüfen nach rücklieferung -------------

Scenario: Ruecklieferung EK-Lieferschein mit Beistellungen, Verwendung und Projekt, ohne MZs, Beistellteile buchen = nein

Given I open an editor "1BE112" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE112"
And I set field "nummer" to "1LS1052"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge |
    | F316   | kg    | 80     |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F317   | Stück | 20     |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F318   | Stück | 10     |
And I save the current editor
And I switch the current editor to editor "1BE112"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1052" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1052"
And I set field "nummer" to "1LS1052R"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge |
    | F316   | kg    | -80    |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F317   | kg    | -20    |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F318   | kg    | -10    |
And I save the current editor
And I switch the current editor to editor "1LS1052"
And I set field "stl" to "nein" in row 1
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1052R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1052R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1052R"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1052R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit Beistellungen, Verwendung und Projekt, MZ-Menge kleiner Pos-Menge

Given I open an editor "1BE113" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE113"
And I set field "nummer" to "1LS1053"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge |
    | F319   | kg    | 80     |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F320   | kg    | 20     |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F321   | kg    | 10     |
And I save the current editor
And I switch the current editor to editor "1BE113"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1053" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1053"
And I set field "nummer" to "1LS1053R"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge |
    | F319   | kg    | -40    |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F320   | kg    | -10    |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F321   | kg    | -5     |
And I save the current editor
And I switch the current editor to editor "1LS1053"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1053R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1053R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1053R"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1053R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit Beistellungen, Verwendung und Projekt, Pos-Menge kleiner MZ-Menge

Given I open an editor "1BE114" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE114"
And I set field "nummer" to "1LS1054"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge |
    | F322   | kg    | 80     |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F323   | kg    | 20     |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F324   | kg    | 10     |
And I save the current editor
And I switch the current editor to editor "1BE114"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1054" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1054"
And I set field "nummer" to "1LS1054R"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge |
    | F322   | kg    | -80    |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F323   | kg    | -20    |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F324   | kg    | -10    |
And I save the current editor
And I switch the current editor to editor "1LS1054"
And I set field "mge" to "-7" in row 1
And I save the current editor

Given I open an editor "1LS1054R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS1054R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1054R"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1054R"
And I close the current editor

Given I open an editor "1LS1054R" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "1LS1054R"
And I set field "ueb" to "true"
And I set field "mge" to "-5" in row 1
And I save the current editor

Given I open an editor "1LS1054R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1054R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1054R"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1054R"
And I close the current editor

Scenario: Teilruecklieferungen EK-Lieferschein mit Beistellungen, Verwendung und Projekt, Chargen

Given I open an editor "1BE115" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE115"
And I set field "nummer" to "1LS1055"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh | zuomge | charge |
    | F325   | kg   | 10     | CH250  |
    | F325   | kg   | 20     | CH251  |
    | F325   | kg   | 50     | CH252  |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh | zuomge | charge |
    | F326   | kg   | 12     | CH255  |
    | F326   | kg   | 6      | CH254  |
    | F326   | kg   | 2      | CH253  |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh | zuomge | charge |
    | F327   | kg   | 2      | CH256  |
    | F327   | kg   | 4      | CH257  |
    | F327   | kg   | 4      | CH258  |
And I save the current editor
And I switch the current editor to editor "1BE115"
And I set field "ueb" to "ja"
And I save the current editor

# 1.Teilruecklieferung, keine Buchung
Given I open an editor "1LS1055" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1055"
And I set field "nummer" to "1LS1055R"
And I set field "vom" to "."
And I set field "mge" to "-2" in row 1
And I save the current editor

# 2. Teilruecklieferung, keine Buchung
Given I open an editor "1LS1055" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1055"
And I set field "nummer" to "2LS1055R"
And I set field "vom" to "."
And I set field "mge" to "-3" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F326   | kg    | -6     |
And I press button "burueckmzzuord"
And I save the current editor
And I switch the current editor to editor "1LS1055"
And I save the current editor

# 3. Teilruecklieferung, keine Buchung
Given I open an editor "1LS1055" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1055"
And I set field "nummer" to "3LS1055R"
And I set field "vom" to "."
And I set field "mge" to "-5" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge |
    | F325   | kg    | -10    |
And I press button "burueckmzzuord"
And I save the current editor
And I switch the current editor to editor "1LS1055"
And I save the current editor

# 2. Teilruecklieferung zuruecknehmen
Given I open an editor "2LS1055R" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "2LS1055R"
And I set field "mge" to "0" in row 1
And I save the current editor

# 1. Teilruecklieferung buchen
Given I open an editor "1LS1055R" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "1LS1055R"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1055R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1055R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1055R"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1055R"
And I close the current editor

Given I open an editor "3LS1055R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "3LS1055R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "3LS1055R"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "3LS1055R"
And I close the current editor

# 4. Teilruecklieferung, direkte Buchung
Given I open an editor "1LS1055" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1055"
And I set field "nummer" to "4LS1055R"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "mge" to "-3" in row 1
And I save the current editor

# 3. Teilruecklieferung buchen
Given I open an editor "3LS1055R" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "3LS1055R"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "3LS1055R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+3LS1055R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "3LS1055R"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "3LS1055R"
And I close the current editor

Given I open an editor "4LS1055R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+4LS1055R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "4LS1055R"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "4LS1055R"
And I close the current editor

Scenario: Beistell-Materialzuordnungen in der Bestellung bei Lieferscheinstorno

Given I open an editor "1BE110" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "1BE110"
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I save the current editor

Given I open an editor "1BE110" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "+1BE110"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1BE110"
And I close the current editor

Scenario: Storno EK-Ruecklieferung mit Beistellungen

# vorbereitung der datenprüfung
# zugehörigkeit/prüflogik: prinzip spiegelbild: die doku findest Du wenn Du i.d. datei nach "zugehörigkeit/prüflogik" suchst  
Given I set StorageQuantity to zero for Product "BEIST1" on StorageLocation "F313" with document "E_RLS_BEIVs"
Given I set StorageQuantity to zero for Product "BEIST2" on StorageLocation "F314" with document "E_RLS_BEIVs"
Given I set StorageQuantity to zero for Product "BEIST3" on StorageLocation "F315" with document "E_RLS_BEIVs"
Given I set StorageQuantity to zero for Product "ARTMITBEIST" on StorageLocation "F1" with document "E_RLS_BEIVs"

# sicher keine bestände mehr!
Given I query "bewertungslagermengen1" from StorageQuantities where "artikel==BEIST1;platz==F313;gebmge<>0;"
Then StorageQuantity is zero
Given I query "bewertungslagermengen1" from StorageQuantities where "artikel==BEIST2;platz==F314;gebmge<>0;"
Then StorageQuantity is zero
Given I query "bewertungslagermengen1" from StorageQuantities where "artikel==BEIST3;platz==F315;gebmge<>0;"
Then StorageQuantity is zero
Given I query "bewertungslagermengen1" from StorageQuantities where "artikel==ARTMITBEIST;platz==F1;gebmge<>0;"
Then StorageQuantity is zero

Given I open an editor "1LS1051R" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+1LS1051R"
And I set field "nummer" to "1LS1051S"
Then pressing button "mzabsm" in row 1 to open a subeditor throws the exception "1272"
And I save the current editor

Given I open an editor "1LS1051S" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1051S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1051S"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1051S"
And I close the current editor


And I append "--- alle LJ zu storno.return L1LS1051S (zur Sortierung s. Feldliste und MawiSteps.java)" to output file "ref_ev_ruecklieferung_mz_cu.lj.50.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "vorgang^kopf^nummer==1LS1051S;vorgang^kopf^objdbez=Einkauf" to output file "ref_ev_ruecklieferung_mz_cu.lj.50.ref"

# -------------------- gebindemengen prüfen nach storno-rücklieferung -------------
And I append "--- nach storno.return ---" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.50.ref" in cucu_refs_dir
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==BEIST1;gebmge<>0;platz==F313" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.50.ref" 
# BEIST2 in 1LS1051R
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==BEIST2;gebmge<>0;platz==F314" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.50.ref" 
# BEIST3 in 1LS1051R
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==BEIST3;gebmge<>0;platz==F315" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.50.ref" 
# ARTMITBEIST in 1LS1051R
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==ARTMITBEIST;gebmge<>0;platz==F1" to output file "ref_ev_ruecklieferung_mz_cu.platzmengen.50.ref" 

# -------------------- ende: gebindemengen prüfen nach storno-rücklieferung -------------


Scenario: Storno EK-Lieferschein mit Beistellungen, Verwendung und Projekt, keine Bestellung

Given I open an editor "BEIST1" from table "(Part):(Product)" with command "UPDATE" for record "BEIST1"
And I set field "abplatz" to "F328"
And I set field "zuplatz" to "F328"
And I save the current editor
Given I open an editor "BEIST2" from table "(Part):(Product)" with command "UPDATE" for record "BEIST2"
And I set field "abplatz" to "F329"
And I set field "zuplatz" to "F329"
And I save the current editor
Given I open an editor "BEIST3" from table "(Part):(Product)" with command "UPDATE" for record "BEIST3"
And I set field "abplatz" to "F330"
And I set field "zuplatz" to "F330"
And I save the current editor

Given I open an editor "1LS1056" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "nummer" to "1LS1056"
And I set field "lief" to "1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artikel" to "ARTMITBEIST" in row 1
And I set field "mge" to "10" in row 1
And I set field "platz" to "F1" in row 1
And I set field "verw" to "1LS156_1" in row 1
And I set field "projekt" to "100" in row 1
And I save the current editor

Given I open an editor "1LS1056" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "1LS1056"
And I set field "nummer" to "1LS1056S"
And I save the current editor

Given I open an editor "1LS1056S" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1056S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1056S"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit Beistellungen, Verwendung und Projekt, keine Bestellung

Given I open an editor "BEIST1" from table "(Part):(Product)" with command "UPDATE" for record "BEIST1"
And I set field "abplatz" to "F231"
And I set field "zuplatz" to "F231"
And I save the current editor
Given I open an editor "BEIST2" from table "(Part):(Product)" with command "UPDATE" for record "BEIST2"
And I set field "abplatz" to "F232"
And I set field "zuplatz" to "F232"
And I save the current editor
Given I open an editor "BEIST3" from table "(Part):(Product)" with command "UPDATE" for record "BEIST3"
And I set field "abplatz" to "F233"
And I set field "zuplatz" to "F233"
And I save the current editor

Given I open an editor "1LS1057" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "nummer" to "1LS1057"
And I set field "lief" to "1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artikel" to "ARTMITBEIST" in row 1
And I set field "mge" to "10" in row 1
And I set field "platz" to "F1" in row 1
And I set field "verw" to "1LS157_1" in row 1
And I set field "projekt" to "100" in row 1
And I save the current editor

Given I open an editor "1LS1057" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1057"
And I set field "nummer" to "1LS1057R"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "1LS1057R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1057R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1057R"
And I close the current editor

Scenario: Storno EK-Rechnung mit Lagerbewegung und Beistellungen, Verwendung und Projekt, ohne MZs

Given I open an editor "BEIST1" from table "(Part):(Product)" with command "UPDATE" for record "BEIST1"
And I set field "zuplatz" to "F334"
And I save the current editor
Given I open an editor "BEIST2" from table "(Part):(Product)" with command "UPDATE" for record "BEIST2"
And I set field "zuplatz" to "F335"
And I save the current editor
Given I open an editor "BEIST3" from table "(Part):(Product)" with command "UPDATE" for record "BEIST3"
And I set field "zuplatz" to "F336"
And I save the current editor

Given I open an editor "1BE116" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE116"
And I set field "nummer" to "1RE1058"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I press button "offueb" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "NS." in row 2
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge |
    | F334   | kg    | 80     |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F335   | kg    | 20     |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F336   | kg    | 10     |
And I save the current editor
And I switch the current editor to editor "1BE116"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1RE1058" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+1RE1058"
And I set field "nummer" to "1RE1058S"
And I save the current editor

Given I open an editor "1RE1058S" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1RE1058S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1RE1058S"
And I close the current editor

Scenario: Ruecklieferung EK-Rechnung mit Lagerbewegung und Beistellungen, Verwendung und Projekt, ohne MZs

Given I open an editor "BEIST1" from table "(Part):(Product)" with command "UPDATE" for record "BEIST1"
And I set field "zuplatz" to "F337"
And I save the current editor
Given I open an editor "BEIST2" from table "(Part):(Product)" with command "UPDATE" for record "BEIST2"
And I set field "zuplatz" to "F338"
And I save the current editor
Given I open an editor "BEIST3" from table "(Part):(Product)" with command "UPDATE" for record "BEIST3"
And I set field "zuplatz" to "F339"
And I save the current editor

Given I open an editor "1BE117" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE117"
And I set field "nummer" to "1RE1059"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I press button "offueb" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "NS." in row 2
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge |
    | F337   | kg    | 80     |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F338   | kg    | 20     |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | F339   | kg    | 10     |
And I save the current editor
And I switch the current editor to editor "1BE117"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1RE1059" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+1RE1059"
And I set field "nummer" to "1LS1059R"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "1LS1059R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS1059R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1059R"
And I close the current editor

Scenario: Storno EK-Rechnung mit Lagerbewegung und Beistellungen, Verwendung und Projekt, ohne MZs, keine Bestellung

Given I open an editor "BEIST1" from table "(Part):(Product)" with command "UPDATE" for record "BEIST1"
And I set field "zuplatz" to "F340"
And I set field "abplatz" to "F340"
And I save the current editor
Given I open an editor "BEIST2" from table "(Part):(Product)" with command "UPDATE" for record "BEIST2"
And I set field "zuplatz" to "F341"
And I set field "abplatz" to "F341"
And I save the current editor
Given I open an editor "BEIST3" from table "(Part):(Product)" with command "UPDATE" for record "BEIST3"
And I set field "zuplatz" to "F342"
And I set field "abplatz" to "F342"
And I save the current editor

Given I open an editor "1RE1060" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "1RE1060"
And I set field "lief" to "1"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artikel" to "ARTMITBEIST" in row 1
And I set field "mge" to "10" in row 1
And I set field "he" to "Stück" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "NS." in row 2
And I save the current editor

Given I open an editor "1RE1060" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+1RE1060"
And I set field "nummer" to "1RE1060S"
And I save the current editor

Given I open an editor "1RE1060S" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1RE1060S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1RE1060S"
And I close the current editor

Scenario: Ruecklieferung EK-Rechnung mit Lagerbewegung und Beistellungen, Verwendung und Projekt, ohne MZs, keine Bestellung

Given I open an editor "BEIST1" from table "(Part):(Product)" with command "UPDATE" for record "BEIST1"
And I set field "zuplatz" to "F343"
And I set field "abplatz" to "F343"
And I save the current editor
Given I open an editor "BEIST2" from table "(Part):(Product)" with command "UPDATE" for record "BEIST2"
And I set field "zuplatz" to "F344"
And I set field "abplatz" to "F344"
And I save the current editor
Given I open an editor "BEIST3" from table "(Part):(Product)" with command "UPDATE" for record "BEIST3"
And I set field "zuplatz" to "F345"
And I set field "abplatz" to "F345"
And I save the current editor

Given I open an editor "1RE1061" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "1RE1061"
And I set field "lief" to "1"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artikel" to "ARTMITBEIST" in row 1
And I set field "mge" to "10" in row 1
And I set field "he" to "Stück" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "NS." in row 2
And I save the current editor

Given I open an editor "1RE1061" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+1RE1061"
And I set field "nummer" to "1LS1061R"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "1LS1061R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS1061R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1061R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit Beistellungen, Lagerplatzvergabe

Given I open an editor "BEIST1" from table "(Part):(Product)" with command "UPDATE" for record "BEIST1"
And I set field "abplatz" to "F346"
And I set field "zuplatz" to "F346"
And I save the current editor
Given I open an editor "BEIST2" from table "(Part):(Product)" with command "UPDATE" for record "BEIST2"
And I set field "abplatz" to "F347"
And I set field "zuplatz" to "F347"
And I save the current editor
Given I open an editor "BEIST3" from table "(Part):(Product)" with command "UPDATE" for record "BEIST3"
And I set field "abplatz" to "F348"
And I set field "zuplatz" to "F348"
And I save the current editor

Given I open an editor "1LS1062" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "nummer" to "1LS1062"
And I set field "lief" to "1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artikel" to "ARTMITBEIST" in row 1
And I set field "mge" to "10" in row 1
And I set field "platz" to "F1" in row 1
And I set field "verw" to "1BE162_1" in row 1
And I set field "projekt" to "100" in row 1
And I save the current editor

Given I open an editor "1LS1062" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1062"
And I set field "nummer" to "1LS1062R"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge |
    | EXTERN | kg    | -40    |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    |        | kg    | -10    |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    |        | kg    | -5     |
And I save the current editor
And I switch the current editor to editor "1LS1062"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1062R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1062R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1062R"
And I close the current editor

Given I open an editor "1BE163" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE163"
And I set field "nummer" to "1LS1063"
And I set field "lief" to "1"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge |
    | KONSI3 | kg    | 80     |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | KONSI4 | kg    | 20     |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge |
    | KONSI5 | kg    | 10     |
And I save the current editor
And I switch the current editor to editor "1BE163"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1063U" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "nummer" to "1LS1001U"
And I set field "lief" to "1"
And I set field "vom" to "."
And I set field "umplatz" to "KONSI"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artikel" to "ARTMITBEIST" in row 1
And I set field "mge" to "10" in row 1
And I set field "he" to "Stück" in row 1
And I set field "platz" to "F1" in row 1
And I set field "verw" to "1BE163_1" in row 1
And I set field "projekt" to "100" in row 1
And I save the current editor

Given I open an editor "1LS1063" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1063"
And I set field "nummer" to "1LS1063R"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I set field "platz" to "F1" in row 1
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1063R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1063R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1063R"
And I close the current editor

Scenario: Externer Lagerplatz in Beistell-MZs

Given I open an editor "1BE127" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "nummer" to "1BE127"
And I create a new row at the end of the table
And I set field "artex" to "ARTMITBEIST" in row 1
And I set field "mge" to "15" in row 1
And I set field "he" to "Stück" in row 1
And I set field "platz" to "F1" in row 1
And I set field "verw" to "1BE127_1" in row 1
And I set field "projekt" to "100" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge |
    | extern | kg    | 15     |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch  | einh | zuomge |
    | extern2 | kg   | 10     |
And I save the current editor
And I switch the current editor to editor "1BE127"
And I save the current editor

Scenario: Storno EK-Lieferschein mit Beistellungen und Koppelprodukten

Given I open an editor "BEIST1" from table "(Part):(Product)" with command "UPDATE" for record "BEIST1"
And I set field "abplatz" to "F352"
And I set field "zuplatz" to "F352"
And I save the current editor
Given I open an editor "BEIST2" from table "(Part):(Product)" with command "UPDATE" for record "BEIST2"
And I set field "abplatz" to "F353"
And I set field "zuplatz" to "F353"
And I save the current editor
Given I open an editor "BEIST3" from table "(Part):(Product)" with command "UPDATE" for record "BEIST3"
And I set field "abplatz" to "F354"
And I set field "zuplatz" to "F354"
And I save the current editor
Given I open an editor "KOMP1" from table "(Part):(Product)" with command "UPDATE" for record "KOMP1"
And I set field "abplatz" to "F355"
And I set field "zuplatz" to "F355"
And I save the current editor
Given I open an editor "KOMP2" from table "(Part):(Product)" with command "UPDATE" for record "KOMP2"
And I set field "abplatz" to "F356"
And I set field "zuplatz" to "F356"
And I save the current editor
Given I open an editor "KOMP3" from table "(Part):(Product)" with command "UPDATE" for record "KOMP3"
And I set field "abplatz" to "F357"
And I set field "zuplatz" to "F357"
And I save the current editor

Given I open an editor "1BE125" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "nummer" to "1BE125"
And I create a new row at the end of the table
And I set field "artex" to "ARTMITBSKOP" in row 1
And I set field "mge" to "15" in row 1
And I set field "he" to "Stück" in row 1
And I set field "platz" to "F358" in row 1
And I set field "verw" to "1BE164_1" in row 1
And I set field "projekt" to "100" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | einh  | zuomge |
    | kg    | 60     |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | 15     |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | 7,5    |
And I press button "abv" to open a subeditor for "mz4"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | 60     |
And I press button "abv" to open a subeditor for "mz5"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | 15     |
And I press button "abv" to open a subeditor for "mz6"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | 7,5    |
And I save the current editor
And I switch the current editor to editor "1BE125"
And I save the current editor

Given I open an editor "1BE125" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE125"
And I set field "nummer" to "1LS1064"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "1LS1064" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS1064"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1064"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz4"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz5"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz6"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1064"
And I close the current editor

Given I open an editor "1LS1064" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "1LS1064"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1064" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS1064"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1064"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz4"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz5"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz6"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1064"
And I close the current editor

Given I open an editor "1LS1064" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "1LS1064"
And I set field "nummer" to "1LS1064S"
And I save the current editor

Given I open an editor "1LS1064S" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1064S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1064S"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz4"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz5"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz6"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1064S"
And I close the current editor

Scenario: Storno EK-Lieferschein mit Beistellungen und Koppelprodukten, keine Bestellung

Given I open an editor "BEIST1" from table "(Part):(Product)" with command "UPDATE" for record "BEIST1"
And I set field "abplatz" to "F359"
And I set field "zuplatz" to "F359"
And I save the current editor
Given I open an editor "BEIST2" from table "(Part):(Product)" with command "UPDATE" for record "BEIST2"
And I set field "abplatz" to "F360"
And I set field "zuplatz" to "F360"
And I save the current editor
Given I open an editor "BEIST3" from table "(Part):(Product)" with command "UPDATE" for record "BEIST3"
And I set field "abplatz" to "F361"
And I set field "zuplatz" to "F361"
And I save the current editor
Given I open an editor "KOMP1" from table "(Part):(Product)" with command "UPDATE" for record "KOMP1"
And I set field "abplatz" to "F362"
And I set field "zuplatz" to "F362"
And I save the current editor
Given I open an editor "KOMP2" from table "(Part):(Product)" with command "UPDATE" for record "KOMP2"
And I set field "abplatz" to "F363"
And I set field "zuplatz" to "F363"
And I save the current editor
Given I open an editor "KOMP3" from table "(Part):(Product)" with command "UPDATE" for record "KOMP3"
And I set field "abplatz" to "F364"
And I set field "zuplatz" to "F364"
And I save the current editor

Given I open an editor "1LS1065" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "nummer" to "1LS1065"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "ARTMITBSKOP" in row 1
And I set field "mge" to "15" in row 1
And I set field "he" to "Stück" in row 1
And I set field "platz" to "F365" in row 1
And I set field "verw" to "1LS165_1" in row 1
And I set field "projekt" to "100" in row 1
And I set field "ueb" to "ja"
And I save the current editor

# Nachkalkulation starten (damit der endgültige bewertungszustand für den vorgang erzeugt wird)
Given I open an editor "Nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

Given I open an editor "1LS1065" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "1LS1065"
And I set field "nummer" to "1LS1065S"
And I save the current editor

Given I open an editor "1LS1065S" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1065S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1065S"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz4"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz5"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz6"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1065S"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit Beistellungen und Koppelprodukten

Given I open an editor "BEIST1" from table "(Part):(Product)" with command "UPDATE" for record "BEIST1"
And I set field "abplatz" to "F366"
And I set field "zuplatz" to "F366"
And I save the current editor
Given I open an editor "BEIST2" from table "(Part):(Product)" with command "UPDATE" for record "BEIST2"
And I set field "abplatz" to "F367"
And I set field "zuplatz" to "F367"
And I save the current editor
Given I open an editor "BEIST3" from table "(Part):(Product)" with command "UPDATE" for record "BEIST3"
And I set field "abplatz" to "F368"
And I set field "zuplatz" to "F368"
And I save the current editor
Given I open an editor "KOMP1" from table "(Part):(Product)" with command "UPDATE" for record "KOMP1"
And I set field "abplatz" to "F369"
And I set field "zuplatz" to "F369"
And I save the current editor
Given I open an editor "KOMP2" from table "(Part):(Product)" with command "UPDATE" for record "KOMP2"
And I set field "abplatz" to "F370"
And I set field "zuplatz" to "F370"
And I save the current editor
Given I open an editor "KOMP3" from table "(Part):(Product)" with command "UPDATE" for record "KOMP3"
And I set field "abplatz" to "F371"
And I set field "zuplatz" to "F371"
And I save the current editor

Given I open an editor "1BE126" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "nummer" to "1BE126"
And I create a new row at the end of the table
And I set field "artex" to "ARTMITBSKOP" in row 1
And I set field "mge" to "15" in row 1
And I set field "he" to "Stück" in row 1
And I set field "platz" to "F372" in row 1
And I set field "verw" to "1BE166_1" in row 1
And I set field "projekt" to "100" in row 1
And I save the current editor

Given I open an editor "1LS1066" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE126"
And I set field "nummer" to "1LS1066"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | einh  | zuomge |
    | kg    | 60     |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | 15     |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | 7,5    |
And I press button "abv" to open a subeditor for "mz4"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | 60     |
And I press button "abv" to open a subeditor for "mz5"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | 15     |
And I press button "abv" to open a subeditor for "mz6"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | 7,5    |
And I save the current editor
And I switch the current editor to editor "1LS1066"
And I save the current editor

Given I open an editor "1LS1066" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS1066"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1066"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz4"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz5"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz6"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1066"
And I close the current editor

Given I open an editor "1LS1066" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "1LS1066"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1066" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS1066"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1066"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz4"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz5"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz6"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1066"
And I close the current editor

Given I open an editor "1LS1066R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1066"
And I set field "nummer" to "1LS1066R"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I set field "platz" to "F372" in row 1
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | einh  | zuomge |
    | kg    | -60    |
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | -15    |
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | -7,5   |
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz4"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1066R"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1066R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1066R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1066R"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz4"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1066R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit Beistellungen und Koppelprodukten, keine Bestellung

Given I open an editor "BEIST1" from table "(Part):(Product)" with command "UPDATE" for record "BEIST1"
And I set field "abplatz" to "F373"
And I set field "zuplatz" to "F373"
And I save the current editor
Given I open an editor "BEIST2" from table "(Part):(Product)" with command "UPDATE" for record "BEIST2"
And I set field "abplatz" to "F374"
And I set field "zuplatz" to "F374"
And I save the current editor
Given I open an editor "BEIST3" from table "(Part):(Product)" with command "UPDATE" for record "BEIST3"
And I set field "abplatz" to "F375"
And I set field "zuplatz" to "F375"
And I save the current editor
Given I open an editor "KOMP1" from table "(Part):(Product)" with command "UPDATE" for record "KOMP1"
And I set field "abplatz" to "F376"
And I set field "zuplatz" to "F376"
And I save the current editor
Given I open an editor "KOMP2" from table "(Part):(Product)" with command "UPDATE" for record "KOMP2"
And I set field "abplatz" to "F377"
And I set field "zuplatz" to "F377"
And I save the current editor
Given I open an editor "KOMP3" from table "(Part):(Product)" with command "UPDATE" for record "KOMP3"
And I set field "abplatz" to "F378"
And I set field "zuplatz" to "F378"
And I save the current editor

Given I open an editor "1LS1067" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "nummer" to "1LS1067"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "ARTMITBSKOP" in row 1
And I set field "mge" to "15" in row 1
And I set field "he" to "Stück" in row 1
And I set field "platz" to "F379" in row 1
And I set field "verw" to "1LS167_1" in row 1
And I set field "projekt" to "100" in row 1
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1067R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1067"
And I set field "nummer" to "1LS1067R"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I set field "platz" to "F379" in row 1
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | einh  | zuomge |
    | kg    | -60    |
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | -15    |
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | einh  | zuomge |
    | kg    | -7,5   |
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz4"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1067R"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1067R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1067R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1067R"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz4"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1067R"
And I close the current editor

Scenario: Pruefung auf negativen Bestand bei der Ruecklieferung von Abgaengen

Given I open an editor "BEIST1" from table "(Part):(Product)" with command "UPDATE" for record "BEIST1"
And I set field "abplatz" to "F523"
And I set field "zuplatz" to "F524"
And I save the current editor
Given I open an editor "BEIST2" from table "(Part):(Product)" with command "UPDATE" for record "BEIST2"
And I set field "abplatz" to "F523"
And I set field "zuplatz" to "F524"
And I save the current editor
Given I open an editor "BEIST3" from table "(Part):(Product)" with command "UPDATE" for record "BEIST3"
And I set field "abplatz" to "F523"
And I set field "zuplatz" to "F524"
And I save the current editor

Given I open an editor "1LS1068" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "nummer" to "1LS1068"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "ARTMITBEIST" in row 1
And I set field "mge" to "10" in row 1
And I set field "he" to "Stück" in row 1
And I set field "platz" to "F525" in row 1
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1068R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS1068"
And I set field "nummer" to "1LS1068R"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | platz | einh  | zuomge |
    | F524  | Stück | -40    |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | platz | einh  | zuomge |
    | F524  | Stück | -10    |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | platz | einh  | zuomge |
    | F524  | Stück | -5     |
And I save the current editor
And I switch the current editor to editor "1LS1068R"
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "2037"
And I set field "ueb" to "nein"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I delete all rows
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I delete all rows
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I delete all rows
And I save the current editor
And I switch the current editor to editor "1LS1068R"
And I set field "ueb" to "ja"
And I save the current editor

Scenario: Beistellung mit Ausschuss, Mengenberechnung pruefen
# Bestellung anlegen
Given I open an editor "1BE111" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | num4   | 1BE111 |
And I append rows
   | artex       | mge | preis | platz |
   | ARTMITBEIST | 100 | 4     | F110  |
And I save the current editor

Given I open an editor "1BE111" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE111"
And I set field "nummer" to "1LS111"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I set field "verlustmge" to "10" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then field "maxmge" has value "440"
And I close the current editor

# -----------------------------------------------------------------------------
#  U M L A G E R U N G E N   E I N K A U F
# -----------------------------------------------------------------------------

Scenario: Storno EK-Umlagerung (Feld umplatz), mit Bestellung

Given I open an editor "1LS1072U" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+1LS1072U"
And I set field "nummer" to "1LS1072S"
And I save the current editor

Given I open an editor "1LS1072S" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1072S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1072S"
And I close the current editor

Given I open an editor "1BE122" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "1BE122"
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I save the current editor

Given I open an editor "1BE122" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "+1BE122"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1BE122"
And I close the current editor

Scenario: Storno EK-Umlagerung (Feld umplatz), ohne Bestellung

Given I open an editor "1LS1073U" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+1LS1073U"
And I set field "nummer" to "1LS1073S"
And I save the current editor

Given I open an editor "1LS1073S" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1073S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1073S"
And I close the current editor

Scenario: Storno EK-Umlagerung (Beschaffungsart Umlagern), mit Bestellung

Given I open an editor "1BE123" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE123"
And I set field "nummer" to "1LS1074U"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I set field "abplatz" to "F418" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I set field "mzueb" to "nein"
And I delete row at position 1
And I append rows
    | lpsuch | einh  | zuomge | charge |
    | F419   | Stück | 10     | CH201  |
    | F419   | Stück | 5      | CH201  |
And I save the current editor
And I switch the current editor to editor "1BE123"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1074U" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "1LS1074U"
And I set field "nummer" to "1LS1074S"
And I save the current editor

Given I open an editor "1LS1074S" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1074S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1074S"
And I close the current editor

Given I open an editor "1BE123" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "1BE123"
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I save the current editor

Given I open an editor "1BE123" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "+1BE123"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1BE123"
And I close the current editor

Scenario: Storno EK-Umlagerung (Beschaffungsart Umlagern), ohne Bestellung

Given I open an editor "1LS1075" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "nummer" to "1LS1075U"
And I set field "bsart" to "Umlagern"
And I set field "lief" to "1"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "AUFTRAGSBEZ" in row 1
And I set field "mge" to "15" in row 1
And I set field "he" to "Stück" in row 1
And I set field "platz" to "F421" in row 1
And I set field "abplatz" to "F420" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I set field "mzueb" to "nein"
And I delete row at position 1
And I append rows
    | lpsuch | einh  | zuomge | charge | verw     | projekt |
    | F421   | Stück | 6      | CH201  | 1LS175_1 | 100     |
    | F421   | Stück | 7      | CH201  | 1LS175_1 | 100     |
    | F421   | Stück | 2      | CH201  | 1LS175_1 | 100     |
And I save the current editor
And I switch the current editor to editor "1LS1075"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS1075U" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "1LS1075U"
And I set field "nummer" to "1LS1075S"
And I save the current editor

Given I open an editor "1LS1075S" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS1075S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1075S"
And I switch the current editor to editor "1LS1075S"
And I close the current editor

# -----------------------------------------------------------------------------
#  U M L A G E R U N G E N   V E R K A U F
# -----------------------------------------------------------------------------

Scenario: Storno VK-Umlagerung (Feld umplatz), ohne Auftrag

Given I open an editor "1LS1070U" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "+1LS1070U"
And I set field "nummer" to "1LS1070S"
And I save the current editor

Given I open an editor "1LS1070S" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1070S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1070S"
And I close the current editor

Scenario: Storno VK-Umlagerung (Feld umplatz), mit Auftrag

Given I open an editor "1LS1071U" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "+1LS1071U"
And I set field "nummer" to "1LS1071S"
And I save the current editor

Given I open an editor "1LS1071S" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1071S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1071S"
And I close the current editor

Given I open an editor "1AU122" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "1AU122"
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I save the current editor

Given I open an editor "1AU122" from table "(Sales):(SalesOrder)" with command "VIEW" for record "+1AU122"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1AU122"
And I close the current editor

Scenario: Storno VK-Umlagerung mit Setartikel (Feld umplatz), ohne Auftrag

Given I open an editor "KOMP1" from table "(Part):(Product)" with command "UPDATE" for record "KOMP1"
And I set field "abplatz" to "F248"
And I set field "zuplatz" to "F248"
And I save the current editor
Given I open an editor "KOMP2" from table "(Part):(Product)" with command "UPDATE" for record "KOMP2"
And I set field "abplatz" to "F249"
And I set field "zuplatz" to "F249"
And I save the current editor
Given I open an editor "KOMP3" from table "(Part):(Product)" with command "UPDATE" for record "KOMP3"
And I set field "abplatz" to "F250"
And I set field "zuplatz" to "F250"
And I save the current editor

Given I open an editor "1LS1027U" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "nummer" to "1LS1027U"
And I set field "kunde" to "1"
And I set field "umplatz" to "F251"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artikel" to "SETART" in row 1
And I set field "mge" to "10" in row 1
And I set field "he" to "Stück" in row 1
And I set field "verw" to "1LS127_1" in row 1
And I set field "projekt" to "100" in row 1
And I save the current editor

Given I open an editor "1LS1027U" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "+1LS1027U"
And I set field "nummer" to "1LS1027S"
And I save the current editor

Given I open an editor "1LS1027S" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1027S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1027S"
And I close the current editor

Scenario: Storno VK-Umlagerung mit Setartikel (Feld umplatz), mit Auftrag

Given I open an editor "KOMP1" from table "(Part):(Product)" with command "UPDATE" for record "KOMP1"
And I set field "abplatz" to "F252"
And I set field "zuplatz" to "F252"
And I save the current editor
Given I open an editor "KOMP2" from table "(Part):(Product)" with command "UPDATE" for record "KOMP2"
And I set field "abplatz" to "F253"
And I set field "zuplatz" to "F253"
And I save the current editor
Given I open an editor "KOMP3" from table "(Part):(Product)" with command "UPDATE" for record "KOMP3"
And I set field "abplatz" to "F254"
And I set field "zuplatz" to "F254"
And I save the current editor

Given I open an editor "1AU123" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU123"
And I set field "nummer" to "1LS1028U"
And I set field "kunde" to "1"
And I set field "umplatz" to "F255"
And I press button "offueb" in row 1
And I press button "mzabsm" to open a subeditor for "mz" in row 1
And I append rows
    | lpsuch | einh  | zuomge | charge |
    | F252   | Stück | 40     | CH210  |
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge | charge |
    | F253   | Stück | 10     | CH213  |
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
And I append rows
    | lpsuch | einh  | zuomge | charge |
    | F254   | Stück | 5      | CH216  |
And I save the current editor
And I switch the current editor to editor "1AU123"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS10278U" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "+1LS1028U"
And I set field "nummer" to "1LS1028S"
And I save the current editor

Given I open an editor "1LS1028S" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS1028S"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS1028S"
And I close the current editor

Given I open an editor "1AU123" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "1AU123"
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I save the current editor

Given I open an editor "1AU123" from table "(Sales):(SalesOrder)" with command "VIEW" for record "+1AU123"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "mzabsm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz2"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I press button "abv" to open a subeditor for "mz3"
And I close the current editor
And I switch the current editor to editor "mz"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_mz.out"
And I close the current editor
And I switch the current editor to editor "1AU123"
And I close the current editor
