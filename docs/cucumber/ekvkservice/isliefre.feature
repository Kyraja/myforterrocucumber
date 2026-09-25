# *****************************************************************************
#  Name             : isliefre.feature
#  Autor            : cl
#  Verantwortlich   : cl
#  Kontrolle        : teaminfosysteme 
#  Funktion         : Testet Plausis bei Umlagerungen mit Behaeltern
#
# *****************************************************************************
@persistent
Feature: Lieferanten und Rechnungen anlegen
Background:
Given I set the fake date to "02.01.1995"

##################################################################################################################

Scenario: Lieferanten anlegen
Given I open an editor "Lieferant-1" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
    | nummer | 1100                |
    | such   | ADAMSKI             |
    | name   | Adam Adamski, Kd    |
    | email  | devnull@abas.de     |
    | urlt   | http://www.abas.de  |
    | kenn   | Kennung ADAMSKI     |
    | bem    | Bemerkung ADAMSKI   |
And I save the current editor


Given I open an editor "Lieferant-2" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
    | nummer  | 1101                                       |
    | such    | BERTON                                     |
    | name    | Berta Berton                               |
    | mtele   | 01727613888                                |
    | anrede  | 52                                         |
    | kontakt | Berton                                     |
    | email   | devnull@abas.de                            |
    | urlt    | http://www.abas.de/de/kontakt/kontakt.htm  |
    | kenn    | Kennung BERTON                             |
    | bem     | Bemerkung BERTON                           |
And I save the current editor


Given I open an editor "Lieferant-3" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
    | nummer  | 1102                                    |
    | such    | CASPAR                                  |
    | name    | Cäsar Caspar, Rechnungsempfänger        |
    | tele    | 07219672372                             |
    | anrede  | 51                                      |
    | kontakt | Caspar                                  |
    | email   | devnull@abas.de                         |
    | urlt    | http://www.abas.de/de/pps/produkte.htm  |
    | kenn    | Kennung CASPAR                          |
    | bem     | Bemerkung CASPAR                        |
And I save the current editor


Given I open an editor "Lieferant-4" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
    | nummer | 1103                                     |
    | such   | DEIMM                                    |
    | name   | Detlef Deimm                             |
    | tele   | 072196723706                             |
    | mtele  | 01727613889                              |
    | anrede | 51                                       |
    | email  | devnull@abas.de                          |
    | urlt   | http://www.abas.de/de/presse/presse.htm  |
    | kenn   | Kennung DEIMM                            |
    | bem    | Bemerkung DEIMM                          |
And I save the current editor


Given I open an editor "Lieferant-5" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
    | nummer  | 1104                                         |
    | such    | ELGAR                                        |
    | name    | Edmund Elgar                                 |
    | email   | devnull@abas.de                              |
    | urlt    | http://www.abas.de/de/firma/unternehmen.htm  |
    | tele    | 072112345 123                                |
    | kontakt | Elgar                                        |
    | kenn    | Kennung ELGAR                                |
    | bem     | Bemerkung ELGAR                              |
And I save the current editor


Given I open an editor "Lieferant-6" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
    | nummer | 1105                                           |
    | such   | FURT                                           |
    | name   | Frieda Furt                                    |
    | tele   | xyzfehler123                                   |
    | mtele  | xyzfehler123                                   |
    | email  | devnull@abas.de                                |
    | urlt   | http://www.abas.de/de/aktuelles/aktuelles.htm  |
    | kenn   | Kennung FURT                                   |
    | bem    | Bemerkung FURT                                 |
And I save the current editor


Scenario: Lieferantenkontakt anlegen
Given I open an editor "LieferantKontakt-1" from table "(Vendor):(VendorContact)" with command "NEW" for record ""
And I set fields
    | nummer  | 1106                                  |
    | such    | GANZ                                  |
    | firma   | 1105                                  |
    | name    | Gerd Ganz,Ksb mit Firma Frieda Furt   |
    | tele    | 072196723706                          |
    | mtele   | 01727613888                           |
    | anrede  | 52                                    |
    | kontakt | Vorganz                               |
    | email   | devnull@abas.de                       |
    | urlt    | http://www.abas-projektierung.de/     |
    | kenn    | Kennung GANZ                          |
    | bem     | Bemerkung GANZ                        |
And I save the current editor


Scenario: Rechnungen anlegen

Given I open an editor "EinkaufRechnung-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
	| num4    | 1                     |
	| such    | adamski               |
	| lief    | 1100                  |
	| betreff | 1. Zeile vom Betreff  |
	| vom     | .                |
	| tterm   | .                |
And I append rows
    | artex   | ptext                         | mge    | preis  |
    | camel   | 1. Zeile;2. Zeile;3. Zeile    | 1      | 999,99 |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


Given I open an editor "EinkaufRechnung-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | num4    | 21                                     |
    | such    | berton                                 |
    | lief    | 1101                                   |
    | betreff | Hier steht der Betreff dieses Vorgangs |
    | schlag  | Testrechnung Berton                    |
    | vom     | .                                      |
    | tterm   | .                                      |
And I append rows
    | artex   | mge    |   preis  |
    | rot     | 10     |   100    |
And I respond with answer "Ja" to the dialog with id "4841"    
And I save the current editor


Given I open an editor "EinkaufRechnung-3" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | num4    | 2                     |
    | such    | caspar                |
    | lief    | caspar                |
    | schlag  | Testrechnung Caspar   |
    | vom     | .                     |
    | tterm   | .                     |
And I append rows
    | artex   | ptext                         | mge    |  preis  |    
    | fort    | Auch hier gibt es einen ptext | 100    |  1000   |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


Given I open an editor "EinkaufRechnung-4" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | num4    | 3                     |
    | such    | deimm                 |
    | lief    | deimm                 |
    | schlag  | Testrechnung Deimm    |
    | vom     | .                     |
    | tterm   | .                     |
And I append rows
    | artex   | mge    |   preis  |
    | camel   | 1000   |   101    |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


Given I open an editor "EinkaufRechnung-5" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | num4    | 4                     |
    | such    | elgar                 |
    | lief    | elgar                 |
    | schlag  | Testrechnung Elgar    |
    | vom     | .                     |
    | tterm   | .                     |
    | budat   | .                     |
And I append rows
    | artikel | mge    |   preis  |
    | rot     | 10000  |   222    |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


Given I open an editor "EinkaufRechnung-6" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer  | 5                     |
    | such    | furt                  |
    | lief    | furt                  |
    | schlag  | Testrechnung Furt     |
    | vom     | .                     |
    | tterm   | .                     |
    | budat   | .                     |
And I append rows
    | artikel | mge    |   preis  | ptext                         | 
    | fort    | 100000 |   333    | 1. Zeile;2. Zeile;3. Zeile    |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


Given I open an editor "EinkaufRechnung-7" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer  | 6                     |
    | such    | ganz                  |
    | lief    | ganz                  |
    | schlag  | Testrechnung Ganz     |
    | vom     | .                     |
    | tterm   | .                     |
    | budat   | .                     |
And I append rows
    | artikel | mge    |   preis  | ptext                         | 
    | camel   | 11     |   44,44  | 1. Zeile;2. Zeile;3. Zeile    |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


Given I open an editor "EinkaufRechnung-8" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer  | 7                     |
    | such    | adamski               |
    | lief    | adamski               |
    | schlag  | Testrechnung Adamski  |
    | ueb     | ja                    |
    | vom     | .                     |
    | tterm   | .                     |
    | budat   | .                     |
And I append rows
    | artikel | mge    |   preis  | ptext                         | 
    | camel   | 11     |   44,44  | 1. Zeile;2. Zeile;3. Zeile    |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


Given I open an editor "EinkaufRechnung-9" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer  | 8                     |
    | such    | berton                |
    | lief    | berton                |
    | schlag  | Testrechnung Berton   |
    | ueb     | ja                    |
    | vom     | .                     |
    | tterm   | .                     |
    | budat   | .                     |
And I append rows
    | artikel | mge    |   preis   | 
    | rot     | 10     |   100,33  |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


Given I open an editor "EinkaufRechnung-10" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer  | 9                     |
    | such    | caspar                |
    | lief    | caspar                |
    | schlag  | Testrechnung Caspar   |
    | ueb     | ja                    |
    | vom     | .                     |
    | tterm   | .                     |
    | budat   | .                     |
And I append rows
    | artikel | mge    |   preis   | 
    | fort    | 100    |   112,56  |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


Given I open an editor "EinkaufRechnung-11" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer  | 10                    |
    | such    | deimm                 |
    | lief    | deimm                 |
    | schlag  | Testrechnung Deimm    |
    | ueb     | ja                    |
    | vom     | .                     |
    | tterm   | .                     |
    | budat   | .                     |
And I append rows
    | artikel | mge    |   preis   | 
    | camel   | 1000   |   111     |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


Given I open an editor "EinkaufRechnung-12" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer  | 11                    |
    | such    | elgar                 |
    | lief    | elgar                 |
    | schlag  | Testrechnung Elgar    |
    | ueb     | ja                    |
    | vom     | .                     |
    | tterm   | .                     |
    | budat   | .                     |
And I append rows
    | artikel | mge    |   preis   | ptext                         | 
    | rot     | 10000  |   1099    | 1. Zeile;2. Zeile;3. Zeile    |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


Given I open an editor "EinkaufRechnung-13" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer  | 12                    |
    | such    | furt                  |
    | lief    | furt                  |
    | schlag  | Testrechnung Furt     |
    | ueb     | ja                    |
    | vom     | .                     |
    | tterm   | .                     |
    | budat   | .                     |
And I append rows
    | artikel | mge    |   preis   |
    | fort    | 100000 |   10234   |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


Given I open an editor "EinkaufRechnung-13" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer  | 13                    |
    | such    | ganz                  |
    | lief    | ganz                  |
    | schlag  | Testrechnung Ganz     |
    | ueb     | ja                    |
    | vom     | .                     |
    | tterm   | .                     |
    | budat   | .                     |
And I append rows
    | artikel | mge    |   preis    |
    | camel   | 11     |   23456,7  |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
