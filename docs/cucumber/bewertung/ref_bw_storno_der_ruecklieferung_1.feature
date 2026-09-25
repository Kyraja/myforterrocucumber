# *****************************************************************************
#  Name             : ref_bw_storno_der_ruecklieferung_1.feature
#  Autor            : wane
#  Verantwortlich   : uo
#  Kontrolle        : 
#  Funktion         : Einkauf: testet STORNO von Ruecklieferungen,
#                              Bewertungen stehen im Vordergrund
# *****************************************************************************

@persistent
Feature: STORNO von Ruecklieferungen
Background: Test von Bewertungen, die beim STORNO von Ruecklieferungen entstehen
Given I set the fake date to "07.01.2002"

@FALL-STORNO-RLS1
Scenario: volle Ruecklieferung + STORNO mit Verbuchung; Testumgebung 2

# Ablauf:
#  be tre ls  tre2 tre3 trls  tre4  trls2 rest-re srestre stre4 strls2 restre2 kgs-rls2
# (1) (2) (3)  (5)  (7)  (9)  (11)  (13)   (15)      (17)  (18)   (19)   (22)    (24)

# Ablauf:
# 1) BE , 100 Stk zu 25.25 EUR
# 2) TRE1 7 Stk zu 27.00 EUR
# 3) LS 100 Stk
# 4) Nachbewerten + Materialkostenverbuchung (N+MKV)
# 5) TRE2 8 Stk zu 28.00 EUR
# 6) N+MKV
# 7) TRE3 45 Stk zu 29.00 EUR
# 8) N+MKV
# 9) Teil-Ruecklieferung1,  25 Stk.
# 10) N+MKV
# 11) TRE4 10 Stk zu 30.00 EUR
# 12) N+MKV
# 13) Teil-Ruecklieferung2, 75 Stk
# 14) N+MKV
# 15) TRE5 30 Stk zu 35.00 EUR
# ...
# 24) N+MKV
# 25) Verkaufslieferschein: 0efall2, 100 Stk.
#     25a) Bewertung pruefen
# 26) N+MKV
# 27) VK-Rechnung (Ausland) aus LS generieren, 100 Stk.
# 28) N+MKV
#
#
# EINKAUF:
#---------
#
#    / 100RE1
#   /  7x27 EUR
#  /
# 100BE --- 100LS ------------- 100RLS1 ------------------------------------- 100SRLS1
# 100 St    100St               25St                                          25St
#  |          \
#  |           \---------------------------- 100RLS2 ------------------------------------------ 100KGS2
#  |            \                            75St                                               75St
#  |
#   \----------- 100RE2
#    \           8x28 EUR
#     \
#      \--------------- 100RE3
#       \               45x29 EUR
#        \
#         \-------------------------- 100RE4 -------------------------- 100SRE4
#          \                          10x30 EUR                         10St
#           \
#            \------------------------------------ 100RE5 ----- 100SRE5
#             \                                    30x35 EUR    30St
#              \
#               \-------------------------------------------------------------------- 100RE5a
#                \                                                                    40x20 EUR
#
# 1 -- 2 -- 3 -- 5 ---- 7 ----- 9 --- 11 --- 13 -- 15 --------- 17 ---- 18 -- 19 ---- 22 ----- 24 ------> Zeitstrahl

And I delete file "saldo_kto_1ifall2_vor_FALL-STORNO-RLS1.ref" in cucu_refs_dir
And I export "bukreis,kosn,gjahr,waehr,saldo" from table "(Account):(TransactionFigures)" where "bukreis==HGB;dart=ist;@ordnung=kosn^nummer,gjahr,waehr" to output file "saldo_kto_1ifall2_vor_FALL-STORNO-RLS1.ref"

# (1) Bestellung anlegen
Given I set the fake date to "8.01.2002"
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa2"
And I set field "num4" to "100BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall2" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "25.25" in row 1
And I set field "kenn" to "FALL-STORNO-RLS1,"
And I save the current editor

# (2) Teil-Rechnung 1 anlegen und verbuchen; 7 Stk
Given I set the fake date to "9.01.2002"
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "100RE1"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "7" in row 1
And I set field "preis" to "27" in row 1
And I set field "kenn" to "FALL-STORNO-RLS1,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# (3) Lieferschein zu Bestellung anlegen
Given I set the fake date to "10.01.2002"
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "100LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "kenn" to "FALL-STORNO-RLS1,"
And I save the current editor

# (4) Nachbewerten + Materialkostenverbuchung
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
#
Given I set the fake date to "11.01.2002"
Given I create a CostEntriesSuggestion "mkv" with type of cost entry "Verbuchung Lagerbestand" for startdate "01.01.2002" until enddate "."


# (5) Teil-Rechnung 2 anlegen und verbuchen; 8 Stk
Given I set the fake date to "12.01.2002"
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "100RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "8" in row 1
And I set field "preis" to "28" in row 1
And I set field "kenn" to "FALL-STORNO-RLS1,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# (6) Nachbewerten + Materialkostenverbuchung
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
#
Given I set the fake date to "13.01.2002"
Given I create a CostEntriesSuggestion "mkv" with type of cost entry "Verbuchung Lagerbestand" for startdate "01.01.2002" until enddate "."


# (7) Teil-Rechnung 3 anlegen und verbuchen; 45 Stk
Given I set the fake date to "14.01.2002"
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "100RE3"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "45" in row 1
And I set field "preis" to "29" in row 1
And I set field "kenn" to "FALL-STORNO-RLS1,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# (8) Nachbewerten + Materialkostenverbuchung
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
#
Given I set the fake date to "15.01.2002"
Given I create a CostEntriesSuggestion "mkv" with type of cost entry "Verbuchung Lagerbestand" for startdate "01.01.2002" until enddate "."


# (9) Teilruecklieferung von 25 Stk.
Given I set the fake date to "16.01.2002"
Given I open an editor "ruecklief-1" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+100LS"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "100RLS1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "EK1-FALL2" in row 1
And I set field "mge" to "-25" in row 1
And I save the current editor
And I close the current editor

# 10) Nachbewerten + Materialkostenverbuchung
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
#
Given I set the fake date to "17.01.2002"
Given I create a CostEntriesSuggestion "mkv" with type of cost entry "Verbuchung Lagerbestand" for startdate "01.01.2002" until enddate "."

# (11) Teil-Rechnung 4 anlegen und verbuchen; 10 Stk
Given I set the fake date to "18.01.2002"
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "100RE4"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "preis" to "30" in row 1
And I set field "kenn" to "FALL-STORNO-RLS1,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# (12) Nachbewerten + Materialkostenverbuchung
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
#
Given I set the fake date to "19.01.2002"
Given I create a CostEntriesSuggestion "mkv" with type of cost entry "Verbuchung Lagerbestand" for startdate "01.01.2002" until enddate "."


# (13) Teil-Ruecklieferung -75 Stk
Given I set the fake date to "20.01.2002"
Given I open an editor "ruecklief-2" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+100LS"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "100RLS2"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
And I set field "bem" to "Doch mehr kaputt als schon verbucht!!!"
Then field "artikel" has value "EK1-FALL2" in row 1
And I set field "mge" to "-75" in row 1
And I save the current editor
And I close the current editor


# 14) Nachbewerten + Materialkostenverbuchung
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
#
Given I set the fake date to "21.01.2002"
Given I create a CostEntriesSuggestion "mkv" with type of cost entry "Verbuchung Lagerbestand" for startdate "01.01.2002" until enddate "."


# (15) Teil-Rechnung 5 anlegen und verbuchen; Rest
Given I set the fake date to "22.01.2002"
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "100RE5"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I set field "preis" to "35" in row 1
And I set field "kenn" to "FALL-STORNO-RLS1,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# (16) Nachbewerten + Materialkostenverbuchung
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
#
Given I set the fake date to "23.01.2002"
Given I create a CostEntriesSuggestion "mkv" with type of cost entry "Verbuchung Lagerbestand" for startdate "01.01.2002" until enddate "."

# (17)
Given I set the fake date to "24.01.2002"
Given I open an editor "teilre5storno" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+100RE5"
Then I set field "nummer" to "100SRE5"
And I save the current editor
And I close the current editor

# (18)
Given I set the fake date to "25.01.2002"
Given I open an editor "teilre4storno" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+100RE4"
Then I set field "nummer" to "100SRE4"
And I save the current editor
And I close the current editor

# (19) Storno 1. Teilruecklieferung (25 stk.)
Given I set the fake date to "26.01.2002"
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "100RLS1"
Then I set field "nummer" to "100SRLS1"
And I save the current editor
And I close the current editor

# (20) Nachbewerten + Materialkostenverbuchung
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
#
Given I set the fake date to "27.01.2002"
Given I create a CostEntriesSuggestion "mkv" with type of cost entry "Verbuchung Lagerbestand" for startdate "01.01.2002" until enddate "."


# (22) Die Menge aus T-RE5 nochmal bezahlen
Given I set the fake date to "28.01.2002"
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "100RE5a"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I set field "preis" to "20" in row 1
And I set field "kenn" to "FALL-STORNO-RLS1,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# (23) Nachbewerten + Materialkostenverbuchung
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
#
Given I set the fake date to "1.2.2002"
Given I create a CostEntriesSuggestion "mkv" with type of cost entry "Verbuchung Lagerbestand" for startdate "01.01.2002" until enddate "."

# (24)
Given I set the fake date to "2.2.2002"
Given I open an editor "KGS100rls2" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "100RLS2"
And I set fields
   | nummer | 100KGS2 |
   | such   | KGS100-2|
   | ueb    | ja      |
   | tterm  | .       |
   | vom    | .       |
   | budat  | .       |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


And I delete file "saldo_kto_1ifall2_nach_FALL-STORNO-RLS1.ref" in cucu_refs_dir
And I export "bukreis,kosn,gjahr,waehr,saldo" from table "(Account):(TransactionFigures)" where "bukreis==HGB;dart=ist;@ordnung=kosn^nummer,gjahr,waehr" to output file "saldo_kto_1ifall2_nach_FALL-STORNO-RLS1.ref"

And I delete file "buchungen_1ifall2_nach_FALL-STORNO-RLS1.ref" in cucu_refs_dir
And I export "nummer,such,budat,zn,soll,konto,iwbu,betrag,erfwaehr,ewbetr,ursache,ursacheref^id,stornovorlobjekt,stornoobjekt,ptext,text" from table "(Entry):(Entry)" where "konto==1ifall2;@zeilen=ja;@ordnung=nummer,zn" to output file "buchungen_1ifall2_nach_FALL-STORNO-RLS1.ref"

And I delete file "buch_alles.ref" in cucu_refs_dir
And I export "nummer,such,budat,zn,umgelegtinkm,soll,konto,iwbu,betrag,erfwaehr,ewbetr,kstelle,ursache,ursacheref^id,stornovorlobjekt,stornoobjekt,ptext,text" from table "(Entry):(Entry)" where "@zeilen=ja" to output file "buch_alles.ref"

# ========================== Verkauf ========================================
#
# 25) Verkaufslieferschein: 0efall2, 100 Stk
Given I set the fake date to "3.2.2002"
Given I open an editor "vk-ls" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "num3" to "200-LS"
And I set field "kunde" to "001fa2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-STORNO-RLS1,"
And I create a new row at the end of the table
And I set field "artikel" to "EK1-FALL1" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "53.33" in row 1
And I save the current editor


# 26) Nachbewerten + Materialkostenverbuchung
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
#
Given I set the fake date to "4.2.2002"
Given I create a CostEntriesSuggestion "mkv" with type of cost entry "Verbuchung Lagerbestand" for startdate "01.01.2002" until enddate "."

# 27) VK-Rechnung (Ausland) aus LS generieren, 100 Stk
Given I set the fake date to "5.2.2002"
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "vk-ls"
And I set field "num3" to "200-RE1"
And I set field "kunde" to "006fa1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "preis" to "60" in row 1
And I set field "kenn" to "FALL-STORNO-RLS1,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# 28) Nachbewerten + Materialkostenverbuchung
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
#
Given I set the fake date to "6.2.2002"
Given I create a CostEntriesSuggestion "mkv" with type of cost entry "Verbuchung Lagerbestand" for startdate "01.01.2002" until enddate "."
