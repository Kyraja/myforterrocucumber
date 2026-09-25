# *****************************************************************************
#  Name             : rewe_objektsperren_ev_000_vorbereitung.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Hier werden benoetigte Stammdaten angelegt/angepasst
#  
# *****************************************************************************

@persistent
Feature: rewe_objektsperren_ev_000_vorbereitung.feature
Background:
Given I set the fake date to "01.02.2001"




Scenario Outline: Standardwarengruppen vorbereiten

# Warengruppe
Given I open an editor "warengruppe-<nummer>" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "<nummer>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I save the current editor

Examples:

 |nummer|such     |namebspr                                  |
 | 55a  |UMLAGERN1|EK Umlagern1, bvabohnezu hat KoRe-Zwang   |
 | 55aa |UMLAGERN2|EK Umlagern2, bvausumlagzu hat KoRe-Zwang |
 | 55b  |GELNBERCH|EK, noch nicht berechnete Bestand         |
 | 55c  |VKGELNIBE|VK, geliefert nicht berechnet             |
# | 55d  |ARTBEDA|Artikel bedarfsbezogen          |
# | 55e  |ARTBESZ|Artikel bedarfsbezogen Satz     |
# | 55f  |ARTAUBE|Artikel AU/BE                   |
###################################################################################################


Scenario Outline:  fuer Umlagern
#Konto bvabohnezu oder Konto bvausumlagzu in der Warengruppe Kore-Zwang hat ("kost" im Konto = ja)

# Konto
Given I open an editor "konto-<feldwg>" from table "(Account):(Account)" with command "COPY" for record "<konto>"
And I set field "nummer" to "<kontoneu>"
And I set field "such" to "<kontosuch>"
And I set field "gv" to "ja"
And I set field "kost" to "ja"
And I create a new row at the end of the table
And I set field "zkoart" to "50000" in row 1
And I save the current editor

# Warengruppe
Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "<wgnum>"
And I set field "<feldwg>" to "<kontoneu>"
And I save the current editor

Examples:

 |wgnum |feldwg      |konto|kontoneu|kontosuch|
 | 55a  |bvabohnezu  |5aoz |5aozneu |K5aozKOP |
 | 55aa |bvausumlagzu|50000|50000neu|K50000KO |
###################################################################################################


Scenario: Konto "Geliefert, nicht berechnet" bestgelniber in der Warengruppe Kore-Zwang hat ("kost" im Konto = ja)

# Konto
Given I open an editor "konto-bestgelniber" from table "(Account):(Account)" with command "COPY" for record "10900"
And I set field "nummer" to "10900b"
And I set field "such" to "K10900B"
And I set field "gv" to "ja"
And I set field "kost" to "ja"
And I create a new row at the end of the table
And I set field "zkoart" to "50000" in row 1
And I save the current editor
And I close the current editor

# Warengruppe
Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "55b"
And I set field "bestgelniber" to "10900b"
And I save the current editor
And I close the current editor
###################################################################################################


Scenario: Konto "Im Verkauf ausgeliefert, nicht berechnet" ein GuV-Konto ist und dieses GuV-Konto den Korezwang auf "ja" stehen hat

# Konto
Given I open an editor "konto-bestgelniber" from table "(Account):(Account)" with command "COPY" for record "13700"
And I set field "nummer" to "13700c"
And I set field "such" to "K13700C"
And I set field "gv" to "ja"
And I set field "kost" to "ja"
And I create a new row at the end of the table
And I set field "zkoart" to "50000" in row 1
And I save the current editor
And I close the current editor

# Warengruppe
Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "55c"
And I set field "bestausgelniber" to "13700c"
And I save the current editor
And I close the current editor
###################################################################################################


Scenario Outline: neue Kostenverteiler


# neue Kostenstelle
Given I open an editor "kstelle-<nummer>" from table "(Account):(CostCenter)" with command "COPY" for record "100"
And I set field "nummer" to "<nummer>ks"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor


# Kostenverteiler
Given I open an editor "kostver-<nummer>" from table "(Account):(CostDistribution)" with command "STORE" for record ""
And I set field "nummer" to "<nummer>kv"
And I set field "such" to "KV<nummer>"
And I set field "namebspr" to "<namebspr>"
# 1.Zeile
And I create a new row at the end of the table
And I set field "kstelle" to "100" in row 1
And I set field "proz" to "25" in row 1
# 2.Zeile
And I create a new row at the end of the table
And I set field "kstelle" to "101" in row 2
And I set field "proz" to "25" in row 2
# 3.Zeile
And I create a new row at the end of the table
And I set field "kstelle" to "<nummer>ks" in row 3
And I set field "proz" to "50" in row 3
And I save the current editor
And I close the current editor


# die neue Kostenstelle wird nachtraeglich gesperrt
Given I open an editor "kstelle-<nummer>" from table "(Account):(CostCenter)" with command "UPDATE" for record "<nummer>ks"
And I set field "sperrkonfigurationneu" to "<sperre>"
And I save the current editor

Examples:
 |nummer|namebspr               |sperre                      |
 | 300  |Normal                 |                            |
 | 301  |Normal                 |                            |
 | 302  |Mit gesperrten Objekten|Standard-Kostenstellensperre|
 | 303  |Mit gesperrten Objekten|Standard-Kostenstellensperre|
 | 304  |Mit gesperrten Objekten|Standard-Kostenstellensperre|
###################################################################################################

