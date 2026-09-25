# *****************************************************************************
#  Name           : ilv_haupt_kst_nur_ktr_umlagen.feature
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Test der ILV und des Ausbuchens der Differenzen auf Hauptkostenstellen unter der Bedingung, daß die
#                   Hauptkostenstellen ausschließlich nach Kostenträgerjahres- und/oder -monatsumlagen entlastet werden 
#                   und keine Gemeinkostenzuschlagssätze besitzen.
#
# *****************************************************************************
@persistent
Feature: BW2-1755
Background:
Given I set the fake date to "05.01.02"


Scenario: 01 Kostenrechnungskonfigutation entsprechend einstellen
Given I open an editor "k" from table "(CostType):(CostAccountingConfig)" with command "UPDATE" for record "korekonf"
And I set field "vsround" to "ja"
And I set field "ilvauto" to "ja"
And I set field "gekobuch" to "ja"
And I set field "gekoindi" to "ja"
And I save the current editor

Scenario: 02 neue Haupt-Kst 8108 anlegen, Umlagekonten eintragen
Given I open an editor "ks" from table "(Account):(CostCenter)" with command "NEW" for record ""
And I set field "nummer" to "8108"
And I set field "such" to "KS8108"
And I set field "namebspr" to "Kostenstelle 8108"
And I set field "hilfsks" to "nein"
And I set field "umlzu" to "91001"
And I set field "umlab" to "91000"
And I save the current editor

Scenario: 03 Kostenstellenumlage 100 erweitern um Kst 8108 und auch Daten für Geschäftsmonat 2 eintragen
Given I open an editor "ksum11" from table "(Assessment):(CostCenterAssessment)" with command "UPDATE" for record "100"
And  I create a new row at the end of the table
And I set field "kszu" to "8108" in row 2
And I save the current editor

Given I open an editor "ksuml3" from table "(Assessment):(CostCenterAssessment)" with command "UPDATE" for record "100"
And I press button "kszuist" to open a subeditor for "Ist-VKZ" in row 2 with dialog "2011" and answer "Ja"
And I set field "s1" to "40"
And I set field "s2" to "40"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "ksuml3"
And I close the current editor

# wenn folgende Aktion vor voriger Aktion steht, scheitert sie, warum?
Given I open an editor "ksuml2" from table "(Assessment):(CostCenterAssessment)" with command "UPDATE" for record "100"
And I press button "kszuist" to open a subeditor for "Ist-VKZ" in row 1 
And I set field "s1" to "60"
And I set field "s2" to "60"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "ksuml2"
And I close the current editor

Scenario: 04 Bezugsgröße 500 erweitern um Werte für Monat 2
Given I open an editor "bg500" from table "(ActivityBase):(ActivityBase)" with command "UPDATE" for record "500"
And I press button "ivkz" to open a subeditor for "Ist-Vkz" in row 0 
And I set field "s2" to "100"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "bg500"

Scenario: 05 in Haupt-Kst 8107 Einzelkostenbasis entfernen, damit kein Gemeinkostenzuschlagssatz errechnet werden kann und individuellen Zuschlagssatz entfernen
Given I open an editor "ks" from table "(Account):(CostCenter)" with command "UPDATE" for record "8107"
And I set field "ekbasis" to "" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "ksz" from table "(Account):(CostCenter)" with command "UPDATE" for record "8107"
And I press button "iizuschlag" to open a subeditor for "Individueller Zuschlagssatz" in row 0
And I set field "s1" to "0"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "ksz"

Scenario: 07a Kosten auf 8107 und 8108 in Monat 1 und 2
Given I open an editor "Buchung1" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "budat" to "10.01.02"
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 1
And I set field "ewhbetr" to "44356.89" in row 1
And I set field "kstelle" to "8107" in row 1
#
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 2
And I set field "ewhbetr" to "13086.73" in row 2
And I set field "kstelle" to "8108" in row 2
#
And I create a new row at the end of the table
And I set field "konto" to "11400" in row 3
And I respond with answer "ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

Given I open an editor "Buchung1" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "budat" to "10.02.02"
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 1
And I set field "ewhbetr" to "6789.89" in row 1
And I set field "kstelle" to "8107" in row 1
#
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 2
And I set field "ewhbetr" to "34875.66" in row 2
And I set field "kstelle" to "8108" in row 2
#
And I create a new row at the end of the table
And I set field "konto" to "11400" in row 3
And I respond with answer "ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

Scenario: 08 Kosten auf Kst 8105 in Monat 2 buchen
Given I open an editor "Buchung1" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "budat" to "10.02.02"
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 1
And I set field "ewhbetr" to "39754.54" in row 1
And I set field "kstelle" to "8105" in row 1
And I create a new row at the end of the table
And I set field "konto" to "11400" in row 2
And I respond with answer "ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

Scenario: 08a Einzelkosten Monat 2 (Skript wird mit Datum 2.01.02 augerufen), damit auch bei der ILV für Monat 2 due Haupt-Kst 8108 Ktr entlastet wird
Given I open an editor "Buchung6" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "budat" to "10.01.02"
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 1
And I set field "ewsbetr" to "1557.43" in row 1
And I set field "kstelle" to "12840925" in row 1
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 2
And I set field "ewsbetr" to "3005.17" in row 2
And I set field "kstelle" to "12840922" in row 2
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 3
And I set field "ewsbetr" to "763.71" in row 3
And I set field "kstelle" to "12840924" in row 3
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 4
And I set field "ewsbetr" to "707.21" in row 4
And I set field "kstelle" to "12840926" in row 4
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 5
And I set field "ewsbetr" to "125.30" in row 5
And I set field "kstelle" to "12840927" in row 5
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 6
And I set field "ewsbetr" to "1017.70" in row 6
And I set field "kstelle" to "12840902" in row 6
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 7
And I set field "ewsbetr" to "167.87" in row 7
And I set field "kstelle" to "12840903" in row 7
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 8
And I set field "ewsbetr" to "16616.40" in row 8
And I set field "kstelle" to "12840906" in row 8
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 9
And I set field "ewsbetr" to "85.38" in row 9
And I set field "kstelle" to "12840905" in row 9
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 10
And I set field "ewsbetr" to "10642.29" in row 10
And I set field "kstelle" to "12840901" in row 10
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 11
And I set field "ewsbetr" to "938.52" in row 11
And I set field "kstelle" to "19110A" in row 11
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 12
And I set field "ewsbetr" to "1506.24" in row 12
And I set field "kstelle" to "18713C15" in row 12
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 13
And I set field "ewsbetr" to "27.31" in row 13
And I set field "kstelle" to "17840601" in row 13
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 14
And I set field "ewsbetr" to "3373.20" in row 14
And I set field "kstelle" to "17840602" in row 14
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 15
And I set field "ewsbetr" to "7504.42" in row 15
And I set field "kstelle" to "12840800" in row 15
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 16
And I set field "ewsbetr" to "499.64" in row 16
And I set field "kstelle" to "999VUE1" in row 16
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 17
And I set field "ewsbetr" to "429.36" in row 17
And I set field "kstelle" to "12840710" in row 17
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 18
And I set field "ewsbetr" to "2.67" in row 18
And I set field "kstelle" to "18014X" in row 18
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 19
And I set field "ewsbetr" to "10.67" in row 19
And I set field "kstelle" to "17768X" in row 19
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 20
And I set field "ewsbetr" to "2.67" in row 20
And I set field "kstelle" to "17954X" in row 20
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 21
And I set field "ewsbetr" to "12.94" in row 21
And I set field "kstelle" to "17619X" in row 21
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 22
And I set field "ewsbetr" to "2.67" in row 22
And I set field "kstelle" to "18087X" in row 22
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 23
And I set field "ewsbetr" to "2.67" in row 23
And I set field "kstelle" to "18126X" in row 23
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 24
And I set field "ewsbetr" to "2.67" in row 24
And I set field "kstelle" to "15788X" in row 24
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 25
And I set field "ewsbetr" to "77.01" in row 25
And I set field "kstelle" to "17994X" in row 25
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 26
And I set field "ewsbetr" to "2.67" in row 26
And I set field "kstelle" to "18243X" in row 26
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 27
And I set field "ewsbetr" to "199.27" in row 27
And I set field "kstelle" to "16601X" in row 27
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 28
And I set field "ewsbetr" to "840" in row 28
And I set field "kstelle" to "17065X" in row 28
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 29
And I set field "ewsbetr" to "2.67" in row 29
And I set field "kstelle" to "16116X" in row 29
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 30
And I set field "ewsbetr" to "20564.50" in row 30
And I set field "kstelle" to "17931A" in row 30
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 31
And I set field "ewsbetr" to "29957.46" in row 31
And I set field "kstelle" to "17931B" in row 31
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 32
And I set field "ewsbetr" to "2.67" in row 32
And I set field "kstelle" to "18392X" in row 32
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 33
And I set field "ewsbetr" to "19214.71" in row 33
And I set field "kstelle" to "17419B" in row 33
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 34
And I set field "ewsbetr" to "19015.73" in row 34
And I set field "kstelle" to "17419C" in row 34
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 35
And I set field "ewsbetr" to "10624" in row 35
And I set field "kstelle" to "17419D" in row 35
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 36
And I set field "ewsbetr" to "10370.51" in row 36
And I set field "kstelle" to "17419E" in row 36
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 37
And I set field "ewsbetr" to "9791.80" in row 37
And I set field "kstelle" to "18316B" in row 37
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 38
And I set field "ewsbetr" to "1763.85" in row 38
And I set field "kstelle" to "1831602" in row 38
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 39
And I set field "ewsbetr" to "727.72" in row 39
And I set field "kstelle" to "18424A" in row 39
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 40
And I set field "ewsbetr" to "616.58" in row 40
And I set field "kstelle" to "18601A" in row 40
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 41
And I set field "ewsbetr" to "5.30" in row 41
And I set field "kstelle" to "18601B" in row 41
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 42
And I set field "ewsbetr" to "134463.45" in row 42
And I set field "kstelle" to "18252A" in row 42
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 43
And I set field "ewsbetr" to "12034.67" in row 43
And I set field "kstelle" to "18591A" in row 43
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 44
And I set field "ewsbetr" to "9343.57" in row 44
And I set field "kstelle" to "18591B" in row 44
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 45
And I set field "ewsbetr" to "8688.95" in row 45
And I set field "kstelle" to "18591C" in row 45
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 46
And I set field "ewsbetr" to "22345" in row 46
And I set field "kstelle" to "17836A" in row 46
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 47
And I set field "ewsbetr" to "23370" in row 47
And I set field "kstelle" to "17836B" in row 47
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 48
And I set field "ewsbetr" to "1.77" in row 48
And I set field "kstelle" to "18522A" in row 48
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 49
And I set field "ewsbetr" to "58" in row 49
And I set field "kstelle" to "17929X" in row 49
#
And I create a new row at the end of the table
And I set field "konto" to "11400" in row 50
And I respond with answer "ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor





Scenario: 07 Kostenträgerjahresumlage für Kst 8108
Given I open an editor "um1000" from table "(Assessment):(CostObjectAnnualAssessment)" with command "NEW" for record ""
And I set field "nummer" to "1000"
And I set field "such" to "um"
And I set field "ksab" to "8108"
And I create a new row at the end of the table
And I set field "kszu" to "12840924" in row 1
And I set field "istmoproz" to "0.1" in row 1
And I set field "planmoproz" to "0.1" in row 1
#
And I create a new row at the end of the table
And I set field "kszu" to "12840925" in row 2
And I set field "istmoproz" to "0.6" in row 2
And I set field "planmoproz" to "0.6" in row 2
#
And I create a new row at the end of the table
And I set field "kszu" to "12840922" in row 3
And I set field "istmoproz" to "3.7" in row 3
And I set field "planmoproz" to "3.7" in row 3
#
And I create a new row at the end of the table
And I set field "kszu" to "12840926" in row 4
And I set field "istmoproz" to "17.5" in row 4
And I set field "planmoproz" to "17.5" in row 4
#
And I create a new row at the end of the table
And I set field "kszu" to "12840927" in row 5
And I set field "istmoproz" to "5.5" in row 5
And I set field "planmoproz" to "5.5" in row 5
#
And I create a new row at the end of the table
And I set field "kszu" to "12840902" in row 6
And I set field "istmoproz" to "3.8" in row 6
And I set field "planmoproz" to "3.8" in row 6
#
And I create a new row at the end of the table
And I set field "kszu" to "12840903" in row 7
And I set field "istmoproz" to "16.7" in row 7
And I set field "planmoproz" to "16.7" in row 7
#
And I create a new row at the end of the table
And I set field "kszu" to "12840906" in row 8
And I set field "istmoproz" to "13.4" in row 8
And I set field "planmoproz" to "13.4" in row 8
#
And I create a new row at the end of the table
And I set field "kszu" to "12840905" in row 9
And I set field "istmoproz" to "4.3" in row 9
And I set field "planmoproz" to "4.3" in row 9
#
And I create a new row at the end of the table
And I set field "kszu" to "12840901" in row 10
And I set field "istmoproz" to "1.8" in row 10
And I set field "planmoproz" to "1.8" in row 10
#
And I create a new row at the end of the table
And I set field "kszu" to "17840601" in row 11
And I set field "istmoproz" to "12.5" in row 11
And I set field "planmoproz" to "12.5" in row 11
#
And I create a new row at the end of the table
And I set field "kszu" to "17840602" in row 12
And I set field "istmoproz" to "10.9" in row 12
And I set field "planmoproz" to "10.9" in row 12
#
And I create a new row at the end of the table
And I set field "kszu" to "12840800" in row 13
And I set field "istmoproz" to "9.2" in row 13
And I set field "planmoproz" to "9.2" in row 13
#
And I save the current editor
And I close the current editor

Scenario: 09 ILV für Monat 1 (ohne Entlastung Haupt-Kst, damit erst gesamte Istkosten der Haupt-Kst zur Verfügung stehen bei der Anlage der KTR-Umlage)
# Flag 260, damit Protokolldaei KSPROT erzeugt wird, zeigt Hilfs- und Hauptkosenstellen, bei denen Differenzen ausgebucht wurden
Given I enable the flag 260
Given I open an editor "Umlage" for tip command "ilv" and arguments ""
And I set field "monat" to "1"
And I set field "vorschau" to "ja"
And I set field "datart" to "Ist"
And I set field "buumfang" to "ILV"
And I press button "bstart"
And I save the current editor

Scenario: 06 Kostenträgermonatsumlage Monat 1 für Kst 8107
Given I open an editor "um20" from table "(Assessment):(CostObjectMonthlyAssessment)" with command "NEW" for record ""
And I set field "nummer" to "20"
And I set field "such" to "um"
And I set field "ksab" to "8107"
And I set field "gmon" to "1"
And I create a new row at the end of the table
And I set field "kszu" to "12840924" in row 1
And I set field "istmoproz" to "60" in row 1
And I set field "planmoproz" to "60" in row 1
And I create a new row at the end of the table
And I set field "kszu" to "12840925" in row 2
And I set field "istmoproz" to "40" in row 2
And I set field "planmoproz" to "40" in row 2
And I save the current editor
Then field "absistrest" has value "0.00"
And I close the current editor

Scenario: 09a ILV für Monat 1 (mit Entlastung Haupt-Kst)
Given I open an editor "Umlage" for tip command "ilv" and arguments ""
And I set field "monat" to "1"
And I set field "vorschau" to "ja"
And I set field "datart" to "Ist"
And I set field "buumfang" to "ILV und Entlastung Hauptkostenstellen"
And I press button "bstart"
And I save the current editor

Scenario: 10 ILV für Monat 2 
Given I open an editor "Umlage" for tip command "ilv" and arguments ""
And I set field "monat" to "2"
And I set field "vorschau" to "ja"
And I set field "datart" to "Ist"
And I set field "buumfang" to "ILV"
And I press button "bstart"
And I save the current editor

Given I open an editor "um10" from table "(Assessment):(CostObjectMonthlyAssessment)" with command "UPDATE" for record "10"
And I press button "istanteil" 
And I save the current editor
Then field "absistrest" has value "0.00"
And I close the current editor

Given I open an editor "um10" from table "(Assessment):(CostObjectMonthlyAssessment)" with command "UPDATE" for record "10"
And I set field "istmoproz" to "0.01" in row 1
And I set field "istmoproz" to "0.01" in row 2
And I set field "istmoproz" to "0.01" in row 3
And I set field "istmoproz" to "0.01" in row 4
And I set field "istmoproz" to "0.01" in row 5
And I set field "istmoproz" to "0.01" in row 6
And I set field "istmoproz" to "0.01" in row 7
And I set field "istmoproz" to "0.01" in row 8
And I set field "istmoproz" to "0.01" in row 9
And I set field "istmoproz" to "0.01" in row 10
And I set field "istmoproz" to "11.12449" in row 11
And I save the current editor
Then field "absistrest" has value "0.00"
And I close the current editor

Given I open an editor "Umlage" for tip command "ilv" and arguments ""
And I set field "monat" to "2"
And I set field "vorschau" to "ja"
And I set field "datart" to "Ist"
And I set field "buumfang" to "ILV und Entlastung Hauptkostenstellen"
And I press button "bstart"
And I save the current editor
