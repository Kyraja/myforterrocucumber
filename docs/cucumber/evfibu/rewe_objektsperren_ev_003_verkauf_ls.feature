# *****************************************************************************
#  Name             : rewe_objektsperren_ev_003_verkauf_ls.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Objektsperren (nur Kostenobjekte) in VK LS.
#
#
#  Konten werden im VK LS NICHT gesperrt!!!
#
#  Warum Pruefung auf Kostenobjekte im Sonderfall?
#
#  Im Verkaufslieferschein oder schon im Auftrag kann ein Kostenobjekt eingetragen werden,
#  das den Vorschlag aus der Warengruppe/Produktgruppe ueberschreibt.
#  Zudem darf man fuer das Konto "im Verkauf ausgelieferter Bestand nicht berechnet"
#  ein GUV-Konto verwenden, zum Beispiel direkt das BV-Konto 50000. Sobald der Lieferschein auf
#  das Aufwandskonto gebucht wird, wird auch das Kostenobjekt bebucht. Damit wäre fuer
#  diesen Spezialfall eine Pruefung der Sperre des Kostenobjekts sinnvoll:
#  - wenn MKV aktiv
#  - wenn Artikel bestandsgefuehrt (jetzt ersetzt durch wenn Position zu einer Lagerbewegung fuehrt)
#  - wenn Konto "Im Verkauf ausgeliefert, nicht berechnet" ein GuV-Konto ist und dieses GuV-Konto den Korezwang auf "ja" stehen hat
#  - wenn "Buchen" im Lieferschein =  ja
#  - wenn nicht Storno
#  - wenn Buchen der Position zu einer Lagerbewegung fuehrt
#
# *****************************************************************************

@persistent
Feature: rewe_objektsperren_ev_003_verkauf_ls.feature
Background:
Given I set the fake date to "01.02.1995"


Scenario: Normalfall

Given I open an editor "auftrag-001" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "001"
And I set field "kunde" to "1"
And I set field "vom" to "."
And I set field "schlag" to "Normal"
And I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "119" in row 1
And I set field "wtrterm" to "." in row 1
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
And I save the current editor
And I close the current editor


# Lieferschein aus Auftrag
Given I open an editor "lieferschein-001" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-001"
And I set field "num3" to "001-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
And I save the current editor
And I close the current editor
###################################################################################################


Scenario: Sonderfall

# WG in der Standartkontierung eintragen
Given I open an editor "warengruppe" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "FIBU"
And I set field "wgruppe" to "VKGELNIBE"
And I save the current editor
And I close the current editor


Given I open an editor "auftrag-002" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "002-AU"
And I set field "kunde" to "1"
And I set field "vom" to "."
And I set field "schlag" to "Normal"
And I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "119" in row 1
And I set field "wtrterm" to "." in row 1
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
And I save the current editor
And I close the current editor


# Lieferschein aus Auftrag "002-AU"
Given I open an editor "lieferschein-002" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-002"
And I set field "num3" to "002-LS"
And I set field "vom" to "."
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
#
And I press button "offueb" in row 1
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
#
And I set field "ueb" to "ja"
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "nein" in row 1
And I save the current editor
And I close the current editor
###################################################################################################


