@persistent
Feature: stammdaten_bde.feature

# *****************************************************************************
#  Name             : stammdaten_bde
#  Autor            : tiwe
#  Verantwortlich   : teaminfosysteme
#  Kontrolle        : cl
#  Funktion         : BDE Stammdaten zu den tests: pdctransfer, worklist, scanordertime, attendance
#  Jira-Issue       : -
# *****************************************************************************
  Background:
  Given I set the fake date to "12.01.1995"
  Scenario Outline: Einkaufsartikel
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>      |
      | namebspr  | <namebspr>  |
      | dispoa    | <dispoa>    |
      | efrist    | 2           |
      | epr       | <epr>       |
      | zuplatz   | <zuplatz>   |
      | chpflicht | <chpflicht> |
      | wgruppe   | 56          |
      | erlgrp    | 66          |
      | le        | <le>        |
    And I save the current editor
    Examples:
      | such   | namebspr     | epr  | zuplatz     | chpflicht | dispoa         | le          |
      | KOMP-1 | Komponente 1 | 4,50 | !dontChange | nein      | bedarfsbezogen | !dontChange |
      | KOMP-2 | Komponente 2 | 6    | !dontChange | nein      | bedarfsbezogen | !dontChange |
      | KOMP-3 | Komponente 3 | 5,30 | !dontChange | nein      | bedarfsbezogen | !dontChange |

  Scenario Outline: Qualifikationen
    Given I open an editor "<such>" from table "(Qualifications):(Qualifications)" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>     |
      | namebspr | <namebspr> |
    And I save the current editor
    Examples:
      | such   | namebspr           |
      | Q-MGR1 | Qualifikation MGR1 |
      | Q-MGR2 | Qualifikation MGR2 |
      | Q-MGR3 | Qualifikation MGR3 |
      | Q-MGR4 | Qualifikation MGR4 |

  Scenario Outline: Maschinengruppen
    Given I open an editor "<such>" from table "(Capacity):(WorkCenter)" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>     |
      | namebspr | <namebspr> |
      | abtlg    | 1          |
      | kstelle  | 101        |
      | serqual  | <serqual>  |
    And I save the current editor
    Examples:
      | such | namebspr          | serqual |
      | MGR1 | Maschinengruppe 1 | Q-MGR1  |
      | MGR2 | Maschinengruppe 2 | Q-MGR2  |
      | MGR3 | Maschinengruppe 3 | Q-MGR3  |
      | MGR4 | Maschinengruppe 4 | Q-MGR4  |


  Scenario Outline: Arbeitsgänge
    Given I open an editor "<such>" from table "(Operation):(Operation)" with command "STORE" for record "<such>"
    And I set fields
      | such       | <such>       |
      | namebspr   | <namebspr>   |
      | mgr        | <mgr>        |
      | lgr        | <lgr>        |
      | lgrruesten | <lgrruesten> |
      | aschein    | ja           |
      | tr         | <tr>         |
      | te         | <te>         |
      | skostfix   | 10           |
      | skostvar   | 20           |
      | rmimdialog | <rmimdialog> |
    And I save the current editor
    Examples:
      | such    | namebspr         | mgr  | lgr | lgrruesten | tr | te | rmimdialog |
      | AG-MGR1 | Arbeitsgang MGR1 | MGR1 | 1   | 2          | 5  | 10 | nein       |
      | AG-MGR2 | Arbeitsgang MGR2 | MGR2 | 1   | 2          | 15 | 6  | ja         |
      | AG-MGR3 | Arbeitsgang MGR3 | MGR3 | 1   | 2          | 0  | 20 | nein       |
      | AG-MGR4 | Arbeitsgang MGR4 | MGR4 | 1   | 2          | 20 | 6  | nein       |


  Scenario Outline: Baugruppen, 3 AG
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>          |
      | namebspr  | <namebspr>      |
      | dispoa    | auftragsbezogen |
      | bsart     | Eigenfertigung  |
      | gemein    | GK2.14.3        |
      | chverfolgung |              |
      | flbasis   | <flbasis>       |
      | wgruppe   | 56              |
      | erlgrp    | 66              |
    And I delete all rows
    And I append rows
      | elex    | anzahl    | kompeig   | manbu   | nutzen   | pverlust   |
      | <elex1> | <anzahl1> |           | <manbu> | <nutzen> |            |
      | <ag1>   | 1         |           |         |          | <pverlust> |
      | <elex2> | <anzahl2> | <kompeig> |         |          |            |
      | <ag2>   | 1         |           |         |          |            |
      | <elex3> | <anzahl3> |           |         |          |            |
      | <ag3>   | 1         |           |         |          |            |
    And I save the current editor
    Examples:
      | such    | namebspr      | flbasis | elex1  | anzahl1 | manbu | nutzen | ag1       | elex2  | anzahl2 | kompeig | ag2       | pverlust | elex3  | anzahl3 | ag3       |
      | BG3-BDE | Baugruppe BDE |         | KOMP-1 | 1       |       |        | A AG-MGR1 | KOMP-2 | 1       |         | A AG-MGR2 |          | KOMP-3 | 1       | A AG-MGR3 |

  Scenario Outline: Baugruppen mit Nutzen und bzw. oder Fertigungslistenbasis
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>          |
      | namebspr  | <namebspr>      |
      | dispoa    | auftragsbezogen |
      | bsart     | Eigenfertigung  |
      | gemein    | GK2.14.3        |
      | flbasis   | <flbasis>       |
      | wgruppe   | 56              |
      | erlgrp    | 66              |
    And I delete all rows
    And I append rows
      | elex    | anzahl    | nutzen   |
      | <elex1> | <anzahl1> |          |
      | <ag1>   | 1         | <nutzen> |
    And I save the current editor
    Examples:
      | such                | namebspr                      | flbasis | elex1  | anzahl1 | ag1       | nutzen |
      | BG01_NUTZEN         | Baugruppe Nutzen im AG        |         | KOMP-1 | 1       | A AG-MGR4 | 5      |
      | BG02_NUTZEN_FLBASIS | Baugruppe Nutzen und FL-Basis | 10      | KOMP-1 | 1       | A AG-MGR4 | 5      |
      | BG03_FLBASIS        | Baugruppe mit FL-Basis        | 10      | KOMP-1 | 1       | A AG-MGR4 |        |

  Scenario Outline: Tagesplan
    Given I open an editor "<such>" from table "(Company):(DailySchedule)" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>       |
      | namebspr | einfacher TP |
      | ranfzeit | 08:00        |
      | rendzeit | 18:00        |
    And I save the current editor
    Examples:
      | such      |
      | TPEINFACH |


  Scenario Outline: Schichtplan
    Given I open an editor "<such>" from table "(Company):(ShiftSchedule)" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>       |
      | namebspr | einfacher SP |
    And I delete all rows
    And I append rows
      | schicht | tplan1    | tplan2    | tplan3    | tplan4    | tplan5    | tplan6    | tplan7    |
      | 1       | TPEINFACH | TPEINFACH | TPEINFACH | TPEINFACH | TPEINFACH | TPEINFACH | TPEINFACH |
    And I save the current editor
    Examples:
      | such      |
      | SPEINFACH |

  Scenario Outline: Mitarbeiter
    Given I open an editor "<such>" from table "(Employee):(Employee)" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>     |
      | namebspr | <namebspr> |
      | lohn     | 1          |
      | splan    | SPEINFACH  |
    And I save the current editor
    Examples:
      | such     | namebspr        |
      | SCHNEID  | Helge Schneider |
      | MACHNIX  | Mathias Machnix |
      | KAEPSELE | Karl Käpsele    |

  Scenario Outline: Qualifikationsliste
    Given I open an editor "<such>" from table "(Qualifications):(ListOfQualifications)" with command "STORE" for search criteria "<search>"
    And I set fields
      | ma | <ma> |
    And I delete all rows
    And I append rows
      | serqual | gltvon | gltbis |
      | <qual1> |        |        |
      | <qual2> |        |        |
      | <qual3> |        |        |
    And I save the current editor
    Examples:
      | search                       | ma       | qual1  | qual2  | qual3  |
      | $,,ma=KAEPSELE;@maxtreffer=1 | KAEPSELE | Q-MGR1 | Q-MGR2 | Q-MGR3 |
