# *****************************************************************************
#  Name             : ref_op_vk_re_edit.feature
#  Verantwortlich   : hc
#  Kontrolle        : dago
# *****************************************************************************
@persistent
Feature: Belegung der ZV-relevanten Felder in der VK-Rechnung

Background:
Given I set the fake date to "31.12.2022"

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Verkauf SEPA Lastschritmandat, Zahlungsart "Ueberweisung"
# ----------------------------------------------------------------------------------------------
Given I open an editor "SEPA_LASTSCHRIFT_888" from table "(PaymentMasterFiles):(SEPADirectDebitMandateSales)" with command "NEW" for record ""
And I set fields
   | num66    | 888       |
   | such66   | SEPA888   |
   | sepacred | DEZZZZ    |
   | debitor  | 1         |
   | sepamref | Mandat_vk |
And I save the current editor

# Kunde 1: SEPA-Lastschriftmandat hinterlegen
Given I open an editor "Kunde1_Lastschrift" from table "(Customer):(Customer)" with command "UPDATE" for record "1"
And I set fields
   | zaform   | Lastschrift |
   | sepamand | 888         |
And I save the current editor

# Kunde 4: Ueberweisung
Given I open an editor "Kunde4_Ueberweisung" from table "(Customer):(Customer)" with command "UPDATE" for record "4"
And I set fields
   | zaform   | Überweisung |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Verkauf - Rechnung erzeugen, kopieren, SEPA Mandat aktualisieren, leeren, Zahlungsart "Lastschrift" setzen
# ----------------------------------------------------------------------------------------------
# Rechnung fuer Rechnungsempfaenger 1 (mit SEPA Lastschrift)
Given I open an editor "RE01_VK" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | kunde    | 1           |
   | kl2      | 1           |
   | such     | RE01VK      |
   | tterm    | .           |
   | vom      | .           |
   | fakt     | ja          |
   | zaform   | Lastschrift |
   | sepamand | 888         |
And I append rows
   | artikel | mge | preis |
   | V1      | 15  | 20    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# SEPA-Mandat wird mitkopiert
Given I open an editor "RE01_VK_B" from table "(Sales):(Invoice)" with command "COPY" for record from editor "RE01_VK"
Then field "zaform" has value "Lastschrift"
Then field "sepamand" has value "888"
And I close the current editor

# Kunde in Rechnung wechseln, SEPA-Daten aus Rechnungsempfaenger uebernehmen
Given I open an editor "RE01_VK_KU" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE01_VK"
And I set fields
   | kunde | 2 |
   | tterm | . |
Then field "zaform" has value "Überweisung"
Then field "sepamand" has value ""
And I save the current editor

# Sepa-Mandat leer?
Given I open an editor "RE01_VK_SEPA_LEER" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE01_VK"
And I set fields
   | kl2   | 5 |
   | tterm | . |
Then field "zaform" has value ""
Then field "sepamand" has value ""
And I save the current editor

# Kunde 1: Rechnungsempfaenger auf Kunde 1 wechseln
Given I open an editor "Kunde1" from table "(Customer):(Customer)" with command "UPDATE" for record "1"
And I set fields
   | reempf | 1 |
And I save the current editor

# Kunde 1 eintragen, pruefen sepamand und zaform aus Kunde 1 uebernommen?
Given I open an editor "RE01_VK_C" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE01_VK"
And I set fields
   | kunde | 1 |
Then field "zaform" has value "Lastschrift"
Then field "sepamand" has value "888"
And I close the current editor

# Kunde 1: Rechnungsempfaenger auf Kunde 4 zurueck
Given I open an editor "Kunde1" from table "(Customer):(Customer)" with command "UPDATE" for record "1"
And I set fields
   | reempf | 4 |
And I save the current editor

# Kunde in Rechnung wechseln, Daten aus Rechnungsempfaenger uebernehmen
Given I open an editor "RE01_VK_KU" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE01_VK"
And I set fields
   | kunde | 1 |
   | tterm | . |
Then field "reempf" has value "4"
Then field "zaform" has value "Überweisung"
Then field "sepamand" has value ""
And I save the current editor

# Sepa-Mandat fuer Rechnungsempfaenger uebernehmen
Given I open an editor "RE01_VK_SEPA_LEER2" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE01_VK"
And I set fields
   | kl2 | 1 |
Then field "zaform" has value "Lastschrift"
Then field "sepamand" has value "888"
# SEPA-Mandat leer, nachdem Zahlungsart geaendert wurde (keine Lastschrift mehr)
And I set fields
   | zaform | Wechsel |
Then field "sepamand" has value ""
And I close the current editor
