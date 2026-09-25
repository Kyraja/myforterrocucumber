# *****************************************************************************
#  Name             : rewe_objektsperren_ev_006_kostenverteiler.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Sperren und Kostenverteiler in EK/VK
#
#
# *****************************************************************************

@persistent
Feature: rewe_objektsperren_ev_006_kostenverteiler.feature
Background:
Given I set the fake date to "01.02.1995"



Scenario: 1.  Umlagern1 -Konto "bvabohnezu" in der Warengruppe Kore-Zwang hat ("kost" im Konto = ja)
#         Versuch bei aktiver Sperre ein KV mit gesperrTen Objekten einzutragen

# In der Standartkontierung eintragen
Given I open an editor "warengruppe" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "FIBU"
And I set field "wgruppe" to "UMLAGERN1"
And I save the current editor
And I close the current editor


# Bestellung anlegen: Umlagern
Given I open an editor "bestellung-102" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1002-BE"
And I set field "bsart" to "Umlagern"


And I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "lgruppe" to "Berlin" in row 1
And I set field "mge" to "040" in row 1
And I set field "preis" to "040" in row 1
Then field "kstelle" is modifiable in row 1
# Sperren deaktiviert
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
#
Then field "konto" has value "59000" in row 1
Then field "mge" has value "40" in row 1
Then field "pwert" has value "1600.00" in row 1
# Kostenverteiler 300kv eintragen - nichts ist gesperrt
Then field "kstelle" is modifiable in row 1
And I set field "kstelle" to "300kv" in row 1
And I save the current editor


# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-102" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-102"
And I set field "num4" to "102-LS"
Then field "typa" has value "Lieferschein"
Then field "bsart" has value "Umlagern"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
#
Then field "konto" has value "59000" in row 1
Then field "kstelle" is modifiable in row 1
Then field "mge" has value "40" in row 1
Then field "pwert" has value "1600.00" in row 1
Then field "kstelle" has value "300kv" in row 1
Then field "kstelle" is modifiable in row 1
# Sperren deaktiviert
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
#
And I set field "ueb" to "ja"
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "nein" in row 1
#
# 3602  |Kostenverteiler enthaelt gesperrte Objekte.
Then setting field "kstelle" to "302kv" in row 1 throws the exception "3602"
Then field "kstelle" has value "300kv" in row 1
And I save the current editor


# STORNO
Given I open an editor "lieferschein-002storno" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "102-LS"
And I set field "num4" to "102-STLS"
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
And I save the current editor
###################################################################################################


Scenario: 2.  Umlagern1 -Konto "bvabohnezu" in der Warengruppe Kore-Zwang hat ("kost" im Konto = ja)
#         In der Bestellung wird ein KV mit gesp. Objekten eingetragen.
#         Das Verbuchen von LS wird das aber merken!

# In der Standartkontierung eintragen
Given I open an editor "warengruppe" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "FIBU"
And I set field "wgruppe" to "UMLAGERN1"
And I save the current editor
And I close the current editor


# Bestellung anlegen: Umlagern
Given I open an editor "bestellung-103" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "103-BE"
And I set field "bsart" to "Umlagern"


And I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "lgruppe" to "Berlin" in row 1
And I set field "mge" to "040" in row 1
And I set field "preis" to "040" in row 1
Then field "kstelle" is modifiable in row 1
# Sperren deaktiviert
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
#
Then field "konto" has value "59000" in row 1
Then field "mge" has value "40" in row 1
Then field "pwert" has value "1600.00" in row 1
# Kostenverteiler 302kv eintragen - mit gesperrten Objekten
Then field "kstelle" is modifiable in row 1
And I set field "kstelle" to "302kv" in row 1
And I save the current editor


# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-103" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-103"
And I set field "num4" to "103-LS"
Then field "typa" has value "Lieferschein"
Then field "bsart" has value "Umlagern"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
#
Then field "konto" has value "59000" in row 1
Then field "kstelle" is modifiable in row 1
Then field "mge" has value "40" in row 1
Then field "pwert" has value "1600.00" in row 1
Then field "kstelle" has value "302kv" in row 1
Then field "kstelle" is modifiable in row 1
# Sperren deaktiviert
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
#
And I set field "ueb" to "ja"
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "nein" in row 1
#
Then field "kstelle" has value "302kv" in row 1
# 3602  |Kostenverteiler enthaelt gesperrte Objekte.
And saving the current editor throws the exception "3602"
And I set field "kstelle" to "300kv" in row 1
And I save the current editor


# STORNO
Given I open an editor "lieferschein-003storno" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "103-LS"
And I set field "num4" to "103-STLS"
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
And I save the current editor
###################################################################################################


Scenario: 3.  Umlagern1 -Konto "bvabohnezu" in der Warengruppe Kore-Zwang hat ("kost" im Konto = ja)
#         Nach dem Vebuchen von EK LS wird eine KS aus KV gesperrt - STORNO von LS muss trotzdem gehen!


# In der Standartkontierung eintragen
Given I open an editor "warengruppe" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "FIBU"
And I set field "wgruppe" to "UMLAGERN1"
And I save the current editor
And I close the current editor


# Bestellung anlegen: Umlagern
Given I open an editor "bestellung-104" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "104-BE"
And I set field "bsart" to "Umlagern"


And I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "lgruppe" to "Berlin" in row 1
And I set field "mge" to "040" in row 1
And I set field "preis" to "040" in row 1
Then field "kstelle" is modifiable in row 1
# Sperren deaktiviert
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
#
Then field "konto" has value "59000" in row 1
Then field "mge" has value "40" in row 1
Then field "pwert" has value "1600.00" in row 1
# Kostenverteiler 301kv eintragen - ohne gesperrten Objekten
Then field "kstelle" is modifiable in row 1
And I set field "kstelle" to "301kv" in row 1
And I save the current editor


# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-104" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-104"
And I set field "num4" to "104-LS"
Then field "typa" has value "Lieferschein"
Then field "bsart" has value "Umlagern"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
#
Then field "konto" has value "59000" in row 1
Then field "kstelle" is modifiable in row 1
Then field "mge" has value "40" in row 1
Then field "pwert" has value "1600.00" in row 1
Then field "kstelle" has value "301kv" in row 1
Then field "kstelle" is modifiable in row 1
# Sperren deaktiviert
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
#
And I set field "ueb" to "ja"
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "nein" in row 1
And I save the current editor


# KST 301ks sperren
Given I open an editor "kstelle-sperre" from table "(Account):(CostCenter)" with command "UPDATE" for record "301ks"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
And I save the current editor


# STORNO muss gehen, obwohl geperrte Objekte im Verteiler
Given I open an editor "lieferschein-004storno" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "104-LS"
And I set field "num4" to "104-STLS"
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
And I save the current editor


# KST 301ks entsperren
Given I open an editor "kstelle-sperre" from table "(Account):(CostCenter)" with command "UPDATE" for record "301ks"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor
###################################################################################################


Scenario: Verkauf Normalfall
#         Im Auftrag wird ein KV mit gesperrten Objekten eingetragen
#         LS kriegt davon nichts mit - Sperren sind deaktiviert
#         Erst die Rechnung merkt den KV mit gesperrten Objekten - Sperre fuer Kostenobj. ist aktiv

# In der Standartkontierung eintragen
Given I open an editor "warengruppe" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "FIBU"
And I set field "wgruppe" to "55"
And I save the current editor
And I close the current editor


Given I open an editor "auftrag-301" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "301"
And I set field "kunde" to "1"
And I set field "vom" to "."
And I set field "schlag" to "Normal 301"
And I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "119" in row 1
And I set field "wtrterm" to "." in row 1
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
# Kostenverteiler 302kv eintragen - mit gesperrten Objekten
Then field "kstelle" is modifiable in row 1
And I set field "kstelle" to "302kv" in row 1
And I save the current editor
And I close the current editor


# Lieferschein aus Auftrag
Given I open an editor "lieferschein-301" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-301"
And I set field "num3" to "301-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
Then field "kstelle" is modifiable in row 1
Then field "kstelle" has value "302kv" in row 1
And I save the current editor
And I close the current editor


# VK-Rechnung aus Lieferschein
Given I open an editor "rechnung-301" from table "(Sales):(Invoice)" with command "NEW" for record "301-LS"
And I set field "num3" to "301-RE"
And I set field "vom" to "."
And I set field "tterm" to "."
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
Then field "kstelle" is modifiable in row 1
Then field "kstelle" has value "302kv" in row 1
Then field "pwert" has value "2975.00" in row 1
#
And I press button "offueb" in row 1
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
#
# Jetzt wird gebucht!
And I set field "ueb" to "ja"
Then field "kontosperredeakt" has value "nein" in row 1
Then field "kstellesperredeakt" has value "nein" in row 1
And I set field "preis" to "711" in row 1
Then field "kontosperredeakt" has value "nein" in row 1
Then field "kstellesperredeakt" has value "nein" in row 1
Then field "kstelle" has value "302kv" in row 1
# 3602  |Kostenverteiler enthaelt gesperrte Objekte.
And saving the current editor throws the exception "3602"
And I set field "kstelle" to "301kv" in row 1
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# KST 301ks sperren
Given I open an editor "kstelle-sperre" from table "(Account):(CostCenter)" with command "UPDATE" for record "301ks"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
And I save the current editor


# STORNO muss gehen, obwohl geperrte Objekte im Verteiler
Given I open an editor "rechnung-301storno" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+301-RE"
And I set field "num3" to "301-STLS"
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
And I save the current editor


# KST 301ks entsperren
Given I open an editor "kstelle-sperre" from table "(Account):(CostCenter)" with command "UPDATE" for record "301ks"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor
######################################################################################################################################


Scenario: Verkauf Sonderfall
#         Im Auftrag wird ein KV mit gesperrten Objekten eingetragen
#         LS merkt den KV mit gesperrten Objekten - Sperre fuer Kostenobj. ist aktiv


# In der Standartkontierung eintragen
Given I open an editor "warengruppe" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "FIBU"
And I set field "wgruppe" to "VKGELNIBE"
And I save the current editor
And I close the current editor


Given I open an editor "auftrag-401" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "401"
And I set field "kunde" to "1"
And I set field "vom" to "."
And I set field "schlag" to "Sonderfall 401"
And I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "119" in row 1
And I set field "wtrterm" to "." in row 1
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
# Kostenverteiler 302kv eintragen - mit gesperrten Objekten
Then field "kstelle" is modifiable in row 1
And I set field "kstelle" to "302kv" in row 1
And I save the current editor
And I close the current editor


# Lieferschein aus Auftrag
Given I open an editor "lieferschein-401" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-401"
And I set field "num3" to "401-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
Then field "kontosperredeakt" has value "ja" in row 1
Then field "kstellesperredeakt" has value "nein" in row 1
Then field "kstelle" is modifiable in row 1
Then field "kstelle" has value "302kv" in row 1
# 3602  |Kostenverteiler enthaelt gesperrte Objekte.
And saving the current editor throws the exception "3602"
And I set field "kstelle" to "300kv" in row 1
And I save the current editor
And I close the current editor
######################################################################################################################################

