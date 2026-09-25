# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      :
# *****************************************************************************
@persistent
Feature: Kombinationen aus wertgutschrift auf eine DIENSTLEISTUNGSRECHNUNG (=KOSTENQUELLE) + rechn.korr. + kostenumlagen

Background:
Given I set the fake date to "25.01.2002"

# ---------------------------------------------------------------------------------------------
Scenario: RE---WGS--REK(2)---KM(kopf:pos)(3)--SKM(4)---SREK(5)    mit plausis
# ---------------------------------------------------------------------------------------------

# graf:
#            ___KM(als kopf:pos)__KM(als kopf:pos)
#           /   scheit. (1b)      scheit. (2b)
#      (1) /
# RE---WGS--------------REK(2)----------KM(kopf:pos)(3)----SKM(4)----SREK(5)
#  \
#   \______KM(als kopf:pos)______KM(als kopf:pos)
#          scheit. (1a)          scheit. (2a)

# Wertgutschrift: Kommando Rechnung auf eine Rechnung
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "25.01.2002" with Command Revalue
Given I set the fake date to "26.01.2002"
Given I open an editor "134-wgs" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+134-add"
And I set fields
   | nummer | 134-wgs|
   | such   | wgs134 |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  ja    |
Then the table has 4 rows
And I set field "pwert" to "-6" in row 1
And I save the current editor

# (plausi 1a aus graf - keine datenspeicherung)
# // 2930 de  |Kostenumlagen zu wertgutgeschiebenen Rechnungspositionen sind nicht erlaubt.
# s. exception rechts =>
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "26.01.2002" with Command Revalue
Given I set the fake date to "27.01.2002"
Given I open an editor "re-100%wgs-plausi-1a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1"
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_11;pwert==6;art==transport;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "2930"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_11"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
And I close the current editor

# (plausi 1b aus graf - keine datenspeicherung)
# // 2946 de  |Kostenumlagen zu Wertgutschriftpositionen sind nicht erlaubt.
# s. exception rechts =>
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "27.01.2002" with Command Revalue
Given I set the fake date to "28.01.2002"
Given I open an editor "re-100%wgs-plausi-1b" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave2"
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_11;art==transport;twertgutschrift==ja;@ablageart=(Filed)" throws the exception "2946"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_11"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
And I close the current editor


# (2) 100%Korrekturrechnung = [Voll]Rechnungskorrektur
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "28.01.2002" with Command Revalue
Given I set the fake date to "1.2.2002"
Given I open an editor "REpos-100%WGS-REK>0--1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+134-add"
And I set fields
   | nummer | 134-rek  |
   | such   | rek-134-1 |
   | ueb    | ja      |
   | tterm  | .          |
   | budat  | .          |
   | vom    | .       |
And I press button "burekorrektur"
Then field "artikel" has value "TRANSPORT" in row 1
Then field "ptext" has value "kost_qu_ek_11" in row 1
And I set field "pwert" to "4" in row 1
# And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ---- ?? BUG ?? ----
# dass die REK wiederholt werden kann ist a.m.s. ein bug, aber vllt. sehe ich nicht alles..
# (2x) 100%Korrekturrechnung = [Voll]Rechnungskorrektur
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "1.2.2002" with Command Revalue
Given I set the fake date to "2.2.2002"
Given I open an editor "REpos-100%WGS-REK>0--1b" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+134-add"
And I set fields
   | nummer | 134-rek2  |
   | such   | rek-134-2 |
   | ueb    | ja      |
   | tterm  | .          |
   | budat  | .          |
   | vom    | .       |
And I press button "burekorrektur"
Then field "artikel" has value "TRANSPORT" in row 1
Then field "ptext" has value "kost_qu_ek_11" in row 1
And I set field "pwert" to "3" in row 1
# And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# (plausi 2a aus graf - keine datenspeicherung)
# // 2930 de  |Kostenumlagen zu wertgutgeschiebenen Rechnungspositionen sind nicht erlaubt.
# s. exception rechts =>
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "2.2.2002" with Command Revalue
Given I set the fake date to "3.2.2002"
Given I open an editor "re-100%wgs-plausi-2a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1"
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_11;art==transport;pwert==6;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "2930"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_11"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
And I close the current editor

# (plausi 2b aus graf - keine datenspeicherung)
# // 2946 de  |Kostenumlagen zu Wertgutschriftpositionen sind nicht erlaubt.
# s. exception rechts =>
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "3.2.2002" with Command Revalue
Given I set the fake date to "4.2.2002"
Given I open an editor "re-100%wgs-plausi-2b" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave2"
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_11;art==transport;twertgutschrift==ja;@ablageart=(Filed)" throws the exception "2946"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_11"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
And I close the current editor

# (3) KM (kopf:pos) auf REK
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "4.2.2002" with Command Revalue
Given I set the fake date to "5.2.2002"
Given I open an editor "REpos-100%WGS-REK>0-KM(REK)" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "1kmrek"
And I set field "such" to "kmrek1"
# addk-aus-ek #And I set field "pos" to "$,,ptext==kost_qu_ek_11;art==transport;pwert==4;rekorrektur==ja;@ablageart=(Filed)"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_11"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos15;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos11;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# (4) Storno Kostenumlage
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "5.2.2002" with Command Revalue
Given I set the fake date to "6.2.2002"
Given I open an editor "REpos-100%WGS-REK>0-KM(REK)-storno" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record from editor "REpos-100%WGS-REK>0-KM(REK)"
And I set field "num135" to "1skmrek"
# And I set field "such" to "kmrek1"
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# (5) Storno der Rechnungskorrektur
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "6.2.2002" with Command Revalue
Given I set the fake date to "7.2.2002"
Given I open an editor "SREK" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+rek-134-1"
And I set field "nummer" to "1kmreks"
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# ---------------------------------------------------------------------------------------------
Scenario: RE---WGS--REK---KM(kopf:pos)---KMRF---SKMRF---SKM
# ---------------------------------------------------------------------------------------------

# graf:
# RE---WGS---REK---KM(kopf:pos)---KMRF---SKMRF---SKM
#      (1)   (2)      (3)         (4)     (5)    (6)

# addk-aus-ek ## Rechnung für add. kosten anlegen
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "7.2.2002" with Command Revalue
Given I set the fake date to "8.2.2002"
# addk-aus-ek #Given I open an editor "re-addkosten-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
# addk-aus-ek #And I set field "num4" to "140-add"
# addk-aus-ek #And I set field "lief" to "1"
# addk-aus-ek #And I set field "erfwaehr" to "eur"
# addk-aus-ek #And I set field "vom" to "."
# addk-aus-ek #And I set field "ueb" to "ja"
# addk-aus-ek #And I append rows
# addk-aus-ek # |artex     | pwert| konto | kstelle | ptext          |
# addk-aus-ek # |transport |     6| 50011 |     111 | kost_qu_ek_14a |
# addk-aus-ek #And I respond with answer "Ja" to the dialog with id "4841"
# addk-aus-ek #And I save the current editor

And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "8.2.2002" with Command Revalue
Given I set the fake date to "9.2.2002"
Given I open an editor "rechnung_fuer_artikel-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | 1      |
    | num4     | 11-15A |
    | such4    | R11-15A|
    | vom      | .      |
    | ueb      | ja     |
    | fakt     | ja     |
    | ebeleg   | MATRE1 |
    | budat    | .      |
And I append rows

# mit-mkv #    | artikel     | mge | preis | tterm | ptext    	| platz     |
# mit-mkv #    | E1EI-VO     | 10  | 10,00 | +4	   | kmzpos12a	|!dontChange|
# mit-mkv #    | E1EI-VO     | 15  | 15,00 | +4	   | kmzpos16a	|!dontChange|

# ohne-mkv #   | artikel     | mge | preis | tterm	| ptext   	| platz     | kstelle |
# ohne-mkv #   | E1EI-VO     | 10  | 10,00 | +4		| kmzpos12a |!dontChange|   110   |
# ohne-mkv #   | E1EI-VO     | 15  | 15,00 | +4		| kmzpos16a |!dontChange|   111   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift: Kommando Rechnung auf eine Rechnung
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "9.2.2002" with Command Revalue
Given I set the fake date to "10.2.2002"
Given I open an editor "140-wgs" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+140-add"
And I set fields
   | nummer | 140-wgs|
   | such   | wgs140 |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  ja    |
Then the table has 4 rows
And I set field "pwert" to "-6" in row 1
And I save the current editor

# (2) 100%Korrekturrechnung = [Voll]Rechnungskorrektur
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "10.2.2002" with Command Revalue
Given I set the fake date to "11.2.2002"
Given I open an editor "REpos-100%WGS-REK>0--2" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+140-add"
And I set fields
   | nummer | 140-rek |
   | such   | rek-140 |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
And I press button "burekorrektur"
Then field "artikel" has value "TRANSPORT" in row 1
Then field "ptext" has value "kost_qu_ek_14a" in row 1
And I set field "pwert" to "5" in row 1
And I save the current editor

# (3) KM (kopf:pos) auf REK
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "11.2.2002" with Command Revalue
Given I set the fake date to "12.2.2002"
Given I open an editor "REpos-100%WGS-REK>0-KM(REK)" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "140kmrek"
And I set field "such" to "kmrek140"
# addk-aus-ek #And I set field "pos" to "$,,ptext==kost_qu_ek_14a;art==transport;pwert==5;rekorrektur==ja;@ablageart=(Filed)"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_14a"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos12a;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos16a;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# (4)
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "12.2.2002" with Command Revalue
Given I set the fake date to "13.2.2002"
Given I open an editor "kostenumlrueck-140" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "140kmrf"
And I set field "name" to "KMRF"
And I set field "such" to "RUECKF140"
And I set field "origvorg" to "+140kmrek"
# And I set field "budat" to ".01.2002"
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# (5)
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "13.2.2002" with Command Revalue
Given I set the fake date to "14.2.2002"
Given I open an editor "kostenumlrueck-770Sa" from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+140kmrf"
And I set field "num135" to "140kmrfs"
And I set field "such" to "RUECKF140S"
And I save the current editor

# (6) Storno Kostenumlage
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "14.2.2002" with Command Revalue
Given I set the fake date to "15.2.2002"
Given I open an editor "sto-140kmrek" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+140kmrek"
And I set field "num135" to "140reks"
And I set field "such" to "KM140S"
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor



# ---------------------------------------------------------------------------------------------
Scenario: RE---WGS--REK---KM(kopf:pos)---SREK
# ---------------------------------------------------------------------------------------------

# graf:
# RE---WGS---REK---KM(kopf:pos)---SREK
#      (1)   (2)      (3)         (4)

# addk-aus-ek ## Rechnung für add. kosten anlegen
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "15.2.2002" with Command Revalue
Given I set the fake date to "16.2.2002"
# addk-aus-ek #Given I open an editor "re-addkosten-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
# addk-aus-ek #And I set field "num4" to "141-add"
# addk-aus-ek #And I set field "lief" to "1"
# addk-aus-ek #And I set field "erfwaehr" to "eur"
# addk-aus-ek #And I set field "vom" to "."
# addk-aus-ek #And I set field "ueb" to "ja"
# addk-aus-ek #And I append rows
# addk-aus-ek # |artex     | pwert| konto | kstelle | ptext          |
# addk-aus-ek # |transport |     6| 50011 |     111 | kost_qu_ek_14b |
# addk-aus-ek #And I respond with answer "Ja" to the dialog with id "4841"
# addk-aus-ek #And I save the current editor

And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "16.2.2002" with Command Revalue
Given I set the fake date to "17.2.2002"
Given I open an editor "rechnung_fuer_artikel-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | 1      |
    | num4     | 11-15B |
    | such4    | R11-15B|
    | vom      | .      |
    | ueb      | ja     |
    | fakt     | ja     |
    | ebeleg   | MATRE1 |
    | budat    | .      |
And I append rows

# mit-mkv #    | artikel     | mge | preis | tterm | ptext    	| platz     |
# mit-mkv #    | E1EI-VO     | 10  | 10,00 | +4	   | kmzpos12b	|!dontChange|
# mit-mkv #    | E1EI-VO     | 15  | 15,00 | +4	   | kmzpos16b	|!dontChange|

# ohne-mkv #   | artikel     | mge | preis | tterm	| ptext   	| platz     | kstelle |
# ohne-mkv #   | E1EI-VO     | 10  | 10,00 | +4		| kmzpos12b |!dontChange|   110   |
# ohne-mkv #   | E1EI-VO     | 15  | 15,00 | +4		| kmzpos16b |!dontChange|   111   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift: Kommando Rechnung auf eine Rechnung
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "17.2.2002" with Command Revalue
Given I set the fake date to "18.2.2002"
Given I open an editor "141-wgs" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+141-add"
And I set fields
   | nummer | 141-wgs|
   | such   | wgs141 |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  ja    |
Then the table has 4 rows
And I set field "pwert" to "-6" in row 1
And I save the current editor

# (2) 100%Korrekturrechnung = [Voll]Rechnungskorrektur
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "18.2.2002" with Command Revalue
Given I set the fake date to "19.2.2002"
Given I open an editor "REpos-100%WGS-REK>0--3" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+141-add"
And I set fields
   | nummer | 141-rek |
   | such   | rek-141 |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
And I press button "burekorrektur"
Then field "artikel" has value "TRANSPORT" in row 1
Then field "ptext" has value "kost_qu_ek_14b" in row 1
And I set field "pwert" to "7" in row 1
And I save the current editor


# (3) KM (kopf:pos) auf REK
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "19.2.2002" with Command Revalue
Given I set the fake date to "20.2.2002"
Given I open an editor "REpos-100%WGS-REK>0-KM(REK)" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "141kmrek"
And I set field "such" to "kmrek141"
# addk-aus-ek #And I set field "pos" to "$,,ptext==kost_qu_ek_14b;art==transport;pwert==7;rekorrektur==ja;@ablageart=(Filed)"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_14b"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos12b;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos16b;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# # IN CUCUMBER TUT DAS NICHT - manuell testen
# (4) Storno der Rechnungskorrektur
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "20.2.2002" with Command Revalue
Given I set the fake date to "21.2.2002"
# Given I open an editor "SREK" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "REpos-100%WGS-REK>0--3"
# And I set field "nummer" to "141-reks"
# # IN CUCUMBER TUT DAS NICHT
# # Rechnung für add. kosten anlegen
# #  TODO: CUCU-184
# # 1290 de      |Die Rechnung wurde mit einer Kostenumlage umgelegt. Wirklich stornieren?
# And I respond with answer "ja" to the dialog with id "1290"
# And I save the current editor


# ---------------------------------------------------------------------------------------------
Scenario: RE---WGS--REK0---KM(kopf:pos)  Nur Plausi
# ---------------------------------------------------------------------------------------------

# graf:             Plausi:
# RE---WGS---REK0---KM(kopf:pos)
#      (1)   (2)    (3pl) scheitert mangels wert > 0

# addk-aus-ek ## Rechnung für add. kosten anlegen
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "21.2.2002" with Command Revalue
Given I set the fake date to "22.2.2002"
# addk-aus-ek #Given I open an editor "re-addkosten-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
# addk-aus-ek #And I set field "num4" to "142-add"
# addk-aus-ek #And I set field "lief" to "1"
# addk-aus-ek #And I set field "erfwaehr" to "eur"
# addk-aus-ek #And I set field "vom" to "."
# addk-aus-ek #And I set field "ueb" to "ja"
# addk-aus-ek #And I append rows
# addk-aus-ek # |artex     | pwert| konto | kstelle | ptext          |
# addk-aus-ek # |transport |     6| 50011 |     111 | kost_qu_ek_14c |
# addk-aus-ek #And I respond with answer "Ja" to the dialog with id "4841"
# addk-aus-ek #And I save the current editor

And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "22.2.2002" with Command Revalue
Given I set the fake date to "23.2.2002"
Given I open an editor "rechnung_fuer_artikel-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | 1      |
    | num4     | 11-15C |
    | such4    | R11-15C|
    | vom      | .      |
    | ueb      | ja     |
    | fakt     | ja     |
    | ebeleg   | MATRE1 |
    | budat    | .      |
And I append rows

# mit-mkv #    | artikel     | mge | preis | tterm | ptext    	| platz     |
# mit-mkv #    | E1EI-VO     | 10  | 10,00 | +4	   | kmzpos12c	|!dontChange|
# mit-mkv #    | E1EI-VO     | 15  | 15,00 | +4	   | kmzpos16c	|!dontChange|

# ohne-mkv #   | artikel     | mge | preis | tterm	| ptext   	| platz     | kstelle |
# ohne-mkv #   | E1EI-VO     | 10  | 10,00 | +4		| kmzpos12c |!dontChange|   110   |
# ohne-mkv #   | E1EI-VO     | 15  | 15,00 | +4		| kmzpos16c |!dontChange|   111   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift: Kommando Rechnung auf eine Rechnung
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "23.2.2002" with Command Revalue
Given I set the fake date to "24.2.2002"
Given I open an editor "142-wgs" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+142-add"
And I set fields
   | nummer | 142-wgs|
   | such   | wgs142 |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  ja    |
Then the table has 4 rows
And I set field "pwert" to "-6" in row 1
And I save the current editor

# (2) 100%Korrekturrechnung = [Voll]Rechnungskorrektur
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "24.2.2002" with Command Revalue
Given I set the fake date to "25.2.2002"
Given I open an editor "REpos-100%WGS-REK>0--4" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+142-add"
And I set fields
   | nummer | 142-rek |
   | such   | rek-142 |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
And I press button "burekorrektur"
Then field "artikel" has value "TRANSPORT" in row 1
Then field "ptext" has value "kost_qu_ek_14c" in row 1
And I set field "pwert" to "0" in row 1
And I save the current editor

# (3pl) KM (kopf:pos) auf REK
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "25.2.2002" with Command Revalue
Given I set the fake date to "26.2.2002"
Given I open an editor "REpos-100%WGS-REK>0-KM(REK)" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "142kmrek"
And I set field "such" to "kmrek142"
#   263 de      |Bitte Beträge vervollständigen
And setting field "pos" to "$,,ptext==kost_qu_ek_14c;art==transport;pwert==0;rekorrektur==ja;@ablageart=(Filed)" throws the exception "263"
And I create a new row at the end of the table
# 3641 de      |Die Tabelle ist leer
And saving the current editor throws the exception "3641"
And I close the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor



# ---------------------------------------------------------------------------------------------
Scenario: REpos - KM - ! 100%WGS : REpos - KM - KMTRF - 100%WGS
# ---------------------------------------------------------------------------------------------

# graf:
# (136-add)   (300)                  __KMTRF
# RE-----------KM ___(tab:kmzpos3)--/  (2)
#  \           (1)
#   \
#    \______________100%WGS __________________100%WGS
#                   scheit. (1a)              scheit. (2a)

# ---- Kostenumlagen erzeugen (1) ----
# kopierquelle : std/test/cucumber/kostenumlage/ref_km_rueck_basis1.template.feature
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "26.2.2002" with Command Revalue
Given I set the fake date to "27.2.2002"
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

# ---- EK-WGS ----
#  die Kostenumlagequelle kost_qu_ek_4 ist in Rechnungsnummer 136-add enthalten
#  Plausi (1a) aus graf
#  bearbeitet in BW2-1841, BW2-1840:
#  diese WGS darf nicht erfassbar/buchbar sein, weil KM weder storniert noch rückgeführt ist

And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "27.2.2002" with Command Revalue
Given I set the fake date to "28.2.2002"
Given I open an editor "136-wgs" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+136-add"
And I set fields
   | nummer | 136wgs     |
   | such   | wgs136     |
   | tterm  | .          |
   | budat  | .          |
   | vom    | .          |
   | ueb    |  ja        |
Then the table has 6 rows
Then field "artikel" has value "TRANSPORT" in row 1
Then field "artikel" has value "TRANSPORT" in row 2
Then field "artikel" has value "TRANSPORT" in row 3
And I set field "pwert" to "-10" in row 1
# 9264 | Kaufmännische Gutschrift nicht möglich, weil die betroffene Rechnung als Quelle in der
#        Kostenumlage (160,135,0) beinhaltet ist.
#        Stornieren Sie zuerst die ursprüngliche(n) Kostenumlage(n) oder führen Sie diese zurück.
And saving the current editor throws the exception "9264"
And I close the current editor


# ----- KMTRF -----
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "28.2.2002" with Command Revalue
Given I set the fake date to "1.3.2002"
Given I open an editor "kostenuml-teilrueck-300" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "301"
And I set field "name" to "KMRF"
And I set field "such" to "RF301"
And I set field "origvorg" to "+U3-2ZEI"
Then field "budat" has value "10.01.02"
And I set field "budat" to "01.02.2002"
And I set field "zurueckfuehren" to "nein" in row 1
And I save the current editor

# ---- EK-WGS ----
#  die Kostenumlagequelle kost_qu_ek_4 ist in Rechnungsnummer 136-add enthalten
#  Plausi (2a) aus graf
#  bearbeitet in BW2-1841, BW2-1840:
#  diese WGS darf immer noch nicht erfassbar/buchbar sein, weil KM nur teilrückgeführt

# versuch TWGS
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "1.3.2002" with Command Revalue
Given I set the fake date to "2.3.2002"
Given I open an editor "136-wgs2-plausi" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+136-add"
And I set fields
   | nummer | 136wgs2     |
   | such   | wgs136.2    |
   | tterm  | .          |
   | budat  | .          |
   | vom    | .          |
   | ueb    |  ja        |
Then the table has 6 rows
Then field "artikel" has value "TRANSPORT" in row 1
Then field "artikel" has value "TRANSPORT" in row 2
Then field "artikel" has value "TRANSPORT" in row 3
And I set field "pwert" to "-10" in row 1

# 9264 | Kaufmännische Gutschrift nicht möglich, weil die betroffene Rechnung als Quelle in der
#        Kostenumlage (1..9,135,0) beinhaltet ist.
#        Stornieren Sie zuerst die ursprüngliche(n) Kostenumlage(n) oder führen Sie diese zurück.
And saving the current editor throws the exception "9264"
And I close the current editor

# ----- KMRRF -----
# ist voraussetzung, dass anschliessend WGS möglich wird.
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "2.3.2002" with Command Revalue
Given I set the fake date to "3.3.2002"
Given I open an editor "kostenuml-restrueck-300" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "302"
And I set field "name" to "KMRF"
And I set field "such" to "RF302"
And I set field "origvorg" to "+U3-2ZEI"
Then field "budat" has value "10.01.02"
And I set field "budat" to "01.02.2002"
And I save the current editor

# nur wgs der gesamten pos. 1
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "3.3.2002" with Command Revalue
Given I set the fake date to "4.3.2002"
Given I open an editor "136-wgs3" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+136-add"
And I set fields
   | nummer | 136wgs3     |
   | such   | wgs136.3    |
   | tterm  | .          |
   | budat  | .          |
   | vom    | .          |
   | ueb    |  ja        |
Then the table has 6 rows
Then field "artikel" has value "TRANSPORT" in row 1
Then field "artikel" has value "TRANSPORT" in row 2
Then field "artikel" has value "TRANSPORT" in row 3
And I set field "pwert" to "-40" in row 1
And I save the current editor

# jetzt prüfung der absicherung gegen mehrfache gutschrift einer neutralen rechnungsposition.
# plus änderung und erstellung einer vollständigen restgutschrift.

And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "4.3.2002" with Command Revalue
Given I set the fake date to "5.3.2002"
Given I open an editor "136-wgs4" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+136-add"
And I set fields
   | nummer | 136wgs4     |
   | such   | wgs136.4    |
   | tterm  | .          |
   | budat  | .          |
   | vom    | .          |
   | ueb    |  ja        |

# diesen button NICHT drücken!  Plausi muss trotzdem kommen!    And I press button "buwertgutschrift"
# denn die absicherung (6825 unterhalb) ist auch notwendig, ohne den omniösen button "buwertgutschrift" der
#  nur im menü gedrückt wird, bei...
#  - <beleg anfügen>
#  - selbst erstellten menükommandos ohne button "buwertgutschrift"
# diese plausi wurde bearbeitet in BW2-1842

Then the table has 6 rows
Then field "artikel" has value "TRANSPORT" in row 1
Then field "artikel" has value "TRANSPORT" in row 2
Then field "artikel" has value "TRANSPORT" in row 3
And I set field "pwert" to "-40" in row 1

# Wertgutschrift mit komplett gutgeschriebenen Positionen kann nicht gespeichert werden
# 6825 de |Bereits komplett gutgeschriebene Positionen können nicht erneut in Wertgutschrift übernommen werden.
Then saving the current editor throws the exception "6825"

# nachbessern: Entfernen der komplett gutgeschriebenen Position
And I press button "buwertgutschrift"
# danach ist position 1 weg!

Then the table has 5 rows
Then field "artikel" has value "NS." in row 3
And I set field "pwert" to "-50" in row 1
And I set field "pwert" to "32" in row 2
And I save the current editor


# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# ---------------------------------------------------------------------------------------------
Scenario: RE----KM----KMRF---WGS---REK  quellfremdwaehrung ungleich zielfremdwaehrung
# ---------------------------------------------------------------------------------------------

#                                 __KM(als kopf:pos)
#                                /  scheit. (4b)
# graf:                         /
# RE----KM----KMRF-------------WGS------------------REK
#  \    (2)   (3)              (4)                  (5)
#   \            \
#    \            \________________Storno KMRF ________Storno KMRF
#     \                            scheitert (4c)      scheitert (5b)
#      \
#       \__KM(als kopf:pos)_______KM(als kopf:pos)_____KM(als kopf:pos)
#          scheit. (2a)           scheit. (4a)         scheit. (5a)

# addk-aus-ek ## Rechnung für add. kosten anlegen
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "5.3.2002" with Command Revalue
Given I set the fake date to "6.3.2002"
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

And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "6.3.2002" with Command Revalue
Given I set the fake date to "7.3.2002"
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
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "7.3.2002" with Command Revalue
Given I set the fake date to "8.3.2002"
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
Then field "budat" has value "07.03.02"
And I save the current editor


# (plausi 2a aus graf - keine datenspeicherung)
# // 8996 de      |Kostenumlage zur Position vorhanden.
# s. exception rechts =>
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "8.3.2002" with Command Revalue
Given I set the fake date to "9.3.2002"
Given I open an editor "143-plausi-2a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1"
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14d;pwert==8;art==transport;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "8996"
And I close the current editor

# (3)
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "9.3.2002" with Command Revalue
Given I set the fake date to "10.3.2002"
Given I open an editor "kostenumlrueck-143" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "143kmrf"
# kein name, damit std.text gezogen wird (testrelevant!)    And I set field "name" to "KMRF"
And I set field "origvorg" to "+143km"
And I set field "such" to "RF143"
# And I set field "budat" to "25.01.2002"
And I save the current editor


# (4) Wertgutschrift: Kommando Rechnung auf eine Rechnung
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "10.3.2002" with Command Revalue
Given I set the fake date to "11.3.2002"
Given I open an editor "143-wgs" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+143-add"
And I set fields
   | nummer | 143-wgs|
   | such   | wgs143 |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  ja    |
Then the table has 4 rows
And I set field "pwert" to "-8" in row 1
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# (plausi 4a aus graf - keine datenspeicherung)
# // 8996 de      |Kostenumlage zur Position vorhanden.
# s. exception rechts =>
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "11.3.2002" with Command Revalue
Given I set the fake date to "12.3.2002"
Given I open an editor "143-plausi-4a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1"
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14d;pwert==8;art==transport;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "8996"
And I close the current editor

# (plausi 4b aus graf - keine datenspeicherung)
# // 2946 de  |Kostenumlagen zu Wertgutschriftpositionen sind nicht erlaubt.
# s. exception rechts =>
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "12.3.2002" with Command Revalue
Given I set the fake date to "13.3.2002"
Given I open an editor "143-plausi-4b" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave2"
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14d;art==transport;twertgutschrift==ja;@ablageart=(Filed)" throws the exception "2946"
And I close the current editor

# (plausi 4c aus graf - keine datenspeicherung)
# 2921 de |Stornierungen von Kostenumlagerückführungen zu Rechnungspositionen mit Wertgutschrift sind nicht erlaubt.
Then opening an editor from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+RF143" throws the exception "2921"

# (5) 100%Korrekturrechnung = [Voll]Rechnungskorrektur
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "13.3.2002" with Command Revalue
Given I set the fake date to "14.3.2002"
Given I open an editor "143-rek" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+143-add"
And I set fields
   | nummer | 143-rek |
   | such   | rek-143 |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
And I press button "burekorrektur"
Then field "artikel" has value "TRANSPORT" in row 1
Then field "ptext" has value "kost_qu_ek_14d" in row 1
And I set field "pwert" to "2" in row 1
And I save the current editor

# (plausi 5a aus graf - keine datenspeicherung)
# // 8996 de      |Kostenumlage zur Position vorhanden.
# s. exception rechts =>
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "14.3.2002" with Command Revalue
Given I set the fake date to "15.3.2002"
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
Scenario: RE----KM----SKM---WGS---REK---KM---KMRF
# ---------------------------------------------------------------------------------------------

#                                  __KM(als kopf:pos)
#                                 /  scheit. (4b)           KM:andere Zielpositionen als
#                                /                         /   in der ursprünglichen KM !!!
# graf:                         /                         /
# RE----KM----SKM--------------WGS------------------REK---KM------KMRF
#  \    (2)   (3)              (4)                  (5)   (6)     (7)
#   \
#    \_____KM(als kopf:pos)______KM(als kopf:pos)_____KM(als kopf:pos)
#          scheit. (2a)          scheit. (4a)         scheit. (5a)

# addk-aus-ek ## Rechnung für add. kosten anlegen
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "15.3.2002" with Command Revalue
Given I set the fake date to "16.3.2002"
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

And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "16.3.2002" with Command Revalue
Given I set the fake date to "17.3.2002"
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
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "17.3.2002" with Command Revalue
Given I set the fake date to "18.3.2002"
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
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "18.3.2002" with Command Revalue
Given I set the fake date to "19.3.2002"
Given I open an editor "144-plausi-2a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1"
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14e;pwert==9;art==transport;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "8996"
And I close the current editor

# (3) Storno Kostenumlage
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "19.3.2002" with Command Revalue
Given I set the fake date to "20.3.2002"
Given I open an editor "144-km-storno" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+144km"
And I set field "num135" to "144kms"
And I set field "such" to "kms144"
And I save the current editor


# (4) Wertgutschrift: Kommando Rechnung auf eine Rechnung
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "20.3.2002" with Command Revalue
Given I set the fake date to "21.3.2002"
Given I open an editor "144-wgs" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+144-add"
And I set fields
   | nummer | 144-wgs|
   | such   | wgs144 |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  ja    |
Then the table has 4 rows
And I set field "pwert" to "-9" in row 1
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor



# (plausi 4a aus graf - keine datenspeicherung)
# // 2930 de  |Kostenumlagen zu wertgutgeschiebenen Rechnungspositionen sind nicht erlaubt.
# s. exception rechts =>
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "21.3.2002" with Command Revalue
Given I set the fake date to "22.3.2002"
Given I open an editor "144-plausi-4a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1"
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14e;pwert==9;art==transport;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "2930"
And I close the current editor

# (plausi 4b aus graf - keine datenspeicherung)
# // 2946 de  |Kostenumlagen zu Wertgutschriftpositionen sind nicht erlaubt.
# s. exception rechts =>
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "22.3.2002" with Command Revalue
Given I set the fake date to "23.3.2002"
Given I open an editor "144-plausi-4b" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave2"
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14e;art==transport;twertgutschrift==ja;@ablageart=(Filed)" throws the exception "2946"
And I close the current editor

# (5) 100%Korrekturrechnung = [Voll]Rechnungskorrektur
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "23.3.2002" with Command Revalue
Given I set the fake date to "24.3.2002"
Given I open an editor "144-rek" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+144-add"
And I set fields
   | nummer | 144-rek |
   | such   | rek-144 |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
And I press button "burekorrektur"
Then field "artikel" has value "TRANSPORT" in row 1
Then field "ptext" has value "kost_qu_ek_14e" in row 1
And I set field "pwert" to "1" in row 1
And I save the current editor

# (plausi 5a aus graf - keine datenspeicherung)
# // 2930 de  |Kostenumlagen zu wertgutgeschiebenen Rechnungspositionen sind nicht erlaubt.
# s. exception rechts =>
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "24.3.2002" with Command Revalue
Given I set the fake date to "25.3.2002"
Given I open an editor "144-plausi-5a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1"
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14e;pwert==9;art==transport;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "2930"
And I close the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# (6) KM (kopf:pos) auf REK
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "25.3.2002" with Command Revalue
Given I set the fake date to "26.3.2002"
Given I open an editor "144-kmrek" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "144kmrek"
And I set field "such" to "kmrek144"
# addk-aus-ek #And I set field "pos" to "$,,ptext==kost_qu_ek_14e;kopf^fakt==nein;rekorrektur==ja;art==transport;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
# !!!! andere Zielpositionen als in der ursprünglichen KM !!!
And I set field "pos" to "$,,ptext==kmzpos12a;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos16c;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor

# (7)
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "26.3.2002" with Command Revalue
Given I set the fake date to "27.3.2002"
Given I open an editor "kostenumlrueck-144" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "144kmrf"
# kein name, damit std.text gezogen wird (testrelevant!)    And I set field "name" to "KMRF"
And I set field "origvorg" to "+144kmrek"
And I set field "such" to "RF144rek"
And I set field "budat" to "."
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# ---------------------------------------------------------------------------------------------
Scenario: RE---KM---KMTRF---KMRRF---WGS---REK
# ---------------------------------------------------------------------------------------------

#                                      __KM(als kopf:pos)
#                                     /  scheit. (4b)
# graf:                              /
# RE----KM----KMTRF--------KMRRF----WGS------------------REK
#  \    (2)   (3a)         (3b)     (4)                  (5)
#   \
#    \_____KM(als kopf:pos)___________KM(als kopf:pos)_____KM(als kopf:pos)
#          scheit. (2a)               scheit. (4a)         scheit. (5a)

# addk-aus-ek ## Rechnung für add. kosten anlegen
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "27.3.2002" with Command Revalue
Given I set the fake date to "28.3.2002"
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

And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "28.3.2002" with Command Revalue
Given I set the fake date to "1.4.2002"
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
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "1.4.2002" with Command Revalue
Given I set the fake date to "2.4.2002"
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
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "2.4.2002" with Command Revalue
Given I set the fake date to "3.4.2002"
Given I open an editor "145-plausi-2a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1"
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14f;pwert==10;art==transport;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "8996"
And I close the current editor

# (3a)
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "3.4.2002" with Command Revalue
Given I set the fake date to "4.4.2002"
Given I open an editor "kostenumlrueck-145" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "145kmrfa"
# kein name, damit std.text gezogen wird (testrelevant!)    And I set field "name" to "KMRF"
And I set field "origvorg" to "+145km"
And I set field "such" to "RF145-A"
# And I set field "budat" to "25.01.2002"
And I set field "zurueckfuehren" to "nein" in row 2
And I save the current editor

# (3b)  KMRRF Restrückführung der Kostenumlage, danach KOMPLETT zurückgeführt.
#
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "4.4.2002" with Command Revalue
Given I set the fake date to "5.4.2002"
Given I open an editor "kostenumlrueck-145" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "145kmrfb"
# kein name, damit std.text gezogen wird (testrelevant!)    And I set field "name" to "KMRF"
And I set field "origvorg" to "+145km"
And I set field "such" to "RF145-B"
# And I set field "budat" to "25.01.2002"
And I save the current editor


# (4) Wertgutschrift: Kommando Rechnung auf eine Rechnung
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "5.4.2002" with Command Revalue
Given I set the fake date to "6.4.2002"
Given I open an editor "145-wgs" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+145-add"
And I set fields
   | nummer | 145-wgs|
   | such   | wgs145 |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  ja    |
Then the table has 4 rows
And I set field "pwert" to "-10" in row 1
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# (plausi 4a aus graf - keine datenspeicherung)
# // 8996 de      |Kostenumlage zur Position vorhanden.
# s. exception rechts =>
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "6.4.2002" with Command Revalue
Given I set the fake date to "7.4.2002"
Given I open an editor "145-plausi-4a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1"
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14f;pwert==10;art==transport;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "8996"
And I close the current editor

# (plausi 4b aus graf - keine datenspeicherung)
# // 2946 de  |Kostenumlagen zu Wertgutschriftpositionen sind nicht erlaubt.
# s. exception rechts =>
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "7.4.2002" with Command Revalue
Given I set the fake date to "8.4.2002"
Given I open an editor "145-plausi-4b" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave2"
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14f;art==transport;twertgutschrift==ja;@ablageart=(Filed)" throws the exception "2946"
And I close the current editor

# (5) 100%Korrekturrechnung = [Voll]Rechnungskorrektur
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "8.4.2002" with Command Revalue
Given I set the fake date to "9.4.2002"
Given I open an editor "145-rek" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+145-add"
And I set fields
   | nummer | 145-rek |
   | such   | rek-145 |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
And I press button "burekorrektur"
Then field "artikel" has value "TRANSPORT" in row 1
Then field "ptext" has value "kost_qu_ek_14f" in row 1
And I set field "pwert" to "6" in row 1
And I save the current editor

# (plausi 5a aus graf - keine datenspeicherung)
# // 8996 de      |Kostenumlage zur Position vorhanden.
# s. exception rechts =>
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "9.4.2002" with Command Revalue
Given I set the fake date to "10.4.2002"
Given I open an editor "145-plausi-5a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1"
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14f;pwert==10;art==transport;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "8996"
And I close the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------------------------
Scenario: LS---TeilRE1---TeilRE2---TeilRE3---KM(TransportkostenRE auf TeilRE2)---WGS(TransportkostenRE)---KMR---WGS(TransportkostenRE)---REK
# -------------------------------------------------------------------------------------------------------------------------------------------

# EK-Rechnung Transportkosten
# addk-aus-ek ## Rechnung für add. kosten anlegen
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "10.4.2002" with Command Revalue
Given I set the fake date to "11.4.2002"
# addk-aus-ek #Given I open an editor "re-addkosten-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
# addk-aus-ek #And I set field "num4" to "146-add"
# addk-aus-ek #And I set field "lief" to "1"
# addk-aus-ek #And I set field "erfwaehr" to "eur"
# addk-aus-ek #And I set field "vom" to "."
# addk-aus-ek #And I set field "ueb" to "ja"
# addk-aus-ek #And I append rows
# addk-aus-ek # |artex     | pwert| konto | kstelle | ptext          |
# addk-aus-ek # |transport |     9| 50011 |     111 | kost_qu_ek_14g |
# addk-aus-ek #And I respond with answer "Ja" to the dialog with id "4841"
# addk-aus-ek #And I save the current editor

# EK-Lieferschein
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "11.4.2002" with Command Revalue
Given I set the fake date to "12.4.2002"
Given I open an editor "lieferschein_fuer_artikel-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief     | 1      |
    | num4     | 11-15G |
    | such4    | L11-15G|
    | vom      | .      |
    | ueb      | ja     |
    | ebeleg   | MATRE1 |
And I append rows

# mit-mkv #    | artikel     | mge | preis | ptext    	| platz     |
# mit-mkv #    | E1EI-VO     | 100  | 10,00 | kmzpos12g	|!dontChange|
# mit-mkv #    | E1EI-VO     | 150  | 15,00 | kmzpos16g	|!dontChange|

# ohne-mkv #   | artikel     | mge | preis | ptext   	| platz     | kstelle |
# ohne-mkv #   | E1EI-VO     | 100  | 10,00 | kmzpos12g |!dontChange|   110   |
# ohne-mkv #   | E1EI-VO     | 150  | 15,00 | kmzpos16g |!dontChange|   111   |
And I save the current editor
And I close the current editor

# EK-Teilrechnung 1
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "12.4.2002" with Command Revalue
Given I set the fake date to "13.4.2002"
Given I open an editor "rechnung1_fuer_artikel-1" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "lieferschein_fuer_artikel-1"
And I set fields
    | lief     | 1       |
    | num4     | 11-15GR1|
    | such4    | R11-15G1|
    | vom      | .       |
    | ueb      | ja      |
    | ebeleg   | MATRE1  |
    | budat    | .       |
And I set field "mge" to "40" in row 1
And I set field "mge" to "50" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# EK-Teilrechnung 2
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "13.4.2002" with Command Revalue
Given I set the fake date to "14.4.2002"
Given I open an editor "rechnung2_fuer_artikel-1" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "lieferschein_fuer_artikel-1"
And I set fields
    | lief     | 1       |
    | num4     | 11-15GR2|
    | such4    | R11-15G2|
    | vom      | .       |
    | ueb      | ja      |
    | ebeleg   | MATRE1  |
    | budat    | .       |
And I set field "mge" to "25" in row 1
And I set field "mge" to "40" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# EK-Teilrechnung 3
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "14.4.2002" with Command Revalue
Given I set the fake date to "15.4.2002"
Given I open an editor "rechnung3_fuer_artikel-1" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "lieferschein_fuer_artikel-1"
And I set fields
    | lief     | 1       |
    | num4     | 11-15GR3|
    | such4    | R11-15G3|
    | vom      | .       |
    | ueb      | ja      |
    | ebeleg   | MATRE1  |
    | budat    | .       |
And I set field "mge" to "15" in row 1
And I set field "mge" to "25" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# KM Transportkosten auf Lieferschein (nicht auf Rechnung!)
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "15.4.2002" with Command Revalue
Given I set the fake date to "16.4.2002"
Given I open an editor "REpos-km-d" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "146km"
And I set field "such" to "km146"
# addk-aus-ek #And I set field "pos" to "$,,ptext==kost_qu_ek_14g;art==transport;@ablageart=(Filed)"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_14b"
# unbenutzt: addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to ""
And I create a new row at the end of the table

# umlegung auf die LS-Pos. / die hat ein früheres buchungsdatum 12.04.02, als in den bewertungen schon angekommen ist 13.-15.4 !
And I set field "pos" to "$,,kopf^num4==11-15G;ptext==kmzpos12g;@gruppe=2;@datenbank=4;@ablageart=lebendig" in row !lastRow

# ZUR INFO
# mit der umlegung der kosten auf diese rechungspostion würde das buchungsdatum der KM auf den 15.04.02 gehen und
# ebenso in der bewertung.
# And I set field "pos" to "$,,kopf^num4=11-15GR3;ptext==kmzpos12g;@gruppe=2;@datenbank=4;@ablageart=abgelegt" in row !lastRow
# And I set field "pos" to "(384,4,0)" in row !lastRow

And I set field "proz" to "35" in row !lastRow
Then field "origposbudat" has value "12.04.02" in row !lastRow

And I create a new row at the end of the table
# umlegung auf die LS-Pos. / die hat ein früheres buchungsdatum 12.04.02, als in den bewertungen schon angekommen ist 13.-15.4 !
And I set field "pos" to "$,,kopf^num4==11-15G;ptext==kmzpos16g;@gruppe=2;@datenbank=4;@ablageart=lebendig" in row !lastRow
Then field "origposbudat" has value "12.04.02" in row !lastRow
And I set field "proz" to "65" in row !lastRow
# And I wait for file cucudbg for debugging
And I save the current editor

# Wertgutschrift auf Transportrechnung (Kostenquelle) verboten!
# wurde in BW2-1841, BW2-1840 bearbeitet
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "16.4.2002" with Command Revalue
Given I set the fake date to "17.4.2002"
Given I open an editor "146-wgs-plausi" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+146-add"
And I set fields
   | nummer | 146wgerr|
   | such   | wgs146err |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  ja    |
# Komplettgutschrift erstellen
And I press button "komplettieren"
Then the table has 4 rows

# 9264 | Kaufmännische Gutschrift nicht möglich, weil die betroffene Rechnung als Quelle in der
#        Kostenumlage (...,135,0) beinhaltet ist.
#        Stornieren Sie zuerst die ursprüngliche(n) Kostenumlage(n) oder führen Sie diese zurück.
And saving the current editor throws the exception "9264"
And I close the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# KM-Rückführung, da keine WGS auf Transportrechnung 146-add möglich ist
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "17.4.2002" with Command Revalue
Given I set the fake date to "18.4.2002"
Given I open an editor "kostenumlrueck-146" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "146kmrfb"
# kein name, damit std.text gezogen wird (testrelevant!)    And I set field "name" to "KMRF"
And I set field "origvorg" to "+146km"
And I set field "such" to "RF146-B"
# And I set field "budat" to "25.01.2002"
And I save the current editor

# nun WGS auf Transportrechnung 146-add (Kostenquelle) durchführen - nach KM-Rückführung erlaubt
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "18.4.2002" with Command Revalue
Given I set the fake date to "19.4.2002"
Given I open an editor "146-wgs" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+146-add"
And I set fields
   | nummer | 146-wgs|
   | such   | wgs146 |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  ja    |
# Komplettgutschrift erstellen
# ohne den da: And I press button "komplettieren"
And I set field "pwert" to "-9" in row 1
Then the table has 4 rows
And I save the current editor


# ---------------------------------------------------------------------------------------------
Scenario: RE----KM----KMRF---WGS---SWGS---SKMRF quellfremdwaehrung ungleich zielfremdwaehrung
#  ähnlich wie 143
# ---------------------------------------------------------------------------------------------

#                            ___________________________KM(als kopf:pos)
#                           /                           scheit. (6a)
# graf:                    /
# RE----KM----KMRF--------WGS-----SWGS--------------SKMRF
#  \    (2)   (3)         (4)     (5)                (6)
#   \
#    \_____KM(als kopf:pos)__________KM(als kopf:pos)___KM(als kopf:pos)
#          scheit. (2a)              scheit. (5a)       scheit. (6b)

# addk-aus-ek ## Rechnung für add. kosten anlegen
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "19.4.2002" with Command Revalue
Given I set the fake date to "20.4.2002"
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

And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "20.4.2002" with Command Revalue
Given I set the fake date to "21.4.2002"
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
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "21.4.2002" with Command Revalue
Given I set the fake date to "22.4.2002"
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
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "22.4.2002" with Command Revalue
Given I set the fake date to "23.4.2002"
Given I open an editor "147-plausi-2a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1"
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14h;pwert==10;art==transport;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "8996"
And I close the current editor

# (3)
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "23.4.2002" with Command Revalue
Given I set the fake date to "24.4.2002"
Given I open an editor "kostenumlrueck-147" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "147kmrf"
# kein name, damit std.text gezogen wird (testrelevant!)    And I set field "name" to "KMRF"
And I set field "origvorg" to "+147km"
And I set field "such" to "RF147"
# And I set field "budat" to "25.01.2002"
And I save the current editor


# (4) Wertgutschrift: Kommando Rechnung auf eine Rechnung
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "24.4.2002" with Command Revalue
Given I set the fake date to "25.4.2002"
Given I open an editor "147-wgs" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+147-add"
And I set fields
   | nummer | 147-wgs|
   | such   | wgs147 |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  ja    |
Then the table has 4 rows
And I set field "pwert" to "-10" in row 1
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# (5) storno wgs
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "25.4.2002" with Command Revalue
Given I set the fake date to "26.4.2002"
Given I open an editor "Swgs" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+wgs147"
And I set fields
    | num4   | 147-swgs  |
And I save the current editor

# (plausi 5a aus graf - keine datenspeicherung)
# // 8996 de      |Kostenumlage zur Position vorhanden.
# s. exception rechts =>
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "26.4.2002" with Command Revalue
Given I set the fake date to "27.4.2002"
Given I open an editor "147-plausi-5a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1"
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14h;pwert==10;art==transport;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "8996"
And I close the current editor

# (6) storno kmrf ist nach storno der wgs erlaubt:
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "27.4.2002" with Command Revalue
Given I set the fake date to "28.4.2002"
Given I open an editor "sto-kostenumlrueck-rf147" from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+RF147"
And I set field "num135" to "147srf"
And I set field "such" to "SRF147"
And I set field "name" to "SKMRF"
And I save the current editor

# (plausi 6a aus graf - keine datenspeicherung)
# // 2946 de  |Kostenumlagen zu Wertgutschriftpositionen sind nicht erlaubt.
# s. exception rechts =>
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "28.4.2002" with Command Revalue
Given I set the fake date to "1.5.2002"
Given I open an editor "147-plausi-6a" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave2"
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14h;art==transport;treart==Stornierte Kaufmaennische Gutschrift;twertgutschrift==ja;@ablageart=(Filed)" throws the exception "2946"
And I close the current editor

# (plausi 6b aus graf - keine datenspeicherung)
# // 8996 de      |Kostenumlage zur Position vorhanden.
# s. exception rechts =>
And I run Revaluation
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.2002" until enddate "1.5.2002" with Command Revalue
Given I set the fake date to "2.5.2002"
Given I open an editor "147-plausi-6b" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "dontsave1"
# addk-aus-ek #And setting field "pos" to "$,,ptext==kost_qu_ek_14h;pwert==10;art==transport;twertgutschrift==nein;@ablageart=(Filed)" throws the exception "8996"
And I close the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
