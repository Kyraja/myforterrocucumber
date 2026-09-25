# *****************************************************************************
#  Name           : offene_mengen_vk.feature
#  Verantwortlich : teampss
#  Funktion       : VK-Tests zur Berechnung der offenen Mengen in
#                   Lieferscheinen, Rechnungen, Ruecklieferscheinen und
#                   kaufm. Gutschriften.
#                   Es werden die Stammdaten aus offene_mengen_ek.feature benutzt.
#
# *****************************************************************************
#
@persistent
Feature: Aktualisierung remge VK
Background:
Given I set the fake date to "02.01.1995"

#----------------------------------------------------------------------------------------------
# TSQ-OFMGE-02: VK - Aktualisierung der offenen Mengen bei Ruecklieferungen
#----------------------------------------------------------------------------------------------

Scenario: Remge bei buchen RLS

Given I open an editor "AU015" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU015  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

Given I open an editor "LS015" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU015"
And I set fields
   | such   | LS015  |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "LS016" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | LS016  |
   | ueb    | ja     |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

Given I open an editor "RLS015" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS015"
And I set fields
   | such | RLS015 |
And I set field "he" to "kg" in row 1
And I set field "mge" to "-10" in row 1
And I save the current editor

Given I open an editor "RLS016" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS016"
And I set fields
   | such | RLS016 |
And I set field "he" to "kg" in row 1
And I set field "mge" to "-10" in row 1
And I save the current editor

Given I open an editor "RLS015" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "RLS015"
And I set field "beleg" to id from editor "LS016"
And I set field "he" to "kg" in row 3
And I set field "mge" to "-10" in row 3
And I save the current editor

Given I open an editor "RLS016" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "RLS016"
And I set field "beleg" to id from editor "LS015"
And I set field "he" to "kg" in row 3
And I set field "mge" to "-10" in row 3
And I save the current editor

Given I open an editor "RLS015V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS015"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS016V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS016"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS015" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "RLS015"
Then setting field "mge" to "-11" in row 1 throws the exception "3917"
And I set field "mge" to "-6" in row 1
And I set field "mge" to "-4" in row 3
And I save the current editor

Given I open an editor "RLS016" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "RLS016"
Then setting field "mge" to "-17" in row 1 throws the exception "3917"
And I set field "mge" to "-4" in row 1
And I set field "mge" to "-6" in row 3
And I save the current editor

Given I open an editor "RLS015V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS015"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS016V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS016"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS015" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "RLS015"
And I set field "ueb" to "ja"
And I set field "mge" to "-10" in row 1
And I set field "mge" to "-10" in row 3
And I save the current editor

Given I open an editor "RLS016" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "RLS016"
And I set field "mge" to "-10" in row 1
And I set field "mge" to "-10" in row 3
And I save the current editor

Given I open an editor "RLS015V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS015"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS016V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS016"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS015S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS015"
And I save the current editor

Given I open an editor "RLS015SV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS015S"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS015V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS015"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS016V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS016"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Remge bei buchen RLS, Beleg anfuegen, Loeschen von Zeilen

Given I open an editor "LS017" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | LS017  |
   | ueb    | ja     |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

Given I open an editor "RLS017" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS017"
And I set fields
   | such | RLS017 |
And I set field "he" to "kg" in row 1
And I set field "mge" to "-5" in row 1
And I save the current editor

Given I open an editor "RLS017B" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS017"
And I set fields
   | such | RLS017B |
And I set field "he" to "kg" in row 1
And I set field "mge" to "-2" in row 1
And I save the current editor

Given I open an editor "RLS017V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS017"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS017BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS017B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS017B" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "RLS017B"
And I delete all rows
And I set field "beleg" to id from editor "LS017"
And I set field "he" to "kg" in row 1
And I set field "mge" to "-2" in row 1
And I save the current editor

Given I open an editor "RLS017V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS017"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS017BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS017B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS017B" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "RLS017B"
And I delete all rows
And I set field "beleg" to id from editor "LS017"
And I set field "he" to "kg" in row 1
And I set field "mge" to "-2" in row 1
And I save the current editor

Given I open an editor "RLS017V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS017"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS017BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS017B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Remge bei buchen RLS, Beleg anfuegen, Loeschen von Zeilen, keine Menge eintragen

Given I open an editor "LS018" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | LS018  |
   | ueb    | ja     |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

Given I open an editor "RLS018" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS018"
And I set fields
   | such | RLS018 |
And I set field "he" to "kg" in row 1
And I set field "mge" to "-5" in row 1
And I save the current editor

Given I open an editor "RLS018B" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS018"
And I set fields
   | such | RLS018B |
And I set field "he" to "kg" in row 1
And I set field "mge" to "-2" in row 1
And I save the current editor

Given I open an editor "RLS018V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS018"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS018BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS018B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS018B" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "RLS018B"
And I delete all rows
And I set field "beleg" to id from editor "LS018"
And I delete all rows
And I set field "beleg" to id from editor "LS018"
And I save the current editor

Given I open an editor "RLS018V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS018"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS018BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS018B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

#----------------------------------------------------------------------------------------------
# TSQ-OFMGE-04: VK - Aktualisierung der offenen Mengen bei kaufm. Gutschriften
#----------------------------------------------------------------------------------------------

Scenario: Remge bei buchen KGS

# Auftrag
Given I open an editor "AU001" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde | 1      |
   | such  | AU001  |
And I append rows
   | artikel | mge | preis |
   | E2      |  10 |     5 |
   | E2      |  10 |     6 |
   | E2      |  10 |     7 |
And I save the current editor

# Lieferung
Given I open an editor "LS001" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU001"
And I set fields
   | such   | LS001  |
   | fakt   | ja     |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I save the current editor

# Rechnung
Given I open an editor "RE001" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS001"
And I set fields
   | such  | RE001  |
   | vom   | .      |
   | tterm | .      |
   | ueb   | ja     |
And I set field "mge" to "8" in row 1
And I set field "preis" to "10" in row 1
And I set field "mge" to "10" in row 2
And I set field "preis" to "11" in row 2
And I set field "mge" to "10" in row 3
And I set field "preis" to "12" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS001" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS001"
And I set fields
   | such   | RLS001  |
   | ueb    | true    |
   | vom    | .       |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I save the current editor

# Teilgutschrift 1
Given I open an editor "KGS001" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS001"
And I set fields
   | such   | KGS001  |
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
Given I open an editor "KGS001B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS001"
And I set fields
   | such   | KGS001B |
   | vom    | .       |
   | tterm  | .       |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefung Teilgutschrift 1
Given I open an editor "KGS001V" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Pruefung Teilgutschrift 2
Given I open an editor "KGS001BV" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS001B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Remge bei buchen KGS, unterschiedliche Einheiten

# Auftrag
Given I open an editor "AU002" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | such   | AU002  |
   | kunde  | 1      |
And I append rows
   | artikel | mge | preis | he    |
   | FB1     |  10 |     5 | Stück |
   | FB1     |  10 |     6 | Stück |
   | FB1     |  10 |     7 | Stück |
And I save the current editor

# Lieferung
Given I open an editor "LS002" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU002"
And I set fields
   | such   | LS002  |
   | fakt   | ja     |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I save the current editor

# Rechnung
Given I open an editor "RE002" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS002"
And I set fields
   | such   | RE002  |
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
Given I open an editor "RLS002" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS002"
And I set fields
   | such   | RLS002  |
   | ueb    | true    |
   | vom    | .       |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I save the current editor

# Teilgutschrift 1
Given I open an editor "KGS002" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS002"
And I set fields
   | such   | KGS002  |
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
Given I open an editor "KGS002B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS002"
And I set fields
   | such   | KGS002B |
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
Given I open an editor "KGS002V" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS002"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Pruefung Teilgutschrift 2
Given I open an editor "KGS002BV" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS002B"
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
#  AU003 -------> LS003 -----> RE003
# (10 zu 5)      (10 zu 5)    (8  zu 10)
# (10 zu 6)      (10 zu 6)    (10 zu 11)
# (10 zu 7)      (10 zu 7)    (12 zu 12)

Scenario: Remge bei buchen KGS, Teilruecklieferung

# Auftrag
Given I open an editor "AU003" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU003  |
And I append rows
   | artikel | mge | preis | he    |
   | FB1     |  10 |     5 | Stück |
   | FB1     |  10 |     6 | Stück |
   | FB1     |  10 |     7 | Stück |
And I save the current editor

# Lieferung
Given I open an editor "LS003" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU003"
And I set fields
   | such   | LS003  |
   | fakt   | ja     |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I save the current editor

# Rechnung
Given I open an editor "RE003" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS003"
And I set fields
   | such   | RE003  |
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
Given I open an editor "RLS003" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS003"
And I set fields
   | such   | RLS003  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-5" in row 1
And I set field "mge" to "-5" in row 2
And I set field "mge" to "-5" in row 3
And I save the current editor

# Teilgutschrift 1
Given I open an editor "KGS003" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS003"
And I set fields
   | such   | KGS003  |
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
Given I open an editor "KGS003B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS003"
And I set fields
   | such   | KGS003B |
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
Given I open an editor "KGS003" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS003"
And I set field "mge" to "-2" in row 1
And I set field "mge" to "-3" in row 2
And I set field "mge" to "-4" in row 3
And I save the current editor

# Teilgutschrift 2 aendern, buchen
Given I open an editor "KGS003B" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS003B"
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
Given I open an editor "KGS003" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS003"
And I delete all rows
And I set field "beleg" to "RLS003"
And I set field "he" to "kg" in row 1
And I set field "he" to "kg" in row 2
And I set field "he" to "kg" in row 3
And I set field "mge" to "-2" in row 3
Then setting field "mge" to "-3" in row 1 throws the exception "2022"
And I set field "mge" to "-7" in row 2
And I set field "mge" to "-8" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefung (offene Menge in nicht gebuchter GS = 0 )
Given I open an editor "KGS003V" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS003"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# In gebuchter KGS muss offene Menge aktualisiert werden
Given I open an editor "KGS003BV" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS003B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Remge bei buchen KGS, Loeschen von Zeilen

# Lieferung
Given I open an editor "LS004" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | LS004  |
   | vom    | .      |
   | ueb    | ja     |
And I append rows
   | artikel | mge | preis | he    |
   | FB1     |  10 |     5 | Stück |
And I save the current editor

# Rechnung
Given I open an editor "RE004" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS004"
And I set fields
   | such   | RE004  |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS004" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS004"
And I set fields
   | such   | RLS004  |
   | ueb    | true    |
   | vom    | .       |
And I set field "mge" to "-10" in row 1
And I save the current editor

# Teilgutschrift 1
Given I open an editor "KGS004" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS004"
And I set fields
   | such   | KGS004  |
   | vom    | .       |
   | tterm  | .       |
And I set field "he" to "kg" in row 1
And I set field "mge" to "-4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilgutschrift 2
Given I open an editor "KGS004B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS004"
And I set fields
   | such   | KGS004B |
   | vom    | .       |
   | tterm  | .       |
And I set field "he" to "kg" in row 1
And I set field "mge" to "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefung offene Menge Teilgutschrift 1
Given I open an editor "KGS004V" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS004"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Aenderung Teilgutschrift 2
Given I open an editor "KGS004B" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS004B"
And I delete all rows
And I set field "beleg" to "id" from editor "RLS004"
And I set field "he" to "kg" in row 1
And I set field "mge" to "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefung offene Menge Teilgutschrift 1
Given I open an editor "KGS004V" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS004"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Aenderung Teilgutschrift 2
Given I open an editor "KGS004B" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS004B"
And I delete all rows
And I set field "beleg" to "id" from editor "RLS004"
And I set field "he" to "kg" in row 1
And I set field "mge" to "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefung offene Menge Teilgutschrift 1
Given I open an editor "KGS004V" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS004"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor


#----------------------------------------------------------------------------------------------
# TSQ-OFMGE-06: VK - Aktualisierung der offenen Mengen bei Rechnungen
#----------------------------------------------------------------------------------------------

Scenario: Remge bei buchen RE

Given I open an editor "AU020" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU020  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

Given I open an editor "LS020" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | LS020  |
   | vom    | .      |
   | ueb    | ja     |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

Given I open an editor "RE020" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU020"
And I set fields
   | such   | RE020  |
   | vom    | .      |
   | tterm  | .      |
   | fakt   | nein   |
And I set field "he" to "kg" in row 1
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE021" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS020"
And I set fields
   | such   | RE021  |
   | vom    | .      |
   | tterm  | .      |
And I set field "he" to "kg" in row 1
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE020" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE020"
And I delete row at position !lastRow
And I delete row at position !lastRow
And I delete row at position !lastRow
And I set field "beleg" to id from editor "LS020"
And I set field "he" to "kg" in row 3
And I set field "mge" to "10" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE021" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE021"
And I delete row at position !lastRow
And I delete row at position !lastRow
And I delete row at position !lastRow
And I set field "beleg" to id from editor "AU020"
And I set field "he" to "kg" in row 3
And I set field "mge" to "10" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE020V" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE020"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE021V" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE021"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE020" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE020"
Then setting field "mge" to "11" in row 1 throws the exception "2810"
And I set field "mge" to "6" in row 1
And I set field "mge" to "4" in row 3
And I save the current editor

Given I open an editor "RE021" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE021"
Then setting field "mge" to "17" in row 1 throws the exception "2810"
And I set field "mge" to "4" in row 1
And I set field "mge" to "6" in row 3
And I save the current editor

Given I open an editor "RE020V" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE020"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE021V" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE021"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE020" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE020"
And I set field "ueb" to "ja"
And I set field "mge" to "10" in row 1
And I set field "mge" to "10" in row 3
And I save the current editor

Given I open an editor "RE021" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE021"
And I set field "mge" to "10" in row 1
And I set field "mge" to "10" in row 3
And I save the current editor

Given I open an editor "RE020V" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE020"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE021V" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE021"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE020S" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE020"
And I save the current editor

Given I open an editor "RE020S" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE020S"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE020V" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE020"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE021V" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE021"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Remge bei RE, Beleg anfuegen, Loeschen von Zeilen

Given I open an editor "LS022" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | LS022  |
   | ueb    | ja     |
   | vom    | .      |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

Given I open an editor "RE022" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS022"
And I set fields
   | such   | RE022  |
   | vom    | .      |
   | tterm  | .      |
And I set field "he" to "kg" in row 1
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE022B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS022"
And I set fields
   | such   | RE022B |
   | vom    | .      |
   | tterm  | .      |
And I set field "he" to "kg" in row 1
And I set field "mge" to "2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE022V" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE022"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE022BV" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE022B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE022B" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE022B"
And I delete all rows
And I set field "beleg" to id from editor "LS022"
And I set field "he" to "kg" in row 1
And I set field "mge" to "2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE022V" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE022"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE022BV" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE022B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE022B" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE022B"
And I delete all rows
And I set field "beleg" to id from editor "LS022"
And I set field "he" to "kg" in row 1
And I set field "mge" to "2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE022V" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE022"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE022BV" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE022B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Remge bei buchen RE, Beleg anfuegen, Loeschen von Zeilen, keine Mengen eintragen

Given I open an editor "LS023" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | LS023  |
   | vom    | .      |
   | ueb    | ja     |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

Given I open an editor "RE023" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS023"
And I set fields
   | such   | RE023  |
   | vom    | .      |
   | tterm  | .      |
And I set field "he" to "kg" in row 1
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE023B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS023"
And I set fields
   | such   | RE023B |
   | vom    | .      |
   | tterm  | .      |
And I set field "he" to "kg" in row 1
And I set field "mge" to "2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE023V" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE023"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE023BV" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE023B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE023B" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE023B"
And I delete all rows
And I set field "beleg" to id from editor "LS023"
And I delete all rows
And I set field "beleg" to id from editor "LS023"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE023V" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE023"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE023BV" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE023B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# ----------------------------------------------------------------------------- #
#                       Fakturierung ueber den Lieferschein                     #
#                       Aktualisierung remge ueberpruefen                       #
# ----------------------------------------------------------------------------- #

#  AU024  ---------- LS024 -------------- RE024
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

Given I open an editor "AU024" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU024  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Ersten Lieferschein aus Auftrag erzeugen
Given I open an editor "LS024" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU024"
And I set fields
   | such   | LS024  |
   | ueb    | true   |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
And I save the current editor

# Zweiten Lieferschein aus Auftrag erzeugen
Given I open an editor "LS024B" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU024"
And I set fields
   | such   | LS024B |
   | ueb    | true   |
Then the table has 1 rows
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnungen zu den Lieferscheinen ueber jeweils 5 Stueck
Given I open an editor "RE024" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS024"
And I set fields
   | such   | RE024   |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE024B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS024B"
And I set fields
   | such   | RE024B  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Lieferschein B
Given I open an editor "LS024BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS024B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
And I close the current editor

# Ruecklieferschein 1 zu LS 2
Given I open an editor "RLS024B" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS024B"
And I set fields
   | such   | RLS024B  |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-3" in row 1
And I save the current editor

# Ausgabe Lieferschein B
Given I open an editor "LS024BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS024B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
And I close the current editor

# Ruecklieferschein 2 zu LS 2
Given I open an editor "RLS024BB" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS024B"
And I set fields
   | such   | RLS024BB |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-4" in row 1
And I save the current editor

# Ausgabe Lieferschein B
Given I open an editor "LS024BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS024B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
And I close the current editor

# Ausgabe Ruecklieferschein 1 zu Lieferschein B
Given I open an editor "RLS024BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS024B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "-2" in row 1
And I close the current editor

# Ausgabe Ruecklieferschein 2 zu Lieferschein B
Given I open an editor "RLS024BBV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS024BB"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "-2" in row 1
And I close the current editor

# Teilgutschrift 1 zu RLS 1
Given I open an editor "KGS024" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS024B"
And I set fields
   | such   | KGS024  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Lieferschein A
Given I open an editor "LS024V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS024"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Ausgabe Lieferschein B
Given I open an editor "LS024BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS024B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
# Then field "remge" has value "0" in row 1
And I close the current editor

# Ausgabe Ruecklieferschein 1 zu Lieferschein B
Given I open an editor "RLS024BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS024B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Ausgabe Ruecklieferschein 2 zu Lieferschein B
Given I open an editor "RLS024BBV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS024BB"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# ----------------------------------------------------------------------------- #
#         Gleiches wie zuvor, nur mit unterschiedlichen Handelseinheiten        #
# ----------------------------------------------------------------------------- #

Scenario: Remge bei RE ueber LS, RLS und KGS buchen, unterschiedliche HE

Given I open an editor "AU025" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU025  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferschein A aus Auftrag erzeugen
Given I open an editor "LS025" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU025"
And I set fields
   | such   | LS025  |
   | ueb    | true   |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
And I save the current editor

# Lieferschein B aus Auftrag erzeugen
Given I open an editor "LS025B" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU025"
And I set fields
   | such   | LS025B |
   | ueb    | true   |
Then the table has 1 rows
# 1 Stueck enstpricht 2 kg
And I set field "he" to "kg" in row 1
And I set field "mge" to "20" in row 1
And I save the current editor

# Rechnungen zu den jeweiligen Lieferscheinen ueber jeweils 5 Stueck: einmal in Einheit "Stueck" und einmal in "kg"
Given I open an editor "RE025" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS025"
And I set fields
   | such   | RE025   |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "he" to "Stueck" in row 1
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE025B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS025B"
And I set fields
   | such   | RE025B  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "he" to "kg" in row 1
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein 1 zu LS B
Given I open an editor "RLS025B" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS025B"
And I set fields
   | such   | RLS025B  |
   | ueb    | true     |
   | vom    | .        |
# 1 Stueck enstpricht 2 kg
And I set field "he" to "kg" in row 1
And I set field "mge" to "-6" in row 1
And I save the current editor

# Ruecklieferschein 2 zu LS B (noch nicht buchen)
Given I open an editor "RLS025BB" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS025B"
And I set fields
   | such   | RLS025BB |
   | vom    | .        |
And I set field "he" to "Stueck" in row 1
And I set field "mge" to "-4" in row 1
And I save the current editor

#  Ruecklieferschein 2 zu LS B - aendern und jetzt buchen!
Given I open an editor "RLS025BB" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "RLS025BB"
And I set fields
   | ueb    | true     |
And I save the current editor

# Teilgutschrift 1 zu RLS 1
Given I open an editor "KGS025" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS025B"
And I set fields
   | such   | KGS025  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "he" to "Stueck" in row 1
And I set field "mge" to "-1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Lieferschein A
Given I open an editor "LS025V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS025"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Ausgabe Lieferschein B
Given I open an editor "LS025BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS025B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "10" in row 1
And I close the current editor

# Ausgabe Ruecklieferschein 1 zu Lieferschein B
Given I open an editor "RLS025BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS025B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "-2" in row 1
And I close the current editor

# Ausgabe Ruecklieferschein 2 zu Lieferschein B
Given I open an editor "RLS025BBV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS025BB"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "-1" in row 1
And I close the current editor


# 1. Auftrag anlegen -> Rechnung ohne LB (buchen) ->  Lieferschein 1 & 2 (buchen)-> Lieferschein 2 -> Ruecklieferschein 1 & 2
# -> Kaufm. Gutschrift aus LS 1

#    AU AU027 ----------  RE ohne LB RE027A
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

Scenario: Remge bei RE aus AU, Ueberbelieferung, Teil-RLS, KGS

Given I open an editor "AU027" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1     |
   | such   | AU027 |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Ersten Lieferschein aus Auftrag erzeugen
Given I open an editor "LS027A" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU027"
And I set fields
   | such   | LS027A  |
   | ueb    | true    |
   | fakt   | false   |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
And I save the current editor

Given I open an editor "Betriebsdaten" from table "(Company):(CompanyData)" with command "STORE" for record "1"
And I set field "emailvkre" to "EINVOICE"
And I save the current editor

Given I open an editor "RE027A" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | such   | RE027A  |
   | kunde  | 1       |
Then field "emailftext" is not empty
And I close the current editor

# Rechnungen zum Auftrag ueber 10 Stueck
Given I open an editor "RE027A" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU027"
And I set fields
   | such   | RE027A  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
Then field "emailftext" is not empty
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge im Auftrag
Given I open an editor "AU027V" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU027"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Lieferschein A
Given I open an editor "LS027AV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS027A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Zweiten Lieferschein aus Auftrag erzeugen
Given I open an editor "LS027B" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU027"
And I set fields
   | such   | LS027B  |
   | ueb    | true    |
Then the table has 1 rows
And I set field "mge" to "10" in row 1
And I save the current editor

# Pruefe remge im Auftrag
Given I open an editor "AU027V" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU027"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
And I close the current editor

# Pruefe remge im Lieferschein B
Given I open an editor "LS027B" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS027B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Ruecklieferschein 1 zu LS 2
Given I open an editor "RLS27B1" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS027B"
And I set fields
   | such   | RLS27B1  |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-3" in row 1
And I save the current editor

# Pruefe remge im Auftrag
Given I open an editor "AU027V" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU027"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
And I close the current editor

# Pruefe remge im Lieferschein B
Given I open an editor "13LS027BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS027B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Ruecklieferschein 1
Given I open an editor "1RLS027B1V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS27B1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Ruecklieferschein 2 zu LS 2
Given I open an editor "RLS27B2" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS027B"
And I set fields
   | such   | RLS27B2  |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-4" in row 1
And I save the current editor

# Pruefe remge im Auftrag
Given I open an editor "AU027V" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU027"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
And I close the current editor

# Pruefe remge im Lieferschein B
Given I open an editor "LS027BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS027B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Ruecklieferschein 1 zu Lieferschein B
Given I open an editor "RLS27B1V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS27B1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "-2" in row 1
And I close the current editor

# Pruefe remge im Ruecklieferschein 2 zu Lieferschein B
Given I open an editor "RLS27B1V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS27B1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "-2" in row 1
And I close the current editor

# Gutschrift 1 zu RLS 1
Given I open an editor "RE027G" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS27B1"
And I set fields
   | such   | RE027G  |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
And I set field "mge" to "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge im Auftrag
Given I open an editor "AU027V" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU027"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
And I close the current editor

# Pruefe remge im Lieferschein A
Given I open an editor "LS027AV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS027A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Lieferschein B
Given I open an editor "LS027BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS027B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Ruecklieferschein 1 zu Lieferschein B
Given I open an editor "RLS27B1V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS27B1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Ruecklieferschein 2 zu Lieferschein B
Given I open an editor "RLS27B2V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS27B2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# 1. Auftrag anlegen -> Rechnung ohne LB (buchen) ->  Lieferschein 1 & 2 (buchen)-> Lieferschein 2 -> Ruecklieferschein 1 & 2
# -> Kaufm. Gutschrift aus LS 1

#    AU AU028 ------------ RE ohne LB RE028A (Stueck)
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

Scenario: Remge bei RE aus AU, Ueberbelieferung, Teil-RLS, KGS, verschiedene Einheiten

Given I open an editor "AU028" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1     |
   | such   | AU028 |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Ersten Lieferschein A aus Auftrag erzeugen (Einheit Stueck)
Given I open an editor "LS028A" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU028"
And I set fields
   | such   | LS028A |
   | ueb    | true   |
   | fakt   | false  |
Then the table has 1 rows
And I set field "he" to "Stueck" in row 1
And I set field "mge" to "5" in row 1
And I save the current editor

# Rechnung zum Auftrag ueber 10 Stueck
Given I open an editor "RE028A" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU028"
And I set fields
   | such   | RE028A  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "he" to "Stueck" in row 1
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge im Auftrag
Given I open an editor "AU028V" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU028"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Zweiten Lieferschein B aus Auftrag erzeugen (Einheit kg)
Given I open an editor "LS028B" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU028"
And I set fields
   | such   | LS028B |
   | ueb    | true   |
Then the table has 1 rows
# 1 Stueck enstpricht 2 kg
And I set field "he" to "kg" in row 1
And I set field "mge" to "20" in row 1
And I save the current editor

# Pruefe remge im Auftrag
Given I open an editor "AU028V" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU028"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
And I close the current editor

# Pruefe remge im Lieferschein B
Given I open an editor "1LS028VB" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS028B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Ruecklieferschein 1 zu LS B
Given I open an editor "RLS028B1" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS028B"
And I set fields
   | such   | RLS028B1  |
   | ueb    | true     |
   | vom    | .        |
# Rueckliefern 6 kg
And I set field "mge" to "-6" in row 1
And I save the current editor

# Pruefe remge im Auftrag:
Given I open an editor "AU028V" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU028"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
And I close the current editor

# Pruefe remge im Lieferschein B
Given I open an editor "LS028BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS028B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Ruecklieferschein 2 zu LS B
Given I open an editor "RLS028B2" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS028B"
And I set fields
   | such   | RLS028B2 |
   | ueb    | true     |
   | vom    | .        |
# Rueckliefern 8 kg
And I set field "mge" to "-8" in row 1
And I save the current editor

# Pruefe remge im Auftrag
Given I open an editor "AU028V" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU028"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
And I close the current editor

# Pruefe remge im Lieferschein B
Given I open an editor "1LS028V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS028B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Ruecklieferschein 1 zu Lieferschein B
Given I open an editor "RLS028B1V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS028B1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
# remge in kg -4
Then field "remge" has value "-4" in row 1
And I close the current editor

# Pruefe remge im Ruecklieferschein 2 zu Lieferschein B
Given I open an editor "RLS028B2" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS028B2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
# remge in kg -4
Then field "remge" has value "-4" in row 1
And I close the current editor

# Teilgutschrift 1 zu RLS 1
Given I open an editor "RE028G" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS028B1"
And I set fields
   | such   | RE028G  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "-4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge im Auftrag
Given I open an editor "AU028V" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU028"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
And I close the current editor

# Pruefe remge im Lieferschein A
Given I open an editor "LS028AV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS028A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Lieferschein B
Given I open an editor "LS028BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS028B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Ruecklieferschein 1 zu Lieferschein B
Given I open an editor "RLS028B1V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS028B1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Ruecklieferschein 2 zu Lieferschein B
Given I open an editor "RLS028B2V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS028B2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

#
#    AU AU032
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

Given I create a SalesOrder "AU032" for Customer "1" with Product "V1" and quantity "10"

# Erste RE mit LB erzeugen
Given I open an editor "RE032A" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU032"
And I set fields
   | such   | RE032A  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# remge im Auftrag hat sich um 5 verringert
Then field "remge" from editor "AU032" in row 1 has value "5"

# Zweite RE mit LB erzeugen - Ueberlieferung
Given I open an editor "RE032B" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU032"
And I set fields
   | such   | RE032B  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
Then the table has 1 rows
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# remge im Auftrag hat sich um 5 verringert
Then field "remge" from editor "AU032" in row 1 has value "0"

# Ruecklieferschein zu RE aus LB
Given I open an editor "RLS032" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "RE032B"
And I set fields
   | such   | RLS032   |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-3" in row 1
And I save the current editor

Then field "remge" from editor "RLS032" in row 1 has value "-3"

# Zweiter Ruecklieferschein zu RE aus LB
Given I open an editor "RLS032B" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "RE032B"
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
Given I open an editor "KGS032" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS032"
And I set fields
   | such   | KGS032  |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
And I set field "mge" to "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ReMge in RLS gedeckelt
Then field "remge" from editor "RLS032" in row 1 has value "-1"
Then field "remge" from editor "RLS032B" in row 1 has value "-4"

# Gutschrift 2 zu RLS032B - 0*-Gutschrift
Given I open an editor "KGS032B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS032B"
And I set fields
   | such   | KGS032B |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
And I set field "mge" to "0" in row 1
# Wollen Sie diese Position wirklich stornieren?
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
#And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "RLS032" in row 1 has value "-1"
Then field "remge" from editor "RLS032B" in row 1 has value "0"

# ----------------------------------------------------------------------------- #
#                       Fakturierung ueber den Auftrag                          #
#                       Aktualisierung remge ueberpruefen                       #
# ----------------------------------------------------------------------------- #

# 1. Auftrag anlegen ->  Lieferschein 1 & 2 (buchen) -> Rechnung ohne LB (buchen)
# -> Ruecklieferschein zu Lieferschein 1 buchen -> Kaufm. Gutschrift aus LS 1

#    AU AU026 ----------------- RE RE026A ohne LB
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

Scenario: Remge bei RE aus AU

Given I open an editor "AU026" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU026  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Ersten Lieferschein A aus Auftrag erzeugen
Given I open an editor "LS026A" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU026"
And I set fields
   | such   | LS026A  |
   | ueb    | true    |
   | fakt   | false   |
   | vom    | .       |
Then the table has 1 rows
And I set field "mge" to "6" in row 1
And I save the current editor

# Zweiten Lieferschein B aus Auftrag erzeugen
Given I open an editor "LS026B" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU026"
And I set fields
   | such   | LS026B  |
   | ueb    | true    |
   | vom    | .       |
Then the table has 1 rows
And I set field "mge" to "4" in row 1
And I save the current editor

# Rechnung A zum Auftrag ueber 5 Stueck
Given I open an editor "RE026A" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU026"
And I set fields
   | such   | RE026A  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "6" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge im Auftrag
Given I open an editor "AU026V" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU026"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "4" in row 1
And I close the current editor

# Pruefe remge im Lieferschein A (0, da RE ueber AU)
Given I open an editor "LS026AV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS026A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Ruecklieferschein 1 zu LS 1
Given I open an editor "RLS26A1" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS026A"
And I set fields
   | such   | RLS26B1  |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Pruefe remge im Auftrag
Given I open an editor "AU026V" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU026"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "4" in row 1
And I close the current editor

# Pruefe remge im Lieferschein A
Given I open an editor "1LS026V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS026A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Ruecklieferschein 1 zu Lieferschein A
Given I open an editor "1RLS026A1V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS26A1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "-1" in row 1
And I close the current editor

# Gutschrift 1 zu RLS 1
Given I open an editor "RE026G" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS26A1"
And I set fields
   | such   | RE026G  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "-1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge im Auftrag
Given I open an editor "AU026V" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU026"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "4" in row 1
And I close the current editor

# Pruefe remge im Lieferschein A
Given I open an editor "LS026A" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS026A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Lieferschein B
Given I open an editor "LS026B" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS026B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge im Ruecklieferschein 1 zu Lieferschein B
Given I open an editor "1RLS026A1V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS26A1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
And I close the current editor


#    AU AU029 -------------> RE RE029 mit LB ---> RLS RLS029 -------> KGS KGS029
#    10 St.                  8 St. (1!)           -5 St. (2!)         -1 St. (3!)
#    | Aktion | remge  |     | Aktion | remge     | Aktion | remge
#    |        | 10 St. |     | (1)    | 0 St.     | (2)    | -5 St.
#    | (1)    |  2 St. |                          | (3)    | -4 St.
#
#

Scenario: Remge bei RE mit Lagerbew aus AU

# Auftrag
Given I create a SalesOrder "AU029" for Customer "1" with Product "V2" and quantity "10" and price "5"

# Rechnung mit LB
Given I open an editor "RE029" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU029"
And I set fields
   | such   | RE029  |
   | vom    | .      |
   | tterm  | .      |
   | fakt   | ja     |
   | ueb    | ja     |
And I set field "mge" to "8" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung der RE mit LB
Given I open an editor "RLS029" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "RE029"
And I set fields
   | such   | RLS029  |
   | ueb    | true    |
   | vom    | .       |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Pruefung Auftrag
Given I open an editor "AU029V" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU029"
Then field "remge" has value "2" in row 1
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Pruefung Rechnung
Given I open an editor "RE029V" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE029"
Then field "remge" has value "-3" in row 1
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Pruefung RLS
Given I open an editor "RLS029V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS029"
Then field "remge" has value "-5" in row 1
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Teilgutschrift
Given I open an editor "KGS029" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS029"
And I set fields
   | such   | KGS029  |
   | ueb    | ja      |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "-1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefung Auftrag (Keine Auswirkung)
Given I open an editor "AU029V" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU029"
Then field "remge" has value "2" in row 1
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Pruefung Rechnung
Given I open an editor "RE029V" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE029"
Then field "remge" has value "-3" in row 1
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Pruefung RLS
Given I open an editor "RLS029V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS029"
Then field "remge" has value "-4" in row 1
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor


# -----------------------------------------------------------------------------
#          Deckelung der offenen Rechnungsmenge im Ruecklieferschein
#             Die Positionsmenge darf nicht ueberschritten werden
# -----------------------------------------------------------------------------

#
#    AU033 --------------> RE033A mit LB
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

# Auftrag anlegen
Given I create a SalesOrder "AU033" for Customer "1" with Product "A100" and quantity "15"

# Rechnung mit LB
Given I open an editor "RE033A" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU033"
And I set fields
   | such   | RE033A |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "AU033" in row 1 has value "10"

# 2. Rechnung mit LB in kg
Given I open an editor "RE033" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU033"
And I set fields
   | such   | RE033  |
   | vom    | .      |
   | tterm  | .      |
   | fakt   | ja     |
   | ueb    | ja     |
And I set field "he" to "kg" in row 1
And I set field "mge" to "20" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "AU033" in row 1 has value "0"

# Teil-Ruecklieferung der RE mit LB (in Stück)
Given I open an editor "RLS033" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "RE033"
And I set fields
   | such   | RLS033  |
   | ueb    | true    |
   | vom    | .       |
And I set field "he" to "Stück" in row 1
And I set field "mge" to "-4" in row 1
And I save the current editor
Then field "remge" from editor "RLS033" in row 1 has value "-4"

# 2. Teil-Ruecklieferung der RE mit LB (in kg)
Given I open an editor "RLS033B" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "RE033"
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
Given I open an editor "KGS033" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS033"
And I set fields
   | such   | KGS033  |
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
Given I open an editor "KGS033B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS033B"
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


#
#  Einheiten: 1 kg (Handelseinheit) = 2 Stueck (Lagereinheit)
#
#   AU030  -------------- RE030 ohne LB
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

Given I open an editor "AU030" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1     |
   | such   | AU030 |
And I append rows
   | artikel | mge |
   | A110    | 10  |
And I save the current editor

# Rechnung aus Aufrag mit Menge 10 Stueck erzeugen, buchen, fakt = FALSE
Given I open an editor "RE030" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg | AU030 |
   | such  | RE030 |
   | ueb   | ja    |
   | fakt  | nein  |
   | tterm | .     |
Then field "emailftext" is not empty
Then the table has 1 rows
And I set field "mge" to "10" in row 1
And I set field "he" to "Stück" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein mit Menge 6 kg erzeugen und buchen
Given I open an editor "LS030-1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | beleg | AU030   |
   | such  | LS030-1 |
   | ueb   | ja      |
And I set field "mge" to "6" in row 1
And I save the current editor

# Lieferschein mit Menge 6 Stueck erzeugen und buchen
Given I open an editor "LS030-2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | beleg | AU030   |
   | such  | LS030-2 |
   | ueb   | ja      |
And I set field "mge" to "6" in row 1
And I set field "he" to "Stück" in row 1
And I save the current editor

# Ruecklieferschein zu Lieferschein 1 erzeugen und buchen
Given I open an editor "RLS030-1" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS030-1"
And I set fields
   | such  | RLS030-1 |
   | ueb   | ja       |
And I set field "mge" to "-6" in row 1
And I save the current editor

Given I open an editor "RLS030-1" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS030-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Ruecklieferschein zu Lieferschein 2 erzeugen und buchen
Given I open an editor "RLS030-2" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS030-2"
And I set fields
   | such  | RLS030-2 |
   | ueb   | ja       |
And I set field "mge" to "-6" in row 1
And I save the current editor
Then field "remge" has value "-6" in row 1

# Ausgabe der Vorgaenge im Endzustand
Given I open an editor "RLS030-1" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS030-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS030-2" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS030-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Teilgutschrift
Given I open an editor "KGS030" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS030-2"
And I set fields
   | such   | KGS030  |
   | ueb    | true    |
   | tterm  | .       |
And I set field "mge" to "-3" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
Then field "remge" from editor "RLS030-1" in row 1 has value "-2.5"

Given I open an editor "RLS030-1" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS030-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS030-2" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS030-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS030" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS030"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# -----------------------------------------------------------------------------
# Rechnung mit LB, Storno RE, remge im Auftrag pruefen
# 1 kg (Handelseinheit) = 2 Stueck (Lagereinheit)
# -----------------------------------------------------------------------------

Scenario: Auftrag ueber 10 Kilo, 2 Rechnungen mit LB mit unterschiedlichen Einheiten gebucht, Storno RE1

Given I open an editor "AU030B" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU030B |
And I append rows
   | artikel | mge |
   | A110    | 10  |
And I save the current editor

# limge im Auftrag ist 10, remge ist 10
Then field "limge" from editor "AU030B" in row 1 has value "10"
Then field "remge" from editor "AU030B" in row 1 has value "10"

# Rechnung 1 mit LB aus AU in KG
Given I open an editor "RE030B1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg | AU030B  |
   | such  | RE030B1 |
   | ueb   | ja      |
   | fakt  | ja      |
   | tterm | .       |
   | vom   | .       |
Then the table has 1 rows
And I set field "mge" to "3" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# limge im Auftrag ist 7, remge ist 7
Then field "limge" from editor "AU030B" in row 1 has value "7"
Then field "remge" from editor "AU030B" in row 1 has value "7"

# Rechnung 2 mit LB aus AU in Stueck
Given I open an editor "RE030B2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg | AU030B  |
   | such  | RE030B2 |
   | ueb   | ja      |
   | fakt  | ja      |
   | tterm | .       |
   | vom   | .       |
Then the table has 1 rows
And I set field "he" to "Stück" in row 1
And I set field "mge" to "10" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# limge im Auftrag ist 2, remge ist 2
Then field "limge" from editor "AU030B" in row 1 has value "2"
Then field "remge" from editor "AU030B" in row 1 has value "2"

Given I open an editor "SRE030B1" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE030B1"
And I save the current editor

# limge im Auftrag ist 5, remge ist 5
Then field "limge" from editor "AU030B" in row 1 has value "5"
Then field "remge" from editor "AU030B" in row 1 has value "5"

# -----------------------------------------------------------------------------
# Rechnung mit LB, Storno RE, remge im Auftrag pruefen
# -----------------------------------------------------------------------------

Scenario: Auftrag ueber 12 Stueck, 2 Rechnungen ueber 5 und 7 Stueck mit LB, Storno RE1

Given I open an editor "AU030C" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU030C |
And I append rows
   | artikel | mge |
   | A100    | 12  |
And I save the current editor

# limge im Auftrag ist 12, remge ist 12
Then field "limge" from editor "AU030C" in row 1 has value "12"
Then field "remge" from editor "AU030C" in row 1 has value "12"

# Rechnung 1 mit LB aus AU in Stueck
Given I open an editor "RE030C1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg | AU030C    |
   | such  | RE030C1   |
   | ueb   | ja        |
   | fakt  | ja        |
   | tterm | .         |
   | vom   | .         |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# limge im Auftrag ist 7, remge ist 7
Then field "limge" from editor "AU030C" in row 1 has value "7"
Then field "remge" from editor "AU030C" in row 1 has value "7"

# Rechnung 2 mit LB aus AU in Stueck
Given I open an editor "RE030C2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg | AU030C    |
   | such  | RE030C2   |
   | ueb   | ja        |
   | fakt  | ja        |
   | tterm | .         |
   | vom   | .         |
Then the table has 1 rows
And I set field "mge" to "7" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# limge im Auftrag ist 2, remge ist 2
Then field "limge" from editor "AU030C" in row 1 has value "0"
Then field "remge" from editor "AU030C" in row 1 has value "0"

Given I open an editor "SRE030C1" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE030C1"
And I save the current editor

# limge im Auftrag ist 5, remge ist 5
Then field "limge" from editor "AU030C" in row 1 has value "5"
Then field "remge" from editor "AU030C" in row 1 has value "5"


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
Given I open an editor "LS031" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | LS031  |
   | vom    | .      |
   | ueb    | ja     |
And I append rows
   | artikel | mge |
   | A100    |  10 |
And I save the current editor

# Rechnung
Given I open an editor "RE031" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS031"
And I set fields
   | such   | RE031  |
   | tterm  | .      |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung 1
Given I open an editor "RLS031-1" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS031"
And I set fields
   | such   | RLS031-1 |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-4" in row 1
And I save the current editor

# Teilgutschrift 1
Given I open an editor "KGS031" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS031-1"
And I set fields
   | such   | KGS031 |
   | tterm  | .      |
   | vom    | .      |
   | ueb    | true   |
And I set field "mge" to "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung 2
Given I open an editor "RLS031-2" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS031"
And I set fields
   | such   | RLS031-2 |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | true     |
And I set field "mge" to "-4" in row 1
And I save the current editor

Given I open an editor "RLS031-1" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS031-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS031-2" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS031-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor


# ----------------------------------------------------------------------------- #
#                             Teil-RLS, KGS, KGS 0*			                    #
# ----------------------------------------------------------------------------- #

#
#     AU034 ------------------  LS034 ----------------  RE034
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

Scenario: AU -> LS -> RE + RLS -> KGS 0*, AU -> LSB + REB, LSB -> RLSB

# Auftrag anlegen
Given I open an editor "AU034" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "such" to "AU034"
And I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

# Lieferschein mit Menge 6 erzeugen und buchen
Given I open an editor "LS034" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU034"
And I set field "such" to "LS034"
And I set field "ueb" to "ja"
And I set field "mge" to "6" in row 1
And I save the current editor

# Rechnung aus Lieferschein erzeugen
Given I open an editor "RE034" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS034"
And I set fields
   | such   | RE034   |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
Then the table has 1 rows
And I set field "mge" to "6" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein mit Menge -1 erzeugen und buchen
Given I open an editor "RLS034" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS034"
And I set fields
   | such   | RLS034   |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-1" in row 1
And I save the current editor

# KGS mit Menge 0 erzeugen, status setzen und buchen
Given I open an editor "KGS034" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS034"
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
Given I open an editor "RLS034" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS034"
Then field "ablagef" has value "ja"
Then field "remge" has value "0" in row 1
And I close the current editor

# Lieferschein aus Auftrag mit Restmenge erzeugen und fakt auf FALSE setzen
Given I open an editor "LS034B" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU034"
And I set fields
   | such   | LS034B  |
   | fakt   | nein    |
   | ueb    | true    |
And I set field "mge" to "4" in row 1
And I save the current editor

# Rechnung aus Auftrag mit Menge 3 erzeugen und buchen
Given I open an editor "RE034B" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU034"
And I set fields
   | such   | RE034B  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "3" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# remge im Auftrag hat sich um 3 verringert
Then field "remge" from editor "AU034" in row 1 has value "1"

# Ruecklieferschein aus Lieferschein erzeugen
Given I open an editor "RLS034B" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS034B"
And I set fields
   | such   | RLS034B  |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-4" in row 1
And I save the current editor
Then field "remge" has value "-3" in row 1

# In Auftrag und erster Ruecklieferung remge = 0
Then field "remge" from editor "AU034" in row 1 has value "1"
Then field "remge" from editor "RLS034" in row 1 has value "0"

#-----------------------------------------------------------------------------------------
# TSQ-OFMGE-08: VK - Aktualisierung der offenen Mengen im Storno Fall
#-----------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------- #
#                       Fakturierung ueber den Auftrag                          #
#                       Aktualisierung remge ueberpruefen                       #
# ----------------------------------------------------------------------------- #

# 1. Auftrag anlegen ->  Lieferschein (RE aus AU) A & B (buchen) -> Rechnung ohne LB (buchen)
# -> Ruecklieferschein zu Lieferschein 1 buchen
# -> Rechnung stornieren

#    AU035 ---------------------- RE035A ohne LB ---------- SRE035
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

Scenario: VK - Remge beim Storno der Rechnung, RE aus AU

Given I open an editor "AU035" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde | 1      |
   | such  | AU035  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferschein 35A aus Auftrag erzeugen
Given I open an editor "LS035A" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU035"
And I set fields
   | such   | LS035A |
   | ueb    | true   |
   | fakt   | false  |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "6" in row 1
And I save the current editor

# Lieferschein 35B aus Auftrag erzeugen
Given I open an editor "LS035B" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU035"
And I set fields
   | such   | LS035B |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "4" in row 1
And I save the current editor

# Rechnung A zum Auftrag ueber 6 Stueck
Given I open an editor "RE035A" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU035"
And I set fields
   | such   | RE035A |
   | ueb    | true   |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "6" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein A1 zu LS A
Given I open an editor "RLS035A1" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS035A"
And I set fields
   | such   | RLS035A |
   | ueb    | true    |
   | vom    | .       |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Rechnung A stornieren
Given I open an editor "SRE035" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE035A"
And I save the current editor

# Pruefe remge im Auftrag
Then field "remge" from editor "AU035" in row 1 has value "10"
# Pruefe remge im Ruecklieferschein
Then field "remge" from editor "RLS035A1" in row 1 has value "0"


#    AU036 -------------------- RE036 ohne LB
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

Scenario: VK - Remge beim Storno des LS, RE aus AU

Given I open an editor "AU036" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde | 1      |
   | such  | AU036  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferschein 36A aus Auftrag erzeugen
Given I open an editor "LS036A" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU036"
And I set fields
   | such   | LS036A |
   | ueb    | true   |
   | fakt   | false  |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "6" in row 1
And I save the current editor

# Lieferschein 36B aus Auftrag erzeugen
Given I open an editor "LS036B" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU036"
And I set fields
   | such   | LS036B |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "4" in row 1
And I save the current editor

# Rechnung 36A zum Auftrag ueber 7 Stueck
Given I open an editor "RE036A" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU036"
And I set fields
   | such   | RE036A |
   | ueb    | true   |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "7" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge in Auftrag
Then field "remge" from editor "AU036" in row 1 has value "3"

# Ruecklieferschein 36B zum LS 36B
Given I open an editor "RLS036B" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS036B"
And I set fields
   | such   | RLS036B |
   | ueb    | true    |
   | vom    | .       |
And I set field "mge" to "-2" in row 1
And I save the current editor

# Pruefe remge in Auftrag
Then field "remge" from editor "AU036" in row 1 has value "3"

# Lieferschein 36A stornieren
Given I open an editor "SLS036A" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "LS036A"
And I save the current editor

# Pruefe remge in Auftrag
Then field "remge" from editor "AU036" in row 1 has value "3"



#    AU037 ---------------------- RE037A ohne LB
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

Scenario: VK - Remge beim Storno des RLS, RE aus AU

Given I open an editor "AU037" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde | 1      |
   | such  | AU0367 |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferschein 37A aus Auftrag erzeugen
Given I open an editor "LS037A" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU037"
And I set fields
   | such   | LS037A |
   | ueb    | true   |
   | fakt   | false  |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "6" in row 1
And I save the current editor

# Lieferschein 37B aus Auftrag erzeugen
Given I open an editor "LS037B" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU037"
And I set fields
   | such   | LS037B |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "4" in row 1
And I save the current editor

# Rechnung 37A zum Auftrag ueber 7 Stueck
Given I open an editor "RE037A" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU037"
And I set fields
   | such   | RE037A |
   | ueb    | true   |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "6" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge in Auftrag
Then field "remge" from editor "AU037" in row 1 has value "4"

# Ruecklieferschein 37A zum LS 37A
Given I open an editor "RLS037A" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS037A"
And I set fields
   | such   | RLS037B |
   | ueb    | true    |
   | vom    | .       |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Pruefe remge in Auftrag
Then field "remge" from editor "AU037" in row 1 has value "4"

# Ruecklieferschein stornieren
Given I open an editor "SRLS037A" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS037A"
And I save the current editor

# Pruefe remge in Auftrag
Then field "remge" from editor "AU037" in row 1 has value "4"



#    AU038 ---------------------- RE038A ohne LB
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

Scenario: VK - Remge beim Storno der KGS, RE aus AU

Given I open an editor "AU038" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde | 1     |
   | such  | AU038 |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferschein 38A aus Auftrag erzeugen
Given I open an editor "LS038A" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU038"
And I set fields
   | such   | LS038A |
   | ueb    | true   |
   | fakt   | false  |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung 38A zum Auftrag ueber 7 Stueck
Given I open an editor "RE038A" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU038"
And I set fields
   | such   | RE038A |
   | ueb    | true   |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "7" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge in Auftrag
Then field "remge" from editor "AU038" in row 1 has value "3"

# Ruecklieferschein 38A zum LS 38A
Given I open an editor "RLS038A" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS038A"
And I set fields
   | such   | RLS038A |
   | ueb    | true    |
   | vom    | .       |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Pruefe remge in Auftrag
Then field "remge" from editor "AU038" in row 1 has value "3"

# Kaufm. Gutschrift zum Ruecklieferschein RLS038A
Given I open an editor "KGS038" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS038A"
And I set fields
   | such   | KGS038A |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
And I set field "mge" to "-1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge im Ruecklieferschein
Then field "remge" from editor "RLS038A" in row 1 has value "-1"

# Kaufm. Gutschrift stornieren
Given I open an editor "SKGS038" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "KGS038"
And I save the current editor

# Pruefe remge in Auftrag
Then field "remge" from editor "AU038" in row 1 has value "3"
# Pruefe remge im Ruecklieferschein
Then field "remge" from editor "RLS038A" in row 1 has value "-2"


# Auftrag anlegen ->  Lieferschein (RE aus AU) (buchen) -> Rechnung ohne LB (buchen)
# -> Ruecklieferschein zu Lieferschein buchen -> Gutschrift aus RLS
# -> Storno Gutschrift- > Storno Ruecklieferschein
# -> Storno Rechnung -> Storno Lieferschein

#    AU043 ----------------- RE043 ohne LB ----------- SRE043
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
#                                       | Aktion | remge  |    | Aktion | remge  |    | Aktion | remge  |
#                                       | (3)    | -1 St. |    |        |  0 St. |    |        |  0 St. |
#                                       | (4)    |  0 St. |
#                                       | (5)    | -1 St. |
#                                       | (6)    |  0 St. |
#                                           \
#                                            SRL043
#                                            +5 St. (6!)
#                                            | Aktion | remge  |
#                                            |        |  0 St. |

Scenario: VK - Remge beim Storno der kaufm. Gutschrift, Ruecklieferschein, Rechnung, Lieferschein RE aus AU

Given I open an editor "AU043" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU043  |
And I append rows
   | artikel | he    | mge |
   | A100    | kg    |   9 |
And I save the current editor

# Remge in Auftrag
Then field "remge" from editor "AU043" in row 1 has value "9"

# Lieferschein aus Auftrag erzeugen
Given I open an editor "LS043" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU043"
And I set fields
   | such   | LS043   |
   | ueb    | true    |
   | fakt   | false   |
   | vom    | .       |
Then the table has 1 rows
And I set field "mge" to "10" in row 1
And I save the current editor

# Remge in Auftrag
Then field "remge" from editor "AU043" in row 1 has value "10"

# Rechnung zum Auftrag ueber 6 Stueck
Given I open an editor "RE043" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU043"
And I set fields
   | such   | RE043   |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "6" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge in Auftrag
Given I open an editor "AU043V" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU043"
Then field "remge" has value "4" in row 1
And I close the current editor

# Pruefe remge in Lieferschein (0, da RE ueber AU)
Given I open an editor "LS043V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS043"
Then field "remge" has value "0" in row 1
And I close the current editor

# Ruecklieferschein zu Lieferschein
Given I open an editor "RLS043" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS043"
And I set fields
   | such   | RLS043   |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Pruefe remge in Auftrag
Given I open an editor "AU043V" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU043"
Then field "remge" has value "4" in row 1
And I close the current editor

# Pruefe remge in Lieferschein
Given I open an editor "1LS043V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS043"
Then field "remge" has value "0" in row 1
And I close the current editor

# Pruefe remge in Ruecklieferschein zu Lieferschein
Given I open an editor "1RLS043V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS043"
Then field "remge" has value "-1" in row 1
And I close the current editor

# Kaufm. Gutschrift zu Ruecklieferschein RLS043
Given I open an editor "KGS043" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS043"
And I set fields
   | such   | KGS043  |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
And I set field "mge" to "-1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge in Auftrag
Then field "remge" from editor "AU043" in row 1 has value "4"
# Pruefe remge in Ruecklieferschein
Then field "remge" from editor "RLS043" in row 1 has value "0"

# kaufm. Gutschrift stornieren
Given I open an editor "SKG043" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "KGS043"
And I save the current editor

# Prufe Remge in Auftrag
Then field "remge" from editor "AU043" in row 1 has value "4"
# Pruefe remge in Ruecklieferschein
Then field "remge" from editor "RLS043" in row 1 has value "-1"

# Ruecklieferschein stornieren
Given I open an editor "SRL043" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS043"
And I save the current editor

# Pruefe remge in Auftrag
Given I open an editor "AU043V" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU043"
Then field "remge" has value "4" in row 1
And I close the current editor

# Pruefe remge in Lieferschein
Then field "remge" from editor "LS043" in row 1 has value "0"
# Pruefe remge in Ruecklieferschein
Then field "remge" from editor "RLS043" in row 1 has value "0"

# Rechnung stornieren
Given I open an editor "SRE043" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE043"
And I save the current editor

# Pruefe remge in Auftrag
Then field "remge" from editor "AU043" in row 1 has value "10"
# Pruefe remge in Lieferschein
Then field "remge" from editor "LS043" in row 1 has value "0"

# Lieferschein stornieren
Given I open an editor "SRL043" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "LS043"
And I save the current editor

# Pruefe remge in Auftrag
Given I open an editor "AU043V" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU043"
Then field "remge" has value "9" in row 1
And I close the current editor

# Pruefe remge in stornierten, abgelegten Lieferschein
Then field "remge" from editor "LS043" in row 1 has value "0"

# Pruefe remge im stornierten, abgelegten Ruecklieferschein
Then field "remge" from editor "RLS043" in row 1 has value "0"


# ----------------------------------------------------------------------------- #
#                       Fakturierung ueber den Lieferschein                     #
#                       Aktualisierung remge ueberpruefen                       #
# ----------------------------------------------------------------------------- #


#  AU039  ------------- LS039 --------------- RE039 ----------------- SRE039
#  10 St.               5 St. (1!)            5 St. (2!)              -5 St. (3!)
#  | Aktion | remge  |  | Aktion | remge |    | Aktion | remge |      | Aktion | remge |
#  |        | 10 St. |  |        | 5 St. |    |        | 5 St. |      |        | 5 St. |
#  | (1)    |  5 St. |  | (2)    | 0 St. |    | (2)    | 0 St. |      | (3)    | 0 St. |
#  | (3)    |  5 St. |  | (3)    | 5 St. |    | (3)    | 0 St. |

Scenario: Remge bei RE ueber LS buchen, RE stornieren

Given I open an editor "AU039" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 1      |
   | such    | AU039  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferschein aus Auftrag erzeugen
Given I open an editor "LS039" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU039"
And I set fields
   | such   | LS039 |
   | ueb    | true  |
   | vom    | .     |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
And I save the current editor

# Pruefe remge in Auftrag
Then field "remge" from editor "AU039" in row 1 has value "5"

# Rechnungen zum Lieferschein ueber 5 Stueck
Given I open an editor "RE039" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS039"
And I set fields
   | such   | RE039  |
   | ueb    | true   |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge im Lieferschein
Then field "remge" from editor "LS039" in row 1 has value "0"

# Rechnung stornieren
Given I open an editor "SRE039" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE039"
And I save the current editor

# Pruefe remge in Auftrag
Then field "remge" from editor "AU039" in row 1 has value "5"
# Pruefe remge Lieferschein
Then field "remge" from editor "LS039" in row 1 has value "5"


# Auftrag -> LS A & B (buchen) -> RE A & B (buchen) -> RLS A & B aus LS B -> KGS zu RLS A ->
# a. Storno KGS
# b. Storno RE B


#  AU040  ------------ LS040A ------------ RE040A
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

Given I open an editor "AU040" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 1      |
   | such    | AU040  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
Then field "remge" has value "10" in row 1
And I save the current editor

# Lieferschein A aus Auftrag erzeugen
Given I open an editor "LS040A" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU040"
And I set fields
   | such   | LS040A |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
Then field "remge" has value "0" in row 1
And I save the current editor

# Pruefe remge im Lieferschein A
Then field "remge" from editor "LS040A" in row 1 has value "5"

# Lieferschein B aus Auftrag erzeugen
Given I open an editor "LS040B" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU040"
And I set fields
   | such   | LS040B |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "10" in row 1
Then field "remge" has value "0" in row 1
And I save the current editor

# Pruefe remge im Lieferschein B
Then field "remge" from editor "LS040B" in row 1 has value "10"
# Pruefe remge in Auftrag
Then field "remge" from editor "AU040" in row 1 has value "0"

# Rechnungen zum Lieferschein A ueber 4 Stueck
Given I open an editor "RE040A" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS040A"
And I set fields
   | such   | RE040A |
   | ueb    | true   |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge in Lieferschein A
Then field "remge" from editor "LS040A" in row 1 has value "1"

# Rechnungen zum Lieferschein B ueber 5 Stueck
Given I open an editor "RE040B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS040B"
And I set fields
   | such   | RE040B |
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
Given I open an editor "RLS040A" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS040B"
And I set fields
   | such   | RLS040A |
   | ueb    | true    |
   | vom    | .       |
And I set field "mge" to "-3" in row 1
And I save the current editor

# Pruefe remge im Lieferschein B
Then field "remge" from editor "LS040B" in row 1 has value "5"
# Pruefe remge im Ruecklieferschein B
Then field "remge" from editor "RLS040A" in row 1 has value "0"

# Ruecklieferschein 2 zu LS B
Given I open an editor "RLS040B" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS040B"
And I set fields
   | such   | RLS040B |
   | ueb    | true    |
   | vom    | .       |
And I set field "mge" to "-4" in row 1
And I save the current editor

# Pruefe remge inmieferschein B
Then field "remge" from editor "LS040B" in row 1 has value "5"
# Pruefe remge im Ruecklieferschein B
Then field "remge" from editor "RLS040B" in row 1 has value "-2"

# Teilgutschrift zum RLS 1
Given I open an editor "KGS040" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS040B"
And I set fields
   | such   | KGS040  |
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
Given I open an editor "SKGS040" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "KGS040"
Then field "remge" has value "0" in row 1
And I save the current editor

# Pruefe remge in der Teilgutschrift
Then field "remge" from editor "SKGS040" in row 1 has value "0"
# Pruefe remge im Ruecklieferschein A
Then field "remge" from editor "RLS040A" in row 1 has value "-2"
# Pruefe remge im Ruecklieferschein B
Then field "remge" from editor "RLS040B" in row 1 has value "-2"

# Rechnung stornieren (8!)
Given I open an editor "SRE040" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE040B"
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
#  AU041  ------------ LS041A -------------- RE041A
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

Given I open an editor "AU041" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 1      |
   | such    | AU041  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
Then field "remge" has value "10" in row 1
And I save the current editor

# Lieferschein A aus Auftrag erzeugen
Given I open an editor "LS041A" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU041"
And I set fields
   | such   | LS041A |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
Then field "remge" has value "0" in row 1
And I save the current editor

# Lieferschein B aus Auftrag erzeugen
Given I open an editor "LS041B" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU041"
And I set fields
   | such   | LS041B |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "6" in row 1
Then field "remge" has value "0" in row 1
And I save the current editor

# Rechnungen zum Lieferschein A ueber 5 Stueck
Given I open an editor "RE041A" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS041A"
And I set fields
   | such   | RE041A |
   | ueb    | true   |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnungen zum Lieferschein B ueber 5 Stueck
Given I open an editor "RE041B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS041B"
And I set fields
   | such   | RE041B |
   | ueb    | true   |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "5" in row 1
Then field "remge" has value "6" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein B stornieren nicht erlaubt
# "Zuerst muessen die Rechnungen storniert werden."
And opening an editor from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "LS041B" throws the exception "9312"

# Rechnung stornieren
Given I open an editor "SRE041B" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE041B"
And I save the current editor

# Lieferschein B stornieren
Given I open an editor "SLS041B" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "LS041B"
And I save the current editor

# Pruefe remge in Auftrag
Then field "remge" from editor "AU041" in row 1 has value "5"
# Pruefe remge im Lieferschein 41A
Then field "remge" from editor "LS041A" in row 1 has value "0"

# Storno des RLS: remge im LS muss erhoeht werden
#
#  AU042  ------------ LS042 --------------- RE042
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

Given I open an editor "AU042" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 1      |
   | such    | AU042  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
Then field "remge" has value "10" in row 1
And I save the current editor

# Lieferschein A aus Auftrag erzeugen
Given I open an editor "LS042A" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU042"
And I set fields
   | such   | LS042A |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
Then field "remge" has value "0" in row 1
And I save the current editor

# Lieferschein B aus Auftrag erzeugen
Given I open an editor "LS042B" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU042"
And I set fields
   | such   | LS042B |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "10" in row 1
Then field "remge" has value "0" in row 1
And I save the current editor

# Rechnungen zum Lieferschein A ueber 5 Stueck
Given I open an editor "RE042A" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS042A"
And I set fields
   | such   | RE042A |
   | ueb    | true   |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnungen zum Lieferschein B ueber 5 Stueck
Given I open an editor "RE042B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS042B"
And I set fields
   | such   | RE042B |
   | ueb    | true   |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge im Lieferschein B
Then field "remge" from editor "LS042B" in row 1 has value "5"

# Ruecklieferschein zu LS B
Given I open an editor "RLS042A" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS042B"
And I set fields
   | such   | RLS042A |
   | ueb    | true    |
   | vom    | .       |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Pruefe remge im Lieferschein B
Then field "remge" from editor "LS042B" in row 1 has value "5"
# Pruefe remge im Ruecklieferschein B
Then field "remge" from editor "RLS042A" in row 1 has value "0"

# Ruecklieferschein zu LS B
Given I open an editor "RLS042B" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS042B"
And I set fields
   | such   | RLS042B |
   | ueb    | true    |
   | vom    | .       |
And I set field "mge" to "-2" in row 1
And I save the current editor

# Ruecklieferschein stornieren
Given I open an editor "SRLS042A" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS042A"
And I save the current editor

# Pruefe remge im Lieferschein B
Then field "remge" from editor "LS042B" in row 1 has value "5"

#----------------------------------------------------------------------------------------------
# TSQ-REFRG-10: VK - Aktualisierung der freigegebenen Mengen bei ungebuchten Vorgaengen
#----------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------- #
#                       Fakturierung ueber den Lieferschein                     #
#                       Aktualisierung remge und refrg ueberpruefen             #
# ----------------------------------------------------------------------------- #

#  AU044  ------------------------- LS044 ------------------------ LS044 buchen ----------- RE044
#   10 St.                          5 St. (1!)                     5 St. (2!)               5 St. (4!)
#    | Aktion | remge  |  refrg |   | Aktion | remge  | refrg |
#    |        | 10 St. |  0 St. |   |        | 0 St.  | 5 St. |
#    | (1)    | 10 St. |  5 St. |   | (2)    | 5 St.  | 0 St. |
#    | (2)    |  5 St. |  0 St. |   | (4)    | 0 St.  | 0 St. |
#    | (3)    |  0 St. |  0 St. |
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

Given I open an editor "AU044" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU044  |
And I append rows
   | artikel | he     | mge |
   | A100    | Stueck | 10  |
And I save the current editor

# Ersten Lieferschein aus Auftrag erzeugen
Given I open an editor "LS044" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU044"
And I set fields
   | such   | LS044  |
   | vom    | .      |
   | ueb    | false  |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU044" in row 1 has value "10"
Then field "refrg" from editor "AU044" in row 1 has value "5"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS044" in row 1 has value "0"
Then field "refrg" from editor "LS044" in row 1 has value "5"

# Ersten Lieferschein buchen
Given I open an editor "LS044" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS044"
And I set fields
   | ueb    | true  |
   | vom    | .     |
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU044" in row 1 has value "5"
Then field "refrg" from editor "AU044" in row 1 has value "0"

# Ausgabe Lieferschein
Given I open an editor "LS044V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS044"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Zweiten Lieferschein aus Auftrag erzeugen
Given I open an editor "LS044B" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU044"
And I set fields
   | such   | LS044B |
   | vom    | .      |
   | ueb    | true   |
Then the table has 1 rows
And I set field "mge" to "10" in row 1
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU044" in row 1 has value "0"
Then field "refrg" from editor "AU044" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS044B" in row 1 has value "10"
Then field "refrg" from editor "LS044B" in row 1 has value "0"

# Rechnungen zu den Lieferscheinen ueber jeweils 5 Stueck
Given I open an editor "RE044" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS044"
And I set fields
   | such   | RE044   |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU044" in row 1 has value "0"
Then field "refrg" from editor "AU044" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS044" in row 1 has value "0"
Then field "refrg" from editor "LS044" in row 1 has value "0"

Given I open an editor "RE044B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS044B"
And I set fields
   | such   | RE044B  |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU044" in row 1 has value "0"
Then field "refrg" from editor "AU044" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS044B" in row 1 has value "10"
Then field "refrg" from editor "LS044B" in row 1 has value "5"

# Zweite Rechnung buchen
Given I open an editor "RE044" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE044B"
And I set fields
   | ueb    | true  |
   | vom    | .     |
And I save the current editor

# Ausgabe Lieferschein B
Given I open an editor "LS044BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS044B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Ruecklieferschein 1 zu LS 2
Given I open an editor "RLS044B" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS044B"
And I set fields
   | such   | RLS044B  |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-3" in row 1
And I save the current editor

# Ausgabe Lieferschein B
Given I open an editor "LS044BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS044B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Pruefe remge und refrg im Ruecklieferschein
Then field "remge" from editor "RLS044B" in row 1 has value "0"
Then field "refrg" from editor "RLS044B" in row 1 has value "0"

# Ruecklieferschein 2 zu LS 2
Given I open an editor "RLS044BB" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS044B"
And I set fields
   | such   | RLS044BB |
   | ueb    | false    |
   | vom    | .        |
And I set field "mge" to "-4" in row 1
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU044" in row 1 has value "0"
Then field "refrg" from editor "AU044" in row 1 has value "0"
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
Given I open an editor "RLS044BB" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "RLS044BB"
And I set fields
   | ueb    | true     |
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU044" in row 1 has value "0"
Then field "refrg" from editor "AU044" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS044" in row 1 has value "0"
Then field "refrg" from editor "LS044" in row 1 has value "0"

# Ausgabe Lieferschein B
Given I open an editor "LS044BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS044B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Ausgabe Ruecklieferschein 1 zu Lieferschein B
Given I open an editor "RLS044BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS044B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "-2" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Ausgabe Ruecklieferschein 2 zu Lieferschein B
Given I open an editor "RLS044BBV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS044BB"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "-2" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Teilgutschrift 1 zu RLS 1
Given I open an editor "KGS044" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS044B"
And I set fields
   | such   | KGS044  |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU044" in row 1 has value "0"
Then field "refrg" from editor "AU044" in row 1 has value "0"
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
Given I open an editor "KGS044P" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS044"
And I set fields
   | ueb    | true    |
And I save the current editor

# Ausgabe Lieferschein A
Given I open an editor "LS044V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS044"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Ausgabe Lieferschein B
Given I open an editor "LS044BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS044B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Ausgabe Ruecklieferschein 1 zu Lieferschein B
Given I open an editor "RLS044BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS044B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Ausgabe Ruecklieferschein 2 zu Lieferschein B
Given I open an editor "RLS044BBV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS044BB"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor


# ----------------------------------------------------------------------------- #
#         Gleiches wie zuvor, nur mit unterschiedlichen Handelseinheiten        #
# ----------------------------------------------------------------------------- #

Scenario: remge und refrg bei RE ueber LS, RLS und KGS erst ungebucht, dann buchen, unterschiedliche HE

Given I open an editor "AU045" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU045  |
And I append rows
   | artikel | he     | mge |
   | A100    | Stueck | 10  |
And I save the current editor

# Lieferschein A aus Auftrag erzeugen
Given I open an editor "LS045" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU045"
And I set fields
   | such   | LS045  |
   | vom    | .      |
   | ueb    | false  |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU045" in row 1 has value "10"
Then field "refrg" from editor "AU045" in row 1 has value "5"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS045" in row 1 has value "0"
Then field "refrg" from editor "LS045" in row 1 has value "5"

# Ersten Lieferschein buchen
Given I open an editor "LS045" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS045"
And I set fields
   | ueb    | true  |
   | vom    | .     |
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU045" in row 1 has value "5"
Then field "refrg" from editor "AU045" in row 1 has value "0"

# Ausgabe Lieferschein
Given I open an editor "LS045V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS045"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "5" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Lieferschein B aus Auftrag erzeugen
Given I open an editor "LS045B" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU045"
And I set fields
   | such   | LS045B |
   | vom    | .      |
   | ueb    | true   |
Then the table has 1 rows
# 1 Stueck enstpricht 2 kg
And I set field "he" to "kg" in row 1
And I set field "mge" to "20" in row 1
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU045" in row 1 has value "0"
Then field "refrg" from editor "AU045" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS045B" in row 1 has value "20"
Then field "refrg" from editor "LS045B" in row 1 has value "0"

# Rechnungen zu den jeweiligen Lieferscheinen ueber jeweils 5 Stueck: einmal in Einheit "Stueck" und einmal in "kg"
Given I open an editor "RE045" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS045"
And I set fields
   | such   | RE045   |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "he" to "Stueck" in row 1
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU045" in row 1 has value "0"
Then field "refrg" from editor "AU045" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS045" in row 1 has value "0"
Then field "refrg" from editor "LS045" in row 1 has value "0"

Given I open an editor "RE045B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS045B"
And I set fields
   | such   | RE045B  |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "he" to "kg" in row 1
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU045" in row 1 has value "0"
Then field "refrg" from editor "AU045" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS045B" in row 1 has value "20"
Then field "refrg" from editor "LS045B" in row 1 has value "10"

Given I open an editor "RE045B" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE045B"
And I set fields
   | ueb    | true    |
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU045" in row 1 has value "0"
Then field "refrg" from editor "AU045" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS045B" in row 1 has value "10"
Then field "refrg" from editor "LS045B" in row 1 has value "0"

# Ruecklieferschein 1 zu LS B
Given I open an editor "RLS045B" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS045B"
And I set fields
   | such   | RLS045B  |
   | ueb    | true     |
   | vom    | .        |
# 1 Stueck enstpricht 2 kg
And I set field "he" to "kg" in row 1
And I set field "mge" to "-6" in row 1
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU045" in row 1 has value "0"
Then field "refrg" from editor "AU045" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS045B" in row 1 has value "10"
Then field "refrg" from editor "LS045B" in row 1 has value "0"
# Pruefe remge und refrg im Ruecklieferschein
Then field "remge" from editor "RLS045B" in row 1 has value "0"
Then field "refrg" from editor "RLS045B" in row 1 has value "0"

# Ruecklieferschein 2 zu LS B (noch nicht buchen)
Given I open an editor "RLS045BB" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS045B"
And I set fields
   | such   | RLS045BB |
   | vom    | .        |
And I set field "he" to "Stueck" in row 1
And I set field "mge" to "-4" in row 1
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU045" in row 1 has value "0"
Then field "refrg" from editor "AU045" in row 1 has value "0"
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
Given I open an editor "RLS045BB" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "RLS045BB"
And I set fields
   | ueb    | true     |
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU045" in row 1 has value "0"
Then field "refrg" from editor "AU045" in row 1 has value "0"
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
Given I open an editor "KGS045" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS045B"
And I set fields
   | such   | KGS045  |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "he" to "Stueck" in row 1
And I set field "mge" to "-1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU045" in row 1 has value "0"
Then field "refrg" from editor "AU045" in row 1 has value "0"
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
Given I open an editor "KGS045P" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS045"
And I set fields
   | ueb    | true    |
And I save the current editor

# Ausgabe Lieferschein A
Given I open an editor "LS045V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS045"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "0" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Ausgabe Lieferschein B
Given I open an editor "LS045BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS045B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "10" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Ausgabe Ruecklieferschein 1 zu Lieferschein B
Given I open an editor "RLS045BV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS045B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "-2" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Ausgabe Ruecklieferschein 2 zu Lieferschein B
Given I open an editor "RLS045BBV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS045BB"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "-1" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

Scenario: RLS in Ablage bringen und wieder aus Ablage holen bei RLS buchen und KGS

#  Ist die remge = 0 gehen die RLS in die Ablage. Es kann sein,
#  dass durch weitere RLS beide RLS aus der Ablage kommen (wiederaufleben)
#  Durch mehrere RLS kann  auch der LS in die Ablage wandern, da keine Restmenge mehr zur Berechnung ansteht
#  Eine KGS kann den aktuellen und den parallelen RLS wieder in die Ablage bringen
#
#  AU046 ---> LS046 -------------- RE046
#  10 St.     10 St.               5 St. (2!)
#             | Aktion | remge  |
#             |        | 10 St. |
#             | (2)    |  5 St. |
#             | (3)    |  5 St. |
#             | (4)    |  5 St. |
#                        \
#                         \ ---------RLS046 ----------------> 046	 ------------> KGSS046
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

#Auftrag anlegen
Given I create a SalesOrder "AU046" for Customer "1" with Product "V1" and quantity "10"

Then field "remge" from editor "AU046" in row 1 has value "10"

Given I open an editor "LS046" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU046"
And I set fields
   | such   | LS046  |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

Then field "remge" from editor "AU046" in row 1 has value "0"
Then "(Sales):(SalesOrder)" with the editor id "AU046" is filed
Then field "remge" from editor "LS046" in row 1 has value "10"

Given I open an editor "RE046" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS046"
And I set fields
   | such   | RE046  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "LS046" in row 1 has value "5"

# Ruecklieferschein 1
Given I open an editor "RLS046" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS046"
And I set fields
   | such   | RLS046   |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-3" in row 1
And I set field "platz" to "F1" in row 1
And I save the current editor

Then field "remge" from editor "LS046" in row 1 has value "5"
Then "(Sales):(PackingSlip)" with the editor id "LS046" is not filed
Then field "remge" from editor "RLS046" in row 1 has value "0"
Then "(Sales):(PackingSlip)" with the editor id "RLS046" is filed

# Ruecklieferschein 2
Given I open an editor "RLS046B" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS046"
And I set fields
   | such   | RLS046B  |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-4" in row 1
And I set field "platz" to "F1" in row 1
And I save the current editor
Then field "remge" from editor "RLS046B" in row 1 has value "-2"
Then "(Sales):(PackingSlip)" with the editor id "RLS046B" is not filed
Then field "remge" from editor "RLS046" in row 1 has value "-2"
Then "(Sales):(PackingSlip)" with the editor id "RLS046" is not filed
Then field "remge" from editor "LS046" in row 1 has value "5"
Then "(Sales):(PackingSlip)" with the editor id "LS046" is not filed

# Teilgutschrift 1 zu RLS 1
Given I open an editor "KGS046" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS046"
And I set fields
   | such   | KGS046  |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "LS046" in row 1 has value "5"
Then "(Sales):(PackingSlip)" with the editor id "LS046" is not filed
Then field "remge" from editor "RLS046" in row 1 has value "0"
Then "(Sales):(PackingSlip)" with the editor id "RLS046" is filed
Then field "remge" from editor "RLS046B" in row 1 has value "0"
Then "(Sales):(PackingSlip)" with the editor id "RLS046B" is filed

# Stornieren des RLS 2 ist nicht moeglich, da es noch eine KGS im parallelen RLS gibt
Then opening an editor from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS046B" throws the exception "3335"

# KGS Stornieren
Given I open an editor "KGSS046" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "KGS046"
And I save the current editor

Then field "remge" from editor "RLS046" in row 1 has value "-2"
Then "(Sales):(PackingSlip)" with the editor id "RLS046" is not filed
Then field "remge" from editor "RLS046B" in row 1 has value "-2"
Then "(Sales):(PackingSlip)" with the editor id "RLS046B" is not filed

# Stornieren des RLS 2 geht nun
Given I open an editor "RLSS046B" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS046B"
And I save the current editor
Then field "remge" from editor "RLS046" in row 1 has value "0"
Then "(Sales):(PackingSlip)" with the editor id "RLS046" is filed
Then field "remge" from editor "RLS046B" in row 1 has value "0"
Then "(Sales):(PackingSlip)" with the editor id "RLS046B" is filed

# ----------------------------------------------------------------------------- #
#                       Fakturierung ueber den Lieferschein                     #
#                       Aktualisierung remge und refrg ueberpruefen             #
# ----------------------------------------------------------------------------- #

#  AU047 -------------------------- LS047 --------------------------------- RE047
#   10 St.                          7 St. (1!)                              5 St. (2!)
#    | Aktion | remge  |  refrg |   | Aktion | remge  | refrg |
#    |        | 10 St. |  0 St. |   |        | 7 St.  | 0 St. |
#    | (1)    |  3 St. |  0 St. |   | (2)    | 2 St.  | 0 St. |
#                                   | (3)    | 2 St.  | 2 St. |
#                                   | (4)    | 2 St.  | 2 St. |
#                                    \
#                                     \
#                                      \
#                                        -------- RE047B   ungebucht
#                                        \       2 St. (3!)
#                                         \      | Aktion | remge  | refrg  |
#                                          \     |        |  2 St. |  2 St. |
#                                           \    | (4)    |  2 St. |  2 St. |
#                                            \
#                                             \
#                                              ------------RLS047 -------------------------- KGS047 ungebucht  ------------ KGS047 aendern
#                                                          -4 St. (4!)                       -2 St. (5!)                     -1 St. (6!)
#                                                          | Aktion | remge  | refrg  |      | Aktion | remge  | refrg  |
#                                                          |        | -2 St. |  0 St. |      |        | -2 St. | -2 St. |
#                                                          | (5)    | -2 St. | -2 St. |      |  (6)   | -1 St. | -1 St. |
#                                                          | (6)    | -2 St. | -1 St. |
#                                                          | (7)    | -2 St. | -2 St. |
#                                                           \
#                                                            \
#                                                             \
#                                                               -------- KGS047B ungebucht
#                                                                        1 St. (7!)
#                                                                        | Aktion | remge  | refrg  |
#                                                                        |        | -1 St. | -1 St. |
#

Scenario: VK: Remge bei RE ueber LS, RLS und KGS buchen

Given I open an editor "AU047" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU047  |
And I append rows
   | artikel | he     | mge |
   | A100    | Stueck | 10  |
And I save the current editor

# Ersten Lieferschein aus Auftrag erzeugen, nocht nicht buchen
Given I open an editor "LS047" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU047"
And I set fields
   | such   | LS047  |
   | ueb    | true   |
Then the table has 1 rows
And I set field "mge" to "7" in row 1
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU047" in row 1 has value "3"
Then field "refrg" from editor "AU047" in row 1 has value "0"

# Ausgabe Lieferschein
Given I open an editor "LS047V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS047"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "7" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Rechnung zu den Lieferschein ueber 5 Stueck
Given I open an editor "RE047" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS047"
And I set fields
   | such   | RE047   |
   | ueb    | true    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU047" in row 1 has value "3"
Then field "refrg" from editor "AU047" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS047" in row 1 has value "2"
Then field "refrg" from editor "LS047" in row 1 has value "0"

# Rechnung 2 zu den Lieferschein ueber 2 Stueck ungebucht
Given I open an editor "RE047B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS047"
And I set fields
   | such   | RE047B  |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU047" in row 1 has value "3"
Then field "refrg" from editor "AU047" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS047" in row 1 has value "2"
Then field "refrg" from editor "LS047" in row 1 has value "2"
# Pruefe refrg in gebuchter Rechnung 1
Then field "refrg" from editor "RE047" in row 1 has value "0"
# Pruefe remge und refrg in ungebuchter Rechnung
Then field "remge" from editor "RE047B" in row 1 has value "2"
Then field "refrg" from editor "RE047B" in row 1 has value "2"

# Ruecklieferschein 1 zu LS 1
Given I open an editor "RLS047" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS047"
And I set fields
   | such   | RLS047   |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-4" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "LS047V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS047"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "2" in row 1
Then field "refrg" has value "2" in row 1
And I close the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU047" in row 1 has value "3"
Then field "refrg" from editor "AU047" in row 1 has value "0"
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
Given I open an editor "KGS047" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS047"
And I set fields
   | such   | KGS047  |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU047" in row 1 has value "3"
Then field "refrg" from editor "AU047" in row 1 has value "0"
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
Given I open an editor "KGS047" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS047"
And I set field "mge" to "-1" in row 1
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU047" in row 1 has value "3"
Then field "refrg" from editor "AU047" in row 1 has value "0"
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
Given I open an editor "KGS047B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS047"
And I set fields
   | such   | KGS047B |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "-1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU047" in row 1 has value "3"
Then field "refrg" from editor "AU047" in row 1 has value "0"
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
And opening an editor from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RE047" throws the exception "1582"


# -----------------------------------------------------------------------------
#         Ungebuchte Teilrechnungen ohne LB aus dem Auftrag
# -----------------------------------------------------------------------------

#  AU048 ---------------- RE048A ohne LB
#  12 St.                 5 St. (1!) (ungebucht)
#  | Aktion | remge  |    | Aktion | remge  |
#  |        | 12 St. |    |   (1)  | 12 St. |
#  |  (2)   | 12 St. |    |   (2)  | 12 St. |
#  |  (3)   | 12 St. |    |   (3)  | 12 St. |
#              \
#               \
#                \
#                  ---------------- LS048 ------------ RLS48 ---------- SRLS048
#                                   8 St.              -7 St (2!)       7 St. (3!)

Scenario: Teilrechnung aus AU nicht gebucht, LS aus AU, RLS buchen, Storno RLS

# Auftrag anlegen
Given I create a SalesOrder "AU048" for Customer "1" with Product "A100" and quantity "12"

Then field "remge" from editor "AU048" in row 1 has value "12"

# Rechnung ohne LB aus AU, ungebucht
Given I open an editor "RE048A" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg | AU048  |
   | such  | RE048A |
   | tterm | .      |
   | fakt  | false  |
   | vom   | .      |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Offene Rechnungsmenge im Auftrag und Rechnung pruefen
Then field "refrg" from editor "AU048" in row 1 has value "5"
Then field "remge" from editor "AU048" in row 1 has value "12"
Then field "remge" from editor "RE048A" in row 1 has value "12"

# Lieferschein aus Auftrag erzeugen
Given I open an editor "LS048" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU048"
And I set fields
   | such   | LS048 |
   | ueb    | true  |
   | vom    | .     |
Then the table has 1 rows
And I set field "mge" to "8" in row 1
And I save the current editor

# Ruecklieferschein 1 zu LS 1
Given I open an editor "RLS048" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS048"
And I set fields
   | such   | RLS048 |
   | ueb    | true   |
   | vom    | .      |
And I set field "mge" to "-7" in row 1
And I save the current editor

# Offene Rechnungsmenge im Auftrag und Rechnung pruefen
Then field "refrg" from editor "AU048" in row 1 has value "5"
Then field "remge" from editor "AU048" in row 1 has value "12"
Then field "remge" from editor "RE048A" in row 1 has value "12"

# Ruecklieferschein stornieren
Given I open an editor "SRLS048" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS048"
And I save the current editor

# Offene Rechnungsmenge im Auftrag und Rechnungen pruefen
Then field "refrg" from editor "AU048" in row 1 has value "5"
Then field "remge" from editor "AU048" in row 1 has value "12"
Then field "remge" from editor "RE048A" in row 1 has value "12"

# -----------------------------------------------------------------------------
# RLS: offene Rechnungsmenge in den ungebuchten RE reduzieren, falls groesser als die erlaubte remge, sonst lassen.
# RE: beim Buchen die remge in allen offenen Rechnungen anpassen, um die maximal noch ausstehende Rechnungsmenge.
# SRLS: offene Rechnungsmenge in den ungebuchten RE und dem AU erhoehen.
# -----------------------------------------------------------------------------
#
# AU049 ------------------------ RE049A ohne LB ------------------ RE049A buchen
# 12 St.                         7 St. (1!) (ungebucht)            1 St. (4!)
# | Aktion | remge  | refrg |    | Aktion | remge  |
# |        | 12 St. |       |    |   (1)  | 12 St. |
# |  (1)   | 12 St. |  7 St.|    |   (2)  |  7 St. |
# |  (2)   | 12 St. | 12 St.|    |   (3)  |  7 St. |
# |  (3)   | 12 St. | 12 St.|    |   (4)  |  0 St. |
# |  (4)   | 11 St. |  5 St.|
# |  (5)   | 11 St. |  5 St.|
#       \      \
#        \      \
#         \      \
#          \       ----------------- RE049B ohne LB
#           \                        5 St. (2!) (ungebucht)
#            \                       | Aktion | remge  |
#             \                      |    neu |  5 St. |
#              \                     |   (2)  |  5 St. |
#               \                    |   (3)  |  5 St. |
#                \                   |   (4)  | 11 St. |
#                 \                  |   (5)  | 11 St. |
#                  \
#                    ----------------- LS049 ------------ RLS049 ---------- SRLS049
#                                      8 St.              -6 St (3!)        6 St. (5!)

Scenario: Teilrechnungen aus AU nicht gebucht, LS aus AU, RLS buchen, RE 2 buchen, Storno RLS

# Auftrag anlegen
Given I create a SalesOrder "AU049" for Customer "1" with Product "A100" and quantity "12"

Then field "remge" from editor "AU049" in row 1 has value "12"

# 1. Teilrechnung RE049A ohne LB aus AU, ungebucht
Given I open an editor "RE049A" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg | AU049  |
   | such  | RE049A |
   | tterm | .      |
   | fakt  | false  |
   | vom   | .      |
Then the table has 1 rows
And I set field "mge" to "7" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# refrg und remge im Auftrag und Rechnung pruefen
Then field "refrg" from editor "AU049" in row 1 has value "7"
Then field "remge" from editor "AU049" in row 1 has value "12"
Then field "remge" from editor "RE049A" in row 1 has value "12"

# 2. Teilrechnung RE049B ohne LB aus AU, ungebucht
Given I open an editor "RE049B" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg | AU049  |
   | such  | RE049B |
   | tterm | .      |
   | vom   | .      |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Offene und vorgemerkte Rechnungsmenge im Auftrag und Rechnungen pruefen
Then field "refrg" from editor "AU049" in row 1 has value "12"
Then field "remge" from editor "AU049" in row 1 has value "12"
Then field "remge" from editor "RE049A" in row 1 has value "7"
Then field "remge" from editor "RE049B" in row 1 has value "5"

# Lieferschein aus Auftrag AU049 erzeugen
Given I open an editor "LS049" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU049"
And I set fields
   | such   | LS049 |
   | ueb    | true  |
   | vom    | .     |
Then the table has 1 rows
And I set field "mge" to "8" in row 1
And I save the current editor

# 3. Ruecklieferschein zu LS049
Given I open an editor "RLS049" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS049"
And I set fields
   | such   | RLS049 |
   | ueb    | true   |
   | vom    | .      |
And I set field "mge" to "-6" in row 1
And I save the current editor

# refrg und remge im Auftrag und Rechnungen pruefen
Then field "refrg" from editor "AU049" in row 1 has value "12"
Then field "refrg" from editor "RE049A" in row 1 has value "7"
Then field "refrg" from editor "RE049B" in row 1 has value "5"
Then field "remge" from editor "AU049" in row 1 has value "12"
Then field "remge" from editor "RE049A" in row 1 has value "7"
Then field "remge" from editor "RE049B" in row 1 has value "5"

# 4. Teilrechnung RE049A buchen
Given I open an editor "RE049A" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE049A"
And I set field "mge" to "1" in row 1
And I set field "ueb" to "ja"
And I save the current editor

# Offene und vorgemerkte Rechnungsmenge im Auftrag und Rechnungen pruefen
Then field "refrg" from editor "AU049" in row 1 has value "5"
Then field "remge" from editor "AU049" in row 1 has value "11"
Then field "remge" from editor "RE049B" in row 1 has value "11"

# 5. Ruecklieferschein RLS049 stornieren
Given I open an editor "SRLS049" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS049"
And I save the current editor

# Offene und vorgemerkte Rechnungsmenge im Auftrag und Rechnungen pruefen
Then field "refrg" from editor "AU049" in row 1 has value "5"
Then field "remge" from editor "AU049" in row 1 has value "11"
Then field "remge" from editor "RE049B" in row 1 has value "11"


# ----------------------------------------------------------------------------- #
#         Gleiches wie zuvor, nur mit unterschiedlichen Handelseinheiten        #
# ----------------------------------------------------------------------------- #

Scenario: Teilrechnungen aus AU nicht gebucht, LS aus AU, RLS buchen, RE 2 buchen, Storno RLS, unterschiedliche HE

# Auftrag anlegen
Given I open an editor "AU050" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU050  |
And I append rows
   | artikel | he     | mge |
   | A100    | Stueck | 12  |
And I save the current editor

Then field "remge" from editor "AU050" in row 1 has value "12"

# Teilrechnung 050A ohne LB aus AU, ungebucht
Given I open an editor "RE050A" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg | AU050  |
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

# refrg und remge im Auftrag und Rechnung pruefen
# in LE
Then field "refrg" from editor "AU050" in row 1 has value "7"
Then field "remge" from editor "AU050" in row 1 has value "12"
# in HE
Then field "remge" from editor "RE050A" in row 1 has value "24"

# 2. Teilrechnung 050B ohne LB aus AU, ungebucht
Given I open an editor "RE050B" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg | AU050  |
   | such  | RE050B |
   | tterm | .      |
   | vom   | .      |
Then the table has 1 rows
And I set field "mge" to "5" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# refrg und remge im Auftrag und Rechnungen pruefen
# in LE
Then field "refrg" from editor "AU050" in row 1 has value "12"
Then field "remge" from editor "AU050" in row 1 has value "12"
# in HE
Then field "remge" from editor "RE050A" in row 1 has value "14"
# in LE
Then field "remge" from editor "RE050B" in row 1 has value "5"

# Lieferschein aus Auftrag erzeugen
Given I open an editor "LS050" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU050"
And I set fields
   | such   | LS050 |
   | ueb    | true  |
   | vom    | .     |
Then the table has 1 rows
And I set field "he" to "kg" in row 1
And I set field "mge" to "16" in row 1
And I save the current editor

# 3. Ruecklieferschein 050 zu LS 050
Given I open an editor "RLS050" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS050"
And I set fields
   | such   | RLS050 |
   | ueb    | true   |
   | vom    | .      |
And I set field "mge" to "-12" in row 1
And I save the current editor

# refrg und remge im Auftrag und Rechnung pruefen
Then field "refrg" from editor "RE050A" in row 1 has value "7"
Then field "refrg" from editor "RE050B" in row 1 has value "5"
Then field "remge" from editor "AU050" in row 1 has value "12"
# in HE
Then field "remge" from editor "RE050A" in row 1 has value "14"
# in LE
Then field "remge" from editor "RE050B" in row 1 has value "5"

# 4. Teilrechnung 050A buchen
Given I open an editor "RE050A" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE050A"
And I set field "mge" to "2" in row 1
And I set field "ueb" to "ja"
And I save the current editor

# Offene Rechnungsmenge im Auftrag und ungebuchter Rechnung pruefen
Then field "remge" from editor "AU050" in row 1 has value "11"
Then field "remge" from editor "RE050B" in row 1 has value "11"

# 5. Ruecklieferschein stornieren
Given I open an editor "SRLS050" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS050"
And I save the current editor

# Offene Rechnungsmenge im Auftrag und ungebuchter Rechnungen pruefen
Then field "remge" from editor "AU050" in row 1 has value "11"
Then field "remge" from editor "RE050B" in row 1 has value "11"


# -----------------------------------------------------------------------------
#         Ungebuchte Teilrechnungen bei LS aus AU, Storno RLS
# -----------------------------------------------------------------------------

#  AU051 ------------------------- LS051 --------------------------- RE051 ungebucht
#  10 St.                          10 St. (1!)                       6 St. (2!)
#  | Aktion | remge  | refrg |     | Aktion | remge  | refrg  |      | Aktion | remge  | refrg  |
#  |        | 10 St. | 0 St. |     |        | 10 St. |  0 St. |      |        | 10 St. |  6 St. |
#  | (1)    |  0 St. | 0 St. |     | (2)    | 10 St. |  6 St. |      | (3)    |  6 St. |  6 St. |
#                                  | (3)    | 10 St. | 10 St. |      | (4)    |  6 St. |  6 St. |
#                                  | (4)    | 10 St. | 10 St. |      | (5)    |  6 St. |  6 St. |
#                                  | (5)    | 10 St. | 10 St. |
#                                    \
#                                     \
#                                      \
#                                        -------- RE051B   ungebucht
#                                        \       4 St. (3!)
#                                         \      | Aktion | remge  | refrg  |
#                                          \     |        |  4 St. |  4 St. |
#                                           \    | (4)    |  4 St. |  4 St. |
#                                            \   | (5)    |  4 St. |  4 St. |
#                                             \
#                                               ----- RLS051 ----------------------- SRLS051
#                                                     -5 St. (4!)                    -5 St. (5!)
#                                                     | Aktion | remge | refrg |     | Aktion | remge | refrg |
#                                                     |        | -5 St.|  0 St.|     |        | -5 St.| -0 St.|
#
#

Scenario: Remge bei RE ueber LS, 2 RE ungebucht, RLS stornieren

Given I open an editor "AU051" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU051  |
And I append rows
   | artikel | he     | mge |
   | A100    | Stueck | 10  |
And I save the current editor

# Ersten Lieferschein aus Auftrag erzeugen
Given I open an editor "LS051" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU051"
And I set fields
   | such   | LS051  |
   | ueb    | true   |
Then the table has 1 rows
And I set field "mge" to "10" in row 1
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU051" in row 1 has value "0"
Then field "refrg" from editor "AU051" in row 1 has value "0"

# Ausgabe Lieferschein
Given I open an editor "LS051V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS051"
# Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "10" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Rechnung zu den Lieferschein ueber 6 Stueck ungebucht
Given I open an editor "RE051" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS051"
And I set fields
   | such   | RE051   |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "6" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU051" in row 1 has value "0"
Then field "refrg" from editor "AU051" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS051" in row 1 has value "10"
Then field "refrg" from editor "LS051" in row 1 has value "6"
# Pruefe remge und refrg in Rechnung 1
Then field "remge" from editor "RE051" in row 1 has value "10"
Then field "refrg" from editor "RE051" in row 1 has value "6"

# Rechnung 2 zu den Lieferschein ueber 4 Stueck ungebucht
Given I open an editor "RE051B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS051"
And I set fields
   | such   | RE051B  |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU051" in row 1 has value "0"
Then field "refrg" from editor "AU051" in row 1 has value "0"
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
Given I open an editor "RLS051" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS051"
And I set fields
   | such   | RLS051   |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "LS051V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS051"
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
Given I open an editor "SRL051" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS051"
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

# -----------------------------------------------------------------------------
# Wie oben, nur eine Rechnung wird vor der Stornierung des RLS, gebucht
# -----------------------------------------------------------------------------

#  AU052 ------------------------ - LS052 -------------------------- RE052A ungebucht --------------- RE052A buchen
#  10 St.                           10 St. (1!)                      6 St. (2!)                       1 St. (5!)
#  | Aktion | remge  | refrg |      | Aktion | remge  | refrg  |     | Aktion | remge  | refrg  |
#  |        | 10 St. | 0 St. |      |        | 10 St. |  0 St. |     |        | 10 St. |  6 St. |
#  | (1)    |  0 St. | 0 St. |      | (2)    | 10 St. |  6 St. |     | (3)    |  6 St. |  6 St. |
#                                   | (3)    | 10 St. | 10 St. |     | (4)    |  6 St. |  6 St. |
#                                   | (4)    | 10 St. | 10 St. |     | (5)    |  0 St. |  0 St. |
#                                   | (5)    |  9 St. |  4 St. |
#                                   | (6)    |  9 St. |  4 St. |
#                                     \
#                                      \
#                                       \
#                                         -------- RE052B   ungebucht --------
#                                         \       4 St. (3!)
#                                          \      | Aktion | remge  | refrg  |
#                                           \     |        |  4 St. |  4 St. |
#                                            \    | (4)    |  4 St. |  4 St. |
#                                             \   | (5)    |  4 St. |  4 St. |
#                                              \  | (6)    |  9 St. |  4 St. |
#                                               \
#                                                 -------------RLS052 -------------------------- SRLS052
#                                                              -5 St. (4!)                       -5 St. (6!)
#                                                              | Aktion | remge  | refrg  |      | Aktion | remge  | refrg  |
#                                                              |        | -5 St. |  0 St. |      |        | -5 St. | -0 St. |
#
#
#
#

Scenario: Remge bei RE ueber LS, RE ungebucht, RLS, RE buchen, RLS stornieren

Given I open an editor "AU052" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU052  |
And I append rows
   | artikel | he     | mge |
   | A100    | Stueck | 10  |
And I save the current editor

# Ersten Lieferschein aus Auftrag erzeugen
Given I open an editor "LS052" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU052"
And I set fields
   | such   | LS052  |
   | ueb    | true   |
Then the table has 1 rows
And I set field "mge" to "10" in row 1
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU052" in row 1 has value "0"
Then field "refrg" from editor "AU052" in row 1 has value "0"

# Ausgabe Lieferschein
Given I open an editor "LS052V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS052"
# Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "10" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Rechnung zu den Lieferschein ueber 6 Stueck ungebucht
Given I open an editor "RE052A" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS052"
And I set fields
   | such   | RE052A  |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "6" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU052" in row 1 has value "0"
Then field "refrg" from editor "AU052" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS052" in row 1 has value "10"
Then field "refrg" from editor "LS052" in row 1 has value "6"
# Pruefe remge und refrg in Rechnung 1
Then field "remge" from editor "RE052A" in row 1 has value "10"
Then field "refrg" from editor "RE052A" in row 1 has value "6"

# Rechnung 2 zu den Lieferschein ueber 4 Stueck ungebucht
Given I open an editor "RE052B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS052"
And I set fields
   | such   | RE052B  |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU052" in row 1 has value "0"
Then field "refrg" from editor "AU052" in row 1 has value "0"
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
Given I open an editor "RLS052" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS052"
And I set fields
   | such   | RLS052   |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "LS052V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS052"
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

Given I open an editor "RE052A" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE052A"
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
Given I open an editor "SRL052" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS052"
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

#  AU055 -------------------------- LS055 --------------------------- RE055 ungebucht
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

Given I open an editor "AU055" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU055  |
And I append rows
   | artikel | he     | mge |
   | A100    | Stueck | 25  |
And I save the current editor

# Ersten Lieferschein aus Auftrag erzeugen
Given I open an editor "LS055" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU055"
And I set fields
   | such   | LS055  |
   | ueb    | true   |
Then the table has 1 rows
And I set field "mge" to "25" in row 1
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU055" in row 1 has value "0"
Then field "refrg" from editor "AU055" in row 1 has value "0"

# Ausgabe Lieferschein
Given I open an editor "LS055V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS055"
# Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
Then field "remge" has value "25" in row 1
Then field "refrg" has value "0" in row 1
And I close the current editor

# Rechnung zu den Lieferschein ueber 12 kg = 6 Stueck ungebucht
Given I open an editor "RE055" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS055"
And I set fields
   | such   | RE055   |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "he" to "kg" in row 1
And I set field "mge" to "18" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU055" in row 1 has value "0"
Then field "refrg" from editor "AU055" in row 1 has value "0"
# Pruefe remge und refrg im Lieferschein
Then field "remge" from editor "LS055" in row 1 has value "25"
Then field "refrg" from editor "LS055" in row 1 has value "9"
# Pruefe remge und refrg in Rechnung 1
Then field "remge" from editor "RE055" in row 1 has value "50"
Then field "refrg" from editor "RE055" in row 1 has value "9"

# Rechnung 2 zu den Lieferschein ueber 4 Stueck ungebucht
Given I open an editor "RE055B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS055"
And I set fields
   | such   | RE055B  |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "6" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU055" in row 1 has value "0"
Then field "refrg" from editor "AU055" in row 1 has value "0"
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
Given I open an editor "RE055C" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS055"
And I set fields
   | such   | RE055C  |
   | ueb    | false   |
   | vom    | .       |
   | tterm  | .       |
And I set field "he" to "kg" in row 1
And I set field "mge" to "15" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge und refrg im Auftrag
Then field "remge" from editor "AU055" in row 1 has value "0"
Then field "refrg" from editor "AU055" in row 1 has value "0"
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
Given I open an editor "RLS055" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS055"
And I set fields
   | such   | RLS055   |
   | ueb    | true     |
   | vom    | .        |
And I set field "mge" to "-18" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "LS055V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS055"
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
Given I open an editor "SRL055" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS055"
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
#   Offene Rechnungsmenge in ungebuchten Rechnungen mit/ohne LB aus AU,
#   RLS aus RE, Storno des RLS - kein Einfluss auf (remge, refrg)
# -----------------------------------------------------------------------------

#  AU053 ------------------------ RE053A mit LB buchen ------------ RLS053 -------------- SRLS053
#  12 St.                         6 St. (1!)                        -4 St. (4!)           4 St. (5!)
#  | Aktion | remge  | refrg  |   | Aktion | remge  |               | Aktion | remge |
#  |        | 12 St. |  0 St. |   |  (1)   |  0 St. |               |  (4)   |  0 St.|
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
#                  -------------------------- RE053C ohne LB, ungebucht
#                                             1 St. (3!)
#                                             | Aktion | remge  |
#                                             |  (3)   |  2 St. |
#                                             |  (4)   |  2 St. |
#                                             |  (5)   |  2 St. |
#

Scenario: ungebuchte/gebuchte Rechnungen mit und ohne LB, RLS, Storno RLS

# Auftrag anlegen
Given I create a SalesOrder "AU053" for Customer "1" with Product "A100" and quantity "12"

# Teilrechnung 1 mit LB aus AU, gebucht
Given I open an editor "RE053A" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU053"
And I set fields
   | such  | RE053A |
   | ueb   | ja     |
   | tterm | .      |
   | vom   | .      |
Then the table has 1 rows
And I set field "mge" to "6" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# refrg im Auftrag bzw. remge in Auftrag pruefen
Then field "refrg" from editor "AU053" in row 1 has value "0"
Then field "remge" from editor "AU053" in row 1 has value "6"

# Teilrechnung 2 mit LB aus AU, ungebucht
Given I open an editor "RE053B" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU053"
And I set fields
   | such  | RE053B |
   | tterm | .      |
   | vom   | .      |
Then the table has 1 rows
And I set field "mge" to "4" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# refrg im Auftrag bzw. remge in Auftrag/Rechnung pruefen
Then field "refrg" from editor "AU053" in row 1 has value "4"
Then field "remge" from editor "AU053" in row 1 has value "6"
Then field "remge" from editor "RE053B" in row 1 has value "6"

# Teilrechnung 3 ohne LB aus AU, ungebucht
Given I open an editor "RE053C" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU053"
And I set fields
   | such  | RE053C |
   | fakt  | false  |
   | tterm | .      |
   | vom   | .      |
Then the table has 1 rows
And I set field "mge" to "1" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# refrg im Auftrag bzw. remge in Auftrag/Rechnung pruefen
Then field "refrg" from editor "AU053" in row 1 has value "5"
Then field "remge" from editor "AU053" in row 1 has value "6"
Then field "remge" from editor "RE053B" in row 1 has value "5"
Then field "remge" from editor "RE053C" in row 1 has value "2"

# Ruecklieferschein 1 zu LS 1
Given I open an editor "RLS053" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "RE053A"
And I set fields
   | such   | RLS053 |
   | ueb    | true   |
   | vom    | .      |
And I set field "mge" to "-4" in row 1
And I save the current editor

# refrg im Auftrag bzw. remge im Auftrag/Rechnung pruefen
Then field "refrg" from editor "AU053" in row 1 has value "5"
Then field "remge" from editor "AU053" in row 1 has value "6"
Then field "remge" from editor "RE053B" in row 1 has value "5"
Then field "remge" from editor "RE053C" in row 1 has value "2"

# Ruecklieferschein stornieren
Given I open an editor "SRL053" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS053"
And I save the current editor

# refrg im Auftrag bzw. remge im Auftrag/Rechnung pruefen
Then field "refrg" from editor "AU053" in row 1 has value "5"
Then field "remge" from editor "AU053" in row 1 has value "6"
Then field "remge" from editor "RE053B" in row 1 has value "5"
Then field "remge" from editor "RE053C" in row 1 has value "2"

# ----------------------------------------------------------------------------- #
#         Gleiches wie zuvor, nur mit unterschiedlichen Handelseinheiten        #
# ----------------------------------------------------------------------------- #

Scenario: ungebuchte/gebuchte Rechnungen mit/ohne LB mit unterschiedlichen HE, RLS, Storno RLS

# Auftrag anlegen
Given I open an editor "AU054" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU054  |
And I append rows
   | artikel | he     | mge |
   | A100    | Stueck | 12  |
And I save the current editor

# Teilrechnung 1 mit LB aus AU, gebucht
Given I open an editor "RE054A" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU054"
And I set fields
   | such  | RE054A |
   | ueb   | ja     |
   | tterm | .      |
   | vom   | .      |
Then the table has 1 rows
And I set field "he" to "kg" in row 1
And I set field "mge" to "12" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# refrg im Auftrag bzw. remge in Auftrag pruefen
Then field "refrg" from editor "AU054" in row 1 has value "0"
Then field "remge" from editor "AU054" in row 1 has value "6"

# Teilrechnung 2 mit LB aus AU, ungebucht
Given I open an editor "RE054B" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU054"
And I set fields
   | such  | RE054B |
   | tterm | .      |
   | vom   | .      |
Then the table has 1 rows
And I set field "mge" to "4" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# refrg im Auftrag bzw. remge in Auftrag/Rechnung pruefen
Then field "refrg" from editor "AU054" in row 1 has value "4"
Then field "remge" from editor "AU054" in row 1 has value "6"
Then field "remge" from editor "RE054B" in row 1 has value "6"

# Teilrechnung 3 ohne LB aus AU, ungebucht
Given I open an editor "RE054C" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU054"
And I set fields
   | such  | RE054C |
   | fakt  | false  |
   | tterm | .      |
   | vom   | .      |
Then the table has 1 rows
And I set field "he" to "kg" in row 1
And I set field "mge" to "2" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# refrg im Auftrag bzw. remge in Auftrag/Rechnung pruefen
Then field "refrg" from editor "AU054" in row 1 has value "5"
Then field "remge" from editor "AU054" in row 1 has value "6"
Then field "remge" from editor "RE054B" in row 1 has value "5"
# Hier: Einheit kg ( 1 Stueck = 2 kg)
Then field "remge" from editor "RE054C" in row 1 has value "4"

# Ruecklieferschein 1 zu LS 1
Given I open an editor "RLS054" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "RE054A"
And I set fields
   | such   | RLS054 |
   | ueb    | true   |
   | vom    | .      |
And I set field "mge" to "-4" in row 1
And I save the current editor

# refrg im Auftrag bzw. remge im Auftrag/Rechnung pruefen
Then field "refrg" from editor "AU054" in row 1 has value "5"
Then field "remge" from editor "AU054" in row 1 has value "6"
Then field "remge" from editor "RE054B" in row 1 has value "5"
# Hier: Einheit kg ( 1 Stueck = 2 kg)
Then field "remge" from editor "RE054C" in row 1 has value "4"

# Ruecklieferschein stornieren
Given I open an editor "SRL054" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS054"
And I save the current editor

# refrg im Auftrag bzw. remge im Auftrag/Rechnung pruefen
Then field "refrg" from editor "AU054" in row 1 has value "5"
Then field "remge" from editor "AU054" in row 1 has value "6"
Then field "remge" from editor "RE054B" in row 1 has value "5"
# Hier: Einheit kg ( 1 Stueck = 2 kg)
Then field "remge" from editor "RE054C" in row 1 has value "4"

#----------------------------------------------------------------------------------------------
# Aktualisierung von (ev)remge in offenen Rechnungen
#----------------------------------------------------------------------------------------------
#
#  AU057 --------> LS057 ------------------------- RE057-1 (offen, Positionssplit) ---> RE057-1 (gebucht) (12!)
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
#

Scenario: Aktualisierung von (ev)remge in offenen Rechnungen - 1. Rechnung mit Splitpositionen

# Auftrag
Given I open an editor "AU057" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU057  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferschein (fakturierbar)
Given I open an editor "LS057" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU057"
And I set fields
   | such   | LS057  |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung 1 mit Splitposition
Given I open an editor "RE057-1" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS057"
And I set fields
   | such   | RE057-1 |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | nein    |
   | beleg  | LS057   |
And I set field "mge" to "2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE057-1" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE057-1"
And I delete row at position 2
And I delete row at position 2
And I delete row at position 2
And I set field "beleg" to "LS057"
And I set field "mge" to "3" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "LS057" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS057"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-1" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE057-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Aktualisierung von (ev)remge in offenen Rechnungen - 2. Rechnung

# Rechnung 2
Given I open an editor "RE057-2" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS057"
And I set fields
   | such   | RE057-2 |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | nein    |
And I set field "mge" to "4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "LS057" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS057"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-1" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE057-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-2" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE057-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Aktualisierung von (ev)remge in offenen Rechnungen - Ruecklieferung 1

# Ruecklieferung 1
Given I open an editor "RLS057-1" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS057"
And I set fields
   | such   | RLS057-1 |
   | vom    | .        |
   | ueb    | ja       |
And I set field "mge" to "-3" in row 1
And I save the current editor

Given I open an editor "LS057" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS057"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-1" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE057-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-2" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE057-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Aktualisierung von (ev)remge in offenen Rechnungen - Reduzierung der Positionsmenge

Given I open an editor "RE057-2" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE057-2"
And I set field "mge" to "2" in row 1
And I save the current editor

Given I open an editor "LS057" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS057"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-1" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE057-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-2" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE057-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Aktualisierung von (ev)remge in offenen Rechnungen - Ruecklieferung 2

# Ruecklieferung 2
Given I open an editor "RLS057-2" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS057"
And I set fields
   | such   | RLS057-2 |
   | vom    | .        |
   | ueb    | ja       |
And I set field "mge" to "-4" in row 1
And I save the current editor

Given I open an editor "LS057" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS057"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-1" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE057-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-2" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE057-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Aktualisierung von (ev)remge in offenen Rechnungen - Reduzierung der Positionsmenge 2

Given I open an editor "RE057-1" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE057-1"
And I set field "mge" to "1" in row 1
And I set field "mge" to "1" in row 3
And I save the current editor

Given I open an editor "RE057-2" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE057-2"
And I set field "mge" to "1" in row 1
And I save the current editor

Given I open an editor "RE057-1" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE057-1"
And I set field "mge" to "1" in row 3
And I save the current editor

Given I open an editor "LS057" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS057"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-1" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE057-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-2" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE057-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Aktualisierung von (ev)remge in offenen Rechnungen - Storno Rücklieferung

Given I open an editor "RLS057-1" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS057-1"
And I save the current editor

Given I open an editor "LS057" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS057"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-1" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE057-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-2" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE057-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Aktualisierung von (ev)remge in offenen Rechnungen - Erhoehung der Positionsmenge

Given I open an editor "RE057-1" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE057-1"
And I set field "mge" to "2" in row 1
And I set field "mge" to "2" in row 3
And I save the current editor

Given I open an editor "RE057-2" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE057-2"
And I set field "mge" to "2" in row 1
And I save the current editor

Given I open an editor "LS057" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS057"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-1" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE057-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-2" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE057-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Aktualisierung von (ev)remge in offenen Rechnungen - Storno Rücklieferung 2

Given I open an editor "RLS057-2" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS057-2"
And I save the current editor

Given I open an editor "LS057" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS057"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-1" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE057-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-2" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE057-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Aktualisierung von (ev)remge in offenen Rechnungen - Erhoehung der Positionsmenge 2

Given I open an editor "RE057-1" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE057-1"
And I set field "mge" to "3" in row 3
And I save the current editor

Given I open an editor "RE057-2" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE057-2"
And I set field "mge" to "4" in row 1
And I save the current editor

Given I open an editor "LS057" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS057"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-1" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE057-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-2" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE057-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Aktualisierung von (ev)remge in offenen Rechnungen - Rechnungsbuchung

Given I open an editor "RE057-1" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE057-1"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "LS057" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS057"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-1" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE057-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-2" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE057-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Aktualisierung von (ev)remge in offenen Rechnungen - Rechnungsbuchung 2

Given I open an editor "RE057-2" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE057-2"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "LS057" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS057"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-1" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE057-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RE057-2" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE057-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Zwei RLS per Beleg anfuegen gutschreiben
# indirekt gesplittete Position im KGS, da die Positionen aus den RLS eine gemeinsame LS Position haben

#  AU058 ---> LS058 -----> RE170
#   170 St.   170 St.      170 St.
#                 \
#                  \
#                   ----------> RLS058
#                    \         -69 St. (1!)
#                     \        | Aktion | remge
#                      \       | (1)    | -69 St.
#                       \      | (2)    | -140 St.\
#                        \     | (3)    | -0 St.   \
#                         \                         \                   KGS058
#                          \                         ----------------> -69 (3!)
#                           \                             -----------> -71 (3!)
#                            ----------> RLS058B         /
#                                          -71 St. (2!) /
#                                          | Aktion | remge   |
#                                          | (2)    | -140 St.|
#                                          | (3)    | -2 St.  |
#                                          | (6)    | -0 St.  |
#

# AU
Given I create a SalesOrder "AU058" for Customer "1" with Product "E1" and quantity "170"

# LS
Given I deliver the SalesOrder "AU058" with PackingSlip "LS058"

# RE
Given I open an editor "RE058" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS058"
And I set field "such" to "RE058"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I save the current editor

# Ruecklieferschein1 anlegen
Given I open an editor "RLS058" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS058"
And I set field "such" to "RLS058"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-69" in row 1
And I set field "platz" to "F2" in row 1
And I save the current editor

# Rücklieferschein2 anlegen
Given I open an editor "RLS058B" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS058"
And I set field "such" to "RLS058B"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-71" in row 1
And I set field "platz" to "F2" in row 1
And I save the current editor

# Gutschrift fuer beide RSL ueber Beleg anfuegen
Given I open an editor "KGS058" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS058"
And I set field "such" to "KGS058"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "mge" to "-69" in row 1
And I set field "beleg" to id from editor "RLS058B"
And I set field "mge" to "-71" in row 3
And I save the current editor

Then field "remge" from editor "RLS058B" in row 1 has value "0"
Then "(Sales):(PackingSlip)" with the editor id "RLS058B" is filed

Then field "remge" from editor "RLS058" in row 1 has value "0"
Then "(Sales):(PackingSlip)" with the editor id "RLS058" is filed

Scenario: KGS mit gesplitteter RLS Position - Pruefe auf Remge in RLS
# Splittung kommt zustande, weil  beim Gutschreiben unterschiedliche Rechnungen zu beruecksichtigen sind
# Behandlung der gesplitteten Positionen in der KGS bezueglich der Remge
#
#  AU059 ---> LS059 ---> RE059
#  160 St.    160 St.    60 St.
#                \
#                 \----------> RE059B
#                  \           100 St.
#                   \
#                    ---------------> RLS059 -------------> KGS059 (Gleiche RLS Position splitten)
#                                     -140 St. (1!)         -60 St. (2!)
#                                     | Aktion | remge      -80 St. (2!)
#                                     | (1)    | -140 St.
#                                     | (2)    |    0 St.

# AU
Given I create a SalesOrder "AU059" for Customer "1" with Product "E1" and quantity "160"

# LS
Given I deliver the SalesOrder "AU059" with PackingSlip "LS059"

# RE
Given I open an editor "RE059" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS059"
And I set field "such" to "RE059"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "mge" to "60" in row 1
And I save the current editor

# RE 2
Given I open an editor "RE059B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS059"
And I set field "such" to "RE059B"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "mge" to "100" in row 1
And I save the current editor

# Ruecklieferschein
Given I open an editor "RLS059" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS059"
And I set field "such" to "RLS059"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-140" in row 1
And I set field "platz" to "F2" in row 1
And I save the current editor
Then field "remge" from editor "RLS059" in row 1 has value "-140"

# Gutschrift zu RLS -> 2 Positionen
Given I open an editor "KGS059" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS059"
And I set field "beleg" to id from editor "RLS059"
And I set field "such" to "KGS059"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
Then the table has 2 rows
Then field "mge" has value "-40" in row 1
Then field "mge" has value "-100" in row 2
And I save the current editor

Then field "remge" from editor "RLS059" in row 1 has value "0"
Then "(Sales):(PackingSlip)" with the editor id "RLS059" is filed

#----------------------------------------------------------------------------------------------
#    Sperren bei einem Storno eines Vorgangs:
#    ist, neben dem Vorgang selbst, auch der Auftrag gesperrt?
#----------------------------------------------------------------------------------------------

#
#  Storno eines Lieferscheins
#

#  AU060 ----------------- LS060A ----------------- SLS060A
#  20 St.                  12 St.                   -12 St. (1!)
#  | Aktion | Sperre |     | Aktion | Sperre |
#  |  (1)   |   ja   |     |  (1)   |   ja   |
#  |  (2)   |   ja   |
#     \           \
#      \            --------------------- RE060A ohne LB
#       \                                 8 St.
#        \
#         \
#           -------- LS060B ---------------------------- SLS060B
#                    4 St.                               -4 St. (2!)
#                    | Aktion | Sperre |
#                    |   (2)  |   ja   |
#                      \
#                       \
#                         -------- RE060B ohne LB
#                                  3 St.
#

Scenario: Storno LS: sind AU und LS gesperrt worden?
# Fall 1: AU, RE aus AU, LS, Storno LS
# Fall 2: AU, LS, RE aus LS, Storno LS

# Auftrag
Given I create a SalesOrder "AU060" for Customer "1" with Product "V1" and quantity "20" and price "6"

# ------------ Fall 1 -------------

# Lieferschein aus Auftrag erzeugen
Given I open an editor "LS060A" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU060"
And I set fields
   | such   | LS060A |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "12" in row 1
And I save the current editor

# Teilrechnung ohne LB aus Auftrag
Given I open an editor "RE060A" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU060"
And I set fields
   | such   | RE060A |
   | ueb    | true   |
   | fakt   | false  |
   | tterm  | .      |
   | vom    | .      |
And I set field "mge" to "8" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein A stornieren um Sperrsituation zu ueberpruefen
Given I open an editor "SLS060A" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "LS060A"

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 1. Auftrag laesst sich nicht oeffnen: Sperre wegen Storno Lieferschein A
Then opening an editor from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AU060" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "SLS060A"
And I save the current editor

# ------------ Fall 2 -------------

# Lieferschein aus Auftrag erzeugen
Given I open an editor "LS060B" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU060"
And I set fields
   | such   | LS060B |
   | ueb    | true   |
   | vom    | .      |
And I set field "mge" to "4" in row 1
And I save the current editor

# Teilrechnung ohne LB aus AU
Given I open an editor "RE060B" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU060"
And I set fields
   | such   | RE060B |
   | ueb    | true   |
   | tterm  | .      |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "1" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein B stornieren
Given I open an editor "SLS060B" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "LS060B"

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 1. Auftrag laesst sich nicht oeffnen: Sperre wegen Storno LS
Then opening an editor from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AU060" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "SLS060B"
And I save the current editor


#
#  Storno einer Rechnung
#

#  AU061 ---------------- RE061A ohne LB -------- SRE061A
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

Scenario: Storno RE: sind AU bzw. LS gesperrt worden?

# Auftrag
Given I create a SalesOrder "AU061" for Customer "1" with Product "V2" and quantity "20" and price "6"

# ------------- Rechnung aus Auftrag ----------

# Teilrechnung ohne LB aus AU
Given I open an editor "RE061A" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU061"
And I set fields
   | such   | RE061A |
   | ueb    | true   |
   | fakt   | false  |
   | tterm  | .      |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "12" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung 61A stornieren
Given I open an editor "SRE061A" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE061A"

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 1. Auftrag laesst sich nicht oeffnen: Sperre wegen Storno LS
Then opening an editor from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AU061" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "SRE061A"
And I save the current editor

# Barzahlung
Given I open an editor "RE061BAR" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU061"
And I set fields
   | such   | RE061BAR |
   | ueb    | true   |
   | tterm  | .      |
   | vom    | .      |
   |vorganga| Barzahlung |
Then the table has 1 rows
And I set field "mge" to "2" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung 61BAR stornieren, nicht speichern
Given I open an editor "SRE061BAR" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE061BAR"

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 1. Auftrag laesst sich nicht oeffnen: Sperre wegen Storno LS
Then opening an editor from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AU061" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "SRE061BAR"
And I save the current editor

# Anzahlung: Fakturaplan fuer AU061 anlegen
Given I open an editor "FPLAN061" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "AU061"
And I set fields
   | such | FPANZ061 |
And I append rows
   | reart     | proz | ptext        | zbed |
   | Anzahlung | 20   | 1. Anzahlung | 203  |
   | Anzahlung | 10   | 2. Anzahlung | 203  |

# Anzahlungsrechnung anlegen
And I press button "anzahlungsrechn" to open a subeditor for "ANZ061" in row 1
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "FPLAN061"
And I save the current editor

# Rechnung ANZ061 stornieren, noch nicht speichern
Given I open an editor "SPLAN061" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "ANZ061"

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 1. Auftrag laesst sich nicht oeffnen: Sperre wegen Storno Anzahlungsrechnung
Then opening an editor from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AU061" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "SPLAN061"
And I save the current editor

# ------------- Rechnung aus Lieferschein ----------

# Lieferschein aus Auftrag erzeugen
Given I open an editor "LS061B" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU061"
And I set fields
   | such   | LS061B |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "4" in row 1
And I save the current editor

# Teilrechnung aus Lieferschein
Given I open an editor "RE061B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS061B"
And I set fields
   | such   | RE061B |
   | ueb    | true   |
   | tterm  | .      |
   | vom    | .      |
And I set field "mge" to "3" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung 61B stornieren, noch nicht speichern
Given I open an editor "SRE061B" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE061B"

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 1. Lieferschein laesst sich nicht oeffnen: Sperre
Then opening an editor from table "(Sales):(PackingSlip)" with command "UPDATE" for record "LS061B" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "SRE061B"
And I save the current editor

# ------------- Rechnung mit Lagerbewegung ----------

# Rechnung mit LB
Given I open an editor "RE061C" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU061"
And I set fields
   | such   | RE061C |
   | vom    | .      |
   | tterm  | .      |
   | fakt   | ja     |
   | ueb    | ja     |
And I set field "mge" to "4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung 61C stornieren, noch nicht speichern
Given I open an editor "SRE061C" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE061C"

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 1. Auftrag laesst sich nicht oeffnen: Sperre wegen Storno LS
Then opening an editor from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AU061" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "SRE061C"
And I save the current editor


# ----------------------------------------------------------------------------------------------
#  Neu, Aendern, Storno eines Ruecklieferscheins
# ----------------------------------------------------------------------------------------------

Scenario: Neu, Aendern, Storno RLS: sind AU bzw. LS gesperrt worden?

#
# ------------- Rechnung aus Auftrag ----------
#

# Auftrag
Given I create a SalesOrder "AU070A" for Customer "1" with Product "V2" and quantity "20" and price "6"

# Teilrechnung ohne LB aus AU
Given I open an editor "RE070A" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU070A"
And I set fields
   | such   | RE070A |
   | ueb    | true   |
   | fakt   | false  |
   | tterm  | .      |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "12" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein aus Auftrag erzeugen
Given I open an editor "LS070A" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU070A"
And I set fields
   | such   | LS070A |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "4" in row 1
And I save the current editor


# ------- Ruecklieferschein neu mit "Beleg anfuegen", nicht speichern - Anfang -------

Given I open an editor "RLS070A2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS070A"
And I set fields
   | such   | RLS070A2 |
And I set field "mge" to "-1" in row 1

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 1. Auftrag laesst sich nicht oeffnen: Sperre wegen RLS Neu mit "Beleg anfuegen"
Then opening an editor from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AU070A" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "RLS070A2"
And I close the current editor

# ------- Ruecklieferschein neu mit "Beleg anfuegen", nicht speichern - Ende -------


# ------- Ruecklieferschein neu, ohne zu buchen - Anfang -------

Given I open an editor "RLS070A" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS070A"
And I set fields
   | such   | RLS070A |
And I set field "mge" to "-1" in row 1

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 1. Auftrag laesst sich nicht oeffnen: Sperre wegen Neuanlage aus LS
Then opening an editor from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AU070A" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "RLS070A"
And I save the current editor

# ------- Ruecklieferschein neu, ohne zu buchen - Ende -------


# ------- Ruecklieferschein aendern und buchen - Anfang -------

Given I open an editor "RLS070A" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "RLS070A"
And I set fields
   | ueb    | ja      |

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 2. Auftrag laesst sich nicht oeffnen: Sperre wegen aendern und buchen RLS
Then opening an editor from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AU070A" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "RLS070A"
And I save the current editor

# ------- Ruecklieferschein aendern und buchen - Ende -------


# ------- Ruecklieferschein stornieren - Anfang -------

Given I open an editor "SRLS070A" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS070A"

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 3. Auftrag laesst sich nicht oeffnen: Sperre wegen Storno RLS
Then opening an editor from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AU070A" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "SRLS070A"
And I save the current editor

# ------- Ruecklieferschein stornieren - Ende -------

#
# ------------- Rechnung aus Lieferschein ----------
#

# Auftrag
Given I create a SalesOrder "AU070B" for Customer "1" with Product "V2" and quantity "20" and price "6"

# Lieferschein aus Auftrag erzeugen
Given I open an editor "LS070B" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU070B"
And I set fields
   | such   | LS070B |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "4" in row 1
And I save the current editor

# Teilrechnung aus Lieferschein
Given I open an editor "RE070B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS070B"
And I set fields
   | such   | RE070B |
   | ueb    | true   |
   | tterm  | .      |
   | vom    | .      |
And I set field "mge" to "3" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein zum Lieferschein
Given I open an editor "RLS070B" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS070B"
And I set fields
   | such   | RLS070B |
   | ueb    | ja      |
And I set field "mge" to "-1" in row 1
And I save the current editor

# Ruecklieferschein stornieren
Given I open an editor "SRLS070B" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS070B"

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# Lieferschein laesst sich nicht oeffnen: Sperre
Then opening an editor from table "(Sales):(PackingSlip)" with command "UPDATE" for record "LS070B" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "SRLS070B"
And I save the current editor

# ----------------------------------------------------------------------------------------------
#       Storno einer kaufmaennischen Gutschrift
# ----------------------------------------------------------------------------------------------

Scenario: Storno KGS: sind AU bzw. LS gesperrt worden?

#
# ------------- Rechnung aus Auftrag ohne LB ----------
#

# Auftrag
Given I open an editor "AU071" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
  | kunde   | 1     |
  | such    | AU071 |
And I append rows
  |artikel  | mge         | preis       |
  |1NEUTRAL | !dontChange | !dontChange |
  |v2       | 20          | 6           |
And I save the current editor

# Teilrechnung ohne LB aus AU
Given I open an editor "RE071A" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU071"
And I set fields
   | such   | RE071A |
   | ueb    | true   |
   | fakt   | false  |
   | tterm  | .      |
   | vom    | .      |
Then the table has 2 rows
And I set field "mge" to "16" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein aus Auftrag erzeugen
Given I open an editor "LS071A" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU071"
And I set fields
   | such   | LS071A |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "10" in row 1
And I save the current editor

# Ruecklieferschein zum Lieferschein
Given I open an editor "RLS071A" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS071A"
And I set fields
   | such   | RLS071A |
   | ueb    | ja      |
And I set field "mge" to "-9" in row 1
And I save the current editor

# ------- KGS neu mit "Beleg anfuegen", nicht speichern - Anfang -------

Given I open an editor "KGS071A1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS071A"
And I set fields
   | such   | KGS071A2 |
And I set field "mge" to "-3" in row 1

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 1. Auftrag laesst sich nicht oeffnen: Sperre wegen Neuanlage mit "Beleg anfuegen"
Then opening an editor from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AU071" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "KGS071A1"
And I close the current editor

# ------- KGS neu mit Beleg anfuegen, nicht speichern - Ende -------


# ------- KGS neu ohne zu buchen - Anfang -------

# Kaufm. Gutschrift A zu RLS A
Given I open an editor "KGS071A2" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS071A"
And I set fields
   | such   | KGS071A |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "-4" in row 1

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 2. Auftrag laesst sich nicht oeffnen: Sperre wegen KGS aus RLS
Then opening an editor from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AU071" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "KGS071A2"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# ------- KGS neu ohne zu buchen - Ende -------

# ------- KGS aendern und buchen - Anfang --------

Given I open an editor "KGS071A3" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS071A2"
And I set fields
   | ueb    | ja      |

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 3. Auftrag laesst sich nicht oeffnen: Sperre wegen Aendern KGS
Then opening an editor from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AU071" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "KGS071A3"
And I save the current editor

# ------- KGS aendern und buchen - Ende --------


# ------- Kaufm. Gutschrift stornieren - Anfang -------

Given I open an editor "SKGS071A" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "KGS071A3"

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 4. Auftrag laesst sich nicht oeffnen: Sperre wegen Storno KGS
Then opening an editor from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AU071" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "SKGS071A"
And I save the current editor

# ------- Kaufm. Gutschrift stornieren - Ende -------

#
# ------------- Rechnung aus Auftrag mit LB ----------
#

# AU wird nicht gesperrt
#           fakt=true
# AU071C ----- RE -----  RLS ----- KGS
#

# Auftrag
Given I open an editor "AU071C" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
  | kunde   | 1      |
  | such    | AU071C |
And I append rows
  |artikel  | mge         | preis       |
  |1NEUTRAL | !dontChange | !dontChange |
  |v2       | 20          | 6           |
And I save the current editor

# Teilrechnung mit LB aus AU
Given I open an editor "RE071C" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU071C"
And I set fields
   | such   | RE071C |
   | ueb    | true   |
   | tterm  | .      |
   | vom    | .      |
Then the table has 2 rows
And I set field "mge" to "16" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein zur Rechnung RE071C
Given I open an editor "RLS071C" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "RE071C"
And I set fields
   | such   | RLS071C |
   | ueb    | ja      |
And I set field "mge" to "-9" in row 2
And I save the current editor

# ------- KGS neu aus RLS - Anfang -------

# NEU: Kaufm. Gutschrift C zu RLS C, nicht buchen
Given I open an editor "KGS071C" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS071C"
And I set fields
   | such   | KGS071C |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "-5" in row 2

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 1. Auftrag laesst sich im Aendern-Modus oeffnen: Keine Sperre wegen KGS Neu
And I open an editor "AU071C_UP1" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU071C"
And I close the current editor

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "KGS071C"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# AENDERN: Kaufm. Gutschrift C buchen
Given I open an editor "KGS071C" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS071C"
And I set fields
   | ueb    | true    |

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 2. Auftrag laesst sich im Aendern-Modus oeffnen: Keine Sperre wegen KGS Aenderung
Given I open an editor "AU071C_UP2" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU071C"
And I close the current editor

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "KGS071C"
And I save the current editor


# ------- KGS neu aus RLS - Ende -------

#
# ------------- Rechnung aus Lieferschein ----------
#

# AU071B ----- LS -------- RLS ----- KGS ----- SKGS
#                \
#                  ---- RE

# Auftrag
Given I open an editor "AU071B" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
  | kunde   | 1      |
  | such    | AU071B |
And I append rows
  |artikel  | mge         | preis       |
  |v2       | 20          | 6           |
And I save the current editor

# Lieferschein aus Auftrag
Given I open an editor "LS071B" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU071B"
And I set fields
   | such   | LS071B |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "12" in row 1
And I save the current editor

# Teilrechnung aus Lieferschein
Given I open an editor "RE071B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS071B"
And I set fields
   | such   | RE071B |
   | ueb    | true   |
   | tterm  | .      |
   | vom    | .      |
And I set field "mge" to "10" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein zum Lieferschein
Given I open an editor "RLS071B" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS071B"
And I set fields
   | such   | RLS071B |
   | ueb    | ja      |
And I set field "mge" to "-9" in row 1
And I save the current editor

# Kaufm. Gutschrift 71B zu RLS 71B
Given I open an editor "KGS071B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS071B"
And I set fields
   | such   | KGS071B |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
And I set field "mge" to "-1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Kaufm. Gutschrift 71B stornieren
Given I open an editor "SKGS071B" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "KGS071B"

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# Auftrag ist nicht gesperrt
Given I open an editor "AU071B_UP" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU071B"
And I close the current editor

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "SKGS071B"
And I save the current editor

# ----------------------------------------------------------------------------------------------
# ---------------- Sperren Pruefungen Ende ------------------
# ----------------------------------------------------------------------------------------------


Scenario: Remge bei RE+LB mit RE ohne LB gemischt

#  AU062 ----------------------> RE062 + LB
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

Given I create a SalesOrder "AU062" for Customer "1" with Product "V1" and quantity "10"

Then field "remge" from editor "AU062" in row 1 has value "10"
Then field "limge" from editor "AU062" in row 1 has value "10"

# Teilrechnung Rechnung mit LBG aus Auftrag erzeugen und buchen
Given I open an editor "RE062" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU062"
And I set fields
   | such   | RE062  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
Then the table has 1 rows
And I set field "mge" to "6" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "AU062" in row 1 has value "4"
Then field "limge" from editor "AU062" in row 1 has value "4"

#  Rechnung ohne LBG mit Menge 2 aus Auftrag erzeugen und buchen
Given I open an editor "RE062B" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU062"
And I set fields
   | such   | RE062B |
   | ueb    | ja     |
   | fakt   | nein   |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "3" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "AU062" in row 1 has value "1"
Then field "limge" from editor "AU062" in row 1 has value "4"

# Lieferschein aus Auftrag mit Menge 3 Stück erzeugen und buchen
Given I open an editor "LS062" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU062"
And I set fields
   | such   | LS062 |
   | ueb    | ja    |
And I set field "mge" to "3" in row 1
And I save the current editor

Then field "remge" from editor "AU062" in row 1 has value "1"
Then field "limge" from editor "AU062" in row 1 has value "1"

# Ruecklieferschein zu Lieferschein mit Menge -1 erzeugen und buchen
Given I open an editor "RLS062" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS062"
And I set fields
   | such   | RLS062 |
   | ueb    | ja     |
And I set field "mge" to "-1" in row 1
And I set field "platz" to "F1" in row 1
And I save the current editor
Then field "remge" from editor "RLS062" in row 1 has value "0"

Then field "remge" from editor "AU062" in row 1 has value "1"
Then field "limge" from editor "AU062" in row 1 has value "1"

# Rechnung aus Auftag mit Menge 1 erstellen
Given I open an editor "RE062C" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU062"
And I set fields
   | such   | RE062C  |
   | ueb    | ja      |
   | fakt   | nein    |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "1" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "AU062" in row 1 has value "0"
Then field "limge" from editor "AU062" in row 1 has value "1"

Scenario: Remge bei RE aus AU bei kompletter RL nur noch 0 Rechnung moeglich

#  AU063 ----------------------> LS063 mit RE   --> RLS063
#   10 St. (1!)              \   10 St. (2!)        -10 St. (3!)
#   | Aktion | remge  | limge \
#   | (1)    | 10 St. | 10 St. \
#   | (2)    |  0 St. |  0 St.  \
#   | (3)    |  0 St. |  0 St.   ---> RE063 (ohne LB nur noch 0 Rechnung moeglich!)
#   | (4)    |  0 St. |  0 St.    \   0 St. (4!)
#

# AU
Given I create a SalesOrder "AU063" for Customer "1" with Product "V1" and quantity "10"

Then field "remge" from editor "AU063" in row 1 has value "10"
Then field "limge" from editor "AU063" in row 1 has value "10"

#LS aus AU ohne RE
Given I open an editor "LS063" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU063"
And I set fields
   | such   | LS063 |
   | ueb    | ja    |
   | fakt   | ja    |
And I set field "mge" to "10" in row 1
And I save the current editor

Then field "remge" from editor "AU063" in row 1 has value "0"
Then field "limge" from editor "AU063" in row 1 has value "0"
Then "(Sales):(SalesOrder)" with the editor id "AU063" is filed

# RLS komplett
Given I open an editor "RLS063" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS063"
And I set fields
   | such   | RLS063 |
   | ueb    | ja     |
And I set field "mge" to "-10" in row 1
And I set field "platz" to "F1" in row 1
And I save the current editor
Then field "remge" from editor "RLS063" in row 1 has value "0"

Then field "remge" from editor "AU063" in row 1 has value "0"
Then field "limge" from editor "AU063" in row 1 has value "0"
Then "(Sales):(SalesOrder)" with the editor id "AU063" is filed

# Rechnung mit LBG aus Auftrag erzeugen und buchen
Given I open an editor "RE063" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU063"
And I set fields
   | such   | RE063  |
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

Then field "remge" from editor "AU063" in row 1 has value "0"
Then field "limge" from editor "AU063" in row 1 has value "0"
Then "(Sales):(SalesOrder)" with the editor id "AU063" is filed

Scenario: Remge bei gesplitteten LS Positionen in Rechnung

#  AU066 --------------> LS066 -------------> RE066
#   150 St. (1!)         150 St. (2!)         100 St. (3!)
#   | Aktion | remge     | Aktion | remge      50 St. (3!)
#   | (1)    | 150 St.   | (2)    | 150 St.
#   | (2)    |   0 St.   | (3)    |   0 St.
#

# AU
Given I create a SalesOrder "AU066" for Customer "1" with Product "E1" and quantity "150"
Then field "remge" from editor "AU066" in row 1 has value "150"

# LS
Given I deliver the SalesOrder "AU066" with PackingSlip "LS066"
Then field "remge" from editor "AU066" in row 1 has value "0"
Then field "remge" from editor "LS066" in row 1 has value "150"
Then "(Sales):(PackingSlip)" with the editor id "LS066" is not filed

# RE
Given I open an editor "RE066" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS066"
And I set field "such" to "RE066"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "mge" to "100" in row 1
And I set field "beleg" to id from editor "LS066"
And I set field "mge" to "50" in row 2
And I save the current editor

Then field "remge" from editor "LS066" in row 1 has value "0"
Then "(Sales):(PackingSlip)" with the editor id "LS066" is filed
Then "(Sales):(Invoice)" with the editor id "RE066" is filed

Scenario: Remge bei gesplitteten LS Positionen aus AU

#  AU067 --------------> LS067 -------------> RE067
#   160 St. (1!)         100 St. (2!)         100 St. (3!)
#   | Aktion | remge      50 St. (2!)          50 St. (3!)
#   | (1)    | 160 St.   | Aktion | remge
#   | (2)    |  10 St.   | (2)    | 100 St.
#                        | (2)    |  50 St.
#                        | (3)    |   0 St.
#                        | (3)    |   0 St.

# AU
Given I create a SalesOrder "AU067" for Customer "1" with Product "E1" and quantity "160"
Then field "remge" from editor "AU067" in row 1 has value "160"

# LS mit gesplitt. Pos
Given I open an editor "LS067" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU067"
And I set field "such" to "LS067"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "mge" to "100" in row 1
And I set field "beleg" to id from editor "LS067"
And I set field "mge" to "50" in row 2
And I save the current editor

Then field "remge" from editor "AU067" in row 1 has value "10"
Then field "remge" from editor "LS067" in row 1 has value "100"
Then field "remge" from editor "LS067" in row 2 has value "50"

# RE
Given I open an editor "RE067" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS067"
And I set field "such" to "RE067"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
Then the table has 2 rows
And I save the current editor
Then field "remge" from editor "LS067" in row 1 has value "0"
Then field "remge" from editor "LS067" in row 2 has value "0"
Then "(Sales):(PackingSlip)" with the editor id "LS067" is filed

Scenario: Remge bei gesplitteten AU Positionen in Rechnung + LB

#  AU068 --------------> RE068 + LB
#   150 St. (1!)         100 St. (2!)
#   | Aktion | remge      50 St. (2!)
#   | (1)    | 150 St.   | Aktion | remge
#   | (2)    |   0 St.   | (2)    |   0 St.
#                        | (2)    |   0 St.
#

# AU
Given I create a SalesOrder "AU068" for Customer "1" with Product "E1" and quantity "150"
Then field "remge" from editor "AU068" in row 1 has value "150"

# RE + LB
Given I open an editor "RE068" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU068"
And I set field "such" to "RE068"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "mge" to "100" in row 1
And I set field "beleg" to id from editor "AU068"
And I set field "mge" to "50" in row 2
And I save the current editor

Then field "fakt" from editor "RE068" in row 1 has value "ja"
Then field "remge" from editor "RE068" in row 1 has value "-100"
Then field "remge" from editor "RE068" in row 2 has value "-50"
Then "(Sales):(Invoice)" with the editor id "RE068" is filed
Then field "remge" from editor "AU068" in row 1 has value "0"
Then "(Sales):(SalesOrder)" with the editor id "AU068" is filed

Scenario: Mehrfaches Stornieren von Lieferscheinen AU -> LSA -> SLSA + LSB -> SLSB

#    AU069
#    10 St.
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

Given I open an editor "AU069" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde | 1      |
   | such  | AU069  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Pruefe remge in Auftrag
Then field "remge" from editor "AU069" in row 1 has value "10"

# Lieferschein 69A aus Auftrag erzeugen
Given I open an editor "LS069A" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU069"
And I set fields
   | such   | LS069A |
   | ueb    | true   |
   | fakt   | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "6" in row 1
And I save the current editor

# Pruefe remge in Auftrag
Then field "remge" from editor "AU069" in row 1 has value "4"
Then field "ablagef" from editor "AU069" in row 0 has value "nein"
Then field "naktiv" from editor "AU069" in row 0 has value "1"
# Pruefe remge in Lieferschein A
Then field "remge" from editor "LS069A" in row 1 has value "6"
Then field "ablagef" from editor "LS069A" in row 0 has value "nein"
Then field "naktiv" from editor "LS069A" in row 0 has value "1"

# Lieferschein 69A stornieren
Given I open an editor "SLS069A" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "LS069A"
And I save the current editor

# Pruefe remge in Auftrag
Then field "remge" from editor "AU069" in row 1 has value "10"
Then field "ablagef" from editor "AU069" in row 0 has value "nein"
Then field "naktiv" from editor "AU069" in row 0 has value "1"
# Pruefe remge in Lieferschein A
Then field "remge" from editor "LS069A" in row 1 has value "0"
Then field "ablagef" from editor "LS069A" in row 0 has value "ja"
Then field "naktiv" from editor "LS069A" in row 0 has value "1"
# Pruefe remge in Storno-Lieferschein A
Then field "remge" from editor "SLS069A" in row 1 has value "0"
Then field "ablagef" from editor "SLS069A" in row 0 has value "ja"
Then field "naktiv" from editor "SLS069A" in row 0 has value "0"

# Lieferschein 69B aus Auftrag erzeugen
Given I open an editor "LS069B" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU069"
And I set fields
   | such   | LS069B |
   | ueb    | true   |
   | vom    | .      |
Then the table has 1 rows
And I set field "mge" to "4" in row 1
And I save the current editor

# Pruefe remge in Auftrag
Then field "remge" from editor "AU069" in row 1 has value "6"
Then field "ablagef" from editor "AU069" in row 0 has value "nein"
Then field "naktiv" from editor "AU069" in row 0 has value "1"
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
Given I open an editor "SLS069B" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "LS069B"
And I save the current editor

# Pruefe remge in Auftrag
Then field "remge" from editor "AU069" in row 1 has value "10"
Then field "ablagef" from editor "AU069" in row 0 has value "nein"
Then field "naktiv" from editor "AU069" in row 0 has value "1"
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
#  AU070 ---------------------> LS070 ------------> RE070
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

Given I create a SalesOrder "AU070" for Customer "1" with Product "V1" and quantity "10"

# limge im Auftrag ist 10, remge ist 10
Then field "limge" from editor "AU070" in row 1 has value "10"
Then field "remge" from editor "AU070" in row 1 has value "10"

# Lieferschein aus Auftrag mit Menge 10 erzeugen und buchen
Given I deliver the SalesOrder "AU070" with PackingSlip "LS070"

# limge im Auftrag ist 0, remge ist 0
Then field "limge" from editor "AU070" in row 1 has value "0"
Then field "remge" from editor "AU070" in row 1 has value "0"

# Teilrechnung aus Lieferschein mit Menge 5 erzeugen und buchen
Given I open an editor "RE070" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS070"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "mge" to "5" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#remge im Lieferschein ist 5
Then field "remge" from editor "LS070" in row 1 has value "5"

# 2. Teilrechnung aus Lieferschein mit Menge 5 erzeugen und buchen
Given I open an editor "RE070B" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS070"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "mge" to "5" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#remge im Lieferschein ist 0
Then field "remge" from editor "LS070" in row 1 has value "0"
Then "(Sales):(PackingSlip)" with the editor id "LS070" is filed

# Teil-RLS zu LS
Given I open an editor "RLS070" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS070"
And I set field "ueb" to "ja"
And I set field "mge" to "-7" in row 1
And I set field "platz" to "F1" in row 1
And I save the current editor
Then field "remge" has value "-7" in row 1

# KGS zu RLS mit Menge -7 erzeugen (ergibt Split) und buchen
Given I open an editor "KGS070" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS070"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
Then the table has 2 rows
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#remge im Ruecklieferschein ist 0
Then field "remge" from editor "RLS070" in row 1 has value "0"
Then "(Sales):(PackingSlip)" with the editor id "RLS070" is filed

# Gesplitteten KGS stornieren
Given I open an editor "SKGS070" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "KGS070"
And I save the current editor

#remge im RLS muss komplett zurueckgesetzt sein
Then field "remge" from editor "RLS070" in row 1 has value "-7"
Then "(Sales):(PackingSlip)" with the editor id "RLS070" is not filed


Scenario: Remge bei gesplitteten Positionen bei RE (komplett) aus AU + RE Storno
#
#  AU171 ------------------> RE171 -----------------------> SRE171 (3!)
#  150 St.   (1!)           100 St. split (2!)
#  | Aktion | remge          50 St. split (2!)
#  | (1)    | 150 St.       | Aktion | remge
#  | (2)    |   0 St.       | (2)    |   0 St.
#  | (3)    | 150 St. sind aber 50!
#

# AU
Given I create a SalesOrder "AU171" for Customer "1" with Product "V1" and quantity "150"
Then field "remge" from editor "AU171" in row 1 has value "150"

# RE ohne LB mit Split
Given I open an editor "RE171" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU171"
And I set fields
| such   | RE171  |
| ueb    | ja     |
| vom    | .      |
| tterm  | .      |
| fakt   | ja     |
And I set field "mge" to "100" in row 1
And I set field "beleg" to id from editor "AU171"
And I set field "mge" to "50" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "RE171" in row 1 has value "-100"
Then field "remge" from editor "RE171" in row 2 has value "-50"

Then field "remge" from editor "AU171" in row 1 has value "0"
Then "(Sales):(SalesOrder)" with the editor id "AU171" is filed

# Storno der gesplitteten RE
Given I open an editor "SRE171" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE171"
And I save the current editor

Then "(Sales):(SalesOrder)" with the editor id "AU171" is not filed
Then field "remge" from editor "AU171" in row 1 has value "150"

Scenario: Loeschen einer Rechnungsposition bei Rechnung aus Lieferschein

#    AU072
#    10 St.
#    | Aktion | remge |
#    |        | 10 St.|
#    |        | 10 St.|
#    | (1)    |  0 St.|
#    | (1)    |  0 St.|
#            \
#              ------ LS072 ---------------- RE072 ungebucht --------- 1. Zeile loeschen und buchen (3!)
#                     6 St. (1!)               8 St. und 5 St. (2!)
#                     | Aktion | remge |    | Aktion | remge |
#                     |        | 10 St.|    |        |  0 St.|
#                     |        | 10 St.|    |        |  0 St.|
#                     | (3)    | 10 St.|
#                     | (3)    |  5 St.|


Given I open an editor "AU072" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde | 1      |
   | such  | AU072  |
And I append rows
   | artikel | he     | mge |
   | A100    | Stueck | 10  |
   | A100    | Stueck | 10  |
And I save the current editor

# Pruefe remge in Auftrag
Then field "remge" from editor "AU072" in row 1 has value "10"

# Lieferschein aus Auftrag erzeugen
Given I open an editor "LS072" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU072"
And I set fields
   | such   | LS072 |
   | ueb    | true  |
   | fakt   | true  |
   | vom    | .     |
Then the table has 2 rows
And I set field "mge" to "10" in row 1
And I set field "mge" to "10" in row 2
And I save the current editor

# Pruefe remge in Auftrag
Then field "remge" from editor "AU072" in row 1 has value "0"
Then field "remge" from editor "AU072" in row 2 has value "0"
Then field "ablagef" from editor "AU072" in row 0 has value "ja"
# Pruefe remge in Lieferschein
Then field "remge" from editor "LS072" in row 1 has value "10"
Then field "remge" from editor "LS072" in row 1 has value "10"

# Rechnung zu Lieferschein noch nicht buchen
Given I open an editor "RE072" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS072"
And I set field "such" to "RE072"
And I set field "ueb" to "nein"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "mge" to "8" in row 1
And I set field "beleg" to id from editor "LS072"
And I set field "mge" to "5" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge in Auftrag
Then field "ablagef" from editor "AU072" in row 0 has value "ja"
# Pruefe remge in Lieferschein
Then field "remge" from editor "LS072" in row 1 has value "10"
Then field "refrg" from editor "LS072" in row 1 has value "8"
Then field "remge" from editor "LS072" in row 2 has value "10"
Then field "refrg" from editor "LS072" in row 2 has value "5"
# Pruefe remge in Rechnung
Then field "remge" from editor "RE072" in row 1 has value "10"
Then field "remge" from editor "RE072" in row 2 has value "10"

# 1. Zeile loeschen und Rechnung buchen
Given I open an editor "RE072" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE072"
And I set field "such" to "RE072"
And I set field "ueb" to "ja"
And I delete row at position 1
And I save the current editor

# Pruefe remge in Auftrag
Then field "ablagef" from editor "AU072" in row 0 has value "ja"
# Pruefe remge in Lieferschein
Then field "remge" from editor "LS072" in row 1 has value "10"
Then field "refrg" from editor "LS072" in row 1 has value "0"
Then field "remge" from editor "LS072" in row 2 has value "5"
Then field "refrg" from editor "LS072" in row 2 has value "0"

Scenario: Loeschen einer Rechnungsposition bei Rechnung aus Auftrag

#    AU073   -------------- RE073 ungebucht --------- 1. Zeile loeschen und buchen (3!)
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


Given I open an editor "AU073" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde | 1      |
   | such  | AU073  |
And I append rows
   | artikel | he     | mge |
   | A100    | Stueck | 10  |
   | A100    | Stueck | 10  |
And I save the current editor

# Pruefe remge in Auftrag
Then field "remge" from editor "AU073" in row 1 has value "10"

# Lieferschein LS073 aus Auftrag erzeugen
Given I open an editor "LS073" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU073"
And I set fields
   | such   | LS073 |
   | ueb    | true   |
   | fakt   | false  |
   | vom    | .      |
Then the table has 2 rows
And I set field "mge" to "10" in row 1
And I set field "mge" to "10" in row 2
And I save the current editor

# Pruefe remge in Auftrag
Then field "remge" from editor "AU073" in row 1 has value "10"
Then field "remge" from editor "AU073" in row 2 has value "10"
# Pruefe remge in Lieferschein A
Then field "remge" from editor "LS073" in row 1 has value "0"
Then field "remge" from editor "LS073" in row 1 has value "0"
Then field "ablagef" from editor "LS073" in row 0 has value "ja"

# Rechnung zu Lieferschein LS073 noch nicht buchen
Given I open an editor "RE073" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU073"
And I set field "such" to "RE073"
And I set field "ueb" to "nein"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "mge" to "8" in row 1
And I set field "beleg" to id from editor "AU073"
And I set field "mge" to "5" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefe remge in Lieferschein
Then field "ablagef" from editor "LS073" in row 0 has value "ja"
# Pruefe remge in Auftrag
Then field "remge" from editor "AU073" in row 1 has value "10"
Then field "refrg" from editor "AU073" in row 1 has value "8"
Then field "remge" from editor "AU073" in row 2 has value "10"
Then field "refrg" from editor "AU073" in row 2 has value "5"
# Pruefe remge in Storno-Lieferschein
Then field "remge" from editor "RE073" in row 1 has value "10"
Then field "remge" from editor "RE073" in row 2 has value "10"

# 1. Zeile loeschen und Rechnung buchen
Given I open an editor "RE073" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE073"
And I set field "such" to "RE073"
And I set field "ueb" to "ja"
And I delete row at position 1
And I save the current editor

# Pruefe remge in Lieferschein
Then field "ablagef" from editor "LS073" in row 0 has value "ja"
# Pruefe remge in Auftrag
Then field "remge" from editor "AU073" in row 1 has value "10"
Then field "refrg" from editor "AU073" in row 1 has value "0"
Then field "remge" from editor "AU073" in row 2 has value "5"
Then field "refrg" from editor "AU073" in row 2 has value "0"

Scenario: Remge im Fall gesplittete RE Pos vorm Buchen loeschen (RE aus AU ohne LB)
#
#  AU074 --------------------> RE074 (ungebucht) ---> RE074 (buchen. 1. Pos loeschen)
#  10 St.   (1!)               1 St. (Split) (2!)      (3!)
#  | Aktion | remge | refrg    2 St. (Split) (2!)
#  | (1)    | 10 St.|  0 St.
#  | (2)    | 10 St.|  3 St.
#  | (3)    |  8 St.|  0 St.
#
#

Given I create a SalesOrder "AU074" for Customer "1" with Product "V1" and quantity "10"

Then field "limge" from editor "AU074" in row 1 has value "10"
Then field "remge" from editor "AU074" in row 1 has value "10"

# Teilrechnung aus AU mit 2 Positionen erzeugen (ungebucht)
Given I open an editor "RE074" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU074"
And I set field "fakt" to "nein"
And I set field "mge" to "1" in row 1
And I set field "beleg" to id from editor "AU074"
And I set field "mge" to "2" in row 2
And I set field "such" to "RE074"
And I set field "vom" to "."
And I set field "tterm" to "."
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "AU074" in row 1 has value "10"
Then field "refrg" from editor "AU074" in row 1 has value "3"

# 1. Position aus Teilrechnung loeschen und Teilrechnung buchen
Given I open an editor "RE074" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE074"
And I delete row at position 1
And I set field "ueb" to "ja"
And I save the current editor

Then field "refrg" from editor "AU074" in row 1 has value "0"
Then field "remge" from editor "AU074" in row 1 has value "8"


Scenario: Remge im Fall gesplittete RE Pos vorm Buchen loeschen
#
#  AU075 ---------------> LS075 ----------------------> RE075 (ungebucht) ---> RE075 (buchen. 1. Pos loeschen)
#  10 St.   (1!)          10 St. (2!)                  1 St. (Split) (3!)      (4!)
#  | Aktion | remge       | Aktion | remge   | refrg   2 St. (Split) (3!)
#  | (1)    | 10 St.      | (2)    |  10 St. |  0 St.
#  | (2)    |  0 St.      | (3)    |  10 St. |  3 St.
#                         | (4)    |   8 St. |  0 St.
#

Given I create a SalesOrder "AU262" for Customer "1" with Product "V1" and quantity "10"

Then field "limge" from editor "AU262" in row 1 has value "10"
Then field "remge" from editor "AU262" in row 1 has value "10"

# LS aus AU
Given I deliver the SalesOrder "AU262" with PackingSlip "LS262"

Then field "limge" from editor "AU262" in row 1 has value "0"
Then field "remge" from editor "AU262" in row 1 has value "0"

Then field "remge" from editor "LS262" in row 1 has value "10"
Then field "refrg" from editor "LS262" in row 1 has value "0"

# Teilrechnung aus Lieferschein mit 2 Positionen erzeugen (ungebucht)
Given I open an editor "RE262" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS262"
And I set field "mge" to "1" in row 1
And I set field "beleg" to id from editor "LS262"
And I set field "mge" to "2" in row 2
And I set field "such" to "RE262"
And I set field "vom" to "."
And I set field "tterm" to "."
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "LS262" in row 1 has value "10"
Then field "refrg" from editor "LS262" in row 1 has value "3"

# 1. Position aus Teilrechnung loeschen und Teilrechnung buchen
Given I open an editor "RE262" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE262"
And I delete row at position 1
And I set field "ueb" to "ja"
And I save the current editor

Then field "refrg" from editor "LS262" in row 1 has value "0"
Then field "remge" from editor "LS262" in row 1 has value "8"


Scenario: Remge bei gesplitteten Positionen bei RE aus AU + RE Storno
#
#  AU161 ------------------> RE161 -----------------------> SRE161 (4!)
#  150 St.   (1!)      \     100 St. split (2!)
#  | Aktion | remge     \     40 St. V2    (2!)
#  | (1)    | 150 St.    \   | Aktion | remge
#  | (2)    |  10 St.     \  | (2)    |   0 St.
#  | (3)    |   0 St.      \
#  | (4) V2 | 140 St.       \
#                            -------> RE161B
#                                     10 St. (3!)
#

# AU
Given I create a SalesOrder "AU075" for Customer "1" with Product "V1" and quantity "150"
Then field "remge" from editor "AU075" in row 1 has value "150"

# RE ohne LB mit Split
Given I open an editor "RE075" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU075"
And I set fields
| such   | RE075  |
| ueb    | ja     |
| vom    | .      |
| tterm  | .      |
| fakt   | nein   |
And I set field "mge" to "100" in row 1
And I set field "beleg" to id from editor "AU075"
And I set field "mge" to "40" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "AU075" in row 1 has value "10"
Then "(Sales):(SalesOrder)" with the editor id "AU075" is not filed

# RE REST
Given I open an editor "RE075B" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU075"
And I set fields
| such   | RE075B |
| ueb    | ja     |
| vom    | .      |
| tterm  | .      |
And I press button "offueb" in row 1
Then table has values
| artikel | mge |
| V1      | 10  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "AU075" in row 1 has value "0"
# Alle Lieferungen stehen noch aus
Then "(Sales):(SalesOrder)" with the editor id "AU075" is not filed

# Storno der gesplitteten RE
Given I open an editor "SRE075" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE075"
And I save the current editor

Then field "remge" from editor "AU075" in row 1 has value "140"
Then "(Sales):(SalesOrder)" with the editor id "AU075" is not filed


Scenario: Remge bei gesplitteten Positionen bei RE aus AU + RE Storno
#
#  AU076 ------------------> RE076 ----------------------------------------> SRE076 (6!)
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

# AU
Given I create a SalesOrder "AU076" for Customer "1" with Product "V1" and quantity "150"
Then field "remge" from editor "AU076" in row 1 has value "150"

# RE ohne LB mit Split
Given I open an editor "RE076" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU076"
And I set fields
| such   | RE076  |
| ueb    | ja     |
| vom    | .      |
| tterm  | .      |
| fakt   | nein   |
And I set field "mge" to "100" in row 1
And I set field "beleg" to id from editor "AU076"
And I set field "mge" to "40" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "AU076" in row 1 has value "10"
Then "(Sales):(SalesOrder)" with the editor id "AU076" is not filed

# RE REST
Given I open an editor "RE076B" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU076"
And I set fields
| such   | RE076B |
| ueb    | ja     |
| vom    | .      |
| tterm  | .      |
And I press button "offueb" in row 1
Then table has values
| artikel | mge |
| V1      | 10  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "AU076" in row 1 has value "0"
# Alle Lieferungen stehen noch aus
Then "(Sales):(SalesOrder)" with the editor id "AU076" is not filed

# LS komplett
Given I open an editor "LS076" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU076"
And I set fields
| such   | LS076  |
| ueb    | ja     |
| vom    | .      |
| tterm  | .      |
And I set field "mge" to "150" in row 1
And I save the current editor

Then field "remge" from editor "RE076B" in row 2 has value "0"

Then field "remge" from editor "RE076" in row 3 has value "0"

Then field "remge" from editor "AU076" in row 1 has value "0"
Then field "remge" from editor "AU076" in row 2 has value "0"
Then "(Sales):(SalesOrder)" with the editor id "AU076" is filed

# RLS komplett
Given I open an editor "RLS076" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS076"
And I set fields
| such   | RLS061 |
| ueb    | ja     |
And I set field "mge" to "-150" in row 1
And I set field "platz" to "F1" in row 1
And I save the current editor

Then field "remge" from editor "RLS076" in row 1 has value "-150"
Then field "remge" from editor "RLS076" in row 2 has value "-150"

Then field "remge" from editor "AU076" in row 1 has value "0"

# Storno der gesplitteten RE
Given I open an editor "SRE076" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE076"
And I save the current editor

Then field "remge" from editor "RLS076" in row 1 has value "-10"

Then field "remge" from editor "AU076" in row 1 has value "140"
Then "(Sales):(SalesOrder)" with the editor id "AU076" is not filed

# KGS ueber 10 noch moeglich
Given I open an editor "KGS076" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS076"
And I set fields
| such   | KGS076  |
| ueb    | ja      |
| vom    | .       |
| tterm  | .       |
And I set field "mge" to "-10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "RLS076" in row 1 has value "0"
Then "(Sales):(PackingSlip)" with the editor id "RLS076" is filed
Then "(Sales):(SalesOrder)" with the editor id "AU076" is not filed

#----------------------------------------------------------------------------------------------
# Ablagestatus des Liefervorgangs bei offenen Ruecklieferungen
#----------------------------------------------------------------------------------------------

Scenario: Ablagestatus des Liefervorgangs - Nicht fakturierbarer Lieferschein

# Auftrag
Given I open an editor "AU077" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU077  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferung
Given I open an editor "LS077" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU077"
And I set fields
   | such   | LS077  |
   | fakt   | nein   |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS077" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS077"
And I set fields
   | such   | RLS077 |
   | vom    | .      |
And I set field "mge" to "-10" in row 1
And I save the current editor

Then "(Sales):(PackingSlip)" with the editor id "LS077" is filed

# Rueckliefschein buchen
Given I open an editor "RLS077" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "RLS077"
And I set fields
   | ueb    | ja     |
And I save the current editor

Then "(Sales):(PackingSlip)" with the editor id "LS077" is filed

Scenario: Ablagestatus des Liefervorgangs - Fakturierbarer Lieferschein

# Auftrag
Given I open an editor "AU078" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU078  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferung
Given I open an editor "LS078" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU078"
And I set fields
   | such   | LS078  |
   | fakt   | ja     |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE078" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS078"
And I set fields
   | such   | RE078  |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I set field "preis" to "100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS078" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS078"
And I set fields
   | such   | RLS078 |
   | vom    | .      |
And I set field "mge" to "-10" in row 1
And I save the current editor

Then "(Sales):(PackingSlip)" with the editor id "LS078" is filed

# Rueckliefschein buchen
Given I open an editor "RLS078" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "RLS078"
And I set fields
   | ueb    | ja     |
And I save the current editor

Then "(Sales):(PackingSlip)" with the editor id "LS078" is filed

Scenario: Ablagestatus des Liefervorgangs - Rechnung mit Lagerbewegung

# Auftrag
Given I open an editor "AU079" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU079  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Rechnung
Given I open an editor "RE079" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU079"
And I set fields
   | such   | RE079  |
   | fakt   | ja     |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I set field "preis" to "100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS079" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "RE079"
And I set fields
   | such   | RLS079 |
   | vom    | .      |
And I set field "mge" to "-10" in row 1
And I save the current editor

Then "(Sales):(Invoice)" with the editor id "RE079" is filed

# Rueckliefschein buchen
Given I open an editor "RLS079" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "RLS079"
And I set fields
   | ueb    | ja     |
And I save the current editor

Then "(Sales):(Invoice)" with the editor id "RE079" is filed

#----------------------------------------------------------------------------------------------
# Aktualisierung der offenen Mengen bei parallelen Gutschriften
#----------------------------------------------------------------------------------------------

Scenario: Offene Gutschriften I

# AU080 --- RE080A
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
Given I open an editor "AU080" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU080  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 30  |
And I save the current editor

# Rechnung 1
Given I open an editor "RE080A" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU080"
And I set fields
   | such   | RE080A |
   | fakt   | nein   |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I set field "preis" to "100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung 2
Given I open an editor "RE080B" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU080"
And I set fields
   | such   | RE080B |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I set field "preis" to "200" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferung
Given I open an editor "LS080" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU080"
And I set fields
   | such   | LS080  |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

# Ruecklieferung 1
Given I open an editor "RLS080A" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS080"
And I set fields
   | such   | RLS080A |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "-15" in row 1
And I save the current editor

# Ruecklieferung 2
Given I open an editor "RLS080B" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS080"
And I set fields
   | such   | RLS080B |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "-15" in row 1
And I save the current editor

Scenario: Offene Gutschriften I - Gutschrift

# Gutschrift
Given I open an editor "KGS080A" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS080A"
And I set field "such" to "KGS080A"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "beleg" to "RLS080B"
And I set field "mge" to "-8" in row 1
And I set field "mge" to "-4" in row 2
And I set field "mge" to "-4" in row 4
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RLS080A" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS080A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS080B" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS080B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS080A" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS080A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften I - Positionen aendern, loeschen und neu anfuegen

Given I open an editor "KGS080A" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS080A"
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

Given I open an editor "RLS080A" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS080A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS080B" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS080B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS080A" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS080A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften I - Einzelne Position loeschen und neu anfuegen

Given I open an editor "KGS080A" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS080A"
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

Given I open an editor "RLS080A" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS080A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS080B" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS080B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS080A" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS080A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften I - Einzelne Position loeschen und neu anfuegen II

Given I open an editor "KGS080A" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS080A"
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

Given I open an editor "RLS080A" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS080A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS080B" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS080B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS080A" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS080A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften I - Gutschrift buchen

Given I open an editor "KGS080A" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS080A"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "RLS080A" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS080A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS080B" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS080B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS080A" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS080A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften I - Gutschrift stornieren

Given I open an editor "KGS080A" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "KGS080A"
And I save the current editor

Given I open an editor "RLS080A" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS080A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS080B" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS080B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS080A" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS080A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften II

# AU081 --- RE081A
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
Given I open an editor "AU081" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU081  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 30  |
And I save the current editor

# Rechnung 1
Given I open an editor "RE081A" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU081"
And I set fields
   | such   | RE081A |
   | fakt   | nein   |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I set field "preis" to "100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung 2
Given I open an editor "RE081B" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU081"
And I set fields
   | such   | RE081B |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I set field "preis" to "200" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferung 1
Given I open an editor "LS081A" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU081"
And I set fields
   | such   | LS081A |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "15" in row 1
And I save the current editor

# Lieferung 2
Given I open an editor "LS081B" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU081"
And I set fields
   | such   | LS081B |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "15" in row 1
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS081A" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS081A"
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
Given I open an editor "KGS081A" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS081A"
And I set fields
   | such   | KGS081A |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | nein    |
And I set field "such" to "KGS081A"
And I set field "mge" to "-8" in row 1
And I set field "mge" to "-4" in row 2
And I set field "mge" to "-4" in row 4
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RLS081A" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS081A" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften II - Positionen aendern, loeschen und neu anfuegen

Given I open an editor "KGS081A" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS081A"
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

Given I open an editor "RLS081A" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS081A" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften II - Einzelne Position loeschen und neu anfuegen

Given I open an editor "KGS081A" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS081A"
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

Given I open an editor "RLS081A" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS081A" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften II - Einzelne Position loeschen und neu anfuegen II

Given I open an editor "KGS081A" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS081A"
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

Given I open an editor "RLS081A" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS081A" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften II - Gutschrift buchen

Given I open an editor "KGS081A" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS081A"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "RLS081A" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS081A" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften II - Gutschrift stornieren

Given I open an editor "KGS081A" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "KGS081A"
And I save the current editor

Given I open an editor "RLS081A" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS081A" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS081A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften III - Parallele Gutschriften

#  AU082 ---------------- RE082A (gebucht)
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
Given I open an editor "AU082" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU082  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 30  |
And I save the current editor

# Rechnung 1
Given I open an editor "RE082A" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU082"
And I set fields
   | such   | RE082A |
   | fakt   | nein   |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I set field "preis" to "100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung 2
Given I open an editor "RE082B" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU082"
And I set fields
   | such   | RE082B |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I set field "preis" to "200" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferung
Given I open an editor "LS082" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU082"
And I set fields
   | such   | LS082  |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

# Ruecklieferung 1
Given I open an editor "RLS082A" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS082"
And I set fields
   | such   | RLS082A |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "-15" in row 1
And I save the current editor

# Ruecklieferung 2
Given I open an editor "RLS082B" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS082"
And I set fields
   | such   | RLS082B |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "-15" in row 1
And I save the current editor

Scenario: Offene Gutschriften III - Gutschrift

# Gutschrift 1
Given I open an editor "KGS082A" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS082A"
And I set field "such" to "KGS082A"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "mge" to "-5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Gutschrift 2
Given I open an editor "KGS082B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS082B"
And I set field "such" to "KGS082B"
And I set field "vom" to "."
And I set field "tterm" to "."
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RLS082A" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS082B" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS082A" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS082B" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften III - Mengenaenderungen

Given I open an editor "KGS082A" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS082A"
And I set field "mge" to "-1" in row 1
And I set field "mge" to "-1" in row 2
And I save the current editor

Given I open an editor "KGS082B" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS082B"
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

Given I open an editor "RLS082A" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS082B" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS082A" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS082B" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften III - Mengenaenderungen II

Given I open an editor "KGS082B" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS082B"
And I set field "mge" to "-5" in row 1
And I set field "mge" to "-5" in row 2
And I save the current editor

Given I open an editor "KGS082A" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS082A"
And I delete row at position 5
And I delete row at position 4
And I delete row at position 3
And I set field "beleg" to "RLS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "KGS082A" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS082A"
And I delete all rows
And I set field "beleg" to "RLS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario: Offene Gutschriften III - Mengenaenderungen II, persistenter Zustand

Given I open an editor "RLS082A" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS082B" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS082A" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS082B" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften III - Gutschrift buchen

Given I open an editor "KGS082A" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS082A"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "RLS082A" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS082B" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS082A" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS082B" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften III - Gutschrift buchen II

Given I open an editor "KGS082B" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS082B"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "RLS082A" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS082B" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS082A" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS082B" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften III - Gutschrift stornieren

Given I open an editor "KGS082A" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "KGS082A"
And I save the current editor

Given I open an editor "RLS082A" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS082B" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS082A" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS082A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS082B" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS082B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften IV - Wie III, aber mit unterschiedlichen Einheiten.

#  AU083 ---------------- RE083A (gebucht)
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
Given I open an editor "AU083" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU083  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 30  |
And I save the current editor

# Rechnung 1
Given I open an editor "RE083A" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU083"
And I set fields
   | such   | RE083A |
   | fakt   | nein   |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I set field "preis" to "100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung 2
Given I open an editor "RE083B" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU083"
And I set fields
   | such   | RE083B |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I set field "preis" to "200" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferung
Given I open an editor "LS083" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU083"
And I set fields
   | such   | LS083  |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

# Ruecklieferung 1
Given I open an editor "RLS083A" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS083"
And I set fields
   | such   | RLS083A |
   | vom    | .       |
   | ueb    | ja      |
And I set field "he" to "kg" in row 1
And I set field "mge" to "-30" in row 1
And I save the current editor

# Ruecklieferung 2
Given I open an editor "RLS083B" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS083"
And I set fields
   | such   | RLS083B |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "-15" in row 1
And I save the current editor

Scenario: Offene Gutschriften IV - Gutschrift

# Gutschrift 1
Given I open an editor "KGS083A" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS083A"
And I set field "such" to "KGS083A"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "mge" to "-10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Gutschrift 2
Given I open an editor "KGS083B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS083B"
And I set field "such" to "KGS083B"
And I set field "vom" to "."
And I set field "tterm" to "."
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RLS083A" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS083A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS083B" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS083B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS083A" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS083A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS083B" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS083B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften IV - Mengenaenderungen

Given I open an editor "KGS083A" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS083A"
And I set field "mge" to "-2" in row 1
And I set field "mge" to "-2" in row 2
And I save the current editor

Given I open an editor "KGS083B" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS083B"
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

Given I open an editor "RLS083A" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS083A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS083B" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS083B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS083A" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS083A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS083B" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS083B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Offene Gutschriften IV - Mengenaenderungen II

Given I open an editor "KGS083B" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS083B"
And I set field "mge" to "-5" in row 1
And I set field "mge" to "-5" in row 2
And I save the current editor

Given I open an editor "KGS083A" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS083A"
And I delete row at position 5
And I delete row at position 4
And I delete row at position 3
And I set field "beleg" to "RLS083A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "KGS083A" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS083A"
And I delete all rows
And I set field "beleg" to "RLS083A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario: Offene Gutschriften IV - Mengenaenderungen II, persistenter Zustand

Given I open an editor "RLS083A" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS083A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "RLS083B" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS083B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS083A" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS083A"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Given I open an editor "KGS083B" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS083B"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

#----------------------------------------------------------------------------------------------
# Restmengenstorno im Lieferschein
#----------------------------------------------------------------------------------------------

Scenario: Restmengenstorno im Lieferschein

# Auftrag
Given I open an editor "1AU090" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU090 |
   | kunde  | 1      |
   | such   | AU090  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferschein
Given I open an editor "1LS090" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU090"
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
Given I open an editor "1LS090S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "1LS090"
And I set fields
   | nummer | 1LS090S |
And I save the current editor

Given I open an editor "1AU090" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU090"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I press button "absteig" to open a subeditor for "AFL" in row 1
Then I fill template "EV_VORG_AFL.ftl" and append it to output file "offene_mengen.out"
And I close the current editor
And I switch the current editor to editor "1AU090"
And I close the current editor

#----------------------------------------------------------------------------------------------
# Lieferscheinstorno nach Ueberbelieferung
#----------------------------------------------------------------------------------------------

Scenario: Lieferscheinstorno nach Ueberbelieferung

# Auftrag
Given I open an editor "1AU095" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU095 |
   | kunde  | 1      |
   | such   | AU095  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 100 |
And I save the current editor

# Teillieferung
Given I open an editor "1LS095" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU095"
And I set fields
   | nummer | 1LS095  |
   | such   | LS095-1 |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "80" in row 1
And I save the current editor

# Teillieferung
Given I open an editor "2LS095" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU095"
And I set fields
   | nummer | 2LS095  |
   | such   | LS095-2 |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "30" in row 1
And I save the current editor

# Disposition
And I run Scheduling
# Auftrag und Reservierung pruefen
Given I open an editor "1AU095" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU095"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor
Given I query "elex,limge,einplan,status" from table "(Purchasing):(Reservations)" where "@ablageart=beides;verw=1AU095_1"
Then query has values
   | elex | limge | einplan | status |
   | A100 | -10   | nein    | *      |

# Storno Lieferschein
Given I open an editor "2LS095S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "2LS095"
And I set fields
   | nummer | 1LS095S |
And I save the current editor

# Auftrag und Reservierung pruefen
Given I open an editor "1AU095" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU095"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor
Given I query "elex,limge,einplan,status" from table "(Purchasing):(Reservations)" where "@ablageart=beides;verw=1AU095_1"
Then query has values
   | elex | limge | einplan | status |
   | A100 | 20    | nein    | *      |

# Disposition
And I run Scheduling

# Auftrag und Reservierung pruefen
Given I open an editor "1AU095" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU095"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor
Given I query "elex,limge,einplan,status" from table "(Purchasing):(Reservations)" where "@ablageart=beides;verw=1AU095_1"
Then query has values
   | elex | limge | einplan | status |
   | A100 | 20    | ja      |        |

Scenario: Lieferscheinstorno nach Ueberbelieferung, mehrfaches Anfuegen von Belegen

# Auftrag
Given I open an editor "1AU096" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU096 |
   | kunde  | 1      |
   | such   | AU096  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 100 |
And I save the current editor

# Lieferung
Given I open an editor "1LS096" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU096"
And I set fields
   | nummer | 1LS096 |
   | such   | LS096  |
   | vom    | .      |
   | ueb    | nein   |
And I set field "mge" to "80" in row 1
And I save the current editor

Given I open an editor "1LS096" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "1LS096"
And I set field "ueb" to "ja"
And I set field "beleg" to id from editor "1AU096"
And I set field "mge" to "70" in row 3
And I save the current editor

# Storno Lieferschein
Given I open an editor "1LS096S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "1LS096"
And I set fields
   | nummer | 1LS096S |
And I save the current editor

Given I open an editor "1AU096" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU096"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I press button "absteig" to open a subeditor for "AFL" in row 1
Then I fill template "EV_VORG_AFL.ftl" and append it to output file "offene_mengen.out"
And I close the current editor
And I switch the current editor to editor "1AU096"
And I close the current editor

Scenario: Lieferscheinstorno nach Ueberbelieferung, mehrfaches Anfuegen von Belegen II

# Auftrag
Given I open an editor "1AU097" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU097 |
   | kunde  | 1      |
   | such   | AU097  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 100 |
And I save the current editor

# Lieferung
Given I open an editor "1LS097" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU097"
And I set fields
   | nummer | 1LS097 |
   | such   | LS097  |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "120" in row 1
And I set field "beleg" to id from editor "1AU097"
And I set field "mge" to "30" in row 2
And I save the current editor

# Storno Lieferschein
Given I open an editor "1LS097S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "1LS097"
And I set fields
   | nummer | 1LS097S |
And I save the current editor

Given I open an editor "1AU097" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU097"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I press button "absteig" to open a subeditor for "AFL" in row 1
Then I fill template "EV_VORG_AFL.ftl" and append it to output file "offene_mengen.out"
And I close the current editor
And I switch the current editor to editor "1AU097"
And I close the current editor

#----------------------------------------------------------------------------------------------
# Ueberbelieferung bei lieferseitigem Abschluss, getrenntes Fakturieren
#----------------------------------------------------------------------------------------------

Scenario: Ueberbelieferung bei lieferseitigem Abschluss, getrenntes Fakturieren

# Auftrag
Given I open an editor "1AU098" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU098 |
   | kunde  | 1      |
   | such   | AU098  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 100 |
And I save the current editor

# Erste Lieferung
Given I open an editor "1LS098" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU098"
And I set fields
   | nummer | 1LS098  |
   | such   | LS098-1 |
   | vom    | .       |
   | fakt   | nein    |
   | ueb    | nein    |
And I set field "mge" to "80" in row 1
And I save the current editor

# Zweite Lieferung
Given I open an editor "2LS098" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU098"
And I set fields
   | nummer | 2LS098  |
   | such   | LS098-2 |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "20" in row 1
And I save the current editor

# Ueberbelieferung erste Lieferung
Given I open an editor "1LS098" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "1LS098"
And I set field "ueb" to "ja"
And I set field "mge" to "100" in row 1
And I save the current editor

Given I open an editor "1AU098" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU098"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

#----------------------------------------------------------------------------------------------
# Lieferung aus abgelegtem Auftrag
#----------------------------------------------------------------------------------------------

Scenario: Lieferung aus abgelegtem Auftrag

# Auftrag
Given I open an editor "1AU110" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU110 |
   | kunde  | 1      |
   | such   | BE110  |
And I append rows
   | artikel | he    | mge  |
   | A100    | Stück | 1000 |
And I save the current editor

# Erste Lieferung
Given I open an editor "1LS110" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU110"
And I set fields
   | nummer | 1LS110  |
   | such   | LS110-1 |
   | vom    | .       |
   | fakt   | ja      |
   | ueb    | ja      |
And I set field "mge" to "1200" in row 1
And I save the current editor

# Zweite Lieferung
Given I open an editor "2LS110" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU110"
And I set fields
   | nummer | 2LS110  |
   | such   | LS110-2 |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "900" in row 1
And I save the current editor

Given I open an editor "1AU110" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU110"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Storno der ersten Lieferung
Given I open an editor "1LS110S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "1LS110"
And I set field "nummer" to "1LS110S"
And I save the current editor

Given I open an editor "1AU110" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU110"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Rechnung zur zweiten Lieferung
Given I open an editor "2RE110" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "2LS110"
And I set fields
   | nummer | 2RE110  |
   | such   | RE110-2 |
   | ueb    | ja      |
   | vom    | .       |
   | tterm  | .       |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "1AU110" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU110"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

Scenario: Lieferung aus abgelegtem Auftrag II

# Auftrag
Given I open an editor "1AU111" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU111 |
   | kunde  | 1      |
   | such   | BE111  |
And I append rows
   | artikel | he    | mge  |
   | A100    | Stück | 1000 |
And I save the current editor

# Erste Lieferung
Given I open an editor "1LS111" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU111"
And I set fields
   | nummer | 1LS111  |
   | such   | LS111-1 |
   | vom    | .       |
   | fakt   | nein    |
   | ueb    | ja      |
And I set field "mge" to "600" in row 1
And I save the current editor

# Rechnung zur ersten Lieferung
Given I open an editor "1RE111" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU111"
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
Given I open an editor "2LS111" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU111"
And I set fields
   | nummer | 2LS111  |
   | such   | LS111-2 |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "800" in row 1
And I save the current editor

# Dritte Lieferung
Given I open an editor "3LS111" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU111"
And I set fields
   | nummer | 3LS111  |
   | such   | LS111-3 |
   | vom    | .       |
   | fakt   | ja      |
   | ueb    | ja      |
And I set field "mge" to "900" in row 1
And I save the current editor

Given I open an editor "1AU111" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU111"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

# Storno der ersten Lieferung
Given I open an editor "1LS111S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "1LS111"
And I set field "nummer" to "1LS111S"
And I save the current editor

Given I open an editor "1AU111" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU111"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

#----------------------------------------------------------------------------------------------
# Teillieferungen mit Ueberbelieferung, Storno erste Teillieferung
#----------------------------------------------------------------------------------------------

Scenario: Teillieferungen mit Ueberbelieferung, Storno erste Teillieferung

# Auftrag
Given I open an editor "1AU112" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU112 |
   | kunde  | 1      |
   | such   | AU112  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
And I save the current editor

# Erste Lieferung
Given I open an editor "1LS112" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU112"
And I set fields
   | nummer | 1LS112  |
   | such   | LS112-1 |
   | vom    | .       |
   | fakt   | ja      |
   | ueb    | ja      |
And I set field "mge" to "5" in row 1
And I save the current editor

# Zweite Lieferung
Given I open an editor "2LS112" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU112"
And I set fields
   | nummer | 2LS112  |
   | such   | LS112-2 |
   | vom    | .       |
   | fakt   | ja      |
   | ueb    | ja      |
And I set field "mge" to "6" in row 1
And I save the current editor

# Storno erste Lieferung
Given I open an editor "1LS112" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "1LS112"
And I set fields
   | nummer | 1LS112S |
And I save the current editor

Given I open an editor "1AU112" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU112"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

#----------------------------------------------------------------------------------------------
# Lieferung Auftrag, Lieferschein speichern, Lieferposition loeschen, buchen
#----------------------------------------------------------------------------------------------

Scenario: Lieferung Auftrag, Lieferschein speichern, Lieferposition loeschen, buchen

# Auftrag
Given I open an editor "1AU113" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU113 |
   | kunde  | 1      |
   | such   | AU113  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
   | A100    | Stück | 10  |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferung
Given I open an editor "1LS113" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU113"
And I set fields
   | nummer | 1LS113  |
   | such   | LS113-1 |
   | vom    | .       |
   | fakt   | ja      |
   | ueb    | ja      |
And I set field "mge" to "5" in row 3
And I save the current editor

# Lieferung
Given I open an editor "2LS113" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU113"
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
Given I open an editor "2LS113" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "2LS113"
And I set field "ueb" to "ja"
And I delete row at position 2
And I delete row at position 2
And I save the current editor

Given I open an editor "1AU113" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU113"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

#----------------------------------------------------------------------------------------------
# Lieferung Auftrag, Lieferposition loeschen, buchen
#----------------------------------------------------------------------------------------------

Scenario: Lieferung Auftrag, Lieferschein speichern, Lieferposition loeschen, buchen

# Auftrag
Given I open an editor "1AU114" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU114 |
   | kunde  | 1      |
   | such   | AU114  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 10  |
   | A100    | Stück | 10  |
   | A100    | Stück | 10  |
And I save the current editor

# Lieferung
Given I open an editor "1LS114" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU114"
And I set fields
   | nummer | 1LS114  |
   | such   | LS114-1 |
   | vom    | .       |
   | fakt   | ja      |
   | ueb    | ja      |
And I set field "mge" to "5" in row 3
And I save the current editor

# Lieferung
Given I open an editor "1LS114" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU114"
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

Given I open an editor "1AU114" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU114"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "offene_mengen.out"
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Lieferposition mit MZ (Einheit MZ ungleich Einheit Pos.), Rechnung aus LS
#----------------------------------------------------------------------------------------------

# Artikel anlegen
Given I open an editor "A200" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | num2   | 200A             |
   | such   | A200             |
   | bsart  | Fremdbeschaffung |
   | dispoa | bedarfsbezogen   |
   | vpr    |  150             |
   | lief   |    1             |
   | epr    |   90             |
   | vhe    |   m²             |
   | fvhe   | 1,15             |
   | le     |    m             |
   | fvhle  |   1              |
   | fvpe   | 1,15             |
   | vpe    |   m²             |
   | fvple  |   1              |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "1LS115" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1LS115 |
   | kunde  | 1      |
   | such   | LS115  |
   | vom    | .      |
   | ueb    | ja     |
   | zbed   | 200    |
And I append rows
   | artikel | mge | he |
   |    A200 |   1 | m² |
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I set field "zuomge" to "36,45" in row 1
And I set field "einh" to "m" in row 1
And I save the current editor
And I switch the current editor to editor "1LS115"
And field "mge" has value "41.918" in row 1
And I save the current editor

# Rechnung aus Lieferschein erzeugen
Given I open an editor "1RE115" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS115"
And field "ofmge" has value "0" in row 1
And I close the current editor

# Rechnung mit Beleg anfuegen erzeugen
Given I open an editor "1RE115" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS115"
Then field "ofmge" has value "0" in row 1
And I set field "mge" to "1,001" in row 1
And I set field "beleg" to id from editor "1LS115"
Then field "ofmge" has value "40.917" in row 2
And I press button "offueb" in row 2
Then field "ofmge" has value "0" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein ohne MZ anlegen
Given I open an editor "1LS116" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1LS116 |
   | kunde  | 1      |
   | such   | LS116  |
   | vom    | .      |
   | ueb    | ja     |
   | zbed   | 200    |
And I append rows
   | artikel | mge    | he |
   |    A200 | 41.918 | m² |
And I save the current editor

# Rechnung aus Lieferschein erzeugen
Given I open an editor "1RE116" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS116"
Then field "ofmge" has value "0" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


#----------------------------------------------------------------------------------------------
Scenario: VK - Auftrag mit Zusatzposition, LS mit negativer Menge, Storno LS, Rechnungsobligo nicht moeglich
#----------------------------------------------------------------------------------------------
# Auftrag
Given I open an editor "AU201" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU201 |
   | kunde  | 1      |
   | such   | AU201  |
And I append rows
   | artikel | mge |
   | AUBE    |  20 |
   | A100    |  10 |
And I save the current editor

# Lieferschein aus Auftrag erzeugen
Given I open an editor "VKLS201" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU201"
And I set fields
   | nummer | 1VKLS201 |
   | such   | VKLS201  |
   | ueb    | true     |
   | vom    | .        |
Then the table has 2 rows
And I set field "mge" to "-6" in row 1
And I set field "mge" to "7" in row 2
And I save the current editor

# Lieferschein stornieren
Given I open an editor "SVKLS201" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "VKLS201"
Then field "remge" has value "0" in row 1
And I save the current editor
# LS geht in die Ablage
Then "(Sales):(PackingSlip)" with the editor id "SVKLS201" is filed
Then field "remge" has value "0" in row 1

#----------------------------------------------------------------------------------------------
Scenario: Restmengenstorno in neutraler Position bei Ueberberechnung
#----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU202" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1AU202 |
	| kunde  | 1      |
And I append rows
	| artikel | mge         | preis      | pwert       |
	| A100    | 10          | 10         | !dontChange |
	| NEUTRAL | !dontChange |!dontChange | 20          |
And I save the current editor

# Lieferschein aus Auftrag erzeugen
Given I open an editor "1LS202" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU202"
And I set fields
	| nummer | 1LS202 |
	| vom    | .      |
	| ueb    | ja     |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung aus Lieferschein erzeugen
Given I open an editor "1RE202" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS202"
And I set fields
	| nummer | 1RE202 |
	| ueb    | ja     |
	| tterm  | .      |
And I set field "pwert" to "25" in row 2
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then "(Sales):(PackingSlip)" with the editor id "1LS202" is filed

#----------------------------------------------------------------------------------------------
Scenario: VK - AU mit Text-Position -> LS -> RE -> Storno der Rechnung: Lieferschein nicht mehr in der Ablage
#----------------------------------------------------------------------------------------------
# Auftrag
Given I open an editor "AU203" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde | 1      |
   | such  | AU203  |
And I append rows
   | artikel | he          | mge         | pwert |
   | TEXT    | !dontChange | !dontChange | 0     |
   | V1      | Stück       | 10          | 203   |
And I save the current editor

# Lieferschein
Given I open an editor "LS203" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU203"
And I set fields
   | such   | LS203 |
   | ueb    | true  |
   | fakt   | true  |
   | vom    | .     |
Then the table has 2 rows
And I set field "mge" to "203" in row 2
And I save the current editor

# Rechnung
Given I open an editor "RE203" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS203"
And I set fields
   | such   | RE203 |
   | ueb    | true  |
   | vom    | .     |
   | tterm  | .     |
Then the table has 2 rows
And I set field "mge" to "203" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung stornieren
Given I open an editor "SRE203" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE203"
And I save the current editor
Then field "remge" from editor "LS203" in row 1 has value "0"
Then field "remge" from editor "LS203" in row 2 has value "203"
Then "(Sales):(PackingSlip)" with the editor id "LS203" is not filed

#----------------------------------------------------------------------------------------------
Scenario: VK - AU mit neutraler Position -> LS -> RE -> Storno der Rechnung: Lieferschein nicht mehr in der Ablage
#----------------------------------------------------------------------------------------------
# Auftrag
Given I open an editor "AU204" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde | 1      |
   | such  | AU204  |
And I append rows
   | artikel | he          | mge         | pwert |
   | NEUTRAL | !dontChange | !dontChange | 0     |
   | V1      | Stück       | 10          | 204   |
And I save the current editor

# Lieferschein
Given I open an editor "LS204" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU204"
And I set fields
   | such   | LS204 |
   | ueb    | true  |
   | fakt   | true  |
   | vom    | .     |
Then the table has 2 rows
And I set field "mge" to "204" in row 2
And I save the current editor

# Rechnung
Given I open an editor "RE204" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS204"
And I set fields
   | such   | RE204 |
   | ueb    | true  |
   | vom    | .     |
   | tterm  | .     |
Then the table has 2 rows
And I set field "mge" to "204" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung stornieren
Given I open an editor "SRE204" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE204"
And I save the current editor
Then field "remge" from editor "LS204" in row 1 has value "0"
Then field "remge" from editor "LS204" in row 2 has value "204"
Then "(Sales):(PackingSlip)" with the editor id "LS204" is not filed

#----------------------------------------------------------------------------------------------
Scenario: VK - LS -> RLS mit neutraler Position und zwei Artikelpositionen -> RE -> KGS zu RLS: Ruecklieferschein in der Ablage
#----------------------------------------------------------------------------------------------

# Lieferschein
Given I open an editor "LS206VK" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde  | 1       |
   | such   | LS206VK |
   | nummer | 1LS206  |
   | ueb    | true    |
   | vom    | .       |
And I append rows
   | artikel | he    | mge |
   | V1      | Stück | 5   |
   | V2      | Stück | 10  |
And I save the current editor

# RLS: neutrale Position an erste Stelle einfuegen
Given I open an editor "RLS206" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS206VK"
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
Then "(Sales):(PackingSlip)" with the editor id "RLS206" is filed

# Rechnung
Given I open an editor "RE206VK" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS206VK"
And I set fields
   | such   | RE206VK |
   | nummer | 1RE206  |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | true    |
Then the table has 2 rows
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# RLS in der Ablage
Then "(Sales):(PackingSlip)" with the editor id "RLS206" is not filed

# Gutschrift zur Ruecklieferung
Given I open an editor "KGS206VK" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS206"
And I set fields
   | such   | KGS206VK |
   | nummer | 1KGS206  |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | true     |
Then the table has 3 rows
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# RLS ist in der Ablage
Then "(Sales):(PackingSlip)" with the editor id "RLS206" is filed

#----------------------------------------------------------------------------------------------
Scenario: Rechnung ohne Lagerbewegung und Restmengenstorno
#----------------------------------------------------------------------------------------------

# Auftrag
Given I create a SalesOrder "AU210" for Customer "1" with Product "V1" and quantity "10"

# Rechnung ohne LB
Given I open an editor "RE210" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU210"
And I set fields
   | such   | RE210  |
   | ebeleg | RE210  |
   | tterm  | .      |
   | fakt   | nein   |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Mengenerhoehung und Restmengenstorno im Auftrag
Given I open an editor "AU210" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU210"
And I set field "mge" to "15" in row 1
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I save the current editor

Then field "limge" from editor "AU210" in row 1 has value "0"
Then field "remge" from editor "AU210" in row 1 has value "0"

# Wertgutschrift
Given I open an editor "WG210" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE210"
And I set fields
   | such   | WG210   |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "-10" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Ruecklieferscheinposition ohne Rechnungsrelevanz
#----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU220" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1AU220 |
	| kunde  | 1      |
And I append rows
	| artikel | mge |
	| A100    | 10  |
And I save the current editor

# Lieferschein aus Bestellung erzeugen
Given I open an editor "1LS220" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU220"
And I set fields
	| nummer | 1LS220 |
	| vom    | .      |
	| ueb    | ja     |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung aus Lieferschein erzeugen
Given I open an editor "1RE220" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS220"
And I set fields
	| nummer | 1RE220 |
	| vom    | .      |
	| ueb    | ja     |
	| tterm  | .      |
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung stornieren
Given I open an editor "1ST220" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "1RE220"
And I set fields
	| nummer | 1RE220S |
And I save the current editor

# Ruecklieferschein aus Lieferschein erzeugen, ohne Rechnungsrelevanz
Given I open an editor "1RLS220" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS220"
And I set fields
	| nummer | 1RLS220 |
	| vom    | .       |
	| ueb    | ja      |
And I set field "mge" to "-10" in row 1
And I set field "rerelev" to "nein" in row 1
And I save the current editor

Then "(Sales):(PackingSlip)" with the editor id "1LS220" is filed
