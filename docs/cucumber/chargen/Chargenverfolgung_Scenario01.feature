# **********************************************************************************
#  Name             : Chargenverfolgung_Scenario01.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : bschiga
#  Funktion         : Testet die Chargenverfolgung fuer Storno, Rueckbau und Storno-Rueckbau
#  ref              : ref_chargenverfolgung_cu
#
# **********************************************************************************

@persistent
Feature: Chargenverfolgung_Scenario01.feature

Background:
And I set the fake date to "16.01.1995"

@Scenario01
Scenario: 01 Chargenverfolgung bei zusaetzlicher Entnahme

Given I create a work order "BA_WOC01" for Product "BG01_CHARGE" with quantity "50" and search word "WOC01_"

Given I create a Lot "C01CHZUS" for Product "BG01_CHARGE"
Given I create a Lot "C02CHZUS" for Product "BG01_CHARGE"
Given I create a Lot "WOC01ZENT" for Product "EK03_CHARGE"
Given I create a Lot "WOC02ZENT" for Product "EK03_CHARGE"

# Rueckmeldung auf BA mit zusaetzlich entnommenem Material
Given I open an editor "RM_WOC01_000_01" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=WOC01_000;@richtung=rückwärts;@maxordtreffer=1"
And I set field "tkcharge" to "C01CHZUS"
And I set field "mgr" to "112"
And I set field "sofort" to "ja"
And I modify table
    | !row  | artikel     | mge         | gutmge      | erbtext1 | tcharge     |
    | 1     | !dontChange | !dontChange | 5           | RM1      | !dontChange |
    | +2    | EK03_CHARGE | 5           | !dontChange | ZE1      | WOC01ZENT   |
And I save the current editor

# Weitere Rueckmeldung auf BA mit zusaetzlich entnommenem Material
Given I open an editor "RM_WOC01_000_02" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=WOC01_000;@richtung=rückwärts;@maxordtreffer=1"
And I set field "tkcharge" to "C02CHZUS"
And I set field "mgr" to "112"
And I set field "sofort" to "ja"
And I modify table
    | !row  | artikel     | mge         | gutmge      | erbtext1 | tcharge     |
    | 1     | !dontChange | !dontChange | 5           | RM2      | !dontChange |
    | +2    | EK03_CHARGE | 10          | !dontChange | ZE2      | WOC02ZENT   |
And I save the current editor

# Chargenverfolgung pruefen
Given I open LotTracking "chverf_BG01_CHARGE_01" for receipt Lot "C01CHZUS" and issue Lot "WOC01ZENT" and product list element "EK03_CHARGE" and receipt movement "BA_WOC01" with command "VIEW"
Then field "fartikel^such" has value "BG01_CHARGE"
Then field "tncharge" has value "C01CHZUS"
Then field "elex^such" has value "EK03_CHARGE"
Then field "reserv" is empty
Then field "tvcharge" has value "WOC01ZENT"
Then field "gltvon" is not empty
Then field "gltbis" is empty
Then field "chverfherkunft" has value "automatisch"
And I close the current editor

Given I open LotTracking "chverf_BG01_CHARGE_02" for receipt Lot "C02CHZUS" and issue Lot "WOC02ZENT" and product list element "EK03_CHARGE" and receipt movement "BA_WOC01" with command "VIEW"
Then field "fartikel^such" has value "BG01_CHARGE"
Then field "tncharge" has value "C02CHZUS"
Then field "elex^such" has value "EK03_CHARGE"
Then field "reserv" is empty
Then field "tvcharge" has value "WOC02ZENT"
Then field "gltvon" is not empty
Then field "gltbis" is empty
Then field "chverfherkunft" has value "automatisch"
And I close the current editor

# Zweite RM komplett wegstornieren
Given I open an editor "RM_WOC01_000_02_Storno" via ID from editor "RM_WOC01_000_02" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
And I save the current editor

# Chargenverfolgung bekommt "gueltig bis" Eintrag und Herkunft "Storno"
Given I open an editor "chverf_BG01_CHARGE_02" via ID from editor "chverf_BG01_CHARGE_02" from field "id" in row 0 for table "(Lots):(LotTracking)" with command "VIEW"
Then field "gltvon" is not empty
Then field "gltbis" is not empty
Then field "chverfherkunft" has value "Storno"
And I close the current editor

# Rueckgabe auf zusaetzliche Entnahme - Teilmenge ueber Rueckmeldung
Given I open an editor "RM_WOC01_000_01_Rueckbau_01" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "WOC01_000"
And I set field "tkcharge" to "C01CHZUS"
And I set field "mgr" to "112"
And I set field "sofort" to "ja"
And I modify table
    | !row                      | mge | tcharge   |
    | artikel=='EK03_CHARGE'    | -2  | WOC01ZENT |
And I save the current editor

# Chargenverfolgung bleibt aktiv, da nicht die gesamte Mengen zurueckgegeben wurde.
Given I open an editor "chverf_BG01_CHARGE_01" via ID from editor "chverf_BG01_CHARGE_01" from field "id" in row 0 for table "(Lots):(LotTracking)" with command "VIEW"
Then field "gltvon" is not empty
Then field "gltbis" is empty
Then field "chverfherkunft" has value "automatisch"
And I close the current editor

# Weitere Rueckgabe auf zusaetzliche Entnahme - Restmenge zurueckgeben ueber Fbuch
Given I open an editor "RM_WOC01_000_01_Rueckbau_02" for tip command "(WOIssue)" and arguments ""
And I set fields
    | auftrag     | WOC01_000              |
    | gmgevorschl | -3                     |
    | bem         | RueckgabeBA1           |
    | tcharge     | C01CHZUS               |
    | mgr         | 112                    |
And I press button "stlvblad"
And I modify table
    | !row                | bumge | tvcharge  |
    | elex=='EK03_CHARGE' | -3    | WOC01ZENT |
And I save the current editor

# Chargenverfolgung bekommt "gueltig bis" Eintrag und Herkunft "Rueckbau Fertiung"
Given I open an editor "chverf_BG01_CHARGE_01" via ID from editor "chverf_BG01_CHARGE_01" from field "id" in row 0 for table "(Lots):(LotTracking)" with command "VIEW"
Then field "gltvon" is not empty
Then field "gltbis" is not empty
Then field "chverfherkunft" has value "Rückbau Fertigung"
And I close the current editor

# Rueckbau stornieren
Given I open an editor "RM_WOC01_000_01_StornoRueckbau" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=WOC01_000;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
And I save the current editor

# Urspruengliche Chargenverfolgung ist unveraendert
Given I open an editor "chverf_BG01_CHARGE_01" via ID from editor "chverf_BG01_CHARGE_01" from field "id" in row 0 for table "(Lots):(LotTracking)" with command "VIEW"
Then field "gltvon" is not empty
Then field "gltbis" is not empty
Then field "vorgaenger" is empty
Then field "chverfherkunft" has value "Rückbau Fertigung"
And I close the current editor

# Zusaetzlich wurde eine neue Chargenverfolgung angelegt - TODO mit Anne besprechen, warum das nicht funktioniert
 Given I open an editor "chverf_BG01_CHARGE_03" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge==C01CHZUS;vcharge==WOC01ZENT;elex==EK03_CHARGE;gltbis==`;"
 Then field "fartikel^such" has value "BG01_CHARGE"
 Then field "tncharge" has value "C01CHZUS"
 Then field "elex^such" has value "EK03_CHARGE"
 Then field "reserv" is empty
 Then field "tvcharge" has value "WOC01ZENT"
 Then field "gltvon" is not empty
 Then field "gltbis" is empty
 Then field "vorgaenger^id" has value equal to field "id" from editor "chverf_BG01_CHARGE_01" in row 0
 Then field "chverfherkunft" has value "Storno-Rückbau Fertigung"
