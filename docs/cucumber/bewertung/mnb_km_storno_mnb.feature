# *****************************************************************************
#  Name           : mnb_km_storno_mnb.feature
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Darstellung von Geschäftsprozessen mit Mengenneubewertung, Kostenumlage, TWGS, RL, kfm. GS, Storno MNB
#
#
# *****************************************************************************
@persistent
Feature: ref_mnb_km_storno_mnb_cu
Background:
Given I set the fake date to "03.02.1995"

# -----------------------------------------------------------------------------------------------------------
Scenario: 01a Stammdaten (Lagerplätze angleichen, Artikel anlegen)
#-----------------------------------------------------------------------------------------------------------
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "10100"
And I set field "such" to "K10100"
And I set field "namebspr" to "Rohstoffe"
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "10200"
And I set field "such" to "K10200"
And I set field "namebspr" to "Rohstoffe"
And I save the current editor

Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "e1"
And I set field "abplatz" to "f1"
And I save the current editor
And I close the current editor

Given I open an editor "teil" from table "(Part):(Product)" with command "COPY" for record "e1"
And I set field "such" to "e100"
And I save the current editor
And I close the current editor

Given I open an editor "teil" from table "(Part):(Product)" with command "COPY" for record "e1"
And I set field "such" to "e200"
And I save the current editor
And I close the current editor

# Zusatzposition Transport
Given I open an editor "zusatzp_transport" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set field "nummer" to "1transp"
And I set field "such" to "transport"
And I set field "name" to "transportkosten"
And I save the current editor

# -----------------------------------------------------------------------------------------------------------
Scenario: 02 BE(m10;p10)-LS(m10;p10)-RE(m10;p11)-MNB(m10;p+2)-KM(m10;p+3)-TWGS1(m-8;p9) -Verbuchung scheitert wegen MNB-
             Storno MNB(m10;p+2) -TWGS1 buchen - RLS(m-9)- KGS(m-1;p8,80)
# -----------------------------------------------------------------------------------------------------------
# EK-Rechnung Transportkosten
# Rechnung für additive Kosten anlegen
Given I open an editor "re-addkosten-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "100-add"
And I set field "lief" to "1"
And I set field "erfwaehr" to "dem"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I append rows
 |artex     | pwert| konto | kstelle | ptext          |
 |transport |   30 | 50197 |     101 | kost_qu_ek_100 |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Bestellung
Given I open an editor "bestellung1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief     | 1      |
    | num4     | 100BE  |
    | such4    | BE100  |
    | vom      | .      |
    | ebeleg   | BE1    |
    | erfwaehr | dem    |
    | budat    | .      |
And I append rows
| artikel | mge | preis |konto      | ptext      |
| E100    | 10  | 10,00 | 10100     | BE100      |
And I save the current editor
And I close the current editor

# Lieferschein
Given I set the fake date to "08.02.1995"
Given I open an editor "lieferschein1" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "100BE"
And I set fields
    | lief     | 1       |
    | num4     | 100LS   |
    | such4    | LS100   |
    | vom      | .       |
    | ueb      | ja      |
    | ebeleg   | LS      |
    | erfwaehr | dem     |
And I press button "offueb" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.02." until enddate "28.02." with Command Revalue

# EK-Rechnung
Given I set the fake date to "10.02.1995"
Given I open an editor "rechnung1" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "lieferschein1"
And I set fields
    | lief     | 1       |
    | num4     | 100RE   |
    | such4    | RE100   |
    | vom      | .       |
    | ueb      | ja      |
    | ebeleg   | RE1     |
    | budat    | .       |
    | erfwaehr | dem     |
And I press button "offueb" in row 1
And I set field "preis" to "11" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# # Mengenneubewertung
Given I set the fake date to "12.02.1995"
Given I open an editor "mnb-1" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-1"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L100LS;art=E100;buart=1;mge=10;@datei=10;@gruppe=1;@ablageart=(Both)" in row 1
And I set field "ntbewpr" to "13" in row 1
# And I set field "nbewertet" to "vorlaeufig" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.02." until enddate "28.02." with Command Revalue

# KM Transportkosten auf Teil-RE2
Given I set the fake date to "14.02.1995"
Given I open an editor "REpos-km-d" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "100km"
And I set field "such" to "km100"
And I set field "pos" to "$,,ptext==kost_qu_ek_100;art==transport;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer==100LS;ptext==BE100;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.02." until enddate "28.02." with Command Revalue

# Teilwertgutschrift 100WGS1 anlegen - wegen MNB nicht verbuchbar!
Given I set the fake date to "18.02.1995"
Given I open an editor "100-wgs1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+100RE"
And I set fields
   | nummer | 100WGS1 |
   | such   | WGS1100 |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    |  ja     |
And I set field "mge" to "-8" in row 1
And I set field "preis" to "9" in row 1
Then the table has 4 rows
# eigentlich kommt hier "4143"
Then saving the current editor throws the exception "3335"
# Speichern ohne zu verbuchen
And I set field "ueb" to "nein"
And I save the current editor
And I close the current editor

# Storno Mengenneubewertung
Given I set the fake date to "19.02.1995"
Given I open an editor "sto-mnb-1mgebewneu-100" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-1"
And I set field "nummer" to "1MNBST"
And I set field "such" to "STOMNB1"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.02." until enddate "28.02." with Command Revalue

# Teilwertgutschrift 100WGS1 verbuchen
Given I set the fake date to "20.02.1995"
Given I open an editor "100-wgs1-update" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "100WGS1"
And I set field "ueb" to "ja"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.02." until enddate "28.02." with Command Revalue

# # Teilruecklieferschein anlegen
Given I set the fake date to "22.02.1995"
Given I open an editor "rls-100" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein1"
And I set field "num4" to "100RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-9" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.02." until enddate "28.02." with Command Revalue

# kfm. Gutschrift
Given I set the fake date to "25.02.1995"
Given I open an editor "kgs-100" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rls-100"
And I set field "num4" to "100-KGS1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 1 rows
Then table has values
  | art       | mge  | preis         | remge |
  | E100      | -9   |   3.80        | -9    |
 And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.02." until enddate "28.02." with Command Revalue

