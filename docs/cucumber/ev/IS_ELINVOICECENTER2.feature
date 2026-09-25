@persistent
Feature: Komfortfunktion im Infosystem ELINVOICECENTER

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: Lieferanten konfigurieren

Given I open an editor "LI1" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
  | nummer   | 24000   |
  | such     | LI1     |
  | steunr   | steunr1 |
  | ustid    | DE123   |
  | gln      | gln1    |
And I save the current editor

Given I open an editor "LI1" from table "(Vendor):(Vendor)" with command "UPDATE" for record "24000"
And I press button "edinfo" to open a subeditor for "EDIInfo"
And I append rows
  | edinachraz             | erlaubt | ieabmodell | suchkonfig | abmodell |
  | (ZUGFeRDInvoiceImport) | ja      | 4160       | 11003      | 4161     |
And I save the current editor
And I switch the current editor to editor "LI1"
And I save the current editor

Given I open an editor "LI2" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
  | nummer   | 24002   |
  | such     | LI2     |
  | steunr   | steunr2 |
  | ustid    | DE124   |
  | gln      | gln2    |
And I save the current editor

Given I open an editor "LI2" from table "(Vendor):(Vendor)" with command "UPDATE" for record "24002"
And I press button "edinfo" to open a subeditor for "EDIInfo"
And I append rows
  | edinachraz             | erlaubt | ieabmodell | suchkonfig | abmodell |
  | (ZUGFeRDInvoiceImport) | ja      | 4190       | 11003      | 4191     |
And I save the current editor
And I switch the current editor to editor "LI2"
And I save the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

# Infosystem ELINVOICECENTER kann START

Scenario: Infosystem ELINVOICECENTER: drei neue E-Rechnungen importieren und anzeigen
Given I open the infosystem "ELINVOICECENTER"
And I set field "datumv" to ""
And I set field "datumb" to ""
And I press button "buimport"
Then the table has 6 rows
And table has values
  | edinr | edipartner | ediobjsuch | vabmodell | fotoz      | edipartnerfehler                                |
  | 5     |            |            |           | icon:stop  | Der Absender konnte nicht ermittelt werden.     |
  | 6     |            |            |           | icon:stop  | Der Absender konnte nicht ermittelt werden.     |
  | 7     |            |            |           | icon:stop  | Der Absender konnte nicht ermittelt werden.     |
  | 8     |            |            |           | icon:stop  | Der Absender konnte nicht ermittelt werden.     |
  | 9     |            |            |           | icon:stop  | Der Absender konnte nicht ermittelt werden.     |
  | 10    |            |            |           | icon:stop  | Der Absender konnte nicht ermittelt werden.     |
And I close the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

Scenario: Infosystem ELINVOICECENTER: 1 Zeile von Kopfbutton aus vorbereiten
Given I open the infosystem "ELINVOICECENTER"
And I set field "datumv" to ""
And I set field "datumb" to ""
And I press button "bstart"
And the table has 6 rows
And I set field "tmark" to "1" in row 5
And I press button "kbuidentifizierenunduebernehmen"
Then table has values
  | edinr | edipartner | ediobjsuch | vabmodell | fotoz           | edipartnerfehler |
  | 5     |            |            |           | icon:ball_blue  |                  |
  | 6     |            |            |           | icon:ball_blue  |                  |
  | 7     |            |            |           | icon:ball_blue  |                  |
  | 8     |            |            |           | icon:ball_blue  |                  |
  | 9     |            |            |           | icon:stop       | Der Absender konnte nicht ermittelt werden. |
  | 10    |            |            |           | icon:ball_blue  |                  |
And I close the current editor

# *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
