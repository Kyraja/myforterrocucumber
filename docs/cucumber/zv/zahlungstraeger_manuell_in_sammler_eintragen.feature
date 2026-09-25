# *****************************************************************************
#  Name             : zahlungstraeger_manuell_in_sammler_eintragen.feature
#  Autor            : jeffler
#  Verantwortlich   : hc
#  Kontrolle        : wane
#  Funktion         :
#
# *****************************************************************************
@persistent

Feature: zahlungstraeger_manuell_in_sammler_eintragen
Background: Zahlungsverkehr

Scenario: Überweisung anlegen und buchen - KEINE Bankdatei erzeugen

Given I open an editor "transfer" from table "(OIProcessing):(OutgoingPaymentsBankTransfers)" with command "NEW" for record ""
And I set field "gkonto" to "geldt"
And I set field "beleg" to "TEST"
And I set field "bdatauto" to "nein"
And I create a new row at the end of the table
And I set field "ophist" to "1" in row 1
And I press button "tueber" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

Scenario: sonstigen Zahlungsträger anlegen und buchen - KEINEN Zahlungsträgersammler erzeugen

Given I open an editor "paymentForm" from table "(OIProcessing):(OtherPayments)" with command "NEW" for record ""
And I set field "gkonto" to "geldt"
And I set field "beleg" to "TEST"
And I set field "zaeinaus" to "Zahlungsausgang"
And I set field "ztrsammauto" to "nein"
And I create a new row at the end of the table
And I set field "ophist" to "7" in row 1
And I press button "tueber" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

Scenario: Neue Bankdatei anlegen und Zahlungsträger in die Bankdatei eintragen

Given I open an editor "BankFile" from table "(PaymentForm):(BankFile)" with command "NEW" for record ""
And I set field "gkonto" to "geldt"
And I create a new row at the end of the table
And I set field "tztr" in row 1 to "nummer" from editor "transfer" in row 0
And I save the current editor
And I close the current editor

Scenario: Neuen Zahlungsträgersammler anlegen und Zahlungsträger in den Zahlungsträgersammler eintragen

Given I open an editor "Carrier" from table "(PaymentForm):(PaymentFormCarrier)" with command "NEW" for record ""
And I set field "zaraum" to "SEPA-Zahlungen"
And I create a new row at the end of the table
And I set field "tztrsonst" in row 1 to "nummer" from editor "paymentForm" in row 0
And I save the current editor
And I close the current editor
