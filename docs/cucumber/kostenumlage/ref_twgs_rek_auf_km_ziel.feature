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
Given I set the fake date to "25.01.2002"

Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "E1EI-VO"
And I set field "gemein" to ""
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "12003vo"
And I delete all rows
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "E1FR-VF"
And I set field "gemein" to ""
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "12002vf"
And I delete all rows
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "E1LO-VO"
And I set field "gemein" to ""
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "12002vf"
And I delete all rows
And I save the current editor


# addk-aus-ek ## Zusatzposition Transport
# addk-aus-ek #Given I open an editor "zusatzp_transport" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
# addk-aus-ek #And I set field "nummer" to "1transp"
# addk-aus-ek #And I set field "such" to "transport"
# addk-aus-ek #And I set field "name" to "transportkosten"
# addk-aus-ek #And I save the current editor




# ---------------------------------------------------------------------------------------------
Scenario: RE(Art.pos)---TWGS---KM(RE)---!REK/!TREK---!RREK---SKM
# ---------------------------------------------------------------------------------------------
Given I set the fake date to "25.01.2002"

#                                 (2a)
#                           ___!REK/!TREK (keine Position)
# graf:                    /
# RE(Art.pos)---TWGS---KM(RE)-----SKM
#               (1)    (2)        (3)

# addk-aus-ek ## Rechnung für add. kosten anlegen
# addk-aus-ek #Given I open an editor "re-addkosten-240" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
# addk-aus-ek #And I set field "num4" to "240-add"
# addk-aus-ek #And I set field "lief" to "1"
# addk-aus-ek #And I set field "erfwaehr" to "USD"
# addk-aus-ek #And I set field "vom" to "."
# addk-aus-ek #And I set field "ueb" to "ja"
# addk-aus-ek #And I append rows
# addk-aus-ek # |artex     | pwert| konto | kstelle | ptext          |
# addk-aus-ek # |transport |     6| 50011 |     111 | kost_qu_ek_14n |
# addk-aus-ek #And I respond with answer "Ja" to the dialog with id "4841"
# addk-aus-ek #And I save the current editor

# RECHNUNG MIT LAGERBEWEGUNG
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
    | erfwaehr | USD    |
And I append rows

# mit-mkv #    | artikel     | mge | preis | tterm | ptext    	| platz     |
# mit-mkv #    | E1EI-VO     | 10  | 10,00 | +4	   | kmzpos12n	|!dontChange|
# mit-mkv #    | E1FR-VF     | 15  | 15,00 | +4	   | kmzpos16n	|!dontChange|

# ohne-mkv #   | artikel     | mge | preis | tterm	| ptext   	| platz     | kstelle |
# ohne-mkv #   | E1EI-VO     | 10  | 10,00 | +4		| kmzpos12n |!dontChange|   110   |
# ohne-mkv #   | E1FR-VF     | 15  | 15,00 | +4		| kmzpos16n |!dontChange|   111   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# (1) TWertgutschrift: Kommando Rechnung auf eine Rechnung
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
And I set field "mge" to "-6" in row 1
Then field "pwert" has value "-60.00" in row 1
Then field "artikel" has value "E1FR-VF" in row 2
Then field "mge" has value "-15" in row 2
And I set field "mge" to "-14" in row 2
Then field "pwert" has value "-210.00" in row 2
And I save the current editor


# (2) KM (kopf:pos)
Given I open an editor "REpos-100%WGS-KM" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "240km"
And I set field "such" to "km240"
# addk-aus-ek #And I set field "pos" to "$,,ptext==kost_qu_ek_14n;art==transport;pwert==6;@ablageart=(Filed)"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_14n"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos12n;mge==10;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos16n;mge==15;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# (2a) Rechnungskorrektur wird nicht untersagt, BLEIBT ABER POSITIONSSEITIG LEER!
Given I open an editor "REpos-100%WGS-KM(RE)-REK>0--1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+11-15N"
And I set fields
   | nummer | 11-15NK |
   | such   | NK-11-15 |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
And I press button "burekorrektur"
Then field "artikel" has value "NS." in row 1
Then field "pwert" has value "0.00" in row 1
And I save the current editor


# (3) Storno Kostenumlage
Given I open an editor "sto-240km" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+240km"
And I set field "num135" to "240s"
And I set field "such" to "KM240S"
And I save the current editor



# ---------------------------------------------------------------------------------------------
Scenario: LS(Art.pos)---RE(Art.pos)---TWGS---KM(RE)---!REK/TREK---!RREK---SKM
# ---------------------------------------------------------------------------------------------
Given I set the fake date to "25.01.2002"

#                                              (2a)
#                                        ___!REK/!TREK (Art.Position keine offene menge mehr)
# graf:                                 /
# LS(Art.pos)---RE(Art.pos)---TWGS---KM(RE)---SKM
#                              (1)    (2)     (3)

# addk-aus-ek ## Rechnung für add. kosten anlegen
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
#                                        bewertungspreis nach wgs wieder in richtung der ls-preise gehen (teil-wgs)
And I set field "preis" to "16" in row 1
And I set field "preis" to "22" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# (1) Wertgutschrift: Kommando Rechnung auf eine Rechnung
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
And I set field "mge" to "-5" in row 1
Then field "pwert" has value "-80.00" in row 1
Then field "artikel" has value "E1FR-VF" in row 2
Then field "mge" has value "-15" in row 2
And I set field "mge" to "-1" in row 2
Then field "pwert" has value "-22.00" in row 2
And I set field "preis" to "18.00" in row 2
Then field "pwert" has value "-18.00" in row 2
And I save the current editor


# (2) KM (kopf:pos)
Given I open an editor "LS-REpos-100%WGS-KM" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "241km"
And I set field "such" to "km241"
# addk-aus-ek #And I set field "pos" to "$,,ptext==kost_qu_ek_14o;art==transport;pwert==7;@ablageart=(Filed)"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_14o"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos12o;mge==10;kopf^typ=Rechnung;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos16o;mge==15;kopf^typ=Rechnung;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# (2a) Rechnungskorrektur nicht möglich, da in den artikelpositionen keine mengen aufgegangen sind
Given I open an editor "LS-REpos-100%WGS-KM(RE)-REK>0--O-1" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "+L11-15O"
And I set fields
   | nummer | 11-15OK |
   | such   | OK-11-15 |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
#                                             über den LS geht das wie eine normale rechnungserstellung!
Then field "burekorrektur" is not modifiable
Then field "artikel" has value "E1EI-VO" in row 1
# 2810 de      |Rechnungsmenge zu hoch.
Then setting field "mge" to "1" in row 1 throws the exception "2810"
And I close the current editor


# (3) Storno Kostenumlage
Given I open an editor "sto-241km" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+241km"
And I set field "num135" to "241s"
And I set field "such" to "KM241S"
And I save the current editor





# ---------------------------------------------------------------------------------------------
Scenario: RE(Art.pos)---KM(RE)---WGS---REK/TREK---RREK---SKM
# ---------------------------------------------------------------------------------------------
Given I set the fake date to "25.01.2002"

#                                 (2a)
#                           ___!REK/!TREK/!RREK (keine Position mehr)
# graf:                    /
# RE(Art.pos)---KM(RE)---TWGS---KMRF
#               (1)      (2)    (3)

# addk-aus-ek ## Rechnung für add. kosten anlegen
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
And I set field "mge" to "-2" in row 1
Then field "pwert" has value "-30.00" in row 1
Then field "artikel" has value "E1FR-VF" in row 2
Then field "mge" has value "-15" in row 2
And I set field "mge" to "-8" in row 2
Then field "pwert" has value "-160.00" in row 2
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# (2a) Rechnungskorrektur nicht mehr möglich, die positionen sind weg
Given I open an editor "REpos-KM-100%WGS-REK>0--1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+11-15P"
And I set fields
   | nummer | 11-15PK |
   | such   | PK-11-15 |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
And I press button "burekorrektur"
Then field "artikel" has value "NS." in row 1
Then field "pwert" has value "0.00" in row 1
And I save the current editor


# (3)
Given I open an editor "kostenumlrueck-243" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "243kmrf"
And I set field "name" to "KMRF"
And I set field "such" to "RUECKF243"
And I set field "origvorg" to "+243km"
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
