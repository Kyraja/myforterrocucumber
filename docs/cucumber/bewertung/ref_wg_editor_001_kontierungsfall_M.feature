# *****************************************************************************
#  Name             : ref_wg_editor_001_kontierungsfall_M.feature
#  Autor            : wane
#  Verantwortlich   : sih
#  Kontrolle        : 
#  Funktion         : das Editieren
#
#                    kurze Zusammenfassung von Bewertungsketten:
#                    ===========================================
#
# *****************************************************************************
@persistent
Feature: WG; Kontierungsfall M
Background: Test von Kontierungsfall 'M' -> besonders die Ersetzung der Konten
Given I set the fake date to "07.01.2002"


@FALL-Inland/EU/Ausland/mitLS
Scenario: Stammdaten; Lieferantenbeistellung Inland/EU/Ausland; mit LS

## ******* Start: Warengruppe erweitern **********
#
#
Given I open an editor "wgruppe2" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "55"
And I create a new row at the end of the table
And I set field "bvfall" to "A" in row 1
And I set field "bestkto" to "10000" in row 1
And I set field "bvkonto" to "50000" in row 1
And I create a new row at the end of the table
And I set field "bvfall" to "B" in row 2
And I set field "bestkto" to "10000" in row 2
And I set field "bvkonto" to "50000" in row 2
And I create a new row at the end of the table
And I set field "bvfall" to "C" in row 3
And I set field "bestkto" to "10000" in row 3
And I set field "bvkonto" to "50000" in row 3
And I create a new row at the end of the table
And I set field "bvfall" to "D" in row 4
And I set field "bestkto" to "10000" in row 4
And I set field "bvkonto" to "50000" in row 4
And I create a new row at the end of the table
And I set field "bvfall" to "E" in row 5
And I set field "bestkto" to "10000" in row 5
And I set field "bvkonto" to "50000" in row 5
And I create a new row at the end of the table
And I set field "bvfall" to "F" in row 6
And I set field "bestkto" to "10000" in row 6
And I set field "bvkonto" to "50000" in row 6
And I create a new row at the end of the table
And I set field "bvfall" to "G" in row 7
And I set field "bestkto" to "10000" in row 7
And I set field "bvkonto" to "50000" in row 7
And I create a new row at the end of the table
And I set field "bvfall" to "H" in row 8
And I set field "bestkto" to "10000" in row 8
And I set field "bvkonto" to "50000" in row 8
And I create a new row at the end of the table
And I set field "bvfall" to "I" in row 9
And I set field "bestkto" to "10000" in row 9
And I set field "bvkonto" to "50000" in row 9
And I create a new row at the end of the table
And I set field "bvfall" to "J" in row 10
And I set field "bestkto" to "10000" in row 10
And I set field "bvkonto" to "50000" in row 10
And I create a new row at the end of the table
And I set field "bvfall" to "L" in row 11
And I set field "bestkto" to "10000" in row 11
And I set field "bestktoneu" to "13700" in row 11
And I create a new row at the end of the table
And I set field "bvfall" to "K" in row 12
And I set field "bestkto" to "10000" in row 12
And I set field "bestktoneu" to "10900" in row 12
And I create a new row at the end of the table
And I set field "bvfall" to "K" in row 13
And I set field "bestkto" to "10015" in row 13
And I set field "bestktoneu" to "10950" in row 13
And I create a new row at the end of the table
And I set field "bvfall" to "K" in row 14
And I set field "bestkto" to "10013" in row 14
And I set field "bestktoneu" to "11100" in row 14
And I create a new row at the end of the table
And I set field "bvfall" to "K" in row 15
And I set field "bestkto" to "10018" in row 15
And I set field "bestktoneu" to "11110" in row 15
#
# neuen Fall aktiviert
And I create a new row at the end of the table
And I set field "bvfall" to "M" in row 16
And I set field "vrgstrgl" to "6002" in row 16
And I set field "bestktoneu" to "10011" in row 16
And I set field "bvkonto" to "50011" in row 16
And I create a new row at the end of the table
And I set field "bvfall" to "M" in row 17
And I set field "vrgstrgl" to "6005" in row 17
And I set field "bestktoneu" to "10012" in row 17
And I set field "bvkonto" to "50012" in row 17
And I create a new row at the end of the table
And I set field "bvfall" to "M" in row 18
And I set field "vrgstrgl" to "6001" in row 18
And I set field "bestktoneu" to "10013" in row 18
And I set field "bvkonto" to "50013" in row 18
And I create a new row at the end of the table
And I set field "bvfall" to "M" in row 19
And I set field "vrgstrgl" to "6004" in row 19
And I set field "bestktoneu" to "10014" in row 19
And I set field "bvkonto" to "50014" in row 19
And I create a new row at the end of the table
And I set field "bvfall" to "M" in row 20
And I set field "vrgstrgl" to "6000" in row 20
And I set field "bestktoneu" to "10015" in row 20
And I set field "bvkonto" to "50015" in row 20
And I create a new row at the end of the table
And I set field "bvfall" to "M" in row 21
And I set field "vrgstrgl" to "6003" in row 21
And I set field "bestktoneu" to "10016" in row 21
And I set field "bvkonto" to "50016" in row 21
And I create a new row at the end of the table
And I set field "bvfall" to "M" in row 22
And I set field "vrgstrgl" to "6009" in row 22
And I set field "bestktoneu" to "10017" in row 22
And I set field "bvkonto" to "50017" in row 22
#
# fuer K-Fall wird das Bestandskonto fuer Beistellung ueber Fall M ermittellt
# deswegen alle Varianten aus M fuer K und C nachgezogen
#10011
#10012
#10013
#10014
#10015
#10016
#10017
And I create a new row at the end of the table
And I set field "bvfall" to "K" in row 23
And I set field "bestkto" to "10011" in row 23
And I set field "bestktoneu" to "10900" in row 23
And I create a new row at the end of the table
And I set field "bvfall" to "K" in row 24
And I set field "bestkto" to "10012" in row 24
And I set field "bestktoneu" to "10900" in row 24
And I create a new row at the end of the table
And I set field "bvfall" to "K" in row 25
And I set field "bestkto" to "10014" in row 25
And I set field "bestktoneu" to "10900" in row 25
And I create a new row at the end of the table
And I set field "bvfall" to "K" in row 26
And I set field "bestkto" to "10016" in row 26
And I set field "bestktoneu" to "10900" in row 26
And I create a new row at the end of the table
And I set field "bvfall" to "K" in row 27
And I set field "bestkto" to "10017" in row 27
And I set field "bestktoneu" to "10900" in row 27
#
And I create a new row at the end of the table
And I set field "bvfall" to "C" in row 28
And I set field "bestkto" to "10011" in row 28
And I set field "bvkonto" to "50000" in row 28
And I create a new row at the end of the table
And I set field "bvfall" to "C" in row 29
And I set field "bestkto" to "10012" in row 29
And I set field "bvkonto" to "50000" in row 29
And I create a new row at the end of the table
And I set field "bvfall" to "C" in row 30
And I set field "bestkto" to "10013" in row 30
And I set field "bvkonto" to "50000" in row 30
And I create a new row at the end of the table
And I set field "bvfall" to "C" in row 31
And I set field "bestkto" to "10014" in row 31
And I set field "bvkonto" to "50000" in row 31
And I create a new row at the end of the table
And I set field "bvfall" to "C" in row 32
And I set field "bestkto" to "10015" in row 32
And I set field "bvkonto" to "50000" in row 32
And I create a new row at the end of the table
And I set field "bvfall" to "C" in row 33
And I set field "bestkto" to "10016" in row 33
And I set field "bvkonto" to "50000" in row 33
And I create a new row at the end of the table
And I set field "bvfall" to "C" in row 34
And I set field "bestkto" to "10017" in row 34
And I set field "bvkonto" to "50000" in row 34
#
And I save the current editor
And I close the current editor
#
#
## ******* Ende: Warengruppe erweitern **********

## ******* Start: fuer Beistellung benoetigten Teile Einkaufen **********
#
# EK-Rechnung anlegen -> Inland
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "400RE-IN"
And I set field "lief" to "001"
And I set field "ueb" to "ja"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "budat" to "."
And I set field "erfwaehr" to "EUR"
And I create a new row at the end of the table
And I set field "artex" to "203" in row 1
And I set field "mge" to "500" in row 1
And I set field "preis" to "3.50" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#
# EK-Rechnung anlegen -> Frankreich
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "400RE-EU"
And I set field "lief" to "003"
And I set field "ueb" to "ja"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "budat" to "."
And I set field "erfwaehr" to "EUR"
And I create a new row at the end of the table
And I set field "artex" to "202" in row 1
And I set field "mge" to "200" in row 1
And I set field "preis" to "11" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
# 
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."
#
#
## ******* Ende: fuer Beistellung benoetigten Teile Einkaufen **********


## ******* Start: Beistellartikel einkaufen/liefern **********
#
# Artikel mit Beistellung bestellen -> Inland
# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "num4" to "100BE"
And I set field "kenn" to "Inland"
And I set field "erfwaehr" to "EUR"
And I create a new row at the end of the table
And I set field "artex" to "400beist" in row 1
And I set field "mge" to "20" in row 1
And I set field "preis" to "70" in row 1
And I save the current editor
#
# EK-Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "100LS-IN"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "20" in row 1
And I save the current editor
#
#
# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."
#
# EK-Rechnung bezahlen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "100RE-IN"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "20" in row 1
And I set field "preis" to "71" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#
#
# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Artikel mit Beistellung bestellen -> EU
# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "003"
And I set field "num4" to "103BE"
And I set field "vstaat" to "Spanien"
And I set field "rechnustid" to "FR123456"
And I set field "kenn" to "EU"
And I set field "erfwaehr" to "EUR"
And I create a new row at the end of the table
And I set field "artex" to "400beist" in row 1
And I set field "mge" to "5" in row 1
And I set field "preis" to "77" in row 1
And I save the current editor
#
# EK-Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "103LS-EU"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "5" in row 1
And I save the current editor
#
# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."
#
# EK-Rechnung bezahlen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "103EU"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "5" in row 1
And I set field "preis" to "78" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#
# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."


# Artikel mit Beistellung bestellen -> Ausland
# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "9746"
And I set field "num4" to "120BE"
And I set field "kenn" to "Ausland"
And I set field "erfwaehr" to "EUR"
And I create a new row at the end of the table
And I set field "artex" to "400beist" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "71.5" in row 1
And I save the current editor
#
# EK-Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "120LS-AU"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I save the current editor
#
#
# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."
#
#
# EK-Rechnung bezahlen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "120RE-AU"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "preis" to "71.5" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#
# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."
#
#
## ******* Ende: Beistellartikel einkaufen/liefern **********



## ******* Start: Beistellartikel verkaufen/liefern **********
#
# VK-Rechnung mit Artikel "400beist" anlegen/verbuchen -> Frankreich
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "400RE-EU"
And I set field "kunde" to "003"
And I set field "ueb" to "ja"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "budat" to "."
And I set field "waehr" to "EUR"
And I create a new row at the end of the table
And I set field "artex" to "400beist" in row 1
And I set field "mge" to "50" in row 1
And I set field "preis" to "250" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#
# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."
#
#
## ******* Ende: Beistellartikel verkaufen/liefern **********
#####################################################################################################################################


@FALL-Inland/EU/Ausland/ohneLS
Scenario: Lieferantenbeistellung Inland/EU/Ausland; ohne LS

## ******* Start: Beistellartikel einkaufen; RE mit Lagerbewegung **********
#
# EK-Rechnung bezahlen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "200RE-IN"
And I set field "lief" to "001"
And I set field "kenn" to "Inland2"
And I set field "erfwaehr" to "EUR"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "400beist" in row 1
And I set field "mge" to "23" in row 1
And I set field "preis" to "70" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#
# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."
#
# EK-Rechnung bezahlen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "200RE-AU"
And I set field "lief" to "9746"
And I set field "kenn" to "Ausland2"
And I set field "erfwaehr" to "EUR"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "400beist" in row 1
And I set field "mge" to "17" in row 1
And I set field "preis" to "65" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#
# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."
#
#
## ******* Ende: Beistellartikel einkaufen; RE mit Lagerbewegung **********

## ******* Start: Beistellartikel verkaufen/liefern **********
#
# VK-Rechnung mit Artikel "400beist" anlegen/verbuchen -> Frankreich
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "800RE-EU"
And I set field "kunde" to "003"
And I set field "ueb" to "ja"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "budat" to "."
And I set field "waehr" to "EUR"
And I create a new row at the end of the table
And I set field "artex" to "400beist" in row 1
And I set field "mge" to "25" in row 1
And I set field "preis" to "270" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#
# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."
#
#
## ******* Ende: Beistellartikel verkaufen/liefern **********
#####################################################################################################################################


@FALL-MZ
Scenario: Lieferantenbeistellung Inland/EU/Ausland; mit MZ


## ******* Start: Beistellteile einkaufen; RE mit Lagerbewegung **********
#
# Beistellteile (E2 und E3) auf Vorrat einkaufen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "500RE"
And I set field "lief" to "001"
And I set field "kenn" to "Vorbereitung FALL-MZ,"
And I set field "erfwaehr" to "EUR"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E2" in row 1
And I set field "mge" to "1500" in row 1
And I set field "preis" to "1,50" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E3" in row 2
And I set field "mge" to "1500" in row 2
And I set field "preis" to "1,10" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#
## ******* Ende: Beistellteile einkaufen; RE mit Lagerbewegung **********


## ******* Start: Beistellartikel einkaufen; BE -> LS -> TRE1, TRE2, TRE3 **********
#

# eine Bestellung fuer Artikel mit Beistellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
# EU-Lieferant
And I set field "lief" to "004"
And I set field "num4" to "1mz-BE"
And I set field "kenn" to "FALL-MZ"
And I create a new row at the end of the table
And I set field "artex" to "400beist" in row 1
And I set field "mge" to "120" in row 1
And I set field "preis" to "75" in row 1
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "1mz-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "schlag" to "FALL-MZ EU"
And I press button "mzsubm" to open a subeditor for "MZFertig" in row !lastRow
And I set field "zuomge" to "21" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "55" in row 2
And I create a new row at the end of the table
And I set field "zuomge" to "44" in row 3
And I save the current editor
And I close the current editor
And I switch the current editor to editor "lieferschein-1"
And I save the current editor


# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."


# EK-Rechnung bezahlen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "1mzRE-IN"
# Inland-Lieferant
And I set field "lief" to "001"
And I set field "schlag" to "FALL-MZ Inland"
And I set field "erfwaehr" to "EUR"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "23" in row 1
And I set field "preis" to "70" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#
# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# EK-Rechnung bezahlen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "1mzRE-AU"
# Ausland-Lieferant
And I set field "lief" to "9746"
And I set field "schlag" to "FALL-MZ Ausland"
And I set field "erfwaehr" to "EUR"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "17" in row 1
And I set field "preis" to "65" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#
# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# EK-Rechnung (Rest) bezahlen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "1mzRE-EU"
# EU-Lieferant
And I set field "schlag" to "FALL-MZ EU"
And I set field "erfwaehr" to "EUR"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I set field "preis" to "77" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#
# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."
#
#
#
## ******* Ende: Beistellartikel einkaufen; BE -> LS -> TRE1, TRE2, TRE3  **********

## ******* Start: Beistellartikel verkaufen/liefern **********
#
# VK-Rechnung mit Artikel "400beist" anlegen/verbuchen -> Frankreich
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "1mzRE-EU"
And I set field "kunde" to "003"
And I set field "ueb" to "ja"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "budat" to "."
And I set field "waehr" to "EUR"
And I create a new row at the end of the table
And I set field "artex" to "400beist" in row 1
And I set field "mge" to "120" in row 1
And I set field "preis" to "270" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#
# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."
#
#
## ******* Ende: Beistellartikel verkaufen/liefern **********
#####################################################################################################################################

@FALL-MZ2
Scenario: Lieferantenbeistellung Inland/EU/Ausland; mit MZ; RE vor LS

## ******* Start: Beistellartikel einkaufen; BE -> TRE1, TRE2, TRE3 -> LS **********
#

# eine Bestellung fuer Artikel mit Beistellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
# EU-Lieferant
And I set field "lief" to "004"
And I set field "num4" to "2mz-BE"
And I set field "schlag" to "FALL-MZ2"
And I create a new row at the end of the table
And I set field "artex" to "400beist" in row 1
And I set field "mge" to "120" in row 1
And I set field "preis" to "75" in row 1
And I save the current editor


# EK-Rechnung bezahlen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "2mzRE-IN"
# Inland-Lieferant
And I set field "lief" to "001"
And I set field "schlag" to "FALL-MZ2 Inland"
And I set field "erfwaehr" to "EUR"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "23" in row 1
And I set field "preis" to "70" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#
# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# EK-Rechnung bezahlen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "2mzRE-AU"
# Ausland-Lieferant
And I set field "lief" to "9746"
And I set field "schlag" to "FALL-MZ2 Ausland"
And I set field "erfwaehr" to "EUR"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "17" in row 1
And I set field "preis" to "65" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#
# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# EK-Rechnung (Rest) bezahlen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "2mzRE-EU"
# EU-Lieferant
And I set field "schlag" to "FALL-MZ2 EU"
And I set field "erfwaehr" to "EUR"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I set field "preis" to "77" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#
# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."


# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "2mz-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "schlag" to "FALL-MZ2 EU"
And I press button "mzsubm" to open a subeditor for "MZFertig" in row !lastRow
And I set field "zuomge" to "21" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "55" in row 2
And I create a new row at the end of the table
And I set field "zuomge" to "44" in row 3
And I save the current editor
And I close the current editor
And I switch the current editor to editor "lieferschein-1"
And I save the current editor


# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."
#
#
## ******* Ende: Beistellartikel einkaufen; BE -> TRE1, TRE2, TRE3 -> LS  **********

## ******* Start: Beistellartikel verkaufen/liefern **********
#
# VK-Rechnung mit Artikel "400beist" anlegen/verbuchen -> Frankreich
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "2mzRE-EU"
And I set field "kunde" to "003"
And I set field "ueb" to "ja"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "budat" to "."
And I set field "waehr" to "EUR"
And I create a new row at the end of the table
And I set field "artex" to "400beist" in row 1
And I set field "mge" to "120" in row 1
And I set field "preis" to "270" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#
# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."
#
#
## ******* Ende: Beistellartikel verkaufen/liefern **********
#####################################################################################################################################
