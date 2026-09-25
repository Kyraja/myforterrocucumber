# *****************************************************************************
#  Name           : ilv_prozesssperre.feature
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Test der Prozesssperrstelle der ILV
#                  
#                   Ausführen der ILV in Konstellationen, in denen ein Be- oder Entlastungskonto für die ILV die ILV-Prozesssperrstelle besitzt:
#                   - Scenario 02: Konto 91011 wird in keiner Kostenstelle verwendet (Sperre darf die ILV nicht verhindern)
#                   - Scenario 03: Konto 91012 wird in einer Hilfs-Kostenstelle verwendet, die nicht relevant für die ILV ist (da sie bspw. keine Kosten besitzt) (Sperre darf die ILV nicht verhindern)
#                   - Scenario 04: Konto 91013 wird in einer Haupt-Kostenstelle verwendet, die nicht relevant für die ILV ist (da sie bspw. keine Kosten besitzt) (Sperre darf die ILV nicht verhindern)
#                   - Scenario 05: Konto 91111 wird in einer Hilfs-Kostenstelle verwendet, die relevant für die ILV ist (Sperre muss die ILV verhindern)
#                   - Scenatio 06: Konto 95020 wird in einer Haupt-Kostenstelle verwendet, die relevant für die ILV ist (Sperre muss die ILV verhindern)
#                   Ausführen der ILV in der Konstellation, daß ein Be- oder Entlastungskonto für die ILV die Standardkontensperre besitzt:
#                   - Scenario 07: Konto 91111 wird in einer Hilfs-Kostenstelle verwendet, die relevant für die ILV ist (Sperre darf die ILV nicht verhindern)
#
# *****************************************************************************
#
@persistent
Feature: ILV-Prozesssperre 
Background: 
Given I set the fake date to "31.01.2004"

Scenario: 01 Stammdaten
# Sperrkonfiguration für die Gruppe Konto ohne Prozesssperrstelle ILV
Given I open an editor "sperrkonfig-konto" from table "(LockConfiguration):(LockConfiguration)" with command "COPY" for record "ACCOUNT-LOCK"
And I set field "such" to "ACCOUNT-LOCK2"
And I set field "namebspr" to "Standard-Kontosperre2"
And I set field "classname" to "AccountStandardNew2"
And I delete row at position !lastRow
And I save the current editor
And I close the current editor

# Sperrkonfiguration in Aufzählung aufnehmen
Given I open an editor "aufzaehlung-konto" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "KONTOSPERRE"
And I set field "reosofort" to "ja"
And I create a new row at the end of the table
And I set field "vaufzelem" to "192 ACCOUNT-LOCK2" in row !lastRow
And I save the current editor
And I close the current editor

Scenario: 02 Konto 91011 (mit ILV-Prozesssperrstelle), wird in keiner Kostenstelle verwendet. Sperre darf die ILV nicht verhindern.
# Konto 91111 kopieren, Sperrkonfiguration mit ILV-Prozesssperrstelle
Given I open an editor "kto-02" from table "(Account):(Account)" with command "COPY" for record "91111"
And I set field "nummer" to "91011"
And I set field "such" to "noilv-02"
And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
And I set field "sperrgrundneu" to "gesperrt"
And I save the current editor
And I close the current editor

# ILV ausführen und Protokolldatei in Referenz schreiben
Given I open an editor "Umlage" for tip command "ilv" and arguments ""
And I set field "vorschau" to "ja"
And I set field "datart" to "Ist"
And I set field "gjahr" to "04"
And I set field "monat" to "1"
And I press button "bstart"
And I save the current editor

Given I execute shell command "echo \" -- Beginn Protokoll der ILV Scenario 02 --\" > ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
And I append ScenarioHeadline to output file "ref_ilv_prozesssperre.ref"
Given I execute shell command "cat ko/ILVPLAUSI.AUS >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \" -- Ende Protokoll Scenario 02 --     \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"--------------------------------------------------------------------------------------------------  \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"

Scenario: 03 Konto 91012 (mit ILV-Prozesssperrstelle), wird in Hilfs-Kostenstelle 2001 verwendet. Sperre darf die ILV nicht verhindern.
# Konto 91111 kopieren, neues erzeugen, ILV-Prozesssperre eintragen, Kostenstelle 1111 kopieren und neues Konto mit ILV-Prozesssperre eintragen
Given I open an editor "kto-03" from table "(Account):(Account)" with command "COPY" for record "91111"
And I set field "nummer" to "91012"
And I set field "such" to "noilv-03"
And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
And I set field "sperrgrundneu" to "gesperrt"
And I save the current editor
And I close the current editor

Given I open an editor "kst-03" from table "(Account):(CostCenter)" with command "COPY" for record "1111"
And I set field "nummer" to "2001"
And I set field "such" to "noilv-03"
And I set field "umlab" to "91012"
And I set field "umlzu" to "91112"
And I save the current editor
And I close the current editor

# ILV ausführen und Protokolldatei in Referenz schreiben
Given I open an editor "Umlage" for tip command "ilv" and arguments ""
And I set field "vorschau" to "ja"
And I set field "datart" to "Ist"
And I set field "gjahr" to "04"
And I set field "monat" to "1"
And I press button "bstart"
And I save the current editor

Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \" -- Beginn Protokoll der ILV Scenario 03 --\" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
And I append ScenarioHeadline to output file "ref_ilv_prozesssperre.ref"
Given I execute shell command "cat ko/ILVPLAUSI.AUS >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \" -- Ende Protokoll Scenario 03 --      \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"--------------------------------------------------------------------------------------------------  \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"

Scenario: 04 Konto 91013 (mit ILV-Prozesssperrstelle), wird in Haupt-Kostenstelle 2201 verwendet. Sperre darf die ILV nicht verhindern.
# Konto 91111 kopieren, neues erzeugen, ILV-Prozesssperre eintragen, Kostenstelle 1111 kopieren und neues Konto mit ILV-Prozesssperre eintragen
Given I open an editor "kto-04" from table "(Account):(Account)" with command "COPY" for record "91111"
And I set field "nummer" to "91013"
And I set field "such" to "noilv-04"
And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
And I set field "sperrgrundneu" to "gesperrt"
And I save the current editor
And I close the current editor

Given I open an editor "kst-04" from table "(Account):(CostCenter)" with command "COPY" for record "1410"
And I set field "nummer" to "2201"
And I set field "such" to "noilv-04"
And I set field "umlab" to "91013"
And I set field "umlzu" to "91112"
And I save the current editor
And I close the current editor

# ILV ausführen und Protokolldatei in Referenz schreiben
Given I open an editor "Umlage" for tip command "ilv" and arguments ""
And I set field "vorschau" to "ja"
And I set field "datart" to "Plan"
And I set field "gjahr" to "04"
And I set field "monat" to "1"
And I press button "bstart"
And I save the current editor

Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \" -- Beginn Protokoll der ILV Scenario 04 --\" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
And I append ScenarioHeadline to output file "ref_ilv_prozesssperre.ref"
Given I execute shell command "cat ko/ILVPLAUSI.AUS >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \" -- Ende Protokoll Scenario 04 --       \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"--------------------------------------------------------------------------------------------------  \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"


# Given I open an editor "bu" from table "(Entry):(StatisticalEntry)" with command "VIEW" for search criteria "$,,vkzart=plan;gjahr=04;monat=8;ursache=Leistungsverrechnung;@richtung=rueckwaerts;@maxtreffer=1" 
# Then field "kstelle" has value "1111" in row 1
# And I close the current editor


Scenario: 05 Konto 91111 (mit ILV-Prozesssperrstelle), wird in Hilfs-Kostenstelle 1111 verwendet. Sperre muss die ILV verhindern.
# Konto 91111: ILV-Prozesssperre eintragen
Given I open an editor "kto-05" from table "(Account):(Account)" with command "UPDATE" for record "91111"
And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
And I set field "sperrgrundneu" to "gesperrt"
And I save the current editor
And I close the current editor

# ILV ausführen und Protokolldatei in Referenz schreiben
Given I open an editor "Umlage" for tip command "ilv" and arguments ""
And I set field "vorschau" to "ja"
And I set field "datart" to "Ist"
And I set field "gjahr" to "04"
And I set field "monat" to "8"
And I press button "bstart"
And I save the current editor

Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \" -- Beginn Protokoll der ILV Scenario 05 --\" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
And I append ScenarioHeadline to output file "ref_ilv_prozesssperre.ref"
Given I execute shell command "cat ko/ILVPLAUSI.AUS >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \" -- Ende Protokoll Scenario 05 --      \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"--------------------------------------------------------------------------------------------------  \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"

Scenario: 06 Konto 95020 (mit ILV-Prozesssperrstelle), wird in Hilfs-Kostenstelle 1510 verwendet. Sperre muss die ILV verhindern.
# Konto 91111: Sperre wieder aufheben für dieses Szenario
Given I open an editor "kto-06-sperre_aufheben" from table "(Account):(Account)" with command "UPDATE" for record "91111"
And I set field "sperrkonfigurationneu" to " "
And I save the current editor
And I close the current editor

Given I open an editor "kto-06-sperre_setzen" from table "(Account):(Account)" with command "UPDATE" for record "95020"
And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
And I set field "sperrgrundneu" to "gesperrt"
And I save the current editor
And I close the current editor

# ILV ausführen und Protokolldatei in Referenz schreiben
Given I open an editor "Umlage" for tip command "ilv" and arguments ""
And I set field "vorschau" to "ja"
And I set field "datart" to "Ist"
And I set field "gjahr" to "04"
And I set field "monat" to "8"
And I press button "bstart"
And I save the current editor

Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \" -- Beginn Protokoll der ILV Scenario 06 --\" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
And I append ScenarioHeadline to output file "ref_ilv_prozesssperre.ref"
Given I execute shell command "cat ko/ILVPLAUSI.AUS >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \" -- Ende Protokoll Scenario 06 --      \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"--------------------------------------------------------------------------------------------------  \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"

Scenario: 07 Konto 91111 (mit Standard-Kontensperre), wird in Hilfs-Kostenstelle 1111 verwendet. Sperre darf die ILV nicht verhindern.
# Konto 95020: Sperre wieder aufheben für dieses Szenario
Given I open an editor "kto-07-sperre-aufheben" from table "(Account):(Account)" with command "UPDATE" for record "95020"
And I set field "sperrkonfigurationneu" to " "
And I save the current editor
And I close the current editor

# Konto wird in Hilfskostenstelle 1111 verwendet. Standard-Kontensperre2 (ohne ILV-Prozesssperre) darf die ILV nicht verhindern.
Given I open an editor "kto-07-sperre_setzen" from table "(Account):(Account)" with command "UPDATE" for record "91111"
And I set field "sperrkonfigurationneu" to "Standard-Kontosperre2"
And I set field "sperrgrundneu" to "gesperrt"
And I save the current editor
And I close the current editor

# ILV ausführen
Given I open an editor "Umlage" for tip command "ilv" and arguments ""
And I set field "vorschau" to "ja"
And I set field "datart" to "Ist"
And I set field "gjahr" to "04"
And I set field "monat" to "8"
And I press button "bstart"
And I save the current editor

Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \" -- Beginn Protokoll der ILV Scenario 07 --\" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
And I append ScenarioHeadline to output file "ref_ilv_prozesssperre.ref"
Given I execute shell command "cat ko/ILVPLAUSI.AUS >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \" -- Ende Protokoll Scenario 07 --      \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"--------------------------------------------------------------------------------------------------  \" >> ref_ilv_prozesssperre.ref"
Given I execute shell command "echo \"        \" >> ref_ilv_prozesssperre.ref"








