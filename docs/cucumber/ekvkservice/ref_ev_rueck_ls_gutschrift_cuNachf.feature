#  Verantwortlich : uo
#  Funktion       : Teilruecklieferungen mit kaufmaennischer Gutschrift und Abschlussrechnung
# *****************************************************************************
@persistent
Feature: Gutschrift
Background: Test von Rechnung der Art "kaufmännischen Gutschrift" bzw. "Gutschrift" im Verkauf
Given I set the fake date to "04.01.1995"

Scenario: rechnungen und gutschriften aus dem vorgaenger wegbuchen
Given I open an editor "gutbuch1" from table "(Purchasing):(Invoice)" with command "TRANSFER" for record "011"
And I save the current editor

Given I open an editor "gutbuch1" from table "(Purchasing):(Invoice)" with command "TRANSFER" for record "013"
And I save the current editor

# EKLS1 buchen, Es gibt bereits eine Rechnung (Vorgaengertest)
Given I open an editor "re1" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "EKLS1"
And I set fields
  | nummer | 1re |
  | ueb    | ja |
  | tterm  | .  |
  | vom    | .  |
  | budat  | .  |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


Scenario: STAMMDATEN - Lieferantenwährung 
Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record "REUS"
And I set field "waehr" to "DEM"
And I save the current editor

Given I open an editor "ed_art1" from table "(Part):(Product)" with command "UPDATE" for record "ARTIKEL1"
And I set field "ewaehr" to "DEM"
And I save the current editor

Given I open an editor "ed_art2" from table "(Part):(Product)" with command "UPDATE" for record "ARTIKEL2"
And I set field "ewaehr" to "DEM"
And I save the current editor

#----------------------------------------------------------------------------------------------
# aus rueck_ls_gutschrift.feature hier jedoch Teilmengen-Rücklieferungen
# TSQ-GUTSCHRIFT-04: Einkauf BE -> LS - TeilRueck-LS - RE mit der Art "Kaufmaennische Gutschrift"
#----------------------------------------------------------------------------------------------

Scenario: 04 Bestellung mit 2 normalen Positionen
Given I open an editor "bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "REUS"
And I set field "nummer" to "901"
And I set field "erfwaehr" to "DEM"
And I create a new row at the end of the table
And I set field "artikel" to "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "artikel2" in row 2
And I set field "mge" to "10" in row 2
# And I set field "artikel" to "artikel3" in row 3
# And I set field "mge" to "10" in row 3
And I save the current editor

Scenario: 04 Lieferschein zu obiger Bestellung anlegen, buchen, rueckliefern und Gutschrift erstellen
Given I open an editor "ek91lieferschein" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung"
And I set field "nummer" to "902"
And I set field "such" to "ek91ls"
And I set field "ueb" to "ja"
And I set field "ebeleg" to "EKLieferschein"
And I set field "vom" to "."
Then setting field "mge" to "-1" in row 2 throws the exception "1361"
And I set field "mge" to "5" in row 1
And I set field "mge" to "5" in row 2
# And I set field "mge" to "5" in row 3
And I save the current editor

#1. Position des Lieferscheins rückliefern
Given I open an editor "ekrueck91" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ek91lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "903"
And I set field "ueb" to "ja"
And I set field "ebeleg" to "EKRlschein"
And I set field "vom" to "."
And I set field "mge" to "-4" in row 1
Then field "rerelev" has value "ja" in row 1
And I save the current editor

#2. Position des Lieferscheins rückliefern
Given I open an editor "ekrueck92" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ek91lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "904"
And I set field "ueb" to "ja"
And I set field "ebeleg" to "EKRlschein"
And I set field "vom" to "."
And I set field "mge" to "-1" in row 2
Then field "rerelev" has value "ja" in row 1
And I save the current editor

# Rechnung zu LS erzeugen, sonst ist keine Kaufm. GS moeglich
Given I open an editor "re_zu_902" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "902"
And I set fields
  | nummer | 902re |
  | ueb    | ja |
  | tterm  | .  |
  | vom    | .  |
  | budat  | .  |
# versuch am preis zu fummeln:
And I set field "preis" to "700" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: 04 Kenner Gutschrift in einer Position setzen, in der anderen nicht, Ruecklieferschein geht in die Ablage
Given I open an editor "ekrechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung"
And I set field "nummer" to "906"
And I set field "erfwaehr" to "DEM"
And I set field "ueb" to "ja"
And I set field "ebeleg" to "EKRechnung"
And I set field "vom" to "."
And I set field "mge" to "5" in row 1
And I set field "mge" to "5" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


#Rechnung rueckliefern
Given I open an editor "ekrueck3" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "ekrechnung"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "907"
And I set field "ueb" to "ja"
And I set field "ebeleg" to "EKRlschein"
And I set field "vom" to "."
Then the table has 2 rows
And I set field "mge" to "-2" in row 1
Then field "rerelev" has value "ja" in row 1
And I set field "rerelev" to "nein" in row 1
And I set field "mge" to "-3" in row 2
Then field "rerelev" has value "ja" in row 2
And I save the current editor

#Kaufm. Gutschrift erstellen, nur eine Position wird uebernommen
Given I open an editor "ekgut2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "REUS"
And I set field "beleg" to id from editor "ekrueck3"
And I set field "nummer" to "908"
And I set field "ueb" to "ja"
Then field "erfwaehr" is modifiable
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I set field "ebeleg" to "EKGutschrift"
And I set field "vom" to "."
Then the table has 1 rows
# Todo mibr: mittlerweile lassen sich RLS und LS in Rechnungen mischen - klaeren, ob das so bleibt
# And setting field "beleg" in row 0 to "id" from editor "ek91lieferschein" in row 0 throws the exception "1361"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "re3" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "+907"
And I set fields
  | nummer | 3re |
  | such | RZUL907 |
  | ueb    | ja |
  | tterm  | .  |
  | vom    | .  |
  | budat  | .  |
# And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
