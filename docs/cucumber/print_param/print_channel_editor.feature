@persistent
@FP_TEST
Feature: Ausgabekanal testen

Scenario Outline: Pruefen der Editier-Buttons im Ausgabekanal

Given I open an editor "Ausgabekanal" from table "(PrintParameter):(OutputChannel)" with command "UPDATE" for record "<kanal>"
And I press button "<button>"
And I close the current editor

Examples:
| row | kanal         | button      |
| 001 | JASPERREPORTS | buislaygen  |
| 002 | JASPERREPORTS | buisdgen    |
| 003 | JASPERREPORTS | buelaycomp  |
| 004 | JASPERREPORTS | bulayparser |
| 005 | EXCELOO       | buislaygen  |
| 006 | EXCELOO       | buisdgen    |
| 007 | EXCELOO       | buelaycomp  |
| 008 | MAPPINGMODEL  | buisdgen    |
| 009 | MAPPINGMODEL  | buelaycomp  |

Scenario Outline: Pruefen der Aktions-Buttons

Given I open an editor "Ausgabekanal" from table "(PrintParameter):(OutputChannel)" with command "UPDATE" for record "<kanal>"
And I press button "<aktion>"
And I close the current editor

Examples:
| row | kanal         | aktion        |
| 001 | JASPERREPORTS | bualllaygen   |
| 002 | JASPERREPORTS | bualldatagen  |
| 003 | JASPERREPORTS | buallcompile  |
| 004 | EXCELOO       | bualllaygen   |
| 005 | EXCELOO       | bualldatagen  |
| 006 | MAPPINGMODEL  | buallcompile  |
