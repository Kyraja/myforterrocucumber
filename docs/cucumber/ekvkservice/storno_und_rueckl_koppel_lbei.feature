# *****************************************************************************
#  Name           : storno_und_rueckl_koppel_lbei.feature
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : wane
#  Funktion       : Test des Stornierens und R�cklieferns von EK-Vorg�ngen mit Lieferantenbeistellung und Koppelprodukt.
#                   
#
# *****************************************************************************
@persistent
Feature: BW2-965 ()
Background:
# Datum wie im Vorgaengertest ref_koppel_lbei
Given I set the fake date to "02.01.1995"

Scenario: Storno des EK-LS des Einkaufsteils und des EK-LS des Kaufteils mit Beistellung                       

# Lagerwert pruefen
# Der Lagerwert hier am Testanfang entspricht dem Lagerwert des Testendes des Vorgaengertests.
Given I open the infosystem "LAGERWERTAKTUELL"
And I set field "bprokonto" to "ja"
And I press start
Then field "summe" has value "590.00"
Then the table has 2 rows
Then table has values
    | kkoreso   | krech    | koendsaldo |  kodifferenz  |
    | 10000     |  350.00  |    350.00  |       0.00    |
    | 10555     |  240.00  |    240.00  |       0.00    |
And I close the current editor

# Lagermenge pr�fen
And I append "--- 1 Lagermenge ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir
And I export "bewertungslagermengen1" from StorageQuantities where "" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref"
And I append "--- Ende 1 Lagermenge ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir

# Lagerjournal pr�fen
And I append "--- 1 Lagerjournal ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "@ordnung=budat" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref"
And I append "--- Ende 1 Lagerjournal ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir

# Artikelmengen pr�fen
And I append "--- 1 Artikelmengen ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref"
And I append "--- Ende 1 Artikelmengen ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir

Given I open an editor "lieferschein-st-300001" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "300001" 
And I set field "num4" to "300001s"
And I save the current editor

Given I open an editor "lieferschein-st-60333.1" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "60333.1" 
And I set field "num4" to "60333.1s"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Lagermenge pr�fen
And I append "--- 2 Lagermenge ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir
And I export "bewertungslagermengen2" from StorageQuantities where "" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref"
And I append "--- Ende 2 Lagermenge ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir

# Lagerjournal pr�fen
And I append "--- 2 Lagerjournal ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "@ordnung=budat" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref"
And I append "--- Ende 2 Lagerjournal ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir

# Artikelmengen pr�fen
And I append "--- 2 Artikelmengen ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref"
And I append "--- Ende 2 Artikelmengen ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir

######################################################################
# Lagerwert pruefen
######################################################################
# nach Storno des ersten Teil-Lieferscheins muss der Lagerwert null sein
Given I open the infosystem "LAGERWERTAKTUELL"
And I set field "bprokonto" to "ja"
And I press start
Then the table has 0 rows
And I close the current editor

#############################################
# PRUEFEN BEWERTUNGEN NACH STORNO
#############################################

# Bewertung zu Zugang Einkaufsteil
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=ekteil;buart=Zugang;detursache=Storno-Lieferung Einkauf;@richtung=rückwärts;@maxtreffer=1"
Then table has values
    | kart              | tmge |   lbdiff   | tlbstatus |
    | Lieferschein-Wert |  0   |    0.00    | verworfen |
    | Lieferschein-Wert |100   | -500.00    | gebucht   |
And I close the current editor

# Bewertung zu Abgang Einkaufsteil
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=ekteil;buart=Abgang;detursache=Storno-Lieferung Einkauf;@richtung=rückwärts;@maxtreffer=1"
Then table has values
    | kart     | tmge |   lbdiff   | tlbstatus |
    | Entnahme |  0   |    0.00    | verworfen |
    | Entnahme | 30   | -150.00    | gebucht   |
And I close the current editor

# Bewertung zu Zugang Koppelteil
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=koppel;buart=Zugang;detursache=Storno-Lieferung Einkauf;@richtung=rückwärts;@maxtreffer=1"
Then table has values
    | kart              | tmge |   lbdiff    | tlbstatus   |
    | Lieferschein-Wert |  0   |     0.00    | verworfen   |
    | Lieferschein-Wert | 30   | -9000.00    | gebucht     |
And I close the current editor

# Bewertung zu Zugang Kaufteil mit Beistellung, Hauptsatz
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=kt-beist;buart=Zugang;detursache=Storno-Lieferung Einkauf;beistelldaten=nein;@richtung=rückwärts;@maxtreffer=1"
Then table has values
    | kart              | tmge |  lbdiff   | tlbstatus |
    | Lieferschein-Wert |  0   |   0.00    | verworfen |
    | Lieferschein-Wert | 30   | -90.00    | gebucht   |
And I close the current editor

# Bewertung zu Zugang Kaufteil mit Beistellung, Beistellsatz
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=kt-beist;buart=Zugang;detursache=Storno-Lieferung Einkauf;beistelldaten=ja;@richtung=rückwärts;@maxtreffer=1"
Then table has values
    | kart              | tmge |    lbdiff   | tlbstatus |
    | Lieferschein-Wert |  0   |     0.00    | verworfen |
    | Lieferschein-Wert | 30   |  8850.00    | gebucht   |
And I close the current editor


Scenario:  Wieder Lieferscheine fuer EKTEIL und KT-BEIST erfassen
Given I set the fake date to "10.02.1995"

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "60333"
And I close the current editor
 
# Lieferschein zu Bestellung für KT-BEIST anlegen
Given I open an editor "ls-60333" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-view"
And I set field "num4" to "60333.2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "20" in row 1
And I set field "kenn" to "LS 60333.2"
And I save the current editor


# Lieferschein EKTEIL anlegen
Given I open an editor "lieferschein-30002" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "num4" to "300002"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "lief" to "1"
And I set field "kenn" to "LS 300002"
And I append rows
   | artikel | mge | platz |
   | ekteil  | 100 | lohnf |
And I save the current editor

# Nachbewerten
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

######################################################################
# Lagerwert pruefen
######################################################################
Given I open the infosystem "LAGERWERTAKTUELL"
And I set field "bprokonto" to "ja"
And I press start
Then field "summe" has value "560.00"
Then the table has 2 rows
Then table has values
    | kkoreso   | krech    | koendsaldo |  kodifferenz  |
    | 10000     |  400.00  |    400.00  |       0.00    |
    | 10555     |  160.00  |    160.00  |       0.00    |
And I close the current editor

#######################################################################
# PRUEFEN BEWERTUNGEN NACH STORNO UND NEUERFASSEN der LIEFERSCHEINE 
#######################################################################

# Bewertung zu Abgang Einkaufsteil
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=ekteil;buart=Abgang;detursache=Lieferschein Einkauf;@richtung=rückwärts;@maxtreffer=1"
Then table has values
    | kart     | tmge |   lbdiff   | tlbstatus |
    | Entnahme | 20   |  100.00    | gebucht   |
And I close the current editor

# Bewertung zu Zugang Koppelteil
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=koppel;buart=Zugang;detursache=Lieferschein Einkauf;@richtung=rückwärts;@maxtreffer=1"
Then table has values
    | kart              | tmge |   lbdiff    | tlbstatus |
    | Lieferschein-Wert | 20   |   6000.00   | gebucht   |
And I close the current editor

# Bewertung zu Zugang Kaufteil mit Beistellung, Hauptsatz
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=kt-beist;buart=Zugang;detursache=Lieferschein Einkauf;beistelldaten=nein;@richtung=rückwärts;@maxtreffer=1"
Then table has values
    | kart              | tmge |  lbdiff   | tlbstatus |
    | Lieferschein-Wert | 20   |  60.00    | gebucht   |
And I close the current editor

# Bewertung zu Zugang Kaufteil mit Beistellung, Beistellsatz
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=kt-beist;buart=Zugang;detursache=Lieferschein Einkauf;beistelldaten=ja;@richtung=rückwärts;@maxtreffer=1"
Then table has values
    | kart              | tmge |    lbdiff   | tlbstatus          |
    | Lieferschein-Wert | 20   |   -5900.00    | gebucht   |
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-3" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

Scenario:  Ruecklieferung
Given I set the fake date to "15.02.1995"
#
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "60333.2"
And I close the current editor
 
# R�cklieferschein 1 zu KT-BEIST anlegen
Given I open an editor "rls-60333.2" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "60333.2"
And I set field "num4" to "60333.2R"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-8" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-4" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "60333.2"
And I close the current editor

# Lagermenge pr�fen
# TODOSIH: wegen Fehler bei Rücklieferung Koppelteil bleiben hier die 20 St�ck, korrekt w�ren 12 St�ck
# siehe EVS-1705 (Koppelprodukte bei R�cklieferungen behandeln)
# KOPPEL   |           |       |       |  20    | Stück | 10.02.95 |          |           |           |           |           |
# KOPPEL   | LOHNF     |       |       |  20    | Stück | 10.02.95 |          |           |           |           |           |
# KOPPEL   | LOHNF     | LOHNF |       |  20    | Stück | 10.02.95 |          |           |           |           |           | 
# KOPPEL   | LOHNF     | LOHNF | LOHNF |  20    | Stück | 10.02.95 |          |  L60333.2 |  L60333.2 |  L60333.2 | L60333.2  |
And I append "--- 3 Lagermenge ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir
And I export "bewertungslagermengen1" from StorageQuantities where "" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref"
And I append "--- Ende 3 Lagermenge ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir

# Lagerjournal pr�fen
And I append "--- 3 Lagerjournal ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "@ordnung=budat" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref"
And I append "--- Ende 3 Lagerjournal ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir

# Artikelmengen pr�fen
And I append "--- 3 Artikelmengen ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref"
And I append "--- Ende 3 Artikelmengen ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir
 
# R�cklieferschein 2 zu KT-BEIST anlegen
Given I open an editor "rls-60333.3" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "60333.2"
And I set field "num4" to "60333.3R"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-12" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-5" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# R�cklieferschein zu EKTEIL anlegen
Given I open an editor "rls-300002" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "300002"
And I set field "num4" to "302R"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-100" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-6" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Lagermenge pr�fen
# SIHTODO: wegen Fehler bei Rücklieferung Koppelteil bleiben hier die 20 St�ck, korrekt w�ren 0 St�ck
# siehe EVS-1705 (Koppelprodukte bei R�cklieferungen behandeln)
# KOPPEL   |           |       |       |  20    | Stück | 10.02.95 |          |           |           |           |           |
# KOPPEL   | LOHNF     |       |       |  20    | Stück | 10.02.95 |          |           |           |           |           |
# KOPPEL   | LOHNF     | LOHNF |       |  20    | Stück | 10.02.95 |          |           |           |           |           | 
# KOPPEL   | LOHNF     | LOHNF | LOHNF |  20    | Stück | 10.02.95 |          |  L60333.2 |  L60333.2 |  L60333.2 | L60333.2  |

And I append "--- 4 Lagermenge ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir
And I export "bewertungslagermengen2" from StorageQuantities where "" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref"
And I append "--- Ende 4 Lagermenge ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir

# Lagerjournal pr�fen
# SIHTODO: warum sind in folgender Zeile rueckmge und rueckgmge 0 und warum ist die restgmge ungleich 0? wegen BW2-980.
# siehe EVS-1705 (Koppelprodukte bei R�cklieferungen behandeln)
# KOPPEL  | L60333.2  |    1  | Lieferschein Einkauf      |   20 |    0     |  20  |    0      |   20    | nein    |          |           |
And I append "--- 4 Lagerjournal ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "@ordnung=budat" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref"
And I append "--- Ende 4 Lagerjournal ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir

# Artikelmengen pr�fen
And I append "--- 4 Artikelmengen ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref"
And I append "--- Ende 4 Artikelmengen ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir

######################################################################
# Lagerwert pruefen
######################################################################
# SIHTODO 27.09.2019:
# Nach vollst�ndiger Ruecklieferung der gebuchen Vorgaenge sollte der Lagerwert null sein.
# Da jedoch das Koppelteil nicht r�ckgeliefert wird, bleibt dessen Wert auf dem Konto stehen.
# siehe EVS-1705 (Koppelprodukte bei R�cklieferungen behandeln)
Given I open the infosystem "LAGERWERTAKTUELL"
And I set field "bprokonto" to "ja"
And I press start
# Then field "summe" has value "6500.00"
Then field "summe" has value "6000.00"
Then the table has 1 rows
Then table has values
    | kkoreso   | krech    | koendsaldo |  kodifferenz  |
    | 10555     | 6000.00  |   6000.00  |       0.00    |
And I close the current editor

#######################################################################
# PRUEFEN BEWERTUNGEN NACH RUECKLIEFERUNG 
#######################################################################
# Bewertung zu Abgang Einkaufsteil
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=ekteil;buart=Abgang;detursache=Ruecklieferung Einkauf;@richtung=rückwärts;@maxtreffer=1"
Then table has values
    | kart     | tmge |   lbdiff   | tlbstatus |
    | Entnahme |  0   |    0.00    | verworfen |
    | Entnahme | 12   |  -60.00    | gebucht   |
And I close the current editor

# SIHTODO 27.09.2019: Bewertung zu Zugang Koppelteil - FEHLT
# siehe EVS-1705 (Koppelprodukte bei R�cklieferungen behandeln)
#Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=koppel;buart=Zugang;detursache=Ruecklieferung Einkauf;@richtung=rückwärts;@maxtreffer=1"
#Then table has values
#    | kart              | tmge |   lbdiff    | tlbstatus |
#    | Lieferschein-Wert | 20   |   6000.00   | gebucht   |
#And I close the current editor

# Bewertung zu Zugang Kaufteil mit Beistellung, Hauptsatz
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=kt-beist;buart=Zugang;detursache=Ruecklieferung Einkauf;beistelldaten=nein;@richtung=rückwärts;@maxtreffer=1"
Then table has values
    | kart              | tmge |  lbdiff   | tlbstatus |
    | Lieferschein-Wert |  0   |   0.00    | verworfen |
    | Lieferschein-Wert | 12   |  -36.00   | gebucht   |
And I close the current editor

# Bewertung zu Zugang Kaufteil mit Beistellung, Beistellsatz
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=kt-beist;buart=Zugang;detursache=Ruecklieferung Einkauf;beistelldaten=ja;@richtung=vorwaerts;@maxtreffer=1"
Then table has values
    | kart              | tmge |    lbdiff   | tlbstatus |
    | Lieferschein-Wert |  0   |     0.00    | verworfen |
    | Lieferschein-Wert | 12   |  3540.00    | gebucht   |
And I close the current editor

#Scenario: Storno der Ruecklieferung                     
Given I set the fake date to "20.02.1995"
#
Given I open an editor "lieferschein-st-rls-60333.2" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+60333.2R" 
And I set field "num4" to "60.2RS"
And I save the current editor
#
Given I open an editor "lieferschein-st-rls-60333.3" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+60333.3R" 
And I set field "num4" to "60.3RS"
And I save the current editor
#
Given I open an editor "lieferschein-st-rls-302R" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+302R" 
And I set field "num4" to "302RS"
And I save the current editor
#

# SIHTODO 27.09.2019: dieses Nachbewerten ist nur eine Abhilfe, weil der Bewertungspreis sonst nicht geliefert wird
# ABC-Nachbewerten - bringt den Preis für das Storno der Rücklieferung des Beistellabgangs, ver�ndert jedoch die Detailursache auf "Lieferschein"
# siehe BW2-1009 (Nachbewerten ver�ndert Detailursache)
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-7" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."
#

# Lagermenge pr�fen
And I append "--- 5 Lagermenge ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir
And I export "bewertungslagermengen1" from StorageQuantities where "" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref"
And I append "--- Ende 5 Lagermenge ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir

# Lagerjournal pr�fen
And I append "--- 5 Lagerjournal ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "@ordnung=budat" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref"
And I append "--- Ende 5 Lagerjournal ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir

# Artikelmengen pr�fen
And I append "--- 5 Artikelmengen ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref"
And I append "--- Ende 5 Artikelmengen ---" to output file "ref_storno_und_rueckl_koppel_lbei_cu.ref" in cucu_refs_dir

#######################################################################
## Lagerwert pruefen
#######################################################################
Given I open the infosystem "LAGERWERTAKTUELL"
And I set field "bprokonto" to "ja"
And I press start
Then field "summe" has value "560.00"
Then the table has 2 rows
Then table has values
    | kkoreso   | krech    | koendsaldo |  kodifferenz  |
    | 10000     |  400.00  |    400.00  |       0.00    |
    | 10555     |  160.00  |    160.00  |       0.00    |
And I close the current editor

#######################################################################
# PRUEFEN BEWERTUNGEN NACH STORNO DER RUECKLIEFERUNG 
#######################################################################

# Bewertung zu Abgang Einkaufsteil
# SIHTODO 27.09.2019: hier muss nach Korrektur wieder die auskommentierte Detailursache stehen
# Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=ekteil;buart=Abgang;detursache=Storno-Ruecklieferung Einkauf;@richtung=rückwärts;@maxtreffer=1"
# durch das ABC_Nachbewerten, welches den Preis für das Storno der RL bringt, wird die Detailursache auf Lieferschein geaendert
# siehe BW2-1009 (Nachbewerten ver�ndert Detailursache)
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=ekteil;buart=Abgang;detursache=Lieferschein Einkauf;@richtung=rückwärts;@maxtreffer=1"
Then table has values
    | kart     | tmge |   lbdiff   | tlbstatus |
    | Entnahme | 20   |   100.00   | gebucht   |
And I close the current editor

# SIHTODO 27.09.2019: Bewertung zu Zugang Koppelteil - FEHLT
# siehe EVS-1705 (Koppelprodukte bei R�cklieferungen behandeln)
#Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=koppel;buart=Zugang;detursache=Storno-Ruecklieferung Einkauf;@richtung=rückwärts;@maxtreffer=1"
#Then table has values
#    | kart              | tmge |   lbdiff    | tlbstatus |
#    | Lieferschein-Wert | 20   |   6000.00   | gebucht   |
#And I close the current editor

# Bewertung zu Zugang Kaufteil mit Beistellung, Hauptsatz
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=kt-beist;buart=Zugang;detursache=Storno-Ruecklieferung Einkauf;beistelldaten=nein;@richtung=rückwärts;@maxtreffer=1"
Then table has values
    | kart              | tmge |  lbdiff   | tlbstatus |
    | Lieferschein-Wert | 20   |   60.00   | gebucht   |
And I close the current editor

# Bewertung zu Zugang Kaufteil mit Beistellung, Beistellsatz
# SIHTODO 10.10.2019: folgende Bewertung wird nicht gefunden, sie hat durch das Nachbewerten (BW2-1009) eine andere Detailursache.
# Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=kt-beist;buart=Zugang;detursache=Storno-Ruecklieferung Einkauf;beistelldaten=ja;@richtung=vorwaerts;@maxtreffer=1"
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=kt-beist;buart=Zugang;detursache=Lieferschein Einkauf;beistelldaten=ja;@richtung=vorwaerts;@maxtreffer=1"
Then table has values
    | kart              | tmge |    lbdiff   | tlbstatus |
    | Lieferschein-Wert | 20   |  -5900.00   | gebucht   |
And I close the current editor
