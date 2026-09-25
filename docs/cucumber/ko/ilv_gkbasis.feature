@persistent
Feature: ILV mit Hauptkostenstelle, die eigene Gemeinkosten in Basis zur Errechnung des GKZS fliessen lässt
Background:
                              
# *****************************************************************************
#  Name             : ilv_gkbasis.feature                 
#  Autor            : Silvia Warth
#  Verantwortlich   : sih
#  Kontrolle        :    
#  Funktion         : REWE-4043 (Auslöser RDSU-2420)
#                     Test der ILV, wenn eine Hauptkostenstelle sich selbst als Gemeinkostenbasis verwendet.              
#
# *****************************************************************************

Scenario: 01 Neuanlage Kostenarten
Given I open an editor "kostenart" from table "(CostType):(CostType)" with command "NEW" for record ""
And I set field "nummer" to "99999995"
And I set field "such" to "STATFK"
And I set field "namebspr" to "statistische Fertigungskosten"
And I set field "prim" to "ja"
And I set field "stat" to "ja"
And I save the current editor
And I close the current editor

Given I open an editor "kostenart" from table "(CostType):(CostType)" with command "NEW" for record ""
And I set field "nummer" to "95730"
And I set field "such" to "ENT"
And I set field "namebspr" to "Belastung Hauptkostenstelle"
And I set field "prim" to "nein"
And I set field "stat" to "ja"
And I save the current editor
And I close the current editor

Scenario: 02 Neuanlage Konten
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "95050"
And I set field "nummer" to "95730"
And I set field "zkoart" to "95730" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "99800"
And I set field "nummer" to "99123"
And I set field "such" to "STATFK"
And I set field "namebspr" to "statistische Fertigungskosten"
And I set field "zkoart" to "99999995" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "UPDATE" for record "99900"
And I set field "kost" to "ja"
And I create a new row at the end of the table
And I set field "zkoart" to "99999999" in row 1
And I save the current editor
And I close the current editor

Scenario: 03 Neuanlage Hauptkostenstelle
Given I open an editor "kostenstelle" from table "(Account):(CostCenter)" with command "NEW" for record ""
And I set field "nummer" to "7530"
And I set field "such" to "KSFERT"
And I set field "namebspr" to "Fertigungskosten"
And I set field "bebuchbar" to "ja"
And I set field "hilfsks" to "nein"
And I set field "umlzu" to "95010"
And I set field "umlab" to "95730"
And I create a new row at the end of the table
And I set field "ekbasis" to "99999995" in row 1 
And I save the current editor 
And I close the current editor

Scenario: 04 Gemeinkosten auf Kostenstelle 7530 buchen
Given I open an editor "buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "gk"
And I set field "budat" to "10.01."
And I create a new row at the end of the table
And I set field "konto" to "50000" in row !lastRow
And I set field "ewsbetr" to "50" in row !lastRow
And I set field "kstelle" to "7530" in row !lastRow
And I create a new row at the end of the table
And I set field "konto" to "10000" in row !lastRow
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor

Scenario: 05 statistische Fertigungseinzelkosten buchen
Given I open an editor "StatBuchung" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
And I set field "such" to "FK"
And I set field "budat" to "10.01."
And I set field "text" to "statistische Fertigungseinzelkosten"
And I create a new row at the end of the table
And I set field "konto" to "99123" in row 1
And I set field "sbetrag" to "6000" in row 1
And I set field "kstelle" to "201100" in row 1
#
And I create a new row at the end of the table
And I set field "konto" to "99123" in row 2
And I set field "sbetrag" to "8000" in row 2
And I set field "kstelle" to "201200" in row 2
#
And I create a new row at the end of the table
And I set field "konto" to "99900" in row 3
And I set field "kstelle" to "7530" in row 3
And I respond with answer "ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

Scenario: 06 ILV ausführen
Given I open an editor "ilv" for tip command "ilv" and arguments ""
And I set field "monat" to "1"
And I set field "vorschau" to "ja"
And I set field "datart" to "Ist"
# And I set field "buumfang" to "ILV"
And I press button "bstart"
And I save the current editor

Scenario: 07 Ergebnis der ILV anzeigen: Insbesondere GKZS der Haupkostenstelle 7530
Given I open an editor "kostenstelle" from table "(Account):(CostCenter)" with command "VIEW" for record "7530"
And I press button "izuschlag" to open a subeditor for "Ist-Gemeinkostenzuschlagssatz" in row 0
Then field "s1" has value "-99.64"
And I close the current editor
And I switch the current editor to editor "kostenstelle"
#
And I press button "ipr" to open a subeditor for "Ist-Gemeinkostenzuschlagssatz" in row 0
Then field "s1" has value "-13950.00"
And I close the current editor
And I switch the current editor to editor "kostenstelle"
#
And I press button "ige" to open a subeditor for "Ist-Gemeinkostenzuschlagssatz" in row 0
Then field "s1" has value "-13950.00"
And I close the current editor
And I switch the current editor to editor "kostenstelle"
And I close the current editor

Scenario: 08 Ergebnis der ILV anzeigen: Entlastungsbuchung Kst 7530 und Keine Differenzbuchung (Differenzen von Haupt-Kostenstellen ausbuchen)
Given I open an editor "statBuchung" from table "(Entry):(StatisticalEntry)" with command "VIEW" for search criteria "$,,monat=1;ursache=Leistungsverrechnung Haupt-Kostenstelle;text=Entlastung Haupt-Kostenstelle     7530;@richtung=rückwärts;@maxtreffer=1"
Then field "konto" has value "95010" in row 1
Then field "kstelle" has value "7530" in row 1
Then field "hbetrag" has value "-13950.00" in row 1
And I close the current editor

Then opening an editor from table "(Entry):(StatisticalEntry)" with command "VIEW" for search criteria "$,,monat=1;ursache=Leistungsverrechnung Haupt-Kostenstelle;text=Differenzen aus der ILV (Ist);@richtung=rückwärts;@maxtreffer=1" throws the exception "1582"

Scenario: 09 Eintrag Kostenstelle 7530 in die Gemeinkostenbasis der Kostenstelle 7530 (aus RDSU-2420: Wie kommt der Zuschlagssatz zustande?)
Given I open an editor "kostenstelle" from table "(Account):(CostCenter)" with command "UPDATE" for record "7530"
And I set field "gkbasis" to "7530" in row 1 
And I save the current editor 
And I close the current editor

Scenario: 10 ILV ausführen
Given I open an editor "ilv" for tip command "ilv" and arguments ""
And I set field "monat" to "1"
And I set field "vorschau" to "ja"
And I set field "datart" to "Ist"
# And I set field "buumfang" to "ILV"
And I press button "bstart"
And I save the current editor

Scenario: 11 Ergebnis der ILV anzeigen: Insbesondere GKZS der Haupkostenstelle 7530, nachdem die GK-Basis in der Kostenstelle eingetragen wurde
Given I open an editor "kostenstelle" from table "(Account):(CostCenter)" with command "VIEW" for record "7530"
And I press button "izuschlag" to open a subeditor for "Ist-Gemeinkostenzuschlagssatz" in row 0
Then field "s1" has value "-27900.00"
And I close the current editor
And I switch the current editor to editor "kostenstelle"
#
And I press button "ipr" to open a subeditor for "Ist-Gemeinkostenzuschlagssatz" in row 0
Then field "s1" has value "-13950.00"
And I close the current editor
And I switch the current editor to editor "kostenstelle"
#
And I press button "ige" to open a subeditor for "Ist-Gemeinkostenzuschlagssatz" in row 0
Then field "s1" has value "-13950.00"
And I close the current editor
And I switch the current editor to editor "kostenstelle"
#
And I switch the current editor to editor "kostenstelle"
And I close the current editor

Scenario: 12 Ergebnis der ILV anzeigen: Entlastungsbuchung Kst 7530 und Keine Differenzbuchung (Differenzen von Haupt-Kostenstellen ausbuchen)
Given I open an editor "statBuchung" from table "(Entry):(StatisticalEntry)" with command "VIEW" for search criteria "$,,monat=1;ursache=Leistungsverrechnung Haupt-Kostenstelle;text=Entlastung Haupt-Kostenstelle     7530;@richtung=rückwärts;@maxtreffer=1"
Then field "konto" has value "95010" in row 1
Then field "kstelle" has value "7530" in row 1
Then field "hbetrag" has value "-3906000.00" in row 1
And I close the current editor

Given I open an editor "DiffBuchung" from table "(Entry):(StatisticalEntry)" with command "VIEW" for search criteria "$,,monat=1;ursache=Leistungsverrechnung Haupt-Kostenstelle;text=Differenzen aus der ILV (Ist);@richtung=rückwärts;@maxtreffer=1"
Then field "konto" has value "99800" in row 1
Then field "kstelle" has value "7530" in row 1
Then field "hbetrag" has value "3892050.00" in row 1
And I close the current editor





