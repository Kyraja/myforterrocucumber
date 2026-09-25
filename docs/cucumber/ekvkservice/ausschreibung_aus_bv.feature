#***************************************************************************
#
#  Name      : ausschreibung_aus_bv
#  Datum     : 29.05.2024
#  Autor     : MOB: mibr, foe, jeffler, khuelskaemper, lclaus
#  Verantw.  : teampss
#
#  Funktion  : Test von Anfragen und Ausschreibungen aus Bestellvorschlaegen
#
#***************************************************************************
@persistent
Feature: Ausschreibung aus BV
Background: Test von Ausschreibungen aus BV
Given I set the fake date to "02.01.1995"
Given I set saved value "REF_FILE" to "ausschreibung_aus_bv.out"
Given I set saved value "Feldliste" to "sel, tlief, preisok, mgediff, artikel, tevposstatus, preis, zwaehr, proz, ttterm, tevkopf, anfrposgrp, verw, tevkopf^bsart, tevkopf^rechnung, lbedname, lgruppe, projekt^such"

#--------------------------------------------------------------------------------------------
Scenario: Zusatzposition mit Umlage anlegen
#--------------------------------------------------------------------------------------------
Given I open an editor "TeilZusatzposition-1" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set fields
	| such     | UMLAGE             |
	| namebspr | Umlage             |
	| zptyp    | neutrale Position  |
	| umlage   | ja                 |
And I save the current editor

#--------------------------------------------------------------------------------------------
Scenario: TSQ-AUSS_AUS_BV-004: Ausschreibung anlegen, Zeile fuer neuen Lieferanten kopieren, Anfragen erzeugen, Ausschreibung ausgeben
#--------------------------------------------------------------------------------------------
# Ausschreibung anlegen, Zeile fuer neuen Lieferanten kopieren, Anfragen erzeugen, Ausschreibung ausgeben
# Bestellvorschlaege fuer Artikel 80001 laden und anfragen
Given I open an editor "bestellvorschlag-1" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "80001"
And I press button "ladetab"
And I set field "lgruppe" to "HONGKONG" in row 1
And I set field "projekt" to "101" in row 1
And I set field "anfragen" to "ja" in row 1
And I press button "manfragen" to open a subeditor for "AUS01"
# Ausschreibung aus BV bearbeiten und Anfrage fuer Lieferanten 60302 kopieren
And I set fields
	| such | ANB.AUS1              |
	| name | ANB.AUS1 Bezeichnung  |
	| lief | 60302                 |
And I press button "tkopieren" in row 1
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# Ausschreibung ausgeben
Given I open an editor "AUS01V" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record from editor "AUS01"
Then I fill template "EV_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
# Felder mit "Daechle" koennen nicht im Tamplate abgefragt werden
Then field "tevkopf^bsart" has value "Fremdbeschaffung" in row 1
Then field "tevkopf^rechnung" has value "" in row 1
Then field "tevkopf^bsart" has value "Fremdbeschaffung" in row 2
Then field "tevkopf^rechnung" has value "" in row 2
And I close the current editor

#--------------------------------------------------------------------------------------------
Scenario: TSQ-AUSS_AUS_BV-014: Ausschreibung fuer LFV anlegen, Zeile fuer neuen Lieferanten kopieren, Anfragen erzeugen, Ausschreibung ausgeben
#--------------------------------------------------------------------------------------------
# Lohnfertigungsvorschlaege fuer LF LFANB.ART4 laden und anfragen
Given I open an editor "Lohnfertigungsvorschlag-1" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "LFANB.ART4"
And I press button "ladetab"
And I set field "anfragen" to "ja" in row 2
And I press button "manfragen" to open a subeditor for "AUS05"
# Ausschreibung aus BV bearbeiten und Anfrage fuer Lieferanten 60302 kopieren
And I set fields
	| such | ANB.AUS5              |
	| name | ANB.AUS5 Bezeichnung  |
	| lief | 60302                 |
And I press button "tkopieren" in row 1
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# Ausschreibung ausgeben
Given I open an editor "AUS05V" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record "ANB.AUS5"
Then I fill template "EV_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
# Felder mit "Daechle" koennen nicht im Tamplate abgefragt werden
Then field "tevkopf^bsart" has value "Lohnfertigung" in row 1
Then field "tevkopf^rechnung" has value "" in row 1
Then field "tevkopf^bsart" has value "Lohnfertigung" in row 2
Then field "tevkopf^rechnung" has value "" in row 2
And I close the current editor

#--------------------------------------------------------------------------------------------
Scenario: TSQ-AUSS_AUS_BV-005: In Anfragen Preise und Liefertermine eintragen, Ausschreibung erneut ausgeben
#--------------------------------------------------------------------------------------------
Given I open an editor "Angebot1" from table "(Purchasing):(Request)" with command "UPDATE" for record "$,,@gruppe=21;ausschr==1;lief==60301"
And I set field "preis" to "15" in row 1
And I set field "wtterm" to "05.01.95" in row 1
And I save the current editor

Given I open an editor "Angebot2" from table "(Purchasing):(Request)" with command "UPDATE" for record "$,,@gruppe=21;ausschr==1;lief==60302"
And I set field "preis" to "16" in row 1
And I set field "wtterm" to "06.01.95" in row 1
And I save the current editor

# Ausschreibung ausgeben
Given I open an editor "AUS01V" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record from editor "AUS01"
Then I fill template "EV_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
And I close the current editor


#--------------------------------------------------------------------------------------------
Scenario:: TSQ-AUSS_AUS_BV-029: Weitere Anfrage in Fremdwaehrung. Beruecksichtigung der Fremdwaehrung bei Ermittlung bester Preis.
#--------------------------------------------------------------------------------------------
Given I open an editor "EinkaufAnfrage-2" from table "(Purchasing):(Request)" with command "NEW" for record ""
And I set fields
	| nummer   | 1GBP      |
	| such     | ANF3      |
	| lief     | 001       |
	| erfwaehr | GBP       |
	| ausschr  | ANB.AUS1  |

And I append rows
	| artikel  | preis | mge | anfrposgrp |
#	| ANB.ART1 | 14.00 | 10  | 1          |
	| 80001   | 14.00 | 10  | 1          |
And I save the current editor

# Ausschreibung ausgeben
Given I open an editor "AUS01V" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record from editor "AUS01"
Then I fill template "EV_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
# Felder mit "Daechle" koennen nicht im Tamplate abgefragt werden
Then table has values
    | tevkopf^bsart    | tevkopf^rechnung | projekt^such |
    | Fremdbeschaffung |                  |        PROJ1 |
    | Fremdbeschaffung |                  |        PROJ1 |
    | Fremdbeschaffung |                6 |              |
And I close the current editor


#--------------------------------------------------------------------------------------------
Scenario: TSQ-AUSS_AUS_BV-015: In LF Anfragen Preise und Liefertermine eintragen, Ausschreibung erneut ausgeben
#--------------------------------------------------------------------------------------------
Given I open an editor "" from table "(Purchasing):(Request)" with command "UPDATE" for search criteria "$,,@gruppe=21;ausschr==2;@richtung=vorwärts;@maxtreffer=1"
And I set field "preis" to "10" in row 1
And I set field "wtterm" to "15.01.95" in row 1
And I save the current editor

# Nochmal aendern
Given I open an editor "" from table "(Purchasing):(Request)" with command "UPDATE" for search criteria "$,,@gruppe=21;ausschr==2;@richtung=rückwärts;@maxtreffer=1"
And I set field "preis" to "11" in row 1
And I set field "wtterm" to "16.01.95" in row 1
And I save the current editor

# Ausschreibung ausgeben
Given I open an editor "AUS05V" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record from editor "AUS05"
Then I fill template "EV_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
# Felder mit "Daechle" koennen nicht im Tamplate abgefragt werden
Then table has values
    | tevkopf^bsart    | tevkopf^rechnung | projekt^such |
    | Lohnfertigung    |                  |              |
    | Lohnfertigung    |                  |              |
And I close the current editor

#--------------------------------------------------------------------------------------------
Scenario: TSQ-AUSS_AUS_BV-006: Guenstigeres Angebot bestellen (erste Zeile, Lieferant 60301), abgelegte Ausschreibung ausgeben
#--------------------------------------------------------------------------------------------
Given I open an editor "ANB.AUS1" from table "(BiddingProcess):(BiddingProcess)" with command "UPDATE" for record "ANB.AUS1"
And I set field "sel" to "ja" in row 1
And I press button "bestell" to open a subeditor for "Bestellung" in row 1
# Bestellung oeffnet sich
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Ausschreibung ausgeben
Given I open an editor "AUS01V" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record from editor "AUS01"
Then I fill template "EV_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
# Felder mit "Daechle" koennen nicht im Tamplate abgefragt werden
Then table has values
    | tevkopf^bsart    | tevkopf^rechnung | projekt^such |
    | Fremdbeschaffung |                  |        PROJ1 |
    | Fremdbeschaffung |                  |        PROJ1 |
    | Fremdbeschaffung |                6 |              |
And I close the current editor


#--------------------------------------------------------------------------------------------
Scenario: TSQ-AUSS_AUS_BV-016: LFV: Guenstigeres Angebot bestellen (erste Zeile, Lieferant 60301), abgelegte Ausschreibung ausgeben
#--------------------------------------------------------------------------------------------
Given I open an editor "ANB.AUS5" from table "(BiddingProcess):(BiddingProcess)" with command "UPDATE" for record "ANB.AUS5"
And I set field "sel" to "ja" in row 1
And I press button "bestell" to open a subeditor for "Bestellung" in row 1
# Bestellung oeffnet sich
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Ausschreibung ausgeben
Given I open an editor "AUS05V" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record from editor "AUS05"
Then I fill template "EV_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
# Felder mit "Daechle" koennen nicht im Tamplate abgefragt werden
Then table has values
    | tevkopf^bsart    | tevkopf^rechnung | projekt^such |
    | Lohnfertigung    |                  |              |
    | Lohnfertigung    |                  |              |
And I close the current editor


#--------------------------------------------------------------------------------------------
Scenario: TSQ-AUSS_AUS_BV-007: Ausschreibung mit mehreren Gruppen erstellen (inkl. Textpositionen). Teilweise Positionen bestellen.
#--------------------------------------------------------------------------------------------
# Neue Ausschreibung mit mehreren Gruppen erstellen inkl. Textpositionen
Given I open an editor "AUS02" from table "(BiddingProcess):(BiddingProcess)" with command "NEW" for record ""
And I set fields
	| such | ANB.AUS2              |
	| name | ANB.AUS2 Bezeichnung  |
And I append rows
    | tlief | artikel | mge         | verw      |anfrposgrp |
    | 60301 |   80001 |   5         | für Elise | 1         | # Verwendung mit Umlaut
    | 60301 |   80002 |   4         |           | 2         |
    | 60301 |   TEXT  | !dontChange |           | 3         |
    | 60302 |   80001 |   5         |           | 1         |
    | 60302 |   TEXT  | !dontChange |           | 3         |
    | 60303 |   80001 |   5         |           | 1         |
    | 60303 |   80002 |   1         |           | 4         |
And I save the current editor

# Ausschreibung ausgeben
Given I open an editor "AUS02V" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record from editor "AUS02"
Then I fill template "EV_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
# Felder mit "Daechle" koennen nicht im Tamplate abgefragt werden
Then table has values
    | tevkopf^bsart    | tevkopf^rechnung | projekt^such |
    | Fremdbeschaffung |                  |              |
    | Fremdbeschaffung |                  |              |
    | Fremdbeschaffung |                  |              |
    | Fremdbeschaffung |                  |              |
    | Fremdbeschaffung |                  |              |
    | Fremdbeschaffung |                  |              |
    | Fremdbeschaffung |                  |              |
And I close the current editor


# Bestellen der ersten und dritten Position -> 2. Anfrage komplett abgelegt, 3. Anfrage 1. Position storniert
Given I open an editor "AUS02" from table "(BiddingProcess):(BiddingProcess)" with command "UPDATE" for record from editor "AUS02"
And I set field "sel" to "ja" in row 1
And I set field "sel" to "ja" in row 3
And I press button "bestell" to open a subeditor for "Bestellung" in row 1
# Bestellung oeffnet sich
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Ausschreibung ausgeben
Given I open an editor "AUS02V" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record from editor "AUS02"
Then I fill template "EV_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
# Felder mit "Daechle" koennen nicht im Tamplate abgefragt werden
Then table has values
    | tevkopf^bsart    | tevkopf^rechnung | projekt^such |
    | Fremdbeschaffung |                  |              |
    | Fremdbeschaffung |                  |              |
    | Fremdbeschaffung |                  |              |
    | Fremdbeschaffung |                  |              |
    | Fremdbeschaffung |                  |              |
    | Fremdbeschaffung |                  |              |
    | Fremdbeschaffung |                  |              |
And I close the current editor


#--------------------------------------------------------------------------------------------
Scenario: TSQ-AUSS_AUS_BV-017: LFV: Ausschreibung mit mehreren Gruppen erstellen (inkl. Textpositionen). Teilweise Positionen bestellen.
#--------------------------------------------------------------------------------------------
Given I open an editor "AUS6" from table "(BiddingProcess):(BiddingProcess)" with command "NEW" for record ""
And I set fields
	| such | ANB.AUS6              |
	| name | ANB.AUS6 Bezeichnung  |
And I append rows
    | tlief | artikel | mge         | verw      |anfrposgrp |
    | 60301 |   80003 |  15         | für Özil  | 1         | # Verwendung mit Umlaut
    | 60301 |   80004 |  14         |           | 2         |
    | 60301 |   TEXT  | !dontChange |           | 3         |
    | 60302 |   80003 |  15         |           | 1         |
    | 60302 |   TEXT  | !dontChange |           | 3         |
    | 60303 |   80003 |  15         |           | 1         |
    | 60303 |   80004 |  11         |           | 4         |
And I save the current editor

# Ausschreibung ausgeben
Given I open an editor "AUS06V" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record from editor "AUS6"
Then I fill template "EV_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
# Felder mit "Daechle" koennen nicht im Tamplate abgefragt werden
Then table has values
    | tevkopf^bsart    | tevkopf^rechnung | projekt^such |
    | Lohnfertigung    |                  |              |
    | Lohnfertigung    |                  |              |
    | Lohnfertigung    |                  |              |
    | Lohnfertigung    |                  |              |
    | Lohnfertigung    |                  |              |
    | Lohnfertigung    |                  |              |
    | Lohnfertigung    |                  |              |
And I close the current editor

# Bestellen der ersten und dritten Position -> 2. Anfrage komplett abgelegt, 3. Anfrage 1. Position storniert
Given I open an editor "AUS06" from table "(BiddingProcess):(BiddingProcess)" with command "UPDATE" for record from editor "AUS6"
And I set field "sel" to "ja" in row 1
Then field "bestell" is not modifiable in row 3
And I set field "sel" to "ja" in row 3
Then field "bestell" is modifiable in row 3
And I press button "bestell" to open a subeditor for "Bestellung" in row 1
# Bestellung oeffnet sich
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Ausschreibung ausgeben
Given I open an editor "AUS06V" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record from editor "AUS6"
Then I fill template "EV_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
# Felder mit "Daechle" koennen nicht im Tamplate abgefragt werden
Then table has values
    | tevkopf^bsart    | tevkopf^rechnung | projekt^such |
    | Lohnfertigung    |                  |              |
    | Lohnfertigung    |                  |              |
    | Lohnfertigung    |                  |              |
    | Lohnfertigung    |                  |              |
    | Lohnfertigung    |                  |              |
    | Lohnfertigung    |                  |              |
    | Lohnfertigung    |                  |              |
And I close the current editor


#--------------------------------------------------------------------------------------------
Scenario: TSQ-AUSS_AUS_BV-008: Wiedervorlagedatum loeschen -> Ausschreibung selbst sowie alle Anfragen werden abgelegt
#--------------------------------------------------------------------------------------------
Given I open an editor "AUS02" from table "(BiddingProcess):(BiddingProcess)" with command "UPDATE" for record from editor "AUS02"
And I set field "tterm" to " "
And I save the current editor
# Ausschreibung ausgeben
Given I open an editor "AUS02V" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record from editor "AUS02"
Then I fill template "EV_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
# Felder mit "Daechle" koennen nicht im Tamplate abgefragt werden
Then table has values
    | tevkopf^bsart    | tevkopf^rechnung | projekt^such |
    | Fremdbeschaffung |                  |              |
    | Fremdbeschaffung |                  |              |
    | Fremdbeschaffung |                  |              |
    | Fremdbeschaffung |                  |              |
    | Fremdbeschaffung |                  |              |
    | Fremdbeschaffung |                  |              |
    | Fremdbeschaffung |                  |              |
And I close the current editor


#--------------------------------------------------------------------------------------------
Scenario: TSQ-AUSS_AUS_BV-018: LFV: Wiedervorlagedatum loeschen -> Ausschreibung selbst sowie alle Anfragen werden abgelegt
#--------------------------------------------------------------------------------------------
Given I open an editor "AUS06" from table "(BiddingProcess):(BiddingProcess)" with command "UPDATE" for record from editor "AUS06"
And I set field "tterm" to " "
And I save the current editor

# Ausschreibung ausgeben
Given I open an editor "AUS06V" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record from editor "AUS06"
Then I fill template "EV_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
# Felder mit "Daechle" koennen nicht im Tamplate abgefragt werden
Then table has values
    | tevkopf^bsart    | tevkopf^rechnung | projekt^such |
    | Lohnfertigung    |                  |              |
    | Lohnfertigung    |                  |              |
    | Lohnfertigung    |                  |              |
    | Lohnfertigung    |                  |              |
    | Lohnfertigung    |                  |              |
    | Lohnfertigung    |                  |              |
    | Lohnfertigung    |                  |              |
And I close the current editor


#--------------------------------------------------------------------------------------------
Scenario: TSQ-AUSS_AUS_BV-009: Ausschreibung aus Kopie der abgelegten Ausschreibung +ANB.AUS1 erstellen. BV Zuordnen
#--------------------------------------------------------------------------------------------
# Neue Ausschreibung aus Kopie der abgelegten Ausschreibung +ANB.AUS1
# Generierter Suchname aus A+yyyymmdd, BVs aufklappen und erster markieren
Given I open an editor "AusschreibungNeu-3" from table "(BiddingProcess):(BiddingProcess)" with command "COPY" for record from editor "ANB.AUS1"
And I set field "name" to "aus Kopie von ANB.AUS1, Ausgabe mit BV Zeilen"
And I save the current editor

# Aendern und BV zuordnen
Given I open an editor "A19950102" from table "(BiddingProcess):(BiddingProcess)" with command "UPDATE" for record "A19950102"
And I press button "aufzualle"
And I set field "bvzuord" to "j" in row 2
And I set field "bvzuord" to "j" in row 9
And I set field "sel" to "n" in row 7
And I save the current editor

# Ausschreibung ausgeben (Alles aufgeklappt)
Given I open an editor "A19950102V" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record from editor "A19950102"
And I press button "aufzualle"
Then I fill template "EV_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
# Felder mit "Daechle" koennen nicht im Tamplate abgefragt werden
 Then table has values
     | tevkopf^bsart    | tevkopf^rechnung | projekt^such |
     | Fremdbeschaffung |                  |              |
     |                  |                  |        PROJ1 |
     |                  |                  |              |
     |                  |                  |              |
     |                  |                  |              |
     |                  |                  |              |
     | Fremdbeschaffung |                  |              |
     |                  |                  |        PROJ1 |
     |                  |                  |              |
     |                  |                  |              |
     |                  |                  |              |
     |                  |                  |              |
     | Fremdbeschaffung |                6 |              |
     |                  |                  |        PROJ1 |
     |                  |                  |              |
     |                  |                  |              |
     |                  |                  |              |
     |                  |                  |              |
And I close the current editor

# Bestellen der 1. Anfrage ueber Ausschreibung -> Damit Ausgabe der BV leer wird (fuer TSQ-AUSS_AUS_BV-012)
Given I open an editor "A19950102" from table "(BiddingProcess):(BiddingProcess)" with command "UPDATE" for record from editor "A19950102"
And I press button "bestell" to open a subeditor for "Bestellung" in row 1
# Bestellung oeffnet sich
And I save the current subeditor to switch back to the parent editor
And I save the current editor


#--------------------------------------------------------------------------------------------
Scenario: TSQ-AUSS_AUS_BV-019: LFV: Ausschreibung aus Kopie der abgelegten Ausschreibung +ANB.AUS5 erstellen. LFV Zuordnen, LFV nur mit passendem Fertigteil
#--------------------------------------------------------------------------------------------
# LFV: Neue Ausschreibung aus Kopie der abgelegten Ausschreibung +ANB.AUS5
# Generierter Suchname aus A+yyyymmdd, BVs aufklappen und erster markieren
# Pruefen, ob Zu-/Abschlag in den LFV uebertragen wird
Given I open an editor "AUS05B" from table "(BiddingProcess):(BiddingProcess)" with command "COPY" for record from editor "ANB.AUS5"
And I set field "name" to "aus Kopie von ANB.AUS5, Ausgabe mit LFV Zeilen"
And I save the current editor
Given I open an editor "ANF900014" from table "(Purchasing):(Request)" with command "UPDATE" for record "900014"
And I set field "proz" to "11" in row 1
And I set field "lffert" to "ANB.ART5" in row 1
And I save the current editor

Given I open an editor "ANF900015" from table "(Purchasing):(Request)" with command "UPDATE" for record "900015"
And I set field "lffert" to "ANB.ART5" in row 1
And I save the current editor

# Aendern und LFV zuordnen
Given I open an editor "AUS05B" from table "(BiddingProcess):(BiddingProcess)" with command "UPDATE" for record from editor "AUS05B"
And I press button "aufzualle"
And I set field "bvzuord" to "j" in row 2
And I set field "bvzuord" to "j" in row 6
And I set field "sel" to "n" in row 4
Then field "bestell" is not modifiable in row 4
And I save the current editor

# Ausschreibung ausgeben (Alles aufgeklappt)
Given I open an editor "AUS05BV" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record from editor "AUS05B"
And I press button "aufzualle"
Then I fill template "EV_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
# Felder mit "Daechle" koennen nicht im Tamplate abgefragt werden
 Then table has values
     | tevkopf^bsart    | tevkopf^rechnung | projekt^such |
     | Lohnfertigung    |                  |              |
     |                  |                  |              |
     |                  |                  |              |
     | Lohnfertigung    |                  |              |
     |                  |                  |              |
     |                  |                  |              |
And I close the current editor

# Bestellen der 1. Anfrage ueber Ausschreibung -> Damit Ausgabe der LFV leer wird (fuer TSQ-AUSS_AUS_BV-012)
Given I open an editor "AUS05B" from table "(BiddingProcess):(BiddingProcess)" with command "UPDATE" for record from editor "AUS05B"
And I press button "bestell" to open a subeditor for "Bestellung" in row 1
# Bestellung oeffnet sich
And I save the current subeditor to switch back to the parent editor
And I save the current editor


#--------------------------------------------------------------------------------------------
Scenario: TSQ-AUSS_AUS_BV-011: Anfrage in Ausschreibung. Anfrage hat vom Lieferant abweichende Rechnungsstellung. Bestellen.
#--------------------------------------------------------------------------------------------
Given I open an editor "AUS04" from table "(BiddingProcess):(BiddingProcess)" with command "NEW" for record ""
And I set fields
	| such  | ANB.AUS4          |
	| bsart | Fremdbeschaffung  |
And I save the current editor

Given I open an editor "EKANF2A" from table "(Purchasing):(Request)" with command "NEW" for record ""
And I set fields
	| nummer | 2A     |
	| such   | ANF2   |
	| lief   | 60301  |
# Eintrag fuer Rechnungsstellung hat Vorrang bei der Bestellung
	| rechnung | 6         |
	| ausschr  | ANB.AUS4  |
And I append rows
	| artikel | mge | anfrposgrp | verw            |
	| e1      | 27  | 1          | rechnungsstellu |
And I save the current editor

# Ausschreibung ausgeben (Alles aufgeklappt)
Given I open an editor "AUS04V" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record from editor "AUS04"
Then I fill template "EV_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
# Felder mit "Daechle" koennen nicht im Tamplate abgefragt werden
Then table has values
    | tevkopf^bsart    | tevkopf^rechnung | projekt^such |
    | Fremdbeschaffung |                6 |              |
And I close the current editor

# Bestellen ueber Ausschreibung
Given I open an editor "AUS04" from table "(BiddingProcess):(BiddingProcess)" with command "UPDATE" for record from editor "AUS04"
And I set field "sel" to "ja" in row 1
And I press button "bestell" to open a subeditor for "Bestellung" in row 1
# Bestellung oeffnet sich
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Erstellte Bestellung ausgeben
Given I open an editor "" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "$,,@gruppe=22;1:verw=rechnungsstellung"
Then I fill template "EV_VORG_BEI_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
And I close the current editor


#--------------------------------------------------------------------------------------------
Scenario: TSQ-AUSS_AUS_BV-010: AUSSCHREIBUNG.LAD: Anlegen von Anfragen aus der Ausschreibung mit Aufrufparametern
#--------------------------------------------------------------------------------------------
# Testet Miniedit, Aufrufparameter und A|Puffer
# Muss als letzter Test kommen
# FOP anschalten FOPEVOUT.EV an Maskeneintritt Anfrage (43)
# Es darf keinen Vaterpuffer mehr geben, da nicht mehr ueber Miniedit angelegt wird
Given I execute shell command "echo \"43  neu    maskein  *  *  *  FOPEVOUT.FOP\" >> fop.txt"

# Aufrufparameter 59180 (Kopffelder) setzen
Given I open an editor "AP59180" from table "(DataExport):(CallParameter)" with command "UPDATE" for record "59180"
And I append rows
    | zielaktion      | zielvar | aufrwtyp | aufrwert |
    | Kopffeld setzen | betreff | Kopffeld |     name |
And I save the current editor

# Aufrufparameter 59181 (Tabellenfelder) setzen
Given I open an editor "AP59181" from table "(DataExport):(CallParameter)" with command "UPDATE" for record "59181"
And I append rows
    | zielaktion           | zielvar | aufrwtyp | aufrwert |
    | Tabellenfeld setzen  |   oterm | Kopffeld |    tterm |
And I save the current editor

# Ausschreibung neu und Speichern -> Kopierparameter werden ausgefuehrt
Given I open an editor "AUS03" from table "(BiddingProcess):(BiddingProcess)" with command "NEW" for record ""
And I set field "such" to "ANB.AUS3"
# Name der Ausschreibung wird ueber Kopierparameter an betreff des Anfragenkopfes vererbt (AP 59180)
And I set field "name" to "ANB.AUS3 Bezeichnung"
# tterm der Ausschreibung wird ueber Kopierparameter an oterm der Anfrageposition vererbt (AP 59181)
And I set field "tterm" to "13.01.95"
And I append rows
    | tlief  | artikel | mge | anfrposgrp |
    | 60301  |   80001 |   5 |          1 |
    | 60301  |   80002 |   4 |          2 |
And I save the current editor

# Erstellte Anfrage ausgeben
Given I open an editor "ANFERSTELLT" from table "(Purchasing):(Request)" with command "VIEW" for record "$,,@gruppe=21;betreff=ANB.AUS3 Bezeichnung"
Then I fill template "EV_VORG_BEI_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
And I close the current editor

#--------------------------------------------------------------------------------------------
Scenario: TSQ-AUSS_AUS_BV-023: Plausi fuer Feld Beschaffungsart in der Ausschreibung. Muss eindeutig sein.
#--------------------------------------------------------------------------------------------
Given I open an editor "AUS07" from table "(BiddingProcess):(BiddingProcess)" with command "NEW" for record ""
And I set fields
	| such | ANB.AUS7              |
	| name | ANB.AUS7 Bezeichnung  |
# Ohne Zeilen sind die nachfolgenden erlaubt
And I set field "bsart" to "Lohnfertigung"
And I set field "bsart" to "Fremdbeschaffung"
And I create a new row at position 1
And I set field "tlief" to "1" in row 1
# Erwarteter Fehler: Artikel passt nicht zur Beschaffungsart
Then setting field "artikel" to "80003" in row 1 throws the exception "5271"
And I set field "artikel" to "E1" in row 1
And I set field "mge" to "7" in row 1
# Erwarteter Fehler: Eintrag ist schreibgeschuetzt
Then field "bsart" is not modifiable
And I delete row at position 1
# Nun Erlaubt
Then field "bsart" is modifiable
And I set field "bsart" to "Lohnfertigung"
And I create a new row at position 1
And I set field "artikel" to "80003" in row 1
And I set field "tlief" to "1" in row 1
Then field "bestell" is not modifiable in row 1
And I save the current editor

# Ausschreibung ausgeben
Given I open an editor "AUS07V" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record from editor "AUS07"
Then I fill template "EV_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
# Felder mit "Daechle" koennen nicht im Tamplate abgefragt werden
Then table has values
    | tevkopf^bsart    | tevkopf^rechnung | projekt^such |
    | Lohnfertigung    |                  |              |
And I close the current editor


#--------------------------------------------------------------------------------------------
Scenario: TSQ-AUSS_AUS_BV-024: Ausschreibung fuer Dienstleisunten anlegen, Fremdfertigungsartikel dazu erfassen, Zeile fuer neuen Lieferanten kopieren, Anfragen erzeugen, Ausschreibung ausgeben
#--------------------------------------------------------------------------------------------
# BV laden Nur Dienstleistungen und Speichern
# BSArt nachreichen
#
# Test fuer Ausschreibungen zu Dienstleistungen
# BV laden Dienstleistungen, Artikel gemischt
# Kopieren auf anderen Lieferanten
# Speichern
#
Given I open an editor "BV_AENDERN" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I create a new row at position 1
And I set field "artikel" to "29904" in row 1
And I set field "mge" to "2" in row 1
And I set field "he" to "h" in row 1
And I set field "lgruppe" to "HONGKONG" in row 1
And I set field "anfragen" to "ja" in row 1
And I save the current editor

Given I open an editor "BV_AENDERN" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set fields
	| artikel | 29904     |
	| lgruppe | HONGKONG  |
And I press button "ladetab"
And I press button "manfragen" to open a subeditor for "AUS08"
# Ausschreibung aus BV bearbeiten und Anfrage fuer Lieferanten 60302 kopieren
And I set fields
	| such | ANB.AUS8              |
	| name | ANB.AUS8 Bezeichnung  |
	| lief | 60302                 |
And I press button "tkopieren" in row 1
# Erwarteter Fehler: Bitte eintragen (Mussfeld bsart)
Then saving the current editor throws the exception "10179"
And I set field "bsart" to "Fremdbeschaffung"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# Mischen mit Fremdbeschaffungsartikel
Given I open an editor "AUS08" from table "(BiddingProcess):(BiddingProcess)" with command "UPDATE" for record from editor "AUS08"
And I set field "lief" to "60301"
And I press button "tkopieren" in row 1
And I create a new row at position 4
And I set field "artikel" to "E1" in row 4
And I set field "mge" to "2" in row 4
And I set field "tlief" to "60301" in row 4
And I save the current editor

# Ausschreibung ausgeben
Given I open an editor "AUS08V" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record from editor "AUS08"
Then I fill template "EV_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
# Felder mit "Daechle" koennen nicht im Tamplate abgefragt werden
Then table has values
    | tevkopf^bsart    | tevkopf^rechnung | projekt^such |
    | Fremdbeschaffung |                  |              |
    | Fremdbeschaffung |                  |              |
    | Fremdbeschaffung |                  |              |
    | Fremdbeschaffung |                  |              |
And I close the current editor


#--------------------------------------------------------------------------------------------
Scenario: TSQ-AUSS_AUS_BV-030: Ausschreibung aus BV. Anfrage in Fremdwaehrung (USD). Diese wird dem BV zugeordnet und bestellt. -> Bestellung ist in Fremdwaehrung (USD)
#--------------------------------------------------------------------------------------------
# Anfrage in Fremdwaerhung.
# Diese bestellen -> Bestellung zieht die Waehrung aus der Anfrage und nicht aus dem Lieferantenstamm
Given I open an editor "BV_AENDERN" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set fields
	| artikel | E3 |
And I append rows
    | artikel | mge | lief  | anfragen |
    | E3      |   3 | 60301 |       ja |
    | E3      |   5 | 60301 |          |
And I save the current editor

Given I open an editor "BV_AENDERN" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set fields
	| artikel | E3     |
And I press button "ladetab"
And I press button "manfragen" to open a subeditor for "AUS09"
# Ausschreibung aus BV bearbeiten und Anfrage fuer Lieferanten 60302 kopieren
And I set fields
	| such | ANB.AUS9              |
	| name | ANB.AUS9 Bezeichnung  |
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# In Anfrage Preise, Liefertermin und Fremdwaehrung eintragen, Ausschreibung erneut ausgeben
Given I open an editor "ANB.AUS9" from table "(Purchasing):(Request)" with command "UPDATE" for record "$,,@gruppe=21;ausschr==ANB.AUS9"
And I set field "preis" to "10" in row 1
And I set field "wtterm" to "06.01.95" in row 1
And I set field "erfwaehr" to "USD"
And I save the current editor

# Aendern und BV zuordnen
Given I open an editor "AUS09" from table "(BiddingProcess):(BiddingProcess)" with command "UPDATE" for record from editor "AUS09"
And I press button "aufzualle"
And I set field "bvzuord" to "j" in row 2
And I set field "bvzuord" to "j" in row 3
And I save the current editor

# BV ausgeben und pwert ueberpruefen
Given I open an editor "BV_AENDERN" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set fields
	| artikel | E3     |
And I press button "ladetab"
Then I fill template "EV_BV.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
# Felder mit "Daechle" koennen nicht im Tamplate abgefragt werden
And I close the current editor

# Bestellung aus Ausschreibung erzeugen
Given I open an editor "AUS09" from table "(BiddingProcess):(BiddingProcess)" with command "UPDATE" for record from editor "AUS09"
And I set field "sel" to "ja" in row 1
And I press button "bestell" to open a subeditor for "Bestellung" in row 1
# Bestellung oeffnet sich
And I set field "such" to "BAUS9"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# Ausschreibung ausgeben
Given I open an editor "AUS08V" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record from editor "AUS09"
Then I fill template "EV_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
# Felder mit "Daechle" koennen nicht im Tamplate abgefragt werden
Then table has values
    | tevkopf^bsart    | tevkopf^rechnung | projekt^such |
    | Fremdbeschaffung |                  |              |
And I close the current editor

# Erstellte Bestellung ausgeben - Muss mit USD sein
Given I open an editor "BAUS9" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "BAUS9"
Then I fill template "EV_VORG_BEI_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
# Felder mit "Daechle" koennen nicht im Tamplate abgefragt werden
And I close the current editor


#--------------------------------------------------------------------------------------------
# TO DO: <Storno>
Scenario: TSQ-AUSS_AUS_BV-031: Ausschreibung aus LFV. Ausschreibung fuer LFV mit unterschiedlichen Fertigteilen. Guenstigster Preis
#--------------------------------------------------------------------------------------------
# Ausschreibung fuer LFV anlegen, Zeile fuer neuen Lieferanten kopieren, Anfragen erzeugen, Ausschreibung ausgeben
# Lohnfertigungsvorschlaege fuer LF LFANB.ART4 laden und anfragen
Given I open an editor "LV_AENDERN" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
And I set fields
	| artikel | LFANB.ART4 |
And I press button "ladetab"
And I set field "anfragen" to "ja" in row 1
And I set field "anfragen" to "ja" in row 2
And I press button "manfragen" to open a subeditor for "AUS10"
# Ausschreibung aus BV bearbeiten und Anfrage fuer Lieferanten 60302 kopieren
And I set fields
	| such | ANB.AUS10              |
	| name | ANB.AUS10 Bezeichnung  |
	| lief | 60302                 |
And I set field "tlief" to "1" in row 1
And I press button "tkopieren" in row 1
And I set field "tlief" to "1" in row 2
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# Preise in die Anfragen eintragen
Given I open an editor "AN900022" from table "(Purchasing):(Request)" with command "UPDATE" for record "900022"
And I set field "preis" to "12" in row 1
And I set field "preis" to "10" in row 2
And I save the current editor

Given I open an editor "AN900023" from table "(Purchasing):(Request)" with command "UPDATE" for record "900023"
And I set field "preis" to "6" in row 1
And I set field "preis" to "17" in row 2
And I save the current editor

# Ausschreibung ausgeben
Given I open an editor "AUS10V" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record from editor "AUS10"
Then I fill template "EV_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
# Felder mit "Daechle" koennen nicht im Tamplate abgefragt werden
Then table has values
    | tevkopf^bsart    | tevkopf^rechnung | projekt^such |
    | Lohnfertigung    |                  |              |
    | Lohnfertigung    |                  |              |
    | Lohnfertigung    |                  |              |
    | Lohnfertigung    |                  |              |
And I close the current editor


#--------------------------------------------------------------------------------------------
Scenario: TSQ-AUSS_AUS_BV-032: Ausschreibung darf keine ZP enthalten, auch nicht, wenn als erstes eingegeben wird
#--------------------------------------------------------------------------------------------
Given I open an editor "AUS11" from table "(BiddingProcess):(BiddingProcess)" with command "NEW" for record ""
And I set fields
	| such | ANB.AUS11              |
	| name | ANB.AUS11 Bezeichnung  |
And I create a new row at position 1
And I set field "tlief" to "60301" in row 1
# Nur Zusatzpositionen des Typs 'Text' oder 'AU/BE-Position,BV' erlaubt.
Then setting field "artikel" to "UMLAGE" in row 1 throws the exception "8864"
And I set field "artikel" to "TEXT" in row 1
And I set field "projekt" to "PROJ1" in row 1
And I create a new row at position 2
And I set field "tlief" to "60301" in row 2
And I set field "artikel" to "80001" in row 2
And I set field "mge" to "4" in row 2
And I set field "projekt" to "PROJ1" in row 2
And I save the current editor

Given I open an editor "AUS12" from table "(BiddingProcess):(BiddingProcess)" with command "COPY" for record "ANB.AUS11"
And I set fields
	| such | ANB.AUS12              |
	| name | ANB.AUS12 Bezeichnung  |
And I save the current editor

# Ausschreibung ausgeben
Given I open an editor "AUS11V" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record from editor "AUS11"
Then I fill template "EV_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
# Felder mit "Daechle" koennen nicht im Tamplate abgefragt werden
Then table has values
    | tevkopf^bsart    | tevkopf^rechnung | projekt^such |
    | Fremdbeschaffung |                  |        PROJ1 |
    | Fremdbeschaffung |                  |        PROJ1 |
And I close the current editor

# Ausschreibung ausgeben
Given I open an editor "AUS12V" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record from editor "AUS12"
Then I fill template "EV_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
# Felder mit "Daechle" koennen nicht im Tamplate abgefragt werden
Then table has values
    | tevkopf^bsart    | tevkopf^rechnung | projekt^such |
    | Fremdbeschaffung |                  |              |
    | Fremdbeschaffung |                  |              |
And I close the current editor
