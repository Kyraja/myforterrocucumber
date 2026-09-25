@persistent
@FP_TEST
Feature: Setzen der PDF-Sicherheitseinstellungen nach Druckertyp

Scenario: Pruefen der Feldsperren im Drucker
Given I open an editor "Drucker" from table "(Infrastructure):(Printer)" with command "NEW" for record ""
#erlaubt
And I set field "druckertyp" to "Datei"
Then field "pdfsich" is modifiable
And I set field "pdfsich" to "true"
Then field "bespassw" is modifiable
Then field "druckerl" is modifiable
Then field "aenderl" is modifiable
Then field "inhkoperl" is modifiable
Then field "anmerl" is modifiable
And I set field "druckertyp" to "Bildschirm"
Then field "pdfsich" is modifiable
And I set field "druckertyp" to "E-Mail Anzeige"
Then field "pdfsich" is modifiable
And I set field "druckertyp" to "E-Mail Versand"
Then field "pdfsich" is modifiable
And I set field "druckertyp" to "SMTP-Server"
Then field "pdfsich" is modifiable
And I set field "druckertyp" to "HTTP-POST"
Then field "pdfsich" is modifiable
#nicht erlaubt
And I set field "druckertyp" to "Drucker"
Then field "pdfsich" is not modifiable
#Then field "bespassw" is not modifiable
#Then field "druckerl" is not modifiable
#Then field "aenderl" is not modifiable
#Then field "inhkoperl" is not modifiable
#Then field "anmerl" is not modifiable
And I set field "druckertyp" to "Arbeitsplatzdrucker"
Then field "pdfsich" is not modifiable
And I set field "druckertyp" to "Standard-Arbeitsplatzdrucker"
Then field "pdfsich" is not modifiable
And I set field "druckertyp" to "Fax"
Then field "pdfsich" is not modifiable

Scenario Outline: Kopieren von Druckern und setzen der PDF-Sicherheitseinstellungen
Given I open an editor "Drucker" from table "(Infrastructure):(Printer)" with command "COPY" for record "<drucker>"
And I set field "such" to "<druckerneu>"
And I set field "pdfsich" to "true"
And I set field "bespassw" to "otto"
And I save the current editor

Examples:
| row | drucker      | druckerneu       |
| 001 | datei        | dateiotto        |
| 002 | bildschirm   | bildschirmotto   |
| 003 | emailprinter | emailotto        |

Scenario Outline: Neue Drucker im Spooler aufnehmen
Given I open an editor "Spooler" from table "(PrintParameter):(Spooler)" with command "UPDATE" for record "<spooler>"
And I create a new row at position 1 
And I set field "spdrucker" to "<druckerneu>" in row 1
And I save the current editor

Examples:
| row | spooler    | druckerneu       |
| 001 | SP-JASPER  | dateiotto        |
| 002 | SP-JASPER  | bildschirmotto   |
| 003 | SP-JASPER  | emailotto        |
| 004 | SP-XMLPRINT| dateiotto        |
| 005 | SP-XMLPRINT| bildschirmotto   |
| 006 | SP-XMLPRINT| emailotto        |

Scenario Outline: Drucken mit  und ohne Verschluesselung
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "VIEW" for record "4718"
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "<layout>"
And I set field "drucker" to "<drucker>"
And I set field "datname" to "<datname>"
And I set field "email" to "<email>"
And I set field "passwort" to "<userpwd>"
And I set field "archiv" to "<archiv>"
And I save the current editor
And I switch the current editor to editor "auftrag"
And I close the current editor

Examples:
| row | layout       | drucker          | datname                         | email                | userpwd     | archiv     |
| 001 | MASTER       | dateiotto        | rmtmp/dateiotto.pdf             | !dontChange          | !dontChange | 0          |
| 002 | MASTER       | bildschirmotto   | rmtmp/bildschirmotto.pdf        | !dontChange          | !dontChange | 0          |
| 003 | MASTER       | emailotto        | rmtmp/emailprinterottokarl.pdf  | devnull@abas.de | karl        | 0          |
| 004 | MASTER       | datei            | rmtmp/dateikarl.pdf             | !dontChange          | karl        | 0          |
| 005 | MASTER       | bildschirm       | rmtmp/bildschirm .pdf           | !dontChange          | !dontChange | 0          |
| 001 | XML.MASKEN.L | dateiotto        | rmtmp/Xdateiotto.pdf            | !dontChange          | !dontChange |!dontChange |
| 002 | XML.MASKEN.L | bildschirmotto   | rmtmp/Xbildschirmottokarl.pdf   | !dontChange          | karl        |!dontChange |
| 004 | XML.MASKEN.L | datei            | rmtmp/Xdateikarl.pdf            | !dontChange          | karl        |!dontChange | 
| 005 | XML.MASKEN.L | bildschirm       | rmtmp/Xbildschirm .pdf          | !dontChange          | !dontChange |!dontChange |

Scenario: Rendernnachfop im Spooler eintragen
Given I open an editor "Spooler" from table "(PrintParameter):(Spooler)" with command "UPDATE" for record "SP-JASPER"
And I set field "rendernachfop" to "RENDERNACH"
And I save the current editor

Scenario Outline: Drucken mit 4und ohne Verschluesselung mit Rendernachfop
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "VIEW" for record "4718"
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "<layout>"
And I set field "drucker" to "<drucker>"
And I set field "datname" to "<datname>"
And I set field "email" to "<email>"
And I set field "passwort" to "<userpwd>"
And I set field "archiv" to "0"
And I set field "anzahl" to "<kopien>"
And I save the current editor
And I switch the current editor to editor "auftrag"
And I close the current editor

Examples:
| row | layout   | drucker          | datname                         | email                | userpwd     | kopien |
| 001 | MASTER   | dateiotto        | rmtmp/dateiotto1.pdf            | !dontChange          | !dontChange | 1      |
| 002 | MASTER   | bildschirmotto   | rmtmp/bildschirmotto2.pdf       | !dontChange          | !dontChange | 2      |
| 003 | MASTER   | emailprinter     | rmtmp/emailprinterkarl1.pdf     | devnull@abas.de | karl        | 1      |
| 004 | MASTER   | bildschirm       | rmtmp/bildschirm2.pdf           | !dontChange          | !dontChange | 2      |

Scenario: PDF-Sicherheitseinstellungen im Drucker entfernen
Given I open an editor "Drucker" from table "(Infrastructure):(Printer)" with command "UPDATE" for record "dateiotto"
And I set field "pdfsich" to "nein"
Then field "bespassw" is empty
Then field "druckerl" has value "nein"
Then field "aenderl" has value "nein"
Then field "inhkoperl" has value "nein"
Then field "anmerl" has value "nein"
