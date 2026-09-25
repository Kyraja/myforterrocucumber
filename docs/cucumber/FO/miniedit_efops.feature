@persistent
Feature: miniedit_efops.feature

  Background:
    And I set the fake date to "02.01.95"

# *****************************************************************************
#  Name             : miniedit_efops.feature
#  Verantwortlich   : @forterro-prd/t024-abas-core
#  Kontrolle        :
#
#  Nimmt Felder mit unterschiedlichen FO- und Maskenschutz, um deren
#  Änderbarkeit im Maskeneintritt und Maskenaustritt von im Kern
#  aufgerufenen miniedit()-Nachläufern zu prüfen.
#
# *****************************************************************************


  Scenario: Voraussetzungen pruefen

    Given I open an editor "VARTAB-02-01" from table "(Company):(Vartab)" with command "VIEW" for record "V-02-01"
    Then table has values
      | vlgs             | vms             | !row                        |
      | änderbar         | änderbar        | $,vname==tebem              |
      | immer geschützt  | änderbar        | $,vname==teflbasis          |
      | immer geschützt  | kerngesteuert   | $,vname==teerab             |
      | immer geschützt  | immer geschützt | $,vname==itobjgruppe        |
    And I close the current editor

    Given I open an editor "VARTAB-09-02" from table "(Company):(Vartab)" with command "VIEW" for record "V-09-02"
    Then table has values
      | vlgs             | vms             | !row                        |
      | änderbar         | änderbar        | $,vname==itversionierenicht |
      | immer geschützt  | änderbar        | $,vname==itclassname        |
      | immer geschützt  | kerngesteuert   | $,vname==bilgr              |
      | immer geschützt  | immer geschützt | $,vname==itobjgruppe        |
    And I close the current editor


  Scenario: Basisartikel aendern und in Maskeneintritt von Artikel auf Maskenaenderbarkeit pruefen

    Given I open an editor "Basisartikel" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BASISART"
    And I set fields
      | konstrukteur | TEST |

    # erster Artikel zum Basisartikel - Maskeneintritt
    And I respond with answer "M|bem" to the dialog with id ""
    And I respond with answer "ja" to the dialog with id ""
    And I respond with answer "M|flbasis" to the dialog with id ""
    And I respond with answer "ja" to the dialog with id ""
    And I respond with answer "M|erab" to the dialog with id ""
    And I respond with answer "ja" to the dialog with id ""
    And I respond with answer "M|objgruppe" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""

    # erster Artikel zum Basisartikel - Maskenaustritt
    And I respond with answer "M|bem" to the dialog with id ""
    And I respond with answer "ja" to the dialog with id ""
    And I respond with answer "M|flbasis" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""
    And I respond with answer "M|erab" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""
    And I respond with answer "M|objgruppe" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""

    # zweiter Artikel zum Basisartikel - Maskeneintritt
    And I respond with answer "M|bem" to the dialog with id ""
    And I respond with answer "ja" to the dialog with id ""
    And I respond with answer "M|flbasis" to the dialog with id ""
    And I respond with answer "ja" to the dialog with id ""
    And I respond with answer "M|erab" to the dialog with id ""
    And I respond with answer "ja" to the dialog with id ""
    And I respond with answer "M|objgruppe" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""

    # zweiter Artikel zum Basisartikel - Maskenaustritt
    And I respond with answer "M|bem" to the dialog with id ""
    And I respond with answer "ja" to the dialog with id ""
    And I respond with answer "M|flbasis" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""
    And I respond with answer "M|erab" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""
    And I respond with answer "M|objgruppe" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""

    And I save the current editor
    And I close the current editor


  Scenario: Betriebsauftrag anlegen

    Given I open an editor "Fertigungsvorschlag" from table "(Purchasing):(WorkOrderSuggestion)" with command "NEW" for record ""
    And I set fields
      | artikel | BG1 |
      | mge     | 111 |
    And I save the current editor

  Given I open an editor "FV_freigeben" from table "(Purchasing):(WorkOrderSuggestion)" with command "RELEASE" for record from editor "Fertigungsvorschlag"
    And I set fields
      | bisuch  | PPP |
    And I save the current editor
    And I close the current editor


  Scenario: Rueckmeldung erfassen, verbuchen und dabei die Aenderbarkeit im Maskeneintritt pruefen

    Given I open an editor "Rueckmeldung" from table "(Workorder):(CompletionConfirmations)" with command "DONE" for record ""
    And I set fields
      | barmex | PPP001 |
      | sofort |     ja |

    And I set field "gutmge" to "1" in row 1

    # Maskeneintritt
    And I respond with answer "M|versionierenicht" to the dialog with id ""
    And I respond with answer "ja" to the dialog with id ""
    And I respond with answer "M|classname" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""
    And I respond with answer "M|lgr" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""
    And I respond with answer "M|objgruppe" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""

    # Maskenaustritt
    And I respond with answer "M|versionierenicht" to the dialog with id ""
    And I respond with answer "ja" to the dialog with id ""
    And I respond with answer "M|classname" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""
    And I respond with answer "M|lgr" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""
    And I respond with answer "M|objgruppe" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""

    And I save the current editor
    And I close the current editor

  Scenario: Basisartikel aendern und in Maskeneintritt von Artikel auf Maskenaenderbarkeit pruefen mit Testflag 50

    Given I enable the flag 50

    And I open an editor "Basisartikel" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BASISART"
    And I set fields
      | konstrukteur | TEST |

    # erster Artikel zum Basisartikel - Maskeneintritt
    And I respond with answer "M|bem" to the dialog with id ""
    And I respond with answer "ja" to the dialog with id ""
    And I respond with answer "M|flbasis" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""
    And I respond with answer "M|erab" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""
    And I respond with answer "M|objgruppe" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""

    # erster Artikel zum Basisartikel - Maskenaustritt
    And I respond with answer "M|bem" to the dialog with id ""
    And I respond with answer "ja" to the dialog with id ""
    And I respond with answer "M|flbasis" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""
    And I respond with answer "M|erab" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""
    And I respond with answer "M|objgruppe" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""

    # zweiter Artikel zum Basisartikel - Maskeneintritt
    And I respond with answer "M|bem" to the dialog with id ""
    And I respond with answer "ja" to the dialog with id ""
    And I respond with answer "M|flbasis" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""
    And I respond with answer "M|erab" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""
    And I respond with answer "M|objgruppe" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""

    # zweiter Artikel zum Basisartikel - Maskenaustritt
    And I respond with answer "M|bem" to the dialog with id ""
    And I respond with answer "ja" to the dialog with id ""
    And I respond with answer "M|flbasis" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""
    And I respond with answer "M|erab" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""
    And I respond with answer "M|objgruppe" to the dialog with id ""
    And I respond with answer "nein" to the dialog with id ""

    And I save the current editor
    And I close the current editor
