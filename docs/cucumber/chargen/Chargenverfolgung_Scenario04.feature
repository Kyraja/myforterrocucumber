# **********************************************************************************
#  Name             : Chargenverfolgung_Scenario04.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : amk
#  Funktion         : Chargenverfolgung durch Rueckmeldung neu
#  ref              : ref_chargenverfolgung_cu
#
# **********************************************************************************

@persistent
Feature: Chargenverfolgung_Scenario04.feature

Background:
And I set the fake date to "16.01.1995"

@Scenario04
Scenario: 04 Chargenverfolgung ueber Rueckmeldung neu erzeugen und wieder stornieren

Given I create a Lot "CHZU4-1" for Product "BG02_CHARGE"
Given I create a Lot "CHAB4-1" for Product "EK02_CHARGE"

Given I open an editor "RMneu1" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record ""
Then field "typa279" has value "Rückmeldung ohne Fertigungsvorschlag"
And I set fields
    | barmex  | 123         |
    | such    | RMohneFVhk  |
    | artikel | BG02_CHARGE |
    | kcharge | !CHZU4-1^id |
    | mgr     | 101         |
    | kstelle | 100000      |
    | lgr     | 2           |
    | mzeit   | 1           |
    | bzeit   | 2           |
And I append rows
    | artikel     | mge | gutmge | charge      |
    | EK02_CHARGE | 2   | 3      | !CHAB4-1^id |
And I save the current editor

# Chargenverfolgung pruefen
Given I open an editor "chverf_BG02_CHARGE" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,fartikel==BG02_CHARGE;ncharge^exnum==CHZU4-1;vcharge^exnum==CHAB4-1;elex==EK02_CHARGE;"
Then field "fartikel^such" has value "BG02_CHARGE"
Then field "zbeweg^id" has value equal to field "id" from editor "RMneu1"
Then field "tncharge" has value "CHZU4-1"
Then field "elex^such" has value "EK02_CHARGE"
Then field "reserv" is empty
Then field "tvcharge" has value "CHAB4-1"
Then field "gltvon" is not empty
Then field "gltbis" is empty
Then field "chverfherkunft" has value "automatisch"
And I close the current editor

# Rueckmeldung <Neu> stornieren
Given I open an editor "RMneuStorno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RMneu1"
Then field "typa279" has value "Storno-Rückmeldung ohne Fertigungsvorschlag"
And I set field "bem" to "Storno RMneu1"
And I save the current editor

# Chargenverfolgung bekommt "gueltig bis" Eintrag und Herkunft "Storno"
Given I open an editor "chverf_BG02_CHARGE" via ID from editor "chverf_BG02_CHARGE" from field "id" in row 0 for table "(Lots):(LotTracking)" with command "VIEW"
Then field "gltvon" is not empty
Then field "gltbis" is not empty
Then field "chverfherkunft" has value "Storno"
And I close the current editor
