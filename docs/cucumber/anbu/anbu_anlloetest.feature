# *****************************************************************************
#  Name             : anbu_anlloetest.feature
#  Autor            : Jan Effler
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : 
# *****************************************************************************

Feature: anbu_anlloetest
Scenario: anlloetest

Given I'm logged in with password "annette"

# Bearbeitung von Anlage_steuer 120000

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "14100" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "22000" throws the exception "1582"
Given I open an editor "acc-01500" from table "(Account):(Account)" with command "DELETE" for record "01500"
Then saving the current editor throws the exception "4484"
And I close the current editor
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "5" throws the exception "1582"
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 1800

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "16000" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "21000" throws the exception "1582"
Given I open an editor "acc-02400" from table "(Account):(Account)" with command "DELETE" for record "02400"
Then saving the current editor throws the exception "4484"
And I close the current editor
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "7" throws the exception "1582"
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 8060

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "17000" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "21000" throws the exception "1582"
Given I open an editor "acc-02500" from table "(Account):(Account)" with command "DELETE" for record "02500"
Then saving the current editor throws the exception "4484"
And I close the current editor
Then opening an editor from table "(Account):(Account)" with command "DELETE" for record "100" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "1" throws the exception "1582"
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 56100

Given I open an editor "acc-02500" from table "(Account):(Account)" with command "DELETE" for record "02500"
Then saving the current editor throws the exception "4484"
And I close the current editor
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "30" throws the exception "1582"
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 50000

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "15500" throws the exception "1582"
Given I open an editor "acc-02400" from table "(Account):(Account)" with command "DELETE" for record "04200"
Then saving the current editor throws the exception "4484"
And I close the current editor
Then opening an editor from table "(Account):(Account)" with command "DELETE" for record "100" throws the exception "1582"
Given I open an editor "anl-50000k" from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "50000k"
Then saving the current editor throws the exception "1622"
And I close the current editor
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "30" throws the exception "1582"
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 50010

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "15500" throws the exception "1582"
Given I open an editor "acc-04200" from table "(Account):(Account)" with command "DELETE" for record "04200"
Then saving the current editor throws the exception "4484"
And I close the current editor
Then opening an editor from table "(Account):(Account)" with command "DELETE" for record "100" throws the exception "1582"
Given I open an editor "anl-50010k" from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "50010k"
Then saving the current editor throws the exception "1622"
And I close the current editor
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "30" throws the exception "1582"
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 50020

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "15500" throws the exception "1582"
Given I open an editor "acc-04200" from table "(Account):(Account)" with command "DELETE" for record "04200"
Then saving the current editor throws the exception "4484"
And I close the current editor
Then opening an editor from table "(Account):(Account)" with command "DELETE" for record "100" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "30" throws the exception "1582"
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 50050

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "15500" throws the exception "1582"
Given I open an editor "acc-04200" from table "(Account):(Account)" with command "DELETE" for record "04200"
Then saving the current editor throws the exception "4484"
And I close the current editor
Then opening an editor from table "(Account):(Account)" with command "DELETE" for record "100" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "7" throws the exception "1582"
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 50040

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "15500" throws the exception "1582"
Given I open an editor "acc-04200" from table "(Account):(Account)" with command "DELETE" for record "04200"
Then saving the current editor throws the exception "4484"
And I close the current editor
Then opening an editor from table "(Account):(Account)" with command "DELETE" for record "100" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "25" throws the exception "1582"
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 60000

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "15000" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "21000" throws the exception "1582"
Given I open an editor "acc-04400" from table "(Account):(Account)" with command "DELETE" for record "04400"
Then saving the current editor throws the exception "4484"
And I close the current editor
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 60020

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "15000" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "21000" throws the exception "1582"
Given I open an editor "acc-04400" from table "(Account):(Account)" with command "DELETE" for record "04400"
Then saving the current editor throws the exception "4484"
And I close the current editor
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 8012

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "15000" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "21000" throws the exception "1582"
Given I open an editor "acc-04400" from table "(Account):(Account)" with command "DELETE" for record "04400"
Then saving the current editor throws the exception "4484"
And I close the current editor
Then opening an editor from table "(Account):(Account)" with command "DELETE" for record "100" throws the exception "1582"
Given I open an editor "anl-8012k" from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "8012k"
Then saving the current editor throws the exception "1622"
And I close the current editor
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "3" throws the exception "1582"
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 8004

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "13100" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "21100" throws the exception "1582"
Given I open an editor "acc-05200" from table "(Account):(Account)" with command "DELETE" for record "05200"
Then saving the current editor throws the exception "4484"
And I close the current editor
Then opening an editor from table "(Account):(Account)" with command "DELETE" for record "100" throws the exception "1582"
Given I open an editor "anl-8004k" from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "8004k"
Then saving the current editor throws the exception "1622"
And I close the current editor
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "3" throws the exception "1582"
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 8007

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "13000" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "21100" throws the exception "1582"
Given I open an editor "acc-05200" from table "(Account):(Account)" with command "DELETE" for record "05200"
Then saving the current editor throws the exception "4484"
And I close the current editor
Then opening an editor from table "(Account):(Account)" with command "DELETE" for record "100" throws the exception "1582"
Given I open an editor "anl-8007k" from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "8007k"
Then saving the current editor throws the exception "1622"
And I close the current editor
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "4" throws the exception "1582"
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 8024

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "14100" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "22000" throws the exception "1582"
Given I open an editor "acc-05200" from table "(Account):(Account)" with command "DELETE" for record "05200"
Then saving the current editor throws the exception "4484"
And I close the current editor
Then opening an editor from table "(Account):(Account)" with command "DELETE" for record "100" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "5" throws the exception "1582"
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 8037

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "14100" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "22000" throws the exception "1582"
Given I open an editor "acc-052000" from table "(Account):(Account)" with command "DELETE" for record "05200"
Then saving the current editor throws the exception "4484"
And I close the current editor
Then opening an editor from table "(Account):(Account)" with command "DELETE" for record "100" throws the exception "1582"
Given I open an editor "anl-8037k" from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "8037k"
Then saving the current editor throws the exception "1622"
And I close the current editor
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "1" throws the exception "1582"
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 8048

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "14100" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "22000" throws the exception "1582"
Given I open an editor "acc-05200" from table "(Account):(Account)" with command "DELETE" for record "05200"
Then saving the current editor throws the exception "4484"
And I close the current editor
Then opening an editor from table "(Account):(Account)" with command "DELETE" for record "100" throws the exception "1582"
Given I open an editor "anl-8048k" from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "8048k"
Then saving the current editor throws the exception "1622"
And I close the current editor
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "1" throws the exception "1582"
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 8046

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "13000" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "21100" throws the exception "1582"
Given I open an editor "acc-05200" from table "(Account):(Account)" with command "DELETE" for record "05200"
Then saving the current editor throws the exception "4484"
And I close the current editor
Then opening an editor from table "(Account):(Account)" with command "DELETE" for record "100" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "1" throws the exception "1582"
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 110020

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "14100" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "22000" throws the exception "1582"
Given I open an editor "acc-05200" from table "(Account):(Account)" with command "DELETE" for record "05200"
Then saving the current editor throws the exception "4484"
And I close the current editor
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "5" throws the exception "1582"
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 8049

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "13100" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "21100" throws the exception "1582"
Given I open an editor "acc-05600" from table "(Account):(Account)" with command "DELETE" for record "05600"
Then saving the current editor throws the exception "4484"
And I close the current editor
Then opening an editor from table "(Account):(Account)" with command "DELETE" for record "100" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "1" throws the exception "1582"
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 8000

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "14000" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "22000" throws the exception "1582"
Given I open an editor "acc-06500" from table "(Account):(Account)" with command "DELETE" for record "06500"
Then saving the current editor throws the exception "4484"
And I close the current editor
Then opening an editor from table "(Account):(Account)" with command "DELETE" for record "100" throws the exception "1582"
Given I open an editor "anl-8000k" from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "8000k"
Then saving the current editor throws the exception "1622"
And I close the current editor
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "1" throws the exception "1582"
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 8088

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "14000" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "21000" throws the exception "1582"
Given I open an editor "acc-06500" from table "(Account):(Account)" with command "DELETE" for record "06500"
Then saving the current editor throws the exception "4484"
And I close the current editor
Then opening an editor from table "(Account):(Account)" with command "DELETE" for record "100" throws the exception "1582"
Given I open an editor "anl-8088k" from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "8088k"
Then saving the current editor throws the exception "1622"
And I close the current editor
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "3" throws the exception "1582"
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 8102

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "14000" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "21000" throws the exception "1582"
Given I open an editor "acc-06500" from table "(Account):(Account)" with command "DELETE" for record "06500"
Then saving the current editor throws the exception "4484"
And I close the current editor
Then opening an editor from table "(Account):(Account)" with command "DELETE" for record "100" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "1" throws the exception "1582"
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 8009

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "14000" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "21100" throws the exception "1582"
Given I open an editor "acc-06500" from table "(Account):(Account)" with command "DELETE" for record "06500"
Then saving the current editor throws the exception "4484"
And I close the current editor
Then opening an editor from table "(Account):(Account)" with command "DELETE" for record "100" throws the exception "1582"
Given I open an editor "anl-8009k" from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "8009k"
Then saving the current editor throws the exception "1622"
And I close the current editor
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "3" throws the exception "1582"
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 8015

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "14000" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "21100" throws the exception "1582"
Given I open an editor "acc-06500" from table "(Account):(Account)" with command "DELETE" for record "06500"
Then saving the current editor throws the exception "4484"
And I close the current editor
Then opening an editor from table "(Account):(Account)" with command "DELETE" for record "100" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "8" throws the exception "1582"
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 110010

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "16100" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "21100" throws the exception "1582"
Given I open an editor "acc-06700" from table "(Account):(Account)" with command "DELETE" for record "06700"
Then saving the current editor throws the exception "4484"
And I close the current editor
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "410" throws the exception "1582"
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

# Bearbeitung von Anlage_steuer 56000a

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "15500" throws the exception "1582"
Given I open an editor "acc-07700" from table "(Account):(Account)" with command "DELETE" for record "07700"
Then saving the current editor throws the exception "4484"
And I close the current editor
Then opening an editor from table "(Account):(Account)" with command "DELETE" for record "100" throws the exception "1582"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "30" throws the exception "1582"
Given I open an editor "acc-62200" from table "(Account):(Account)" with command "DELETE" for record "62200"
Then saving the current editor throws the exception "4484"
And I close the current editor

Given I open an editor "anl-8000" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record "8000"
And I set field "nummer" to "8000ovkz"
And I set field "such" to "Loesch"
And I set field "name" to "Anlage ohne Verkehrszahlen"
And I save the current editor

# An dieser Stelle m�sste gefragt werden ob wirklich gelöscht werden soll - 826: Wirklich löschen? - (vgl. GUI), 
# in Cucumber wird einfach gelöscht.
# Deshalb hier: nicht löschen und anlegen von 8000pvkz mit COPY
#
# Given I open an editor "anl-8000ovkz" from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "8000ovkz"
# And I save the current editor
# And I close the current editor

Given I open an editor "anl-8000pvkz" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "8000ovkz"
And I set field "nummer" to "8000pvkz"
And I set field "such" to "LOEPVKZ"
And I set field "name" to "Anlage mit Planverkehrszahlen"
And I save the current editor
And I close the current editor

Given I open an editor "anl-8000pvkz" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "8000pvkz"
# 2011: Datensatz nicht vorhanden, neuen erzeugen?
And I press button "pvkz" to open a subeditor for "anl-8000pvkz-pvkz" in row 0 with dialog "2011" and answer "ja"
# 2012: Bewegungsdaten ok.?
And I respond with answer "ja" to the dialog with id "2012"
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-8000pvkz" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "8000pvkz"
And I press button "pvkz" to open a subeditor for "anl-8000pvkz-pvkz"
And I set field "s1" to "1000"
# 2012: Bewegungsdaten ok.?
And I respond with answer "ja" to the dialog with id "2012"
And I save the current subeditor to switch back to the parent editor
And I close the current editor


Given I open an editor "anl-8000pvkz" from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "8000pvkz"
And I respond with answer "nein" to the dialog with id ""
Then saving the current editor throws the exception "1622"
And I close the current editor



