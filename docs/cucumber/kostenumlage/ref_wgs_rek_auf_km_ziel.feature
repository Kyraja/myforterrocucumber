# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      :
# *****************************************************************************
@persistent
Feature: Kombinationen aus wertgutschrift auf eine ARTIKELRECHNUNG (=KOSTENZIEL) + rechn.korr. + kostenumlagen

Background:
Given I set the fake date to "25.01.2002"

# ---------------------------------------------------------------------------------------------
Scenario: Stammdaten vorbereiten
# ---------------------------------------------------------------------------------------------

And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "25.01.2002" with Command Revalue
Given I set the fake date to "26.01.2002"
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "E1EI-VO"
And I set field "gemein" to ""
And I save the current editor

And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "26.01.2002" with Command Revalue
Given I set the fake date to "27.01.2002"
Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "12003vo"
And I delete all rows
And I save the current editor

And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "27.01.2002" with Command Revalue
Given I set the fake date to "28.01.2002"
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "E1FR-VF"
And I set field "gemein" to ""
And I save the current editor

And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "28.01.2002" with Command Revalue
Given I set the fake date to "1.2.2002"
Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "12002vf"
And I delete all rows
And I save the current editor

And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "1.2.2002" with Command Revalue
Given I set the fake date to "2.2.2002"
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "E1LO-VO"
And I set field "gemein" to ""
And I save the current editor

And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "2.2.2002" with Command Revalue
Given I set the fake date to "3.2.2002"
Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "12002vf"
And I delete all rows
And I save the current editor


# addk-aus-ek ## Zusatzposition Transport
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "3.2.2002" with Command Revalue
Given I set the fake date to "4.2.2002"
# addk-aus-ek #Given I open an editor "zusatzp_transport" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
# addk-aus-ek #And I set field "nummer" to "1transp"
# addk-aus-ek #And I set field "such" to "transport"
# addk-aus-ek #And I set field "name" to "transportkosten"
# addk-aus-ek #And I save the current editor


# ---------------------------------------------------------------------------------------------
Scenario: RE(Art.pos)---WGS---KM(RE)---REK/TREK---RREK---SKM   quellfremdwaehrung ist eine andere als zielfremdwaehrung
# ---------------------------------------------------------------------------------------------

# graf:
# RE(Art.pos)---WGS---KM(RE)---REK/TREK---RREK---SKM
#               (1)    (2)       (3)       (4)   (5)

# addk-aus-ek ## Rechnung für add. kosten anlegen
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "4.2.2002" with Command Revalue
Given I set the fake date to "5.2.2002"
# addk-aus-ek #Given I open an editor "re-addkosten-240" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
# addk-aus-ek #And I set field "num4" to "240-add"
# addk-aus-ek #And I set field "lief" to "1"
# addk-aus-ek #And I set field "erfwaehr" to "usd"
# addk-aus-ek #And I set field "vom" to "."
# addk-aus-ek #And I set field "ueb" to "ja"
# addk-aus-ek #And I append rows
# addk-aus-ek # |artex     | pwert| konto | kstelle | ptext          |
# addk-aus-ek # |transport |     6| 50011 |     111 | kost_qu_ek_14n |
# addk-aus-ek #And I respond with answer "Ja" to the dialog with id "4841"
# addk-aus-ek #And I save the current editor

And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "5.2.2002" with Command Revalue
Given I set the fake date to "6.2.2002"
Given I open an editor "rechnung_fuer_artikel-n" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | 1      |
    | num4     | 11-15N |
    | such4    | R11-15N|
    | vom      | .      |
    | ueb      | ja     |
    | fakt     | ja     |
    | ebeleg   | MATRE1 |
    | budat    | .      |
    | erfwaehr |  GBP   |
And I append rows

# mit-mkv #    | artikel     | mge | preis | tterm | ptext    	| platz     |
# mit-mkv #    | E1EI-VO     | 10  | 10,00 | +4	   | kmzpos12n	|!dontChange|
# mit-mkv #    | E1FR-VF     | 15  | 15,00 | +4	   | kmzpos16n	|!dontChange|

# ohne-mkv #   | artikel     | mge | preis | tterm	| ptext   	| platz     | kstelle |
# ohne-mkv #   | E1EI-VO     | 10  | 10,00 | +4		| kmzpos12n |!dontChange|   110   |
# ohne-mkv #   | E1FR-VF     | 15  | 15,00 | +4		| kmzpos16n |!dontChange|   111   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# (1) Wertgutschrift: Kommando Rechnung auf eine Rechnung
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "6.2.2002" with Command Revalue
Given I set the fake date to "7.2.2002"
Given I open an editor "240-wgs" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+11-15N"
And I set fields
   | nummer | 11-15Nw|
   | such   | wgs11-15N |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  ja    |
And I press button "komplettieren"
Then the table has 5 rows
Then field "artikel" has value "E1EI-VO" in row 1
Then field "mge" has value "-10" in row 1
Then field "pwert" has value "-100.00" in row 1
Then field "artikel" has value "E1FR-VF" in row 2
Then field "mge" has value "-15" in row 2
Then field "pwert" has value "-225.00" in row 2
And I save the current editor


# (2) KM (kopf:pos)
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "7.2.2002" with Command Revalue
Given I set the fake date to "8.2.2002"
Given I open an editor "REpos-100%WGS-KM" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "240km"
And I set field "such" to "km240"
# addk-aus-ek #And I set field "pos" to "$,,ptext==kost_qu_ek_14n;art==transport;pwert==6;@ablageart=(Filed)"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_14n"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos12n;rekorrektur==ja;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos16n;rekorrektur==ja;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# (3) Voll-Rechnungskorrektur  +  Teil-Rechnungskorrektur
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "8.2.2002" with Command Revalue
Given I set the fake date to "9.2.2002"
Given I open an editor "REpos-100%WGS-KM(RE)-REK>0--1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+11-15N"
And I set fields
   | nummer | 11-15NK |
   | such   | NK-11-15 |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
And I press button "burekorrektur"
Then field "artikel" has value "E1EI-VO" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "3" in row 1
Then field "artikel" has value "E1FR-VF" in row 2
And I set field "mge" to "3" in row 2
And I set field "preis" to "4" in row 2
And I save the current editor


# (4) Rest-Rechnungskorrektur
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "9.2.2002" with Command Revalue
Given I set the fake date to "10.2.2002"
Given I open an editor "REpos-100%WGS-KM(RE)-REK>0-RREK=0" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+11-15N"
And I set fields
   | nummer | 11-15NRK |
   | such   | NRK-11-15 |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
And I press button "burekorrektur"
Then field "artikel" has value "E1FR-VF" in row 1
And I press button "offueb" in row 1
# And I set field "mge" to "12" in row 1
And I set field "preis" to "0" in row 1
And I save the current editor


# (5) Storno Kostenumlage
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "10.2.2002" with Command Revalue
Given I set the fake date to "11.2.2002"
Given I open an editor "sto-240km" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+240km"
And I set field "num135" to "240s"
And I set field "such" to "KM240S"
And I save the current editor




# ---------------------------------------------------------------------------------------------
Scenario: LS(Art.pos)---RE(Art.pos)---WGS---KM(RE)---REK/TREK---RREK---SKM
# ---------------------------------------------------------------------------------------------

# graf:
# LS(Art.pos)---RE(Art.pos)---WGS---KM(RE)---REK/TREK---RREK---SKM
#                             (1)    (2)       (3)       (4)   (5)

# addk-aus-ek ## Rechnung für add. kosten anlegen
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "11.2.2002" with Command Revalue
Given I set the fake date to "12.2.2002"
# addk-aus-ek #Given I open an editor "re-addkosten-241" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
# addk-aus-ek #And I set field "num4" to "241-add"
# addk-aus-ek #And I set field "lief" to "1"
# addk-aus-ek #And I set field "erfwaehr" to "eur"
# addk-aus-ek #And I set field "vom" to "."
# addk-aus-ek #And I set field "ueb" to "ja"
# addk-aus-ek #And I append rows
# addk-aus-ek # |artex     | pwert| konto | kstelle | ptext          |
# addk-aus-ek # |transport |     7| 50011 |     111 | kost_qu_ek_14o |
# addk-aus-ek #And I respond with answer "Ja" to the dialog with id "4841"
# addk-aus-ek #And I save the current editor


And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "12.2.2002" with Command Revalue
Given I set the fake date to "13.2.2002"
Given I open an editor "ls_fuer_artikel-o" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief     | 1      |
    | num4     | 11-15OL|
    | such4    | L11-15O|
    | vom      | .      |
    | ueb      | ja     |
    | ebeleg   | MATLS1 |
    | erfwaehr |  EUR   |
And I append rows

# mit-mkv #    | artikel     | mge | preis | tterm | ptext    	| platz     |
# mit-mkv #    | E1EI-VO     | 10  | 10,00 | +4	   | kmzpos12o	|!dontChange|
# mit-mkv #    | E1FR-VF     | 15  | 15,00 | +4	   | kmzpos16o	|!dontChange|

# ohne-mkv #   | artikel     | mge | preis | tterm	| ptext   	| platz     | kstelle |
# ohne-mkv #   | E1EI-VO     | 10  | 10,00 | +4		| kmzpos12o |!dontChange|   110   |
# ohne-mkv #   | E1FR-VF     | 15  | 15,00 | +4		| kmzpos16o |!dontChange|   111   |
And I save the current editor


And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "13.2.2002" with Command Revalue
Given I set the fake date to "14.2.2002"
Given I open an editor "rechnung_fuer_artikel-o" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "L11-15O"
And I set fields
    | lief     | 1      |
    | num4     | 11-15OR |
    | such4    | R11-15O|
    | vom      | .      |
    | ueb      | ja     |
    | ebeleg   | MATRE1 |
    | budat    | .      |
    | erfwaehr |  EUR   |
#                                        rechnungspreise abweichend von be/ls-preise. dadurch muss der
#                                        bewertungspreis nach wgs wieder zurück auf die ls-preise
And I set field "preis" to "16" in row 1
And I set field "preis" to "22" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# (1) Wertgutschrift: Kommando Rechnung auf eine Rechnung
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "14.2.2002" with Command Revalue
Given I set the fake date to "15.2.2002"
Given I open an editor "241-wgs" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+11-15OR"
And I set fields
   | nummer | 11-15Ow|
   | such   | wgs11-15O |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  ja    |
And I press button "komplettieren"
Then the table has 5 rows
Then field "artikel" has value "E1EI-VO" in row 1
Then field "mge" has value "-10" in row 1
Then field "pwert" has value "-160.00" in row 1
Then field "artikel" has value "E1FR-VF" in row 2
Then field "mge" has value "-15" in row 2
Then field "pwert" has value "-330.00" in row 2
And I save the current editor


# (2) KM (kopf:pos)
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "15.2.2002" with Command Revalue
Given I set the fake date to "16.2.2002"
Given I open an editor "LS-REpos-100%WGS-KM" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "241km"
And I set field "such" to "km241"
# addk-aus-ek #And I set field "pos" to "$,,ptext==kost_qu_ek_14o;art==transport;pwert==7;@ablageart=(Filed)"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_14o"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos12o;mge==10;kopf^wertgutschrift==nein;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos16o;mge==15;kopf^wertgutschrift==nein;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# (3) Voll-Rechnungskorrektur  +  Teil-Rechnungskorrektur
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "16.2.2002" with Command Revalue
Given I set the fake date to "17.2.2002"
Given I open an editor "LS-REpos-100%WGS-KM(RE)-REK>0--O-1" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "L11-15O"
And I set fields
   | nummer | 11-15OK |
   | such   | OK-11-15 |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
#                                             über den LS geht das wie eine normale rechnungserstellung!
#                                             And I press button "burekorrektur"

Then field "artikel" has value "E1EI-VO" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "3" in row 1
Then field "artikel" has value "E1FR-VF" in row 2
And I set field "mge" to "3" in row 2
And I set field "preis" to "4" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# (4) Rest-Rechnungskorrektur
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "17.2.2002" with Command Revalue
Given I set the fake date to "18.2.2002"
Given I open an editor "LS-REpos-100%WGS-KM(RE)-REK>0--O-2" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "L11-15O"
And I set fields
   | nummer | 11-15ORK |
   | such   | ORK-11-15 |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
#                                             über den LS geht das wie eine normale rechnungserstellung!
#                                             And I press button "burekorrektur"

Then field "artikel" has value "E1FR-VF" in row 1
And I press button "offueb" in row 1
# And I set field "mge" to "12" in row 1
And I set field "preis" to "0" in row 1
And I save the current editor

# (5) Storno Kostenumlage
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "18.2.2002" with Command Revalue
Given I set the fake date to "19.2.2002"
Given I open an editor "sto-241km" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+241km"
And I set field "num135" to "241s"
And I set field "such" to "KM241S"
And I save the current editor








# ---------------------------------------------------------------------------------------------
Scenario: RE(Art.pos)---KM(RE)---WGS---REK/TREK---RREK---SKM
# ---------------------------------------------------------------------------------------------

# graf:
# RE(Art.pos)---KM(RE)---WGS---REK/TREK---RREK---KMRF
#               (1)      (2)     (3)      (4)    (5)

# addk-aus-ek ## Rechnung für add. kosten anlegen
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "19.2.2002" with Command Revalue
Given I set the fake date to "20.2.2002"
# addk-aus-ek #Given I open an editor "re-addkosten-243" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
# addk-aus-ek #And I set field "num4" to "243-add"
# addk-aus-ek #And I set field "lief" to "1"
# addk-aus-ek #And I set field "erfwaehr" to "eur"
# addk-aus-ek #And I set field "vom" to "."
# addk-aus-ek #And I set field "ueb" to "ja"
# addk-aus-ek #And I append rows
# addk-aus-ek # |artex     | pwert| konto | kstelle | ptext          |
# addk-aus-ek # |transport |     8| 50011 |     111 | kost_qu_ek_14p |
# addk-aus-ek #And I respond with answer "Ja" to the dialog with id "4841"
# addk-aus-ek #And I save the current editor

And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "20.2.2002" with Command Revalue
Given I set the fake date to "21.2.2002"
Given I open an editor "rechnung_fuer_artikel-p" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | 1      |
    | num4     | 11-15P |
    | such4    | R11-15P|
    | vom      | .      |
    | ueb      | ja     |
    | fakt     | ja     |
    | ebeleg   | MATRE1 |
    | budat    | .      |
    | erfwaehr |  EUR   |
And I append rows

# mit-mkv #    | artikel     | mge | preis | tterm | ptext    	| platz     |
# mit-mkv #    | E1EI-VO     | 10  | 15,00 | +4	   | kmzpos12p	|!dontChange|
# mit-mkv #    | E1FR-VF     | 15  | 20,00 | +4	   | kmzpos16p	|!dontChange|

# ohne-mkv #   | artikel     | mge | preis | tterm	| ptext   	| platz     | kstelle |
# ohne-mkv #   | E1EI-VO     | 10  | 15,00 | +4		| kmzpos12p |!dontChange|   110   |
# ohne-mkv #   | E1FR-VF     | 15  | 20,00 | +4		| kmzpos16p |!dontChange|   111   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# (1) KM (kopf:pos)
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "21.2.2002" with Command Revalue
Given I set the fake date to "22.2.2002"
Given I open an editor "REpos-KM-100%WGS" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "243km"
And I set field "such" to "km243"
# addk-aus-ek #And I set field "pos" to "$,,ptext==kost_qu_ek_14p;art==transport;pwert==8;@ablageart=(Filed)"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_14p"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos12p;preis==15;kopf^fakt==ja;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos16p;preis==20;kopf^fakt==ja;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor


# (2) Wertgutschrift: Kommando Rechnung auf eine Rechnung
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "22.2.2002" with Command Revalue
Given I set the fake date to "23.2.2002"
Given I open an editor "243-wgs" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+11-15P"
And I set fields
   | nummer | 11-15Pw|
   | such   | wgs11-15P |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  ja    |
And I press button "komplettieren"
Then the table has 5 rows
Then field "artikel" has value "E1EI-VO" in row 1
Then field "mge" has value "-10" in row 1
Then field "pwert" has value "-150.00" in row 1
Then field "artikel" has value "E1FR-VF" in row 2
Then field "mge" has value "-15" in row 2
Then field "pwert" has value "-300.00" in row 2
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# (3) Voll-Rechnungskorrektur  +  Teil-Rechnungskorrektur
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "23.2.2002" with Command Revalue
Given I set the fake date to "24.2.2002"
Given I open an editor "REpos-KM-100%WGS-REK>0--1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+11-15P"
And I set fields
   | nummer | 11-15PK |
   | such   | PK-11-15 |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
And I press button "burekorrektur"
Then field "artikel" has value "E1EI-VO" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "3" in row 1
Then field "artikel" has value "E1FR-VF" in row 2
And I set field "mge" to "3" in row 2
And I set field "preis" to "4" in row 2
And I save the current editor


# (4) Rest-Rechnungskorrektur
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "24.2.2002" with Command Revalue
Given I set the fake date to "25.2.2002"
Given I open an editor "REpos-KM(RE)-100%WGS-REK>0-RREK=0" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+11-15P"
And I set fields
   | nummer | 11-15PRK |
   | such   | PRK-11-15 |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
And I press button "burekorrektur"
Then field "artikel" has value "E1FR-VF" in row 1
And I press button "offueb" in row 1
# And I set field "mge" to "12" in row 1
And I set field "preis" to "0" in row 1
And I save the current editor


# (5)
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "25.2.2002" with Command Revalue
Given I set the fake date to "26.2.2002"
Given I open an editor "kostenumlrueck-243" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "243kmrf"
And I set field "name" to "KMRF"
And I set field "such" to "RUECKF243"
And I set field "origvorg" to "+243km"
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# ---------------------------------------------------------------------------------------------------------
Scenario: LS---TeilRE1---TeilRE2---TeilRE3---KM(TransportkostenRE auf TeilRE2)---WGS(TeilRE2)---REK1---REK2
# ---------------------------------------------------------------------------------------------------------

# EK-Rechnung Transportkosten
# addk-aus-ek ## Rechnung für add. kosten anlegen
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "26.2.2002" with Command Revalue
Given I set the fake date to "27.2.2002"
# addk-aus-ek #Given I open an editor "re-addkosten-244" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
# addk-aus-ek #And I set field "num4" to "244-add"
# addk-aus-ek #And I set field "lief" to "1"
# addk-aus-ek #And I set field "erfwaehr" to "eur"
# addk-aus-ek #And I set field "vom" to "."
# addk-aus-ek #And I set field "ueb" to "ja"
# addk-aus-ek #And I append rows
# addk-aus-ek # |artex     | pwert| konto | kstelle | ptext          |
# addk-aus-ek # |transport |     9| 50011 |     111 | kost_qu_ek_14q |
# addk-aus-ek #And I respond with answer "Ja" to the dialog with id "4841"
# addk-aus-ek #And I save the current editor

# EK-Lieferschein
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "27.2.2002" with Command Revalue
Given I set the fake date to "28.2.2002"
Given I open an editor "lieferschein_fuer_artikel-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief     | 1      |
    | num4     | 11-15Q |
    | such4    | L11-15Q|
    | vom      | .      |
    | ueb      | ja     |
    | ebeleg   | MATRE1 |
    | erfwaehr | eur    |
And I append rows

# mit-mkv #    | artikel     | mge | preis | ptext    	| platz     |
# mit-mkv #    | E1EI-VO     | 100  | 10,00 | kmzpos12q	|!dontChange|
# mit-mkv #    | E1EI-VO     | 150  | 15,00 | kmzpos16q	|!dontChange|

# ohne-mkv #   | artikel     | mge | preis | ptext   	| platz     | kstelle |
# ohne-mkv #   | E1EI-VO     | 100  | 10,00 | kmzpos12q |!dontChange|   110   |
# ohne-mkv #   | E1EI-VO     | 150  | 15,00 | kmzpos16q |!dontChange|   111   |
And I save the current editor
And I close the current editor

# EK-Teilrechnung 1
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "28.2.2002" with Command Revalue
Given I set the fake date to "1.3.2002"
Given I open an editor "rechnung1_fuer_artikel-1" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "lieferschein_fuer_artikel-1"
And I set fields
    | lief     | 1       |
    | num4     | 11-15QR1|
    | such4    | R11-15Q1|
    | vom      | .       |
    | ueb      | ja      |
    | ebeleg   | MATRE1  |
    | budat    | .       |
    | erfwaehr | eur     |
And I set field "mge" to "40" in row 1
And I set field "preis" to "20" in row 1
And I set field "mge" to "50" in row 2
And I set field "preis" to "20" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# EK-Teilrechnung 2
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "1.3.2002" with Command Revalue
Given I set the fake date to "2.3.2002"
Given I open an editor "rechnung2_fuer_artikel-1" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "lieferschein_fuer_artikel-1"
And I set fields
    | lief     | 1       |
    | num4     | 11-15QR2|
    | such4    | R11-15Q2|
    | vom      | .       |
    | ueb      | ja      |
    | ebeleg   | MATRE1  |
    | budat    | .       |
    | erfwaehr | eur     |
And I set field "mge" to "25" in row 1
And I set field "preis" to "22" in row 1
And I set field "mge" to "40" in row 2
And I set field "preis" to "22" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# EK-Teilrechnung 3
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "2.3.2002" with Command Revalue
Given I set the fake date to "3.3.2002"
Given I open an editor "rechnung3_fuer_artikel-1" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "lieferschein_fuer_artikel-1"
And I set fields
    | lief     | 1       |
    | num4     | 11-15QR3|
    | such4    | R11-15Q3|
    | vom      | .       |
    | ueb      | ja      |
    | ebeleg   | MATRE1  |
    | budat    | .       |
    | erfwaehr | eur     |
And I set field "mge" to "15" in row 1
And I set field "preis" to "24" in row 1
And I set field "mge" to "25" in row 2
And I set field "preis" to "24" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# KM Transportkosten auf Teil-RE2
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "3.3.2002" with Command Revalue
Given I set the fake date to "4.3.2002"
Given I open an editor "REpos-km-d" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "244km"
And I set field "such" to "km244"
# addk-aus-ek #And I set field "pos" to "$,,ptext==kost_qu_ek_14q;art==transport;@ablageart=(Filed)"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_14b"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos12q;@gruppe=2;@datenbank=4" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos16q;@gruppe=2;@datenbank=4" in row !lastRow
And I save the current editor

# Wertgutschrift auf EK-Teilrechnung 2
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "4.3.2002" with Command Revalue
Given I set the fake date to "5.3.2002"
Given I open an editor "teilrechnung2-wgs" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+11-15QR2"
And I set fields
   | nummer | 15R2-wgs|
   | such   | wgs15QR2 |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  ja    |
# Komplettgutschrift erstellen
And I press button "komplettieren"
Then the table has 5 rows
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# Rechnungskorrektur 1 (nicht über komplette Menge)
# EK-Teilrechnung 1
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "5.3.2002" with Command Revalue
Given I set the fake date to "6.3.2002"
Given I open an editor "rechnung1_fuer_artikel-1" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "lieferschein_fuer_artikel-1"
And I set fields
    | lief     | 1    |
    | num4     | 11-15QK1|
    | such4    | QK111-15|
    | vom      | .        |
    | ueb      | ja       |
    | ebeleg   | MATRE1   |
    | budat    | .        |
    | erfwaehr | eur      |
And I set field "mge" to "40" in row 1
And I set field "preis" to "26" in row 1
And I set field "mge" to "70" in row 2
And I set field "preis" to "26" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Rechnungskorrektur 2 (über Restmenge)
# EK-Teilrechnung 1
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "6.3.2002" with Command Revalue
Given I set the fake date to "7.3.2002"
Given I open an editor "rechnung1_fuer_artikel-1" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "lieferschein_fuer_artikel-1"
And I set fields
    | lief     | 1    |
    | num4     | 11-15QK2|
    | such4    | QK211-15|
    | vom      | .        |
    | ueb      | ja       |
    | ebeleg   | MATRE1   |
    | budat    | .        |
    | erfwaehr | eur      |
And I set field "mge" to "5" in row 1
And I set field "preis" to "28" in row 1
And I set field "mge" to "5" in row 2
And I set field "preis" to "28" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor



