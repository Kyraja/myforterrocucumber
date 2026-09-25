@persistent
Feature: PROCESSANALYSIS
Background:
Given I set the fake date to "02.01.1995"
# *****************************************************************************
#  Name           : processanalysis.feature
#  Autor          : cl
#  Verantwortlich : cl
#  Kontrolle      : teampss
#  Funktion       : Cucumber Tests fuer PROCESSANALYSIS
#                   
# *****************************************************************************

@Infosystem_PROCESSANALYSIS
Scenario:  Infosystem starten PROCESSANALYSIS Verkauf, Stornierte Kundenalieferung
Given I open the infosystem "PROCESSANALYSIS"
And I set field "vorgang" to "200001"
And I set field "mitstorno" to "true"
And I press button "bstart"
Then fields have values
| sumbestellung   | -81.00 |
| sumlieferschein |  30.00 |
| sumrueckls      |   0.00 |
| sumkundenls     |   0.00 |
| sumrechnung     |   0.00 |
| sumgutschrift   |   0.00 |
| sumkonto        |   0.00 |

Then the table has 6 rows

Then table has values
  | tstufe   | tvorgang  | Gebucht | vart                           | mge | tvorp^id^artex | preis | pwert   | bestellung | lieferschein | kundenls | rechnung | rueckls | gutschrift | remenge |
  | 0        | V 200001  | ja      | Auftrag                        | -20 | V1             | 6.00  | -120.00 | -120.00    |  0.00        |    0.00  | 0.00     | 0.00    | 0.00       | -20     |
  | 1        | V +300003 | ja      | Stornierte Kundenanlieferung   | -20 | V1             | 6.00  | -120.00 |    0.00    |  0.00        |    0.00  | 0.00     | 0.00    | 0.00       |   0     |
  | 1        | V +300004 | ja      | Storno-Kundenanlieferung       |  20 | V1             | 6.00  |  120.00 |    0.00    |  0.00        |    0.00  | 0.00     | 0.00    | 0.00       |   0     |
  | ----     |           | nein    | ------------------------------ |   0 |                | 0.00  |    0.00 |    0.00    |  0.00        |    0.00  | 0.00     | 0.00    | 0.00       |   0     |
  | 0        | V 200001  | ja      | Auftrag                        |  13 | V2             | 3.00  |   39.00 |   39.00    |  0.00        |    0.00  | 0.00     | 0.00    | 0.00       |   3     |
  | 1        | V 300002  | ja      | Lieferschein                   |  10 | V2             | 3.00  |   30.00 |    0.00    | 30.00        |    0.00  | 0.00     | 0.00    | 0.00       |  10     |

  
Scenario:  Infosystem starten PROCESSANALYSIS Verkauf, Kundenanlieferung, daher in Summe
Given I open the infosystem "PROCESSANALYSIS"
And I set field "vorgang" to "+200002"
And I press button "bstart"
Then fields have values
| sumbestellung   | -30.00 |
| sumlieferschein |   0.00 |
| sumrueckls      |   0.00 |
| sumkundenls     | -30.00 |
| sumrechnung     |   0.00 |
| sumgutschrift   |   0.00 |
| sumkonto        |   0.00 |

Then the table has 2 rows

Then table has values
   | tstufe   | tvorgang  | Gebucht  | vart                           | mge | tvorp^id^artex | preis | pwert  | bestellung | lieferschein | kundenls | rechnung | rueckls | gutschrift | remenge |
   | 0        | V +200002 | ja       | Auftrag                        | -5  | V1             | 6.00  | -30.00 | -30.00     | 0.00         |   0.00   | 0.00     | 0.00    | 0.00       |  0      |

   | 1        | V 300006  | ja       | Kundenanlieferung              | -5  | V1             | 6.00  | -30.00 |   0.00     | 0.00         | -30.00   | 0.00     | 0.00    | 0.00       |  -5     |

Scenario: Kaufm. Gutschrift aus Kundenanlieferung KANLMZ2 erstellen
Given I open an editor "KANLMZ2GS" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "KANLMZLS2"
And I set field "such" to "KANLMZ2GS"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then field "lsart" has value ""
And I set fields
  | ueb    | ja |
  | tterm  | .  |
  | budat  | .  |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


Scenario:  Infosystem starten PROCESSANALYSIS Verkauf, mit Kaufm. Gutschrift
Given I open the infosystem "PROCESSANALYSIS"
And I set field "vorgang" to "V +200002"
And I press button "bstart"
Then fields have values
| sumbestellung   | -30.00 |
| sumlieferschein |   0.00 |
| sumrueckls      |   0.00 |
| sumkundenls     | -30.00 |
| sumrechnung     |   0.00 |
| sumgutschrift   | -30.00 |
| sumkonto        | -30.00 |

Then the table has 3 rows

Then table has values
   | tstufe   | tvorgang  | Gebucht  | vart                           | mge | tvorp^id^artex | preis | pwert  | bestellung | lieferschein | kundenls | rechnung | rueckls | gutschrift | remenge |
   | 0        | V +200002 | ja       | Auftrag                        | -5  | V1             | 6.00  | -30.00 | -30.00     | 0.00         |   0.00   | 0.00     | 0.00    |   0.00     | 0       |
   | 1        | V +300006 | ja       | Kundenanlieferung              | -5  | V1             | 6.00  | -30.00 |   0.00     | 0.00         | -30.00   | 0.00     | 0.00    |   0.00     | 0       |
   | 2        | V +400007 | ja       | Kaufmännische Gutschrift      | -5  | V1             | 6.00  | -30.00 |   0.00     | 0.00         |   0.00   | 0.00     | 0.00    | -30.00     | 0       |

        
Scenario:  Infosystem starten PROCESSANALYSIS Verkauf 1
Given I open the infosystem "PROCESSANALYSIS"
And I set field "vorgang" to "200003"
And I set field "mitstorno" to "ja"
And I press button "bstart"
Then fields have values
| sumbestellung   |-120.00 |
| sumlieferschein |   0.00 |
| sumrueckls      |   0.00 |
| sumkundenls     |   0.00 |
| sumrechnung     |   0.00 |
| sumgutschrift   |   0.00 |
| sumkonto        |   0.00 |

Then the table has 3 rows

Then table has values
   | tstufe   | tvorgang  | Gebucht | vart                         | mge | tvorp^id^artex | preis   | pwert    | bestellung | lieferschein | kundenls | rechnung | rueckls | gutschrift | remenge |
   | 0        | V 200003  | ja      | Auftrag                      | -20 | V1             | 6.00    | -120.00  | -120.00    | 0.00         | 0.00     | 0.00     | 0.00    | 0.00       | -20     |
   | 1        | V +300009 | ja      | Stornierte Kundenanlieferung | -20 | V1             | 6.00    | -120.00  |    0.00    | 0.00         | 0.00     | 0.00     | 0.00    | 0.00       |   0     |
   | 1        | V +300010 | ja      | Storno-Kundenanlieferung     |  20 | V1             | 6.00    |  120.00  |    0.00    | 0.00         | 0.00     | 0.00     | 0.00    | 0.00       |   0     |

    
Scenario:  Infosystem starten PROCESSANALYSIS Verkauf 2
Given I open the infosystem "PROCESSANALYSIS"
And I set field "vorgang" to "200004"
And I press button "bstart"
Then fields have values
| sumbestellung   | -125.00 |
| sumlieferschein |    0.00 |
| sumrueckls      |    0.00 |
| sumkundenls     |  -50.00 |
| sumrechnung     |    0.00 |
| sumgutschrift   |  -50.00 |
| sumkonto        |  -50.00 |

Then the table has 3 rows

Then table has values
   | tstufe   | tvorgang  | Gebucht  | vart                         | mge | tvorp^id^artex | preis | pwert  | bestellung | lieferschein | kundenls |rechnung  | rueckls | gutschrift | remenge |
   | 0        | V 200004  | ja       | Auftrag                      | -5  | V1             |25.00  |-125.00 |-125.00     | 0.00         |   0.00   | 0.00     | 0.00    |   0.00     | -3      |
   | 1        | V +300012 | ja       | Kundenanlieferung            | -2  | V1             |25.00  | -50.00 |   0.00     | 0.00         | -50.00   | 0.00     | 0.00    |   0.00     | 0       |
   | 2        | V +400002 | ja       | Kaufmännische Gutschrift    | -2  | V1             |25.00  | -50.00 |   0.00     | 0.00         |   0.00   | 0.00     | 0.00    | -50.00     | 0       |
   

Scenario:  Kaufm. Gutschrift stornieren
Given I open an editor "KANLKGS2S" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+KANLKGS2"
Then field "vorganga" has value "Storno kaufmännische Gutschrift"
Then field "lsart" has value ""
And I save the current editor
  

Scenario:  Infosystem starten PROCESSANALYSIS Verkauf 3
Given I open the infosystem "PROCESSANALYSIS"
And I set field "vorgang" to "200004"
And I set field "mitstorno" to "ja"
And I press button "bstart"
Then fields have values
| sumbestellung   | -125.00 |
| sumlieferschein |    0.00 |
| sumrueckls      |    0.00 |
| sumkundenls     |  -50.00 |
| sumrechnung     |    0.00 |
| sumgutschrift   |    0.00 |
| sumkonto        |    0.00 |

Then the table has 4 rows

Then table has values
   | tstufe   | tvorgang  | Gebucht  | vart                                    | mge | tvorp^id^artex | preis | pwert  | bestellung | lieferschein | kundenls |rechnung  | rueckls | gutschrift | remenge |
   | 0        | V 200004  | ja       | Auftrag                                 | -5  | V1             |25.00  |-125.00 |-125.00     | 0.00         |   0.00   | 0.00     | 0.00    |   0.00     | -3      |
   | 1        | V 300012  | ja       | Kundenanlieferung                       | -2  | V1             |25.00  | -50.00 |   0.00     | 0.00         | -50.00   | 0.00     | 0.00    |   0.00     | -2      |
   | 2        | V +400002 | ja       | Stornierte kaufmännische Gutschrift    | -2  | V1             |25.00  | -50.00 |   0.00     | 0.00         |   0.00   | 0.00     | 0.00    | -50.00     |  0      |
   | 2        | V +400008 | ja       | Storno kaufmännische Gutschrift        |  2  | V1             |25.00  |  50.00 |   0.00     | 0.00         |   0.00   | 0.00     | 0.00    |  50.00     |  0      |
