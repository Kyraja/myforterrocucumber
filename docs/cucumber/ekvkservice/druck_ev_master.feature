#@persistent
Feature: Testen von Kopien, Exemplaren und Briefpapier bei Layout Master
Background:
Given I set the fake date to "02.01.1995"
# Given I enable the flag 309

@print:
Scenario: Aktivieren der Konfiguration erech
Given I open an editor "konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "habel" to "1"
And I set field "zugferd" to "1"
And I save the current editor

Scenario: Drucker kopieren - ohne Logo wegen Briefpapier
Given I enable the flag 298
Given I open an editor "drucker" from table "(Infrastructure):(Printer)" with command "COPY" for record "BILDS"
And I set field "briefpapier" to "1"
And I set field "such" to "BRIEF"
And I save the current editor
And I close the current editor

Scenario: Spooler erweitern
Given I open an editor "spooler" from table "(PrintParameter):(Spooler)" with command "UPDATE" for record "15007"
And I create a new row at the end of the table
And I set field "spdrucker" to "BRIEF" in row !lastRow
And I save the current editor
And I close the current editor

Scenario Outline: EDI-Konfiguration ZUGFERD setzen
Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "<nummer>"
And I press button "edinfo" to open a subeditor for "EDIInfo"
And I create a new row at the end of the table
And I set field "edinachraz" to "ZUGFeRD-Rechnung Export" in row 1
And I set field "ieabmodell" to "4150" in row 1
And I set field "erlaubt" to "ja" in row 1
And I save the current editor
And I switch the current editor to editor "Kunde"
And I save the current editor

Examples:
|row  | nummer|
| 001 | 5     |

Scenario Outline: Erstellen von Auftraegen zum Drucken
Given I open an editor "rechnung" from table "<editor>" with command "NEW" for record ""
And I set field "schlag" to "<schlag>"
And I set field "nummer" to "<nummer>"
And I set field "kl" to "<kl>"
And I set field "such" to "<such>"
And I set field "tterm" to "."
And I set field "kopien" to "1"
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "mge" to "5" in row 1
And I set field "preis" to "35,45" in row 1
And I save the current editor

Examples:
| row | editor                       | nummer| such  | schlag                      |kl           |
| 001 | (Sales):(SalesOrder)         | 1520  | A1520 | Auftrag                     | 1           |
| 002 | (Sales):(SalesOrder)         | 1521  | A1521 | Auftrag                     | 1           |
| 003 | (Purchasing):(PurchaseOrder) | 3520  | B3520 | Bestellung                  | 1           |

Scenario Outline: Erstellen von Rechnungen zum Drucken
Given I open an editor "rechnung" from table "<editor>" with command "NEW" for record ""
And I set field "schlag" to "<schlag>"
And I set field "kl" to "<kl>"
And I set field "nummer" to "<nummer>"
And I set field "such" to "<such>"
And I set field "tterm" to "."
And I set field "kopien" to "1"
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "mge" to "5" in row 1
And I set field "preis" to "35,45" in row 1
And I set field "erechok" to "<erechok>"
And I set field "erechmail" to "<erechmail>"
And I set field "ueb" to "<ueb>"
And I respond with answer "Yes" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Examples:
| row | editor            | nummer| such   | schlag                      |kl           | erechok     |erechmail      | ueb         |
| 001 | (Sales):(Invoice) | 2520  | R2520  | Rechnung                    | 1           | !dontChange |!dontChange    | !dontChange |
| 002 | (Sales):(Invoice) | 2522  | R2522  | E-Rechnung                  | 1           | 1           |devnull@abas.de| 1           |
| 003 | (Sales):(Invoice) | 2523  | R2523  | E-Rechnung                  | 1           | 1           |devnull@abas.de| 1           |
| 004 | (Sales):(Invoice) | 2524  | R2524  | E-Rechnung                  | 1           | 1           |devnull@abas.de| 1           |
| 005 | (Sales):(Invoice) | 2525  | R2525  | ZUGFERD-Rechnung            | 5           | 1           |devnull@abas.de| 1           |
| 006 | (Sales):(Invoice) | 2526  | R2526  | ZUGFERD-Rechnung            | 5           | 1           |devnull@abas.de| 1           |
| 007 | (Sales):(Invoice) | 2527  | R2527  | ZUGFERD-Rechnung            | 5           | 1           |devnull@abas.de| 1           |

Scenario Outline: Drucken der Vorgänge mit Vorschau
Given I open an editor "vorgang" from table "<editor>" with command "VIEW" for record "<such>"
And I print preview for layout "<layout>"
And I close the current editor

Examples:
| row | editor              | such   | layout |
| 001 | (Sales):(SalesOrder)| A1520  | MASTER |
| 002 | (Sales):(Invoice)   | R2520  | MASTER |
| 003 | (Sales):(Invoice)   | +2523  | MASTER |
| 004 | (Sales):(Invoice)   | +2524  | MASTER |
| 005 | (Sales):(Invoice)   | +2525  | MASTER |

Scenario Outline: Drucken der Vorgänge
Given I enable the flag 310
Given I open an editor "vorgang" from table "<editor>" with command "VIEW" for record "<such>"
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "<layout>"
And I set field "drucker" to "<drucker>"
And I set field "anzahl" to "<anzahl>"
And I set field "exemplare" to "<exemplare>"
And I set field "archiv" to "<archiv>"
And I set field "datname" to "<datname>"
And I save the current editor
And I switch the current editor to editor "vorgang"
And I close the current editor
Then file "<datname>" exists
Then PDF file "<datname>" contains <seiten> pages
Then PDF file "<datname>" contains <bilder> images

Examples:
| row | editor                       | such   | layout | drucker       | datname                                   | anzahl      | exemplare   | archiv | seiten | bilder |
| 001 | (Sales):(SalesOrder)         | A1520  | MASTER | DATEI         | rmtmp/out/Auftrag_A1520.pdf               | 2           | 2           | 0      | 4      | 2      |
| 002 | (Sales):(SalesOrder)         | A1520  | MASTER | EMAILPRINTER  | rmtmp/out/Auftrag_A1520.pdf               | !dontChange | !dontChange | 1      | 2      | 1      |
| 003 | (Sales):(SalesOrder)         | A1520  | MASTER | BILDS         | rmtmp/out/Auftrag_A1520.pdf               | 2           | 2           | 0      | 8      | 4      |
| 004 | (Sales):(SalesOrder)         | A1520  | MASTER | BILDS         | rmtmp/out/Auftrag_A1520_a.pdf             | 2           | 2           | 1      | 8      | 4      |
| 005 | (Sales):(SalesOrder)         | A1521  | MASTER | BRIEF         | rmtmp/out/Auftrag_A1521_Brief.pdf         | 1           | 1           | 1      | 2      | 0      |
| 006 | (Sales):(Invoice)            | R2520  | MASTER | BILDS         | rmtmp/out/Rechnung_R2520.pdf              | 2           | 2           | 0      | 8      | 4      |
| 007 | (Sales):(Invoice)            | R2520  | MASTER | BILDS         | rmtmp/out/Rechnung_R2520_a.pdf            | 2           | 2           | 1      | 8      | 4      |
| 008 | (Sales):(Invoice)            | R2520  | MASTER | BRIEF         | rmtmp/out/Rechnung_R2520_Brief.pdf        | 1           | 1           | 1      | 2      | 0      |
| 009 | (Purchasing):(PurchaseOrder) | B3520  | MASTER | BILDS         | rmtmp/out/Bestellung_B3520.pdf            | 2           | 2           | 0      | 4      | 4      |
| 010 | (Purchasing):(PurchaseOrder) | B3520  | MASTER | BILDS         | rmtmp/out/Bestellung_B3520_a.pdf          | 2           | 2           | 1      | 4      | 4      |
| 011 | (Purchasing):(PurchaseOrder) | B3520  | MASTER | BRIEF         | rmtmp/out/Bestellung_B3520_Brief.pdf      | 1           | 1           | 1      | 1      | 0      |

Scenario Outline: Drucken der Vorgänge ERechnung und ZUGFeRD
Given I open an editor "vorgang" from table "<editor>" with command "VIEW" for record "<such>"
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "<layout>"
And I set field "drucker" to "<drucker>"
And I set field "anzahl" to "<anzahl>"
And I set field "exemplare" to "<exemplare>"
And I set field "archiv" to "<archiv>"
And I set field "datname" to "<datname>"
And I save the current editor
And I switch the current editor to editor "vorgang"
And I close the current editor
Then PDF file "<datname>" contains <seiten> pages
Then PDF file "<datname>" contains <bilder> images

Examples:
| row | editor                       | such   | layout | drucker       | datname                                   | anzahl      | exemplare   | archiv | seiten | bilder |
| 001 | (Sales):(Invoice)            | +2522  | MASTER | BILDS         | rmtmp/out/ERechnung_R2522.pdf             | 2           | 2           | 0      | 4      | 2      |
| 002 | (Sales):(Invoice)            | +2523  | MASTER | BILDS         | rmtmp/out/ERechnung_R2523_a.pdf           | 2           | 2           | 1      | 4      | 2      |
| 003 | (Sales):(Invoice)            | +2524  | MASTER | BRIEF         | rmtmp/out/ERechnung_R2524_Brief.pdf       | 1           | 1           | 1      | 2      | 0      |
| 004 | (Sales):(Invoice)            | +2525  | MASTER | BILDS         | rmtmp/out/ZUGFERDRechnung_R2525.pdf       | 2           | 2           | 0      | 2      | 2      |
| 005 | (Sales):(Invoice)            | +2526  | MASTER | BILDS         | rmtmp/out/ZUGFERDRechnung_R2526_a.pdf     | 2           | 2           | 1      | 2      | 2      |
| 006 | (Sales):(Invoice)            | +2527  | MASTER | BRIEF         | rmtmp/out/ZUGFERDRechnung_R2527_Brief.pdf | 1           | 1           | 1      | 1      | 0      |

Scenario Outline: Druck und Vorschau aus Infosystem mit Fehler
Given I open the infosystem "<infosystem>"
And I set field "<field>" to "<fieldval>"
And I press start
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "<layout>"
And I set field "drucker" to "<drucker>"
And I press button "buvorschau"
And I save the current editor
And I close the current editor
And I close the current editor

Examples:
| row | infosystem  | field        | fieldval | layout   | drucker | error |
| 001 | PRINTQUEUE  | ktransaction | A1520    | EMASTER  | BILDS   | Keine Verkaufsrechnung ausgewählt. |
| 002 | PRINTQUEUE  | ktransaction | A1520    | ZUGFERD2 | BILDS   | Keine Verkaufsrechnung ausgewählt. |
| 003 | PRINTQUEUE  | ktransaction | R2520    | EMASTER  | BILDS   | Die Rechnung ist keine E-Rechnung. |
| 004 | PRINTQUEUE  | ktransaction | R2520    | ZUGFERD2 | BILDS   | Das Abbildungsmodell fehlt im Rechnungsempfänger. |


Scenario Outline: Drucken aus Infosystem
Given I enable the flag 310
Given I open the infosystem "<infosystem>"
And I set field "<field>" to "<fieldval>"
And I press start
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "<layout>"
And I set field "drucker" to "<drucker>"
And I set field "anzahl" to "<anzahl>"
And I set field "exemplare" to "<exemplare>"
And I set field "archiv" to "<archiv>"
And I set field "datname" to "<datname>"
And I save the current editor
And I close the current editor

Examples:
| row | infosystem  | field        | fieldval | layout | drucker | datname                               | anzahl | exemplare | archiv |
| 001 | EVVORGANG   | vorgang      | A1520    | MASTER | BILDS   | rmtmp/out/EVVORGANG_Auftrag1520.pdf   | 2      | 2         | 0      |
| 002 | PRINTQUEUE  | ktransaction | A1520    | MASTER | BILDS   | rmtmp/out/PRINTQUEUE_Auftrag1520.pdf  | 2      | 2         | 0      |

Scenario Outline: E-Mails pruefen
And I find <anzahl> files with content "<content>" and pattern "<pattern>"

Examples:

| row | content    | pattern                                         | anzahl |
| 001 | Message-ID:| myhomedir/abasdms/gedosod/spools/Dragdrop/*.eml | 4      |
| 002 | attachment;| myhomedir/abasdms/gedosod/spools/Dragdrop/*.eml | 4      |
