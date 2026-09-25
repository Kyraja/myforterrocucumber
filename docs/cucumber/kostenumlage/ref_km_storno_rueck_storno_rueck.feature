# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      : 
# *****************************************************************************
@persistent
Feature: BW2-1520 Kostenumlage stornieren u. Rücklieferungen 

Background:
Given I set the fake date to "21.01.2002"

# ---------------------------------------------------------------------------------------------
Scenario: schaffen einer weiterverwendbaren schematischen bewegungsdatenbasis
# ------------------------------------------------------------------------
#
# die anzahl zuordnungen/zeile ergibt die anzahl tabellenzeilen
# in der km
#
# die anzahl zuordnungen/spalte ergibt die mehrfachbelegung von 
# zugängen mit km
#
# nicht vorhandene zuordnung bedeutet: derzeit keine verwendung von
# zeilen oder spalten
#
# ----------------|------------------------------------------------------
#                 | Zielposition auf die die kostenquelle umgelegt wird:
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
#                 | 11| 15| 2 | 3 | 4 | 5 | 6 | 7 | 8 |
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
# kostenquelle:   |   |   |   |   |   |   |   |   |   |
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
# kost_qu_ek_11   |100|   |   |   |   |   |   |100|   |
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
# kost_qu_ek_15   |   |150|   |   |   |   |   |   |   |
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
# kost_qu_ek_2_12 |   |   |   |200|   |   |   |   |   |
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
# kost_qu_ek_3    |400|   |400|   |400|400|   |   |   |           400 = U4-4ZEI
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
# kost_qu_ek_4    |   |   |300|300|   |   |   |   |   |           300 = U3-2ZEI
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
# kost_qu_ek_5_12 |   |   |500|500|   |   |500|   |   |           500 = U5-3ZEI-12
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
# kost_qu_ek_6    |   |   |   |   |   |   |   |   |600|           600 = U6-NEG (-)           
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
#
# in KM 200: identische guv konten und kostenobjekte, damit ohne umbuchung 
#                                                           ~~~~~~~~~~~~~~
#            in der km und der rückführung erlaubt!
#
# in KM 500: identische guv konto und kostenobjekt mit zielpos3, 
#            deshalb nur teilweise umbuchung in der km und der rückführung!
#                        ~~~~~~~~~~~~~~~~~~~
# ---------------------------------------------------------------------------------------------
Given I'm logged in with password "sy"
Given I set the fake date to "21.01.2002"

Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "E1EI-VO"
And I set field "gemein" to ""
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "E1LO-VO"
And I set field "gemein" to ""
And I save the current editor

# addk-aus-ek:
# ------------
# Zusatzposition Transport
Given I open an editor "zusatzp_transport" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set field "nummer" to "1transp"
And I set field "such" to "transport"
And I set field "name" to "transportkosten"
And I save the current editor

# addk-aus-ek:
# ------------
# Rechnung für add. kosten anlegen
Given I open an editor "re-addkosten1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "134-add"
And I set field "lief" to "1"
And I set field "erfwaehr" to "gbp"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I append rows
 |artex     | pwert| konto | kstelle | ptext         | 
 |transport |     6| 50011 |     111 | kost_qu_ek_11 |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# addk-aus-FIBU ## --- km-fähige fibu-buchung -----
# addk-aus-FIBU #Given I open an editor "buchung_1km_faehige_bilanzzeile" from table "(Entry):(Entry)" with command "NEW" for record ""
# addk-aus-FIBU #And I set field "such" to "b134-add"
# addk-aus-FIBU #And I set field "erfwaehr" to "gbp"
# addk-aus-FIBU #And I set field "budat" to "10.01.2002"
# addk-aus-FIBU #And I set field "text" to "qu:z2:11"
# addk-aus-FIBU #And I append rows
# addk-aus-FIBU # | konto | kstelle   |ewsbetr| ptext         | 
# addk-aus-FIBU # | 10000 |!dontChange|       |               |
# addk-aus-FIBU # | 50011 |     111   |     6 | kost_qu_ek_11 |
# addk-aus-FIBU #And I respond with answer "Ja" to the dialog with id "1941"
# addk-aus-FIBU #And I save the current editor


# Rechnung für add. kosten anlegen
# addk-aus-ek:
# ------------
Given I open an editor "re-addkosten2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "135-add"
And I set field "lief" to "1"
And I set field "erfwaehr" to "eur"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I append rows
 |artex     | pwert| konto | kstelle | ptext          | 
 |transport |    10| 50011 |     111 | kost_qu_ek_15  |
 |transport |    20| 50012 |     112 | kost_qu_ek_2_12|
 |transport |    30| 50013 |     113 | kost_qu_ek_3   |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# addk-aus-FIBU ## --- km-fähige fibu-buchung -----
# addk-aus-FIBU #Given I open an editor "buchung_2km_faehige_bilanzzeile" from table "(Entry):(Entry)" with command "NEW" for record ""
# addk-aus-FIBU #And I set field "such" to "b135-add"
# addk-aus-FIBU #And I set field "budat" to "10.01.2002"
# addk-aus-FIBU #And I set field "text" to "qu:z2:15,z3:2_12,z4:3"
# addk-aus-FIBU #And I append rows
# addk-aus-FIBU # | konto | kstelle   |ewsbetr| ptext        | 
# addk-aus-FIBU # | 10000 |!dontChange|       |              |
# addk-aus-FIBU # | 50011 |     111   |    10 | kost_qu_ek_15 |
# addk-aus-FIBU # | 50012 |     112   |    20 | kost_qu_ek_2_12 |
# addk-aus-FIBU # | 50013 |     113   |    30 | kost_qu_ek_3 |
# addk-aus-FIBU #
# addk-aus-FIBU #And I respond with answer "Ja" to the dialog with id "1941"
# addk-aus-FIBU #And I save the current editor

# addk-aus-ek:
# ------------
# Rechnung für add. kosten anlegen
Given I open an editor "re-addkosten3" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "136-add"
And I set field "lief" to "1"
And I set field "erfwaehr" to "eur"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I append rows
 |artex     | pwert| konto | kstelle | ptext          | 
 |transport |    40| 50014 |     114 | kost_qu_ek_4   |
 |transport |    50| 50012 |     112 | kost_qu_ek_5_12|
 |transport |   -32| 50016 |     113 | kost_qu_ek_6   |

# 16er-hinweis:
# diese -32 landen mit dem guv-konto letztlich im haben
# deshalb auch unten in der entspr. fibu-zeile die 32 im haben
# und die kstelle darf nicht 116 sein, weil sonst quell- u.
# ziel-kstelle identisch werden wodurch keine umbuchung gemacht wird. 



And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# addk-aus-FIBU ## --- km-fähige fibu-buchung -----
# addk-aus-FIBU #Given I open an editor "buchung_3km_faehige_bilanzzeile" from table "(Entry):(Entry)" with command "NEW" for record ""
# addk-aus-FIBU #And I set field "such" to "b136-add"
# addk-aus-FIBU #And I set field "budat" to "10.01.2002"
# addk-aus-FIBU #And I set field "text" to "qu:z2:4,z3:5_12,z4:6"
# addk-aus-FIBU #And I append rows
# addk-aus-FIBU # | konto | kstelle   |ewsbetr|ewhbetr| ptext            | 
# addk-aus-FIBU # | 10000 |!dontChange|       |       |                  |
# addk-aus-FIBU # | 50014 |     114   |    40 |       |  kost_qu_ek_4    |
# addk-aus-FIBU # | 50012 |     112   |    50 |       |  kost_qu_ek_5_12 |
# addk-aus-FIBU # | 50016 |     113   |       |   32  |  kost_qu_ek_6    |
# addk-aus-FIBU ##      siehe oben 32er-hinweis

# addk-aus-FIBU #And I respond with answer "Ja" to the dialog with id "1941"
# addk-aus-FIBU #And I save the current editor


Given I open an editor "Rechnung_01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | 1      |
    | num4     | 11-15-2|
    | such4    | R11-15-2|
    | vom      | .      |
    | ueb      | ja     |
    | fakt     | ja     |
    | ebeleg   | MATRE1 |
    | budat    | .      |
And I append rows

   | artikel     | mge | preis | tterm	| ptext    | platz     |
# # mit-mkv #    | E1EI-VO     | 10  | 10,00 | +4	| kmzpos11 |!dontChange|
  | E1EI-VO     | 15  | 15,00 | +4	| kmzpos15 |!dontChange|
# # mit-mkv #    | E1EI-VO     | 20  | 20,00 | +4	| kmzpos2  |  L3F1     |

# ohne-mkv #   | artikel     | mge | preis | tterm	| ptext    | platz     | kstelle |
# ohne-mkv #   | E1EI-VO     | 10  | 10,00 | +4	| kmzpos11 |!dontChange|   110   |
# ohne-mkv #   | E1EI-VO     | 15  | 15,00 | +4	| kmzpos15 |!dontChange|   111   |
# ohne-mkv #   | E1EI-VO     | 20  | 20,00 | +4	| kmzpos2  |  L3F1     |   112   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# KANN IRGENDWANN RAUS WENN NICHT BENÖTIGT:
# -------------------------------------------

#  Given I open an editor "Rechnung_02" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
#  And I set fields
#   | lief     | 1   |
#   | num4     | 3-4 |
#   | such4    | R3-4|
#   | vom      | .      |
#   | ueb      | ja     |
#   | ebeleg   | MATRE1 |
#   | budat    | .      |
#  And I append rows
#   | artikel |  lffert   |mge | preis | tterm	| ptext   | konto     | kstelle   |
#   | E1LO-VO | EFLO-VO   | 30 | 30,00 | +4	| kmzpos3 | 50012     |    112    |
#  # mit-mkv # | E1EI-VO |!dontChange| 40 | 40,00 | +4	| kmzpos4 |!dontChange|!dontChange|
#  # ohne-mkv # | E1EI-VO |!dontChange| 40 | 40,00 | +4	| kmzpos4 |!dontChange|    118    |
#  And I respond with answer "ja" to the dialog with id "4841"
#  And I save the current editor
#  
#  Given I open an editor "Rechnung_02" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
#  And I set fields
#      | lief     | 1     |
#      | num4     | 5-6-7 |
#      | such4    | R5-6-7|
#      | vom      | .      |
#      | ueb      | ja     |
#      | fakt     | ja     |
#      | ebeleg   | MATRE1 |
#      | budat    | .      |
#  And I append rows
#  # mit-mkv #    | artikel     | mge | preis | tterm	| ptext   |
#  # mit-mkv #    | E1EI-VO     | 50  | 50,00 | +4	| kmzpos5 |
#  # mit-mkv #    | E1EI-VO     | 60  | 60,00 | +4	| kmzpos6 |
#  # mit-mkv #    | E1EI-VO     | 70  | 70,00 | +4	| kmzpos7 |
#  # mit-mkv #    | E2FR-VF     | 80  | 80,00 | +4	| kmzpos8 |
#  
#  # ohne-mkv #    | artikel     | mge | preis | tterm	| ptext   | kstelle |
#  # ohne-mkv #    | E1EI-VO     | 50  | 50,00 | +4	| kmzpos5 |   114   |
#  # ohne-mkv #    | E1EI-VO     | 60  | 60,00 | +4	| kmzpos6 |   115   |
#  # ohne-mkv #    | E1EI-VO     | 70  | 70,00 | +4	| kmzpos7 |   116   |
#  # ohne-mkv #    | E2FR-VF     | 80  | 80,00 | +4	| kmzpos8 |   116   |
#  And I respond with answer "ja" to the dialog with id "4841"
#  And I save the current editor

#  # ------------------------------------------------------------------------
#  Scenario: Manuelle Abgänge der Zugänge und darüber hinaus (ohne bestand)
#  # ------------------------------------------------------------------------
#  
#  Given I set the fake date to "21.01.2002"
#  
#  Given I open an editor "LbuchAb" for tip command "(Stockadjustment)" and arguments ""
#  And I set field "artikel" to "E1EI-VO"
#  And I set field "beleg" to "allesweg"
#  And I set field "beldat" to "."
#  And I set field "buart" to "Abgang"
#  
#  And I set field "mge" to "100" in row !lastRow
#  And I set field "platz" to "F2" in row !lastRow
#  
#  And I create a new row at the end of the table
#  And I set field "mge" to "180" in row !lastRow
#  And I set field "platz" to "F2" in row !lastRow
#  
#  And I save the current editor
#  
#  Given I open an editor "LbuchAb" for tip command "(Stockadjustment)" and arguments ""
#  And I set field "artikel" to "E1LO-VO"
#  And I set field "beleg" to "loweg"
#  And I set field "beldat" to "."
#  And I set field "buart" to "Abgang"
#  And I set field "lffert" to "EFLO-VO"
#  
#  And I set field "mge" to "30" in row !lastRow
#  And I set field "platz" to "F1" in row !lastRow
#  
#  And I save the current editor
#  
#  # ------ nachbewerten ---------------
#  Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
#  And I close the current editor

# ------------------------------------------------------------------------
Scenario: Kostenumlagen erzeugen
# ------------------------------------------------------------------------

Given I set the fake date to "21.01.2002"

#  Given I open an editor "kostenuml-11" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
#  And I set field "num135" to "110" 
#  And I set field "such" to "U11-2ZEI" 
#  # addk-aus-ek #And I set field "pos" to "$,,ptext==kost_qu_ek_11;art==transport;@ablageart=(Filed)"
#  # addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_11"
#  # addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
#  And I set field "fibuumbuch" to "ja"
#  And I set field "umlagemeth" to "Wert"
#  And I create a new row at the end of the table
#  And I set field "pos" to "$,,ptext==kmzpos11;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
#  And I create a new row at the end of the table
#  And I set field "pos" to "$,,ptext==kmzpos7;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
#  And I save the current editor

# Kostenumlagen erzeugen
Given I open an editor "kostenuml-15" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "150" 
And I set field "such" to "U15-1ZEI" 
And I set field "pos" to "$,,ptext==kost_qu_ek_15;art==transport;@ablageart=(Filed)"
# addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_15"
# addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
And I set field "fibuumbuch" to "ja"
# ohne-mkv #And I set field "fibuumbuch" to "nein"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos15;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor



Given I open an editor "sto-kostenuml-15.1" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+U15-1ZEI"
And I set field "num135" to "150s" 
And I set field "such" to "S15-1ZEI" 
And I set field "name" to "SKM"
And I save the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-11-15-2-mge20" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+R11-15-2"
And I set field "num4" to "11152-20"
And I set field "such4" to "RL11mge20"
And I set field "ebeleg" to "RL11-15-2-mge20"
And I set field "vom" to "."
And I set field "mge" to "-15" in row 1
And I save the current editor

# Ruecklieferschein buchen (muss funktionieren, weil keine aktive Kostenumlage mehr)
Given I open an editor "srls-11-15-2-mge20" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "11152-20"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "sRL" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "11152-20"
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor



########################################################################

@FALL-730
Scenario: FALL-730   BE - LS aus BE - KM auf LS - TRE1 aus LS - TRE2 aus LS ... 
#                    Buchung RLS geblockt - SKM - Buchung RLS möglich
#
# !! Besonderheit hier: KM auf LS !!   
# wie in ref_km_rueck_ek_rueck_ek, JEDOCH STORNO KOSTENUMLAGEN   

Given I'm logged in with password "sy"
Given I set the fake date to "21.01.2002"

# Konto 730-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0730FALL"
And I set field "such" to "FALL-730"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

# Konto 58-xxxx Anschaffungsnebenkosten
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "58000"
And I set field "nummer" to "58-0730"
And I set field "such" to "FALL-58xxxx"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0730FALL"
And I set field "such" to "FALL-730"
And I set field "bestausekso" to "FALL-730"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "730-FALL"
And I set field "num2" to "730-FALL"
And I set field "such" to "FALL-730"
And I set field "namebspr" to "FALL-730"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-730"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-730" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "730-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-730" in row 1
And I set field "mge" to "730" in row 1
And I set field "preis" to "730" in row 1
And I set field "kenn" to "FALL-730"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "730-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-730" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-730"
And I set field "num4" to "730-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "730" in row 1
And I set field "kenn" to "FALL-730"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-730" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "730-LS"
And I close the current editor

# Rechnung1a anlegen
Given I open an editor "rechnung-730-1a" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "730-RE1a"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "1730" in row 1
And I set field "konto" to "58-0730" in row 1
And I set field "kenn" to "FALL-730"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+730-RE1a"
And I close the current editor

# Kostenumlage erzeugen
Given I open an editor "kostenuml-730" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "730-KMa" 
And I set field "pos" to "$,,kopf^nummer=730-RE1a;art=TEXT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=730-LS;artex=FALL-730;@gruppe=2;@datenbank=4;@ablageart=(Active)" in row 1
And I save the current editor

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+730-KMa"
And I close the current editor


# Material-Rechnung anlegen
Given I open an editor "rechnung-730-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-730"
And I set field "num4" to "730-RE2a"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-730"
#And I set field "fakt" to "nein"
And I set field "mge" to "230" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung vorhanden
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+730-RE2a"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-730-2b" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-730"
And I set field "num4" to "730-RE2b"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-730"
# And I set field "mge" to "500" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-730" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Rechnung vorhanden
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+730-RE2b"
And I close the current editor


# Rücklieferschein anlegen
Given I open an editor "rls-730" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+730-LS"
And I set field "num4" to "730-RLS"
And I set field "vom" to "."
And I set field "mge" to "-730" in row 1
And I set field "kenn" to "FALL-730 Ruecklieferschein"
And I save the current editor

# Ruecklieferschein buchen (muss scheitern wegen zwei noch vorhandenen Kostenumlagen)
Given I open an editor "rls-730" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "730-RLS"
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "2888"
And I close the current editor


Given I open an editor "kostenumlrueck-730a" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+730-KMa"
And I save the current editor

# Ruecklieferschein buchen (muss funktionieren, weil keine aktive Kostenumlage mehr)
Given I open an editor "rls-730" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "730-RLS"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "srls-730" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "730-RLS"
And I save the current editor

#############################################################################

@FALL-740
Scenario: FALL-740   BE - LS aus BE - KM auf LS - TRE1 aus LS - TRE2 aus LS ... 
#                    Buchung RLS geblockt - SKM - Buchung RLS möglich
#
# !! Besonderheit hier: KM auf LS !!   
# wie in ref_km_rueck_ek_rueck_ek, JEDOCH STORNO KOSTENUMLAGEN   

Given I'm logged in with password "sy"
Given I set the fake date to "21.01.2002"

# Konto 740-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0740FALL"
And I set field "such" to "FALL-740"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

# Konto 58-xxxx Anschaffungsnebenkosten
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "58000"
And I set field "nummer" to "58-0740"
And I set field "such" to "FALL-58xxxx"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0740FALL"
And I set field "such" to "FALL-740"
And I set field "bestausekso" to "FALL-740"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "740-FALL"
And I set field "num2" to "740-FALL"
And I set field "such" to "FALL-740"
And I set field "namebspr" to "FALL-740"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-740"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-740" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "740-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-740" in row 1
And I set field "mge" to "740" in row 1
And I set field "preis" to "740" in row 1
And I set field "kenn" to "FALL-740"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "740-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-740" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-740"
And I set field "num4" to "740-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "740" in row 1
And I set field "kenn" to "FALL-740"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-740" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "740-LS"
And I close the current editor

# Rechnung1a anlegen
Given I open an editor "rechnung-740-1a" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "740-RE1a"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "1740" in row 1
And I set field "konto" to "58-0740" in row 1
And I set field "kenn" to "FALL-740"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+740-RE1a"
And I close the current editor

# Material-Rechnung anlegen
Given I open an editor "rechnung-740-2" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "740-LS"
And I set field "num4" to "740-RE2a"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-740"
#And I set field "fakt" to "nein"
# And I set field "mge" to "230" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-740" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Kostenumlage erzeugen
Given I open an editor "kostenuml-740" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "740-KMa" 
And I set field "pos" to "$,,kopf^nummer=740-RE1a;art=TEXT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=740-RE2a;artex=FALL-740;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 1
And I save the current editor

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+740-KMa"
And I close the current editor

# Rechnung vorhanden
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+740-RE2a"
And I close the current editor


# Rücklieferschein anlegen
Given I open an editor "rls-740" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+740-LS"
And I set field "num4" to "740-RLS"
And I set field "vom" to "."
And I set field "mge" to "-740" in row 1
And I set field "kenn" to "FALL-740 Ruecklieferschein"
And I save the current editor

# Ruecklieferschein buchen (muss scheitern wegen zwei noch vorhandenen Kostenumlagen)
Given I open an editor "rls-740" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "740-RLS"
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "2888"
And I close the current editor

Given I open an editor "kostenumlrueck-740a" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+740-KMa"
And I save the current editor

# Ruecklieferschein buchen (muss funktionieren, weil keine aktive Kostenumlage mehr)
Given I open an editor "rls-740" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "740-RLS"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "srls-740" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "740-RLS"
And I save the current editor

###################################################################################

@FALL-800
# wie 790, aber RL von LSb hier zuerst. Dieser ist nur von einer KM-Pos. abhängig,
#          im gegensatz zu LSa

Scenario: FALL-800  BE - TREa aus BE 190 - TREb aus BE 600...
#                   KMa auf TREa - KMb auf TREb -
#                   TLSa aus BE OHNE Faktura 300 - TLSb aus BE OHNE Faktura 300 
#                   Buchung RLSb geblockt - 
#                   SKM => fehler verbleibende add. kosten in einer kette 
#                   Buchung RLSa möglich ...
#                   SRLSb => Fehler add. kosten in der anderen kette
#
# !!! ABWEICHENDE MENGEN ZWISCHEN TEILRECHNUNGEN UND TEILLIEFERSCHEINEN !!	
# !!! im Einkauf hier keine mengemäßige Zuordnung der LS-pos zu den RE-pos !!   
# wie in ref_km_rueck_ek_rueck_ek, JEDOCH STORNO KOSTENUMLAGEN   
   

Given I'm logged in with password "sy"
Given I set the fake date to "21.01.2002"

# Konto 800-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0800FALL"
And I set field "such" to "FALL-800"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

# Konto 58-xxxx Anschaffungsnebenkosten
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "58000"
And I set field "nummer" to "58-0800"
And I set field "such" to "FALL-58xxxx"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0800FALL"
And I set field "such" to "FALL-800"
And I set field "bestausekso" to "FALL-800"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "800-FALL"
And I set field "num2" to "800-FALL"
And I set field "such" to "FALL-800"
And I set field "namebspr" to "FALL-800"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-800"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-800" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "800-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-800" in row 1
And I set field "mge" to "800" in row 1
And I set field "preis" to "800" in row 1
And I set field "kenn" to "FALL-800"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "800-BE"
And I close the current editor


# Rechnung1 der umzulegenden kosten anlegen
Given I open an editor "rechnung-800-1a" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "800-RE1a"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "1800" in row 1
And I set field "konto" to "58-0800" in row 1
And I set field "kenn" to "FALL-800"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+800-RE1a"
And I close the current editor

# Rechnung-b  der umzulegenden kosten anlegen
Given I open an editor "rechnung-800-1b" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "800-RE1b"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "20" in row 1
And I set field "konto" to "58-0800" in row 1
And I set field "kenn" to "FALL-800"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+800-RE1b"
And I close the current editor


# Material-Rechnungen anlegen
# ---------------------------
Given I open an editor "rechnung-800-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-800"
And I set field "num4" to "800-RE2a"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-800"
And I set field "fakt" to "nein"
And I set field "mge" to "190" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-800-2b" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-800"
And I set field "num4" to "800-RE2b"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-800"
And field "fakt" is not modifiable
And I set field "mge" to "600" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung vorhanden
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+800-RE2a"
And I close the current editor
# Rechnung vorhanden
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+800-RE2b"
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-800" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."


# Kostenumlage erzeugen
#------------------------
Given I open an editor "kostenuml-800" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "800-KMa" 
And I set field "pos" to "$,,kopf^nummer=800-RE1a;art=TEXT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=800-RE2a;artex=FALL-800;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 1
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=800-RE2b;artex=FALL-800;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 2
And I save the current editor

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+800-KMa"
And I close the current editor


# Lieferschein a  zu Bestellung anlegen
#------------------------------------
Given I open an editor "lieferschein-800a" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-800"
And I set field "num4" to "800-LSa"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And field "fakt" is not modifiable
And field "fakt" has value "nein"
And I set field "mge" to "300" in row 1
And I set field "kenn" to "FALL-800"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+800-LSa"
And I close the current editor

# Lieferschein b  zu Bestellung anlegen
#------------------------------------
Given I open an editor "lieferschein-800b" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-800"
And I set field "num4" to "800-LSb"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And field "fakt" is not modifiable
And field "fakt" has value "nein"
And I set field "mge" to "490" in row 1
And I set field "kenn" to "FALL-800"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+800-LSb"
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-800" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Rücklieferschein zu LSa anlegen
Given I open an editor "rls-800" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+800-LSb"
And I set field "num4" to "800-RLSb"
And I set field "vom" to "."
And I set field "mge" to "-490" in row 1
And I set field "kenn" to "FALL-800 Ruecklieferschein"
And I save the current editor

# Ruecklieferschein buchen (muss scheitern wegen zwei noch vorhandenen Kostenumlagen)
Given I open an editor "rls-800" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "800-RLSb"
And I set field "ueb" to "ja"
# And I save the current editor
Then saving the current editor throws the exception "2888"
And I close the current editor

# KM stornieren
#------------------------------
Given I open an editor "kostenumlrueck-800b" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+800-KMa"
And I save the current editor

# Ruecklieferschein buchen (muss funktionieren, keine Kostenumlagen)
Given I open an editor "rls-800" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "800-RLSb"
And I set field "ueb" to "ja"
And I save the current editor

# Ruecklieferschein stornieren
Given I open an editor "srls-800" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "800-RLSb"
And I save the current editor

