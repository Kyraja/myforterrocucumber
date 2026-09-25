# **********************************************************************************
#  Name             : Chargenverfolgung_Scenario05.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Bei Umlagerung ohne Umchargieren, wird keine Chargenverfolgung erzeugt
#  ref              : ref_chargenverfolgung_cu
#
# **********************************************************************************

@persistent
Feature: Chargenverfolgung_Scenario05.feature

Background:
And I set the fake date to "16.01.1995"

@Scenario05
Scenario: 05 Umlagerungslieferschein im Einkauf ohne Umchargieren erzeugt keine Chargenverfolgung

Given I create a Lot "CHAB5-1" for Product "EK02_CHARGE"

Given I open an editor "5-1ekls" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | nummer   | 5-1ekls      |
    | bsart    | Umlagern     |
    | lief     | 1            |
    | vom      | .            |
    | ebeleg   | Umlagern 5-1 |
    | ueb      | ja           |
And I append rows
    | artikel     | mge | abplatz | platz | charge      |
    | EK02_CHARGE | 20  | F1      | L3F1  | !CHAB5-1^id |
And I save the current editor


# Chargenverfolgung pruefen
Given I query "nummer,fartikel,zbeweg,ncharge,elex,reserv,vcharge" from table "(Lots):(LotTracking)" where "fartikel==EK02_CHARGE;ncharge^exnum==CHAB5-1;zbeweg^nummer==5-1ekls;elex==EK02_CHARGE;reserv==`;vcharge^exnum==CHAB5-1"
Then query has no hits

