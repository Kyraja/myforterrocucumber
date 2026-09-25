# *****************************************************************************
# Name           : objektsperren.feature
# Verantwortlich : teampss
# Funktion       : Prueft Sperrkonfigurationen, die den Einkauf/Verkauf betreffen.
#
# *****************************************************************************
@persistent
Feature: Test von Sperrkonfigurationen, die den Einkauf/Verkauf betreffen

  Background:
    Given I set the fake date to "02.01.1995"
    Given I enable the flag 39

  # ---------------------------------------------------------------------------------------------
  Scenario: EDI einschalten
    # ---------------------------------------------------------------------------------------------
    Given I open an editor "Firma" from table "(Company):(Configuration)" with command "UPDATE" for record "KONFIG"
    And I set field "automotive" to "ja"
    And I set field "edi" to "ja"
    And I save the current editor

  # -----------------------------------------------------------------------------
  Scenario: Stammdaten anlegen
    # -----------------------------------------------------------------------------
    # Lieferant
    Given I open an editor "LI001" from table "(Vendor):(Vendor)" with command "NEW" for record ""
    And I set fields
      | nummer | 1LI001            |
      | such   | LI001             |
      | name   | Testlieferant 001 |
      | ans    | Testlieferant 001 |
      | nort   | Karlsruhe         |
      | plz    | 76133             |
      | waehr  | DEM               |
    And I save the current editor
    # Lieferantenkontakt
    Given I open an editor "LK001" from table "(Vendor):(VendorContact)" with command "NEW" for record ""
    And I set fields
      | nummer | 1LK001                     |
      | such   | LK001                      |
      | firma  | LI001                      |
      | name   | Testlieferantenkontakt 001 |
      | ans    | TestLieferantenkontakt 001 |
    And I save the current editor
    # Artikel 1
    Given I open an editor "TE001" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
      | such     | TE001            |
      | namebspr | Teil 001         |
      | bsart    | Fremdbeschaffung |
      | dispoa   | auftragsbezogen  |
      | vpr      | 10               |
      | lief     | LK001            |
      | epr      | 10               |
      | lief2    | LI001            |
      | epr2     | 20               |
      | lief3    |                  |
      | epr3     | 30               |
    And I save the current editor
    # Artikel 2
    Given I open an editor "TE002" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
      | such     | TE002            |
      | namebspr | Teil 002         |
      | bsart    | Fremdbeschaffung |
      | dispoa   | auftragsbezogen  |
      | vpr      | 200              |
      | lief     | LK001            |
      | epr      | 100              |
    And I save the current editor
    # Lohnfertigung
    Given I open an editor "LF001" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
      | such     | LF001             |
      | namebspr | Lohnfertigung 001 |
      | bsart    | Lohnfertigung     |
    And I save the current editor
    # Kunde 1
    Given I open an editor "KU001" from table "(Customer):(Customer)" with command "NEW" for record ""
    And I set fields
      | nummer | 1KU001        |
      | such   | KU001         |
      | name   | Testkunde 001 |
      | ans    | Testkunde 001 |
      | nort   | Karlsruhe     |
      | plz    | 76133         |
      | waehr  | DEM           |
    And I save the current editor
    # Kundenkontakt
    Given I open an editor "KK001" from table "(Customer):(CustomerContact)" with command "NEW" for record ""
    And I set fields
      | nummer | 1KK001                |
      | such   | KK001                 |
      | firma  | KU001                 |
      | name   | Testkundenkontakt 001 |
      | ans    | TestKundenkontakt 001 |
    And I save the current editor
    # Kunde 2
    Given I open an editor "KU002" from table "(Customer):(Customer)" with command "NEW" for record ""
    And I set fields
      | nummer | 1KU002        |
      | such   | KU002         |
      | name   | Testkunde 002 |
      | ans    | Testkunde 002 |
      | nort   | Karlsruhe     |
      | plz    | 76133         |
      | waehr  | DEM           |
    And I save the current editor
    # EDI Kunde anlegen
    Given I open an editor "KU003" from table "(Customer):(Customer)" with command "NEW" for record ""
    And I set fields
      | nummer | 1KU003    |
      | such   | KU003     |
      | name   | TESLO     |
      | ans    | TESLO     |
      | nort   | Karlsruhe |
      | plz    | 76133     |
      | waehr  | DEM       |
    And I save the current editor
    # Kundenkontakt
    Given I open an editor "KK003" from table "(Customer):(CustomerContact)" with command "NEW" for record ""
    And I set fields
      | nummer    | 1KK003          |
      | such      | KK003           |
      | firma     | KU003           |
      | name      | TESLO Zentrum 2 |
      | werk      | 2               |
      | ablstelle | Tor 1           |
      | ans       | TESLO AG        |
      | str       | Mozartstr 50    |
      | lakenn    | D               |
      | plz       | 89073           |
      | nort      | Ulm             |
      | gln       | GLN302          |
    And I save the current editor
    # EDI Lieferant anlegen
    Given I open an editor "LI003" from table "(Vendor):(Vendor)" with command "NEW" for record ""
    And I set fields
      | such  | LI003 |
      | name  | BOSCH |
      | ans   | BOSCH |
      | nort  | Bühl  |
      | plz   | 7915  |
      | waehr | DEM   |
    And I save the current editor
    # Lieferantenkontakt
    Given I open an editor "LK003" from table "(Vendor):(VendorContact)" with command "NEW" for record ""
    And I set fields
      | such      | LK003                 |
      | firma     | LI003                 |
      | name      | BOSCH Zentrum 2       |
      | werk      | 2                     |
      | ablstelle | Tor 1                 |
      | ans       | BOSCH AG              |
      | str       | Robert-Bosch-Straße 1 |
      | lakenn    | D                     |
      | plz       | 89073                 |
      | nort      | Ulm                   |
      | gln       | GLN312                |
    And I save the current editor

  # -----------------------------------------------------------------------------
  Scenario: Prozesssperrstelle - Lieferantenkontakt in der Preisfindung
    # -----------------------------------------------------------------------------
    Given I open an editor "BEVOR" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | mge |
      | TE001   | 1   |
    Then table has values
      | artikel | kl     | preis |
      | TE001   | 1LK001 | 10.00 |
    And I close the current editor
    Given I open an editor "LK001" from table "(Vendor):(VendorContact)" with command "UPDATE" for record from editor "LK001"
    And I set field "sperrkonfigurationneu" to "Standard-Lieferantenkontaktsperre"
    And I save the current editor
    Given I open an editor "BEVOR" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | mge |
      | TE001   | 1   |
    Then table has values
      | artikel | kl | preis |
      | TE001   |    | 30.00 |
    And I close the current editor

  # -----------------------------------------------------------------------------
  Scenario: Prozesssperrstelle - Lieferant in der Preisfindung
    # -----------------------------------------------------------------------------
    Given I open an editor "TE001" from table "(Part):(Product)" with command "UPDATE" for record from editor "TE001"
    And I press button "ersterlief2"
    And I save the current editor
    Given I open an editor "BEVOR" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | mge |
      | TE001   | 1   |
    Then table has values
      | artikel | kl     | preis |
      | TE001   | 1LI001 | 20.00 |
    And I close the current editor
    Given I open an editor "LI001" from table "(Vendor):(Vendor)" with command "UPDATE" for record from editor "LI001"
    And I set field "sperrkonfigurationneu" to "Standard-Lieferantensperre"
    And I save the current editor
    Given I open an editor "BEVOR" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | mge |
      | TE001   | 1   |
    Then table has values
      | artikel | kl | preis |
      | TE001   |    | 30.00 |
    And I close the current editor
    Given I open an editor "TE001" from table "(Part):(Product)" with command "UPDATE" for record from editor "TE001"
    And I set fields
      | lief2 |    |
      | epr2  | 30 |
      | lief3 |    |
      | epr3  | 0  |
    And I save the current editor
    Given I open an editor "LK001" from table "(Vendor):(VendorContact)" with command "UPDATE" for record from editor "LK001"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    Given I open an editor "BEVOR" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | kl     | mge |
      | TE001   | 1LK001 | 1   |
    Then table has values
      | artikel | kl     | preis |
      | TE001   | 1LK001 | 30.00 |
    And I close the current editor
    Given I open an editor "LI001" from table "(Vendor):(Vendor)" with command "UPDATE" for record from editor "LI001"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    Given I open an editor "TE001" from table "(Part):(Product)" with command "UPDATE" for record from editor "TE001"
    And I set fields
      | lief  |       |
      | epr   | 30    |
      | lief2 | LI001 |
      | epr2  | 20    |
    And I save the current editor
    Given I open an editor "BEVOR" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | kl     | mge |
      | TE001   | 1LK001 | 1   |
    Then table has values
      | artikel | kl     | preis |
      | TE001   | 1LK001 | 20.00 |
    And I close the current editor

  # -----------------------------------------------------------------------------
  Scenario Outline: Prozesssperrstelle - Wandlung von Interessenten zu Kunden - Stammdaten
    # -----------------------------------------------------------------------------
    Given I open an editor "<such>" from table "<table>" with command "NEW" for record ""
    And I set fields
      | nummer | <nummer>  |
      | such   | <such>    |
      | name   | <name>    |
      | ans    | <ans>     |
      | nort   | Karlsruhe |
      | plz    | 76133     |
      | firma  | <firma>   |
      | reempf | <reempf>  |
    And I save the current editor

    Examples:
      | table                        | nummer  | such   | name                         | ans                          | firma       | reempf      |
      | (Customer):(Prospect)        | 1INT001 | INT001 | Testinteressent 001          | Testinteressent 001          | !dontChange | !dontChange |
      | (Customer):(ProspectContact) | 1INK001 | INK001 | Testinteressentenkontakt 001 | Testinteressentenkontakt 001 | INT001      | !dontChange |
      | (Customer):(ProspectContact) | 1INK002 | INK002 | Testinteressentenkontakt 002 | Testinteressentenkontakt 002 | INT001      | !dontChange |
      | (Customer):(Prospect)        | 1INT002 | INT002 | Testinteressent 002          | Testinteressent 002          | !dontChange | INT001      |
      | (Customer):(ProspectContact) | 1INK003 | INK003 | Testinteressentenkontakt 003 | Testinteressentenkontakt 003 | INT002      | !dontChange |
      | (Customer):(ProspectContact) | 1INK004 | INK004 | Testinteressentenkontakt 004 | Testinteressentenkontakt 004 | INT002      | !dontChange |

  # -----------------------------------------------------------------------------
  Scenario: Prozesssperrstelle - Wandlung von Interessenten mit Interessentenkontakten zu Kunden mit Kundenkontakten
    # -----------------------------------------------------------------------------
    Given I open an editor "INK004" from table "(Customer):(ProspectContact)" with command "UPDATE" for record from editor "INK004"
    And I set field "sperrkonfigurationneu" to "Standard-Interessentenkontaktsperre"
    And I save the current editor
    Given I open an editor "transfer" from table "(Customer):(Prospect)" with command "TRANSFER" for record from editor "INT002"
    And I respond with answer "ja" to the dialog with id "8993"
    Then saving the current editor throws the exception "4806"
    And I close the current editor
    Given I open an editor "INK004" from table "(Customer):(ProspectContact)" with command "UPDATE" for record from editor "INK004"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    Given I open an editor "INK003" from table "(Customer):(ProspectContact)" with command "UPDATE" for record from editor "INK003"
    And I set field "sperrkonfigurationneu" to "Standard-Interessentenkontaktsperre"
    And I save the current editor
    Given I open an editor "transfer" from table "(Customer):(Prospect)" with command "TRANSFER" for record from editor "INT002"
    And I respond with answer "ja" to the dialog with id "8993"
    Then saving the current editor throws the exception "4806"
    And I close the current editor
    Given I open an editor "INK003" from table "(Customer):(ProspectContact)" with command "UPDATE" for record from editor "INK003"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    Given I open an editor "INK002" from table "(Customer):(ProspectContact)" with command "UPDATE" for record from editor "INK002"
    And I set field "sperrkonfigurationneu" to "Standard-Interessentenkontaktsperre"
    And I save the current editor
    Given I open an editor "transfer" from table "(Customer):(Prospect)" with command "TRANSFER" for record from editor "INT002"
    And I respond with answer "ja" to the dialog with id "8993"
    Then saving the current editor throws the exception "4806"
    And I close the current editor
    Given I open an editor "INK002" from table "(Customer):(ProspectContact)" with command "UPDATE" for record from editor "INK002"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    Given I open an editor "INK001" from table "(Customer):(ProspectContact)" with command "UPDATE" for record from editor "INK001"
    And I set field "sperrkonfigurationneu" to "Standard-Interessentenkontaktsperre"
    And I save the current editor
    Given I open an editor "transfer" from table "(Customer):(Prospect)" with command "TRANSFER" for record from editor "INT002"
    And I respond with answer "ja" to the dialog with id "8993"
    Then saving the current editor throws the exception "4806"
    And I close the current editor
    Given I open an editor "INK001" from table "(Customer):(ProspectContact)" with command "UPDATE" for record from editor "INK001"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    Given I open an editor "INT002" from table "(Customer):(Prospect)" with command "UPDATE" for record from editor "INT002"
    And I set field "sperrkonfigurationneu" to "Standard-Interessentensperre"
    And I save the current editor
    Given I open an editor "transfer" from table "(Customer):(Prospect)" with command "TRANSFER" for record from editor "INT002"
    And I respond with answer "ja" to the dialog with id "8993"
    Then saving the current editor throws the exception "4806"
    And I close the current editor
    Given I open an editor "INT002" from table "(Customer):(Prospect)" with command "UPDATE" for record from editor "INT002"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    Given I open an editor "INT001" from table "(Customer):(Prospect)" with command "UPDATE" for record from editor "INT001"
    And I set field "sperrkonfigurationneu" to "Standard-Interessentensperre"
    And I save the current editor
    Given I open an editor "transfer" from table "(Customer):(Prospect)" with command "TRANSFER" for record from editor "INT002"
    And I respond with answer "ja" to the dialog with id "8993"
    Then saving the current editor throws the exception "4806"
    And I close the current editor
    Given I open an editor "INT001" from table "(Customer):(Prospect)" with command "UPDATE" for record from editor "INT001"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    Given I open an editor "transfer" from table "(Customer):(Prospect)" with command "TRANSFER" for record from editor "INT002"
    And I respond with answer "ja" to the dialog with id "8993"
    And I save the current editor

  # -----------------------------------------------------------------------------
  Scenario: Prozesssperrstelle - In der Versandplanung wird ein Kunde mit Sperrkonfiguration Gesperrt nicht uebernommen
    # -----------------------------------------------------------------------------
    # Artikel 2 sperren
    Given I open an editor "TE002" from table "(Part):(Product)" with command "UPDATE" for record "TE002"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor
    # Auftrag anlegen
    Given I open an editor "Auftrag1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "KU001"
    And I append rows
      | artikel | mge | fmenge | abruftyp |
      | TE001   | 100 | 10     | LAB      |
      | TE002   | 50  | 5      | LAB      |
    And I save the current editor
    # Kunde 1 sperren
    And I switch the current editor to editor "KU001" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Kundensperre"
    And I save the current editor
    # Versandplanung ueber Selektionskriterien im Kopf, ueber Beleg anfuegen und Zeile
    Given I open an editor "Versandplanung" from table "(ShippingPlanning):(ShippingPlanning)" with command "NEW" for record ""
    # Eingabe nicht uebernommen, da Kunde gesperrt ist.
    Then setting field "beleganfuegen" to "200001" throws the exception "7852"
    Then the table has 0 rows
    And I close the current editor
    # Kunde 1 leere Sperre
    And I switch the current editor to editor "KU001" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    # Versandplanung ueber Selektionskriterien im Kopf, ueber Beleg anfuegen und Zeile
    Given I open an editor "Versandplanung1" from table "(ShippingPlanning):(ShippingPlanning)" with command "NEW" for record ""
    And I set field "beleganfuegen" to "nummer" from editor "Auftrag1"
    Then the table has 1 rows
    And I close the current editor
    # Auftrag 2 anlegen
    Given I open an editor "Auftrag2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "KU002"
    And I append rows
      | artikel | mge | fmenge | abruftyp |
      | TE001   | 100 | 10     | LAB      |
    And I save the current editor
    # Kunde 2 sperren
    And I switch the current editor to editor "KU002" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Kundensperre"
    And I save the current editor
    Given I open an editor "Versandplanung2" from table "(ShippingPlanning):(ShippingPlanning)" with command "NEW" for record ""
    And I create a new row at the end of the table
    # Eingabe nicht uebernommen
    Then setting field "vkkopf" to "200002" in row 1 throws the exception "7852"
    And I close the current editor
    # Auftrag 3 anlegen
    Given I open an editor "Auftrag3" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "KK001"
    And I append rows
      | artikel | mge | fmenge | abruftyp |
      | TE001   | 100 | 10     | LAB      |
    And I save the current editor
    # Kundenkontakt 1 sperren
    And I switch the current editor to editor "KK001" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Kundenkontaktsperre"
    And I save the current editor
    Given I open an editor "Versandplanung3" from table "(ShippingPlanning):(ShippingPlanning)" with command "NEW" for record ""
    And I create a new row at the end of the table
    # Eingabe nicht uebernommen
    Then setting field "vkkopf" to "200003" in row 1 throws the exception "7852"
    And I close the current editor
    # Artikel 2 leere Sperre
    Given I open an editor "TE002" from table "(Part):(Product)" with command "UPDATE" for record "TE002"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    # Kundenkontakt 1 leere Sperre
    And I switch the current editor to editor "KK001" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

  # -----------------------------------------------------------------------------
  Scenario: Ein Kunde in einer Versandplanung kann nicht weiter bearbeitet werden, wenn Kunde gesperrt wurde
    # -----------------------------------------------------------------------------
    # Kunde 1 leere Sperre
    Given I open an editor "KU001" from table "(Customer):(Customer)" with command "UPDATE" for record "KU001"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    # Auftrag anlegen
    Given I open an editor "Auftrag4" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "KU001"
    And I append rows
      | artikel | mge | fmenge | abruftyp |
      | TE001   | 100 | 10     | LAB      |
    And I save the current editor
    # Versandplanung anlegen
    Given I open an editor "Versandplanung4" from table "(ShippingPlanning):(ShippingPlanning)" with command "NEW" for record ""
    And I set field "pstermvon" to "."
    And I create a new row at the end of the table
    And I set field "vkkopf" to "nummer" from editor "Auftrag4" in row 1
    Then the table has 1 rows
    And I save the current editor
    # Kunde 1 sperren
    And I switch the current editor to editor "KU001" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Kundensperre"
    And I save the current editor
    And I switch the current editor to editor "Versandplanung4" with command "UPDATE"
    Then field "statusico" has value "icon:stop" in row 1
    Then field "mfreig" has value "nein" in row 1
    Then field "mfreig" is not modifiable in row 1

  # -----------------------------------------------------------------------------
  Scenario: Prozesssperrstelle - In der Versandplanung werden Auftragspositionen mit einem gesperrten Rechnungskunden oder Warenempfaenger nicht uebernommen
    # -----------------------------------------------------------------------------
    # Kunde 1 leere Sperre
    And I switch the current editor to editor "KU001" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    # Kunde 2 leere Sperre
    And I switch the current editor to editor "KU002" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    # Auftrag 5 anlegen
    Given I open an editor "Auftrag5" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "KU001"
    And I set field "kl2" to "KU002"
    And I append rows
      | artikel | mge | fmenge | abruftyp |
      | TE001   | 10  | 10     | LAB      |
      | TE002   | 20  | 10     | LAB      |
    And I save the current editor
    # Auftrag 6 anlegen
    Given I open an editor "Auftrag6" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "KU001"
    And I set field "warenempf" to "KU002"
    And I append rows
      | artikel | mge | fmenge | abruftyp |
      | TE001   | 100 | 10     | LAB      |
    And I save the current editor
    # Kunde 2 sperren
    And I switch the current editor to editor "KU002" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Kundensperre"
    And I save the current editor
    # Versandplanung ueber Selektionskriterien im Kopf, ueber Beleg anfuegen und Zeile
    Given I open an editor "Versandplanung5" from table "(ShippingPlanning):(ShippingPlanning)" with command "NEW" for record ""
    Then setting field "beleganfuegen" to "200005" throws the exception "7852"
    # Nichts uebernommen, da Rechnungskunde gesperrt
    Then the table has 0 rows
    Then setting field "beleganfuegen" to "200006" throws the exception "7852"
    # Nichts uebernommen, da Warenempfaenger gesperrt
    Then the table has 0 rows
    And I close the current editor
    # Kunde 2 leere Sperre
    And I switch the current editor to editor "KU002" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    Given I open an editor "Versandplanung5" from table "(ShippingPlanning):(ShippingPlanning)" with command "NEW" for record ""
    And I set field "beleganfuegen" to "nummer" from editor "Auftrag5"
    Then the table has 2 rows
    And I set field "beleganfuegen" to "nummer" from editor "Auftrag6"
    Then the table has 3 rows
    And I close the current editor

  # -----------------------------------------------------------------------------
  Scenario: Prozesssperrstelle - In der Versandplanung koennen Positionen mit einem gesperrten Kunden und Artikeln nicht fuer die Freigabe markiert werden
    # -----------------------------------------------------------------------------
    # Auftrag 7 anlegen
    Given I open an editor "Auftrag7" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "KU002"
    And I append rows
      | artikel | mge | fmenge | abruftyp |
      | TE001   | 10  | 10     | LAB      |
      | TE002   | 20  | 10     | LAB      |
    And I save the current editor
    # Auftrag 8 anlegen
    Given I open an editor "Auftrag8" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "KU001"
    And I append rows
      | artikel | mge | fmenge | abruftyp |
      | TE001   | 30  | 10     | LAB      |
    And I save the current editor
    # Versandplanung ueber Beleg anfuegen
    Given I open an editor "Versandplanung7" from table "(ShippingPlanning):(ShippingPlanning)" with command "NEW" for record ""
    And I set field "pstermvon" to "."
    And I set field "pstermbis" to "+1"
    And I set field "beleganfuegen" to "nummer" from editor "Auftrag7"
    Then the table has 2 rows
    And I set field "beleganfuegen" to "nummer" from editor "Auftrag8"
    Then the table has 3 rows
    And I save the current editor
    # Kunde 1 sperren
    And I switch the current editor to editor "KU001" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Kundensperre"
    And I save the current editor
    # Artikel 2 sperren
    Given I open an editor "TE002" from table "(Part):(Product)" with command "UPDATE" for record "TE002"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor
    # Versandplanung aendern
    Given I open an editor "Versandplanung7" from table "(ShippingPlanning):(ShippingPlanning)" with command "UPDATE" for record from editor "Versandplanung7"
    Then field "mfreig" has value "nein" in row 1
    Then field "mfreig" is modifiable in row 1
    Then field "mfreig" has value "nein" in row 2
    Then field "mfreig" is not modifiable in row 2
    Then field "mfreig" has value "nein" in row 3
    Then field "mfreig" is not modifiable in row 3
    And I close the current editor
    # Kunde 1 leere Sperre
    And I switch the current editor to editor "KU001" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    # Artikel 2 leer Sperre
    Given I open an editor "TE002" from table "(Part):(Product)" with command "UPDATE" for record "TE002"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    Given I open an editor "Versandplanung7" from table "(ShippingPlanning):(ShippingPlanning)" with command "UPDATE" for record from editor "Versandplanung7"
    Then field "statusico" has value "icon:flag_blue" in row 1
    Then field "mfreig" has value "nein" in row 1
    Then field "mfreig" is modifiable in row 1
    Then field "mfreig" has value "nein" in row 2
    Then field "mfreig" is modifiable in row 2
    Then field "mfreig" has value "nein" in row 3
    Then field "mfreig" is modifiable in row 3
    And I close the current editor

  # -----------------------------------------------------------------------------
  Scenario: Prozesssperrstelle - In der Versandplanung koennen Positionen mit einem gesperrten Kunden und Artikeln nicht freigegeben werden
    # -----------------------------------------------------------------------------
    # Versandplanung 4 aendern: Positionen fuer Freigabe markieren
    Given I open an editor "Versandplanung4" from table "(ShippingPlanning):(ShippingPlanning)" with command "UPDATE" for record from editor "Versandplanung4"
    And I press button "malle"
    Then field "mfreig" has value "ja" in row 1
    Then field "mfreig" is modifiable in row 1
    And I save the current editor
    # Versandplanung 7 aendern: Alle Positionen fuer Freigabe markieren
    Given I open an editor "Versandplanung7" from table "(ShippingPlanning):(ShippingPlanning)" with command "UPDATE" for record from editor "Versandplanung7"
    And I press button "malle"
    Then field "mfreig" has value "ja" in row 1
    Then field "mfreig" is modifiable in row 1
    Then field "mfreig" has value "ja" in row 2
    Then field "mfreig" is modifiable in row 2
    Then field "mfreig" has value "ja" in row 3
    Then field "mfreig" is modifiable in row 3
    And I save the current editor
    # Kunde 1 sperren
    Given I open an editor "KU001" from table "(Customer):(Customer)" with command "UPDATE" for record "KU001"
    And I set field "sperrkonfigurationneu" to "Standard-Kundensperre"
    And I save the current editor
    # Artikel 2 sperren
    Given I open an editor "TE002" from table "(Part):(Product)" with command "UPDATE" for record "TE002"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor
    # Versandplanung 4 aendern: Es kann nichts freigegeben werden
    Given I open an editor "Versandplanung4" from table "(ShippingPlanning):(ShippingPlanning)" with command "UPDATE" for record from editor "Versandplanung4"
    And I press button "malle"
    Then field "statusico" has value "icon:stop" in row 1
    Then field "mfreig" has value "nein" in row 1
    And I press button "freig" to open a subeditor for "VersandLS4"
    And I close the current editor
    And I switch the current editor to editor "Versandplanung4"
    # Then pressing button "freig" in row 0 to open a subeditor throws the exception "4806"
    And I close the current editor
    # Versandplanung 7 aendern: Es kann nur eine Position freigegeben werden
    Given I open an editor "Versandplanung7" from table "(ShippingPlanning):(ShippingPlanning)" with command "UPDATE" for record from editor "Versandplanung7"
    Then field "mfreig" has value "ja" in row 1
    Then field "mfreig" has value "nein" in row 2
    Then field "mfreig" has value "nein" in row 3
    And I press button "freig" to open a subeditor for "VersandLS7"
    And I close the current editor
    And I switch the current editor to editor "Versandplanung7"
    And I save the current editor
    # Von der Versandplanung erstellten Lieferschein pruefen
    Given I open an editor "VP-LS7" from table "(Sales):(PackingSlip)" with command "VIEW" for record "300001"
    Then the table has 1 rows
    Then field "artikel" has value "TE001" in row 1
    Then field "mge" has value "10" in row 1
    And I close the current editor

  # -----------------------------------------------------------------------------
  Scenario: Prozesssperrstelle - In der Versandplanung koennen Positionen mit einem gesperrten Kunden (in 1. Zeile) nicht freigegeben werden
    # -----------------------------------------------------------------------------
    # Kunde 1 Keine Sperre
    Given I open an editor "KU001" from table "(Customer):(Customer)" with command "UPDATE" for record "KU001"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    # Artikel 2 Keine Sperre
    Given I open an editor "TE002" from table "(Part):(Product)" with command "UPDATE" for record "TE002"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    # Auftrag 9 anlegen
    Given I open an editor "Auftrag9" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "KU002"
    And I append rows
      | artikel | mge | fmenge | abruftyp |
      | TE002   | 100 | 50     | LAB      |
    And I save the current editor
    # Auftrag 10 anlegen
    Given I open an editor "Auftrag10" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "KU001"
    And I append rows
      | artikel | mge | fmenge | abruftyp |
      | TE002   | 150 | 50     | LAB      |
    And I save the current editor
    # Versandplanung ueber Beleg anfuegen
    Given I open an editor "Versandplanung10" from table "(ShippingPlanning):(ShippingPlanning)" with command "NEW" for record ""
    And I set field "pstermvon" to "."
    And I set field "pstermbis" to "+1"
    And I set field "beleganfuegen" to "nummer" from editor "Auftrag9"
    Then the table has 1 rows
    And I set field "beleganfuegen" to "nummer" from editor "Auftrag10"
    Then the table has 2 rows
    And I save the current editor
    # Kunde 2 sperren
    And I switch the current editor to editor "KU002" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Kundensperre"
    And I save the current editor
    # Versandplanung 10 anzeigen: In 1. Zeile ist der Kunden gesperrt
    Given I open an editor "Versandplanung10" from table "(ShippingPlanning):(ShippingPlanning)" with command "VIEW" for record from editor "Versandplanung10"
    Then field "statusico" has value "icon:stop" in row 1
    Then field "statusico" has value "icon:flag_blue" in row 2
    And I close the current editor
    # Versandplanung 10 aendern: Positionen fuer Freigabe markieren, es kann nur die 2. Position freigegeben werden
    Given I open an editor "Versandplanung10" from table "(ShippingPlanning):(ShippingPlanning)" with command "UPDATE" for record from editor "Versandplanung10"
    And I press button "malle"
    Then field "mfreig" has value "nein" in row 1
    Then field "mfreig" is not modifiable in row 1
    Then field "mfreig" has value "ja" in row 2
    Then field "mfreig" is modifiable in row 2
    And I press button "freig" to open a subeditor for "VersandLS10"
    And I close the current editor
    And I switch the current editor to editor "Versandplanung10"
    And I save the current editor
    # Von der Versandplanung 10 erstellten Lieferschein pruefen
    Given I open an editor "VP-LS10" from table "(Sales):(PackingSlip)" with command "VIEW" for record "300002"
    Then the table has 1 rows
    Then field "artikel" has value "TE002" in row 1
    Then field "mge" has value "150" in row 1
    And I close the current editor

  # -----------------------------------------------------------------------------
  Scenario: Gesperrter Lieferant/Lieferantenkontakt bei der Freigabe von Beschaffungsvorschlaegen
    # -----------------------------------------------------------------------------
    # Lieferant
    Given I open an editor "LI002" from table "(Vendor):(Vendor)" with command "NEW" for record ""
    And I set fields
      | nummer | 1LI002            |
      | such   | LI002             |
      | name   | Testlieferant 002 |
      | ans    | Testlieferant 002 |
      | nort   | Karlsruhe         |
      | plz    | 76133             |
      | waehr  | DEM               |
    And I save the current editor
    # Lieferantenkontakt
    Given I open an editor "LK002" from table "(Vendor):(VendorContact)" with command "NEW" for record ""
    And I set fields
      | nummer | 1LK002                     |
      | such   | LK002                      |
      | firma  | LI002                      |
      | name   | Testlieferantenkontakt 002 |
      | ans    | TestLieferantenkontakt 002 |
    And I save the current editor
    # Bestellvorschlaege
    Given I open an editor "BEVOR" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
    And I append rows
      | artikel | lief  | mge | mfreig |
      | E2      | LI002 | 10  | ja     |
      | E2      | LK002 | 20  | ja     |
    And I save the current editor
    # Umlagervorschlaege
    Given I open an editor "UMVOR" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
    And I append rows
      | artikel | lief  | mge | platz | mfreig |
      | E2      | LI002 | 10  | L3F1  | ja     |
      | E2      | LK002 | 20  | L3F1  | ja     |
    And I save the current editor
    # Lohnfertigungsvorschlaege
    Given I open an editor "LFVOR" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
    And I append rows
      | artikel | lief  | mge | lffert | mfreig |
      | LF001   | LI002 | 10  | V1     | ja     |
      | LF001   | LK002 | 20  | V1     | ja     |
    And I save the current editor
    # Bestellvorschlaege laden
    Given I open an editor "BEVOR" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
    And I press button "ladetab"
    # Parallel mit einem anderen Benutzer Lieferant sperren
    Given I'm logged in with password "annette"
    Given I open an editor "LI002S" from table "(Vendor):(Vendor)" with command "UPDATE" for record from editor "LI002"
    And I set field "sperrkonfigurationneu" to "Standard-Lieferantensperre"
    And I save the current editor
    # Versuch, Bestellvorschlaege freizugeben
    Given I'm logged in with password "sy"
    Given I switch the current editor to editor "BEVOR"
    Then pressing button "freig" in row 0 to open a subeditor throws the exception "4806"
    And I save the current editor
    # Bestellvorschlaege laden - Freigabefeld ist fuer gesperrten Lieferanten leer und schreibgeschuetzt.
    Given I open an editor "BEVOR" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "kl" to "LI002"
    And I press button "ladetab"
    Then field "mfreig" is not modifiable in row 1
    Then field "mfreig" has value "nein" in row 1
    And I set field "lief" to "002" in row 1
    Then field "mfreig" is modifiable in row 1
    Then field "mfreig" has value "nein" in row 1
    And I close the current editor
    # Unlagervorschlaege laden
    Given I open an editor "UMVOR" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
    And I press button "ladetab"
    # Parallel mit einem anderen Benutzer Lieferantenkontakt sperren
    Given I'm logged in with password "annette"
    Given I open an editor "LK002S" from table "(Vendor):(VendorContact)" with command "UPDATE" for record from editor "LK002"
    And I set field "sperrkonfigurationneu" to "Standard-Lieferantenkontaktsperre"
    And I save the current editor
    # Versuch, Umlagervorschlaege freizugeben oder umzulagern
    Given I'm logged in with password "sy"
    Given I switch the current editor to editor "UMVOR"
    Then pressing button "freig" in row 0 to open a subeditor throws the exception "4806"
    And I set field "beleg" to "UML001"
    And I set field "beldat" to "."
    Then pressing button "umbuchen" in row 0 to open a subeditor throws the exception "4806"
    And I close the current editor
    # Umlagervorschlaege laden - Freigabefeld ist fuer gesperrten Lieferantenkontakt leer und schreibgeschuetzt.
    Given I open an editor "UMVOR" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
    And I set field "kl" to "LK002"
    And I press button "ladetab"
    Then field "mfreig" is not modifiable in row 1
    Then field "mfreig" has value "nein" in row 1
    And I set field "lief" to "002" in row 1
    Then field "mfreig" is modifiable in row 1
    Then field "mfreig" has value "nein" in row 1
    And I close the current editor
    # Lieferant entsperren
    Given I open an editor "LI002" from table "(Vendor):(Vendor)" with command "UPDATE" for record from editor "LI002"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    # Lohnfertigungsvorschlaege laden
    Given I open an editor "LFVOR" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
    And I press button "ladetab"
    # Parallel mit einem anderen Benutzer Lieferant sperren
    Given I'm logged in with password "annette"
    Given I open an editor "LI002S" from table "(Vendor):(Vendor)" with command "UPDATE" for record from editor "LI002"
    And I set field "sperrkonfigurationneu" to "Standard-Lieferantensperre"
    And I save the current editor
    # Versuch, Lohnfertigungsvorschlaege freizugeben
    Given I'm logged in with password "sy"
    Given I switch the current editor to editor "LFVOR"
    Then pressing button "freig" in row 0 to open a subeditor throws the exception "4806"
    And I close the current editor
    # Lohnfertigungsvorschlaege laden - Freigabefeld ist fuer gesperrten Lieferanten leer und schreibgeschuetzt.
    Given I open an editor "LFVOR" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
    And I set field "kl" to "LI002"
    And I press button "ladetab"
    Then field "mfreig" is not modifiable in row 1
    Then field "mfreig" has value "nein" in row 1
    And I set field "lief" to "002" in row 1
    Then field "mfreig" is modifiable in row 1
    Then field "mfreig" has value "nein" in row 1
    And I close the current editor
    # Lieferant entsperren
    Given I open an editor "LI002" from table "(Vendor):(Vendor)" with command "UPDATE" for record from editor "LI002"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    # Lieferantenkontakt entsperren
    Given I open an editor "LK002" from table "(Vendor):(VendorContact)" with command "UPDATE" for record from editor "LK002"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    # Bestellvorschlaege - Freigabe wieder moeglich
    And I open an editor "BEVOR" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
    And I press button "ladetab"
    Then field "mfreig" is modifiable in row 1
    Then field "mfreig" is modifiable in row 2
    Then field "mfreig" has value "ja" in row 1
    Then field "mfreig" has value "ja" in row 2
    And I close the current editor
    # Umlagervorschlaege - Freigabe wieder moeglich
    And I open an editor "UMVOR" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
    And I press button "ladetab"
    Then field "mfreig" is modifiable in row 1
    Then field "mfreig" is modifiable in row 2
    Then field "mfreig" has value "ja" in row 1
    Then field "mfreig" has value "ja" in row 2
    And I close the current editor
    # Lohnfertigungsvorschlaege - Freigabe wieder moeglich
    And I open an editor "LFVOR" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
    And I press button "ladetab"
    Then field "mfreig" is modifiable in row 1
    Then field "mfreig" is modifiable in row 2
    Then field "mfreig" has value "ja" in row 1
    Then field "mfreig" has value "ja" in row 2
    And I close the current editor

  # -----------------------------------------------------------------------------
  Scenario: VSS (VK) - Kunde, -enkontakt, Spediteur sperren, neue VK-Vorgaenge, Fehlermeldung pruefen
    # -----------------------------------------------------------------------------
    # Auftrag 11_1 anlegen
    Given I open an editor "Auftrag11_1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "KU001"
    And I append rows
      | artikel | mge | fmenge | abruftyp |
      | TE002   | 150 | 50     | LAB      |
    And I save the current editor
    # Kunde 1 sperren
    Given I open an editor "KU001" from table "(Customer):(Customer)" with command "UPDATE" for record "KU001"
    And I set field "sperrkonfigurationneu" to "Standard-Kundensperre"
    And I save the current editor
    # Kundenkontakt 1 sperren
    And I switch the current editor to editor "KK001" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Kundenkontaktsperre"
    And I save the current editor
    # Lieferant 1 sperren
    Given I open an editor "LI001" from table "(Vendor):(Vendor)" with command "UPDATE" for record "LI001"
    And I set field "sperrkonfigurationneu" to "Standard-Lieferantensperre"
    And I save the current editor
    # Auftrag/Service/Versandplanung auf Sperren testen
    # Auftrag 11_2 anlegen
    Given I open an editor "Auftrag11_2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    Then setting field "kunde" to "KU001" throws the exception "1361"
    Then setting field "kl2" to "KK001" throws the exception "1361"
    Then setting field "spediteur" to "LI001" throws the exception "1361"
    And I close the current editor
    # Serviceangebot anlegen
    Given I open an editor "Serviceangebot1" from table "(Sales):(ServiceQuotation)" with command "NEW" for record ""
    Then setting field "kunde" to "KU001" throws the exception "1361"
    And I close the current editor
    # Versandplanung ueber Beleg anfuegen
    Given I open an editor "Versandplanung10" from table "(ShippingPlanning):(ShippingPlanning)" with command "NEW" for record ""
    And I set field "pstermvon" to "."
    And I set field "pstermbis" to "+1"
    And I create a new row at the end of the table
    Then setting field "vkkopf" in row 1 to "nummer" from editor "Auftrag11_1" in row 0 throws the exception "1361"
    And I close the current editor

  # # Kunde 1 Hinweissperre - TODO
  # Given I open an editor "KU001" from table "(Customer):(Customer)" with command "UPDATE" for record "KU001"
  # And I set field "sperrkonfigurationneu" to "Standard-Kundensperrhinweis"
  # And I save the current editor
  # # Auftrag anlegen
  # Given I open an editor "Auftrag11_2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
  # Der Hinweis kann aktuell nicht abgefragt werden
  # Then setting field "kunde" to "KU001" throws the exception "1361"
  # And I close the current editor
  # # Kundenkontakt 1 Hinweissperre - TODO
  # And I switch the current editor to editor "KK001" with command "UPDATE"
  # And I set field "sperrkonfigurationneu" to "Standard-Kundenkontaktsperrhinweis"
  # And I save the current editor
  # # Auftrag anlegen
  # Given I open an editor "Auftrag11_2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
  # Der Hinweis kann aktuell nicht abgefragt werden
  # Then setting field "kunde" to "KK001" throws the exception "1361"
  # And I close the current editor
  # -----------------------------------------------------------------------------
  Scenario: VSS (EK) - Lieferant, -enkontakt, Spediteur sperren, neue EK-Vorgaenge, Fehlermeldung pruefen
    # -----------------------------------------------------------------------------
    # Lieferantenkontakt 1 sperren
    Given I open an editor "LK001" from table "(Vendor):(VendorContact)" with command "UPDATE" for record "1LK001"
    And I set field "sperrkonfigurationneu" to "Standard-Lieferantenkontaktsperre"
    And I save the current editor
    # Anfrage 11 anlegen
    Given I open an editor "Anfrage11" from table "(Purchasing):(Request)" with command "NEW" for record ""
    Then setting field "spediteur" to "LI001" throws the exception "1361"
    Then setting field "lief" to "LI001" throws the exception "1361"
    Then setting field "lief" to "LK001" throws the exception "1361"
    And I close the current editor
    # Rahmenauftrag 11 anlegen
    Given I open an editor "Anfrage11" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
    Then setting field "spediteur" to "LI001" throws the exception "1361"
    Then setting field "lief" to "LI001" throws the exception "1361"
    Then setting field "lief" to "LK001" throws the exception "1361"
    And I close the current editor
    # Bestellung 11 anlegen
    Given I open an editor "Bestellung11" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
    Then setting field "spediteur" to "LI001" throws the exception "1361"
    Then setting field "lief" to "LI001" throws the exception "1361"
    Then setting field "lief" to "LK001" throws the exception "1361"
    And I close the current editor
    # Lieferung 11 anlegen
    Given I open an editor "Lieferung11" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
    Then setting field "spediteur" to "LI001" throws the exception "1361"
    Then setting field "lief" to "LI001" throws the exception "1361"
    Then setting field "lief" to "LK001" throws the exception "1361"
    And I close the current editor
    # Rechnung 11 anlegen
    Given I open an editor "Lieferung11" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    Then setting field "spediteur" to "LI001" throws the exception "1361"
    Then setting field "lief" to "LI001" throws the exception "1361"
    Then setting field "lief" to "LK001" throws the exception "1361"
    And I close the current editor

  # -----------------------------------------------------------------------------
  Scenario: Sperrkonfiguration setzen bei Kunden setzt EDI-Nachrichten aktiv
    # -----------------------------------------------------------------------------
    Given I open an editor "KundeEDINachrichten" from table "(Customer):(Customer)" with command "UPDATE" for record "KU003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    And I append rows
      | edinachraz          | erlaubt | protokoll | edlnum | umplatz |
      | Lieferabruf         | ja      | EDIFACT   | 002    | L3F2    |
      | Auftrag             | ja      | EDIFACT   | 002    | L3F2    |
      | Auftragsänderung    | nein    | EDIFACT   | 002    | L3F2    |
      | Auftragsbestätigung | ja      | EDIFACT   | 002    | L3F2    |
      | Lieferschein        | ja      | EDIFACT   | 002    | L3F2    |
    And I save the current editor
    And I switch the current editor to editor "KundeEDINachrichten"
    And I save the current editor
    # Kunde setzt Sperrkonfiguraton 1
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "KU003"
    And I set field "sperrkonfigurationneu" to "EDI-AU-AB-Nachrichtensperre"
    And I save the current editor
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "VIEW" for record "KU003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | ja      | 0           |
      | Auftrag             | nein    | 2           |
      | Auftragsänderung    | nein    | 1           |
      | Auftragsbestätigung | nein    | 2           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Kunde"
    And I close the current editor
    # Kunde setzt Sperrkonfiguraton 1 -> 2
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "KU003"
    And I set field "sperrkonfigurationneu" to "EDI-AU-LS-Nachrichtensperre"
    And I save the current editor
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "VIEW" for record "KU003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | ja      | 0           |
      | Auftrag             | nein    | 2           |
      | Auftragsänderung    | nein    | 1           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | nein    | 2           |
    And I close the current editor
    And I switch the current editor to editor "Kunde"
    And I close the current editor
    # Kunde setzt Sperrkonfiguraton 2->keine
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "KU003"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "VIEW" for record "KU003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | ja      | 0           |
      | Auftrag             | ja      | 0           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Kunde"
    And I close the current editor

  # -----------------------------------------------------------------------------
  Scenario: Sperrkonfiguration setzen bei Kundenkontakt setzt EDI-Nachrichten aktiv
    # -----------------------------------------------------------------------------
    Given I open an editor "KundenKontaktEDINachrichten" from table "(Customer):(CustomerContact)" with command "UPDATE" for record "KK003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    And I append rows
      | edinachraz          | erlaubt | protokoll | edlnum | umplatz |
      | Lieferabruf         | ja      | EDIFACT   | 002    | L3F2    |
      | Auftrag             | ja      | EDIFACT   | 002    | L3F2    |
      | Auftragsänderung    | nein    | EDIFACT   | 002    | L3F2    |
      | Auftragsbestätigung | ja      | EDIFACT   | 002    | L3F2    |
      | Lieferschein        | ja      | EDIFACT   | 002    | L3F2    |
    And I save the current editor
    And I switch the current editor to editor "KundenKontaktEDINachrichten"
    And I save the current editor
    # Kundenkontakt setzt Sperrkonfiguraton 1
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "UPDATE" for record "KK003"
    And I set field "sperrkonfigurationneu" to "EDI-AU-AB-Nachrichtensperre-Kont"
    And I save the current editor
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "VIEW" for record "KK003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | nein    | 2           |
      | Auftrag             | nein    | 2           |
      | Auftragsänderung    | nein    | 1           |
      | Auftragsbestätigung | nein    | 2           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Kundenkontakt"
    And I close the current editor
    # Kundenkontakt setzt Sperrkonfiguraton 1 -> 2
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "UPDATE" for record "KK003"
    And I set field "sperrkonfigurationneu" to "EDI-AU-LS-Nachrichtensperre-Kont"
    And I save the current editor
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "VIEW" for record "KK003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | ja      | 0           |
      | Auftrag             | nein    | 2           |
      | Auftragsänderung    | nein    | 1           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | nein    | 2           |
    And I close the current editor
    And I switch the current editor to editor "Kundenkontakt"
    And I close the current editor
    # Kundenkontakt setzt Sperrkonfiguraton 2->keine
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "UPDATE" for record "KK003"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "VIEW" for record "KK003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | ja      | 0           |
      | Auftrag             | ja      | 0           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Kundenkontakt"
    And I close the current editor

  # -----------------------------------------------------------------------------
  Scenario: Sperrkonfiguration setzen bei Lieferanten setzt EDI-Nachrichten aktiv
    # -----------------------------------------------------------------------------
    Given I open an editor "LieferantEDINachrichten" from table "(Vendor):(Vendor)" with command "UPDATE" for record "LI003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    And I append rows
      | edinachraz          | erlaubt | protokoll |
      | Lieferabruf         | ja      | EDIFACT   |
      | Auftrag             | ja      | EDIFACT   |
      | Auftragsänderung    | nein    | EDIFACT   |
      | Auftragsbestätigung | ja      | EDIFACT   |
      | Lieferschein        | ja      | EDIFACT   |
    And I save the current editor
    And I switch the current editor to editor "LieferantEDINachrichten"
    And I save the current editor
    # Lieferant setzt Sperrkonfiguraton 1
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record "LI003"
    And I set field "sperrkonfigurationneu" to "EDI-LA-BE-Nachrichtensperre"
    And I save the current editor
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "VIEW" for record "LI003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | nein    | 2           |
      | Auftrag             | nein    | 2           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor
    # Lieferant setzt Sperrkonfiguraton 1 -> 2
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record "LI003"
    And I set field "sperrkonfigurationneu" to "EDI-LA-Nachrichtensperre"
    And I save the current editor
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "VIEW" for record "LI003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | nein    | 2           |
      | Auftrag             | ja      | 0           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor
    # Lieferant setzt Sperrkonfiguraton 2->keine
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record "LI003"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "VIEW" for record "LI003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | ja      | 0           |
      | Auftrag             | ja      | 0           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor

  # -----------------------------------------------------------------------------
  Scenario: Sperrkonfiguration setzen bei Lieferantenkontakten setzt EDI-Nachrichten aktiv
    # -----------------------------------------------------------------------------
    Given I open an editor "LieferantenkontaktEDINachrichten" from table "(Vendor):(VendorContact)" with command "UPDATE" for record "LK003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    And I append rows
      | edinachraz          | erlaubt | protokoll |
      | Lieferabruf         | ja      | EDIFACT   |
      | Auftrag             | ja      | EDIFACT   |
      | Auftragsänderung    | nein    | EDIFACT   |
      | Auftragsbestätigung | ja      | EDIFACT   |
      | Lieferschein        | ja      | EDIFACT   |
    And I save the current editor
    And I switch the current editor to editor "LieferantenkontaktEDINachrichten"
    And I save the current editor
    # Lieferant setzt Sperrkonfiguraton 1
    Given I open an editor "Lieferant" from table "(Vendor):(VendorContact)" with command "UPDATE" for record "LK003"
    And I set field "sperrkonfigurationneu" to "EDI-LA-BE-Nachrichtensperre-Kont"
    And I save the current editor
    Given I open an editor "Lieferant" from table "(Vendor):(VendorContact)" with command "VIEW" for record "LK003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | nein    | 2           |
      | Auftrag             | nein    | 2           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor
    # Lieferant setzt Sperrkonfiguraton 1 -> 2
    Given I open an editor "Lieferant" from table "(Vendor):(VendorContact)" with command "UPDATE" for record "LK003"
    And I set field "sperrkonfigurationneu" to "EDI-LA-Nachrichtensperre-Kont"
    And I save the current editor
    Given I open an editor "Lieferant" from table "(Vendor):(VendorContact)" with command "VIEW" for record "LK003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | nein    | 2           |
      | Auftrag             | ja      | 0           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor
    # Lieferant setzt Sperrkonfiguraton 2->keine
    Given I open an editor "Lieferant" from table "(Vendor):(VendorContact)" with command "UPDATE" for record "LK003"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    Given I open an editor "Lieferant" from table "(Vendor):(VendorContact)" with command "VIEW" for record "LK003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | ja      | 0           |
      | Auftrag             | ja      | 0           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor

  # -----------------------------------------------------------------------------
  Scenario: Lieferantensperre in Ausschreibung
    # -----------------------------------------------------------------------------
    Given I open an editor "E1C" from table "(Part):(Product)" with command "COPY" for record "E1"
    And I set fields
      | such | E1C |
    And I save the current editor
    # Lieferant LGESP anlegen
    Given I open an editor "LGESP" from table "(Vendor):(Vendor)" with command "COPY" for record "1"
    And I set field "such" to "LGESP"
    And I save the current editor
    # BV anlegen
    Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | mge | verw    | lief  |
      | !E1C^id | 200 | AUS06BV | 1     |
      | !E1C^id | 100 | AUS06BV | LGESP |
    And I save the current editor
    # Ausschreibung aus BV
    Given I open an editor "BV" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "!E1C^id"
    And I press button "ladetab"
    And I set field "anfragen" to "ja" in row 1
    And I set field "anfragen" to "ja" in row 2
    And I press button "manfragen" to open a subeditor for "AUS07"
    # In der Ausschreibung
    Then field "bsart" has value "Fremdbeschaffung"
    And I set field "such" to "AUS07"
    And I set field "tlief" to "1" in row 2
    And I save the current subeditor to switch back to the parent editor
    And I close the current editor
    # Lieferant LGESP sperren
    Given I open an editor "LGESP" from table "(Vendor):(Vendor)" with command "UPDATE" for record from editor "LGESP"
    And I set field "sperrkonfigurationneu" to "Standard-Lieferantensperre"
    And I save the current editor
    Given I open an editor "AUS07" from table "(BiddingProcess):(BiddingProcess)" with command "UPDATE" for record "AUS07"
    And I press button "elemaufzu" in row 2
    And I press button "elemaufzu" in row 1
    # Kein Fehler, obwohl der zweite BV der zweiten Position einem gesperrten Lieferanten gehoert
    And I save the current editor
    # BV Zuordnen
    Given I open an editor "AUS07" from table "(BiddingProcess):(BiddingProcess)" with command "UPDATE" for record "AUS07"
    And I press button "elemaufzu" in row 2
    And I press button "elemaufzu" in row 1
    And I set field "bvzuord" to "ja" in row 6
    And I set field "bvzuord" to "ja" in row 2
    And I save the current editor
    # Ausschreibungstabelle ueberpruefen
    Given I open an editor "AUS07" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record "AUS07"
    And I press button "elemaufzu" in row 2
    And I press button "elemaufzu" in row 1
    Then table has values
      | artikel | tlief | mge | bvzuord | stufeausschr |
      | E1C     | 1     | 200 | nein    | 0            |
      | E1C     | 1     | 200 | ja      | 1            |
      | E1C     | 1     | 100 | nein    | 1            |
      | E1C     | 1     | 100 | nein    | 0            |
      | E1C     | 1     | 200 | nein    | 1            |
      | E1C     | 1     | 100 | ja      | 1            |
    And I close the current editor
