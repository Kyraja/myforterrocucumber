@persistent
@FP_TEST
Feature: Druckparameter testen

Scenario: Testdaten erstellen

Given I open an editor "Infosystem" from table "(Infosystem):(Infosystem)" with command "NEW" for record ""
And I set field "such" to "test1"
And I set field "name" to "Test Infosystem"
And I set field "arb" to "ow1"
And I set field "maskorigin" to "Automatisch erzeugen"
And I set field "layoutorigin" to "Keine Ausgabe"
And I save the current editor

Given I open an editor "Aufrufparameter" from table "(DataExport):(CallParameter)" with command "NEW" for record ""
And I set field "such" to "apsammel1"
And I set field "name" to "AP1 fuer Sammellayout"
And I set field "aufrktxt" to "v-00-01"
And I set field "zielobj" to "i test1"
And I save the current editor
And I close the current editor

Given I open an editor "Aufrufparameter" from table "(DataExport):(CallParameter)" with command "NEW" for record ""
And I set field "such" to "apsammel2"
And I set field "name" to "AP2 fuer Sammellayout"
And I set field "aufrktxt" to "v-00-02"
And I set field "zielobj" to "i test1"
And I save the current editor
And I close the current editor

Given I open an editor "Drucker" from table "(Infrastructure):(Printer)" with command "NEW" for record ""
And I set field "such" to "testdrucker"
And I set field "name" to "Testdrucker"
And I set field "namesys" to "hplj5m"
And I set field "namesmb" to "hplj5m_smb"
And I set field "druckertyp" to "Drucker"
And field "briefpapier" is modifiable
And I set field "drpcl" to "true"
And I set field "drps" to "true"
And I set field "pflparam1" to "(1)"
And I set field "pflparam1" to "(0)"
And I set field "schacht0" to "automatisch"
And I set field "schacht1" to "schacht1"
And I set field "aktiv" to "true"
Then saving the current editor throws the exception "279"
And I set field "leinh" to "mm"
Then field "druckfop" is not modifiable
And I set field "drindiv" to "true"
And I set field "druckfop" to "blabla"
And I set field "pfldatname" to "optional"
And I save the current editor
And I close the current editor

Scenario: Ausgabekanal
#Laengenheinheit fehlt

Given I open an editor "Ausgabekanal" from table "(PrintParameter):(OutputChannel)" with command "NEW" for record ""
And I set field "nummer" to "6-Kanal"
And I set field "such" to "inaktiv"
And I set field "name" to "Inaktiver Kanal"
Then saving the current editor throws the exception "279"
And I set field "leinh" to "mm"
And I save the current editor

# Kopie anlegen, diese auf aktiv setzen
Given I open an editor "Ausgabekanal" from table "(PrintParameter):(OutputChannel)" with command "COPY" for record "inaktiv"
And I set field "such" to "aktiv"
And I set field "name" to "Aktiver Kanal"
And I set field "aktiv" to "true"
And I set field "drucker" to "datei"
Then field "doislaygen" is not modifiable
And I set field "isdatagen" to "DUMMYDATAGEN.FOP"
And I set field "dgfoppfx" to "DUMMY."
And I save the current editor
And I close the current editor

Scenario: Ausgabekanal - noch ein Kanal mit anderem DG-FOP-Gen, aber gleichem DGFOP-Praefix

Given I open an editor "Ausgabekanal" from table "(PrintParameter):(OutputChannel)" with command "COPY" for record "aktiv"
And I set field "such" to "a2ktiv"
And I set field "isdatagen" to "DUMMYDATAGEN2.FOP"
And I set field "isdatagen" to ""
And I set field "dgfoppfx" to "DUMM2."
And I save the current editor
And I close the current editor

Scenario: Ausgabekanal - Pruefen der Feldsperren

Given I open an editor "Ausgabekanal" from table "(PrintParameter):(OutputChannel)" with command "NEW" for record ""
Then field "layext" is not modifiable
And I set field "hatlayout" to "true"
Then field "layext" is modifiable
Then field "laynichtpruefen" is not modifiable
And I set field "laycomp" to "java:de.abas.erp.print.exceloo.DefaultLayoutFactory@de.abas.erp.print.EXCELOO"
Then field "laynichtpruefen" is modifiable
Then field "doislaygen" is not modifiable
And I set field "islaygen" to "java:de.abas.erp.print.exceloo.DefaultLayoutFactory@de.abas.erp.print.EXCELOO"
Then field "islaygen" is modifiable
And I close the current editor

Scenario: Ausgabekanal - Speichern eines Ausgabekanals

Given I open an editor "Ausgabekanal" from table "(PrintParameter):(OutputChannel)" with command "COPY" for record "JASPERREPORTS"
And saving the current editor throws the exception "4364"
And I close the current editor

Scenario: Spooler

Given I open an editor "Spooler" from table "(PrintParameter):(Spooler)" with command "NEW" for record ""
And I set field "nummer" to "5-Spooler"
And I set field "such" to "dummy-aktiv"
And I set field "name" to "Dummy-Spooler Test"
And I set field "kanal" to "XMLPRINT"
 And I create a new row at the end of the table
And I save the current editor
And I close the current editor

Given I open an editor "Spooler" from table "(PrintParameter):(Spooler)" with command "NEW" for record ""
And I set field "such" to "dummy-inaktiv"
And I set field "name" to "Dummy-Spooler Test"
And I set field "kanal" to "inaktiv"
And I save the current editor

Scenario: Spooler - doppelte Drucker

Given I open an editor "Spooler" from table "(PrintParameter):(Spooler)" with command "NEW" for record ""
And I set field "such" to "sp-test"
And I set field "kanal" to "jasperreports"
And I save the current editor

Given I open an editor "Spooler" from table "(PrintParameter):(Spooler)" with command "UPDATE" for record "sp-test"
And I set field "nummer" to "99sp-test"
And I set field "datdrucker" to "datei"
Then saving the current editor throws the exception "5733"
And I set field "datdrucker" to ""
Then setting field "datdrucker" to "bildschirm" throws the exception "6277"
And I set field "kanal" to "XMLPRINT"
And I set field "datdrucker" to ""
And I create a new row at the end of the table
And I set field "spdrucker" to "bildschirm" in row 1
Then saving the current editor throws the exception "5733"
And I set field "spdrucker" to "datei" in row 1
Then saving the current editor throws the exception "5733"

Scenario: Layouts - Infosystem-Layout

Given I open an editor "Layout" from table "(PrintParameter):(Layout)" with command "NEW" for record ""
And I set field "nummer" to "08154711"
And I set field "such" to "is-test1"
And I set field "name" to "Testlayout f?r Infosystem"
Then saving the current editor throws the exception "279"
And I set field "kanal" to "XMLPRINT"
And I set field "kontext" to "v v-00-01"
And I set field "laytyp" to "(105)"
Then saving the current editor throws the exception "10927"
And I set field "kontext" to "i test1"
And I set field "layname" to "istest1.apl"
And setting field "laygenfop" to "blabla" throws the exception "131"
And I press button "bulayedit"
And I save the current editor

Scenario: Layouts - manuelles jasper-Layout

Given I open an editor "Layout" from table "(PrintParameter):(Layout)" with command "NEW" for record ""
And I set field "nummer" to "08154712"
And I set field "such" to "is-test2"
And I set field "name" to "Testlayout f?r Infosystem"
And I set field "laytyp" to "(105)"
And I set field "kontext" to "i test1"
And I set field "kanal" to "jasper"
And I set field "layname" to "jasper/layout/test1-man1.jrxml"
And I set field "datagenfop" to "is/XML.ISTEST1.INDIV"
And I set field "layname" to "jasper/layout/test1-man1.jrxml"
And I save the current editor

Given I open an editor "Layout" from table "(PrintParameter):(Layout)" with command "COPY" for record "is-test2"
And I set field "nummer" to "08154713"
And I set field "layname" to "jasper/layout/jasper/layout/test1-man2.jrxml"
And I save the current editor

Scenario: Layouts - Hardcopy

Given I open an editor "Layout" from table "(PrintParameter):(Layout)" with command "NEW" for record ""
And I set field "such" to "hc-test1"
And I set field "name" to "Hardcopy-Testlayout"
And I set field "laytyp" to "(104)"
And I set field "kanal" to "XMLPRINT"
And I set field "drucker" to "testdrucker"
And I set field "layname" to "hc1.apl"
Then saving the current editor throws the exception "279"
And I set field "kontext" to "V-00-01"
And I set field "maske" to "mask.0"
And I set field "layname" to "hc1.apl"
And I save the current editor

Scenario: Layouts - Freies Layout

Given I open an editor "Layout" from table "(PrintParameter):(Layout)" with command "NEW" for record ""
And I set field "such" to "frei-test1"
And I set field "name" to "Freies Testlayout"
And I set field "laytyp" to "(102)"
And I set field "kanal" to "XMLPRINT"
And I set field "drucker" to "datei"
And I set field "layname" to "frei1.apl"
Then saving the current editor throws the exception "279"
And I set field "kontext" to "V-00-01"
And I save the current editor

Scenario: Layouts - Universelle Layouts

Given I open an editor "Layout" from table "(PrintParameter):(Layout)" with command "NEW" for record ""
And I set field "such" to "is-test-univ"
And I set field "name" to "Universelles Testlayout f?r Infosystem"
And I set field "laytyp" to "(73)"
And I set field "kanal" to "XMLPRINT"
And I set field "layname" to "univ-is.apl"
And I set field "kontext" to "V-00-01"
And I set field "laytyp" to "(73)"
Then saving the current editor throws the exception "7808"
And I set field "kontext" to ""
And I save the current editor

Given I open an editor "Layout" from table "(PrintParameter):(Layout)" with command "NEW" for record ""
And I set field "such" to "hc-test-univ"
And I set field "name" to "Universelles Testlayout f?r Hardcopy"
And I set field "laytyp" to "(72)"
And I set field "kanal" to "XMLPRINT"
And I set field "layname" to "univ-hc.apl"
And I save the current editor

Scenario: Layouts - Layout mit Kontext

Given I open an editor "Layout" from table "(PrintParameter):(Layout)" with command "NEW" for record ""
And I set field "such" to "frei-test2"
And I set field "name" to "Freies Testlayout"
And I set field "laytyp" to "(102)"
And I set field "kanal" to "XMLPRINT"
And I set field "layname" to "frei2.apl"
Then saving the current editor throws the exception "279"
And I set field "kontext" to "V-00-01"
And I save the current editor

Scenario: Sammellayout

Given I open an editor "Sammellayout" from table "(PrintParameter):(CollectiveLayout)" with command "NEW" for record ""
And I set field "nummer" to "99abc"
And I set field "such" to "sammel1"
And I set field "kontext" to "v-00-01"
And I set field "preprint" to "abc/xyz"
And I set field "preprint" to "st/xyz"
And I set field "postprint" to "abc/xyz"
And I set field "postprint" to "st/xyz"
And I set field "postprint" to ""
And I create a new row at the end of the table
And setting field "tlayout" to "isjasistest1" in row 1 throws the exception "1361"
Then saving the current editor throws the exception "279"
And I set field "kanal" to "jasperreports"
Then saving the current editor throws the exception "11068"
And setting field "isaufruf" to "apsammel2" in row 1 throws the exception "1361"
Then saving the current editor throws the exception "11068"
And I set field "isaufruf" to "apsammel1" in row 1
Then saving the current editor throws the exception "11068"
And I close the current editor

Given I open an editor "Sammellayout" from table "(PrintParameter):(CollectiveLayout)" with command "NEW" for record ""
And I set field "such" to "sammel2"
And I set field "kanal" to "jasperreports"
And I set field "kontext" to "v-03-24"
And I create a new row at the end of the table
And I set field "tlayout" to "18012" in row 1
And I set field "isaufruf" to "vkre" in row 1
And I set field "persist" to "false"
Then saving the current editor throws the exception "7514"
And I set field "persist" to "true"
And I save the current editor

Scenario: Sammellayout - Leeren Tabelle
Given I open an editor "Sammellayout" from table "(PrintParameter):(CollectiveLayout)" with command "NEW" for record ""
And I set field "such" to "sammel"
And I create a new row at the end of the table
And I set field "tlayout" to "xml.masken.p" in row 1
And I delete all rows
Then saving the current editor throws the exception "11068"

Scenario: Parameterlayout

Given I open an editor "Parameterlayout" from table "(PrintParameter):(ParameterLayout)" with command "NEW" for record ""
And I set field "such" to "param1"
And I set field "kanal" to "jasperreports"
Then saving the current editor throws the exception "10179"
And I set field "sublayout" to "param"
Then field "subkontext" has value "I BKOPF"
And I set field "kontext" to "I BKOPF"
And I set field "persist" to "false"
Then saving the current editor throws the exception "7514"
And I set field "persist" to "true"
And I save the current editor


Scenario: Drucker - vonseite oder bisseite bei eingetragenem Schacht aendern

Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "VIEW" for record "1"
And I press button "budruck" to open a subeditor for "Druckdialog"
And I set field "drucker" to "testdrucker"
And I set field "schacht" to "schacht1"
And I set field "vonseite" to "1"
And I close the current editor
And I switch the current editor to editor "Kunde"
And I close the current editor
