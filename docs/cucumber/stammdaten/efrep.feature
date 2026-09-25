@persistent
Feature: efrep.feature

  Background:
    And I set the fake date to "01.01.2000"

    Given I'm logged in with password "annette"
    And I enable the flag 71

# *****************************************************************************
#  Name             : efrep.feature
#  Autor            : drpf
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : efrep-Test
#
# *****************************************************************************

  Scenario Outline: Alternative Fertigungslisten anlegen
    Given I open an editor "<such>" from table "(ProductionList):(ProductionList)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>      |
      | artikel   | <artikel>   |
      | lgruppe   | <lgruppe>   |
      | flistestd | <flistestd> |
    And I delete all rows
    And I append rows
      | elex  | elanzahl    |
      | BG1   | 1           |
      | a ag1 | !dontChange |
    And I save the current editor
    Examples:
      | such        | artikel     | lgruppe     | flistestd | 
      | alternativ1 | TEST        | BERLIN      | ja        | 
      | alternativ2 | TEST        | Karlsruhe   | nein      | 
      | alternativ3 | V3          | Karlsruhe   | nein      | 
      | alternativ4 | V3          | BERLIN      | ja        | 
      | Dummy       | !dontChange | !dontChange | nein      | 
      | Dummyart    | V3          | !dontChange | nein      | 
      | Dummylg     | !dontChange | BERLIN      | nein      | 
      | v4_hk       | V4          | HONGKONG    | ja        | 
      | v2_hk       | V2          | HONGKONG    | ja        |

  Scenario: Artikel umstellen
    Given I open an editor "V1" from table "(Part):(Product)" with command "UPDATE" for record "V1"
    And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
    And I append rows
      | lgruppe  | bsart          | umllg     |
      | HONGKONG | Umlagern       | Berlin    |
      | Berlin   | Eigenfertigung |           |
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

    Given I open an editor "V4" from table "(Part):(Product)" with command "UPDATE" for record "V4"
    And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
    And I append rows
      | lgruppe  | bsart          | umllg       |
      | HONGKONG | Umlagern       | Karlsruhe   |
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

    Given I open an editor "V2" from table "(Part):(Product)" with command "UPDATE" for record "V2"
    And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
    And I append rows
      | lgruppe  | bsart  |     
      | HONGKONG | Fremd  |
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

  Scenario Outline: Artikel Lagergruppeneigenschaften anlegen
    Given I open an editor "<such>" from table "(Part):(Product)" with command "UPDATE" for record "<such>"
    And I set fields
      | umllg         | <umllg>     |
      | bsart         | <bsart>     |
    And I save the current editor

    Examples:
      | such | umllg       | bsart    |
      | V1   | HONGKONG    | Umlagern |
      | V2   | HONGKONG    | Umlagern |
      | V4   | !dontChange | Fremd    |


  Scenario Outline: Basisartikel anlegen
    Given I open an editor "<such>" from table "(Part):(BaseProduct)" with command "STORE" for record "<such>"
    And I set fields
      | such         | <such>     |
      | namebspr     | <namebspr> |
      | konstrukteur | MEIER      |
      | fbetreuer    | KARL       |
    And I delete all rows
    And I append rows
      | tversion   | tindex | tstdvers |
      | <tversion> | 001    | ja       |
    And I save the current editor
    Examples:
      | such | namebspr | tversion |
      | BE1  | BE1      | E1       |
      | BE2  | BE2      | E2       |
      | BE3  | BE3      | E3       |
      | BBG1 | BBG1     | BG1      |

  Scenario: Daten loeschen
    Given I execute FOP "FLLAD"
