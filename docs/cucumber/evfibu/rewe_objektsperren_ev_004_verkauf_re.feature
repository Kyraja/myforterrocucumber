# *****************************************************************************
#  Name             : rewe_objektsperren_ev_004_verkauf_re.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Objektsperren in EK/VK bei Lohnfertigung mit Beistellung
#
#
#     Die Konten und Kostenobjekte, die in den Zeilen der Verkaufsrechnung stehen, sollen auf Sperren geprueft werden:
#        wenn Positionswert ungleich 0
#         wenn "ueb" = ja
#         wenn nicht Stornovorgang
#     Egal ob primäre Rechnung oder Umlagerungsrechnung.
#
#
# *****************************************************************************

@persistent
Feature: rewe_objektsperren_ev_004_verkauf_re.feature
Background:
Given I set the fake date to "01.02.1995"


Scenario: Normal

# In der Standartkontierung eintragen
Given I open an editor "warengruppe" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "FIBU"
And I set field "wgruppe" to "55"
And I save the current editor
And I close the current editor

# VK-Rechnung aus Lieferschein
Given I open an editor "rechnung-001" from table "(Sales):(Invoice)" with command "NEW" for record "001-LS"
And I set field "num3" to "001-RE"
And I set field "vom" to "."
And I set field "tterm" to "."
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
Then field "pwert" has value "2975.00" in row 1
#
And I press button "offueb" in row 1
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
#
And I set field "ueb" to "ja"
Then field "kontosperredeakt" has value "nein" in row 1
Then field "kstellesperredeakt" has value "nein" in row 1
And I set field "preis" to "711" in row 1
Then field "kontosperredeakt" has value "nein" in row 1
Then field "kstellesperredeakt" has value "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
######################################################################################################################################


Scenario: Sonderfall

# In der Standartkontierung eintragen
Given I open an editor "warengruppe" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "FIBU"
And I set field "wgruppe" to "VKGELNIBE"
And I save the current editor
And I close the current editor

# VK-Rechnung aus Lieferschein
Given I open an editor "rechnung-002" from table "(Sales):(Invoice)" with command "NEW" for record "002-LS"
And I set field "num3" to "002-RE"
And I set field "vom" to "."
And I set field "tterm" to "."
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
Then field "pwert" has value "2975.00" in row 1
#
And I press button "offueb" in row 1
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
#
And I set field "ueb" to "ja"
Then field "kontosperredeakt" has value "nein" in row 1
Then field "kstellesperredeakt" has value "nein" in row 1
And I set field "preis" to "711" in row 1
Then field "kontosperredeakt" has value "nein" in row 1
Then field "kstellesperredeakt" has value "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Storno Rechnung
Given I open an editor "rechnung-st-002" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+002-RE"
And I set field "num3" to "002-STRE"
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
And I save the current editor
######################################################################################################################################



