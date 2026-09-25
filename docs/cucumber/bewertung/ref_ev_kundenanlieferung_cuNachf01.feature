# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Funktion       : 
# *****************************************************************************
#
@persistent
Feature: Kundenanlieferung
Background:
Given I set the fake date to "02.01.1995"

# ==================================================================
@Mengenneubewertung
Scenario: Kommando <(QuantityRevaluation)>

Given I set the fake date to "09.01.1995"
# ------------------------------

# MN die storniert wird (auch wg. datrep-test)
Given I open an editor "MN1" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MN1SUCH" 

Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,artikel=V1;vorgang^kopf^such=KANLMZ1;buart=1;mge==10;buart=1;verw==B10;@datei=10;@gruppe=1" in row 1
And I set field "ntbewpr" to "5" in row 1

And I save the current editor
And I close the current editor

# ------------------------------
# 21.2.22: die menge dieser MN geht nun nach lmenge21 in diesem test nicht mehr ab. 
# MN die nicht storniert wird wg. datrep-test (mit cucu kommt ja nicht dazwischen,
# deshalb die varianten ueber die daten)
Given I open an editor "MN2" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MN2SUCH" 

Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,artikel=V1;vorgang^kopf^such=KANLLS3;buart=1;mge==7;@datei=10;@gruppe=1" in row 1
And I set field "ntbewpr" to "44" in row 1

And I save the current editor
And I close the current editor

# ==================================================================
@kundenanlieferung
Scenario: abgange von kundenanlieferungsbestand aus konsi nach extern
Given I set the fake date to "11.01.1995"

# --------- abang ueber VK -----------
Given I open an editor "VKLS" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | ueb   | ja                |
   | kunde | 1                 |
   | such  | KANLVKLS    |
   | vom   | .                 |
And I append rows
   | artikel | mge  | preis | platz   |
   | V1      |  2   | 6     | KONSILP |
Then the table has 1 rows
Then field "mge" has value "2" in row 1
And I save the current editor

# -------------- abgang ins nirvana -----------
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | V1 |
    | buart     | Abgang    |
    | beleg     | Kanlnirvana    |
    | beldat    | .         |
And I append rows
    | mge       | platz   |
    |  3        | KONSILP |
And I save the current editor

# ==================================================================
@kundenanlieferung
Scenario: kundenanlieferung aus konsi auf verschieden arten ins eigentum umbuchen oder umlagern
Given I set the fake date to "14.01.1995"
 
# ------------ umbuchen ------------------
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | V1 |
    | buart     | umbuchung |
    | beleg     | Kanl-F1   |
    | beldat    | .         |
And I append rows
    | mge       | platz   | platz2 | verw  |
    |  2        | KONSILP |     F1 | eignt |
And I save the current editor

# ---- Mengenneubewertung der ins eigentum umgebuchten menge -------
Given I open an editor "MN3" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MN3EIGTM" 

Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,artikel=V1;platz=F1;mge==2;buart=1;@datei=10;@gruppe=1" in row 1
And I set field "ntbewpr" to "3.5" in row 1

And I save the current editor
And I close the current editor

# ------ direktes umlagern mit buchungswunsch ----------------
Given I open an editor "DirektUmlagern" from table "(Purchasing):(RelocationSuggestions)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "mge" to "6" in row 1
And I set field "abplatz" to "KONSILP" in row 1
And I set field "verw2" to "MN-UML-EIGT" in row 1
And I set field "platz" to "F2" in row 1
And I set field "verw" to "UMLZ-MIT-MKV" in row 1
And I set field "mfreig" to "JA" in row 1
And I set field "beleg" to "diruml1"
And I set field "beldat" to "."
And I set field "mkvwunsch" to "ja"
And I press button "umbuchen" to open a subeditor for "Umlagerung"
And I close the current editor
And I switch the current editor to editor "DirektUmlagern"
And I save the current editor

# ------------- direktes umlagern ohne buchungswunsch ------------
Given I open an editor "DirektUmlagern2" from table "(Purchasing):(RelocationSuggestions)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "mge" to "1" in row 1
And I set field "abplatz" to "KONSILP" in row 1
And I set field "verw2" to "MN-UML-EIGT" in row 1
And I set field "platz" to "F2" in row 1
And I set field "verw" to "UMLZ-OH-MKV" in row 1
And I set field "mfreig" to "JA" in row 1

And I set field "beleg" to "diruml2"
And I set field "beldat" to "."
And I set field "mkvwunsch" to "nein"

And I press button "umbuchen" to open a subeditor for "Umlagerung2"
And I close the current editor
And I switch the current editor to editor "DirektUmlagern2"
And I save the current editor

# ---------- umlagerungslieferschein ohne buchungswunsch -------
Given I open an editor "Umlls-oh-mkv" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "bsart" to "umlagern"
And I set field "lief" to "1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "num4" to "83757ls"
And I create a new row at the end of the table
And I set field "artikel" to "V2" in row 1
And I set field "mge" to "1" in row 1
And I set field "abplatz" to "KONSILP" in row 1
And I set field "platz" to "F1" in row 1
And I set field "verw" to "UMLLS-OH-MKV" in row 1
And I save the current editor
And I close the current editor

# re zum ls unmittelbar oberhalb
Given I open an editor "uml-Rechn" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "83757ls"
And I set field "num4" to "83757re"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "preis" to "5.50" in row 1
And I respond with answer "yes" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# ---------- umlagerungslieferschein mit buchungswunsch -------
Given I open an editor "Umlls-mit-mkv" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "bsart" to "umlagern"
And I set field "lief" to "1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "num4" to "27484ls"
And I set field "mkvwunsch" to "ja"
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "mge" to "3" in row 1
And I set field "abplatz" to "KONSILP" in row 1
And I set field "platz" to "F2" in row 1
And I set field "verw" to "UMLLS-MIT-MKV" in row 1
And I save the current editor

# re zum ls unmittelbar oberhalb
Given I open an editor "uml-Rechn2" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "27484ls"
And I set field "num4" to "27484re"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "preis" to "7.0" in row 1
And I respond with answer "yes" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# ---------------------
