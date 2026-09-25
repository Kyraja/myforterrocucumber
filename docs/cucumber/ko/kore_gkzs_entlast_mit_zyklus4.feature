@persistent
Feature: BW2-1823
Background:
Given I set the fake date to "30.08.2002"

# *****************************************************************************
#  Name             : kore_gkzs_entlast_mit_zyklus4.feature
#  Autor            : Silvia Warth
#  Verantwortlich   : sih
#  Kontrolle        : uo
#  Funktion         : Test der Hauptkostenstellen mit GK-Basis vor der ILV:
#                     Bei Hauptkostenstellen mit Eintrag in GK-Basis muss sichergestellt sein, dass zunächst
#                     die Hauptkostenstellen, die im Feld "Gemeinkostenbasis" einer Hauptkostenstelle eingetragen sind, entlastet werden, 
#                     da diese benötigt werden zur Entlastung dieser Hauptkostenstelle, in deren Tabellenfeld "Gemeinkostenbasis" sie eingetragen sind.
#                     Durch diese Art der Definition
#                     Kst A hat Kst B als GK-Basis (d.h. Kostenstelle B muss vor Kst A entlastet werden)
#                     Kst B hat Kst C als GK-Basis (d.h. Kostenstelle C muss vor Kst B entlastet werden)
#                     Kst C hat Kst A als GK-Basis (d.h. Kostenstelle A muss vor Kst C entlastet werden)
#                     entsteht ein Zyklus.
#                    
#                     Im Fehlerfall bei bestehendem Zyklus:
#                     ERROR_MESSAGE Cat=FATALERROR No=1547: falsches Ergebnis in der ILV
#
# *****************************************************************************

Scenario: 01 Kostenarten anlegen 
Given I open an editor "ko" from table "(CostType):(CostType)" with command "COPY" for record "95010"
And I set field "nummer" to "95001"
# And I set field "bem" to "Entlastung Kst"
And I save the current editor

Given I open an editor "ko" from table "(CostType):(CostType)" with command "COPY" for record "95020"
And I set field "nummer" to "95009"
# And I set field "bem" to ""
And I save the current editor

Given I open an editor "ko" from table "(CostType):(CostType)" with command "COPY" for record "95020"
And I set field "nummer" to "95011"
# And I set field "bem" to ""
And I save the current editor

Given I open an editor "ko" from table "(CostType):(CostType)" with command "COPY" for record "95011"
And I set field "nummer" to "95012"
And I save the current editor

Given I open an editor "ko" from table "(CostType):(CostType)" with command "COPY" for record "95011"
And I set field "nummer" to "95013"
And I save the current editor

Given I open an editor "ko" from table "(CostType):(CostType)" with command "COPY" for record "95011"
And I set field "nummer" to "95014"
And I save the current editor

Scenario: 02 Konten anlagen
Given I open an editor "ko" from table "(Account):(Account)" with command "COPY" for record "95010"
And I set field "nummer" to "95001"
And I set field "bem" to "Belastung Kst 201, 202, 203, 204"
And I create a new row at the end of the table
And I set field "zkoart" to "95001" in row 1
And I save the current editor

Given I open an editor "ko" from table "(Account):(Account)" with command "COPY" for record "95020"
And I set field "nummer" to "95009"
And I set field "bem" to ""
And I create a new row at the end of the table
And I set field "zkoart" to "95009" in row 1
And I save the current editor


Given I open an editor "ko" from table "(Account):(Account)" with command "COPY" for record "95020"
And I set field "nummer" to "95011"
And I set field "bem" to ""
And I create a new row at the end of the table
And I set field "zkoart" to "95011" in row 1
And I save the current editor

Given I open an editor "ko" from table "(Account):(Account)" with command "COPY" for record "95011"
And I set field "nummer" to "95012"
And I set field "bem" to ""
And I create a new row at the end of the table
And I set field "zkoart" to "95012" in row 1
And I save the current editor

Given I open an editor "ko" from table "(Account):(Account)" with command "COPY" for record "95011"
And I set field "nummer" to "95013"
And I set field "bem" to ""
And I create a new row at the end of the table
And I set field "zkoart" to "95013" in row 1
And I save the current editor

Given I open an editor "ko" from table "(Account):(Account)" with command "COPY" for record "95011"
And I set field "nummer" to "95014"
And I set field "bem" to ""
And I create a new row at the end of the table
And I set field "zkoart" to "95014" in row 1
And I save the current editor

Scenario: 03 Hauptkostenstellen anlegen
Given I open an editor "ko" from table "(Account):(CostCenter)" with command "COPY" for record "101"
And I set field "nummer" to "106"
And I set field "umlzu" to "95001"
And I set field "umlab" to "95011"
And I save the current editor

Given I open an editor "ko" from table "(Account):(CostCenter)" with command "COPY" for record "101"
And I set field "nummer" to "105"
And I set field "umlzu" to "95001"
And I set field "umlab" to "95012"
And I create a new row at the end of the table
And I set field "ekbasis" to "50000" in row 1
And I set field "gkbasis" to "106" in row 1
And I create a new row at the end of the table
And I set field "ekbasis" to "95011" in row 2
And I save the current editor

Given I open an editor "ko" from table "(Account):(CostCenter)" with command "UPDATE" for record "106"
And I create a new row at the end of the table
And I set field "ekbasis" to "50000" in row 1
And I set field "gkbasis" to "105" in row 1
And I create a new row at the end of the table
And I set field "ekbasis" to "95009" in row 2
And I create a new row at the end of the table
And I set field "ekbasis" to "95012" in row 3
And I save the current editor

Given I open an editor "ko" from table "(Account):(CostCenter)" with command "COPY" for record "101"
And I set field "nummer" to "104"
And I set field "umlzu" to "95001"
And I set field "umlab" to "95013"
And I create a new row at the end of the table
And I set field "ekbasis" to "50000" in row 1
And I save the current editor

Given I open an editor "ko" from table "(Account):(CostCenter)" with command "COPY" for record "101"
And I set field "nummer" to "103"
And I set field "umlzu" to "95001"
And I set field "umlab" to "95014"
And I create a new row at the end of the table
And I set field "ekbasis" to "50000" in row 1
And I set field "gkbasis" to "104" in row 1
And I create a new row at the end of the table
And I set field "ekbasis" to "95013" in row 2
And I save the current editor

Given I open an editor "ko" from table "(Account):(CostCenter)" with command "COPY" for record "101"
And I set field "nummer" to "102"
And I set field "umlzu" to "95001"
And I set field "umlab" to "95009"
And I create a new row at the end of the table
And I set field "ekbasis" to "50000" in row 1
And I set field "gkbasis" to "103" in row 1
And I create a new row at the end of the table
And I set field "ekbasis" to "95014" in row 2
And I save the current editor

Given I open an editor "ko" from table "(Account):(CostCenter)" with command "UPDATE" for record "104"
And I create a new row at the end of the table
And I set field "ekbasis" to "50000" in row 1
And I set field "gkbasis" to "102" in row 1
And I create a new row at the end of the table
And I set field "ekbasis" to "95009" in row 2
And I save the current editor

Given I open an editor "ko" from table "(Account):(CostCenter)" with command "UPDATE" for record "106"
And I create a new row at the end of the table
And I set field "gkbasis" to "102" in row 2
And I save the current editor

Scenario: 04 ILV ausführen
Given I open an editor "Umlage" for tip command "ilv" and arguments ""
And I set field "monat" to "1"
And I set field "gjahr" to "04"
And I set field "vorschau" to "ja"
And I set field "datart" to "Ist"
And I press button "bstart"
And I save the current editor


