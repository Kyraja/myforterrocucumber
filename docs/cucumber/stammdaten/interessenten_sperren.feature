# *****************************************************************************
#  Name           : interessenten_mit_sperren.feature
#  Autor          : foe
#  Verantwortlich : teampss
#  Funktion       : Stammdatentest zu Interessenten,
#                   Interessentenkontakte und
#                   Interessentenwandlung mit Sperren
#
# *****************************************************************************
#
@persistent
Feature: Interessenten mit Sperren
Background:
Given I set the fake date to "05.01.1995"

# ----------------------------------------------------------------------------------------------
Scenario Outline: Weitere Interessenten anlegen
# ----------------------------------------------------------------------------------------------

Given I open an editor "interessent" from table "(Customer):(Prospect)" with command "NEW" for record ""
And I set fields
   | nummer      | <nummer>     |
   | such        | <such>       |
   | reempf      | <reempf>     |
   | name        | <name>       |
   | ans         | <name>       |
   | str         | <str>        |
   | plz         | <plz>        |
   | nort        | <nort>       |
   | staat       | DEUTSCHLAND  |
   | email       | <email>      |
   | ftext       | <ftext>      |
   | ftext2      | <ftext2>     |
And I save the current editor

Examples:
| nummer | such     | reempf      | name            | str               | plz   | nort      | email                       | ftext                  | ftext2                    |
| 1001   | MUELLER  | !dontChange | Anna Mueller    | Schlossstrasse 12 | 76131 | Karlsruhe | anna.mueller@gmail.com      | Amor vincit omnia.     | Semper fidelis.           |
| 1002   | MEYER    | 1001        | Frank Meyer     | Bahnhofstrasse 9  | 60329 | Frankfurt | frank.meyer@gmx.de          | Carpe diem!            | Per aspera ad astra.      |
| 1011   | SCHMIDT  | !dontChange | Bernd Schmidt   | Hauptstrasse 45   | 10115 | Berlin    | bernd.schmidt@web.de        | Veni, vidi, vici.      | Sic transit gloria mundi. |
| 1012   | FISCHER  | 1011        | Gisela Fischer  | Gartenstrasse 18  | 70174 | Stuttgart | gisela.fischer@freenet.de   | In vino veritas.       | Non ducor, duco.          |
| 1021   | WEBER    | !dontChange | Claudia Weber   | Mozartweg 7       | 80333 | Muenchen  | claudia.weber@yahoo.com     | Alea iacta est.        | Memento mori.             |
| 1022   | BECKER   | 1021        | Hans Becker     | Goetheplatz 4     | 04109 | Leipzig   | hans.becker@icloud.com      | Cogito ergo sum.       | Dum spiro, spero.         |

# ----------------------------------------------------------------------------------------------
Scenario Outline: Weitere Interessentenkontakte anlegen
# ----------------------------------------------------------------------------------------------

Given I open an editor "interessentenkontakt" from table "(Customer):(ProspectContact)" with command "NEW" for record ""
And I set fields
   | nummer      | <nummer>     |
   | such        | <such>       |
   | firma       | <firma>      |
   | name        | <name>       |
   | ans         | <name>       |
   | str         | <str>        |
   | plz         | <plz>        |
   | nort        | <nort>       |
   | staat       | DEUTSCHLAND  |
   | email       | <email>      |
   | ftext       | <ftext>      |
   | ftext2      | <ftext2>     |
And I save the current editor

Examples:
| nummer | such     | firma | name             | str                   | plz   | nort       | email                       | ftext                          | ftext2                        |
| 1003   | MUELLER  | 1001  | Katja Mueller    | Bergstrasse 10        | 69115 | Heidelberg | katja.mueller@zoho.com      | Amor patriae nostra lex.       | Felix culpa.                  |
| 1004   | MEYER    | 1002  | Ralf Meyer       | Beethovenstrasse 17   | 04107 | Leipzig    | ralf.meyer@yandex.com       | Ars longa, vita brevis.        | Labor omnia vincit.           |
| 1005   | MUELLER  | 1001  | Anja Mueller     | Bahnhofstrasse 2      | 01069 | Dresden    | anja.mueller@tutanota.com   | Acta non verba.                | Ora et labora.                |
| 1006   | MEYER    | 1002  | Felix Meyer      | Kurfuerstendamm 18    | 10719 | Berlin     | felix.meyer@terra.com.br    | Bona fide.                     | Pax vobiscum.                 |
| 1013   | SCHMIDT  | 1011  | Lars Schmidt     | Friedensstrasse 8     | 14467 | Potsdam    | lars.schmidt@protonmail.com | De facto.                      | Sapere aude.                  |
| 1014   | FISCHER  | 1012  | Sabine Fischer   | Blumenstrasse 22      | 68159 | Mannheim   | sabine.fischer@lycos.com    | Ex nihilo nihil fit.           | Veni, vidi, amavi.            |
| 1015   | SCHMIDT  | 1011  | Ben Schmidt      | Muensterplatz 6       | 79098 | Freiburg   | ben.schmidt@inbox.com       | Homo homini lupus.             | Vita sine libris mors.        |
| 1016   | FISCHER  | 1012  | Gabriele Fischer | Maximilianstrasse 21  | 80539 | Muenchen   | gabriele.fischer@uol.com.br | In loco parentis.              | Amicitia eterna.              |
| 1023   | WEBER    | 1021  | Maria Weber      | Schillerstrasse 14    | 90409 | Nuernberg  | maria.weber@hushmail.com    | Ipsa scientia potestas est.    | Cave canem.                   |
| 1024   | BECKER   | 1022  | Thomas Becker    | Schoenhauser Allee 33 | 10435 | Berlin     | thomas.becker@me.com        | Morituri te salutant.          | Dulce bellum inexpertis.      |

# ----------------------------------------------------------------------------------------------
Scenario Outline: Vorgaenge zu Interessenten/Interessenkontakte
# ----------------------------------------------------------------------------------------------

Given I open an editor "vorgang" from table "(Sales):(<gruppe>)" with command "NEW" for record ""
And I set fields
	| nummer      | <nummer>     |
	| kunde       | <kunde>      |
	| kl2         | <kunde2>     |
	| warenempf   | <kunde3>     |
	| such        | <such>       |

And I append rows
	| artikel | mge |
	| v1	  |  1  |
And I save the current editor

Examples:
| gruppe 	  | nummer | such  | kunde | kunde2 | kunde3 |
| Opportunity | 710001 | CH1   | 1001  | 1001   | 1001   |
| Opportunity | 710002 | CH2   | 1001  | 1001   | 1001   |
| Opportunity | 710003 | CH3   | 1     | 1001   | 1001   |
| Quotation   | 110001 | AN1   | 1001  | 1001   | 1001   |
| Quotation   | 110002 | AN2   | 1012  | 1011   | 1012   |
| Quotation   | 110003 | AN3   | 1     | 1001   | 1001   |
| WebOrder    | 810001 | WA1   | 1021  | 1021   | 1021   |
| WebOrder    | 810002 | WA2   | 1021  | 1021   | 1022   |
| WebOrder    | 810003 | WA3   | 1     | 1001   | 1001   |

# ----------------------------------------------------------------------------------------------
Scenario: Ursache für Serviceanfrage erstellen
# ----------------------------------------------------------------------------------------------

Given I open an editor "Serviceanfrage" from table "(ServiceRequest):(ServiceRequestCause)" with command "NEW" for record ""
And I set field "such" to "URSACHE1"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario Outline: Serviceanfrage zu Interessenten und Interessenkontakte anlegen
# ----------------------------------------------------------------------------------------------

Given I open an editor "Serviceanfrage" from table "(ServiceRequest):(ServiceRequest)" with command "NEW" for record ""
And I set fields
	| such 	     | <such>    |
	| ursache    | <ursache> |
	| rman1      | <rman1>   |
	| rman2      | <rman2>   |
	| rman3      | <rman3>   |
	| rman4      | <rman4>   |
	| rman5      | <rman5>   |
	| kunde      | <kunde>   |
And I save the current editor

Examples:
	| such  | ursache   | rman1 | rman2 | rman3 | rman4 | rman5 | kunde |
	| SVA1  | URSACHE1  | 1001  | 1001  | 1001  | 1001  | 1001  | 1001  |
	| SVA2  | URSACHE1  | 1003  | 1003  | 1003  | 1003  | 1003  | 1003  |

# ----------------------------------------------------------------------------------------------
#                        AB HIER WERDEN INTERESSENTEN UMGEWANDELT
# ----------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------
Scenario: Interessenten und seine Kontakte ueber TRANSFER-Kommando wandeln
# ----------------------------------------------------------------------------------------------
# Chance sperren
Given I open an editor "chance1" from table "(Sales):(Opportunity)" with command "UPDATE" for record "CH1"

# Benutzersitzung wechseln
Given I'm logged in with password "annette"
# ist jetzt gesperrt -> Sperrdialog erwarten und dann abbrechen
Given I open an editor "TransI" from table "(Customer):(Prospect)" with command "TRANSFER" for record "1001"

# Zurueckwechseln und Chance wieder freigeben
Given I'm logged in with password "sy"
Given I switch the current editor to editor "chance1"
And I set field "bem" to "vor der Wandlung"
And I save the current editor

# Wieder Benutzersitzung wechseln - Jetzt ist Wandlung moeglich
Given I'm logged in with password "annette"
Given I switch the current editor to editor "TransI"
And I respond with answer "Ja" to the dialog with id "8994"
And I save the current editor

# In der Chance wurde nun der Kunde eingetragen
Given I open an editor "chance1" from table "(Sales):(Opportunity)" with command "VIEW" for record "CH1"
Then field "kunde" has value "1001"
Then field "kunde^grbez" has value "Kunde"
Then field "bem" has value "vor der Wandlung"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Interessenten mit Rechungsempfaenger und seine Kontakte ueber TRANSFER-Kommando wandeln
# ----------------------------------------------------------------------------------------------

# Angebot sperren
Given I open an editor "angebot2" from table "(Sales):(Quotation)" with command "UPDATE" for record "AN2"

# Benutzersitzung wechseln
Given I'm logged in with password "annette"
Given I open an editor "interessmitreempf" from table "(Customer):(Prospect)" with command "TRANSFER" for record "1012"

# Zurueckwechseln und Angebot wieder freigeben
Given I'm logged in with password "sy"
Given I switch the current editor to editor "angebot2"
And I set field "bem" to "vor Wandlung"
And I save the current editor

# Wieder Benutzersitzung wechseln - Jetzt ist Wandlung moeglich
Given I'm logged in with password "annette"
Given I switch the current editor to editor "interessmitreempf"
And I respond with answer "Ja" to the dialog with id "8993"
And I save the current editor

# Im Angebot wurde nun der Kunde eingetragen
Given I open an editor "angebot2" from table "(Sales):(Quotation)" with command "VIEW" for record "AN2"
Then field "kunde" has value "1012"
Then field "kunde^grbez" has value "Kunde"
Then field "bem" has value "vor Wandlung"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Interessenten (Rechungsempfaenger eines Interessenten) und seine Kontakte ueber TRANSFER-Kommando wandeln
# ----------------------------------------------------------------------------------------------

# Webauftrag sperren
Given I open an editor "webauftrag2" from table "(Sales):(WebOrder)" with command "UPDATE" for record "WA2"

# Benutzersitzung wechseln
Given I'm logged in with password "annette"
Given I open an editor "interessmitreempf" from table "(Customer):(Prospect)" with command "TRANSFER" for record "1021"

# Zurueckwechseln und Webauftrag wieder freigeben
Given I'm logged in with password "sy"
Given I switch the current editor to editor "webauftrag2"
And I set field "bem" to "vor Wandlung"
And I save the current editor

# Wieder Benutzersitzung wechseln - Jetzt ist Wandlung moeglich
Given I'm logged in with password "annette"
Given I switch the current editor to editor "interessmitreempf"
And I respond with answer "Ja" to the dialog with id "8994"
And I save the current editor

# Im Webauftrag wurde nun der Kunde eingetragen
Given I open an editor "webauftrag2" from table "(Sales):(WebOrder)" with command "VIEW" for record "WA2"
Then field "kunde" has value "1021"
Then field "kunde^grbez" has value "Kunde"
Then field "bem" has value "vor Wandlung"
And I close the current editor
