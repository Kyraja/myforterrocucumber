@persistent
Feature: basisartikel_verkehrszahlen.feature

# *****************************************************************************
#  Name             : basisartikel_verkehrszahlen
#  Autor            : lschneider
#  Verantwortlich   : drpf
#  Kontrolle        : bschiga
#  Funktion         : Prüft die verdichtete Darstellung der Verkehrszahlen
#                     in einem Basisartikel mit zwei Versionen
#
# *****************************************************************************


  Scenario: Basisartikel mit zwei Versionen anlegen
    Given I open an editor "VZAHLEN" from table "(Part):(BaseProduct)" with command "STORE" for record "VZAHLEN"
    And I set field "such" to "VZAHLEN"
    And I delete all rows
    And I append rows
      | tversion | tstdvers | tindex |
      | V1       | ja       | V01    |
      | V2       |          | V02    |
    And I save the current editor


  Scenario: Zu- und Abgänge V1 und V2 in 1994
    Given I set the fake date to "03.02.1994"
    Given I post a receipt via ManualStockAdjustment for Product "V1" and quantity "50" on StorageLocation "F1" with document "LBUCH1"
    Given I post a receipt via ManualStockAdjustment for Product "V2" and quantity "50" on StorageLocation "F1" with document "LBUCH2"
    Given I set the fake date to "01.04.1994"
    Given I post a receipt via ManualStockAdjustment for Product "V1" and quantity "10" on StorageLocation "F1" with document "LBUCH3"
    Given I post a receipt via ManualStockAdjustment for Product "V2" and quantity "50" on StorageLocation "F1" with document "LBUCH4"

    Given I set the fake date to "03.02.1994"
    # Aufträge, Lieferungen und Rechnungen für V1 und V2 - 1994
    Given I create a SalesOrder "V1-0220-1" for Customer "1" with Product "V1" and quantity "20"
    Given I create a SalesOrder "V1-0220-2" for Customer "1" with Product "V1" and quantity "5"
    Given I deliver the SalesOrder "V1-0220-1" with PackingSlip "V1-02201L"
    Given I deliver the SalesOrder "V1-0220-2" with PackingSlip "V1-02202L"
    Given I invoice the PackingSlip "V1-02201L" with Invoice "V1-02201R"
    Given I invoice the PackingSlip "V1-02202L" with Invoice "V1-02202R"

    Given I create a SalesOrder "V2-0220-1" for Customer "1" with Product "V2" and quantity "25"
    Given I create a SalesOrder "V2-0220-2" for Customer "1" with Product "V2" and quantity "10"
    Given I deliver the SalesOrder "V2-0220-1" with PackingSlip "V2-02201L"
    Given I deliver the SalesOrder "V2-0220-2" with PackingSlip "V2-02202L"
    Given I invoice the PackingSlip "V2-02201L" with Invoice "V2-02201R"
    Given I invoice the PackingSlip "V2-02202L" with Invoice "V2-02202R"

    Given I set the fake date to "02.03.1994"
    Given I create a SalesOrder "V1-0320-1" for Customer "1" with Product "V1" and quantity "2"
    Given I create a SalesOrder "V1-0320-2" for Customer "1" with Product "V1" and quantity "7"
    Given I deliver the SalesOrder "V1-0320-1" with PackingSlip "V1-03201L"
    Given I deliver the SalesOrder "V1-0320-2" with PackingSlip "V1-03202L"
    Given I invoice the PackingSlip "V1-03201L" with Invoice "V1-03201R"
    Given I invoice the PackingSlip "V1-03202L" with Invoice "V1-03202R"

    Given I create a SalesOrder "V2-0320-1" for Customer "1" with Product "V2" and quantity "10"
    Given I create a SalesOrder "V2-0320-2" for Customer "1" with Product "V2" and quantity "3"
    Given I deliver the SalesOrder "V2-0320-1" with PackingSlip "V2-03201L"
    Given I deliver the SalesOrder "V2-0320-2" with PackingSlip "V2-03202L"
    Given I invoice the PackingSlip "V2-03201L" with Invoice "V2-03201R"
    Given I invoice the PackingSlip "V2-03202L" with Invoice "V2-03202R"

    Given I set the fake date to "01.06.1994"
    Given I create a SalesOrder "V1-0620-1" for Customer "1" with Product "V1" and quantity "2"
    Given I create a SalesOrder "V1-0620-2" for Customer "1" with Product "V1" and quantity "3"
    Given I deliver the SalesOrder "V1-0620-1" with PackingSlip "V1-06201L"
    Given I deliver the SalesOrder "V1-0620-2" with PackingSlip "V1-06202L"
    Given I invoice the PackingSlip "V1-06201L" with Invoice "V1-06201R"
    Given I invoice the PackingSlip "V1-06202L" with Invoice "V1-06202R"

    Given I create a SalesOrder "V2-0620-1" for Customer "1" with Product "V2" and quantity "4"
    Given I create a SalesOrder "V2-0620-2" for Customer "1" with Product "V2" and quantity "5"
    Given I deliver the SalesOrder "V2-0620-1" with PackingSlip "V2-06201L"
    Given I deliver the SalesOrder "V2-0620-2" with PackingSlip "V2-06202L"
    Given I invoice the PackingSlip "V2-06201L" with Invoice "V2-06201R"
    Given I invoice the PackingSlip "V2-06202L" with Invoice "V2-06202R"

    Given I set the fake date to "02.11.1994"
    Given I create a SalesOrder "V1-1120-1" for Customer "1" with Product "V1" and quantity "10"
    Given I create a SalesOrder "V1-1120-2" for Customer "1" with Product "V1" and quantity "10"
    Given I deliver the SalesOrder "V1-1120-1" with PackingSlip "V1-11201L"
    Given I deliver the SalesOrder "V1-1120-2" with PackingSlip "V1-11202L"
    Given I invoice the PackingSlip "V1-11201L" with Invoice "V1-11201R"
    Given I invoice the PackingSlip "V1-11202L" with Invoice "V1-11202R"

    Given I create a SalesOrder "V2-1120-1" for Customer "1" with Product "V2" and quantity "10"
    Given I create a SalesOrder "V2-1120-2" for Customer "1" with Product "V2" and quantity "15"
    Given I deliver the SalesOrder "V2-1120-1" with PackingSlip "V2-11201L"
    Given I deliver the SalesOrder "V2-1120-2" with PackingSlip "V2-11202L"
    Given I invoice the PackingSlip "V2-11201L" with Invoice "V2-11201R"
    Given I invoice the PackingSlip "V2-11202L" with Invoice "V2-11202R"


  Scenario: Zu- und Abgänge V1 und V2 in 1995
    Given I set the fake date to "04.01.1995"
    Given I post a receipt via ManualStockAdjustment for Product "V1" and quantity "50" on StorageLocation "F1" with document "LBUCH1"
    Given I post a receipt via ManualStockAdjustment for Product "V2" and quantity "100" on StorageLocation "F1" with document "LBUCH2"
    Given I set the fake date to "01.04.1995"
    Given I post a receipt via ManualStockAdjustment for Product "V1" and quantity "20" on StorageLocation "F1" with document "LBUCH3"
    Given I post a receipt via ManualStockAdjustment for Product "V2" and quantity "50" on StorageLocation "F1" with document "LBUCH4"

    Given I set the fake date to "03.02.1995"
    # Aufträge, Lieferungen und Rechnungen für V1 und V2 - 1995
    Given I create a SalesOrder "V1-0221-1" for Customer "1" with Product "V1" and quantity "17"
    Given I create a SalesOrder "V1-0221-2" for Customer "1" with Product "V1" and quantity "5"
    Given I deliver the SalesOrder "V1-0221-1" with PackingSlip "V1-02211L"
    Given I deliver the SalesOrder "V1-0221-2" with PackingSlip "V1-02212L"
    Given I invoice the PackingSlip "V1-02211L" with Invoice "V1-02211R"
    Given I invoice the PackingSlip "V1-02212L" with Invoice "V1-02212R"

    Given I create a SalesOrder "V2-0221-1" for Customer "1" with Product "V2" and quantity "20"
    Given I create a SalesOrder "V2-0221-2" for Customer "1" with Product "V2" and quantity "15"
    Given I deliver the SalesOrder "V2-0221-1" with PackingSlip "V2-02211L"
    Given I deliver the SalesOrder "V2-0221-2" with PackingSlip "V2-02212L"
    Given I invoice the PackingSlip "V2-02211L" with Invoice "V2-02211R"
    Given I invoice the PackingSlip "V2-02212L" with Invoice "V2-02212R"

    Given I set the fake date to "02.03.1995"
    Given I create a SalesOrder "V1-0321-1" for Customer "1" with Product "V1" and quantity "5"
    Given I create a SalesOrder "V1-0321-2" for Customer "1" with Product "V1" and quantity "8"
    Given I deliver the SalesOrder "V1-0321-1" with PackingSlip "V1-03211L"
    Given I deliver the SalesOrder "V1-0321-2" with PackingSlip "V1-03212L"
    Given I invoice the PackingSlip "V1-03211L" with Invoice "V1-03211R"
    Given I invoice the PackingSlip "V1-03212L" with Invoice "V1-03212R"

    Given I create a SalesOrder "V2-0321-1" for Customer "1" with Product "V2" and quantity "15"
    Given I create a SalesOrder "V2-0321-2" for Customer "1" with Product "V2" and quantity "3"
    Given I deliver the SalesOrder "V2-0321-1" with PackingSlip "V2-03211L"
    Given I deliver the SalesOrder "V2-0321-2" with PackingSlip "V2-03212L"
    Given I invoice the PackingSlip "V2-03211L" with Invoice "V2-03211R"
    Given I invoice the PackingSlip "V2-03212L" with Invoice "V2-03212R"

    Given I set the fake date to "01.06.1995"
    Given I create a SalesOrder "V1-0621-1" for Customer "1" with Product "V1" and quantity "7"
    Given I create a SalesOrder "V1-0621-2" for Customer "1" with Product "V1" and quantity "3"
    Given I deliver the SalesOrder "V1-0621-1" with PackingSlip "V1-06211L"
    Given I deliver the SalesOrder "V1-0621-2" with PackingSlip "V1-06212L"
    Given I invoice the PackingSlip "V1-06211L" with Invoice "V1-06211R"
    Given I invoice the PackingSlip "V1-06212L" with Invoice "V1-06212R"

    Given I create a SalesOrder "V2-0621-1" for Customer "1" with Product "V2" and quantity "8"
    Given I create a SalesOrder "V2-0621-2" for Customer "1" with Product "V2" and quantity "15"
    Given I deliver the SalesOrder "V2-0621-1" with PackingSlip "V2-06211L"
    Given I deliver the SalesOrder "V2-0621-2" with PackingSlip "V2-06212L"
    Given I invoice the PackingSlip "V2-06211L" with Invoice "V2-06211R"
    Given I invoice the PackingSlip "V2-06212L" with Invoice "V2-06212R"

    Given I set the fake date to "04.10.1995"
    Given I create a SalesOrder "V1-1021-1" for Customer "1" with Product "V1" and quantity "10"
    Given I create a SalesOrder "V1-1021-2" for Customer "1" with Product "V1" and quantity "10"
    Given I deliver the SalesOrder "V1-1021-1" with PackingSlip "V1-10211L"
    Given I deliver the SalesOrder "V1-1021-2" with PackingSlip "V1-10212L"
    Given I invoice the PackingSlip "V1-10211L" with Invoice "V1-10211R"
    Given I invoice the PackingSlip "V1-10212L" with Invoice "V1-10212R"

    Given I create a SalesOrder "V2-1021-1" for Customer "1" with Product "V2" and quantity "10"
    Given I create a SalesOrder "V2-1021-2" for Customer "1" with Product "V2" and quantity "15"
    Given I deliver the SalesOrder "V2-1021-1" with PackingSlip "V2-10211L"
    Given I deliver the SalesOrder "V2-1021-2" with PackingSlip "V2-10212L"
    Given I invoice the PackingSlip "V2-10211L" with Invoice "V2-10211R"
    Given I invoice the PackingSlip "V2-10212L" with Invoice "V2-10212R"


  Scenario: Umsätze werden verdichtet für alle Versionen für Quartal und Monat im Basisartikel angezeigt
    Given I switch the current editor to editor "VZAHLEN" with command "UPDATE"
    # Zugänge pro Quartal laufendes Jahr 1995
    Then fields have values
      | pzm  | 150 |
      | pzm2 | 70  |
      | pzm3 | 0   |
      | pzm4 | 0   |
      | jzu  | 220 |
    # Zugänge pro Quartal Vorjahr 1994
    Then fields have values
      | pzma  | 100 |
      | pzma2 | 60  |
      | pzma3 | 0   |
      | pzma4 | 0   |
      | jzu2  | 160 |
    # Abgänge pro Quartal laufendes Jahr 1995
    Then fields have values
      | pam  | 88  |
      | pam2 | 33  |
      | pam3 | 0   |
      | pam4 | 45  |
      | jab  | 166 |
    # Abgänge pro Quartal Vorjahr 1994
    Then fields have values
      | pama  | 82  |
      | pama2 | 14  |
      | pama3 | 0   |
      | pama4 | 45  |
      | jab2  | 141 |
    # Zugänge pro Monat laufendes Jahr 1995
    Then field "gjahr" has value "95"
    Then fields have values
      | zm1  | 150 |
      | zm2  | 0   |
      | zm3  | 0   |
      | zm4  | 70  |
      | zm5  | 0   |
      | zm6  | 0   |
      | zm7  | 0   |
      | zm8  | 0   |
      | zm9  | 0   |
      | zm10 | 0   |
      | zm11 | 0   |
      | zm12 | 0   |
    # Abgänge pro Monat laufendes Jahr 1995
    Then fields have values
      | am1  | 0  |
      | am2  | 57 |
      | am3  | 31 |
      | am4  | 0  |
      | am5  | 0  |
      | am6  | 33 |
      | am7  | 0  |
      | am8  | 0  |
      | am9  | 0  |
      | am10 | 45 |
      | am11 | 0  |
      | am12 | 0  |

    # Zugänge pro Monat Vorjahr 1994
    And I set field "gjahr" to "94"
    Then fields have values
      | zm1  | 0   |
      | zm2  | 100 |
      | zm3  | 0   |
      | zm4  | 60  |
      | zm5  | 0   |
      | zm6  | 0   |
      | zm7  | 0   |
      | zm8  | 0   |
      | zm9  | 0   |
      | zm10 | 0   |
      | zm11 | 0   |
      | zm12 | 0   |
     # Abgänge pro Monat Vorjahr 1994
    Then fields have values
      | am1  | 0  |
      | am2  | 60 |
      | am3  | 22 |
      | am4  | 0  |
      | am5  | 0  |
      | am6  | 14 |
      | am7  | 0  |
      | am8  | 0  |
      | am9  | 0  |
      | am10 | 0  |
      | am11 | 45 |
      | am12 | 0  |
    And I close the current editor
