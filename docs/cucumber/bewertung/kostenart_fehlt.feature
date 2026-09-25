# *****************************************************************************
#  Name           : kostenart_fehlt.feature
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Darstellung des Grunds "Kostenart fehlt" in manuell erstellen Bewertungen.
#
# *****************************************************************************
@persistent
Feature: BW2-1853 (Plausibilisierung der Bewertungserzeugung vom Typ 2 ohne Kostenart)
Background:
Given I set the fake date to "30.03.02"


Scenario: 01 Bewertung 25 - neue Zeile erfassen ohne Kostenart, bestehende Zeilen löschen

Given I open an editor "Bewertung25" from table "(Valuation):(Valuation)" with command "UPDATE" for record "BUCHBAR4"
And I delete row at position 2
And I delete row at position 1
And I create a new row at the end of the table
And I set field "tbudat" to "5.01.02" in row 1
And I set field "tmge" to "5" in row 1
And I set field "tbewpr" to "2.0000" in row 1
And I set field "koreso" to "88100" in row 1
And I set field "koreha" to "88101" in row 1
And I set field "kostobj" to "100000" in row 1
And I set field "kstellemgr" to "112" in row 1
And I set field "lbgvktohkostktr" to "ja" in row 1
And I set field "sokoue" to "10500" in row 1
And I set field "hakoue" to "48113" in row 1
And I press button "ergaenzen1"
And I set field "bem" to "hakoeu wird manuell gefuellt. PrdGrp wird ueber Artikel automatisch ergaenzt. kart ist leer, daher nicht verbuchbar"
And I save the current editor
And I close the current editor

Given I open an editor "Bewertung25" from table "(Valuation):(Valuation)" with command "VIEW" for record "BUCHBAR4"
Then field "lbgrund" has value "Kostenart fehlt."
Then field "uegrund" has value "Kostenart fehlt."
Then field "tlbstatus" has value "nicht verbuchbar" in row 1
Then field "tuestatus" has value "nicht verbuchbar" in row 1
And I close the current editor
  
Scenario: 02 Bewertung 21 - neue Zeilen erfassen ohne Kostenart, bestehende Zeilen löschen
# hier kommt nach der Ändddddderung allerdings "unterschiedliche Zeilenzustände" und nicht "Kostenart fehlt."
Given I'm logged in with password "annette"

Given I open an editor "Bewertung21" from table "(Valuation):(Valuation)" with command "UPDATE" for record "AUSSCHM1"
And I delete row at position 2
And I delete row at position 1
And I set field "manuellgeaendert" to "nein"
And I create a new row at the end of the table
And I set field "tmge" to "4" in row 1
And I set field "tbudat" to "5.01.02" in row 1
And I set field "koreso" to "88100" in row 1
And I set field "koreha" to "88101" in row 1
And I set field "kostobj" to "100000" in row 1
And I set field "kstellemgr" to "110" in row 1
And I set field "lbgvktohkostktr" to "ja" in row 1
# And I set field "sokoue" to "10500" in row 1
And I set field "tbewpr" to "0.0000" in row 1
And I create a new row at the end of the table
#
And I set field "tmge" to "6" in row 2 
And I set field "tbewpr" to "0.0000" in row 2
And I set field "koreha" to "88100" in row 2
And I set field "koreso" to "88101" in row 2
And I set field "kostobj" to "100000" in row 2
And I set field "lbgvktohkostktr" to "ja" in row 2
# And I press button "ergaenzen1"     
#
And I save the current editor
And I close the current editor

Scenario: 03 Bewertung 24 - neue Zeilen erfassen ohne Kostenart, bestehende Zeilen löschen
Given I'm logged in with password "annette"

Given I open an editor "Bewertung24" from table "(Valuation):(Valuation)" with command "UPDATE" for record "AUSSCHO3"
And I delete row at position !lastRow
And I delete row at position !lastRow
And I create a new row at the end of the table
And I set field "tmge" to "1" in row 1
And I set field "tbudat" to "5.01.02" in row 1
And I set field "koreso" to "88100" in row 1
And I set field "koreha" to "88101" in row 1
And I set field "kostobj" to "100000" in row 1
And I set field "kstellemgr" to "110" in row 1
And I set field "lbgvktohkostktr" to "ja" in row 1
And I set field "tbewpr" to "0.0000" in row 1
#
And I create a new row at the end of the table
And I set field "tmge" to "2" in row 2
And I set field "koreso" to "88100" in row 2
And I set field "koreha" to "88101" in row 2
And I set field "kostobj" to "100" in row 2
And I set field "kstellemgr" to "110" in row 2
And I set field "lbgvktohkostktr" to "ja" in row 2
And I set field "tbewpr" to "2.0000" in row 2
#
And I save the current editor
And I close the current editor

Given I open an editor "Bewertung24" from table "(Valuation):(Valuation)" with command "VIEW" for record "AUSSCHO3"
Then field "lbgrund" has value "Kostenart fehlt."
Then field "uegrund" has value "Kostenart fehlt."
Then field "tlbstatus" has value "nicht verbuchbar" in row 1
Then field "tuestatus" has value "nicht verbuchbar" in row 1
Then field "tlbstatus" has value "nicht verbuchbar" in row 2
Then field "tuestatus" has value "nicht verbuchbar" in row 2
And I close the current editor





