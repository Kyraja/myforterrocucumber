# ******************************************************************************************************
# Name           : zugferd_pruef_fehler.feature
# Autor          : sb
# Verantwortlich : foe
# Kontrolle      : cl
# Funktion       : Cucumber Tests zum Prüfen der Fehlermeldungen für ZUGFERD
#
# *****************************************************************************************************
#
@persistent
Feature: Testdaten der Fehlermeldungen aus ZUGFRD.FUELL (Extended Format)

  Background:
    Given I set the fake date to "02.01.1999"
    Given I enable the flag 39

    # ----------------------------------------------------------------------------------------------
  Scenario Outline: Drei Jahresabschluesse durchfuehren bis 1998
    # ----------------------------------------------------------------------------------------------
    # Erst ab 1998 ist Buchungswaehrung und Erfassungswaehrung EUR -> ZugFerd funktioniert NICHT mit DEM!
    And I set the fake date to "<datum>"
    Given I open an editor "abschl<num>" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
    And I set field "nummer" to "200zz<num>"
    And I set field "such" to "ABSCHL<num>"
    And I set field "such" to "ABSCHL<num>"
    And I set field "jastart" to "ja"
    And I respond with answer "ja" to the dialog with id "10747"
    And I respond with answer "ja" to the dialog with id "7626"
    And I save the current editor
    And I close the current editor

    Examples:
      | num | datum      |
      | 1   | 02.01.1996 |
      | 2   | 02.01.1998 |
      | 3   | 02.01.1999 |

    # ----------------------------------------------------------------------------------------------
  Scenario: GJ-Tabelle pruefen
    # ----------------------------------------------------------------------------------------------
    # Aktuelles Jahr muss 1998 sein (EUR)
    Given I open an editor "gjtab" from table "(Company):(FinancialDates)" with command "VIEW" for record "2"
    Then table has values
      | gjahr | gjkenn                  |
      | 94    | vergangen               |
      | 95    | vergangen               |
      | 96    | vergangen               |
      | 97    | vorläufig abgeschlossen |
      | 98    | aktuell                 |
      | 99    | neu                     |
    And I close the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: STAMMDATEN - In der Konfiguration muss zugferd aktiv sein
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
    And I set field "zugferd" to "ja"
    And I set field "datevss" to "nein"
    # And I set field "habel" to "ja"
    And I save the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: STAMMDATEN - Betriebsdaten pflegen
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "bdaten" from table "(Company):(CompanyData)" with command "UPDATE" for record "1"
    And I set fields
      | such     | Zugferd-Ex         |
      | namebspr | ZUGFeRD Export     |
      | knam1    | ZUGFeRD Export     |
      | ans      | ZUGFeRD Export AG  |
      | str      | ZUGFeRD Strasse 20 |
      | plz      | 54321              |
      | nort     | ZUGFeRDstadt       |
      | region   | Baden-Württemberg  |
      | staat    | Deutschland        |
      | tele     | 070010101          |
      | iban     | DE5500000000000025 |
      | gln      | 999888777          |
    And I save the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: USTID in Land eintragen
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "land" from table "(Regions):(RegionCountryEconomicArea)" with command "UPDATE" for record "deutschland"
    And I set field "ustid" to "DE987654321"
    And I set field "steunr" to "987654321"
    And I save the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: STAMMDATEN - Mitarbeiter ohne Telefonnummer anlegen
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "zugferd"
    And I set fields
      | such     | Zugferd             |
      | namebspr | ZUGFeRD Mitarbeiter |
      | ans      | ZUGFeRD GmbH        |
      | str      | ZUGFeRD Strasse 12  |
      | plz      | 55555               |
      | nort     | ZUGFeRDstadt        |
      | region   | Bayern              |
      | tele     |                     |
    And I save the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: STAMMDATEN - Kunde ohne Betreuer anlegen
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "kunde1" from table "(Customer):(Customer)" with command "STORE" for record "Zugferdd"
    And I set fields
      | nummer    | 22244              |
      | such      | Zugferdd           |
      | namebspr  | ZUGFeRD Drittland  |
      | ans       |                    |
      | str       | ZUGFeRD Strasse 15 |
      | plz       | 12345              |
      | nort      | ZUGFeRDdorf        |
      | staat     | USA                |
      | ans2      | ZUGFeRD Ausland AG |
      | str2      | ZUGFeRD Strasse 15 |
      | plz2      |                    |
      | nort2     | ZUGFeRDdorf        |
      | staat2    | USA                |
      # | tele      | 070010100            |
      | betreuer  |                    |
      | erechmail |                    |
      | leitwegid |                    |
      # | lbed      | exw                  |
      | zbed      | 200                |
      | zaform    | Überweisung        |
    # | frbez     | 11122                |
    # | gln       | 666555444            |
    And I save the current editor
    # EDI-Nachricht ZUGFeRD eintragen
    Given I open an editor "edikunde" from table "(Customer):(Customer)" with command "UPDATE" for record "Zugferdd"
    And I press button "edinfo" to open a subeditor for "edinachricht"
    And I create a new row at the end of the table
    And I set field "edinachraz" to "ZUGFeRD-Rechnung Export" in row 1
    # And I set field "ieabmodell" to "4180" in row 1
    And I set field "erlaubt" to "ja" in row 1
    And I save the current editor
    And I switch the current editor to editor "edikunde"
    And I save the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: STAMMDATEN - Kunde anlegen
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "kunde2" from table "(Customer):(Customer)" with command "STORE" for record "Zugferdi"
    And I set fields
      | nummer    | 22233              |
      | such      | Zugferdi           |
      | namebspr  | ZUGFeRD Import     |
      | ans       | ZUGFeRD Import AG  |
      | str       | ZUGFeRD Strasse 15 |
      | plz       | 12345              |
      | nort      | ZUGFeRDdorf        |
      | region    | Baden-Württemberg  |
      | tele      | 070010100          |
      | betreuer  | zugferd            |
      | erechmail | info@abas.de       |
      | lbed      | exw                |
      | zbed      | 200                |
      | zaform    | Überweisung        |
      | frbez     | 11122              |
      | gln       | 666555444          |
    And I save the current editor
    # EDI-Nachricht ZUGFeRD eintragen
    Given I open an editor "edikunde" from table "(Customer):(Customer)" with command "UPDATE" for record "Zugferdi"
    And I press button "edinfo" to open a subeditor for "edinachricht"
    And I create a new row at the end of the table
    And I set field "edinachraz" to "ZUGFeRD-Rechnung Export" in row 1
    And I set field "ieabmodell" to "4180" in row 1
    And I set field "erlaubt" to "ja" in row 1
    And I save the current editor
    And I switch the current editor to editor "edikunde"
    And I save the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: STAMMDATEN - Dienstleistung anlegen
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "dl" from table "(Part):(Service)" with command "STORE" for record "dl"
    And I set fields
      | such     | dl             |
      | namebspr | Dienstleistung |
      | vpr      | 50             |
      | epr      | 50             |
      | gtin     | GTIN-DL        |
    And I save the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: STAMMDATEN - Einheit in Zusatzpositon vom Typ AU/BE eintragen
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "zupos" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "a."
    And I set fields
      | le      | Stück     |
      | vhe     | Stück     |
      | vpe     | Stück     |
      | vpr     | 10        |
      | zfzutyp | Sonstiges |
    And I save the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: STAMMDATEN - Sammellayout 12762 aktivieren
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "layout" from table "(PrintParameter):(CollectiveLayout)" with command "UPDATE" for record "12762"
    And I set field "such" to "XMLDATAGENS"
    And I set field "aktiv" to "ja"
    And I save the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: STAMMDATEN - Zuschlags- und Abschlagstyp in Textposition eintragen
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "rabatt" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "PR."
    And I set fields
      | zfzutyp | Sonstiges |
      | zfabtyp | Rabatt    |
    And I save the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: STAMMDATEN - GTIN in Artikel eintragen
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "art1" from table "(Part):(Product)" with command "UPDATE" for record "E2"
    And I set field "gtin" to "GTIN-E2"
    And I save the current editor
    Given I open an editor "art2" from table "(Part):(Product)" with command "UPDATE" for record "E3"
    And I set field "gtin" to "GTIN-E3"
    And I save the current editor
    Given I open an editor "art3" from table "(Part):(Product)" with command "UPDATE" for record "V1"
    And I set field "gtin" to "GTIN-V1"
    And I save the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: STAMMDATEN - Steuerregel 5004 anpassen
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "steuerregel" from table "(TaxCode):(TaxRuleHead)" with command "UPDATE" for record "5004"
    And I set fields
      | zftaxcode  | Steuerbefreit               |
      | zfvatexemp | Nicht umsatzsteuerpflichtig |
    And I save the current editor
    # Im Null-Steuerschluessel den Kenner Steuer in Rechnung nicht ausweisen aktivieren
    Given I open an editor "nullstschl" from table "(TaxCode):(TaxCodeHead)" with command "UPDATE" for record "0"
    And I set field "kstausw" to "nein"
    And I save the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: STAMMDATEN - Neutrale Position anlegen
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "neutral" from table "(Part):(SupplementaryItem)" with command "STORE" for record "neutral"
    And I set fields
      | such     | neutral           |
      | namebspr | Neutrale Position |
      | zptyp    | neutrale Position |
    And I save the current editor
    # ----------------------------------------------------------------------------------------------
    # Scenario: STAMMDATEN - Abbildungsmodell ohne Format
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "abbildmodel" from table "(EDIConfiguration):(MappingModel)" with command "COPY" for record "AEXRECHN"
    And I set fields
      | nummer  | 100000  |
      | such    | AEXLEER |
      | request |         |
    And I save the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: 1. Fall Abbildungsmodell in EDI-Nachricht des Kunden ist leer
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "rech1" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde1"
    And I set field "betreff" to "Fall 1: Abbildungsmodell fehlt"
    And I append rows
      | pnum | artex | mge | preis | proz |
      | 1    | v1    | 15  | 10,5  | -10  |
      | 2    | a.    | 10  | 10    | 10   |
      | 3    | dl    | 5   | 15    | -5   |
    # Fehlermeldung 3821
    And saving the current editor throws the exception "ZUGFeRD: Kein Abbildungsmodell vorhanden. Bitte eintragen."
    And I close the current editor
    # Abbildungsmodell ZUGFeRD eintragen
    Given I open an editor "edikunde" from table "(Customer):(Customer)" with command "UPDATE" for record "Zugferdd"
    And I press button "edinfo" to open a subeditor for "edinachricht"
    And I set field "ieabmodell" to "4180" in row 1
    And I save the current editor
    And I switch the current editor to editor "edikunde"
    And I save the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: 1b. Fall Abbildungsmodell in EDI-Nachricht des Kunden ist falsch
    # ----------------------------------------------------------------------------------------------
    # Abbildungsmodell ohne Format eintragen
    Given I open an editor "edikunde" from table "(Customer):(Customer)" with command "UPDATE" for record "Zugferdd"
    And I press button "edinfo" to open a subeditor for "edinachricht"
    And I set field "ieabmodell" to "100000" in row 1
    And I save the current editor
    And I switch the current editor to editor "edikunde"
    And I save the current editor
    Given I open an editor "rech1b" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde1"
    And I set field "betreff" to "Fall 1: Abbildungsmodell fehlt"
    And I append rows
      | pnum | artex | mge | preis |
      | 1    | v1    | 15  | 10,5  |
    # Fehlermeldung 3822: ZUGFeRD: Das Abbildungsmodell ist leer. Bitte gültigen Nachrichtentyp eintragen.
    And saving the current editor throws the exception "ZUGFeRD: Das Abbildungsmodell ist leer. Bitte gültigen Nachrichtentyp eintragen."
    And I close the current editor
    Given I open an editor "abbildmodel" from table "(EDIConfiguration):(MappingModel)" with command "STORE" for record "100000"
    And I set field "request" to "xrechnung-cii"
    And I save the current editor
    # Abbildungsmodell ZUGFeRD eintragen
    Given I open an editor "edikunde" from table "(Customer):(Customer)" with command "UPDATE" for record "Zugferdd"
    And I press button "edinfo" to open a subeditor for "edinachricht"
    And I set field "ieabmodell" to "4180" in row 1
    And I save the current editor
    And I switch the current editor to editor "edikunde"
    And I save the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: Fall 1c IBAN fehlt
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "konfiguration" from table "(Company):(CompanyData)" with command "UPDATE" for record "1"
    And I set field "iban" to ""
    And I save the current editor
    Given I open an editor "rech1c" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde1"
    And I set field "betreff" to "Fall 1c: IBAN fehlt"
    And I append rows
      | pnum | artex | mge | preis | proz |
      | 1    | v1    | 15  | 10,5  | -10  |
      | 2    | a.    | 10  | 10    | 10   |
      | 3    | dl    | 5   | 15    | -5   |
    # Fehlermeldung 3829
    And saving the current editor throws the exception "ZUGFeRD: Bitte IBAN in den Betriebsdaten füllen."
    And I close the current editor
    Given I open an editor "konfiguration" from table "(Company):(CompanyData)" with command "UPDATE" for record "1"
    And I set field "iban" to "DE5500000000000025"
    And I save the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: 2. Fall: Im Kunde ist kein Betreuer eingetragen
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "rech2" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde1"
    And I set field "betreff" to "Fall 2: Betreuer fehlt"
    And I append rows
      | pnum | artex | mge | preis | proz |
      | 1    | v1    | 15  | 10,5  | -10  |
      | 2    | a.    | 10  | 10    | 10   |
      | 3    | dl    | 5   | 15    | -5   |
    # Fehlermeldung 3810
    And saving the current editor throws the exception "ZUGFeRD: Der Betreuer fehlt. Bitte eintragen."
    And I close the current editor
    # Betreuer in Kunde eintragen
    Given I open an editor "kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "Zugferdd"
    And I set fields
      | betreuer | zugferd |
    And I save the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: 3. Fall: Im Betreuer ist keine Telefonnummer eingetragen
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "rech3" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde1"
    And I set field "betreff" to "Fall 3: Telefonnummer des Betreuers fehlt"
    And I append rows
      | pnum | artex | mge | preis | proz |
      | 1    | v1    | 15  | 10,5  | -10  |
      | 2    | a.    | 10  | 10    | 10   |
      | 3    | dl    | 5   | 15    | -5   |
    # Fehlermeldung 3811
    And saving the current editor throws the exception "ZUGFeRD: Die Telefonnummer des Betreuers fehlt. Bitte eintragen."
    And I close the current editor
    # Telefonnummer in Betreuer eintragen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "UPDATE" for record "zugferd"
    And I set fields
      | tele | 080010100 |
    And I save the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: 4. Fall: Im Rechnungempfaenger fehlt die E-Mail
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "rech4" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde1"
    And I set field "betreff" to "Fall 4: Email im Rechnungsempfaenger fehlt"
    And I append rows
      | pnum | artex | mge | preis | proz |
      | 1    | v1    | 15  | 10,5  | -10  |
      | 2    | a.    | 10  | 10    | 10   |
      | 3    | dl    | 5   | 15    | -5   |
    # Fehlermeldung 3825
    And saving the current editor throws the exception "ZUGFeRD: Im Rechnungsempfänger ist das Feld E-Mail Rechnungsempfänger nicht gefüllt. Bitte eintragen."
    And I close the current editor
    # Email in Rechnungsempfaenger eintragen
    Given I open an editor "kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "Zugferdd"
    And I set fields
      | erechmail | info@abas.de |
    And I save the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: 4b. Fall: Im Rechnungempfaenger fehlt die Anschrift
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "rech4" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde1"
    And I set field "betreff" to "Fall 4: Anschrift im Rechnungsempfaenger fehlt"
    And I append rows
      | pnum | artex | mge | preis | proz |
      | 1    | v1    | 15  | 10,5  | -10  |
      | 2    | a.    | 10  | 10    | 10   |
      | 3    | dl    | 5   | 15    | -5   |
    # Fehlermeldung 3826
    And saving the current editor throws the exception "ZUGFeRD: Bitte den Namen des Rechnungsempfängers eintragen."
    And I close the current editor
    # Email in Rechnungsempfaenger eintragen
    Given I open an editor "kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "Zugferdd"
    And I set fields
      | ans | ZUGFeRD Drittland AG |
    And I save the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: Fall 4c: Leitweg-ID/Versandadresse fehlt bei X-Rechnung
    # ----------------------------------------------------------------------------------------------
    # Abbildungsmodell XRECHNUNG eintragen
    Given I open an editor "edikunde" from table "(Customer):(Customer)" with command "UPDATE" for record "Zugferdd"
    And I press button "edinfo" to open a subeditor for "edinachricht"
    And I set field "ieabmodell" to "4170" in row 1
    And I save the current editor
    And I switch the current editor to editor "edikunde"
    And I save the current editor
    Given I open an editor "rech4c" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde1"
    And I set field "betreff" to "Fall 4c: Leitweg-ID/Versandadresse fehlt bei X-Rechnung"
    And I append rows
      | pnum | artex | mge | preis |
      | 1    | v1    | 15  | 10,5  |
    # Fehlermeldung 38??:
    And saving the current editor throws the exception "ZUGFeRD: Bitte die Versandadresse füllen."
    And I set field "plz2" to "12345"
    # Fehlermeldung 38??:
    And saving the current editor throws the exception "ZUGFeRD: Bitte die Leitweg-ID füllen."
    And I set field "leitwegid" to "12344"
    And I save the current editor
    # Abbildungsmodell ZUGFeRD eintragen
    Given I open an editor "edikunde" from table "(Customer):(Customer)" with command "UPDATE" for record "Zugferdd"
    And I press button "edinfo" to open a subeditor for "edinachricht"
    And I set field "ieabmodell" to "4180" in row 1
    And I save the current editor
    And I switch the current editor to editor "edikunde"
    And I save the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: 5. Fall: Zahlungsart fehlt im Kunden
    # ---------------------------------------------------------------------------------------------
    # Zahlungsart im Kunde leeren
    Given I open an editor "kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "Zugferdd"
    And I set field "zaform" to ""
    And I save the current editor
    Given I open an editor "rech5" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde1"
    And I set field "betreff" to "Fall 5: Zahlungsart in Kunde fehlt"
    And I append rows
      | pnum | artex | mge | preis | proz |
      | 1    | v1    | 15  | 10,5  | -10  |
      | 2    | a.    | 10  | 10    | 10   |
      | 3    | dl    | 5   | 15    | -5   |
    # Fehlermeldung 3827
    And saving the current editor throws the exception "ZUGFeRD: Bitte Zahlungsart im Reiter ZUGFeRD füllen."
    And I close the current editor
    # Zahlungsart im Kunde hinterlegen
    Given I open an editor "kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "Zugferdd"
    And I set fields
      | zaform | Überweisung |
    And I save the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: 6. Fall: Rechnung fuer Kunde aus Drittland ohne USTID anlegen
    # ----------------------------------------------------------------------------------------------
    # Im Null-Steuerschluessel den Kenner Steuer in Rechnung nicht ausweisen aktivieren
    Given I open an editor "nullstschl" from table "(TaxCode):(TaxCodeHead)" with command "UPDATE" for record "0"
    And I set field "kstausw" to "ja"
    And I save the current editor
    # Rechnung anlegen
    Given I open an editor "rech1" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde1"
    And I set field "betreff" to "Fall 1: Rechnung für Kunde aus Drittland"
    And I append rows
      | pnum | artex | mge | preis | proz |
      | 1    | v1    | 15  | 10,5  | -10  |
      | 2    | a.    | 10  | 10    | 10   |
      | 3    | dl    | 5   | 15    | -5   |
    # Fehlermeldung 38??: ZUGFeRD: Bitte im Null-Steuerschlüssel 0 das Kennzeichen "Steuer in Rechnung nicht ausweisen" deaktivieren.
    And saving the current editor throws the exception "2672"
    And I close the current editor

    # Im Null-Steuerschluessel den obigen Kenner deakivieren
    Given I open an editor "nullstschl" from table "(TaxCode):(TaxCodeHead)" with command "UPDATE" for record "0"
    And I set field "kstausw" to "nein"
    And I save the current editor
    # Rechnung nochmal anlegen
    Given I open an editor "rech2" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde1"
    And I set field "betreff" to "Fall 1: Rechnung für Kunde aus Drittland"
    And I append rows
      | pnum | artex | mge | preis | proz |
      | 1    | v1    | 15  | 10,5  | -10  |
      | 2    | a.    | 10  | 10    | 10   |
      | 3    | dl    | 5   | 15    | -5   |
    And I save the current editor
    # ZUGFeRD-Rechnung ueber EVVORGANG drucken fuer Kunde
    Given I open the infosystem "EVVORGANG"
    And I set field "vorgang" to id from editor "rech2"
    And I press button "bstart"
    And I print layout "XMLDATAGENS" with printer "BILDSCHIRM" and filename "dfue/empfangen/factur-x_1.xml" with quantity "1" and copies "1"
    And I close the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: Fall 6 Zahlungsverteiler darf nicht gefüllt sein
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "zv" from table "(PaymentMasterFiles):(PaymentDistributor)" with command "NEW" for record ""
    And I set field "such" to "zv"
    And I append rows
      | proz | zbed |
      | 10   | 200  |
      | 90   | 201  |
    And I save the current editor
    Given I open an editor "rech6" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde"
    And I set field "betreff" to "Fall 6: Zahlungsverteiler darf nicht gefüllt sein"
    And I set field "zbedvert" to id from editor "zv"
    And I append rows
      | pnum | artex | mge | preis | proz |
      | 1    | v1    | 15  | 10,5  | -10  |
      | 2    | a.    | 10  | 10    | 10   |
      | 3    | dl    | 5   | 15    | -5   |
    # Fehlermeldung 3812
    And saving the current editor throws the exception "ZUGFeRD: Der Zahlungsverteiler darf nicht gefüllt sein. Bitte entfernen."
    And I close the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: Fall 7 Bruttopreise werden nicht unterstuetzt
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "rech7" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde"
    And I set field "betreff" to "Fall 7: Bruttopreise werden nicht unterstützt"
    And I set field "brutto" to "ja"
    And I append rows
      | pnum | artex | mge | preis | proz |
      | 1    | v1    | 15  | 10,5  | -10  |
      | 2    | a.    | 10  | 10    | 10   |
      | 3    | dl    | 5   | 15    | -5   |
    # Fehlermeldung 3824
    And saving the current editor throws the exception "ZUGFeRD: Es werden keine Bruttopreise unterstützt."
    And I close the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: Fall 1A Rechnung fuer Kunde aus Drittland ohne USTID anlegen
    # ----------------------------------------------------------------------------------------------
    # Rechnung fuer Inlandskunde ohne USTID anlegen
    Given I open an editor "rech3" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde2"
    And I set field "betreff" to "Fall1: Rechnung für Inlandskunde"
    And I append rows
      | pnum | artex | mge | preis | proz |
      | 1    | v1    | 15  | 10,5  | -10  |
      | 2    | a.    | 10  | 10    | 10   |
      | 3    | dl    | 5   | 15    | -5   |
    # Fehlermeldung 3823:
    And saving the current editor throws the exception "ZUGFeRD: Im Rechnungskunde 22233 ist das Feld USTID nicht gefüllt. Bitte eintragen."
    And I close the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: Fall 2: Rechnung fuer Inlandskunden ohne USTID mit Vorgangssteuerregel 5003 anlegen
    # ----------------------------------------------------------------------------------------------
    # Rechnung anlegen
    Given I open an editor "rech4" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde2"
    And I set field "betreff" to "Fall 2: Rechnung mit Vorgangssteuerregel 5003"
    And I set field "vrgstrgl" to "5003"
    And I append rows
      | pnum | artex | mge | preis | proz |
      | 1    | v1    | 15  | 10,5  | -10  |
      | 2    | a.    | 10  | 10    | 10   |
      | 3    | dl    | 5   | 15    | -5   |
    And I save the current editor
    # ZUGFeRD-Rechnung ueber EVVORGANG drucken fuer Kunde
    Given I open the infosystem "EVVORGANG"
    And I set field "vorgang" to id from editor "rech4"
    And I press button "bstart"
    And I print layout "XMLDATAGENS" with printer "BILDSCHIRM" and filename "dfue/empfangen/factur-x_2.xml" with quantity "1" and copies "1"
    And I close the current editor
    # Im Null-Steuerschluessel den obigen Kenner aktivieren
    Given I open an editor "nullstschl" from table "(TaxCode):(TaxCodeHead)" with command "UPDATE" for record "0"
    And I set field "kstausw" to "ja"
    And I save the current editor
    # Rechnung nochmal anlegen
    Given I open an editor "rech5" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde2"
    And I set field "betreff" to "Fall 2: Rechnung mit Vorgangssteuerregel 5003"
    And I set field "vrgstrgl" to "5003"
    And I append rows
      | pnum | artex | mge | preis | proz |
      | 1    | v1    | 15  | 10,5  | -10  |
      | 2    | a.    | 10  | 10    | 10   |
      | 3    | dl    | 5   | 15    | -5   |
    # Fehlermeldung 38??: ZUGFeRD: Im Null-Steuerschlüssel %s darf das Kennzeichen "Steuer in Rechnung nicht ausweisen" nicht gesetzt sein. Bitte deaktivieren.
    And saving the current editor throws the exception "2672"
    And I close the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: Fall 3B Rechnung fuer Inlandsk:unden ohne USTID mit Vorgangssteuerregel 5000 anlegen
    # ----------------------------------------------------------------------------------------------
    # Rechnung anlegen
    # Im Null-Steuerschluessel den obigen Kenner deaktivieren
    Given I open an editor "nullstschl" from table "(TaxCode):(TaxCodeHead)" with command "UPDATE" for record "0"
    And I set field "kstausw" to "ja"
    And I save the current editor
    Given I open an editor "rech6" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde2"
    And I set field "betreff" to "Fall 3: Rechnung mit Vorgangssteuerregel 5000"
    And I append rows
      | pnum | artex | mge | preis | proz | strgl |
      | 1    | v1    | 15  | 10,5  | -10  | 5006  |
      | 2    | a.    | 10  | 10    | 10   | 5006  |
      | 3    | dl    | 5   | 15    | -5   | 5006  |

    # Fehlermeldung 38??: ZUGFeRD: Im Null-Steuerschlüssel %s darf das Kennzeichen "Steuer in Rechnung nicht ausweisen" nicht gesetzt sein. Bitte deaktivieren.
    And saving the current editor throws the exception "2672"
    And I close the current editor
    # Im Null-Steuerschluessel den obigen Kenner deaktivieren
    Given I open an editor "nullstschl" from table "(TaxCode):(TaxCodeHead)" with command "UPDATE" for record "0"
    And I set field "kstausw" to "nein"
    And I save the current editor
    # Rechnung anlegen
    Given I open an editor "rech7" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde2"
    And I set field "betreff" to "Fall 3: Rechnung mit Vorgangssteuerregel 5000"
    And I append rows
      | pnum | artex | mge | preis | proz | strgl |
      | 1    | v1    | 15  | 10,5  | -10  | 5006  |
      | 2    | a.    | 10  | 10    | 10   | 5006  |
      | 3    | dl    | 5   | 15    | -5   | 5006  |

    And I save the current editor
    # ZUGFeRD-Rechnung ueber EVVORGANG drucken fuer Kunde
    Given I open the infosystem "EVVORGANG"
    And I set field "vorgang" to id from editor "rech7"
    And I press button "bstart"
    And I print layout "XMLDATAGENS" with printer "BILDSCHIRM" and filename "dfue/empfangen/factur-x_3.xml" with quantity "1" and copies "1"
    And I close the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: Fall 8 Positionsnummer fehlt
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "rech8" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde"
    And I set field "betreff" to "Fall 7: Positionsnummer muss vergeben werden"
    And I append rows
      | artex | mge | preis | proz |
      | v1    | 15  | 10,5  | -10  |
    # Fehlermeldung 3813: ZUGFeRD: Positionsnummern für Zeilen vom Typ "AU/BE-Position,BV" müssen vergeben sein. Bitte vervollständigen.
    And saving the current editor throws the exception "2672"
    And I close the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: Fall 9 Nur Abschlaege erlaubt bei Abblidungsmodell 4150
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "ediabschlag" from table "(Customer):(Customer)" with command "UPDATE" for record "Zugferdd"
    And I press button "edinfo" to open a subeditor for "edinachricht"
    And I create a new row at the end of the table
    And I set field "ieabmodell" to "4150" in row 1
    And I save the current editor
    And I switch the current editor to editor "ediabschlag"
    And I save the current editor
    Given I open an editor "rech9" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde"
    And I set field "betreff" to "Fall 9: Nur Abschläge erlaubt im Comfort-Format"
    And I append rows
      | pnum | artex | mge | preis | proz |
      | 1    | v1    | 15  | 10,5  | 10   |
      | 2    | a.    | 10  | 10    | 10   |
      | 3    | dl    | 5   | 15    | 5    |
    # Fehlermeldung 3814
    And saving the current editor throws the exception "ZUGFeRD: Es sind nur Abschläge erlaubt. Bitte Wert kleiner 0 eintragen. Zuschläge sind nur im Extended-Format zulässig."
    And I close the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: Fall 10 Sammelrechnung im Comfort-Format nicht erlaubt
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "lief1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde"
    And I set field "betreff" to "Fall 9: Sammelrechnung nicht erlaubt im Comfort-Format"
    And I set field "ueb" to "ja"
    And I append rows
      | pnum | artex | mge | preis | proz |
      | 1    | v1    | 15  | 10,5  | -10  |
    And I save the current editor
    Given I open an editor "lief2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde"
    And I set field "betreff" to "Fall 9: Sammelrechnung nicht erlaubt im Comfort-Format"
    And I set field "ueb" to "ja"
    And I append rows
      | pnum | artex | mge | preis | proz |
      | 1    | v2    | 15  | 10,5  | -10  |
    And I save the current editor
    # Sammelrechnung erzeugen
    Given I open an editor "rech10" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "lief1"
    And I set field "beleg" to id from editor "lief2"
    # Fehlermeldung 3818
    And saving the current editor throws the exception "ZUGFeRD: Es ist keine Sammelrechnung erlaubt. Bitte entfernen Sie die unerlaubten Positionen"
    And I close the current editor
    # Extended-Format in EDI-Nachricht des Kunden eintragen
    Given I open an editor "ediext" from table "(Customer):(Customer)" with command "UPDATE" for record "Zugferdd"
    And I press button "edinfo" to open a subeditor for "edinachricht"
    And I create a new row at the end of the table
    And I set field "ieabmodell" to "4180" in row 1
    And I save the current editor
    And I switch the current editor to editor "ediext"
    And I save the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: Fall 11 Mindestens eine Zeile mit Positionsnummer
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "rech11" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde"
    And I set field "betreff" to "Fall 11: Mindestens eine Zeile muss eine Positionsnummer haben"
    And I append rows
      | artex   | pwert |
      | neutral | 15    |
    # Fehlermeldung 3850 ZUGFeRD: Mindestens eine Zeile vom Typ "neutrale Position" mit einem positiven Wert muss eine Positionsnummer haben. Bitte vervollständigen.
    And saving the current editor throws the exception "2672"
    And I close the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: Fall 12 Neutrale Position mit negativem Wert soll keine Positionsnummer haben
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "rech11" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde"
    And I set field "betreff" to "Fall 12: Neutrale Position mit negativem Wert soll keine Positionsnummer haben"
    And I append rows
      | pnum | artex   | pwert |
      | 1    | neutral | -5    |
    # Fehlermeldung 3851 ZUGFeRD: Zeilen vom Typ "neutrale Position" mit einem negativen Wert sollen keine Positionsnummer haben. Bitte leeren
    And saving the current editor throws the exception "2672"
    And I close the current editor

    # ---------------------------------------------------------------------------------------------
  Scenario: Fall 13 Abschlagstyp für Zusatzposition fuellen
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "rech13" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde"
    And I set field "betreff" to "Fall 13: Abschlagstyp für Zusatzposition fuellen"
    And I append rows
      | pnum | artex   | mge         | preis       | pwert |
      | 1    | v1      | 15          | 10,5        |       |
      |      | neutral | !dontChange | !dontChange | -5    |
    # Fehlermeldung 3819
    And saving the current editor throws the exception "ZUGFeRD: Bitte den Abschlagstyp für die Zusatzposition in Zeile 2 füllen."
    And I close the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: Fall 14 Zuschlagstyp für Zusatzposition fuellen
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "rech14" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde"
    And I set field "betreff" to "Fall 14: Zuschlagstyp für Zusatzposition fuellen"
    And I append rows
      | pnum | artex   | mge         | preis       | pwert |
      | 1    | v1      | 15          | 10,5        |       |
      |      | neutral | !dontChange | !dontChange | 5     |
    # Fehlermeldung 3820
    And saving the current editor throws the exception "ZUGFeRD: Bitte den Zuschlagstyp für die Zusatzposition in Zeile 2 füllen."
    And I close the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: Fall 15 Zuschlagstyp für Mindestbestellwertposition fuellen
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "rech15" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde"
    And I set field "betreff" to "Fall 15: Zuschlagstyp für Mindestbestellwertposition fuellen"
    And I append rows
      | pnum | artex | mge         | preis |
      | 1    | v1    | 2           | 10,5  |
      |      | MI.50 | !dontChange | 50    |
    # Fehlermeldung 3852
    And saving the current editor throws the exception "ZUGFeRD: Bitte den Zuschlagstyp für die Mindestbestellwertposition in Zeile 2 füllen."
    And I close the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: Fall 16 Artikelkurzbezeichnung oder Artikelname fuellen
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "art4" from table "(Part):(Product)" with command "UPDATE" for record "V1"
    And I set field "name" to ""
    And I set field "vkbez" to ""
    And I save the current editor
    Given I open an editor "rech16" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde"
    And I set field "betreff" to "Fall 16: Artikelbezeichnung oder Artikelname fuellen"
    And I append rows
      | pnum | artex | mge | preis |
      | 1    | v1    | 2   | 10,5  |
    # Fehlermeldung 3828:
    And saving the current editor throws the exception "ZUGFeRD: Bitte Artikelkurzbezeichnung oder Artikelname für Artikel 401 in Zeile 1 füllen."
    And I close the current editor
    # Artikel wieder zuruecksetzen
    Given I open an editor "art5" from table "(Part):(Product)" with command "UPDATE" for record "V1"
    And I set field "name" to "Verkaufsteil eins"
    And I save the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: Fall 17 Steuerschluessel fehlt
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "rech17" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde"
    And I set field "betreff" to "Fall 17: Steuerschlüssel fehlt"
    And I append rows
      | pnum | artex | mge | preis |
      | 1    | v1    | 2   | 10,5  |
    And I set field "strgl" to "" in row 1
    # Fehlermeldung 38??:
    And saving the current editor throws the exception "ZUGFeRD: Der Steuerschlüssel fehlt in der Zeile 1."
    And I close the current editor

    # ----------------------------------------------------------------------------------------------
  Scenario: Fall 18 - Kunde ohne ZUGFeRD - Rechnung - Kunde auf ZUGFeRD umstellen - Wertgutschrift
    # ----------------------------------------------------------------------------------------------
    # Kunde ohne ZUGFeRD anlegen
    Given I open an editor "kundeohneZF" from table "(Customer):(Customer)" with command "STORE" for record "ohneZF"
    And I set fields
        | nummer    | 88899                    |
        | such      | KUohneZF                 |
        | namebspr  | Kunde ohne ZUGFeRD       |
        | ans       | Kunde ohne ZUGFeRD GmbH  |
        | str       | Teststrasse 99           |
        | plz       | 99999                    |
        | nort      | Teststadt                |
        | region    | Bayern                   |
        | ans2      | Kunde ohne ZUGFeRD GmbH  |
        | str2      | Teststrasse 99           |
        | plz2      | 99999                    |
        | nort2     | Teststadt                |
        | region2   | Bayern                   |
        | tele      | 080099999                |
        | betreuer  | zugferd                  |
        | erechmail | test@example.de          |
        | ustid     | DE999888777              |
        | steunr    | 999888777                |
        | lbed      | exw                      |
        | zbed      | 200                      |
        | zaform    | Überweisung              |
        | frbez     | 11122                    |
        | gln       | 111222333                |
    And I save the current editor

    # Rechnung fuer "Kunde ohne ZUGFeRD" anlegen und buchen
    Given I open an editor "rechohneZF" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set fields
        | nummer  | 40ohneZF             |
        | kunde   | KUohneZF             |
        | betreff | Rechnung vor ZUGFeRD |
        | ueb     | ja                   |
    And I append rows
        | pnum | artex | mge | preis |
        | 1    | e2    | 10  | 10,5  |
        | 2    | a.    | 5   | 10    |
        | 3    | dl    | 15  | 50    |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

    # Kunde auf ZUGFeRD umstellen (EDI-Nachricht hinzufuegen)
    Given I open an editor "UmstellKundeZF" from table "(Customer):(Customer)" with command "UPDATE" for record "KUohneZF"
    And I press button "edinfo" to open a subeditor for "edinachricht"
    And I append rows
        | edinachraz              | ieabmodell  | erlaubt |
        | ZUGFeRD-Rechnung Export | 4150        | ja      |
    And I save the current editor
    And I switch the current editor to editor "UmstellKundeZF"
    And I save the current editor

    # Wertgutschrift zu Rechnung anlegen, Kunde ist inzwischen mit ZUGFeRD
    Given I open an editor "GUT-Mit-ZF" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "rechohneZF"
    And I set fields
        | nummer | 50mitZF |
        | ebeleg | 40mitZF |
    And I set field "pnum" to "1" in row 1
    And I set field "pnum" to "2" in row 2
    And I set field "pnum" to "3" in row 3
    And I press button "offueb" in row 1
    And I press button "offueb" in row 2
    And I press button "offueb" in row 3
    And I save the current editor
