@persistent
Feature: Artikelbereich Produktkategorie

#***************************************************************************
#
#  Name      : artber_aufzaehl.feature
#  Datum     : 28.08.2007
#  Vers.     : 1.0
#  Autor     : foe
#  Verantwortlich : foe
#  Kontrolle :
#
#  Funktion  : Erweitern der Aufzaehlung Produktkategogie um neue Kurztexte
#
#***************************************************************************

Scenario:  Erweitern der Aufzaehlung Produktkategogie um neue Kurztexte
# --------------------------------------------------------------------------
# Elemente in Standard-Aufzaehlung Produktkategorie 10000 eintragen
# --------------------------------------------------------------------------
Given I open an editor "Aufzaehlung" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "10000"
# 3 Kurztexte eintragen
# Zeile 7-9: Zusatzartikel, Alternativartikel, Sonderangebot
And I append rows
| aufzelem   |
| ZUSATZ     |
| ALTERNATIV |
| SONDER     |
#
# Durch diese Änderung wird eine Reorganisation notwendig.
# Reorganisation sofort starten?
And I respond with answer "ja" to the dialog with id "10951"
And I save the current editor
