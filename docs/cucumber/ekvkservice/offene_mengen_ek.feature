# *****************************************************************************
#  Name           : offene_mengen_ek.feature
#  Verantwortlich : teampss
#  Funktion       : EK-Tests zur Berechnung der offenen Mengen in
#                   Lieferscheinen, Rechnungen, Ruecklieferscheinen und
#                   kaufm. Gutschriften.
#
# *****************************************************************************
#
@persistent
Feature: Aktualisierung remge EK
Background:
Given I set the fake date to "02.01.1995"

#----------------------------------------------------------------------------------------------
Scenario: Stammdaten
#----------------------------------------------------------------------------------------------

Given I open an editor "A100" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such   | A100             |
   | bsart  | Fremdbeschaffung |
   | dispoa | auftragsbezogen  |
   | vpr    | 100              |
   | lief   | 1                |
   | epr    | 100              |
   | fvhe   | 2                |
   | vhe    | kg               |
And I save the current editor

Given I open an editor "A110" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such   | A110             |
   | bsart  | Fremdbeschaffung |
   | dispoa | bedarfsbezogen   |
   | vpr    | 10000            |
   | lief   | 1                |
   | epr    | 9000             |
   | vhe    | kg               |
   | fvhle  | 2                |
   | ehe    | kg               |
   | fehle  | 2                |
And I save the current editor

Given I open an editor "1FB" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | nummer   | 1FB              |
   | such     | FB1              |
   | namebspr | FB1              |
   | bsart    | Fremdbeschaffung |
   | dispoa   | bedarfsbezogen   |
   | fvhle    | 2                |
   | fvple    | 2                |
   | fehle    | 2                |
   | feple    | 2                |
   | le       | kg               |
   | lief     | 1                |
And I save the current editor

Scenario Outline: STAMMDATEN - Zusatzpositionen
Given I open an editor "<zusatzpos>" from table "(Part):(SupplementaryItem)" with command "STORE" for record "<such>"
And I set field "num2" to "<num2>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "zptyp" to "<zptyp>"
And I set field "vkbez" to "<vkbez>"
And I set field "vbez" to "<vbez>"
And I set field "ebez" to "<ebez>"
And I set field "vpr" to "<vpr>"
And I set field "epr" to "<epr>"
And I save the current editor

Examples: Artikel
| num2     | zusatzpos   | such    | namebspr             | zptyp             | vkbez                | vbez                 | ebez                 | vpr         | epr         |
| 1AUBE    | zusatzAUBE  | AUBE    | Zusatzposition AU/BE | AU/BE-Position,BV | Zusatzposition AU/BE | Zusatzposition AU/BE | Zusatzposition AU/BE | 1100        | 1000        |
| 1NEUTRAL | neutralePOS | NEUTRAL | NEUTRAL              | Neutrale Position | Neutrale Position    | Neutrale Position    | Neutrale Position    | 500         | 400         |
| 0NEUTRAL | neutralePOS | NEUTRAL0| NEUTRAL0             | Neutrale Position | Neutrale Position    | Neutrale Position    | Neutrale Position    |  0          | 0           |

#----------------------------------------------------------------------------------------------
# TSQ-OFMGE-01: EK - Aktualisierung der offenen Mengen bei Ruecklieferungen
#----------------------------------------------------------------------------------------------

Scenario: Remge bei buchen RLS, Einheiten im RLS in kg, im LS in Stueck

# Bestellung
Given I open an editor "BE016" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE016  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferschein 016 aus Bestellung
Given I open an editor "LS016" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE016"
And I set fields
   | such   | LS016  |
   | ebeleg | LS016  |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

# Lieferschein 017 neu
Given I open an editor "LS017" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | LS017  |
   | ebeleg | LS017  |
   | vom    | .      |
   | ueb    | ja     |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# RLS zu Lieferschein 016
Given I open an editor "RLS016" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS016"
And I set fields
   | such   | RLS016  |
   | vom    | .       |
And I set field "he" to "kg" in row 1
And I set field "mge" to "-10" in row 1
And I save the current editor

# RLS zu Lieferschein 017
Given I open an editor "RLS017" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS017"
And I set fields
   | such   | RLS017  |
   | vom    | .       |
And I set field "he" to "kg" in row 1
And I set field "mge" to "-10" in row 1
And I save the current editor

Given I open an editor "RLS016" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "RLS016"
And I set field "beleg" to id from editor "LS017"
And I set field "he" to "kg" in row 3
And I set field "mge" to "-10" in row 3
And I save the current editor

Given I open an editor "RLS017" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "RLS017"
And I set field "beleg" to id from editor "LS016"
And I set field "he" to "kg" in row 3
And I set field "mge" to "-10" in row 3
And I save the current editor

Given I open an editor "RLS016V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS016"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS017V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS017"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS016" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "RLS016"
# Rueckliefermenge zu hoch
Then setting field "mge" to "-11" in row 1 throws the exception "3917"
And I set field "mge" to "-6" in row 1
And I set field "mge" to "-4" in row 3
And I save the current editor

Given I open an editor "RLS017" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "RLS017"
# Rueckliefermenge zu hoch
Then setting field "mge" to "-17" in row 1 throws the exception "3917"
And I set field "mge" to "-4" in row 1
And I set field "mge" to "-6" in row 3
And I save the current editor

Given I open an editor "RLS016V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS016"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS017V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS017"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS016" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "RLS016"
And I set field "ueb" to "ja"
And I set field "mge" to "-10" in row 1
And I set field "mge" to "-10" in row 3
And I save the current editor

Given I open an editor "RLS017" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "RLS017"
And I set field "mge" to "-10" in row 1
And I set field "mge" to "-10" in row 3
And I save the current editor

Given I open an editor "RLS016V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS016"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS017V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS017"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS016S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "RLS016"
And I save the current editor

Given I open an editor "RLS016SV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS016S"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS016V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS016"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS017V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS017"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Remge bei buchen RLS, Beleg anfuegen, Loeschen von Zeilen

Given I open an editor "LS018" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | LS018  |
   | ebeleg | LS018  |
   | ueb    | ja     |
   | vom    | .      |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

Given I open an editor "RLS018" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS018"
And I set fields
   | such   | RLS018  |
   | vom    | .       |
And I set field "he" to "kg" in row 1
And I set field "mge" to "-5" in row 1
And I save the current editor

Given I open an editor "RLS018B" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS018"
And I set fields
   | such   | RLS018B |
   | vom    | .       |
And I set field "he" to "kg" in row 1
And I set field "mge" to "-2" in row 1
And I save the current editor

Given I open an editor "RLS018V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS018"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS018BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS018B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS018B" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "RLS018B"
And I delete all rows
And I set field "beleg" to id from editor "LS018"
And I set field "he" to "kg" in row 1
And I set field "mge" to "-2" in row 1
And I save the current editor

Given I open an editor "RLS018V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS018"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS018BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS018B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS018B" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "RLS018B"
And I delete all rows
And I set field "beleg" to id from editor "LS018"
And I set field "he" to "kg" in row 1
And I set field "mge" to "-2" in row 1
And I save the current editor

Given I open an editor "RLS018V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS018"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS018BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS018B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Remge bei buchen RLS, Beleg anfuegen, Loeschen von Zeilen, keine Mengen eintragen

Given I open an editor "LS019" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | LS019  |
   | ebeleg | LS019  |
   | vom    | .      |
   | ueb    | ja     |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

Given I open an editor "RLS019" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS019"
And I set fields
   | such   | RLS019  |
   | vom    | .       |
And I set field "he" to "kg" in row 1
And I set field "mge" to "-5" in row 1
And I save the current editor

Given I open an editor "RLS019B" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS019"
And I set fields
   | such   | RLS019B |
   | vom    | .       |
And I set field "he" to "kg" in row 1
And I set field "mge" to "-2" in row 1
And I save the current editor

Given I open an editor "RLS019V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS019"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS019BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS019B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS019B" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "RLS019B"
And I delete all rows
And I set field "beleg" to id from editor "LS019"
And I delete all rows
And I set field "beleg" to id from editor "LS019"
And I save the current editor

Given I open an editor "RLS019V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS019"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS019BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS019B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

#----------------------------------------------------------------------------------------------
# TSQ-OFMGE-03: EK - Aktualisierung der offenen Mengen bei kaufm. Gutschriften
#----------------------------------------------------------------------------------------------

#                                          +-------------------> KGS001B
#                                         /                      (-4 zu 10)
#                       +--------> RLS001 ----->  KGS001         (-5 zu 11)
#                      /           (10,10,10)     (-4 zu 10)     (-4 zu 12)
# BE001 ------>  LS001 ------>  RE001             (-5 zu 11)
# (10 zu 5)      (10 zu 5)      (8  zu 10)        (-6 zu 12)
# (10 zu 6)      (10 zu 6)      (10 zu 11)
# (10 zu 7)      (10 zu 7)      (12 zu 12)

Scenario: Remge bei buchen KGS

# Bestellung
Given I open an editor "BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE001  |
And I append rows
   | artikel | mge | preis |
   | E2      |  10 |     5 |
   | E2      |  10 |     6 |
   | E2      |  10 |     7 |
And I save the current editor

# Lieferung
Given I open an editor "LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE001"
And I set fields
   | such   | LS001  |
   | ebeleg | LS001  |
   | fakt   | ja     |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I save the current editor

# Rechnung
Given I open an editor "RE001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS001"
And I set fields
   | such   | RE001  |
   | ebeleg | RE001  |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "8" in row 1
And I set field "preis" to "10" in row 1
And I set field "mge" to "10" in row 2
And I set field "preis" to "11" in row 2
And I set field "mge" to "10" in row 3
And I set field "preis" to "12" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS001" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS001"
And I set fields
   | such   | RLS001  |
   | ueb    | true    |
   | vom    | .       |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I save the current editor

# Teilgutschrift 1
Given I open an editor "KGS001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS001"
And I set fields
   | such   | KGS001  |
   | ebeleg | KGS001  |
   | vom    | .       |
   | tterm  | .       |
Then setting field "mge" to "1" in row 1 throws the exception "2024"
Then setting field "mge" to "-9" in row 1 throws the exception "2022"
And I set field "mge" to "-4" in row 1
And I set field "mge" to "-5" in row 2
And I set field "mge" to "-6" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilgutschrift 2
Given I open an editor "KGS001B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS001"
And I set fields
   | such   | KGS001B |
   | ebeleg | KGS001B |
   | vom    | .       |
   | tterm  | .       |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefung Teilgutschrift 1
Given I open an editor "KGS001V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Pruefung Teilgutschrift 2
Given I open an editor "KGS001BV" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS001B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor


#                                          +-----------------> KGS002B
#                                         /                    (-8  zu 10)
#                       +--------> RLS002 -----> KGS002        (-10 zu 11)
#                      /           (voll)        (-8  zu 10    (-8  zu 12)
#                     /                          (-10 zu 11)
# BE002 ------> LS002 ------> RE002              (-12 zu 12)
# (10 zu 5)      (10 zu 5)    (8  zu 10)
# (10 zu 6)      (10 zu 6)    (10 zu 11)
# (10 zu 7)      (10 zu 7)    (12 zu 12)

Scenario: Remge bei buchen KGS, unterschiedliche Einheiten

# Bestellung
Given I open an editor "BE002" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | such   | BE002  |
   | lief   | 1      |
And I append rows
   | artikel | mge | preis | he    |
   | FB1     |  10 |     5 | Stück |
   | FB1     |  10 |     6 | Stück |
   | FB1     |  10 |     7 | Stück |
And I save the current editor

# Lieferung
Given I open an editor "LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE002"
And I set fields
   | such   | LS002  |
   | ebeleg | LS002  |
   | fakt   | ja     |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I save the current editor

# Rechnung
Given I open an editor "RE002" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS002"
And I set fields
   | such   | RE002  |
   | ebeleg | RE002  |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "8" in row 1
And I set field "preis" to "10" in row 1
And I set field "mge" to "10" in row 2
And I set field "preis" to "11" in row 2
And I set field "mge" to "10" in row 3
And I set field "preis" to "12" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS002" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS002"
And I set fields
   | such   | RLS002  |
   | ueb    | true    |
   | vom    | .       |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I save the current editor

# Teilgutschrift 1
Given I open an editor "KGS002" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS002"
And I set fields
   | such   | KGS002  |
   | ebeleg | KGS002  |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
And I set field "he" to "kg" in row 1
And I set field "mge" to "-8" in row 1
And I set field "he" to "kg" in row 2
And I set field "mge" to "-10" in row 2
And I set field "he" to "kg" in row 3
And I set field "mge" to "-12" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilgutschrift 2
Given I open an editor "KGS002B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS002"
And I set fields
   | such   | KGS002B |
   | ebeleg | KGS002B |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
And I set field "he" to "kg" in row 1
And I set field "mge" to "-8" in row 1
And I set field "he" to "kg" in row 2
And I set field "mge" to "-10" in row 2
And I set field "he" to "kg" in row 3
And I set field "mge" to "-8" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefung Teilgutschrift 1
Given I open an editor "KGS002V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS002"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Pruefung Teilgutschrift 2
Given I open an editor "KGS002BV" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS002B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor


# LE des Artikels ist kg -> 1 kg = 2 Stueck (Die Vorgaenge hier sind meist in Stueck)
#
#                                                              (Mengen und HE aendern)
#                                          +-----------------> KGS003B -------------- KGS003B (aendern/buchen)
#                                         /                    (-2 kg zu 10)          (-4 kg zu 10)
#                                        /                     (-5 kg zu 11)          (-3 kg zu 11)
#                                       /                      (-4 kg zu 12)          (-2 kg zu 12)
#                                      /
#                                     /         (Mengen und HE aendern)
#                       +--------> RLS003 ---> KGS003 ------------- KGS003 (aendern) ------ KGS003 (aendern)
#                      /           (-5)        (-4 kg zu 10)        (-2 kg zu 10)           (-6 kg zu 10)
#                     /            (-5)        (-5 kg zu 11)        (-3 kg zu 11)           (-7 kg zu 11)
#                    /             (-5)        (-6 kg zu 12)        (-4 kg zu 12)           (-8 kg zu 12)
#                   /
# BE003 ------> LS003 ----> RE003
# (10 zu 5)      (10 zu 5)    (8  zu 10)
# (10 zu 6)      (10 zu 6)    (10 zu 11)
# (10 zu 7)      (10 zu 7)    (10 zu 12)

Scenario: Remge bei buchen KGS, Teilruecklieferung

# Bestellung
Given I open an editor "BE003" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE003  |
And I append rows
   | artikel | mge | preis | he    |
   | FB1     |  10 |     5 | Stück |
   | FB1     |  10 |     6 | Stück |
   | FB1     |  10 |     7 | Stück |
And I save the current editor

# Lieferung
Given I open an editor "LS003" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE003"
And I set fields
   | such   | LS003  |
   | ebeleg | LS003  |
   | fakt   | ja     |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I save the current editor

# Rechnung
Given I open an editor "RE003" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS003"
And I set fields
   | such   | RE003  |
   | ebeleg | RE003  |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "8" in row 1
And I set field "preis" to "10" in row 1
And I set field "mge" to "10" in row 2
And I set field "preis" to "11" in row 2
And I set field "mge" to "10" in row 3
And I set field "preis" to "12" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilruecklieferung
Given I open an editor "RLS003" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS003"
And I set fields
   | such   | RLS003  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-5" in row 1
And I set field "mge" to "-5" in row 2
And I set field "mge" to "-5" in row 3
And I save the current editor

# Teilgutschrift 1
Given I open an editor "KGS003" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS003"
And I set fields
   | such   | KGS003  |
   | ebeleg | KGS003  |
   | vom    | .       |
   | tterm  | .       |
And I set field "he" to "kg" in row 1
And I set field "mge" to "-4" in row 1
And I set field "he" to "kg" in row 2
And I set field "mge" to "-5" in row 2
And I set field "he" to "kg" in row 3
And I set field "mge" to "-6" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilgutschrift 2
Given I open an editor "KGS003B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS003"
And I set fields
   | such   | KGS003B |
   | ebeleg | KGS003B |
   | vom    | .       |
   | tterm  | .       |
And I set field "he" to "kg" in row 1
And I set field "mge" to "-2" in row 1
And I set field "he" to "kg" in row 2
And I set field "mge" to "-5" in row 2
And I set field "he" to "kg" in row 3
And I set field "mge" to "-4" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilgutschrift 1 aendern
Given I open an editor "KGS003" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS003"
And I set field "mge" to "-2" in row 1
And I set field "mge" to "-3" in row 2
And I set field "mge" to "-4" in row 3
And I save the current editor

# Teilgutschrift 2 aendern, buchen
Given I open an editor "KGS003B" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS003B"
And I set field "ueb" to "ja"
And I delete all rows
And I set field "beleg" to "RLS003"
And I set field "he" to "kg" in row 1
And I set field "mge" to "-4" in row 1
And I set field "he" to "kg" in row 2
And I set field "mge" to "-3" in row 2
And I set field "he" to "kg" in row 3
And I set field "mge" to "-2" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilgutschrift 1 aendern
Given I open an editor "KGS003" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS003"
And I delete all rows
And I set field "beleg" to "RLS003"
And I set field "he" to "kg" in row 1
And I set field "he" to "kg" in row 2
And I set field "he" to "kg" in row 3
And I set field "mge" to "-2" in row 1
Then setting field "mge" to "-3" in row 1 throws the exception "2022"
And I set field "mge" to "-7" in row 2
And I set field "mge" to "-8" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefung (offene Menge in nicht gebuchter GS = 0 )
Given I open an editor "KGS003V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS003"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# In gebuchter GS muss offene Menge aktualisiert werden
Given I open an editor "KGS003BV" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS003B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Remge bei buchen KGS, Loeschen von Zeilen

# Lieferung
Given I open an editor "LS004" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | LS004  |
   | ebeleg | LS004  |
   | vom    | .      |
   | ueb    | ja     |
And I append rows
   | artikel | mge | preis | he    |
   | FB1     |  10 |     5 | Stück |
And I save the current editor

# Rechnung
Given I open an editor "RE004" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS004"
And I set fields
   | such   | RE004  |
   | ebeleg | RE004  |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS004" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS004"
And I set fields
   | such   | RLS004  |
   | ueb    | true    |
   | vom    | .       |
And I set field "mge" to "-10" in row 1
And I save the current editor

# Teilgutschrift 1
Given I open an editor "KGS004" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS004"
And I set fields
   | such   | KGS004  |
   | ebeleg | KGS004  |
   | vom    | .       |
   | tterm  | .       |
And I set field "he" to "kg" in row 1
And I set field "mge" to "-4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilgutschrift 2
Given I open an editor "KGS004B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS004"
And I set fields
   | such   | KGS004B |
   | ebeleg | KGS004B |
   | vom    | .       |
   | tterm  | .       |
And I set field "he" to "kg" in row 1
And I set field "mge" to "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefung offene Menge Teilgutschrift 1
Given I open an editor "KGS004V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS004"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Aenderung Teilgutschrift 2
Given I open an editor "KGS004B" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS004B"
And I delete all rows
And I set field "beleg" to "id" from editor "RLS004"
And I set field "he" to "kg" in row 1
And I set field "mge" to "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefung offene Menge Teilgutschrift 1
Given I open an editor "KGS004V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS004"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Aenderung Teilgutschrift 2
Given I open an editor "KGS004B" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS004B"
And I delete all rows
And I set field "beleg" to "id" from editor "RLS004"
And I set field "he" to "kg" in row 1
And I set field "mge" to "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefung offene Menge Teilgutschrift 1
Given I open an editor "KGS004V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS004"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

#----------------------------------------------------------------------------------------------
# TSQ-OFMGE-05: EK - Aktualisierung der offenen Mengen bei Rechnungen
#----------------------------------------------------------------------------------------------

Scenario: Remge bei buchen RE

Given I open an editor "BE020" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE020  |
   | ebeleg | BE020  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

Given I open an editor "LS020" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | LS020  |
   | ebeleg | LS020  |
   | vom    | .      |
   | ueb    | ja     |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

Given I open an editor "RE020" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE020"
And I set fields
   | such   | RE020  |
   | ebeleg | RE020  |
   | vom    | .      |
   | tterm  | .      |
   | fakt   | nein   |
And I set field "he" to "kg" in row 1
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE021" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS020"
And I set fields
   | such   | RE021  |
   | ebeleg | RE021  |
   | vom    | .      |
And I set field "he" to "kg" in row 1
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE020" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE020"
And I delete row at position !lastRow
And I delete row at position !lastRow
And I delete row at position !lastRow
And I set field "beleg" to id from editor "LS020"
And I set field "he" to "kg" in row 3
And I set field "mge" to "10" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE021" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE021"
And I delete row at position !lastRow
And I delete row at position !lastRow
And I delete row at position !lastRow
And I set field "beleg" to id from editor "BE020"
And I set field "he" to "kg" in row 3
And I set field "mge" to "10" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE020V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE020"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE021V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE021"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE020" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE020"
Then setting field "mge" to "11" in row 1 throws the exception "2810"
And I set field "mge" to "6" in row 1
And I set field "mge" to "4" in row 3
And I save the current editor

Given I open an editor "RE021" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE021"
Then setting field "mge" to "17" in row 1 throws the exception "2810"
And I set field "mge" to "4" in row 1
And I set field "mge" to "6" in row 3
And I save the current editor

Given I open an editor "RE020V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE020"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE021V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE021"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE020" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE020"
And I set field "ueb" to "ja"
And I set field "mge" to "10" in row 1
And I set field "mge" to "10" in row 3
And I save the current editor

Given I open an editor "RE021" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE021"
And I set field "mge" to "10" in row 1
And I set field "mge" to "10" in row 3
And I save the current editor

Given I open an editor "RE020V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE020"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE021V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE021"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE020S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE020"
And I save the current editor

Given I open an editor "RE020SV" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE020S"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE020V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE020"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE021V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE021"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Remge bei buchen RE, Beleg anfuegen, Loeschen von Zeilen

Given I open an editor "LS022" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | LS022  |
   | ebeleg | LS022  |
   | ueb    | ja     |
   | vom    | .      |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

Given I open an editor "RE022" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS022"
And I set fields
   | such   | RE022  |
   | ebeleg | RE022  |
   | vom    | .      |
   | tterm  | .      |
And I set field "he" to "kg" in row 1
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE022B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS022"
And I set fields
   | such   | RE022B |
   | ebeleg | RE022B |
   | vom    | .      |
   | tterm  | .      |
And I set field "he" to "kg" in row 1
And I set field "mge" to "2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE022V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE022"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE022BV" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE022B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE022B" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE022B"
And I delete all rows
And I set field "beleg" to id from editor "LS022"
And I set field "he" to "kg" in row 1
And I set field "mge" to "2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE022V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE022"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE022BV" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE022B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE022B" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE022B"
And I delete all rows
And I set field "beleg" to id from editor "LS022"
And I set field "he" to "kg" in row 1
And I set field "mge" to "2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE022V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE022"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE022BV" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE022B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Remge bei buchen RE, Beleg anfuegen, Loeschen von Zeilen, keine Mengen eintragen

Given I open an editor "LS023" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | LS023  |
   | ebeleg | LS023  |
   | vom    | .      |
   | ueb    | ja     |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

Given I open an editor "RE023" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS023"
And I set fields
   | such   | RE023  |
   | ebeleg | RE023  |
   | vom    | .      |
And I set field "he" to "kg" in row 1
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE023B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS023"
And I set fields
   | such   | RE023B |
   | ebeleg | RE023B |
   | vom    | .      |
And I set field "he" to "kg" in row 1
And I set field "mge" to "2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE023V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE023"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE023BV" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE023B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE023B" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE023B"
And I delete all rows
And I set field "beleg" to id from editor "LS023"
And I delete all rows
And I set field "beleg" to id from editor "LS023"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE023V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE023"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE023BV" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE023B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# ----------------------------------------------------------------------------- #
#                       Fakturierung ueber den Lieferschein                     #
#                       Aktualisierung remge ueberpruefen                       #
# ----------------------------------------------------------------------------- #

#  BE024  ---------- LS024 -------------- RE024
#   10 St.           5 St.                5 St. (1!)
#       \            | Aktion | remge  |
#        \           |        | 5 St.  |
#         \          | (1)    | 0 St.  |
#          \
#            ----------LS024B -------------- RE024B
#                      10 St.                5 St. (2!)
#                      | Aktion | remge  |
#                      |        | 10 St. |
#                      | (2)    |  5 St. |
#                      | (3)    |  5 St. |
#                      | (4)    |  5 St. |
#                            \
#                             \
#                                ------------RLS024B --------------- KGS024
#                               \            -3 St. (3!)             2 St. (5!)
#                                \           | Aktion | remge  |
#                                 \          |        | 0 St.  |
#                                  \         | (4)    | 2 St.  |
#                                   \        | (5)    | 0 St.  |
#                                    \
#                                       ----------- RLS024BB
#                                                   -4 St. (4!)
#                                                   | Aktion | remge  |
#                                                   |        | 2 St.  |
#                                                   | (5)    | 0 St.  |


Scenario: Remge bei RE ueber LS, RLS und KGS buchen

Given I open an editor "BE024" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE024  |
   | ebeleg | BE024  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Ersten Lieferschein aus Bestellung erzeugen
Given I open an editor "LS024" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE024"
And I set fields
   | such   | LS024  |
   | ebeleg | LS024  |
   | vom    | .      |
   | ueb    | true   |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
And I save the current editor

# Zweiten Lieferschein aus Bestellung erzeugen
Given I open an editor "LS024B" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE024"
And I set fields
   | such   | LS024B |
   | ebeleg | LS024B |
   | vom    | .      |
   | ueb    | true   |
Then the table has 1 rows
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnungen zu den Lieferscheinen ueber jeweils 5 Stueck
Given I open an editor "RE024" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS024"
And I set fields
   | such   | RE024   |
   | ebeleg | RE024   |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE024B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS024B"
And I set fields
   | such   | RE024B  |
   | ebeleg | RE024B  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Lieferschein B
Given I open an editor "LS024BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS024B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
And I close the current editor

# Ruecklieferschein 1 zu LS 2
Given I open an editor "RLS024B" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS024B"
And I set fields
   | such   | RLS024B  |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-3" in row 1
And I save the current editor

# Ausgabe Lieferschein B
Given I open an editor "LS024BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS024B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
And I close the current editor

# Ruecklieferschein 2 zu LS 2
Given I open an editor "RLS024BB" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS024B"
And I set fields
   | such   | RLS024BB |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-4" in row 1
And I save the current editor

# Ausgabe Lieferschein B
Given I open an editor "LS024BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS024B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
And I close the current editor

# Ausgabe Ruecklieferschein 1 zu Lieferschein B
Given I open an editor "RLS024BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS024B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "-2" in row 1
And I close the current editor

# Ausgabe Ruecklieferschein 2 zu Lieferschein B
Given I open an editor "RLS024BBV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS024BB"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "-2" in row 1
And I close the current editor

# Teilgutschrift 1 zu RLS 1
Given I open an editor "KGS024" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS024B"
And I set fields
   | such   | KGS024  |
   | ebeleg | KGS024  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Lieferschein A
Given I open an editor "LS024V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS024"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Ausgabe Lieferschein B
Given I open an editor "LS024BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS024B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
# Then field "remge" has value "0" in row 1
And I close the current editor

# Ausgabe Ruecklieferschein 1 zu Lieferschein B
Given I open an editor "RLS024BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS024B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Ausgabe Ruecklieferschein 2 zu Lieferschein B
Given I open an editor "RLS024BBV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS024BB"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor


# ----------------------------------------------------------------------------- #
#         Gleiches wie zuvor, nur mit unterschiedlichen Handelseinheiten        #
# ----------------------------------------------------------------------------- #

Scenario: Remge bei RE ueber LS, RLS und KGS buchen, unterschiedliche HE

Given I open an editor "BE025" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE025  |
   | ebeleg | BE025  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferschein A aus Bestellung erzeugen
Given I open an editor "LS025" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE025"
And I set fields
   | such   | LS025  |
   | ebeleg | LS025  |
   | vom    | .      |
   | ueb    | true   |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
And I save the current editor

# Lieferschein B aus Bestellung erzeugen
Given I open an editor "LS025B" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE025"
And I set fields
   | such   | LS025B |
   | ebeleg | LS025B |
   | vom    | .      |
   | ueb    | true   |
Then the table has 1 rows
# 1 Stueck enstpricht 2 kg
And I set field "he" to "kg" in row 1
And I set field "mge" to "20" in row 1
And I save the current editor

# Rechnungen zu den jeweiligen Lieferscheinen ueber jeweils 5 Stueck: einmal in Einheit "Stueck" und einmal in "kg"
Given I open an editor "RE025" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS025"
And I set fields
   | such   | RE025   |
   | ebeleg | RE025   |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "he" to "Stueck" in row 1
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE025B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS025B"
And I set fields
   | such   | RE025B  |
   | ebeleg | RE025B  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "he" to "kg" in row 1
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein 1 zu LS B
Given I open an editor "RLS025B" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS025B"
And I set fields
   | such   | RLS025B  |
   | ueb    | true     |
   | vom    | .        |
# 1 Stueck enstpricht 2 kg
And I set field "he" to "kg" in row 1
And I set field "mge" to "-6" in row 1
And I save the current editor

# Ruecklieferschein 2 zu LS B (noch nicht buchen)
Given I open an editor "RLS025BB" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS025B"
And I set fields
   | such   | RLS025BB |
   | vom    | .        |
And I set field "he" to "Stueck" in row 1
And I set field "mge" to "-4" in row 1
And I save the current editor

#  Ruecklieferschein 2 zu LS B - aendern und jetzt buchen!
Given I open an editor "RLS025BB" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "RLS025BB"
And I set fields
   | ueb    | true     |
And I save the current editor

# Teilgutschrift 1 zu RLS 1
Given I open an editor "KGS025" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS025B"
And I set fields
   | such   | KGS025  |
   | ebeleg | KGS025  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "he" to "Stueck" in row 1
And I set field "mge" to "-1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Lieferschein A
Given I open an editor "LS025V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS025"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Ausgabe Lieferschein B
Given I open an editor "LS025BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS025B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "10" in row 1
And I close the current editor

# Ausgabe Ruecklieferschein 1 zu Lieferschein B
Given I open an editor "RLS025BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS025B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "-2" in row 1
And I close the current editor

# Ausgabe Ruecklieferschein 2 zu Lieferschein B
Given I open an editor "RLS025BBV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS025BB"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "-1" in row 1
And I close the current editor


# 1. Bestellung anlegen -> Rechnung ohne LB (buchen) ->  Lieferschein 1 & 2 (buchen)-> Lieferschein 2 -> Ruecklieferschein 1 & 2
# -> Kaufm. Gutschrift aus LS 1

#    BE BE027 ----------  RE ohne LB RE027A
#    10 St.               10 St. (1!)
#    | Aktion | remge  |
#    |        | 10 St. |
#    | (1)    |  0 St. |
#    | (2)    |  5 St. |
#    | (3)    |  5 St. |
#    | (4)    |  5 St. |
#            \
#             \
#                -------------- LS LS027A
#               \               5 St.
#                \
#                 \
#                    -------------- LS LS027B (ueberbeliefert)
#                                   10 St. (2!)
#                                     \
#                                      \
#                                         ------------- RLS RLS27B1 --------- KGS RE027G
#                                        \              -3 St. (3!)           -2 St. (5!)
#                                         \           | Aktion | remge  |
#                                          \          | (3)    |  0 St. |
#                                           \         | (4)    | -2 St. |
#                                            \        | (5)    |  0 St. |
#                                             \
#                                                -------------  RLS RLS27B2
#                                                                 -4 St. (4!)
#                                                            | Aktion | remge  |
#                                                            |        | -2 St. |
#                                                            | (5)    |  0 St. |

Scenario: Remge bei RE aus BE, Ueberbelieferung, Teil-RLS, KGS

Given I open an editor "BE027" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1     |
   | such   | BE027 |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Ersten Lieferschein aus Bestellung erzeugen
Given I open an editor "LS027A" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE027"
And I set fields
   | such   | LS027A  |
   | ebeleg | LS027A  |
   | vom    | .       |
   | ueb    | true    |
   | fakt   | false   |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
And I save the current editor

# Rechnungen zum Bestellung ueber 10 Stueck
Given I open an editor "RE027A" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE027"
And I set fields
   | such   | RE027A  |
   | ebeleg | RE027A  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge in Bestellung
Given I open an editor "BE027V" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE027"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Lieferschein A
Given I open an editor "LS027AV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS027A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Zweiten Lieferschein aus Bestellung erzeugen
Given I open an editor "LS027B" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE027"
And I set fields
   | such   | LS027B  |
   | ebeleg | LS027B  |
   | vom    | .       |
   | ueb    | true    |
Then the table has 1 rows
And I set field "mge" to "10" in row 1
And I save the current editor

# Pruefe remge in Bestellung
Given I open an editor "BE027V" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE027"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
And I close the current editor

# Pruefe remge im Lieferschein B
Given I open an editor "LS027B" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS027B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Ruecklieferschein 1 zu LS 2
Given I open an editor "RLS27B1" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS027B"
And I set fields
   | such   | RLS27B1  |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-3" in row 1
And I save the current editor

# Pruefe remge in Bestellung
Given I open an editor "BE027V" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE027"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
And I close the current editor

# Pruefe remge im Lieferschein B
Given I open an editor "13LS027BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS027B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Ruecklieferschein 1
Given I open an editor "1RLS027B1V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS27B1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Ruecklieferschein 2 zu LS 2
Given I open an editor "RLS27B2" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS027B"
And I set fields
   | such   | RLS27B2  |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-4" in row 1
And I save the current editor

# Pruefe remge in Bestellung
Given I open an editor "BE027V" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE027"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
And I close the current editor

# Pruefe remge im Lieferschein B
Given I open an editor "LS027BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS027B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Ruecklieferschein 1 zu Lieferschein B
Given I open an editor "RLS27B1V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS27B1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "-2" in row 1
And I close the current editor

# Pruefe remge im Ruecklieferschein 2 zu Lieferschein B
Given I open an editor "RLS27B1V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS27B1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "-2" in row 1
And I close the current editor

# Gutschrift 1 zu RLS 1
Given I open an editor "RE027G" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS27B1"
And I set fields
   | such   | RE027G  |
   | ebeleg | RE027G  |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
And I set field "mge" to "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge in Bestellung
Given I open an editor "BE027V" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE027"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
And I close the current editor

# Pruefe remge im Lieferschein A
Given I open an editor "LS027AV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS027A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Lieferschein B
Given I open an editor "LS027BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS027B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Ruecklieferschein 1 zu Lieferschein B
Given I open an editor "RLS27B1V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS27B1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Ruecklieferschein 2 zu Lieferschein B
Given I open an editor "RLS27B2V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS27B2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor


# 1. Bestellung anlegen -> Rechnung ohne LB (buchen) ->  Lieferschein 1 & 2 (buchen)-> Lieferschein 2 -> Ruecklieferschein 1 & 2
# -> Kaufm. Gutschrift aus LS 1

#    BE BE028 ------------ RE ohne LB RE028A (Stueck)
#    10 St.                10 St. (1!)
#    | Aktion | remge  |
#    |        | 10 St. |
#    | (1)    | 0 St.  |
#    | (2)    | 5 St.  |
#    | (3)    | 5 St.  |
#    | (4)    | 5 St.  |
#            \
#             \
#                -----------  LS LS028A (Stueck)
#               \             5 St.
#                \
#                 \
#                    -----------  LS LS028B (kg)
#                                 20 kg = 10 St. (2!)
#                                     \
#                                      \
#                                         ----------  RLS RLS028B1 (kg) ------ KGS RE028G (kg)
#                                        \            -6 kg = -3 St. (3!)      -4 kg = -2 St. (5!)
#                                         \           | Aktion | remge  |
#                                          \          |        |  0 kg  |
#                                           \         | (4)    | -4 kg  |
#                                            \        | (5)    |  0 kg  |
#                                             \
#                                                ----------- RLS RLS028B2 (Stueck)
#                                                            -8 kg = -4 St. (4!)
#                                                            | Aktion | remge  |
#                                                            | (4)    | -4 kg  |
#                                                            | (5)    |  0 kg  |
#

Scenario: Remge bei RE aus BE, Ueberbelieferung, Teil-RLS, KGS, verschiedene Einheiten

Given I open an editor "BE028" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1     |
   | such   | BE028 |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Ersten Lieferschein A aus Bestellung erzeugen (Einheit Stueck)
Given I open an editor "LS028A" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE028"
And I set fields
   | such   | LS028A |
   | ebeleg | LS028A |
   | vom    | .      |
   | ueb    | true   |
   | fakt   | false  |
Then the table has 1 rows
And I set field "he" to "Stueck" in row 1
And I set field "mge" to "5" in row 1
And I save the current editor

# Rechnung zum Bestellung ueber 10 Stueck
Given I open an editor "RE028A" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE028"
And I set fields
   | such   | RE028A  |
   | ebeleg | RE028A  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "he" to "Stueck" in row 1
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge in Bestellung
Given I open an editor "BE028V" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE028"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Zweiten Lieferschein B aus Bestellung erzeugen (Einheit kg)
Given I open an editor "LS028B" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE028"
And I set fields
   | such   | LS028B |
   | ebeleg | LS028B |
   | vom    | .      |
   | ueb    | true   |
Then the table has 1 rows
# 1 Stueck enstpricht 2 kg
And I set field "he" to "kg" in row 1
And I set field "mge" to "20" in row 1
And I save the current editor

# Pruefe remge im Bestellung
Given I open an editor "BE028V" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE028"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
And I close the current editor

# Pruefe remge im Lieferschein B
Given I open an editor "1LS028VB" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS028B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Ruecklieferschein 1 zu LS B
Given I open an editor "RLS028B1" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS028B"
And I set fields
   | such   | RLS028B1  |
   | ueb    | true     |
   | vom    | .        |
# Rueckliefern 6 kg
And I set field "mge" to "-6" in row 1
And I save the current editor

# Pruefe remge in Bestellung:
Given I open an editor "BE028V" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE028"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
And I close the current editor

# Pruefe remge im Lieferschein B
Given I open an editor "LS028BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS028B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Ruecklieferschein 2 zu LS B
Given I open an editor "RLS028B2" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS028B"
And I set fields
   | such   | RLS028B2 |
   | ueb    | true     |
   | vom    | .        |
# Rueckliefern 8 kg
And I set field "mge" to "-8" in row 1
And I save the current editor

# Pruefe remge in Bestellung
Given I open an editor "BE028V" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE028"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
And I close the current editor

# Pruefe remge im Lieferschein B
Given I open an editor "1LS028V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS028B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Ruecklieferschein 1 zu Lieferschein B
Given I open an editor "RLS028B1V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS028B1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
# remge in kg -4
Then field "remge" has value "-4" in row 1
And I close the current editor

# Pruefe remge im Ruecklieferschein 2 zu Lieferschein B
Given I open an editor "RLS028B2" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS028B2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
# remge in kg -4
Then field "remge" has value "-4" in row 1
And I close the current editor

# Teilgutschrift 1 zu RLS 1
Given I open an editor "RE028G" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS028B1"
And I set fields
   | such   | RE028G  |
   | ebeleg | RE028G  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "-4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge in Bestellung
Given I open an editor "BE028V" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE028"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
And I close the current editor

# Pruefe remge im Lieferschein A
Given I open an editor "LS028AV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS028A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Lieferschein B
Given I open an editor "LS028BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS028B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Ruecklieferschein 1 zu Lieferschein B
Given I open an editor "RLS028B1V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS028B1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Ruecklieferschein 2 zu Lieferschein B
Given I open an editor "RLS028B2V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS028B2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

#
#    BE BE032
#    10 St.
#    | Aktion | remge  |
#    |        | 10 St. |
#    | (1)    |  5 St. |
#    | (2)    |  0 St. |
#            \
#             \
#                -------------- RE032A mit LB
#               \               5 St. (1!)
#                \
#                 \
#                    -------------- RE032B mit LB (ueberbeliefert)
#                                   10 St. (2!)
#                                   | Aktion | remge  |
#                                   | (2)    | 0 St.  |
#                                     \
#                                      \
#                                         ------------- RLS RLS032 --------- KGS032
#                                        \              -3 St. (3!)           -2 St. (5!)
#                                         \            | Aktion | remge  |
#                                          \           | (3)    | -3 St. |
#                                           \          | (4)    | -3 St. | (Deckelung)
#                                            \         | (5)    | -1 St. | (Deckelung)
#                                             \        | (6)    | -1 St. |
#                                              \
#                                                -------------  RLS RLS032B ---------------KGS032B
#                                                               -4 St. (4!)                0 St. (6!) 0-KGS!
#                                                               | Aktion | remge  |
#                                                               | (4)    | -4 St. | (Deckelung)
#                                                               | (5)    | -4 St. | (Deckelung)
#                                                               | (6)    |  0 St. |

Scenario: Remge bei RE mit Lagerbew, Ueberbelieferung, Teil-RLS, KGS, KGS 0*

Given I create a PurchaseOrder "BE032" for Vendor "1" with Product "V1" and quantity "10"

# Erste RE mit LB erzeugen
Given I open an editor "RE032A" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE032"
And I set fields
   | such   | RE032A  |
   | ebeleg | RE032A  |
   | ueb    | true    |
   | fakt   | true    |
   | vom    | .       |
   | tterm  | .       |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
And I save the current editor
# remge im Bestellung hat sich um 5 verringert
Then field "remge" from editor "BE032" in row 1 has value "5"

# Zweite RE mit LB erzeugen - Ueberlieferung
Given I open an editor "RE032B" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE032"
And I set fields
   | such   | RE032B  |
   | ebeleg | RE032B  |
   | ueb    | true    |
   | fakt   | true    |
   | vom    | .       |
   | tterm  | .       |
Then the table has 1 rows
And I set field "mge" to "10" in row 1
# And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# In gebuchter Re mit LB remge = -mge
Then field "remge" from editor "RE032B" in row 1 has value "-10"
# remge im Bestellung hat sich um 5 verringert
Then field "remge" from editor "BE032" in row 1 has value "0"

# Ruecklieferschein zu RE aus LB
Given I open an editor "RLS032" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RE032B"
And I set fields
   | such   | RLS032   |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-3" in row 1
And I save the current editor

Then field "remge" from editor "RLS032" in row 1 has value "-3"
# Zweiter Ruecklieferschein zu RE aus LB
Given I open an editor "RLS032B" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RE032B"
And I set fields
   | such   | RLS032B  |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-4" in row 1
And I save the current editor

# Remge eigentlich -7, aber auf die mge der RLS gedeckelt
Then field "remge" from editor "RLS032" in row 1 has value "-3"
Then field "remge" from editor "RLS032B" in row 1 has value "-4"

# Gutschrift 1 zu RLS032
Given I open an editor "KGS032" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS032"
And I set fields
   | such   | KGS032  |
   | ebeleg | KGS032  |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
And I set field "mge" to "-2" in row 1
#And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ReMge in RLS gedeckelt
Then field "remge" from editor "RLS032" in row 1 has value "-1"
Then field "remge" from editor "RLS032B" in row 1 has value "-4"

# Gutschrift 2 zu RLS032B - 0*-Gutschrift
Given I open an editor "KGS032B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS032B"
And I set fields
   | such   | KGS032B |
   | ebeleg | KGS032B |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
And I set field "mge" to "0" in row 1
# Wollen Sie diese Position wirklich stornieren?
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
#And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# In gebuchter Re mit LB remge = -mge
Then field "remge" from editor "RE032B" in row 1 has value "-3"
Then field "remge" from editor "RLS032" in row 1 has value "-1"
Then field "remge" from editor "RLS032B" in row 1 has value "0"


# ----------------------------------------------------------------------------- #
#                       Fakturierung ueber die Bestellung                       #
#                       Aktualisierung remge ueberpruefen                       #
# ----------------------------------------------------------------------------- #

# 1. Bestellung anlegen ->  Lieferschein 1 & 2 (buchen) -> Rechnung ohne LB (buchen)
# -> Ruecklieferschein zu Lieferschein 1 buchen -> Kaufm. Gutschrift aus LS 1

#    BE BE026 ----------------- RE RE026A ohne LB
#    10 St.                      6 St. (1!)
#    | Aktion | remge  |
#    |        | 10 St. |
#    | (1)    |  4 St. |
#    | (2)    |  4 St. |
#            \
#             \
#                ---------- LS LS026A
#               \           6 St.
#                \           \
#                 \           \
#                  \            ------------ RLS RLS26A1 ------- KGS RE026G
#                   \                        -5 St. (2!)         -1 St. (3!)
#                    \                      | Aktion | remge  |
#                     \                     | (2)    | -1 St. |
#                      \                    | (3)    |  0 St. |
#                       \
#                        \
#                           ------ LS LS026B
#                                  4 St.
#

Scenario: Remge bei RE aus BE

Given I open an editor "BE026" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE026  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Ersten Lieferschein A aus Bestellung erzeugen
Given I open an editor "LS026A" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE026"
And I set fields
   | such   | LS026A  |
   | ebeleg | LS026A  |
   | ueb    | true    |
   | fakt   | false   |
   | vom    | .       |
Then the table has 1 rows
And I set field "mge" to "6" in row 1
And I save the current editor

# Zweiten Lieferschein B aus Bestellung erzeugen
Given I open an editor "LS026B" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE026"
And I set fields
   | such   | LS026B  |
   | ebeleg | LS026B  |
   | ueb    | true    |
   | vom    | .       |
Then the table has 1 rows
And I set field "mge" to "4" in row 1
And I save the current editor

# Rechnung A zum Bestellung ueber 5 Stueck
Given I open an editor "RE026A" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE026"
And I set fields
   | such   | RE026A  |
   | ebeleg | RE026A  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "6" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge in Bestellung
Given I open an editor "BE026V" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE026"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "4" in row 1
And I close the current editor

# Pruefe remge im Lieferschein A (0, da RE ueber BE)
Given I open an editor "LS026AV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS026A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Ruecklieferschein 1 zu LS 1
Given I open an editor "RLS26A1" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS026A"
And I set fields
   | such   | RLS26B1  |
   | ebeleg | RLS26B1  |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Pruefe remge im Bestellung
Given I open an editor "BE026V" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE026"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "4" in row 1
And I close the current editor

# Pruefe remge im Lieferschein A
Given I open an editor "1LS026V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS026A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Ruecklieferschein 1 zu Lieferschein A
Given I open an editor "1RLS026A1V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS26A1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "-1" in row 1
And I close the current editor

# Gutschrift 1 zu RLS 1
Given I open an editor "RE026G" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS26A1"
And I set fields
   | such   | RE026G  |
   | ebeleg | RE026G  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "-1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge in Bestellung
Given I open an editor "BE026V" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE026"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "4" in row 1
And I close the current editor

# Pruefe remge im Lieferschein A
Given I open an editor "LS026A" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS026A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Lieferschein B
Given I open an editor "LS026B" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS026B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Ruecklieferschein 1 zu Lieferschein B
Given I open an editor "1RLS026A1V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS26A1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# ----------------------------------------------------------------------------- #
#                          Rechnung mit Lagerbewegung                           #
#                       Aktualisierung remge ueberpruefen                       #
# ----------------------------------------------------------------------------- #

#    BE BE029 -------------> RE RE029 mit LB ---> RLS RLS029 -------> KGS KGS029
#    10 St.                  8 St. (1!)           -5 St. (2!)         -1 St. (3!)
#    | Aktion | remge  |     | Aktion | remge     | Aktion | remge
#    |        | 10 St. |     | (1)    | 0 St.     | (2)    | -5 St.
#    | (1)    |  2 St. |                          | (3)    | -4 St.
#
#

Scenario: Remge bei RE mit Lagerbew aus BE

# Bestellung
Given I create a PurchaseOrder "BE029" for Vendor "1" with Product "E2" and quantity "10" and price "5"

# Rechnung mit LB
Given I open an editor "RE029" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE029"
And I set fields
   | such   | RE029  |
   | ebeleg | RE029  |
   | vom    | .      |
   | tterm  | .      |
   | fakt   | ja     |
   | ueb    | ja     |
And I set field "mge" to "8" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung der RE mit LB
Given I open an editor "RLS029" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RE029"
And I set fields
   | such   | RLS029  |
   | ueb    | true    |
   | vom    | .       |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Pruefung Bestellung
Given I open an editor "BE029V" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE029"
Then field "remge" has value "2" in row 1
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Pruefung Rechnung
Given I open an editor "RE029V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE029"
Then field "remge" has value "-3" in row 1
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Pruefung RLS
Given I open an editor "RLS029V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS029"
Then field "remge" has value "-5" in row 1
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Teilgutschrift
Given I open an editor "KGS029" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS029"
And I set fields
   | such   | KGS029  |
   | ebeleg | KGS029  |
   | ueb    | ja      |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "-1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefung Bestellung (Keine Auswirkung)
Given I open an editor "BE029V" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE029"
Then field "remge" has value "2" in row 1
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Pruefung Rechnung
Given I open an editor "RE029V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE029"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Pruefung RLS
Given I open an editor "RLS029V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS029"
Then field "remge" has value "-4" in row 1
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# -----------------------------------------------------------------------------
#          Deckelung der offenen Rechnungsmenge im Ruecklieferschein
#             Die Positionsmenge darf nicht ueberschritten werden
# -----------------------------------------------------------------------------

#
#    BE033 --------------> RE033A mit LB
#    10 St.                5 St. (1!)
#    | Aktion | remge  |
#    |        | 15 St. |
#    | (1)    | 10 St. |
#    | (2)    |  0 St. |
#        \
#         ------------------> RE033 it LB ----------> RLS033 --------------> KGS033
#                             20 kg = 10 St. (2!)      -4 St. (3!)           -4 kg (5!)
#                             | Aktion | remge  |     | Aktion | remge  |
#                             | (2)    | 0 St.  |     | (3)    | -4 St. |
#                               \                     | (4)    | -4 St. | (Deckelung)
#                                \                    | (5)    | -2 St. | (Deckelung)
#                                 \                   | (6)    | -2 St. | (Deckelung)
#                                  \
#                                   \
#                                   -------------------------> RLS033B ---------------------> KGS033B
#                                                              -12kg = 6 St. (4!)             0 St. (6!) 0-KGS!
#                                                              | Aktion | remge  |
#                                                              | (4)    | -12 kg | (Deckelung)
#                                                              | (5)    | -12 kg | (Deckelung)
#                                                              | (6)    |   0 kg |

Scenario: Remge bei RE mit Lagerbew, Teil-RLS, KGS, KGS 0*, Unterschiedliche Einheiten

# Bestellung anlegen
Given I create a PurchaseOrder "BE033" for Vendor "1" with Product "A100" and quantity "15"

# Rechnung mit LB
Given I open an editor "RE033A" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE033"
And I set fields
   | such   | RE033A |
   | ebeleg | RE033A |
   | vom    | .      |
   | tterm  | .      |
   | fakt   | ja     |
   | ueb    | ja     |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "BE033" in row 1 has value "10"

# 2. Rechnung mit LB in kg
Given I open an editor "RE033" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE033"
And I set fields
   | such   | RE033  |
   | ebeleg | RE033  |
   | vom    | .      |
   | tterm  | .      |
   | fakt   | ja     |
   | ueb    | ja     |
And I set field "he" to "kg" in row 1
And I set field "mge" to "20" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "BE033" in row 1 has value "0"

# Teil-Ruecklieferung der RE mit LB (in Stück)
Given I open an editor "RLS033" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RE033"
And I set fields
   | such   | RLS033  |
   | ueb    | true    |
   | vom    | .       |
And I set field "he" to "Stück" in row 1
And I set field "mge" to "-4" in row 1
And I save the current editor
Then field "remge" from editor "RLS033" in row 1 has value "-4"

# 2. Teil-Ruecklieferung der RE mit LB (in kg)
Given I open an editor "RLS033B" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RE033"
And I set fields
   | such   | RLS033B |
   | ueb    | true    |
   | vom    | .       |
And I set field "he" to "kg" in row 1
And I set field "mge" to "-12" in row 1
And I save the current editor

# -12 kg
Then field "remge" from editor "RLS033B" in row 1 has value "-12"
# -4 Stück (gedeckelt)
Then field "remge" from editor "RLS033" in row 1 has value "-4"

# Teilgutschrift
Given I open an editor "KGS033" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS033"
And I set fields
   | such   | KGS033  |
   | ebeleg | KGS033  |
   | ueb    | ja      |
   | vom    | .       |
   | tterm  | .       |
And I set field "he" to "kg" in row 1
And I set field "mge" to "-4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# -2 Stück (gedeckelt)
Then field "remge" from editor "RLS033" in row 1 has value "-2"
# -12 kg (gedeckelt)
Then field "remge" from editor "RLS033B" in row 1 has value "-12"

# 2. Gutschrift 0*-Gutschrift
Given I open an editor "KGS033B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS033B"
And I set fields
   | such   | KGS033B |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
And I set field "he" to "Stück" in row 1
And I set field "mge" to "0" in row 1
# Wollen Sie diese Position wirklich stornieren?
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
#And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# -0 kg (gedeckelt) -Abgeschlossen
Then field "remge" from editor "RLS033B" in row 1 has value "0"
# -2 Stück (gedeckelt)
Then field "remge" from editor "RLS033" in row 1 has value "-2"

# -----------------------------------------------------------------------------
# Verschiedene Einheiten:
# 1 kg (Handelseinheit) = 2 Stueck (Lagereinheit)
# -----------------------------------------------------------------------------

#   BE030  -------------- RE030 ohne LB
#   10 kg                 10 St. (1!)
#  | Aktion | remge  |
#  |        | 10 kg  |
#  | (1)    |  5 kg  |
#          \
#           \
#            \
#              --------------- LS030-1
#              \               6 kg (2!)
#               \             | Aktion | remge  |
#                \            | (2)    | 0 St.  |
#                 \                   \
#                  \                   \
#                   \                    -------------- RLS030-1
#                    \                                 -6 kg (3!)
#                     \                               | Aktion | remge    |
#                      \                              | (3)    | -1 kg    |
#                       \                             | (4)    | -4 kg    |
#                        \                            | (5)    | -2.5 kg  |
#                         \
#                           ----------- LS030-2
#                                       6 St. (3!)
#                                   | Aktion | remge  |
#                                   | (3)    | 0 St.  |
#                                           \
#                                            \
#                                              ---------------- RLS030-2 -------------- KGS030
#                                                              -6 St. (4!)             -3 St. (5!)
#                                                             | Aktion | remge  |
#                                                             | (4)    | -6 St. | (Deckelung)
#                                                             | (5)    | -3 St. |
#

Scenario: Deckelung der offenen Rechnungsmenge im Ruecklieferschein

Given I open an editor "BE030" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1     |
   | such   | BE030 |
And I append rows
   | artikel | mge |
   | A110    | 10  |
And I save the current editor

# Rechnung aus Aufrag mit Menge 10 Stueck erzeugen, buchen, fakt = FALSE
Given I open an editor "RE030" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg | BE030 |
   | such  | RE030 |
   | ebeleg| RE030 |
   | ueb   | ja    |
   | fakt  | nein  |
   | tterm | .     |
   | vom   | .     |
Then the table has 1 rows
And I set field "mge" to "10" in row 1
And I set field "he" to "Stück" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein mit Menge 6 kg erzeugen und buchen
Given I open an editor "LS030-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | beleg  | BE030   |
   | such   | LS030-1 |
   | ebeleg | LS030-1 |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "6" in row 1
And I save the current editor

# Lieferschein mit Menge 6 Stueck erzeugen und buchen
Given I open an editor "LS030-2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | beleg  | BE030   |
   | such   | LS030-2 |
   | ebeleg | LS030-1 |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "6" in row 1
And I set field "he" to "Stück" in row 1
And I save the current editor

# Ruecklieferschein zu Lieferschein 1 erzeugen und buchen
Given I open an editor "RLS030-1" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS030-1"
And I set fields
   | such  | RLS030-1 |
   | ueb   | ja       |
And I set field "mge" to "-6" in row 1
And I save the current editor

Given I open an editor "RLS030-1" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS030-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Ruecklieferschein zu Lieferschein 2 erzeugen und buchen
Given I open an editor "RLS030-2" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS030-2"
And I set fields
   | such  | RLS030-2 |
   | ueb   | ja       |
And I set field "mge" to "-6" in row 1
And I save the current editor
Then field "remge" has value "-6" in row 1

# Ausgabe der Vorgaenge im Endzustand
Given I open an editor "RLS030-1" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS030-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS030-2" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS030-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Teilgutschrift
Given I open an editor "KGS030" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS030-2"
And I set fields
   | such   | KGS030  |
   | ebeleg | KGS030  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "-3" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
Then field "remge" from editor "RLS030-1" in row 1 has value "-2.5"

Given I open an editor "RLS030-1" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS030-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS030-2" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS030-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS030" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS030"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# -----------------------------------------------------------------------------
# Rechnung mit LB, Storno RE, remge in Bestellung pruefen
# 1 kg (Handelseinheit) = 2 Stueck (Lagereinheit)
# -----------------------------------------------------------------------------

Scenario: Bestellung ueber 10 Kilo, 2 Rechnungen mit LB mit unterschiedlichen Einheiten gebucht, Storno RE1

Given I open an editor "BE030B" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE030B |
And I append rows
   | artikel | mge |
   | A110    | 10  |
And I save the current editor

# limge in Bestellung ist 10, remge ist 10
Then field "limge" from editor "BE030B" in row 1 has value "10"
Then field "remge" from editor "BE030B" in row 1 has value "10"

# Rechnung 1 mit LB aus BE in KG
Given I open an editor "RE030B1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg | BE030B    |
   | ebeleg| Rechnung1 |
   | such  | RE030B1   |
   | ueb   | ja        |
   | fakt  | ja        |
   | tterm | .         |
   | vom   | .         |
Then the table has 1 rows
And I set field "mge" to "3" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# limge in Bestellung ist 7, remge ist 7
Then field "limge" from editor "BE030B" in row 1 has value "7"
Then field "remge" from editor "BE030B" in row 1 has value "7"

# Rechnung 2 mit LB aus BE in Stueck
Given I open an editor "RE030B2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg | BE030B    |
   | ebeleg| Rechnung2 |
   | such  | RE030B2   |
   | ueb   | ja        |
   | fakt  | ja        |
   | tterm | .         |
   | vom   | .         |
Then the table has 1 rows
And I set field "he" to "Stück" in row 1
And I set field "mge" to "10" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# limge in Bestellung ist 2, remge ist 2
Then field "limge" from editor "BE030B" in row 1 has value "2"
Then field "remge" from editor "BE030B" in row 1 has value "2"

Given I open an editor "SRE030B1" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE030B1"
And I save the current editor

# limge in Bestellung ist 5, remge ist 5
Then field "limge" from editor "BE030B" in row 1 has value "5"
Then field "remge" from editor "BE030B" in row 1 has value "5"

# -----------------------------------------------------------------------------
# Rechnung mit LB, Storno RE, remge in Bestellung pruefen
# -----------------------------------------------------------------------------

Scenario: Bestellung ueber 12 Stueck, 2 Rechnungen ueber 5 und 7 Stueck mit LB, Storno RE1

Given I open an editor "BE030C" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE030C |
And I append rows
   | artikel | mge |
   | A100    | 12  |
And I save the current editor

# limge in Bestellung ist 12, remge ist 12
Then field "limge" from editor "BE030C" in row 1 has value "12"
Then field "remge" from editor "BE030C" in row 1 has value "12"

# Rechnung 1 mit LB aus BE in Stueck
Given I open an editor "RE030C1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg | BE030C    |
   | ebeleg| Rechnung1 |
   | such  | RE030C1   |
   | ueb   | ja        |
   | fakt  | ja        |
   | tterm | .         |
   | vom   | .         |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# limge in Bestellung ist 7, remge ist 7
Then field "limge" from editor "BE030C" in row 1 has value "7"
Then field "remge" from editor "BE030C" in row 1 has value "7"

# Rechnung 2 mit LB aus BE in Stueck
Given I open an editor "RE030C2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg | BE030C    |
   | ebeleg| Rechnung2 |
   | such  | RE030C2   |
   | ueb   | ja        |
   | fakt  | ja        |
   | tterm | .         |
   | vom   | .         |
Then the table has 1 rows
And I set field "mge" to "7" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# limge in Bestellung ist 2, remge ist 2
Then field "limge" from editor "BE030C" in row 1 has value "0"
Then field "remge" from editor "BE030C" in row 1 has value "0"

Given I open an editor "SRE030C1" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE030C1"
And I save the current editor

# limge in Bestellung ist 5, remge ist 5
Then field "limge" from editor "BE030C" in row 1 has value "5"
Then field "remge" from editor "BE030C" in row 1 has value "5"


# -----------------------------------------------------------------------------
# Rechnung 1 mit LB, Rechnung 2 ohne LB Storno RE, remge in Bestellung pruefen
# -----------------------------------------------------------------------------

Scenario: Bestellung ueber 12 Stueck, 2 Rechnungen ueber 5 und 7 Stueck mit LB, Storno RE1

Given I open an editor "BE030D" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE030D |
And I append rows
   | artikel | mge |
   | A100    | 12  |
And I save the current editor

# limge in Bestellung ist 12, remge ist 12
Then field "limge" from editor "BE030D" in row 1 has value "12"
Then field "remge" from editor "BE030D" in row 1 has value "12"

# Rechnung 1 mit LB aus BE in Stueck
Given I open an editor "RE030D1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg | BE030D    |
   | ebeleg| Rechnung1 |
   | such  | RE030D1   |
   | ueb   | ja        |
   | fakt  | ja        |
   | tterm | .         |
   | vom   | .         |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# limge in Bestellung ist 7, remge ist 7
Then field "limge" from editor "BE030D" in row 1 has value "7"
Then field "remge" from editor "BE030D" in row 1 has value "7"

# Rechnung 2 ohne LB aus BE in Stueck
Given I open an editor "RE030D2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg | BE030D    |
   | ebeleg| Rechnung2 |
   | such  | RE030D2   |
   | ueb   | ja        |
   | tterm | .         |
   | vom   | .         |
Then the table has 1 rows
And I set field "mge" to "7" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# limge in Bestellung ist 2, remge ist 2
Then field "limge" from editor "BE030D" in row 1 has value "0"
Then field "remge" from editor "BE030D" in row 1 has value "0"

Given I open an editor "SRE030D1" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE030D1"
And I save the current editor

# limge in Bestellung ist 5, remge ist 5
Then field "limge" from editor "BE030D" in row 1 has value "5"
Then field "remge" from editor "BE030D" in row 1 has value "5"


#
#   LS031 ----------------- RE031
#   10 St.                  10 St. (1!)
#  | Aktion | remge  |
#  | (1)    | 0 St.  |
#          \
#           \
#             ------------------ RLS031-1 -------------- KGS031
#             \                 -4 St. (2!)             -2 St. (3!)
#              \               | Aktion | remge  |
#               \              | (2)    | -4 St. |
#                \             | (3)    | -2 St. |
#                 \            | (4)    | -2 St. | (Deckelung)
#                  \
#                   \
#                     ------------------------------------------ RLS031-2
#                                                               -4 St. (4!)
#                                                              | Aktion | remge  |
#                                                              | (4)    | -4 St. | (Deckelung)
#

Scenario: Deckelung der offenen Rechnungsmenge im Ruecklieferschein II

# Lieferung
Given I open an editor "LS031" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | LS031  |
   | ebeleg | LS031  |
   | vom    | .      |
   | ueb    | ja     |
And I append rows
   | artikel | mge |
   | A100    |  10 |
And I save the current editor

# Rechnung
Given I open an editor "RE031" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS031"
And I set fields
   | such   | RE031  |
   | ebeleg | RE031  |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung 1
Given I open an editor "RLS031-1" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS031"
And I set fields
   | such   | RLS031-1 |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-4" in row 1
And I save the current editor

# Teilgutschrift 1
Given I open an editor "KGS031" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS031-1"
And I set fields
   | such   | KGS031  |
   | ebeleg | KGS031  |
   | vom    | .       |
   | ueb    | true    |
And I set field "mge" to "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung 2
Given I open an editor "RLS031-2" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS031"
And I set fields
   | such   | RLS031-2 |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-4" in row 1
And I save the current editor

Given I open an editor "RLS031-1" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS031-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS031-2" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS031-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# ----------------------------------------------------------------------------- #
#                             Teil-RLS, KGS, KGS 0*			                    #
# ----------------------------------------------------------------------------- #

#
#     BE034 ------------------  LS034 ----------------  RE034
#     10 St.                    6 St.                   6 St. (1!)
#    | Aktion | remge  |       | Aktion | remge  |
#    |        |  0 St. |       |        | 6 St.  |
#    | (4)    |  4 St. |       | (1)    | 0 St.  |
#    | (5)    |  1 St. |         \
#      \                          \
#       \                           ------------- RLS RLS034 --------- KGS034
#        \                                         -1 St. (2!)           0 St. (3!) 0-KGS!
#         \                                       | Aktion | remge  |
#          \                                      |        | -1 St. |
#           \                                     | (3)    |  0 St. |
#            \
#             \
#                -------------- LS034B  -------------  RLS RLS034B
#               \               4 St. (4!)              -4 St. (6!)
#                \                                      | Aktion | remge  |
#                 \                                     | (4)    | -3 St. |
#                    ------------------ RE034B
#                                     3 St. (5!)
#

Scenario: BE -> LS -> RE + RLS -> KGS 0*, BE -> LSB + REB, LSB -> RLSB

# Bestellung anlegen
Given I open an editor "BE034" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "such" to "BE034"
And I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

# Lieferschein mit Menge 6 erzeugen und buchen
Given I open an editor "LS034" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE034"
And I set fields
   | such   | LS034  |
   | ebeleg | LS034  |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "6" in row 1
And I save the current editor

# Rechnung aus Lieferschein erzeugen
Given I open an editor "RE034" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS034"
And I set fields
   | such   | RE034   |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
Then the table has 1 rows
And I set field "mge" to "6" in row 1
And I save the current editor

# Ruecklieferschein mit Menge -1 erzeugen und buchen
Given I open an editor "RLS034" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS034"
And I set fields
   | such   | RLS034   |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-1" in row 1
And I save the current editor

# KGS mit Menge 0 erzeugen, status setzen und buchen
Given I open an editor "KGS034" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS034"
And I set fields
   | such   | KGS034  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "0" in row 1
And I respond with answer "Ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I save the current editor

# Ruecklieferschein aufrufen und pruefen, ob er in der Ablage ist
Given I open an editor "RLS034" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS034"
Then field "ablagef" has value "ja"
Then field "remge" has value "0" in row 1
And I close the current editor

# Lieferschein aus Bestellung mit Restmenge erzeugen und fakt auf FALSE setzen
Given I open an editor "LS034B" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE034"
And I set fields
	| such   | LS034B |
	| ebeleg | LS034B |
	| fakt   | nein   |
	| vom    | .      |
	| ueb    | ja     |
And I set field "mge" to "4" in row 1
And I save the current editor

# Rechnung aus Bestellung mit Menge 3 erzeugen und buchen
Given I open an editor "RE034B" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE034"
And I set fields
   | such   | RE034B  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "3" in row 1
And I save the current editor

# remge in Bestellung hat sich um 3 verringert
Then field "remge" from editor "BE034" in row 1 has value "1"

# Ruecklieferschein aus Lieferschein erzeugen
Given I open an editor "RLS034B" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS034B"
And I set fields
   | such   | RLS034   |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-4" in row 1
And I save the current editor
Then field "remge" has value "-3" in row 1


# In Bestellung und erster Ruecklieferung remge = 0
Then field "remge" from editor "BE034" in row 1 has value "1"
Then field "remge" from editor "RLS034" in row 1 has value "0"

#-----------------------------------------------------------------------------------------
# TSQ-OFMGE-07: EK - Aktualisierung der offenen Mengen im Storno Fall
#-----------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------- #
#                       Fakturierung ueber die Bestellung                       #
#                       Aktualisierung remge ueberpruefen                       #
# ----------------------------------------------------------------------------- #

# 1. Bestellung anlegen ->  Lieferschein (RE aus BE) A & B (buchen) -> Rechnung ohne LB (buchen)
# -> Ruecklieferschein zu Lieferschein 1 buchen
# -> Rechnung stornieren

#    BE035 ---------------------- RE035A ohne LB ---------- SRE035
#    10 St.                       6 St. (1!)                -6 St. (3!)
#    | Aktion | remge  |          | Aktion | remge  |       | Aktion | remge  |
#    |        | 10 St. |          |        |  0 St. |       |        |  0 St. |
#    | (1)    |  4 St. |
#    | (2)    |  4 St. |
#    | (3)    | 10 St. |
#         \
#          \
#             -------- LS035A
#            \         6 St.
#             \        | Aktion | remge  |
#              \       |        |  0 St. |
#               \          \
#                \          \
#                 \           ------------- RLS35A1
#                  \                        -5 St. (2!)
#                   \                       | Aktion | remge  |
#                    \                      | (2)    | -1 St. |
#                     \                     | (3)    |  0 St. |
#                      \
#                       \
#                         --- LS035B
#                             4 St.
#                             | Aktion | remge  |
#                             |        |  0 St. |

Scenario: Remge beim Storno der Rechnung, RE aus BE

Given I open an editor "BE035" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE035  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferschein 35A aus Bestellung erzeugen
Given I open an editor "LS035A" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE035"
And I set fields
   | such   | LS035A |
   | ebeleg | LS035A |
   | ueb    | true   |
   | fakt   | false  |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "6" in row 1
And I save the current editor

# Lieferschein 35B aus Bestellung erzeugen
Given I open an editor "LS035B" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE035"
And I set fields
   | such   | LS035B |
   | ebeleg | LS035B |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "4" in row 1
And I save the current editor

# Rechnung A zur Bestellung ueber 6 Stueck
Given I open an editor "RE035A" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE035"
And I set fields
   | such   | RE035A |
   | ebeleg | RE035A |
   | ueb    | true   |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "6" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein A1 zu LS A
Given I open an editor "RLS035A1" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS035A"
And I set fields
   | such   | RLS035A |
   | ebeleg | RLS035A |
   | ueb    | true    |
   | vom    | .       |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Rechnung A stornieren
Given I open an editor "SRE035" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE035A"
And I save the current editor

# Pruefe remge in Bestellung
Then field "remge" from editor "BE035" in row 1 has value "10"
# Pruefe remge im Ruecklieferschein
Then field "remge" from editor "RLS035A1" in row 1 has value "0"


#    BE036 -------------------- RE036 ohne LB
#    10 St.                     7 St. (1!)
#    | Aktion | remge |
#    |        | 10 St.|
#    | (1)    |  3 St.|
#    | (2)    |  3 St.|
#    | (3)    |  3 St.|
#           \
#            \
#              ------ LS036A ------------------------ SLS036A
#              \       6 St.                          -6 St. (3!)
#               \     | Aktion | remge |
#                \    |        |  0 St.|
#                 \
#                  \
#                    --- LS036B
#                         4 St.
#                        | Aktion | remge |
#                        |        |  0 St.|
#                          \
#                           \
#                             -------- RLS036B
#                                      -2 St. (2!)
#                                     | Aktion | remge |
#                                     |        |  0 St.|

Scenario: Remge beim Storno des LS, RE aus BE

Given I open an editor "BE036" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE036  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferschein 36A aus Bestellung erzeugen
Given I open an editor "LS036A" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE036"
And I set fields
   | such   | LS036A |
   | ebeleg | LS036A |
   | ueb    | true   |
   | fakt   | false  |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "6" in row 1
And I save the current editor

# Lieferschein 36B aus Bestellung erzeugen
Given I open an editor "LS036B" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE036"
And I set fields
   | such   | LS036B |
   | ebeleg | LS036B |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "4" in row 1
And I save the current editor

# Rechnung 36A zur Bestellung ueber 7 Stueck
Given I open an editor "RE036A" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE036"
And I set fields
   | such   | RE036A |
   | ebeleg | RE036A |
   | ueb    | true   |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "7" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge in Bestellung
Then field "remge" from editor "BE036" in row 1 has value "3"

# Ruecklieferschein 36B zum LS 36B
Given I open an editor "RLS036B" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS036B"
And I set fields
   | such   | RLS036B |
   | ebeleg | RLS036B |
   | ueb    | true    |
   | vom    | .       |
And I set field "mge" to "-2" in row 1
And I save the current editor

# Pruefe remge in Bestellung
Then field "remge" from editor "BE036" in row 1 has value "3"

# Lieferschein 36A stornieren
Given I open an editor "SLS036A" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "LS036A"
And I save the current editor

# Pruefe remge in Bestellung
Then field "remge" from editor "BE036" in row 1 has value "3"



#    BE037 ---------------------- RE037A ohne LB
#    10 St.                       6 St. (1!)
#    | Aktion | remge  |
#    |        | 10 St. |
#    | (1)    |  4 St. |
#    | (2)    |  4 St. |
#    | (3)    |  4 St. |
#           \
#            \
#              -------- LS037A
#              \        6 St.
#               \          \
#                \          \
#                 \           ------------- RLS37A1 --------------- SRLS37A1
#                  \                        -5 St. (2!)   		    -5 St. (3!)
#                   \                       | Aktion | remge  |
#                    \                      | (2)    | -1 St. |
#                     \                     | (3)    |  0 St. |
#                      \
#                       \
#                         --- LS037B
#                             4 St.
#

Scenario: Remge beim Storno des RLS, RE aus BE

Given I open an editor "BE037" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE0367 |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferschein 37A aus Bestellung erzeugen
Given I open an editor "LS037A" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE037"
And I set fields
   | such   | LS037A |
   | ebeleg | LS037A |
   | ueb    | true   |
   | fakt   | false  |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "6" in row 1
And I save the current editor

# Lieferschein 37B aus Bestellung erzeugen
Given I open an editor "LS037B" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE037"
And I set fields
   | such   | LS037B |
   | ebeleg | LS037B |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "4" in row 1
And I save the current editor

# Rechnung 37A zur Bestellung ueber 7 Stueck
Given I open an editor "RE037A" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE037"
And I set fields
   | such   | RE037A |
   | ebeleg | RE037A |
   | ueb    | true   |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "6" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge in Bestellung
Then field "remge" from editor "BE037" in row 1 has value "4"

# Ruecklieferschein 37A zum LS 37A
Given I open an editor "RLS037A" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS037A"
And I set fields
   | such   | RLS037B |
   | ebeleg | RLS037B |
   | ueb    | true    |
   | vom    | .       |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Pruefe remge in Bestellung
Then field "remge" from editor "BE037" in row 1 has value "4"

# Ruecklieferschein stornieren
Given I open an editor "SRLS037A" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "RLS037A"
And I save the current editor

# Pruefe remge in Bestellung
Then field "remge" from editor "BE037" in row 1 has value "4"



#    BE038 ---------------------- RE038A ohne LB
#    10 St.                       7 St. (1!)
#    | Aktion | remge  |
#    |        | 10 St. |
#    | (1)    |  3 St. |
#    | (2)    |  3 St. |
#    | (3)    |  3 St. |
#    | (4)    |  3 St. |
#           \
#            \
#              -------- LS038A
#                       10 St.
#                          \
#                           \
#                             ------------ RLS38A1 -------------- KGS38A1 -------- SKGS358
#                                          -5 St. (2!)   		  -1 St. (3!)      -5 St. (4!)
#                                          | Aktion | remge  |
#                                          | (2)    | -2 St. |
#                                          | (3)    | -1 St. |
#                                          | (4)    | -2 St. |
#

Scenario: Remge beim Storno der KGS, RE aus BE

Given I open an editor "BE038" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1     |
   | such   | BE038 |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferschein 38A aus Bestellung erzeugen
Given I open an editor "LS038A" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE038"
And I set fields
   | such   | LS038A |
   | ebeleg | LS038A |
   | ueb    | true   |
   | fakt   | false  |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung 38A zur Bestellung ueber 7 Stueck
Given I open an editor "RE038A" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE038"
And I set fields
   | such   | RE038A |
   | ebeleg | RE038A |
   | ueb    | true   |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "7" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge in Bestellung
Then field "remge" from editor "BE038" in row 1 has value "3"

# Ruecklieferschein 38A zum LS 38A
Given I open an editor "RLS038A" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS038A"
And I set fields
   | such   | RLS038A |
   | ebeleg | RLS038A |
   | ueb    | true    |
   | vom    | .       |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Pruefe remge in Bestellung
Then field "remge" from editor "BE038" in row 1 has value "3"

# Kaufm. Gutschrift zum Ruecklieferschein RLS038A
Given I open an editor "KGS038" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS038A"
And I set fields
   | such   | KGS038A |
   | ebeleg | KGS038A |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
And I set field "mge" to "-1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge im Ruecklieferschein
Then field "remge" from editor "RLS038A" in row 1 has value "-1"

# Kaufm. Gutschrift stornieren
Given I open an editor "SKGS038" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KGS038"
And I save the current editor

# Pruefe remge in Bestellung
Then field "remge" from editor "BE038" in row 1 has value "3"
# Pruefe remge im Ruecklieferschein
Then field "remge" from editor "RLS038A" in row 1 has value "-2"

# Bestellung anlegen ->  Lieferschein (RE aus BE) (buchen) -> Rechnung ohne LB (buchen)
# -> Ruecklieferschein zu Lieferschein buchen -> Gutschrift aus RLS
# -> Storno Gutschrift- > Storno Ruecklieferschein
# -> Storno Rechnung -> Storno Lieferschein

#    BE043 ----------------- RE043 ohne LB ----------- SRE043
#     9 St.                  6 St. (2!)               -6 St. (7!)
#    | Aktion | remge  |     | Aktion | remge  |         | Aktion | remge  |
#    |        |  9 St. |     |        |  0 St. |         |        |  0 St. |
#    | (1)    | 10 St. |
#    | (2)    |  4 St. |
#    | (3)    |  4 St. |
#    | (6)    |  4 St. |
#    | (7)    | 10 St. |
#    | (8)    |  9 St. |
#       \
#        \
#          --------- LS043 ------------------ SLS043
#                    10 St. (1!)              -10 St. (8!)
#                    | Aktion | remge  |      | Aktion | remge  |
#                    |        |  0 St. |      |        |  0 St. |
#                        \
#                         \
#                           ------------ RLS043 --------------- KGS043 ------------- SKG043
#                                        -5 St. (3!)           -1 St. (4!)           +1 St. (5!)
#                                       | Aktion | remge  |    | Aktion | remge  |   | Aktion | remge  |
#                                       | (3)    | -1 St. |    |        |  0 St. |   |        |  0 St. |
#                                       | (4)    |  0 St. |
#                                       | (5)    | -1 St. |
#                                       | (6)    |  0 St. |
#                                           \
#                                            SRL043
#                                            +5 St. (6!)
#                                            | Aktion | remge  |
#                                            |        |  0 St. |

Scenario: Remge beim Storno der kaufm. Gutschrift, Ruecklieferschein, Rechnung, Lieferschein RE aus BE

Given I open an editor "BE043" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE043  |
And I append rows
   | artikel | he    | mge |
   | A100    | kg    |   9 |
And I save the current editor

# Remge in Bestellung
Then field "remge" from editor "BE043" in row 1 has value "9"

# Ersten Lieferschein aus Bestellung erzeugen
Given I open an editor "LS043" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE043"
And I set fields
   | such   | LS043   |
   | ebeleg | LS043   |
   | ueb    | true    |
   | fakt   | false   |
   | vom    | .       |
Then the table has 1 rows
And I set field "mge" to "10" in row 1
And I save the current editor

# Remge in Bestellung
Then field "remge" from editor "BE043" in row 1 has value "10"

# Rechnung zum Bestellung ueber 6 Stueck
Given I open an editor "RE043" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE043"
And I set fields
   | such   | RE043   |
   | ebeleg | RE043   |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "6" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge in Bestellung
Given I open an editor "BE043V" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE043"
Then field "remge" has value "4" in row 1
And I close the current editor

# Pruefe remge in Lieferschein (0, da RE ueber BE)
Given I open an editor "LS043V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS043"
Then field "remge" has value "0" in row 1
And I close the current editor

# Ruecklieferschein zu Lieferschein
Given I open an editor "RLS043" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS043"
And I set fields
   | such   | RLS043   |
   | ebeleg | RLS043   |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Pruefe remge in Bestellung
Given I open an editor "BE043V" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE043"
Then field "remge" has value "4" in row 1
And I close the current editor

# Pruefe remge in Lieferschein
Given I open an editor "1LS043V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS043"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge in Ruecklieferschein zu Lieferschein
Given I open an editor "1RLS043V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS043"
Then field "remge" has value "-1" in row 1
And I close the current editor

# Kaufm. Gutschrift zu Ruecklieferschein RLS043
Given I open an editor "KGS043" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS043"
And I set fields
   | such   | KGS043  |
   | ebeleg | KGS043  |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
And I set field "mge" to "-1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge in Bestellung
Then field "remge" from editor "BE043" in row 1 has value "4"
# Pruefe remge in Ruecklieferschein
Then field "remge" from editor "RLS043" in row 1 has value "0"

# kaufm. Gutschrift stornieren
Given I open an editor "SKG043" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KGS043"
And I save the current editor

# Prufe Remge in Bestellung
Then field "remge" from editor "BE043" in row 1 has value "4"
# Pruefe remge in Ruecklieferschein
Then field "remge" from editor "RLS043" in row 1 has value "-1"

# Ruecklieferschein stornieren
Given I open an editor "SRL043" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "RLS043"
And I save the current editor

# Pruefe remge in Bestellung
Given I open an editor "BE043V" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE043"
Then field "remge" has value "4" in row 1
And I close the current editor

# Pruefe remge in Lieferschein
Then field "remge" from editor "LS043" in row 1 has value "0"
# Pruefe remge in Ruecklieferschein
Then field "remge" from editor "RLS043" in row 1 has value "0"

# Rechnung stornieren
Given I open an editor "SRE043" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE043"
And I save the current editor

# Pruefe remge in Bestellung
Then field "remge" from editor "BE043" in row 1 has value "10"
# Pruefe remge in Lieferschein
Then field "remge" from editor "LS043" in row 1 has value "0"

# Lieferschein stornieren
Given I open an editor "SRL043" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "LS043"
And I save the current editor

# Pruefe remge in Bestellung
Given I open an editor "BE043V" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE043"
Then field "remge" has value "9" in row 1
And I close the current editor

# Pruefe remge in stornierten , abgelegten Lieferschein
Then field "remge" from editor "LS043" in row 1 has value "0"

# Pruefe remge im stornierten, abgelegten Ruecklieferschein
Then field "remge" from editor "RLS043" in row 1 has value "0"


# ----------------------------------------------------------------------------- #
#                       Fakturierung ueber den Lieferschein                     #
#                       Aktualisierung remge ueberpruefen                       #
# ----------------------------------------------------------------------------- #


#  BE039  ------------- LS039 --------------- RE039 ----------------- SRE039
#  10 St.               5 St. (1!)            5 St. (2!)              -5 St. (3!)
#  | Aktion | remge  |  | Aktion | remge |    | Aktion | remge |      | Aktion | remge |
#  |        | 10 St. |  |        | 5 St. |    |        | 5 St. |      |        | 5 St. |
#  | (1)    |  5 St. |  | (2)    | 0 St. |    | (2)    | 0 St. |      | (3)    | 0 St. |
#  | (3)    |  5 St. |  | (3)    | 5 St. |    | (3)    | 0 St. |

Scenario: Remge bei RE ueber LS buchen, RE stornieren

Given I open an editor "BE039" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE039  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferschein aus Bestellung erzeugen
Given I open an editor "LS039" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE039"
And I set fields
   | such   | LS039 |
   | ebeleg | LS039 |
   | ueb    | true  |
   | vom    | .     |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
And I save the current editor

# Pruefe remge in Bestellung
Then field "remge" from editor "BE039" in row 1 has value "5"

# Rechnungen zum Lieferschein ueber 5 Stueck
Given I open an editor "RE039" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS039"
And I set fields
   | such   | RE039  |
   | ebeleg | RE039  |
   | ueb    | true   |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge im Lieferschein
Then field "remge" from editor "LS039" in row 1 has value "0"

# Rechnung stornieren
Given I open an editor "SRE039" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE039"
And I save the current editor

# Pruefe remge in Bestellung
Then field "remge" from editor "BE039" in row 1 has value "5"
# Pruefe remge Lieferschein
Then field "remge" from editor "LS039" in row 1 has value "5"


# Bestellung -> LS A & B (buchen) -> RE A & B (buchen) -> RLS A & B aus LS B -> KGS zu RLS A ->
# a. Storno KGS
# b. Storno RE B


#  BE040  ------------ LS040A ------------ RE040A
#  10 St.              5 St. (1!)          4 St. (2!)
#  | Aktion | remge |  | Aktion | remge|  | Aktion | remge|
#  | mge Ein| 10 St.|  |  neu   | 0 St.|  | neu    | 5 St.|
#  |  (1)   | 5 St. |  | (1)    | 5 St.|  | (2)    | 0 St.|
#  |  (1b)  | 0 St. |  | (2)    | 1 St.|
#         \
#          \
#            --------- LS040B ------------- RE040B -------------------------------------------- SRE040B
#                      10 St. (1b!)          5 St. (3!)                                         -5 St. (8!)
#                      | Aktion | remge |   | Aktion | remge |                                  | Aktion | remge |
#                      |   neu  |  0 St.|   | neu    | 10 St.|                                  | neu    | -5 (??? IST 0) St.|
#                      | (1b!)  | 10 St.|   | (3)    |  0 St.|                                  | (8)    |  0 St.|
#                      | (3)    |  5 St.|
#                      | (4)    |  5 St.|
#                      | (5)    |  5 St.|
#                      | (8)    | 10 St.|
#                         \
#                          \
#                             ---------------- RLS040A ------------ KGS040A ----------- SKGS040A
#                            \                 -3 St. (4!)          -1 St. (6!)         1 St. (7!)
#                             \                | Aktion | remge |  | Aktion | remge |   | Aktion | remge |
#                              \               | neu    |  0 St.|  | neu    | -2 St.|   | neu    |  -1(??? IST 0) St.|
#                               \              | (4)    |  0 St.|  | (6)    |  0 St.|   | (7)    |  0 St.|
#                                \             | (5)    | -2 St.|
#                                 \            | (6)    | -1 St.|
#                                  \           | (7)    | -2 St.|
#                                   \          | (8)    |  0 St.|
#                                    \
#                                     \
#                                       ---------- RLS040B
#                                                  -4 St. (5!)
#                                                  | Aktion | remge |
#                                                  | neu    | 0 St. |
#                                                  | (5)    | -2 St.|
#                                                  | (6)    | -1 St.|
#                                                  | (7)    | -2 St.|
#                                                  | (8)    |  0 St.|

Scenario: Remge bei RE ueber LS buchen: Storno der KGS, Storno der RE

Given I open an editor "BE040" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE040  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
Then field "remge" has value "10" in row 1
And I save the current editor

# Lieferschein A aus Bestellung erzeugen
Given I open an editor "LS040A" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE040"
And I set fields
   | such   | LS040A |
   | ebeleg | LS040A |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
Then field "remge" has value "0" in row 1
And I save the current editor

# Pruefe remge im Lieferschein A
Then field "remge" from editor "LS040A" in row 1 has value "5"

# Lieferschein B aus Bestellung erzeugen
Given I open an editor "LS040B" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE040"
And I set fields
   | such   | LS040B |
   | ebeleg | LS040B |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "10" in row 1
Then field "remge" has value "0" in row 1
And I save the current editor

# Pruefe remge im Lieferschein B
Then field "remge" from editor "LS040B" in row 1 has value "10"
# Pruefe remge in Bestellung
Then field "remge" from editor "BE040" in row 1 has value "0"

# Rechnungen zum Lieferschein A ueber 4 Stueck
Given I open an editor "RE040A" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS040A"
And I set fields
   | such   | RE040A |
   | ebeleg | RE040A |
   | ueb    | true   |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge in Lieferschein A
Then field "remge" from editor "LS040A" in row 1 has value "1"

# Rechnungen zum Lieferschein B ueber 5 Stueck
Given I open an editor "RE040B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS040B"
And I set fields
   | such   | RE040B |
   | ebeleg | RE040B |
   | ueb    | true   |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "5" in row 1
Then field "remge" has value "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge im Lieferschein B
Then field "remge" from editor "LS040B" in row 1 has value "5"

# Ruecklieferschein 1 zu LS B
Given I open an editor "RLS040A" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS040B"
And I set fields
   | such   | RLS040A |
   | ebeleg | RLS040A |
   | ueb    | true    |
   | vom    | .       |
And I set field "mge" to "-3" in row 1
And I save the current editor

# Pruefe remge im Lieferschein B
Then field "remge" from editor "LS040B" in row 1 has value "5"
# Pruefe remge im Ruecklieferschein B
Then field "remge" from editor "RLS040A" in row 1 has value "0"

# Ruecklieferschein 2 zu LS B
Given I open an editor "RLS040B" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS040B"
And I set fields
   | such   | RLS040B |
   | ebeleg | RLS040B |
   | ueb    | true    |
   | vom    | .       |
And I set field "mge" to "-4" in row 1
And I save the current editor

# Pruefe remge im Lieferschein B
Then field "remge" from editor "LS040B" in row 1 has value "5"
# Pruefe remge im Ruecklieferschein B
Then field "remge" from editor "RLS040B" in row 1 has value "-2"

# Teilgutschrift zum RLS 1
Given I open an editor "KGS040" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS040B"
And I set fields
   | such   | KGS040  |
   | ebeleg | KGS040  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "-1" in row 1
Then field "remge" has value "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge in der Teilgutschrift
Then field "remge" from editor "KGS040" in row 1 has value "0"
# Pruefe remge im Ruecklieferschein A
Then field "remge" from editor "RLS040A" in row 1 has value "-1"
# Pruefe remge im Ruecklieferschein B
Then field "remge" from editor "RLS040B" in row 1 has value "-1"

# Kaufm. Gutschrift stornieren (7!)
Given I open an editor "SKGS040" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KGS040"
Then field "remge" has value "0" in row 1
And I save the current editor

# Pruefe remge in der Teilgutschrift
Then field "remge" from editor "SKGS040" in row 1 has value "0"
# Pruefe remge im Ruecklieferschein A
Then field "remge" from editor "RLS040A" in row 1 has value "-2"
# Pruefe remge im Ruecklieferschein B
Then field "remge" from editor "RLS040B" in row 1 has value "-2"

# Rechnung stornieren (8!)
Given I open an editor "SRE040" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE040B"
Then field "remge" has value "0" in row 1
And I save the current editor

# Pruefe remge im Lieferschein
Then field "remge" from editor "LS040B" in row 1 has value "10"
# Pruefe remge im Ruecklieferschein A
Then field "remge" from editor "RLS040A" in row 1 has value "0"
# Pruefe remge im Ruecklieferschein B
Then field "remge" from editor "RLS040B" in row 1 has value "0"


# Storno des LS: RE muessen schon storniert sein
#
#  BE041  ------------ LS041A -------------- RE041A
#  10 St.              5 St. (1!)            5 St. (2!)
#  | Aktion | remge|   | Aktion | remge |
#  | (1)    | 5 St.|   |        | 5 St. |
#  | (1b)   | 0 St.|   | (2)    | 0 St. |
#  | (5)    | 5 St.|
#       \
#        \
#         \
#           --------- LS041B --------------- RE041B ------- SRE041B
#                      6 St. (1b!)           5 St. (3!)     -5 St. (4!)
#                     | Aktion | remge  |
#                     |        |  6 St. |
#                     | (3)    |  1 St. |
#                     | (4)    |  6 St. |
#                     | (5)    |  0 St. |
#                           \
#                            \
#                             \
#                               --------------------------------- SLS041B
#                                                                 -6 St. (5!)
#

Scenario: Remge bei RE ueber LS buchen: Storno des LS

Given I open an editor "BE041" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE041  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
Then field "remge" has value "10" in row 1
And I save the current editor

# Lieferschein A aus Bestellung erzeugen
Given I open an editor "LS041A" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE041"
And I set fields
   | such   | LS041A |
   | ebeleg | LS041A |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
Then field "remge" has value "0" in row 1
And I save the current editor

# Lieferschein B aus Bestellung erzeugen
Given I open an editor "LS041B" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE041"
And I set fields
   | such   | LS041B |
   | ebeleg | LS041B |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "6" in row 1
Then field "remge" has value "0" in row 1
And I save the current editor

# Rechnungen zum Lieferschein A ueber 5 Stueck
Given I open an editor "RE041A" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS041A"
And I set fields
   | such   | RE041A |
   | ebeleg | RE041A |
   | ueb    | true   |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnungen zum Lieferschein B ueber 5 Stueck
Given I open an editor "RE041B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS041B"
And I set fields
   | such   | RE041B |
   | ebeleg | RE041B |
   | ueb    | true   |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "5" in row 1
Then field "remge" has value "6" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein B stornieren nicht erlaubt
# "Zuerst muessen die Rechnungen storniert werden."
And opening an editor from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "LS041B" throws the exception "9312"

# Rechnung stornieren
Given I open an editor "SRE041B" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE041B"
And I save the current editor

# Lieferschein B stornieren
Given I open an editor "SLS041B" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "LS041B"
And I save the current editor

# Pruefe remge in Bestellung
Then field "remge" from editor "BE041" in row 1 has value "5"
# Pruefe remge im Lieferschein 41A
Then field "remge" from editor "LS041A" in row 1 has value "0"

# Storno des RLS: remge im LS muss erhoeht werden
#
#  BE042  ------------ LS042 --------------- RE042
#  10 St.              5 St. (1!)            5 St. (2!)
#  | Aktion | remge|   | Aktion | remge|
#  | (1)    | 5 St.|   |        | 5 St.|
#  | (1b)   | 0 St.|   | (2)    | 0 St.|
#         \
#          \
#            --------- LS042B -------------- RE042B
#                      10 St. (1b!)          5 St. (3!)
#                      | Aktion | remge |
#                      |        | 10 St.|
#                      | (3)    |  5 St.|
#                      | (4)    |  5 St.|
#                      | (5)    |  5 St.|
#                      | (6)    |  5 St.|
#                         \
#                          \
#                            --------------- RLS042A --------------- SRLS042A
#                            \              -5 St. (4!)              5 St. (6!)
#                             \              | Aktion | remge  |
#                              \             |        |  0 St. |
#                               \            | (5)    | -2 St. |
#                                \           | (6)    |  0 St. |
#                                 \
#                                  \
#                                    ------- RLS042B
#                                           -2 St. (5!)
#                                            | Aktion | remge  |
#                                            |        | -2 St. |
#                                            | (6)    |  0 St. |
#

Scenario: Remge bei RE ueber LS buchen: Storno des RLS

Given I open an editor "BE042" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE042  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
Then field "remge" has value "10" in row 1
And I save the current editor

# Lieferschein A aus Bestellung erzeugen
Given I open an editor "LS042A" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE042"
And I set fields
   | such   | LS042A |
   | ebeleg | LS042A |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
Then field "remge" has value "0" in row 1
And I save the current editor

# Lieferschein B aus Bestellung erzeugen
Given I open an editor "LS042B" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE042"
And I set fields
   | such   | LS042B |
   | ebeleg | LS042B |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "10" in row 1
Then field "remge" has value "0" in row 1
And I save the current editor

# Rechnungen zum Lieferschein A ueber 5 Stueck
Given I open an editor "RE042A" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS042A"
And I set fields
   | such   | RE042A |
   | ebeleg | RE042A |
   | ueb    | true   |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnungen zum Lieferschein B ueber 5 Stueck
Given I open an editor "RE042B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS042B"
And I set fields
   | such   | RE042B |
   | ebeleg | RE042B |
   | ueb    | true   |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge im Lieferschein B
Then field "remge" from editor "LS042B" in row 1 has value "5"

# Ruecklieferschein zu LS B
Given I open an editor "RLS042A" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS042B"
And I set fields
   | such   | RLS042A |
   | ebeleg | RLS042A |
   | ueb    | true    |
   | vom    | .       |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Pruefe remge im Lieferschein B
Then field "remge" from editor "LS042B" in row 1 has value "5"
# Pruefe remge im Ruecklieferschein B
Then field "remge" from editor "RLS042A" in row 1 has value "0"

# Ruecklieferschein zu LS B
Given I open an editor "RLS042B" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS042B"
And I set fields
   | such   | RLS042B |
   | ebeleg | RLS042B |
   | ueb    | true    |
   | vom    | .       |
And I set field "mge" to "-2" in row 1
And I save the current editor

# Ruecklieferschein stornieren
Given I open an editor "SRLS042A" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "RLS042A"
And I save the current editor

# Pruefe remge im Lieferschein B
Then field "remge" from editor "LS042B" in row 1 has value "5"

#----------------------------------------------------------------------------------------------
# TSQ-REFRG-09: EK - Aktualisierung der freigegebenen Mengen bei ungebuchten Vorgaengen
#----------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------- #
#                       Fakturierung ueber den Lieferschein                     #
#                       Aktualisierung remge und refrg ueberpruefen             #
# ----------------------------------------------------------------------------- #

#  BE044  ------------------------- LS044 ------------------------ LS044 buchen ----------- RE044
#  10 St.                           5 St. (1!)                     5 St. (2!)               5 St. (4!)
#  | Aktion | remge  | refrg |      | Aktion | remge  | refrg |
#  |        | 10 St. | 0 St. |      |        | 0 St.  | 5 St. |
#  | (1)    | 10 St. | 5 St. |      | (2)    | 5 St.  | 0 St. |
#  | (2)    |  5 St. | 0 St. |      | (4)    | 0 St.  | 0 St. |
#  | (3)    |  0 St. | 0 St. |
#          \
#            ----------LS044B ------------------------ RE044B  ------- RE044B buchen
#                      10 St. (3!)                     5 St. (5!)      5 St. (6!)
#                      | Aktion | remge  |  refrg |
#                      |        | 10 St. |  0 St. |
#                      | (5)    | 10 St. |  5 St. |
#                      | (6)    |  5 St. |  0 St. |
#                      | (7)    |  5 St. |  0 St. |
#                      | (9)    |  5 St. |  0 St. |
#                            \
#                             \
#                                ------------RLS044B ----------------------------- KGS044   ------------ KGS044
#                               \            -3 St. (7!)                           2 St. (10!)            2 St. (11!)
#                                \           | Aktion | remge  | refrg  |
#                                 \          |        |  0 St. |  0 St. |
#                                  \         | (9)    | -2 St. |  0 St. |
#                                   \        | (10)   | -2 St. | -2 St. |
#                                    \       | (11)   |  0 St. |  0 St. |
#                                     \
#                                       ----------- RLS044BB -------------------- RLS044B buchen
#                                                   -4 St. (8!)                   -4 St. (9!)
#                                                   | Aktion | remge   | refrg  |
#                                                   |        |  0 St.  | -4 St. |
#                                                   | (9)    | -2 St.  |  0 St. |
#                                                   | (10)   | -2 St.  |  0 St. |
#                                                   | (11)   |  0 St.  |  0 St. |

Scenario: remge und refrg bei RE ueber LS, RLS und KGS erst ungebucht, dann buchen

Given I open an editor "BE044" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE044  |
   | ebeleg | BE044  |
And I append rows
   | artikel | he     | mge |
   | A100    | Stueck | 10  |
And I save the current editor

# Ersten Lieferschein aus Bestellung erzeugen
Given I open an editor "LS044" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE044"
And I set fields
   | such   | LS044  |
   | ebeleg | LS044  |
   | vom    | .      |
   | ueb    | false  |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
And I save the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE044" in row 1 has value "10"
Then field "refrg" from editor "BE044" in row 1 has value "5"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS044" in row 1 has value "0"
Then field "refrg" from editor "LS044" in row 1 has value "5"

# Ersten Lieferschein buchen
Given I open an editor "LS044" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "LS044"
And I set fields
   | ueb    | true  |
   | vom    | .     |
And I save the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE044" in row 1 has value "5"
Then field "refrg" from editor "BE044" in row 1 has value "0"

# Ausgabe Lieferschein
Given I open an editor "LS044V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS044"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Zweiten Lieferschein aus Bestellung erzeugen
Given I open an editor "LS044B" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE044"
And I set fields
   | such   | LS044B |
   | ebeleg | LS044B |
   | vom    | .      |
   | ueb    | true   |
Then the table has 1 rows
And I set field "mge" to "10" in row 1
And I save the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE044" in row 1 has value "0"
Then field "refrg" from editor "BE044" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS044B" in row 1 has value "10"
Then field "refrg" from editor "LS044B" in row 1 has value "0"

# Rechnungen zu den Lieferscheinen ueber jeweils 5 Stueck
Given I open an editor "RE044" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS044"
And I set fields
   | such   | RE044   |
   | ebeleg | RE044   |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE044" in row 1 has value "0"
Then field "refrg" from editor "BE044" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS044" in row 1 has value "0"
Then field "refrg" from editor "LS044" in row 1 has value "0"

Given I open an editor "RE044B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS044B"
And I set fields
   | such   | RE044B  |
   | ebeleg | RE044B  |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE044" in row 1 has value "0"
Then field "refrg" from editor "BE044" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS044B" in row 1 has value "10"
Then field "refrg" from editor "LS044B" in row 1 has value "5"

# Zweite Rechnung buchen
Given I open an editor "RE044" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE044B"
And I set fields
   | ueb    | true  |
   | vom    | .     |
And I save the current editor

# Ausgabe Lieferschein B
Given I open an editor "LS044BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS044B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Ruecklieferschein 1 zu LS 2
Given I open an editor "RLS044B" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS044B"
And I set fields
   | such   | RLS044B  |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-3" in row 1
And I save the current editor

# Ausgabe Lieferschein B
Given I open an editor "LS044BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS044B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Pruefe remge und refrg im Ruecklieferschein
Then field "remge" from editor "RLS044B" in row 1 has value "0"
Then field "refrg" from editor "RLS044B" in row 1 has value "0"

# Ruecklieferschein 2 zu LS 2
Given I open an editor "RLS044BB" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS044B"
And I set fields
   | such   | RLS044BB |
   | ueb    | false    |
   | vom    | .        |
And I set field "mge" to "-4" in row 1
And I save the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE044" in row 1 has value "0"
Then field "refrg" from editor "BE044" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein 2
Then field "remge" from editor "LS044B" in row 1 has value "5"
Then field "refrg" from editor "LS044B" in row 1 has value "0"
# Pruefe remge und refrg im Ruecklieferschein 1
Then field "remge" from editor "RLS044B" in row 1 has value "0"
Then field "refrg" from editor "RLS044B" in row 1 has value "0"
# Pruefe remge und refrg im Ruecklieferschein 2
Then field "remge" from editor "RLS044BB" in row 1 has value "0"
Then field "refrg" from editor "RLS044BB" in row 1 has value "-4"

#  Ruecklieferschein 2 zu LS B - aendern und jetzt buchen!
Given I open an editor "RLS044BB" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "RLS044BB"
And I set fields
   | ueb    | true     |
And I save the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE044" in row 1 has value "0"
Then field "refrg" from editor "BE044" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS044" in row 1 has value "0"
Then field "refrg" from editor "LS044" in row 1 has value "0"

# Ausgabe Lieferschein B
Given I open an editor "LS044BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS044B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Ausgabe Ruecklieferschein 1 zu Lieferschein B
Given I open an editor "RLS044BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS044B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "-2" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Ausgabe Ruecklieferschein 2 zu Lieferschein B
Given I open an editor "RLS044BBV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS044BB"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "-2" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Teilgutschrift 1 zu RLS 1
Given I open an editor "KGS044" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS044B"
And I set fields
   | such   | KGS044  |
   | ebeleg | KGS044  |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE044" in row 1 has value "0"
Then field "refrg" from editor "BE044" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS044B" in row 1 has value "5"
Then field "refrg" from editor "LS044B" in row 1 has value "0"
# Pruefe remge und refrg im Ruecklieferschein
Then field "remge" from editor "RLS044B" in row 1 has value "-2"
Then field "refrg" from editor "RLS044B" in row 1 has value "-2"
# Pruefe remge und refrg im Ruecklieferschein
Then field "remge" from editor "RLS044BB" in row 1 has value "-2"
Then field "refrg" from editor "RLS044BB" in row 1 has value "0"

# Teilgutschrift buchen
Given I open an editor "KGS044P" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS044"
And I set fields
   | ueb    | true    |
And I save the current editor

# Ausgabe Lieferschein A
Given I open an editor "LS044V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS044"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Ausgabe Lieferschein B
Given I open an editor "LS044BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS044B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Ausgabe Ruecklieferschein 1 zu Lieferschein B
Given I open an editor "RLS044BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS044B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Ausgabe Ruecklieferschein 2 zu Lieferschein B
Given I open an editor "RLS044BBV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS044BB"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor


# ----------------------------------------------------------------------------- #
#         Gleiches wie zuvor, nur mit unterschiedlichen Handelseinheiten        #
# ----------------------------------------------------------------------------- #

Scenario: remge und refrg bei RE ueber LS, RLS und KGS erst ungebucht, dann buchen, unterschiedliche HE

Given I open an editor "BE045" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE045  |
   | ebeleg | BE045  |
And I append rows
   | artikel | he     | mge |
   | A100    | Stueck | 10  |
And I save the current editor

# Lieferschein A aus Bestellung erzeugen
Given I open an editor "LS045" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE045"
And I set fields
   | such   | LS045  |
   | ebeleg | LS045  |
   | vom    | .      |
   | ueb    | false   |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
And I save the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE045" in row 1 has value "10"
Then field "refrg" from editor "BE045" in row 1 has value "5"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS045" in row 1 has value "0"
Then field "refrg" from editor "LS045" in row 1 has value "5"

# Ersten Lieferschein buchen
Given I open an editor "LS045" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "LS045"
And I set fields
   | ueb    | true  |
   | vom    | .     |
And I save the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE045" in row 1 has value "5"
Then field "refrg" from editor "BE045" in row 1 has value "0"

# Ausgabe Lieferschein
Given I open an editor "LS045V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS045"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Lieferschein B aus Bestellung erzeugen
Given I open an editor "LS045B" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE045"
And I set fields
   | such   | LS045B |
   | ebeleg | LS045B |
   | vom    | .      |
   | ueb    | true   |
Then the table has 1 rows
# 1 Stueck enstpricht 2 kg
And I set field "he" to "kg" in row 1
And I set field "mge" to "20" in row 1
And I save the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE045" in row 1 has value "0"
Then field "refrg" from editor "BE045" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS045B" in row 1 has value "20"
Then field "refrg" from editor "LS045B" in row 1 has value "0"

# Rechnungen zu den jeweiligen Lieferscheinen ueber jeweils 5 Stueck: einmal in Einheit "Stueck" und einmal in "kg"
Given I open an editor "RE045" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS045"
And I set fields
   | such   | RE045   |
   | ebeleg | RE045   |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "he" to "Stueck" in row 1
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE045" in row 1 has value "0"
Then field "refrg" from editor "BE045" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS045" in row 1 has value "0"
Then field "refrg" from editor "LS045" in row 1 has value "0"

Given I open an editor "RE045B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS045B"
And I set fields
   | such   | RE045B  |
   | ebeleg | RE045B  |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "he" to "kg" in row 1
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE045" in row 1 has value "0"
Then field "refrg" from editor "BE045" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS045B" in row 1 has value "20"
Then field "refrg" from editor "LS045B" in row 1 has value "10"

Given I open an editor "RE045B" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE045B"
And I set fields
   | ueb    | true    |
And I save the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE045" in row 1 has value "0"
Then field "refrg" from editor "BE045" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS045B" in row 1 has value "10"
Then field "refrg" from editor "LS045B" in row 1 has value "0"

# Ruecklieferschein 1 zu LS B
Given I open an editor "RLS045B" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS045B"
And I set fields
   | such   | RLS045B  |
   | ueb    | true     |
   | vom    | .        |
# 1 Stueck enstpricht 2 kg
And I set field "he" to "kg" in row 1
And I set field "mge" to "-6" in row 1
And I save the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE045" in row 1 has value "0"
Then field "refrg" from editor "BE045" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS045B" in row 1 has value "10"
Then field "refrg" from editor "LS045B" in row 1 has value "0"
# Pruefe remge und refrg im Ruecklieferschein
Then field "remge" from editor "RLS045B" in row 1 has value "0"
Then field "refrg" from editor "RLS045B" in row 1 has value "0"

# Ruecklieferschein 2 zu LS B (noch nicht buchen)
Given I open an editor "RLS045BB" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS045B"
And I set fields
   | such   | RLS045BB |
   | vom    | .        |
And I set field "he" to "Stueck" in row 1
And I set field "mge" to "-4" in row 1
And I save the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE045" in row 1 has value "0"
Then field "refrg" from editor "BE045" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS045B" in row 1 has value "10"
Then field "refrg" from editor "LS045B" in row 1 has value "0"
# Pruefe remge und refrg im Ruecklieferschein 1
Then field "remge" from editor "RLS045B" in row 1 has value "0"
Then field "refrg" from editor "RLS045B" in row 1 has value "0"
# Pruefe remge und refrg im Ruecklieferschein 2
Then field "remge" from editor "RLS045BB" in row 1 has value "0"
Then field "refrg" from editor "RLS045BB" in row 1 has value "-8"

#  Ruecklieferschein 2 zu LS B - aendern und jetzt buchen!
Given I open an editor "RLS045BB" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "RLS045BB"
And I set fields
   | ueb    | true     |
And I save the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE045" in row 1 has value "0"
Then field "refrg" from editor "BE045" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS045B" in row 1 has value "10"
Then field "refrg" from editor "LS045B" in row 1 has value "0"
# Pruefe remge und refrg im Ruecklieferschein 1
Then field "remge" from editor "RLS045B" in row 1 has value "-4"
Then field "refrg" from editor "RLS045B" in row 1 has value "0"
# Pruefe remge und refrg im Ruecklieferschein
Then field "remge" from editor "RLS045BB" in row 1 has value "-2"
Then field "refrg" from editor "RLS045BB" in row 1 has value "0"

# Teilgutschrift 1 zu RLS 1
Given I open an editor "KGS045" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS045B"
And I set fields
   | such   | KGS045  |
   | ebeleg | KGS045  |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "he" to "Stueck" in row 1
And I set field "mge" to "-1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE045" in row 1 has value "0"
Then field "refrg" from editor "BE045" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS045B" in row 1 has value "10"
Then field "refrg" from editor "LS045B" in row 1 has value "0"
# Pruefe remge und refrg im Ruecklieferschein 1
Then field "remge" from editor "RLS045B" in row 1 has value "-4"
Then field "refrg" from editor "RLS045B" in row 1 has value "-2"
# Pruefe remge und refrg im Ruecklieferschein 1
Then field "remge" from editor "RLS045BB" in row 1 has value "-2"
Then field "refrg" from editor "RLS045BB" in row 1 has value "0"

# Teilgutschrift buchen
Given I open an editor "KGS045P" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS045"
And I set fields
   | ueb    | true    |
And I save the current editor

# Ausgabe Lieferschein A
Given I open an editor "LS045V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS045"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Ausgabe Lieferschein B
Given I open an editor "LS045BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS045B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "10" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Ausgabe Ruecklieferschein 1 zu Lieferschein B
Given I open an editor "RLS045BV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS045B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "-2" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Ausgabe Ruecklieferschein 2 zu Lieferschein B
Given I open an editor "RLS045BBV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS045BB"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "-1" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

Scenario: RLS in Ablage bringen und wieder aus Ablage holen bei RLS buchen und KGS

#  Ist die remge = 0 gehen die RLS in die Ablage. Es kann sein,
#  dass durch weitere RLS beide RLS aus der Ablage kommen (wiederaufleben)
#  Eine KGS kann den aktuellen und den parallelen RLS wieder in die Ablage bringen
#
#  BE046 ---> LS046 -------------- RE046
#  10 St.     10 St.               5 St. (2!)
#             | Aktion | remge  |
#             |        | 10 St. |
#             | (2)    |  5 St. |
#             | (3)    |  5 St. |
#             | (4)    |  5 St. |
#                        \
#                         \ ---------RLS046 ----------------> KGS046	---------> KGSS046
#                          \         -3 St. (3!)              2 St. (5!)           Storno (6!)
#                           \        | Aktion | remge   |
#                            \       | (3)    |  0 St.  | (abgelegt)
#                             \      | (4)    | -2 St.  | (wieder lebendig)
#                              \     | (5)    |  0 St.  | (abgelegt)
#                               \    | (6)    | -2 St.  | (wieder lebendig)
#                                \   | (7)    |  0 St.  | (abgelegt)
#                                 \
#                                  -------- RLS046B ------------------------> RLSS046B -----> RLSS046B
#                                           -4 St. (4!)                      (Storno          Storno (7!)
#                                           | Aktion | remge   |              nicht erl.)
#                                           | (4)    | -2 St.  |
#                                           | (5)    |  0 St.  | (abgelegt)
#                                           | (6)    | -2 St.  | (wieder lebendig)
#                                           | (7)    |  0 St.  | (abgelegt)
#

# Bestellung anlegen
Given I create a PurchaseOrder "BE046" for Vendor "1" with Product "V1" and quantity "10"

Then field "remge" from editor "BE046" in row 1 has value "10"

Given I open an editor "LS046" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE046"
And I set fields
   | such   | LS046  |
   | ebeleg | LS046  |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

Then field "remge" from editor "BE046" in row 1 has value "0"
Then "(Purchasing):(PurchaseOrder)" with the editor id "BE046" is filed
Then field "remge" from editor "LS046" in row 1 has value "10"

Given I open an editor "RE046" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS046"
And I set fields
   | such   | RE046  |
   | ebeleg | RE046  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "5" in row 1
And I save the current editor

Then field "remge" from editor "LS046" in row 1 has value "5"

# Ruecklieferschein 1
Given I open an editor "RLS046" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS046"
And I set fields
   | such   | RLS046   |
   | ebeleg | RLS046   |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-3" in row 1
And I set field "platz" to "F1" in row 1
And I save the current editor

Then field "remge" from editor "LS046" in row 1 has value "5"
Then "(Purchasing):(PackingSlip)" with the editor id "LS046" is not filed
Then field "remge" from editor "RLS046" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "RLS046" is filed

# Ruecklieferschein 1
Given I open an editor "RLS046B" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS046"
And I set fields
   | such   | RLS046B  |
   | ebeleg | RLS046B  |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-4" in row 1
And I set field "platz" to "F1" in row 1
And I save the current editor
Then field "remge" from editor "RLS046B" in row 1 has value "-2"
Then "(Purchasing):(PackingSlip)" with the editor id "RLS046B" is not filed
Then field "remge" from editor "RLS046" in row 1 has value "-2"
Then "(Purchasing):(PackingSlip)" with the editor id "RLS046" is not filed
Then field "remge" from editor "LS046" in row 1 has value "5"
Then "(Purchasing):(PackingSlip)" with the editor id "LS046" is not filed

# Teilgutschrift 1 zu RLS 1
Given I open an editor "KGS046" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS046"
And I set fields
   | such   | KGS046  |
   | ebeleg | KGS046  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "-2" in row 1
And I save the current editor

Then field "remge" from editor "LS046" in row 1 has value "5"
Then "(Purchasing):(PackingSlip)" with the editor id "LS046" is not filed
Then field "remge" from editor "RLS046" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "RLS046" is filed
Then field "remge" from editor "RLS046B" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "RLS046B" is filed

# Stornieren des RLS 2 ist nicht moeglich, da es noch eine KGS im parallelen RLS gibt
Then opening an editor from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "RLS046B" throws the exception "3335"

# KGS Stornieren
Given I open an editor "KGSS046" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KGS046"
And I save the current editor

Then field "remge" from editor "RLS046" in row 1 has value "-2"
Then "(Purchasing):(PackingSlip)" with the editor id "RLS046" is not filed
Then field "remge" from editor "RLS046B" in row 1 has value "-2"
Then "(Purchasing):(PackingSlip)" with the editor id "RLS046B" is not filed

# Stornieren des RLS 2 geht nun
Given I open an editor "RLSS046B" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "RLS046B"
And I save the current editor
Then field "remge" from editor "RLS046" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "RLS046" is filed
Then field "remge" from editor "RLS046B" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "RLS046B" is filed


# ----------------------------------------------------------------------------- #
#                       Fakturierung ueber den Lieferschein                     #
#                       Aktualisierung remge und refrg ueberpruefen             #
# ----------------------------------------------------------------------------- #

#  BE047 ------------------------- LS047 --------------------------------- RE047
#  10 St.                          7 St. (1!)                              5 St. (2!)
#  | Aktion | remge  | refrg |     | Aktion | remge  | refrg |
#  |        | 10 St. | 0 St. |     |        | 7 St.  | 0 St. |
#  | (1)    |  3 St. | 0 St. |     | (2)    | 2 St.  | 0 St. |
#                                  | (3)    | 2 St.  | 2 St. |
#                                  | (4)    | 2 St.  | 2 St. |
#                                    \
#                                     \
#                                      \
#                                        ------- RE047B ungebucht
#                                        \       2 St. (3!)
#                                         \      | Aktion | remge  | refrg  |
#                                          \     |        |  2 St. |  2 St. |
#                                           \    | (4)    |  2 St. |  2 St. |
#                                            \
#                                             \
#                                              ----------- RLS047 -------------------------- KGS047 ungebucht  ------------ KGS047 aendern
#                                                          -4 St. (4!)                       -2 St. (5!)                     -1 St. (6!)
#                                                          | Aktion | remge  | refrg  |      | Aktion | remge  | refrg  |
#                                                          |        | -2 St. |  0 St. |      |        | -2 St. | -2 St. |
#                                                          | (5)    | -2 St. | -2 St. |      |  (6)   | -1 St. | -1 St. |
#                                                          | (6)    | -2 St. | -1 St. |
#                                                          | (7)    | -2 St. | -2 St. |
#                                                              \
#                                                               \
#                                                                \
#                                                                  -------- KGS047B ungebucht
#                                                                           1 St. (7!)
#                                                                           | Aktion | remge  | refrg  |
#                                                                           |        | -1 St. | -1 St. |
#

Scenario: VK: Remge bei RE ueber LS, RLS und KGS buchen

Given I open an editor "BE047" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE047  |
   | ebeleg | BE047  |
And I append rows
   | artikel | he     | mge |
   | A100    | Stueck | 10  |
And I save the current editor

# Ersten Lieferschein aus Bestellung erzeugen, nocht nicht buchen
Given I open an editor "LS047" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE047"
And I set fields
   | such   | LS047  |
   | ebeleg | LS047  |
   | vom    | .      |
   | ueb    | true   |
Then the table has 1 rows
And I set field "mge" to "7" in row 1
And I save the current editor

# Pruefe remge und refrg in Bestellung
Then field "remge" from editor "BE047" in row 1 has value "3"
Then field "refrg" from editor "BE047" in row 1 has value "0"

# Ausgabe Lieferschein
Given I open an editor "LS047V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS047"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "7" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Rechnung zu den Lieferschein ueber 5 Stueck
Given I open an editor "RE047" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS047"
And I set fields
   | such   | RE047   |
   | ebeleg | RE047   |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg in Bestellung
Then field "remge" from editor "BE047" in row 1 has value "3"
Then field "refrg" from editor "BE047" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS047" in row 1 has value "2"
Then field "refrg" from editor "LS047" in row 1 has value "0"

# Rechnung 2 zu den Lieferschein ueber 2 Stueck ungebucht
Given I open an editor "RE047B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS047"
And I set fields
   | such   | RE047B  |
   | ebeleg | RE047B  |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg in Bestellung
Then field "remge" from editor "BE047" in row 1 has value "3"
Then field "refrg" from editor "BE047" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS047" in row 1 has value "2"
Then field "refrg" from editor "LS047" in row 1 has value "2"
# Pruefe refrg in gebuchter Rechnung 1
Then field "refrg" from editor "RE047" in row 1 has value "0"
# Pruefe remge und refrg in ungebuchter Rechnung
Then field "remge" from editor "RE047B" in row 1 has value "2"
Then field "refrg" from editor "RE047B" in row 1 has value "2"

# Ruecklieferschein 1 zu LS 1
Given I open an editor "RLS047" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS047"
And I set fields
   | such   | RLS047   |
   | ebeleg | RLS047   |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-4" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "LS047V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS047"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "2" in row 1
Then field "refrg" has value "2" in row 1
And I close the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE047" in row 1 has value "3"
Then field "refrg" from editor "BE047" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein 2
Then field "remge" from editor "LS047" in row 1 has value "2"
Then field "refrg" from editor "LS047" in row 1 has value "2"
# Pruefe remge und refrg im Ruecklieferschein
Then field "remge" from editor "RLS047" in row 1 has value "-2"
Then field "refrg" from editor "RLS047" in row 1 has value "0"
# Pruefe refrg in gebuchter Rechnung 1
Then field "refrg" from editor "RE047" in row 1 has value "0"
# Pruefe remge und refrg in ungebuchter Rechnung
Then field "remge" from editor "RE047B" in row 1 has value "2"
Then field "refrg" from editor "RE047B" in row 1 has value "2"


# Teilgutschrift 1 zu RLS 1 nicht buchen
Given I open an editor "KGS047" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS047"
And I set fields
   | such   | KGS047  |
   | ebeleg | KGS047  |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg in Bestellung
Then field "remge" from editor "BE047" in row 1 has value "3"
Then field "refrg" from editor "BE047" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS047" in row 1 has value "2"
Then field "refrg" from editor "LS047" in row 1 has value "2"
# Pruefe remge und refrg im Ruecklieferschein
Then field "remge" from editor "RLS047" in row 1 has value "-2"
Then field "refrg" from editor "RLS047" in row 1 has value "-2"
# Pruefe remge und refrg in der kaufm. Gutschrift
Then field "remge" from editor "KGS047" in row 1 has value "-2"
Then field "refrg" from editor "KGS047" in row 1 has value "-2"


# Teilgutschrift 1 aendern
Given I open an editor "KGS047" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS047"
And I set field "mge" to "-1" in row 1
And I save the current editor

# Pruefe remge und refrg in Bestellung
Then field "remge" from editor "BE047" in row 1 has value "3"
Then field "refrg" from editor "BE047" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS047" in row 1 has value "2"
Then field "refrg" from editor "LS047" in row 1 has value "2"
# Pruefe remge und refrg im Ruecklieferschein
Then field "remge" from editor "RLS047" in row 1 has value "-2"
Then field "refrg" from editor "RLS047" in row 1 has value "-1"
# Pruefe remge und refrg in der kaufm. Gutschrift
Then field "remge" from editor "KGS047" in row 1 has value "-1"
Then field "refrg" from editor "KGS047" in row 1 has value "-1"


# Teilgutschrift 2 zu RLS 1 nicht buchen
Given I open an editor "KGS047B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS047"
And I set fields
   | such   | KGS047B |
   | ebeleg | KGS047B |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "-1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg in Bestellung
Then field "remge" from editor "BE047" in row 1 has value "3"
Then field "refrg" from editor "BE047" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS047" in row 1 has value "2"
Then field "refrg" from editor "LS047" in row 1 has value "2"
# Pruefe remge und refrg im Ruecklieferschein
Then field "remge" from editor "RLS047" in row 1 has value "-2"
Then field "refrg" from editor "RLS047" in row 1 has value "-2"
# Pruefe remge und refrg im Ruecklieferschein2
Then field "remge" from editor "KGS047B" in row 1 has value "-1"
Then field "refrg" from editor "KGS047B" in row 1 has value "-1"

# Rechnung stornieren
And opening an editor from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "RE047" throws the exception "1582"

# -----------------------------------------------------------------------------
#         Ungebuchte Teilrechnungen ohne LB aus der Bestellung
# -----------------------------------------------------------------------------

#  BE048 ---------------- RE048A ohne LB
#  12 St.                 5 St. (1!) (ungebucht)
#  | Aktion | remge  |    | Aktion | remge  |
#  |        | 12 St. |    |   (1)  | 12 St. |
#  |  (2)   | 12 St. |    |   (2)  | 12 St. |
#  |  (3)   | 12 St. |    |   (3)  | 12 St. |
#             \
#              \
#               \
#                 ---------------- LS048 ------------ RLS48 ---------- SRLS048
#                                  8 St.              -7 St (2!)       7 St (3!)

Scenario: Teilrechnung aus BE nicht gebucht, LS aus BE, RLS buchen, Storno RLS

# Bestellung anlegen
Given I create a PurchaseOrder "BE048" for Vendor "1" with Product "A100" and quantity "12"

Then field "remge" from editor "BE048" in row 1 has value "12"

# Rechnung ohne LB aus BE, ungebucht
Given I open an editor "RE048A" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg | BE048  |
   | ebeleg| RE048A |
   | such  | RE048A |
   | tterm | .      |
   | fakt  | false  |
   | vom   | .      |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Offene Rechnungsmenge in Bestellung und Rechnung pruefen
Then field "refrg" from editor "BE048" in row 1 has value "5"
Then field "remge" from editor "BE048" in row 1 has value "12"
Then field "remge" from editor "RE048A" in row 1 has value "12"

# Lieferschein aus Bestellung erzeugen
Given I open an editor "LS048" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE048"
And I set fields
   | such   | LS048 |
   | ebeleg | LS048 |
   | ueb    | true  |
   | vom    | .     |
Then the table has 1 rows
And I set field "mge" to "8" in row 1
And I save the current editor

# Ruecklieferschein 1 zu LS 1
Given I open an editor "RLS048" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS048"
And I set fields
   | such   | RLS048 |
   | ebeleg | RLS048 |
   | ueb    | true   |
   | vom    | .      |
And I set field "mge" to "-7" in row 1
And I save the current editor

# Offene Rechnungsmenge in Bestellung und Rechnung pruefen
Then field "refrg" from editor "BE048" in row 1 has value "5"
Then field "remge" from editor "BE048" in row 1 has value "12"
Then field "remge" from editor "RE048A" in row 1 has value "12"

# Ruecklieferschein stornieren
Given I open an editor "SRLS048" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "RLS048"
And I save the current editor

# Offene Rechnungsmenge in Bestellung und Rechnungen pruefen
Then field "refrg" from editor "BE048" in row 1 has value "5"
Then field "remge" from editor "BE048" in row 1 has value "12"
Then field "remge" from editor "RE048A" in row 1 has value "12"


# -----------------------------------------------------------------------------
# RLS: offene Rechnungsmenge in den ungebuchten RE reduzieren, falls groesser als die erlaubte remge, sonst lassen.
# RE: beim Buchen die remge in allen offenen Rechnungen anpassen, um die maximal noch ausstehende Rechnungsmenge.
# SRLS: offene Rechnungsmenge in den ungebuchten RE und der BE erhoehen.
# -----------------------------------------------------------------------------
#
# BE049 ------------------------ RE049A ohne LB ------------------ RE049A buchen
# 12 St.                        7 St. (1!) (ungebucht)            1 St. (4!)
# | Aktion | remge  | refrg |   | Aktion | remge  |
# |        | 12 St. |       |   |   (1)  | 12 St. |
# |  (1)   | 12 St. |  7 St.|   |   (2)  |  7 St. |
# |  (2)   | 12 St. | 12 St.|   |   (3)  |  7 St. |
# |  (3)   | 12 St. | 12 St.|   |   (4)  |  0 St. |
# |  (4)   | 11 St. |  5 St.|
# |  (5)   | 11 St. |  5 St.|
#       \      \
#        \      \
#         \      \
#          \       --------------- RE049B ohne LB
#           \                      5 St. (2!) (ungebucht)
#            \                     | Aktion | remge  |
#             \                    |    neu |  5 St. |
#              \                   |   (2)  |  5 St. |
#               \                  |   (3)  |  5 St. |
#                \                 |   (4)  | 11 St. |
#                 \                |   (5)  | 11 St. |
#                  \
#                    ---------------- LS049 ------------ RLS049 ---------- SRLS049
#                                     8 St.              -6 St (3!)        6 St. (5!)

Scenario: Teilrechnungen aus BE nicht gebucht, LS aus BE, RLS buchen, RE 2 buchen, Storno RLS

# Bestellung anlegen
Given I create a PurchaseOrder "BE049" for Vendor "1" with Product "A100" and quantity "12"

Then field "remge" from editor "BE049" in row 1 has value "12"

# 1. Teilrechnung 049A ohne LB aus BE, ungebucht
Given I open an editor "RE049A" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg | BE049  |
   | ebeleg| RE049A |
   | such  | RE049A |
   | tterm | .      |
   | fakt  | false  |
   | vom   | .      |
Then the table has 1 rows
And I set field "mge" to "7" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# refrg und remge in Bestellung und Rechnung pruefen
Then field "refrg" from editor "BE049" in row 1 has value "7"
Then field "remge" from editor "BE049" in row 1 has value "12"
Then field "remge" from editor "RE049A" in row 1 has value "12"

# 2. Teilrechnung 049B ohne LB aus BE, ungebucht
Given I open an editor "RE049B" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg | BE049  |
   | ebeleg| RE049B |
   | such  | RE049B |
   | tterm | .      |
   | vom   | .      |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Offene und vorgemerkte Rechnungsmenge in Bestellung und Rechnungen pruefen
Then field "refrg" from editor "BE049" in row 1 has value "12"
Then field "remge" from editor "BE049" in row 1 has value "12"
Then field "remge" from editor "RE049A" in row 1 has value "7"
Then field "remge" from editor "RE049B" in row 1 has value "5"

# Lieferschein aus Bestellung erzeugen
Given I open an editor "LS049" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE049"
And I set fields
   | such   | LS049 |
   | ebeleg | LS049 |
   | ueb    | true  |
   | vom    | .     |
Then the table has 1 rows
And I set field "mge" to "8" in row 1
And I save the current editor

# 3. Ruecklieferschein zu LS049
Given I open an editor "RLS049" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS049"
And I set fields
   | such   | RLS049 |
   | ueb    | true   |
   | vom    | .      |
And I set field "mge" to "-6" in row 1
And I save the current editor

# refrg und remge in Bestellung und Rechnung pruefen
Then field "refrg" from editor "BE049" in row 1 has value "12"
Then field "refrg" from editor "RE049A" in row 1 has value "7"
Then field "refrg" from editor "RE049B" in row 1 has value "5"
Then field "remge" from editor "BE049" in row 1 has value "12"
Then field "remge" from editor "RE049A" in row 1 has value "7"
Then field "remge" from editor "RE049B" in row 1 has value "5"

# 4. Teilrechnung RE049A buchen
Given I open an editor "RE049A" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE049A"
And I set field "mge" to "1" in row 1
And I set field "ueb" to "ja"
And I save the current editor

# Offene und vorgemerkte Rechnungsmenge in Bestellung und Rechnungen pruefen
Then field "refrg" from editor "BE049" in row 1 has value "5"
Then field "remge" from editor "BE049" in row 1 has value "11"
Then field "remge" from editor "RE049B" in row 1 has value "11"

# 5. Ruecklieferschein RLS049 stornieren
Given I open an editor "SRLS049" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "RLS049"
And I save the current editor

# Offene Rechnungsmenge in Bestellung und Rechnungen pruefen
Then field "refrg" from editor "BE049" in row 1 has value "5"
Then field "remge" from editor "BE049" in row 1 has value "11"
Then field "remge" from editor "RE049B" in row 1 has value "11"


# ----------------------------------------------------------------------------- #
#         Gleiches wie zuvor, nur mit unterschiedlichen Handelseinheiten        #
# ----------------------------------------------------------------------------- #

Scenario: Teilrechnungen aus BE nicht gebucht, LS aus BE, RLS buchen, RE 2 buchen, Storno RLS, unterschiedliche HE

# Bestellung anlegen
Given I create a PurchaseOrder "BE050" for Vendor "1" with Product "A100" and quantity "12"

Then field "remge" from editor "BE050" in row 1 has value "12"

# Teilrechnung 1 ohne LB aus BE, ungebucht
Given I open an editor "RE050A" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg | BE050  |
   | ebeleg| RE050A |
   | such  | RE050A |
   | tterm | .      |
   | fakt  | false  |
   | vom   | .      |
Then the table has 1 rows
# 1 Stueck enstpricht 2 kg
And I set field "he" to "kg" in row 1
And I set field "mge" to "14" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# refrg und remge in Bestellung und Rechnung pruefen
# in LE
Then field "refrg" from editor "BE050" in row 1 has value "7"
Then field "remge" from editor "BE050" in row 1 has value "12"
# in HE
Then field "remge" from editor "RE050A" in row 1 has value "24"

# 2. Teilrechnung 050B ohne LB aus BE, ungebucht
Given I open an editor "RE050B" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg | BE050  |
   | ebeleg| RE050B |
   | such  | RE050B |
   | tterm | .      |
   | vom   | .      |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# refrg und remge in Bestellung und Rechnungen pruefen
Then field "refrg" from editor "BE050" in row 1 has value "12"
Then field "remge" from editor "BE050" in row 1 has value "12"
# in HE
Then field "remge" from editor "RE050A" in row 1 has value "14"
# in LE
Then field "remge" from editor "RE050B" in row 1 has value "5"

# Lieferschein aus Bestellung erzeugen
Given I open an editor "LS050" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE050"
And I set fields
   | such   | LS050 |
   | ebeleg | LS050 |
   | ueb    | true  |
   | vom    | .     |
Then the table has 1 rows
And I set field "he" to "kg" in row 1
And I set field "mge" to "16" in row 1
And I save the current editor

# 3. Ruecklieferschein zu LS 050
Given I open an editor "RLS050" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS050"
And I set fields
   | such   | RLS050 |
   | ueb    | true   |
   | vom    | .      |
And I set field "mge" to "-12" in row 1
And I save the current editor

# refrg und remge in Bestellung und Rechnung pruefen
Then field "refrg" from editor "RE050A" in row 1 has value "7"
Then field "refrg" from editor "RE050B" in row 1 has value "5"
Then field "remge" from editor "BE050" in row 1 has value "12"
# in HE
Then field "remge" from editor "RE050A" in row 1 has value "14"
# in LE
Then field "remge" from editor "RE050B" in row 1 has value "5"

# 4. Teilrechnung 050A buchen
Given I open an editor "RE050A" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE050A"
And I set field "mge" to "2" in row 1
And I set field "ueb" to "ja"
And I save the current editor

# Offene Rechnungsmenge in Bestellung und Rechnungen pruefen
Then field "remge" from editor "BE050" in row 1 has value "11"
Then field "remge" from editor "RE050B" in row 1 has value "11"

# 5. Ruecklieferschein stornieren
Given I open an editor "SRLS050" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "RLS050"
And I save the current editor

# Offene Rechnungsmenge in Bestellung und Rechnungen pruefen
Then field "remge" from editor "BE050" in row 1 has value "11"
Then field "remge" from editor "RE050B" in row 1 has value "11"


# -----------------------------------------------------------------------------
#         Ungebuchte Teilrechnungen bei LS aus BE, Storno RLS
# -----------------------------------------------------------------------------

#  BE051 -------------------------- LS051 --------------------------- RE051 ungebucht
#  10 St.                           10 St. (1!)                       6 St. (2!)
#  | Aktion | remge  | refrg |      | Aktion | remge  | refrg  |      | Aktion | remge  | refrg  |
#  |        | 10 St. | 0 St. |      |        | 10 St. |  0 St. |      |        | 10 St. |  6 St. |
#  | (1)    |  0 St. | 0 St. |      | (2)    | 10 St. |  6 St. |      | (3)    |  6 St. |  6 St. |
#                                   | (3)    | 10 St. | 10 St. |      | (4)    |  6 St. |  6 St. |
#                                   | (4)    | 10 St. | 10 St. |      | (5)    |  6 St. |  6 St. |
#                                   | (5)    | 10 St. | 10 St. |
#                                    \
#                                     \
#                                      \
#                                        -------- RE051B ungebucht
#                                        \        4 St. (3!)
#                                         \       | Aktion | remge  | refrg  |
#                                          \      |        |  4 St. |  4 St. |
#                                           \     |        |  4 St. |  4 St. |
#                                            \    | (4)    |  4 St. |  4 St. |
#                                             \   | (5)    |  4 St. |  4 St. |
#                                              \
#                                               ----- RLS051 ----------------------- SRLS051
#                                                     -5 St. (4!)                    -5 St. (5!)
#                                                     | Aktion | remge | refrg |     | Aktion | remge | refrg |
#                                                     |        | -5 St.|  0 St.|     |        | -5 St.| -0 St.|
#

Scenario: Remge bei RE ueber LS, 2 RE ungebucht, RLS stornieren

Given I open an editor "BE051" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE051  |
   | ebeleg | BE051  |
And I append rows
   | artikel | he     | mge |
   | A100    | Stueck | 10  |
And I save the current editor

# Ersten Lieferschein aus Bestellung erzeugen
Given I open an editor "LS051" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE051"
And I set fields
   | such   | LS051  |
   | ebeleg | LS051  |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "10" in row 1
And I save the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE051" in row 1 has value "0"
Then field "refrg" from editor "BE051" in row 1 has value "0"

# Ausgabe Lieferschein
Given I open an editor "LS051V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS051"
# Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "10" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Rechnung zu den Lieferschein ueber 6 Stueck ungebucht
Given I open an editor "RE051" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS051"
And I set fields
   | such   | RE051   |
   | ebeleg | RE051   |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "6" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE051" in row 1 has value "0"
Then field "refrg" from editor "BE051" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS051" in row 1 has value "10"
Then field "refrg" from editor "LS051" in row 1 has value "6"
# Pruefe remge und refrg in Rechnung 1
Then field "remge" from editor "RE051" in row 1 has value "10"
Then field "refrg" from editor "RE051" in row 1 has value "6"

# Rechnung 2 zu den Lieferschein ueber 4 Stueck ungebucht
Given I open an editor "RE051B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS051"
And I set fields
   | such   | RE051B  |
   | ebeleg | RE051B  |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE051" in row 1 has value "0"
Then field "refrg" from editor "BE051" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS051" in row 1 has value "10"
Then field "refrg" from editor "LS051" in row 1 has value "10"
# Pruefe remge und refrg im Rechnung 1
Then field "remge" from editor "RE051" in row 1 has value "6"
Then field "refrg" from editor "RE051" in row 1 has value "6"
# Pruefe remge und refrg im Ruecklieferschein
Then field "remge" from editor "RE051B" in row 1 has value "4"
Then field "refrg" from editor "RE051B" in row 1 has value "4"

# Ruecklieferschein 1 zu LS 1
Given I open an editor "RLS051" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS051"
And I set fields
   | such   | RLS051   |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "LS051V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS051"
# Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "10" in row 1
Then field "refrg" has value "10" in row 1
And I close the current editor

# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS051" in row 1 has value "10"
Then field "refrg" from editor "LS051" in row 1 has value "10"
# Pruefe remge und refrg im Ruecklieferschein
Then field "remge" from editor "RLS051" in row 1 has value "0"
Then field "refrg" from editor "RLS051" in row 1 has value "0"
# Pruefe remge und refrg im Rechnung 1
Then field "remge" from editor "RE051" in row 1 has value "6"
Then field "refrg" from editor "RE051" in row 1 has value "6"
# Pruefe remge und refrg im Rechnung 2
Then field "remge" from editor "RE051B" in row 1 has value "4"
Then field "refrg" from editor "RE051B" in row 1 has value "4"

# Ruecklieferschein stornieren
Given I open an editor "SRL051" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "RLS051"
And I save the current editor

# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS051" in row 1 has value "10"
Then field "refrg" from editor "LS051" in row 1 has value "10"
# Pruefe remge und refrg im Ruecklieferschein
Then field "remge" from editor "RLS051" in row 1 has value "0"
Then field "refrg" from editor "RLS051" in row 1 has value "0"
# Pruefe remge und refrg im Rechnung 1
Then field "remge" from editor "RE051" in row 1 has value "6"
Then field "refrg" from editor "RE051" in row 1 has value "6"
# Pruefe remge und refrg im Rechnung 2
Then field "remge" from editor "RE051B" in row 1 has value "4"
Then field "refrg" from editor "RE051B" in row 1 has value "4"


#  BE052 ------------------------- LS052 -------------------------- RE052A ungebucht --------------- RE052A buchen
#  10 St.                          10 St. (1!)                      6 St. (2!)                       1 St. (5!)
#  | Aktion | remge  | refrg |     | Aktion | remge  | refrg  |     | Aktion | remge  | refrg  |
#  |        | 10 St. | 0 St. |     |        | 10 St. |  0 St. |     |        | 10 St. |  6 St. |
#  | (1)    |  0 St. | 0 St. |     | (2)    | 10 St. |  6 St. |     | (3)    |  6 St. |  6 St. |
#                                  | (3)    | 10 St. | 10 St. |     | (4)    |  6 St. |  6 St. |
#                                  | (4)    | 10 St. | 10 St. |     | (5)    |  0 St. |  0 St. |
#                                  | (5)    |  9 St. |  4 St. |
#                                  | (6)    |  9 St. |  4 St. |
#                                    \
#                                     \
#                                      \
#                                        -------- RE052B   ungebucht ---------
#                                        \       4 St. (3!)
#                                         \      | Aktion | remge  | refrg  |
#                                          \     |        |  4 St. |  4 St. |
#                                           \    | (4)    |  4 St. |  4 St. |
#                                            \   | (5)    |  4 St. |  4 St. |
#                                             \  | (6)    |  9 St. |  4 St. |
#                                              \
#                                               ------------RLS052 -------------------------- SRLS052
#                                                           -5 St. (4!)                       -5 St. (6!)
#                                                           | Aktion | remge  | refrg  |      | Aktion | remge  | refrg  |
#                                                           |        | -5 St. |  0 St. |      |        | -5 St. | -0 St. |
#
#
#
#

Scenario: Remge bei RE ueber LS, RE ungebucht, RLS, RE buchen, RLS stornieren

Given I open an editor "BE052" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE052  |
   | ebeleg | BE052  |
And I append rows
   | artikel | he     | mge |
   | A100    | Stueck | 10  |
And I save the current editor

# Ersten Lieferschein aus Bestellung erzeugen
Given I open an editor "LS052" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE052"
And I set fields
   | such   | LS052  |
   | ebeleg | LS052  |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "10" in row 1
And I save the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE052" in row 1 has value "0"
Then field "refrg" from editor "BE052" in row 1 has value "0"

# Ausgabe Lieferschein
Given I open an editor "LS052V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS052"
# Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "10" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Rechnung zu den Lieferschein ueber 6 Stueck ungebucht
Given I open an editor "RE052A" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS052"
And I set fields
   | such   | RE052A  |
   | ebeleg | RE052A  |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "6" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE052" in row 1 has value "0"
Then field "refrg" from editor "BE052" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS052" in row 1 has value "10"
Then field "refrg" from editor "LS052" in row 1 has value "6"
# Pruefe remge und refrg in Rechnung 1
Then field "remge" from editor "RE052A" in row 1 has value "10"
Then field "refrg" from editor "RE052A" in row 1 has value "6"

# Rechnung 2 zu den Lieferschein ueber 4 Stueck ungebucht
Given I open an editor "RE052B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS052"
And I set fields
   | such   | RE052B  |
   | ebeleg | RE052B  |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE052" in row 1 has value "0"
Then field "refrg" from editor "BE052" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS052" in row 1 has value "10"
Then field "refrg" from editor "LS052" in row 1 has value "10"
# Pruefe remge und refrg im Rechnung 1
Then field "remge" from editor "RE052A" in row 1 has value "6"
Then field "refrg" from editor "RE052A" in row 1 has value "6"
# Pruefe remge und refrg im Ruecklieferschein
Then field "remge" from editor "RE052B" in row 1 has value "4"
Then field "refrg" from editor "RE052B" in row 1 has value "4"

# Ruecklieferschein 1 zu LS 1
Given I open an editor "RLS052" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS052"
And I set fields
   | such   | RLS052   |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "LS052V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS052"
# Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "10" in row 1
Then field "refrg" has value "10" in row 1
And I close the current editor

# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS052" in row 1 has value "10"
Then field "refrg" from editor "LS052" in row 1 has value "10"
# Pruefe remge und refrg im Ruecklieferschein
Then field "remge" from editor "RLS052" in row 1 has value "0"
Then field "refrg" from editor "RLS052" in row 1 has value "0"
# Pruefe remge und refrg im Rechnung 1
Then field "remge" from editor "RE052A" in row 1 has value "6"
Then field "refrg" from editor "RE052A" in row 1 has value "6"
# Pruefe remge und refrg im Rechnung 2
Then field "remge" from editor "RE052B" in row 1 has value "4"
Then field "refrg" from editor "RE052B" in row 1 has value "4"

Given I open an editor "RE052A" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE052A"
And I set fields
   | ueb    | true    |
And I set field "mge" to "1" in row 1
And I save the current editor

# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS052" in row 1 has value "9"
Then field "refrg" from editor "LS052" in row 1 has value "4"
# Pruefe refrg in gebuchter Rechnung 1
Then field "refrg" from editor "RE052A" in row 1 has value "0"
# Pruefe remge und refrg in ungebuchter Rechnung 2
Then field "remge" from editor "RE052B" in row 1 has value "9"
Then field "refrg" from editor "RE052B" in row 1 has value "4"

# Ruecklieferschein stornieren
Given I open an editor "SRL052" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "RLS052"
And I save the current editor

# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS052" in row 1 has value "9"
Then field "refrg" from editor "LS052" in row 1 has value "4"
# Pruefe remge und refrg im Ruecklieferschein
Then field "remge" from editor "RLS052" in row 1 has value "0"
Then field "refrg" from editor "RLS052" in row 1 has value "0"
# Pruefe refrg in gebuchter Rechnung 1
Then field "refrg" from editor "RE052A" in row 1 has value "0"
# Pruefe remge und refrg in ungebuchter Rechnung 2
Then field "remge" from editor "RE052B" in row 1 has value "9"
Then field "refrg" from editor "RE052B" in row 1 has value "4"

# ----------------------------------------------------------------------------- #
#         Aehnlich wie 051, nur mit unterschiedlichen Handelseinheiten          #
# ----------------------------------------------------------------------------- #

#  BE055 -------------------------- LS055 --------------------------- RE055 ungebucht
#   25 St.                          25 St. (1!)                        18 kg = 9 St. (2!)
#    | Aktion | remge  |  refrg |   | Aktion | remge   | refrg    |   | Aktion | remge  | refrg  |
#    |        | 25 St. |  0 St. |   |        | 25 St.  |  0   St. |   |        |  50 kg |  9 St. |
#    | (1)    |  0 St. |  0 St. |   | (2)    | 25 St.  |  9   St. |   | (3)    |  38 kg |  9 St. |
#                                   | (3)    | 25 St.  | 15   St. |   | (4)    |  23 kg |  9 St. |
#                                   | (4)    | 25 St.  | 22.5 St. |   | (5)    |  23 kg |  9 St. |
#                                   | (5)    | 25 St.  | 22.5 St. |   | (6)    |  23 kg |  9 St. |
#                                   | (6)    | 25 St.  | 22.5 St. |
#                                    \
#                                     \
#                                       -------- RE055B   ungebucht
#                                       \        6 St. (3!)
#                                        \       | Aktion | remge    | refrg  |
#                                         \      |        | 16   St. |  6 St. |
#                                          \     | (4)    |  8.5 St. |  6 St. |
#                                           \    | (6)    |  8.5 St. |  6 St. |
#                                            \   | (6)    |  8.5 St. |  6 St. |
#                                             \
#                                               -------- RE055C  ungebucht
#                                               \        15 kg = 7.5 St. (4!)
#                                                \       | Aktion | remge  | refrg    |
#                                                 \      |        |  20 kg |  7.5 St. |
#                                                  \     | (5)    |  20 kg |  7.5 St. |
#                                                   \    | (6)    |  20 kg |  7.5 St. |
#                                                    \
#                                                      ------ RLS055 ----------------------- SRLS055
#                                                             -18 St. (5!)                    -18 St. (6!)
#                                                             | Aktion | remge  | refrg |     | Aktion | remge  | refrg |
#                                                             |        | -18 St.|  0 St.|     |        | -18 St.| -0 St.|
#


Scenario: VK: Remge bei RE ueber LS, RLS buchen

Given I open an editor "BE055" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE055  |
And I append rows
   | artikel | he     | mge |
   | A100    | Stueck | 25  |
And I save the current editor

# Ersten Lieferschein aus Bestellung erzeugen
Given I open an editor "LS055" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE055"
And I set fields
   | such   | LS055  |
   | ebeleg | LS055  |
   | vom    | .      |
   | ueb    | true   |
Then the table has 1 rows
And I set field "mge" to "25" in row 1
And I save the current editor

# Pruefe remge und refrg im Bestellung
Then field "remge" from editor "BE055" in row 1 has value "0"
Then field "refrg" from editor "BE055" in row 1 has value "0"

# Ausgabe Lieferschein
Given I open an editor "LS055V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS055"
# Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "25" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Rechnung zu den Lieferschein ueber 12 kg = 6 Stueck ungebucht
Given I open an editor "RE055" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS055"
And I set fields
   | such   | RE055   |
   | ebeleg | RE055   |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "he" to "kg" in row 1
And I set field "mge" to "18" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg in Bestellung
Then field "remge" from editor "BE055" in row 1 has value "0"
Then field "refrg" from editor "BE055" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS055" in row 1 has value "25"
Then field "refrg" from editor "LS055" in row 1 has value "9"
# Pruefe remge und refrg in Rechnung 1
Then field "remge" from editor "RE055" in row 1 has value "50"
Then field "refrg" from editor "RE055" in row 1 has value "9"

# Rechnung 2 zu den Lieferschein ueber 4 Stueck ungebucht
Given I open an editor "RE055B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS055"
And I set fields
   | such   | RE055B  |
   | ebeleg | RE055B  |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "6" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg in Bestellung
Then field "remge" from editor "BE055" in row 1 has value "0"
Then field "refrg" from editor "BE055" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS055" in row 1 has value "25"
Then field "refrg" from editor "LS055" in row 1 has value "15"
# Pruefe remge und refrg in Rechnung 1
Then field "remge" from editor "RE055" in row 1 has value "38"
Then field "refrg" from editor "RE055" in row 1 has value "9"
# Pruefe remge und refrg in Rechnung 2
Then field "remge" from editor "RE055B" in row 1 has value "16"
Then field "refrg" from editor "RE055B" in row 1 has value "6"

# Rechnung 2 zu den Lieferschein ueber 25 kg = 12.5 Stueck ungebucht
Given I open an editor "RE055C" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS055"
And I set fields
   | such   | RE055C  |
   | ebeleg | RE055C  |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "he" to "kg" in row 1
And I set field "mge" to "15" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg in Bestellung
Then field "remge" from editor "BE055" in row 1 has value "0"
Then field "refrg" from editor "BE055" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS055" in row 1 has value "25"
Then field "refrg" from editor "LS055" in row 1 has value "22.5"
# Pruefe remge und refrg in Rechnung 1
Then field "remge" from editor "RE055" in row 1 has value "23"
Then field "refrg" from editor "RE055" in row 1 has value "9"
# Pruefe remge und refrg in Rechnung 2
Then field "remge" from editor "RE055B" in row 1 has value "8.5"
Then field "refrg" from editor "RE055B" in row 1 has value "6"
# Pruefe remge und refrg  in Rechnung 3
Then field "remge" from editor "RE055C" in row 1 has value "20"
Then field "refrg" from editor "RE055C" in row 1 has value "7.5"

# Ruecklieferschein 1 zu LS 1
Given I open an editor "RLS055" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS055"
And I set fields
   | such   | RLS055   |
   | ebeleg | RE055C |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-18" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "LS055V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS055"
# Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "25" in row 1
Then field "refrg" has value "22.5" in row 1
And I close the current editor

# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS055" in row 1 has value "25"
Then field "refrg" from editor "LS055" in row 1 has value "22.5"
# Pruefe remge und refrg im Ruecklieferschein
Then field "remge" from editor "RLS055" in row 1 has value "0"
Then field "refrg" from editor "RLS055" in row 1 has value "0"
# Pruefe remge und refrg in Rechnung 1
Then field "remge" from editor "RE055" in row 1 has value "23"
Then field "refrg" from editor "RE055" in row 1 has value "9"
# Pruefe remge und refrg in Rechnung 2
Then field "remge" from editor "RE055B" in row 1 has value "8.5"
Then field "refrg" from editor "RE055B" in row 1 has value "6"
# Pruefe remge und refrg in Rechnung 3
Then field "remge" from editor "RE055C" in row 1 has value "20"
Then field "refrg" from editor "RE055C" in row 1 has value "7.5"

# Ruecklieferschein stornieren
Given I open an editor "SRL055" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "RLS055"
And I save the current editor

# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS055" in row 1 has value "25"
Then field "refrg" from editor "LS055" in row 1 has value "22.5"
# Pruefe remge und refrg im Ruecklieferschein
Then field "remge" from editor "RLS055" in row 1 has value "0"
Then field "refrg" from editor "RLS055" in row 1 has value "0"
# Pruefe remge und refrg in Rechnung 1
Then field "remge" from editor "RE055" in row 1 has value "23"
Then field "refrg" from editor "RE055" in row 1 has value "9"
# Pruefe remge und refrg in Rechnung 2
Then field "remge" from editor "RE055B" in row 1 has value "8.5"
Then field "refrg" from editor "RE055B" in row 1 has value "6"
# Pruefe remge und refrg in Rechnung 3
Then field "remge" from editor "RE055C" in row 1 has value "20"
Then field "refrg" from editor "RE055C" in row 1 has value "7.5"

# -----------------------------------------------------------------------------
#   Offene Rechnungsmenge in ungebuchten Rechnungen mit/ohne LB aus BE,
#   RLS aus RE, Storno des RLS - kein Einfluss auf (remge, refrg)
# -----------------------------------------------------------------------------

#  BE053 ------------------------ RE053A mit LB buchen -------- RLS053 -------------- SRLS053
#  12 St.                         6 St. (1!)                    -4 St. (4!)           4 St. (5!)
#  | Aktion | remge  | refrg  |   | Aktion | remge  |           | Aktion | remge |
#  |        | 12 St. |  0 St. |   |  (1)   |  0 St. |           |  (4)   |  0 St.|
#  | (1)    |  6 St. |  0 St. |
#  | (2)    |  6 St. |  4 St. |
#  | (3)    |  6 St. |  5 St. |
#  | (4)    |  6 St. |  5 St. |
#  | (5)    |  6 St. |  5 St. |
#      \         \
#       \         \
#        \         \
#         \          ------------------ RE053B mit LB, ungebucht
#          \                            4 St. (2!)
#           \                           | Aktion | remge  |
#            \                          |  (2)   |  6 St. |
#             \                         |  (3)   |  5 St. |
#              \                        |  (4)   |  5 St. |
#               \                       |  (5)   |  5 St. |
#                \
#                  --------------------------- RE053C ohne LB, ungebucht
#                                              1 St. (3!)
#                                              | Aktion | remge  |
#                                              |  (3)   |  2 St. |
#                                              |  (4)   |  2 St. |
#                                              |  (5)   |  2 St. |
#

Scenario: ungebuchte/gebuchte Rechnungen mit und ohne LB, RLS, Storno RLS

# Bestellung anlegen
Given I create a PurchaseOrder "BE053" for Vendor "1" with Product "A100" and quantity "12"

# Teilrechnung 1 mit LB aus BE, gebucht
Given I open an editor "RE053A" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE053"
And I set fields
   | such   | RE053A |
   | ebeleg | RE053A |
   | fakt   | true   |
   | ueb    | ja     |
   | tterm  | .      |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "6" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# refrg in Bestellung bzw. remge in Bestellung/Rechnung pruefen
Then field "refrg" from editor "BE053" in row 1 has value "0"
Then field "remge" from editor "BE053" in row 1 has value "6"

# Teilrechnung 2 mit LB aus BE, ungebucht
Given I open an editor "RE053B" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE053"
And I set fields
   | such   | RE053B |
   | ebeleg | RE053B |
   | fakt   | true   |
   | tterm  | .      |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "4" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# refrg in Bestellung bzw. remge in Bestellung/Rechnung pruefen
Then field "refrg" from editor "BE053" in row 1 has value "4"
Then field "remge" from editor "BE053" in row 1 has value "6"
Then field "remge" from editor "RE053B" in row 1 has value "6"

# Teilrechnung 3 ohne LB aus BE, ungebucht
Given I open an editor "RE053C" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE053"
And I set fields
   | such   | RE053C |
   | ebeleg | RE053C |
   | tterm  | .      |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "1" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# refrg in Bestellung bzw. remge in Bestellung/Rechnung pruefen
Then field "refrg" from editor "BE053" in row 1 has value "5"
Then field "remge" from editor "BE053" in row 1 has value "6"
Then field "remge" from editor "RE053B" in row 1 has value "5"
Then field "remge" from editor "RE053C" in row 1 has value "2"

# Ruecklieferschein zu Rechnung A mit LB
Given I open an editor "RLS053" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+RE053A"
And I set fields
   | such   | RLS053 |
   | ebeleg | RLS053 |
   | ueb    | true   |
   | vom    | .      |
And I set field "mge" to "-4" in row 1
And I save the current editor

# refrg in Bestellung bzw. remge im Bestellung/Rechnung pruefen
Then field "refrg" from editor "BE053" in row 1 has value "5"
Then field "remge" from editor "BE053" in row 1 has value "6"
Then field "remge" from editor "RE053B" in row 1 has value "5"
Then field "remge" from editor "RE053C" in row 1 has value "2"

# Ruecklieferschein stornieren
Given I open an editor "SRL053" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "RLS053"
And I save the current editor

# refrg in Bestellung bzw. remge im Bestellung/Rechnung pruefen
Then field "refrg" from editor "BE053" in row 1 has value "5"
Then field "remge" from editor "BE053" in row 1 has value "6"
Then field "remge" from editor "RE053B" in row 1 has value "5"
Then field "remge" from editor "RE053C" in row 1 has value "2"


# ----------------------------------------------------------------------------- #
#         Gleiches wie zuvor, nur mit unterschiedlichen Handelseinheiten        #
# ----------------------------------------------------------------------------- #

Scenario: ungebuchte/gebuchte Rechnungen mit/ohne LB und verschiedene HE, RLS, Storno RLS

# Bestellung anlegen
Given I create a PurchaseOrder "BE054" for Vendor "1" with Product "A100" and quantity "12"

# Teilrechnung 1 mit LB aus BE, gebucht
Given I open an editor "RE054A" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE054"
And I set fields
   | such   | RE054A |
   | ebeleg | RE054A |
   | fakt   | true   |
   | ueb    | ja     |
   | tterm  | .      |
   | vom    | .      |
Then the table has 1 rows
And I set field "he" to "kg" in row 1
And I set field "mge" to "12" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# refrg in Bestellung bzw. remge in Bestellung/Rechnung pruefen
Then field "refrg" from editor "BE054" in row 1 has value "0"
Then field "remge" from editor "BE054" in row 1 has value "6"

# Teilrechnung 2 mit LB aus BE, ungebucht
Given I open an editor "RE054B" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE054"
And I set fields
   | such   | RE054B |
   | ebeleg | RE054B |
   | fakt   | true   |
   | tterm  | .      |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "4" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# refrg in Bestellung bzw. remge in Bestellung/Rechnung pruefen
Then field "refrg" from editor "BE054" in row 1 has value "4"
Then field "remge" from editor "BE054" in row 1 has value "6"
Then field "remge" from editor "RE054B" in row 1 has value "6"

# Teilrechnung 3 ohne LB aus BE, ungebucht
Given I open an editor "RE054C" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE054"
And I set fields
   | such   | RE054C |
   | ebeleg | RE054C |
   | tterm  | .      |
   | vom    | .      |
Then the table has 1 rows
And I set field "he" to "kg" in row 1
And I set field "mge" to "2" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# refrg in Bestellung bzw. remge in Bestellung/Rechnung pruefen
Then field "refrg" from editor "BE054" in row 1 has value "5"
Then field "remge" from editor "BE054" in row 1 has value "6"
Then field "remge" from editor "RE054B" in row 1 has value "5"
# Hier: Einheit kg ( 1 Stueck = 2 kg)
Then field "remge" from editor "RE054C" in row 1 has value "4"

# Ruecklieferschein zu Rechnung A mit LB
Given I open an editor "RLS054" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+RE054A"
And I set fields
   | such   | RLS054 |
   | ebeleg | RLS054 |
   | ueb    | true   |
   | vom    | .      |
And I set field "mge" to "-4" in row 1
And I save the current editor

# refrg in Bestellung bzw. remge im Bestellung/Rechnung pruefen
Then field "refrg" from editor "BE054" in row 1 has value "5"
Then field "remge" from editor "BE054" in row 1 has value "6"
Then field "remge" from editor "RE054B" in row 1 has value "5"
# Hier: Einheit kg ( 1 Stueck = 2 kg)
Then field "remge" from editor "RE054C" in row 1 has value "4"

# Ruecklieferschein stornieren
Given I open an editor "SRL054" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "RLS054"
And I save the current editor

# refrg in Bestellung bzw. remge im Bestellung/Rechnung pruefen
Then field "refrg" from editor "BE054" in row 1 has value "5"
Then field "remge" from editor "BE054" in row 1 has value "6"
Then field "remge" from editor "RE054B" in row 1 has value "5"
# Hier: Einheit kg (1 Stueck = 2 kg)
Then field "remge" from editor "RE054C" in row 1 has value "4"

#----------------------------------------------------------------------------------------------
# Aktualisierung von (ev)remge in offenen Rechnungen
#----------------------------------------------------------------------------------------------
#
#  BE057 --------> LS057 ------------------------- RE057-1 (offen, Positionssplit) ---> RE057-1 (gebucht) (12!)
#  10 St.          10 St. (1!)                     2 St. (2!) ---> 1 St. (7!) ---> 2 St. (9!)
#                  | Aktion | remge  | refrg  |    | Aktion | remge  | ofmge  |
#                  | (1)    | 10 St. | 0 St.  |    | (2)    | 10 St. | 8 St.  |
#                  | (2)    | 10 St. | 5 St.  |    | (3)    | 6 St.  | 4 St.  |
#                  | (3)    | 10 St. | 9 St.  |    | (4)    | 6 St.  | 4 St.  |
#                  | (4)    | 10 St. | 9 St.  |    | (5)    | 8 St.  | 6 St.  |
#                  | (5)    | 10 St. | 7 St.  |    | (6)    | 8 St.  | 6 St.  |
#                  | (6)    | 10 St. | 7 St.  |    | (7)    | 9 St.  | 8 St.  |
#                  | (7)    | 10 St. | 3 St.  |    | (8)    | 9 St.  | 8 St.  |
#                  | (8)    | 10 St. | 3 St.  |    | (9)    | 8 St.  | 6 St.  |
#                  | (9)    | 10 St. | 6 St.  |    | (10)   | 8 St.  | 6 St.  |
#                  | (10)   | 10 St. | 6 St.  |    | (11)   | 6 St.  | 4 St.  |
#                  | (11)   | 10 St. | 9 St.  |    | (12)   | 0 St.  | 4 St.  |
#                  | (12)   |  5 St. | 4 St.  |    | (13)   | 0 St.  | 4 St.  |
#                  | (13)   |  1 St. | 0 St.  |    |        |        |        |
#                     \                            3 St. (2!) ---> 1 St. (7!) ---> 2 St. (9!) ---> 3 St. (11!)
#                      \                           | Aktion | remge  | ofmge  |
#                       \                          | (2)    | 8 St.  | 5 St.  |
#                        \                         | (3)    | 4 St.  | 1 St.  |
#                         \                        | (4)    | 4 St.  | 1 St.  |
#                          \                       | (5)    | 6 St.  | 3 St.  |
#                           \                      | (6)    | 6 St.  | 3 St.  |
#                            \                     | (7)    | 8 St.  | 7 St.  |
#                             \                    | (8)    | 8 St.  | 7 St.  |
#                              \                   | (9)    | 6 St.  | 4 St.  |
#                               \                  | (10)   | 6 St.  | 4 St.  |
#                                \                 | (11)   | 4 St.  | 1 St.  |
#                                 \                | (12)   | 0 St.  | 1 St.  |
#                                  \               | (13)   | 0 St.  | 1 St.  |
#                                   \
#                                      ------------------------ RE057-2 (offen) ---> RE057-2 (gebucht) (13!)
#                                     \                         4 St. (3!) ---> 2 St. (5!) ---> 1 St. (7!) ---> 2 St. (9!) --> 4 St. (11!)
#                                      \                        | Aktion | remge  | ofmge  |
#                                       \                       | (3)    | 5 St.  | 1 St.  |
#                                        \                      | (4)    | 5 St.  | 1 St.  |
#                                         \                     | (5)    | 5 St.  | 3 St.  |
#                                          \                    | (6)    | 5 St.  | 3 St.  |
#                                           \                   | (7)    | 8 St.  | 7 St.  |
#                                            \                  | (8)    | 8 St.  | 7 St.  |
#                                             \                 | (9)    | 6 St.  | 4 St.  |
#                                              \                | (10)   | 6 St.  | 4 St.  |
#                                               \               | (11)   | 5 St.  | 1 St.  |
#                                                \              | (12)   | 5 St.  | 1 St.  |
#                                                 \             | (13)   | 0 St.  | 1 St.  |
#                                                  \
#                                                     --------------------------- RLS057-1 ---------- RLS057-1 (Storno)
#                                                    \                           -3 St. (4!)          3 St. (8!)
#                                                     \
#                                                        ---------------------------------- RLS057-2 ---------- RLS057-2 (Storno)
#                                                                                          -4 St. (6!)          4 St. (10!)
#

Scenario: Aktualisierung von (ev)remge in offenen Rechnungen - 1. Rechnung mit Splitpositionen

# Bestellung
Given I open an editor "BE057" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE057  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferschein (fakturierbar)
Given I open an editor "LS057" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE057"
And I set fields
   | such   | LS057  |
   | ebeleg | LS057  |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung 1 mit Splitposition
Given I open an editor "RE057-1" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS057"
And I set fields
   | such   | RE057-1 |
   | ebeleg | RE057-1 |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | nein    |
   | beleg  | LS057   |
And I set field "mge" to "2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE057-1" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE057-1"
And I delete row at position 2
And I delete row at position 2
And I delete row at position 2
And I set field "beleg" to "LS057"
And I set field "mge" to "3" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "LS057" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS057"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-1" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE057-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Aktualisierung von (ev)remge in offenen Rechnungen - 2. Rechnung

# Rechnung 2
Given I open an editor "RE057-2" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS057"
And I set fields
   | such   | RE057-2 |
   | ebeleg | RE057-2 |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | nein    |
And I set field "mge" to "4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "LS057" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS057"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-1" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE057-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-2" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE057-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Aktualisierung von (ev)remge in offenen Rechnungen - Ruecklieferung 1

# Ruecklieferung 1
Given I open an editor "RLS057-1" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS057"
And I set fields
   | such   | RLS057-1 |
   | vom    | .        |
   | ueb    | ja       |
And I set field "mge" to "-3" in row 1
And I save the current editor

Given I open an editor "LS057" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS057"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-1" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE057-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-2" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE057-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Aktualisierung von (ev)remge in offenen Rechnungen - Reduzierung der Positionsmenge

Given I open an editor "RE057-2" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE057-2"
And I set field "mge" to "2" in row 1
And I save the current editor

Given I open an editor "LS057" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS057"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-1" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE057-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-2" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE057-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Aktualisierung von (ev)remge in offenen Rechnungen - Ruecklieferung 2

# Ruecklieferung 2
Given I open an editor "RLS057-2" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS057"
And I set fields
   | such   | RLS057-2 |
   | vom    | .        |
   | ueb    | ja       |
And I set field "mge" to "-4" in row 1
And I save the current editor

Given I open an editor "LS057" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS057"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-1" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE057-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-2" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE057-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Aktualisierung von (ev)remge in offenen Rechnungen - Reduzierung der Positionsmenge 2

Given I open an editor "RE057-1" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE057-1"
And I set field "mge" to "1" in row 1
And I set field "mge" to "1" in row 3
And I save the current editor

Given I open an editor "RE057-2" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE057-2"
And I set field "mge" to "1" in row 1
And I save the current editor

Given I open an editor "RE057-1" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE057-1"
And I set field "mge" to "1" in row 3
And I save the current editor

Given I open an editor "LS057" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS057"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-1" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE057-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-2" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE057-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Aktualisierung von (ev)remge in offenen Rechnungen - Storno Rücklieferung

Given I open an editor "RLS057-1" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "RLS057-1"
And I save the current editor

Given I open an editor "LS057" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS057"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-1" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE057-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-2" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE057-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Aktualisierung von (ev)remge in offenen Rechnungen - Erhoehung der Positionsmenge

Given I open an editor "RE057-1" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE057-1"
And I set field "mge" to "2" in row 1
And I set field "mge" to "2" in row 3
And I save the current editor

Given I open an editor "RE057-2" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE057-2"
And I set field "mge" to "2" in row 1
And I save the current editor

Given I open an editor "LS057" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS057"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-1" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE057-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-2" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE057-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Aktualisierung von (ev)remge in offenen Rechnungen - Storno Rücklieferung 2

Given I open an editor "RLS057-2" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "RLS057-2"
And I save the current editor

Given I open an editor "LS057" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS057"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-1" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE057-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-2" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE057-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Aktualisierung von (ev)remge in offenen Rechnungen - Erhoehung der Positionsmenge 2

Given I open an editor "RE057-1" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE057-1"
And I set field "mge" to "3" in row 3
And I save the current editor

Given I open an editor "RE057-2" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE057-2"
And I set field "mge" to "4" in row 1
And I save the current editor

Given I open an editor "LS057" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS057"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-1" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE057-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-2" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE057-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Aktualisierung von (ev)remge in offenen Rechnungen - Rechnungsbuchung

Given I open an editor "RE057-1" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE057-1"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "LS057" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS057"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-1" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE057-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-2" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE057-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Aktualisierung von (ev)remge in offenen Rechnungen - Rechnungsbuchung 2

Given I open an editor "RE057-2" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE057-2"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "LS057" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS057"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-1" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE057-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-2" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE057-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Zwei RLS per Beleg anfuegen gutschreiben
# indirekt gesplittete Position im KGS, da die Positionen aus den RLS eine gemeinsame LS Position haben

#  BE058 ---> LS058 -----> RE170
#   170 St.   170 St.      170 St.
#                 \
#                  \
#                   ----------> RLS058
#                    \         -69 St. (1!)
#                     \        | Aktion | remge   |
#                      \       | (1)    | -69 St. |
#                       \      | (2)    | -140 St.|\
#                        \     | (3)    | -0 St.  | \
#                         \                          \                 KGS058
#                          \                           --------------> -69 (3!)
#                           \                             -----------> -71 (3!)
#                            ----------> RLS058B         /
#                                          -71 St. (2!) /
#                                          | Aktion | remge   |
#                                          | (2)    | -140 St.|
#                                          | (3)    | -2 St.  |
#                                          | (6)    | -0 St.  |
#

# BE
Given I create a PurchaseOrder "BE058" for Vendor "1" with Product "E1" and quantity "170" and price "2"

# LS
Given I deliver the PurchaseOrder "BE058" with PackingSlip "LS058"

# RE
Given I open an editor "RE058" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS058"
And I set field "such" to "RE058"
And I set field "ebeleg" to "RE058"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein1 anlegen
Given I open an editor "RLS058" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS058"
And I set field "such" to "RLS058"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-69" in row 1
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rücklieferschein2 anlegen
Given I open an editor "RLS058B" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS058"
And I set field "such" to "RLS058B"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-71" in row 1
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Gutschrift fuer beide RSL ueber Beleg anfuegen
Given I open an editor "KGS058" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS058"
And I set field "such" to "KGS058"
And I set field "ebeleg" to "KGS058"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-69" in row 1
And I set field "beleg" to id from editor "RLS058B"
And I set field "mge" to "-71" in row 3
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "RLS058B" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "RLS058B" is filed

Then field "remge" from editor "RLS058" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "RLS058" is filed

Scenario: KGS mit gesplitteter RLS Position - Pruefe auf Remge in RLS
# Splittung kommt zustande, weil  beim Gutschreiben unterschiedliche Rechnungen zu beruecksichtigen sind
# Behandlung der gesplitteten Positionen in der KGS bezueglich der Remge
#
#  BE059 ---> LS059 ---> RE059
#  160 St.    160 St.    60 St.
#                \
#                 \----------> RE059B
#                  \           100 St.
#                   \
#                    ---------------> RLS059 ---------------> KGS059 (Gleiche RLS Position splitten)
#                                     -140 St. (1!)           -60 St. (2!)
#                                     | Aktion | remge    |   -80 St. (2!)
#                                     | (1)    | -140 St. |
#                                     | (2)    |    0 St. |

# BE
Given I create a PurchaseOrder "BE059" for Vendor "1" with Product "E1" and quantity "160" and price "2"

# LS
Given I deliver the PurchaseOrder "BE059" with PackingSlip "LS059"

# RE
Given I open an editor "RE059" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS059"
And I set field "such" to "RE059"
And I set field "ebeleg" to "RE059"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "60" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# RE 2
Given I open an editor "RE059B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS059"
And I set field "such" to "RE059B"
And I set field "ebeleg" to "RE059B"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein
Given I open an editor "RLS059" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS059"
And I set field "such" to "RLS059"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-140" in row 1
And I save the current editor
Then field "remge" from editor "RLS059" in row 1 has value "-140"

# Gutschrift zu RLS -> 2 Positionen
Given I open an editor "KGS059" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS059"
And I set field "beleg" to id from editor "RLS059"
And I set field "such" to "KGS059"
And I set field "ebeleg" to "KGS059"
#And I set field "ueb" to "ja"
And I set field "vom" to "."
Then the table has 2 rows
Then field "mge" has value "-60" in row 1
Then field "mge" has value "-80" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "KGS059" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS059"
And I set field "ueb" to "ja"
And I save the current editor

Then field "remge" from editor "RLS059" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "RLS059" is filed


# ----------------------------------------------------------------------------------------------
#
#    Sperren pruefen beim Storno eines Vorganges:
#    ist, neben dem Vorgang selbst, auch die Bestellung bzw. der Lieferschein gesperrt?
#
# ----------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------
#  Storno eines Lieferscheins
# ----------------------------------------------------------------------------------------------

#  BE060 ----------------- LS060A ------------------ SLS060A
#  20 St.                  12 St.                    -12 St. (1!)
#  | Aktion | Sperre |     | Aktion | Sperre |
#  |  (1)   |   ja   |     |  (1)   |   ja   |
#  |  (2)   |   ja   |
#     \           \
#      \            --------------------- RE060A ohne LB
#       \                                 8 St.
#        \
#         \
#           -------- LS060B ----------------------------- SLS060B ohne LB
#                    4 St.                                -4 St. (2!)
#                    | Aktion | Sperre |
#                    |   (2)  |   ja   |
#                      \
#                       \
#                         -------- RE060B
#                                  3 St.
#

Scenario: Storno LS: sind BE und LS gesperrt worden?
# Fall 1: BE, RE aus BE, LS, Storno LS
# Fall 2: BE, LS, RE aus LS, Storno LS

# Bestellung
Given I create a PurchaseOrder "BE060" for Vendor "1" with Product "E1" and quantity "20" and price "6"

# ------------ Fall 1 -------------

# Lieferschein aus Bestellung erzeugen
Given I open an editor "LS060A" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE060"
And I set fields
   | such   | LS060A |
   | ebeleg | LS060A |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "12" in row 1
And I save the current editor

# Teilrechnung ohne LB aus Bestellung
Given I open an editor "RE060A" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE060"
And I set fields
   | such   | RE060A |
   | ebeleg | RE060A |
   | ueb    | true   |
   | tterm  | .      |
   | vom    | .      |
And I set field "mge" to "8" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein A stornieren um Sperrsituation zu ueberpruefen
Given I open an editor "SLS060A" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "LS060A"

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 1. Bestellung laesst sich nicht oeffnen: Sperre wegen Storno Lieferschein A
Then opening an editor from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE060" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "SLS060A"
And I save the current editor

# ------------ Fall 2 -------------

# Lieferschein aus Bestellung erzeugen
Given I open an editor "LS060B" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE060"
And I set fields
   | such   | LS060B |
   | ebeleg | LS060B |
   | ueb    | true   |
   | vom    | .      |
And I set field "mge" to "4" in row 1
And I save the current editor

# Teilrechnung ohne LB aus BE
Given I open an editor "RE060B" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE060"
And I set fields
   | such   | RE060B |
   | ebeleg | RE060B |
   | ueb    | true   |
   | tterm  | .      |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "1" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein B stornieren
Given I open an editor "SLS060B" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "LS060B"

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 1. Bestellung laesst sich nicht oeffnen: Sperre wegen Storno LS
Then opening an editor from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE060" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "SLS060B"
And I save the current editor


# ----------------------------------------------------------------------------------------------
#  Storno einer Rechnung
# ----------------------------------------------------------------------------------------------

#  BE061 ---------------- RE061A ohne LB -------- SRE061A
#  20 St.                 12 St.                  -12 St. (1!)
#  | Aktion | Sperre |    | Aktion | Sperre |
#  |  (1)   |   ja   |    |  (1)   |   ja   |
#  |  (3)   |   ja   |
#     \    \
#      \    \
#       \     --- LS061B
#        \        4 St.
#         \       | Aktion | Sperre |
#          \      |   (2)  |   ja   |
#           \         \
#            \         \
#             \          -------- RE065B ------------- SRE061B
#              \                  3 St.                -3 St. (2!)
#               \
#                \
#                  --- RE061A mit LB --------- SRE061A
#                      4 St.                   -4 St. (3!)
#
#
# In der Grafik nicht abgebildet: Rechnungen der Art "Barzahlung" und "Anzahlung"

Scenario: Storno RE: sind BE bzw. LS gesperrt worden?

# Bestellung
Given I create a PurchaseOrder "BE061" for Vendor "1" with Product "E2" and quantity "20" and price "6"

#
# ------------- Rechnung aus Bestellung ----------
#

# Teilrechnung ohne LB aus BE
Given I open an editor "RE061A" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE061"
And I set fields
   | such   | RE061A |
   | ebeleg | RE061A |
   | ueb    | true   |
   | tterm  | .      |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "12" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung 61A stornieren
Given I open an editor "SRE061A" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE061A"

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 1. Bestellung laesst sich nicht oeffnen: Sperre wegen Storno RE
Then opening an editor from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE061" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "SRE061A"
And I save the current editor

# Barzahlung
Given I open an editor "RE061BAR" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE061"
And I set fields
   | such   | RE061BAR |
   | ebeleg | RE061BAR |
   | ueb    | true     |
   | tterm  | .        |
   | vom    | .        |
   |vorganga| Barzahlung |
Then the table has 1 rows
And I set field "mge" to "2" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung 61BAR stornieren, nicht speichern
Given I open an editor "SRE061BAR" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE061BAR"

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 1. Bestellung laesst sich nicht oeffnen: Sperre wegen Storno RE
Then opening an editor from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE061" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "SRE061BAR"
And I save the current editor

# Anzahlung: Fakturaplan anlegen und Anzahlungsrechnung anlegen
Given I open an editor "FPLAN061E" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "BE061"
And I set fields
   | such   | FPLAN061E |
And I append rows
   | reart     | proz | ptext        | zbed |
   | Anzahlung | 20   | 1. Anzahlung | 203  |
   | Anzahlung | 10   | 2. Anzahlung | 203  |

# Anzahlungsrechnung anlegen
And I press button "anzahlungsrechn" to open a subeditor for "EKANZ061" in row 1
And I set fields
   | such   | ANZRE061E |
   | ebeleg | ANZRE061E |
   | ueb    | true      |
   | tterm  | .         |
   | vom    | .         |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "FPLAN061E"
And I save the current editor

# Rechnung ANZ061 stornieren, noch nicht speichern
Given I open an editor "SPLAN061E" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "EKANZ061"

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 1. Bestellung laesst sich nicht oeffnen: Sperre wegen Storno RE
Then opening an editor from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE061" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "SPLAN061E"
And I save the current editor

#
# ------------- Rechnung aus Lieferschein ----------
#

# Lieferschein aus Bestellung erzeugen
Given I open an editor "LS061B" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE061"
And I set fields
   | such   | LS061B |
   | ebeleg | LS061B |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "4" in row 1
And I save the current editor

# Teilrechnung aus Lieferschein
Given I open an editor "RE061B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS061B"
And I set fields
   | such   | RE061B |
   | ebeleg | RE061B |
   | ueb    | true   |
   | tterm  | .      |
   | vom    | .      |
And I set field "mge" to "3" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung 61B stornieren
Given I open an editor "SRE061B" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE061B"

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 1. Lieferschein laesst sich nicht oeffnen: Sperre
Then opening an editor from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "LS061B" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "SRE061B"
And I save the current editor

#
# ------------- Rechnung mit Lagerbewegung ----------
#

# Rechnung mit LB
Given I open an editor "RE061C" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE061"
And I set fields
   | such   | RE061C |
   | ebeleg | RE061C |
   | vom    | .      |
   | tterm  | .      |
   | fakt   | ja     |
   | ueb    | ja     |
And I set field "mge" to "4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung 61C stornieren
Given I open an editor "SRE061C" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE061C"

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 1. Bestellung laesst sich nicht oeffnen: Sperre wegen Storno RE
Then opening an editor from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE061" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "SRE061C"
And I save the current editor


# ----------------------------------------------------------------------------------------------
#  Neu, Aendern, Storno eines Ruecklieferscheins
# ----------------------------------------------------------------------------------------------

Scenario: Neu, Aendern, Storno RLS: sind BE bzw. LS gesperrt worden?

# Bestellung
Given I create a PurchaseOrder "BE070A" for Vendor "1" with Product "E2" and quantity "20" and price "6"

#
# ------------- Rechnung aus Bestellung ----------
#

# Teilrechnung ohne LB aus BE
Given I open an editor "RE070A" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE070A"
And I set fields
   | such   | RE070A |
   | ebeleg | RE070A |
   | ueb    | true   |
   | tterm  | .      |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "12" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein aus Bestellung erzeugen
Given I open an editor "LS070A" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE070A"
And I set fields
   | such   | LS070A |
   | ebeleg | LS070A |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "4" in row 1
And I save the current editor

# ------- Ruecklieferschein neu mit "Beleg anfuegen", nicht speichern - Anfang -------

Given I open an editor "RLS070A2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS070A"
And I set fields
   | such   | RLS070A2 |
And I set field "mge" to "-1" in row 1

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 1. Bestellung laesst sich nicht oeffnen: Sperre wegen RLS Neu mit "Beleg anfuegen"
Then opening an editor from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE070A" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "RLS070A2"
And I close the current editor

# ------- Ruecklieferschein neu mit "Beleg anfuegen", nicht speichern - Ende -------


# ------- Ruecklieferschein neu, ohne zu buchen - Anfang -------

Given I open an editor "RLS070A" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS070A"
And I set fields
   | such   | RLS070A |
And I set field "mge" to "-1" in row 1
And I set field "platz" to "F1" in row 1

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 1. Bestellung laesst sich nicht oeffnen: Sperre wegen Neuanlage aus LS
Then opening an editor from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE070A" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "RLS070A"
And I save the current editor

# ------- Ruecklieferschein neu, ohne zu buchen - Ende -------


# ------- Ruecklieferschein aendern und buchen - Anfang --------

Given I open an editor "RLS070A" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "RLS070A"
And I set fields
   | ueb    | ja      |

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 2. Bestellung laesst sich nicht oeffnen: Sperre wegen Aendern-Modus im RLS
Then opening an editor from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE070A" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "RLS070A"
And I save the current editor

# ------- Ruecklieferschein aendern und buchen - Ende  -------


# ------- Ruecklieferschein stornieren - Anfang -------

Given I open an editor "SRLS070A" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "RLS070A"

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 3. Bestellung laesst sich nicht oeffnen: Sperre wegen Storno RLS
Then opening an editor from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE070A" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "SRLS070A"
And I save the current editor

# ------- Ruecklieferschein stornieren - Ende -------

#
# ------------- Rechnung aus Lieferschein ----------
#

#            fakt=true
# BE070B ----- LS ------- RLS ----- SRLS
#               \
#                 ---- RE

# Bestellung
Given I create a PurchaseOrder "BE070B" for Vendor "1" with Product "E2" and quantity "11" and price "6"

# Lieferschein aus Bestellung erzeugen
Given I open an editor "LS070B" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE070B"
And I set fields
   | such   | LS070B |
   | ebeleg | LS070B |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "4" in row 1
And I save the current editor

# Teilrechnung aus Lieferschein
Given I open an editor "RE070B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS070B"
And I set fields
   | such   | RE070B |
   | ebeleg | RE070B |
   | ueb    | true   |
   | tterm  | .      |
   | vom    | .      |
And I set field "mge" to "3" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein zum Lieferschein
Given I open an editor "RLS070B" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS070B"
And I set fields
   | such   | RLS070B |
And I set field "mge" to "-1" in row 1
And I save the current editor

# --- Aendern Ruecklieferschein + buchen ---
Given I open an editor "RLS070B" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "RLS070B"
And I set fields
   | ueb    | ja   |

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# Bestellung laesst sich im Aendern-Modus oeffnen, keine Sperre
Given I open an editor "BE070B_UP1" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "BE070B"
And I close the current editor

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "RLS070B"
And I save the current editor

# Ruecklieferschein stornieren
Given I open an editor "SRLS070B" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "RLS070B"

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# Bestellung laesst sich im Aendern-Modus oeffnen, keine Sperre
Given I open an editor "BE070B_UP2" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "BE070B"
And I close the current editor

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "SRLS070B"
And I save the current editor

# ----------------------------------------------------------------------------------------------
#       Storno einer kaufmaennischen Gutschrift
# ----------------------------------------------------------------------------------------------

Scenario: Storno KGS: sind BE bzw. LS gesperrt worden?

#
# ------------- Rechnung aus Bestellung ----------
#

# Bestellung
Given I create a PurchaseOrder "BE071" for Vendor "1" with Product "E2" and quantity "20" and price "6"

# Teilrechnung ohne LB aus BE
Given I open an editor "RE071A" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE071"
And I set fields
   | such   | RE071A |
   | ebeleg | RE071A |
   | ueb    | true   |
   | tterm  | .      |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "16" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein aus Bestellung
Given I open an editor "LS071A" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE071"
And I set fields
   | such   | LS071A |
   | ebeleg | LS071A |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "10" in row 1
And I save the current editor

# Ruecklieferschein zum Lieferschein
Given I open an editor "RLS071A" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS071A"
And I set fields
   | such   | RLS071A |
   | ebeleg | RLS071A |
   | ueb    | ja      |
And I set field "mge" to "-9" in row 1
And I save the current editor

# Kaufm. Gutschrift 71A zum RLS
Given I open an editor "KGS071A" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS071A"
And I set fields
   | such   | KGS071A |
   | ebeleg | KGS071A |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
And I set field "mge" to "-4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Kaufm. Gutschrift 71A stornieren
Given I open an editor "SKGS071A" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KGS071A"

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 1. Bestellung laesst sich nicht oeffnen: Sperre wegen Storno KGS 71A
Then opening an editor from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE071" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "SKGS071A"
And I save the current editor

#
# ------------- Rechnung aus Lieferschein ----------
#

#            fakt=true
# BE071B ------ LS ------ RLS ------ KGS --- SKGS
#                \
#                 ----- RE
#                   fakt=false

# Bestellung
Given I create a PurchaseOrder "BE071B" for Vendor "1" with Product "E2" and quantity "20" and price "6"

# Lieferschein aus Bestellung erzeugen
Given I open an editor "LS071B" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE071B"
And I set fields
   | such   | LS071B |
   | ebeleg | LS071B |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "12" in row 1
And I save the current editor

# Teilrechnung aus Lieferschein
Given I open an editor "RE071B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS071B"
And I set fields
   | such   | RE071B |
   | ebeleg | RE071B |
   | ueb    | true   |
   | tterm  | .      |
   | vom    | .      |
And I set field "mge" to "10" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein erzeugen und buchen
Given I open an editor "RLS071B" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS071B"
And I set fields
   | such   | RLS071B |
   | ueb    | ja      |
And I set field "mge" to "-9" in row 1
And I save the current editor

# Kaufm. Gutschrift 71B zu RLS 71B
Given I open an editor "KGS071B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS071B"
And I set fields
   | such   | KGS071B |
   | ebeleg | KGS071B |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
And I set field "mge" to "-1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Kaufm. Gutschrift 71B stornieren
Given I open an editor "SKGS071B" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KGS071B"

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 1. Bestellung laesst sich im Aendern-Modus oeffnen: Keine Sperre wegen Storno KGS
Given I open an editor "BE071B_UP" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "BE071B"
And I close the current editor

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "SKGS071B"
And I save the current editor

# ----------------------------------------------------------------------------------------------
# ---------------- Sperren Pruefungen Ende ------------------
# ----------------------------------------------------------------------------------------------


Scenario: Remge bei RE+LB mit RE ohne LB gemischt

#  BE062 ----------------------> RE062 + LB
#   10 St. (1!)              \   6 St. (2!)
#   | Aktion | remge  | limge \
#   | (1)    | 10 St. | 10 St. \
#   | (2)    |  4 St. |  4 St.  \
#   | (3)    |  1 St. |  4 St.   ---> RE062B
#   | (4)    |  1 St. |  1 St.    \   3 St. (3!)
#   | (5)    |  1 St. |  1 St.     \
#   | (6)    |  0 St. |  1 St.      -----> LS062 ------> RLS062
#                                    \     3 St. (4!)    -1 St. (5!)
#                                     \
#                                      -------------------------------> RE062C
#                                                                       1 St. (6!)

Given I create a PurchaseOrder "BE062" for Vendor "1" with Product "V1" and quantity "10"

Then field "remge" from editor "BE062" in row 1 has value "10"
Then field "limge" from editor "BE062" in row 1 has value "10"

# Teilrechnung Rechnung mit LBG aus Bestellung erzeugen und buchen
Given I open an editor "RE062" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE062"
And I set fields
   | such   | RE062  |
   | ebeleg | RE062  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
Then the table has 1 rows
And I set field "mge" to "6" in row 1
And I save the current editor

Then field "remge" from editor "BE062" in row 1 has value "4"
Then field "limge" from editor "BE062" in row 1 has value "4"

#  Rechnung ohne LBG mit Menge 2 aus Bestellung erzeugen und buchen
Given I open an editor "RE062B" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE062"
And I set fields
   | such   | RE062B |
   | ebeleg | RE062B |
   | ueb    | ja     |
   | fakt   | nein   |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "3" in row 1
And I save the current editor

Then field "remge" from editor "BE062" in row 1 has value "1"
Then field "limge" from editor "BE062" in row 1 has value "4"

# Lieferschein aus Bestellung mit Menge 3 Stueck erzeugen und buchen
Given I open an editor "LS062" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE062"
And I set fields
   | ebeleg | LS062 |
   | such   | LS062 |
   | ueb    | ja    |
   | vom    | .     |
   | tterm  | .     |
And I set field "mge" to "3" in row 1
And I save the current editor

Then field "remge" from editor "BE062" in row 1 has value "1"
Then field "limge" from editor "BE062" in row 1 has value "1"

# Ruecklieferschein zu Lieferschein mit Menge -1 erzeugen und buchen
Given I open an editor "RLS062" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS062"
And I set fields
   | such   | RLS062 |
   | ueb    | ja     |
And I set field "mge" to "-1" in row 1
And I set field "platz" to "F1" in row 1
And I save the current editor
Then field "remge" from editor "RLS062" in row 1 has value "0"

Then field "remge" from editor "BE062" in row 1 has value "1"
Then field "limge" from editor "BE062" in row 1 has value "1"

# Rechnung aus Bestellung mit Menge 1 erstellen
Given I open an editor "RE062C" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE062"
And I set fields
   | such   | RE062C  |
   | ebeleg | RE062C  |
   | ueb    | ja      |
   | fakt   | nein    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "1" in row 1
And I save the current editor

Then field "remge" from editor "BE062" in row 1 has value "0"
Then field "limge" from editor "BE062" in row 1 has value "1"

Scenario: Remge bei RE aus BE bei kompletter RL nur noch 0 Rechnung moeglich

#  BE063 ----------------------> LS063 mit RE   --> RLS063
#   10 St. (1!)              \   10 St. (2!)        -10 St. (3!)
#   | Aktion | remge  | limge \
#   | (1)    | 10 St. | 10 St. \
#   | (2)    |  0 St. |  0 St.  \
#   | (3)    |  0 St. |  0 St.   ---> RE063 (ohne LB nur noch 0 Rechnung moeglich!)
#   | (4)    |  0 St. |  0 St.    \   0 St. (4!)
#

# BE
Given I create a PurchaseOrder "BE063" for Vendor "1" with Product "V1" and quantity "10"

Then field "remge" from editor "BE063" in row 1 has value "10"
Then field "limge" from editor "BE063" in row 1 has value "10"

# LS aus BE ohne RE
Given I open an editor "LS063" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE063"
And I set fields
   | such   | LS063 |
   | ebeleg | LS063 |
   | ueb    | ja    |
   | fakt   | ja    |
   | vom    | .     |
   | tterm  | .     |
And I set field "mge" to "10" in row 1
And I save the current editor

Then field "remge" from editor "BE063" in row 1 has value "0"
Then field "limge" from editor "BE063" in row 1 has value "0"
Then "(Purchasing):(PurchaseOrder)" with the editor id "BE063" is filed

# RLS komplett
Given I open an editor "RLS063" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS063"
And I set fields
   | such   | RLS063 |
   | ueb    | ja     |
And I set field "mge" to "-10" in row 1
And I set field "platz" to "F1" in row 1
And I save the current editor
Then field "remge" from editor "RLS063" in row 1 has value "0"

Then field "remge" from editor "BE063" in row 1 has value "0"
Then field "limge" from editor "BE063" in row 1 has value "0"
Then "(Purchasing):(PurchaseOrder)" with the editor id "BE063" is filed

# Rechnung mit LBG aus Bestellung erzeugen und buchen
Given I open an editor "RE063" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE063"
And I set fields
   | such   | RE063  |
   | ebeleg | RE063  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
Then the table has 1 rows
# Mit LB beliebige Menge erlaubt
And I set field "mge" to "666" in row 1
And I set field "fakt" to "nein"
# Max 0 Rechnung moeglich: Rechnungsmenge zu hoch
Then setting field "mge" to "1" in row 1 throws the exception "2810"
And I set field "mge" to "0" in row 1
And I save the current editor

Then field "remge" from editor "BE063" in row 1 has value "0"
Then field "limge" from editor "BE063" in row 1 has value "0"
Then "(Purchasing):(PurchaseOrder)" with the editor id "BE063" is filed

Scenario: Remge bei gesplitteten LS Positionen in Rechnung

#  BE066 --------------> LS066 -------------> RE066
#   150 St. (1!)         150 St. (2!)         100 St. (3!)
#   | Aktion | remge     | Aktion | remge      50 St. (3!)
#   | (1)    | 150 St.   | (2)    | 150 St.
#   | (2)    |   0 St.   | (3)    |   0 St.
#

# BE
Given I create a PurchaseOrder "BE066" for Vendor "1" with Product "E1" and quantity "150"
Then field "remge" from editor "BE066" in row 1 has value "150"

# LS
Given I deliver the PurchaseOrder "BE066" with PackingSlip "LS066"
Then field "remge" from editor "BE066" in row 1 has value "0"
Then field "remge" from editor "LS066" in row 1 has value "150"
Then "(Purchasing):(PackingSlip)" with the editor id "LS066" is not filed

# RE
Given I open an editor "RE066" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS066"
And I set field "such" to "RE066"
And I set field "ebeleg" to "RE066"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "mge" to "100" in row 1
And I set field "beleg" to id from editor "LS066"
And I set field "mge" to "50" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "LS066" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "LS066" is filed
Then "(Purchasing):(Invoice)" with the editor id "RE066" is filed

Scenario: Remge bei gesplitteten LS Positionen aus BE

#  BE067 --------------> LS067 -------------> RE067
#   160 St. (1!)         100 St. (2!)         100 St. (3!)
#   | Aktion | remge      50 St. (2!)          50 St. (3!)
#   | (1)    | 160 St.   | Aktion | remge
#   | (2)    |  10 St.   | (2)    | 100 St.
#                        | (2)    |  50 St.
#                        | (3)    |   0 St.
#                        | (3)    |   0 St.

# BE
Given I create a PurchaseOrder "BE067" for Vendor "1" with Product "E1" and quantity "160"
Then field "remge" from editor "BE067" in row 1 has value "160"

# LS mit gesplitt. Pos
Given I open an editor "LS067" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE067"
And I set field "such" to "LS067"
And I set field "ebeleg" to "LS067"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "mge" to "100" in row 1
And I set field "beleg" to id from editor "LS067"
And I set field "mge" to "50" in row 2
And I save the current editor

Then field "remge" from editor "BE067" in row 1 has value "10"
Then field "remge" from editor "LS067" in row 1 has value "100"
Then field "remge" from editor "LS067" in row 2 has value "50"

# RE
Given I open an editor "RE067" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS067"
And I set field "such" to "RE067"
And I set field "ebeleg" to "RE067"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
Then the table has 2 rows
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
Then field "remge" from editor "LS067" in row 1 has value "0"
Then field "remge" from editor "LS067" in row 2 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "LS067" is filed

Scenario: Remge bei gesplitteten BE Positionen in Rechnung + LB

#  BE068 --------------> RE068 + LB
#   150 St. (1!)         100 St. (2!)
#   | Aktion | remge      50 St. (2!)
#   | (1)    | 150 St.   | Aktion | remge
#   | (2)    |   0 St.   | (2)    |   0 St.
#                        | (2)    |   0 St.
#

# BE
Given I create a PurchaseOrder "BE068" for Vendor "1" with Product "E1" and quantity "150"
Then field "remge" from editor "BE068" in row 1 has value "150"

# RE + LB
Given I open an editor "RE068" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE068"
And I set field "such" to "RE068"
And I set field "ebeleg" to "RE068"
And I set field "ueb" to "ja"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "mge" to "100" in row 1
And I set field "beleg" to id from editor "BE068"
And I set field "mge" to "50" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "fakt" from editor "RE068" in row 1 has value "ja"
Then field "remge" from editor "RE068" in row 1 has value "-100"
Then field "remge" from editor "RE068" in row 2 has value "-50"
Then "(Purchasing):(Invoice)" with the editor id "RE068" is filed
Then field "remge" from editor "BE068" in row 1 has value "0"
Then "(Purchasing):(PurchaseOrder)" with the editor id "BE068" is filed

Scenario: Mehrfaches Stornieren von Lieferscheinen BE -> LSA -> SLSA + LSB -> SLSB

#    BE069
#    | Aktion | remge |
#    |        | 10 St.|
#    | (1)    |  4 St.|
#    | (2)    | 10 St.|
#    | (3)    |  6 St.|
#    | (3)    | 10 St.|
#           \
#            \
#              ------ LS069A -------------- SLS069A
#              \       6 St. (1!)               -6 St. (2!)
#               \     | Aktion | remge |    | Aktion | remge |
#                \    |        |  6 St.|    |        |  0 St.|
#                 \   | (2)    |  0 St.|
#                  \
#                    --- LS069B   -------------- SLS069B
#                         4 St. (3!)                   -4 St. (4!)
#                        | Aktion | remge |      | Aktion | remge |
#                        |        |  4 St.|      |        |  0 St.|
#                        |        |  0 St.|

Given I open an editor "BE069" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE069  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferschein 69A aus Bestellung erzeugen
Given I open an editor "LS069A" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE069"
And I set fields
   | such   | LS069A |
   | ebeleg | LS069A |
   | ueb    | true   |
   | fakt   | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "6" in row 1
And I save the current editor

# Pruefe remge in Bestellung
Then field "remge" from editor "BE069" in row 1 has value "4"
Then field "ablagef" from editor "BE069" in row 0 has value "nein"
Then field "naktiv" from editor "BE069" in row 0 has value "1"

# Pruefe remge in Lieferschein A
Then field "remge" from editor "LS069A" in row 1 has value "6"
Then field "ablagef" from editor "LS069A" in row 0 has value "nein"
Then field "naktiv" from editor "LS069A" in row 0 has value "1"

# Lieferschein 69A stornieren
Given I open an editor "SLS069A" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "LS069A"
And I save the current editor

# Pruefe remge in Bestellung
Then field "remge" from editor "BE069" in row 1 has value "10"
Then field "ablagef" from editor "BE069" in row 0 has value "nein"
Then field "naktiv" from editor "BE069" in row 0 has value "1"
# Pruefe remge in Lieferschein A
Then field "remge" from editor "LS069A" in row 1 has value "0"
Then field "ablagef" from editor "LS069A" in row 0 has value "ja"
Then field "naktiv" from editor "LS069A" in row 0 has value "1"
# Pruefe remge in Storno-Lieferschein A
Then field "remge" from editor "SLS069A" in row 1 has value "0"
Then field "ablagef" from editor "SLS069A" in row 0 has value "ja"
Then field "naktiv" from editor "SLS069A" in row 0 has value "0"

# Lieferschein 69B aus Bestellung erzeugen
Given I open an editor "LS069B" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE069"
And I set fields
   | such   | LS069B |
   | ebeleg | LS069B |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "4" in row 1
And I save the current editor

# Pruefe remge in Bestellung
Then field "remge" from editor "BE069" in row 1 has value "6"
Then field "ablagef" from editor "BE069" in row 0 has value "nein"
Then field "naktiv" from editor "BE069" in row 0 has value "1"
# Pruefe remge in Lieferschein A
Then field "remge" from editor "LS069A" in row 1 has value "0"
Then field "ablagef" from editor "LS069A" in row 0 has value "ja"
Then field "naktiv" from editor "LS069A" in row 0 has value "1"
# Pruefe remge in Storno-Lieferschein A
Then field "remge" from editor "SLS069A" in row 1 has value "0"
Then field "ablagef" from editor "SLS069A" in row 0 has value "ja"
Then field "naktiv" from editor "SLS069A" in row 0 has value "0"
# Pruefe remge in Lieferschein B
Then field "remge" from editor "LS069B" in row 1 has value "4"
Then field "ablagef" from editor "LS069B" in row 0 has value "nein"
Then field "naktiv" from editor "LS069B" in row 0 has value "1"

# Lieferschein 69B stornieren
Given I open an editor "SLS069B" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "LS069B"
And I save the current editor

# Pruefe remge in Bestellung
Then field "remge" from editor "BE069" in row 1 has value "10"
Then field "ablagef" from editor "BE069" in row 0 has value "nein"
Then field "naktiv" from editor "BE069" in row 0 has value "1"
# Pruefe remge in Lieferschein A
Then field "remge" from editor "LS069A" in row 1 has value "0"
Then field "ablagef" from editor "LS069A" in row 0 has value "ja"
Then field "naktiv" from editor "LS069A" in row 0 has value "1"
# Pruefe remge in Storno-Lieferschein A
Then field "remge" from editor "SLS069A" in row 1 has value "0"
Then field "ablagef" from editor "SLS069A" in row 0 has value "ja"
Then field "naktiv" from editor "SLS069A" in row 0 has value "0"
# Pruefe remge in Lieferschein B
Then field "remge" from editor "LS069B" in row 1 has value "0"
Then field "ablagef" from editor "LS069B" in row 0 has value "ja"
Then field "naktiv" from editor "LS069B" in row 0 has value "1"
# Pruefe remge in Storno-Lieferschein A
Then field "remge" from editor "SLS069B" in row 1 has value "0"
Then field "ablagef" from editor "SLS069B" in row 0 has value "ja"
Then field "naktiv" from editor "SLS069B" in row 0 has value "0"

Scenario: Remge bei Stornieren einer gesplitteten KGS
#
#  BE070 ---------------------> LS070 ------------> RE070
#  10 St. (1!)                  10 St. (2!)     \   5 St. (3!)
#  | Aktion | remge  | limge    | Aktion | remge \
#  | (1)    | 10 St. | 10 St.   | (2)    | 10 St. ------> RE 070B
#  | (2)    |  0 St. |  0 St.   | (3)    |  5 St.         5 St. (4!)
#  | (3)    |  0 St. |          | (4)    |  0 St.
#  | (5)    | ??? St.|                  \
#                                        -------------------> RLS070 ---------> KGS070 ------> SKGS070 (Storno)
#                                                             -7 St. (5!)        -5 St. (6!)   (7!)
#                                                             | Aktion | remge   -2 St. (6!)
#                                                             | (5)    | -7 St.  (Split entsteht)
#                                                             | (6)    |  0 St.
#                                                             | (7)    | -7 St.
#

Given I create a PurchaseOrder "BE070" for Vendor "1" with Product "E1" and quantity "10"

#limge in Bestellung ist 10, remge ist 10
Then field "limge" from editor "BE070" in row 1 has value "10"
Then field "remge" from editor "BE070" in row 1 has value "10"

# Lieferschein aus Bestellung mit Menge 10 erzeugen und buchen
Given I deliver the PurchaseOrder "BE070" with PackingSlip "LS070"

#limge in Bestellung ist 0, remge ist 0
Then field "limge" from editor "BE070" in row 1 has value "0"
Then field "remge" from editor "BE070" in row 1 has value "0"

# Teilrechnung aus Lieferschein mit Menge 5 erzeugen und buchen
Given I open an editor "RE070" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS070"
And I set field "such" to "RE170"
And I set field "ebeleg" to "RE170"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "mge" to "5" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#remge im Lieferschein ist 5
Then field "remge" from editor "LS070" in row 1 has value "5"

# 2. Teilrechnung aus Lieferschein mit Menge 5 erzeugen und buchen
Given I open an editor "RE070B" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS070"
And I set field "such" to "RE170B"
And I set field "ebeleg" to "RE170B"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "mge" to "5" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#remge im Lieferschein ist 0
Then field "remge" from editor "LS070" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "LS070" is filed

# Teil-RLS zu LS
Given I open an editor "RLS070" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS070"
And I set field "ueb" to "ja"
And I set field "mge" to "-7" in row 1
And I set field "platz" to "F1" in row 1
And I save the current editor
Then field "remge" has value "-7" in row 1

# KGS zu RLS mit Menge -7 erzeugen (ergibt Split) und buchen
Given I open an editor "KGS070" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS070"
And I set field "such" to "KGS170"
And I set field "ebeleg" to "KGS170"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
Then the table has 2 rows
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#remge im Ruecklieferschein ist 0
Then field "remge" from editor "RLS070" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "RLS070" is filed

# Gesplitteten KGS stornieren
Given I open an editor "SKGS070" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KGS070"
And I save the current editor

#remge im RLS muss komplett zurueckgesetzt sein
Then field "remge" from editor "RLS070" in row 1 has value "-7"
Then "(Purchasing):(PackingSlip)" with the editor id "RLS070" is not filed


Scenario: Remge bei gesplitteten Positionen bei RE (komplett) aus BE + RE Storno
#
#  BE171 ------------------> RE171 -----------------------> SRE171 (3!)
#  150 St.   (1!)           100 St. split (2!)
#  | Aktion | remge          50 St. split (2!)
#  | (1)    | 150 St.       | Aktion | remge
#  | (2)    |   0 St.       | (2)    |   0 St.
#  | (3)    | 150 St. sind aber 50!
#

# BE
Given I create a PurchaseOrder "BE171" for Vendor "1" with Product "V1" and quantity "150"
Then field "remge" from editor "BE171" in row 1 has value "150"

# RE ohne LB mit Split
Given I open an editor "RE171" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE171"
And I set fields
| such   | RE171  |
| ebeleg | RE171  |
| ueb    | ja     |
| vom    | .      |
| tterm  | .      |
| fakt   | ja     |
And I set field "mge" to "100" in row 1
And I set field "beleg" to id from editor "BE171"
And I set field "mge" to "50" in row 2
And I save the current editor

Then field "remge" from editor "BE171" in row 1 has value "0"
Then "(Purchasing):(PurchaseOrder)" with the editor id "BE171" is filed

# Storno der gesplitteten RE
Given I open an editor "SRE171" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE171"
And I save the current editor

Then "(Purchasing):(PurchaseOrder)" with the editor id "BE171" is not filed
Then field "remge" from editor "BE171" in row 1 has value "150"

Scenario: Loeschen einer Rechnungsposition bei Rechnung aus Lieferschein

#    BE072
#    10 St.
#    | Aktion | remge |
#    |        | 10 St.|
#    |        | 10 St.|
#    | (1)    |  0 St.|
#    | (1)    |  0 St.|
#            \
#              ------ LS072  -------------- RE072  ungebucht --------- 1. Zeile loeschen und buchen (3!)
#                     6 St. (1!)               8 St. und 5 St. (2!)
#                     | Aktion | remge |    | Aktion | remge |
#                     |        | 10 St.|    |        |  0 St.|
#                     |        | 10 St.|    |        |  0 St.|
#                     | (3)    | 10 St.|
#                     | (3)    |  5 St.|


Given I open an editor "BE072" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE072  |
   | ebeleg | BE072  |
And I append rows
   | artikel | he     | mge |
   | A100    | Stueck | 10  |
   | A100    | Stueck | 10  |
And I save the current editor

# Pruefe remge in Bestellung
Then field "remge" from editor "BE072" in row 1 has value "10"

# Lieferschein aus Bestellung erzeugen
Given I open an editor "LS072" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE072"
And I set fields
   | such   | LS072  |
   | ebeleg | LS072  |
   | ueb    | true   |
   | fakt   | true   |
   | vom    | .      |
Then the table has 2 rows
And I set field "mge" to "10" in row 1
And I set field "mge" to "10" in row 2
And I save the current editor

# Pruefe remge in Bestellung
Then field "remge" from editor "BE072" in row 1 has value "0"
Then field "remge" from editor "BE072" in row 2 has value "0"
Then field "ablagef" from editor "BE072" in row 0 has value "ja"
# Pruefe remge in Lieferschein
Then field "remge" from editor "LS072" in row 1 has value "10"
Then field "remge" from editor "LS072" in row 1 has value "10"

# Rechnung zu Lieferschein noch nicht buchen
Given I open an editor "RE072" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS072"
And I set field "such" to "RE072"
And I set field "ebeleg" to "RE072"
And I set field "ueb" to "nein"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "mge" to "8" in row 1
And I set field "beleg" to id from editor "LS072"
And I set field "mge" to "5" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge in Bestellung
Then field "ablagef" from editor "BE072" in row 0 has value "ja"
# Pruefe remge in Lieferschein
Then field "remge" from editor "LS072" in row 1 has value "10"
Then field "refrg" from editor "LS072" in row 1 has value "8"
Then field "remge" from editor "LS072" in row 2 has value "10"
Then field "refrg" from editor "LS072" in row 2 has value "5"
# Pruefe remge in Rechnung
Then field "remge" from editor "RE072" in row 1 has value "10"
Then field "remge" from editor "RE072" in row 2 has value "10"

# 1. Zeile loeschen und Rechnung buchen
Given I open an editor "RE072" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE072"
And I set field "such" to "RE072"
And I set field "ueb" to "ja"
And I delete row at position 1
And I save the current editor

# Pruefe remge in Bestellung
Then field "ablagef" from editor "BE072" in row 0 has value "ja"
# Pruefe remge in Lieferschein A
Then field "remge" from editor "LS072" in row 1 has value "10"
Then field "refrg" from editor "LS072" in row 1 has value "0"
Then field "remge" from editor "LS072" in row 2 has value "5"
Then field "refrg" from editor "LS072" in row 2 has value "0"


Scenario: Loeschen einer Rechnungsposition bei Rechnung aus Bestellung

#    BE073   -------------- RE073 ungebucht --------- 1. Zeile loeschen und buchen (3!)
#    10 St.                     8 St. und 5 St. (2!)
#    | Aktion | remge |      | Aktion | remge |
#    |        | 10 St.|      |        |  0 St.|
#    |        | 10 St.|      |        |  0 St.|
#    | (1)    | 10 St.|
#    | (1)    | 10 St.|
#    | (3)    | 10 St.|
#    | (3)    |  5 St.|
#            \
#              ------ LS073
#                     10 St.  + 10 St. (1!)
#                     | Aktion | remge |
#                     |        |  0 St.|
#                     |        |  0 St.|


Given I open an editor "BE073" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE073  |
   | ebeleg | BE073  |
And I append rows
   | artikel | he     | mge |
   | A100    | Stueck | 10  |
   | A100    | Stueck | 10  |
And I save the current editor

# Pruefe remge in Bestellung
Then field "remge" from editor "BE073" in row 1 has value "10"

# Lieferschein LS073 aus Bestellung erzeugen
Given I open an editor "LS073" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE073"
And I set field "ebeleg" to "LS073"
And I set fields
   | such   | LS073  |
   | ueb    | true   |
   | fakt   | false  |
   | vom    | .      |
Then the table has 2 rows
And I set field "mge" to "10" in row 1
And I set field "mge" to "10" in row 2
And I save the current editor

# Pruefe remge in Bestellung
Then field "remge" from editor "BE073" in row 1 has value "10"
Then field "remge" from editor "BE073" in row 2 has value "10"
# Pruefe remge in Lieferschein
Then field "remge" from editor "LS073" in row 1 has value "0"
Then field "remge" from editor "LS073" in row 1 has value "0"
Then field "ablagef" from editor "LS073" in row 0 has value "ja"

# Rechnung zu Lieferschein noch nicht buchen
Given I open an editor "RE073" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE073"
And I set field "such" to "RE073"
And I set field "ebeleg" to "RE073"
And I set field "ueb" to "nein"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "mge" to "8" in row 1
And I set field "beleg" to id from editor "BE073"
And I set field "mge" to "5" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge in Lieferschein
Then field "ablagef" from editor "LS073" in row 0 has value "ja"
# Pruefe remge in Bestellung
Then field "remge" from editor "BE073" in row 1 has value "10"
Then field "refrg" from editor "BE073" in row 1 has value "8"
Then field "remge" from editor "BE073" in row 2 has value "10"
Then field "refrg" from editor "BE073" in row 2 has value "5"
# Pruefe remge in Storno-Lieferschein
Then field "remge" from editor "RE073" in row 1 has value "10"
Then field "remge" from editor "RE073" in row 2 has value "10"

# 1. Zeile loeschen und Rechnung buchen
Given I open an editor "RE073" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE073"
And I set field "such" to "RE073"
And I set field "ueb" to "ja"
And I delete row at position 1
And I save the current editor

# Pruefe remge in Lieferschein
Then field "ablagef" from editor "LS073" in row 0 has value "ja"
# Pruefe remge in Bestellung
Then field "remge" from editor "BE073" in row 1 has value "10"
Then field "refrg" from editor "BE073" in row 1 has value "0"
Then field "remge" from editor "BE073" in row 2 has value "5"
Then field "refrg" from editor "BE073" in row 2 has value "0"

Scenario: Remge im Fall gesplittete RE Pos vorm Buchen loeschen (RE aus BE ohne LB)
#
#  BE074 --------------------> RE074 (ungebucht) ---> RE074 (buchen. 1. Pos loeschen)
#  10 St.   (1!)               1 St. (Split) (2!)      (3!)
#  | Aktion | remge | refrg    2 St. (Split) (2!)
#  | (1)    | 10 St.|  0 St.
#  | (2)    | 10 St.|  3 St.
#  | (3)    |  8 St.|  0 St.
#
#

Given I create a PurchaseOrder "BE074" for Vendor "1" with Product "V1" and quantity "10"

Then field "limge" from editor "BE074" in row 1 has value "10"
Then field "remge" from editor "BE074" in row 1 has value "10"

# Teilrechnung aus BE mit 2 Positionen erzeugen (ungebucht)
Given I open an editor "RE074" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE074"
And I set field "fakt" to "nein"
And I set field "mge" to "1" in row 1
And I set field "beleg" to id from editor "BE074"
And I set field "mge" to "2" in row 2
And I set field "such" to "RE074"
And I set field "ebeleg" to "RE074"
And I set field "vom" to "."
And I set field "tterm" to "."
And I save the current editor

Then field "remge" from editor "BE074" in row 1 has value "10"
Then field "refrg" from editor "BE074" in row 1 has value "3"

# 1. Position aus Teilrechnung loeschen und Teilrechnung buchen
Given I open an editor "RE074" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE074"
And I delete row at position 1
And I set field "ueb" to "ja"
And I save the current editor

Then field "refrg" from editor "BE074" in row 1 has value "0"
Then field "remge" from editor "BE074" in row 1 has value "8"


Scenario: Remge im Fall gesplittete RE Pos vorm Buchen loeschen
#
#  BE075 ---------------> LS075 ----------------------> RE075 (ungebucht) ---> RE075 (buchen. 1. Pos loeschen)
#  10 St.   (1!)          10 St. (2!)                  1 St. (Split) (3!)      (4!)
#  | Aktion | remge       | Aktion | remge   | refrg   2 St. (Split) (3!)
#  | (1)    | 10 St.      | (2)    |  10 St. |  0 St.
#  | (2)    |  0 St.      | (3)    |  10 St. |  3 St.
#                         | (4)    |   8 St. |  0 St.
#

Given I create a PurchaseOrder "BE262" for Vendor "1" with Product "V1" and quantity "10"

Then field "limge" from editor "BE262" in row 1 has value "10"
Then field "remge" from editor "BE262" in row 1 has value "10"

# LS aus BE
Given I deliver the PurchaseOrder "BE262" with PackingSlip "LS262"

Then field "limge" from editor "BE262" in row 1 has value "0"
Then field "remge" from editor "BE262" in row 1 has value "0"

Then field "remge" from editor "LS262" in row 1 has value "10"
Then field "refrg" from editor "LS262" in row 1 has value "0"

# Teilrechnung aus Lieferschein mit 2 Positionen erzeugen (ungebucht)
Given I open an editor "RE262" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS262"
And I set field "mge" to "1" in row 1
And I set field "beleg" to id from editor "LS262"
And I set field "mge" to "2" in row 2
And I set field "such" to "RE262"
And I set field "ebeleg" to "RE262"
And I set field "vom" to "."
And I set field "tterm" to "."
And I save the current editor

Then field "remge" from editor "LS262" in row 1 has value "10"
Then field "refrg" from editor "LS262" in row 1 has value "3"

# 1. Position aus Teilrechnung loeschen und Teilrechnung buchen
Given I open an editor "RE262" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE262"
And I delete row at position 1
And I set field "ueb" to "ja"
And I save the current editor

Then field "refrg" from editor "LS262" in row 1 has value "0"
Then field "remge" from editor "LS262" in row 1 has value "8"


Scenario: Remge bei gesplitteten Positionen bei RE aus BE + RE Storno
#
#  BE161 ------------------> RE161 -----------------------> SRE161 (4!)
#  150 St.   (1!)      \     100 St. split (2!)
#  | Aktion | remge     \     40 St. V2    (2!)
#  | (1)    | 150 St.    \   | Aktion | remge
#  | (2)    |  10 St.     \  | (2)    |   0 St.
#  | (3)    |   0 St.      \
#  | (4) V2 | 140 St.       \
#                            -------> RE161B
#                                     10 St. (3!)
#

# BE
Given I create a PurchaseOrder "BE075" for Vendor "1" with Product "V1" and quantity "150"
Then field "remge" from editor "BE075" in row 1 has value "150"

# RE ohne LB mit Split
Given I open an editor "RE075" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE075"
And I set fields
| such   | RE075  |
| ebeleg |  RE075   |
| ueb    | ja     |
| vom    | .      |
| tterm  | .      |
| fakt   | nein   |
And I set field "mge" to "100" in row 1
And I set field "beleg" to id from editor "BE075"
And I set field "mge" to "40" in row 2
And I save the current editor

Then field "remge" from editor "BE075" in row 1 has value "10"
Then "(Purchasing):(PurchaseOrder)" with the editor id "BE075" is not filed

# RE REST
Given I open an editor "RE075B" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE075"
And I set fields
| such   | RE075B |
| ebeleg |  RE075B  |
| ueb    | ja     |
| vom    | .      |
| tterm  | .      |
And I press button "offueb" in row 1
Then table has values
| artikel | mge |
| V1     | 10  |
And I save the current editor

Then field "remge" from editor "BE075" in row 1 has value "0"
# Alle Lieferungen stehen noch aus
Then "(Purchasing):(PurchaseOrder)" with the editor id "BE075" is not filed

# Storno der gesplitteten RE
Given I open an editor "SRE075" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE075"
And I save the current editor

Then field "remge" from editor "BE075" in row 1 has value "140"
Then "(Purchasing):(PurchaseOrder)" with the editor id "BE075" is not filed


Scenario: Remge bei gesplitteten Positionen bei RE aus BE + RE Storno
#
#  BE076 ------------------> RE076 ----------------------------------------> SRE076 (6!)
#  150 St.   (1!)      \     100 St. split (2!)
#  | Aktion | remge     \     40 St. split (2!)
#  | (1)    | 150 St.    \   | Aktion | remge
#  | (2)    |  10 St.     \  | (2)    |  0 S.t
#  | (3)    |   0 St.      \
#  | (5)    |   0 St.       \
#                            -------> RE076B
#                             \       10 St. (3!)
#                              \
#                               ----------------> LS076 -------------> RLS076 ----------> KGS076
#                                                 150 St. (4!)         -150 St. (5!)      10 St (7!)
#                                                 | Aktion | remge     | Aktion | remge
#                                                 | (4)    |   0 St.   | (5)    | -150 St
#                                                                      | (6)    |  -10 St
#                                                                      | (7)    |    0 St

# BE
Given I create a PurchaseOrder "BE076" for Vendor "1" with Product "V1" and quantity "150"
Then field "remge" from editor "BE076" in row 1 has value "150"

# RE ohne LB mit Split
Given I open an editor "RE076" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE076"
And I set fields
| such   | RE076  |
| ebeleg | RE076  |
| ueb    | ja     |
| vom    | .      |
| tterm  | .      |
| fakt   | nein   |
And I set field "mge" to "100" in row 1
And I set field "beleg" to id from editor "BE076"
And I set field "mge" to "40" in row 2
And I save the current editor

Then field "remge" from editor "BE076" in row 1 has value "10"
Then "(Purchasing):(PurchaseOrder)" with the editor id "BE076" is not filed

# RE REST
Given I open an editor "RE076B" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE076"
And I set fields
| such   | RE076B |
| ebeleg | RE076B |
| ueb    | ja     |
| vom    | .      |
| tterm  | .      |
And I press button "offueb" in row 1
Then table has values
| artikel | mge |
| V1      | 10  |
And I save the current editor

Then field "remge" from editor "BE076" in row 1 has value "0"
# Alle Lieferungen stehen noch aus
Then "(Purchasing):(PurchaseOrder)" with the editor id "BE076" is not filed

# LS komplett
Given I open an editor "LS076" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE076"
And I set fields
| such   | LS076  |
| ebeleg | LS076  |
| ueb    | ja     |
| vom    | .      |
| tterm  | .      |
And I set field "mge" to "150" in row 1
And I save the current editor

Then field "remge" from editor "RE076B" in row 1 has value "-10"
Then field "remge" from editor "RE076B" in row 2 has value "-10"

Then field "remge" from editor "RE076" in row 1 has value "-100"
Then field "remge" from editor "RE076" in row 2 has value "-40"
Then field "remge" from editor "RE076" in row 3 has value "-40"

Then field "remge" from editor "BE076" in row 1 has value "0"
Then field "remge" from editor "BE076" in row 2 has value "0"
Then "(Purchasing):(PurchaseOrder)" with the editor id "BE076" is filed

# RLS komplett
Given I open an editor "RLS076" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS076"
And I set fields
| such   | RLS076 |
| ebeleg | RLS076 |
| ueb    | ja     |
And I set field "mge" to "-150" in row 1
And I set field "platz" to "F1" in row 1
And I save the current editor

Then field "remge" from editor "RLS076" in row 1 has value "-150"
Then field "remge" from editor "RLS076" in row 2 has value "-150"

Then field "remge" from editor "BE076" in row 1 has value "0"

# Storno der gesplitteten RE
Given I open an editor "SRE076" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE076"
And I save the current editor

Then field "remge" from editor "RLS076" in row 1 has value "-10"

Then field "remge" from editor "BE076" in row 1 has value "140"
Then "(Purchasing):(PurchaseOrder)" with the editor id "BE076" is not filed

# KGS ueber 10 noch moeglich
Given I open an editor "KGS076" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS076"
And I set fields
| such   | KGS076  |
| ebeleg | KGS076  |
| ueb    | ja      |
| vom    | .       |
| tterm  | .       |
And I set field "mge" to "-10" in row 1
And I save the current editor

Then field "remge" from editor "RLS076" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "RLS076" is filed
Then "(Purchasing):(PurchaseOrder)" with the editor id "BE076" is not filed

#----------------------------------------------------------------------------------------------
# Ablagestatus des Liefervorgangs bei offenen Ruecklieferungen
#----------------------------------------------------------------------------------------------

Scenario: Ablagestatus des Liefervorgangs - Nicht fakturierbarer Lieferschein

# Bestellung
Given I open an editor "BE077" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE077  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferung
Given I open an editor "LS077" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE077"
And I set fields
   | such   | LS077  |
   | ebeleg | LS077  |
   | fakt   | nein   |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS077" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS077"
And I set fields
   | such   | RLS077 |
   | vom    | .      |
And I set field "mge" to "-10" in row 1
And I save the current editor

Then "(Purchasing):(PackingSlip)" with the editor id "LS077" is filed

# Rueckliefschein buchen
Given I open an editor "RLS077" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "RLS077"
And I set fields
   | ueb    | ja     |
And I save the current editor

Then "(Purchasing):(PackingSlip)" with the editor id "LS077" is filed

Scenario: Ablagestatus des Liefervorgangs - Fakturierbarer Lieferschein

# Bestellung
Given I open an editor "BE078" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE078  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferung
Given I open an editor "LS078" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE078"
And I set fields
   | such   | LS078  |
   | ebeleg | LS078  |
   | fakt   | ja     |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE078" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS078"
And I set fields
   | such   | RE078  |
   | ebeleg | RE078  |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I set field "preis" to "100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS078" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS078"
And I set fields
   | such   | RLS078 |
   | vom    | .      |
And I set field "mge" to "-10" in row 1
And I save the current editor

Then "(Purchasing):(PackingSlip)" with the editor id "LS078" is filed

# Rueckliefschein buchen
Given I open an editor "RLS078" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "RLS078"
And I set fields
   | ueb    | ja     |
And I save the current editor

Then "(Purchasing):(PackingSlip)" with the editor id "LS078" is filed

Scenario: Ablagestatus des Liefervorgangs - Rechnung mit Lagerbewegung

# Bestellung
Given I open an editor "BE079" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE079  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Rechnung
Given I open an editor "RE079" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE079"
And I set fields
   | such   | RE079  |
   | ebeleg | RE079  |
   | fakt   | ja     |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I set field "preis" to "100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS079" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RE079"
And I set fields
   | such   | RLS079 |
   | vom    | .      |
And I set field "mge" to "-10" in row 1
And I save the current editor

Then "(Purchasing):(Invoice)" with the editor id "RE079" is filed

# Rueckliefschein buchen
Given I open an editor "RLS079" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "RLS079"
And I set fields
   | ueb    | ja     |
And I save the current editor

Then "(Purchasing):(Invoice)" with the editor id "RE079" is filed

#----------------------------------------------------------------------------------------------
# Aktualisierung der offenen Mengen bei parallelen Gutschriften
#----------------------------------------------------------------------------------------------

Scenario: Offene Gutschriften I

# BE080 --- RE080A
# 30 St.    10 St.
#  \
#   \
#     ----- RE080B
#     \     10 St.
#      \
#        --------- LS080
#                  30 St.
#                   \
#                    \
#                      -------- RLS080A --- <Rechnung> ----------
#                      \        -15 St.                           \
#                       \                                           --- KGS080A
#                        \                                        /     | mge     | orig    | herkunft |
#                          ---- RLS080B --- (Beleg anfuegen) ----       | -10 St. | RLS080A | RE080A   |
#                               -15 St.                                 |  -5 St. | RLS080A | RE080B   |
#                                                                       | ------- | ------- | -------- |
#                                                                       |  -5 St. | RLS080B | RE080B   |

# Bestellung
Given I open an editor "BE080" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE080  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 30  |
And I save the current editor

# Rechnung 1
Given I open an editor "RE080A" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE080"
And I set fields
   | such   | RE080A |
   | ebeleg | RE080A |
   | fakt   | nein   |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I set field "preis" to "100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung 2
Given I open an editor "RE080B" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE080"
And I set fields
   | such   | RE080B |
   | ebeleg | RE080B |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I set field "preis" to "200" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferung
Given I open an editor "LS080" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE080"
And I set fields
   | such   | LS080  |
   | ebeleg | LS080  |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

# Ruecklieferung 1
Given I open an editor "RLS080A" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS080"
And I set fields
   | such   | RLS080A |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "-15" in row 1
And I save the current editor

# Ruecklieferung 2
Given I open an editor "RLS080B" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS080"
And I set fields
   | such   | RLS080B |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "-15" in row 1
And I save the current editor

Scenario: Offene Gutschriften I - Gutschrift

# Gutschrift
Given I open an editor "KGS080A" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS080A"
And I set field "such" to "KGS080A"
And I set field "ebeleg" to "KGS080A"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "beleg" to "RLS080B"
And I set field "mge" to "-8" in row 1
And I set field "mge" to "-4" in row 2
And I set field "mge" to "-4" in row 4
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RLS080A" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS080A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS080B" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS080B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS080A" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS080A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften I - Positionen aendern, loeschen und neu anfuegen

Given I open an editor "KGS080A" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS080A"
And I set field "mge" to "-4" in row 1
And I set field "mge" to "-2" in row 2
And I set field "mge" to "-2" in row 4
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I delete all rows
And I set field "beleg" to "RLS080A"
And I set field "beleg" to "RLS080B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario: Offene Gutschriften I - Positionen aendern, loeschen und neu anfuegen, persistenter Zustand

Given I open an editor "RLS080A" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS080A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS080B" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS080B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS080A" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS080A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften I - Einzelne Position loeschen und neu anfuegen

Given I open an editor "KGS080A" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS080A"
And I delete row at position 7
And I delete row at position 6
And I delete row at position 5
And I delete row at position 4
And I delete row at position 3
And I set field "beleg" to "RLS080A"
And I set field "beleg" to "RLS080B"
And I delete row at position 5
And I delete row at position 4
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario: Offene Gutschriften I - Einzelne Position loeschen und neu anfuegen, persistenter Zustand

Given I open an editor "RLS080A" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS080A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS080B" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS080B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS080A" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS080A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften I - Einzelne Position loeschen und neu anfuegen II

Given I open an editor "KGS080A" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS080A"
And I delete row at position 7
And I delete row at position 6
And I delete row at position 5
And I delete row at position 3
And I delete row at position 2
And I delete row at position 1
And I set field "beleg" to "RLS080A"
And I set field "beleg" to "RLS080B"
And I delete row at position 6
And I delete row at position 5
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario: Offene Gutschriften I - Einzelne Position loeschen und neu anfuegen II, persistenter Zustand

Given I open an editor "RLS080A" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS080A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS080B" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS080B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS080A" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS080A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften I - Gutschrift buchen

Given I open an editor "KGS080A" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS080A"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "RLS080A" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS080A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS080B" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS080B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS080A" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS080A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften I - Gutschrift stornieren

Given I open an editor "KGS080A" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KGS080A"
And I save the current editor

Given I open an editor "RLS080A" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS080A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS080B" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS080B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS080A" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS080A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften II

# BE081 --- RE081A
# 30 St.    10 St.
#  \
#   \
#     ----- RE081B
#     \     10 St.
#      \
#        --------- LS081A --- <Retoure> -----------
#        \         15 St.                           \
#         \                                           --- RLS081A ----------------- KGS081A
#          \                                        /     | mge     | orig   |      | mge     | orig      | herkunft |
#            ----- LS081B --- (Beleg anfuegen) ----       | -15 St. | LS081A |      |  -5 St. | RLS081A_1 | RE080A   |
#                  15 St.                                 | ------- | ------ |      | ------- | --------- | -------- |
#                                                         | -15 St. | LS081B |      | -10 St. | RLS081A_2 | RE080A   |
#                                                                                   |  -5 St. | RLS081A_2 | RE080B   |
#

# Bestellung
Given I open an editor "BE081" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE081  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 30  |
And I save the current editor

# Rechnung 1
Given I open an editor "RE081A" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE081"
And I set fields
   | such   | RE081A |
   | ebeleg | RE081A |
   | fakt   | nein   |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I set field "preis" to "100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung 2
Given I open an editor "RE081B" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE081"
And I set fields
   | such   | RE081B |
   | ebeleg | RE081B |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I set field "preis" to "200" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferung 1
Given I open an editor "LS081A" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE081"
And I set fields
   | such   | LS081A |
   | ebeleg | LS081A |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "15" in row 1
And I save the current editor

# Lieferung 2
Given I open an editor "LS081B" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE081"
And I set fields
   | such   | LS081B |
   | ebeleg | LS081B |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "15" in row 1
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS081A" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS081A"
And I set fields
   | such   | RLS081A |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "-15" in row 1
And I set field "beleg" to "+LS081B"
And I set field "mge" to "-15" in row 3
And I save the current editor

Scenario: Offene Gutschriften II - Gutschrift

# Gutschrift
Given I open an editor "KGS081A" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS081A"
And I set fields
   | such   | KGS081A |
   | ebeleg | KGS081A |
   | vom    | .       |
   | ueb    | nein    |
And I set field "such" to "KGS081A"
And I set field "mge" to "-8" in row 1
And I set field "mge" to "-4" in row 2
And I set field "mge" to "-4" in row 4
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RLS081A" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS081A" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften II - Positionen aendern, loeschen und neu anfuegen

Given I open an editor "KGS081A" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS081A"
And I set field "mge" to "-4" in row 1
And I set field "mge" to "-2" in row 2
And I set field "mge" to "-2" in row 4
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I delete all rows
And I set field "beleg" to "RLS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario: Offene Gutschriften II - Positionen aendern, loeschen und neu anfuegen, persistenter Zustand

Given I open an editor "RLS081A" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS081A" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften II - Einzelne Position loeschen und neu anfuegen

Given I open an editor "KGS081A" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS081A"
And I delete row at position 7
And I delete row at position 6
And I delete row at position 5
And I delete row at position 3
And I delete row at position 2
And I delete row at position 1
And I set field "beleg" to "RLS081A"
And I delete row at position 6
And I delete row at position 5
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario: Offene Gutschriften II - Einzelne Position loeschen und neu anfuegen, persistenter Zustand

Given I open an editor "RLS081A" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS081A" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften II - Einzelne Position loeschen und neu anfuegen II

Given I open an editor "KGS081A" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS081A"
And I delete row at position 7
And I delete row at position 6
And I delete row at position 5
And I delete row at position 4
And I delete row at position 2
And I delete row at position 1
And I set field "beleg" to "RLS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario: Offene Gutschriften II - Einzelne Position loeschen und neu anfuegen II, persistenter Zustand

Given I open an editor "RLS081A" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS081A" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften II - Gutschrift buchen

Given I open an editor "KGS081A" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS081A"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "RLS081A" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS081A" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften II - Gutschrift stornieren

Given I open an editor "KGS081A" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KGS081A"
And I save the current editor

Given I open an editor "RLS081A" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS081A" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften III - Parallele Gutschriften

#  BE082 ---------------- RE082A (gebucht)
#  30 St.                 10 St.
#    \
#     \
#        ---------------- RE082B (gebucht)
#       \                 10 St.
#        \
#         \
#            ------------ LS082  (gebucht)
#                         30 St.
#                           \
#                              ---------------- RLS082A ------------- KGS082A (offen)
#                             \                -15 St.                | mge     | herkunft |
#                              \                                      | -10 St. | RE082A   |
#                               \                                     |  -5 St. | RE082B   |
#                                \
#                                  ------------ RLS082B  ------------ KGS082B (offen)
#                                              -15 St.                | mge     | herkunft |
#                                                                     |  -5 St. | RE082B   |
#

# Bestellung
Given I open an editor "BE082" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE082  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 30  |
And I save the current editor

# Rechnung 1
Given I open an editor "RE082A" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE082"
And I set fields
   | such   | RE082A |
   | ebeleg | RE082A |
   | fakt   | nein   |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I set field "preis" to "100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung 2
Given I open an editor "RE082B" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE082"
And I set fields
   | such   | RE082B |
   | ebeleg | RE082B |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I set field "preis" to "200" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferung
Given I open an editor "LS082" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE082"
And I set fields
   | such   | LS082  |
   | ebeleg | LS082  |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

# Ruecklieferung 1
Given I open an editor "RLS082A" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS082"
And I set fields
   | such   | RLS082A |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "-15" in row 1
And I save the current editor

# Ruecklieferung 2
Given I open an editor "RLS082B" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS082"
And I set fields
   | such   | RLS082B |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "-15" in row 1
And I save the current editor

Scenario: Offene Gutschriften III - Gutschrift

# Gutschrift 1
Given I open an editor "KGS082A" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS082A"
And I set field "such" to "KGS082A"
And I set field "ebeleg" to "KGS082A"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "mge" to "-5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Gutschrift 2
Given I open an editor "KGS082B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS082B"
And I set field "such" to "KGS082B"
And I set field "ebeleg" to "KGS082B"
And I set field "vom" to "."
And I set field "tterm" to "."
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RLS082A" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS082B" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS082A" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS082B" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften III - Mengenaenderungen

Given I open an editor "KGS082A" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS082A"
And I set field "mge" to "-1" in row 1
And I set field "mge" to "-1" in row 2
And I save the current editor

Given I open an editor "KGS082B" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS082B"
And I delete row at position 5
And I delete row at position 4
And I delete row at position 3
And I set field "beleg" to "RLS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I delete all rows
And I set field "beleg" to "RLS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario: Offene Gutschriften III - Mengenaenderungen, persistenter Zustand

Given I open an editor "RLS082A" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS082B" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS082A" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS082B" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften III - Mengenaenderungen II

Given I open an editor "KGS082B" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS082B"
And I set field "mge" to "-5" in row 1
And I set field "mge" to "-5" in row 2
And I save the current editor

Given I open an editor "KGS082A" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS082A"
And I delete row at position 5
And I delete row at position 4
And I delete row at position 3
And I set field "beleg" to "RLS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "KGS082A" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS082A"
And I delete all rows
And I set field "beleg" to "RLS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario: Offene Gutschriften III - Mengenaenderungen II, persistenter Zustand

Given I open an editor "RLS082A" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS082B" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS082A" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS082B" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften III - Gutschrift buchen

Given I open an editor "KGS082A" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS082A"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "RLS082A" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS082B" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS082A" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS082B" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften III - Gutschrift buchen II

Given I open an editor "KGS082B" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS082B"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "RLS082A" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS082B" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS082A" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS082B" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften III - Gutschrift stornieren

Given I open an editor "KGS082A" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KGS082A"
And I save the current editor

Given I open an editor "RLS082A" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS082B" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS082A" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS082B" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften IV - Wie III, aber mit unterschiedlichen Einheiten.

#  BE083 ---------------- RE083A (gebucht)
#  30 St.                 10 St.
#    \
#     \
#        ---------------- RE083B (gebucht)
#       \                 10 St.
#        \
#         \
#            ------------ LS083  (gebucht)
#                         30 St.
#                           \
#                              ---------------- RLS083A ------------- KGS083A (offen)
#                             \                -30 kg                 | mge     | herkunft |
#                              \                                      | -20 kg  | RE083A   |
#                               \                                     | -10 kg. | RE083B   |
#                                \
#                                  ------------ RLS083B  ------------ KGS083B (offen)
#                                              -15 St.                | mge     | herkunft |
#                                                                     |  -5 St. | RE083B   |
#

# Bestellung
Given I open an editor "BE083" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE083  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 30  |
And I save the current editor

# Rechnung 1
Given I open an editor "RE083A" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE083"
And I set fields
   | such   | RE083A |
   | ebeleg | RE083A |
   | fakt   | nein   |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I set field "preis" to "100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung 2
Given I open an editor "RE083B" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE083"
And I set fields
   | such   | RE083B |
   | ebeleg | RE083B |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I set field "preis" to "200" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferung
Given I open an editor "LS083" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE083"
And I set fields
   | such   | LS083  |
   | ebeleg | LS083  |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

# Ruecklieferung 1
Given I open an editor "RLS083A" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS083"
And I set fields
   | such   | RLS083A |
   | vom    | .       |
   | ueb    | ja      |
And I set field "he" to "kg" in row 1
And I set field "mge" to "-30" in row 1
And I save the current editor

# Ruecklieferung 2
Given I open an editor "RLS083B" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS083"
And I set fields
   | such   | RLS083B |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "-15" in row 1
And I save the current editor

Scenario: Offene Gutschriften IV - Gutschrift

# Gutschrift 1
Given I open an editor "KGS083A" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS083A"
And I set field "such" to "KGS083A"
And I set field "ebeleg" to "KGS083A"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "mge" to "-10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Gutschrift 2
Given I open an editor "KGS083B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS083B"
And I set field "such" to "KGS083B"
And I set field "ebeleg" to "KGS083B"
And I set field "vom" to "."
And I set field "tterm" to "."
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RLS083A" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS083A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS083B" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS083B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS083A" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS083A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS083B" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS083B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften IV - Mengenaenderungen

Given I open an editor "KGS083A" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS083A"
And I set field "mge" to "-2" in row 1
And I set field "mge" to "-2" in row 2
And I save the current editor

Given I open an editor "KGS083B" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS083B"
And I delete row at position 5
And I delete row at position 4
And I delete row at position 3
And I set field "beleg" to "RLS083B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I delete all rows
And I set field "beleg" to "RLS083B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario: Offene Gutschriften IV - Mengenaenderungen, persistenter Zustand

Given I open an editor "RLS083A" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS083A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS083B" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS083B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS083A" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS083A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS083B" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS083B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften IV - Mengenaenderungen II

Given I open an editor "KGS083B" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS083B"
And I set field "mge" to "-5" in row 1
And I set field "mge" to "-5" in row 2
And I save the current editor

Given I open an editor "KGS083A" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS083A"
And I delete row at position 5
And I delete row at position 4
And I delete row at position 3
And I set field "beleg" to "RLS083A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "KGS083A" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS083A"
And I delete all rows
And I set field "beleg" to "RLS083A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario: Offene Gutschriften IV - Mengenaenderungen II, persistenter Zustand

Given I open an editor "RLS083A" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS083A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS083B" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS083B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS083A" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS083A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS083B" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS083B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

#----------------------------------------------------------------------------------------------
# Restmengenstorno im Lieferschein
#----------------------------------------------------------------------------------------------

Scenario: Restmengenstorno im Lieferschein

# Bestellung
Given I open an editor "1BE090" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE090 |
   | lief   | 1      |
   | such   | BE090  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferschein
Given I open an editor "1LS090" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE090"
And I set fields
   | nummer | 1LS090 |
   | such   | LS090  |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "4" in row 1
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I save the current editor

# Storno Lieferschein
Given I open an editor "1LS090S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "1LS090"
And I set fields
   | nummer | 1LS090S |
And I save the current editor

Given I open an editor "1BE090" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "1BE090"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

#----------------------------------------------------------------------------------------------
# Lieferscheinstorno nach Ueberbelieferung
#----------------------------------------------------------------------------------------------

Scenario: Lieferscheinstorno nach Ueberbelieferung

# Bestellung
Given I open an editor "1BE095" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE095 |
   | lief   | 1      |
   | such   | BE095  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 100 |
And I save the current editor

# Teillieferung
Given I open an editor "1LS095" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE095"
And I set fields
   | nummer | 1LS095  |
   | such   | LS095-1 |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "80" in row 1
And I save the current editor

# Teillieferung
Given I open an editor "2LS095" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE095"
And I set fields
   | nummer | 2LS095  |
   | such   | LS095-2 |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "30" in row 1
And I save the current editor

# Storno Lieferschein
Given I open an editor "2LS095S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "2LS095"
And I set fields
   | nummer | 1LS095S |
And I save the current editor

Given I open an editor "1BE095" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "1BE095"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Lieferscheinstorno nach Ueberbelieferung, mehrfaches Anfuegen von Belegen

# Bestellung
Given I open an editor "1BE096" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE096 |
   | lief   | 1      |
   | such   | BE096  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 100 |
And I save the current editor

# Lieferung
Given I open an editor "1LS096" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE096"
And I set fields
   | nummer | 1LS096 |
   | such   | LS096  |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "80" in row 1
And I set field "beleg" to id from editor "1BE096"
And I set field "mge" to "70" in row 2
And I save the current editor

# Storno Lieferschein
Given I open an editor "1LS096S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "1LS096"
And I set fields
   | nummer | 1LS096S |
And I save the current editor

Given I open an editor "1BE096" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "1BE096"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Lieferscheinstorno nach Ueberbelieferung, mehrfaches Anfuegen von Belegen II

# Bestellung
Given I open an editor "1BE097" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE097 |
   | lief   | 1      |
   | such   | BE097  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 100 |
And I save the current editor

# Lieferung
Given I open an editor "1LS097" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE097"
And I set fields
   | nummer | 1LS097 |
   | such   | LS097  |
   | vom    | .      |
   | ueb    | nein   |
And I set field "mge" to "120" in row 1
And I save the current editor

Given I open an editor "1LS097" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "1LS097"
And I set field "ueb" to "ja"
And I set field "beleg" to id from editor "1BE097"
And I set field "mge" to "30" in row 3
And I save the current editor

# Storno Lieferschein
Given I open an editor "1LS097S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "1LS097"
And I set fields
   | nummer | 1LS097S |
And I save the current editor

Given I open an editor "1BE097" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "1BE097"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

#----------------------------------------------------------------------------------------------
# Ueberbelieferung bei lieferseitigem Abschluss, getrenntes Fakturieren
#----------------------------------------------------------------------------------------------

Scenario: Ueberbelieferung bei lieferseitigem Abschluss, getrenntes Fakturieren

# Bestellung
Given I open an editor "1BE098" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE098 |
   | lief   | 1      |
   | such   | BE098  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 100 |
And I save the current editor

# Erste Lieferung
Given I open an editor "1LS098" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE098"
And I set fields
   | nummer | 1LS098  |
   | such   | LS098-1 |
   | vom    | .       |
   | fakt   | nein    |
   | ueb    | nein    |
And I set field "mge" to "80" in row 1
And I save the current editor

# Zweite Lieferung
Given I open an editor "2LS098" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE098"
And I set fields
   | nummer | 2LS098  |
   | such   | LS098-2 |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "20" in row 1
And I save the current editor

# Ueberbelieferung erste Lieferung
Given I open an editor "1LS098" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "1LS098"
And I set field "ueb" to "ja"
And I set field "mge" to "100" in row 1
And I save the current editor

Given I open an editor "1BE098" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "1BE098"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

#----------------------------------------------------------------------------------------------
# Lieferung aus abgelegter Bestellung
#----------------------------------------------------------------------------------------------

Scenario: Lieferung aus abgelegter Bestellung

# Bestellung
Given I open an editor "1BE110" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE110 |
   | lief   | 1      |
   | such   | BE110  |
And I append rows
   | artikel | he    | mge  |
   | A100    | Stück | 1000 |
And I save the current editor

# Erste Lieferung
Given I open an editor "1LS110" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE110"
And I set fields
   | nummer | 1LS110  |
   | such   | LS110-1 |
   | vom    | .       |
   | fakt   | ja      |
   | ueb    | ja      |
And I set field "mge" to "1200" in row 1
And I save the current editor

# Zweite Lieferung
Given I open an editor "2LS110" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE110"
And I set fields
   | nummer | 2LS110  |
   | such   | LS110-2 |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "900" in row 1
And I save the current editor

Given I open an editor "1BE110" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "1BE110"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Storno der ersten Lieferung
Given I open an editor "1LS110S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "1LS110"
And I set field "nummer" to "1LS110S"
And I save the current editor

Given I open an editor "1BE110" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "1BE110"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Rechnung zur zweiten Lieferung
Given I open an editor "2RE110" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "2LS110"
And I set fields
   | nummer | 2RE110  |
   | such   | RE110-2 |
   | ueb    | ja      |
   | vom    | .       |
   | tterm  | .       |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "1BE110" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "1BE110"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Lieferung aus abgelegter Bestellung II

# Bestellung
Given I open an editor "1BE111" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE111 |
   | lief   | 1      |
   | such   | BE111  |
And I append rows
   | artikel | he    | mge  |
   | A100    | Stück | 1000 |
And I save the current editor

# Erste Lieferung
Given I open an editor "1LS111" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE111"
And I set fields
   | nummer | 1LS111  |
   | such   | LS111-1 |
   | vom    | .       |
   | fakt   | nein    |
   | ueb    | ja      |
And I set field "mge" to "600" in row 1
And I save the current editor

# Rechnung zur ersten Lieferung
Given I open an editor "1RE111" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE111"
And I set fields
   | nummer | 1RE111  |
   | such   | RE111-1 |
   | ueb    | ja      |
   | vom    | .       |
   | tterm  | .       |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Zweite Lieferung
Given I open an editor "2LS111" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE111"
And I set fields
   | nummer | 2LS111  |
   | such   | LS111-2 |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "800" in row 1
And I save the current editor

# Dritte Lieferung
Given I open an editor "3LS111" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE111"
And I set fields
   | nummer | 3LS111  |
   | such   | LS111-3 |
   | vom    | .       |
   | fakt   | ja      |
   | ueb    | ja      |
And I set field "mge" to "900" in row 1
And I save the current editor

Given I open an editor "1BE111" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "1BE111"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Storno der ersten Lieferung
Given I open an editor "1LS111S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "1LS111"
And I set field "nummer" to "1LS111S"
And I save the current editor

Given I open an editor "1BE111" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "1BE111"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

#----------------------------------------------------------------------------------------------
# Teillieferungen mit Ueberbelieferung, Storno erste Teillieferung
#----------------------------------------------------------------------------------------------

Scenario: Teillieferungen mit Ueberbelieferung, Storno erste Teillieferung

# Bestellung
Given I open an editor "1BE112" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE112 |
   | lief   | 1      |
   | such   | BE112  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Erste Lieferung
Given I open an editor "1LS112" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE112"
And I set fields
   | nummer | 1LS112  |
   | such   | LS112-1 |
   | vom    | .       |
   | fakt   | ja      |
   | ueb    | ja      |
And I set field "mge" to "5" in row 1
And I save the current editor

# Zweite Lieferung
Given I open an editor "2LS112" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE112"
And I set fields
   | nummer | 2LS112  |
   | such   | LS112-2 |
   | vom    | .       |
   | fakt   | ja      |
   | ueb    | ja      |
And I set field "mge" to "6" in row 1
And I save the current editor

# Storno erste Lieferung
Given I open an editor "1LS112" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "1LS112"
And I set fields
   | nummer | 1LS112S |
And I save the current editor

Given I open an editor "1BE112" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "1BE112"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

#----------------------------------------------------------------------------------------------
# Lieferung Bestellung, Lieferschein speichern, Lieferposition loeschen, buchen
#----------------------------------------------------------------------------------------------

Scenario: Lieferung Bestellung, Lieferschein speichern, Lieferposition loeschen, buchen

# Bestellung
Given I open an editor "1BE113" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE113 |
   | lief   | 1      |
   | such   | BE113  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
   | A100    | Stück | 10  |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferung
Given I open an editor "1LS113" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE113"
And I set fields
   | nummer | 1LS113  |
   | such   | LS113-1 |
   | vom    | .       |
   | fakt   | ja      |
   | ueb    | ja      |
And I set field "mge" to "5" in row 3
And I save the current editor

# Lieferung
Given I open an editor "2LS113" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE113"
And I set fields
   | nummer | 2LS113  |
   | such   | LS113-2 |
   | vom    | .       |
   | fakt   | ja      |
And I set field "mge" to "10" in row 1
And I set field "mge" to "10" in row 2
And I set field "mge" to "3" in row 3
And I save the current editor

# Lieferposition loeschen, buchen
Given I open an editor "2LS113" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "2LS113"
And I set field "ueb" to "ja"
And I delete row at position 2
And I delete row at position 2
And I save the current editor

Given I open an editor "1BE113" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "1BE113"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

#----------------------------------------------------------------------------------------------
# Lieferung Bestellung, Lieferposition loeschen, buchen
#----------------------------------------------------------------------------------------------

Scenario: Lieferung Bestellung, Lieferschein speichern, Lieferposition loeschen, buchen

# Bestellung
Given I open an editor "1BE114" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE114 |
   | lief   | 1      |
   | such   | BE114  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
   | A100    | Stück | 10  |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferung
Given I open an editor "1LS114" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE114"
And I set fields
   | nummer | 1LS114  |
   | such   | LS114-1 |
   | vom    | .       |
   | fakt   | ja      |
   | ueb    | ja      |
And I set field "mge" to "5" in row 3
And I save the current editor

# Lieferung
Given I open an editor "1LS114" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE114"
And I set fields
   | nummer | 2LS114  |
   | such   | LS114-2 |
   | vom    | .       |
   | fakt   | ja      |
   | ueb    | ja      |
And I set field "mge" to "10" in row 1
And I set field "mge" to "10" in row 2
And I set field "mge" to "3" in row 3
And I delete row at position 2
And I delete row at position 2
And I save the current editor

Given I open an editor "1BE114" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "1BE114"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: Kommando <Einkauf> ... <uebertragen> bei Ueberberechnung nach Ruecklieferung
#----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE115" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE115 |
   | lief   | 1      |
   | such   | BE115  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 250 |
And I save the current editor

# Lieferung
Given I open an editor "1LS115" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE115"
And I set fields
   | nummer | 1LS115  |
   | such   | LS115   |
   | vom    | .       |
   | fakt   | ja      |
   | ueb    | ja      |
And I set field "mge" to "250" in row 1
And I save the current editor

# Rechnung
Given I open an editor "1RE115" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS115"
And I set fields
   | nummer | 1RE115 |
   | such   | RE115  |
   | vom    | .      |
And I set field "mge" to "250" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "1LS115" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS115"
And I set fields
   | nummer | 1RLS115 |
   | such   | RLS115  |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "-250" in row 1
And I save the current editor

# Rechnung buchen
Given I open an editor "1RE115" from table "(Purchasing):(Invoice)" with command "TRANSFER" for record from editor "1RE115"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Storno einer Bestellposition bei Fakturierung ueber die Bestellung
#----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE116" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE116 |
   | lief   | 1      |
   | such   | BE116  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 500 |
And I save the current editor

# Lieferschein
Given I open an editor "1LS116" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "1BE116"
And I set fields
   | nummer | 1LS116 |
   | such   | LS116  |
   | fakt   | false  |
   | ueb    | true   |
   | vom    | .      |
And I set field "mge" to "400" in row 1
And I save the current editor

# Rechnung
Given I open an editor "1RE116" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE116"
And I set fields
   | nummer | 1RE116 |
   | such   | RE116  |
   | ueb    | true   |
   | vom    | .      |
And I set field "mge" to "400" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein
Given I open an editor "1RLS116" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS116"
And I set fields
   | nummer | 1RLS116 |
   | such   | RLS116  |
   | ueb    | true    |
   | vom    | .       |
And I set field "mge" to "-400" in row 1
And I save the current editor

# Kaufm. Gutschrift
Given I open an editor "1KGS116" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1RLS116"
And I set fields
   | nummer | 1KGS116 |
   | such   | KGS116  |
   | vom    | .       |
Then field "mge" has value "-300" in row 1
And I close the current editor

# Bestellposition stornieren
Given I open an editor "1BE116" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "1BE116"
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I save the current editor

# Kaufm. Gutschrift
Given I open an editor "1KGS116" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1RLS116"
And I set fields
   | nummer | 1KGS116 |
   | such   | KGS116  |
   | vom    | .       |
# FEHLER: Menge muesste durch die Stornierung der Bestellposition -400 sein.
Then field "mge" has value "-300" in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: Rundungsproblematik von (ev)limge und (ev)remge bei gebrochenen Mengen
#----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE117" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE117 |
   | lief   | 1      |
   | such   | BE117  |
And I append rows
   | artikel | he    | mge    |
   | A100    | Stück | 100000 |
And I save the current editor

# Lieferschein
Given I open an editor "1LS117" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "1BE117"
And I set fields
   | nummer | 1LS117 |
   | such   | LS117  |
   | vom    | .      |
   | ueb    | true   |
And I set field "mge" to "1.1" in row 1
And I set field "beleg" to id from editor "1BE117"
And I set field "mge" to "1.1" in row 2
And I set field "beleg" to id from editor "1BE117"
And I set field "mge" to "1.1" in row 3
And I set field "beleg" to id from editor "1BE117"
And I set field "mge" to "1.1" in row 4
And I set field "beleg" to id from editor "1BE117"
And I set field "mge" to "1.1" in row 5
And I set field "beleg" to id from editor "1BE117"
And I set field "mge" to "1.1" in row 6
And I set field "beleg" to id from editor "1BE117"
And I set field "mge" to "1.1" in row 7
And I set field "beleg" to id from editor "1BE117"
And I set field "mge" to "1.1" in row 8
And I set field "beleg" to id from editor "1BE117"
And I set field "mge" to "1.1" in row 9
And I set field "beleg" to id from editor "1BE117"
And I set field "mge" to "1.1" in row 10
And I set field "beleg" to id from editor "1BE117"
And I set field "mge" to "1.1" in row 11
And I set field "beleg" to id from editor "1BE117"
And I set field "mge" to "1.1" in row 12
And I set field "beleg" to id from editor "1BE117"
And I set field "mge" to "1.1" in row 13
And I set field "beleg" to id from editor "1BE117"
And I set field "mge" to "1.1" in row 14
And I set field "beleg" to id from editor "1BE117"
And I set field "mge" to "1.1" in row 15
And I set field "beleg" to id from editor "1BE117"
And I set field "mge" to "1.1" in row 16
And I set field "beleg" to id from editor "1BE117"
And I set field "mge" to "1.1" in row 17
And I set field "beleg" to id from editor "1BE117"
And I set field "mge" to "1.1" in row 18
And I save the current editor

# Fakturierung ueber einen neuen Lieferschein muss moeglich sein. Andernfalls sind (ev)limge und (ev)remge auseinandergelaufen.
Given I open an editor "2LS117" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE117"
Then field "fakt" is modifiable in row 0
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Auftrag mit Zusatzposition, LS mit negativer Menge, Storno LS, Rechnungsobligo nicht moeglich
#----------------------------------------------------------------------------------------------
# Bestellung
Given I open an editor "BE201" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE201 |
   | lief   | 1      |
   | such   | BE201  |
And I append rows
   | artikel | mge |
   | AUBE    |  20 |
   | A100    |  10 |
And I save the current editor

# Lieferschein aus Bestellung erzeugen
Given I open an editor "EKLS201" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE201"
And I set fields
   | nummer | 1EKLS201 |
   | such   | EKLS201  |
   | ueb    | true     |
   | vom    | .        |
Then the table has 2 rows
And I set field "mge" to "-6" in row 1
And I set field "mge" to "7" in row 2
And I save the current editor

# Lieferschein stornieren
Given I open an editor "SEKLS201" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "EKLS201"
Then field "remge" has value "0" in row 1
And I save the current editor
# LS geht in die Ablage
Then "(Purchasing):(PackingSlip)" with the editor id "SEKLS201" is filed
Then field "remge" has value "0" in row 1

#----------------------------------------------------------------------------------------------
Scenario: Restmengenstorno in neutraler Position bei Ueberberechnung
#----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE202" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1BE202 |
	| lief   | 1      |
And I append rows
	| artikel | mge         | preis      | pwert       |
	| A100    | 10          | 10         | !dontChange |
	| NEUTRAL | !dontChange |!dontChange | 20          |
And I save the current editor

# Lieferschein aus Bestellung erzeugen
Given I open an editor "1LS202" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE202"
And I set fields
	| nummer | 1LS202 |
	| vom    | .      |
	| ueb    | ja     |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung aus Lieferschein erzeugen
Given I open an editor "1RE202" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS202"
And I set fields
	| nummer | 1RE202 |
	| ueb    | ja     |
	| vom    | .      |
And I set field "pwert" to "25" in row 2
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then "(Purchasing):(PackingSlip)" with the editor id "1LS202" is filed

#----------------------------------------------------------------------------------------------
Scenario: EK - BE mit Text Position -> LS -> RE -> Storno RE: Lieferschein nicht mehr in der Ablage
#----------------------------------------------------------------------------------------------
# Bestellung
Given I open an editor "BE203" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief  | 1      |
   | such  | BE203  |
And I append rows
   | artikel | he          | mge         | pwert |
   | Text    | !dontChange | !dontChange |   0   |
   | NEUTRAL | !dontChange | !dontChange |   0   |
   | E1      | Stück       | 10          | 203   |
Then field "pwert" has value "0.00" in row 1
And I save the current editor

# Lieferschein
Given I open an editor "LS203EK" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE203"
And I set fields
   | such   | LS203EK |
   | nummer | 1LS203  |
   | ueb    | true    |
   | fakt   | true    |
   | vom    | .       |
Then the table has 3 rows
And I set field "mge" to "203" in row 3
And I save the current editor

# Rechnung
Given I open an editor "RE203EK" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS203EK"
And I set fields
   | such   | RE203EK |
   | nummer | 1RE203  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
Then the table has 3 rows
And I set field "mge" to "203" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
Then "(Purchasing):(PackingSlip)" with the editor id "LS203EK" is filed

# Rechnung stornieren
Given I open an editor "SRE203EK" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE203EK"
And I save the current editor
Then field "remge" from editor "LS203EK" in row 1 has value "0"
Then field "remge" from editor "LS203EK" in row 3 has value "203"
Then "(Purchasing):(PackingSlip)" with the editor id "LS203EK" is not filed

#----------------------------------------------------------------------------------------------
Scenario: EK - BE mit neutraler Position -> LS -> RE -> Storno RE: Lieferschein nicht mehr in der Ablage
#----------------------------------------------------------------------------------------------
# Bestellung
Given I open an editor "BE203B" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief  | 1      |
   | such  | BE203B |
And I append rows
   | artikel | he          | mge         | pwert |
   | NEUTRAL | !dontChange | !dontChange |   0   |
   | Text    | !dontChange | !dontChange |   0   |
   | E1      | Stück       | 10          | 203   |
Then field "pwert" has value "0.00" in row 1
And I save the current editor

# Lieferschein
Given I open an editor "LS203EKB" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE203"
And I set fields
   | such   | LS203EKB|
   | nummer | 1LS203B |
   | ueb    | true    |
   | fakt   | true    |
   | vom    | .       |
Then the table has 3 rows
And I set field "mge" to "203" in row 3
And I save the current editor

# Rechnung
Given I open an editor "RE203EKB" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS203EKB"
And I set fields
   | such   | RE203EKB|
   | nummer | 1RE203B |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
Then the table has 3 rows
And I set field "mge" to "203" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung stornieren
Given I open an editor "SRE203EKB" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE203EKB"
And I save the current editor
Then field "remge" from editor "LS203EKB" in row 1 has value "0"
Then field "remge" from editor "LS203EKB" in row 3 has value "203"
Then "(Purchasing):(PackingSlip)" with the editor id "LS203EKB" is not filed


#----------------------------------------------------------------------------------------------
Scenario: EK - LS -> RLS mit Text Position -> RE -> KGS zu RLS: Ruecklieferschein in der Ablage
#----------------------------------------------------------------------------------------------
# Lieferschein
Given I open an editor "LS204EK" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lief   | 1       |
   | such   | LS204EK |
   | nummer | 1LS204  |
   | ueb    | true    |
   | vom    | .       |
And I append rows
   | artikel | he    | mge |
   | E1      | Stück | 5   |
And I save the current editor

# RLS: Textposition an erste Stelle einfuegen
Given I open an editor "RLS204" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS204EK"
And I set fields
   | such   | RLS204  |
   | nummer | 1RLS204 |
   | vom    | .       |
   | ueb    | true    |
And I create a new row at position 1
And I set field "artikel" to "Text" in row 1
And I set field "mge" to "-2" in row 2
And I save the current editor
# RLS abgelegt
Then "(Purchasing):(PackingSlip)" with the editor id "RLS204" is filed

# Rechnung ohne zu buchen
Given I open an editor "RE204EK" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS204EK"
And I set fields
   | such   | RE204EK |
   | nummer | 1RE204  |
   | vom    | .       |
   | tterm  | .       |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# RLS in der Ablage
Then "(Purchasing):(PackingSlip)" with the editor id "RLS204" is filed

# Rechnung buchen
Given I open an editor "RE204EK" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE204EK"
And I set field "ueb" to "ja"
And I save the current editor
# RLS nicht mehr in der Ablage
Then "(Purchasing):(PackingSlip)" with the editor id "RLS204" is not filed

# KGS zu der Ruecklieferung
Given I open an editor "KGS204EK" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS204"
And I set fields
   | such   | KGS204EK |
   | nummer | 1KGS204  |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | true     |
Then the table has 2 rows
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# RLS ist in der Ablage
Then "(Purchasing):(PackingSlip)" with the editor id "RLS204" is filed

#----------------------------------------------------------------------------------------------
Scenario: EK - LS -> RLS mit neutraler Position -> RE -> KGS zu RLS: Ruecklieferschein in der Ablage
#----------------------------------------------------------------------------------------------
# Lieferschein
Given I open an editor "LS205EK" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lief   | 1       |
   | such   | LS205EK |
   | nummer | 1LS205  |
   | ueb    | true    |
   | vom    | .       |
And I append rows
   | artikel | he    | mge |
   | E1      | Stück | 5   |
And I save the current editor

# RLS: neutrale Position an erste Stelle einfuegen
Given I open an editor "RLS205" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS205EK"
And I set fields
   | such   | RLS205  |
   | nummer | 1RLS205 |
   | vom    | .       |
   | ueb    | true    |
And I create a new row at position 1
And I set field "artikel" to "0NEUTRAL" in row 1
And I set field "mge" to "-3" in row 2
And I save the current editor
# RLS abgelegt
Then "(Purchasing):(PackingSlip)" with the editor id "RLS205" is filed

# Rechnung ohne zu buchen
Given I open an editor "RE205EK" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS205EK"
And I set fields
   | such   | RE205EK |
   | nummer | 1RE205  |
   | vom    | .       |
   | tterm  | .       |
Then the table has 1 rows
Then field "mge" has value "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# RLS in der Ablage
Then "(Purchasing):(PackingSlip)" with the editor id "RLS205" is filed

# Rechnung buchen
Given I open an editor "RE205EK" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE205EK"
And I set field "ueb" to "ja"
And I save the current editor
# RLS nicht mehr in der Ablage
Then "(Purchasing):(PackingSlip)" with the editor id "RLS205" is not filed

# KGS zu der Ruecklieferung
Given I open an editor "KGS205EK" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS205"
And I set fields
   | such   | KGS205EK |
   | nummer | 1KGS205  |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | true     |
Then the table has 2 rows
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# RLS ist in der Ablage
Then "(Purchasing):(PackingSlip)" with the editor id "RLS205" is filed

#----------------------------------------------------------------------------------------------
Scenario: EK - LS -> RLS mit neutraler Position und zwei Artikelpositionen -> RE -> KGS zu RLS: Ruecklieferschein in der Ablage
#----------------------------------------------------------------------------------------------

# Lieferschein
Given I open an editor "LS206EK" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lief   | 1       |
   | such   | LS206EK |
   | nummer | 1LS206  |
   | ueb    | true    |
   | vom    | .       |
And I append rows
   | artikel | he    | mge |
   | E1      | Stück | 5   |
   | E2      | Stück | 10  |
And I save the current editor

# RLS: neutrale Position an erste Stelle einfuegen
Given I open an editor "RLS206" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS206EK"
And I set fields
   | such   | RLS206  |
   | nummer | 1RLS206 |
   | vom    | .       |
   | ueb    | true    |
And I create a new row at position 1
And I set field "artikel" to "0NEUTRAL" in row 1
And I set field "mge" to "-5" in row 2
And I set field "mge" to "-5" in row 3
And I save the current editor
# RLS abgelegt
Then "(Purchasing):(PackingSlip)" with the editor id "RLS206" is filed

# Rechnung
Given I open an editor "RE206EK" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS206EK"
And I set fields
   | such   | RE206EK |
   | nummer | 1RE206  |
   | vom    | .       |
   | ueb    | true    |
Then the table has 2 rows
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# RLS in der Ablage
Then "(Purchasing):(PackingSlip)" with the editor id "RLS206" is not filed

# Gutschrift zur Ruecklieferung
Given I open an editor "KGS206EK" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS206"
And I set fields
   | such   | KGS206EK |
   | nummer | 1KGS206  |
   | vom    | .        |
   | ueb    | true     |
Then the table has 3 rows
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# RLS ist in der Ablage
Then "(Purchasing):(PackingSlip)" with the editor id "RLS206" is filed

#----------------------------------------------------------------------------------------------
Scenario: Rechnung ohne Lagerbewegung und Restmengenstorno
#----------------------------------------------------------------------------------------------

# Bestellung
Given I create a PurchaseOrder "BE210" for Vendor "1" with Product "E2" and quantity "10" and price "5"

# Rechnung ohne LB
Given I open an editor "RE210" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE210"
And I set fields
   | such   | RE210  |
   | ebeleg | RE210  |
   | vom    | .      |
   | fakt   | nein   |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Mengenerhoehung und Restmengenstorno in der Bestellung
Given I open an editor "BE210" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "BE210"
And I set field "mge" to "15" in row 1
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I save the current editor

Then field "limge" from editor "BE210" in row 1 has value "0"
Then field "remge" from editor "BE210" in row 1 has value "0"

# Wertgutschrift
Given I open an editor "WG210" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE210"
And I set fields
   | such   | WG210   |
   | ebeleg | RE210  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-10" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Ruecklieferscheinposition ohne Rechnungsrelevanz
#----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE220" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1BE220 |
	| lief   | 1      |
And I append rows
	| artikel | mge |
	| A100    | 10  |
And I save the current editor

# Lieferschein aus Bestellung erzeugen
Given I open an editor "1LS220" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE220"
And I set fields
	| nummer | 1LS220 |
	| vom    | .      |
	| ueb    | ja     |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung aus Lieferschein erzeugen
Given I open an editor "1RE220" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS220"
And I set fields
	| nummer | 1RE220 |
	| vom    | .      |
	| ueb    | ja     |
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung komplett gutschreiben
Given I open an editor "1WG220" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE220"
And I set fields
	| nummer | 1WG220 |
	| vom    | .      |
	| ueb    | ja     |
And I set field "mge" to "-10" in row 1
And I save the current editor

# Ruecklieferschein aus Lieferschein erzeugen, ohne Rechnungsrelevanz
Given I open an editor "1RLS220" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS220"
And I set fields
	| nummer | 1RLS220 |
	| vom    | .       |
	| ueb    | ja      |
And I set field "mge" to "-10" in row 1
And I set field "rerelev" to "nein" in row 1
And I save the current editor

Then "(Purchasing):(PackingSlip)" with the editor id "1LS220" is filed
