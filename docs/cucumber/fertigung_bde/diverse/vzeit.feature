@persistent
Feature: Seriennummer_erneut_verwenden.feature

  Background:
    And I set the fake date to "16.01.1995"

  # **********************************************************************************
  # Name             : Seriennummer_erneut_verwenden.feature
  # Autor            : bschiga
  # Verantwortlich   : amk
  # Kontrolle        : drpf
  # Funktion         : Testet erneutes Verwenden von Seriennummern in der Fertigung
  # ref              : ref_seriennr_erneut_verwenden_cu
  #
  # **********************************************************************************
  Scenario Outline: Arbeitsgänge
    Given I open an editor "<such>" from table "(Operation):(Operation)" with command "STORE" for record "<such>"
    And I set fields
      | such        | <such>        |
      | namebspr    | <namebspr>    |
      | mgr         | <mgr>         |
      | grgr        | <grgr>        |
      | grgrruesten | <grgrruesten> |
      | lgr         | <lgr>         |
      | lgrruesten  | <lgrruesten>  |
      | aschein     | <aschein>     |
      | tr          | <tr>          |
      | te          | <te>          |
    And I save the current editor

    Examples:
      | such          | namebspr               | mgr  | grgr | grgrruesten | lgr | lgrruesten | aschein | tr | te |
      | AG-NOGRGR     | AG ohne grgr/grruesten | MGR3 | 0    | 0           | 1   | 3          | ja      | 60 | 10 |
      | AG-NURGR      | AG nur grgr            | MGR3 | 1    | 0           | 1   | 3          | ja      | 60 | 10 |
      | AG-NURRUST    | AG nur grgrruesten     | MGR3 | 0    | 2           | 1   | 3          | ja      | 60 | 10 |
      | AG-GRGLEICH   | AG grgr = grgrruesten  | MGR3 | 3    | 3           | 1   | 3          | ja      | 60 | 10 |
      | AG-GRUNGLEICH | AG grgr <> grgrruesten | MGR3 | 4    | 5           | 1   | 3          | ja      | 60 | 10 |
      | AG-LGRGLEICH  | AG Lohngruppen gleich  | MGR3 | 6    | 7           | 2   | 2          | ja      | 60 | 10 |

  Scenario Outline: Baugruppen zum testen der vorgeschlagenen Vorgabezeit
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>         |
      | namebspr | <namebspr>     |
      | dispoa   | <dispoa>       |
      | bsart    | Eigenfertigung |
    And I delete all rows
    And I append rows
      | elex    | anzahl    |
      | <elex1> | <anzahl1> |
      | <elex2> | <anzahl2> |
      | <elex3> | <anzahl3> |
      | <elex4> | <anzahl4> |
      | <elex5> | <anzahl5> |
      | <elex6> | <anzahl6> |
      | <elex7> | <anzahl7> |
    And I save the current editor

    Examples:
      | such     | namebspr            | dispoa      | elex1      | anzahl1 | elex2       | anzahl2 | elex3      | anzahl3 | elex4        | anzahl4 | elex5         | anzahl5 | elex6           | anzahl6 | elex7          | anzahl7 |
      | BG-VZEIT | BG TEST Vorgabezeit | !dontChange | EK1-BEDARF | 1       | A AG-NOGRGR | 1       | A AG-NURGR | 1       | A AG-NURRUST | 1       | A AG-GRGLEICH | 1       | A AG-GRUNGLEICH | 1       | A AG-LGRGLEICH | 1       |

  Scenario: VZ01 Vorgabezeit und Maschinenzeit berechnen und getrennt nach Lohngruppen eintragen
    Given I create a work order "VZ01" for Product "BG-VZEIT" with quantity "10" and search word "VZ01_"
    # Rückmeldung auf Arbeitsschein 1 mit Menge 10 erstellen
    # AG ohne grgr/grruesten: grgr=grgrruesten=0 => bzeit=0, mzeit=2.67
    Given I open an editor "RM1_VZ01" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=VZ01_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | gut       | ja       |
      | vzeitvorb | ja       |
      | bem       | RM1_VZ01 |
    Then fields have values
      | lgr    | 1    |
      | bzeit  | 0    |
      | mzeit  | 2.67 |
      | lgr2   | 3    |
      | bzeit2 | 0    |
      | mzeit2 | 0    |
      | lgr3   | 0    |
      | bzeit3 | 0    |
      | mzeit3 | 0    |
      | lgr4   | 0    |
      | bzeit4 | 0    |
      | mzeit4 | 0    |
      | lgr5   | 0    |
      | bzeit5 | 0    |
      | mzeit5 | 0    |
    And I save the current editor
    # Rückmeldung auf Arbeitsschein 2 mit Menge 10 erstellen
    # AG nur grgr (grgrruesten=grgr): grgr=1, grgrruesten=0 => bzeit=, bzeit2=0, mzeit=2.67
    Given I open an editor "RM2_VZ01" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=VZ01_002;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | gut       | ja       |
      | vzeitvorb | ja       |
      | bem       | RM2_VZ01 |
    Then fields have values
      | lgr    | 1    |
      | bzeit  | 1.67 |
      | mzeit  | 2.67 |
      | lgr2   | 3    |
      | bzeit2 | 1    |
      | mzeit2 | 0    |
      | lgr3   | 0    |
      | bzeit3 | 0    |
      | mzeit3 | 0    |
      | lgr4   | 0    |
      | bzeit4 | 0    |
      | mzeit4 | 0    |
      | lgr5   | 0    |
      | bzeit5 | 0    |
      | mzeit5 | 0    |
    And I save the current editor
    # Rückmeldung auf Arbeitsschein 3 mit Menge 10 erstellen
    # AG nur grgrruesten: grgr=0, grgrruesten=2 => bzeit=0, bzeit2=0, mzeit=2.67
    Given I open an editor "RM3_VZ01" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=VZ01_003;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | gut       | ja       |
      | vzeitvorb | ja       |
      | bem       | RM3_VZ01 |
    Then fields have values
      | lgr    | 1    |
      | bzeit  | 0    |
      | mzeit  | 2.67 |
      | lgr2   | 3    |
      | bzeit2 | 2    |
      | mzeit2 | 0    |
      | lgr3   | 0    |
      | bzeit3 | 0    |
      | mzeit3 | 0    |
      | lgr4   | 0    |
      | bzeit4 | 0    |
      | mzeit4 | 0    |
      | lgr5   | 0    |
      | bzeit5 | 0    |
      | mzeit5 | 0    |
    And I save the current editor
    # Rückmeldung auf Arbeitsschein 4 mit Menge 10 erstellen
    # AG grgr = grgrruesten: grgr=3, grgrruesten=3 => bzeit=, bzeit2=0, mzeit=2.67
    Given I open an editor "RM4_VZ01" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=VZ01_004;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | gut       | ja       |
      | vzeitvorb | ja       |
      | bem       | RM4_VZ01 |
    Then fields have values
      | lgr    | 1    |
      | bzeit  | 5    |
      | mzeit  | 2.67 |
      | lgr2   | 3    |
      | bzeit2 | 3    |
      | mzeit2 | 0    |
      | lgr3   | 0    |
      | bzeit3 | 0    |
      | mzeit3 | 0    |
      | lgr4   | 0    |
      | bzeit4 | 0    |
      | mzeit4 | 0    |
      | lgr5   | 0    |
      | bzeit5 | 0    |
      | mzeit5 | 0    |
    And I save the current editor
    # Rückmeldung auf Arbeitsschein 5 mit Menge 10 erstellen
    # AG grgr <> grgrruesten: grgr=4, grgrruesten=5 => bzeit=, bzeit2=0, mzeit=2.67
    Given I open an editor "RM5_VZ01" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=VZ01_005;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | gut       | ja       |
      | vzeitvorb | ja       |
      | bem       | RM5_VZ01 |
    Then fields have values
      | lgr    | 1    |
      | bzeit  | 6.67 |
      | mzeit  | 2.67 |
      | lgr2   | 3    |
      | bzeit2 | 5    |
      | mzeit2 | 0    |
      | lgr3   | 0    |
      | bzeit3 | 0    |
      | mzeit3 | 0    |
      | lgr4   | 0    |
      | bzeit4 | 0    |
      | mzeit4 | 0    |
      | lgr5   | 0    |
      | bzeit5 | 0    |
      | mzeit5 | 0    |
    And I save the current editor
    # Rückmeldung auf Arbeitsschein 6 mit Menge 10 erstellen
    # AG Lohngruppen gleich: grgr=6, grgrruesten=7 => bzeit=, bzeit2=0, mzeit=2.67
    Given I open an editor "RM6_VZ01" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=VZ01_006;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | gut       | ja       |
      | vzeitvorb | ja       |
      | bem       | RM6_VZ01 |
    Then fields have values
      | lgr    | 2    |
      | bzeit  | 17   |
      | mzeit  | 2.67 |
      | lgr2   | 0    |
      | bzeit2 | 0    |
      | mzeit2 | 0    |
      | lgr3   | 0    |
      | bzeit3 | 0    |
      | mzeit3 | 0    |
      | lgr4   | 0    |
      | bzeit4 | 0    |
      | mzeit4 | 0    |
      | lgr5   | 0    |
      | bzeit5 | 0    |
      | mzeit5 | 0    |
    And I save the current editor

  Scenario: VZ02 Plausiprüfung, wenn die Anzahl der leeren Felder nicht ausreicht
    Given I create a work order "VZ02" for Product "BG-VZEIT" with quantity "10" and search word "VZ02_"
    # Rückmeldung auf Arbeitsschein 2, alle Felder sind bereits belegt
    Given I open an editor "RM1_VZ01" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=VZ02_002;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | gut  | ja |
      | lgr  | 4  |
      | lgr2 | 4  |
      | lgr3 | 4  |
      | lgr4 | 4  |
      | lgr5 | 4  |
    Then setting field "vzeitvorb" to "ja" throws the exception "1475"
    And I close the current editor
    # Rückmeldung auf Arbeitsschein 2, Lohngruppe ruesten (lgrruesten) steht in Zeile 2, Lohngruppe (lgr) in Zeile 5
    Given I open an editor "RM1_VZ01" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=VZ02_002;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | gut       | ja       |
      | lgr       | 4        |
      | lgr2      | 3        |
      | lgr3      | 4        |
      | lgr4      | 4        |
      | lgr5      | 1        |
      | bem       | RM2_VZ02 |
      | vzeitvorb | ja       |
    Then fields have values
      | lgr    | 4    |
      | bzeit  | 0    |
      | mzeit  | 0    |
      | lgr2   | 3    |
      | bzeit2 | 1    |
      | mzeit2 | 0    |
      | lgr3   | 4    |
      | bzeit3 | 0    |
      | mzeit3 | 0    |
      | lgr4   | 4    |
      | bzeit4 | 0    |
      | mzeit4 | 0    |
      | lgr5   | 1    |
      | bzeit5 | 1.67 |
      | mzeit5 | 2.67 |
    And I save the current editor
