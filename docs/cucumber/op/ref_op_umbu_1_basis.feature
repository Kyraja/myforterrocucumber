# *****************************************************************************
#  Name             : ref_op_umbu_1_basis.feature
#  Autor            : hc
#  Verantwortlich   : hc
#  Kontrolle        :
#  Funktion         : Stammdaten und Offene Posten für Folgetests erfassen
#  ref              : ref_op_umbu_1_basis_cu
# *******************************************************************************
@persistent
Feature: Zahlungsverkehr
Background: Stammdaten und Offene Posten für Folgetests erfassen

Given I set the fake date to "31.12.2022"

# ========================= Diverse Stammdaten ================================================

# ---------------------------------------------------------------------------------------------
Scenario: Bank in Deutschland
# ---------------------------------------------------------------------------------------------
Given I open an editor "Bank-DE" from table "(BankData):(Bank)" with command "NEW" for record ""
And I set fields
  |nummer|1DEBANK      |
  |such  |DEBANK       |
  |name  |Deutsche Bank|
  |iident|BICDEBANK    |
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario Outline: Kostenstelle in Sachkonten vorbelegen
# ---------------------------------------------------------------------------------------------
Given I open an editor "Konto-kstelle" from table "(Account):(Account)" with command "UPDATE" for record "<record>"
And I set fields
  |kstelle|<kstelle>|
And I save the current editor

Examples:
|record|kstelle|
|44000 |101    |
|54000 |101    |

# ========================= Geldtransitkonten =================================================

# ---------------------------------------------------------------------------------------------
Scenario Outline: Geldtransitkonten erzeugen
# ---------------------------------------------------------------------------------------------
Given I open an editor "Geldtransitkonten" from table "(Account):(Account)" with command "COPY" for record "14600"
And I set fields
  |nummer     |<nummer>     |
  |such       |<such>       |
  |name       |<name>       |
  |zaform     |<zaform>     |
  |zaraum     |<zaraum>     |
  |zasammelart|<zasammelart>|
And I save the current editor

Examples:
|nummer|such         |zaform     |zaraum          |zasammelart                  |name|
|14611 |UEBERW-N     |Überweisung|Inlandszahlungen|Nicht sammeln                |Geldtransitkonto für Überweisungen;Sammelart Nicht sammeln|
|14612 |UEBERW-S-BU  |Überweisung|Inlandszahlungen|Sammelbuchungen              |Geldtransitkonto für Überweisungen;Sammelart Sammelbuchungen|
|14613 |UEBERW-S-OP  |Überweisung|Inlandszahlungen|Sammelbuchungen und Sammel-OP|Geldtransitkonto für Überweisungen;Sammelart Sammelbuchungen und Sammel-OP|
#
|14621 |LAST-N       |Lastschrift|Inlandszahlungen|Nicht sammeln                |Geldtransitkonto für Lastschriften;Sammelart Nicht sammeln|
|14622 |LAST-S-BU    |Lastschrift|Inlandszahlungen|Sammelbuchungen              |Geldtransitkonto für Lastschriften;Sammelart Sammelbuchungen|
|14623 |LAST-S-OP    |Lastschrift|Inlandszahlungen|Sammelbuchungen und Sammel-OP|Geldtransitkonto für Lastschriften;Sammelart Sammelbuchungen und Sammel-OP|
#
|14631 |ASCHECK-N    |Scheck     |Inlandszahlungen|Nicht sammeln                |Geldtransitkonto für Scheckausgänge;Sammelart Nicht sammeln|
|14632 |ASCHECK-S-BU |Scheck     |Inlandszahlungen|Sammelbuchungen              |Geldtransitkonto für Scheckausgänge;Sammelart Sammelbuchungen|
|14633 |ASCHECK-S-OP |Scheck     |Inlandszahlungen|Sammelbuchungen und Sammel-OP|Geldtransitkonto für Scheckausgänge;Sammelart Sammelbuchungen und Sammel-OP|
#
|14641 |ESCHECK-N    |Scheck     |Inlandszahlungen|Nicht sammeln                |Geldtransitkonto für Scheckeingänge;Sammelart Nicht sammeln|
|14642 |ESCHECK-S-BU |Scheck     |Inlandszahlungen|Sammelbuchungen              |Geldtransitkonto für Scheckeingänge;Sammelart Sammelbuchungen|
|14643 |ESCHECK-S-OP |Scheck     |Inlandszahlungen|Sammelbuchungen und Sammel-OP|Geldtransitkonto für Scheckeingänge;Sammelart Sammelbuchungen und Sammel-OP|
#
|14651 |WECHSEL-N    |Wechsel    |Inlandszahlungen|Nicht sammeln                |Geldtransitkonto für Kundenwechsel;Sammelart Nicht sammeln|
|14652 |WECHSEL-S-BU |Wechsel    |Inlandszahlungen|Sammelbuchungen              |Geldtransitkonto für Kundenwechsel;Sammelart Sammelbuchungen|
|14653 |WECHSEL-S-OP |Wechsel    |Inlandszahlungen|Sammelbuchungen und Sammel-OP|Geldtransitkonto für Kundenwechsel;Sammelart Sammelbuchungen und Sammel-OP|
#
|14661 |SONSTAUS-N   |Sonstige   |Inlandszahlungen|Nicht sammeln                |Geldtransitkonto für sonstige Zahlungsausgänge;Sammelart Nicht sammeln|
|14662 |SONSTAUS-S-BU|Sonstige   |Inlandszahlungen|Sammelbuchungen              |Geldtransitkonto für sonstige Zahlungsausgänge;Sammelart Sammelbuchungen|
|14663 |SONSTAUS-S-OP|Sonstige   |Inlandszahlungen|Sammelbuchungen und Sammel-OP|Geldtransitkonto für sonstige Zahlungsausgänge;Sammelart Sammelbuchungen und Sammel-OP|
#
|14671 |SONSTEIN-N   |Sonstige   |Inlandszahlungen|Nicht sammeln                |Geldtransitkonto für sonstige Zahlungseingänge;Sammelart Nicht sammeln|
|14672 |SONSTEIN-S-BU|Sonstige   |Inlandszahlungen|Sammelbuchungen              |Geldtransitkonto für sonstige Zahlungseingänge;Sammelart Sammelbuchungen|
|14673 |SONSTEIN-S-OP|Sonstige   |Inlandszahlungen|Sammelbuchungen und Sammel-OP|Geldtransitkonto für sonstige Zahlungseingänge;Sammelart Sammelbuchungen und Sammel-OP|

# ---------------------------------------------------------------------------------------------
Scenario Outline: Bankverbindungen für Geldtransitkonten erzeugen
# ---------------------------------------------------------------------------------------------
Given I open an editor "Bankverbindung-Geldtrans" from table "(BankData):(BankDetails)" with command "NEW" for record ""
And I set fields
  |nummer|<nummer>|
  |such  |<such>  |
  |konto |<konto> |
  |bank  |<bank>  |
  |iban  |<iban>  |
And I save the current editor

Examples:
|nummer|such    |konto|bank   |iban             |
|14611 |KO-14611|14611|1DEBANK|DE999999999914611|
|14612 |KO-14612|14612|1DEBANK|DE999999999914612|
|14613 |KO-14613|14613|1DEBANK|DE999999999914613|
#
|14621 |KO-14621|14621|1DEBANK|DE999999999914621|
|14622 |KO-14622|14622|1DEBANK|DE999999999914622|
|14623 |KO-14623|14623|1DEBANK|DE999999999914623|
#
|14631 |KO-14631|14631|1DEBANK|DE999999999914631|
|14632 |KO-14632|14632|1DEBANK|DE999999999914632|
|14633 |KO-14633|14633|1DEBANK|DE999999999914633|
#
|14641 |KO-14641|14641|1DEBANK|DE999999999914641|
|14642 |KO-14642|14642|1DEBANK|DE999999999914642|
|14643 |KO-14643|14643|1DEBANK|DE999999999914643|
#
|14651 |KO-14651|14651|1DEBANK|DE999999999914651|
|14652 |KO-14652|14652|1DEBANK|DE999999999914652|
|14653 |KO-14653|14653|1DEBANK|DE999999999914653|
#
|14661 |KO-14661|14661|1DEBANK|DE999999999914661|
|14662 |KO-14662|14662|1DEBANK|DE999999999914662|
|14663 |KO-14663|14663|1DEBANK|DE999999999914663|
#
|14671 |KO-14671|14671|1DEBANK|DE999999999914671|
|14672 |KO-14672|14672|1DEBANK|DE999999999914672|
|14673 |KO-14673|14673|1DEBANK|DE999999999914673|

# ---------------------------------------------------------------------------------------------
Scenario Outline: Bankverbindungen in Geldtransitkonten eintragen
# ---------------------------------------------------------------------------------------------
Given I open an editor "Geldtransitkonto-bverb" from table "(Account):(Account)" with command "UPDATE" for record "<record>"
And I set fields
  |bverb|<bverb>|
And I save the current editor

Examples:
|record|bverb|
|14611 |14611|
|14612 |14612|
|14613 |14613|
#
|14621 |14621|
|14622 |14622|
|14623 |14623|
#
|14631 |14631|
|14632 |14632|
|14633 |14633|
#
|14641 |14641|
|14642 |14642|
|14643 |14643|
#
|14651 |14651|
|14652 |14652|
|14653 |14653|
#
|14661 |14661|
|14662 |14662|
|14663 |14663|
#
|14671 |14671|
|14672 |14672|
|14673 |14673|

# ========================= Kunden und Kunden-OPs  ============================================

# ---------------------------------------------------------------------------------------------
Scenario Outline: Kunden erfassen
# ---------------------------------------------------------------------------------------------
Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set fields
  |nummer|<nummer>|
  |such  |<such>  |
  |name  |<name>  |
  |staat |<staat> |
  |waehr |<waehr> |
  |zbed  |<zbed>  |
  |zaform|<zaform>|
And I save the current editor

Examples:
|nummer|such |staat    |waehr|zbed|zaform     |name|
|110|KU110|DEUTSCHLAND |EUR  |200 |Lastschrift|Kunde 110 Deutschland EUR Lastschrift|
|120|KU120|DEUTSCHLAND |EUR  |200 |Scheck     |Kunde 120 Deutschland EUR Scheck     |
|130|KU130|DEUTSCHLAND |EUR  |200 |Sonstige   |Kunde 130 Deutschland EUR Sonstige   |
|140|KU140|DEUTSCHLAND |EUR  |200 |Wechsel    |Kunde 140 Deutschland EUR Wechsel    |
|150|KU150|DEUTSCHLAND |EUR  |200 |           |Kunde 150 Deutschland EUR            |

# ---------------------------------------------------------------------------------------------
Scenario Outline: Bankverbindungen für Kunden erzeugen
# ---------------------------------------------------------------------------------------------
Given I open an editor "Bankverbindung-Kunde" from table "(BankData):(BankDetails)" with command "NEW" for record ""
And I set fields
  |nummer|<nummer>|
  |such  |<such>  |
  |konto |<konto> |
  |bank  |<bank>  |
  |iban  |<iban>  |
And I save the current editor

Examples:
|nummer|such  |konto|bank   |iban             |
|110ku |KU-110|K 110|1DEBANK|DE9999999999KU110|
|120ku |KU-120|K 120|1DEBANK|DE9999999999KU120|
|130ku |KU-130|K 130|1DEBANK|DE9999999999KU130|
|140ku |KU-140|K 140|1DEBANK|DE9999999999KU140|
|150ku |KU-150|K 150|1DEBANK|DE9999999999KU150|

# ---------------------------------------------------------------------------------------------
Scenario Outline: Bankverbindungen in Kunden eintragen
# ---------------------------------------------------------------------------------------------
Given I open an editor "Kunde-bverb" from table "(Customer):(Customer)" with command "UPDATE" for record "<record>"
And I set fields
  |bverb|<bverb>|
And I save the current editor

Examples:
|record|bverb|
|110   |110ku|
|120   |120ku|
|130   |130ku|
|140   |140ku|
|150   |150ku|

# ---------------------------------------------------------------------------------------------
Scenario: Kunden-OP erzeugen (Buchung neu)
# ---------------------------------------------------------------------------------------------
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  |such  |BRE1101   |
  |beleg |RE1101    |
  |beldat|01.03.2022|
  |budat |01.03.2022|
And I append rows
  |konto|ewsbetr    |ewhbetr    |
  |K 110|10000.00   |!dontChange|
  |44000|!dontChange|!dontChange|
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario Outline: Weitere Kunden-OPs erzeugen (Buchung neu)
# ---------------------------------------------------------------------------------------------
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "COPY" for record "BRE1101"
And I set field "beleg" to "<beleg>"
And I set field "konto" to "<konto>" in row 1
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

Examples:
 |beleg |konto|
 |RE1102|K 110|
 |RE1103|K 110|
 |RE1104|K 110|
 |RE1105|K 110|
#
 |RE1201|K 120|
 |RE1202|K 120|
 |RE1203|K 120|
 |RE1204|K 120|
 |RE1205|K 120|
 #
 |RE1301|K 130|
 |RE1302|K 130|
 |RE1303|K 130|
 |RE1304|K 130|
 |RE1305|K 130|
 #
 |RE1401|K 140|
 |RE1402|K 140|
 |RE1403|K 140|
 |RE1404|K 140|
 |RE1405|K 140|
 #
 |RE1501|K 150|
 |RE1502|K 150|
 |RE1503|K 150|
 |RE1504|K 150|
 |RE1505|K 150|

# ========================= Lieferanten und Lieferanten-OPs  ==================================

# ---------------------------------------------------------------------------------------------
Scenario Outline: Lieferanten erfassen
# ---------------------------------------------------------------------------------------------
Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
  |nummer|<nummer>|
  |such  |<such>  |
  |name  |<name>  |
  |staat |<staat> |
  |waehr |<waehr> |
  |zbed  |<zbed>  |
  |zaform|<zaform>|
And I save the current editor

Examples:
|nummer|such |staat    |waehr|zbed|zaform     |name|
|510|LI510|DEUTSCHLAND |EUR  |200 |Überweisung|Lieferant 510 Deutschland EUR Überweisung|
|520|LI520|DEUTSCHLAND |EUR  |200 |Scheck     |Lieferant 520 Deutschland EUR Scheck     |
|530|LI530|DEUTSCHLAND |EUR  |200 |Sonstige   |Lieferant 530 Deutschland EUR Sonstige   |
|540|LI540|DEUTSCHLAND |EUR  |200 |           |Lieferant 540 Deutschland EUR            |
|550|LI550|DEUTSCHLAND |EUR  |200 |           |Lieferant 550 Deutschland EUR            |

# ---------------------------------------------------------------------------------------------
Scenario Outline: Bankverbindungen für Lieferanten erzeugen
# ---------------------------------------------------------------------------------------------
Given I open an editor "Bankverbindung-Lieferant" from table "(BankData):(BankDetails)" with command "NEW" for record ""
And I set fields
  |nummer|<nummer>|
  |such  |<such>  |
  |konto |<konto> |
  |bank  |<bank>  |
  |iban  |<iban>  |
And I save the current editor

Examples:
|nummer|such  |konto|bank   |iban             |
|510li |LI-510|L 510|1DEBANK|DE9999999999LI510|
|520li |LI-520|L 520|1DEBANK|DE9999999999LI520|
|530li |LI-530|L 530|1DEBANK|DE9999999999LI530|
|540li |LI-540|L 540|1DEBANK|DE9999999999LI540|
|550li |LI-550|L 550|1DEBANK|DE9999999999LI550|

# ---------------------------------------------------------------------------------------------
Scenario Outline: Bankverbindungen in Lieferanten eintragen
# ---------------------------------------------------------------------------------------------
Given I open an editor "Lieferant-bverb" from table "(Vendor):(Vendor)" with command "UPDATE" for record "<record>"
And I set fields
  |bverb|<bverb>|
And I save the current editor

Examples:
|record|bverb|
|510   |510li|
|520   |520li|
|530   |530li|
|540   |540li|
|550   |550li|

# ---------------------------------------------------------------------------------------------
Scenario: Lieferanten-OP erzeugen (Buchung neu)
# ---------------------------------------------------------------------------------------------
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  |such  |BRE5101   |
  |beleg |RE5101    |
  |beldat|01.03.2022|
  |budat |01.03.2022|
And I append rows
  |konto|ewsbetr    |ewhbetr    |
  |L 510|!dontChange|10000.00   |
  |54000|!dontChange|!dontChange|
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario Outline: Weitere Lieferanten-OPs erzeugen (Buchung neu)
# ---------------------------------------------------------------------------------------------
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "COPY" for record "BRE5101"
And I set field "beleg" to "<beleg>"
And I set field "konto" to "<konto>" in row 1
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

Examples:
 |beleg |konto|
 |RE5102|L 510|
 |RE5103|L 510|
 |RE5104|L 510|
 |RE5105|L 510|
#
 |RE5201|L 520|
 |RE5202|L 520|
 |RE5203|L 520|
 |RE5204|L 520|
 |RE5205|L 520|
 #
 |RE5301|L 530|
 |RE5302|L 530|
 |RE5303|L 530|
 |RE5304|L 530|
 |RE5305|L 530|
 #
 |RE5401|L 540|
 |RE5402|L 540|
 |RE5403|L 540|
 |RE5404|L 540|
 |RE5405|L 540|
 #
 |RE5501|L 550|
 |RE5502|L 550|
 |RE5503|L 550|
 |RE5504|L 550|
 |RE5505|L 550|
