@persistent
Feature: Storno EK
Background: Test von Stornos im Einkauf
Given I set the fake date to "08.01.2002"


@Stammdaten
Scenario: Kommando <(Part)> <(new)>
Given I set the fake date to "08.01.2002"

Given I open an editor "artikel" from table "(Part):(Product)" with command "NEW" for record ""

And I set field "num2" to "34345" 
And I set field "such2" to "artohneekpreis" 

And I save the current editor
And I close the current editor

# ----------------------
@Stammdaten
Scenario: Kommando <(Customer)> <(update)>
Given I open an editor "k1" from table "(Customer):(Customer)" with command "UPDATE" for record "TEST"

And I set field "waehr" to "EUR"

And I save the current editor
And I close the current editor
# hilft leider nix

# ----------------------
@Lieferschein
Scenario: Kommando <(Purchasing)> LIEFERSCHEIN <(new)>
# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
# Lieferscheinart kann nicht geandert werden.

Given I open an editor "LS1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""

Then field "typa" has value "Lieferschein"
Then field "lief" is modifiable

And I set field "lief" to "TEST"
And I set field "vom" to "." 
And I set field "num4" to "37476ls" 
And I set field "ueb" to "ja" 
And I set field "erfwaehr" to "EUR"

And I create a new row at the end of the table
And I set field "artikel" to "13vo" in row 1
And I set field "mge" to "2" in row 1
And I set field "preis" to "20" in row 1

And I save the current editor
And I close the current editor

# ---------------------
@Kostenbuchung
Scenario: Kommando <(CostEntriesSuggestion) A >
# Given I set the fake date to "09.01.2002"

Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""

And I set field "adat" to "01.01.2002" 
And I set field "edat" to "." 
And I press button "kosvor"

And I respond with answer "yes" to the dialog with id "2324"
# 5567 ist nur das Fragewort Weiter?, JEDOCH SIND EIGENTLICH FOLGENDE FRAGEN INHALTLICH ENTSCHEIDEND, DIE HIER ANGEZEIGT WERDEN MUESSEN!
# Kostenbuchungen ab Startdatum %s erzeugen. oder...
# Kostenbuchungsvorschlag speichern und Startdatum auf den %s setzen.
And I respond with answer "yes" to the dialog with id "5567"
And I save the current editor

And I close the current editor

@EK-Rechnung
Scenario: Kommando <(Purchasing)> RE <(new)>
Given I set the fake date to "09.01.2002"

Given I open an editor "RE_zu_LS1" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "37476ls"
And I set field "num4" to "37476re" 
And I set field "vom" to "." 
And I set field "ueb" to "ja" 

And I respond with answer "yes" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# ---------------------
@Mengenneubewertung
Scenario: Kommando <(QuantityRevaluation)>
Given I set the fake date to "09.01.2002"

Given I open an editor "MN1" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MN1SUCH" 

Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,art=13vo;buart=1;platz=F2;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "55" in row 1
# nbewertet

And I save the current editor
And I close the current editor

# ---------------------
# ---------------------

@Kostenbuchung
Scenario: Kommando <(CostEntriesSuggestion) B >
Given I set the fake date to "10.01.2002"

Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""

And I set field "adat" to "01.01.2002"
And I set field "edat" to "." 
And I press button "kosvor"

And I set field "buchen" to "nein" in row 2 

And I respond with answer "yes" to the dialog with id "2324"

And I save the current editor
And I close the current editor

# ---------------------
@Mengenneubewertung
Scenario: Kommando <(QuantityRevaluation)>
Given I set the fake date to "10.01.2002"

Given I open an editor "MN2" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MN2SUCH" 

Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,art=13vo;buart=1;platz=F2;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1

And I set field "ntbewpr" to "42" in row 1
# nbewertet

And I save the current editor
And I close the current editor

# ---------------------
@Kostenbuchung
Scenario: Kommando <(CostEntriesSuggestion) C1 >
Given I set the fake date to "10.01.2002"

Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""

And I set field "adat" to "01.01.2002"
And I set field "edat" to "." 
And I press button "kosvor"

And I set field "buchen" to "nein" in row 2 

And I respond with answer "yes" to the dialog with id "2324"

And I save the current editor
And I close the current editor

# ---------------------
@Mengenneubewertung
Scenario: Kommando <(QuantityRevaluation)>
Given I set the fake date to "11.01.2002"

Given I open an editor "SMN1" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MN1SUCH"
And I set field "such" to "SMN1SUCH" 

And I save the current editor
And I close the current editor

# ---------------------
@Kostenbuchung
Scenario: Kommando <(CostEntriesSuggestion) C2 >
Given I set the fake date to "11.01.2002"

Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""

And I set field "adat" to "01.01.2002"
And I set field "edat" to "." 
And I press button "kosvor"

And I respond with answer "yes" to the dialog with id "2324"
And I save the current editor
And I close the current editor
# ========================================
@EK-Rechnung
Scenario: Kommando <(Purchasing)> RE <(new)>
Given I set the fake date to "11.01.2002"

Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+37476re"
And I close the current editor

Given opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "rechnung" throws the exception "3335"
And I close the current editor

# ========================================

# ----------------------
@Lieferschein
Scenario: Kommando <(Purchasing)> LIEFERSCHEIN <(new)>
# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
# Lieferscheinart kann nicht geandert werden.
Given I set the fake date to "11.01.2002"

Given I open an editor "LS1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""

Then field "typa" has value "Lieferschein"
Then field "lief" is modifiable

And I set field "lief" to "TEST"
And I set field "vom" to "." 
And I set field "num4" to "37444s" 
And I set field "ueb" to "ja" 
And I set field "erfwaehr" to "EUR"

And I create a new row at the end of the table
And I set field "artikel" to "13vo" in row 1
And I set field "mge" to "2" in row 1
And I set field "preis" to "20" in row 1

And I save the current editor
And I close the current editor
 
# ---------------------
@Kostenbuchung
Scenario: Kommando <(CostEntriesSuggestion) A >
Given I set the fake date to "11.01.2002"

Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""

And I set field "adat" to "01.01.2002" 
And I set field "edat" to "." 
And I press button "kosvor"

And I respond with answer "yes" to the dialog with id "2324"

And I save the current editor

And I close the current editor

#                          VERMUTLICH IST FOLGENDER WEG SINNVOLL:
#               VIELE KLEINE PARALLELTESTS - BASIEREND AUF EINIGEN CUCU FEATUREDATEIEN
#               WEGEN : LAGERBESTAND UND KONTENSALDEN MISCHEN SICH ZU SEHR
#     MAN KOENNTE DEN BESTAND NACH JEDEN TEILSTUECK AUF 0 BRINGEN, MACHT ABER 
#     WOHL SEHR WENIG SPASS....
#                * SALDENABFRAGE UEBER DEN EDITOR MACHEN, MUSS UEBERALL GLEICH SEIN
#                * DIE KONTEXTDATEN ABER IMMER MIT ERZEUGEN WIE EINE REFERENZ
#               * TESTS KOENNEN HEISSEN WIE IHR GESCHAEFTSPROZESS

# # ---------------------
# @Mengenneubewertung
# Scenario: Kommando <(QuantityRevaluation)>
# Given I set the fake date to "10.01.2002"
# 
# Given I open an editor "MN2b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
# And I set field "such" to "MN2SUCHB" 
# 
# Then field "vorgang" is modifiable in row 1
# And I set field "vorgang" to "$,,art=13vo;buart=1;platz=F2;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
# 
# And I set field "ntbewpr" to "42" in row 1
# And I set field "nbewertet" to "direkt" in row 1
# 
# And I save the current editor
# And I close the current editor
# 
# # ---------------------
# @Kostenbuchung
# Scenario: Kommando <(CostEntriesSuggestion) C1 >
# Given I set the fake date to "10.01.2002"
# 
# Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
# 
# And I set field "adat" to "01.01.2002"
# And I set field "edat" to "." 
# And I press button "kosvor"
# 
# # And I set field "buchen" to "nein" in row 2 
# 
# And I respond with answer "yes" to the dialog with id "2324"
# 
# And I save the current editor
# And I close the current editor
# 



@Lieferschein
Scenario: Kommando <(Purchasing)> LIEFERSCHEIN <(new)>
# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
# Lieferscheinart kann nicht geandert werden.
Given I set the fake date to "12.01.2002"

Given I open an editor "LS3" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""

Then field "typa" has value "Lieferschein"
Then field "lief" is modifiable

And I set field "lief" to "TEST"
And I set field "vom" to "." 
And I set field "num4" to "37478ls" 
And I set field "ueb" to "ja" 
And I set field "erfwaehr" to "EUR"

And I create a new row at the end of the table
And I set field "artikel" to "artohneekpreis" in row 1
And I set field "mge" to "2" in row 1
# And I set field "preis" to "0" in row 1

And I save the current editor
And I close the current editor

# ---------------------
@Mengenneubewertung
Scenario: Kommando <(QuantityRevaluation)>
Given I set the fake date to "12.01.2002"

Given I open an editor "MN3" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MN3SUCH" 

Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,art=artohneekpreis;buart=1;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1

And I set field "ntbewpr" to "2" in row 1
And I set field "nbewertet" to "direkt" in row 1

And I save the current editor
And I close the current editor

@Kostenbuchung
Scenario: Kommando <(CostEntriesSuggestion) A >
Given I set the fake date to "12.01.2002"

Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""

And I set field "adat" to "01.01.2002" 
And I set field "edat" to "." 
And I press button "kosvor"

And I respond with answer "yes" to the dialog with id "2324"

And I save the current editor

And I close the current editor


@Mengenneubewertung
Scenario: Kommando <(QuantityRevaluation)>
Given I set the fake date to "13.01.2002"

Given I open an editor "SMN3" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MN3SUCH"
And I set field "such" to "SMN3SUCH" 

And I save the current editor
And I close the current editor


@Kostenbuchung
Scenario: Kommando <(CostEntriesSuggestion) A >
Given I set the fake date to "13.01.2002"

Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""

And I set field "adat" to "01.01.2002" 
And I set field "edat" to "." 
And I press button "kosvor"

And I respond with answer "yes" to the dialog with id "2324"

And I save the current editor

And I close the current editor

# =====================================================================================================

@Lieferschein
Scenario: LV_KBL_RE_MN1_KBL_KM_SMN1_KBL
#  E: 25:_LV1._KBL_RE.2_MN1_KBL_KM1_SMN1_KBL:refbwstorno_cu:(158,10,0,):13:73747ls

# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
# Lieferscheinart kann nicht geandert werden.
Given I set the fake date to "14.01.2002"

Given I open an editor "LS2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""

Then field "typa" has value "Lieferschein"
Then field "lief" is modifiable

And I set field "lief" to "TEST"
And I set field "vom" to "." 
And I set field "num4" to "73747ls" 
And I set field "ueb" to "ja" 
And I set field "erfwaehr" to "EUR"

And I create a new row at the end of the table
And I set field "artikel" to "E1FR-VF" in row 1
And I set field "mge" to "3" in row 1
And I set field "preis" to "15" in row 1

And I save the current editor
And I close the current editor

# ---------------------
# Kostenbuchung
Given I set the fake date to "14.01.2002"

Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "adat" to "01.01.2002" 
And I set field "edat" to "." 
And I press button "kosvor"
And I respond with answer "yes" to the dialog with id "2324"

And I save the current editor
And I close the current editor

# EK-Rechnung
Given I set the fake date to "15.01.2002"

Given I open an editor "RE_zu_LS2" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "73747ls"
And I set field "num4" to "73747re"
And I set field "vom" to "." 
And I set field "ueb" to "ja" 
And I respond with answer "yes" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# ---------------------
@Mengenneubewertung
Scenario: Kommando <(QuantityRevaluation)>
Given I set the fake date to "16.01.2002"

Given I open an editor "MN4" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MN4SUCH" 

Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,art=E1FR-VF;buart=1;platz=F2;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "22" in row 1
# nbewertet

And I save the current editor
And I close the current editor

# ---------------------
# Kostenbuchung
Given I set the fake date to "16.01.2002"

Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "adat" to "01.01.2002"
And I set field "edat" to "." 
And I press button "kosvor"
# And I set field "buchen" to "nein" in row 2 
And I respond with answer "yes" to the dialog with id "2324"
And I save the current editor
And I close the current editor

# ++++++ kontrolle +++++++
Given I open the infosystem "LAGERWERTAKTUELL"
And I set field "artikel" to "E1FR-VF" 
And I set field "kbestand" to "10019" 
And I press button "bstart"
Then field "summe" has value "66.00"
And I close the current editor

Given I open an editor "Konto10019" from table "(Account):(Account)" with command "VIEW" for record "10019"
Then field "saldo" has value "66.00"
And I close the current editor

# zwischenkonto muss nach vollstaendiger/letzter rechnung und ausbuchung 0 sein
Given I open an editor "Konto10900" from table "(Account):(Account)" with command "VIEW" for record "10900"
Then field "saldo" has value "0.00"
And I close the current editor


# Guv-Rechnung zum umlegen erzeugen (kostenumlage)
Given I open an editor "rechnung-980-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "980-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "erfwaehr" to "EUR"
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "600" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Kostenumlage erzeugen
Given I open an editor "kostenuml-980" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "980-KM" 
And I set field "pos" to "$,,kopf^nummer=980-RE1;art=TEXT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=73747re;artex=E1FR-VF;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 1
And I save the current editor

# ++++++ kontrolle +++++++
Given I open the infosystem "LAGERWERTAKTUELL"
And I set field "artikel" to "E1FR-VF" 
And I set field "kbestand" to "10019" 
And I press button "bstart"
Then field "summe" has value "666.00"
And I close the current editor

Given I open an editor "Konto10019" from table "(Account):(Account)" with command "VIEW" for record "10019"
Then field "saldo" has value "666.00"
And I close the current editor

# MN storno
Given I open an editor "SMN4" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MN4SUCH"
And I set field "such" to "SMN4SUCH" 
And I save the current editor
And I close the current editor

# Kostenbuchung
Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "adat" to "01.01.2002"
And I set field "edat" to "." 
And I press button "kosvor"
And I respond with answer "yes" to the dialog with id "2324"
And I save the current editor
And I close the current editor

# ++++++ kontrolle +++++++
Given I open the infosystem "LAGERWERTAKTUELL"
And I set field "artikel" to "E1FR-VF" 
And I set field "kbestand" to "10019" 
And I press button "bstart"
Then field "summe" has value "645.00"
And I close the current editor

Given I open an editor "Konto10019" from table "(Account):(Account)" with command "VIEW" for record "10019"
Then field "saldo" has value "645.00"
And I close the current editor

# zwischenkonto muss am ende 0 sein
Given I open an editor "Konto10900" from table "(Account):(Account)" with command "VIEW" for record "10900"
Then field "saldo" has value "0.00"
And I close the current editor

# =====================================================================================================

@Lieferschein
Scenario: LV_KBL_TRE_TMN1_KBL_KM_SMN1_KBL
#  E: 25:_LV1._KBL_TRE.2_MN1_KBL_KM1_SMN1_KBL_TRE.3_KBL_SMNX:refbwstorno_cu:(160,10,0,):19:82365ls
# hier Mischpreis, deshalb abweichungen zw. IS Lagerwert und Kontensaldo
# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
# Lieferscheinart kann nicht geandert werden.
Given I set the fake date to "16.01.2002"

Given I open an editor "LS3" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""

Then field "typa" has value "Lieferschein"
Then field "lief" is modifiable

And I set field "lief" to "TEST"
And I set field "vom" to "." 
And I set field "num4" to "82365ls" 
And I set field "ueb" to "ja" 
And I set field "erfwaehr" to "EUR"

And I create a new row at the end of the table
And I set field "artikel" to "E1EI-VM" in row 1
And I set field "mge" to "3" in row 1
And I set field "preis" to "15" in row 1

And I save the current editor
And I close the current editor

# ---------------------
# Kostenbuchung
Given I set the fake date to "16.01.2002"

Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "adat" to "01.01.2002" 
And I set field "edat" to "." 
And I press button "kosvor"
And I respond with answer "yes" to the dialog with id "2324"

And I save the current editor
And I close the current editor

# EK-Rechnung
Given I set the fake date to "17.01.2002"

Given I open an editor "RE_zu_LS3" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "82365ls"
And I set field "num4" to "82365re"
And I set field "vom" to "." 
And I set field "ueb" to "ja" 
And I set field "mge" to "1" in row 1
And I respond with answer "yes" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# ---------------------
# Mengenneubewertung
Given I open an editor "MN5" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MN5SUCH" 

Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,art=E1EI-VM;buart=1;platz=F1;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
Then field "tmge" has value "1" in row 1
Then field "tmge" has value "2" in row 2
And I set field "ntbewpr" to "22" in row 2
# nbewertet

And I save the current editor
And I close the current editor

# ---------------------
# Kostenbuchung
Given I set the fake date to "18.01.2002"

Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "adat" to "01.01.2002"
And I set field "edat" to "." 
And I press button "kosvor"
# And I set field "buchen" to "nein" in row 2 
And I respond with answer "yes" to the dialog with id "2324"
And I save the current editor
And I close the current editor

# ++++++ kontrolle +++++++
Given I open the infosystem "LAGERWERTAKTUELL"
And I set field "artikel" to "E1EI-VM" 
And I set field "kbestand" to "10021" 
And I press button "bstart"
#abweichung#saldo (siehe unten)=59.00
Then field "summe" has value "15.00"
And I close the current editor

Given I open an editor "Konto10021" from table "(Account):(Account)" with command "VIEW" for record "10021"
Then field "saldo" has value "59.00"
And I close the current editor

# Guv-Rechnung zum umlegen erzeugen (kostenumlage)
Given I open an editor "rechnung-981-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "981-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "erfwaehr" to "EUR"
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "600" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Kostenumlage erzeugen
Given I open an editor "kostenuml-981" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "981-KM" 
And I set field "pos" to "$,,kopf^nummer=981-RE1;art=TEXT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=82365re;artex=E1EI-VM;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 1
And I save the current editor

# ++++++ kontrolle +++++++
Given I open the infosystem "LAGERWERTAKTUELL"
And I set field "artikel" to "E1EI-VM" 
And I set field "kbestand" to "10021" 
And I press button "bstart"
#abweichung#saldo (siehe unten)=659.00
Then field "summe" has value "15.00"
And I close the current editor

Given I open an editor "Konto10021" from table "(Account):(Account)" with command "VIEW" for record "10021"
Then field "saldo" has value "659.00"
And I close the current editor

# MN storno
Given I open an editor "SMN5" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MN5SUCH"
And I set field "such" to "SMN5SUCH" 
And I save the current editor
And I close the current editor

# Kostenbuchung
Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "adat" to "01.01.2002"
And I set field "edat" to "." 
And I press button "kosvor"
And I respond with answer "yes" to the dialog with id "2324"
And I save the current editor
And I close the current editor

# ++++++ kontrolle +++++++
Given I open the infosystem "LAGERWERTAKTUELL"
And I set field "artikel" to "E1EI-VM" 
And I set field "kbestand" to "10021" 
And I press button "bstart"
#abweichung#saldo (siehe unten)=645.00
Then field "summe" has value "15.00"
And I close the current editor

Given I open an editor "Konto10021" from table "(Account):(Account)" with command "VIEW" for record "10021"
Then field "saldo" has value "645.00"
And I close the current editor

# EK-restrechnung
Given I set the fake date to "19.01.2002"

Given I open an editor "RE_zu_LS3" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "82365ls"
And I set field "num4" to "82366re"
And I set field "vom" to "." 
And I set field "ueb" to "ja" 
And I respond with answer "yes" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Kostenbuchung
Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "adat" to "01.01.2002"
And I set field "edat" to "." 
And I press button "kosvor"
And I respond with answer "yes" to the dialog with id "2324"
And I save the current editor
And I close the current editor

# ++++++ kontrolle +++++++
Given I open the infosystem "LAGERWERTAKTUELL"
And I set field "artikel" to "E1EI-VM" 
And I set field "kbestand" to "10021" 
And I press button "bstart"
#abweichung#saldo (siehe unten)=645.00
Then field "summe" has value "35.00"
And I close the current editor

Given I open an editor "Konto10021" from table "(Account):(Account)" with command "VIEW" for record "10021"
Then field "saldo" has value "645.00"
And I close the current editor

# zwischenkonto muss nach letzter rechnung 0 und ausbuchung sein
Given I open an editor "Konto10030" from table "(Account):(Account)" with command "VIEW" for record "10030"
Then field "saldo" has value "0.00"
And I close the current editor
# =====================================================================================================

@Lieferschein
Scenario: LV_KBL_TRE_TMN1_KBL_KM_SMN1_KBL
#  E: 25:_LV1._KBL_TRE.2_MN1_KBL_KM1_SMN1_KBL_TRE.3_KBL_SMNX:refbwstorno_cu:(160,10,0,):19:28743ls

# hier Preis des Zugangs, deshalb muss Kontensaldo und IS-Lagerwert die gleichen Werte ausgeben.  
# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
# Lieferscheinart kann nicht geandert werden.
Given I set the fake date to "16.01.2002"

Given I open an editor "Konto10020" from table "(Account):(Account)" with command "VIEW" for record "10020"
Then field "saldo" has value "124.00"
And I close the current editor

Given I open an editor "LS3" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""

Then field "typa" has value "Lieferschein"
Then field "lief" is modifiable

And I set field "lief" to "TEST"
And I set field "vom" to "." 
And I set field "num4" to "28743ls" 
And I set field "ueb" to "ja" 
And I set field "erfwaehr" to "EUR"

And I create a new row at the end of the table
And I set field "artikel" to "E1EI-VO" in row 1
And I set field "mge" to "3" in row 1
And I set field "preis" to "15" in row 1

And I save the current editor
And I close the current editor

# ---------------------
# Kostenbuchung
Given I set the fake date to "16.01.2002"

Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "adat" to "01.01.2002" 
And I set field "edat" to "." 
And I press button "kosvor"
And I respond with answer "yes" to the dialog with id "2324"

And I save the current editor
And I close the current editor

Given I open an editor "Konto10020" from table "(Account):(Account)" with command "VIEW" for record "10020"
Then field "saldo" has value "169.00"
And I close the current editor

# EK-Rechnung
Given I set the fake date to "17.01.2002"

Given I open an editor "RE_zu_LSa3" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "28743ls"
And I set field "num4" to "28743re"
And I set field "vom" to "." 
And I set field "ueb" to "ja" 
And I set field "mge" to "1" in row 1
And I respond with answer "yes" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# ---------------------
# Mengenneubewertung
Given I open an editor "MN6" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MN6SUCH" 

Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,art=E1EI-VO;buart=1;platz=F2;vorgang^kopf^nummer==28743ls;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
Then field "tmge" has value "1" in row 1
Then field "tmge" has value "2" in row 2
And I set field "ntbewpr" to "22" in row 2
# nbewertet

And I save the current editor
And I close the current editor

# ---------------------
# Kostenbuchung
Given I set the fake date to "18.01.2002"

Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "adat" to "01.01.2002"
And I set field "edat" to "." 
And I press button "kosvor"
# And I set field "buchen" to "nein" in row 2 
And I respond with answer "yes" to the dialog with id "2324"
And I save the current editor
And I close the current editor

# ++++++ kontrolle +++++++
Given I open the infosystem "LAGERWERTAKTUELL"
And I set field "artikel" to "E1EI-VO" 
And I set field "kbestand" to "10020" 
And I press button "bstart"
#abweichung#saldo (siehe unten)=59.00
# Then field "summe" has value "45.00"
And I close the current editor

Given I open an editor "Konto10020" from table "(Account):(Account)" with command "VIEW" for record "10020"
# Then field "saldo" has value "59.00"
And I close the current editor

# Guv-Rechnung zum umlegen erzeugen (kostenumlage)
Given I open an editor "rechnung-981-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "741-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "erfwaehr" to "EUR"
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "600" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Kostenumlage erzeugen
Given I open an editor "kostenuml-981" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "741-KM" 
And I set field "pos" to "$,,kopf^nummer=741-RE1;art=TEXT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=28743re;artex=E1EI-VO;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 1
And I save the current editor

# ++++++ kontrolle +++++++
Given I open the infosystem "LAGERWERTAKTUELL"
And I set field "artikel" to "E1EI-VO" 
And I set field "kbestand" to "10020" 
And I press button "bstart"
#abweichung#saldo (siehe unten)=659.00
# Then field "summe" has value "45.00"
And I close the current editor

Given I open an editor "Konto10020" from table "(Account):(Account)" with command "VIEW" for record "10020"
# Then field "saldo" has value "659.00"
And I close the current editor

# MN storno
Given I open an editor "SMN6" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MN6SUCH"
And I set field "such" to "SMN6SUCH" 
And I save the current editor
And I close the current editor

# Kostenbuchung
Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "adat" to "01.01.2002"
And I set field "edat" to "." 
And I press button "kosvor"
And I respond with answer "yes" to the dialog with id "2324"
And I save the current editor
And I close the current editor

# ++++++ kontrolle +++++++
Given I open the infosystem "LAGERWERTAKTUELL"
And I set field "artikel" to "E1EI-VO" 
And I set field "kbestand" to "10020" 
And I press button "bstart"
#abweichung#saldo (siehe unten)=645.00
# Then field "summe" has value "45.00"
And I close the current editor

Given I open an editor "Konto10020" from table "(Account):(Account)" with command "VIEW" for record "10020"
# Then field "saldo" has value "645.00"
And I close the current editor

# EK-restrechnung
Given I set the fake date to "19.01.2002"

Given I open an editor "RE_zu_LS3" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "28743ls"
And I set field "num4" to "82366re"
And I set field "vom" to "." 
And I set field "ueb" to "ja" 
And I respond with answer "yes" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Kostenbuchung
Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "adat" to "01.01.2002"
And I set field "edat" to "." 
And I press button "kosvor"
And I respond with answer "yes" to the dialog with id "2324"
And I save the current editor
And I close the current editor

# ++++++ kontrolle +++++++
Given I open the infosystem "LAGERWERTAKTUELL"
And I set field "artikel" to "E1EI-VO" 
And I set field "kbestand" to "10020" 
And I press button "bstart"
# 124.00 + 645.00 = 769.00
Then field "summe" has value "769.00"
And I close the current editor

Given I open an editor "Konto10020" from table "(Account):(Account)" with command "VIEW" for record "10020"
# 124.00 + 645.00 = 769.00
Then field "saldo" has value "769.00"
And I close the current editor

# zwischenkonto muss nach letzter rechnung 0 und ausbuchung sein
Given I open an editor "Konto10030" from table "(Account):(Account)" with command "VIEW" for record "10030"
Then field "saldo" has value "0.00"
And I close the current editor
