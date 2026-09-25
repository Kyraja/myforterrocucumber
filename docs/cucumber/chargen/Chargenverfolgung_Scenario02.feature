# **********************************************************************************
#  Name             : Chargenverfolgung_Scenario02.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : bschiga
#  Funktion         : Testet die Chargenverfolgung fuer Storno, Rueckbau und Storno-Rueckbau
#  ref              : ref_chargenverfolgung_cu
#
# **********************************************************************************

@persistent
Feature: Chargenverfolgung_Scenario02.feature

Background:
And I set the fake date to "16.01.1995"
@Scenario02
Scenario: 02 Chargenverfolgung bei Storno und Materialrueckgabe

Given I create a work order "BA_CHVERF02" for Product "BG01_CHARGE" with quantity "50" and search word "CHVERF02_"

Given I create a Lot "CHZU1" for Product "BG01_CHARGE"
Given I create a Lot "CHZU2" for Product "BG01_CHARGE"
Given I create a Lot "CHAB1" for Product "EK01_CHARGE"
Given I create a Lot "CHAB2" for Product "EK01_CHARGE"

Given I open an editor "BA_CHVERF02_000_01" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "CHVERF02_000"
And I press button "absteig" to open a subeditor for "AFL"
And I delete row at position 3
And I save value from field "id" in row 1
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge    |
    | +1    | F1     | 50       | CHAB1      |
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I switch the current editor to editor "BA_CHVERF02_000_01"
And I save the current editor

# Rueckmeldung auf zweiten Arbeitsschein, Zugangsbuchung
Given I open an editor "RM_CHVERF02_002_01" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=CHVERF02_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "tkcharge" to "CHZU1"
And I set field "sofort" to "ja"
And I modify table
    | !row  | artikel     | mge         | gutmge      | erbtext1 | tcharge     |
    | 1     | !dontChange | !dontChange | 5           | RM1      | !dontChange |
And I save the current editor

# Weitere Rueckmeldung auf zweiten Arbeitsschein, Zugangsbuchung
Given I open an editor "RM_CHVERF02_002_02" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=CHVERF02_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "tkcharge" to "CHZU2"
And I set field "sofort" to "ja"
And I modify table
    | !row  | artikel     | mge         | gutmge      | erbtext1 | tcharge     |
    | 1     | !dontChange | !dontChange | 10          | RM2      | !dontChange |
And I save the current editor

# Chargenverfolgung pruefen
Given I open an editor "chverf_BG01_CHARGE_01" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHZU1;vcharge^exnum==CHAB1;elex==EK01_CHARGE;"
Then field "fartikel^such" has value "BG01_CHARGE"
Then field "tncharge" has value "CHZU1"
Then field "elex^such" has value "EK01_CHARGE"
Then field "reserv^id" in row 0 equals saved value
Then field "tvcharge" has value "CHAB1"
Then field "gltvon" is not empty
Then field "gltbis" is empty
Then field "chverfherkunft" has value "automatisch"
And I close the current editor

Given I open an editor "chverf_BG01_CHARGE_02" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHZU2;vcharge^exnum==CHAB1;elex==EK01_CHARGE;"
Then field "fartikel^such" has value "BG01_CHARGE"
Then field "tncharge" has value "CHZU2"
Then field "elex^such" has value "EK01_CHARGE"
Then field "reserv^id" in row 0 equals saved value
Then field "tvcharge" has value "CHAB1"
Then field "gltvon" is not empty
Then field "gltbis" is empty
Then field "chverfherkunft" has value "automatisch"
And I close the current editor

# Zweite RM komplett wegstornieren
Given I open an editor "RM_CHVERF02_002_02_Storno" via ID from editor "RM_CHVERF02_002_02" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
And I save the current editor

# Chargenverfolgung bekommt "gueltig bis" Eintrag und Herkunft "Storno"
Given I open an editor "chverf_BG01_CHARGE_02" via ID from editor "chverf_BG01_CHARGE_02" from field "id" in row 0 for table "(Lots):(LotTracking)" with command "VIEW"
Then field "gltvon" is not empty
Then field "gltbis" is not empty
Then field "chverfherkunft" has value "Storno"
And I close the current editor

# Rueckgabe Teilmenge ueber Rueckmeldung
Given I open an editor "RM_CHVERF02_002_01_Rueckbau_01" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "CHVERF02_002"
And I set field "tkcharge" to "CHZU1"
And I set field "sofort" to "ja"
And I modify table
    | !row  | gutmge    |
    | 1     | -2        |
And I save the current editor

# Chargenverfolgung bleibt aktiv, da nicht die gesamte Mengen zurueckgegeben wurde.
Given I open an editor "chverf_BG01_CHARGE_01" via ID from editor "chverf_BG01_CHARGE_01" from field "id" in row 0 for table "(Lots):(LotTracking)" with command "VIEW"
Then field "gltvon" is not empty
Then field "gltbis" is empty
Then field "chverfherkunft" has value "automatisch"
And I close the current editor

# Weitere Rueckgabe, Restmenge zurueckgeben ueber Fbuch
Given I open an editor "RM_CHVERF02_001_01_Rueckbau_02" for tip command "(WOIssue)" and arguments ""
And I set fields
    | auftrag     | CHVERF02_001           |
    | gmgevorschl | -3                     |
    | autorment   | ja                     |
    | bem         | RueckgabeRM1           |
    | tcharge     | CHZU1                  |
And I press button "stllad"
And I modify table
    | !row                | tvcharge  |
    | elex=='EK01_CHARGE' | CHAB1     |
And I save the current editor

# Chargenverfolgung bekommt "gueltig bis" Eintrag und Herkunft "Rueckbau Fertiung"
Given I open an editor "chverf_BG01_CHARGE_01" via ID from editor "chverf_BG01_CHARGE_01" from field "id" in row 0 for table "(Lots):(LotTracking)" with command "VIEW"
Then field "gltvon" is not empty
Then field "gltbis" is not empty
Then field "chverfherkunft" has value "Rückbau Fertigung"
And I close the current editor

# Rueckbau stornieren
Given I open an editor "RM_CHVERF02_001_01_StornoRueckbau" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=CHVERF02_001;bem=RueckgabeRM1;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
And I save the current editor

# Urspruengliche Chargenverfolgung ist unveraendert
Given I open an editor "chverf_BG01_CHARGE_01" via ID from editor "chverf_BG01_CHARGE_01" from field "id" in row 0 for table "(Lots):(LotTracking)" with command "VIEW"
Then field "gltvon" is not empty
Then field "gltbis" is not empty
Then field "vorgaenger" is empty
Then field "chverfherkunft" has value "Rückbau Fertigung"
And I close the current editor

# Zusaetzlich wurde eine neue Chargenverfolgung angelegt
Given I open an editor "chverf_BG01_CHARGE_02" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHZU1;vcharge^exnum==CHAB1;elex==EK01_CHARGE;gltbis==`;"
Then field "fartikel^such" has value "BG01_CHARGE"
Then field "tncharge" has value "CHZU1"
Then field "elex^such" has value "EK01_CHARGE"
Then field "reserv^id" in row 0 equals saved value
Then field "tvcharge" has value "CHAB1"
Then field "gltvon" is not empty
Then field "gltbis" is empty
Then field "vorgaenger^id" has value equal to field "id" from editor "chverf_BG01_CHARGE_01" in row 0
Then field "chverfherkunft" has value "Storno-Rückbau Fertigung"
