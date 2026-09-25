@persistent
Feature: Infosystem ELINVOICEPROCESS mit EDI-Nachricht verwenden

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: Infosystem ELINVOICEPROCESS kann START

# Die Rumf-EDI-Nachricht "ZF1" aus IS_ELINVOICECENTER_feature wird weiter verwendet
# Infosystem ELINVOICEPROCESS kennt Zeilenarten: Artikel, Notiz, Steuer, Zu-/Abschlag

Given I open an editor "EZF1" from table "(EDI):(EDI)" with command "UPDATE" for record "ZF1"
Then the table has 0 rows
And I save the current editor

Given I open an editor "EZF1" from table "(EDI):(EDI)" with command "UPDATE" for record "ZF1"
And I delete all rows
And I append rows
   | text1 | text2  | text3 | text4                                     | text5     |
   | 0     |        |       | ExchangedDocumentID                       | 444444    |
   | 0     |        |       | ExchangedDocumentTypeCode                 | 380       |
   | 0     | NOTE   | 1     | IncludedNoteContent                       | Notiz 1   |
   | 0     | NOTE   | 2     | IncludedNoteContent                       | Notiz 2   |
   | 0     | NOTE   | 3     | IncludedNoteContent                       | Notiz 3   |
   | 0     |        |       | BuyerTradePartyID                         | GLN1      |
   | 0     | TAX    | 1     | TaxCalculatedAmount                       | 40        |
   | 0     | TAX    | 1     | TaxTypeCode                               | VAT       |
   | 0     | TAX    | 2     | TaxCalculatedAmount                       | 80        |
   | 0     | TAX    | 2     | TaxTypeCode                               | VAT       |
   | 0     | CHARGE | 1     | ChargeBasisAmount                         | 10.00     |
   | 0     | CHARGE | 2     | ChargeBasisAmount                         | 20.00     |
   | 10    |        |       | GlobalID                                  | Artikel 1 |
   | 20    |        |       | GlobalID                                  | Artikel 2 |
Then the table has 14 rows
And I save the current editor

Given I open the infosystem "ELINVOICEPROCESS"
And I set field "edifact" to "ZF1"
And I press button "bstart"
Then the table has 6 rows
And field "ediobjsuch" has value "11003"
And field "ExchangedDocumentID" has value "444444"
And I close the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: Infosystem ELINVOICEPROCESS kennt Zeilenarten: Artikel, Notiz, Steuer, Zu-/Abschlag

# Die Felder text1+text2+text3 Steuern welche Felder (1 Feld pro Zeile) 
# in den Kopf des Infsoytesms oder in einer Zeile im Infosystem gehoeren

Given I open the infosystem "ELINVOICEPROCESS"
And I set field "edifact" to "ZF1"
And I set field "btabellemitnotizen" to "ja"
And I press button "bstart"
Then the table has 9 rows
And table has values
  | zeilentyptext      | globalid  | includednotecontent | taxcalculatedamount | chargebasisamount |
  | Steuer             |           |                     | 40.00               |                   |
  | Steuer             |           |                     | 80.00               |                   |
  | Zuschlag/Abschlag  |           |                     | 0.00                | 10.00             |  
  | Zuschlag/Abschlag  |           |                     | 0.00                | 20.00             |  
  | Artikel            | Artikel 1 |                     | 0.00                |                   | # Featurealarm: Weil in der EDI-Tabelle nach TAX keine anderen text1+text2+text3="0"-Zeile kommt, landen die Artikel nicht ganz oben :)
  | Artikel            | Artikel 2 |                     | 0.00                |                   |
  | Notiz              |           | Notiz 1             | 0.00                |                   |
  | Notiz              |           | Notiz 2             | 0.00                |                   |
  | Notiz              |           | Notiz 3             | 0.00                |                   |
And I close the current editor

Given I open the infosystem "ELINVOICEPROCESS"
And I set field "edifact" to "ZF1"
And I press button "bstart"
Then the table has 6 rows
And table has values
  | zeilentyptext      | globalid  | includednotecontent | taxcalculatedamount | chargebasisamount |
  | Steuer             |           |                     | 40.00               |                   |
  | Steuer             |           |                     | 80.00               |                   |
  | Zuschlag/Abschlag  |           |                     | 0.00                | 10.00             |  
  | Zuschlag/Abschlag  |           |                     | 0.00                | 20.00             |  
  | Artikel            | Artikel 1 |                     | 0.00                |                   | # Featurealarm: Weil in der EDI-Tabelle nach TAX keine anderen text1+text2+text3="0"-Zeile kommt, landen die Artikel nicht ganz oben :)
  | Artikel            | Artikel 2 |                     | 0.00                |                   |
And I close the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: Infosystem ELINVOICEPROCESS findet RESTELLER und LIEFERANT: steunr

# Der Nachrichtenpartner aus IS_ELINVOICECENTER_feature ist auch der Lieferant bzw. Rechnungssteller
#   | nummer   | 24000   |
#   | such     | LI1     |
#   | steunr   | steunr1 |
#   | ustid    | DE123   |

Given I open an editor "EZF1" from table "(EDI):(EDI)" with command "UPDATE" for record "ZF1"
And I append rows
   | text1 | text2 | text3 | text4                                     | text5 |
   | 0     |       |       | SellerTradePartySpecifiedTaxRegistration  | DE123 |
Then the table has 15 rows
And I save the current editor

Given I open the infosystem "ELINVOICEPROCESS"
And I set field "edifact" to "ZF1"
And I press button "bstart"
And the table has 6 rows
And field "ediobjsuch" has value "11003"
And field "SellerTradePartySpecifiedTaxRegistration" has value "DE123"
And field "resteller" has value ""
And field "lieferant" has value ""
And I press button "kbuobjektsuche"
Then field "resteller" has value "L 24000"
And field "lieferant" has value "L 24000"
And I close the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: Infosystem ELINVOICEPROCESS findet RESTELLER und LIEFERANT: steunr

# Der Nachrichtenpartner aus IS_ELINVOICECENTER_feature ist auch der Lieferant bzw. Rechnungssteller
#   | nummer   | 24000   |
#   | such     | LI1     |
#   | steunr   | steunr1 |
#   | ustid    | DE123   |
#   | gln      | gln1    |

Given I open an editor "EZF1" from table "(EDI):(EDI)" with command "UPDATE" for record "ZF1"
And I append rows
   | text1 | text2 | text3 | text4                                     | text5 |
   | 0     |       |       | SellerTradePartySpecifiedTaxRegistration  | DE123 |
   | 0     |       |       | BuyerTradePartyID                         | gln1  |
Then the table has 17 rows
And I save the current editor

Given I open the infosystem "ELINVOICEPROCESS"
And I set field "edifact" to "ZF1"
And I press button "bstart"
And the table has 6 rows
And field "ediobjsuch" has value "11003"
And field "SellerTradePartySpecifiedTaxRegistration" has value "DE123"
And field "BuyerTradePartyID" has value "gln1"
And field "resteller" has value ""
And field "lieferant" has value ""
And I press button "kbuobjektsuche"
Then field "resteller" has value "L 24000"
And field "lieferant" has value "L 24000"
And I close the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: Infosystem ELINVOICEPROCESS findet RESTELLER und LIEFERANT: ustid

# Der Nachrichtenpartner aus IS_ELINVOICECENTER_feature ist auch der Lieferant bzw. Rechnungssteller
#   | nummer   | 24000   |
#   | such     | LI1     |
#   | steunr   | steunr1 |
#   | ustid    | DE123   |
#   | gln      | gln1    |

Given I open an editor "EZF1" from table "(EDI):(EDI)" with command "UPDATE" for record "ZF1"
And I append rows
   | text1 | text2 | text3 | text4                                     | text5 |
   | 0     |       |       | SellerTradePartySpecifiedTaxRegistration  | DE123 |
Then the table has 18 rows
And I save the current editor

Given I open the infosystem "ELINVOICEPROCESS"
And I set field "edifact" to "ZF1"
And I press button "bstart"
And the table has 6 rows
And field "ediobjsuch" has value "11003"
And field "SellerTradePartySpecifiedTaxRegistration" has value "DE123"
And field "resteller" has value ""
And field "lieferant" has value ""
And I press button "kbuobjektsuche"
Then field "resteller" has value "L 24000"
And field "lieferant" has value "L 24000"
And I close the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: Betriebsdaten mit STEUNR + GLN aktualisieren

# Eigene Daten: Betriebsdaten etc.
#  steunr222
#  GLN 222

# Die Angaben zu USTID / STEUNR / GLN in der Zugferd-Nachricht (bzw. dann EDI-Tabelle) müssen zu unseren Betriebsdaten passen
Given I open an editor "Betriebsdaten" from table "(Company):(CompanyData)" with command "UPDATE" for record "BETR"
And I set field "gln" to "GLN222"
And I save the current editor

# Die Eigene Steuernummer muss ins Land eingetragen
Given I open an editor "region" from table "(Regions):(RegionCountryEconomicArea)" with command "UPDATE" for record "Deutschland"
And I set field "finlakenn" to "BADEN-W"
And I set field "steunr" to "steunr222"
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: Infosystem ELINVOICEPROCESS identifiziert "uns" als korrekten Rechnungsempfaenger: steunr + gln

Given I open an editor "EZF1" from table "(EDI):(EDI)" with command "UPDATE" for record "ZF1"
And I delete all rows
And I append rows
   | text1 | text2  | text3 | text4                                   | text5     |
   | 0     |        |       | BuyerTradePartySpecifiedTaxRegistration | DE124     |
   | 0     |        |       | InvoiceTradePartyID                     | GLN222    |
   | 0     |        |       | ExchangedDocumentID                     | 444444    |
   | 0     |        |       | ExchangedDocumentTypeCode               | 380       |
   | 0     | NOTE   | 1     | IncludedNoteContent                     | Notiz 1   |
   | 0     | NOTE   | 2     | IncludedNoteContent                     | Notiz 2   |
   | 0     | NOTE   | 3     | IncludedNoteContent                     | Notiz 3   |
   | 0     |        |       | BuyerTradePartyID                       | GLN1      |
   | 0     | TAX    | 1     | TaxCalculatedAmount                     | 40        |
   | 0     | TAX    | 1     | TaxTypeCode                             | VAT       |
   | 0     | TAX    | 2     | TaxCalculatedAmount                     | 80        |
   | 0     | TAX    | 2     | TaxTypeCode                             | VAT       |
   | 0     | CHARGE | 1     | ChargeBasisAmount                       | 10.00     |
   | 0     | CHARGE | 2     | ChargeBasisAmount                       | 20.00     |
   | 10    |        |       | GlobalID                                | Artikel 1 |
   | 20    |        |       | GlobalID                                | Artikel 2 |

Then the table has 16 rows
And I save the current editor

Given I open the infosystem "ELINVOICEPROCESS"
And I set field "edifact" to "ZF1"
And I press button "bstart"
And the table has 6 rows
And field "ediobjsuch" has value "11003"
And field "BuyerTradePartySpecifiedTaxRegistration" has value "DE124"
And field "InvoiceTradePartyID" has value "GLN222"
And field "reempfpasstzubetriebsdaten" has value "nein"
And I press button "kbuobjektsuche"
And field "reempfpasstzubetriebsdaten" has value "ja"
And I close the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: Infosystem ELINVOICEPROCESS identifiziert "uns" als korrekten Rechnungsempfaenger: steunr

Given I open an editor "EZF1" from table "(EDI):(EDI)" with command "UPDATE" for record "ZF1"
And I delete all rows
And I append rows
   | text1 | text2  | text3 | text4                                     | text5     |
   | 0     |        |       | BuyerTradePartySpecifiedTaxRegistration   | DE123     |
   | 0     |        |       | ExchangedDocumentID                       | 444444    |
   | 0     |        |       | ExchangedDocumentTypeCode                 | 380       |
   | 0     | NOTE   | 1     | IncludedNoteContent                       | Notiz 1   |
   | 0     | NOTE   | 2     | IncludedNoteContent                       | Notiz 2   |
   | 0     | NOTE   | 3     | IncludedNoteContent                       | Notiz 3   |
   | 0     |        |       | BuyerTradePartyID                         | GLN1      |
   | 0     | TAX    | 1     | TaxCalculatedAmount                       | 40        |
   | 0     | TAX    | 1     | TaxTypeCode                               | VAT       |
   | 0     | TAX    | 2     | TaxCalculatedAmount                       | 80        |
   | 0     | TAX    | 2     | TaxTypeCode                               | VAT       |
   | 0     | CHARGE | 1     | ChargeBasisAmount                         | 10.00     |
   | 0     | CHARGE | 2     | ChargeBasisAmount                         | 20.00     |
   | 10    |        |       | GlobalID                                  | Artikel 1 |
   | 20    |        |       | GlobalID                                  | Artikel 2 |

Then the table has 15 rows
And I save the current editor

Given I open the infosystem "ELINVOICEPROCESS"
And I set field "edifact" to "ZF1"
And I press button "bstart"
And the table has 6 rows
And field "ediobjsuch" has value "11003"
And field "BuyerTradePartySpecifiedTaxRegistration" has value "DE123"
And field "InvoiceTradePartyID" has value ""
And field "reempfpasstzubetriebsdaten" has value "nein"
And I press button "kbuobjektsuche"
And field "reempfpasstzubetriebsdaten" has value "nein"
And I close the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: Infosystem ELINVOICEPROCESS identifiziert "uns" als korrekten Rechnungsempfaenger: gln

Given I open an editor "EZF1" from table "(EDI):(EDI)" with command "UPDATE" for record "ZF1"
And I delete all rows
And I append rows
   | text1 | text2  | text3 | text4                                     | text5     |
   | 0     |        |       | InvoiceTradePartyID                       | GLN222    |
   | 0     |        |       | ExchangedDocumentID                       | 444444    |
   | 0     |        |       | ExchangedDocumentTypeCode                 | 380       |
   | 0     | NOTE   | 1     | IncludedNoteContent                       | Notiz 1   |
   | 0     | NOTE   | 2     | IncludedNoteContent                       | Notiz 2   |
   | 0     | NOTE   | 3     | IncludedNoteContent                       | Notiz 3   |
   | 0     |        |       | BuyerTradePartyID                         | GLN1      |
   | 0     | TAX    | 1     | TaxCalculatedAmount                       | 40        |
   | 0     | TAX    | 1     | TaxTypeCode                               | VAT       |
   | 0     | TAX    | 2     | TaxCalculatedAmount                       | 80        |
   | 0     | TAX    | 2     | TaxTypeCode                               | VAT       |
   | 0     | CHARGE | 1     | ChargeBasisAmount                         | 10.00     |
   | 0     | CHARGE | 2     | ChargeBasisAmount                         | 20.00     |
   | 10    |        |       | GlobalID                                  | Artikel 1 |
   | 20    |        |       | GlobalID                                  | Artikel 2 |

Then the table has 15 rows
And I save the current editor

Given I open the infosystem "ELINVOICEPROCESS"
And I set field "edifact" to "ZF1"
And I press button "bstart"
And the table has 6 rows
And field "ediobjsuch" has value "11003"
And field "BuyerTradePartySpecifiedTaxRegistration" has value ""
And field "InvoiceTradePartyID" has value "GLN222"
And field "reempfpasstzubetriebsdaten" has value "nein"
And I press button "kbuobjektsuche"
And field "reempfpasstzubetriebsdaten" has value "ja"
And I close the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: Infosystem ELINVOICEPROCESS identifiziert "uns" als NICHT korrekten Rechnungsempfaenger 

Given I open an editor "EZF1" from table "(EDI):(EDI)" with command "UPDATE" for record "ZF1"
And I delete all rows
And I append rows
   | text1 | text2  | text3 | text4                                     | text5     |
   | 0     |        |       | InvoiceTradePartyID                       | GLN777    |
   | 0     |        |       | ExchangedDocumentID                       | 444444    |
   | 0     |        |       | ExchangedDocumentTypeCode                 | 380       |
   | 0     | NOTE   | 1     | IncludedNoteContent                       | Notiz 1   |
   | 0     | NOTE   | 2     | IncludedNoteContent                       | Notiz 2   |
   | 0     | NOTE   | 3     | IncludedNoteContent                       | Notiz 3   |
   | 0     |        |       | BuyerTradePartyID                         | GLN1      |
   | 0     | TAX    | 1     | TaxCalculatedAmount                       | 40        |
   | 0     | TAX    | 1     | TaxTypeCode                               | VAT       |
   | 0     | TAX    | 2     | TaxCalculatedAmount                       | 80        |
   | 0     | TAX    | 2     | TaxTypeCode                               | VAT       |
   | 0     | CHARGE | 1     | ChargeBasisAmount                         | 10.00     |
   | 0     | CHARGE | 2     | ChargeBasisAmount                         | 20.00     |
   | 10    |        |       | GlobalID                                  | Artikel 1 |
   | 20    |        |       | GlobalID                                  | Artikel 2 |

Then the table has 15 rows
And I save the current editor

Given I open the infosystem "ELINVOICEPROCESS"
And I set field "edifact" to "ZF1"
And I press button "bstart"
And the table has 6 rows
And field "ediobjsuch" has value "11003"
And field "BuyerTradePartySpecifiedTaxRegistration" has value ""
And field "InvoiceTradePartyID" has value "GLN777"
And field "reempfpasstzubetriebsdaten" has value "nein"
And I press button "kbuobjektsuche"
And field "reempfpasstzubetriebsdaten" has value "nein"
And I close the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: Infosystem ELINVOICEPROCESS identifiziert Zahlungsbedingung: erfolgreich

Given I open an editor "EZF1" from table "(EDI):(EDI)" with command "UPDATE" for record "ZF1"
And I delete all rows
And I append rows
   | text1 | text2  | text3 | text4                                     | text5     |
   | 0     |        |       | SpecifiedTradePaymentMeans                | 30        |
   | 0     |        |       | ExchangedDocumentID                       | 444444    |
   | 0     |        |       | ExchangedDocumentTypeCode                 | 380       |
   | 0     | NOTE   | 1     | IncludedNoteContent                       | Notiz 1   |
   | 0     | NOTE   | 2     | IncludedNoteContent                       | Notiz 2   |
   | 0     | NOTE   | 3     | IncludedNoteContent                       | Notiz 3   |
   | 0     |        |       | BuyerTradePartyID                         | GLN1      |
   | 0     | TAX    | 1     | TaxCalculatedAmount                       | 40        |
   | 0     | TAX    | 1     | TaxTypeCode                               | VAT       |
   | 0     | TAX    | 2     | TaxCalculatedAmount                       | 80        |
   | 0     | TAX    | 2     | TaxTypeCode                               | VAT       |
   | 0     | CHARGE | 1     | ChargeBasisAmount                         | 10.00     |
   | 0     | CHARGE | 2     | ChargeBasisAmount                         | 20.00     |
   | 10    |        |       | GlobalID                                  | Artikel 1 |
   | 20    |        |       | GlobalID                                  | Artikel 2 |

Then the table has 15 rows
And I save the current editor

Given I open the infosystem "ELINVOICEPROCESS"
And I set field "edifact" to "ZF1"
And I press button "bstart"
And the table has 6 rows
And field "ediobjsuch" has value "11003"
And field "SpecifiedTradePaymentMeans" has value "30"
And field "zfpaymenttypazk" has value ""
And field "zfpaymenttypaz" has value ""
And I press button "kbuobjektsuche"
And field "SpecifiedTradePaymentMeans" has value "30"
And field "zfpaymenttypazk" has value "30"
And field "zfpaymenttypaz" has value "Überweisung"
And I close the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: Infosystem ELINVOICEPROCESS identifiziert Zahlungsbedingung: nicht

Given I open an editor "EZF1" from table "(EDI):(EDI)" with command "UPDATE" for record "ZF1"
And I append rows
   | text1 | text2 | text3 | text4                      | text5     |
   | 0     |       |       | SpecifiedTradePaymentMeans | 77        |
Then the table has 16 rows
And I save the current editor

Given I open the infosystem "ELINVOICEPROCESS"
And I set field "edifact" to "ZF1"
And I press button "bstart"
And the table has 6 rows
And field "ediobjsuch" has value "11003"
And field "SpecifiedTradePaymentMeans" has value "77"
And field "zfpaymenttypazk" has value ""
And field "zfpaymenttypaz" has value ""
And I press button "kbuobjektsuche"
And field "SpecifiedTradePaymentMeans" has value "77"
And field "zfpaymenttypazk" has value ""
And field "zfpaymenttypaz" has value ""
And I close the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: GTINs fuer Artikel ausfuellen
Given I open an editor "E1" from table "(Part):(Product)" with command "UPDATE" for record "E1"
And I set fields 
   | gtin | GTIN-E1 |
And I save the current editor

Given I open an editor "E2" from table "(Part):(Product)" with command "UPDATE" for record "E2"
And I set fields 
   | gtin | GTIN-E2 |
And I save the current editor

Given I open an editor "E3" from table "(Part):(Product)" with command "UPDATE" for record "E3"
And I set fields 
   | lief2  | LI1       |
   | bstnr2 | E3-BSTNR  | 
And I save the current editor

Given I open an editor "DL-ZUGF1" from table "(Part):(Service)" with command "NEW" for record ""
And I set fields 
   | such | DL-ZUGF1   |
   | gtin | GTIN-ZUGF1 |
And I save the current editor

Given I open an editor "DL-ZUGF2" from table "(Part):(Service)" with command "NEW" for record ""
And I set fields 
   | such   | DL-ZUGF2  |
   | lief3  | LI1       |
   | bstnr3 | BSTNRZF2  | 
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: Bestellung fuer Zugferd-Lieferanten erstellen

Given I open an editor "BESTELLUNG" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | LI1    |
   | frzeich | 444444 |
And I append rows  
   | artikel | mge |
   | E1      | 10  |
   | E2      | 20  |
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: Infosystem ELINVOICEPROCESS pruefte ARTIKEL und EINHEIT

Given I open an editor "EZF1" from table "(EDI):(EDI)" with command "UPDATE" for record "ZF1"
And I delete all rows
And I append rows
   | text1 | text2 | text3 | text4                                     | text5      |
   | 0     |       |       | SellerTradePartySpecifiedTaxRegistration  | DE123      |
   | 1     |       |       | GlobalID                                  | GTIN-E1    |
   | 1     |       |       | BilledQuantityUnitCode                    | MTK        | # Quadratmeter
   | 2     |       |       | GlobalID                                  | GTIN-E2    |
   | 2     |       |       | BilledQuantityUnitCode                    | H87        | # Stück
   | 3     |       |       | GlobalID                                  | GTIN-ZUGF1 |
   | 4     |       |       | SpecifiedTradeProductSellerAssignedID     | BSTNRZF2   |   
   | 5     |       |       | SpecifiedTradeProductSellerAssignedID     | E3-BSTNR   |   
Then the table has 8 rows
And I save the current editor

Given I open the infosystem "ELINVOICEPROCESS"
And I set field "edifact" to "ZF1"
And I press button "bstart"
And the table has 5 rows
And table has values
  | zeilentyptext      | globalid   | SpecifiedTradeProductSellerAssignedID | billedquantityunitcode | artikel | einheit |
  | Artikel            | GTIN-E1    |                                       | MTK                    |         |         | 
  | Artikel            | GTIN-E2    |                                       | H87                    |         |         |
  | Artikel            | GTIN-ZUGF1 |                                       |                        |         |         |
  | Artikel            |            | BSTNRZF2                              |                        |         |         |
  | Artikel            |            | E3-BSTNR                              |                        |         |         |
And I press button "kbuobjektsuche"
And table has values
  | zeilentyptext      | globalid   | SpecifiedTradeProductSellerAssignedID | billedquantityunitcode | artikel  | einheit |
  | Artikel            | GTIN-E1    |                                       | MTK                    | E1       | m²      | 
  | Artikel            | GTIN-E2    |                                       | H87                    | E2       | Stück   |
  | Artikel            | GTIN-ZUGF1 |                                       |                        | DL-ZUGF1 |         |
  | Artikel            |            | BSTNRZF2                              |                        | DL-ZUGF2 |         |
  | Artikel            |            | E3-BSTNR                              |                        | E3       |         |
And I close the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: Infosystem ELINVOICEPROCESS findet Bestellung

Given I open an editor "EZF1" from table "(EDI):(EDI)" with command "UPDATE" for record "ZF1"
And I append rows
   | text1 | text2 | text3 | text4                                    | text5  |
   | 0     |       |       | InvoiceTradePartyID                      | GLN222 |
   | 0     |       |       | SellerTradePartySpecifiedTaxRegistration | DE123  | 
   | 0     |       |       | ExchangedDocumentID                      | 444444 |
Then the table has 11 rows
And I save the current editor

Given I open the infosystem "ELINVOICEPROCESS"
And I set field "edifact" to "ZF1"
And I press button "bstart"
And the table has 5 rows
And field "SellerTradePartySpecifiedTaxRegistration" has value "DE123"
And field "InvoiceTradePartyID" has value "GLN222"
And field "ExchangedDocumentID" has value "444444"
And field "resteller" has value ""
And field "lieferant" has value ""
And field "bestellung" has value ""
And I press button "kbuobjektsuche"
Then field "resteller" has value "L 24000"
And field "lieferant" has value "L 24000"
And field "bestellung" has value equal to field "nummer" from editor "BESTELLUNG"
And I close the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: Infosystem ELINVOICEPROCESS: Alles auf einmal

Given I open an editor "EZF1" from table "(EDI):(EDI)" with command "UPDATE" for record "ZF1"
And I delete all rows
And I append rows
   | text1 | text2 | text3 | text4                                     | text5   |
   | 0     |       |       | InvoiceTradePartyID                       | GLN222  |
   | 0     |       |       | SellerTradePartySpecifiedTaxRegistration  | DE  123 | # Testen ob Leerzeichen in USTID entfernt werden
   | 0     |       |       | ExchangedDocumentID                       | 444444  |
   | 0     |       |       | SpecifiedTradePaymentMeans                | 30      |
   | 0     |       |       | SpecifiedTradePaymentTermsDueDateDateTime | .       | 
   | 1     |       |       | GlobalID                                  | GTIN-E1 |
   | 1     |       |       | BilledQuantityUnitCode                    | MTK     |
   | 2     |       |       | GlobalID                                  | GTIN-E2 | 
   | 2     |       |       | BilledQuantityUnitCode                    | H87     |
Then the table has 9 rows
And I save the current editor


Given I open the infosystem "ELINVOICEPROCESS"
And I set field "edifact" to "ZF1"
And I press button "bstart"
And the table has 2 rows
And I press button "kbuobjektsuche"
Then field "resteller" has value "L 24000"
And field "lieferant" has value "L 24000"
And field "bestellung" has value equal to field "nummer" from editor "BESTELLUNG"
And field "reempfpasstzubetriebsdaten" has value "ja"
And field "zfpaymenttypazk" has value "30"
And field "zfpaymenttypaz" has value "Überweisung"
And table has values
  | zeilentyptext      | globalid | billedquantityunitcode | artikel | einheit |
  | Artikel            | GTIN-E1  | MTK                    | E1      | m²      | 
  | Artikel            | GTIN-E2  | H87                    | E2      | Stück   |
And I close the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: Infosystem ELINVOICEPROCESS: aktiv kennzeichen

Given I open the infosystem "ELINVOICEPROCESS"
And I set field "edifact" to "ZF1"
And I press button "bstart"
And the table has 2 rows
And field "ediaktiv" has value "ja"
And I close the current editor

Given I open an editor "LI1" from table "(Vendor):(Vendor)" with command "UPDATE" for record "24000"
And I press button "edinfo" to open a subeditor for "EDIInfo"
And I set field "erlaubt" to "nein" in row 1
And I save the current editor
And I switch the current editor to editor "LI1"
And I save the current editor

Given I open the infosystem "ELINVOICEPROCESS"
And I set field "edifact" to "ZF1"
And I press button "bstart"
And the table has 2 rows
And field "ediaktiv" has value "nein"
And I close the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
