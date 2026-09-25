# *****************************************************************************
#  Name           : IS_EDIGA.feature
#  Autor          : khuelskaemper
#  Verantwortlich : teaminfosysteme
#  Funktion       : Testet Funktionen IS EDIGA
#
# *****************************************************************************
#
# Test in Cucumber erstellt, ersetzt den alten Test noch nicht vollständig:
# - Fehlermeldung mit zwei Zeilen wird nicht geprüft, wie geht der Zeilenumbruch?
# - Bei 'And I press button "tburechnung"' wird keine Rechnung erstellt, warum konnte ich keiner annehmbaren Zeiten gefunden werden
# - --> funktioniert auch bei edo Vorgänger ref_edi_gutschriften schon nicht (ganz unten)

@persistent
Feature: EDI-Gutschriftenprotokoll
Background:
Given I set the fake date to "05.01.1995"

# ------------------------------------------------------
Scenario: Gutschrift ohne LS als EDI Datei erstellen und importieren
# ------------------------------------------------------

Given I open the infosystem "EDITEST"
And I set fields
	| kbimport    | ja        |
	| kediref     | R-VKGAV   |
	| kkundegav   | EDISB-14  |
	| kbdatei     | ja        |
	| kbanhaengen | nein      |
	| kbudatei    | 1         |
	| kinzeilen   | 1         |
	| ksteuergav  | 7         |
	| kbeleggav   | 14000     |
	| kkunde      | EDIKD-4   |
	| kabm        | 4130      |
	| kedinachr   | 2112      |
And I delete all rows
And I append rows
	| tartex   | tmenge | tpreis | tdatum | tbeleg   |
	| EDIART-1 | 100    | 50     | .      | 00014014 |
And I press button "kbudateineu"

And I set fields
	| kbimport    | ja       |
	| kediref     | R-VKGAV  |
	| kkundegav   | EDISB-24 |
	| kbdatei     | ja       |
	| kbanhaengen | ja       |
	| kbudatei    | 1        |
	| kinzeilen   | 1        |
	| ksteuergav  | 7        |
	| kbeleggav   | 24000    |
	| kkunde      | EDIKD-4  |
	| kabm        | 4130     |
	| kedinachr   | 2112     |
And I delete all rows
And I append rows
	| tartex   | tmenge | tpreis | tdatum | tbeleg   |
	| EDIART-2 | 150    | 45     | .      | 00024024 |
And I press button "kbudateineu"

And I close the current editor

# EDI Datei importieren
Given I open the infosystem "EDIIMPORT"
And I press button "bstart"
# Zeilen mit Importdateien sind automatisch ausgewählt
And I press button "buimport"
And I close the current editor

# ------------------------------------------------------
Scenario: Daten in EDIGA testen
# ------------------------------------------------------

Given I open the infosystem "EDIGA"
And I press button "bstart"
Then the table has 12 rows
And table has values
	| ganr    | art      | mge  | preis | tbelegmoeglich |
	| G351601 | EDIART-1 | 5000 | 50.00 | ja             |
	| G351601 | EDIART-2 | 5000 | 50.00 | ja             |
	| G351601 | 	     |    0 |  0.00 | nein           |
	| G351603 | EDIART-3 | 1500 | 50.00 | ja             |
	| G351603 | 	     |    0 |  0.00 | nein           |
	| G351604 | EDIART-4 | 5000 | 50.00 | ja             |
	| G351604 | EDIART-5 | 6000 | 50.00 | ja             |
	| G351604 |          |    0 |  0.00 | nein           |
	| 14000   | EDIART-1 |  100 | 50.00 | nein           |
	| 14000   |          |    0 |  0.00 | nein           |
	| 24000   | EDIART-2 |  150 | 45.00 | nein           |
	| 24000   |          |    0 |  0.00 | nein           |
		
And field "fehler" has value "Die ermittelte Lieferscheinposition hat keine Gutschriftenanzeigenummer." in row 1	
# And field "fehler" has value """Zur Position in der Gutschriftenanzeige konnte keine Lieferscheinposition ermittelt werden. Die ermittelte Lieferscheinposition hat keine Gutschriftenanzeigenummer.""" in row 9

And I close the current editor

# ------------------------------------------------------
Scenario: Rechnungen der Gutschriften erstellen
# ------------------------------------------------------

Given I open the infosystem "EDIGA"
And I press button "bstart"

# Gutschriftenanzeigenummer per Freigabe in die Positionen vom Lieferschein schreiben
And I press button "tbufreigabe" in row 4
And I press button "tbufreigabe" in row 6
And I press button "tbufreigabe" in row 7
And I press button "bstart"

Then field "fotoz" has value "icon:ball_red" in row 2
And field "fotoz" has value "icon:ball_green" in row 4

# Rechnungen erstellen
And I press button "tburechnung" in row 4
And I press button "tburechnung" in row 7
And I press button "bstart"

# Zeilen 6 und 7 gegeneinander prüfen, es sollten beide zusammen verarbeitet werden, da gleicher LS
# And field "rechnr" has value "400002" in row 6

And I close the current editor

# # ------------------------------------------------------
# Scenario: Externe Belegnummer prüfen
# # ------------------------------------------------------

# # In der Rechnung soll die Externe Belegnummer die Nummer der Gutschrift enthalten
# Given I open an editor "Rechnung" from table "(Sales):(Invoice)" with command "VIEW" for record "400002"
# And field "ebeleg" has value "G351604"
# And I close the current editor

