# *****************************************************************************
#  Name             : rewe_objektsperren_ev_001_einkauf_ls.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Sperren von Konten und Kostenobjekten in EK LS
#
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
#      und wenn Konto in der Tabelle ein GuV-Konto ist ("gv" im Konto = ja)
#          und Konto "Geliefert, nicht berechnet" bestgelniber in der Warengruppe Kore-Zwang hat ("kost" im Konto = ja)
#          Das ist der Fall bei Lohnfertigungungen und Beistellartikeln.
#      oder wenn Konto in der Tabelle ein GuV-Konto ist ("gv" im Konto = ja)
#           und Lieferschein die Beschaffungsart "Umlagern" hat
#           und Konto bvabohnezu oder Konto bvausumlagzu in der Warengruppe Kore-Zwang hat ("kost" im Konto = ja)
#           Das ist der Fall bei Lieferscheinen mit der Beschaffungsart "Umlagern".
#
# *****************************************************************************

@persistent
Feature: rewe_objektsperren_ev_001_einkauf_ls.feature
Background:
Given I set the fake date to "01.02.1995"


Scenario: Normalfall


# Bestellung anlegen: Normalfall
Given I open an editor "bestellung-001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0001-BE"
And I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "020" in row 1
And I set field "preis" to "020" in row 1
# Sperren deaktiviert
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
#
Then field "konto" has value "10000" in row 1
Then field "kstelle" is not modifiable in row 1
Then field "mge" has value "20" in row 1
Then field "pwert" has value "400.00" in row 1
And I save the current editor


# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-001" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-001"
And I set field "num4" to "001-LS"

And I set field "vom" to "."
And I set field "mge" to "020" in row 1
#
Then field "konto" has value "10000" in row 1
Then field "kstelle" is not modifiable in row 1
Then field "mge" has value "20" in row 1
Then field "pwert" has value "400.00" in row 1
# Sperren deaktiviert
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
#
And I set field "ueb" to "ja"
Then field "kontosperredeakt" has value "nein" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
And I save the current editor
###################################################################################################


Scenario: Umlagern1 -Konto "bvabohnezu" in der Warengruppe Kore-Zwang hat ("kost" im Konto = ja)

# In der Standartkontierung eintragen
Given I open an editor "warengruppe" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "FIBU"
And I set field "wgruppe" to "UMLAGERN1"
And I save the current editor
And I close the current editor


# Bestellung anlegen: Umlagern
Given I open an editor "bestellung-002" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0002-BE"
And I set field "bsart" to "Umlagern"


And I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "lgruppe" to "Berlin" in row 1
And I set field "mge" to "040" in row 1
And I set field "preis" to "040" in row 1
# Sperren deaktiviert
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
#
Then field "konto" has value "59000" in row 1
Then field "kstelle" is modifiable in row 1
Then field "mge" has value "40" in row 1
Then field "pwert" has value "1600.00" in row 1
And I save the current editor


# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-002" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-002"
And I set field "num4" to "002-LS"
Then field "typa" has value "Lieferschein"
Then field "bsart" has value "Umlagern"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
#
Then field "konto" has value "59000" in row 1
Then field "kstelle" is modifiable in row 1
Then field "mge" has value "40" in row 1
Then field "pwert" has value "1600.00" in row 1
# Sperren deaktiviert
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
#
And I set field "ueb" to "ja"
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "nein" in row 1
And I save the current editor


# STORNO
Given I open an editor "lieferschein-002storno" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "002-LS"
And I set field "num4" to "002-STLS"
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
And I save the current editor
###################################################################################################


Scenario: Umlagern2 - Konto "bvausumlagzu" in der Warengruppe Kore-Zwang hat ("kost" im Konto = ja)

# In der Standartkontierung eintragen
Given I open an editor "warengruppe" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "FIBU"
And I set field "wgruppe" to "UMLAGERN2"
And I save the current editor
And I close the current editor


# Bestellung anlegen: Umlagern
Given I open an editor "bestellung-003" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0003-BE"
And I set field "bsart" to "Umlagern"


And I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "lgruppe" to "Berlin" in row 1
And I set field "mge" to "040" in row 1
And I set field "preis" to "040" in row 1
# Sperren deaktiviert
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
#
Then field "konto" has value "59000" in row 1
Then field "kstelle" is modifiable in row 1
Then field "mge" has value "40" in row 1
Then field "pwert" has value "1600.00" in row 1
And I save the current editor


# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-003" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-003"
And I set field "num4" to "003-LS"
Then field "typa" has value "Lieferschein"
Then field "bsart" has value "Umlagern"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
#
Then field "konto" has value "59000" in row 1
Then field "kstelle" is modifiable in row 1
Then field "mge" has value "40" in row 1
Then field "pwert" has value "1600.00" in row 1
# Sperren deaktiviert
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
#
And I set field "ueb" to "ja"
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "nein" in row 1
And I save the current editor
###################################################################################################







