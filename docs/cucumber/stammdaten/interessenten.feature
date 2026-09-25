# *****************************************************************************
#  Name           : interessenten.feature
#  Autor          : mibr
#  Verantwortlich : teampss
#  Funktion       : Stammdatentest zu Interessenten,
#                   Interessentenkontakte und
#                   Interessentenwandlung
#
# *****************************************************************************
#
@persistent
Feature: Interessenten
Background:
Given I set the fake date to "05.01.1995"
# Given I enable the flag 473
# Mit Flag 473 kann die Protokolldatei iwandlung.txt aktiviert werden

# ----------------------------------------------------------------------------------------------
Scenario: Interessent mit Kontakten anlegen
# ----------------------------------------------------------------------------------------------

# Interessent anlegen
Given I open an editor "Interessent-1" from table "(Customer):(Prospect)" with command "NEW" for record ""
And I set fields
	| such     | inter1                |
	| name     | Testinteressent       |
	| ans      | Interessent 1         |
	| ans2     | Interessent 1;Versand |
	| str      | Interstr. 7           |
	| str2     | Am Interversand 12    |
	| plz      | 76139                 |
	| plz2     | 76131                 |
	| nort     | Karlsruhe             |
	| nort2    | Karlsruhe             |
	| region   | baden                 |
	| region2  | baden                 |
	| anrede   | AHERR                 |
	| kontakt  | Inter                 |
	| tele     | 0721 / 123456         |
	| mtele    | 0171 / 654321         |
	| email    | meier@inter.de        |
	| vertret  | 4                     |
	| betreuer | 7802                  |
Then field "waehr" is not empty
Then field "liwaehr" is not empty
And I save the current editor

# Sachbearbeiter 1 zu Interessent anlegen
Given I open an editor "Interessentenkontakt1" from table "(Customer):(ProspectContact)" with command "NEW" for record ""
And I set fields
	| firma   | inter1                   |
	| such    | INTSB1                   |
	| name    | Testinteressent SB1      |
	| ans     | Interessent 1;Hr. Anton  |
	| anrede  | AHERR                    |
	| kontakt | Anton                    |
And I save the current editor

# Sachbearbeiter 2 zu Interessent anlegen
Given I open an editor "Interessentenkontakt2" from table "(Customer):(ProspectContact)" with command "COPY" for record "intsb1"
And I set fields
	| such    | INTSB2                  |
	| name    | Testinteressent SB2     |
	| ans     | Interessent 1;Hr. Bert  |
	| kontakt | Bert                    |
	| ans2    | Hr. Bert                |
	| str2    | Im Interesse 2          |
	| plz2    | 72135                   |
	| nort2   | Karlsruhe               |
And I save the current editor

# Fibukontakt fuer Interessent-1 auf INTSB2 setzen
Given I open an editor "Interessent-1fibuk" from table "(Customer):(Prospect)" with command "UPDATE" for record from editor "Interessent-1"
And I set fields
	| fibukontakt   | INTSB2     |
And I save the current editor

# Interessent Wandle anlegen
Given I open an editor "Interessent-4" from table "(Customer):(Prospect)" with command "NEW" for record ""
And I set fields
	| such     | wandle                |
	| name     | Wandle                |
	| ans      | Wandle 1              |
	| ans2     | Wandle 2;Versand      |
	| str      | Wandlestr. 2          |
	| str2     | Am Wandelversand 122  |
	| plz      | 76133                 |
	| plz2     | 76131                 |
	| nort     | Karlsruhe             |
	| nort2    | Karlsruhe             |
	| region   | baden                 |
	| region2  | baden                 |
	| anrede   | AHERR                 |
	| kontakt  | Inter1                |
	| tele     | 0721 / 123456         |
	| mtele    | 0171 / 654321         |
	| email    | meier@wandle.de       |
	| vertret  | 4                     |
	| betreuer | 7802                  |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Interessent loeschen
# ----------------------------------------------------------------------------------------------

Given I open an editor "InteressentLoeschen" from table "(Customer):(ProspectContact)" with command "DELETE" for record "INTSB1"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Interessent zu Kunden wandeln
# ----------------------------------------------------------------------------------------------

Given I open an editor "InteressentWandeln" from table "(Customer):(Prospect)" with command "TRANSFER" for record "INTER1"
And I respond with answer "Ja" to the dialog with id "8994"
And I save the current editor

# Fehler erwartet "nicht gefunden" : abgelegter Interessenten-Sachbearbeiter wurde gewandelt
Then opening an editor from table "(Customer):(ProspectContact)" with command "VIEW" for search criteria "$,,firma=INTER1;@gruppe=7;@ablageart=abgelegt" throws the exception "149"

# Hier sollte etwas gefunden werden
Given I open an editor "" from table "(Customer):(CustomerContact)" with command "VIEW" for search criteria "$,,firma=INTER1;@gruppe=2;@ablageart=lebendig"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Interessent darf nicht gleichzeitig Rechnungsempfaenger sein
# ----------------------------------------------------------------------------------------------

# 1. Zwei Interessenten anlegen
Given I open an editor "Interessent-6" from table "(Customer):(Prospect)" with command "NEW" for record ""
And I set fields
	| such     | inter2                  |
	| name     | Testinteressent 2       |
	| ans      | Interessent 2           |
	| ans2     | Interessent 2; Versand  |
	| str      | Interstr. 7             |
	| str2     | Am Interversand 12      |
	| plz      | 76139                   |
	| plz2     | 76131                   |
	| nort     | Karlsruhe               |
	| nort2    | Karlsruhe               |
	| region   | baden                   |
	| region2  | baden                   |
	| anrede   | AHERR                   |
	| kontakt  | Inter2                  |
	| tele     | 0721 / 123456           |
	| email    | meier2@inter.de         |
	| vertret  | 4                       |
	| betreuer | 7802                    |
And I save the current editor

Given I open an editor "Interessent-7" from table "(Customer):(Prospect)" with command "NEW" for record ""
And I set fields
	| such     | inter3                  |
	| name     | Testinteressent 3       |
	| ans      | Interessent 3           |
	| ans2     | Interessent 3; Versand  |
	| str      | Interstr. 7             |
	| str2     | Am Interversand 12      |
	| plz      | 76139                   |
	| plz2     | 76131                   |
	| nort     | Karlsruhe               |
	| region   | baden                   |
	| region2  | baden                   |
	| anrede   | AHERR                   |
	| kontakt  | Inter3                  |
	| vertret  | 4                       |
	| betreuer | 7802                    |
And I save the current editor

# 2. Rechnungsempfaengertest
Given I open an editor "Interessent-6.7" from table "(Customer):(Prospect)" with command "UPDATE" for record "inter2"
# Fehler erwartet: Rechnungsempfaenger und Interessent duerfen nicht identisch sein.
Then setting field "reempf" to "inter2" throws the exception "177"
And I set field "reempf" to "inter3"
And I save the current editor

# Testet: Interessent "Wandle" in einen Kunden wandeln.
Given I open an editor "InteressentWandeln2" from table "(Customer):(Prospect)" with command "TRANSFER" for record "wandle"
And I respond with answer "Ja" to the dialog with id "8994"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario Outline: Kunde anlegen
# ----------------------------------------------------------------------------------------------

Given I open an editor "kunde" from table "(Customer):(Customer)" with command "NEW" for record ""
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
And I save the current editor

Examples:
| nummer | such     | reempf      | name             | str              | plz   | nort      | email                      |
| 1201   | BERGER   | !dontChange | Karlheinz Berger | Obere Strasse 12 | 79453 | Nuernberg | karlheinz.berger@gmail.com |

# ----------------------------------------------------------------------------------------------
Scenario Outline: Kundenkontakte anlegen
# ----------------------------------------------------------------------------------------------

Given I open an editor "kundenkontakt" from table "(Customer):(CustomerContact)" with command "NEW" for record ""
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
And I save the current editor

Examples:
| nummer | such     | firma | name             | str                   | plz   | nort       | email                |
| 2201   | BERGER   | 1201  | Yvonne Berger    | Bergstrasse 182       | 79234 | Nuernberg  | yvonne.berger@web.de |

# ----------------------------------------------------------------------------------------------
Scenario: Alle Zahlungsarten im Interessent erlaubt
# ----------------------------------------------------------------------------------------------

# Interessenten anlegen
Given I open an editor "Interessent-8" from table "(Customer):(Prospect)" with command "NEW" for record ""
And I set fields
	| such     | inter4                  |
	| name     | Testinteressent 4       |
	| ans      | Interessent 4           |
	| ans2     | Interessent 4; Versand  |
	| str      | Interstr. 29            |
	| str2     | Am Interversand 1       |
	| plz      | 76139                   |
	| plz2     | 76131                   |
	| nort     | Karlsruhe               |
	| nort2    | Karlsruhe               |
	| region   | baden                   |
	| region2  | baden                   |
	| anrede   | AHERR                   |
	| kontakt  | inter4                  |
	| tele     | 0721 / 765432           |
	| email    | bergmann@inter.de       |
	| vertret  | 4                       |
	| betreuer | 7802                    |
And I save the current editor

# Zahlungsart in Interessent aendern
Given I open an editor "Interessent-8b" from table "(Customer):(Prospect)" with command "UPDATE" for record from editor "Interessent-8"
# Alle Zahlungsarten erlaubt
And I set field "zaform" to "Lastschrift"
And I set field "zaform" to "Kreditkarte"
And I set field "zaform" to "Nachnahme"
And I set field "zaform" to "Barzahlung"
And I set field "zaform" to "Vorkasse"
And I save the current editor

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
   | ykaesesorte | <kaesesorte> |
   | ftext       | <ftext>      |
   | ftext2      | <ftext2>     |
And I save the current editor

Examples:
| row | nummer | such     | reempf      | name            | str               | plz   | nort      | email                       | kaesesorte | ftext                  | ftext2                    |
|   1 | 1001   | MUELLER  | !dontChange | Anna Mueller    | Schlossstrasse 12 | 76131 | Karlsruhe | anna.mueller@gmail.com      | Gouda      | Amor vincit omnia.     | Semper fidelis.           |
|   2 | 1002   | MEYER    | 1001        | Frank Meyer     | Bahnhofstrasse 9  | 60329 | Frankfurt | frank.meyer@gmx.de          | Mozzarella | Carpe diem!            | Per aspera ad astra.      |
|   3 | 1011   | SCHMIDT  | !dontChange | Bernd Schmidt   | Hauptstrasse 45   | 10115 | Berlin    | bernd.schmidt@web.de        | Camembert  | Veni, vidi, vici.      | Sic transit gloria mundi. |
|   4 | 1012   | FISCHER  | 1011        | Gisela Fischer  | Gartenstrasse 18  | 70174 | Stuttgart | gisela.fischer@freenet.de   | Parmesan   | In vino veritas.       | Non ducor, duco.          |
|   5 | 1021   | WEBER    | !dontChange | Claudia Weber   | Mozartweg 7       | 80333 | Muenchen  | claudia.weber@yahoo.com     | Emmentaler | Alea iacta est.        | Memento mori.             |
|   6 | 1022   | BECKER   | 1021        | Hans Becker     | Goetheplatz 4     | 04109 | Leipzig   | hans.becker@icloud.com      | Feta       | Cogito ergo sum.       | Dum spiro, spero.         |
|   7 | 1031   | SCHNEIDE | !dontChange | David Schneider | Rheinufer 3       | 50667 | Koeln     | david.schneider@outlook.com | Brie       | Audere est facere.     | Ad astra per aspera.      |
|   8 | 1032   | WAGNER   | 1031        | Ingrid Wagner   | Marktstrasse 6    | 01067 | Dresden   | ingrid.wagner@arcor.de      | Cheddar    | Lux et veritas.        | Vincit qui se vincit.     |
|   9 | 1041   | KLEIN    | !dontChange | Eva Klein       | Lindenallee 21    | 30159 | Hannover  | eva.klein@t-online.de       | Edamer     | Tempus fugit.          | Audentes fortuna iuvat.   |
|  10 | 1042   | WOLF     | 1041        | Juergen Wolf    | Kirchplatz 15     | 28195 | Bremen    | juergen.wolf@posteo.de      | Roquefort  | Veritas vos liberabit. | Fortes fortuna adiuvat.   |
|  11 | 1051   | KELLER   | !dontChange | Patrick Keller  | Eisenbahnstr. 7   | 77815 | Buehl     | patrick.keller@yahoo.de     | Mozzarella | Veritas vos liberabit. | Fortes fortuna adiuvat.   |
|  12 | 1061   | WERNER   | 1051        | Rieke Werner    | Lindenstr. 9      | 67165 | Waldsee   | rieke.werner@gmail.com      | Tomme      | Alea iacta est.        | Fortes fortuna adiuvat.   |
|  13 | 1100   | MUELLER  | !dontChange | Lena Mueller    | Am Park 4         | 76133 | Karlsruhe | lena.mueller@copilot.com    | Cambozola  | !dontChange            | !dontChange               |
|  14 | 1110   | GROSS    | BERGER      | Lisa Gross      | Schillerstrasse 41| 76135 | Karlsruhe | lisa.gross@t-online.de      | Gorgonzola | !dontChange            | !dontChange               |
|  15 | 1120   | SCHUSTER | !dontChange | Bernd Schuster  | Schustergasse 1   | 76133 | Karlsruhe | bernd.schuster@t-online.de  | Brie       | !dontChange            | !dontChange               |
|  15 | 1121   | RAUM     | !dontChange | Robert Raum     | Zimmergasse 11    | 33605 | Bielefeld | robert.raum@compuserve.de   | Geramont   | !dontChange            | !dontChange               |

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
   | ykaesesorte | <kaesesorte> |
   | ftext       | <ftext>      |
   | ftext2      | <ftext2>     |
And I save the current editor

Examples:
| nummer | such     | firma | name             | str                   | plz   | nort       | email                       | kaesesorte     | ftext                          | ftext2                        |
| 1003   | MUELLER  | 1001  | Katja Mueller    | Bergstrasse 10        | 69115 | Heidelberg | katja.mueller@zoho.com      | Harzer         | Amor patriae nostra lex.       | Felix culpa.                  |
| 1004   | MEYER    | 1002  | Ralf Meyer       | Beethovenstrasse 17   | 04107 | Leipzig    | ralf.meyer@yandex.com       | Manchego       | Ars longa, vita brevis.        | Labor omnia vincit.           |
| 1005   | MUELLER  | 1001  | Anja Mueller     | Bahnhofstrasse 2      | 01069 | Dresden    | anja.mueller@tutanota.com   | Quark          | Acta non verba.                | Ora et labora.                |
| 1006   | MEYER    | 1002  | Felix Meyer      | Kurfuerstendamm 18    | 10719 | Berlin     | felix.meyer@terra.com.br    | Romadur        | Bona fide.                     | Pax vobiscum.                 |
| 1013   | SCHMIDT  | 1011  | Lars Schmidt     | Friedensstrasse 8     | 14467 | Potsdam    | lars.schmidt@protonmail.com | Limburger      | De facto.                      | Sapere aude.                  |
| 1014   | FISCHER  | 1012  | Sabine Fischer   | Blumenstrasse 22      | 68159 | Mannheim   | sabine.fischer@lycos.com    | Taleggio       | Ex nihilo nihil fit.           | Veni, vidi, amavi.            |
| 1015   | SCHMIDT  | 1011  | Ben Schmidt      | Muensterplatz 6       | 79098 | Freiburg   | ben.schmidt@inbox.com       | Cottage Cheese | Homo homini lupus.             | Vita sine libris mors.        |
| 1016   | FISCHER  | 1012  | Gabriele Fischer | Maximilianstrasse 21  | 80539 | Muenchen   | gabriele.fischer@uol.com.br | Bergkaese      | In loco parentis.              | Amicitia eterna.              |
| 1023   | WEBER    | 1021  | Maria Weber      | Schillerstrasse 14    | 90409 | Nuernberg  | maria.weber@hushmail.com    | Ricotta        | Ipsa scientia potestas est.    | Cave canem.                   |
| 1024   | BECKER   | 1022  | Thomas Becker    | Schoenhauser Allee 33 | 10435 | Berlin     | thomas.becker@me.com        | Pecorino       | Morituri te salutant.          | Dulce bellum inexpertis.      |
| 1025   | WEBER    | 1021  | Carola Weber     | Rathausplatz 9        | 20095 | Hamburg    | carola.weber@ymail.com      | Frischkaese    | Nemo me impune lacessit.       | Errare humanum est.           |
| 1026   | BECKER   | 1022  | Uwe Becker       | Lange Strasse 27      | 70173 | Stuttgart  | uwe.becker@libero.it        | Fontina        | Panem et circenses.            | Festina lente.                |
| 1033   | SCHNEIDE | 1031  | Niklas Schneider | Am See 5              | 78462 | Konstanz   | niklas.schneider@mail.com   | Gorgonzola     | Quis custodiet ipsos custodes? | Homo sum, humani nihil.       |
| 1034   | WAGNER   | 1032  | Ulrike Wagner    | Koenigsplatz 1        | 86150 | Augsburg   | ulrike.wagner@live.com      | Halloumi       | Si vis pacem, para bellum.     | Ignis aurum probat.           |
| 1035   | SCHNEIDE | 1031  | Daniel Schneider | Leipziger Strasse 12  | 10117 | Berlin     | daniel.schneider@aim.com    | Butterkaese    | Status quo.                    | Lupus in fabula.              |
| 1036   | WAGNER   | 1032  | Vera Wagner      | Am Hauptbahnhof 3     | 60329 | Frankfurt  | vera.wagner@alice.it        | Asiago         | Tempora mutantur.              | Natura non contristatur.      |
| 1043   | KLEIN    | 1041  | Petra Klein      | Waldweg 11            | 53113 | Bonn       | petra.klein@fastmail.com    | Mascarpone     | Terra incognita.               | Omnia vincit amor.            |
| 1044   | WOLF     | 1042  | Volker Wolf      | Breite Strasse 44     | 50667 | Koeln      | volker.wolf@msn.com         | Grana Padano   | Ultima Thule.                  | Qui tacet consentire videtur. |
| 1045   | KLEIN    | 1041  | Elke Klein       | Am Markt 15           | 28195 | Bremen     | elke.klein@bol.com.br       | Tilsiter       | Vox populi, vox Dei.           | Roma locuta, causa finita.    |
| 1046   | WOLF     | 1042  | Wilfried Wolf    | Kaiserstrasse 36      | 90403 | Nuernberg  | wilfried.wolf@virgilio.it   | Gorgonzola     | Vivere est cogitare.           | Verba volant, scripta manent. |

| 1052   | SPEICHER | 1051  | Sigmund Speicher | Mozartstrasse 44      | 76185 | Karlsruhe  | sigmund.speicher@now.it     | Maasdammer     | Vivere est cogitare.           | Verba volant, scripta manent. |
| 1062   | KLEIN    | 1061  | Simone Klein     | Wiesenweg 16          | 76043 | Stutensee  | simone.klein@web.de         | Edamer         | Quod era demonstratum.         | Romae non per diem.           |


| 1200   | SCHMIDT  | 1100  | Max Schmidt      | Lindenstrasse 13      | 50674 | Koeln      | max.schmidt@copilot.com     | Appenzeller    | !dontChange                    | !dontChange                   |

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
| Opportunity | 710004 | CH4   | 1051  | 1051   | 1051   |
| Quotation   | 110001 | AN1   | 1001  | 1001   | 1001   |
| Quotation   | 110002 | AN2   | 1001  | 1001   | 1001   |
| Quotation   | 110003 | AN3   | 1     | 1001   | 1001   |
| Quotation   | 110004 | AN4   | 1051  | 1051   | 1051   |
| WebOrder    | 810001 | WA1   | 1001  | 1001   | 1001   |
| WebOrder    | 810002 | WA2   | 1001  | 1001   | 1001   |
| WebOrder    | 810003 | WA3   | 1     | 1001   | 1001   |
| WebOrder    | 810004 | WA4   | 1052  | 1      | 1052   |


# ----------------------------------------------------------------------------------------------
Scenario: Jeden zweiten Vorgang ablegen
# ----------------------------------------------------------------------------------------------

Given I open an editor "vorgang" from table "(Sales):(Opportunity)" with command "UPDATE" for record "CH2"
And I set field "tterm" to ""
And I save the current editor

Given I open an editor "vorgang" from table "(Sales):(Quotation)" with command "UPDATE" for record "AN2"
And I set field "tterm" to ""
And I save the current editor

Given I open an editor "vorgang" from table "(Sales):(WebOrder)" with command "UPDATE" for record "WA2"
And I set field "status" to "S" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario Outline: Dokumente zu Interessenten anlegen
# ----------------------------------------------------------------------------------------------

# Internes Dokument Geschaeftspartner und Bezugsobjekt auf Interessent-1 setzen
Given I open an editor "Interessent-1IntPartner" from table "(Document):(<dbgruppe>)" with command "NEW" for record ""
And I set fields
	| such 		| <such>    |
	| partner	| <partner> |
	| bezobj	| <bezobj>  |

And I save the current editor

Examples:
 | dbgruppe         | such     | partner | tkonto | bezobj |
 | InternalDocument | INT_PART | K 1001  | K 1001 | K 1001 |
 | ExternalDocument | EXT_PART | K 1001  | K 1001 | K 1001 |
 | ReturnsDocument  | RET_PART | K 1001  | K 1001 | K 1001 |

# ----------------------------------------------------------------------------------------------
Scenario: Neues externes Dokument fuer Konto
# ----------------------------------------------------------------------------------------------

Given I open an editor "externKonto" from table "(Document):(ExternalDocument)" with command "NEW" for record ""
And I create a new row at position 1
And I set field "such" to "EXT_KONT"
And I set field "tkonto" to "K 1001" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Zusatzposition fuer Gutschein anlegen
# ----------------------------------------------------------------------------------------------

Given I open an editor "zusatzpos" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set field "such" to "ZPGUTSCHEIN"
And I set field "zptyp" to "neutrale Position"
And I set field "kategorie" to "Gutschein"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario Outline: Gutschein zu Interessenten und Interessentenkontakt anlegen
# ----------------------------------------------------------------------------------------------

Given I open an editor "Interessent-1Gutschein" from table "(Pricing):(Voucher)" with command "NEW" for record ""
And I set fields
	| such 	   	    | <such>  |
	| kunde	   	    | <kunde> |
	| gutscheincode | <code>  |
	| gutscheinpos  | <pos>   |
	| wert 		    | <wert>  |
And I save the current editor

Examples:
	| such 	      | kunde | code 	 | pos		   | wert |
	| INTERESSENT | 1001  | inter123 | ZPGUTSCHEIN | 1.00 |
	| KONTAKT     | 1003  | ikonta12 | ZPGUTSCHEIN | 1.00 |
	| KUNDE       | 1201  | kunde123 | ZPGUTSCHEIN | 1.00 |


# ----------------------------------------------------------------------------------------------
Scenario Outline: Vorgangsverwaltung Projekt zu Interessenten und Interessenkontakte anlegen
# ----------------------------------------------------------------------------------------------

Given I open an editor "Projekt" from table "(Transaction):(Project)" with command "NEW" for record ""
And I set fields
	| such 	     | <such>    |
	| ursache    | <ursache> |
And I save the current editor

Examples:
	| such  | ursache |
	| VGI1  | K 1001  |
	| VGI2  | K 1003  |

# ----------------------------------------------------------------------------------------------
Scenario Outline: Vorgangsverwaltung Aufgabe zu Interessenten und Interessenkontakte anlegen
# ----------------------------------------------------------------------------------------------

Given I open an editor "Aufgabe" from table "(Transaction):(Task)" with command "NEW" for record ""
And I set fields
	| such 	     | <such>    |
	| ursache    | <ursache> |
	| partner    | <partner> |
And I append rows
	| anhobj    | name    |
	| <anhobj>  | Anhang1 |
	| <anhobj2> | Anhang2 |
	| <anhobj>  | Anhang3 |
And I save the current editor

Examples:
	| such  | ursache | partner | anhobj | anhobj2 |
	| VGI1  | K 1001  | K 1001  | K 1001 | K MAIER |
	| VGI2  | K 1003  | K 1003  | K 1003 | K MAIER |


# ----------------------------------------------------------------------------------------------
Scenario Outline: Webrollenliste zu Interessenten und Interessentenkontakte anlegen
# ----------------------------------------------------------------------------------------------

Given I open an editor "Webrollenliste" from table "(WEBUser):(WebRoleList)" with command "NEW" for record ""
And I set fields
	| such 	  | <such> |
And I append rows
	| tperson    |
	| <tperson>  |
And I save the current editor

Examples:
	| such   | tperson |
	| WEBRO1 | K 1001  |
	| WEBRO2 | K 1003  |

# ----------------------------------------------------------------------------------------------
Scenario Outline: Webnutzer zu Interessenten und Interessentenkontakte anlegen
# ----------------------------------------------------------------------------------------------

# Rollenliste muss auch angegeben werden, obwohl es kein Pflichtfeld ist
Given I open an editor "Webnutzer" from table "(WEBUser):(WebUser)" with command "NEW" for record ""
And I set fields
	| such 	  	  | <such>   	  |
	| login   	  | <login>  	  |
	| rollenliste | <rollenliste> |
	| person  	  | <person> 	  |
And I save the current editor

Examples:
	| such  | login | person | rollenliste |
	| WEBU1 | log1  | K 1001 | WEBRO1 	   |
	| WEBU2 | log2  | K 1003 | WEBRO2 	   |

# ----------------------------------------------------------------------------------------------
Scenario Outline: Bankverbindung anlegen
# ----------------------------------------------------------------------------------------------

Given I open an editor "Bankverbindung" from table "(BankData):(BankDetails)" with command "NEW" for record ""
And I set fields
	| konto | <konto> |
	| bank  | <bank>  |
	| iban  | <iban>  |
	| konum | <konum> |
And I save the current editor

Examples:
	| konto  | bank     | iban | konum |
	| K 1001 | BA_14601 | 1234 | 43210 |
	| K 1201 | BA_14601 | 1234 | 43210 |

# ----------------------------------------------------------------------------------------------
Scenario Outline: Sanktionslistenpruefung anlegen
# ----------------------------------------------------------------------------------------------

Given I open an editor "Sanktionslistenpruefung" from table "(ExclusionListCheck):(Log)" with command "NEW" for record ""
And I set fields
	| such   | <such>  	|
	| probj  | <probj> 	|
	| pruefstatus  | Treffer - Verdacht |
And I save the current editor

Examples:
	| such | probj    |
	| SLP1 | K 1001   |
	| SLP2 | K INTER2 |
	| SLP3 | K 1003   |

# ----------------------------------------------------------------------------------------------
Scenario: Ursache fuer Serviceanfrage erstellen
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
Scenario Outline: Notiz zu Interessenten und Interessenkontakte anlegen
# ----------------------------------------------------------------------------------------------

Given I open an editor "Notiz" from table "(Notes):(Note)" with command "NEW" for record ""
And I set fields
	| such 	    | <such>      |
	| partner 	| <partner>   |
	| ausloeser | <ausloeser> |
	| ursache   | <ursache>   |
And I save the current editor

Examples:
	| such | ursache | partner | ausloeser | ursache |
	| NO1  | K 1001  | 1001    | K 1001    | 1001    |
	| NO2  | K 1003  | 1003    | K 1003    | 1003    |

# ----------------------------------------------------------------------------------------------
Scenario Outline: Dispokalender zu Interessenten und Interessenkontakte anlegen
# ----------------------------------------------------------------------------------------------
# Kapazitaetskalender muss nicht beruecksichtigt werden, da dort nur Maschinengruppen und
# Abteilungen als Kalenderbezugsobjekt eingegeben werden koennen.

Given I open an editor "Kalender" from table "(Calendar):(SchedulingCalendar)" with command "NEW" for record ""
And I set fields
	| such 	      | <such>        |
	| dispobezobj | <dispobezobj> |
And I save the current editor

Examples:
	| such | dispobezobj |
	| SC0  | INTER2      |
	| SC1  | 1001        |
	| SC2  | 1003        |


# ----------------------------------------------------------------------------------------------
Scenario: Interessent mit einem Rechnungsempfaenger, der anderweitig gewandelt wird
# ----------------------------------------------------------------------------------------------

Given I open an editor "1120" from table "(Customer):(Prospect)" with command "UPDATE" for record "1120"
And I set field "reempf" to "1012"
And I save the current editor

# ----------------------------------------------------------------------------------------------
#                        AB HIER WERDEN INTERESSENTEN UMGEWANDELT
# ----------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------
Scenario: Interessent ueber COPY-Kommando wandeln
# ----------------------------------------------------------------------------------------------

# Direkte Wandlung eines Interessenten nicht erlaubt
Given opening an editor from table "(Customer):(Customer)" with command "COPY" for record "1100" throws the exception "40"

# ----------------------------------------------------------------------------------------------
Scenario: Interessentenkontakt ueber COPY-Kommando wandeln
# ----------------------------------------------------------------------------------------------

# Direkte Wandlung eines Interessentenkontakts nicht erlaubt
Given opening an editor from table "(Customer):(CustomerContact)" with command "COPY" for record "1200" throws the exception "40"

# ----------------------------------------------------------------------------------------------
Scenario: Interessent und seine Kontakte ueber TRANSFER-Kommando wandeln
# ----------------------------------------------------------------------------------------------

Given I open an editor "kunde" from table "(Customer):(Prospect)" with command "TRANSFER" for record "1001"
And I respond with answer "Ja" to the dialog with id "8994"
And I save the current editor

# Freitexte aendern
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "1001"
And I set field "ftext" to "Respice finem."
And I set field "ftext2" to "Ubi bene, ibi patria."
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Interessent mit Rechnungsempfaenger und seine Kontakte ueber TRANSFER-Kommando wandeln
# ----------------------------------------------------------------------------------------------

Given I open an editor "kundemitreempf" from table "(Customer):(Prospect)" with command "TRANSFER" for record "1012"
And I respond with answer "Ja" to the dialog with id "8993"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Interessent mit Kunde als Rechnungsempfaenger und seine Kontakte ueber TRANSFER-Kommando wandeln
# ----------------------------------------------------------------------------------------------

Given I open an editor "kundemitreempf2" from table "(Customer):(Prospect)" with command "TRANSFER" for record "1110"
And I respond with answer "Ja" to the dialog with id "8993"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: Interessent mit Kunde als Rechnungsempfaenger und seine Kontakte ueber TRANSFER-Kommando wandeln
# ----------------------------------------------------------------------------------------------

# Bankverbindung fuer Interessent
Given I open an editor "Bankverb" from table "(BankData):(BankDetails)" with command "NEW" for record ""
And I set field "nummer" to "100"
And I set field "koinh" to "Juergen Wolf"
And I set field "such" to "BVERB1"
And I set field "name" to "Bankverbindung 1042"
And I set field "konto" to "K 1042"
And I set field "bank" to "1"
And I set field "iban" to "DE5000700104206355066"
And I save the current editor

# Bankverbindung fuer Rechunsgempfaenger des Interessenten
Given I open an editor "Bankverb" from table "(BankData):(BankDetails)" with command "NEW" for record ""
And I set field "nummer" to "101"
And I set field "koinh" to "Eva Klein"
And I set field "such" to "BVERB2"
And I set field "name" to "Bankverbindung 1042"
And I set field "konto" to "K 1041"
And I set field "bank" to "1"
And I set field "iban" to "DE53207001042063550678"
And I save the current editor

# Bankverbindungen eintragen
Given I open an editor "interessmitbverb" from table "(Customer):(Prospect)" with command "UPDATE" for record "1042"
And I set field "bverb" to "100"
And I save the current editor

Given I open an editor "interessmitbverb2" from table "(Customer):(Prospect)" with command "UPDATE" for record "1041"
And I set field "bverb" to "101"
And I save the current editor

# Zunaechst nur Rechnungsempfaenger und seine Kontakte wandeln
Given I open an editor "kundemitbverb" from table "(Customer):(Prospect)" with command "TRANSFER" for record "1041"
And I respond with answer "Ja" to the dialog with id "8994"
And I save the current editor

Given I open an editor "interessentohnebverb" from table "(Customer):(Prospect)" with command "VIEW" for record "+1041"
Then field "bverb" has value ""
And I close the current editor

Given I open an editor "kundemitbverb" from table "(Customer):(Customer)" with command "VIEW" for record "1041"
Then field "bverb" has value "101"
And I close the current editor

Given I open an editor "Bankverb" from table "(BankData):(BankDetails)" with command "VIEW" for record "101"
Then field "konto" has value "K 1041"
And I close the current editor

# Interessent und seine Kontakte wandeln
Given I open an editor "kundemitbverb2" from table "(Customer):(Prospect)" with command "TRANSFER" for record "1042"
And I respond with answer "Ja" to the dialog with id "8993"
And I save the current editor

Given I open an editor "interessentohnebverb2" from table "(Customer):(Prospect)" with command "VIEW" for record "+1042"
Then field "bverb" has value ""
And I close the current editor

Given I open an editor "kundemitbverb2" from table "(Customer):(Customer)" with command "VIEW" for record "1042"
Then field "bverb" has value "100"
And I close the current editor

Given I open an editor "Bankverb2" from table "(BankData):(BankDetails)" with command "VIEW" for record "100"
Then field "konto" has value "K 1042"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Interessent wandeln nicht moeglich, da Interessentenkontakt parallel gesperrt
# ----------------------------------------------------------------------------------------------

# Interessenten wandeln
Given I open an editor "interessw2" from table "(Customer):(Prospect)" with command "TRANSFER" for record "1021"

# Parallel mit einem anderen Benutzer Interessenkontakt sperren
Given I'm logged in with password "annette"
Given I open an editor "interessk2" from table "(Customer):(ProspectContact)" with command "UPDATE" for record "1025"

Given I'm logged in with password "sy"
Given I switch the current editor to editor "interessw2"
# Wandlung wird wegen Sperre abgebrochen
And I respond with answer "Ja" to the dialog with id "8994"
And I save the current editor

Given I'm logged in with password "annette"
Given I switch the current editor to editor "interessk2"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Interessent wandeln nicht moeglich, da ein Fehler in einem EFOP aufgetreten ist
# ----------------------------------------------------------------------------------------------

Given I open an editor "kundemitreempf2" from table "(Customer):(Prospect)" with command "TRANSFER" for record "1032"
And I respond with answer "Ja" to the dialog with id "8993"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: Beim Kopieren von Angebot und Chance abgelegten Interessenten durch Kunden ersetzen
# ----------------------------------------------------------------------------------------------
# Abgelegte Chance verweist auf abgelegten Interessenten
Given I open an editor "vorgang" from table "(Sales):(Opportunity)" with command "VIEW" for record "+CH2"
Then field "kunde" has value "+1001"
Then field "reempf" has value "+1001"
Then field "warenempf" has value "+1001"
And I close the current editor

# Abgelegtes Angebot verweist auf abgelegten Interessenten
Given I open an editor "vorgang" from table "(Sales):(Quotation)" with command "VIEW" for record "+AN2"
Then field "kunde" has value "+1001"
Then field "reempf" has value "+1001"
Then field "warenempf" has value "+1001"
And I close the current editor

# Kopierte Chance verweist auf Kunden
Given I open an editor "vorgang" from table "(Sales):(Opportunity)" with command "COPY" for record "+CH2"
Then field "kunde" has value "1001"
Then field "reempf" has value "1001"
Then field "warenempf" has value "1001"
And I close the current editor

# Kopiertes Angebot verweist auf Kunden
Given I open an editor "vorgang" from table "(Sales):(Quotation)" with command "COPY" for record "+AN2"
Then field "kunde" has value "1001"
Then field "reempf" has value "1001"
Then field "warenempf" has value "1001"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Interessent wandeln, abgelegten Interessent kopieren, Interessentenkopie wandeln
# ----------------------------------------------------------------------------------------------

Given I open an editor "1012" from table "(Customer):(Prospect)" with command "COPY" for record "+1012"
And I set field "nummer" to "1012K"
And I save the current editor

Given I open an editor "1012K" from table "(Customer):(Prospect)" with command "TRANSFER" for record "1012K"
And I respond with answer "Ja" to the dialog with id "8993"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Interessent wandeln, Rechnungsempfaenger und dessen Vorgaenge muessen auch gewandelt werden
# ----------------------------------------------------------------------------------------------
#
#    I1051
#        CH_4
#        AN_4
#       IK 1052
#        WA_4
#
#    I1061 ***WANDELN***
#       Reempf IK 1051
#       IK 1062
#
Given I open an editor "I1061" from table "(Customer):(Prospect)" with command "TRANSFER" for record "1061"
And I respond with answer "Ja" to the dialog with id "8993"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Interessent mit archiviertem Vorgang wandeln
# ----------------------------------------------------------------------------------------------

# DMS-Schnittstelle aktivieren
Given I open an editor "konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "habel" to "1"
And I save the current editor

# Chance anlegen
Given I open an editor "CH5" from table "(Sales):(Opportunity)" with command "NEW" for record ""
And I set fields
	| nummer | 710005 |
	| kunde  | 1121   |
	| such   | CH5    |
	| druck  | ja     |
And I append rows
	| artikel | mge |
	| V1	  | 1   |
And I save the current editor

# Chance drucken
Given I open an editor "CH5" from table "(Sales):(Opportunity)" with command "VIEW" for record from editor "CH5"
And I print layout "MASTER" with filename "rmtmp/CH5.pdf"
And I close the current editor

# Interessent wandeln
Given I open an editor "1121" from table "(Customer):(Prospect)" with command "TRANSFER" for record "1121"
And I respond with answer "Ja" to the dialog with id "8994"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Kunde, der aus Interessent gewandelt worden ist, kopieren
# ----------------------------------------------------------------------------------------------

# Kunde kopieren
Given I open an editor "CPY1121" from table "(Customer):(Customer)" with command "NEW" for record "1121"
And I set fields
	| such     | CPY1121          |
	| name     | Peter Raum Kopie |
Then field "origobj" has value ""
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Kundenkontakt, der aus Interessentenkontakt gewandelt worden ist, kopieren
# ----------------------------------------------------------------------------------------------

# Kundenkontakt kopieren
Given I open an editor "CPY1062" from table "(Customer):(CustomerContact)" with command "NEW" for record "1062"
And I set fields
	| such     | CPY1062            |
	| name     | Elvira Klein Kopie |
Then field "origobj" has value ""
And I save the current editor
