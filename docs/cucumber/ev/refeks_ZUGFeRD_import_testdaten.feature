# *****************************************************************************
#  Name             : refeks_ZUGFeRD_import_testdaten.feature
#  Autor            : mh
#  Verantwortlich   : mh
#  Kontrolle        : cl
#  Funktion         : Testdaten ZUGFeRD-Import in refeks1
# *****************************************************************************
@persistent
Feature: Testdaten ZUGFeRD-Import anlegen

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: GLN UND STEUERNUMMER IN BETRIEBSDATEN
# 
# In refeks1 sollten wir /nicht/ an den Betriebsdaten schrauben,
# sondern verwenden, was bereits konfiguiert ist:
#   steunr = 28839934
#   gln = 4012345678901
#
# Given I open an editor "Betriebsdaten" from table "(Company):(CompanyData)" with command "UPDATE" for record "BETR"
# And I set field "gln" to "GLN222"
# And I save the current editor
# 
# Given I open an editor "region" from table "(Regions):(RegionCountryEconomicArea)" with command "UPDATE" for record "Deutschland"
# And I set field "finlakenn" to "BADEN-W"
# And I set field "steunr" to "steunr222"
# And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: ARTIKEL MIT GTIN AUSSTATTEN

Given I open an editor "E1" from table "(Part):(Product)" with command "UPDATE" for record "E1"
And I set fields 
   | gtin | GTIN-E1 |
And I save the current editor

Given I open an editor "E2" from table "(Part):(Product)" with command "UPDATE" for record "E2"
And I set fields 
   | gtin | GTIN-E2 |
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: NACHRICHTENPARTNER + LIEFERANT + RECHNUNGSSTELLER 

Given I open an editor "ZFLI1" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
  | nummer   | 24000                             |
  | such     | ZFLI1                             |
  | name     | Testlieferant fuer ZUGFeRD-Import |
  | steunr   | steunr1                           |
  | ustid    | DE123                             |
  | gln      | gln1                              |
And I save the current editor

Given I open an editor "ZFLI1" from table "(Vendor):(Vendor)" with command "UPDATE" for record "24000"
And I press button "edinfo" to open a subeditor for "EDIInfo"
And I append rows
  | edinachraz             | erlaubt | ieabmodell | suchkonfig | abmodell |
  | (ZUGFeRDInvoiceImport) | ja      | 4160       | ZUGFERD    | 4161     |  # mit Abbildungsmodellen
And I save the current editor
And I switch the current editor to editor "ZFLI1"
And I save the current editor

Given I open an editor "BVZFLI1" from table "(BankData):(BankDetails)" with command "NEW" for record ""
And I set fields
  | such  | BVZFLI1  |
  | konto | L ZFLI1  |
  | bank  | 1010     |
  | iban  | 12345677 |
And I save the current editor

Given I open an editor "ZFLI1" from table "(Vendor):(Vendor)" with command "UPDATE" for record "ZFLI1"
And I set fields
  | bverb    | BVZFLI1 |
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: BESTELLUNG 1 - WICHTIG: FRZEICH IST "ExchangedDocumentID"

Given I open an editor "BESTELLUNG1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | ZFLI1  |
   | frzeich | 1122   |
And I append rows  
   | artikel | mge | preis |
   | E1      | 10  | 10    |
   | E2      | 20  | 12    |
And I save the current editor

Given I open an editor "LIEFER1A" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG1"
And I set fields
   | ebeleg  | 1122A    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "5" in row 1
And I set field "mge" to "5" in row 2
And I save the current editor

Given I open an editor "LIEFER1B" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG1"
And I set fields
   | ebeleg  | 1122B    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "5" in row 1
And I set field "mge" to "15" in row 2
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: EDI-NACHRICHT MIT ZUGFERD-RECHNUNGS-TEILEN ERSTELLEN 1

Given I open an editor "EZF1" from table "(EDI):(EDI)" with command "NEW" for record ""
And I set fields
  | such       | ZF1                    |
  | name       | TEST                   |
  | edinachraz | (ZUGFeRDInvoiceImport) |
  | ediimex    | IM                     |
  | glabkunde  | gln1                   |
  | kenn       | steunr1/DE123          |
And I delete all rows
And I append rows
   | text1 | text2 | text3 | text4                                     | text5    |
   | 0     |       |       | BuyerTradePartySpecifiedTaxRegistration   | 28839934 |  
   | 0     |       |       | SellerTradePartySpecifiedTaxRegistration  | DE123    | 
   | 0     |       |       | SpecifiedTradePaymentMeans                | 30       |
   | 0     |       |       | ExchangedDocumentID                       | 1122     |
   | 0     |       |       | SpecifiedTradePaymentTermsDueDateDateTime | .        | 
   | 0     |       |       | PayeePartyCreditorFinancialAccountIBANID  | 12345677 |
   | 0     |       |       | IssueDateTime                             | .        |
   | 0     |       |       | DeliveryDateTime                          | .        |
   | 1     |       |       | GlobalID                                  | GTIN-E1  |
   | 1     |       |       | BilledQuantityUnitCode                    | H87      |
   | 1     |       |       | BilledQuantity                            | 10       |
   | 1     |       |       | NetPriceProductTradePrice                 | 10       |
   | 1     |       |       | LineTotalAmount                           | 100      |
   | 1     |       |       | GrossPriceProductTradePrice               | 10       |
   | 2     |       |       | GlobalID                                  | GTIN-E2  | 
   | 2     |       |       | BilledQuantityUnitCode                    | H87      |
   | 2     |       |       | BilledQuantity                            | 20       |
   | 2     |       |       | NetPriceProductTradePrice                 | 12       |
   | 2     |       |       | LineTotalAmount                           | 240      |
   | 2     |       |       | GrossPriceProductTradePrice               | 12       |
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: BESTELLUNG 2 - WICHTIG: FRZEICH IST "ExchangedDocumentID"

Given I open an editor "BESTELLUNG2" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | ZFLI1  |
   | frzeich | 1133   |
And I append rows  
   | artikel | mge | preis |
   | E1      | 10  | 10    |
   | E2      | 20  | 12    |
And I save the current editor

Given I open an editor "LIEFER2A" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG2"
And I set fields
   | ebeleg  | 1133A    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "8" in row 1
And I set field "mge" to "12" in row 2
And I save the current editor

Given I open an editor "LIEFER2B" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG2"
And I set fields
   | ebeleg  | 1133B    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "5" in row 1
And I set field "mge" to "12" in row 2
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: EDI-NACHRICHT MIT ZUGFERD-RECHNUNGS-TEILEN ERSTELLEN 2

Given I open an editor "EZF2" from table "(EDI):(EDI)" with command "NEW" for record ""
And I set fields
  | such       | ZF2                    |
  | name       | TEST                   |
  | edinachraz | (ZUGFeRDInvoiceImport) |
  | ediimex    | IM                     |
  | glabkunde  | gln1                   |
  | kenn       | steunr1/DE123          |
And I delete all rows
And I append rows
   | text1 | text2 | text3 | text4                                     | text5    |
   | 0     |       |       | BuyerTradePartySpecifiedTaxRegistration   | 28839934 |  
   | 0     |       |       | SellerTradePartySpecifiedTaxRegistration  | DE123    | 
   | 0     |       |       | ExchangedDocumentID                       | 1133     |
   | 0     |       |       | SpecifiedTradePaymentMeans                | 30       |
   | 0     |       |       | SpecifiedTradePaymentTermsDueDateDateTime | .        | 
   | 0     |       |       | PayeePartyCreditorFinancialAccountIBANID  | 12345677 |
   | 0     |       |       | IssueDateTime                             | .        |
   | 0     |       |       | DeliveryDateTime                          | .        |
   | 0     |       |       | kLineTotalAmount                          | 340,00   |
   | 1     |       |       | GlobalID                                  | GTIN-E1  |
   | 1     |       |       | BilledQuantityUnitCode                    | H87      |
   | 1     |       |       | BilledQuantity                            | 10       |
   | 1     |       |       | NetPriceProductTradePrice                 | 10       |
   | 1     |       |       | LineTotalAmount                           | 100      |
   | 1     |       |       | GrossPriceProductTradePrice               | 10       |
   | 2     |       |       | GlobalID                                  | GTIN-E2  | 
   | 2     |       |       | BilledQuantityUnitCode                    | H87      |
   | 2     |       |       | BilledQuantity                            | 20       |
   | 2     |       |       | NetPriceProductTradePrice                 | 12       |
   | 2     |       |       | LineTotalAmount                           | 240      |
   | 2     |       |       | GrossPriceProductTradePrice               | 12       |
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: BESTELLUNG 3 - WICHTIG: FRZEICH IST "ExchangedDocumentID"

Given I open an editor "BESTELLUNG3" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | ZFLI1  |
   | frzeich | 1144   |
And I append rows  
   | artikel | mge | preis |
   | E1      | 100 | 10    |
   | E2      | 200 | 12    |
And I save the current editor

Given I open an editor "LIEFER3A" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG3"
And I set fields
   | ebeleg  | 1144A    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "2" in row 1
And I set field "mge" to "2" in row 2
And I save the current editor

Given I open an editor "LIEFER3B" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG3"
And I set fields
   | ebeleg  | 1144B    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "2" in row 1
And I set field "mge" to "2" in row 2
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: EDI-NACHRICHT MIT ZUGFERD-RECHNUNGS-TEILEN ERSTELLEN 3

Given I open an editor "EZF3" from table "(EDI):(EDI)" with command "NEW" for record ""
And I set fields
  | such       | ZF3                    |
  | name       | TEST                   |
  | edinachraz | (ZUGFeRDInvoiceImport) |
  | ediimex    | IM                     |
  | glabkunde  | gln1                   |
  | kenn       | steunr1/DE123          |
And I delete all rows
And I append rows
   | text1 | text2 | text3 | text4                                     | text5    |
   | 0     |       |       | BuyerTradePartySpecifiedTaxRegistration   | 28839934 |  
   | 0     |       |       | SellerTradePartySpecifiedTaxRegistration  | DE123    | 
   | 0     |       |       | ExchangedDocumentID                       | 1144     |
   | 0     |       |       | SpecifiedTradePaymentMeans                | 30       |
   | 0     |       |       | SpecifiedTradePaymentTermsDueDateDateTime | .        | 
   | 0     |       |       | PayeePartyCreditorFinancialAccountIBANID  | 12345677 |
   | 0     |       |       | IssueDateTime                             | .        |
   | 0     |       |       | DeliveryDateTime                          | .        |
   | 1     |       |       | GlobalID                                  | E1       |
   | 1     |       |       | BilledQuantityUnitCode                    | H87      |
   | 1     |       |       | BilledQuantity                            | 10       |
   | 1     |       |       | NetPriceProductTradePrice                 | 10       |
   | 1     |       |       | LineTotalAmount                           | 100      |
   | 1     |       |       | GrossPriceProductTradePrice               | 10       |
   | 2     |       |       | GlobalID                                  | GTIN-E2  | 
   | 2     |       |       | BilledQuantityUnitCode                    | H87      |
   | 2     |       |       | BilledQuantity                            | 200      |
   | 2     |       |       | NetPriceProductTradePrice                 | 12       |
   | 2     |       |       | LineTotalAmount                           | 240      |
   | 2     |       |       | GrossPriceProductTradePrice               | 12       |
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: BESTELLUNG 4 - WICHTIG: FRZEICH IST "ExchangedDocumentID"

Given I open an editor "BESTELLUNG4" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | ZFLI1  |
   | frzeich | 1155   |
And I append rows  
   | artikel | mge | preis |
   | E1      |   5 | 10    |
   | DL-INSP |   5 | 200   |
And I save the current editor

Given I open an editor "LIEFER4A" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG4"
And I set fields
   | ebeleg  | 1155A    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "1" in row 1
And I set field "mge" to "1" in row 2
And I save the current editor

Given I open an editor "LIEFER4A" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG4"
And I set fields
   | ebeleg  | 1155B    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "1" in row 1
And I set field "mge" to "1" in row 2
And I save the current editor

Given I open an editor "LIEFER4A" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG4"
And I set fields
   | ebeleg  | 1155C    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "1" in row 1
And I set field "mge" to "1" in row 2
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: EDI-NACHRICHT MIT ZUGFERD-RECHNUNGS-TEILEN ERSTELLEN 4

Given I open an editor "EZF4" from table "(EDI):(EDI)" with command "NEW" for record ""
And I set fields
  | such       | ZF4                    |
  | name       | TEST                   |
  | edinachraz | (ZUGFeRDInvoiceImport) |
  | ediimex    | IM                     |
  | glabkunde  | gln1                   |
  | kenn       | steunr1/DE123          |
And I delete all rows
And I append rows
   | text1 | text2 | text3 | text4                                     | text5    |
   | 0     |       |       | BuyerTradePartySpecifiedTaxRegistration   | 28839934 |  
   | 0     |       |       | SellerTradePartySpecifiedTaxRegistration  | DE123    | 
   | 0     |       |       | ExchangedDocumentID                       | 1155     |
   | 0     |       |       | SpecifiedTradePaymentMeans                | 30       |
   | 0     |       |       | SpecifiedTradePaymentTermsDueDateDateTime | .        | 
   | 0     |       |       | PayeePartyCreditorFinancialAccountIBANID  | 12345677 |
   | 0     |       |       | IssueDateTime                             | .        |
   | 0     |       |       | DeliveryDateTime                          | .        |
   | 1     |       |       | GlobalID                                  | DL-INSP  |
   | 1     |       |       | BilledQuantityUnitCode                    | H87      |
   | 1     |       |       | BilledQuantity                            | 5        |
   | 1     |       |       | NetPriceProductTradePrice                 | 200      |
   | 1     |       |       | LineTotalAmount                           | 1000     |
   | 1     |       |       | GrossPriceProductTradePrice               | 200      |
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: BESTELLUNG 5 - WICHTIG: FRZEICH IST "ExchangedDocumentID"

Given I open an editor "BESTELLUNG5" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | ZFLI1  |
   | frzeich | 1166   |
And I append rows  
   | artikel | mge | preis |
   | A.      |   5 | 10    |
And I append rows  
   | artikel | pwert |
   | VERSAND | 100   |
And I save the current editor

Given I open an editor "LIEFER5A" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG5"
And I set fields
   | ebeleg  | 1166A    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "2" in row 1
And I save the current editor

Given I open an editor "LIEFER5B" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG5"
And I set fields
   | ebeleg  | 1166B    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "5" in row 1
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: EDI-NACHRICHT MIT ZUGFERD-RECHNUNGS-TEILEN ERSTELLEN 5

Given I open an editor "EZF5" from table "(EDI):(EDI)" with command "NEW" for record ""
And I set fields
  | such       | ZF5                    |
  | name       | TEST                   |
  | edinachraz | (ZUGFeRDInvoiceImport) |
  | ediimex    | IM                     |
  | glabkunde  | gln1                   |
  | kenn       | steunr1/DE123          |
And I delete all rows
And I append rows
   | text1 | text2 | text3 | text4                                     | text5    |
   | 0     |       |       | BuyerTradePartySpecifiedTaxRegistration   | 28839934 |  
   | 0     |       |       | SellerTradePartySpecifiedTaxRegistration  | DE123    | 
   | 0     |       |       | ExchangedDocumentID                       | 1166     |
   | 0     |       |       | SpecifiedTradePaymentMeans                | 30       |
   | 0     |       |       | SpecifiedTradePaymentTermsDueDateDateTime | .        | 
   | 0     |       |       | PayeePartyCreditorFinancialAccountIBANID  | 12345677 |
   | 0     |       |       | IssueDateTime                             | .        |
   | 0     |       |       | DeliveryDateTime                          | .        |
   | 1     |       |       | GlobalID                                  | A.       |
   | 1     |       |       | BilledQuantityUnitCode                    | H87      |
   | 1     |       |       | BilledQuantity                            | 5        |
   | 1     |       |       | NetPriceProductTradePrice                 | 10       |
   | 1     |       |       | LineTotalAmount                           | 100      |
   | 1     |       |       | GrossPriceProductTradePrice               | 10       |
   | 2     |       |       | GlobalID                                  | VERSAND  |
   | 2     |       |       | BilledQuantityUnitCode                    | H87      |
   | 2     |       |       | BilledQuantity                            | 1        |
   | 2     |       |       | NetPriceProductTradePrice                 | 100      |
   | 2     |       |       | LineTotalAmount                           | 100      |
   | 2     |       |       | GrossPriceProductTradePrice               | 100      |
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: NACHRICHTENPARTNER + LIEFERANT + RECHNUNGSSTELLER -- EXTENDED

Given I open an editor "ZFLI2" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
  | nummer   | 24002   |
  | such     | ZFLI2   |
  | name     | Testlieferant fuer ZUGFeRD-Import |
  | steunr   | steunr2 |
  | ustid    | DE222   |
  | gln      | gln2    |
And I save the current editor

Given I open an editor "ZFLI2" from table "(Vendor):(Vendor)" with command "UPDATE" for record "24002"
And I press button "edinfo" to open a subeditor for "EDIInfo"
And I append rows
  | edinachraz             | erlaubt | ieabmodell | suchkonfig | abmodell |
  | (ZUGFeRDInvoiceImport) | ja      | 4190       | ZUGFERD    | 4191     |  # mit Abbildungsmodellen
And I save the current editor
And I switch the current editor to editor "ZFLI2"
And I save the current editor

Given I open an editor "BVZFLI2" from table "(BankData):(BankDetails)" with command "NEW" for record ""
And I set fields
  | such  | BVZFLI2  |
  | konto | L ZFLI2  |
  | bank  | 1010     |
  | iban  | 12345678 |
And I save the current editor

Given I open an editor "ZFLI2" from table "(Vendor):(Vendor)" with command "UPDATE" for record "ZFLI2"
And I set fields
  | bverb    | BVZFLI2 |
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: BESTELLUNG 6 - WICHTIG: FRZEICH IST "ExchangedDocumentID"

Given I open an editor "BESTELLUNG6" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | ZFLI2  |
   | frzeich | 1177   |
And I append rows  
   | pnum | artikel | mge | preis |
   | 10   | E1      | 10  | 10    |
   | 20   | E2      | 20  | 12    |
And I save the current editor

Given I open an editor "LIEFER6A" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG6"
And I set fields
   | ebeleg  | 1177A    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "5" in row 1
And I set field "mge" to "20" in row 2
And I save the current editor

Given I open an editor "LIEFER6B" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG6"
And I set fields
   | ebeleg  | 1177B    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "5" in row 1
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: EDI-NACHRICHT MIT ZUGFERD-RECHNUNGS-TEILEN ERSTELLEN 6

Given I open an editor "EZF6" from table "(EDI):(EDI)" with command "NEW" for record ""
And I set fields
  | such       | ZF6                    |
  | name       | TEST                   |
  | edinachraz | (ZUGFeRDInvoiceImport) |
  | ediimex    | IM                     |
  | glabkunde  | gln2                   |
  | kenn       | steunr2/DE222          |
And I delete all rows
And I append rows
   | text1 | text2 | text3 | text4                                     | text5    |
   | 0     |       |       | BuyerTradePartySpecifiedTaxRegistration   | 28839934 |  
   | 0     |       |       | SellerTradePartySpecifiedTaxRegistration  | DE222    | 
   | 0     |       |       | SpecifiedTradePaymentMeans                | 30       |
   | 0     |       |       | ExchangedDocumentID                       | 1177     |
   | 0     |       |       | SpecifiedTradePaymentTermsDueDateDateTime | .        | 
   | 0     |       |       | PayeePartyCreditorFinancialAccountIBANID  | 12345678 |
   | 0     |       |       | IssueDateTime                             | .        |
   | 0     |       |       | DeliveryDateTime                          | .        |
   | 1     |       |       | GlobalID                                  | GTIN-E1  |
   | 1     |       |       | BilledQuantityUnitCode                    | H87      |
   | 1     |       |       | BilledQuantity                            | 5        |
   | 1     |       |       | NetPriceProductTradePrice                 | 10       |
   | 1     |       |       | LineTotalAmount                           | 50       |
   | 1     |       |       | GrossPriceProductTradePrice               | 10       |
   | 1     |       |       | OccurreDateTime                           | .        |  
   | 1     |       |       | DeliveryNoteIssuerAssignedID              | 1177A    |
   | 1     |       |       | DeliveryNoteLineID                        | 10       |
   | 1     |       |       | DeliveryNoteIssueDateTime                 | .        |
   | 1     |       |       | BuyerOrderIssuerAssignedID                | 1177     |
   | 1     |       |       | BuyerOrderLineID                          | 10       |
   | 1     |       |       | BuyerOrderIssueDateTime                   | .        |   
   | 2     |       |       | GlobalID                                  | GTIN-E2  | 
   | 2     |       |       | BilledQuantityUnitCode                    | H87      |
   | 2     |       |       | BilledQuantity                            | 20       |
   | 2     |       |       | NetPriceProductTradePrice                 | 12       |
   | 2     |       |       | LineTotalAmount                           | 240      |
   | 2     |       |       | GrossPriceProductTradePrice               | 12       |
   | 2     |       |       | OccurreDateTime                           | .        |  
   | 2     |       |       | DeliveryNoteIssuerAssignedID              | 1177A    |
   | 2     |       |       | DeliveryNoteLineID                        | 20       |
   | 2     |       |       | DeliveryNoteIssueDateTime                 | .        |   
   | 2     |       |       | BuyerOrderIssuerAssignedID                | 1177     |
   | 2     |       |       | BuyerOrderLineID                          | 20       |
   | 2     |       |       | BuyerOrderIssueDateTime                   | .        |   
   | 3     |       |       | GlobalID                                  | GTIN-E1  |
   | 3     |       |       | BilledQuantityUnitCode                    | H87      |
   | 3     |       |       | BilledQuantity                            | 5        |
   | 3     |       |       | NetPriceProductTradePrice                 | 10       |
   | 3     |       |       | LineTotalAmount                           | 50       |
   | 3     |       |       | GrossPriceProductTradePrice               | 10       |
   | 3     |       |       | OccurreDateTime                           | .        |  
   | 3     |       |       | DeliveryNoteIssuerAssignedID              | 1177B    |
   | 3     |       |       | DeliveryNoteLineID                        | 10       |
   | 3     |       |       | DeliveryNoteIssueDateTime                 | .        |
   | 3     |       |       | BuyerOrderIssuerAssignedID                | 1177     |
   | 3     |       |       | BuyerOrderLineID                          | 10       |
   | 3     |       |       | BuyerOrderIssueDateTime                   | .        |
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: BESTELLUNG 7 - E-Rechnung Extended Format

Given I open an editor "BESTELLUNG7" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | ZFLI2  |
   | frzeich | 1188   |
And I append rows  
   | pnum | artikel | mge | preis |
   | 10   | E1      | 10  | 10    |
   | 20   | E2      | 20  | 12    |
And I save the current editor

Given I open an editor "LIEFER7A" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG7"
And I set fields
   | ebeleg  | 1188A    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "5" in row 1
And I set field "mge" to "10" in row 2
And I save the current editor

Given I open an editor "LIEFER7B" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG7"
And I set fields
   | ebeleg  | 1188B    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "5" in row 1
And I set field "mge" to "10" in row 2
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: EDI-NACHRICHT MIT ZUGFERD-RECHNUNGS-TEILEN ERSTELLEN 7

Given I open an editor "EZF7" from table "(EDI):(EDI)" with command "NEW" for record ""
And I set fields
  | such       | ZF7                    |
  | name       | TEST                   |
  | edinachraz | (ZUGFeRDInvoiceImport) |
  | ediimex    | IM                     |
  | glabkunde  | gln2                   |
  | kenn       | steunr2/DE222          |
And I delete all rows
And I append rows
   | text1 | text2 | text3 | text4                                     | text5    |
   | 0     |       |       | BuyerTradePartySpecifiedTaxRegistration   | 28839934 |  
   | 0     |       |       | SellerTradePartySpecifiedTaxRegistration  | DE222    | 
   | 0     |       |       | ExchangedDocumentID                       |          |
   | 0     |       |       | SpecifiedTradePaymentMeans                | 30       |
   | 0     |       |       | SpecifiedTradePaymentTermsDueDateDateTime | .        | 
   | 0     |       |       | PayeePartyCreditorFinancialAccountIBANID  | 12345678 |
   | 0     |       |       | IssueDateTime                             | .        |
   | 0     |       |       | DeliveryDateTime                          | .        |
   | 0     |       |       | kLineTotalAmount                          | 340,00   |
   | 1     |       |       | GlobalID                                  | GTIN-E1  |
   | 1     |       |       | BilledQuantityUnitCode                    | H87      |
   | 1     |       |       | BilledQuantity                            | 5        |
   | 1     |       |       | NetPriceProductTradePrice                 | 10       |
   | 1     |       |       | LineTotalAmount                           | 50       |
   | 1     |       |       | GrossPriceProductTradePrice               | 10       |
   | 1     |       |       | OccurreDateTime                           | .        |  
   | 1     |       |       | DeliveryNoteIssuerAssignedID              | 1188A    |
   | 1     |       |       | DeliveryNoteLineID                        | 10       |
   | 1     |       |       | DeliveryNoteIssueDateTime                 | .        |
   | 1     |       |       | BuyerOrderIssuerAssignedID                | 1188     |
   | 1     |       |       | BuyerOrderLineID                          | 10       |
   | 1     |       |       | BuyerOrderIssueDateTime                   | .        |
   | 2     |       |       | GlobalID                                  | GTIN-E2  | 
   | 2     |       |       | BilledQuantityUnitCode                    | H87      |
   | 2     |       |       | BilledQuantity                            | 10       |
   | 2     |       |       | NetPriceProductTradePrice                 | 12       |
   | 2     |       |       | LineTotalAmount                           | 120      |
   | 2     |       |       | GrossPriceProductTradePrice               | 12       |
   | 2     |       |       | OccurreDateTime                           | .        |  
   | 2     |       |       | DeliveryNoteIssuerAssignedID              | 1188A    |
   | 2     |       |       | DeliveryNoteLineID                        | 20       |
   | 2     |       |       | DeliveryNoteIssueDateTime                 | .        |
   | 2     |       |       | BuyerOrderIssuerAssignedID                | 1188     |
   | 2     |       |       | BuyerOrderLineID                          | 20       |
   | 2     |       |       | BuyerOrderIssueDateTime                   | .        |
   | 3     |       |       | GlobalID                                  | GTIN-E1  |
   | 3     |       |       | BilledQuantityUnitCode                    | H87      |
   | 3     |       |       | BilledQuantity                            | 5        |
   | 3     |       |       | NetPriceProductTradePrice                 | 10       |
   | 3     |       |       | LineTotalAmount                           | 50       |
   | 3     |       |       | GrossPriceProductTradePrice               | 10       |
   | 3     |       |       | OccurreDateTime                           | .        |  
   | 3     |       |       | DeliveryNoteIssuerAssignedID              | 1188B    |
   | 3     |       |       | DeliveryNoteLineID                        | 10       |
   | 3     |       |       | DeliveryNoteIssueDateTime                 | .        |
   | 3     |       |       | BuyerOrderIssuerAssignedID                | 1188     |
   | 3     |       |       | BuyerOrderLineID                          | 10       |
   | 3     |       |       | BuyerOrderIssueDateTime                   | .        |
   | 4     |       |       | GlobalID                                  | GTIN-E2  | 
   | 4     |       |       | BilledQuantityUnitCode                    | H87      |
   | 4     |       |       | BilledQuantity                            | 10       |
   | 4     |       |       | NetPriceProductTradePrice                 | 12       |
   | 4     |       |       | LineTotalAmount                           | 120      |
   | 4     |       |       | GrossPriceProductTradePrice               | 12       |
   | 4     |       |       | OccurreDateTime                           | .        |  
   | 4     |       |       | DeliveryNoteIssuerAssignedID              | 1188B    |
   | 4     |       |       | DeliveryNoteLineID                        | 20       |
   | 4     |       |       | DeliveryNoteIssueDateTime                 | .        |
   | 4     |       |       | BuyerOrderIssuerAssignedID                | 1188     |
   | 4     |       |       | BuyerOrderLineID                          | 20       |
   | 4     |       |       | BuyerOrderIssueDateTime                   | .        |   
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: BESTELLUNG 8 UND 9 - Extended Format 2 BE -> 2 LI -> 1 E-Rechnung

Given I open an editor "BESTELLUNG8" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | ZFLI2  |
   | frzeich | 1191   |
And I append rows  
   | pnum | artikel | mge | preis |
   | 10   | E1      | 10  | 10    |
And I save the current editor

Given I open an editor "LIEFER8A" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG8"
And I set fields
   | ebeleg  | 1191A    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "5" in row 1
And I save the current editor

Given I open an editor "LIEFER8B" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG8"
And I set fields
   | ebeleg  | 1191B    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "5" in row 1
And I save the current editor

Given I open an editor "BESTELLUNG9" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | ZFLI2  |
   | frzeich | 1192   |
And I append rows  
   | pnum | artikel | mge | preis |
   | 20   | E2      | 20  | 12    |
And I save the current editor

Given I open an editor "LIEFER9A" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG9"
And I set fields
   | ebeleg  | 1192A    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "LIEFER9B" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG9"
And I set fields
   | ebeleg  | 1192B    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "10" in row 1
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: EDI-NACHRICHT MIT ZUGFERD-RECHNUNGS-TEILEN ERSTELLEN 7

Given I open an editor "EZF8" from table "(EDI):(EDI)" with command "NEW" for record ""
And I set fields
  | such       | ZF8                    |
  | name       | TEST                   |
  | edinachraz | (ZUGFeRDInvoiceImport) |
  | ediimex    | IM                     |
  | glabkunde  | gln2                   |
  | kenn       | steunr2/DE222          |
And I delete all rows
And I append rows
   | text1 | text2 | text3 | text4                                     | text5    |
   | 0     |       |       | BuyerTradePartySpecifiedTaxRegistration   | 28839934 |  
   | 0     |       |       | SellerTradePartySpecifiedTaxRegistration  | DE222    | 
   | 0     |       |       | ExchangedDocumentID                       |          |
   | 0     |       |       | SpecifiedTradePaymentMeans                | 30       |
   | 0     |       |       | SpecifiedTradePaymentTermsDueDateDateTime | .        | 
   | 0     |       |       | PayeePartyCreditorFinancialAccountIBANID  | 12345678 |
   | 0     |       |       | IssueDateTime                             | .        |
   | 0     |       |       | DeliveryDateTime                          | .        |
   | 0     |       |       | kLineTotalAmount                          | 340,00   |
   | 1     |       |       | GlobalID                                  | GTIN-E1  |
   | 1     |       |       | BilledQuantityUnitCode                    | H87      |
   | 1     |       |       | BilledQuantity                            | 5        |
   | 1     |       |       | NetPriceProductTradePrice                 | 10       |
   | 1     |       |       | LineTotalAmount                           | 50       |
   | 1     |       |       | GrossPriceProductTradePrice               | 10       |
   | 1     |       |       | OccurreDateTime                           | .        |  
   | 1     |       |       | DeliveryNoteIssuerAssignedID              | 1191A    |
   | 1     |       |       | DeliveryNoteLineID                        | 10       |
   | 1     |       |       | DeliveryNoteIssueDateTime                 | .        |
   | 1     |       |       | BuyerOrderIssuerAssignedID                | 1191     |
   | 1     |       |       | BuyerOrderLineID                          | 10       |
   | 1     |       |       | BuyerOrderIssueDateTime                   | .        |
   | 2     |       |       | GlobalID                                  | GTIN-E1  | 
   | 2     |       |       | BilledQuantityUnitCode                    | H87      |
   | 2     |       |       | BilledQuantity                            | 5        |
   | 2     |       |       | NetPriceProductTradePrice                 | 10       |
   | 2     |       |       | LineTotalAmount                           | 50       |
   | 2     |       |       | GrossPriceProductTradePrice               | 10       |
   | 2     |       |       | OccurreDateTime                           | .        |  
   | 2     |       |       | DeliveryNoteIssuerAssignedID              | 1191B    |
   | 2     |       |       | DeliveryNoteLineID                        | 10       |
   | 2     |       |       | DeliveryNoteIssueDateTime                 | .        |
   | 2     |       |       | BuyerOrderIssuerAssignedID                | 1191     |
   | 2     |       |       | BuyerOrderLineID                          | 10       |
   | 2     |       |       | BuyerOrderIssueDateTime                   | .        |
   | 3     |       |       | GlobalID                                  | GTIN-E2  |
   | 3     |       |       | BilledQuantityUnitCode                    | H87      |
   | 3     |       |       | BilledQuantity                            | 10       |
   | 3     |       |       | NetPriceProductTradePrice                 | 12       |
   | 3     |       |       | LineTotalAmount                           | 120      |
   | 3     |       |       | GrossPriceProductTradePrice               | 12       |
   | 3     |       |       | OccurreDateTime                           | .        |  
   | 3     |       |       | DeliveryNoteIssuerAssignedID              | 1192A    |
   | 3     |       |       | DeliveryNoteLineID                        | 20       |
   | 3     |       |       | DeliveryNoteIssueDateTime                 | .        |
   | 3     |       |       | BuyerOrderIssuerAssignedID                | 1192     |
   | 3     |       |       | BuyerOrderLineID                          | 20       |
   | 3     |       |       | BuyerOrderIssueDateTime                   | .        |
   | 4     |       |       | GlobalID                                  | GTIN-E2  | 
   | 4     |       |       | BilledQuantityUnitCode                    | H87      |
   | 4     |       |       | BilledQuantity                            | 10       |
   | 4     |       |       | NetPriceProductTradePrice                 | 12       |
   | 4     |       |       | LineTotalAmount                           | 120      |
   | 4     |       |       | GrossPriceProductTradePrice               | 12       |
   | 4     |       |       | OccurreDateTime                           | .        |  
   | 4     |       |       | DeliveryNoteIssuerAssignedID              | 1192B    |
   | 4     |       |       | DeliveryNoteLineID                        | 20       |
   | 4     |       |       | DeliveryNoteIssueDateTime                 | .        |
   | 4     |       |       | BuyerOrderIssuerAssignedID                | 1192     |
   | 4     |       |       | BuyerOrderLineID                          | 20       |
   | 4     |       |       | BuyerOrderIssueDateTime                   | .        |   
And I save the current editor


# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
# 
# E-Rechnungen zu mehreren Bestellungen, ohne LSFAKT (kann auch beim ZUGFeRD-Export von Abas ERP erstellt werden)
# -> 2x 1 Bestellung + 1 Lieferschein OHNE Fakturieren aus Lieferschein
#
# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: BESTELLUNG 10 UND 11 - Extended Format 2 x BE+LI -> 1 E-Rechnung

Given I open an editor "BESTELLUNG10" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | ZFLI2  |
   | frzeich | 1194   |
And I append rows  
   | pnum | artikel | mge | preis |
   | 10   | E1      | 10  | 10    |
And I save the current editor

Given I open an editor "LIEFER10" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG10"
And I set fields
   | ebeleg  | 1194A    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "BESTELLUNG11" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | ZFLI2  |
   | frzeich | 1193   |
And I append rows  
   | pnum | artikel | mge | preis |
   | 20   | E2      | 20  | 12    |
And I save the current editor

Given I open an editor "LIEFER11" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG11"
And I set fields
   | ebeleg  | 1193A    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
   | fakt    | nein     |
And I set field "mge" to "20" in row 1
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: EDI-NACHRICHT MIT ZUGFERD-RECHNUNGS-TEILEN ERSTELLEN 10

Given I open an editor "EZF10" from table "(EDI):(EDI)" with command "NEW" for record ""
And I set fields
  | such       | ZF10                   |
  | name       | TEST                   |
  | edinachraz | (ZUGFeRDInvoiceImport) |
  | ediimex    | IM                     |
  | glabkunde  | gln2                   |
  | kenn       | steunr2/DE222          |
And I delete all rows
And I append rows
   | text1 | text2 | text3 | text4                                     | text5    |
   | 0     |       |       | BuyerTradePartySpecifiedTaxRegistration   | 28839934 |  
   | 0     |       |       | SellerTradePartySpecifiedTaxRegistration  | DE222    | 
   | 0     |       |       | ExchangedDocumentID                       |          |
   | 0     |       |       | SpecifiedTradePaymentMeans                | 30       |
   | 0     |       |       | SpecifiedTradePaymentTermsDueDateDateTime | .        | 
   | 0     |       |       | PayeePartyCreditorFinancialAccountIBANID  | 12345678 |
   | 0     |       |       | IssueDateTime                             | .        |
   | 0     |       |       | DeliveryDateTime                          | .        |
   | 0     |       |       | kLineTotalAmount                          | 340,00   |
   | 1     |       |       | GlobalID                                  | GTIN-E1  |
   | 1     |       |       | BilledQuantityUnitCode                    | H87      |
   | 1     |       |       | BilledQuantity                            | 10       |
   | 1     |       |       | NetPriceProductTradePrice                 | 10       |
   | 1     |       |       | LineTotalAmount                           | 100      |
   | 1     |       |       | GrossPriceProductTradePrice               | 10       |
   | 1     |       |       | OccurreDateTime                           | .        |  
   | 1     |       |       | DeliveryNoteIssuerAssignedID              | 1194A    |
   | 1     |       |       | DeliveryNoteLineID                        | 10       |
   | 1     |       |       | DeliveryNoteIssueDateTime                 | .        |
   | 1     |       |       | BuyerOrderIssuerAssignedID                | 1194     |
   | 1     |       |       | BuyerOrderLineID                          | 10       |
   | 1     |       |       | BuyerOrderIssueDateTime                   | .        |
   | 3     |       |       | GlobalID                                  | GTIN-E2  |
   | 3     |       |       | BilledQuantityUnitCode                    | H87      |
   | 3     |       |       | BilledQuantity                            | 20       |
   | 3     |       |       | NetPriceProductTradePrice                 | 12       |
   | 3     |       |       | LineTotalAmount                           | 250      |
   | 3     |       |       | GrossPriceProductTradePrice               | 12       |
   | 3     |       |       | OccurreDateTime                           | .        |  
   | 3     |       |       | DeliveryNoteIssuerAssignedID              | 1193A    |
   | 3     |       |       | DeliveryNoteLineID                        | 20       |
   | 3     |       |       | DeliveryNoteIssueDateTime                 | .        |
   | 3     |       |       | BuyerOrderIssuerAssignedID                | 1193     |
   | 3     |       |       | BuyerOrderLineID                          | 20       |
   | 3     |       |       | BuyerOrderIssueDateTime                   | .        |
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
#
# E-Rechnungen zu mehreren Bestellungen (kann  beim ZUGFeRD-Export von Abas ERP NICHT erstellt werden)
# Testdaten sollen prüfen, ob per Beleg-Anfuegen daraus eine EK-rechnung erstellt werden kann
# -> 2x 1 Bestellung + 1 Lieferschein mit "Fakturieren aus Lieferschein" + 1 Lieferschein OHNE Fakturieren aus Lieferschein
#
# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***


Scenario: BESTELLUNG 12 UND 13 - Extended Format 2 BE -> je 2 LI -> 1 E-Rechnung

Given I open an editor "BESTELLUNG12" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | ZFLI2  |
   | frzeich | 1195   |
And I append rows  
   | pnum | artikel | mge | preis |
   | 10   | E1      | 10  | 10    |
And I save the current editor

Given I open an editor "LIEFER12A" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG12"
And I set fields
   | ebeleg  | 1195A    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
   | fakt    | nein     |
And I set field "mge" to "5" in row 1
And I save the current editor

Given I open an editor "LIEFER12B" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG12"
And I set fields
   | ebeleg  | 1195B    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "5" in row 1
And I save the current editor

Given I open an editor "BESTELLUNG13" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | ZFLI2  |
   | frzeich | 1196   |
And I append rows  
   | pnum | artikel | mge | preis |
   | 20   | E2      | 20  | 12    |
And I save the current editor

Given I open an editor "LIEFER13A" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG13"
And I set fields
   | ebeleg  | 1196A    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "LIEFER13B" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG13"
And I set fields
   | ebeleg  | 1196B    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
   | fakt    | nein     |
And I set field "mge" to "10" in row 1
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: EDI-NACHRICHT MIT ZUGFERD-RECHNUNGS-TEILEN ERSTELLEN 12

Given I open an editor "EZF12" from table "(EDI):(EDI)" with command "NEW" for record ""
And I set fields
  | such       | ZF12                   |
  | name       | TEST                   |
  | edinachraz | (ZUGFeRDInvoiceImport) |
  | ediimex    | IM                     |
  | glabkunde  | gln2                   |
  | kenn       | steunr2/DE222          |
And I delete all rows
And I append rows
   | text1 | text2 | text3 | text4                                     | text5    |
   | 0     |       |       | BuyerTradePartySpecifiedTaxRegistration   | 28839934 |  
   | 0     |       |       | SellerTradePartySpecifiedTaxRegistration  | DE222    | 
   | 0     |       |       | ExchangedDocumentID                       |          |
   | 0     |       |       | SpecifiedTradePaymentMeans                | 30       |
   | 0     |       |       | SpecifiedTradePaymentTermsDueDateDateTime | .        | 
   | 0     |       |       | PayeePartyCreditorFinancialAccountIBANID  | 12345678 |
   | 0     |       |       | IssueDateTime                             | .        |
   | 0     |       |       | DeliveryDateTime                          | .        |
   | 0     |       |       | kLineTotalAmount                          | 340,00   |
   | 1     |       |       | GlobalID                                  | GTIN-E1  |
   | 1     |       |       | BilledQuantityUnitCode                    | H87      |
   | 1     |       |       | BilledQuantity                            | 5        |
   | 1     |       |       | NetPriceProductTradePrice                 | 10       |
   | 1     |       |       | LineTotalAmount                           | 50       |
   | 1     |       |       | GrossPriceProductTradePrice               | 10       |
   | 1     |       |       | OccurreDateTime                           | .        |  
   | 1     |       |       | DeliveryNoteIssuerAssignedID              | 1195A    |
   | 1     |       |       | DeliveryNoteLineID                        | 10       |
   | 1     |       |       | DeliveryNoteIssueDateTime                 | .        |
   | 1     |       |       | BuyerOrderIssuerAssignedID                | 1195     |
   | 1     |       |       | BuyerOrderLineID                          | 10       |
   | 1     |       |       | BuyerOrderIssueDateTime                   | .        |
   | 2     |       |       | GlobalID                                  | GTIN-E1  | 
   | 2     |       |       | BilledQuantityUnitCode                    | H87      |
   | 2     |       |       | BilledQuantity                            | 5        |
   | 2     |       |       | NetPriceProductTradePrice                 | 10       |
   | 2     |       |       | LineTotalAmount                           | 50       |
   | 2     |       |       | GrossPriceProductTradePrice               | 10       |
   | 2     |       |       | OccurreDateTime                           | .        |  
   | 2     |       |       | DeliveryNoteIssuerAssignedID              | 1195B    |
   | 2     |       |       | DeliveryNoteLineID                        | 10       |
   | 2     |       |       | DeliveryNoteIssueDateTime                 | .        |
   | 2     |       |       | BuyerOrderIssuerAssignedID                | 1195     |
   | 2     |       |       | BuyerOrderLineID                          | 10       |
   | 2     |       |       | BuyerOrderIssueDateTime                   | .        |
   | 3     |       |       | GlobalID                                  | GTIN-E2  |
   | 3     |       |       | BilledQuantityUnitCode                    | H87      |
   | 3     |       |       | BilledQuantity                            | 10       |
   | 3     |       |       | NetPriceProductTradePrice                 | 12       |
   | 3     |       |       | LineTotalAmount                           | 120      |
   | 3     |       |       | GrossPriceProductTradePrice               | 12       |
   | 3     |       |       | OccurreDateTime                           | .        |  
   | 3     |       |       | DeliveryNoteIssuerAssignedID              | 1196A    |
   | 3     |       |       | DeliveryNoteLineID                        | 20       |
   | 3     |       |       | DeliveryNoteIssueDateTime                 | .        |
   | 3     |       |       | BuyerOrderIssuerAssignedID                | 1196     |
   | 3     |       |       | BuyerOrderLineID                          | 20       |
   | 3     |       |       | BuyerOrderIssueDateTime                   | .        |
   | 4     |       |       | GlobalID                                  | GTIN-E2  | 
   | 4     |       |       | BilledQuantityUnitCode                    | H87      |
   | 4     |       |       | BilledQuantity                            | 10       |
   | 4     |       |       | NetPriceProductTradePrice                 | 12       |
   | 4     |       |       | LineTotalAmount                           | 120      |
   | 4     |       |       | GrossPriceProductTradePrice               | 12       |
   | 4     |       |       | OccurreDateTime                           | .        |  
   | 4     |       |       | DeliveryNoteIssuerAssignedID              | 1196B    |
   | 4     |       |       | DeliveryNoteLineID                        | 20       |
   | 4     |       |       | DeliveryNoteIssueDateTime                 | .        |
   | 4     |       |       | BuyerOrderIssuerAssignedID                | 1196     |
   | 4     |       |       | BuyerOrderLineID                          | 20       |
   | 4     |       |       | BuyerOrderIssueDateTime                   | .        |   
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
# 
# E-Rechnungen zu mehreren Bestellungen, 1 BE hat noch keinen Lieferschein
# -> 1 Bestellung + 1 Lieferschein MIT Fakturieren aus Lieferschein
# -> 1 Bestellung + ohne Lieferschein !!!
#
# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: BESTELLUNG 14 UND 15 - Extended Format 1 x BE+LI und 1x nur BE -> 1 E-Rechnung

Given I open an editor "BESTELLUNG14" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | ZFLI2  |
   | frzeich | 1197   |
And I append rows  
   | pnum | artikel | mge | preis |
   | 10   | E1      | 10  | 10    |
And I save the current editor

Given I open an editor "LIEFER14" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESTELLUNG14"
And I set fields
   | ebeleg  | 1197A    |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "BESTELLUNG15" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | ZFLI2  |
   | frzeich | 1198   |
And I append rows  
   | pnum | artikel | mge | preis |
   | 20   | E2      | 20  | 12    |
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: EDI-NACHRICHT MIT ZUGFERD-RECHNUNGS-TEILEN ERSTELLEN 14

Given I open an editor "EZF14" from table "(EDI):(EDI)" with command "NEW" for record ""
And I set fields
  | such       | ZF14                   |
  | name       | TEST                   |
  | edinachraz | (ZUGFeRDInvoiceImport) |
  | ediimex    | IM                     |
  | glabkunde  | gln2                   |
  | kenn       | steunr2/DE222          |
And I delete all rows
And I append rows
   | text1 | text2 | text3 | text4                                     | text5    |
   | 0     |       |       | BuyerTradePartySpecifiedTaxRegistration   | 28839934 |  
   | 0     |       |       | SellerTradePartySpecifiedTaxRegistration  | DE222    | 
   | 0     |       |       | ExchangedDocumentID                       |          |
   | 0     |       |       | SpecifiedTradePaymentMeans                | 30       |
   | 0     |       |       | SpecifiedTradePaymentTermsDueDateDateTime | .        | 
   | 0     |       |       | PayeePartyCreditorFinancialAccountIBANID  | 12345678 |
   | 0     |       |       | IssueDateTime                             | .        |
   | 0     |       |       | DeliveryDateTime                          | .        |
   | 0     |       |       | kLineTotalAmount                          | 340,00   |
   | 1     |       |       | GlobalID                                  | GTIN-E1  |
   | 1     |       |       | BilledQuantityUnitCode                    | H87      |
   | 1     |       |       | BilledQuantity                            | 5        |
   | 1     |       |       | NetPriceProductTradePrice                 | 10       |
   | 1     |       |       | LineTotalAmount                           | 50       |
   | 1     |       |       | GrossPriceProductTradePrice               | 10       |
   | 1     |       |       | OccurreDateTime                           | .        |  
   | 1     |       |       | DeliveryNoteIssuerAssignedID              | 1197A    |
   | 1     |       |       | DeliveryNoteLineID                        | 10       |
   | 1     |       |       | DeliveryNoteIssueDateTime                 | .        |
   | 1     |       |       | BuyerOrderIssuerAssignedID                | 1197     |
   | 1     |       |       | BuyerOrderLineID                          | 10       |
   | 1     |       |       | BuyerOrderIssueDateTime                   | .        |
   | 3     |       |       | GlobalID                                  | GTIN-E2  |
   | 3     |       |       | BilledQuantityUnitCode                    | H87      |
   | 3     |       |       | BilledQuantity                            | 20       |
   | 3     |       |       | NetPriceProductTradePrice                 | 12       |
   | 3     |       |       | LineTotalAmount                           | 240      |
   | 3     |       |       | GrossPriceProductTradePrice               | 12       |
   | 3     |       |       | OccurreDateTime                           | .        |  
   | 3     |       |       | BuyerOrderIssuerAssignedID                | 1198     |
   | 3     |       |       | BuyerOrderLineID                          | 20       |
   | 3     |       |       | BuyerOrderIssueDateTime                   | .        |
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
