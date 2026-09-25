# *****************************************************************************
#  Name             : LIQPLAN_steuer_01_01_stammdaten.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Vorbereitung - legt benoetigte Objekte an:
#                     * Buchungen
#                     * Liquplanszenario
#                     * Konfig-Anpassung
#                     * neuer Kunde
#                     * Zahlungsbedingung
#                     * neuer Artikel
#                     * VK-Auftrag + Fakturaplan
#
#
# *****************************************************************************

@persistent
Feature: LIQPLAN_steuer_01_01_stammdaten.feature
Background: MMM

Given I set the fake date to "07.01.1995"

@FALL-Buchungen
Scenario Outline: Vorbereitung1; Steuerbuchungen
Given I open an editor "Buchung-Verkauf" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
 | budat | <budat>  |
 | such  | <such1>  |
 | beleg | <beleg1> |
 | zbed  | <zbed>   |
And I create a new row at the end of the table
And I set field "konto" to "<kunde>" in row 1
And I create a new row at the end of the table
And I set field "konto" to "<vkonto>" in row 2
And I set field "ewhbetr" to "<betrag>" in row 2
And I set field "kstelle" to "100" in row 2
Then field "ustva" has value "<position1>" in row 2
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor


Given I open an editor "Buchung-Einkauf" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
 | budat | <budat>   |
 | such  | <such2>   |
 | beleg | <beleg2>  |
And I create a new row at the end of the table
And I set field "konto" to "<lieferant>" in row 1
And I create a new row at the end of the table
And I set field "konto" to "<ekonto>" in row 2
And I set field "ewsbetr" to "10.00" in row 2
And I set field "kstelle" to "100" in row 2
#Then field "ustva" has value "<position2>" in row 2
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

Examples:
 | budat      | such1 | such2 | beleg1  | beleg2  | kunde | lieferant | vkonto | ekonto | betrag | position1 | position2 | zbed |
 | 01.01.1995 | B50   | B66   | ustva50 | ustva66 | K 1   | L 1       | 44000  | 54000  | 100.00 | 10        | 66        |      |
 | 15.01.1995 | B50   | B66   | ustva50 | ustva66 | K 001 | L 001     | 44000  | 54000  | 100.00 | 10        | 66        |      |
 | 01.02.1995 | B50   | B66   | ustva50 | ustva66 | K 4   | L 002     | 44000  | 54000  | 100.00 | 10        | 66        | 200  |
 | 15.02.1995 | B50   | B66   | ustva50 | ustva66 | K 002 | L 003     | 44000  | 54000  | 100.00 | 10        | 66        |      |
 | 01.03.1995 | B50   | B66   | ustva50 | ustva66 | K 5   | L 004     | 44000  | 54000  | 100.00 | 10        | 66        | 200  |
 | 15.03.1995 | B50   | B66   | ustva50 | ustva66 | K 003 | L 1       | 44000  | 54000  | 100.00 | 10        | 66        |      |
 | 01.04.1995 | B50   | B66   | ustva50 | ustva66 | K 001 | L 001     | 44000  | 54000  | 100.00 | 10        | 66        |      |
 | 15.04.1995 | B50   | B66   | ustva50 | ustva66 | K 1   | L 002     | 44000  | 54000  | 100.00 | 10        | 66        |      |
 | 01.05.1995 | B50   | B66   | ustva50 | ustva66 | K 002 | L 003     | 44000  | 54000  | 100.00 | 10        | 66        |      |
 | 20.05.1995 | B50   | B66   | ustva50 | ustva66 | K 4   | L 004     | 44000  | 54000  | 100.00 | 10        | 66        | 200  |
 | 01.06.1995 | B50   | B66   | ustva50 | ustva66 | K 003 | L 1       | 44000  | 54000  | 100.00 | 10        | 66        |      |
 | 20.06.1995 | B50   | B66   | ustva50 | ustva66 | K 5   | L 001     | 44000  | 54000  | 100.00 | 10        | 66        | 200  |
 | 01.07.1995 | B50   | B66   | ustva50 | ustva66 | K 004 | L 002     | 44000  | 54000  | 100.00 | 10        | 66        |      |
 | 20.07.1995 | B50   | B66   | ustva50 | ustva66 | K 4   | L 003     | 44000  | 54000  | 100.00 | 10        | 66        | 200  |
 | 01.08.1995 | B50   | B66   | ustva50 | ustva66 | K 006 | L 004     | 44000  | 54000  | 100.00 | 10        | 66        |      |
 | 20.08.1995 | B50   | B66   | ustva50 | ustva66 | K 006 | L 1       | 44000  | 54000  | 100.00 | 10        | 66        |      |
 | 01.09.1995 | B50   | B66   | ustva50 | ustva66 | K 008 | L 001     | 44000  | 54000  | 100.00 | 10        | 66        |      |
 | 20.09.1995 | B50   | B66   | ustva50 | ustva66 | K 008 | L 002     | 44000  | 54000  | 100.00 | 10        | 66        |      |
 | 01.10.1995 | B50   | B66   | ustva50 | ustva66 | K 001 | L 003     | 44000  | 54000  | 100.00 | 10        | 66        |      |
 | 20.10.1995 | B50   | B66   | ustva50 | ustva66 | K 002 | L 004     | 44000  | 54000  | 100.00 | 10        | 66        |      |
 | 01.11.1995 | B50   | B66   | ustva50 | ustva66 | K 1   | L 1       | 44000  | 54000  | 100.00 | 10        | 66        |      |
 | 20.11.1995 | B50   | B66   | ustva50 | ustva66 | K 4   | L 001     | 44000  | 54000  | 100.00 | 10        | 66        | 200  |
 | 01.12.1995 | B50   | B66   | ustva50 | ustva66 | K 5   | L 002     | 44000  | 54000  | 100.00 | 10        | 66        | 200  |
 | 20.12.1995 | B50   | B66   | ustva50 | ustva66 | K 001 | L 003     | 44000  | 54000  | 100.00 | 10        | 66        |      |
###############################################################################


Scenario: Vorbereitung 2
# Liqui-Planung + Steuer
# <(PaymentMasterFiles)> <(Empty)>, (LiquidityPlanningScenario)
Given I open an editor "LiquiPlan" from table "(PaymentMasterFiles):(LiquidityPlanningScenario)" with command "STORE" for record "STD"
And I set fields
| such           | std                |
| ekfaell        | Erste Fälligkeit  |
| vkfaell        | Letzte Fälligkeit |
|  ekredataktdat | ja                 |
| vkredataktdat  | ja                 |
| ustvazeitraum  | monatlich          |
| ustzahltag     | 15                 |
| ustzahlmon     | 1                  |
| ustvaakt       | 2020               |
| ustpossteuer   | 242G               |
| ustpossteuerzn | 37                 |
And I save the current editor

# Liqui-Planung als Standardkonfig setzen
# <(PaymentMasterFiles)> <(View)>, (CMConfig)
Given I open an editor "LiquiPlanKonfig" from table "(PaymentMasterFiles):(CMConfig)" with command "STORE" for record "KONFIG"
And I set field "lqplanszenario" to "STD"
And I save the current editor

# Stammdaten
# Zahlungsbedingungen
Given I open an editor "Zahlunsgbed" from table "(Company):(TermOfPayment)" with command "STORE" for record "ZTEST"
And I set fields
    | such      | ZTEST              |
    | namebspr  | 10 Tage ohne Abzug |
And I delete all rows
And I append rows
    | frist |
    | 10    |
And I save the current editor
# Kunde
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "ALBRECHT"
And I set fields
    | such      | ALBRECHT           |
    | namebspr  | Albrecht Maschinen |
    | str       | Riedstr. 24-28     |
    | plz       | 76437              |
    | nort      | Rastatt            |
    | ustid     | DE56454651         |
    | lbed      | EXW                |
    | zbed      | ZTEST              |
And I save the current editor
# Verkaufsartikel
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "TRAKTOR10PS"
And I set fields
    | such      | TRAKTOR10PS        |
    | namebspr  | Rasentraktor 10 PS |
    | vpr       | 12000              |
    | bsart     | Fremdbeschaffung   |
    | dispoa    | bedarfsbezogen     |
    | efrist    | 15                 |
And I save the current editor

Scenario: Auftrag anlegen
# <(Sales)> <(Empty)>, (SalesOrder)
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "zbed" to "Z30N"
And I set field "waehr" to "DEM"
And I append rows
    | artikel     | mge | wtterm |
    | TRAKTOR10PS | 1   | 31.03  |
And I save the current editor

# Fakturaplan anlegen
# HINWEIS! Verrechnungsdatum (verrterm) der Anzahlungen muss Geplanten Rechnungstermin (planredat) der Schlussrechnung entsprechen.
# <(BillingPlan)> <(Empty)>, (BillingPlan)
Given I open an editor "fakturaplan" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "namebspr" to "Test-Fakturaplan 1995"
And I set field "evvorgang" to id from editor "auftrag"
And I append rows
    | reart     | proz  | planredat  | verrterm | zbed  |
    | Anzahlung | 30    | 16.01.1995 | 31.3.    | ZTEST |
    | Anzahlung | 40    | 16.02.1995 | 31.3.    | ZTEST |
    | Rechnung  | 30    | 31.03.1995 |          | Z30N  |
And I save the current editor

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Scenario: Formular USTVA2020 "vorbereiten"

# Ust-Formular Konfiguration
Given I open an editor "temp" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "USTVA2020"
And I set field "bempos" to "10" in row 6
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "95"
And I set field "ganmon" to "1"
And I set field "gendmon" to "1"
And I set field "bukreis" to "HGB"
And I press button "berech"
Then I save the current editor

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

