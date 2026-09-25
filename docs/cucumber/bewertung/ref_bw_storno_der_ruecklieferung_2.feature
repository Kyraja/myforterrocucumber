# *****************************************************************************
#  Name             : ref_bw_storno_der_ruecklieferung_2.feature
#  Autor            : wane
#  Verantwortlich   : uo
#  Kontrolle        : 
#  Funktion         : Einkauf: testet STORNO von Ruecklieferungen,
#                              Bewertungen stehen im Vordergrund
# *****************************************************************************

@persistent
Feature: STORNO von Ruecklieferungen
Background: Test von Bewertungen, die beim STORNO von Ruecklieferungen entstehen
Given I set the fake date to "25.02.2002"

@FALL-STORNO-RLS10
Scenario: fast volle Ruecklieferung + STORNO mit MNB und KM in der Kette; mit Verbuchung

# Ablauf:
# be tre_oWB KM  LS  tre2  tre3   mn  trls  rest-re  strls   srest-re  strls  rest-re2
# 1)  2)     3)  4)   6)     8)  11)  13)    15)      17)       18)     19)      21) 
#                                                   verboten          erlaubt   

# Ablauf:
#  1) Bestellung anlegen -> 333 Stk. zu 25.25
#  2) Teil-Rechnung 1 anlegen und verbuchen; 70 Stk zu 27,00
#     Ohne Warenbewegung!!!
#  3) Kostenumlage (333 EUR) -> vor LS
#  4) Lieferschein zu Bestellung anlegen -> 333 Stk.
#  5) NB + MKV
#  6) Teil-Rechnung 2 anlegen und verbuchen; 80 Stk zu 28,00
#    6a) Bewertung pruefen
#  7) NB + MKV
#  8) Teil-Rechnung 3 anlegen und verbuchen; 40 Stk zu 32,00

#      9) Verkaufsrechnung mit Lagerbewegung
#     10) NB + MKV
# 11) Mengenneubewertung -> ueber Platzmenge (133 Stk. zu 31.00)
#   11a) Bewertung pruefen
# 12) NB + MKV
# 13) Ruecklieferung von 330 Stk.
#   13a) Bewertung pruefen
# 14) NB + MKV
# 15) Teil-Rechnung 4 anlegen und verbuchen; Rest
#   15a) Bewertung pruefen
# 16) NB + MKV
# 17) Storno 1. Teilruecklieferung -> da wo die Menge falsch war
#   17a) Bewertung pruefen -> Einkauf
# 18) NB + MKV
#   18a) Bewertung pruefen -> Verkauf
#

And I delete file "saldo_kto_1ifall10_vor_FALL-STORNO-RLS10.ref" in cucu_refs_dir
And I export "bukreis,kosn,gjahr,waehr,saldo" from table "(Account):(TransactionFigures)" where "bukreis==HGB;dart=ist;kosn==1ifall10;@ordnung=kosn^nummer,gjahr,waehr" to output file "saldo_kto_1ifall10_vor_FALL-STORNO-RLS10.ref"

And I delete file "buchungen_1ifall10_vor_FALL-STORNO-RLS10.ref" in cucu_refs_dir
And I export "nummer,such,budat,zn,soll,konto,iwbu,betrag,erfwaehr,ewbetr,ursache,ursacheref^id,stornovorlobjekt,stornoobjekt,ptext,text" from table "(Entry):(Entry)" where "konto==1ifall10;@zeilen=ja;@ordnung=nummer,zn" to output file "buchungen_1ifall10_vor_FALL-STORNO-RLS10.ref"

# 1) Bestellung anlegen -> 333 Stk. zu 25.25
Given I set the fake date to "26.02.2002"
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa10"
And I set field "num4" to "333BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall10" in row 1
And I set field "mge" to "333" in row 1
And I set field "preis" to "25.25" in row 1
And I set field "kenn" to "FALL-STORNO-RLS10,"
And I save the current editor

# 2) Teil-Rechnung 1 anlegen und verbuchen; 70 Stk zu 27,00
#    Ohne Warenbewegung!!!
Given I set the fake date to "27.02.2002"
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "333RE1"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "70" in row 1
And I set field "preis" to "27" in row 1
And I set field "kenn" to "FALL-STORNO-RLS10,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Datum hochsetzen


# 3) Kostenumlage (333 EUR) -> vor LS
# zuerst die Frachtrechnung anlegen
Given I set the fake date to "28.02.2002"
Given I open an editor "fracht" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "001fa10"
And I set field "num4" to "333km1"
And I set field "kenn" to "FALL-STORNO-RLS10,"
And I set field "such" to "KM333"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "FRACHT" in row 1
And I set field "pwert" to "333" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
# danach die Kostenumlage erzeugen
Given I set the fake date to "1.3.2002"
Given I open an editor "kostenuml" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "333-KM1"
And I set field "pos" to "$,,kopf^nummer=333km1;art=FRACHT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Linear"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=333RE1;artex=0efall10;mge=70;@gruppe=2;@datenbank=4;@ablageart=(Both)" in row 1
And I save the current editor

# Datum hochsetzen

# 4) Lieferschein zu Bestellung anlegen und verbuchen
Given I set the fake date to "2.3.2002"
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "333LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "333" in row 1
And I set field "kenn" to "FALL-STORNO-RLS10,"
And I save the current editor

# Datum hochsetzen

# 5) # Nachbewerten + Kostenverbuchung(alles)
Given I set the fake date to "3.3.2002"
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.02.2002" until enddate "." with Command Revalue
# Datum hochsetzen


# 6) Teil-Rechnung 2 anlegen und verbuchen; 80 Stk zu 28,00
Given I set the fake date to "4.3.2002"
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "333RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "80" in row 1
And I set field "preis" to "28" in row 1
And I set field "kenn" to "FALL-STORNO-RLS10,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Datum hochsetzen

# 7) # Nachbewerten + Kostenverbuchung(alles)
Given I set the fake date to "5.3.2002"
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.02.2002" until enddate "." with Command Revalue

# Datum hochsetzen

# 8) Teil-Rechnung 3 anlegen und verbuchen; 40 Stk zu 32,00
Given I set the fake date to "6.3.2002"
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "333RE3"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
And I set field "preis" to "32" in row 1
And I set field "kenn" to "FALL-STORNO-RLS10,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Datum hochsetzen


# 9) Verkaufsrechnung mit Lagerbewegung
Given I set the fake date to "7.3.2002"
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "333RE"
And I set field "kunde" to "001fa10"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-STORNO-RLS10,"
And I create a new row at the end of the table
And I set field "artikel" to "0efall10" in row 1
And I set field "mge" to "200" in row 1
And I set field "preis" to "445.60" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Datum hochsetzen

# 10) # Nachbewerten + Kostenverbuchung(alles)
Given I set the fake date to "8.3.2002"
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.02.2002" until enddate "." with Command Revalue

# Datum hochsetzen

# 11) Mengenneubewertung -> ueber Platzmengenelement (133 Stk. zu 31.00)
Given I set the fake date to "9.3.2002"
Given I open an editor "mnb" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-333"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,artikel=0efall10;platz==F1;@datei=40:4;@ablage=(Both)" in row 1
And I set field "ntbewpr" to "31" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Datum hochsetzen

# 12) # Nachbewerten + Kostenverbuchung(alles)
Given I set the fake date to "10.3.2002"
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.02.2002" until enddate "." with Command Revalue
# Datum hochsetzen

# 13) Teilruecklieferung von 330 Stk.
Given I set the fake date to "11.3.2002"
Given I open an editor "ruecklief-1" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+333LS"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "333RLS1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "EK1-FALL10" in row 1
And I set field "mge" to "-330" in row 1
And I save the current editor
And I close the current editor

# 14) # Nachbewerten + Kostenverbuchung(alles)
Given I set the fake date to "12.3.2002"
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.02.2002" until enddate "." with Command Revalue

# 15) Teil-Rechnung 4 anlegen und verbuchen; Rest
Given I set the fake date to "13.3.2002"
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "333RE4"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I set field "preis" to "35" in row 1
And I set field "kenn" to "FALL-STORNO-RLS10,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# 16) # Nachbewerten + Kostenverbuchung(alles)
Given I set the fake date to "14.3.2002"
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.02.2002" until enddate "." with Command Revalue

# 17) Storno 1. Teilruecklieferung verboten, da falsche Bewertung entstehen würde
Given opening an editor from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "333RLS1" throws the exception "3335" 
And I close the current editor

# 18)
Given I set the fake date to "15.3.2002"
Given I open an editor "storno-rest-re4" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+333RE4"
Then I set field "nummer" to "333SRE4"
And I save the current editor
And I close the current editor

# 19)
Given I set the fake date to "16.3.2002"
Given I open an editor "storno-rückliefer-ls1" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "333RLS1"
Then I set field "nummer" to "333SRLS1"
And I save the current editor
And I close the current editor

# 20) Manuelle Lagerbuchung Abgang
Given I set the fake date to "17.3.2002"
Given I open an editor "Lagerbuchung" for tip command "Lbuchung" and arguments ""
And I set fields
  | artikel | 0efall10 |
  | buart   | Abgang      |
  | beldat  | .           |
  | beleg   | manAbg      |
And I modify table
  | mge | platz | !row |
  | 133 | F1    | 1    |
And I save the current editor


# 21) Rest-Rechnung2 NOCHMALS MIT HÖHERER MENGE anlegen und verbuchen
Given I set the fake date to "18.3.2002"
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "333RE5"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I set field "preis" to "37" in row 1
And I set field "kenn" to "FALL-STORNO-RLS10,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Datum hochsetzen

# Nachbewerten + Kostenverbuchung(alles)
Given I set the fake date to "19.3.2002"
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.02.2002" until enddate "." with Command Revalue


And I delete file "saldo_kto_1ifall10_nach_FALL-STORNO-RLS10.ref" in cucu_refs_dir
And I export "bukreis,kosn,gjahr,waehr,saldo" from table "(Account):(TransactionFigures)" where "bukreis==HGB;dart=ist;kosn==1ifall10;@ordnung=kosn^nummer,gjahr,waehr" to output file "saldo_kto_1ifall10_nach_FALL-STORNO-RLS10.ref"

And I delete file "buchungen_1ifall10_nach_FALL-STORNO-RLS10.ref" in cucu_refs_dir
And I export "nummer,such,budat,zn,soll,konto,iwbu,betrag,erfwaehr,ewbetr,ursache,ursacheref^id,stornovorlobjekt,stornoobjekt,ptext,text" from table "(Entry):(Entry)" where "konto==1ifall10;@zeilen=ja;@ordnung=nummer,zn" to output file "buchungen_1ifall10_nach_FALL-STORNO-RLS10.ref"

And I delete file "buch_alles2.ref" in cucu_refs_dir
And I export "nummer,such,budat,zn,umgelegtinkm,soll,konto,iwbu,betrag,erfwaehr,ewbetr,kstelle,ursache,ursacheref^id,stornovorlobjekt,stornoobjekt,ptext,text" from table "(Entry):(Entry)" where "@zeilen=ja" to output file "buch_alles2.ref"
