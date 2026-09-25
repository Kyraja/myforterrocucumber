# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      : 
# *****************************************************************************
@persistent
Feature: Kombinationen aus TEIL-wertgutschrift auf eine DIENSTLEISTUNGSRECHNUNG (=KOSTENQUELLE) + rechn.korr. + kostenumlagen  

Background:
Given I set the fake date to "25.01.2002"

# ---------------------------------------------------------------------------------------------
Scenario: RE---TWGS--REK(2)---KM(kopf:pos)(3)--SKM(4)---SREK(5)    mit plausis
# ---------------------------------------------------------------------------------------------
Given I set the fake date to "25.01.2002"

# graf:
#            ___KM(als kopf:pos)__KM(als kopf:pos)
#           /   scheit. (1b)      scheit. (2b)
#      (1) /
# RE---TWGS----------REK(2)------------------!KM(REK)----!SKM---------SREK(3)
#  \           LEER => keine dienstl.pos.=>   ni.möglich  entfällt    
#   \          REK formal möglich                                     SREK formal möglich  
#    \         hier inhaltlich sinnlos                                hier inhaltlich sinnlos
#     \
#      \______KM(als kopf:pos)______KM(als kopf:pos)
#             scheit. (1a)          scheit. (2a) 
#
# und natürlich ist auch das folgende hier nicht mehr geteste scenario nach der REK nicht mehr möglich,
# weil in der REK keine verwertbare position mehr steht! 
#
#  RE---TWGS--REK---KM(kopf:pos)---KMRF---SKMRF---SKM
#                | ab hier nicht mögl. 
#                | wird hier nicht getestet, ist überflüssig
#
#  RE---TWGS--REK---KM(kopf:pos)---SREK             
#                | ab hier nicht mögl. 
#                | wird hier nicht getestet, ist überflüssig
#
#  RE---TWGS--REK0---KM(kopf:pos)
#                 | ab hier nicht mögl. 
#                 | wird hier nicht getestet, ist überflüssig


# Wertgutschrift: Kommando Rechnung auf eine Rechnung
Given I open an editor "134-twgs" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+134-add"
And I set fields
   | nummer | 134-twgs|
   | such   | twgs134 |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  ja    |
Then the table has 4 rows
And I set field "pwert" to "-5" in row 1
And I save the current editor

# (plausi 1a aus graf - keine datenspeicherung)
# // 2930 de  |Kostenumlagen zu wertgutgeschiebenen Rechnungspositionen sind nicht erlaubt. 
# s. exception rechts =>
Given I open an editor "re-twgs-plausi-1a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1" 
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_11;pwert==6;art==transport;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "2930"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_11"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
And I close the current editor

# (plausi 1b aus graf - keine datenspeicherung)
# // 2946 de  |Kostenumlagen zu Wertgutschriftpositionen sind nicht erlaubt.
# s. exception rechts =>
Given I open an editor "re-twgs-plausi-1b" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave2"
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_11;art==transport;twertgutschrift==ja;@ablageart=(Filed)" throws the exception "2946"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_11"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
And I close the current editor


# (2) KEINE Rechnungskorrektur möglich
Given I open an editor "REpos-twgs-REK>0--1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+134-add"
And I set fields
   | nummer | 134-rek  |
   | such   | rek-134-1 |
   | ueb    | ja      |
   | tterm  | .          |
   | budat  | .          |
   | vom    | .       |
And I press button "burekorrektur"
Then the table has 3 rows
Then field "artikel" has value "NS." in row 1
Then field "pwert" has value "0.00" in row 1
Then field "artikel" has value "ST." in row 2
Then field "pwert" has value "0.00" in row 2
Then field "artikel" has value "ES." in row 3
Then field "pwert" has value "0.00" in row 3
And I save the current editor


# (plausi 2a aus graf - keine datenspeicherung)
# // 2930 de  |Kostenumlagen zu wertgutgeschiebenen Rechnungspositionen sind nicht erlaubt. 
# s. exception rechts =>
Given I open an editor "re-twgs-plausi-2a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1" 
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_11;art==transport;pwert==6;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "2930"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_11"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
And I close the current editor

# (plausi 2b aus graf - keine datenspeicherung)
# // 2946 de  |Kostenumlagen zu Wertgutschriftpositionen sind nicht erlaubt.
# s. exception rechts =>
Given I open an editor "re-twgs-plausi-2b" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave2"
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_11;art==transport;twertgutschrift==ja;@ablageart=(Filed)" throws the exception "2946"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_11"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
And I close the current editor

# (3) Storno der Rechnungskorrektur - formal möglich - inhaltlich sinnlos
Given I open an editor "SREK" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+rek-134-1"
And I set field "nummer" to "1kmreks" 
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# ---------------------------------------------------------------------------------------------
Scenario: REpos - KM - ! TWGS : REpos - KM - KMTRF - TWGS
# ---------------------------------------------------------------------------------------------
Given I set the fake date to "25.01.2002"

# graf:
#(136-add)   (300)                 __KMTRF
#---RE-------KM ___(tab:kmzpos3)--/  (2)
#    \      (1)                         
#     \
#      \__________TWGS _____________________TWGS
#                scheit. (1a)              scheit. (2a)

# ---- Kostenumlagen erzeugen (1) ----
# kopierquelle : std/test/cucumber/kostenumlage/ref_km_rueck_basis1.template.feature
Given I open an editor "kostenuml-3" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "300" 
And I set field "such" to "U3-2ZEI" 
# addk-aus-ek #And I set field "pos" to "$,,ptext==kost_qu_ek_4;art==transport;@ablageart=(Filed)"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_4"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuzeile" to "2"

And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos2;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I set field "proz" to "40" in row !lastRow

And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos3;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I set field "proz" to "60" in row !lastRow

# ohne-mkv ##  mit fibuumbuch=nein wird eine ADM.FEHL erzeugt. in der GUI aber nicht. warum ist unklar.
# ohne-mkv ##  die meldung ist ungefähr so: EFOP Maskenaustritt an dieser Stelle nicht erlaubt.
# ohne-mkv ##  siehe dazu https://jira.abasag.intra/browse/CUCU-190 (on premis jira bis 2021)
# ohne-mkv ##  und https://jira.abasag.intra/browse/BW2-1391 (on premis jira bis 2021)
# ohne-mkv ## mit fibuumbuch = nein und ohne respond 2911 (früher 9425) kam es zu einer ADM.FEHL  
# ohne-mkv #And I set field "fibuumbuch" to "nein"
# ohne-mkv #And I respond with answer "Nein" to the dialog with id "2911"

# mit-mkv #And I set field "fibuumbuch" to "nein"
# mit-mkv ## 8878 de      |Abweichende Konten in Kopf und Tabelle der Kostenumlage. Umbuchung durchfhren.
# mit-mkv #And saving the current editor throws the exception "8878"
# mit-mkv #And I set field "fibuumbuch" to "ja"
And I save the current editor

# ---- EK-TWGS ----
#  die Kostenumlagequelle kost_qu_ek_4 ist in Rechnungsnummer 136-add enthalten
#  Plausi (1a) aus graf 
#  zu BW2-1845: diese TWGS darf nicht erfassbar/buchbar sein.
#  Speicherung muss blockieren:
Given I open an editor "136-twgs" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+136-add"
And I set fields
   | nummer | 136twgs     |
   | such   | twgs136     |
   | tterm  | .          |
   | budat  | .          |
   | vom    | .          |
   | ueb    |  ja        |
Then the table has 6 rows
And I set field "pwert" to "-4" in row 1
And saving the current editor throws the exception "9264"
And I close the current editor

Given I set the fake date to "01.02.2002"

# ----- KMTRF -----
#   kopierquelle : std/test/cucumber/kostenumlage/ref_km_rueck_basis1.template.feature
Given I open an editor "kostenuml-teilrueck-300" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "301" 
And I set field "name" to "KMRF" 
And I set field "such" to "RF301" 
And I set field "origvorg" to "+U3-2ZEI"
Then field "budat" has value "10.01.02"
And I set field "budat" to "01.02.2002"
And I set field "zurueckfuehren" to "nein" in row 1
And I save the current editor

# ---- EK-TWGS ----
#  die Kostenumlagequelle kost_qu_ek_4 ist in Rechnungsnummer 136-add enthalten
#  Plausi (2a) aus graf 
#  zu BW2-1845: diese TWGS darf immer noch nicht erfassbar/buchbar sein, weil KM nur teilrückgeführt
#  Speicherung muss auch hier noch blockieren:

Given I open an editor "136-twgs2" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+136-add"
And I set fields
   | nummer | 136twgs2     |
   | such   | twgs136.2    |
   | tterm  | .          |
   | budat  | .          |
   | vom    | .          |
   | ueb    |  ja        |
Then the table has 6 rows
And I set field "pwert" to "-3.75" in row 1
And saving the current editor throws the exception "9264"
And I close the current editor


# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# ---------------------------------------------------------------------------------------------
Scenario: RE----KM----KMRF---TWGS---REK(LEER)   quellfremdwaehrung ist eine andere als zielfremdwaehrung
# ---------------------------------------------------------------------------------------------
Given I set the fake date to "01.02.2002"

#                                 __KM(als kopf:pos)
#                                /  scheit. (4b)     
# graf:                         /    
# RE----KM----KMRF------------TWGS------------------REK
#  \    (2)   (3)              (4)               (5)LEER!
#   \            \
#    \            \________________Storno KMRF ________Storno KMRF
#     \                            scheitert (4c)      scheitert (5b)
#      \
#       \__KM(als kopf:pos)_______KM(als kopf:pos)_____KM(als kopf:pos)
#          scheit. (2a)           scheit. (4a)         scheit. (5a) 


# addk-aus-ek ## Rechnung für add. kosten anlegen
# addk-aus-ek #Given I open an editor "re-addkosten-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
# addk-aus-ek #And I set field "num4" to "143-add"
# addk-aus-ek #And I set field "lief" to "1"
# addk-aus-ek #And I set field "erfwaehr" to "USD"
# addk-aus-ek #And I set field "vom" to "."
# addk-aus-ek #And I set field "ueb" to "ja"
# addk-aus-ek #And I append rows
# addk-aus-ek # |artex     | pwert| konto | kstelle | ptext          | 
# addk-aus-ek # |transport |     8| 50011 |     111 | kost_qu_ek_14d |
# addk-aus-ek #And I respond with answer "Ja" to the dialog with id "4841"
# addk-aus-ek #And I save the current editor

Given I open an editor "rechnung_fuer_artikel-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | 1      |
    | num4     | 11-15D |
    | such4    | R11-15D|
    | vom      | .      |
    | ueb      | ja     |
    | fakt     | ja     |
    | ebeleg   | MATRE1 |
    | budat    | .      |
    | erfwaehr |  GBP   |
And I append rows

# mit-mkv #    | artikel     | mge | preis | tterm | ptext    	| platz     |
# mit-mkv #    | E1EI-VO     | 10  | 10,00 | +4	   | kmzpos12d	|!dontChange|
# mit-mkv #    | E1EI-VO     | 15  | 15,00 | +4	   | kmzpos16d	|!dontChange|

# ohne-mkv #   | artikel     | mge | preis | tterm	| ptext   	| platz     | kstelle |
# ohne-mkv #   | E1EI-VO     | 10  | 10,00 | +4		| kmzpos12d |!dontChange|   110   |
# ohne-mkv #   | E1EI-VO     | 15  | 15,00 | +4		| kmzpos16d |!dontChange|   111   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# (2) KM (kopf:pos) auf RE
Given I open an editor "REpos-km-d" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "143km" 
And I set field "such" to "km143" 
# addk-aus-ek #And I set field "pos" to "$,,ptext==kost_qu_ek_14d;art==transport;@ablageart=(Filed)"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_14b"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos12d;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos16d;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor

# (plausi 2a aus graf - keine datenspeicherung)
# // 8996 de      |Kostenumlage zur Position vorhanden. 
# s. exception rechts =>
Given I open an editor "143-plausi-2a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1" 
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14d;pwert==8;art==transport;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "8996"
And I close the current editor

# (3)
Given I open an editor "kostenumlrueck-143" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "143kmrf" 
# kein name, damit std.text gezogen wird (testrelevant!)    And I set field "name" to "KMRF" 
And I set field "origvorg" to "+143km"
And I set field "such" to "RF143" 
And I set field "budat" to "."
And I save the current editor


# (4) Wertgutschrift: Kommando Rechnung auf eine Rechnung
Given I open an editor "143-twgs" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+143-add"
And I set fields
   | nummer | 143-twgs|
   | such   | twgs143 |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  ja    |
Then the table has 4 rows
And I set field "pwert" to "-1" in row 1
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# (plausi 4a aus graf - keine datenspeicherung)
# // 8996 de      |Kostenumlage zur Position vorhanden. 
# s. exception rechts =>
Given I open an editor "143-plausi-4a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1" 
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14d;pwert==8;art==transport;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "8996"
And I close the current editor

# (plausi 4b aus graf - keine datenspeicherung)
# // 2946 de  |Kostenumlagen zu Wertgutschriftpositionen sind nicht erlaubt.
# s. exception rechts =>
Given I open an editor "143-plausi-4b" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave2"
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14d;art==transport;twertgutschrift==ja;@ablageart=(Filed)" throws the exception "2946"
And I close the current editor

# (plausi 4c aus graf - keine datenspeicherung)
# 2921 de |Stornierungen von Kostenumlagerückführungen zu Rechnungspositionen mit Wertgutschrift sind nicht erlaubt.
Then opening an editor from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+RF143" throws the exception "2921"

# (5) KEINE Rechnungskorrektur möglich
Given I open an editor "143-rek" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+143-add"
And I set fields
   | nummer | 143-rek |
   | such   | rek-143 |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
And I press button "burekorrektur"
Then the table has 3 rows
Then field "artikel" has value "NS." in row 1
Then field "pwert" has value "0.00" in row 1
Then field "artikel" has value "ST." in row 2
Then field "pwert" has value "0.00" in row 2
Then field "artikel" has value "ES." in row 3
Then field "pwert" has value "0.00" in row 3
And I save the current editor


# (plausi 5a aus graf - keine datenspeicherung)
# // 8996 de      |Kostenumlage zur Position vorhanden. 
# s. exception rechts =>
Given I open an editor "143-plausi-5a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1" 
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14d;pwert==8;art==transport;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "8996"
And I close the current editor


# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# (plausi 5b aus graf - keine datenspeicherung)
# 2921 de |Stornierungen von Kostenumlagerückführungen zu Rechnungspositionen mit Wertgutschrift sind nicht erlaubt.
Then opening an editor from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+RF143" throws the exception "2921"


# ---------------------------------------------------------------------------------------------
Scenario: RE----KM----SKM---TWGS---REK---!KM---!KMRF
# ---------------------------------------------------------------------------------------------
Given I set the fake date to "01.02.2002"

#                                  __KM(als kopf:pos)
#                                 /  scheit. (4b)         
#                                /                        
# graf:                         /                         
# RE----KM----SKM--------------TWGS------------------REK-----!KM------!KMRF
#  \    (2)   (3)              (4)                  (5)    
#   \                                              LEER    | ab hier ohne REK NICHT MÖGLICH!
#    \    
#     \_____KM(als kopf:pos)______KM(als kopf:pos)_____KM(als kopf:pos)
#           scheit. (2a)          scheit. (4a)         scheit. (5a) 

# addk-aus-ek ## Rechnung für add. kosten anlegen
# addk-aus-ek #Given I open an editor "re-addkosten-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
# addk-aus-ek #And I set field "num4" to "144-add"
# addk-aus-ek #And I set field "lief" to "1"
# addk-aus-ek #And I set field "erfwaehr" to "eur"
# addk-aus-ek #And I set field "vom" to "."
# addk-aus-ek #And I set field "ueb" to "ja"
# addk-aus-ek #And I append rows
# addk-aus-ek # |artex     | pwert| konto | kstelle | ptext          | 
# addk-aus-ek # |transport |     9| 50011 |     111 | kost_qu_ek_14e |
# addk-aus-ek #And I respond with answer "Ja" to the dialog with id "4841"
# addk-aus-ek #And I save the current editor

Given I open an editor "rechnung_fuer_artikel-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | 1      |
    | num4     | 11-15E |
    | such4    | R11-15E|
    | vom      | .      |
    | ueb      | ja     |
    | fakt     | ja     |
    | ebeleg   | MATRE1 |
    | budat    | .      |
And I append rows

# mit-mkv #    | artikel     | mge | preis | tterm | ptext    	| platz     |
# mit-mkv #    | E1EI-VO     | 10  | 10,00 | +4	   | kmzpos12e	|!dontChange|
# mit-mkv #    | E1EI-VO     | 15  | 15,00 | +4	   | kmzpos16e	|!dontChange|

# ohne-mkv #   | artikel     | mge | preis | tterm	| ptext   	| platz     | kstelle |
# ohne-mkv #   | E1EI-VO     | 10  | 10,00 | +4		| kmzpos12e |!dontChange|   110   |
# ohne-mkv #   | E1EI-VO     | 15  | 15,00 | +4		| kmzpos16e |!dontChange|   111   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# (2) KM (kopf:pos) auf RE
Given I open an editor "REpos-km-d" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "144km" 
And I set field "such" to "km144" 
# addk-aus-ek #And I set field "pos" to "$,,ptext==kost_qu_ek_14e;art==transport;@ablageart=(Filed)"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_14b"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos12e;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos16e;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor

# (plausi 2a aus graf - keine datenspeicherung)
# // 8996 de      |Kostenumlage zur Position vorhanden. 
# s. exception rechts =>
Given I open an editor "144-plausi-2a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1" 
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14e;pwert==9;art==transport;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "8996"
And I close the current editor

# (3) Storno Kostenumlage
Given I open an editor "144-km-storno" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+144km"
And I set field "num135" to "144kms" 
And I set field "such" to "kms144" 
And I save the current editor


# (4) Wertgutschrift: Kommando Rechnung auf eine Rechnung
Given I open an editor "144-twgs" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+144-add"
And I set fields
   | nummer | 144-twgs|
   | such   | twgs144 |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  ja    |
Then the table has 4 rows
And I set field "pwert" to "-2" in row 1
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor



# (plausi 4a aus graf - keine datenspeicherung)
# // 2930 de  |Kostenumlagen zu wertgutgeschiebenen Rechnungspositionen sind nicht erlaubt. 
# s. exception rechts =>
Given I open an editor "144-plausi-4a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1" 
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14e;pwert==9;art==transport;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "2930"
And I close the current editor

# (plausi 4b aus graf - keine datenspeicherung)
# // 2946 de  |Kostenumlagen zu Wertgutschriftpositionen sind nicht erlaubt.
# s. exception rechts =>
Given I open an editor "144-plausi-4b" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave2"
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14e;art==transport;twertgutschrift==ja;@ablageart=(Filed)" throws the exception "2946"
And I close the current editor

# (5) KEINE Rechnungskorrektur möglich
Given I open an editor "144-rek" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+144-add"
And I set fields
   | nummer | 144-rek |
   | such   | rek-144 |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
And I press button "burekorrektur"
Then the table has 3 rows
Then field "artikel" has value "NS." in row 1
Then field "pwert" has value "0.00" in row 1
Then field "artikel" has value "ST." in row 2
Then field "pwert" has value "0.00" in row 2
Then field "artikel" has value "ES." in row 3
Then field "pwert" has value "0.00" in row 3
And I save the current editor


# (plausi 5a aus graf - keine datenspeicherung)
# // 2930 de  |Kostenumlagen zu wertgutgeschiebenen Rechnungspositionen sind nicht erlaubt. 
# s. exception rechts =>
Given I open an editor "144-plausi-5a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1" 
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14e;pwert==9;art==transport;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "2930"
And I close the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# ---------------------------------------------------------------------------------------------
Scenario: RE---KM---KMTRF---KMRRF---TWGS---REK
# ---------------------------------------------------------------------------------------------
Given I set the fake date to "01.02.2002"

#                                      __KM(als kopf:pos)
#                                     /  scheit. (4b)     
# graf:                              /    
# RE----KM----KMTRF--------KMRRF----TWGS------------------REK
#  \    (2)   (3a)         (3b)     (4)                  (5)
#   \                           
#    \_____KM(als kopf:pos)___________KM(als kopf:pos)_____KM(als kopf:pos)
#          scheit. (2a)               scheit. (4a)         scheit. (5a) 

# addk-aus-ek ## Rechnung für add. kosten anlegen
# addk-aus-ek #Given I open an editor "re-addkosten-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
# addk-aus-ek #And I set field "num4" to "145-add"
# addk-aus-ek #And I set field "lief" to "1"
# addk-aus-ek #And I set field "erfwaehr" to "eur"
# addk-aus-ek #And I set field "vom" to "."
# addk-aus-ek #And I set field "ueb" to "ja"
# addk-aus-ek #And I append rows
# addk-aus-ek # |artex     | pwert| konto | kstelle | ptext          | 
# addk-aus-ek # |transport |    10| 50011 |     111 | kost_qu_ek_14f |
# addk-aus-ek #And I respond with answer "Ja" to the dialog with id "4841"
# addk-aus-ek #And I save the current editor

Given I open an editor "rechnung_fuer_artikel-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | 1      |
    | num4     | 11-15F |
    | such4    | R11-15F|
    | vom      | .      |
    | ueb      | ja     |
    | fakt     | ja     |
    | ebeleg   | MATRE1 |
    | budat    | .      |
And I append rows

# mit-mkv #    | artikel     | mge | preis | tterm | ptext    	| platz     |
# mit-mkv #    | E1EI-VO     | 10  | 10,00 | +4	   | kmzpos12f	|!dontChange|
# mit-mkv #    | E1EI-VO     | 15  | 15,00 | +4	   | kmzpos16f	|!dontChange|

# ohne-mkv #   | artikel     | mge | preis | tterm	| ptext   	| platz     | kstelle |
# ohne-mkv #   | E1EI-VO     | 10  | 10,00 | +4		| kmzpos12f |!dontChange|   110   |
# ohne-mkv #   | E1EI-VO     | 15  | 15,00 | +4		| kmzpos16f |!dontChange|   111   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# (2) KM (kopf:pos) auf RE
Given I open an editor "REpos-km-d" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "145km" 
And I set field "such" to "km145" 
# addk-aus-ek #And I set field "pos" to "$,,ptext==kost_qu_ek_14f;art==transport;@ablageart=(Filed)"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_14b"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos12f;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos16f;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor

# (plausi 2a aus graf - keine datenspeicherung)
# // 8996 de      |Kostenumlage zur Position vorhanden. 
# s. exception rechts =>
Given I open an editor "145-plausi-2a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1" 
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14f;pwert==10;art==transport;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "8996"
And I close the current editor

# (3a)
Given I open an editor "kostenumlrueck-145" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "145kmrfa" 
# kein name, damit std.text gezogen wird (testrelevant!)    And I set field "name" to "KMRF" 
And I set field "origvorg" to "+145km"
And I set field "such" to "RF145-A" 
And I set field "budat" to "."
And I set field "zurueckfuehren" to "nein" in row 2
And I save the current editor

# (3b)  KMRRF Restrückführung der Kostenumlage, danach KOMPLETT zurückgeführt.
#
Given I open an editor "kostenumlrueck-145" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "145kmrfb"
# kein name, damit std.text gezogen wird (testrelevant!)    And I set field "name" to "KMRF" 
And I set field "origvorg" to "+145km"
And I set field "such" to "RF145-B" 
And I set field "budat" to "."
And I save the current editor


# (4) Wertgutschrift: Kommando Rechnung auf eine Rechnung
Given I open an editor "145-twgs" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+145-add"
And I set fields
   | nummer | 145-twgs|
   | such   | twgs145 |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  ja    |
Then the table has 4 rows
And I set field "pwert" to "-3" in row 1
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# (plausi 4a aus graf - keine datenspeicherung)
# // 8996 de      |Kostenumlage zur Position vorhanden. 
# s. exception rechts =>
Given I open an editor "145-plausi-4a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1" 
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14f;pwert==10;art==transport;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "8996"
And I close the current editor

# (plausi 4b aus graf - keine datenspeicherung)
# // 2946 de  |Kostenumlagen zu Wertgutschriftpositionen sind nicht erlaubt.
# s. exception rechts =>
Given I open an editor "145-plausi-4b" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave2"
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14f;art==transport;twertgutschrift==ja;@ablageart=(Filed)" throws the exception "2946"
And I close the current editor

# (5) Korrekturrechnung = Rechnungskorrektur nicht möglich, da nur TWGS
Given I open an editor "145-rek" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+145-add"
And I set fields
   | nummer | 145-rek |
   | such   | rek-145 |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
And I press button "burekorrektur"
Then the table has 3 rows
Then field "artikel" has value "NS." in row 1
Then field "pwert" has value "0.00" in row 1
Then field "artikel" has value "ST." in row 2
Then field "pwert" has value "0.00" in row 2
Then field "artikel" has value "ES." in row 3
Then field "pwert" has value "0.00" in row 3
And I save the current editor


# (plausi 5a aus graf - keine datenspeicherung)
# // 8996 de      |Kostenumlage zur Position vorhanden. 
# s. exception rechts =>
Given I open an editor "145-plausi-5a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1" 
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14f;pwert==10;art==transport;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "8996"
And I close the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# ---------------------------------------------------------------------------------------------
Scenario: RE----KM----KMRF---TWGS---STWGS---SKMRF quellfremdwaehrung ungleich zielfremdwaehrung
#  ähnlich wie 143 hier und sehr ähnlich wie 147 im test für vollwertgutschriften
# ---------------------------------------------------------------------------------------------
Given I set the fake date to "6.02.2002"

#                            ___________________________KM(als kopf:pos)
#                           /                           scheit. (6a)     
# graf:                    /    
# RE----KM----KMRF--------TWGS----STWGS--------------SKMRF
#  \    (2)   (3)         (4)     (5)                (6) 
#   \
#    \_____KM(als kopf:pos)__________KM(als kopf:pos)___KM(als kopf:pos)
#          scheit. (2a)              scheit. (5a)       scheit. (6b) 

# addk-aus-ek ## Rechnung für add. kosten anlegen
# addk-aus-ek #Given I open an editor "re-addkosten-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
# addk-aus-ek #And I set field "num4" to "147-add"
# addk-aus-ek #And I set field "lief" to "1"
# addk-aus-ek #And I set field "erfwaehr" to "USD"
# addk-aus-ek #And I set field "vom" to "."
# addk-aus-ek #And I set field "ueb" to "ja"
# addk-aus-ek #And I append rows
# addk-aus-ek # |artex     | pwert| konto | kstelle | ptext          | 
# addk-aus-ek # |transport |    10| 50012 |     112 | kost_qu_ek_14h |
# addk-aus-ek #And I respond with answer "Ja" to the dialog with id "4841"
# addk-aus-ek #And I save the current editor

Given I open an editor "rechnung_fuer_artikel-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | 1      |
    | num4     | 11-15H |
    | such4    | R11-15H|
    | vom      | .      |
    | ueb      | ja     |
    | fakt     | ja     |
    | ebeleg   | MATRE1 |
    | budat    | .      |
    | erfwaehr |  GBP   |
And I append rows

# mit-mkv #    | artikel     | mge | preis | tterm | ptext    	| platz     |
# mit-mkv #    | E1EI-VO     | 10  | 10,00 | +4	   | kmzpos12h	|!dontChange|
# mit-mkv #    | E1EI-VO     | 15  | 15,00 | +4	   | kmzpos16h	|!dontChange|

# ohne-mkv #   | artikel     | mge | preis | tterm	| ptext   	| platz     | kstelle |
# ohne-mkv #   | E1EI-VO     | 10  | 10,00 | +4		| kmzpos12h |!dontChange|   110   |
# ohne-mkv #   | E1EI-VO     | 15  | 15,00 | +4		| kmzpos16h |!dontChange|   111   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# (2) KM (kopf:pos) auf RE
Given I open an editor "REpos-km-d" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "147km" 
And I set field "such" to "km147" 
# addk-aus-ek #And I set field "pos" to "$,,ptext==kost_qu_ek_14h;art==transport;@ablageart=(Filed)"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_14b"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos12h;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos16h;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor

# (plausi 2a aus graf - keine datenspeicherung)
# // 8996 de      |Kostenumlage zur Position vorhanden. 
# s. exception rechts =>
Given I open an editor "147-plausi-2a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1" 
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14h;pwert==10;art==transport;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "8996"
And I close the current editor

# (3)
Given I open an editor "kostenumlrueck-147" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "147kmrf" 
# kein name, damit std.text gezogen wird (testrelevant!)    And I set field "name" to "KMRF" 
And I set field "origvorg" to "+147km"
And I set field "such" to "RF147" 
And I set field "budat" to "06.02.2002"
And I save the current editor


# (4) Wertgutschrift: Kommando Rechnung auf eine Rechnung
Given I open an editor "147-wgs" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+147-add"
And I set fields
   | nummer | 147-twgs|
   | such   | twgs147 |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  ja    |
Then the table has 4 rows
And I set field "pwert" to "-1" in row 1
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# (5) storno twgs
Given I open an editor "Stwgs" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+twgs147"
And I set fields
    | num4   | 147stwgs  |
And I save the current editor

# (plausi 5a aus graf - keine datenspeicherung)
# // 8996 de      |Kostenumlage zur Position vorhanden. 
# s. exception rechts =>
Given I open an editor "147-plausi-5a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1" 
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14h;pwert==10;art==transport;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "8996"
And I close the current editor

# (6) storno kmrf ist nach storno der twgs erlaubt:
Given I open an editor "sto-kostenumlrueck-rf147" from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+RF147"
And I set field "num135" to "147srf" 
And I set field "such" to "SRF147"
And I set field "name" to "SKMRF" 
And I save the current editor

# (plausi 6a aus graf - keine datenspeicherung)
# // 2946 de  |Kostenumlagen zu Wertgutschriftpositionen sind nicht erlaubt.
# s. exception rechts =>
Given I open an editor "147-plausi-6a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave2"
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14h;art==transport;treart==Stornierte Kaufmaennische Gutschrift;twertgutschrift==ja;@ablageart=(Filed)" throws the exception "2946"
And I close the current editor

# (plausi 6b aus graf - keine datenspeicherung)
# // 8996 de      |Kostenumlage zur Position vorhanden. 
# s. exception rechts =>
Given I open an editor "147-plausi-6b" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1" 
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14h;pwert==10;art==transport;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "8996"
And I close the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

