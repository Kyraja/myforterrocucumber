# *****************************************************************************
#  Name             : IS_INVOICEEXPORT.feature
#  Autor            : mh
#  Verantwortlich   : teaminfosysteme
#  Funktion         : Tests IS INVOICEEXPORT fuer Steuersumme = 0.0
#  
#  Wegen Vorgaenger ref_edidaten ist das Testjahr 1995
# *****************************************************************************
@persistent
Feature: Zeilenaufbau IS INVOICEEXPORT fuer Steuersumme null (0)


# -----------------------------------------------------------------------------
# Es wird ein VK-Rechnung mit 1 Artikel erstellt. 
# > Der Artikel hat einen Preis.
# > Da die Steuerregel auf VKINFREI gesetzt wird, wird Steuersatz 0 gesetzt.
# > Es werden keine Steuerzeilen erzeugt.
# > Die Rechnung hat eine Summenzeile "ES".
# Das Infosystem INVOICEEXPORT muss Rechnungssumme und Gesamtsumme mit 
# Netto- und Bruttobetraegen erzuegen
# -----------------------------------------------------------------------------
Scenario: Zeilenaufbau IS INVOICEEXPORT zu VK-Rechnung Steuer 0.0 wegen Steuerregel VKINFREI
Given I set the fake date to "07.01.1995"

Given I open an editor "RE1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "227502"
And I set field "tterm" to "."
And I set field "vom" to "."
And I set field "budat" to "."
And I set field "ueb" to "nein"
And I create a new row at the end of the table
And I set field "artikel" to "EDIART-1" in row 1
And I set field "mge" to "200" in row 1
And I set field "strgl" to "VKINFREI" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I open the infosystem "INVOICEEXPORT"
And I set field "renummer" to "!RE1"
And I press button "bstart"
Then the table has 6 rows
# Rechnungskopf
# Zahlungsbedingung
# Artikelzeile EDIART-1 (22001)
# Steuerzeile Steuersatz 0.0 
# Rechnungssumme (VK-Rechnung)
# Gesamtsumme (EDI-Rechnung = Sammelrechnung)
And table has values
    | tinvoicerecipientg | tpaymentmethod | tcashdiscountbuyin | tsupplierproductno | tquantityinvoice | tmonamountlin | ttaxratemea |  tnetsalesprice  | ttaxrateuns | tgoodsvalue | ttotalgoodsvalue | tnetinvoiceamount | tgrossivcodedunt |  ttaxamount |ttaxrate | ttotalnetofallinvo | ttotalgrossofallin | ttotaltaxamount |
    | GLN227502          |                |                    |                    |                0 |          0.00 |             |             0.00 |             |        0.00 |             0.00 |              0.00 |             0.00 |        0.00 |         |               0.00 |               0.00 |            0.00 |
    |                    |              7 |            5112.00 |                    |                0 |          0.00 |             |             0.00 |             |        0.00 |             0.00 |              0.00 |             0.00 |        0.00 |         |               0.00 |               0.00 |            0.00 |
    |                    |                |                    |              22001 |              200 |       5112.00 |        0.00 |          5112.00 |             |        0.00 |             0.00 |              0.00 |             0.00 |        0.00 |         |               0.00 |               0.00 |            0.00 |
    |                    |                |                    |                    |                0 |          0.00 |             |             0.00 |        0.00 |     5112.00 |          5112.00 |              0.00 |             0.00 |        0.00 |         |               0.00 |               0.00 |            0.00 |
    |                    |                |                    |                    |                0 |          0.00 |             |             0.00 |             |        0.00 |          5112.00 |           5112.00 |          5112.00 |        0.00 |         |               0.00 |               0.00 |            0.00 |
    |                    |                |                    |                    |                0 |          0.00 |             |             0.00 |             |        0.00 |             0.00 |              0.00 |             0.00 |        0.00 |    0.00 |            5112.00 |            5112.00 |            0.00 |
And I close the current editor


# -----------------------------------------------------------------------------
# Es wird ein VK-Rechnung mit 1 Artikel erstellt. 
# > Der Artikel hat den Preis 0!
# > Die Steuerregel bleibt auf Standard 15%
# > Es werden keine Steuerzeilen erzeugt.
# > Die Rechnung hat keine Summenzeile.
# Das Infosystem INVOICEEXPORT hat in den Zeilen zu Rechnungssumme und Gesamtsumme 
# zwar die Brutto- und Nettobetraege als 0, der Steuersatz ist NICHT 0.0!
# -----------------------------------------------------------------------------
Scenario: Zeilenaufbau IS INVOICEEXPORT zu VK-Rechnung Steuer 0.0 bei Steuersatz "normal" und Wert 0.0
Given I set the fake date to "07.01.1995"

Given I open an editor "RE2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "227502"
And I set field "tterm" to "."
And I set field "vom" to "."
And I set field "budat" to "."
And I set field "ueb" to "nein"
And I create a new row at the end of the table
And I set field "artikel" to "EDIART-1" in row 1
And I set field "mge" to "200" in row 1
And I set field "preis" to "0" in row 1
# And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I open the infosystem "INVOICEEXPORT"
And I set field "renummer" to "!RE2"
And I press button "bstart"
Then the table has 6 rows
# Rechnungskopf
# Zahlungsbedingung
# Artikelzeile EDIART-1 (22001)
# Steuerzeile Steuersatz 15.0 
# Rechnungssumme (VK-Rechnung)
# Gesamtsumme (EDI-Rechnung = Sammelrechnung)
And table has values
    | tinvoicerecipientg | tpaymentmethod | tcashdiscountbuyin | tsupplierproductno | tquantityinvoice | tmonamountlin | ttaxratemea |  tnetsalesprice  | ttaxrateuns | tgoodsvalue | ttotalgoodsvalue | tnetinvoiceamount | tgrossivcodedunt |  ttaxamount |ttaxrate | ttotalnetofallinvo | ttotalgrossofallin | ttotaltaxamount |
    | GLN227502          |                |                    |                    |                0 |          0.00 |             |             0.00 |             |        0.00 |             0.00 |              0.00 |             0.00 |        0.00 |         |               0.00 |               0.00 |            0.00 |
    |                    |              7 |               0.00 |                    |                0 |          0.00 |             |             0.00 |             |        0.00 |             0.00 |              0.00 |             0.00 |        0.00 |         |               0.00 |               0.00 |            0.00 |
    |                    |                |                    |              22001 |              200 |          0.00 |        15.0 |             0.00 |             |        0.00 |             0.00 |              0.00 |             0.00 |        0.00 |         |               0.00 |               0.00 |            0.00 |
    |                    |                |                    |                    |                0 |          0.00 |             |             0.00 |        15.0 |        0.00 |             0.00 |              0.00 |             0.00 |        0.00 |         |               0.00 |               0.00 |            0.00 |
    |                    |                |                    |                    |                0 |          0.00 |             |             0.00 |             |        0.00 |             0.00 |              0.00 |             0.00 |        0.00 |         |               0.00 |               0.00 |            0.00 |
    |                    |                |                    |                    |                0 |          0.00 |             |             0.00 |             |        0.00 |             0.00 |              0.00 |             0.00 |        0.00 |    15.0 |               0.00 |               0.00 |            0.00 |
And I close the current editor


# -----------------------------------------------------------------------------
# Es wird ein VK-Rechnung mit 2 Artikel erstellt. 
# > Der 1. Artikel hat den Preis 5 bei Menge 200!
# > Der 2. Artikel hat den Preis -5 bei Menge 200!
# > Die Steuerregel bleibt auf Standard 15%
# > Druch das +/- hat die REchnung den Wert 0
# > Es werden keine Steuerzeilen erzeugt.
# > Die Rechnung hat eine Summenzeile ("ES").
# Das Infosystem INVOICEEXPORT hat in den Zeilen zu Rechnungssumme und Gesamtsumme 
# zwar die Brutto- und Nettobetraege als 0, der Steuersatz ist NICHT 0.0!
# In den Artikelzeilen muss das +/- der Werte zu erkennen sein.
# -----------------------------------------------------------------------------
Scenario: Zeilenaufbau IS INVOICEEXPORT zu VK-Rechnung Steuer 0.0 bei Rechnung+Gutschrift ergibt "zufaelligerweise" Steuerbetrag 0.0
Given I set the fake date to "07.01.1995"

Given I open an editor "RE3" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "227502"
And I set field "tterm" to "."
And I set field "vom" to "."
And I set field "budat" to "."
And I set field "ueb" to "nein"
And I create a new row at the end of the table
And I set field "artikel" to "EDIART-1" in row 1
And I set field "mge" to "200" in row 1
And I set field "preis" to "5" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "EDIART-2" in row 2
And I set field "mge" to "200" in row 2
And I set field "preis" to "-5" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I open the infosystem "INVOICEEXPORT"
And I set field "renummer" to "!RE3"
And I press button "bstart"
Then the table has 7 rows
# Rechnungskopf
# Zahlungsbedingung
# Artikelzeile EDIART-1 (22001) 200 PCE zu  5 EUR
# Artikelzeile EDIART-2 (22002) 200 PCE zu -5 EUR ("tnetsalesprice" ist ein vorzeichenloser Betrag)
# Steuerzeile Steuersatz 15.0 
# Rechnungssumme (VK-Rechnung)
# Gesamtsumme (EDI-Rechnung = Sammelrechnung)
And table has values
    | tinvoicerecipientg | tpaymentmethod | tcashdiscountbuyin | tsupplierproductno | tquantityinvoice |tmonamountlin | ttaxratemea |  tnetsalesprice | ttaxrateuns |tgoodsvalue | ttotalgoodsvalue | tnetinvoiceamount | tgrossivcodedunt |  ttaxamount |ttaxrate | ttotalnetofallinvo | ttotalgrossofallin | ttotaltaxamount |
    | GLN227502          |                |                    |                    |                0 |         0.00 |             |            0.00 |             |       0.00 |             0.00 |              0.00 |             0.00 |        0.00 |         |               0.00 |               0.00 |            0.00 |
    |                    |              7 |               0.00 |                    |                0 |         0.00 |             |            0.00 |             |       0.00 |             0.00 |              0.00 |             0.00 |        0.00 |         |               0.00 |               0.00 |            0.00 |
    |                    |                |                    |              22001 |              200 |      1000.00 |        15.0 |         1000.00 |             |       0.00 |             0.00 |              0.00 |             0.00 |        0.00 |         |               0.00 |               0.00 |            0.00 |
    |                    |                |                    |              22002 |              200 |     -1000.00 |        15.0 |         1000.00 |             |       0.00 |             0.00 |              0.00 |             0.00 |        0.00 |         |               0.00 |               0.00 |            0.00 |
    |                    |                |                    |                    |                0 |         0.00 |             |            0.00 |        15.0 |       0.00 |             0.00 |              0.00 |             0.00 |        0.00 |         |               0.00 |               0.00 |            0.00 |
    |                    |                |                    |                    |                0 |         0.00 |             |            0.00 |             |       0.00 |             0.00 |              0.00 |             0.00 |        0.00 |         |               0.00 |               0.00 |            0.00 |
    |                    |                |                    |                    |                0 |         0.00 |             |            0.00 |             |       0.00 |             0.00 |              0.00 |             0.00 |        0.00 |    15.0 |               0.00 |               0.00 |            0.00 |
And I close the current editor
