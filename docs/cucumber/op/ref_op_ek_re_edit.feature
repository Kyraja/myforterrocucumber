# *****************************************************************************
#  Name             : ref_op_ek_re_edit.feature
#  Verantwortlich   : hc
#  Kontrolle        : dago
# *****************************************************************************
@persistent
Feature: Belegung der ZV-relevanten Felder in der EK-Rechnung

Background:
Given I set the fake date to "31.12.2022"

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Einkauf SEPA Lastschritmandat
# ----------------------------------------------------------------------------------------------
Given I open an editor "SEPA_LASTSCHRIFT_777" from table "(PaymentMasterFiles):(SEPADirectDebitMandatePurchasing)" with command "NEW" for record ""
And I set fields
   | num66    | 777       |
   | such66   | SEPA777   |
   | kreditor | L 1       |
   | sepacred | DEAAAA    |
   | sepamref | Mandat_ek |
And I save the current editor

# Lieferant 1: SEPA-Lastschriftmandat hinterlegen
Given I open an editor "Lieferant1" from table "(Vendor):(Vendor)" with command "UPDATE" for record "1"
And I set fields
   | zaform   | Lastschrift |
   | sepamand | 777         |
And I save the current editor

# Lieferant 001: Ueberweisung
Given I open an editor "Lieferant001_Ueberweisung" from table "(Vendor):(Vendor)" with command "UPDATE" for record "001"
And I set fields
   | zaform   | Überweisung |
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: EK - Rechnung erzeugen, kopieren, SEPA-Mandat aktualisieren, leeren und Zahlungsart "Lastschrift" setzen
# ---------------------------------------------------------------------------------------------
# Rechnung fuer Rechnungssteller 1 (mit SEPA-Lastschrift)
Given I open an editor "RE01_EK" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | lief     | 1           |
   | kl2      | 1           |
   | such     | RE01EK      |
   | tterm    | .           |
   | vom      | .           |
   | fakt     | ja          |
   | ebeleg   | RE01        |
   | zaform   | Lastschrift |
   | sepamand | 777         |
And I append rows
   | artikel | mge | preis |
   | E1      | 15  | 20    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# SEPA-Mandat wird mitkopiert
Given I open an editor "RE01_EK_KOPIE" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "RE01_EK"
Then field "zaform" has value "Lastschrift"
Then field "sepamand" has value "777"
And I close the current editor

# Lieferant in Rechnung wechseln, SEPA-Daten aus Rechnungssteller uebernehmen
Given I open an editor "RE01_EK_KU" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE01_EK"
And I set fields
   | lief  | 001 |
   | tterm | .   |
Then field "zaform" has value "Überweisung"
Then field "sepamand" has value ""
And I save the current editor

# SEPA-Mandat leer?
Given I open an editor "RE01_EK_SEPA_LEER" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE01_EK"
And I set fields
   | kl2 | 003 |
Then field "zaform" has value ""
Then field "sepamand" has value ""
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# SEPA-Mandat fuer Lieferanten uebernehmen
Given I open an editor "RE01_EK_SEPA_LEER_2" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE01_EK"
And I set fields
   | kl2 | 1 |
Then field "zaform" has value "Lastschrift"
Then field "sepamand" has value "777"
# SEPA-Mandat leer, nachdem Zahlungsart geaendert wurde (keine Lastschrift mehr)
And I set fields
   | zaform | Scheck |
Then field "sepamand" has value ""
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
