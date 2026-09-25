@persistent
Feature: CEPI_Sperrmodus_Gesperrt_INDIVIDUELL.feature

Background:
Given I set the operation language to "DEUTSCH"
Given I set the fake date to "06.02.1995"

# *****************************************************************************
#  Name             : CEPI_Sperrmodus_Gesperrt_INDIVIDUELL
#  Autor            : bschiga
#  Verantwortlich   : bheim
#  Kontrolle        : drpf
#  Funktion         : Testet individuelle Sperrkonfiguration
#  ref              : ref_cepi_individuell_cu
#
# *****************************************************************************

Scenario: Individuelle Sperrkonfiguration anlegen

Given I open an editor "Verweissperrstelle" from table "(LockConfiguration):(LockableReferences)" with command "COPY" for record "PRODUCT-PURCH-LOCK"
And I set fields
    | such      | PRODUCT-PURCH-LOCK-IND                    |
    | namebspr  | Artikel im Einkauf mit Sperre individuell |
Then table has values
    | verweisfeldingruppe   |
    | V-04-22               |
    | V-04-23               |
    | V-04-24               |
    | V-04-07               |
And I delete row at position 3
And I modify table
    | !row                              | bedingungsfeld    |
    | verweisfeldingruppe=='V-04-23'    |                   |
And I save the current editor

Given I open an editor "Sperrkonfiguration" from table "(LockConfiguration):(LockConfiguration)" with command "COPY" for record "PRODUCTLOCK"
And I set fields
    | such      | PRODUCTLOCKIND                |
    | namebspr  | Individuelle Artikelsperre    |
    | classname | ArticleIndividuell            |
And I modify table
    | !row                                              | verweissperrstellen       | aktiv         |
    | verweissperrstellen=='PRODUCT-PURCH-LOCK'         | PRODUCT-PURCH-LOCK-IND    | !dontChange   |
    | prozesssperrstelle=='POST-SALES-PACK-SLIP'        | !dontChange               | nein          |
    | prozesssperrstelle=='SCHED-PROC-SUGGEST'          | !dontChange               | nein          |
    | prozesssperrstelle=='SCHED-MATERIAL-ALLOCATIONS'  | !dontChange               | nein          |
    | prozesssperrstelle=='ORDER-PROD-LIST-SCHED'       | !dontChange               | nein          |
And I save the current editor

Given I open an editor "Aufzaehlung" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "ARTIKELSPERRE"
And I set field "reosofort" to "ja"
And I create a new row at position !lastRow
And I modify table
    | !row      | aufzelem       | aeaktiv  |
    | !lastRow  | PRODUCTLOCKIND | ja       |
And I save the current editor

Scenario Outline: Artikel anlegen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such                  | <such>                    |
    | namebspr              | <namebspr>                |
    | bsart                 | Fremdbeschaffung          |
    | dispoa                | <dispoa>                  |
    | lief                  | <lief>                    |

And I save the current editor

Examples:
    | such              | namebspr            | dispoa            | lief  |
    | INDIV_SPERR       | individuelle Sperre | auftragsbezogen   | TEST  |
    | STANDARD_SPERR    | Standard Sperre     | bedarfsbezogen    | TEST  |
    | IND_SPERR_EINPL   | individuelle Sperre | auftragsbezogen   | TEST  |


Scenario: 01 Unterschied Prozesssperrstelle Hinweis und Gesperrt im bereits erstellten VK-LS

Given I create a SalesOrder "HINWEIS" for Customer "Test" with Product "INDIV_SPERR" and quantity "10"
Given I create a SalesOrder "GESPERRT" for Customer "Test" with Product "STANDARD_SPERR" and quantity "10"

# Lieferscheine erstellen, nicht buchen
Given I open an editor "HINWEIS" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "HINWEIS"
And I set fields
   | such   | VKLS_H    |
   | vom    | .         |
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "GESPERRT" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "GESPERRT"
And I set fields
   | such   | VKLS_G    |
   | vom    | .         |
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "INDIV_SPERR" from table "(Part):(Product)" with command "UPDATE" for record "INDIV_SPERR"
And I set field "sperrkonfigurationneu" to "Individuelle Artikelsperre"
And I save the current editor

Given I open an editor "STANDARD_SPERR" from table "(Part):(Product)" with command "UPDATE" for record "STANDARD_SPERR"
And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
And I save the current editor

# fuer Artikel mit Prozesssperrstelle "Hinweis" kann der VK-LS gebucht werden
Given I open an editor "VKLS_H" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "VKLS_H"
And I set field "ueb" to "ja"
And I save the current editor

# fuer Artikel mit Prozesssperrstelle "Gesperrt" kann der VK-LS NICHT gebucht werden
Given I open an editor "VKLS_G" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "VKLS_G"
And I set field "ueb" to "ja"
# 4806 Objekt ist gesperrt
Then saving the current editor throws the exception "4806"
And I close the current editor


Scenario: 02 individuelle Verweissperrstelle Einkauf OHNE Gruppe EK-Rechnung, EK-Rechnung kann neu erstellt werden

Given I open an editor "EKRE-HINWEIS" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | Test     |
    | such   | EK-RE-H  |
    | ebeleg | EK-RE-H  |
    | vom    | .        |
    | tterm  | .        |
    | fakt   | ja       |
And I append rows
    | artikel       | mge |
    | INDIV_SPERR   | 10  |
And I save the current editor

Given I open an editor "EKRE-GESPERRT" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | Test     |
    | such   | EK-RE-G  |
    | ebeleg | EK-RE-G  |
    | vom    | .        |
    | tterm  | .        |
    | fakt   | ja       |
And I create a new row at position 1
# STANDARD_SPERR Standard Sperre Artikel ist mit "Standard-Artikelsperre" gesperrt.
Then setting field "artikel" to "STANDARD_SPERR" in row 1 throws the exception ""
And I close the current editor


Scenario: 03 individuelle Verweissperrstelle Einkaufslieferschein, Bedingung artsperredeakt ist NICHT eingetragen, Stornobeleg kann NICHT gespeichert werden

Given I open an editor "INDIV_SPERR" from table "(Part):(Product)" with command "UPDATE" for record "INDIV_SPERR"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor

Given I open an editor "EKLS-HINWEIS" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | Test         |
    | such   | EK-LS-HIN    |
    | ebeleg | EK-LS-HIN    |
    | vom    | .            |
    | tterm  | .            |
    | ueb    | ja           |
And I append rows
    | artikel       | mge |
    | INDIV_SPERR   | 10  |
And I save the current editor

Given I open an editor "INDIV_SPERR" from table "(Part):(Product)" with command "UPDATE" for record "INDIV_SPERR"
And I set field "sperrkonfigurationneu" to "Individuelle Artikelsperre"
And I save the current editor

Given I open an editor "EKLS-HINWEIS" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "EK-LS-HIN"
# 100086 HINWEISTEST Einkaufsteil Artikel ist mit "Individuelle Artikelsperre" gesperrt.
Then saving the current editor throws the exception "4806"
And I close the current editor

Given I open an editor "INDIV_SPERR" from table "(Part):(Product)" with command "UPDATE" for record "INDIV_SPERR"
And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
And I save the current editor

Given I open an editor "EKLS-HINWEIS" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "EK-LS-HIN"
And I save the current editor


Scenario: 04 Prozessperrstelle SCHED-PROC-SUGGEST von Hinweis auf Gesperrt aendern, Dispoanstoss und Bestellvorschlaege werden geloescht

And I set StorageQuantity to zero for Product "INDIV_SPERR" on StorageLocation "F1"

Given I open an editor "INDIV_SPERR" from table "(Part):(Product)" with command "UPDATE" for record "INDIV_SPERR"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor

Given I create a SalesOrder "DISPO" for Customer "Test" with Product "INDIV_SPERR" and quantity "100"

And I run Scheduling

Given I open an editor "INDIV_SPERR" from table "(Part):(Product)" with command "UPDATE" for record "INDIV_SPERR"
And I set field "sperrkonfigurationneu" to "Individuelle Artikelsperre"
And I save the current editor

And I run Scheduling

Given I open an editor "Bestellvorschlaege" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "INDIV_SPERR"
And I press button "ladetab"
Then the table has 1 rows
And I close the current editor

Given I open the infosystem "PLANKARTE"
And I set field "kart" to "INDIV_SPERR"
And I press start
Then field "hinweis" is empty
Then the table has 3 rows
And I close the current editor

Given I open an editor "Sperrkonfiguration" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "PRODUCTLOCKIND"
And I modify table
    | !row                                          | aktiv         |
    | prozesssperrstelle=='SCHED-PROC-SUGGEST'      | ja            |
And I save the current editor

Given I open the infosystem "PLANKARTE"
And I set field "kart" to "INDIV_SPERR"
And I press start
Then field "hinweis" has value "Plankarte muss von der Disposition noch aktualisiert werden"
And I close the current editor

And I run Scheduling

Given I open the infosystem "PLANKARTE"
And I set field "kart" to "INDIV_SPERR"
And I press start
Then field "hinweis" is empty
Then the table has 2 rows
And I close the current editor

Given I open an editor "Bestellvorschlaege" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "INDIV_SPERR"
And I press button "ladetab"
Then the table has 0 rows
And I close the current editor

Given I open an editor "Sperrkonfiguration" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "PRODUCTLOCKIND"
And I modify table
    | !row                                          | aktiv         |
    | prozesssperrstelle=='SCHED-PROC-SUGGEST'      | nein          |
And I save the current editor

And I run Scheduling

Given I open an editor "Bestellvorschlaege" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "INDIV_SPERR"
And I press button "ladetab"
Then the table has 1 rows
And I close the current editor

# Mindestbestand eintragen
Given I open an editor "INDIV_SPERR" from table "(Part):(Product)" with command "UPDATE" for record "INDIV_SPERR"
And I set field "mindest" to "200"
And I save the current editor

And I run Scheduling

# BV als Mindestbestandsauffueller wird erstellt
Given I open an editor "Bestellvorschlaege" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "INDIV_SPERR"
And I press button "ladetab"
Then the table has 2 rows
And I close the current editor

Given I open an editor "Sperrkonfiguration" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "PRODUCTLOCKIND"
And I modify table
    | !row                                              | aktiv         |
    | prozesssperrstelle=='SCHED-MATERIAL-ALLOCATIONS'  | ja            |
And I save the current editor

Given I open the infosystem "PLANKARTE"
And I set field "kart" to "INDIV_SPERR"
And I press start
Then field "hinweis" is not empty
And I close the current editor

And I run Scheduling

# BV wurden geloescht
Given I open an editor "Bestellvorschlaege" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "INDIV_SPERR"
And I press button "ladetab"
Then the table has 0 rows
And I close the current editor

# Bedarf aus Auftragsposition bleibt in der Plankarte, keine Beschaffer, da keine MZ
Given I open the infosystem "PLANKARTE"
And I set field "kart" to "INDIV_SPERR"
And I press start
Then field "hinweis" is empty
Then the table has 2 rows
Then table has values
    |!row   | abgang    | vart      |
    | 2     | 100       | Auftrag   |
And I close the current editor

# Auftrag stornieren, um aufzurauemen fuer weitere Szenarien
Given I open an editor "DISPO" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "DISPO"
And I respond with answer "ja" to the dialog with id ""
And I set field "mge" to "0" in row 1
And I save the current editor


Scenario: 05 Prozessperrstellen SCHED-PROC-SUGGEST und ORDER-PROD-LIST-SCHED gemeinsam von Hinweis auf Gesperrt aendern, Auftragsposition bleibt eingeplant, BV wird geloescht

Given I create a SalesOrder "EINPLAN" for Customer "Test" with Product "IND_SPERR_EINPL" and quantity "100"

And I run Scheduling

Given I open an editor "Sperrkonfiguration" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "PRODUCTLOCKIND"
And I modify table
    | !row                                              | aktiv         |
    | prozesssperrstelle=='SCHED-MATERIAL-ALLOCATIONS'  | nein          |
And I save the current editor

Given I open an editor "IND_SPERR_EINPL" from table "(Part):(Product)" with command "UPDATE" for record "IND_SPERR_EINPL"
And I set field "sperrkonfigurationneu" to "Individuelle Artikelsperre"
And I set field "mindest" to "500"
And I save the current editor

And I run Scheduling

Given I open an editor "Bestellvorschlaege" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "IND_SPERR_EINPL"
And I press button "ladetab"
Then the table has 2 rows
And I close the current editor

Given I open the infosystem "PLANKARTE"
And I set field "kart" to "IND_SPERR_EINPL"
And I press start
Then field "hinweis" is empty
Then the table has 4 rows
And I close the current editor

Given I open an editor "Sperrkonfiguration" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "PRODUCTLOCKIND"
And I modify table
    | !row                                          | aktiv         |
    | prozesssperrstelle=='SCHED-PROC-SUGGEST'      | ja            |
    | prozesssperrstelle=='ORDER-PROD-LIST-SCHED'   | ja            |
And I save the current editor

Given I open the infosystem "PLANKARTE"
And I set field "kart" to "IND_SPERR_EINPL"
And I press start
Then field "hinweis" has value "Plankarte muss von der Disposition noch aktualisiert werden"
And I close the current editor

And I run Scheduling

# Auftragsposition bleibt eingeplant, Bestellvorschlag wird geloescht
Given I open the infosystem "PLANKARTE"
And I set field "kart" to "IND_SPERR_EINPL"
And I press start
Then field "hinweis" is empty
Then the table has 2 rows
And I close the current editor

Given I open an editor "Bestellvorschlaege" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "IND_SPERR_EINPL"
And I press button "ladetab"
Then the table has 0 rows
And I close the current editor

# nur BV einplanen wieder auf Hinweis setzen
Given I open an editor "Sperrkonfiguration" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "PRODUCTLOCKIND"
And I modify table
    | !row                                          | aktiv         |
    | prozesssperrstelle=='SCHED-PROC-SUGGEST'      | nein          |
And I save the current editor

And I run Scheduling

Given I open an editor "Bestellvorschlaege" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "IND_SPERR_EINPL"
And I press button "ladetab"
Then the table has 2 rows
And I close the current editor


Scenario: 06 Reservierung bleibt eingeplant, auch wenn ORDER-PROD-LIST-SCHED und SCHED-PROC-SUGGEST auf gesperrt gesetzt werden

Given I create a work order "WO" for Product "BG1" with quantity "15" and search word "WO_"

# pruefen ob AFL-Zeile eingeplant ist
Given I open an editor "WOPRUEF" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "WO_000"
And I press button "absteig" to open a subeditor for "AFL"
Then field "einplan" has value "ja" in row 1
And I close the current editor
And I switch the current editor to editor "WOPRUEF"
And I close the current editor

Given I open an editor "Sperrkonfiguration" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "PRODUCTLOCKIND"
And I modify table
    | !row                                          | sperrwirkung  |
    | prozesssperrstelle=='SCHED-PROC-SUGGEST'      | Gesperrt      |
    | prozesssperrstelle=='ORDER-PROD-LIST-SCHED'   | Gesperrt      |
And I save the current editor

Given I open an editor "E1" from table "(Part):(Product)" with command "UPDATE" for record "E1"
And I set field "sperrkonfigurationneu" to "Individuelle Artikelsperre"
And I save the current editor

And I run Scheduling

# pruefen ob AFL-Zeile eingeplant ist
Given I open an editor "WOPRUEF" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "WO_000"
And I press button "absteig" to open a subeditor for "AFL"
Then field "einplan" has value "ja" in row 1
And I close the current editor
And I switch the current editor to editor "WOPRUEF"
And I close the current editor
