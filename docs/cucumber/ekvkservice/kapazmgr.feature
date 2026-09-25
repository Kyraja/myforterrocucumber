#***************************************************************************
#
#  Name           : kapazmgr.feature
#  Datum          : 04.03.2021
#  Autor          : dago
#  Verantwortlich : dago
#  Kontrolle      : amk
#  Funktion       : Artikel angelegt mit AG3 in FT-Liste.
#                   Auftraege zu diesem Artikel erzeugt, einmal mit einer Lagergruppe in
#                   "Berlin" und mit einer anderer Lagergruppe als in "Karlsruhe" (Hongkong).
#                   Fuer den Test von ".hol mbel".
#
#***************************************************************************
#
@persistent
Feature: Maschinenkapazitaet und Lagergruppen pruefen
Background:
Given I set the fake date to "02.01.1995"

#---------------------------------------------------------------------------
#          Artikel und Auftraege zu diesem Artikel anlegen
#---------------------------------------------------------------------------
Scenario: Artikel und Auftraege zu diesem Artikel anlegen
Given I open an editor "Artikel-11a" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| nummer  | 11a         |
	| such    | A_AG3_BOHR  |
	| name    | Artikel Lgr |
	| zuplatz | F1          |
	| abplatz | F1          |
	| bsart   | E           |
	| umllg   | BERLIN      |
# Absteigen in Lagergruppeneigenschaften
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I create a new row at position 1
And I set field "lgruppe" to "BERLIN" in row 1
And I set field "bsart" to "Eigenfertigung" in row 1
And I create a new row at position 2
And I set field "lgruppe" to "HONGKONG" in row 2
And I set field "bsart" to "Eigenfertigung" in row 2
And I save the current editor
And I switch the current editor to editor "Artikel-11a"
And I create a new row at position 1
And I set field "vpos" to "1" in row 1
And I set field "elex" to "A AG3" in row 1
And I create a new row at position 2
And I set field "vpos" to "2" in row 2
And I set field "elex" to "A BOHR" in row 2
And I save the current editor
#
Given I open an editor "AU_Artikel11a" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1 |
	| kunde  | 1 |
And I create a new row at position 1
And I set field "pnum" to "1" in row 1
And I set field "artikel" to "11a" in row 1
And I set field "mge" to "44" in row 1
And I set field "preis" to "12" in row 1
And I set field "lgruppe" to "BERLIN" in row 1
And I save the current editor

# Auftrag 2 anlegen
Given I open an editor "AU2_Artikel11a" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 2 |
	| kunde  | 1 |
And I create a new row at position 1
And I set field "pnum" to "1" in row 1
And I set field "artikel" to "11a" in row 1
And I set field "mge" to "1" in row 1
And I set field "preis" to "13" in row 1
And I save the current editor

# Auftrag 3 anlegen
Given I open an editor "AU3_Artikel11a" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 3 |
	| kunde  | 2 |
And I create a new row at position 1
And I set field "pnum" to "1" in row 1
And I set field "artikel" to "11a" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "13" in row 1
And I set field "lgruppe" to "HONGKONG" in row 1
And I save the current editor

#---------------------------------------------------------------------------
#          Disposition starten
#---------------------------------------------------------------------------
And I run Scheduling
#---------------------------------------------------------------------------
#          FOP starten
#---------------------------------------------------------------------------
Given I execute FOP "KAPAZMGR.FOP"

