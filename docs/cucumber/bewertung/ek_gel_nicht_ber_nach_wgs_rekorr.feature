# *****************************************************************************
#  Name           : ek_gel_nicht_ber_nach_wgs_rekorr.feature
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Darstellung von nicht berechneten, gelieferten Bestaenden im Einkauf
#                   
#
# *****************************************************************************
@persistent
Feature: ref_ek_gel_nicht_ber_nach_wgs_rekorr_cu
Background:
Given I set the fake date to "01.02.1995"

# -----------------------------------------------------------------------------------------------------------
Scenario: 01 Stammdaten (Lagerplaetze angleichen, Artikel anlegen) 
#-----------------------------------------------------------------------------------------------------------
#    RE 100 St vom 3.02.
#
#    100%-WGS vom 5.02.
#
#    Re-Korr über 80 St vom 8.02.
#
#    Re-Korr über 10 St vom 10.02.

Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "10100"
And I set field "such" to "K10100"
And I set field "namebspr" to "Rohstoffe"
And I save the current editor 
 
# -----------------------------------------------------------------------------------------------------------
Scenario: 02 BE - REmLB (m100) - 100% WGS - ReKorr1 (m80) - ReKorr2 (m10)
# brauchen wir den LS???
# -----------------------------------------------------------------------------------------------------------
# Bestellung
Given I set the fake date to "1.02.1995"
Given I open an editor "bestellung1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief     | 1      |
    | num4     | 100BE  |
    | such4    | BE100  |
    | vom      | .      |
    | ebeleg   | BE     |
    | erfwaehr | dem    |
    | budat    | .      |
And I append rows
| artikel | mge  | preis |konto      | ptext      |
| E1      | 100  | 10,00 | 10100     |            |
And I save the current editor
And I close the current editor

# Rechnung aus Bestellung
Given I set the fake date to "03.02.1995"
Given I open an editor "rechnung" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "bestellung1"
And I set field "num4" to "100RE"
And I set field "lief" to "1"
And I set field "erfwaehr" to "dem"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "fakt" to "ja"
And I press button "offueb" in row 1
And I set field "preis" to "20" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
   
# Wertgutschrift 
Given I set the fake date to "05.02.1995"
Given I open an editor "100-wgs1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+100RE"
And I set fields
   | nummer | 100WGS1 |
   | such   | WGS1100 |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    |  ja     |
And I press button "komplettieren"
Then the table has 4 rows
And I save the current editor

# Rechnungskorrektur 1
Given I set the fake date to "08.02.1995"
Given I open an editor "rechnung-korr1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+100RE"
And I set fields
   | nummer | 100RKOR1|
   | such   | REKORR1  |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
And I press button "burekorrektur"
And I set field "mge" to "80" in row 1
And I set field "preis" to "12" in row 1
And I save the current editor

# Rechnungskorrektur 2
Given I set the fake date to "10.02.1995"
Given I open an editor "rechnung-korr2" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+100RE"
And I set fields
   | nummer | 100RKOR2|
   | such   | REKORR2  |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
And I press button "burekorrektur"   
And I set field "mge" to "10" in row 1
And I save the current editor




