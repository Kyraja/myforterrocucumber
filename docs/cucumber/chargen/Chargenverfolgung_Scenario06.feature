# **********************************************************************************
#  Name             : Chargenverfolgung_Scenario06.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : bschiga
#  Funktion         : Testet die Chargenverfolgung fuer Storno, Rueckbau und Storno-Rueckbau
#  ref              : ref_chargenverfolgung_cu
#
# **********************************************************************************

@persistent
Feature: Chargenverfolgung_Scenario06.feature

Background:
And I set the fake date to "16.01.1995"
@Scenario06
Scenario: 06 Chargenverfolgung bei Storno und Materialrueckgabe

Given I create a work order "BA_CHVERF06" for Product "BG01_CHARGE" with quantity "50" and search word "CHVERF06_"

Given I create a Lot "CHZU6-1" for Product "BG01_CHARGE"
Given I create a Lot "CHAB6-1" for Product "EK01_CHARGE"

Given I open an editor "BA_CHVERF06_000_01" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "CHVERF06_000"
And I press button "absteig" to open a subeditor for "AFL"
And I delete row at position 3
And I save value from field "id" in row 1
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge    |
    | +1    | F1     | 50       | CHAB6-1    |
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I switch the current editor to editor "BA_CHVERF06_000_01"
And I save the current editor

Given I open an editor "Materialentnahme_06_001_01" for tip command "(WOIssue)" and arguments ""
And I set fields
    | auftrag   | CHVERF06_001     |
    | autorment | ja               |
    | mgr       | 101              |
    | charge    | !CHZU6-1^id      |
    | bem       | Entnahme01       |
And I press button "stllad"
Then table has values
    | elex          | bumge | manbu |
    | EK01_CHARGE   | 50    | nein  |
And I modify table
    | !row | manbu | bumge | rescharge   |
    | 1    | ja    | 5     | !CHAB6-1^id |
And I save the current editor

Given I open an editor "Materialentnahme_06_001_02" for tip command "(WOIssue)" and arguments ""
And I set fields
    | auftrag   | CHVERF06_001     |
    | autorment | ja               |
    | mgr       | 101              |
    | charge    | !CHZU6-1^id      |
    | bem       | Entnahme02       |
And I press button "stllad"
Then table has values
    | elex          | bumge | manbu |
    | EK01_CHARGE   | 45    | ja    |
And I modify table
    | !row | bumge | rescharge   |
    | 1    | 10    | !CHAB6-1^id |
And I save the current editor

Given I open an editor "Materialentnahme_06_001_03" for tip command "(WOIssue)" and arguments ""
And I set fields
    | auftrag   | CHVERF06_001     |
    | autorment | ja               |
    | mgr       | 101              |
    | charge    | !CHZU6-1^id      |
    | bem       | Entnahme03       |
And I press button "stllad"
Then table has values
    | elex          | bumge | manbu |
    | EK01_CHARGE   | 35    | ja    |
And I modify table
    | !row | bumge | rescharge   |
    | 1    | 8     | !CHAB6-1^id |
And I save the current editor

# Chargenverfolgung pruefen
Given I open an editor "chverf_BG01_CHARGE_01" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHZU6-1;vcharge^exnum==CHAB6-1;elex==EK01_CHARGE;"
Then field "fartikel^such" has value "BG01_CHARGE"
Then field "tncharge" has value "CHZU6-1"
Then field "elex^such" has value "EK01_CHARGE"
Then field "reserv^id" in row 0 equals saved value
Then field "tvcharge" has value "CHAB6-1"
Then field "gltvon" is not empty
Then field "gltbis" is empty
Then field "chverfherkunft" has value "automatisch"
And I close the current editor

# Rueckbau auf die letzte Materialentnahme
Given I open an editor "RM_CHVERF06_001_01_Rueckbau_06" for tip command "(WOIssue)" and arguments ""
And I set fields
    | auftrag     | CHVERF06_001 |
    | autorment   | ja           |
    | bem         | RueckgabeMN3 |
    | charge      | !CHZU6-1^id  |
And I press button "stllad"
And I modify table
    | !row                |  bumge | rescharge   |
    | elex=='EK01_CHARGE' |  -8    | !CHAB6-1^id |
And I save the current editor

# Weitere Materialentnahmen stornieren
Given I open an editor "RM_CHVERF06_001_02_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=CHVERF06_001;bem==Entnahme02;@ablageart=abgelegt;"
And I save the current editor

Given I open an editor "RM_CHVERF06_001_01_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=CHVERF06_001;bem==Entnahme01;@ablageart=abgelegt;"
And I save the current editor

# Chargenverfolgung pruefen -> Herkunft = Storno
Given I open an editor "chverf_BG01_CHARGE_01" via ID from editor "chverf_BG01_CHARGE_01" from field "id" in row 0 for table "(Lots):(LotTracking)" with command "VIEW"
Then field "gltvon" is not empty
Then field "gltbis" is not empty
Then field "chverfherkunft" has value "Storno"
And I close the current editor

# Rueckbau stornieren
Given I open an editor "RM_CHVERF06_001_01_StornoRueckbau" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=CHVERF06_001;bem==RueckgabeMN3;@ablageart=abgelegt;"
And I save the current editor

# Urspruengliche Chargenverfolgung ist unveraendert
Given I open an editor "chverf_BG01_CHARGE_01" via ID from editor "chverf_BG01_CHARGE_01" from field "id" in row 0 for table "(Lots):(LotTracking)" with command "VIEW"
Then field "gltvon" is not empty
Then field "gltbis" is not empty
Then field "vorgaenger" is empty
Then field "chverfherkunft" has value "Storno"
And I close the current editor

# Zusaetzlich wurde eine neue Chargenverfolgung angelegt
Given I open an editor "chverf_BG01_CHARGE_02" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHZU6-1;vcharge^exnum==CHAB6-1;elex==EK01_CHARGE;gltbis==`;"
Then field "fartikel^such" has value "BG01_CHARGE"
Then field "tncharge" has value "CHZU6-1"
Then field "elex^such" has value "EK01_CHARGE"
Then field "reserv^id" in row 0 equals saved value
Then field "tvcharge" has value "CHAB6-1"
Then field "gltvon" is not empty
Then field "gltbis" is empty
Then field "vorgaenger^id" has value equal to field "id" from editor "chverf_BG01_CHARGE_01" in row 0
Then field "chverfherkunft" has value "Storno-Rückbau Fertigung"
And I close the current editor
