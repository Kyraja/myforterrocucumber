# *****************************************************************************
#  Name             : behaelter_ekls_mit_mz_scenario08.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Behaelterfelder leeren, wenn Behaelter aus Feld geloescht wird
#
# *****************************************************************************
@persistent
Feature: behaelter_ekls_mit_mz_scenario08.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Behaelter anlegen
And I create a Container "M08_BEHLEER_1" for packaging material "KLT"
And I create a Container "M08_BEHLEER_2" for packaging material "SKARTON"


Scenario: 02 Behaelterfelder werden geleert, wenn ein eingetragener Behaelter wieder aus Feld geloescht wird
Given I open an editor "EKLS08" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER  |
    | ebeleg | EKLS_M08 |
    | vom    | .        |
And I append rows
    | artikel | mge | !dialogId                                     | !dialogAnswer | exbehnum              |
    | RAD     | 10  | Externe Behälternummer ist bereits vergeben. | nein          | !M08_BEHLEER_1^nummer |
    | SATTEL  | 10  | Externe Behälternummer ist bereits vergeben. | nein          | !M08_BEHLEER_2^nummer |
Then table has values
    | behaelter^id      | packm^id                | exbehnum                |
    | !M08_BEHLEER_1^id | !M08_BEHLEER_1^packm^id | !M08_BEHLEER_1^exbehnum |
    | !M08_BEHLEER_2^id | !M08_BEHLEER_2^packm^id | !M08_BEHLEER_2^exbehnum |
And I modify table
    | !row | exbehnum |
    | 1    |          |
    | 2    |          |
Then table has values 
    | behaelter | packm | exbehnum |
    |           |       |          |
    |           |       |          |
And I close the current editor

