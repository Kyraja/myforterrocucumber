# *****************************************************************************
#  Name             : rewe_objektsperren_ev_005_lohnfert_mit_beistellung.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Objektsperren in EK/VK bei Lohnfertigung mit Beistellung
#
#===============================================================================
#
# Regeln fuer EK LS
#===================
#  Das Konto soll geprueft werden:
#      und wenn MKV aktiv
#      und wenn "Buchen" im Lieferschein = ja
#      und wenn kein Storno-Lieferschein
#      und wenn Menge groesser Null
#      wenn es sich um eine Artikelposition handelt
#      und wenn Artikel bestandsgefuehrt
#      und wenn Konto ein Bestandskonto ist ("gv" im Konto = nein)
#
#  Das Kostenobjekt soll geprueft werden:
#      und wenn MKV aktiv
#      und wenn "Buchen" im Lieferschein = ja
#      und wenn nicht Storno
#      und wenn Menge groesser Null
#      wenn es sich um eine Artikelposition handelt
#      und wenn Konto in der Tabelle ein GuV-Konto ist ("gv" im Konto = ja) und Konto "Geliefert, nicht berechnet" bestgelniber in der Warengruppe Kore-Zwang hat ("kost" im Konto = ja)
#      Das ist der Fall bei Lohnfertigungungen und Beistellartikeln.
#      oder wenn Konto in der Tabelle ein GuV-Konto ist ("gv" im Konto = ja) und Lieferschein die Beschaffungsart "Umlagern" hat und Konto bvabohnezu oder Konto bvausumlagzu in der Warengruppe Kore-Zwang hat ("kost" im Konto = ja)
#      Das ist der Fall bei Lieferscheinen mit der Beschaffungsart "Umlagern".
#
# Regeln fuer EK RE
#===================
#   Die Konten und Kostenobjekte, die in den Zeilen der Einkaufsrechnung stehen,
#   sollen auf Sperren geprueft werden:
#       wenn Positionswert ungleich 0
#       wenn "ueb" = ja
#       wenn nicht Stornovorgang
#   Egal ob primaere Rechnung oder Umlagerungsrechnung.
#   Die MKV bucht hier die Lieferscheinbuchung aus. Diese muss immer gehen.
#
# Regeln fuer VK LS
#===================
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
#
# Regeln fuer VK RE
#===================
#     Die Konten und Kostenobjekte, die in den Zeilen der Verkaufsrechnung stehen, sollen auf Sperren geprueft werden:
#        wenn Positionswert ungleich 0
#         wenn "ueb" = ja
#         wenn nicht Stornovorgang
#     Egal ob primäre Rechnung oder Umlagerungsrechnung.
# *****************************************************************************

@persistent
Feature: rewe_objektsperren_ev_005_lohnfert_mit_beistellung.feature
Background:
Given I set the fake date to "01.02.1995"


Scenario: Lohnfertigung mit Beistellung; Lohnfertigungsartikel 'LOHN3'

# VK-Auftrag über 699 mit Ktr 205100
Given I open an editor "auftrag-1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "300"
And I set field "kunde" to "1"
And I set field "vom" to "."
And I set field "schlag" to "BEIST_"
And I create a new row at the end of the table
And I set field "artex" to "699" in row 1
And I set field "mge" to "119" in row 1
And I set field "wtrterm" to "." in row 1
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
And I save the current editor
And I close the current editor


#Disposition starten
And I run Scheduling


# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I set field "bisuch" to "BEIST_" in row 1
And I press button "malle"
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor
And I close the current editor


# Bestellvorschlag + Bestellung (fuer Art. 201 + 1000)
Given I open an editor "bestellvorschlag-1" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I press button "malle"
And I press button "freig" to open a subeditor for "bestellung-1"
And I set field "num4" to "300-BE"
And I set field "lief" to "1"
And I save the current editor
And I close the current editor
And I switch the current editor to editor "bestellvorschlag-1"
And I close the current editor


# Lieferschein aus Bestellung "300-BE" -> Inland
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "300-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-LohnFertMitBeist,"
And I press button "offueb" in row 1
Then field "kontosperredeakt" has value "nein" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
And I press button "offueb" in row 2
Then field "kontosperredeakt" has value "nein" in row 2
Then field "kstellesperredeakt" has value "ja" in row 2
And I save the current editor
And I close the current editor


# Lohnfertigungsvorschlag + Bestellung (fuer Art. LOHN3)
Given I open an editor "lohnfertigungsvorschlag-1" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I press button "malle"
And I press button "freig" to open a subeditor for "lohnfertigung-1"
And I set field "num4" to "300LO-BE"
# Ausland
And I set field "lief" to "001"
And I save the current editor
And I close the current editor
And I switch the current editor to editor "lohnfertigungsvorschlag-1"
And I close the current editor


# Lieferschein aus Bestellung "300LO-BE" (Lohnfertigung) -> Ausland
Given I open an editor "lieferschein-2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lohnfertigung-1"
And I set field "num4" to "300LO-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-LohnFertMitBeist,"
And I press button "offueb" in row 1
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
And I save the current editor
And I close the current editor


# Rechnung aus Lieferschein 1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "300-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "preis" to "19.19" in row 1
Then field "kontosperredeakt" has value "nein" in row 1
Then field "kstellesperredeakt" has value "nein" in row 1
And I set field "kenn" to "FALL-LohnFertMitBeist,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Rechnung aus Lieferschein 2
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2"
And I set field "num4" to "300LO-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# Inland
And I set field "lief" to "1"
And I set field "preis" to "107" in row 1
Then field "kontosperredeakt" has value "nein" in row 1
Then field "kstellesperredeakt" has value "nein" in row 1
And I set field "kenn" to "FALL-LohnFertMitBeist,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Rueckmeldung auf ersten Arbeitsgang
Given I open an editor "rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEIST_001"
And I set fields
	| sofort	| 1		|
	| bzeit		| 0,7	|
	| mzeit		| 8,7	|
	| gut		| 1		|
And I save the current editor
And I close the current editor


# Rueckmeldung auf ersten Arbeitsgang
Given I open an editor "rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEIST_000"
And I set fields
	| sofort	| 1		|
	| bzeit		| 0,5	|
	| mzeit		| 13	|
	| gut		| 1		|
	| lgr		| 1		|
And I save the current editor
And I close the current editor


# VK-Rechnung aus Auftrag
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-1"
And I set field "num3" to "300-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "kenn" to "FALL-LohnFertMitBeist,"
And I press button "offueb" in row 1
And I set field "preis" to "711" in row 1
Then field "kontosperredeakt" has value "nein" in row 1
Then field "kstellesperredeakt" has value "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
######################################################################################################################################

