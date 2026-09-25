@persistent
Feature: Infosystem LIQPLAN Bugfix REWE-2081 Problem 2
########################################################################
# * Wir haben nur den Auftrag, keine weiteren Vorgänge. 
# * Der Auftrag ist Anzahlung mit Fakturaplan. 
#########################################################################

Background:
Given I set the fake date to "07.01.1995"


Scenario: Liqui-Planung + Steuer
# <(PaymentMasterFiles)> <(Empty)>, (LiquidityPlanningScenario)
Given I open an editor "LiquiPlan" from table "(PaymentMasterFiles):(LiquidityPlanningScenario)" with command "STORE" for record "STD"
And I set fields
| such           | std                           |
| ekfaell        | Erste Fälligkeit               |
| vkfaell        | Letzte Fälligkeit              |
|  ekredataktdat | ja                             |
| vkredataktdat  | ja                             |
| ustvazeitraum  | monatlich                      |
| ustzahltag     | 15                             |
| ustzahlmon     | 1                              |
| ustvaakt       | 2020                           |
| ustpossteuer   | 242G                           |
| ustpossteuerzn | 37                             |
And I save the current editor

Scenario: Ust-Formular Konfiguration
Given I open an editor "temp" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "USTVA2020"
And I set field "bempos" to "10" in row 6
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "95"
And I set field "ganmon" to "1"
And I set field "gendmon" to "1"
And I set field "bukreis" to "HGB"
And I press button "berech"
Then I save the current editor


Scenario: Liqui-Planung als Standardkonfig setzen
# <(PaymentMasterFiles)> <(View)>, (CMConfig)
Given I open an editor "LiquiPlanKonfig" from table "(PaymentMasterFiles):(CMConfig)" with command "STORE" for record "KONFIG"
And I set field "lqplanszenario" to "STD"
And I save the current editor



Scenario: Stammdaten
# Zahlungsbedingungen
Given I open an editor "Zahlunsgbed" from table "(Company):(TermOfPayment)" with command "STORE" for record "ZTEST"
And I set fields
    | such      | ZTEST                 |
    | namebspr  | 10 Tage ohne Abzug    |
And I delete all rows
And I append rows
    | frist | 
    | 10    |
And I save the current editor

# Kunde
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "ALBRECHT"
And I set fields
    | such      | ALBRECHT                  |
    | namebspr  | Albrecht Maschinen        |
    | str       | Riedstr. 24-28            |
    | plz       | 76437                     |
    | nort      | Rastatt                   |
    | ustid     | DE56454651                |
    | lbed      | EXW                       |
    | zbed      | ZTEST                     |
And I save the current editor

# Verkaufsartikel
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "TRAKTOR10PS"
And I set fields
    | such      | TRAKTOR10PS           |
    | namebspr  | Rasentraktor 10 PS    |
    | vpr       | 12000                 |
    | bsart     | Fremdbeschaffung      |
    | dispoa    | bedarfsbezogen        |
    | efrist    | 15                    |
And I save the current editor

Scenario: Auftrag anlegen
# <(Sales)> <(Empty)>, (SalesOrder)
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "zbed" to "Z30N"
And I set field "waehr" to "DEM"
And I append rows
    | artikel       | mge   | wtterm |
    | TRAKTOR10PS   | 1     | 31.03 |
And I save the current editor

# anzpwert, zbedname, zbet und tterm werden automatisch gesetzt
Scenario: Fakturaplan anlegen
# HINWEIS! Verrechnungsdatum (verrterm) der Anzahlungen muss Geplanten Rechnungstermin (planredat) der Schlussrechnung entsprechen. 
# <(BillingPlan)> <(Empty)>, (BillingPlan)
Given I open an editor "fakturaplan" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "namebspr" to "Test-Fakturaplan 1995"
And I set field "evvorgang" to id from editor "auftrag"
And I append rows
    | reart     | proz  | planredat     | verrterm | zbed   |
    | Anzahlung | 30    | 16.01.1995    | 31.3.    | ZTEST  |
    | Anzahlung | 40    | 16.02.1995    | 31.3.    | ZTEST  |
    | Rechnung  | 30    | 31.03.1995    |          | Z30N   |
And I save the current editor

Scenario: Liquiditätsplanung öffnen
# (Infosystem) LIQPLAN
Given I open the infosystem "LIQPLAN"
#And I set fields
#| planszenario | STD |
And I press button "bstart"
Then table has values
|tposition|tekvk|twert0|twert1|twert2 |twert3 |twert4  |twert5  |twert6  |twert7  |twert8  |twert9  |twert10 |twert11 |twert12 |twert13  |tzeilensum|
|Eigene liquide Mittel (AB)      |       |||||        |4140.00 |4140.00 |4140.00 |3600.00 |3600.00 |9120.00 |9120.00 |8400.00 |8400.00  |         |
|Kreditlinie (AB)                |       |||||        |        |        |        |        |        |        |        |        |         |         |
|Zahlungsmittel (AB)             |       |||||        |4140.00 |4140.00 |4140.00 |3600.00 |3600.00 |9120.00 |9120.00 |8400.00 |8400.00  |         |
|Offene Posten                   |Verkauf|||||        |        |        |        |        |        |        |        |        |         |         |
|Rechnungsobligo                 |Verkauf|||||4140.00 |        |        |        |        |5520.00 |        |        |        |-9660.00 |         |
|Lieferobligo                    |Verkauf|||||        |        |        |        |        |        |        |        |        |13800.00 |13800.00 |
|Sonstige Einzahlungen           |Verkauf|||||        |        |        |        |        |        |        |        |        |         |         |
|Einzahlungen gesamt             |       |||||4140.00 |        |        |        |        |5520.00 |        |        |        |4140.00  |13800.00 |
|Offene Posten                   |Einkauf|||||        |        |        |        |        |        |        |        |        |         |         |
|Rechnungsobligo                 |Einkauf|||||        |        |        |        |        |        |        |        |        |         |         |
|Lieferobligo                    |Einkauf|||||        |        |        |        |        |        |        |        |        |         |         |
|Sonstige Auszahlungen           |Einkauf|||||        |        |        |        |        |        |        |        |        |         |         |
|Auszahlungen gesamt             |       |||||        |        |        |        |        |        |        |        |        |         |         |
|Liquiditätssaldo I              |       |||||4140.00 |        |        |        |        |5520.00 |        |        |        |4140.00  |         |
|Gebuchte Umsatzsteuerzahllast   |       |||||        |        |        |        |        |        |        |        |        |         |         |
|Umsatzsteuerzahllast aus Obligos|       |||||        |        |        |540.00  |        |        |        |720.00  |        |540.00   |1800.00  |
|Zinssatz Bereitstellung (%)     |       |||||        |        |        |        |        |        |        |        |        |         |         |
|Zinsen Bereitstellung           |       |||||        |        |        |        |        |        |        |        |        |         |         |
|Zinssatz Inanspruchnahme (%)    |       |||||        |        |        |        |        |        |        |        |        |         |         |
|Zinsen Inanspruchnahme          |       |||||        |        |        |        |        |        |        |        |        |         |         |
|Weitere Belastungen gesamt      |       |||||        |        |        |540.00  |        |        |        |720.00  |        |540.00   |1800.00  |
|Liquiditätssaldo II             |       |||||4140.00 |        |        |-540.00 |        |5520.00 |        |-720.00 |        |3600.00  |         |
|Eigene liquide Mittel (EB)      |       |||||4140.00 |4140.00 |4140.00 |3600.00 |3600.00 |9120.00 |9120.00 |8400.00 |8400.00 |12000.00 |         |
|Kreditlinie (EB)                |       |||||        |        |        |        |        |        |        |        |        |         |         |
|Zahlungsmittel (EB)             |       |||||4140.00 |4140.00 |4140.00 |3600.00 |3600.00 |9120.00 |9120.00 |8400.00 |8400.00 |12000.00 |         |
|Inanspruchnahme Kreditlinie abs.|       |||||        |        |        |        |        |        |        |        |        |         |         |
|Inanspruchnahme Kreditlinie (%) |       |||||        |        |        |        |        |        |        |        |        |         |         |
|Änderung Kreditvolumen          |       |||||        |        |        |        |        |        |        |        |        |         |         |

Scenario: Umsatzsteuerzahllast aus Obligo für Anzahlungen
# (Infosystem) LIQPLANDETAILS
Given I open the infosystem "LIQPLANDETAILS"
# (Infosystem) LIQPLANDETAILS
#stichtag=19950107|zeiteinheit=(Week)|auswaehr=DEM|bukreis=HGB|buwaehr=DEM|planszenario=STD|kategorieauswert=0|allekategorien=1|zeigealle=0|periodevon=13|periodebis=13|position=Umsatzsteuerzahllast aus Obligos
And I set fields
|stichtag|19950107|
|zeiteinheit|(Week)|
|auswaehr|DEM|
|bukreis|HGB|
|buwaehr|DEM|
|planszenario|STD|
|kategorieauswert|0|
|allekategorien|1|
|zeigealle|0|
|periodevon|13|
|periodebis|13|
|position|Umsatzsteuerzahllast aus Obligos|
And I press button "bstart"
Then the table has 3 rows
Then field "tterm" has value "15.04.1995" in row 1
Then field "tzabetr" has value "1800.00" in row 1
Then field "tterm" has value "15.04.1995" in row 2
Then field "tzabetr" has value "-540.00" in row 2
Then field "tterm" has value "15.04.1995" in row 3
Then field "tzabetr" has value "-720.00" in row 3

Scenario: Lieferobligo Termin mit Zahlungsbedingung. 
Given I open the infosystem "LIQPLANDETAILS"
# (Infosystem) LIQPLANDETAILS
And I set fields
|stichtag|19950107|
|zeiteinheit|(Week)|
|auswaehr|DEM|
|bukreis|HGB|
|buwaehr|DEM|
|planszenario|STD|
|kategorieauswert|0|
|allekategorien|1|
|zeigealle|0|
|periodevon|13|
|periodebis|13|
|position|Lieferobligo|
|ekvk|(Sales)|
And I press button "bstart"
Then the table has 1 rows
Then field "tterm" has value "02.05.1995" in row 1

############################################
# Rechnungsobligo Prüfung LIQPLANDETAILS 
############################################
Scenario: Rechnungsobligo Periode 13 Weitere - Anzahlungen Abzug Schlussrechnung mit Zahlungsbedingung aus Auftrag
Given I open the infosystem "LIQPLANDETAILS"
# (Infosystem) LIQPLANDETAILS
And I set fields
|stichtag|19950107|
|zeiteinheit|(Week)|
|auswaehr|DEM|
|bukreis|HGB|
|buwaehr|DEM|
|planszenario|STD|
|kategorieauswert|0|
|allekategorien|1|
|zeigealle|0|
|periodevon|13|
|periodebis|13|
|position|Rechnungsobligo|
|ekvk|(Sales)|
And I press button "bstart"
Then field "summe" has value "-9660.00"
Then table has values
|zuabz|tkategorie|tic|tperiode|tbeschreibung|tkonto|tbelegtyp|tbelegkopf|tzabetr|tskonto|tskontosatz|tbeldat|tterm|tzbed|
#|                  |Kategorie|Intercompany|Periode|Beschreibung|Konto          |Belegart                   |Belegkopf        |Zahlungsbetrag|Skonto|Skontosatz|Belegdatum|Termin    |Zahlungsbedingung|
|icon:transfer_minus|         |nein        |13     |Anzahlung   |Kunde     70001|Auftrag (neutrale Position)|Verkauf    200001|-4140.00      |0.00  |0.00      |07.01.1995  |02.05.1995  |203              |
|icon:transfer_minus|         |nein        |13     |Anzahlung   |Kunde     70001|Auftrag (neutrale Position)|Verkauf    200001|-5520.00      |0.00  |0.00      |07.01.1995  |02.05.1995  |203              |

Scenario: Rechnungsobligo Periode 9
Given I open the infosystem "LIQPLANDETAILS"
# (Infosystem) LIQPLANDETAILS
And I set fields
|stichtag|19950107|
|zeiteinheit|(Week)|
|auswaehr|DEM|
|bukreis|HGB|
|buwaehr|DEM|
|planszenario|STD|
|kategorieauswert|0|
|allekategorien|1|
|zeigealle|0|
|periodevon|9|
|periodebis|9|
|position|Rechnungsobligo|
|ekvk|(Sales)|
And I press button "bstart"
Then field "summe" has value "5520.00"
Then table has values
|zuabz|tkategorie|tic|tperiode|tbeschreibung|tkonto|tbelegtyp|tbelegkopf|tzabetr|tskonto|tskontosatz|tbeldat|tterm|tzbed|
#|                  |Kategorie|Intercompany|Periode|Beschreibung|Konto          |Belegart                   |Belegkopf        |Zahlungsbetrag|Skonto|Skontosatz|Belegdatum  |Termin      |Zahlungsbedingung|
|icon:transfer_plus |         |nein        |9      |Anzahlung   |Kunde     70001|Auftrag (neutrale Position)|Verkauf    200001|5520.00       |0.00  |0.00      |07.01.1995  |27.02.1995  |63              |

Scenario: Rechnungsobligo Periode 4
Given I open the infosystem "LIQPLANDETAILS"
# (Infosystem) LIQPLANDETAILS
And I set fields
|stichtag|19950107|
|zeiteinheit|(Week)|
|auswaehr|DEM|
|bukreis|HGB|
|buwaehr|DEM|
|planszenario|STD|
|kategorieauswert|0|
|allekategorien|1|
|zeigealle|0|
|periodevon|4|
|periodebis|4|
|position|Rechnungsobligo|
|ekvk|(Sales)|
And I press button "bstart"
Then field "summe" has value "4140.00"
Then table has values
|zuabz|tkategorie|tic|tperiode|tbeschreibung|tkonto|tbelegtyp|tbelegkopf|tzabetr|tskonto|tskontosatz|tbeldat|tterm|tzbed|
#|                  |Kategorie|Intercompany|Periode|Beschreibung|Konto          |Belegart                   |Belegkopf        |Zahlungsbetrag|Skonto|Skontosatz|Belegdatum  |Termin      |Zahlungsbedingung|
|icon:transfer_plus |         |nein        |4      |Anzahlung   |Kunde     70001|Auftrag (neutrale Position)|Verkauf    200001|4140.00       |0.00  |0.00      |07.01.1995  |26.01.1995  |63              |


##################################################################################################
# Bezahlen vorbereiten - Stammdaten
##################################################################################################
Scenario: Kontenbereich anlegen
Given I open an editor "kontenbereich" from table "(AccountRange):(AccountRange)" with command "NEW" for record ""
# <(AccountRange)> <(Empty)>, (AccountRange)
And I set field "nummer" to "18100"
And I set field "such" to "Bank"
And I set field "fausart" to "Bilanz"
And I append rows
    | konto |
    | 18100 |
Then I save the current editor

Scenario: Zahlungsverkehr-Konfiguration
Given I open an editor "zahlungsverkehr" from table "(PaymentMasterFiles):(CMConfig)" with command "UPDATE" for record "KONFIG"
# <(PaymentMasterFiles)> <(View)>, (CMConfig)
And I set field "lqkbereich" to id from editor "kontenbereich"
Then I save the current editor

Scenario: Steuerkonfiguration Konto
Given I open an editor "temp" from table "(Account):(Account)" with command "UPDATE" for record "32700"
# <(Account)> <(Empty)>, (Account)
And I set field "ktostrgl" to "VKINLREGEL"
Then I save the current editor

Given I open an editor "temp" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ANZAHLUNG"
# <(Part)> <(Empty)>, (SupplementaryItem)
And I set field "vkonto" to "32700"
Then I save the current editor


##################################################################################################
# Bezahlen Anzahlungsrechnung 1
##################################################################################################
Scenario: Anzahlungsrechnung aus Fakturaplan erstellen 1
Given I open an editor "fakturaplan" from table "(BillingPlan):(BillingPlan)" with command "UPDATE" for record "1"
# <(BillingPlan)> <(Empty)>, (BillingPlan)
And I press button "anzahlungsrechn" to open a subeditor for "rechnung" in row 1
And I switch the current editor to editor "rechnung"
And I set field "budat" to "16.01.95"
And I set field "vom" to "16.01.95"
# Checkbox Buchen
And I set field "ueb" to "true"
# Rechnungsabschlusspositionen OK
And I respond with answer "1" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Scenario: Liquiditätsplanung Werte prüfen Rechnungsobligo => Offene Posten 1
# (Infosystem) LIQPLAN
Given I open the infosystem "LIQPLAN"
And I press button "bstart"
Then field "twert4" has value "" in row 5
Then field "twert4" has value "4140.00" in row 4

Scenario: Bezahlung Anzahlung 1
Given I open an editor "temp" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
# <(OIProcessing)> <(Empty)>, (DebitOutstandingItems)
And I set fields 
| gkonto | 18100 |
| kbudat | 28.01.95 |
| beleg | 12345 |
And I append rows
    | konto      |
    | K ALBRECHT |
And I press button "topladen" in row 1
And I press button "tueber" in row 1
# Sind Sie sicher? Ja!
And I respond with answer "1" to the dialog with id "588"
Then I save the current editor

Scenario: Liquiditätsplanung Werte prüfen Offene Posten => Eigene Liquide Mittel (EB) 1
# (Infosystem) LIQPLAN
Given I open the infosystem "LIQPLAN"
And I press button "bstart"
Then field "twert4" has value "" in row 4


##################################################################################################
# Bezahlen Anzahlungsrechnung 2
##################################################################################################
Scenario: Anzahlungsrechnung aus Fakturaplan erstellen 2
Given I open an editor "fakturaplan" from table "(BillingPlan):(BillingPlan)" with command "UPDATE" for record "1"
# <(BillingPlan)> <(Empty)>, (BillingPlan)
And I press button "anzahlungsrechn" to open a subeditor for "rechnung" in row 2
And I switch the current editor to editor "rechnung"
And I set field "budat" to "23.02.95"
And I set field "vom" to "23.02.95"
# Checkbox Buchen
And I set field "ueb" to "true"
# Rechnungsabschlusspositionen OK
And I respond with answer "1" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Scenario: Liquiditätsplanung Werte prüfen Rechnungsobligo => Offene Posten 2
# (Infosystem) LIQPLAN
Given I open the infosystem "LIQPLAN"
And I press button "bstart"
Then field "twert9" has value "" in row 5
Then field "twert10" has value "5520.00" in row 4

Scenario: Bezahlung Anzahlung 2
Given I open an editor "temp" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
# <(OIProcessing)> <(Empty)>, (DebitOutstandingItems)
And I set fields 
| gkonto | 18100 |
| kbudat | 13.03.95 |
| beleg | 123456 |
And I append rows
    | konto      |
    | K ALBRECHT |
And I press button "topladen" in row 1
And I press button "tueber" in row 1
# Sind Sie sicher? Ja!
And I respond with answer "1" to the dialog with id "588"
Then I save the current editor

Scenario: Liquiditätsplanung Werte prüfen Offene Posten => Eigene Liquide Mittel (EB) 2
# (Infosystem) LIQPLAN
Given I open the infosystem "LIQPLAN"
And I press button "bstart"
Then field "twert10" has value "" in row 4


##################################################################################################
# Bezahlen Schlussrechnung
##################################################################################################
Scenario: Rechnungsobligo Periode 13 Weitere - Anzahlungen Abzug Schlussrechnung sind immer noch da. 
Given I open the infosystem "LIQPLANDETAILS"
# (Infosystem) LIQPLANDETAILS
And I set fields
|stichtag|19950107|
|zeiteinheit|(Week)|
|auswaehr|DEM|
|bukreis|HGB|
|buwaehr|DEM|
|planszenario|STD|
|kategorieauswert|0|
|allekategorien|1|
|zeigealle|0|
|periodevon|13|
|periodebis|13|
|position|Rechnungsobligo|
|ekvk|(Sales)|
And I press button "bstart"
Then field "summe" has value "-9660.00"
Then table has values
|zuabz|tkategorie|tic|tperiode|tbeschreibung|tkonto|tbelegtyp|tbelegkopf|tzabetr|tskonto|tskontosatz|tbeldat|tterm|tzbed|
#|                  |Kategorie|Intercompany|Periode|Beschreibung|Konto          |Belegart                   |Belegkopf        |Zahlungsbetrag|Skonto|Skontosatz|Belegdatum|Termin    |Zahlungsbedingung|
|icon:transfer_minus|         |nein        |13     |Anzahlung   |Kunde     70001|Auftrag (neutrale Position)|Verkauf    200001|-4140.00      |0.00  |0.00      |07.01.1995  |02.05.1995  |203              |
|icon:transfer_minus|         |nein        |13     |Anzahlung   |Kunde     70001|Auftrag (neutrale Position)|Verkauf    200001|-5520.00      |0.00  |0.00      |07.01.1995  |02.05.1995  |203              |

Scenario: Rechnung 3 aus Fakturaplan erstellen
Given I open an editor "rechnung3" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "BALBRECHT"
And I set fields 
| budat | 31.03.95  |
| vom   | 31.03.95  |
| ueb   | true      |
And I set field "mge" to "1" in row 1
# Rechnungsabschlusspositionen OK
And I respond with answer "1" to the dialog with id "4841"
Then I save the current editor

Scenario: Liquiditätsplanung Werte prüfen Rechnungsobligo => Offene Posten 3
# (Infosystem) LIQPLAN
Given I open the infosystem "LIQPLAN"
And I press button "bstart"
Then field "twert13" has value "4140.00" in row 4
Then field "twert13" has value "" in row 5

Scenario: Bezahlung Rechnung 3
Given I open an editor "temp" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
# <(OIProcessing)> <(Empty)>, (DebitOutstandingItems)
And I set fields 
| gkonto | 18100 |
| kbudat | 28.04.95 |
| beleg | 123456 |
And I append rows
    | konto      |
    | K ALBRECHT |
And I press button "topladen" in row 1
And I press button "tueber" in row 1
# Sind Sie sicher? Ja!
And I respond with answer "1" to the dialog with id "588"
Then I save the current editor

Scenario: Liquiditätsplanung Werte prüfen Offene Posten leer, Gebuchte Umsatzsteuerzahllast
# (Infosystem) LIQPLAN
Given I open the infosystem "LIQPLAN"
And I press button "bstart"
Then field "twert13" has value "" in row 4
Then field "twert13" has value "" in row 5
Then table has values
|tposition                  |tekvk|twert0 | twert1 | twert2 | twert3 |twert4  |twert5  |twert6  |twert7  |twert8  |twert9  |twert10 |twert11 |twert12 |twert13  |tzeilensum|
|Eigene liquide Mittel (AB)      |       ||4140.00 |4140.00 |4140.00 |4140.00 |4140.00 |4140.00 |4140.00 |3600.00 |3600.00 |3600.00 |3600.00 |3600.00 |3600.00  |        |
|Kreditlinie (AB)                |       ||        |        |        |        |        |        |        |        |        |        |        |        |         |        |
|Zahlungsmittel (AB)             |       ||4140.00 |4140.00 |4140.00 |4140.00 |4140.00 |4140.00 |4140.00 |3600.00 |3600.00 |3600.00 |3600.00 |3600.00 |3600.00  |        |
|Offene Posten                   |Verkauf||        |        |        |        |        |        |        |        |        |        |        |        |         |        |
|Rechnungsobligo                 |Verkauf||        |        |        |        |        |        |        |        |        |        |        |        |         |        |
|Lieferobligo                    |Verkauf||        |        |        |        |        |        |        |        |        |        |        |        |         |        |
|Sonstige Einzahlungen           |Verkauf||        |        |        |        |        |        |        |        |        |        |        |        |         |        |
|Einzahlungen gesamt             |       ||        |        |        |        |        |        |        |        |        |        |        |        |         |        |
|Offene Posten                   |Einkauf||        |        |        |        |        |        |        |        |        |        |        |        |         |        |
|Rechnungsobligo                 |Einkauf||        |        |        |        |        |        |        |        |        |        |        |        |         |        |
|Lieferobligo                    |Einkauf||        |        |        |        |        |        |        |        |        |        |        |        |         |        |
|Sonstige Auszahlungen           |Einkauf||        |        |        |        |        |        |        |        |        |        |        |        |         |        |
|Auszahlungen gesamt             |       ||        |        |        |        |        |        |        |        |        |        |        |        |         |        |
|Liquiditätssaldo I              |       ||        |        |        |        |        |        |        |        |        |        |        |        |         |        |
|Gebuchte Umsatzsteuerzahllast   |       ||        |        |        |        |        |        |540.00  |        |        |        |        |        |1260.00  |1800.00 |
|Umsatzsteuerzahllast aus Obligos|       ||        |        |        |        |        |        |        |        |        |        |        |        |         |        |
|Zinssatz Bereitstellung (%)     |       ||        |        |        |        |        |        |        |        |        |        |        |        |         |        |
|Zinsen Bereitstellung           |       ||        |        |        |        |        |        |        |        |        |        |        |        |         |        |
|Zinssatz Inanspruchnahme (%)    |       ||        |        |        |        |        |        |        |        |        |        |        |        |         |        |
|Zinsen Inanspruchnahme          |       ||        |        |        |        |        |        |        |        |        |        |        |        |         |        |
|Weitere Belastungen gesamt      |       ||        |        |        |        |        |        |540.00  |        |        |        |        |        |1260.00  |1800.00 |
|Liquiditätssaldo II             |       ||        |        |        |        |        |        |-540.00 |        |        |        |        |        |-1260.00 |        |
|Eigene liquide Mittel (EB)      |       ||4140.00 |4140.00 |4140.00 |4140.00 |4140.00 |4140.00 |3600.00 |3600.00 |3600.00 |3600.00 |3600.00 |3600.00 |2340.00  |        |
|Kreditlinie (EB)                |       ||        |        |        |        |        |        |        |        |        |        |        |        |         |        |
|Zahlungsmittel (EB)             |       ||4140.00 |4140.00 |4140.00 |4140.00 |4140.00 |4140.00 |3600.00 |3600.00 |3600.00 |3600.00 |3600.00 |3600.00 |2340.00  |        |
|Inanspruchnahme Kreditlinie abs.|       ||        |        |        |        |        |        |        |        |        |        |        |        |         |        |
|Inanspruchnahme Kreditlinie (%) |       ||        |        |        |        |        |        |        |        |        |        |        |        |         |        |
|Änderung Kreditvolumen          |       ||        |        |        |        |        |        |        |        |        |        |        |        |         |        |

##############################################################################################
# Ohne Fakturaplan
##############################################################################################
Scenario: Auftrag anlegen
# <(Sales)> <(Empty)>, (SalesOrder)
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "waehr" to "DEM"
And I set field "such" to "OHNEPLAN"
And I append rows
	| artikel		| mge	| wtterm |
	| TRAKTOR10PS	| 1		| 30.01 |
And I save the current editor

Scenario: Liquiditätsplanung Werte prüfen Rechnungsobligo => Offene Posten
# (Infosystem) LIQPLAN
Given I open the infosystem "LIQPLAN"
And I press button "bstart"
Then field "twert6" has value "13800.00" in row 6
Then field "twert7" has value "1800.00" in row 16

Scenario: Rechnung erstellen
Given I open an editor "rechnung3" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "OHNEPLAN"
And I set fields 
| budat | 30.01.95  |
| vom   | 30.01.95  |
| ueb   | true      |
And I set field "mge" to "1" in row 1
# Rechnungsabschlusspositionen OK
And I respond with answer "1" to the dialog with id "4841"
Then I save the current editor

Scenario: Bezahlung Rechnung
Given I open an editor "temp" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
# <(OIProcessing)> <(Empty)>, (DebitOutstandingItems)
And I set fields 
| gkonto | 18100 |
| kbudat | 08.02.95 |
| beleg | 66 |
And I append rows
    | konto      |
    | K ALBRECHT |
And I press button "topladen" in row 1
And I press button "tueber" in row 1
# Sind Sie sicher? Ja!
And I respond with answer "1" to the dialog with id "588"
Then I save the current editor

Scenario: Liquiditätsplanung Werte prüfen Offene Posten leer, Gebuchte Umsatzsteuerzahllast
# (Infosystem) LIQPLAN
Given I open the infosystem "LIQPLAN"
And I press button "bstart"
Then field "twert6" has value "" in row 6
Then field "twert7" has value "2340.00" in row 15
Then field "twert7" has value "" in row 16












######################################################
# Fakturaplan mit Oterm REWE-2098
# Zusatzposition wird niemals geliefert - Nur Rechnungsobligo relevant
######################################################
# Verkaufsartikel
Scenario: Zusatzposition anlegen Verkauf
Given I open an editor "zusatzpos" from table "(Part):(SupplementaryItem)" with command "STORE" for record "TRAKTORZUSATZ"
And I set fields
    | such      | TRAKTORZUSATZ           |
    | namebspr  | Rasentraktor Zusatzposition    |
    | vpr       | 12000                 |
    | zptyp     | neutrale Position     |
And I save the current editor

Scenario: Auftrag anlegen
# <(Sales)> <(Empty)>, (SalesOrder)
Given I open an editor "auftragOterm" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "zbed" to "Z30N"
And I set field "waehr" to "DEM"
And I append rows
    | artikel         | oterm |
    | TRAKTORZUSATZ   | 31.03 |
And I save the current editor

# anzpwert, zbedname, zbet und tterm werden automatisch gesetzt
Scenario: Fakturaplan anlegen
# HINWEIS! Verrechnungsdatum (verrterm) der Anzahlungen muss Geplanten Rechnungstermin (planredat) der Schlussrechnung entsprechen. 
# <(BillingPlan)> <(Empty)>, (BillingPlan)
Given I open an editor "fakturaplan" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "namebspr" to "Test-Fakturaplan 1995"
And I set field "evvorgang" to id from editor "auftragOterm"
And I append rows
    | reart     | proz  | planredat     | verrterm | zbed   |
    | Anzahlung | 30    | 16.01.1995    | 31.3.    | ZTEST  |
    | Anzahlung | 40    | 16.02.1995    | 31.3.    | ZTEST  |
    | Rechnung  | 30    | 31.03.1995    |          | Z30N   |
And I save the current editor

############################################
# Rechnungsobligo Prüfung LIQPLANDETAILS 
############################################
Scenario: Rechnungsobligo Periode 13 Weitere - Anzahlungen Abzug Schlussrechnung mit Zahlungsbedingung aus Auftrag
Given I open the infosystem "LIQPLANDETAILS"
# (Infosystem) LIQPLANDETAILS
And I set fields
|stichtag|19950107|
|zeiteinheit|(Week)|
|auswaehr|DEM|
|bukreis|HGB|
|buwaehr|DEM|
|planszenario|STD|
|kategorieauswert|0|
|allekategorien|1|
|zeigealle|0|
|periodevon|13|
|periodebis|13|
|position|Rechnungsobligo|
|ekvk|(Sales)|
And I press button "bstart"
Then field "summe" has value "4140.00"
Then table has values
|zuabz|tkategorie|tic|tperiode|tbeschreibung|tkonto|tbelegtyp|tbelegkopf|tzabetr|tskonto|tskontosatz|tbeldat|tterm|tzbed|
#|                  |Kategorie|Intercompany|Periode|Beschreibung                  |Konto          |Belegart                   |Belegkopf        |Zahlungsbetrag|Skonto|Skontosatz|Belegdatum|Termin    |Zahlungsbedingung|
|icon:transfer_plus |         |nein        |13     |Rasentraktor Zusatzposition   |Kunde     70001|Auftrag (neutrale Position)|Verkauf    200003|13800.00      |0.00  |0.00      |07.01.1995  |02.05.1995  |203              |
|icon:transfer_minus|         |nein        |13     |Anzahlung                     |Kunde     70001|Auftrag (neutrale Position)|Verkauf    200003|-4140.00      |0.00  |0.00      |07.01.1995  |02.05.1995  |203              |
|icon:transfer_minus|         |nein        |13     |Anzahlung                     |Kunde     70001|Auftrag (neutrale Position)|Verkauf    200003|-5520.00      |0.00  |0.00      |07.01.1995  |02.05.1995  |203              |
And I save the current editor

#####################################################################################
### Scenario Einkaufsrechnung mit Anzahlung
### Testen des Bugs: REWE-2324
#####################################################################################

# Lieferant
Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "STORE" for record "TLAND"
And I set fields
    | such      | TLAND                     |
    | namebspr  | Traktorland               |
    | str       | Traktorengasse 11         |
    | plz       | 71263                     |
    | nort      | Weil der Stadt            |
    | ustid     | DE7958624                 |
    | zbed      | Z30N                      |
And I save the current editor

Scenario: Bestellung anlegen
# *<(Purchasing)><(Empty)>,(PurchaseOrder)
Given I open an editor "bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to id from editor "lieferant"
And I set field "zbed" to "Z30N"
And I set field "erfwaehr" to "DEM"
And I append rows
    | artikel       | mge   |preis  | wtterm |
    | TRAKTOR10PS   | 1     |12000  | 15.04 |
And I save the current editor

Scenario: Fakturaplan anlegen
# <(BillingPlan)> <(Empty)>, (BillingPlan)
Given I open an editor "fakturaplanEK" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "namebspr" to "Test-Fakturaplan EK"
And I set field "evvorgang" to id from editor "bestellung"
And I append rows
    | reart     | proz  | planredat     | verrterm  | zbed   |
    | Anzahlung | 30    | 29.03.1995    | 15.04.    | Z30N   |
And I save the current editor

Scenario: Liquiditaetsplanung Werte pruefen, EK-Bestellung mit Anzahlung in Zeile Rechnungsobligo
# (Infosystem) LIQPLAN
Given I open the infosystem "LIQPLAN"
And I set field "stichtag" to "27.03."
And I press button "bstart"
Then field "twert5" has value "4140.00" in row 10
Then field "twert8" has value "-4140.00" in row 10
And I save the current editor


