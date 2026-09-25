# *****************************************************************************
#  Name           : ausschreibung.feature
#  Autor          : mibr
#  Verantwortlich : teampss
#  Funktion       : Test von Ausschreibungen (nur im EK), bzw. Anfragen/Auschreibungen aus BVs
#
# *****************************************************************************
#
@persistent
Feature: Ausschreibung EK
Background: Test von Ausschreibungen im Einkauf
Given I set the fake date to "02.01.1995"
Given I enable the flag 39

###############################################################################
# E I N K A U F
###############################################################################

Scenario Outline: Zusatzposition vom Typ AU/BE und neutrale Position anlegen
Given I open an editor "<zusatzpos>" from table "(Part):(SupplementaryItem)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "zptyp" to "<zptyp>"
And I set field "vkbez" to "<vkbez>"
And I set field "vbez" to "<vbez>"
And I set field "ebez" to "<ebez>"
And I set field "vpr" to "<vpr>"
And I set field "epr" to "<epr>"
And I save the current editor

Examples:
| zusatzpos       | such    | namebspr             | zptyp             | vkbez                   | vbez                 | ebez                  | vpr   | epr  |
| zusatzAUBE      | AUBE    | Zusatzposition AU/BE | AU/BE-Position,BV | Zusatzposition AU/BE    | Zusatzposition AU/BE | Zusatzposition AU/BE  | 1100  | 1000 |
| neutralePOS     | NEUPOS  | Neutrale Position    | Neutrale Position | Neutrale Position       | Neutrale Position    | Neutrale Position     | 500   | 400  |

#----------------------------------------------------------------------------------------------
Scenario: Anfrage freigeben soll den verbundenen BV verwenden
#----------------------------------------------------------------------------------------------
# Datumsformat M-D-Y setzen (Test fuer Wiedervorlagedatum beim Anlegen -> XML)
# Einen BV anlegen
# Ausschreibung anlegen mit zwei Lieferanten
# Den Zweiten auswaehlen und den BV zuordnen - wird fixiert
# ! dann die Anfrage bestellen (nicht aus der Ausschreibung heraus!)
# Datumsformat in Konfig wieder zuruecksetzen auf D.M.Y
#
# Soll Zustand:
# Bestellung hat BV angefuegt (Verwendung aus BV).
# Anfragepos ist Vorgaenger von Bestellpos
# BV ist nicht mehr da
# Anfragen und Ausschreibungen sind in der Ablage

 # Datumsformat in Konfig auf Wert mit anderem Trenner setzen M-D-Y
 Given I open an editor "Firma" from table "(Company):(Configuration)" with command "UPDATE" for record "KONFIG"
 And I set field "bdatformd" to "M-D-Y"
 And I save the current editor

Given I open an editor "E1B" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set fields
   | such | E1B |
And I save the current editor

# BV anlegen
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
And I append rows
  | artikel  | mge    | verw    | pwert |
  | !E1B^id  | 200    | AUS01BV | 2000  |
And I save the current editor

# Ausschreibung mit zwei Lieferanten
Given I open an editor "AUS01" from table "(BiddingProcess):(BiddingProcess)" with command "NEW" for record ""
And I set fields
   |bsart |Fremdbeschaffung |
   | such | AUS01           |
And I append rows
  | tlief  | artikel | mge  | verw   | anfrposgrp |
  | 1      | E1      | 50   | AUS01  | 2          |
  | 1      | E2      | 60   | AUS01  | 3          |
  | 1      | !E1B^id | 200  | AUS01  | 1          |
  | 001    | E1      | 50   | AUS01  | 2          |
  | 001    | E2      | 60   | AUS01  | 3          |
  | 001    | !E1B^id | 200  | FALSCH | 1          |
And I save the current editor

# BV der Anfrageposition des zweiten Lieferanten zuordnen
Given I open an editor "AUS01ZO" from table "(BiddingProcess):(BiddingProcess)" with command "UPDATE" for record from editor "AUS01"
Then field "tterm" has value "01-12-95"
And I set field "betreff" to "!AUS01^id"
And I press button "aufzualle"
And I set field "bvzuord" to "ja" in row !lastRow
And I save the current editor

# Anfrage 01 oeffnen
Given I open PurchasingRequest "ANF01" from BiddingProcess "AUS01" with Vendor "001" and command "UPDATE"
# Given I open an editor "ANF01" from table "(Purchasing):(Request)" with command "UPDATE" for search criteria "$,,id==;ausschr==!AUS01^id;kl==001;@gruppe=1;@ablageart=beides;@richtung=rückwärts;@maxtreffer=1"
Then field "ausschr" in row 0 has value equal to field "nummer" from editor "AUS01" in row 0
Then field "verw" has value "FALSCH" in row !lastRow
And I set fields
   |kenn |Markiert |
   |such |ANF01    |
And I save the current editor

# Anfrage ANF01B oeffnen
Given I open PurchasingRequest "ANF01B" from BiddingProcess "AUS01" with Vendor "1" and command "UPDATE"
# Given I open an editor "ANF01B" from table "(Purchasing):(Request)" with command "UPDATE" for search criteria "$,,id==;ausschr==!AUS01^id;kl==1;@gruppe=1;@ablageart=beides;@richtung=rückwärts;@maxtreffer=1"
And I set fields
   |such |ANF01B |
And I save the current editor

 # Datumsformat in Konfig auf Wert mit anderem Trenner setzen M-D-Y
 Given I open an editor "Firma" from table "(Company):(Configuration)" with command "UPDATE" for record "KONFIG"
 And I set field "bdatformd" to "D.M.Y"
 And I save the current editor

# Ausschreibung oeffnen -> Datum ist wieder im alten Format
Given I open an editor "AUS01Z2" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record from editor "AUS01"
Then field "tterm" has value "12.01.95"
And I close the current editor

# Anfrage 01 bestellen -> Wert muss aus BV uebernommen werden
Given I open an editor "ANF01BES" from table "(Purchasing):(Request)" with command "RELEASE" for record from editor "ANF01"
Then table has values
    | art  | mge | preis | pwert | verw    | orig^kopf^such |
    | E1   |  50 | 0.00  | 0.00  | AUS01   | ANF01          |
    | E2   |  60 | 0.00  | 0.00  | AUS01   | ANF01          |
    | E1B  | 200 | 0.00  | 0.00  | AUS01BV | ANF01          |
# Anm.: Verwendung der 3. Zeile kommt aus dem BV
Then the table has 3 rows
And I save the current editor

# Pruefen: Der BV darf nicht mehr da sein
# ToDo Der Step "opening an editor ... for  search criteria ... throws exception ..." fehlt noch
# Then opening an editor "BV01V" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for search criteria "$,,grbez=;nummer=;artex=E1B!E1B;sucherw~/;@gruppe=1.4.5;@ablageart=(Active)" throws the exception "203"
Given I open an editor "BV01V" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to id from editor "E1B"
And I press button "ladetab"
Then the table has 0 rows
And I close the current editor

# Anfragen und Ausschreibung ist abgelegt
Then "(Purchasing):(Request)" with the editor id "ANF01" is filed
Then "(Purchasing):(Request)" with the editor id "ANF01B" is filed
Then "(BiddingProcess):(BiddingProcess)" with the editor id "AUS01" is filed


#----------------------------------------------------------------------------------------------
Scenario: Anfrageposition freigeben soll den verbundenen BV verwenden
#----------------------------------------------------------------------------------------------
# Einen BV anlegen
# Ausschreibung anlegen mit zwei Lieferanten
# Den Zweiten auswaehlen und den BV zuordnen - wird fixiert
# ! dann die Anfrage bestellen (nicht aus der Ausschreibung heraus!)
# Hier: Einzelne Anfrageposition wird per Beleg anfuegen an eine Bestellung
# angefuegt oder direkt freigegeben.
# Soll Zustand:
# Bestellung hat zugeordnete BVs angefuegt (Verwendung aus BV).
# Anfragepos ist Vorgaenger von Bestellpos
# BV ist nicht mehr da
# Anfragen und Ausschreibungen sind in der Ablage

Given I open an editor "E1C" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set fields
   | such | E1C |
And I save the current editor

# BV anlegen
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
And I append rows
  | artikel  | mge    | verw    |
  | !E1C^id  | 200    | AUS02BV |
And I save the current editor

# Ausschreibung mit zwei Lieferanten
Given I open an editor "AUS02" from table "(BiddingProcess):(BiddingProcess)" with command "NEW" for record ""
And I set fields
   |bsart |Fremdbeschaffung |
   | such | AUS02           |
And I append rows
  | tlief  | artikel | mge  | verw           | anfrposgrp |
  | 1      | !E1C^id | 25   | AUS02          | 1          |
  | 001    | !E1C^id | 200  | FALSCHAUS02POS | 1          |
And I save the current editor

# BV der Anfrageposition des zweiten Lieferanten zuordnen
Given I open an editor "AUS02ZO" from table "(BiddingProcess):(BiddingProcess)" with command "UPDATE" for record from editor "AUS02"
And I set field "betreff" to "!AUS02^id"
And I press button "aufzualle"
And I set field "bvzuord" to "ja" in row !lastRow
And I save the current editor

# Anfrage 01 oeffnen
Given I open an editor "ANF02" from table "(Purchasing):(Request)" with command "UPDATE" for search criteria "$,,id==;ausschr==AUS02;kl==001;@gruppe=1;@ablageart=beides;@richtung=rückwärts;@maxtreffer=1"
Then field "ausschr" in row 0 has value equal to field "nummer" from editor "AUS02" in row 0
Then field "verw" has value "FALSCHAUS02POS" in row !lastRow
And I set fields
   |kenn |Markiert |
   |such |ANF02    |
And I save the current editor

# Anfrage ANF02B oeffnen
Given I open an editor "ANF02B" from table "(Purchasing):(Request)" with command "UPDATE" for search criteria "$,,ausschr==AUS02;kl==1;@gruppe=1;@ablageart=beides;@richtung=rückwärts;@maxtreffer=1"
And I set fields
   |such |ANF02B |
And I save the current editor

# Anfrageposition aus ANF02 bestellen/freigeben -> Wert muss aus BV uebernommen werden

Given I open an editor "BE01" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;verw=FALSCHAUS02POS"
And I set field "such" to "BE01"
Then table has values
    | E1C  | 200 | 0.00  | AUS02BV  | ANF02          |
# Anm.: Verwendung der Zeile kommt aus dem BV
Then the table has 1 rows
And I save the current editor

# Pruefen: Der BV darf nicht mehr da sein
# ToDo Der Step "opening an editor ... for  search criteria ... throws exception ..." fehlt noch
# Then opening an editor "BV01V" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for search criteria "$,,grbez=;nummer=;artex=E1C!E1C;sucherw~/;@gruppe=1.4.5;@ablageart=(Active)" throws the exception "203"
Given I open an editor "BV01V" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to id from editor "E1C"
And I press button "ladetab"
# Hier kommt der Fehler
Then the table has 0 rows
And I close the current editor

# Anfragen und Ausschreibung ist abgelegt
Then "(Purchasing):(Request)" with the editor id "ANF02" is filed
Then "(Purchasing):(Request)" with the editor id "ANF02B" is filed
Then "(BiddingProcess):(BiddingProcess)" with the editor id "AUS02" is filed

#----------------------------------------------------------------------------------------------
Scenario: AUBE Positionen in Ausschreibung erlauben
#----------------------------------------------------------------------------------------------
Given I open an editor "AUS03" from table "(BiddingProcess):(BiddingProcess)" with command "NEW" for record ""
And I set field "bsart" to "Fremdbeschaffung"
And I set field "such" to "AUS03"
And I append rows
    | artikel | mge | tlief |anfrposgrp |
    | E1      | 10  | 001   |1          |
    | AUBE    | 10  | 001   |1          |
    | E1      | 10  | 002   |1          |
    | AUBE    | 10  | 002   |1          |
And I save the current editor

Given I open an editor "AN02" from table "(Purchasing):(Request)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "such" to "AN02"
And I set field "ausschr" to id from editor "AUS03"
And I append rows
    | artikel | mge | anfrposgrp |
    | E1      | 10  | 1          |
    | AUBE    | 10  | 1          |
And I save the current editor

# Ausschreibung aendern -> Bestellen
Given I open an editor "AUS03V" from table "(BiddingProcess):(BiddingProcess)" with command "UPDATE" for record from editor "AUS03"
Then the table has 6 rows
And I set field "sel" to "ja" in row 3
And I set field "sel" to "ja" in row 4
And I press button "bestell" to open a subeditor for "Bestellung" in row 3

# Bestellung oeffnet sich
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Ausschreibung ist in der Ablage
Then "(BiddingProcess):(BiddingProcess)" with the editor id "AUS03" is filed

#----------------------------------------------------------------------------------------------
Scenario: AUBE in BVs anfragen ueber Ausschreibung und Zuordnen
#----------------------------------------------------------------------------------------------
# Lieferant AUBE01 anlegen
Given I open an editor "LSAUBE04" from table "(Vendor):(Vendor)" with command "COPY" for record "1"
And I set field "such" to "LSAUBE04"
And I save the current editor

# BV anlegen
Given I open an editor "BV" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I append rows
    | artikel    | mge    | verw    | lief      |
    | AUBE       | 10     | AUSS    | !LSAUBE04 |
And I save the current editor

# Ausschreibung aus BV
Given I open an editor "BV" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "AUBE"
And I set field "kl" to id from editor "LSAUBE04"
And I press button "ladetab"
And I set field "anfragen" to "ja" in row 1
# BV fuer Zusatzposition wird nicht in der Dispo eingeplant
Then field "einplan" has value "nein" in row 1
Then field "bveinplan" has value "ja" in row 1
And I press button "manfragen" to open a subeditor for "AUS04"
# In der Ausschreibung
Then field "bsart" has value "Fremdbeschaffung"
And I set field "such" to "AUS04"
And I set field "tlief" to "1" in row 1
And I set field "lief" to "004"
And I press button "tkopieren" in row 1
And I append rows
    | artikel | mge | tlief |anfrposgrp |
    | AUBE    | 10  | 001   |1          |
Then the table has 3 rows
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# Ausschreibung aendern, BV zuordnen, Bestellen
Given I open an editor "AUS04U" from table "(BiddingProcess):(BiddingProcess)" with command "UPDATE" for record from editor "AUS04"
And I press button "elemaufzu" in row 1
And I set field "bvzuord" to "ja" in row 2
Then field "sel" has value "ja" in row 1
And I press button "bestell" to open a subeditor for "Bestellung" in row 1
# Bestellung oeffnet sich
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Ausschreibung ist in der Ablage
Then "(BiddingProcess):(BiddingProcess)" with the editor id "AUS04U" is filed

# BVs es gibt kein BV mehr
Given I open an editor "BV" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "AUBE"
And I set field "kl" to id from editor "LSAUBE04"
And I press button "ladetab"
Then the table has 0 rows
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: Guenstigster Preis bei unterschiedlichen Preiseinheiten
#----------------------------------------------------------------------------------------------
# Artikel E4PE mit untersch. Preiseinheit anlegen
Given I open an editor "E4PE" from table "(Part):(Product)" with command "COPY" for record "E3"
And I set field "such" to "E4PE"
And I set field "vpe" to "dt"
And I set field "fvple" to "100"
And I set field "epe" to "kg"
And I set field "lief" to "1"
And I set field "epr" to "1,58"
And I set field "epe1" to "kg"
And I set field "lief2" to "002"
And I set field "epr2" to "152,40"
And I set field "epe2" to "dt"
And I save the current editor

# BV anlegen
Given I open an editor "BV" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I append rows
    | artikel    | mge    | verw    | lief |
    | !E4PE      | 10     | AUSS    | 001  |
And I save the current editor

# Leere Ausschreibung anlegen
Given I open an editor "AUS05" from table "(BiddingProcess):(BiddingProcess)" with command "NEW" for record ""
And I set field "bsart" to "Fremdbeschaffung"
And I set field "such" to "AUS05"
# Test mit Kaufmanns-Und
And I set field "betreff" to "Black & Decker"
And I delete all rows
And I save the current editor

# Anfrage 1 anlegen
Given I open an editor "AN05A" from table "(Purchasing):(Request)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "such" to "AN05A"
And I set field "ausschr" to id from editor "AUS05"
And I set field "zbed" to ""
And I append rows
    | artikel | mge  | he    | preis | anfrposgrp |
    | E4PE    | 100  | Stück | 1,58  | 1          |
And I save the current editor

# Anfrage 2 anlegen
Given I open an editor "AN05B" from table "(Purchasing):(Request)" with command "NEW" for record ""
And I set field "lief" to "002"
And I set field "such" to "AN05B"
And I set field "ausschr" to id from editor "AUS05"
And I append rows
    | artikel | mge | he    | preis  | anfrposgrp |
    | E4PE    | 100 | Stück | 152,40 | 1          |
Then field "pehe" has value "0.01" in row 1
Then field "pe" has value "dt" in row 1
And I save the current editor

# Ausschreibung oeffnen, Pos 2 ist die guenstigere
Given I open an editor "AUS05V" from table "(BiddingProcess):(BiddingProcess)" with command "UPDATE" for record from editor "AUS05"
# Durch die unterschiedliche PE ist das zweite Angebot guenstiger!
Then table has values
| artikel | tlief   | mge  | he    | preisokico |
| E4PE    | 001     | 100  | Stück |            |
| E4PE    | 002     | 100  | Stück |  icon:ok   |
# BV zuordnen
And I press button "elemaufzu" in row 2
And I set field "bvzuord" to "ja" in row 3

# Bestellen
And I set field "sel" to "ja" in row 2
And I press button "bestell" to open a subeditor for "Bestellung" in row 2

# Bestellung oeffnet sich
Then table has values
| artikel | mge   | preis  | he    | pwert | pehe | pe |
| E4PE    | 10    | 152.40 | Stück | 15.24 | 0.01 | dt |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Ausschreibung ist in der Ablage
Then "(BiddingProcess):(BiddingProcess)" with the editor id "AUS05V" is filed

#----------------------------------------------------------------------------------------------
Scenario: Kopieraufrufparameter von BV nach Ausschreibung (AP 59189)
#----------------------------------------------------------------------------------------------
# Lieferant L_BV_KP anlegen
Given I open an editor "L_BV_KP" from table "(Vendor):(Vendor)" with command "COPY" for record "1"
And I set field "such" to "L_BV_KP"
And I save the current editor

# Artikel E1_KP anlegen
Given I open an editor "E1_KP" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1_KP"
And I save the current editor

# BV_KP zum Testen von Kopieraufrufparameter anlegen
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
And I append rows
  | artikel  | mge    | lief     | verw         |
  | !E1_KP   | 77     | !L_BV_KP | verw_betreff |
  | !E1_KP   | 88     | !L_BV_KP | verw_betreff |
  | !E1_KP   | 99     | !L_BV_KP | verw_betreff |
And I save the current editor

# Kopieraufrufparameter 59189 editieren und verwenden (BV verw -> Ausschreibung betreff)
Given I open an editor "AP59189" from table "(DataExport):(CallParameter)" with command "UPDATE" for record "59189"
And I create a new row at the end of the table
And I set field "zielaktion" to "Kopffeld setzen" in row 1
And I set field "zielvar" to "betreff" in row 1
And I set field "aufrwtyp" to "Tabellenfeld" in row 1
And I set field "aufrwert" to "verw" in row 1
And I save the current editor

# Ausschreibung aus BV
Given I open an editor "BV1" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to id from editor "E1_KP"
And I set field "kl" to id from editor "L_BV_KP"
And I press button "ladetab"
And I set field "anfragen" to "ja" in row 1
And I set field "anfragen" to "ja" in row 2
And I set field "anfragen" to "ja" in row 3
And I press button "manfragen" to open a subeditor for "AUSKP"
# In der Ausschreibung
Then field "bsart" has value "Fremdbeschaffung"

# Durch Kopierparameter 59189 wird dieser Wert ins Kopffeld betreff uebertragen
Then field "betreff" has value "verw_betreff"
And I set field "such" to "AUSKP"

And I save the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "AUSKP" from table "(BiddingProcess):(BiddingProcess)" with command "UPDATE" for record from editor "AUSKP"
# BV zuordnen
And I press button "elemaufzu" in row 1
And I set field "bvzuord" to "ja" in row 2
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Kopieraufrufparameter von LFV nach Ausschreibung (AP 59193)
#----------------------------------------------------------------------------------------------
# Lieferant L_LFV_KP anlegen
Given I open an editor "L_LFV_KP" from table "(Vendor):(Vendor)" with command "COPY" for record "1"
And I set field "such" to "L_LFV_KP"
And I save the current editor

# Artikel LFANB_KP anlegen
Given I open an editor "LFANB_KP" from table "(Part):(Product)" with command "COPY" for record "LFANB.ART4"
And I set field "such" to "LFANB_KP"
And I save the current editor

# LFV zum Testen von Kopieraufrufparameter anlegen
Given I open an editor "LFV01" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
And I append rows
  | artikel   | mge    | lief      | lffert | verw         |
  | !LFANB_KP | 77     | !L_LFV_KP | V1     | verw_betreff |
  | !LFANB_KP | 88     | !L_LFV_KP | V1     | verw_betreff |
  | !LFANB_KP | 99     | !L_LFV_KP | V1     | verw_betreff |
And I save the current editor

# Kopieraufrufparameter 59193 editieren und verwenden (LFV verw -> Ausschreibung betreff)
Given I open an editor "AP59193" from table "(DataExport):(CallParameter)" with command "UPDATE" for record "59193"
And I create a new row at the end of the table
And I set field "zielaktion" to "Kopffeld setzen" in row 1
And I set field "zielvar" to "betreff" in row 1
And I set field "aufrwtyp" to "Tabellenfeld" in row 1
And I set field "aufrwert" to "verw" in row 1
And I save the current editor

# Ausschreibung aus LFV
Given I open an editor "LV1" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to id from editor "LFANB_KP"
And I set field "kl" to id from editor "L_LFV_KP"
And I press button "ladetab"
And I set field "anfragen" to "ja" in row 1
And I set field "anfragen" to "ja" in row 2
And I set field "anfragen" to "ja" in row 3
And I press button "manfragen" to open a subeditor for "AUSKP"
# In der Ausschreibung
Then field "bsart" has value "Lohnfertigung"

# Durch Kopierparameter 59193 wird dieser Wert ins Kopffeld betreff uebertragen
Then field "betreff" has value "verw_betreff"

And I set field "such" to "AUSKP"

And I save the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "AUSKP" from table "(BiddingProcess):(BiddingProcess)" with command "UPDATE" for record from editor "AUSKP"
# LFV zuordnen
And I press button "elemaufzu" in row 1
And I set field "bvzuord" to "ja" in row 2
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Ausschreibungen mit Basisartikel: Schreibschutz pruefen
#----------------------------------------------------------------------------------------------
# VK/EK - Aktivieren der Konfiguration Versionsnummerverwaltung im Verkauf/Einkauf
Given I open an editor "konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "verskontr" to "1"
And I set field "verskontreink" to "1"
And I save the current editor

Given I open an editor "AUS03" from table "(BiddingProcess):(BiddingProcess)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to "AUBE" in row 1
Then field "tbasisartikel" is not modifiable in row 1
And I set field "artikel" to "TEXT" in row 1
Then field "tbasisartikel" is not modifiable in row 1
# Dienstleistungen sind nicht erlaubt
Then setting field "artikel" to "REPARIEREN" in row 1 throws the exception "1361"
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: LF Ausschreibung - Wechsel auf nicht LF Artikel loescht lffert
#----------------------------------------------------------------------------------------------

Given I open an editor "V1-METALL1" from table "(Part):(Product)" with command "COPY" for record "V1"
And I set fields
  | such  | V1-METALL1     |
  | le    | Stück          |
  | bsart | Eigenfertigung |
And I save the current editor

Given I open an editor "V1-METALL2" from table "(Part):(Product)" with command "COPY" for record "V1"
And I set fields
  | such  | V1-METALL2      |
  | le    | Stück           |
  | bsart | Eigenfertigung  |
And I save the current editor

# EK - Versionen zum Basisartikel Metallplatte anlegen,
Given I open an editor "B-METALLPLATTE" from table "(Part):(BaseProduct)" with command "NEW" for record ""
And I set fields
  | such     | B-METALLPLATTE |
  | namebspr | Metallplatte   |
And I append rows
  | tversion      | tindex  | tstdvers |
  | !V1-METALL1^id | 1      | nein     |
  | !V1-METALL2^id | 2      | ja       |
And I save the current editor
# Lohnfertigungsteile  anlegen
Given I open an editor "LF.SCHLEIFEN" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | LF.SCHLEIFEN             |
   | namebspr | Lohnfertigung Schleifen  |
   | bsart    | Lohnfertigung            |
And I save the current editor

Given I open an editor "LF.GALVANISIEREN" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | LF.GALVANISIEREN             |
   | namebspr | Lohnfertigung Galvanisieren |
   | bsart    | Lohnfertigung                |
And I save the current editor

# Lohnfertigungsvorschlag anlegen und anfragen
Given I open an editor "lohn-basis" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
And I create a new row at the end of the table
And I delete row at position 1
And I append rows
  | artikel        | lffert       | basisartikel     | mge | lief | anfragen |
  | !LF.SCHLEIFEN  | !V1-METALL2  | !B-METALLPLATTE  |  20 | 1    | ja       |
And I press button "manfragen" to open a subeditor for "AUSKP"
# In der Ausschreibung
Then field "artikel" has value "LF.SCHLEIFEN" in row 1
Then field "lffert" has value "V1-METALL2" in row 1
Then field "tbasisartikel" has value "B-METALLPLATTE" in row 1

And I set field "artikel" to "!LF.GALVANISIEREN" in row 1
Then field "lffert" has value "V1-METALL2" in row 1
Then field "tbasisartikel" has value "B-METALLPLATTE" in row 1

And I set field "artikel" to "V1" in row 1
Then field "lffert" is empty in row 1
Then field "tbasisartikel" is empty in row 1

And I set field "artikel" to "!LF.GALVANISIEREN" in row 1
And I set field "lffert" to "!V1-METALL1" in row 1
Then field "tbasisartikel" has value "B-METALLPLATTE" in row 1

And I set field "tbasisartikel" to "" in row 1
Then field "lffert" is empty in row 1
Then field "artikel" has value "LF.GALVANISIEREN" in row 1

And I set field "artikel" to "V1" in row 1
And I save the current subeditor to switch back to the parent editor
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: Vererben von ptext und Freitext aus BV
#----------------------------------------------------------------------------------------------

# Lieferant L_BV_TXT anlegen
Given I open an editor "L_BV_TXT" from table "(Vendor):(Vendor)" with command "COPY" for record "1"
And I set field "such" to "L_BV_TXT"
And I save the current editor

# Artikel E1_TEXT anlegen
Given I open an editor "E1_TEXT" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1_TEXT"
And I save the current editor

# BV_TEXT als BVs anlegen
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
And I append rows
  | artikel  | mge    | lief      | verw       | ptext              | pftext                                      |
  | !E1_TEXT | 66     | !L_BV_TXT | verw_text  | Umlauttest äöüÄÖÜß | Umlauttest äöüÄÖÜß<>                        |
  | !E1_TEXT | 77     | !L_BV_TXT | verw_text  | she once had me?   | Where the wedding has been lives in a dream |
  | !E1_TEXT | 88     | !L_BV_TXT | verw_text  | Or WHAT?           | Picks up the rice from the FLOOR            |
  | !E1_TEXT | 99     | !L_BV_TXT | verw_text  | I once had a girl  | Eleanor Rigby                               |
And I save the current editor

# Ausschreibung aus BV
Given I open an editor "BV1" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to id from editor "E1_TEXT"
And I set field "kl" to id from editor "L_BV_TXT"
And I press button "ladetab"
And I set field "anfragen" to "ja" in row 1
And I set field "anfragen" to "ja" in row 2
And I set field "anfragen" to "ja" in row 3
And I set field "anfragen" to "ja" in row 4
And I press button "manfragen" to open a subeditor for "AUSSTEXT"
# In der Ausschreibung
Then table has values
  | ptext              | pftext                                      |
  | I once had a girl  | Eleanor Rigby                               |
  | Or WHAT?           | Picks up the rice from the FLOOR            |
  | she once had me?   | Where the wedding has been lives in a dream |
  | Umlauttest äöüÄÖÜß | Umlauttest äöüÄÖÜß<>                        |
# Text in Ausschreibung vor dem Speichern aendern
And I set field "such" to "AUSSTXT"
And I set field "ptext" to "or should I say" in row 2
And I set field "pftext" to "Picks up the rice in the church" in row 2
And I save the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "AUSSTEXTV" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record from editor "AUSSTEXT"
Then table has values
  | ptext              | pftext                                      |
  | I once had a girl  | Eleanor Rigby                               |
  | or should I say    | Picks up the rice in the church             |
  | she once had me?   | Where the wedding has been lives in a dream |
  | Umlauttest äöüÄÖÜß | Umlauttest äöüÄÖÜß<>                        |
And I close the current editor
