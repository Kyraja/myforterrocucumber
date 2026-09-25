@persistent
Feature: Infosystem ELINVOICECENTER starten und Partner identifizieren

# Infosystem ELINVOICECENTER kann START

Scenario: Infosystem ELINVOICECENTER ausfueheren ohne zu verarbeitenden Nachrichten
Given I open the infosystem "ELINVOICECENTER"
And I set field "datumv" to ""
And I set field "datumb" to ""
And I press button "bstart"
Then the table has 0 rows
And I close the current editor

# Infosystem ELINVOICECENTER zeigt eine ZUGFERD-Nachricht

Scenario: Infosystem ELINVOICECENTER ausfuehren nachdem vorher eine Rumpf-Nachricht erstellt wurde
Given I open an editor "EZF1" from table "(EDI):(EDI)" with command "NEW" for record ""
And I set fields
  | such       | ZF1                    |
  | name       | TEST                   |
  | edinachraz | (ZUGFeRDInvoiceImport) |
  | ediimex    | IM                     |
And I save the current editor

Given I open the infosystem "ELINVOICECENTER"
And I set field "datumv" to ""
And I set field "datumb" to ""
And I press button "bstart"
Then the table has 1 rows
And I close the current editor

Given I open an editor "EZF1" from table "(EDI):(EDI)" with command "UPDATE" for record "ZF1"
And I set fields
| glabkunde | gln1           |
| kenn      | steunr1/DE123  |
And I save the current editor

Given I open the infosystem "ELINVOICECENTER"
And I set field "datumv" to ""
And I set field "datumb" to ""
And I press button "bstart"
Then the table has 1 rows
And table has values
    | edipartnergln | edipartnerustid | edipartnersteuernummer | edipartner | ediobjsuch | vabmodell |
    | gln1          | DE123           | STEUNR1                |            |            |           |
And I close the current editor

# Infosystem ELINVOICECENTER sucht den Nachrichtenpartner

Scenario: Infosystem ELINVOICECENTER ausfuehren und Partner suchen,  nachdem der Partner angelegt wurde

Given I open an editor "LI1" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
  | nummer   | 24000   |
  | such     | LI1     |
  | steunr   | steunr1 |
  | ustid    | DE123   |
  | gln      | gln1    |
And I save the current editor

Given I open the infosystem "ELINVOICECENTER"
And I set field "datumv" to ""
And I set field "datumb" to ""
And I press button "bstart"
And the table has 1 rows
And I set field "tmark" to "1" in row 1
And table has values
  | edipartnergln | edipartnerustid | edipartnersteuernummer | edipartner | ediobjsuch | vabmodell | tmark |
  | gln1          | DE123           | STEUNR1                |            |            |           | ja    |
And I press button "kbupartneridentifizieren"
Then the table has 1 rows
And table has values
  | edipartnergln | edipartnerustid | edipartnersteuernummer | edipartner | ediobjsuch | vabmodell | tmark |
  | gln1          | DE123           | STEUNR1                | L 24000    |            |           | ja    |
And I close the current editor

# Infosystem ELINVOICECENTER sucht den Nachrichtenpartner und schreibt gefundenen Partner in die EDI-Nachricht

Scenario: Infosystem ELINVOICECENTER ausfuehren und Partner suchen,  nachdem der Partner und Nachrichtenkonfig angelegt wurde

Given I open an editor "LI1" from table "(Vendor):(Vendor)" with command "UPDATE" for record "24000"
And I press button "edinfo" to open a subeditor for "EDIInfo"
And I append rows
  | edinachraz             | erlaubt | ieabmodell | suchkonfig | abmodell |
  | (ZUGFeRDInvoiceImport) | ja      | 4160       | 11003      | 4161     |
And I save the current editor
And I switch the current editor to editor "LI1"
And I save the current editor

Given I open the infosystem "ELINVOICECENTER"
And I set field "datumv" to ""
And I set field "datumb" to ""
And I press button "bstart"
And the table has 1 rows
And I set field "tmark" to "1" in row 1
And table has values
  | edipartnergln | edipartnerustid | edipartnersteuernummer | edipartner | ediobjsuch | vabmodell | tmark |
  | gln1          | DE123           | STEUNR1                |            |            |           | ja    |
And I press button "kbupartneridentifizieren"
And the table has 1 rows
And table has values
  | edipartnergln | edipartnerustid | edipartnersteuernummer | edipartner | ediobjsuch | vabmodell | tmark |
  | gln1          | DE123           | STEUNR1                | L 24000    | 11003      | 4161      | ja    |
And I press button "bstart"
Then the table has 1 rows
And table has values
  | edipartnergln | edipartnerustid | edipartnersteuernummer | edipartner | ediobjsuch | vabmodell | tmark |
  | gln1          | DE123           | STEUNR1                |            |            |           | nein  |
  # ohne "kbupartneruebernehmen" wurde nicht gespeichert
And I close the current editor

Given I open the infosystem "ELINVOICECENTER"
And I set field "datumv" to ""
And I set field "datumb" to ""
And I press button "bstart"
Then the table has 1 rows
And I set field "tmark" to "1" in row 1
And I press button "kbupartneridentifizieren"
And I press button "kbupartneruebernehmen"
And I press button "bstart"
Then the table has 1 rows
And table has values
  | edipartnergln | edipartnerustid | edipartnersteuernummer | edipartner | ediobjsuch | vabmodell | tmark  | vorgangstyp | edidatenart |
  | gln1          | DE123           | STEUNR1                | L 24000    | 11003      | 4161      | nein   |             |             |
  # jetzt ist auch nach neuem START der identifizierte Partner und das vabmodell ausgefuellt
And I close the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: Selektion nach Absender in Infosystem ELINVOICECENTER

# there is only 1 edi message, and it is assigned to LI1
# query with LI1 has 1 row
# query with LI2 has 0 rows

Given I open an editor "LI2" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
  | nummer   | 24002   |
  | such     | LI2     |
  | steunr   | steunr2 |
  | ustid    | DE124   |
  | gln      | gln2    |
And I save the current editor

Given I open the infosystem "ELINVOICECENTER"
And I set field "kgeschaeftspartner" to "L LI2"
And I press button "bstart"
Then the table has 0 rows
And I close the current editor

Given I open the infosystem "ELINVOICECENTER"
And I set field "kgeschaeftspartner" to "L LI1"
And I press button "bstart"
Then the table has 1 rows
And I close the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: EDI-Konfig fuer LI2 mit erlaubt=nein

Given I open an editor "LI2" from table "(Vendor):(Vendor)" with command "UPDATE" for record "24002"
And I press button "edinfo" to open a subeditor for "EDIInfo"
And I append rows
  | edinachraz             | erlaubt | ieabmodell | suchkonfig | abmodell |
  | (ZUGFeRDInvoiceImport) | nein    | 4190       | 11003      | 4191     |
And I save the current editor
And I switch the current editor to editor "LI2"
And I save the current editor


Scenario: ZF2-Nachricht fuer LI2

Given I open an editor "EZF2" from table "(EDI):(EDI)" with command "NEW" for record ""
And I set fields
  | such       | ZF2                    |
  | name       | TEST                   |
  | edinachraz | (ZUGFeRDInvoiceImport) |
  | ediimex    | IM                     |
  | glabkunde  | gln2                   |
  | kenn       | steunr2/DE124          |
And I save the current editor

Given I open the infosystem "ELINVOICECENTER"
And I set field "datumv" to ""
And I set field "datumb" to ""
And I press button "bstart"
Then the table has 2 rows
And table has values
  | edipartnergln | edipartnerustid | edipartnersteuernummer | edipartner | ediobjsuch | vabmodell | ediaktiv  |
  | gln1          | DE123           | STEUNR1                | L 24000    | 11003      | 4161      | ja        |
  | gln2          | DE124           | STEUNR2                |            |            |           | nein      |
And I close the current editor

