# *****************************************************************************
#  Name             : rewe_objektsperren_ev_002_einkauf_re.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Objektsperren in EK RE
#
#
#   Buchen der Einkaufsrechnung auf gesperrte Konten und Kostenobjekte
#   ==================================================================
#   Die Konten und Kostenobjekte, die in den Zeilen der Einkaufsrechnung stehen,
#   sollen auf Sperren geprueft werden:
#       wenn Positionswert ungleich 0
#       wenn "ueb" = ja
#       wenn nicht Stornovorgang
#   Egal ob primaere Rechnung oder Umlagerungsrechnung.
#   Die MKV bucht hier die Lieferscheinbuchung aus. Diese muss immer gehen.
#
# *****************************************************************************

@persistent
Feature: rewe_objektsperren_ev_002_einkauf_re.feature
Background:
Given I set the fake date to "01.02.1995"


Scenario: Normalfall

# In der Standartkontierung eintragen
Given I open an editor "warengruppe" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "FIBU"
And I set field "wgruppe" to "55"
And I save the current editor
And I close the current editor


# Rechnung aus Lieferschein "001-LS"
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record "001-LS"
# And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "001-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "preis" to "17,5" in row 1
Then field "kontosperredeakt" has value "nein" in row 1
Then field "kstellesperredeakt" has value "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Storno Rechnung
Given I open an editor "rechnung-st-001" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+001-RE"
And I set field "num4" to "001-STRE"
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
And I save the current editor
###################################################################################################


Scenario: Umlagern2 -> WG ist immer noch aktiv

# In der Standartkontierung eintragen
Given I open an editor "warengruppe" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "FIBU"
And I set field "wgruppe" to "UMLAGERN2"
And I save the current editor
And I close the current editor


# Rechnung aus Lieferschein "003-LS"
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record "003-LS"
# And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "003-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "preis" to "17,5" in row 1
Then field "kontosperredeakt" has value "nein" in row 1
Then field "kstellesperredeakt" has value "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Storno Rechnung
Given I open an editor "rechnung-st-003" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+003-RE"
And I set field "num4" to "003-STRE"
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
And I save the current editor
###################################################################################################

