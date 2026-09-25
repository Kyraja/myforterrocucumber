# *****************************************************************************
#  Name             : jedi2_transaktionen.feature
#  Autor            : dsch
#  Verantwortlich   : tkellermann
#  Kontrolle        : 
#  Funktion         : Test von Transkationen in dem Modul de.abas.jedi2.JEdi
#
# *****************************************************************************

Feature: IN72_JEDI2_Transaktionen

#####################################################################################################################
# Aufruf von JEdi2 <(Text)> de.abas.edi2.JEdi.java -id XXXX ...<(View)>
# Scenario 01: normaler Durchlauf von JEdi2. Eine zweite EDP-Session wird verwendet.
#####################################################################################################################

Scenario: 01callJEdi2
Given I execute FOP "de.abas.edi2.JEdi.java -id 100025 -execindex 1 -xmlfile entegraPart.xml -suppressloglevel -jedplogging"
Given I execute FOP "FOP.AUFRUF.EDPIMPORT1"
Given I open an editor "editor530" from table "(EDI):(EDI)" with command "VIEW" for search criteria "$,,@ordnung=nummer;@richtung=rueckwaerts;@maxtreffer=1"
Then field "such" has value "AIPDMPART"
Then field "status" has value "2"
Then field "fcode" has value "0"
Then field "ediimex" has value "IM"
Then field "abmodell" has value "100025"

#####################################################################################################################
# Scenario 02: im ersten Durchlauf des Abbildungsmodelles wird die EDI-Nachricht gespeichert obwohl ein Fehler
#              vorkommt. Hier wird die cloned EDP-Session verwendet. Danach wird die EDI-Nachricht ueber die
#              normale EDP-Session auf Status Fehler gesetzt.
#####################################################################################################################
Scenario: 02storeOnError
Then executing FOP "de.abas.edi2.JEdi.java -id 100025 -execindex 2 -xmlfile entegraPart.xml -suppressloglevel -methodsdir methods2" throws the exception "Der Vorgang konnte nicht oder nur unvoll.*"
Given I open an editor "editor530s02" from table "(EDI):(EDI)" with command "VIEW" for search criteria "$,,@ordnung=nummer;@richtung=rueckwaerts;@maxtreffer=1"
Then field "such" has value "AIPDMPART"
Then field "status" has value "4"
Then field "fcode" has value "1"
Then field "ediimex" has value "IM"
Then field "abmodell" has value "100025"
Then field "ftext" has value "Test for EdiMethodException"
And I close the current editor

#####################################################################################################################
# Scenario 03: im ersten Durchlauf des Abbildungsmodelles wird der Artikel ENTEGRA_ARTIKEL neu angelegt.
#              Ein Fehler erscheint beim Update der EDI-Nachricht. Damit wird ein Rollback ausgefuehrt.
#              Der Artikel ist nicht mehr vorhanden. Danach wird die EDI-Nachricht ueber die
#              normale EDP-Session auf Status Fehler gesetzt.
#####################################################################################################################
Scenario: 03rollback
Then executing FOP "de.abas.edi2.JEdi.java -id 100169 -edidbid $,,status=2;@ordnung=nummer;@richtung=rueckwaerts;@maxtreffer=1 -suppressloglevel -methodsdir methods2" throws the exception "Der Vorgang konnte nicht oder nur unvoll.*"
# Artikel ENTEGRA darf nicht existieren
Then opening an editor from table "(Part):(Product)" with command "VIEW" for record "$,,such/ENTEGRA" throws the exception "1582"
# EDI-Nachricht hat Fehler Status
Given I switch the current editor to editor "editor530" with command "VIEW"
Then field "such" has value "AIPDMPART"
Then field "status" has value "4"
Then field "fcode" has value "1"
Then field "ediimex" has value "IM"
Then field "abmodell" has value "100025"
Then field "ftext" has value "ERROR_MESSAGE Cat=ERROR No=25: FOP.137.BUPDMREQ: Datei nicht gefunden"
And I close the current editor
# hier wird protokolliert, dass der Artikel ENTEGRA gespeichert wurde
Given I execute FOP "FOP.AUFRUF.EDPIMPORT2"

