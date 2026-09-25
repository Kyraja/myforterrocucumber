@persistent
Feature: CEPI_Stammdaten.feature

  Background:
    And I set the fake date to "07.01.1995"
#And I set the operation language to "Deutsch"

# **********************************************************************************
#  Name             : CEPI_Stammdaten.feature
#  Autor            : bschiga
#  Verantwortlich   : bheim
#  Kontrolle        : bschiga
#  Funktion         : Stammdaten mit Sperrkonfiguration
#                     Änderungen bitte nur in Absprache mit den Verantwortlichen!
#
# **********************************************************************************

  # Struktur:

  # Lagerplatz und Konsilager
  # Lieferant und Kunde
  # Sperrkonfiguration
  # Packmittel und Packanweisungen
  # Arbeitsgang 
  # Artikel
  # Dienstleistungen
  # Zusatzpositionen


  Scenario: Sperrlagerplatz und Konsilager anlegen

    Given I open an editor "Lagerplatz" from table "(Location):(Location)" with command "STORE" for record "SPERR"
    And I set fields
      | such  | SPERR |
      | lager | L1    |
    And I save the current editor

# Konsilager, Konsilagergruppe anlegen
    Given I open an editor "Lagergruppe" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "KONSILG"
    And I set field "such" to "KONSILG"
    And I set field "zkonsilg" to "Ja"
    And I save the current editor

    Given I open an editor "Lager" from table "(Warehouse):(Warehouse)" with command "STORE" for record "KONSILAGER"
    And I set field "such" to "KONSILAGER"
    And I set field "lgruppe" to "KONSILG"
    And I save the current editor

    Given I open an editor "Lagerplatz" from table "(Location):(Location)" with command "STORE" for record "KONSILP"
    And I set field "such" to "KONSILP"
    And I set field "lager" to "KONSILAGER"
    And I save the current editor

# Lagergruppe mit Lagerplatz: Platz fuer Kundenanlieferung (Konsilager) eintragen
    Given I open an editor "LagergruppeKA" from table "(Warehouse):(WarehouseGroup)" with command "UPDATE" for record "KARLSRUHE"
    And I set field "vkkundenanlieferung" to "KONSILP"
    And I save the current editor

  Scenario: Lieferant und Kunde anlegen

    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "STORE" for record "FABER"
    And I set fields
      | such     | FABER         |
      | namebspr | Faber-Castell |
      | zbed     | 201           |
    And I save the current editor

    Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "PFISCHER"
    And I set fields
      | such     | PFISCHER       |
      | namebspr | Papier-Fischer |
      | ustid    | DE56454651     |
      | lbed     | EXW            |
      | zbed     | 201            |
    And I save the current editor

#  Scenario: Aufzaehlung ARTIKELSPERRE aendern und Reorganisation sofort

    Given I open an editor "Aufzaehlung" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "ARTIKELSPERRE"
    And I set field "reosofort" to "ja"
    And I delete all rows
    And I append rows
      | aufzelem     | aebez                                |
      | PRODUCTLOCK  | Standard-Artikelsperre               |
      | PRODUCTNOTE  | Standard-Artikelsperre, nur Hinweise |
    And I save the current editor

    Given I open an editor "Dienstleistung" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "DIENSTLSTSPERRE"
    And I set field "reosofort" to "ja"
    And I delete all rows
    And I append rows
      | aufzelem       | aebez                                        |
      | SERVICELOCK    | Standard-Dienstleistungssperre               |
      | SERVICENOTE    | Standard-Dienstleistungssperre, nur Hinweise |
    And I save the current editor

# Aufzaehlung ZUSPOSSPERRE aendern und Reorganisation sofort
    Given I open an editor "Aufzaehlung" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "ZUSPOSSPERRE"
    And I set field "reosofort" to "ja"
    And I delete all rows
    And I append rows
      | aufzelem       | aebez                                        |
      | SUPP_ITEMLOCK  | Standard-Zusatzpositionssperre               |
      | SUPP_ITEMNOTE  | Standard-Zusatzpositionssperre, nur Hinweise |
    And I save the current editor


  Scenario Outline: Packmittel

    Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such                  | <such>                  |
      | namebspr              | <namebspr>              |
      | packmit               | <packmit>               |
      | pmtyp                 | <pmtyp>                 |
      | sperrkonfigurationneu | <sperrkonfigurationneu> |
    And I save the current editor

    Examples:
      | such       | namebspr               | packmit | pmtyp     | sperrkonfigurationneu |
      | PACKSPERR  | Packmittel Sperre      | JA      | Behaelter | !dontChange           |
      | PACKOSPERR | Packmittel ohne Sperre | JA      | Behaelter | !dontChange           |
      | SPALETTE   | Palette Standard       | JA      | Palette   | !dontChange           |


  Scenario: Packmittel kann nicht gesperrt werden

    Given I open an editor "packmittel" from table "(Part):(Product)" with command "UPDATE" for record "PACKSPERR"
  # Fehlermeldung: 862 de   |Packmittel können nicht gesperrt werden.
    Then setting field "sperrkonfigurationneu" to "Standard-Artikelsperre" throws the exception "862"
    Then field "sperrkonfigurationneu" has value " "
    And I close the current editor


  Scenario: Packanweisungen mit und ohne gesperrtes Packmittel anlegen

    Given I open an editor "Packanweisung" from table "(PackingInstructions):(PackingInstructions)" with command "STORE" for record "PACKSPERR"
    And I set fields
      | such | PACKSPERR |
    And I append rows
      | artikel   | anzahl | ebene | minebene | auffuell |
      | PACKSPERR | 4      | 1     | 1        | ja       |
      | SPALETTE  | 1      | 1     | 1        | ja       |
    And I save the current editor

    Given I open an editor "Packanweisung" from table "(PackingInstructions):(PackingInstructions)" with command "STORE" for record "PACKOSPERR"
    And I set fields
      | such | PACKOSPERR |
    And I append rows
      | artikel    | anzahl | ebene | minebene | auffuell |
      | PACKOSPERR | 4      | 1     | 1        | ja       |
      | SPALETTE   | 1      | 1     | 1        | ja       |
    And I save the current editor


  Scenario Outline: Arbeitsgang anlegen

    Given I open an editor "arbeitsgang" from table "(Operation):(Operation)" with command "STORE" for record "<such>"
    And I set fields
      | such       | <such>       |
      | namebspr   | <such>       |
      | mgr        | <mgr>        |
      | lgr        | <lgr>        |
      | lgrruesten | <lgrruesten> |
      | aschein    | <aschein>    |
      | tr         | <tr>         |
      | te         | <te>         |
    And I save the current editor

    Examples:
      | such       | mgr | lgr | lgrruesten | aschein | tr | te |
      | MONTAGE1   | 112 | 2   | 2          | JA      | 15 | 2  |
      | REPARATUR1 | 112 | 2   | 2          | JA      | 5  | 60 |


  Scenario Outline: Einkaufsartikel mit und ohne Sperre anlegen

    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such                  | <such>                  |
      | namebspr              | <namebspr>              |
      | bsart                 | Fremdbeschaffung        |
      | dispoa                | auftragsbezogen         |
      | lief                  | <lief>                  |
      | efrist                | <efrist>                |
      | epr                   | <epr>                   |
      | chverfolgung          | <chverfolgung>          |
      | chimlager             | <chimlager>             |
      | sperrkonfigurationneu | <sperrkonfigurationneu> |
    And I save the current editor

    Examples: Artikel
      | such          | namebspr                       | lief  | efrist | epr | chverfolgung | chimlager   | sperrkonfigurationneu                |
      | EK-OHNESPERRE | Einkaufsartikel ohne Sperre    | FABER | 2      | 10  | Chargenverf  | JA          | !dontChange                          |
      | EK-HINWEIS    | Einkaufsartikel hinweis Sperre | FABER | 2      | 10  | Chargenverf  | JA          | Standard-Artikelsperre, nur Hinweise |
      | EK-GESPERRT   | Einkaufsart gesperrt           | FABER | 2      | 10  | Chargenverf  | JA          | Standard-Artikelsperre               |
      | EK-SWITCH     | Switch-Artikel fuer Sperren    | FABER | 1      | 5   | !dontChange  | !dontChange | !dontChange                          |


  Scenario Outline: Komponenten Fertigungsartikel

    Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>     |
      | namebspr | <namebspr> |
      | lief     | <lief>     |
      | efrist   | <efrist>   |
      | epr      | <epr>      |
    And I save the current editor

    Examples: Artikel
      | such      | namebspr       | lief  | efrist | epr  |
      | MINE      | Mine           | FABER | 1      | 0,50 |
      | FEDER     | Feder          | FABER | 1      | 0,05 |
      | GRIFFROHR | Griffrohr      | FABER | 1      | 1    |
      | VORSCHUB  | Vorschubhuelse | FABER | 1      | 0,70 |


  Scenario Outline: Eigenfertigungsartikel mit und ohne Sperre anlegen

    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such                  | <such>                  |
      | namebspr              | <namebspr>              |
      | bsart                 | Eigenfertigung          |
      | dispoa                | auftragsbezogen         |
      | vpr                   | <vpr>                   |
      | chverfolgung          | <chverfolgung>          |
      | chimlager             | <chimlager>             |
      | sperrkonfigurationneu | <sperrkonfigurationneu> |
    And I delete all rows
    And I append rows
      | elex       | elanzahl | lge | breite |
      | MINE       | 1        |     |        |
      | FEDER      | 1        |     |        |
      | GRIFFROHR  | 1        |     |        |
      | VORSCHUB   | 1        |     |        |
      | A MONTAGE1 |          | 15  | 2      |
    And I save the current editor

    Examples: Artikel
      | such          | namebspr                      | vpr         | chverfolgung | chimlager   | sperrkonfigurationneu                |
      | VK-OHNESPERRE | Fertigungsartikel ohne Sperre | 5           | Chargenverf  | JA          | !dontChange                          |
      | VK-HINWEIS    | Fertigungsart hinweis Sperre  | 5           | Chargenverf  | JA          | Standard-Artikelsperre, nur Hinweise |
      | VK-GESPERRT   | Fertigungsart gesperrt        | 5           | Chargenverf  | JA          | Standard-Artikelsperre               |
      | VK-SWITCH     | Switch-Artikel fuer Sperren   | 1           | !dontChange  | !dontChange | !dontChange                          |
      | BG-GESPERRT   | Gesperrte BG                  | !dontChange | !dontChange  | !dontChange | Standard-Artikelsperre               |


  Scenario Outline: Setartikel/Baugruppe mit gesperrten Komponenten mit und ohne Lieferantenbeistellung

    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>         |
      | namebspr | <namebspr>     |
      | bsart    | Eigenfertigung |
      | earta    | <eart>         |
    And I delete all rows
    And I append rows
      | elex        | bua         | elanzahl | lge | breite |
      | EK-GESPERRT | <bua>       | 1        |     |        |
      | VORSCHUB    | !dontChange | 1        |     |        |
      | A MONTAGE1  | !dontChange |          | 15  | 2      |
    And I save the current editor

    Examples: Artikel
      | such           | namebspr                        | eart            | bua                    |
      | SET-K-GESPERRT | Set mit gesperrten Komponenten  | über Stückliste | !dontChange            |
      | BG-LB-GESPERRT | Baugruppe mit gesperrten lbeist | über Artikel    | lieferantenbeistellung |
      | BG-K-GESPERRT  | Baugruppe mit gesperrter Komp   | über Artikel    | !dontChange            |


  Scenario Outline: Eigenfertigung mit gesperrten Komponenten

    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such                  | <such>                  |
      | namebspr              | <namebspr>              |
      | bsart                 | Eigenfertigung          |
      | dispoa                | auftragsbezogen         |
      | sperrkonfigurationneu | <sperrkonfigurationneu> |
    And I delete all rows
    And I append rows
      | elex       | elanzahl | lge | breite |
      | MINE       | 1        |     |        |
      | FEDER      | 1        |     |        |
      | GRIFFROHR  | 1        |     |        |
      | <elex>     | 1        |     |        |
      | A MONTAGE1 |          | 15  | 2      |
    And I save the current editor

    Examples:
      | such           | namebspr                       | sperrkonfigurationneu | elex          |
      | ART-GESPERRT   | Artikel mit gesperrter BG      | !dontChange           | BG-GESPERRT   |
      | ART-K-GESPERRT | Artikel mit gesperrter BG Komp | !dontChange           | BG-K-GESPERRT |
      | BG-K-SWITCH    | Baugruppe mit Switch Komp      | !dontChange           | EK-SWITCH     |
      | BG-SWITCH      | Switch-Baugruppe fuer Sperren  | !dontChange           | EK-OHNESPERRE |


  Scenario Outline: Dienstleistung ohne Fertigungsliste

    Given I open an editor "<such>" from table "(Part):(Service)" with command "STORE" for record "<such>"
    And I set fields
      | such                  | <such>                  |
      | namebspr              | <such>                  |
      | sperrkonfigurationneu | <sperrkonfigurationneu> |
      | vpr                   | 120                     |
      | lirelev               | nein                    |
    And I save the current editor

    Examples:
      | such          | sperrkonfigurationneu                        |
      | DL-OHNESPERRE | !dontChange                                  |
      | DL-HINWEIS    | Standard-Dienstleistungssperre, nur Hinweise |
      | DL-GESPERRT   | Standard-Dienstleistungssperre               |


  Scenario: Dienstleistung mit eine gesperrte Komponente

    Given I open an editor "DL-KOMPSPERRE" from table "(Part):(Service)" with command "STORE" for record "DL-KOMPSPERRE"
    And I set fields
      | such     | DL-KOMPSPERRE |
      | namebspr | DL-KOMPSPERRE |
      | vpr      | 120           |
      | lirelev  | nein          |
    And I delete all rows
    And I append rows
      | elex        | elanzahl | lge | breite |
      | MINE        | 1        |     |        |
      | FEDER       | 1        |     |        |
      | GRIFFROHR   | 1        |     |        |
      | EK-GESPERRT | 1        |     |        |
      | A MONTAGE1  |          | 15  | 2      |
    And I save the current editor


  Scenario Outline: Servicepflichtiger Eigenfertigungsartikel mit und ohne Sperre anlegen

    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such                  | <such>                  |
      | namebspr              | <namebspr>              |
      | bsart                 | Eigenfertigung          |
      | dispoa                | <dispoa>                |
      | vpr                   | <vpr>                   |
      | chverfolgung          | <chverfolgung>          |
      | chimlager             | <chimlager>             |
      | sperrkonfigurationneu | <sperrkonfigurationneu> |
      | serpflicht            | ja                      |
    And I delete all rows
    And I append rows
      | elex        | elanzahl | lge | breite | tnwpflicht |
      | MINE        | 1        |     |        | ja         |
      | FEDER       | 1        |     |        |            |
      | GRIFFROHR   | 1        |     |        | ja         |
      | EK-GESPERRT | 1        |     |        |            |
      | A MONTAGE1  |          | 15  | 2      |            |
    And I save the current editor

    Examples: Artikel
      | such         | namebspr                     | dispoa      | vpr         | chverfolgung | chimlager | sperrkonfigurationneu                |
      | S-OHNESPERRE | Serviceartikel ohne gesperrt | !dontChange | 5           | Chargenverf  | JA        | !dontChange                          |
      | S-HINWEIS    | Serviceart hinweis Sperre    | !dontChange | 5           | Chargenverf  | JA        | Standard-Artikelsperre, nur Hinweise |
      | S-GESPERRT   | Servicesart gesperrt         | !dontChange | 5           | Chargenverf  | JA        | Standard-Artikelsperre               |
      | S-LEIH       | Serviceart Leihgeraet        | !dontChange | !dontChange | !dontChange  | JA        | !dontChange                          |


  Scenario: Artikel mit Dipsoausschuss

    Given I open an editor "UBG_AUSSCHUSS" from table "(Part):(Product)" with command "STORE" for record "UBG_AUSSCHUSS"
    And I set fields
      | such   | UBG_AUSSCHUSS   |
      | bsart  | Eigenfertigung  |
      | dispoa | auftragsbezogen |
    And I delete all rows
    And I append rows
      | elex       | elanzahl    |
      | FEDER      | 1           |
      | A MONTAGE1 | !dontChange |
    And I save the current editor

    Given I open an editor "BG_AUSSCHUSS" from table "(Part):(Product)" with command "STORE" for record "BG_AUSSCHUSS"
    And I set fields
      | such   | BG_AUSSCHUSS    |
      | bsart  | Eigenfertigung  |
      | dispoa | auftragsbezogen |
    And I delete all rows
    And I append rows
      | elex              | elanzahl    | pverlust    |
      | !UBG_AUSSCHUSS^id | 1           | 10          |
      | A MONTAGE1        | !dontChange | !dontChange |
    And I save the current editor


  Scenario: Lohnfertigungs-Artikel anlegen

    Given I open an editor "HALB-F" from table "(Part):(Product)" with command "STORE" for record "HALB-F"
    And I set fields
      | such                  | HALB-F         |
      | sperrkonfigurationneu |                |
      | dispoa                |                |
      | bsart                 | Eigenfertigung |
    And I save the current editor

    Given I open an editor "LOHN-FERT" from table "(Part):(Product)" with command "STORE" for record "LOHN-FERT"
    And I set fields
      | such                  | LOHN-FERT     |
      | sperrkonfigurationneu |               |
      | bsart                 | Lohnfertigung |
    And I delete all rows
    And I append rows
      | elex   | elanzahl |
      | HALB-F | 1        |
    And I save the current editor

    Given I open an editor "SWITCH-LOHN" from table "(Part):(Product)" with command "STORE" for record "SWITCH-LOHN"
    And I set fields
      | such                  | SWITCH-LOHN    |
      | sperrkonfigurationneu |                |
      | bsart                 | Eigenfertigung |
      | lief                  | FABER          |
      | efrist                | 2              |
    And I delete all rows
    And I append rows
      | elex       | elanzahl | lge | breite |
      | LOHN-FERT  | 1        |     |        |
      | A MONTAGE1 |          | 5   | 10     |
    And I save the current editor


  Scenario Outline: Zusatzpositionen mit und ohne Sperre anlegen

    Given I open an editor "<such>" from table "(Part):(SupplementaryItem)" with command "STORE" for record "<such>"
    And I set fields
      | such                  | <such>                     |
      | namebspr              | Zusatzposition Test Sperre |
      | zptyp                 | AU/BE-Position,BV          |
      | lirelev               | ja                         |
      | rerelev               | ja                         |
      | umlage                | nein                       |
      | ebezbspr              | <ebezbspr>                 |
      | vkbezbspr             | <vkbezbspr>                |
      | sperrkonfigurationneu | <sperrkonfigurationneu>    |
    And I save the current editor

    Examples:
      | such            | sperrkonfigurationneu          | ebezbspr                | vkbezbspr               |
      | ZUSATZ-GESPERRT | Standard-Zusatzpositionssperre | AU/BE-Position gesperrt | AU/BE-Position gesperrt |
      | ZUSATZ-SWITCH   | !dontChange                    | AU/BE-Position Switch   | AU/BE-Position Switch   |
