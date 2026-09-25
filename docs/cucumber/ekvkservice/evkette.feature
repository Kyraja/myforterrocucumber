@persistent
Feature: EVKETTE: Kundenanlieferung
Background:
Given I set the fake date to "02.01.1995"
# *****************************************************************************
#  Name           : evkette.feature
#  Autor          : cl
#  Verantwortlich : teampss
#  Funktion       : Cucumber Tests fuer EVKETTE zur Kundenanlieferungen
#
# *****************************************************************************

@Infosystem_EVKETTE
Scenario:  Infosystem starten EVKETTE
Given I open the infosystem "EVKETTE"
And I set field "vorgang" to "200001"
And I set field "richtung" to "vorwaerts"
And I press button "bstart"
Then the table has 6 rows

Then table has values
    | tstufe   | tvorgang  | vart                           | mge | tvorp^id^artex |
    | 0        | V 200001  | Auftrag                        | -20 | V1             |
    | 1        | V +300003 | Stornierte Kundenanlieferung   | -20 | V1             |
    | 1        | V +300004 | Storno-Kundenanlieferung       | 20  | V1             |
    | ----     |           | ------------------------------ | 0   |                |
    | 0        | V 200001  | Auftrag                        | 13  | V2             |
    | 1        | V 300002  | Lieferschein                   | 10  | V2             |


Scenario:  Infosystem starten EVKETTE
Given I open the infosystem "EVKETTE"
And I set field "vorgang" to "+200002"
And I set field "richtung" to "vorwaerts"
And I press button "bstart"
Then the table has 2 rows

Then table has values
    | tstufe   | tvorgang  | vart                           | mge | tvorp^id^artex |
    | 0        | V +200002 | Auftrag                        | -5  | V1             |
    | 1        | V 300006  | Kundenanlieferung              | -5  | V1             |


Scenario:  Infosystem starten EVKETTE
Given I open the infosystem "EVKETTE"
And I set field "vorgang" to "200003"
And I set field "richtung" to "vorwaerts"
And I press button "bstart"
Then the table has 3 rows

Then table has values
    | tstufe   | tvorgang  | vart                           | mge | tvorp^id^artex |
    | 0        | V 200003  | Auftrag                        | -20 | V1             |
    | 1        | V +300009 | Stornierte Kundenanlieferung   | -20 | V1             |
    | 1        | V +300010 | Storno-Kundenanlieferung       | 20  | V1             |


Scenario:  Infosystem starten EVKETTE
Given I open the infosystem "EVKETTE"
And I set field "vorgang" to "200004"
And I set field "richtung" to "vorwaerts"
And I press button "bstart"
Then the table has 3 rows

Then table has values
    | tstufe   | tvorgang  | vart                           | mge | tvorp^id^artex |
    | 0        | V 200004  | Auftrag                        | -5  | V1             |
    | 1        | V +300012 | Kundenanlieferung              | -2  | V1             |
    | 2        | V +400002 | Kaufmännische Gutschrift      | -2  | V1             |

