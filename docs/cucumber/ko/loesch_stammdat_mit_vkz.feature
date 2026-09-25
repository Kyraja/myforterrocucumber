# *****************************************************************************
#  Name           : loesch_stammdat_mit_vkz.feature             
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Test des Ablaufs des Löschens (Dialoge) von Stamm- mit zugehörigen Bewegungsdaten.
#                   Löscheabfrage zunächst mit "nein" beantworten und Dialog abarbeiten.
#                   Dann Löschabfrage mit "ja" beantworten und Diaglog abarbeiten.
#
# *****************************************************************************
@persistent
Feature: ref_loesch_stammdat_mit_vkz_cu
Background: 
Given I set the fake date to "1.05.02"

# Bezugsgröße

Scenario: 01 Bezugsgröße anlegen

Given I open an editor "bg1" from table "(ActivityBase):(ActivityBase)" with command "NEW" for record ""
And I set field "such" to "bg-km"
And I set field "einheitbz" to "km"
And I save the current editor

Scenario: 02 Ist-VKZ zur Bezugsgröße

Given I open an editor "bg1" from table "(ActivityBase):(ActivityBase)" with command "UPDATE" for record "bg-km"
And I press button "ivkz" to open a subeditor for "Ist-Vkz" in row 0 with dialog "2011" and answer "Ja"
And I set field "s1" to "100"
And I set field "s2" to "100"
And I set field "s3" to "100"
And I set field "s4" to "100"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "bg1"
And I close the current editor

Scenario: 03 Bezugsgröße löschen - nein

Given I open an editor "bg1" from table "(ActivityBase):(ActivityBase)" with command "DELETE" for record "bg-km"
# 2625 de      |Objekt hat Ist-Verkehrszahlen (VKZ)-trotzdem löschen (inkl. VKZ)?
Given I respond with answer "nein" to the dialog with id "2625"
Then saving the current editor throws the exception "2743"
And I close the current editor

Scenario: 04 Bezugsgröße löschen - ja

Given I open an editor "bg1" from table "(ActivityBase):(ActivityBase)" with command "DELETE" for record "bg-km"
# 2625 de      |Objekt hat Ist-Verkehrszahlen (VKZ)-trotzdem löschen (inkl. VKZ)?
Given I respond with answer "ja" to the dialog with id "2625"
# 826 de   |Wirklich löschen?
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

Scenario: 05 Bezugsgröße mit Ist- und Plan-VKZ anlegen

Given I open an editor "bg2" from table "(ActivityBase):(ActivityBase)" with command "NEW" for record ""
And I set field "such" to "bg-km2"
And I set field "einheitbz" to "km"
And I save the current editor

Given I open an editor "bg2" from table "(ActivityBase):(ActivityBase)" with command "UPDATE" for record "bg-km2"
And I press button "ivkz" to open a subeditor for "Ist-Vkz" in row 0 with dialog "2011" and answer "Ja"
And I set field "s1" to "100"
And I set field "s2" to "100"
And I set field "s3" to "100"
And I set field "s4" to "100"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "bg2"
And I close the current editor

Given I open an editor "bg2" from table "(ActivityBase):(ActivityBase)" with command "UPDATE" for record "bg-km2"
And I press button "pvkz" to open a subeditor for "Ist-Vkz" in row 0 with dialog "2011" and answer "Ja"
And I set field "s1" to "200"
And I set field "s2" to "200"
And I set field "s3" to "200"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "bg2"
And I close the current editor

Scenario: 06 Bezugsgröße mit Ist- und Plan-VKZ löschen - nein
Given I open an editor "bg2" from table "(ActivityBase):(ActivityBase)" with command "DELETE" for record "bg-km2"
# 2578 de      |Objekt hat Ist- u. Plan-Verkehrszahlen (VKZ)-trotzdem löschen (inkl. VKZ)?
Given I respond with answer "nein" to the dialog with id "2578"
Then saving the current editor throws the exception "2743"
And I close the current editor

Scenario: 07 Bezugsgröße mit Ist- und Plan-VKZ löschen - ja

Given I open an editor "bg2" from table "(ActivityBase):(ActivityBase)" with command "DELETE" for record "bg-km2"
# 2578 de      |Objekt hat Ist- u. Plan-Verkehrszahlen (VKZ)-trotzdem löschen (inkl. VKZ)?
Given I respond with answer "ja" to the dialog with id "2578"
# 826 de   |Wirklich löschen?
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

# Kostenstelle

Scenario: 08 Kst mit Plan-VKZ

Given I open an editor "ks1" from table "(Account):(CostCenter)" with command "NEW" for record ""
And I set field "nummer" to "500"
And I set field "such" to "KS500"
And I set field "namebspr" to "Kostenstelle 500"
And I save the current editor

Given I open an editor "ks1" from table "(Account):(CostCenter)" with command "UPDATE" for record "KS500"
And I press button "pvkz" to open a subeditor for "Plan-Vkz" in row 0 with dialog "2011" and answer "Ja"
And I set field "s1" to "100"
And I set field "s2" to "100"
And I set field "s3" to "100"
And I set field "s4" to "100"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "ks1"
And I close the current editor

Scenario: 09 Kst mit Plan-VKZ löschen -nein
Given I open an editor "ks1" from table "(Account):(CostCenter)" with command "DELETE" for record "KS500"
# 2579 de      |Objekt hat Plan-Verkehrszahlen (VKZ)-trotzdem löschen (inkl. VKZ)?
And I respond with answer "nein" to the dialog with id "2579"
Then saving the current editor throws the exception "2743"
And I close the current editor

Scenario: 10 Kst mit Plan-VKZ löschen -ja

Given I open an editor "ks1" from table "(Account):(CostCenter)" with command "DELETE" for record "KS500"
# 2579 de      |Objekt hat Plan-Verkehrszahlen (VKZ)-trotzdem löschen (inkl. VKZ)?
And I respond with answer "ja" to the dialog with id "2579"
# 826 de   |Wirklich löschen?
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

# Konto

Scenario: 11 Konto mit Plan-VKZ

Given I open an editor "ko1" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "50123"
And I set field "such" to "K50123"
And I set field "namebspr" to "Konto 50123"
And I save the current editor

Given I open an editor "ko1" from table "(Account):(Account)" with command "UPDATE" for record "K50123"
And I press button "pvkz" to open a subeditor for "Plan-Vkz" in row 0 with dialog "2011" and answer "Ja"
And I set field "s1" to "100"
And I set field "s2" to "100"
And I set field "s3" to "100"
And I set field "s4" to "100"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "ko1"
And I close the current editor

Scenario: 11 Konto mit Plan-VKZ löschen - nein
Given I open an editor "ko1" from table "(Account):(Account)" with command "DELETE" for record "K50123"
# 2579 de      |Objekt hat Plan-Verkehrszahlen (VKZ)-trotzdem löschen (inkl. VKZ)?
And I respond with answer "nein" to the dialog with id "2579"
Then saving the current editor throws the exception "2743"
And I close the current editor

Scenario: 12 Konto mit Plan-VKZ löschen - ja

Given I open an editor "ko1" from table "(Account):(Account)" with command "DELETE" for record "K50123"
# 2579 de      |Objekt hat Plan-Verkehrszahlen (VKZ)-trotzdem löschen (inkl. VKZ)?
And I respond with answer "ja" to the dialog with id "2579"
# 826 de   |Wirklich löschen?
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

Scenario: 13 Konto mit Ist-VKZ

Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "budat" to "."
And I set field "beldat" to "."
And I create a new row at the end of the table
And I set field "konto" to "60100" in row 1
And I set field "ewsbetr" to "139" in row 1
And I set field "kstelle" to "101" in row 1
And I create a new row at the end of the table
And I set field "konto" to "11400" in row 2
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

Scenario: 14 Konto mit Ist-VKZ löschen - ja - geht aber nicht
Given I open an editor "ko2" from table "(Account):(Account)" with command "DELETE" for record "60100"
# 5478   | Konto bereits bebucht!
Then saving the current editor throws the exception "5478"
And I close the current editor

Scenario: 15 Kostenverteiler 10 und 20
Given I open an editor "kv-1" from table "(Account):(CostDistribution)" with command "NEW" for record ""
And I set field "nummer" to "10"
And I set field "such" to "kv"
And I create a new row at the end of the table
And I set field "kstelle" to "101" in row 1
And I set field "proz" to "10" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "100000" in row 2
And I set field "proz" to "5" in row 2
And I create a new row at the end of the table
And I set field "kstelle" to "100" in row 3
And I set field "proz" to "85" in row 3
And I save the current editor

Given I open an editor "kv-2" from table "(Account):(CostDistribution)" with command "NEW" for record ""
And I set field "nummer" to "20"
And I set field "such" to "kv"
And I create a new row at the end of the table
And I set field "kstelle" to "101" in row 1
And I set field "proz" to "10" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "100000" in row 2
And I set field "proz" to "90" in row 2
And I save the current editor

Given I open an editor "Buchung2" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "budat" to "."
And I set field "beldat" to "."
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 1
And I set field "ewsbetr" to "200" in row 1
And I set field "kstelle" to "10" in row 1
And I create a new row at the end of the table
And I set field "konto" to "11400" in row 2
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

Scenario: 16 KV löschen - ja - geht aber nicht
Given I open an editor "kv" from table "(Account):(CostDistribution)" with command "DELETE" for record "10"
# 1212 | Kst/Ktr/Kv kommt noch in einer Buchung vor. Kein Loschen moglich!
Then saving the current editor throws the exception "1212"
And I close the current editor

Given I open an editor "kv" from table "(Account):(CostDistribution)" with command "DELETE" for record "20"
# 826 de   |Wirklich löschen?
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor 
And I close the current editor

Scenario: 17 Kst mit Plan-VKZ - Vorkommnis in Kostenstellenumlage
# BUG: Löschen trotzdem möglich 
Given I open an editor "ks102" from table "(Account):(CostCenter)" with command "NEW" for record ""
And I set field "nummer" to "102"
And I set field "such" to "KS102"
And I set field "namebspr" to "Kostenstelle 102"
And I set field "hilfsks" to "ja"
And I save the current editor

Given I open an editor "ks17" from table "(Account):(CostCenter)" with command "NEW" for record ""
And I set field "nummer" to "1700"
And I set field "such" to "KS1700"
And I set field "namebspr" to "Kostenstelle 1700"
And I save the current editor

Given I open an editor "ks17" from table "(Account):(CostCenter)" with command "UPDATE" for record "KS1700"
And I press button "pvkz" to open a subeditor for "Plan-Vkz" in row 0 with dialog "2011" and answer "Ja"
And I set field "s1" to "100"
And I set field "s2" to "100"
And I set field "s3" to "100"
And I set field "s4" to "100"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "ks17"
And I close the current editor

Given I open an editor "ksum1" from table "(Assessment):(CostCenterAssessment)" with command "NEW" for record ""
And I set field "such" to "um17"
And I set field "ksab" to "102"
And I create a new row at the end of the table
And I set field "kszu" to "ks1700" in row 1
And I save the current editor
And I close the current editor

Scenario: 18 Kst mit Plan-VKZ und Vorkommnis in Kostenstellenumlage löschen - wird abgelehnt
Given I open an editor "ks17" from table "(Account):(CostCenter)" with command "DELETE" for record "KS1700"
# 9730 de      |Kostenobjekt kommt in einer Kostenstellenumlage vor. Kein Löschen möglich!
Then saving the current editor throws the exception "9730"
And I close the current editor

Scenario: 19 Kst und Ktr mit und ohne Plan-VKZ - Vorkommnis in Kassenbuch
# BUG: Löschen trotzdem möglich 
Given I open an editor "ks18" from table "(Account):(CostCenter)" with command "NEW" for record ""
And I set field "nummer" to "1800"
And I set field "such" to "KS1800"
And I set field "namebspr" to "Kostenstelle 1800"
And I save the current editor

Given I open an editor "ks18" from table "(Account):(CostCenter)" with command "UPDATE" for record "KS1800"
And I press button "pvkz" to open a subeditor for "Plan-Vkz" in row 0 with dialog "2011" and answer "Ja"
And I set field "s1" to "100"
And I set field "s2" to "100"
And I set field "s3" to "100"
And I set field "s4" to "100"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "ks18"
And I close the current editor

Given I open an editor "ks19" from table "(Account):(CostCenter)" with command "NEW" for record ""
And I set field "nummer" to "1900"
And I set field "such" to "KS1900"
And I set field "namebspr" to "Kostenstelle 1900"
And I save the current editor

Given I open an editor "kt18" from table "(Account):(CostObject)" with command "NEW" for record ""
And I set field "nummer" to "180000"
And I set field "such" to "KT180000"
And I set field "namebspr" to "Kostentraeger 1800"
And I save the current editor

Given I open an editor "kt18" from table "(Account):(CostObject)" with command "UPDATE" for record "KT180000"
And I press button "pvkz" to open a subeditor for "Plan-Vkz" in row 0 with dialog "2011" and answer "Ja"
And I set field "s1" to "100"
And I set field "s2" to "100"
And I set field "s3" to "100"
And I set field "s4" to "100"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "kt18"
And I close the current editor

Given I open an editor "kt19" from table "(Account):(CostObject)" with command "NEW" for record ""
And I set field "nummer" to "190000"
And I set field "such" to "KT190000"
And I set field "namebspr" to "Kostenstraeger 1900"
And I save the current editor

Given I open an editor "kasse1" from table "(CashBook):(CashBook)" with command "NEW" for record ""
And I set field "such" to "kasse1"
And I set field "kasskto" to "16000"
And I create a new row at the end of the table
And I set field "beldat" to "." in row 1
And I set field "bausg" to "20" in row 1
And I set field "gkonto" to "54000" in row 1
And I set field "kstelle" to "ks1800" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "kasse1" from table "(CashBook):(CashBook)" with command "UPDATE" for record "1"
And I create a new row at the end of the table
And I set field "beldat" to "." in row 2
And I set field "bausg" to "30" in row 2
And I set field "gkonto" to "54000" in row 2
And I set field "kstelle" to "ks1900" in row 2
And I save the current editor
And I close the current editor

Given I open an editor "kasse1" from table "(CashBook):(CashBook)" with command "UPDATE" for record "1"
And I create a new row at the end of the table
And I set field "beldat" to "." in row 3
And I set field "bausg" to "40" in row 3
And I set field "gkonto" to "54000" in row 3
And I set field "kstelle" to "kt180000" in row 3
And I save the current editor
And I close the current editor

Given I open an editor "kasse1" from table "(CashBook):(CashBook)" with command "UPDATE" for record "1"
And I create a new row at the end of the table
And I set field "beldat" to "." in row 4
And I set field "bausg" to "50" in row 4
And I set field "gkonto" to "54000" in row 4
And I set field "kstelle" to "kt190000" in row 4
And I save the current editor
And I close the current editor

Scenario: 20 Kst mit/ohne Plan-VKZ und Vorkommnis in Kassenbuch löschen - wird abgelehnt
Given I open an editor "ks18" from table "(Account):(CostCenter)" with command "DELETE" for record "KS1800"
# 7260 de   |Konto bzw. KST/KV/KT wird noch in mindestens einem Kassenbuch verwendet.
Then saving the current editor throws the exception "7260"
And I close the current editor

Given I open an editor "ks19" from table "(Account):(CostCenter)" with command "DELETE" for record "KS1900"
# 7260 de   |Konto bzw. KST/KV/KT wird noch in mindestens einem Kassenbuch verwendet.
Then saving the current editor throws the exception "7260"
And I close the current editor

Scenario: 21 Ktr mit/ohne Plan-VKZ und Vorkommnis in Kassenbuch löschen - wird abgelehnt
Given I open an editor "kt18" from table "(Account):(CostObject)" with command "DELETE" for record "KT180000"
# 7260 de   |Konto bzw. KST/KV/KT wird noch in mindestens einem Kassenbuch verwendet.
Then saving the current editor throws the exception "7260"
And I close the current editor

Given I open an editor "kt19" from table "(Account):(CostObject)" with command "DELETE" for record "KT190000"
# 7260 de   |Konto bzw. KST/KV/KT wird noch in mindestens einem Kassenbuch verwendet.
Then saving the current editor throws the exception "7260"
And I close the current editor

Scenario: 22 Konto mit/ohne Plan-VKZ und Vorkommnis im Kassenbuch
Given I open an editor "ko21" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "50130"
And I set field "such" to "K50130"
And I set field "namebspr" to "Konto 50130"
And I set field "gv" to "ja"
And I save the current editor

Given I open an editor "ko21" from table "(Account):(Account)" with command "UPDATE" for record "K50130"
And I press button "pvkz" to open a subeditor for "Plan-Vkz" in row 0 with dialog "2011" and answer "Ja"
And I set field "s1" to "100"
And I set field "s2" to "100"
And I set field "s3" to "100"
And I set field "s4" to "100"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "ko21"
And I close the current editor

Given I open an editor "ko21b" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "50131"
And I set field "such" to "K50131"
And I set field "namebspr" to "Konto 50131"
And I set field "gv" to "ja"
And I save the current editor
 
Given I open an editor "kasse1" from table "(CashBook):(CashBook)" with command "UPDATE" for record "1"
And I create a new row at the end of the table
And I set field "beldat" to "." in row 5
And I set field "bausg" to "500" in row 5
And I set field "gkonto" to "50130" in row 5
And I set field "kstelle" to "kt190000" in row 5
And I save the current editor
And I close the current editor

Given I open an editor "kasse1" from table "(CashBook):(CashBook)" with command "UPDATE" for record "1"
And I create a new row at the end of the table
And I set field "beldat" to "." in row 6
And I set field "bausg" to "500" in row 6
And I set field "gkonto" to "50131" in row 6
And I set field "kstelle" to "kt190000" in row 6
And I save the current editor
And I close the current editor
 
# Konto 50130 kann nicht gelöscht werden - Vorkommnis in Kassenbuch
Given I open an editor "ko21c" from table "(Account):(Account)" with command "DELETE" for record "50130"
# 7260 de   |Konto bzw. KST/KV/KT wird noch in mindestens einen Kassenbuch verwendet.
Then saving the current editor throws the exception "7260"
And I close the current editor

Given I open an editor "ko21d" from table "(Account):(Account)" with command "DELETE" for record "50131"
# 7260 de   |Konto bzw. KST/KV/KT wird noch in mindestens einem Kassenbuch verwendet.
Then saving the current editor throws the exception "7260"
And I close the current editor
 
Scenario: 23 Konto mit/ohne Plan-VKZ und Vorkommnis in einer Steuerregel
Given I open an editor "ko22" from table "(Account):(Account)" with command "UPDATE" for record "57315"
And I press button "pvkz" to open a subeditor for "Plan-Vkz" in row 0 with dialog "2011" and answer "Ja"
And I set field "s1" to "100"
And I set field "s2" to "100"
And I set field "s3" to "100"
And I set field "s4" to "100"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "ko22"
And I close the current editor

# Konto 57315 kann nicht gelöscht werden - Vorkommnis in Steuerregel 6001
Given I open an editor "ko21c" from table "(Account):(Account)" with command "DELETE" for record "57315"
# 1104 de   |Konto wird in einer Steuerregel verwendet. Es kann nicht gelöscht werden.
Then saving the current editor throws the exception "1104"
And I close the current editor

Given I open an editor "ko21d" from table "(Account):(Account)" with command "DELETE" for record "57366"
# 1104 de   |Konto wird in einer Steuerregel verwendet. Es kann nicht gelöscht werden.
Then saving the current editor throws the exception "1104"
And I close the current editor
 

Scenario: 24 Konto mit/ohne Plan-VKZ und Vorkommnis in einer OP-Bewegung
Given I open an editor "ko23" from table "(Account):(Account)" with command "UPDATE" for record "57365"
And I press button "pvkz" to open a subeditor for "Plan-Vkz" in row 0 with dialog "2011" and answer "Ja"
And I set field "s1" to "100"
And I set field "s2" to "100"
And I set field "s3" to "100"
And I set field "s4" to "100"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "ko23"
And I close the current editor

Given I open an editor "Rechnung23" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | 1    |
    | vom    | .    |
    | ebeleg | RE23 |
    | ueb    | ja   |
And I append rows
    | artikel | mge |
    | e1      | 2   |
    | e2      | 4   |
And I respond with answer "Ja" to the dialog with id "4841"    
And I save the current editor
And I close the current editor    

# 57355 und 57365 ersetzen in Steuerregeln (wenn Konto im OP ist, in der Steuerregel ersetzen sonst kann Vewendung (allein) im OP nicht getestet werden)
Given I open an editor "koneu1" from table "(Account):(Account)" with command "COPY" for record "57355"
And I set field "nummer" to "57991"
And I set field "such" to "skto"
And I save the current editor
And I close the current editor

Given I open an editor "koneu1" from table "(Account):(Account)" with command "COPY" for record "57355"
And I set field "nummer" to "57992"
And I set field "such" to "skto"
And I save the current editor
And I close the current editor

Given I open an editor "Steuerregel" from table "(TaxCode):(TaxRule)" with command "UPDATE" for record "6000"
And I set field "skkto" to "57992" in row 1
And I set field "skkto" to "57992" in row 2
And I set field "skkto" to "57991" in row 3
And I save the current editor
And I close the current editor

Given I open an editor "Steuerregel" from table "(TaxCode):(TaxRule)" with command "UPDATE" for record "6006"
And I set field "skkto" to "57992" in row 1
And I set field "skkto" to "57991" in row 2
And I save the current editor
And I close the current editor

Given I open an editor "Steuerregel" from table "(TaxCode):(TaxRule)" with command "UPDATE" for record "6008"
And I set field "skkto" to "57992" in row 1
And I set field "skkto" to "57991" in row 2
And I save the current editor
And I close the current editor

# Löschen von Konto 57365 nicht möglich - Vorkommnis in Steuerregel
Given I open an editor "kodel1" from table "(Account):(Account)" with command "DELETE" for record "57365"
# 1104 de   |Konto wird in einer Steuerregel verwendet. Es kann nicht gelöscht werden.
Then saving the current editor throws the exception "1104"
And I close the current editor

# Skontokonto 57355 kann trotz Vorkommnis in OP-Bewegung (100:2) gelöscht werden.
Given I open an editor "kodel2" from table "(Account):(Account)" with command "DELETE" for record "57355"
# 826 de   |Wirklich löschen?
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

Scenario: 25 Konto mit/ohne Plan-VKZ und Vorkommnis in einer Fertigungskontengruppe
Given I open an editor "ko24" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "50160"
And I set field "such" to "K50160"
And I set field "namebspr" to "Konto 50160"
And I set field "gv" to "ja"
And I set field "stat" to "Kostenrechnung"
And I save the current editor

Given I open an editor "ko24" from table "(Account):(Account)" with command "UPDATE" for record "50160"
And I press button "pvkz" to open a subeditor for "Plan-Vkz" in row 0 with dialog "2011" and answer "Ja"
And I set field "s1" to "100"
And I set field "s2" to "100"
And I set field "s3" to "100"
And I set field "s4" to "100"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "ko24"
And I close the current editor

Given I open an editor "ko24b" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "50161"
And I set field "such" to "K50161"
And I set field "namebspr" to "Konto 50161"
And I set field "gv" to "ja"
And I set field "stat" to "Kostenrechnung"
And I save the current editor

Given I open an editor "fkogrp" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "UPDATE" for record "100"
And I set field "belast" to "50160" in row 1 
And I set field "belast" to "50161" in row 2
And I save the current editor
And I close the current editor

# Löschen Konto 50160 nicht möglich - Vorkommnis in Fertigungskontengruppe 
Given I open an editor "ko24del" from table "(Account):(Account)" with command "DELETE" for record "50160"
# 2148 de   |Konto wird noch in Fertigungskontengruppen verwendet. Kann nicht gelöscht werden.
Then saving the current editor throws the exception "2148"
And I close the current editor

Given I open an editor "ko24del" from table "(Account):(Account)" with command "DELETE" for record "50161"
# 2148 de   |Konto wird noch in Fertigungskontengruppen verwendet. Kann nicht gelöscht werden.
Then saving the current editor throws the exception "2148"
And I close the current editor

Scenario: 26 Konto löschen, welches im Kontenbereich vorkommt
Given I open an editor "kontenbereich" from table "(AccountRange):(AccountRange)" with command "NEW" for record ""
And I set field "nummer" to "2046"
And I set field "such" to "bil"
And I set field "fausart" to "bil"
And I set field "reregeln" to "endsaldo"
And I set field "konum" to "!"
And I save the current editor
And I close the current editor

Given I open an editor "ko26del" from table "(Account):(Account)" with command "DELETE" for record "00400"
# 4473 de   |Konto kommt im Kontenbereich vor
Then saving the current editor throws the exception "4473"
And I close the current editor


