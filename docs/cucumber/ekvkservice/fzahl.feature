@persistent
Feature: Fortschrittszahl bei Rahmenauftraegen

Background:
Given I set the fake date to "02.01.1995"

#***************************************************************************
#
#  Name      : fzahl.feature
#  Datum     : 15.03.21
#
#  Verantwortlich : teampss
#
#  Funktion  : Test der Fortschrittszahlen/Rahmenauftraege
#              Alle Tests werden mit dem Artikel "E1" durchgefuehrt
#              Umlagerungsvorschlaege und Umagerungslieferscheine duerfen
#              die Fortschrittszahlen nicht erhoehen!
#
#***************************************************************************
#
# *** Umlagerungsvorschlaege Einkauf ***
# Einkauf: RA 1001 anlegen
# Einkauf: RA 1001 -- kopieren  --> RA 1002
# Einkauf: UMV erfassen und direkt umbuchen
# Einkauf: 2 UMV erfassen
# Einkauf: 1. Umlagerungsvorschlag aufgreifen und umbuchen
# Einkauf: 2. UMV  -- freigeben --> BE 2001
# Einkauf: BE 2001 -- kopieren  --> BE 2002
# Einkauf: BE 2001 -- Lieferung --> LS 3001 -- Rechnung -->  RE 4001  + buchen
# Einkauf: BE 2002 -- Rechnung  --> RE 4002.1  Teilrechnung mit  Lagerbewegung ergaenzen + buchen
# Einkauf: BE 2002 -- Rechnung  --> RE 4002.2  Teilrechnung ohne Lagerbewegung + buchen
# Einkauf: LS 3001 -- kopieren  --> LS 3002    + buchen
# Einkauf: LS 3002 -- kopieren  --> LS 3003    Umlagerungslieferschein draus machen + buchen
# *** Umlagerungslieferscheine Einkauf ***
# Einkauf: RA 1001 -- freigeben --> BE 2003
# Einkauf: BE 2003 -- kopieren  --> BE 2004
# Einkauf: BE 2003 -- Lieferung --> LS 3004    Umlagerungslieferschein + buchen
# Einkauf: BE 2004 -- Lieferung --> LS 3005    Umlagerungslieferschein, ergaenzen + buchen
# Einkauf: LS 3004 -- kopieren  --> LS 3006    Umlagerungslieferschein, RA 1002 eintragen + buchen
# Einkauf: LS 3005 -- kopieren  --> LS 3007    + buchen
# *** Lieferscheine Einkauf ***
# Einkauf: RA 1001 -- freigeben --> BE 2103
# Einkauf: BE 2103 -- kopieren  --> BE 2104
# Einkauf: BE 2103 -- Lieferung --> LS 3104    + buchen
# Einkauf: BE 2104 -- Lieferung --> LS 3105    ergaenzen + buchen
# Einkauf: LS 3104 -- kopieren  --> LS 3106    RA 1002 eintragen + buchen
# Einkauf: LS 3105 -- kopieren  --> LS 3107    + buchen
# Einkauf: BE 2003 -- Rechnung  --> RE 4103    mit  Lagerbewegung
# Einkauf: LS 3105 -- Rechnung  --> RE 4105    ohne Lagerbewegung
# Einkauf: Rechnungen 4103 + 4105 buchen
# Einkauf: RA 1003 -- Rahmenauftrag mit Lohnfertigung und (ev)savings = true
# Einkauf: BE 2105 -- RA 1003 eintragen
# Einkauf: BE 2105 -- Lieferung --> LS 3107    + buchen
# Einkauf: RA 1003 -- freigeben --> BE 2106
# Einkauf: BE 2106 -- Lieferung --> LS 3108    + buchen
# Einkauf: RA 1003 -- (ev)savings = false
# Einkauf: BE 2107 -- Preisfindung (RA 1003)
# Einkauf: BE 2107 -- Lieferung --> LS 3109 + buchen
# Einkauf: RA 1003 -- freigeben --> BE 2108
# Einkauf: BE 2108 -- Lieferung --> LS 3110 + buchen
# Ausgabe aller Einkaufspositionen an die Datei FZAHL.REF
# Verkauf: RA 1001 anlegen
# Verkauf: RA 1001 -- kopieren  --> RA 1002
# *** Umlagerungslieferscheine Verkauf ***
# Verkauf: RA 1001 -- freigeben --> AU 2003
# Verkauf: AU 2003 -- kopieren  --> AU 2004
# Verkauf: AU 2003 -- Lieferung --> LS 3004    Umlagerungslieferschein + buchen
# Verkauf: AU 2004 -- Lieferung --> LS 3005    Umlagerungslieferschein, ergaenzen + buchen
# Verkauf: LS 3004 -- kopieren  --> LS 3006    Umlagerungslieferschein, RA 1002 eintragen + buchen
# Verkauf: LS 3005 -- kopieren  --> LS 3007    + buchen
# *** Lieferscheine Verkauf ***
# Verkauf: RA 1001 -- freigeben --> AU 2103
# Verkauf: AU 2103 -- kopieren  --> AU 2104
# Verkauf: AU 2103 -- Lieferung --> LS 3104    + buchen
# Verkauf: AU 2104 -- Lieferung --> LS 3105    ergaenzen + buchen
# Verkauf: LS 3104 -- kopieren  --> LS 3106    RA 1002 eintragen + buchen
# Verkauf: LS 3105 -- kopieren  --> LS 3107    + buchen
# Verkauf: AU 2003 -- Rechnung  --> RE 4103    mit  Lagerbewegung
# Verkauf: LS 3105 -- Rechnung  --> RE 4105    ohne Lagerbewegung
# Verkauf: Rechnungen 4103 + 4105 buchen
# *** Zusatzpositionen AU/BE und Dienstleistungen ***
# Verkauf: RA 1003 mit Dienstleistung anlegen
# Verkauf: RA 1004 mit Zusatzposition AU/BE anlegen
# Verkauf: AU 2005 aus RA 1003 erstellen
# Verkauf: Serviceuftrag 2006 aus RA 1004 erstellen
# Verkauf: AU 2005 -- Rechnung mit Lagerbewegung --> RE 4106 + buchen
# Verkauf: Serviceauftrag 2006 -- Lieferung --> LS 3109 + buchen
# *** Kopffeld evrahmen Plausi und uebertragen auf Zeilen  ***
# Verkauf: RA 1007 mit gemischten Positionen anlegen (gueltig ab 4.1.95)
# Verkauf: RA 1008 mit gemischten Positionen anlegen
# Verkauf: AU 2008 -- Anlegen zrahmen aus Pos loeschen, mit Kopffeld rahmen wieder belegen
# Verkauf: AU 2008 -- Lieferung + buchen
# Verkauf: AU 2009 -- Anlegen zrahmen aus Pos loeschen, mit Kopffeld rahmen wieder belegen, Kunde aendern (->Rahmen neu ermitteln)
# Verkauf: AU 2009 -- Lieferung + buchen
#
# Ausgabe aller Verkaufspositionen an die Datei FZAHL.REF
# Ausgabe des Lagerjournal in die Datei DRUCK.LST
# Ausgabe des Artikelumsatzzaehler fuer "E1" an die Datei DRUCK.LST
#
#***************************************************************************
#

Scenario: Stammdaten anlegen

# Artikel anlegen
Given I open an editor "TeilZusatzposition-1" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set fields
	| nummer | 1ZU001                |
	| such   | ZU001                 |
	| name   | Zusatzposition AU/BE  |
	| zptyp  | AU/BE                 |
And I save the current editor

Given I open an editor "TeilZusatzposition-2" from table "(Part):(SupplementaryItem)" with command "COPY" for record "1ZU001"
And I set fields
	| nummer | 1ZU002                |
	| such   | ZU002                 |
	| name   | Zusatzposition AU/BE  |
	| zptyp  | AU/BE                 |
And I save the current editor
Given I open an editor "TeilDienstleistung-3" from table "(Part):(Service)" with command "NEW" for record ""
And I set fields
	| nummer | 1DE001          |
	| such   | DE001           |
	| name   | Dienstleistung  |
And I save the current editor
Given I open an editor "TeilDienstleistung-4" from table "(Part):(Service)" with command "COPY" for record "1DE001"
And I set fields
	| nummer | 1DE002          |
	| such   | DE002           |
	| name   | Dienstleistung  |
And I save the current editor

Given I open an editor "A100" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such   | A100             |
   | bsart  | Fremdbeschaffung |
   | dispoa | auftragsbezogen  |
   | vpr    | 100              |
   | lief   | 1                |
   | epr    | 100              |
And I save the current editor

# Vorgangsart Serviceauftrag anlegen
Given I open an editor "FirmaKurztext-5" from table "(Company):(Summary)" with command "NEW" for record ""
And I set fields
	| nummer    | 1SERVAU         |
	| such      | SERVAU          |
	| classname | Serviceauftrag  |
	| typ       | Serviceauftrag  |
And I save the current editor
Given I open an editor "Aufzaehlung-1" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "20341"
And I set fields
	| fldname  | such  |
	| fldkname | such  |
And I create a new row at position 1
And I set field "aufzelem" to "SERVAU" in row 1
And I respond with answer "ja" to the dialog with id "10951"
And I save the current editor

Given I open an editor "Aufzaehlung-2" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "20341"
# -->  <Aufzaehlung> 20341 <aendern> - Modus?
And I set fields
	| reosofort | ja  |
And I save the current editor


Scenario: EK - Umlagerungsvorschlaege erfassen un direkt umbuchen
# *** Umlagerungsvorschlaege Einkauf ***
# Einkauf: RA 1001 anlegen
Given I open an editor "EinkaufRahmenauftrag-6" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1001  |
	| lief   | 1     |
	| vom    | -2    |
And I append rows
	| pnum | artikel | mge   |
	| 1    | e1      | 3000  |
	| 2    | e1      | 10000 |
And I save the current editor

# Einkauf: RA 1001 -- kopieren  --> RA 1002
Given I open an editor "EinkaufRahmenauftrag-7" from table "(Purchasing):(BlanketOrder)" with command "COPY" for record "1001"
And I set fields
	| nummer | 1002  |
And I save the current editor

# Einkauf: UMV erfassen und direkt umbuchen
Given I open an editor "EinkaufUmlagerungsvorschlaege-7" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
And I create a new row at position 1
And I set field "artikel" to "e1" in row 1
And I set field "mge" to "1" in row 1
And I set field "platz" to "l3f1" in row 1
And I set field "zrahmen" to "1001" in row 1
And I set field "beleg" to "1"
And I set field "beldat" to "."
And I press button "malle"
And I press button "umbuchen" to open a subeditor for "Umbuchen"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "EinkaufUmlagerungsvorschlaege-7b" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
# es erscheint eine neue Leermaske
# Einkauf: 2 UMV erfassen
And I create a new row at position 1
And I set field "artikel" to "e1" in row 1
And I set field "mge" to "2" in row 1
And I set field "platz" to "l3f1" in row 1
And I set field "tterm" to "+1" in row 1
And I set field "zrahmen" to "1001" in row 1
And I create a new row at position 2
And I set field "artikel" to "e1" in row 2
And I set field "mge" to "3" in row 2
And I set field "platz" to "l2f1" in row 2
And I set field "tterm" to "+5" in row 2
And I set field "zrahmen" to "1001" in row 2
And I save the current editor

# Einkauf: 1. Umlagerungsvorschlag aufgreifen und umbuchen
Given I open an editor "EinkaufUmlagerungsvorschlaege-8" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I delete row at position 2
And I set field "vkzakt" to "j"
And I set field "beleg" to "2"
And I set field "beldat" to "."
And I press button "malle"
And I press button "umbuchen" to open a subeditor for "Umbuchen"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# Einkauf: 2. UMV  -- freigeben --> BE 2001
Given I open an editor "EinkaufUmlagerungsvorschlaege-9" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
And I set field "bis" to "+10"
And I press button "ladetab"
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "Freigeben"
And I set field "nummer" to "2001"
And I set field "lief" to "1"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "EinkaufBestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "COPY" for record "2001"
And I set fields
	| nummer | 2002  |
And I save the current editor

Scenario: EK - Vorgangskette BE bis RE
# Einkauf: BE 2001 -- Lieferung --> LS 3001 -- Rechnung -->  RE 4001  + buchen
Given I open an editor "EinkaufLieferschein-1" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "2001"
And I set fields
	| nummer | 3001  |
	| vom    | -2    |
	| ueb    | j     |
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "EinkaufRechnung-1" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "3001"
And I set fields
	| nummer | 4001  |
	| vom    | -2    |
And I set field "preis" to "12" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "EinkaufRechnung-1T" from table "(Purchasing):(Invoice)" with command "TRANSFER" for record "4001"
And I save the current editor

# Einkauf: BE 2002 -- Rechnung  --> RE 4002.1  Teilrechnung mit  Lagerbewegung, ergaenzen + buchen
Given I open an editor "EinkaufsRechnung-2" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "2002"
And I set fields
	| nummer | 4002.1  |
	| vom    | -2      |
	| fakt   | j       |
	| ueb    | j       |
And I set field "mge" to "0,3" in row 1
And I set field "preis" to "11" in row 1
And I create a new row at position 2
And I set field "artikel" to "E1" in row 2
And I set field "mge" to "3" in row 2
And I set field "preis" to "2.00" in row 2
And I set field "fixpwert" to "nein" in row 2
And I set field "zrahmen" to "1001" in row 2
And I set field "platz" to "L2F1" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Einkauf: BE 2002 -- Rechnung  --> RE 4002.2  Teilrechnung ohne Lagerbewegung + buchen
Given I open an editor "EinkaufsRechnung-3" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "2002"
# -->  <Einkauf> 2002 <Rechnung> - Modus?
And I set fields
	| nummer | 4002.2  |
	| vom    | -2      |
	| fakt   | n       |
    | ueb    | j       |
And I set field "mge" to ",4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Einkauf: LS 3001 -- kopieren  --> LS 3002    + buchen
Given I open an editor "EinkaufsLieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record "+3001"
And I set fields
	| nummer | 3002  |
	| vom    | -1    |
	| ueb    | j     |
And I save the current editor

# *** Umlagerungslieferscheine Einkauf ***
# Einkauf: RA 1001 -- freigeben --> BE 2003
Given I open an editor "EinkaufsBestellung-1" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "1001"
And I set fields
	| nummer | 2003  |
And I set field "mge" to "2990,7" in row 1
And I save the current editor

# Einkauf: BE 2003 -- kopieren  --> BE 2004
Given I open an editor "EinkaufsBestellung-2" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record "2003"
And I set fields
	| nummer | 2004  |
And I set field "mge" to "3000" in row 1
And I save the current editor

Scenario: EK - Vorgangskette mit Umlagerungslieferschein
# Einkauf: BE 2003 -- Lieferung --> LS 3004    Umlagerungslieferschein + buchen
Given I open an editor "EinkaufsLieferschein-2" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "2003"
And I set fields
	| nummer  | 3004  |
	| umplatz | f4    |
	| ueb     | j     |
And I set field "mge" to "1100" in row 1
And I set field "mge" to "2100" in row 2
And I save the current editor

# Einkauf: BE 2004 -- Lieferung --> LS 3005    Umlagerungslieferschein, ergaenzen + buchen
Given I open an editor "EinkaufLieferschein-2" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "2004"
And I set fields
	| nummer  | 3005  |
	| umplatz | f3    |
	| ueb     | ja    |
And I set field "mge" to "120" in row 1
And I set field "mge" to "240" in row 2
And I create a new row at position 3
And I set field "pnum" to "3" in row 3
And I set field "artikel" to "e1" in row 3
And I set field "mge" to "100" in row 3
And I save the current editor

# Einkauf: LS 3004 -- kopieren  --> LS 3006    Umlagerungslieferschein, RA 1002 eintragen + buchen
Given I open an editor "" from table "(Purchasing):(PackingSlip)" with command "NEW" for record "+3004"
And I set fields
	| nummer | 3006  |
	| ueb    | j     |
And I set field "fixpwert" to "nein" in row 1
And I set field "zrahmen" to "1002" in row 1
And I save the current editor

# Einkauf: LS 3005 -- kopieren  --> LS 3007    + buchen
Given I open an editor "EinkaufsLieferschein-3" from table "(Purchasing):(PackingSlip)" with command "NEW" for record "+3005"
And I set fields
	| nummer  | 3007  |
	| umplatz | f4    |
And I save the current editor

Given I open an editor "EinkaufsLieferschein-3T" from table "(Purchasing):(PackingSlip)" with command "TRANSFER" for record "3007"
And I save the current editor

Scenario: EK -Lieferschein
# *** Lieferscheine Einkauf ***
# Einkauf: RA 1001 -- freigeben --> BE 2103
Given I open an editor "EinkaufsBestellung-3" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "1001"
And I set fields
	| nummer | 2103  |
And I set field "mge" to "3000" in row 1
And I set field "mge" to "10000" in row 2
And I save the current editor

# Einkauf: BE 2103 -- kopieren  --> BE 2104
Given I open an editor "EinkaufsBestellung-4" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record "2103"
And I set fields
	| nummer | 2104  |
And I save the current editor

# Einkauf: BE 2103 -- Lieferung --> LS 3104    + buchen
Given I open an editor "EinkaufsLieferschein-4" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "2103"
And I set fields
	| nummer | 3104  |
	| vom    | -2    |
	| ueb    | j     |
And I set field "mge" to "2000" in row 1
And I set field "mge" to "3000" in row 2
And I save the current editor

# Einkauf: BE 2104 -- Lieferung --> LS 3105    ergaenzen + buchen
Given I open an editor "EinkaufsLieferschein-5" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "2104"
And I set fields
	| nummer | 3105  |
	| vom    | -1    |
	| ueb    | ja    |
And I set field "mge" to "700" in row 1
And I set field "mge" to "800" in row 2
And I create a new row at position 3
And I set field "artikel" to "e1" in row 3
And I set field "mge" to "150" in row 3
And I set field "pnum" to "3" in row 3
And I save the current editor

# Einkauf: LS 3104 -- kopieren  --> LS 3106    RA 1002 eintragen + buchen
Given I open an editor "EinkaufsLieferschein-6" from table "(Purchasing):(PackingSlip)" with command "NEW" for record "3104"
And I set fields
	| nummer | 3106  |
	| vom    | .     |
	| ueb    | j     |
	And I set field "fixpwert" to "nein" in row 1
And I set field "zrahmen" to "1002" in row 1
And I save the current editor

# Einkauf: LS 3105 -- kopieren  --> LS 3107    + buchen
Given I open an editor "EinkaufsLieferschein-7" from table "(Purchasing):(PackingSlip)" with command "NEW" for record "3105"
And I set fields
	| nummer | 3107  |
	| vom    | -3    |
	| ueb    | ja    |
Then field "zrahmen" has value "" in row 1
Then field "zrahmen" has value "" in row 2
And I save the current editor

Scenario: EK - Rechnung mit LB
# Einkauf: BE 2003 -- Rechnung  --> RE 4103    mit  Lagerbewegung
Given I open an editor "EinkaufsRechnung-4" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "2003"
And I set fields
	| nummer | 4103  |
	| fakt   | j     |
	| vom    | -1    |
	| ueb    | ja    |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I set field "preis" to "3" in row 1
And I set field "preis" to "4" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Einkauf: LS 3105 -- Rechnung  --> RE 4105    ohne Lagerbewegung
Given I open an editor "EinkaufsRechnung-5" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "3105"
And I set fields
	| nummer | 4105  |
	| vom    | -2    |
	| ueb    | ja    |
And I set field "preis" to "1" in row 1
And I set field "preis" to "2" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


Scenario: EK RA mit Lohnfertigung
# Einkauf: Rechnungen 4103 + 4105 buchen s.o.

# Einkauf: RA 1003 -- Rahmenauftrag mit Lohnfertigung und (ev)savings = true
Given I open an editor "Teil-12" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| such     | LFERT            |
	| namebspr | Lohnfertigung    |
	| lief     | 1                |
	| epr      | 33               |
	| dispoa   | auftragsbezogen  |
	| bsart    | Lohnfertigung    |
And I save the current editor

Given I open an editor "EinkaufRahmenauftrag-13" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
	| lief   | 1     |
	| nummer | 1003  |
And I append rows
	| artikel | mge | preis | lffert | savings | pnum |
	| LFERT   | 100 | 44    | V1     | ja      | 1    |
	| LFERT   | 100 | 66    | V2     | ja      | 2    |
And I save the current editor

# Einkauf: BE 2105 -- RA 1003 eintragen
Given I open an editor "EinkaufRechnungen-14" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 2105  |
	| lief   | 1     |
And I create a new row at position 1
And I set field "artikel" to "LFERT" in row 1
And I set field "mge" to "1" in row 1
And I set field "pnum" to "1" in row 1
Then field "zrahmen" has value "" in row 1
And I set field "lffert" to "V1" in row 1
Then field "zrahmen" has value "" in row 1
And I set field "zrahmen" to "1003" in row 1
Then field "zrahmen" has value "1003" in row 1
And I set field "lffert" to "V2" in row 1
Then field "zrahmen" has value "1003" in row 1
And I set field "lffert" to "V1" in row 1
Then field "zrahmen" has value "1003" in row 1
And I set field "zrahmen" to "1003" in row 1
Then field "zrahmen" has value "1003" in row 1

And I create a new row at position 2
And I set field "artikel" to "LFERT" in row 2
And I set field "mge" to "10" in row 2
And I set field "pnum" to "2" in row 2
And I set field "lffert" to "V2" in row 2
Then field "zrahmen" has value "" in row 2
And I set field "zrahmen" to "1003" in row 2
Then field "zrahmen" has value "1003" in row 2
And I set field "lffert" to "V3" in row 2
Then field "zrahmen" has value "" in row 2
And I set field "lffert" to "V2" in row 2
Then field "zrahmen" has value "" in row 2
And I set field "zrahmen" to "1003" in row 2
Then field "zrahmen" has value "1003" in row 2

And I create a new row at position 3
And I set field "artikel" to "LFERT" in row 3
And I set field "mge" to "100" in row 3
And I set field "pnum" to "3" in row 3
And I set field "lffert" to "V2" in row 3
Then field "zrahmen" has value "" in row 3
And I set field "zrahmen" to "1003" in row 3
Then field "zrahmen" has value "1003" in row 3
And I set field "lffert" to "V3" in row 3
Then field "zrahmen" has value "" in row 3
# Setze auf 1003 -> Rahmenauftrag passt nicht.
Then setting field "zrahmen" to "1003" in row 3 throws the exception "2438"
Then field "zrahmen" has value "" in row 3
Then table has values
    | artikel | lffert  | mge | zrahmen |
    | LFERT   | V1      |   1 | 1003    |
    | LFERT   | V2      |  10 | 1003    |
    | LFERT   | V3      | 100 |         |
And I save the current editor

# Einkauf: BE 2105 -- Lieferung --> LS 3107 + buchen
Given I open an editor "" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "2105"
And I set fields
	| num    | 3107  |
	| vom    | -2    |
	| ueb    | j     |
And I set field "mge" to "1" in row 1
And I set field "mge" to "10" in row 2
And I set field "mge" to "100" in row 3
Then field "zrahmen" has value "1003" in row 1
Then field "zrahmen" has value "1003" in row 2
And I save the current editor

# Einkauf: RA 1003 -- freigeben --> BE 2106
Given I open an editor "EinkaufRechnungen-13.15" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "1003"
And I set fields
	| nummer | 2106  |
And I set field "mge" to "1" in row 1
And I set field "fixpwert" to "n" in row 1
And I set field "lffert" to "V2" in row 1
And I set field "mge" to "10" in row 2
And I set field "fixpwert" to "n" in row 2
And I set field "lffert" to "V1" in row 2
And I save the current editor

# Einkauf: BE 2106 -- Lieferung --> LS 3108 + buchen
Given I open an editor "" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "2106"
And I set fields
	| nummer | 3108  |
	| vom    | -2    |
	| ueb    | j     |
And I set field "mge" to "1" in row 1
And I set field "mge" to "10" in row 2
Then field "zrahmen" has value "1003" in row 1
Then field "zrahmen" has value "1003" in row 2
And I save the current editor

# Einkauf: RA 1003 -- (ev)savings = false
Given I open an editor "EinkaufRahmenauftrag-13.16" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "1003"
And I set field "savings" to "nein" in row 1
And I set field "savings" to "nein" in row 2
And I save the current editor

Scenario: EK - Preisfindung
# Einkauf: BE 2107 -- Preisfindung (RA 1003)
Given I open an editor "EinkaufBestellung-17" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 2107  |
	| lief   | 1     |
And I create a new row at position 1
And I set field "artikel" to "LFERT" in row 1
And I set field "mge" to "1" in row 1
And I set field "pnum" to "1" in row 1
Then field "zrahmen" has value "" in row 1
And I set field "lffert" to "V2" in row 1
Then field "zrahmen" has value "1003" in row 1
And I set field "lffert" to "V1" in row 1
Then field "zrahmen" has value "1003" in row 1

And I create a new row at position 2
And I set field "artikel" to "LFERT" in row 2
And I set field "mge" to "10" in row 2
And I set field "pnum" to "2" in row 2
Then field "zrahmen" has value "" in row 2
And I set field "lffert" to "V2" in row 2
Then field "zrahmen" has value "1003" in row 2
And I set field "lffert" to "V3" in row 2
Then field "zrahmen" has value "" in row 2
And I set field "lffert" to "V2" in row 2
Then field "zrahmen" has value "1003" in row 2

And I create a new row at position 3
And I set field "artikel" to "LFERT" in row 3
And I set field "mge" to "100" in row 3
And I set field "pnum" to "3" in row 3
Then field "zrahmen" has value "" in row 3
And I set field "lffert" to "V2" in row 3
Then field "zrahmen" has value "1003" in row 3
And I set field "lffert" to "V3" in row 3
Then field "zrahmen" has value "" in row 3
And I save the current editor

# Einkauf: BE 2107 -- Lieferung --> LS 3109 + buchen
Given I open an editor "" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "2107"
And I set fields
	| num    | 3109  |
	| vom    | -2    |
	| ueb    | j     |
And I set field "mge" to "1" in row 1
And I set field "mge" to "10" in row 2
And I save the current editor

# Einkauf: RA 1003 -- freigeben --> BE 2108
Given I open an editor "EinkaufRechnungen-13.18" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "1003"
And I set fields
	| nummer | 2108  |
And I set field "mge" to "1" in row 1
And I set field "fixpwert" to "n" in row 1
# Fertigteil vertauschen -> zrahmenpos muss sich aendern
And I set field "lffert" to "V2" in row 1
And I set field "mge" to "10" in row 2
And I set field "fixpwert" to "n" in row 2
And I set field "lffert" to "V1" in row 2
Then field "zrahmen" has value "1003" in row 1
Then field "zrahmen" has value "1003" in row 2
And I save the current editor

# Einkauf: BE 2108 -- Lieferung --> LS 3110 + buchen
Given I open an editor "" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "2108"
And I set fields
	| num    | 3110  |
	| vom    | -2    |
	| ueb    | j     |
And I set field "mge" to "1" in row 1
And I set field "mge" to "10" in row 2
Then field "zrahmen" has value "1003" in row 1
Then field "zrahmen" has value "1003" in row 2
And I save the current editor

# Einkauf: Fortschrittszahl von ungueltig gewordenem Rahmenauftrag bebuchen

Given I open an editor "RA-1009" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1009  |
	| lief   | 1     |
    | vom    | .     |
And I append rows
    | artikel | mge  | zgltvon | zgltbis |
    | A100    | 1000 | -100    | .       |
And I save the current editor

Given I open an editor "BE-2010" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 2010  |
	| lief   | 1     |
And I append rows
	| pnum | artikel | mge  |
	| 1    | A100    | 20   |
And I save the current editor

# Einkauf: BE 2010 -- Rahmenauftrag ungueltig - Lieferung + buchen
Given I set the fake date to "03.01.1995"
Given I open an editor "LS-3010" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "2010"
And I set fields
	| nummer | 3010  |
	| vom    | .     |
	| ueb    | ja    |
And I press button "offueb" in row 1
And I save the current editor

Scenario: EK - Testausgabe per FOP Alle Positionen
# Ausgabe aller Einkaufspositionen an die Datei FZAHL.REF
Given I execute FOP "FZAHL.PROTO Einkauf"



Scenario: VK - Umlagerungsvorschlaege erfassen und direkt umbuchen
# Verkauf: RA 1001 anlegen
Given I open an editor "VerkaufRahmenauftrag-19" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1001  |
	| kunde  | 1     |
And I append rows
	| pnum | artikel | mge   |
	| 1    | e1      | 3000  |
	| 2    | e1      | 10000 |
And I save the current editor

# Verkauf: RA 1001 -- kopieren  --> RA 1002
Given I open an editor "VerkaufRahmenauftrag-20" from table "(Sales):(BlanketOrder)" with command "NEW" for record "1001"
And I set fields
	| nummer | 1002  |
And I save the current editor

# *** Umlagerungslieferscheine Verkauf ***
# Verkauf: RA 1001 -- freigeben --> AU 2003
Given I open an editor "" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "1001"
And I set fields
	| nummer | 2003  |
And I set field "mge" to "3000" in row 1
And I save the current editor

# Verkauf: AU 2003 -- kopieren  --> AU 2004
Given I open an editor "VerkaufAuftrag-20" from table "(Sales):(SalesOrder)" with command "NEW" for record "2003"
And I set fields
	| nummer | 2004  |
And I save the current editor

# Verkauf: AU 2003 -- Lieferung --> LS 3004    Umlagerungslieferschein + buchen
Given I open an editor "VerkaufAuftrag-21" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "2003"
And I set fields
	| nummer  | 3004  |
	| umplatz | f4    |
	| ueb     | j     |
And I set field "mge" to "1100" in row 1
And I set field "mge" to "2100" in row 2
And I save the current editor

# Verkauf: AU 2004 -- Lieferung --> LS 3005    Umlagerungslieferschein, ergaenzen + buchen
Given I open an editor "" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "2004"
And I set fields
	| nummer  | 3005  |
	| umplatz | f3    |
	| ueb     | ja    |
And I set field "mge" to "120" in row 1
And I set field "mge" to "240" in row 2
And I create a new row at position 3
And I set field "pnum" to "3" in row 3
And I set field "artikel" to "e1" in row 3
And I set field "mge" to "100" in row 3
And I save the current editor

# Verkauf: LS 3004 -- kopieren  --> LS 3006    Umlagerungslieferschein, RA 1002 eintragen + buchen
Given I open an editor "" from table "(Sales):(PackingSlip)" with command "NEW" for record "+3004"
And I set fields
	| nummer | 3006  |
	| ueb    | j     |
And I set field "fixpwert" to "nein" in row 1
And I set field "zrahmen" to "1002" in row 1
And I save the current editor

Scenario: VK - Vorgangskette AU bis RE
# Verkauf: LS 3005 -- kopieren  --> LS 3007    + buchen
Given I open an editor "" from table "(Sales):(PackingSlip)" with command "NEW" for record "+3005"
And I set fields
	| nummer  | 3007  |
	| umplatz | f4    |
	| ueb     | ja    |
And I save the current editor

# *** Lieferscheine Verkauf ***
# Verkauf: RA 1001 -- freigeben --> AU 2103
Given I open an editor "" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "1001"
And I set fields
	| nummer | 2103  |
And I set field "mge" to "3000" in row 1
And I set field "mge" to "10000" in row 2
And I save the current editor

# Verkauf: AU 2103 -- kopieren  --> AU 2104
Given I open an editor "" from table "(Sales):(SalesOrder)" with command "NEW" for record "2103"
And I set fields
	| nummer | 2104  |
And I save the current editor

# Verkauf: AU 2103 -- Lieferung --> LS 3104    + buchen
Given I open an editor "" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "2103"
And I set fields
	| nummer | 3104  |
	| vom    | -2    |
	| ueb    | j     |
And I set field "mge" to "2000" in row 1
And I set field "mge" to "3000" in row 2
And I save the current editor

# Verkauf: AU 2104 -- Lieferung --> LS 3105    ergaenzen + buchen
Given I open an editor "" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "2104"
And I set fields
	| nummer | 3105  |
	| vom    | -1    |
	| ueb    | ja    |
And I set field "mge" to "700" in row 1
And I set field "mge" to "800" in row 2
And I create a new row at position 3
And I set field "pnum" to "3" in row 3
And I set field "artikel" to "e1" in row 3
And I set field "mge" to "150" in row 3
And I save the current editor

# Verkauf: LS 3104 -- kopieren  --> LS 3106    RA 1002 eintragen + buchen
Given I open an editor "" from table "(Sales):(PackingSlip)" with command "NEW" for record "3104"
And I set fields
	| nummer | 3106  |
	| vom    | .     |
	| ueb    | j     |
And I set field "fixpwert" to "nein" in row 1
And I set field "zrahmen" to "1002" in row 1
And I save the current editor

# Verkauf: LS 3105 -- kopieren  --> LS 3107    + buchen
Given I open an editor "" from table "(Sales):(PackingSlip)" with command "NEW" for record "3105"
And I set fields
	| nummer | 3107  |
	| vom    | -3    |
	| ueb    | ja    |
And I save the current editor

Scenario: VK - Rechnung mit LB
# Verkauf: AU 2003 -- Rechnung  --> RE 4103    mit  Lagerbewegung
Given I open an editor "" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "2003"
And I set fields
	| nummer | 4103  |
	| fakt   | j     |
	| vom    | -1    |
	| tterm  | +10   |
	| ueb    | ja    |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I set field "preis" to "3" in row 1
And I set field "preis" to "4" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Verkauf: LS 3105 -- Rechnung  --> RE 4105    ohne Lagerbewegung
Given I open an editor "" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "3105"
And I set fields
	| nummer | 4105  |
	| vom    | -2    |
	| tterm  | +10   |
	| ueb    | ja    |
And I set field "preis" to "1" in row 1
And I set field "preis" to "2" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Verkauf: Rechnungen 4103 + 4105 buchen s.o.

Scenario: VK - Dienstleistung, ZO, gemischten Positionen
# Verkauf: RA 1003 mit Dienstleistung anlegen
Given I open an editor "VerkaufRechnungen-21" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1003  |
	| kunde  | 1     |
And I append rows
	| pnum | artikel | mge |
	| 1    | 1ZU001  | 100 |
And I save the current editor

# Verkauf: RA 1004 mit Zusatzposition AU/BE anlegen
Given I open an editor "VerkaufRechnungen-22" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
	| nummer  | 1004    |
	| kunde   | 1       |
	| vorgart | SERVAU  |
And I append rows
	| pnum | artikel | mge |
	| 1    | 1DE001  | 100 |
And I save the current editor

# Verkauf: AU 2005 aus RA 1003 erstellen
Given I open an editor "" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "1003"
And I set fields
	| nummer | 2005  |
And I set field "mge" to "33" in row 1
And I save the current editor

# Verkauf: RA 1007 mit gemischten Positionen anlegen (gueltig ab 4.1.95)
Given I open an editor "VerkaufRahmenauftrag-23" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1007  |
	| kunde  | 001   |
	| vom    | +2    |
And I append rows
	| pnum | artikel | mge |
	| 1    | v1      | 100 |
	| 2    | 1ZU001  | 100 |
	| 3    | 1DE001  | 100 |
And I save the current editor

# Verkauf: RA 1008 mit gemischten Positionen anlegen
Given I open an editor "" from table "(Sales):(BlanketOrder)" with command "NEW" for record "1007"
And I set fields
	| nummer | 1008  |
	| vom    | .     |
And I save the current editor

# Verkauf: Serviceuftrag 2006 aus RA 1004 erstellen
Given I open an editor "" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "1004"
And I set fields
	| nummer | 2006  |
And I set field "mge" to "44" in row 1
And I set field "ganztag" to "ja" in row 1
And I save the current editor

# Verkauf: AU 2005 -- Rechnung mit Lagerbewegung --> RE 4106 + buchen
Given I open an editor "" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "2005"
And I set fields
	| nummer | 4106  |
	| vom    | .     |
	| tterm  | .     |
	| ueb    | ja    |
And I press button "offueb" in row 1
And I save the current editor

Scenario: VK - Serviceauftraege
# Verkauf: Serviceauftrag 2006 -- Lieferung --> LS 3109 + buchen
Given I open an editor "" from table "(Sales):(ServiceOrder)" with command "DELIVERY" for record "2006"
And I set fields
	| nummer | 3109  |
	| vom    | .     |
	| ueb    | ja    |
And I press button "offueb" in row 1
And I save the current editor

Scenario: VK - Kopffeld Rahmen zur Vorbelegung
# Verkauf: AU 2008 -- Anlegen zrahmen aus Pos loeschen, mit Kopffeld rahmen wieder belegen
Given I open an editor "VerkaufAuftrag-24" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 2008  |
	| kunde  | 001   |
And I append rows
	| pnum | artikel | mge         | zrahmen     | pwert       |
	| 1    | v1      | 20          |             | !dontChange |
	| 2    | v2      | 20          |             | !dontChange |
	| 3    | 1ZU001  | 30          |             | !dontChange |
	| 4    | 1ZU002  | 30          |             | !dontChange |
	| 5    | 1DE001  | 40          |             | !dontChange |
	| 6    | 1DE002  | 40          |             | !dontChange |
	| 7    | TEXT    | !dontChange | !dontChange | 250         |

# Erwarteter Fehler: Rahmenauftrag passt nicht (Kunde stimmt nicht)
Then setting field "rahmen" to "1001" throws the exception "10908"
And I set field "rahmen" to "1008"
And I save the current editor


# Verkauf: AU 2008 -- Neue Positionen einfuegen mit Vorschlagswert aus Kopffeld evrahmen belegen
Given I open an editor "VerkaufAuftrag-24.25" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "2008"
And I create a new row at position 8
And I set field "pnum" to "8" in row 8
# Erwartet: Rahmenauftrag wird mit 1008 vorbelegt
And I set field "artikel" to "V1" in row 8
And I set field "mge" to "50" in row 8
And I create a new row at position 9
And I set field "pnum" to "9" in row 9
# Erwartet: Rahmenauftrag wird NICHT mit 1008 vorbelegt, da Artikel nicht im Rahmenauftrag enthalten
And I set field "artikel" to "V2" in row 9
And I set field "mge" to "60" in row 9
And I save the current editor

# Verkauf: AU 2008 -- Lieferung + buchen
Given I open an editor "VerkaufAuftrag-24.26" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "2008"
And I set fields
	| nummer | 3008  |
	| vom    | .     |
	| ueb    | ja    |
And I set field "mge" to "20" in row 1
And I set field "mge" to "20" in row 2
And I set field "mge" to "30" in row 3
And I set field "mge" to "30" in row 4
And I set field "mge" to "40" in row 5
And I set field "mge" to "40" in row 6
# Erwartet: Fortschrittszahl fuer Artikel v1 im Rahmen 1008 wird um 50 erhoeht
And I set field "mge" to "50" in row 8
# Erwartet: Keinen Einfluss auf Fortschrittszahlen
And I set field "mge" to "60" in row 9
And I save the current editor

Given I open an editor "VerkaufAuftrag-27" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 2009  |
	| kunde  | 001   |
And I append rows
	| pnum | artikel | mge         | zrahmen     | pwert       |
	| 1    | v1      | 20          |             | !dontChange |
	| 2    | v2      | 20          |             | !dontChange |
	| 3    | 1ZU001  | 30          |             | !dontChange |
	| 4    | 1ZU002  | 30          |             | !dontChange |
	| 5    | 1DE001  | 40          |             | !dontChange |
	| 6    | 1DE002  | 40          |             | !dontChange |
	| 7    | TEXT    | !dontChange | !dontChange | 250         |
And I set field "rahmen" to "1008"
# Kunde wechseln!!! (-> Rahmen loeschen)
And I set field "kunde" to "1"
And I save the current editor

# Verkauf: AU 2009 -- Lieferung + buchen
Given I open an editor "VerkaufAuftrag-27.28" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "2009"
And I set fields
	| nummer | 3009  |
	| vom    | .     |
	| ueb    | ja    |
# Erwartet: da Kunde geaendert wurde, sind nun autom. neue Rahmenauftaege belegt worden
And I set field "mge" to "22" in row 1
And I set field "mge" to "23" in row 2
And I set field "mge" to "24" in row 3
And I set field "mge" to "25" in row 4
And I set field "mge" to "26" in row 5
And I set field "mge" to "27" in row 6
# And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Verkauf: Fortschrittszahl von ungueltig gewordenem Rahmenauftrag bebuchen

Given I open an editor "RA-1009" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1009  |
	| kunde  | 1     |
    | vom    | .     |
And I append rows
    | artikel | mge  | zgltvon | zgltbis |
    | A100    | 1000 | -100    | .       |
And I save the current editor

Given I open an editor "AU-2010" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 2010  |
	| kunde  | 1     |
And I append rows
	| pnum | artikel | mge  |
	| 1    | A100    | 20   |
And I save the current editor

# Verkauf: AU 2010 -- Rahmenauftrag ungueltig - Lieferung + buchen
Given I set the fake date to "04.01.1995"
Given I open an editor "LS-3010" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "2010"
And I set fields
	| nummer | 3010  |
	| vom    | .     |
	| ueb    | ja    |
And I press button "offueb" in row 1
And I save the current editor

#  T E S T A U S G A B E
Scenario: VK - Testausgabe per FOP Alle Positionen
# Ausgabe aller Verkaufspositionen an die Datei FZAHL.REF
Given I execute FOP "FZAHL.PROTO Verkauf"


#--------------------------------------------------------------------------------------------
Scenario: UMV vor Freigabe Menge auf Null setzrn
#--------------------------------------------------------------------------------------------
# Diser Fall fuerhte zu einer Diagnosemeldung wegen doppelter Pufferbelegung nur bei ULV.
Given I open an editor "UV_AENDERN" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
And I append rows
	| artikel | lief  | mge  | platz| mfreig |
	| E1      | 003   | 2    | L3F1 | ja     |
	| E1      | 003   | 10   | L3F1 | ja     |
And I save the current editor

Given I open an editor "UV_AENDERN" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
 And I set field "artikel" to "E1"
And I press button "ladetab"
# Beim Aendern kurz vor Freigabe eine Menge auf 0 setzen -> Diag wegen Puffersperre doppelt geholt
And I set field "mge" to "0" in row 2
And I press button "freig" to open a subeditor for "BE33"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

